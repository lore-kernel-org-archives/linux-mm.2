Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CA9EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5AC6B00B1; Tue,  3 Mar 2026 07:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2A36B00B4; Tue,  3 Mar 2026 07:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE686B00B8; Tue,  3 Mar 2026 07:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 284666B00B1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:50:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0E91160111
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:50:15 +0000 (UTC)
X-FDA: 84504734790.11.4A26FE6
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9B814000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:50:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=arQFzala;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772542213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQR3yhh4HdUVDg2I8t6pZIuvCqPm8OVYSM3fHUXSeCQ=;
	b=BlzKzeeblo8s3SLtLCNp9VtHbV2yggIIOjzJIF/8PK+j+VBhTY4aH2qgELILYnbU2jhEGF
	UIxNYWjYSLUPnT/7XzE1NkkkP5iAZ8fPpcem1TD2H4G29/8DUNxj8ER3GD4tOBzupPkqak
	+QDnwf0+ngqebSBM0BRu3unqDV2jZx4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=arQFzala;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772542213; a=rsa-sha256;
	cv=none;
	b=l/qicqILQvhjhKccvIsLupYqdCRBTtRv070iFyvdCeD9J5OUiET3Fpnt82W9shV+/DrmS2
	ReCeiztNBtEaCgG8pzRwGi7XBJvSBvKPtOLWkqeJTLOrVyXymMv+/vQuHDi5VebwUO7wHj
	aXrh/WQmyUirVCsCmYQpvDiYUcFykbo=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8f92f3db6fso832383666b.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772542212; x=1773147012; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQR3yhh4HdUVDg2I8t6pZIuvCqPm8OVYSM3fHUXSeCQ=;
        b=arQFzalaGm06nARWE6iD7jvqNzr/Mt/3tiG7S53AyvwoeQDh+YM5Q9K2h4UFkgkeCR
         XT9Ynb6novPSksnnXm42sDSLIvLUmbJ4SOMQ2Q4+T3F9J4MCI+AyNY4+AfIi89TbJP+U
         PNSLpYVf1R1ITHMcrvPyE0N1c64Lxhyy6Ot0GSBL1xB+olc7ZW1AWzHWo88145bFXxri
         SVAXHKWa9rcaDchE48delTzAQFdU543NTLD77gpbJI31TeeuRVxVp/EScvA5Gbh0rCjQ
         1/z+7/5gGOuOUcxoq2nhpItHu2fdtvPoDkjxe4PExjCQbkuHFQ1RB+hVFFEeZVD0Zu1s
         YB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772542212; x=1773147012;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eQR3yhh4HdUVDg2I8t6pZIuvCqPm8OVYSM3fHUXSeCQ=;
        b=UlrOwo9JqVyBoFkZXVJf+PNRV7IhmNCEZ6TwH/rJDaYO4mnT65FF2o0xj51dWQfcnF
         wUvOlK8IrEzjQcwKBvaq9C7RWzRpFp+p6y/TyGhTv1Rif6kWEJbC+H+Ba4S/u0zWilAh
         bQzvkkI0Oz/2fqrJutoExCzvnjqDp31JoZLwloB3utzfJd1TXmh6gDW8PGDUyjCn9Zq5
         qgIQ8HsL3i0VTMC1SMQYWgj0ebuwh9EPorDBt5UIkt81Wrign/6CSYW0xprf2Ouk0XkX
         Gfm2PN6kBR8oLrILeopaiElT5cAXEH5JaeVcV1lC1DR7jbG6BjeXL3lqgPWwZbtzZIO5
         ESCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpxT0lQrWYGd20WLCD1r+Uw1+15H9ok2STst8Nic+mJrsqxJ/g3INg3JiqvgSyAfCHkbCqKXpmVw==@kvack.org
X-Gm-Message-State: AOJu0YxRQVgefFwidqk+jLiQpjp0a+iF695TvYVEyVjiNA18PfL3iv/h
	TbcpVjkP5xb9MI172KSRiEZYzJLsDOQHY2Kbc+88vzdYKb5dHAJF4EM0
