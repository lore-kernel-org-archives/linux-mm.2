Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C23FFD9E2B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB756B00CF; Thu, 26 Feb 2026 19:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6696E6B0143; Thu, 26 Feb 2026 19:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568636B014C; Thu, 26 Feb 2026 19:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1426B00CF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:51:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D404AB8525
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:51:34 +0000 (UTC)
X-FDA: 84488408508.06.8DCA393
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id D881A180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:51:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j+/OhOdE";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153493;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziOF1sTr5P1k7Bu3IgRhG8faEgmBbG5xr8uehp4L0ys=;
	b=jCRnb/R5VMUsh0CQ3BaRjqQryaSAq2xdBXB6qH33nviiSws+ue+JTviLWAj8bxTC4m0ja1
	CY7vkEWBaDN4/RSl2lofaq94pB5CDJoF4NM3wHjbTTbTJoZwot954JHCYb2H833SWAS4Zq
	mijtcydsuXP7795Zok3Mvaj2lAa6RDs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j+/OhOdE";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772153493; a=rsa-sha256;
	cv=none;
	b=qrUCjChgz+3IgP/i8qGH5lcCTp4pWbtXonR4HXu9OQzG24kgbXJTUxRq6rao3xDNacSVEE
	fCUCazzh5y7Q6mf5hmJ8lwxRXiqFeaD0zTmSeZzDFmLR7Fquuj1ViJaQ0dy3t8AbuTsX2K
	zW4aiGNJy8573pgDea21/ew2rd5OFTM=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8f8d80faebso422548866b.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772153491; x=1772758291; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziOF1sTr5P1k7Bu3IgRhG8faEgmBbG5xr8uehp4L0ys=;
        b=j+/OhOdEbrMBoXZjmrD1L1zRVSYoiAxBCDPEQY9EplLFSuQZ9BUA8dmNr7JlYvpRe7
         lLe+nuOgLsX2XjKaP+mN1yYykpESrYkRXcwKXWJ4l/WCqMHN5MVELKpXWCAioZV+KJ0W
         2saia/Ndor3DjubCeZX4a63KtlEjyJCgCy1Xp5DmRecUPqZ/vw4DPNgi0RRFItDKd8Tj
         hOfASg4lxkdWKET4sXzCCssewZ+yEl32qoVFUbYHdWSd5IWkd66nHVEgqLPv460MTJSx
         G1rVDwXOgpOzLXTrn4Sb+/0bXWaatp54cpR6pYHRm/g+G4ioOIEw6ZTXzxsIikvKAUzF
         qq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772153491; x=1772758291;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziOF1sTr5P1k7Bu3IgRhG8faEgmBbG5xr8uehp4L0ys=;
        b=KJ7EtZR6fzyrIjJLTEfA5sM99ujqOuvaKUeqs8gT1UFXm+KEYnMb+SalgRYyK9fv5h
         sRXgop6amHhTyy2Yz2gLEjuLcaBSS0A+cVm1aH8HnzlFLuxww7y53seAfD65ClmhSxvd
         tuA9y8K1fvfgjQgLuwx62PjkgZ+Jy2o3jAqEeg1KRu/wD5Rlum6xWqqhdwsBHH2OP+P9
         EPTfAHI5WPOG9Mc+g0w/Qf41w24vZflOiOrNczCL0DfOxM4eidab+b95mejctFdXQcV/
         V3JuaRs6M5YXVeBjiSKQQK0c8glaSV7jUskW3q74OSApdn5R4L4x6zNfZNLzS8d5VE22
         KuDw==
X-Forwarded-Encrypted: i=1; AJvYcCWfF+FmS2zfw/YUFX93HQ/mlYOlnBUPrR5XTqMtFDIYPyX8SF/vBDmKEtx3ym/0KjfOby7v6OzDJg==@kvack.org
X-Gm-Message-State: AOJu0Ywl7c1kNvP9jpDlfnw3p7G1/iBIm6v8xUcz/Txr3J9xEk8d0Fh8
	8hL/uCN4JCLrELtdipkCxG0g9jUukTm3e6RscYL2SFDQk7D9nc1ihcCr
