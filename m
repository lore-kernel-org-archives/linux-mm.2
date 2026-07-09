Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50231C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 16:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC476B008A; Thu,  9 Jul 2026 12:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3116B008C; Thu,  9 Jul 2026 12:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBC76B0093; Thu,  9 Jul 2026 12:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA6646B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:23:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60D18C083E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:23:18 +0000 (UTC)
X-FDA: 84969758076.06.3507A8C
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65F4E12000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:23:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ybl/lx/j";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783614196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXLUlDscKdqaFtWa6gdX4peXTtyRH3C0w3/WMXcttMw=;
	b=NaE6vjHJ9jDK4UmbwarE+G74yJuqvHs4hIE9IEt5uBnrKqZ/wkAxLRaesmI9jkyDRR8x9v
	qRgvrKYPpu0TiBGyYSg3HtctN+eQZF2pVKAlEpeA/ePOH/uYhkiyqeTXciOddZDbzoNpNu
	ecE9hSs1aa3Pb3z01E0B1f24Bgim7zc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ybl/lx/j";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783614196;
	b=Cf+tV/BO/da/gccv/iu+5gg7h0bmRCvJIb9wBVjFZhLMaswb+Rsu7I+DOIphxtVuCBIxDJ
	VTVdtu3j07uj04UNEnqCeosvSU/zizpGXsB80CrSUqaheM/wFxaQFIaAjondanCdUAsQOI
	g3R3SXEOwW6TC9DUPyKlP43/Q/pvXP0=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso8920a12.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 09:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783614195; cv=none;
        d=google.com; s=arc-20260327;
        b=Swm8xhZ7fI/bVHBPldmzPP7aHKaowcCyJU2RJwDzwAlRddHPEXoED+RtWXpR+EJGx0
         EXRyQwATnraUlwGlq3DYNQNKBsIENNvHcFk81xAUAe0ofAGrIn5pFEwVKzkeE5uf+uGT
         Ok/pH4czbWryy8AJo48pDN5eHbbmEnlDw00MZvF3BsPW8qO53Fa5b63oFEEBvG+sg2Ia
         u7oF8UKWPSczhXTlrFuq68pCAHTb2+53MIzx3l9hiy3TqU2eFxr9qKiNXHQYUBIOc8T5
         JW1Kh6amCnGHHjEkq7q533oAC/FhCyy3Q/rnSxBgCp0nqyyElXCJGMClDDC83rnh5e8Y
         c4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=yXLUlDscKdqaFtWa6gdX4peXTtyRH3C0w3/WMXcttMw=;
        fh=LQ7LHEIOehraUYGYK4a4efzI/ZLgdi6Gm3de1UsvUfA=;
        b=ZRNdbSmuX+WA+JiBdcdW4D/yejk8zJE9f/bq5Ez3PRoTYoPuu5ceG/VSTpC27gcYa1
         zeASIi7LOqLQZfsV8wWRUklMfUzNosGlnXEBhQnUNrSB+vyq6zdXP52m6/SIadkrPu14
         ZQ/1UDGsXulsEnaooUrW45zKFAbLRvWL+79nY6gRh50HdcWkG2uDel+7jN4DEa9ERt3c
         aSgWlmyDvA/6j+hXwk/BDPFSQgYUfka0wGvuFqfC1E8h7VSEfR6kfsU82RgwEprrvYzE
         mnBUyZyi70AcfeIbCBOUmt3xkpsab9e1LY8OEH0C28YDqOdiWAzVPQiA8XOVXMufMyXd
         Imhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783614195; x=1784218995; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yXLUlDscKdqaFtWa6gdX4peXTtyRH3C0w3/WMXcttMw=;
        b=Ybl/lx/jXBb4WOjaEwKsXoCSLt/Gle2ObA1wNH/CMacX/PiMB5MXwKoaY1OUAcRbNC
         y0FElRW+WRWLSLMR61iwVdaRCjScIp4OO/XcAfqHghIUuSgf8gwX/w2oejbXxQXgVz9I
         d+G8fszP4cILOuuM6lpJN5+DwosRTAYgiZNUqW/CLjgFoL4xpnkN5oNmXlGc+XxkO9mJ
         yPSDEf5y3yTH2PK+k3EckxC6WONExBj+7mRudCkc+hCejSoJxtgjZPrPIB8NTJ+GDvs9
         hMh0YaU9p5qNHwnx1n1CPtVi2Zw/IEKMtPLDMHNtcHGRe5V22/40jE6vxYHpwy5MlrQK
         ZtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783614195; x=1784218995;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yXLUlDscKdqaFtWa6gdX4peXTtyRH3C0w3/WMXcttMw=;
        b=nu/VIIIvNv6imEGClH2Hhr6VYO2x7K0p5YZ7Iw1zkNf28Xix+SqZhRgl3zgsNx5h8Q
         j0ZAYdFC2NtOwP74IgOht3CczoKEMVfFMvxCghA01zd3EgE0m3xNctK/bQ4ysNPkv+n9
         2SbMMUfG0nQV8Apr/OSj0sABOcA2AXk/PPQsoMWSTNogQ5+SENS/qoBP8tLF1FwhDqjf
         dtHEmFo99ADIjuL+ocuRBcQrFFuIS5a7HW34hrz6uM4RZpbTAXgYp6mbTjBFXKDUbGoM
         YWYgflVKhP1sNqGbX99m/9Zh+WAYIWWhpnNsAXlOK6FB9ZEJ2gDETkuer5x2iaalwEaF
         AH8A==
