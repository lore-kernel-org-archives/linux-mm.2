Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B947CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB7C6B027F; Wed, 27 Aug 2025 07:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C935B6B0280; Wed, 27 Aug 2025 07:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81EC6B0281; Wed, 27 Aug 2025 07:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A56E86B027F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:51:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24037BA483
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:51:23 +0000 (UTC)
X-FDA: 83822372046.19.C805A3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B560140014
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:51:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAXy15HG;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kj+WQqNx6mfeEUrQ2egTOZFN5drPRSU994Gb6Ia13Mw=;
	b=Na4dlEgFyTuqhABVEdpRzBTYo23oNTZMBaEj4ztmTqWHVwmRP9c+mjLiR8IHp5ynPLW+dI
	Ae4udpl97FsBeDZqFT6xKt6/JWZzowaFx9ka81njonSleUFOHfWj8cgK+hGWgd2MIgE7FV
	GAcZfy9ASFGJFW0G575q0zeRzApnovQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295480; a=rsa-sha256;
	cv=none;
	b=Wjry58iJPGyDrN3UOV6PivS4V90z1y97QNXCx4TSdbi4NKV/rAKp66krUHmp/YXlfn9kIl
	RD7ng/HZC+nQFO9wtUZYpT0ilhfk2kBtR4IhO8R3x4KfXszNpqMOXWsZJljrb7v4pv3U3w
	+4LksydKRa0olIdT+LTEdCQwJfWVP+4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAXy15HG;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756295479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Kj+WQqNx6mfeEUrQ2egTOZFN5drPRSU994Gb6Ia13Mw=;
	b=MAXy15HG3gUkj7W1p/nCk0OtFwU6oyf6Y5p8+KkxUty6LZzvqzVW2hil0BcKASwkPKaw0K
	Z0df1BJTJHAUEfodRFO9SAkp2N/BI+85xmekvQuTAIU9mDlOSJ0Z++NM8sVD5zjBmJ9I0c
	gizvopzsxQ+N/JYbKhYybE+zURDrzmY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-zxM8z_T4Nfqef9n_3SQ4Yw-1; Wed, 27 Aug 2025 07:51:18 -0400
X-MC-Unique: zxM8z_T4Nfqef9n_3SQ4Yw-1
X-Mimecast-MFC-AGG-ID: zxM8z_T4Nfqef9n_3SQ4Yw_1756295478
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e86f8f27e1so215976485a.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756295478; x=1756900278;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kj+WQqNx6mfeEUrQ2egTOZFN5drPRSU994Gb6Ia13Mw=;
        b=W5muRHbuydaLPcCeHYjbuhdNS1FpeyIN8a+lV0d3i0eZuDIQRox94K2/DxiP+VKzFW
         egQwDgHXNC15EuXCst+WnZQC5lImj64ZE1YaKKtzXHs3pgy5AObJN3R2eaaUVGjxss6n
         PiD7nFmC0QY5gY5uacU6CdXBgK3e108b1xW1FImzdj0A9FjudQK/vPM+8o4tv8JRx/QV
         A5aPY4kCNA1TnHyIzUIfrlqfWdlfbiapxiegsBH1Igbs9L9h0bIBhLGHJb06K0UYSbtQ
         LsJ6TR6aUzsmk8AW8t6Bn/QJX6OoMed6bu9Ad5kIzkjgy3Dy+DJsUwtwAbECrHZeovXB
         LlIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIdIBI3cjz29StxpZRWnhM8r4Yvnzb9yi6RoqyoPEjT8VlYVimpEsfgmm4U/siKswv6ioEyIObJw==@kvack.org
X-Gm-Message-State: AOJu0Yzappp8zLMWGu0yOOJICPTRnnmsdSZASHcZzUJXBLfqg5c/mTe2
	5I+tMB5xE3eBtRBTfK4Ig6Shf9fB1N4Hvaowg8qdeIOH2wuaZh704i1TAvlxiBfGrkgDuF9M6TL
	ifmxPTcbM1hAWd0zFtipz6lVRvV3yKtC8wNgoRNnCmCqobC/6+lRB