X-Gm-Gg: ATEYQzwT6RuxVLAMKCH63/gjIWv5i6c2CQ5mLxzI6MvA5Moj9LU2k+rkTeSjLj13p0Y
	JSL1785QRSzS4HqXOFH7JRsrfZB8mQbiG2UkChlOfNU8mnQB86jIZpXHnN6WJey+OFMcoNvj1YH
	nVYiBOalyxl5fOM42nYJI4RI5CX0a0JljkrZ8YVq5RFkgTRuUuOm4SPZhKIBA14IcTyWf6u7QXQ
	TCLHR2sbKNY5wPm645cqv01ld6x9VNdu8pxO9JTzBq9/hds/vh8N+ywW3ZyxtiXUchLeiue2UPo
	xQiWZhtMVTiWDxW37elz2qG8Pb/jFuTgH9GStRrMb9fopgP2xcMsCHibVsCBFPN4xOubh22xbAc
	2JnzRtwplczhGDtSOaN7vdRmm23AtJITxsW8ArzNZKZb4glyEdFKpkyH7ugcfSOIVEVk7qb2F2v
	LPZP4tLnjDb5+7hYre7Vp0vg==
X-Received: by 2002:a17:907:968d:b0:b8a:e013:9c5b with SMTP id a640c23a62f3a-b937580caeamr73449966b.4.1772153490944;
        Thu, 26 Feb 2026 16:51:30 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935aedd746sm100330466b.59.2026.02.26.16.51.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Feb 2026 16:51:30 -0800 (PST)
Date: Fri, 27 Feb 2026 00:51:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260227005129.ujpgdvjjyqpemzxy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
 <20260223115948.sbylmtqhznmabcth@master>
 <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: kt1o91n1ufdua5634nc7u57nyaujz3hd
X-Rspam-User: 
X-Rspamd-Queue-Id: D881A180002
X-Rspamd-Server: rspam04
X-HE-Tag: 1772153492-95945
X-HE-Meta: U2FsdGVkX18AZJZwektkkqSpyQdLpNQca9nLRjN6fXKBfS+YR5n6EkqSZe7Y58ijiI9l84omxiwC0Ym4wY5CD3XHdQQyR1wM60rpNEBkythhAU2rTo9YH0jhniCIoFsbKl1CJuJf7w06RiDEDU0JZoef+77FNZ3JCcVMFlMg1NGD8LWYxHQJa9iNPCpPKoSYe+F4Q1pltG2qdpLoVYsJS2FfEHMhBXoTUAlYAlgL2irUymLULnilmmciz1953aTnymyGvjpg8DyQIbh9b2UsbJGfGfB0Ga6QMM4wM2ILwEzWjnmM5DkuezdXb0wIvwRoBOWyJL7f5P6Pp22sY/3zWg9hsIJ5uSkFV/12ctRuyWz4NRfdOyydgMbi7GDMrGG1ZPnkqxZdMHwNAPQc56/A42tIvxXv9MlHgawrEd3EOod/QBrjwGE9YbjccBaaMbsqpuZgKa8K2R/6vMdNoYg3zzEG7ZpfjAiNuzSD5k357RE/NVTLBQSAUBDh4Y9Z6+h2Uh1PMsERzhOcaspgAmSdF7bg2rNUFq4lQo5JWmH9BFA+8gPqIkc7bDZAGWxxUsgAVJGQTWSg15U1ivfYVG3ovSCo889JIGBTRe3K7T1jqY+/hRoEXKaDfQAYoVtELkXEqmwmzOx+kallHayXCjjJJWVt1gjOKC0wlN3erCbJSxuG23k+6Ja4stKz8bfJXgWhBoOCmSRIRy85JEL0IqCJadTOuY74iq8Q5UXZULNReP+dDt4fZmL3kD8osFrzM0jKUxU9yHaHzWiCtwuNyPkGGcPjYWvnuvfJYouwOMcfr6epoqKGJ+/zMO0RnRTg9mWVMOJCvahYNgS5CfmURtG651S2N25RWdhmhXX5GpRwvOE6rgZZ15d1uHfyytIzgFPzY0/1eHLQgcZT3LZ/DFoJTRF4hfjcGTcY1GhWIjPsmt9lNJhRN5LeiJWO2eetyDLItdygpZ0BcnIyVXJttlk
 6g+T8NJu
 Seh+/ZyDyBW+gUDoD8ON93jbgYM4Bw6OihyEIXQbJuHGJswpN62K2w6F/yzEiCJSc50g69Voy7wjizFvgGE84IGBAIc5XBpy2AAVU189KtOGIZgKahU/zI6OSD5v3MIFH9QHv6E3aeBDNGNOSlH9F+farBAa1b5RKlvsOMedQjtvIHf27o5RUixa0ZVO6x2EEJsYLVlHJEjKg8slTXgyvRyg3+rp2NYJltJWDcdXDrG9pXlOmZLnIezP5gRgXFkZKTMr9WtW3iIxBm7IqJKBQllIiCvvbqanpgEEv2tD5NjBNouP+gfQbiYJanH6GMCMehZBgeHzbuK8LcFCiIsdfmb/KyihI+FiLZirG5finEeDHRXWx94RSRlVnI/BlxFQnDtwQyBjrrbcxqlFd0hLlB0pGO552UVUQeVmUlEqf6beNMkp4gqhNjNQyb3m6k2HRN2ABnAc6TUnUYo32H1j4lmd0Mh3oT2mik3hRaqvi9fRkYTN/p3c7ZTZqC+P7pMUC7pRmvrU4EZV0OOj/pAE+7SO6lMFOieyiPaP2QkGSqlhaUb9eS2kt0MbPj+FFd2RcRmVxRZDnS9jLXmLUx2KL2alXEyd/KimYktzZiA4sXoXp6pZq2Dp5bLvsBdgC9dgoaIZs+JzlCiwK+ySgQk86KP8Hci45JLSRrFNfV+lTfq60r7FiyFBuay31i3caigDEWyT5eSrpnihIFhgkkkdGDUkkMPqT2D0ypI4Qh2nU9t58zPniFB9vwTYoXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:00:01PM -0500, Zi Yan wrote:
