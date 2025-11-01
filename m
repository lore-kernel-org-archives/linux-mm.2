Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B76CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB2C8E008F; Fri, 31 Oct 2025 20:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB578E0068; Fri, 31 Oct 2025 20:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC728E008F; Fri, 31 Oct 2025 20:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D95518E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:08:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F636140629
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:08:52 +0000 (UTC)
X-FDA: 84060102504.08.8F0F11C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71CF5A0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:08:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QSrNMqGP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955730; a=rsa-sha256;
	cv=none;
	b=GaH1T7J/GQp2SadN3Lk+rDLinSc3gI3D4WCbjGgKaQvrHzZHMZJvXC6BsYlXr5TSolVxft
	uu7/GeQPvhqffvn8stpWPeJSjrRCC8zQ5lDwlBWH70fW8juecM4+Uhe5GWK04efFTGVyNH
	oNm9pUDJmqEYGljIHyUxBHtqOuloU1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QSrNMqGP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955730;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqXAJAEFd904kI53cyI6EmfD14ywqnwjSyxvJFGdSTo=;
	b=JMAUSMScA4o9w/odZcICfwu6ylW+6KLQqfF5PxGRC/CKTw54JBlNu0IvvP9WT+BjaoG1oH
	N8Fm2knYaDEVqhqEuRniWo4Q8rQ6ABkEgDzyvLAX2JRgL8zTzTMJEo1c45g9O835Hnt8CT
	aik8rlNjmj4Scb7cJ0RxE4Q+3WKLSzU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b6dbb4a209aso514389566b.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761955729; x=1762560529; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqXAJAEFd904kI53cyI6EmfD14ywqnwjSyxvJFGdSTo=;
        b=QSrNMqGPAGJl4nJQCX7p5QrrVSMGtX0Zzj6x81XOHqBaHJoi6MImhEJkpybljQojZ1
         30DufJShJKTgfIxGE0mChP3rMOpc3e4ToFdvna8fe8od+UGREGEgkcLiXMQdLwgD12JN
         By/K5kIJvoD2cKM7AoG72s9tjoGHLnMbES8Yn7kI6zJi5j12mjNMTIqNEwR4gc8FucoH
         gHCkzngksbDjiD7hAag6IlBho+aon+X/D5dAA0VDOrCiYpCC1lOiGVlh2jctdCPlQM3X
         WzlHucdwde857LC5XBwZ+4IsjMgg7ZOu2WFodBjzKXYqvv6Dlut7INZEH0F4zG60WGT4
         E62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761955729; x=1762560529;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tqXAJAEFd904kI53cyI6EmfD14ywqnwjSyxvJFGdSTo=;
        b=D6xHCu6RNXtxmqM6ssx4lPEikQTQXzO0xBqWpmhxksxztvBZIkOTfROKCHA8GOF1EN
         7jYV1CHn/qJLiyz6JjCrTOI5ZJNAtzi2ZNAKc/mhnCRVT5Pq5VROegV1Xc+tcxH7Tiyx
         G5XKk7YApJUBukpzgyHIdtjWlsYFTtgRZvxitrds+57rjeBaydUBL9YUdchxyVgVKgOu
         Qx0mhyQ47oNhrbj1gLt3Iu0WewApxLKPJ22DgjdMEYVGEs4Ky2cUgAlt4m2v8MkcSkKQ
         +B5PFtqhjsSCMIycySe7d8iSxJgTOXhS5NTvR1OqXyh1ckEmZj5s9Dz/CyfSm7zGSiAY
         Y97A==
X-Forwarded-Encrypted: i=1; AJvYcCW+K0O7OlTKaB+GzYwTEkqAFjLDKyvberkKIRVWhkAPS9FPd2HpCFLn85L2OYMIbo4RT3Guvj3aMA==@kvack.org
X-Gm-Message-State: AOJu0Yz22MGR27x31BkZTw+6pMKsDRA6t/X/DhKJiYoUalVvCNlKNyqH
	yOSJf9QnK33onWUEWdzUEpZZHH3AlIRsKvUI3W3rDR+I/skSB6rb95FK
X-Gm-Gg: ASbGncvmPApdsx/gZ183rqDVoiFm/+o2VYOcO1cqAmD2hPS4q6Y8cN7uASHkJtj6qim
	MyqbF7BXUbX4RATQmlR/h39mrwVI0Ghnxj1ImVxNOvfEV1QoOJG+RgPuhtTQTXbdT0jzDw0oeZl
	EFDegImRpsrSLKOjLlsjUUP9f6IzERWh+CZLa66mzd0pZdp6STIl0fRbLJRaj3HwfsUmGNOfsHl
	ZToX1tLD/k9UvPxkZDaYFTFnPQWrt2Jj903m+KOzb5aPbAmBOIqaQT4MEV6a5M3uD/LSHSVJKqc
	h039f95UaO1I2uGEIgf+W8araeJeP5n9zAJTVj+hT33Gbs8dve5ihPoFF1GTo7cbVIPnMWymDcK
	EKm0rGR94bm2ZfR55Nr/yictgrAfFRU52+P21+oP8Qw7yc7y98/CO2yYulm47mplBnFjKiDXPl9
	4gb/Up/miahA==