X-Gm-Gg: ASbGncvMO0CydNoabDZM/UnKrWGOCEcnb9qT5gRWs5NXHw2oCZjbulLgTHnBGUTVwUu
	bffxKnn7KDau9yOQ8CFK9HO4+fxFf9Fg5md2ofyXZSgUqm65DQHs3ep9P14oNyagAfXMSE/w2HC
	rpyGHi/JXB+AevuYwcjDlRUSk106IOrPDIB2Mod2ObHOzPL7i6co5AznvR8tzGTtJa12py5RWvy
	6pRHbh3UFrmNA//AdcBvFanchC1qceXumngS1GPMhCu70j/YYPVcpZnLwFEzhvQ/If22rSO9RfX
	YeVQ9ScSoiriebZbWyIYrlVPVpU2T3qvadBdlFFnG79/lXJYDAze/xJQvbgjag==
X-Received: by 2002:a05:620a:3885:b0:7f6:9f86:4e76 with SMTP id af79cd13be357-7f69f865039mr312099485a.23.1756295478098;
        Wed, 27 Aug 2025 04:51:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVmBzDtfDq10Nt79ue8F/PO01PWq9Aj/sKChiNk7iQU5whHjgTqD35dLozWe6HEX9Zy0TzKw==
X-Received: by 2002:a05:620a:3885:b0:7f6:9f86:4e76 with SMTP id af79cd13be357-7f69f865039mr312096285a.23.1756295477451;
        Wed, 27 Aug 2025 04:51:17 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebecb1825bsm848326885a.10.2025.08.27.04.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:51:17 -0700 (PDT)
Message-ID: <1be63942-f3a8-404f-bf26-cfe7eaf2ef58@redhat.com>
Date: Wed, 27 Aug 2025 13:51:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
To: "Li,Rongqing" <lirongqing@baidu.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "giorgitchankvetadze1997@gmail.com" <giorgitchankvetadze1997@gmail.com>
Cc: "Xu,Wenjie(ACG CCN)" <xuwenjie04@baidu.com>
References: <33c9676b1fda4cbaa42857787e03c7ec@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <33c9676b1fda4cbaa42857787e03c7ec@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HXdlHDanItjehbD-IQ0D_phgmEMkRF_4CVKgegfDou0_1756295478
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8B560140014
X-Stat-Signature: gbaygy6x9d1up1jhfgexoxs5c8u6ow5e
X-Rspam-User: 
X-HE-Tag: 1756295480-663115
X-HE-Meta: U2FsdGVkX1/kPzAmdGCozmPoHOU77e9Fl0BbW3NFa1wdiJF9MZz3j8qEPIyOGLb/wnf+OUI+SPKr6eJA96oSo9uX6wU9X2vMlbid0txNuADCXYTqW+zPfz0qlLNBdmN/fXtibUfKQhechv7GASrK6/iRPfQMBhEuXB8tqhH3oomCnmbGDMq39McwhR8QrIyYe5Nj8HocWZgUsPbqT3iwkueJABr4mw0CktsJkH4dl8RX5rmLMxwnpM56TlNazBTIRyVB8XxrH9cnkftw2zwxzq0+wTjDN94bIjJ4O8scszdXCZOVzvqT93euo7Bi5LylmrLzKLczOQFUhNUUzwrNy4ke+MSZ7B6CdXaqIEmeILOZ3FF4TE3BjZ21xIIii4Qw0Ht5xH6l/4wUl9JfBVOvf/6nJJuFc0yZS1wPUZ4Xg0c/LA7TBPIRV8uoxol0v98gEs65b5f92EvrsWzafA4tEIPuJtqYTK0FyWW5phpjKav7XHffAcU38Lf1UBCDIxWriv2HvhbV2IJebYq4oousLIMAEa0ATTRVyxwhOhJ2ZNZrejP2B4Wt3HIkLSGmkiiaSfjE2M4FzZVIb0tEmG8di9eym7T6Z2vvEH11gs11fksSRtRHhYr90rCuROOO5LVPekD52PrpHsPouSSJESGmNByflWdubZ0ghkekQruIIH/kieyWiY1knY33zY6WNBq2uJLreD9IRpVxTi7oF/t76V+5JRX8wTIN0MnY/Ke4YZcQt+/V5bTTQNMLWf0dUmWtNOGND7hW7nyjipD1U2F9NNfilLelq3Of762Zuoqv7h2lwjrx0Q986xTb0rKfAMcL1cPcT7MzSU0EeNpEWI0zmbRoKsrIe5kvpOQLwoRmpH6c//WtDwfl/CrOMpaz0d3O8oMFyoTp901f3raLrbmfLOaw+ZulZKFRJWL2WacdeVvo6sl9IuDqGTs4OL6//voNnSBvoDoPdz9y8yRBXID
 hz+Bv753
 N1Ig2Ug6fMksQ7sYbtKjNmqV1mXk/zv2fn/NXrY9LgSqPc/fGGd4ZliiCHWaM7heKuE9aH8flATpJz/bZJ7FwN0EhGD+nXHXqeb3+iQutFzlIDthkDLnkAl5loMAiFWtso5cVpHz66OC6qD98CiOT0HOhnvsiuERiIFNJnDDEGs4VFLNrMh0UwYwaYijQ6EraM8+yvax6CXAAiDI2s2kixO2I7qysNq2DqgnUbkSOA4JS8NXcJORgKhln2FuNkPduJA+Hej2llZFLfL7mKevl2MtFy5zn3W25ZVJbPMy9zDLV37IEn/Rxh6sm7bsPL88R3PSipiwbtbyvqE856iTQjSsKZNjCAvi1YEGZgFx+nDRAIYSGnT9mtWloXry7OL8+30WmlWGTW2El0/ounjAiJ81Xfq5HvMBmjSgEJHJ55VsJcKkbVmX0bD+iLbyCqH/dhwsP5ZLhhkmPpAo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 06:12, Li,Rongqing wrote:
> 
> .
>>
>> Also, can't we fail lightly during the first attempt and dynamically decide if we
>> should do a second pase?
>>
> 
> 
> Good idea, like below
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b..425a759 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3589,6 +3589,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
> 
>          unsigned long jiffies_start;
>          unsigned long jiffies_end;
> +       unsigned long remaining;
> 
>          job.thread_fn   = hugetlb_pages_alloc_boot_node;
>          job.start       = 0;
> @@ -3620,6 +3621,18 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
> 
>          jiffies_start = jiffies;
>          padata_do_multithreaded(&job);
> +
> +       if (h->nr_huge_pages != h->max_huge_pages && hugetlb_vmemmap_optimizable(h)) {
> +               remaining = h->max_huge_pages - h->nr_huge_pages;
> +               /* vmemmap optimization can save about 1.6% (4/250) memory */
> +               remaining = min(remaining, (h->nr_huge_pages * 4 / 250));

I don't like hard coding that here.

> +
> +               job.start       = h->nr_huge_pages;
> +               job.size        = remaining;
> +               job.min_chunk   = remaining / hugepage_allocation_threads;
> +               padata_do_multithreaded(&job);
> +       }

Thinking out load, can't we try in a loop until either

a) We allocated all we need

b) We don't make any more progress


Not sure if something like the following could fly:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1f42186a85ea4..dfb4d717b8a02 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3595,8 +3595,6 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
         unsigned long jiffies_end;
  
         job.thread_fn   = hugetlb_pages_alloc_boot_node;
-       job.start       = 0;
-       job.size        = h->max_huge_pages;
  
         /*
          * job.max_threads is 25% of the available cpu threads by default.
@@ -3620,10 +3618,24 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
         }
  
         job.max_threads = hugepage_allocation_threads;
-       job.min_chunk   = h->max_huge_pages / hugepage_allocation_threads;
  
         jiffies_start = jiffies;
-       padata_do_multithreaded(&job);
+       /* TODO: comment why we retry and how it interacts with vmemmap op. */
+       while (h->nr_huge_pages != h->max_huge_pages) {
+               unsigned long remaining = h->max_huge_pages - h->nr_huge_pages;
+
+               job.start       = h->nr_huge_pages;
+               job.size        = remaining;
+               job.min_chunk   = remaining / hugepage_allocation_threads;
+               padata_do_multithreaded(&job);
+
+               if (hugetlb_vmemmap_optimizable(h))
+                       break;
+
+               /* Stop if there is no progress. */
+               if (remaining == h->max_huge_pages - h->nr_huge_pages)
+                       break;
+       }
         jiffies_end = jiffies;
  
         pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",


-- 
Cheers

David / dhildenb


