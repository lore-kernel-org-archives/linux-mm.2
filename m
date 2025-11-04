Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB89ECCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335748E00D2; Mon,  3 Nov 2025 19:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C668E0058; Mon,  3 Nov 2025 19:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249498E00D2; Mon,  3 Nov 2025 19:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147258E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:41:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C676E16030F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:41:17 +0000 (UTC)
X-FDA: 84071070594.16.873EEDB
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0F1010000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:41:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Marh7a0Z;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762216875;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQl1axNOhyjx04fkHhAWI3pqP+t+WvxDJDVtFkTeqnw=;
	b=TNFn1M2IbWgKVGWWyDPip2JPpdL+112d2V8K0YxgdNGRsCDwNkMlStDG+X63TVw36kfcoX
	KuAOyUECrYjW1FTXJGeT16I3aUti+7laZdWVMHy8my1P9Ehz7Zfd1UHMKunB+zAfZYkpoq
	+I4kO6+V74VqNZk6zWBbsjfHDXUM1XI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Marh7a0Z;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762216875; a=rsa-sha256;
	cv=none;
	b=hbORPoxkOpw7fJuhoi5aKxEYRWib0fteVVH9QzGTnB3b44lcA3EZ5/0BySvKzxxeD8403u
	tf23IpIx+ZYBYLzt9G2cZziYeGqL3fXZsXO0N/iVVUpROrPv58QIXnFEFN1bGBJyPcbpR8
	zHMNpI+A3hRP120v2sO6APyVasTRDtw=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63bea08a326so7162253a12.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 16:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762216874; x=1762821674; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQl1axNOhyjx04fkHhAWI3pqP+t+WvxDJDVtFkTeqnw=;
        b=Marh7a0ZP8TCSqnmzA06iq5DbfaJtw/osq9ZkDXt43JChuVPeMqlAqo64EIjvi+vCZ
         U0U4HYDPsOUDgbvsqGFhWDX2Y0rCqc5yJy0YV9JhDxv7u8s+eeJAc0aRTcKuLPrD8jV3
         K4JMWByqzHQbcvl060CeBQb1ZOxILMQu/JB7nO+gSNF7T9RVNK/iqOrqja6Gu8hYFp6C
         ekGLpelPhL3Sj4DjshpeX6G7nNKQ/NSGwT71R0I3NL8XVpGxbXqpRNu3KIFT/gV4e5W1
         b/82N4B+AznM/v88SQWp4YZBPHn3vBiBO1DWQL8agmqeq2KEtxhDZTdE1nAMgBnw0WWU
         0PJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216874; x=1762821674;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQl1axNOhyjx04fkHhAWI3pqP+t+WvxDJDVtFkTeqnw=;
        b=mwcnlqR2qhKepE2zOYFFQ4M/oisr/pZWvoFouEyQB7kKw1kN7DGlXQ9EcIEAviM0ln
         ViR0CvFmQRLMjqlgeWngxD4PyYM/Q6AzW1xXqrl1umSEBpNZh2NsRAy8fU8ReYB/DC+A
         JyE8nR5D5DYXbRrA2t04vkwECZA8FdikEUPIz5UJOR+2Fbg/CO0w6sOL6Xmc0ymb+I8S
         Oq1tbDgoWvdK/KOuUvKvEupm7s73fh7g91SEAk77DbzTFRh/gE7Zv0tWpBFC0n7GRR6K
         AGstqRwXM2WnpliNH+9tR24bGiBJDAT7R0hkiLA6xYsJzlXIlQ8WMfW22Jo0PPFKzTq5
         xhAA==
X-Forwarded-Encrypted: i=1; AJvYcCXU9WTd1LLPclORLpDESxJn+GNyePL/ExRvl4tyIchuRxxJIG9ggjal2DPAwNOh9RQ/zXA5HBaSGw==@kvack.org
X-Gm-Message-State: AOJu0Yw+F6kDJJUMiGV/40z1jzkmyBwWpd4h2mcTbpxtJNPd765zGDf3
	fzm3FKQ7Srl2+auqol9siY6ACWmFUKwrFwxDRbPUGPISxHhi2NdWfzrF