X-Google-Smtp-Source: AGHT+IEwMGMxJ1HbzA7e85hEVqx/WAPxKz46lBfAPL00PToE30wxaTZd53z+QG8i0UJAYghIe/jUag==
X-Received: by 2002:a17:907:608d:b0:b40:b54d:e687 with SMTP id a640c23a62f3a-b70706271c3mr339730266b.47.1761955728728;
        Fri, 31 Oct 2025 17:08:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077976075sm308313966b.3.2025.10.31.17.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 17:08:48 -0700 (PDT)
Date: Sat, 1 Nov 2025 00:08:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>,
	linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Message-ID: <20251101000847.3ht26lmiug6aznsh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251031162001.670503-1-ziy@nvidia.com>
 <20251031162001.670503-4-ziy@nvidia.com>
 <20251031233610.ftpqyeosb4cedwtp@master>
 <BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71CF5A0006
X-Stat-Signature: cr7n43u5k7zgobebpmr9h8pwp7358tuk
X-HE-Tag: 1761955730-681116
X-HE-Meta: U2FsdGVkX1+OETuk7VqfCejQVHFCIPSEy8B+rHcnGmOV3CP3grxgRPCMhai3ZpXUWZC7oR58p/XHk4Wk/OSjKe8jcxgszPZ4Owx+n/2dLLv5VJASiGRtBd6OYd8yQMmQn61uWS2O1QLtBK/ymF3Pl4t8btRZKuI+kxK4a4W4BvxQzrcP6spbLIhoxpWrA1k/5dw06YI52qo9/exlwcngE9y1ilG0qw4UCz9Q0CDIkQMuocfW/ud6zpPwI+GKE5Aqerx1FbvoZXAdOTfCpQxFKHIDMb/P5G8fnCet0HlDPEfueJdmzcRGztjARwmlX80CFtU0ayxWrao+VxkiJLBztSbDi+WtfC6NAdtfxpFh+t2mHwY8gUfsXnHV60GP9ZwgWD++/glnoyQo9ORlzk7f9HEx5zCA90de1+1PdF/YyyLtYGNqHTcWr7lieWxC3GL7k3wqgpYjshZ45iGG/nuQIA8aKwQzgY6SMp+eXKcs+uQ4Jo7bRe2ron182NETRUVu0srYZ2NIQt3YWaWxBNE2aygaYeFeNcqbTpRjf4DJ9cJpr9daWaH5jqjjjegmem3pAr+vaPPh9vPyUnvwnr+XOZzGIIHmDbmEKNlzF2DPnWJQrZirgkm8ygTr2MTRJyorCxBhoAUK9wnwgQyDFhSNMPh/DvBDiMMmYX7mEjwTlJNB/rsI5wqhs4UiXU/HY3ZeBFZsf8+DQUXAS5CvdFsncnMsZqey2C+/FeV0r1iQh22MzVGcb/pUg06jAx84yHdIKZmTSKDhSjaXAcB2oZ2QFK+uBGxOwTKRweinKAQiqQG9sNkf0SkeutSPE+wAeHvltXGHa1NbX7oXgCfe68n2Lih0qyk8GWBNH2GtOJ6cEy5gzKD2jHXuOVOoFFSII+8NyLciqRT2mv2IqAkPlLv/6GFmzO84/07Asi8xFEJbpNObrHl+OvSF26HcCcKex2o5E0rPf/hRFjejsQWWLho
 TdYmJzef
 73iWtXRsBoMD7clTiT8bfBlBRy8wreZ764cHWnCv2wfWca3U5saILegeBPrqeoWc1FS+2N449T0BMAjw6d0F9CmWedjWN8sT3CvJ5iFbWRMlVtpFq+ZO8dtwOF4Cb6SD7mhk8ABoPlLWCQfuawifbPSh4J41w6QEfelfFO/fvazNfSXUZ1O5vgmTJNGzifGPxxhMIzVKgZR4MVmvbzPaQchK0MBr/xDoE9o53f3iPPcCGt7MM0zwS9K+BwPK3nNZBkEnaDgy3/jwiZK4D8a1CjKTdBmDX0sYZPSakKAVySV7+LKH5tKvGo7+NvT0WQrpL69jKFdl2d+3UfhFjCgMPWVbmv0IWOgpSa50fdSMxq8C7BLsAwJAog++vDT51YIlqsXANHru5wGDSjYYr92r9nHaoxZ2ETkgRt2ZTjE8u8/ScOT5oWE6YIrOYvp90Ik1onVMaqMCgQwqGEnLKksXVic282tTLmwmMm5Fp8u27Kvlj5SAEQNTIDBVLR+BUoFQuXxvvBs3RO6PytgfC70DhZQl9XaQq5p7Kp7M1h+Uyo9EdQlyKgZ4J+/lCLZElNC6MftjndN6j/NOZr1HI4/lr78w1fM8JTGtys3TaTkIndJfAIh06u7Z4pq3/jkQXiaxGk89aghPZTgwk9VC1NVujUa2hPR2K4ntIYgxPmRqZ24Gy5A5O8vmDgBFjU+cjn7fzuz3UmU6e3vIQzpKaogj1Zp+0NTZblNmpY70E2PgagqZSgSfyHkxwlQG7L6bygioLcUqOnzTVC5wrALc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 07:52:28PM -0400, Zi Yan wrote:
>On 31 Oct 2025, at 19:36, Wei Yang wrote:
>
>> On Fri, Oct 31, 2025 at 12:20:01PM -0400, Zi Yan wrote:
>> [...]
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 0e24bb7e90d0..ad2fc52651a6 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>> 		ClearPageCompound(&folio->page);
>>> }
>>>
>>> -/*
>>> - * It splits an unmapped @folio to lower order smaller folios in two ways.
>>> +/**
>>> + * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
>>> + * two ways: uniform split or non-uniform split.
>>>  * @folio: the to-be-split folio
>>>  * @new_order: the smallest order of the after split folios (since buddy
>>>  *             allocator like split generates folios with orders from @folio's
>>> @@ -3589,22 +3590,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>  *    uniform_split is false.
>>>  *
>>>  * The high level flow for these two methods are:
>>> - * 1. uniform split: a single __split_folio_to_order() is called to split the
>>> - *    @folio into @new_order, then we traverse all the resulting folios one by
>>> - *    one in PFN ascending order and perform stats, unfreeze, adding to list,
>>> - *    and file mapping index operations.
>>> - * 2. non-uniform split: in general, folio_order - @new_order calls to
>>> - *    __split_folio_to_order() are made in a for loop to split the @folio
>>> - *    to one lower order at a time. The resulting small folios are processed
>>> - *    like what is done during the traversal in 1, except the one containing
>>> - *    @page, which is split in next for loop.
>>> + * 1. uniform split: @xas is split with no expectation of failure and a single
>>> + *    __split_folio_to_order() is called to split the @folio into @new_order
>>> + *    along with stats update.
>>> + * 2. non-uniform split: folio_order - @new_order calls to
>>> + *    __split_folio_to_order() are expected to be made in a for loop to split
>>> + *    the @folio to one lower order at a time. The folio containing @page is
>>
>> Hope it is not annoying.
>>
>> The parameter's name is @split_at, maybe we misuse it?
>>
>> s/containing @page/containing @split_at/
>>
>>> + *    split in each iteration. @xas is split into half in each iteration and
>>> + *    can fail. A failed @xas split leaves split folios as is without merging
>>> + *    them back.
>>>  *
>>>  * After splitting, the caller's folio reference will be transferred to the
>>>  * folio containing @page. The caller needs to unlock and/or free after-split
>>
>> The same above.
>>
>> And probably there is another one in above this comment(not shown here).
>
>Hi Andrew,
>
>Do you mind applying this fixup to address Wei's concerns?
>
>Thanks.
>
>From e1894a4e7ac95bdfe333cf5bee567f0ff90ddf5d Mon Sep 17 00:00:00 2001
>From: Zi Yan <ziy@nvidia.com>
>Date: Fri, 31 Oct 2025 19:50:55 -0400
>Subject: [PATCH] mm/huge_memory: kernel-doc fixup
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index ad2fc52651a6..a30fee2001b5 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3586,7 +3586,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  *    uniform_split is true.
>  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
>  *    half and one of the half (containing the given page) is split into half
>- *    until the given @page's order becomes @new_order. This is done when
>+ *    until the given @folio's order becomes @new_order. This is done when
>  *    uniform_split is false.
>  *
>  * The high level flow for these two methods are:
>@@ -3595,14 +3595,14 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  *    along with stats update.
>  * 2. non-uniform split: folio_order - @new_order calls to
>  *    __split_folio_to_order() are expected to be made in a for loop to split
>- *    the @folio to one lower order at a time. The folio containing @page is
>- *    split in each iteration. @xas is split into half in each iteration and
>+ *    the @folio to one lower order at a time. The folio containing @split_at
>+ *    is split in each iteration. @xas is split into half in each iteration and
>  *    can fail. A failed @xas split leaves split folios as is without merging
>  *    them back.
>  *
>  * After splitting, the caller's folio reference will be transferred to the
>- * folio containing @page. The caller needs to unlock and/or free after-split
>- * folios if necessary.
>+ * folio containing @split_at. The caller needs to unlock and/or free
>+ * after-split folios if necessary.
>  *
>  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
>  * split but not to @new_order, the caller needs to check)
>-- 
>2.51.0
>
>

Thanks.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

