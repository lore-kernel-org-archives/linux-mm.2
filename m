Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 841A0CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD44F8E0014; Wed, 10 Sep 2025 10:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA268E0011; Wed, 10 Sep 2025 10:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC01E8E0014; Wed, 10 Sep 2025 10:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD3568E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:43:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DB761608BC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:43:03 +0000 (UTC)
X-FDA: 83873607846.02.B3FD1AF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id E25CE100005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:43:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xxEGwVz3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3mYbgzYO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xxEGwVz3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3mYbgzYO;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7zZBlpRaloLSWsrsBQ1IAvXmVM0pVfZ2e6nO4O5vjY=;
	b=hHZMAI5iX+uE7TyhhtXXfVDT4mCrwwZug46micZ3pzl6r88PW6UNugDtuTVY7CnMJnzIYj
	4LvNM2noYEUJrGyCPaePcN8wD0N4fyIHTcbYajEz3B+Q7Q1T/85Ghc4M3a1g1UT7WtnHcn
	wWhUX0GaHXX7UKf+1sGHiJrijAk+wsg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xxEGwVz3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3mYbgzYO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xxEGwVz3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3mYbgzYO;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515381; a=rsa-sha256;
	cv=none;
	b=J/Vnhxq54hG+VxFMdFzTo+nh2lNQSRleUVQwCMpeyiLM+gcIq/dYZx1J4pcoSyPFDjSSNW
	h8GLOe8ThrBIwU44h6R5DjM9bQigJQUfP65h96A8hGysRQrTSibhaIR4ZLHWMg7QDTG7/l
	B1iMVBhA9Ayq3pTfctJGH/Kr91y79/Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D197738506;
	Wed, 10 Sep 2025 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y7zZBlpRaloLSWsrsBQ1IAvXmVM0pVfZ2e6nO4O5vjY=;
	b=xxEGwVz34/LBEhSaAtnd4pCq3af6bsTWuE9E+GRuKita/RX2uFyScCz5lPNQEofoMffv+8
	tDT7D0bj7bnbq+mmaMOppYiznKGqY7H16CSEz4dsHk2+iiF1j6Y9QWaeprcwcu/77he7/d
	e2oiP7lBNeZz08Ed7Fn2eTZcw0uBXlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y7zZBlpRaloLSWsrsBQ1IAvXmVM0pVfZ2e6nO4O5vjY=;
	b=3mYbgzYO1EZ1MCUfwo16WnmbtaE4fsfWNfKytVpEByVPuSZMXhLQUPGo5wPxH+erm7hZLT
	RIMcCMehe6VZShAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y7zZBlpRaloLSWsrsBQ1IAvXmVM0pVfZ2e6nO4O5vjY=;
	b=xxEGwVz34/LBEhSaAtnd4pCq3af6bsTWuE9E+GRuKita/RX2uFyScCz5lPNQEofoMffv+8
	tDT7D0bj7bnbq+mmaMOppYiznKGqY7H16CSEz4dsHk2+iiF1j6Y9QWaeprcwcu/77he7/d
	e2oiP7lBNeZz08Ed7Fn2eTZcw0uBXlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y7zZBlpRaloLSWsrsBQ1IAvXmVM0pVfZ2e6nO4O5vjY=;
	b=3mYbgzYO1EZ1MCUfwo16WnmbtaE4fsfWNfKytVpEByVPuSZMXhLQUPGo5wPxH+erm7hZLT
	RIMcCMehe6VZShAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB7C913A54;
	Wed, 10 Sep 2025 14:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id maR3LXCOwWiTKAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:42:56 +0000
Message-ID: <36965cf1-d35c-4634-a6fb-09cd2a81f914@suse.cz>
Date: Wed, 10 Sep 2025 16:42:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: Remove redundant test in
 validate_page_before_insert()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
References: <20250910142923.2465470-1-willy@infradead.org>
 <20250910142923.2465470-3-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250910142923.2465470-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t9jowayuoc6em8b6io88hktge63w575w