X-Gm-Gg: ASbGncvHIyyOroUM/X6+ixEYg23ZngsbC9wf4uXvIDqwOV8xXxaOrfSeFyIAwc/Frfs
	wTsfqlwrW3krqg0HVqEt+WhHEUlHB4QXA8s/1KBJYW5KaJDcdC1A04mPyPj+xwT5mG6MWZZSC2r
	fSXIn3MC5/G7Szr543SAl3g/IlfelJ/RwBl4ueD8S8o/mKzIeDSmxirE8Kk2mIN+PajJem0+xBX
	KaAR4qtH2hoiEpxUN+3pGzO6c+Vt5md89sTHvt0i/4KoY/FpNzlCiXZuguBg0vyjfW5A55iOR5x
	EHAXZcpVOmZ1UYTt0ykrilLWUwg8QrvI+Zo6z6WINQ5d8Tzf7Q9Jtl2c/T3CMhnZ0dJkL+JxhSq
	kvctcbgsLJmgKTLt0zw0RUVOVLXM14mEEp3xhZlx0suItTxZcbALWGbedzEqlkgYMNfmxe4nxYX
	E=
X-Google-Smtp-Source: AGHT+IEDNbM+/ximokNrUr41JUNL23hIscSaBhA4FsB84VTND1PzPO2aaRghpsgN68M/f+1kFnc0rw==
X-Received: by 2002:a05:6402:24d5:b0:640:c3c4:45f3 with SMTP id 4fb4d7f45d1cf-640c3c4659fmr3829946a12.6.1762216874073;
        Mon, 03 Nov 2025 16:41:14 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640e6a7fcd7sm718644a12.37.2025.11.03.16.41.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Nov 2025 16:41:12 -0800 (PST)
Date: Tue, 4 Nov 2025 00:41:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251104004111.3h5uwrwhoifshss2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <f0fa3ed5-9cc4-4bce-b22f-883db9135a84@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0fa3ed5-9cc4-4bce-b22f-883db9135a84@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0F1010000B
X-Stat-Signature: huhka3wa6zdc4z57xjfbg6nttitmzpu9
X-Rspam-User: 
X-HE-Tag: 1762216875-782622
X-HE-Meta: U2FsdGVkX1+g7uVfZ3sh5w1niqx93UutHSIkIt1Y6j6z2vTdJlmtWxRS6O5a56GR603nhHEOr+pviAvV9cAvaHgAJ5961B7+bijtgh6B/sW0+c0tk7/73iNYdHG0aEiDSWhylIlGhsjW4GcqHtOYrYEdplEAJjE/1W3JSyEzcXAA+KQWux0DYB02fNo/MHJ3+vi+BKisNEcqehEE6SJMxWnGqZGAsnBB2vNZyy31FFyjAlO1jbHb0k9Bzw9GT/tJJJL9iTDTN6BsY70jgC8fl78/sT/3GLDILL2o4QGDOqofdbbEdhJYQ3oo1uIhEVIL4MJpLCmjg//yFIiRHnvggUapYNW6D8yR1Pp94OFGVhbxwhmS8zCkMr3rkTkwSutwL4Ssmo3OYMX1vHEJTLRJObXhYMtnrBYVHDjPt1zcK/8Y3GAl31VPhzYQLYvCPMAvmN6w8XrzJSZr6cnBfPgyzS4g1wkP9F+Qip8zp7X0av4BM5vFMKgVeGFnbKY+NPLeyeIOsMLomOrKxNJEkc+40ORn2L6hR6SPP7G6CoNXq2SMw6F7Pny06eMSlfc/iqw85p6oV7ZbXh5UJsAIHjpOPqzh3pZXPyE4ozPUfDhBbns6vf9o3bST7gAP6e91pDHxygE2A6bFVk+QcW06xwxbc4y0di01aCdDGwDt6bMyuV9GSwskS017Sc98wvuCIS/Xb6mSSlh+GIutqwRnTZHZ0mS950rvkFzkPeInNo9q8WQQ9OGyXBeKXRuFRObYdLd/f4WdqKIDUZ7C9msg2Uy44/i/WGAM+DJ7d52SCKUdoZXnSUZt/wp1ZCwMlhYZAypu+WtEnDnq/zrkTAQNdtawBqc85QvLgyu7exrgr26QEqewXIsPMxc5k983WYBaEGuOFGVi6GKSlYY1FhrNyT7T6UyxKWscSs1MEc3xtRH5XFrFB1Gt+xe2NmOWnxT2Sek6NqiA+FBywkwtChcRxRW
 MK4mzaJp
 jchZet24EkPNXDZcRS94JeRBiloigDQYwwwyinkpKpxvuNQQyv8pE+Z5Y8S1RbmyAOXA/R6OF00qZDPM0UHVxXRiVCEjwsgBpPV/b0i9BRoWJLWKl8r0Yx6MolFoE1x63rbaMVVuApdHTN3pjeETWrlGnklpZOfFO3dk5nH/K73qoCzDOsxcB9seaOQcTw9W3OzneNQnrHbMOFYWCG3L7I6DSxTeKVbbVdEej2g5YmPHUqSXTMjeZTvs864fOX2FDJ7DkzMFMjghLwxjm5kS7uYFW8BxaCH/FfB0VBeeBckWPSIPeSw+Plu2MT/mytDgDBta+E60+QYdqLuGY/Pb6qQa6XWMXz54nFGgRVJ0rrA41d2X2l6lV25tsSBTcE9LEujRdHK4pThJ2B9gVok2xHNK04d4HTk4ji9S0GT6MhNle2zV+OLZzurWn0ZR5nyk3sMTX5VQsW/TxDAKF+Bp4EsOy253QUPvmGIedvyKr0pJD1qAI4JH20Xzkldep50b2/TolTDfn+BMhd9OyJGW1eHNtwUXd6ySDcOxedMPN/I1Ep5CqNV1sDULMd0j8MyvjU7JSSbOItgtQFydmK68sYzYtQgvsw6SXsY8YGaeLJsFCBmWLvtbfsOXmAlUR2IOclU3twUv5NVTYkgnzHefh38OOMqJwFP/vd8toyEkDgIHOaLWs6DxiYwXUmJ3ri/+owcq772vbO+zvHpSmrGoBuAwlNQ1HOSXC+rJU8zx1/PDNsjH170wSnrv0DnqKwnepsLXVGDHDo/njapMymksC2ueOKiKNXuZslxWEKZuMZnf3mRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:50:32PM +0100, David Hildenbrand (Red Hat) wrote:
