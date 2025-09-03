Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04ABFCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FB76B0007; Wed,  3 Sep 2025 09:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7A08E0001; Wed,  3 Sep 2025 09:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D64D6B000C; Wed,  3 Sep 2025 09:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4CD6B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:11:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED942140199
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:11:25 +0000 (UTC)
X-FDA: 83847975330.10.1FB6A06
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B95940009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:11:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sbq3SGvO;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756905084; a=rsa-sha256;
	cv=none;
	b=kz5Bx5QhBtjPYYLTewT+eru398HZL431KxloOADpOuE45oNvbEHxVMokczL27ZnM1X5tkC
	ZI3BB1mImSc6wZPqrRSd6WieomXpjW0R2RxIYUuGfYHNcsypxh6srK6ltnq2P06pat+D6N
	cbxKuo7cZDKF05CYa4bNGtHGWGe7YWY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sbq3SGvO;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756905084;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HclYStwOCOKmcMB/Tt8c6EjEFXgSd65p/VjuWOlNOQ=;
	b=VSHPaiTccuNM70irhUwhctAdEWcYK8gCpaQr5vEiSBFU7InT2/oFm3bqmAyK/EMFPpevCX
	2MJW6/JgsxWDccD2+ZKdnpxErRKKt6pTC1h2ke4kD13LSFee1erGwij/QAmoBC3CstEOj0
	rwMnBxLDIweFHxjel0q80SNV+xTOZT4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b043da5a55fso396110366b.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 06:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756905082; x=1757509882; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HclYStwOCOKmcMB/Tt8c6EjEFXgSd65p/VjuWOlNOQ=;
        b=Sbq3SGvOnc5NQdJ/dFIaBp633KXQwxRHDd1ryTulzA1gCWeuw3A/ZmmrvUR2MhVxQV
         N0WBZV5PloMo/wOjnTxqO/PvniMIHgN6fPzitdgrXqs/pxSnEY4XN+h4TBBbq4QfXJP4
         qyFCT5zlUX+EcGpYfwvdYvAsdUyLeNigR3ECvWbspwZwPTC6hO2Gx3kVc7LoKQQ0i7Is
         bmzgZL1FMuY/CKFLcY5gnhl1S7uzua1/yA6PVOhVl3QV0vqL511mQPnMz4U3sm97eX5P
         WTmCGC7Kvgw6Uat0xAIlUB791UT9uUOBtVZR2gWKn3B74p6eD6umADvFv2wWro+QZp/Q
         89Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756905082; x=1757509882;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4HclYStwOCOKmcMB/Tt8c6EjEFXgSd65p/VjuWOlNOQ=;
        b=sW8tWxHdwYrc/UiixrTcaNBQ9kGknF70anyYcAB6W4yCvn9QSLUOr9t4aVADqN/o/Q
         lFU27HV2GeNM4mEP0bVj+MReRY9YNf0Yapqn084BDjgCeTZeI5Urp0hSBkG6Kv7C35FB
         zPgmk/soXUO+vwf7wIwJeLyNCOprnq7HVTBBFM/71dH2T2XRpW/PDtV40Vt+YmQvG40p
         GBHIpb/65bEPePpq2Kw1AJ3JdIsmcOWPobCB9nMUqbDgfNny2MBc/xtFrtEzrpT+Hh3w
         Mc/3IBrtvjtuHTTI4vsZe08kioTBSQT1KsCiUhjkhQ8/KsESwa0hZFGpVh+ol33FLgti
         PEfw==
X-Forwarded-Encrypted: i=1; AJvYcCUSm5OFMLMQQVsxNYZfz6HG8wypSv7rg3TwFgok27JXvkLviZTD01whptsBufj+2M+ZAF/IjDTz3A==@kvack.org
X-Gm-Message-State: AOJu0YyXp6z/BbW1drOHkUe6tSO9CTEBLReW5diBwV4yZcENqYrrWNNU
	z5DVA6DjLLLgpuSQPleZGR/3laSEb99cmcCioig1QC659r0hfvbhmC9q
X-Gm-Gg: ASbGncv6Ga0j20bzqcDGIkNTKWMkDbcNVhCy54ESH4tRPd9lxR2RM1O5FJ5Eyr1OMab
	h8OLWgf3iZZZEcA9cvE5R3o5twUNNKe3B4Djc10Aat6JAVbwDeYBZ0QfzHHM/Sm1Qq5rpLzwFAm
	Yk8Sjo94J/USAFBn/jC/qMLZ/n1kDFsV7ov1Sr6MemYcYREGBJt3yPZIAJzAoq/wJuzLVwYRztu
	dyIYf0Nu00DOSu7KgYKJLuyGfUSnnS5KquAKT/TOzoxdJAfnHzLl7FM9uTx+Yx2uzdZvEVIqpNj
	izD1NzIGRd1b5VJ9VrPft0O12j55tjSBsL71Vwt1adYbanXMdWqGj3vm8TAu7xYdXShToVUfE0n
	5EEEnQ1wIqvHwkw7BO31rYqFpgC/lEzRNPc3o
X-Google-Smtp-Source: AGHT+IEvolQ0TZapG8a9VwnXAMFKX6vFBRt9OPxFXx9ScLuFAy8TDm0fNdRCVyXZA4v1mqzngETARA==
X-Received: by 2002:a17:907:a48:b0:afe:c795:9ad5 with SMTP id a640c23a62f3a-b01d8a32186mr1345554866b.2.1756905082215;
        Wed, 03 Sep 2025 06:11:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04709b3effsm79021666b.5.2025.09.03.06.11.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Sep 2025 06:11:21 -0700 (PDT)
