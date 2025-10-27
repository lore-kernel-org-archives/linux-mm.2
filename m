Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11A7CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0433980081; Mon, 27 Oct 2025 14:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35398000A; Mon, 27 Oct 2025 14:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDF380081; Mon, 27 Oct 2025 14:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB48B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:04:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79D2FC0223
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:04:18 +0000 (UTC)
X-FDA: 84044668596.29.8759ABC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42CE516000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:04:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h90XAuon;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OjoIL1Y9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pGvVdq+L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EHfJJzjM;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761588256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKhZqMc355tSWa8i+ajqzPxXOBkuGBJTN5j3rmeaLQA=;
	b=p3o05tnHc8nV3S5H4oywqsvjAmNMX5gTvVdJpp96J8XJp++hfNPxKaH2lUDWFhzMkae8hR
	1jvkT30HW3yKXeulIqRoeNaSjR+oUcmA0HsN6bgVxObB7yBLgxm42y3fgtFUwF7VfT8l8Q
	7zDXBHky4vaPFZiEKP5hWSnAbbgknO4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h90XAuon;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OjoIL1Y9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pGvVdq+L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EHfJJzjM;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761588256; a=rsa-sha256;
	cv=none;
	b=wOAZhU9RbKqqFjqO+NXZRewjY8BoB9nMGYZfgWsvWwrk+M1pRCUnBPaz9p6CjCCcw5e1p+
	FPnp8dfegrxHR/AoUwhr9dsVAR/86HWQEaLjM/nO04XBOtTIrUwPLz0GRlRRY/lrw6pT5M
	St/E61POnoodzU7GJzcEXSMImsSdDOY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9222D1F44F;
	Mon, 27 Oct 2025 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RKhZqMc355tSWa8i+ajqzPxXOBkuGBJTN5j3rmeaLQA=;
	b=h90XAuonqgCeyvkhmyGQ0ujI6Ny8SyeLoxjmHskr58+WjAmfpGAxKtKaQhBIr6IfznrCXR
	mi5QtFCytSZx+6Dc/4mQBiS+vG68nUYmWFx+50Zyz1k+E/2vwWCWOqWlirPNRRIMHlfkkj
	9ajcY25FZxdrkM9OR+PPmn9/Vn+mJP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RKhZqMc355tSWa8i+ajqzPxXOBkuGBJTN5j3rmeaLQA=;
	b=OjoIL1Y9xwtei45K0B6K4VjW38PNpGzT4SYtUVnjSxQt7Wvjic7NMsPs3uZQrxGKLyKfhY
	UaV4t1XCEdtHtJDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RKhZqMc355tSWa8i+ajqzPxXOBkuGBJTN5j3rmeaLQA=;
	b=pGvVdq+LOlG5UiWVLq+NqWdFlOLyVr7H409rw4Oz7Hw+FsTKLrDPmaiK98LJIEjL40Do7Q
	SuTtFq8vJLxbS9aNhip3TS2F9ozXlrOoMJQo4uwuL9zDYzCzc9PW6Xct1GX91WWLuPAGvr
	X8AQT05xRMWNkj5EVT26vsc+WxMp6Wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RKhZqMc355tSWa8i+ajqzPxXOBkuGBJTN5j3rmeaLQA=;
	b=EHfJJzjMSkfCGWY4dhzm6ghAX7ZHN/DURLnDoQIbieSB4jCNI1dkBOsKIxKAAYp3QEpMWb
	Tolj4t//LhAXaBDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 816A2136CF;
	Mon, 27 Oct 2025 18:04:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e51IHx20/2iJbwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:04:13 +0000
Message-ID: <769bd988-e2ae-466c-9e5b-aee235cf1e2e@suse.cz>
Date: Mon, 27 Oct 2025 19:04:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/17] slab: Remove dead code from free_large_kmalloc()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-12-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-12-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42CE516000C
X-Stat-Signature: 8zhp7heputzo9coqbixsh6hsdhgt3z7s
X-Rspam-User: 
X-HE-Tag: 1761588256-423619
X-HE-Meta: U2FsdGVkX1+3rSdC/5Ec99tKXO09oEs0O0d8Zf8MzlfV05h90+IfAKV8hWWgZo11tHM0rN2yk+Aeel2bpRAbppmGalVfcyzwbpdm4RDc72ZE9tTX7W7Ljbs/QZDTaAXx3rUzYtMSF08Wez9nb18NCBSNk37J5p/+lLdLVP4hBuCYkQHKpliLYdFYO5k9B+vanW+UEi5HyZArmWAsrlc8B2dnipyDcm9B1Ub2ilaszkw/IqtRK3z34lbV8LP1KOYmhmjdTKLrMsEyQIriWSfaqU7awbYxZ/0jPGhvEkZut6yvZREVCPImtLiP7N9CHvRTqslYs6hYrICvd3yLX9H54DnkG1kB53EdD8PYFZ+kkKYF19KhNIqcD1R/VToBQQWB3b4+hLFUl81XlhpwrQRdoa0teEUlW88Nz+/svso19b9uYjrHDOzQCYHYqXW95vhKI55vGdkf033mCrgC0IWJNkqvA+ZImRz+3JIVcptbNZUPs6pTUfeY9PKUl+JcaqPQDUQlfL5t1XbhLhUeANjS/o6dAjdRVNX796TRtGqbuThtAaB8cxPzmML35I2SZubo+b2JXs4VeHiC9vF5ixZyES/glkPFrEc3DT1Dk5PBb0Ra4AT8+zIrWW+Do1Y2EMz0oZoil1KmGXWfkK9ZXnYIq2Mvi5ZE/Za5/kX8Q/6vq3XlivenBOiDLpi2+HoJmIGciHTvFSPdC4Bnm0MNASZNRPytMJ0zEzHgGcSfKEWXgQalTkgkZaBKZ7W0vPsAwltqFCYiYSLEw73BLz0fUmqvk3J5V/LXE9QarXAgWLuAaf2QQdWuk6umeftrcX/NfkQldAhUtPIY3401PNjEwMx/Fn9sLev6FW88RdDLkxL1EW4XVX71Oe1F9iTILKFHNAQk7bw/EZ906Ol5J7VyvQaw21CGszeIJUCSaRQ8T7vVZJklwGZ9NGHFnntqYftonbpHcBwSnjPvMRb7qw95ByY
 QgsR04uF
 nnwWjQBr4sW6on1Pdptb+d1TdbB2JaZYeUqh5aTyTDIyA3Rw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> All three callers of free_large_kmalloc() check PageLargeKmalloc
> first so this warning is now unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>

With testing page_slab() for NULL and fallback free_large_kmalloc() I'd then
not remove the warning.

> ---
>  mm/slub.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index e72016ff0236..e37f584352f2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6738,11 +6738,6 @@ static void free_large_kmalloc(struct page *page, void *object)
>  {
>  	unsigned int order = compound_order(page);
>  
> -	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
> -		dump_page(page, "Not a kmalloc allocation");
> -		return;
> -	}
> -
>  	if (WARN_ON_ONCE(order == 0))
>  		pr_warn_once("object pointer: 0x%p\n", object);
>  


