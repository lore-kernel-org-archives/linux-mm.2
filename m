Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED1FCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D058E0003; Mon, 15 Sep 2025 05:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E2C8E0001; Mon, 15 Sep 2025 05:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A838E0003; Mon, 15 Sep 2025 05:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 734B08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:15:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1484114053B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:15:47 +0000 (UTC)
X-FDA: 83890927134.03.5E446BB
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08BB7180011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:15:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WhbSzH57;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757927745;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNBhVmmY8aQ1GY1rwDVK9tf/36+BZqlM3hO7w9ox7WY=;
	b=iMJ0pHG4Jv2qRo1NIOmfShm0Q3jP7LAu4gBwbrO09L/HLa4OxBerGY2J2pFXO6Evjl24FM
	qy1/Axgd5EgvZjpF/av4mFzCM08N8QM7abv4exVQ+Rc2UkKKHSD/iRZYURrp9kk58HNGUz
	5qCha6DgpmVEy/YdeB4hdEeO1eKg5VM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757927745; a=rsa-sha256;
	cv=none;
	b=yo79KK+72CCVZ1scmylJdeXJ62OvtaxGN58UNKVKw7zS63Q4y9nccK2DkNBySFqMnZvt2b
	8hzYznYMMxyKYIIvAVHK3fqOIJI1IACvnN4fn9irWc64A8omXVP6gUmJ1UgGIRbeMv6GRR
	HQl3zrGc0E29CxJ2CfD/0HDQOVdhHmE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WhbSzH57;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b0787fdb137so575614266b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757927743; x=1758532543; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNBhVmmY8aQ1GY1rwDVK9tf/36+BZqlM3hO7w9ox7WY=;
        b=WhbSzH57FWGcSPnBLJEotPoWdFMBl/pwlp0xUnc37fBONrhsjKci/CNUSs57fnZLAE
         QKwV6ejV7eBJlAHelm74AS7edzfUdLlohyxzD2Ar+xEVerV5c0NXamZXUBuDzwvbcnGo
         /itp7Qs90Pj/kRbrUhb1mPtgcNfSpxaZLNqmN9GIR0ltA+MyjOQ6vLPpXcrZl7qZGhsP
         91WGmMyb4Ydq4jO5PFD71fKi571q4fxAE4xvXrQlNamVlrh6Hk6luJ8KUPv9vLRv5hPd
         WbMaxeFSWqBAZpkowv/dH2CXkestoNAQAX99dK6Eousj85uXYfG+5726nMO2kuyOnmQs
         4heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757927743; x=1758532543;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SNBhVmmY8aQ1GY1rwDVK9tf/36+BZqlM3hO7w9ox7WY=;
        b=S5qzYhzOTjJ1qvsHwPL7ONfzdpTESfD5r2c859sddlMpX//vKUpkt6oZJ1cnIypMA2
         PoUYkw+rAjAgzrFHXeaskfMrcOy0KVWH45cFtRxpETtFJhDWH4RXEv9vDLJlyvi8gDzG
         ykTd4uiPNf4dIrhHSKriEwdze5Wvx4rkTrdk7XB5FQ9YCTSdDli3sZyL3L6dTaGgEUtc
         IJQ7ibuQUpnEaDxBcQdanFpUxA99V6CVJAZF4KmwTUcq3Z+cC5WOj9xp77lXU3qzXbeh
         CUcpyH3JXJtbh1APH2Fvh3yRzl79dgJ+CxNByW5M2yk/lXMkh9yn+2gK/jofoajO6jZP
         nOOA==
X-Forwarded-Encrypted: i=1; AJvYcCXVLrG8EYynbOclH00hkQQ3ijEFxrym7OGnVsLbnkWIHH8nQyPxZLLxXg9F7ZwkIoYvqgmTfecu3w==@kvack.org
X-Gm-Message-State: AOJu0YwBA2EX6kyoK5gFx+YcHKUf3dtdexk57fXHVZVnZCfF6HtCQgd9
	ZH5WGhCA8Mo1wJWbjvggP2Wpf7xMg4f46px9XKYXjBCyHHNJrFUtjXxm
X-Gm-Gg: ASbGnctKCKrOA8sTthNW9zNBnM8xP7RxB/eggUAHYiX1JS0nqJ0m1l1EvSx7VPSoaQV
	yJK/kgo2m5hns35v49sw5s9NL+dyL+L45z5cVwge/7r0Eo563HqME0gEM8cWCrvEixwgwSktdAl
	sp572bE/BV+qRKUGuWfdEEZXcZICOArljBo2uuVVhMplNYVy42Yi9RklPSh4ArbFXcH8b1z9Yf4
	WkguJmXUAydK5dIKhfBuYu6ySMyTbYz+D6OWNNvL3gVJvenhBnPHti/T6pZ0yDUFyqX/RLNnY+2
	xFqs0QnYucZYQUYADH3bM+GjzKpUnrzm0x5s0m9TtYMqIgyVcIEs3XG9LH5r59GALVuU8JCx3kN
	xjFnfGRzSNwJ/8D2PhRs8tg==
X-Google-Smtp-Source: AGHT+IGLyeoKNX+9VefqtGqCNVYou3ZfdBoX7cF7DDZ1lPuEcbaS8UX7ov8yZtcDA80IR5/EJ1hu7w==
X-Received: by 2002:a17:907:3fa1:b0:b04:5200:5ebe with SMTP id a640c23a62f3a-b07c396d4b9mr1302828366b.54.1757927743153;
        Mon, 15 Sep 2025 02:15:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b30da27esm922725366b.6.2025.09.15.02.15.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 02:15:42 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:15:42 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, npache@redhat.com, ryan.roberts@arm.com,
	xu.xin16@zte.com.cn, baohua@kernel.org, Liam.Howlett@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915091542.gqqfdodrr6ztm3oh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 8s5ihhzad9homwdygbn6b4t53ambxrc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 08BB7180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1757927744-748778