>On 23 Feb 2026, at 6:59, Wei Yang wrote:
>
>> On Mon, Feb 23, 2026 at 10:23:11AM +0100, David Hildenbrand (Arm) wrote:
>>>> BTW, in the folio world, I do not think it is possible to perform the aforementioned
>>>> split_huge_page_to_list_to_order() pattern any more, since you always work on folio,
>>>> the head. Unless there is a need of getting hold of a tail after-split folio after
>>>> a folio split, the pattern would be:
>>>>
>>>> tail_page = folio_page(folio, N);
>>>>
>>>> folio_get(folio);
>>>> folio_lock(folio);
>>>> folio_split(folio, ..., /* new parameter: lock_at = */ tail_page, ...);
>>>> tail_folio = page_folio(tail_page);
>>>> folio_unlock(tail_folio);
>>>> folio_put(tail_folio);
>>>
>>
>> Missed this. Agree.
>>
>>> Agreed. Maybe it would be even nicer if the split function could return the
>>> new folio directly.
>>>
>>> folio_get(folio);
>>> folio_lock(folio);
>>> split_folio = folio_split_XXX(folio, ..., tail_page, ...);
>>> if (IS_ERR_VALUE(split_folio)) {
>>> 	...
>>> }
>>> folio_unlock(split_folio);
>>> folio_put(split__folio);
>>>
>>
>> I am afraid it would be complicated?
>>
>> Well, we don't have this usecase now, could decide it when we do need it.
>
>The patch below should work, but for now, since we do not have any user,
>it is better to update the comment and add a check to make sure @lock_at
>always points to the head page if @list is not NULL.

Hi, Zi Yan

Below is my draft change for the comment and check. If it looks good, I would
like to send a formal patch.

Look forward your opinion.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2dbb35accf4b..8047f00bfc2a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4158,8 +4158,9 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 
 /*
  * This function splits a large folio into smaller folios of order @new_order.
- * @page can point to any page of the large folio to split. The split operation
- * does not change the position of @page.
+ * If @list is null, @page can point to any page of the large folio to split.
+ * If @list is !null, @page must be head page of the large folio to split.
+ * The split operation does not change the position of @page.
  *
  * Prerequisites:
  *
@@ -4208,6 +4209,16 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 {
 	struct folio *folio = page_folio(page);
 
+	/*
+	 * When @list is !null, each after-split tail folio would get one
+	 * refcount in lru_add_split_folio(). But all after-split folio
+	 * would release one refcount except the one at @page.
+	 *
+	 * So @page should be the head page for this case, otherwise the
+	 * refcount would be wrong.
+	 */
+	VM_WARN_ON_ONCE_FOLIO(list && (page != folio_page(folio, 0)), folio);
+
 	return __folio_split(folio, new_order, &folio->page, page, list,
 			     SPLIT_TYPE_UNIFORM);
 }
-- 
2.34.1

-- 
Wei Yang
Help you, Help me

