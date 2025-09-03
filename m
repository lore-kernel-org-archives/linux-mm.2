Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC37CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7528E8E0007; Wed,  3 Sep 2025 12:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704178E0001; Wed,  3 Sep 2025 12:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB198E0007; Wed,  3 Sep 2025 12:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46E0A8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:10:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F06E58660F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:10:15 +0000 (UTC)
X-FDA: 83848425990.02.8ED68FA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 65D2040005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:10:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OGIcL53j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3GgwWeT6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A2oJl7rd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIDC7OUi;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756915813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kFdrcOpazHZrThB6UJlu0enSEY95qx9lQ2QWGdUPhM=;
	b=da7JklCMA+fTCvcEI0umgODZcFqkeRCPBV6/MlotadwasLJ/192f3W3GliBwvTiD7ZJaqT
	79Eovo+BFA0TFxTS0S31E9w93cJWpncLG/YkNeriZAIQINCFQf+m5kUFk9AIgtdmYYV8Qr
	ozxWmcm9LV0IGgCPWKEcCJC9n9SaWho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756915813; a=rsa-sha256;
	cv=none;
	b=WdlMFoGu06xQnfD4Aicv49v2idx+3Aq5G9eKonu3JV6mojCuoUt+9HIa53TIOoopW6wWiI
	VHbbP7QSejNZLtOUxTC+J1BkaIF7uoGL37E+4EmWWis0XYRx2Sw2T4u8LzK75ocl18T7Hw
	LocOo5m36yhur1wyafF9VHBeiPxkJp8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OGIcL53j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3GgwWeT6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A2oJl7rd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIDC7OUi;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFB7F211CD;
	Wed,  3 Sep 2025 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756915811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4kFdrcOpazHZrThB6UJlu0enSEY95qx9lQ2QWGdUPhM=;
	b=OGIcL53j2wIBWIy54VCWoJGMfkKi/rFapnhivXM5JN09scRlkfxsd4QHOkAcYJA1XCnYQj
	58xyukuIpX7sDl+6ZGFaoSHsgmNswxgPppitKUUDJK//bdhQdfMB3voDuMec8RydYuQf4o
	q9OT1xvFRG0890fodzUv+ozADHUZq38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756915811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4kFdrcOpazHZrThB6UJlu0enSEY95qx9lQ2QWGdUPhM=;
	b=3GgwWeT6M3RfdoReY85K7sr7KrAarVPqpyKxSf3A6k+WmBUnwRi/HBOjqt9XhS+wMQ02M3
	guqz+AIlSCAjpqAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756915810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4kFdrcOpazHZrThB6UJlu0enSEY95qx9lQ2QWGdUPhM=;
	b=A2oJl7rdUeSEENGB3+o6WQU/LWh4bphI9pqf+AyoMyp+7gEM4nr7ADKgHea+I2fzt7AadF
	sE3BoUHP6x10CKb7cAZQm7HEEJ8VfVYCADWc3fbiq2Fv2aWEnl4w9Bajr9p36NIjBm2Kuj
	VsExHBQiuOZW0Yx7CzycsQSJaHPgLGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756915810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4kFdrcOpazHZrThB6UJlu0enSEY95qx9lQ2QWGdUPhM=;
	b=EIDC7OUibeJ1NT1YVW7XMCD+kJt6I/bqMcSyuhDOPJus1hos9HVVjZltrl/ePOPK+6m7dH
	HwG9Y2U+9D6Mr8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA2F913A31;
	Wed,  3 Sep 2025 16:10:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qxcdLWJouGjtdQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 16:10:10 +0000
Message-ID: <b1b683e7-e191-4487-b549-79a57986c670@suse.cz>
Date: Wed, 3 Sep 2025 18:10:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756897825.git.pyyjason@gmail.com>
 <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65D2040005