X-Rspam-User: 
X-Rspamd-Queue-Id: E25CE100005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757515380-692348
X-HE-Meta: U2FsdGVkX18hXTwhK82AdVy/QMz+FW4XX7gwSsOKWcE2JAkUKb4knmu4dBZ1mluG+Yt0/TWs1YpIedXNhLwXn9706MGFTx1G9z3n1oc1XSmRoUHEZtH/iCnaiibKRsDndybRlvUzYyL9bJbiHkKsyRt5td41CsZVw0uzGKC5cDEDqvq4MhNlYTOGFbZL5ZKlGCIIt+2YZtaqRFKxesDe3EFaj7Tr3vHIblAZG6XpYCeuu5KfkJsIdYNeTE1WtVn+7CK5xwsUrvFOV6qCm3YVhuXA7UfkBrSmhTBDyW5qzd1jWxiWWi8bHqO+PyiPEoXhcG57p484M4IqIM49mlOBcP6GHJVHM79YcATXoBPX+YY+rSbvKoXnIu2aQnNF08UCc+39WRRVsxq+Hgr4NKK8Yik5QbDGOmvIao3RFXvieT6nyp4HBvFdy3jUfu50MA4REyke3XrV+74E1szcAHW2+lCggO0OkyrXQ4HpcZbme2o+m5SG/sfQAUBMajzZjuRLodaVYmYfs7nw7+ZUspAwBT2J3UBtC6kPKxt0ZR1Ac9vV6KHeqE09yz4vBOzvLdOwZkwHz4N2KWzNYM7nEt/cbqalqFRLD6lUlf2OiqUEPU0usKOQLEyNXJ5PPnnh2MFfKpoygFprbe9lGkffrbanMRUqzSq/r8I2RKLsfjAsD3Hn959xYFgqBaqDVbXzTcH6tmxJLQdpgpL7ocaq738ACrHJ2ASSQDu6BRsUYYWYL/NQiWEgsKzh7CqyqfFyIx8p2JC4q5uSItKTi3dQmVYQBQNvy9I4fvSFrB+ia3WgYGeaKv9wC6z2+kgn3PG/dM833zekhZMaYmARRCfSnJJq9GVhJ4JGFjNXxBQodG0+T6+TMmYhczPxAJKygLnYiQa/Ly9Qh7o6k2bpArvLNnefe+9bmetxd2zSqOdpBO24eOik8Zs3U2GienrN368fy5T+MyPPx3rH1lyJTt6rKM3
 mNyssd48
 WbSRSUguR4t9TxSWeqsa2Hv1iRBV1w87jtg2eQTt9K4o9Y9krb9mOxhWfgrv6Vo7Mdzgax0koOwvgmstEJ70ymAPRzRC+9C7cB0cwdQzcnotzR2x6kFMSmWNoMK454RBsoH40t8ddufmKoTDkd0mYhyYZcIZXzB9/WfXXi/Iuvi+kaupiWFvx8IHejcqPAEiAHqcn2k6yVYNTAoatNmRcfoMK2vDiYOlpXsnlZiDzjqHVnt+Yf90Z03W3f9xeRUcmS51T9aPv0sIFveKfqTQBHDF0K0f3ph5DNBpq4qo1EInP4RkTr96MyAvT+L2XLdbHFPojRYumUHhhFoX/7UWd56VaeLXSA/ZBKaWLwsGs6SOb+xQtiOKkl9LjlnDs/JQQ+EjLbcItjPZkML+pVbA3Shb8AmSuYqZ71Hhi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 16:29, Matthew Wilcox (Oracle) wrote:
> The page_has_type() call would have included slab since commit
> 46df8e73a4a3 and now we don't even get that far because slab
> pages have a zero refcount since commit 9aec2fb0fd5e.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3e0404bd57a0..46fa459d9a11 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2268,8 +2268,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>  			return -EINVAL;
>  		return 0;
>  	}
> -	if (folio_test_anon(folio) || folio_test_slab(folio) ||
> -	    page_has_type(page))
> +	if (folio_test_anon(folio) || page_has_type(page))
>  		return -EINVAL;
>  	flush_dcache_folio(folio);
>  	return 0;