X-Gm-Gg: ATEYQzyBE7vj0IcMUZnXsZ5FNCcborYo6vAb+y5Ad1jKatx121ImOC7OJ1SQmkhn964
	FpgIqvq6phmSThNuJl1lFRP6K7oSdP6SzXxtmrGt1czfznYqvKyzBnqRKnmpwUbATok7GMUwAAQ
	ueYBwY3NvyS8Dib1S6mzzpOxNmvWYZw4k14p5rTJLKzK2Hk1iyu3JcUtTnH4YD3Vq08b56y+YwT
	oYWfpuTFTMOaviqt+rYW/IXw0QBdLEnoPCAlnlEY/wgrywf1VXoKIPv6D2965UHsN2zJjZ7LiV3
	cqBn9sE6c76nhAbg1K3yCGo/M5hv0r656yYcTHqZcx5oQXARx0SVCSIwiu6Oz0scS5kGDoayJ2a
	IlU1V+d6xCIiBY+dKuJfyb9MwF4CG7AJoqucJ2+hJxxSRoast6Vn4vmGIRXTuS1IBhviWl1Of4n
	xQpCZgwDszXPdnzhwHo5xYQA==
X-Received: by 2002:a17:907:3d0d:b0:b8f:d13:def3 with SMTP id a640c23a62f3a-b93763a65bamr955636166b.19.1772542211770;
        Tue, 03 Mar 2026 04:50:11 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ab13558sm602304866b.5.2026.03.03.04.50.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Mar 2026 04:50:11 -0800 (PST)
Date: Tue, 3 Mar 2026 12:50:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
	jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, stable <stable@kernel.org>
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Message-ID: <20260303125010.54j3bmu3joixezkk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260303061528.2429162-1-dev.jain@arm.com>
 <20260303121727.ss3d3gbzituygb6p@master>
 <257aa379-64cf-47af-b48d-8817f7bca257@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <257aa379-64cf-47af-b48d-8817f7bca257@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9B814000A
X-Stat-Signature: 8k7kwsuiqubw4wtzrng7qoy8t3ypkz7y
X-Rspam-User: 
X-HE-Tag: 1772542213-898850
X-HE-Meta: U2FsdGVkX18bBOCs8LPJ+9g4DjD+2TSfBeWndgXp8/8dcoWmU/YDRqT/etq5iLiN3uTafQeF2VOoWRawfS/AatrkvRGipptxl0lCFAyThgWNnMWeQqC5q2ilnxWhn+L0L4eVjCKY5Ur7FfgyId7/ZkQLmsZGgKEZpPyGJ2mhf/PTjQr/itLYywDDWoChnFXvSaRXvXqrIlbkJZokH8HkWCGiszGS7XRVEhqxifM1r66lx5Umo256A/0f8xaDYdRmiUru2MRJ+IaqXQd+oOGWYC8WSpk70OLmbrP5/pYpMBHqCXpGXYeoDBNJtBMbO1E2hRPtt8ydbyvOSZHwb1W4rDLBIN5zL/b0lfvUJjKkhbAgrSp+JrWplzaAtZ4PFN2vt/gGbByAPGw2U/qIr9zeZCCT7fR5fe4FBopZSvm9jF/1bgSIqwZiRNo7yL1leL4ptlgP54NAm20aHzkBMDnnqLFLbaxasZDmXSMk3F7MH9UiCaWk7hg13rBonuuWFn5w1ROCqU4gIqfv46//dBVSGfMW1JM5BIBGOlmYrZwFXgVIjFwpCl6srfT7pZoMHLTfqArPMwCe4tuxTyDBLXV1Q7r1wTT0RpS/ul7Od5/PvqD7Jow6aniibvti/fN8RHtnEfVp1D9NnjynhXvu7B1BGzAHK0UXEuq1TYkjjNoZKsdqGXsHRwxqKAGMsf2s2xc2nf45TTRpfISXLGAPl7/el3tbMFt0vtPcdgxWUiMz/v8UafOtw/LIpAOd6oTRmpw/zpKo/RnFMjnlG7OSXy3ZSIsnhGP/vnasvnJfbq3IDYFoYp0fJTIDDIdzLEdC/Z1+GFSqlXKLpqWxRRQ0T0BmP+PEha2i5jlu4koA24UOGJJDd53nc8EaLzbqNP8ZvJP2B6bMDFmYCPtNJHxfPM/zgNqfi58QikXJNaEduHSUmaM7iitn1X+9rBisuv/+DwB2D5TQCmud/OURN/2tRbl
 P15U3sNu
 RbyEQMqI5ZIbdK1fjvUFbG/E+0Q6zIu+tuH3Csf0rBqXkGITg9MnSQc27nPaKblf2pm455M/oMx/jEkh6KFFRa1pHpC+HrXGDCdmlQSGnjrjP0rSvvgk0RE/cJs4w9er+N7L8U4K7F19X7hFIEluehHLox7wGQ0bzjy4YuJ4p5RDUotXEOIIK/DNzgE0Mr6TYoHRTeY+Y2ksCPV3Mz8p4Bov3nP0+zBa+XGrefjVZPVVluxnBrMzQ5RF5Ne0RTs2C2NkXxEl1JTZqURuAX53ErgNGKAM0+zczDdmlkSOZPfp0YNKeATCUiEmSz/jqDIhfbGg6cQo7C2/8A/EN0vSs09YJ3E1tTzLWqDoVrswMk5gOfH4byQCSwms2+azvnqM4XaC1+XOU60eGLOqBa3Opg47SPV9Tt2eaP7kTm/tzv+CWuDljYneX+4IbvHttkQKtDDZGNw+XPOkX077p6LWWsyGrMtvmBH/frGC+tbE8PSnzbrJwBB1W4zNj+iTzeHmlPjdPpod4Dfa19f3hTIBIIkbIYKn44ILAHeA28oLZWNWR/PgypEPWWUePaMizbhTl8u1AB2UE2P1p5NVH+D7c0g5Al0v9ffcDAiZhDpTLkswiA7XhkOim6OnYstH2QH6DFDQrHK0XA4xIZUHViPB6H1uNiq9EksJhokb9e7YGpCEEeCaO0YskPGsv3a55S9vb5Tw9Yl+XRJYUgYL5rxOIdT8gVqoxb27xhA7hxHX+gGb2N+sU+g2Wjgyi77+1StIgojRuVaelGaY7wClt9xBQ35hmDFs/Pg9Nbs/r4z+NqICBwtg6y4BIc4Y/5NdPPkM58aD2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:55:58PM +0530, Dev Jain wrote:
[...]
>>>
>>> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>>> Cc: stable <stable@kernel.org>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>> Patch applies on mm-unstable (9af4957ef127).
>>>
>>> v2->v3:
>>> - Don't special case for anon folios
>>>
>>> v1->v2:
>>> - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>>>   failure path
>>> - Also handle soft-dirty bit
>>>
>>> mm/rmap.c | 9 ++++++++-
>>> 1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index bff8f222004e4..5a3e408e3f179 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>> 	if (userfaultfd_wp(vma))
>>> 		return 1;
>>>
>>> -	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>>> +	/*
>>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>>> +	 * upgrading write permissions for ptes that were not originally
>>> +	 * writable, and to avoid losing the soft-dirty bit, use the
>>> +	 * appropriate FPB flags.
>>> +	 */
>>> +	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>>> +				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>> }
>>>
>> 
>> Hi, Dev
>> 
>> When reading the code, I got one confusion. Current call flow is like below:
>> 
>>     try_to_unmap_one();
>>         nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
>> 	..
>> 	pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>> 	..
>> 	set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> 
>> We get pteval by folio_unmap_pte_batch() but it is set again by
>
>folio_unmap_pte_batch() gives the batch size, not pteval. pteval is
>given by get_and_clear_ptes() after accumulating a/d bits.
>
>> get_and_clear_ptes(), which maybe a different value. Then we use this pteval
>> to restore ptes.
>> 
>> So even we fix folio_unmap_pte_batch(), how this impact on the final restored
>> value?
>
>By respecting writable bit, we ensure that the ptes in the batch do not
>have a mix of writable and non writable ptes.
>

Thanks for your explanation. I got it.

Then the fix LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>So, if pteval returned by get_and_clear_ptes() is writable, then it is
>guaranteed via folio_unmap_pte_batch() that the all pte values of
>these nr_pages consecutive ptes, are writable. And vice versa.
>
>> 
>> Hope I don't miss something.
>> 
>>> /*
>>> -- 
>>> 2.34.1
>>>
>> 

-- 
Wei Yang
Help you, Help me