X-Stat-Signature: 5dxe4rfq15rbnkseootjkjz54igk6mqp
X-Rspam-User: 
X-HE-Tag: 1756915813-845276
X-HE-Meta: U2FsdGVkX1946LcndWhCHfbP232cJHBk3bnsKft6504/+WoKAmNRfWmybDUX4MtsKn/Y5D24FedaKyLp0neip6eG+P3dWLrw96OT6LxearMAE5yEByzy7++t2DrYkIncR+wCFwLE9s6KlXjWD/Y0BTG9nz8Fk7pocCVcosrlWWGt6YOyLZTm0jArkbd5nHS6wi9tTKSO2pH4pE2uU/gSalv2ctjsslB+4EKzjsSwIry0cXAaCZmInh8f5xvRN4je2ILT30bVuyFQvOD60bf8u7SugQyuFdpEhEuoEdd+OZSVy7QAfe5OjMcaug/vakpFen2MsSy/MbU++b3VsqV7Fmqw95fs1FBtu54INeuFikBmisoCio41Td0YIbf/nLd6CUL7Ey4W6M/aufNq05I38ErUQL0zR5DxTmr4f6lE/qGiIb7ZgdFb8ikhFoQ4txKrOP42Ewcx+bUxYe45ix1liszZSBNhfuLORiJA9X2fsL5zbKueOyjwudQEbVzccYpIafxkbvfBl3BUVyY+mKIk3b5ZDou/VPToeVMJoboteASw8NidXLltr/dkU2acdHB9BHSKzt8PjKwRiyCnLzBUwgcrs3qcKtw7ttOlovyE2djigKZhl541lcJ7lq7BXIdRsnyTj5hwHNzaY4wRSJ5mplHMbGfIRt3mxiM5aepudbbfn3e2Gh+NGD/DkyU6exqsUrp0IlqkKCWPF89BqH9WDme8EMven/06CeYGmAyvFsHayj3oCUWbFagO7sAV/PBf6xfOMVPcXankCOyWgah1mqBDjzwxfF+PY4kyw4JHeJ6zWw3QsFskVk4wtMkesqHI0WULBvSWXZq9/MxQgBkztisoqIxs577mPZ97QFA5T3X0BSXeisSfMalrVOXT4aXTBC6su3hkfSt6woYbLClq3Y7tDY855k2E43CnU6RLKaB/xD5gNAY3Dw/EVnKbwHPmh9FHN0I1xJwIkITg6XJ
 keXanADO
 lq84B/TKAHTNkGo+UgLJuuMbbA+NGtULNm2JyHu+2IWvIq1L6kCnmHSi+I8JXYmibS/drCAO6ircU8uU0HLPMbTkSubFvvjmVg3ZjHjFOnEbvaoqFRSDo7VICF+FYqtaGXIW52yRnniaOK6nXSI0PRvbJjqEb4voXr2o47dGa/YolRc6kI044/xD/1X5RNpwRGK1R98duoNTz+TXjtxcH6HIXTiFSKuVU1NVyeQIQQLy5lA1w/YgG73dWWd3kPvgcBMJmFuO6TsRge+BtLeTfqgIZX+6b5dy1C1N3cl1YaaBbmrvMTSLa1GDcEQ3KDObitWlrRkltk+QTlEBW9/m+iIxv1ky+oKvbK0u75gJ4hYg3v818gMbzeY6xGwMhH+pbdZTcYmop5/IzuImcMFd/CNq/+H+Vnr2a3lYMzR/CHqKOEyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 13:16, Yueyang Pan wrote:
> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/show_mem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index ecf20a93ea54..fd85a028a926 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -427,7 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  
>  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>  		if (nr) {
> -			pr_notice("Memory allocations:\n");
> +			pr_notice("Memory allocations (profiling is currently turned %s):\n",
> +				mem_alloc_profiling_enabled() ? "on" : "off");
>  			for (i = 0; i < nr; i++) {
>  				struct codetag *ct = tags[i].ct;
>  				struct alloc_tag *tag = ct_to_alloc_tag(ct);