Date: Wed, 3 Sep 2025 13:11:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, kas@kernel.org, willy@infradead.org,
	hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <20250903131121.eq32tcuswgiossgi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
 <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B95940009
X-Stat-Signature: q5fwwdci5jdxhshz6bef6ai7inksrrdd
X-Rspam-User: 
X-HE-Tag: 1756905083-303628
X-HE-Meta: U2FsdGVkX1/hoFI+0mTYM4z6XLuSMkvg4ZOv0a3AbN+TGXMeSCvoemK3lIRTScY2WpXZz/+TY3I9urMX5uuX62tFOqhaDKRh6JND87pLSW0iIHMw3b6NEfRGFoe1/N/W0pgLX+w3rHmkZVzF/HPp+tUgpNsjlfxp0yWI1GDZs/N/aceJiTx1tWW1gemqfRXVTxT/vxJY7n915h/1Z+yUxl4CSiF8Mvy2U/nlr0rgblFsCEU57LncyeZIkneRccp/0qDG+QznxP6D5KPLAmRywKGVIvxorDVEDNsEowNxv0OT8PRKr/IQYbPCMgrQi7P0lgoKAEHrE+osTsz7AQJeQQ8/2OAn1FzNoI9d0/5YM76B+p4xytdwY6FKu5GRGaeiaXVQml/kiLXDRILLoc7DZxhSEOTdqcf4H+4Y8MC6jO/i/LJK82PoSqGg6r+JUDPUnTzFyrIIrqujMqXAE5/SeYCRHsFDKvrl5iURS1+q3qSDTCZlu+t9ZTTlxn2YHdBVtIz1jV9IC9ffTWoSqH5RULoZiNDNyfQxd6sU6MPFjp4yh1DO9S+fg+nTJ+DK7gycp6eEWCrTgQJosjsEb0VoRns5OdWR3867NEnxiZdsv/warQYOXl5CaZ243bPXUns7yPqt3XMlqbRyV6My0iuAuW7ChcF57r0Dfd5LIHfY9ycPipU2u/2Arc4WB2utER0Ag9w1ozSAVQ8GY0EyRBpWvn2MaAlCCB+eKESwm+/oC29DF070P7wgdjXU6tvmDyLNZ4a8Rar/B7rAvfC7Uvf7n37t9Ily9G87MWNYsH/o2Q2ojdmQgno1SeubyAqgn4c48hUJY8KSOkf6M3KKvsFzzxdAlS7BH+SPcAGNeTR3X/vi+YerU64mphgtTALipzsFybdjl3WuddgrhtHMfKIcY4Uolja1qPI3rDGUISOnA5TpXg4hf51hAI+rbgnS910GGpZ5//Il8OMNmqlLakO
 vdJ/T+uo
 wjezyc9qyM/H+Ifi5wCA/kI/t9O5yRRYhIc0dJHXGT+TILfIQGrs0OGzRag+IGD7ZcO2X5JnlkwbNVr2u8fX6kqSGnP4GGf6IRp+o8B/Uvt8C4c6EwpKuXzo/91UQ3yuOBll8N7ssEMVWnQrIZaE6oxpRMbQL5UUwpYk3F5OBnhAr29gcFb2p1rhgf16Eb4ivBWMPRpypXXhIsk3nrT5v8sRXgYpriozPDwMASHDptvMsF2PcwOwzv+m2+LySpP96gWrzMYK5COZvsUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:45:28PM +0530, Dev Jain wrote:
>
>On 03/09/25 1:38 pm, Wei Yang wrote:
>> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> > Currently khugepaged does not collapse a region which does not have a
>> > single writable page. This is wasteful since non-writable VMAs mapped by
>> > the application won't benefit from THP collapse. Therefore, remove this
>> > restriction and allow khugepaged to collapse a VMA with arbitrary
>> > protections.
>> > 
>> > Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> > non-writable VMA, and this restriction is nowhere to be found on the
>> > manpage - the restriction itself sounds wrong to me since the user knows
>> > the protection of the memory it has mapped, so collapsing read-only
>> > memory via madvise() should be a choice of the user which shouldn't
>> > be overriden by the kernel.
>> > 
>> > On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> > benchmarks, particularly hackbench, with a maximum improvement of 12%.
>> > 
>> > Signed-off-by: Dev Jain <dev.jain@arm.com>
>> > ---
>> [...]
>> > mm/khugepaged.c | 9 ++-------
>> > 1 file changed, 2 insertions(+), 7 deletions(-)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> > 			writable = true;
>> > 	}
>> > 
>> > -	if (unlikely(!writable)) {
>> > -		result = SCAN_PAGE_RO;
>> > -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>> Would this cause more memory usage in system?
>> 
>> For example, one application would fork itself many times. It executable area
>> is read only, so all of them share one copy in memory.
>> 
>> Now we may collapse the range and create one copy for each process.
>> 
>> Ok, we have max_ptes_shared, while if some ptes are none, could it still do
>> collapse?
>> 
>> Maybe this is not realistic, just curious.
>
>Misunderstood your concern - you mean to say that a parent forks and the children
>VMAs are read-only pointing to the pages which were mapped by parent. Hmm.
>

This is one of the case in my mind, while what I described above is file
backed VMA.

Since pages are mapped both in parent and child, we would count shared ptes
during scan. So max_ptes_shared would decide whether to collapse or not.

To play with max_ptes_shared, this is a magic to me... Probably, there is no
optimal value for all scenario. And if it do gain much performance after
collapse, maybe it is the application author's responsibility to use hugetlb?

-- 
Wei Yang
Help you, Help me

