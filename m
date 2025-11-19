Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B8BCF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB536B0010; Wed, 19 Nov 2025 08:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D29E6B008A; Wed, 19 Nov 2025 08:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8A36B00B6; Wed, 19 Nov 2025 08:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0964B6B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:14:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8CBC59112
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:14:36 +0000 (UTC)
X-FDA: 84127400952.21.EE556A5
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id D303B18000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:14:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MgkGfwr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558073; a=rsa-sha256;
	cv=none;
	b=6/OWWxicDpzV/clgd9rviU5V3myazPxVXlcBEjNlgG4do9iOqAz9VGLl5m1kRrKh/pMfMl
	GSHu3l48RPBP6COhEuvUYe+AF5ifVlA1TaXZpy+79VejBumCiYZ+ZJaV12bDOU1yckufRe
	XP1VJ+AjUEwusmVFa79bDQJKVww/zzg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MgkGfwr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558073;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRF+ue/Id9ldgZPTyrJqrSqz6d2mMp+yZHF4xezoixc=;
	b=wyy0VgNSDYj4kVhB3w/yKQmqQjfrIrnPl3FvMT+2CUfAtODorIxkJtpx4ZtBhn4c8TCu2i
	1LfgrxqifbSP3+UKjj4//BaRwii4SyrRdasPYtixi5euk8G9EsrwHqVXOGFz94WHD8/P10
	rTfGvTfnlwkSjJyYGs6AQ+Uoy4DuBK0=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso1391576a12.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763558072; x=1764162872; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRF+ue/Id9ldgZPTyrJqrSqz6d2mMp+yZHF4xezoixc=;
        b=MgkGfwr5uYkEbuiFMoSYX6VJlT6JFYKkBdxwTXYSQgyzyTbRAmrUZOXoJK7HkZ1LZL
         9MhzycJJ1gAMfkGw3SS7XucmCTEHTCdanmVAV2x72XWLo/Zps43mv49NCIRe9UAoS9nK
         sVeIUBFvoPhLllLnqR216OBPfgwQdp7WzljTrhzeWOg9fbfVK0l4YE67EHmrKAxVCg/0
         zVA1lVMKefxKmkTUITRiF3vyoyob/FkmsGiSUk7gqSM/UE33Jkd0hDnNjcIvdXPo+NXE
         xbJjJHdpagffTePUha+vruUv2LCCXsncm1PCwPBeKvrigiHCxhJo/YfZep6eVS8+Fudc
         KWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763558072; x=1764162872;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRF+ue/Id9ldgZPTyrJqrSqz6d2mMp+yZHF4xezoixc=;
        b=A++2EpGwzdpBMCAYxxvOIg3ZOCV3/b6svQofjSv7i+++wj2qT1vVel6+hRxRfrxy8N
         opami5fo5oUqr442gYE+3U1Zn7OTSEMLaOKVImoazqsaYjZ6Eg+GVRKguOHZico99atZ
         H7FAcOIt7Iq7O4aXrT0rvWGc6Y/Z1Bbmr9sl8OWwEPKPHRfZ+bMQ0/Fhh9nvqWFV9hgy
         2x6+ACHbL0cbtn2cwlJpwTrT6SARfE/66jUBAXx019wMhEMl8vRad27x2QfdA3qTwWUI
         hKuCmAeDobu7m4y+vdYwCZbbVyqgHIJcwtsIj5p2SGTvNUc14M0BlXogQRswEzB5Rs3f
         WgWg==
X-Forwarded-Encrypted: i=1; AJvYcCWJwueZ4XtEQijJMGok6NydgIAn86wks566SNIe0F5qvTsbeRS7wxIhrd1/n9Vc+inHhzDn8UwaQQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl/2dcKc+1C/oLJHMB3lwJ8GFwfcTiQwiFGLnb2BCOBNBLlv1H
	6IT6gfXNnmtC/1mHEuFXhQV+CXmMhjTz+83F/Mxx007a0hkMlQ6+pPcS