X-Forwarded-Encrypted: i=1; AHgh+RpeHvzui5o/6nAuxeKQ6wI4QnerJgY8ftlZBUVJKtOzewj0/XlRkVxXm9Eo9VV/okpYCtnR9SYYVQ==@kvack.org
X-Gm-Message-State: AOJu0Yyklw++02bBTBxDINhymGNcpItJllKxaj27PWcYPa+QIVS1Vk82
	zhNDLanD9ny4RlBnzF7hKE7tgYJ5XXxdI8fwfBCuFFXOj5uPkRtgHQ9a0LMT2TsjK77V0Bsw85I
	OCPWQY3baJDFo7cdfF9MqVmPW/0cMj71xP/DglJ6e
X-Gm-Gg: AfdE7clxSvAXQ/3u4wjkC5st9/8lgOYeYAoRAUwpa8O0wPfj7EgS9I2+mjwp8VtcALG
	1fGsEOZP28Bh/O/1unFqldUZRMq3DqwuJ//1rnP+swpmbwcyXFqnKWcWPxq1luqSRAplHpwV3DD
	JEa6OO0s6tCeGqyUQkStzI5u0a8YM5+O0fNQNKOa6kP+1mWmUoRe1mxso6mT1lf8N25AR9zKdJl
	MKpxGqeQymWYiN1/yC02xeZ8JDFRSZdSg4xLTUhuFw5llx6Tx6InZD4m3zdrtvwsfR8zTHxrjGI
	YPNNL5HSWpuDWvgwlB2orQ2zhKL33I2tswykWuHJvbYeS3EhbB8dF6VsXhY=
X-Received: by 2002:a05:6a20:d507:b0:39b:d5f1:4ff with SMTP id
 adf61e73a8af0-3c0bc902b0dmr9484766637.20.1783614194738; Thu, 09 Jul 2026
 09:23:14 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 09:23:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 09:23:13 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260709153409.2091070-1-joshua.hahnjy@gmail.com>
References: <20260709153409.2091070-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Thu, 9 Jul 2026 09:23:13 -0700
X-Gm-Features: AVVi8Cch-3WqSt7i_HowDJvLyFz1SAr8FV9RFaDIKKJW4K9V-dKOUNAs9cFlW40
Message-ID: <CAEvNRgH9WSF64eKardR9M9VeRiN85UkS=Zsje9H8mqjQQychmw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
	jthoughton@google.com, vannapurve@google.com, erdemaktas@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	David Carlier <devnexen@gmail.com>, Zhao Li <enderaoelyther@gmail.com>, lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65F4E12000D