>On 01.11.25 03:11, Wei Yang wrote:
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>> 
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order before
>> proceeding with further validation.
>> 
>> This commit unifies the logic by introducing a new variable,
>> @need_check, which is conditionally set based on whether a uniform
>> split is requested. This allows us to merge the two functions into
>> a single, combined helper, removing redundant code and simplifying
>> the split support checking mechanism.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h |  8 +++---
>>   mm/huge_memory.c        | 55 +++++++++++------------------------------
>>   2 files changed, 18 insertions(+), 45 deletions(-)
>> 
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index cbb2243f8e56..79343809a7be 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>   		unsigned int new_order, bool unmapped);
>>   int min_order_for_split(struct folio *folio);
>>   int split_folio_to_list(struct folio *folio, struct list_head *list);
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns);
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns);
>>   int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>   		struct list_head *list);
>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>>   static inline int try_folio_split_to_order(struct folio *folio,
>>   		struct page *page, unsigned int new_order)
>>   {
>> -	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
>> +	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
>>   		return split_huge_page_to_order(&folio->page, new_order);
>>   	return folio_split(folio, new_order, page, NULL);
>>   }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>   	return 0;
>>   }
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> +		bool uniform_split, bool warns)
>
>Likely a simple
>
>enum split_type {
>	SPLIT_TYPE_UNIFORM,
>	SPLIT_TYPE_NON_UNIFORM, // or SPLIT_TYPE_BUDDY?
>};
>
>Could make invocations easier to read.
>

Hmm... if so we may need to change the caller too.

>>   {
>> -	if (folio_test_anon(folio)) {
>> -		/* order-1 is not supported for anonymous THP. */
>> -		VM_WARN_ONCE(warns && new_order == 1,
>> -				"Cannot split to order-1 folio");
>> -		return new_order != 1;
>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    !mapping_large_folio_support(folio->mapping)) {
>> -		/*
>> -		 * No split if the file system does not support large folio.
>> -		 * Note that we might still have THPs in such mappings due to
>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>> -		 * does not actually support large folios properly.
>> -		 */
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split file folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	/* Only swapping a whole PMD-mapped folio is supported */
>> -	if (folio_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> -	}
>> +	bool need_check = uniform_split ? new_order : true;
>
>(could be const)
>
>Not really a great name for that variable (what needs a check?).  Maybe
>simply ...
>
>
>
>> -	return true;
>> -}
>> -
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>> -		bool warns)
>> -{
>>   	if (folio_test_anon(folio)) {
>> +		/* order-1 is not supported for anonymous THP. */
>>   		VM_WARN_ONCE(warns && new_order == 1,
>>   				"Cannot split to order-1 folio");
>>   		return new_order != 1;
>> -	} else  if (new_order) {
>> +	} else if (need_check) {
>
>... change this to ("!uniform_split || new_order")
>

Looks simple, thanks.

>} else if (!uniform_split || new_order) {

-- 
Wei Yang
Help you, Help me