X-Gm-Gg: ASbGnctXlfMx14eGPic2UKc7pSK79aXzUXa9Wc/cPwm7P04mXdrPNlFi8VQUH/WuL1k
	C05h86xZ97Cqe0kPbhQbVVNClKvQEWEViYpjOyhB/orIhReVmMelK48CyhZStRt+Qyg+uG0zTNJ
	6SAZ8OD6clt77S+c+HlfwE/WWtIHZ/rZtrStifNJssRddodSl94YCXx7+x8gRIasM/1g1LkfAdc
	Q9noTEXCl8FKevgX78RqHjM6WEILi3FYnwomIHtO+UxYmgb/n28c3TNQ3JBoYKczaA52YVq2n5i
	8aLzZIgdXA+L5bbVoy3c4Y6FSvBj7eucpnOUnrrl9FVePcRzMW3bRxa1CW1o2nDtBkXE2XblI6a
	tr1KC5p3wRoXHcW9hYueFVkLAnKF9j1vlPBrJyMRls2s97IOl9veAYyGZR72VMyTtYnRDJik7+s
	s97dB8UDqRmNXiERZ5m5gC3FCu
X-Google-Smtp-Source: AGHT+IE4FtaAmTPc8nlPuMZkbBbMHwWd3hGOnt5zgEOovXAqLkOxf/D6wSnvJsL5jecKKropYCT3DA==
X-Received: by 2002:a17:907:7e9d:b0:b72:84bd:88f3 with SMTP id a640c23a62f3a-b7638d4b9bfmr251787466b.11.1763558071974;
        Wed, 19 Nov 2025 05:14:31 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fed80f0sm1624937366b.66.2025.11.19.05.14.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 05:14:31 -0800 (PST)
Date: Wed, 19 Nov 2025 13:14:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119131431.gzr77o24cnnt3o34@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D303B18000F
X-Stat-Signature: mmgpfyh6sa1o4yg865tepqhsrtn5tp98
X-Rspam-User: 
X-HE-Tag: 1763558073-820425
X-HE-Meta: U2FsdGVkX19hTvUp7ENjdm9kLclWFmkf0dMzOlhSNPxVIXZ3KCxUDSB7L0gShGUFenSWqEOegQq1BaHNLpgHA35uAbhyME6H/vlV2NhrrOn7Q/ZYGQdCDj+TUTZRVrWZmEm103YkpbwKmeNQygQazu661sKribPB8+PCM5y1Axh/QRea5cw2xvfX9jxjcVb8MGMYPq2YOFZC3HyczS5NqgQU+B8fYuqd3UA/Dy7K9YkKzj4dV8EHlJM5u03nwujADSbfjHYvvsZR0Qpq+/H7gLiZnqS77w+od9O4sawoP+KKNLXgcIGZ9lJNYNVBk3bh95Q+KdT7WT9VBFbxty8Ko9VedCBoaFQhm/R3WWRxxUDuU747U0dDg9qmt+V4G/VwHngxmHKQ+K+mtL8R+fKiVcGrZrfgvzjg+0MYCD3bGyrc2GE6a/dDkpuUGY2jTfSdsUJDbtpS7oGaPY3SWZlzpKn/UNGynWw/9pMGnvVKlham3rHUfvdl0P/8qiAYZnRBz5+FYlaL5w/h59RQau+GxABkCaQlRJ+D3ePdMBY4rrjMIlWOSpSUtF8A0qTYWJ25kU4cjAEPdrrIG0195LPmINeIGvy63gtN8CjY/eZev48VW8dUUakXmXQTO5ulrqDpgz/vv9ajIh8xwv77o59OTbyGgLfm0hg2/LJJHpWWCQTcq9YEVziHyaLbhFG2nTL68i4Ydr9oOQo3IfB5isTOKTTBBAI+oub8AkDWnc+y39q5Ne+wjiWhc8UcXQ3pW8RJmWjJ33Jg2Nh34uhWamg9l4QQR5vTSblYT5IudFVpPTwWO7fHl39hvRjhBMhaa9fpFkrFvXkN8KiEIpjVhbG1CTUmgtST+I25x5s1ilieJwlIPG1Pb7CBxRsapSksvZqrl0wrO6riaXM1dTqCvknX/QwijK2pW+qRRyQ9YwXTWSMqDGTsr9DlFpJeNcdYHxj+yiZoZb41UswV0Fk6J2O
 5Jqphp/d
 gSdsQ+vMard+zKweDyMR8UvQZ8zpcxV5O0Bt7mM2HhPQdnJVPKV9MzRbyCoApwU2iz/fDiYt+Uf6nBmMh2qoCXtsoLQxg+ur5OEr0YU6fGVetsjpdK+f4bySMhJ8tbt5LS69Q3NG0ack6rgbgUipfyf5/VFc1AgBl1Mxq/1DRyljlxQNYo7Micljasuh/QxCZG/N18XWgEVMJefi0cieRRT33smkLni2GZwqOmk+5CXg9ZaBQiflpunCU+RjJB6+naSfd2O28xBHb4+7VAAeZUUES/3/EOkMg+9jZa/QH31I9ICMvMC1GN5wJ63KP5YMyu/pc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 01:54:45PM +0100, David Hildenbrand (Red Hat) wrote:
>
>> 
>> > So I think we should try to keep truncation return -EBUSY. For the shmem
>> > case, I think it's ok to return -EINVAL. I guess we can identify such folios
>> > by checking for folio_test_swapcache().
>> > 
>> 
>> Hmm... Don't get how to do this nicely.
>> 
>> Looks we can't do it in folio_split_supported().
>> 
>> Or change folio_split_supported() return error code directly?
>
>
>On upstream, I would do something like the following (untested):
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 2f2a521e5d683..33fc3590867e2 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3524,6 +3524,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>                                "Cannot split to order-1 folio");
>                if (new_order == 1)
>                        return false;
>+       } else if (folio_test_swapcache(folio)) {
>+               /* TODO: support shmem folios that are in the swapcache. */
>+               return false;
>        } else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>            !mapping_large_folio_support(folio->mapping)) {
>                /*
>@@ -3556,6 +3559,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>                                "Cannot split to order-1 folio");
>                if (new_order == 1)
>                        return false;
>+       } else if (folio_test_swapcache(folio)) {
>+               /* TODO: support shmem folios that are in the swapcache. */
>+               return false;
>        } else  if (new_order) {
>                if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>                    !mapping_large_folio_support(folio->mapping)) {
>@@ -3619,6 +3625,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>        if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>                return -EINVAL;
>+       /*
>+        * Folios that just got truncated cannot get split. Signal to the
>+        * caller that there was a race.
>+        *
>+        * TODO: support shmem folios that are in the swapcache.
>+        */
>+       if (!is_anon && !folio->mapping && !folio_test_swapcache(folio))
>+               return -EBUSY;
>+
>        if (new_order >= folio_order(folio))
>                return -EINVAL;
>@@ -3659,17 +3674,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>                gfp_t gfp;
>                mapping = folio->mapping;
>-
>-               /* Truncated ? */
>-               /*
>-                * TODO: add support for large shmem folio in swap cache.
>-                * When shmem is in swap cache, mapping is NULL and
>-                * folio_test_swapcache() is true.
>-                */
>-               if (!mapping) {
>-                       ret = -EBUSY;
>-                       goto out;
>-               }
>+               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>                min_order = mapping_min_folio_order(folio->mapping);
>                if (new_order < min_order) {
>
>
>So rule out the truncated case earlier, leaving only the swapcache check to be handled
>later.
>
>Thoughts?
>

Cleaner, will test this first.

>> 
>> > 
>> > Probably worth mentioning that this was identified by code inspection?
>> > 
>> 
>> Agree.
>> 
>> > > 
>> > > Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > Cc: Zi Yan <ziy@nvidia.com>
>> > > Cc: <stable@vger.kernel.org>
>> > 
>> > Hmm, what would this patch look like when based on current upstream? We'd
>> > likely want to get that upstream asap.
>> > 
>> 
>> This depends whether we want it on top of [1].
>> 
>> Current upstream doesn't have it [1] and need to fix it in two places.
>> 
>> Andrew mention prefer a fixup version in [2].
>> 
>> [1]: lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
>> [2]: lkml.kernel.org/r/20251118140658.9078de6aab719b2308996387@linux-foundation.org
>
>As we will want to backport this patch, likely we want to have it apply on current master.
>
>Bur Andrew can comment what he prefers in this case of a stable fix.
>

Yep, I will prepare patch both for current master and current mm-new.

And wait for Andrew's order.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