X-HE-Meta: U2FsdGVkX197vFHmi+4xvbpSLyzLgxi5pc+2XBjsbuY569taxQCR7h5xa9HPiBEycpuhQQbR0Lmv7sF4QW47bq9i2SAJOXi2OkCY3l8yBJJ4DsRPAMNS6B+AyVBLwQoh/8QPhaRsrLlhcRnoWOtGUsPvcXixUSg5TmcTsb+IpWBnVY/IqkceAmMkBZKkBo9II234J+qPPmXj1PYAxmgbhBZ4qWbmcPdgSEJgAz28DyQFvXB6Gs82o68/cmlfNrVJ+QzCxPTMz2me72/PL01L8nRyw66+NPFkUDAsf89AEG+nTMY7AOY1VbgFCozQNgZ+POPI5E3oFbBG85vCAAUuGr0v9WZUwgWM0KEQIVsUPYp7yb3sKlleg1db8rHSl3ld3Hz3jRkso6PhHZbQmN0YTeDkczO7m1BqAiVacpNcT5I68Mo+U/Mree7Klb7LvSvkR6jKN5/MIXrjhAjduQeE2XRtsP87ErZfUAJL+9sY+rWBXHQEofQbATJu3HLRHtGzCalLtbbUQLtcmLj9VbJxPe66cCXAXSXx4isJBRK2+Fmp2hFY+bRg+1vuDrlqQ6p7hG4Ceoe23P01cgGkwira29MYzPV88GLwW6L/sXEW6PMlHEBpXY1DQ/CCVe543DMpEI6z/v8QNZZHW6dFP6RWBi1xYf/jXsIULCjuoFmpQJUopm6LA+1mMLzPlPk4BRqfUC5DXcAcAdXzFNhpOJJn7mDtyIxSXUXQidSUeO26pKF1ARQSDmgA0h5z9vQQfSrPa+8Sx+OTks8jvMys01x6t/UtQNCbxzj1wf4MpK6BFBOu1eDptlw7j9sAiyaOT3WHMSRkkiiD8mQT8b7yrUeJj5Bp4T44WfVNfK2XX49olRpm6XtkkQbt/yC4b5+qNDkwXHENZzOl86HWRCRHlCV2/j3Sk2TOLBh3kcpfQTGuUWqF2cEsJ5D2L0u00PpHK0pchVJDXUM30UEsU/dj4XA
 qFw0LdOY
 pxPxrI0s7NOU+C8xgopSb5pcHi5qCDzz9SaNqigaSjTRl7W87cU9xSQ/9t6/DxylUqirko0ghHmHmfMmnkxJnucd7f2qcTCweppIvhLekhUbvzxHGZHWWUoGZHTEZaMxXNFIIRyGGwQ46dyv23P3bhk2LgWzVCiMxWWukcJjvOxhTw4dGej2Ve6NgTN6vmIs4s1PBiM49CqyNsIbqw2BywG255VAoDaSnqttrdxxIECgYc+x2Np9LncdOmYogR+P18m4Lv7Wg55jXHSivJsjxLqcGDA5qAaZapeJWzWgkORrGXubN65W0WfP4yqkC8boj0GAZDGZTKBDhe6ShNrkXfnfmvsbNIpyTHkYvuzBTf62Fm/A0QPsUciw9ATT55KRIKNhufIf4jUC7qCJ2CA30119C1SXzCEE2F0okSVyi/GkAqtMMJyLRard2vtydRU3l1TrfRDu9NzLGuWuoNAOUc6uB9tY9HrqnjXrG/tf1ISefymWtXwMIq8WQeKgMwmlJ9lxPG9nnSvafoP/TTFm01H5b1t4OssqxwoWZ/AICgxvHM6Ds738mzyy5vVE/uGmdbIyhn+10OPlFBBZAPzzN9UL6pWSWqrPBkJse8jAyMwC56zh2abiE0fvTXgTZFCxOwk4IMSiZse4jaP05/MzXdOfHv/nZ1ZU6exzduRkQdJyJn1M4j/E9imscQzq4j8+EJO4TViV2uvane1xcKcnAuOgtj+kY7p4O46TkWZXUxN53yYYD9I6iH1DPyAPAOAaadTN+6CpRpNhVcNCuT6QzriPBdzkGsXz2EDHCAkabyZIH/Y7BBkCZ0FbjFJO/ffmVgfHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:56:34AM +0200, David Hildenbrand wrote:
[...]
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6b40bdfd224c3..70a32d59d7d2f 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
>        spin_lock(&khugepaged_mm_lock);
>        slot = mm_slot_lookup(mm_slots_hash, mm);
>-       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>-       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>-               hash_del(&slot->hash);
>-               list_del(&slot->mm_node);
>-               free = 1;
>+       if (slot) {
>+               mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>+               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>+                       hash_del(&slot->hash);
>+                       list_del(&slot->mm_node);
>+                       free = 1;
>+               }
>        }

But... to be honest, for khugepaged_mm_slot, I'd prefer to remove the
definition of it. struct khugepaged_mm_slot just wrap struct mm_slot.

One un-convenient thing of this change is we cant use KMEM_CACHE() to define
the slab allocator. Have to convert to the old api.

-- 
Wei Yang
Help you, Help me