X-Stat-Signature: 5dantns4mc3srfiky9i9fxyc7z63ogg3
X-HE-Tag: 1783614196-289709
X-HE-Meta: U2FsdGVkX18hTRxGb4FWVEeV/ib7PAnj91/SpttCpe8fqkcXzcODGJK4WFDJ7Kugf1nC35XMXpjDM3N7IPynelYptzxbFcofy7Ilmdo2TX/+9uffUGMFgphWA7uQjEuaeAXB4Jf/vmo/6q4z6RxJS2J/KwNvz+/LHcLWAtiJt4cNf487gRFvmc/HPnF2Zi2TPdWHXdXcN8pcqTluRn41rTBL/QkGVX067hFxrJo0t17rxoKk1rVF5k3AhtGDqW6v99cyTQUqAzNzavz6wnsyF2knjRZwAxVjI74mbnYPFrcZvUbJFRmmIZQUuftF3WBBxEOdiUUx3BIHM18q46Lhm+iNE8GlKKET5ySNyFZjQJnL6iHbUNhJQG6OjNpslDZdMwd0VcSSnDAOwRG1pueb1TZ2xyxzOKPk+WOt1z0gXoldK4oUG9VW4l5f1jsNEZkxqRl4UkMIphoUJXT98OwUV9cl67jEfbhhj0Cwakn2KlYXm7voF73uvZGo0CU/74AfzDKDpSoddg2qmKrJmsaaSEcSRGBqjVzB/6H31FEuJwbwZ4uBs7Mo34FdulH4JfS4oRmusOJ4i5h5Q2bFghzWHBsBkBUYCbnDmWAQIu+kbbxZyZAi0D+TOKigNwunV0NVKjYGaajLynUDR2LTjZFLw7xgun72vJBIrU/KUf6MQoBhJS9gJm+PLYq6iO0h63MrSWwyDla/3xZ2qqe/Nhwmkqch8fd8HjyvE34zMbtPshiAXYo+rC+Ar4qxP4nHgCMj4fB95d/Veq8ravD1BWysFVoY6oUDMOPyDHS+iyuyO6XBLgHK7oJPyifzW5UopZyKv33yJUGVdZzjsxIETznwURddB62cuPI5E3sUyhaCCHvhXkUSfM+xTzBXXlRdvFnyKhMRFP1Xhym/35fp7auOjztKnC5O8qJbAV0d/VBOEwK9sANRnwylc1x3Jy81nno0H3alqhNfPS5/0aiDI3z
 urIuNQZr
 9vQovKXOCdks3lS9y6VwENVQ51+nEa4B7PCeRUik8lqgMtXXz/AjxUOys6wB5FpAZDJo7t+UkHOnO6nYYFnJK3lmMMfqTplLTbzVNytREBPnXo31QxxE497GKolD9DFamuCIfCrPeKgncpnM6WplSLFJx245R5FT32WNSlEJHhV9HknlQW0XdMrtDrD+rSWKhsW+Nct48J156DurXKwhmOK1OgSfPJkfmG1sEWaSdcnkjSBUbgYjZ5E6EoJFiXFXwshTMO2Y6/2W0cS/tONef7faleQcGwgC48BnD2w5jZQUVARLj2vmshls5ZTWiWvMQ0qLCuT0l6AD9nior6xumeXd7Smjg4Wz+YTsvNKK6q+VYyENE5EfWDgFfQoeyHxbjIFNkU4ENs2zP2MaOL7G+PvWa91z+Wlai37/c+2kFlPlj0hSNoMKgq3k3djVepwPSTt1uW1ngIhuRXLhk9b6Z7v5SSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> Hi Ackerley,
>
> Thank you for this series. I really wanted to work on hugeTLB accounting
> fixes but never got the time to get to it. I'm very grateful that you
> are taking a look!!
>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
>> hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
>> was not used, but a global page was allocated instead), the subpool page
>> acquired via hugepage_subpool_get_pages() must still be returned.
>>
>> Currently, the error path out_subpool_put: only calls
>> hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
>> skips it, permanently leaking the subpool's used_hpages counter.
>>
>> With the earlier patch to always track used_hpages in the subpool, always
>> call hugepage_subpool_put_pages() if map_chg is true to consistently
>> restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
>> global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
>> subpool (and global) reservation was used.
>
> So I think that I've seen that this part of the accounting specifically
> is a bit suspicious. There have been two attempts in the past to fix
> this area [1] [2]. I think functionally they are quite similar to this
> fix, they just open-code the contents of the put_pages function inside
> the condition. I've Cc-ed the authors of those two patches in case
> they wanted to chime in.
>

Thanks for connecting us! I didn't realize this was already being worked
on. Also adding Lance, who commented at [3].

> I reference these fixes because I think they handle the minimum
> subpage case a bit differently. To be honest, I recall reading those
> fixes a while back and getting a bit confused on what exactly happens
> when the page is absorbed to fulfill the minimum size...
>
> It does seem like Sashiko also notes this as a possible concern.
> WDYT? Does your reproducer for this issue also work when a minimum
> size is set (let's say, to 1?)
>

Let me look into this more!

> Thanks again. I hope you have a great day!!!
> Joshua
>
>> Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  mm/hugetlb.c | 14 ++++++--------
>>  1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ee5e99c1894b9..4093c1c0a4a1d 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2852,7 +2852,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>  	struct hugepage_subpool *spool = subpool_vma(vma);
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct folio *folio;
>> -	long retval, gbl_chg, gbl_reserve;
>> +	long retval, gbl_chg;
>>  	map_chg_state map_chg;
>>  	int ret, idx;
>>  	struct hugetlb_cgroup *h_cg = NULL;
>> @@ -3003,13 +3003,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>  		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>>  						    h_cg_rsvd);
>>  out_subpool_put:
>> -	/*
>> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
>> -	 * during hugepage_subpool_get_pages.
>> -	 */
>> -	if (map_chg && !gbl_chg) {
>> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>> -		hugetlb_acct_memory(h, -gbl_reserve);
>> +	if (map_chg) {
>> +		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>> +
>> +		if (!gbl_chg)
>> +			hugetlb_acct_memory(h, -gbl_reserve);
>>  	}
>
> [1] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/
[3] https://lore.kernel.org/linux-mm/20260428113059.79001-1-lance.yang@linux.dev/

