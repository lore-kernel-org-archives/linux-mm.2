Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3642BD6D229
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859016B0089; Thu, 18 Dec 2025 08:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806136B008A; Thu, 18 Dec 2025 08:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712836B008C; Thu, 18 Dec 2025 08:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 619E96B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:55:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBBDA86E54
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:55:04 +0000 (UTC)
X-FDA: 84232738128.25.7EDA160
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF931C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:55:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jweA2bq1;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766066103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDnXzSjtYaHM4x40x58+Blau4mKWsjcizNbfaizYC4s=;
	b=Myib0sQtl2WkyfGqc5+XRb7hT+lnFYs6JzbeoAaEcGusWP04iURUzeAhc+RJhFLzwjpzxp
	MubCMgP7muTgquLi6ANIE4HOknTLwi0IP2nHNQVwWIEOa04xZTQ6t8ikskqgQVHqTcxkrB
	n1zqrvH4zqj9WSHUnJZZKTOEe4agiCs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jweA2bq1;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766066103; a=rsa-sha256;
	cv=none;
	b=gvM3CBNwCqGHKjo41Lo857NT+1VoQ4q2mpCiJ8Kgy7OUMQk+7VaNvbOlbTdU2bY8VjGM/g
	R7LKsX0I2zdnTO9X+YXEy8+FSj4KNMzTXP0YVGNQDp0rsXXbUvSy+u5jY3WVkOiiA7hVKp
	nvTtZgCam3ni9wf1mXH5bwaFcERUXXM=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-597c83bb5c2so552322e87.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766066101; x=1766670901; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HDnXzSjtYaHM4x40x58+Blau4mKWsjcizNbfaizYC4s=;
        b=jweA2bq1JzTJ/UCpYKRUC8VSZebuheBHe3UCTYEean8mS/buCEcExEIuaCDzfT9n39
         hUe+35j8vYGxQUc9XFXxRA5MWLHevIWlpfiJc/Mbgj9bfrOfGV/3R6nkIVDdSXHPMHZc
         td5rIntu/FYpKvGdZKOk4pMBlir9+ANmT9V8oEy1LZRuPe0csDmXXT0b/Cp9rmdsyPT8
         IJXy3vbD6bXnBBsmen7lN5TiFeGzhCAIO0WpWshlJimlPnkgnSfrYp5LYeL2dWBT26fY
         bYmDQRbC0af2FLwjxzWUOv7NmtOIALGOHqq1WRtiFzudGXWddl+0UXYZj4O+JEzoWdgp
         yCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766066101; x=1766670901;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDnXzSjtYaHM4x40x58+Blau4mKWsjcizNbfaizYC4s=;
        b=PFUm2lbFPmkFUa5kVOYiKTTEKDFbyBFImEoRyRTaBqnjGRGxqY8phmT/qjYpkE2zHT
         n8T5gFclDTSyCG+qqNZNGA//ZwJcM3O6EKIGVpdUpkuRM8oZQvcgd8hPk7yb2QMgmNvw
         zwOhS5s8+ug9wIaGuT5Jy0GRwYyEYY7dbWgIsQlG0WPGhXdjHuq6Ti4o7gsXuk5LYOt8
         C11m5Uu20ktMUaGVUxoWehIOPIlLdoYPGuBZdSYVsOUczIkhMpoAhNkE51L/wuuoteIq
         A07pcaIPMQ3dcrnEx5k4DW5FEYajVGAlQ+786XwOa7vEbM8gvyVX8hvY3VKfhzwcQ3tB
         5EDw==
X-Forwarded-Encrypted: i=1; AJvYcCXqsQk8mtY5Px3/1T87sTVe2alquRUDhnQV5Paz5LNkKcAxxhzVj/O96kroNT+llZ8EfVESpgVWDQ==@kvack.org
X-Gm-Message-State: AOJu0Yzob5smJkZztkgtUY2jnxEMp5Zi8aEFzbkATtqS8DcqHvu9O83N
	YXRpUg89vzYikCVjmT4pai6+SFNN92TgLA8HzZv2llS9cax5IMHVO/rm
X-Gm-Gg: AY/fxX6tuQ82q54f7vqNfL7ka4wkk0eycYkm3v5fHfe3LgRt5Jg+Y6VF3Yr3dTjoStN
	zJWIECeEFfOfDKwEw2lSgjfTCSiJHAsqFbkpBKZUig7Q8XN4B3I+4BxaZmDV4CVoS8J3W2NzgO0
	+y9/SWodqDcM9KKQ4Fnx1vVcYseKqNk8DB/95UiqBS02zE/orj2uf5bDHtw4L46e8heRGc1MtGI
	flIayXXdCSJUyPtO/BYILLrQZKtF7Iw4GGvWZ7805KTPrLGiCYHnYLWVLrhOLUCoqfBy00woq9F
	DXMzuSNQlp4mxnK10e/mEf5s+YwilOUONWxQtstKAWzMEsPFD3jyfDx4s9rW7cJNdIOT/Irb8wb
	iKCaJYfevS9VlggGN8p3JCHFVYgOGHy/hkio6raRacKjxsO8qrhJn
X-Google-Smtp-Source: AGHT+IFEs/IPmhycLdgTpBPBgGa1eUvj3QCPpB/NO2gh7wKbNs6ilucY3zYK/1hGd6Pg8xIq9YxpJw==
X-Received: by 2002:a05:6512:6783:b0:596:51d0:9373 with SMTP id 2adb3069b0e04-598faa4d58emr5189309e87.24.1766066100616;
        Thu, 18 Dec 2025 05:55:00 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a13506b2dsm1116848e87.95.2025.12.18.05.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:55:00 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 18 Dec 2025 14:54:58 +0100
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Barry Song <21cnbao@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	jstultz@google.com, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
Message-ID: <aUQHss6K8b_esvpw@milan>
References: <20251215053050.11599-1-21cnbao@gmail.com>
 <e7c8478b-1ce4-4a15-a185-de9d9121438c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7c8478b-1ce4-4a15-a185-de9d9121438c@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF931C000B
X-Stat-Signature: x5ugz9ky55bkj76pu6raia3uf7zsnstq
X-Rspam-User: 
X-HE-Tag: 1766066102-628827
X-HE-Meta: U2FsdGVkX18s2ft/7JAenGBPFxjj1gKL3j9ZKpP4O3f3+WFkSsPbT1O3lGDvokN2ORUBIrnTzblFY7gi/pTMJx3ES5UbtCCYBgwn9Rb2ipx343yHCVJTDLLpQKYmvpkAbPiFdOPZV6PqyHQGuwU5zqCl83f+vw41nF9gHPGW6JJ9aUnYZ6UqXIRgO2ymc89P0fywhr3VFHaL1DanmQJMKS5a25Xi7rhvFtAIYp8QXHlwwoIzulx+4yVEtFOvuRjM2HLspXSdxxuoT2nSiCwF6QAj1tBrUNLsbQtwnIo4eNsTvrwB9QgpEM8vIgOSMZygi4UiWgAGIg73y91gGODmqSfpPoMBgxWQ+Ys+UT35VeHs5e4+s4RUruiKNDdrezejlIA6j+fOR3y/x6hw10gB1Enp+w6FDNYTFd1p0SHUNLup1k6bdLeIoT0rejD+nsuh4ZRTQVs2yrM5ldS3HGsbA4KuKUTVlrjwgtNJ9a1BSmFDOW72KM95ZZkPRo8uEWjUKxvaHjM0Mg6Q2W5PTpcTS26AXhEYf0ou6o/YUoU4esx1eOHubp4BUXW8+He7CdXGISKnaOIhqF4H6fdfk2gm2On9HNkGc18q0/gCqCImz41GWaFO75hzG2oBsCOLOhctYUYLPd/CZZ0WQli9uN3vYI7V3xP269Mj0T7jTXXs2aWM0CGLTZpiovGOJe2ZaP2yliyBOguQTdHblY53bYm/SsF4I8pEwNMhy9Wze3A5ympZ3Pk+4a+AV31Y0vILwH8Dt79KEbtLNCNbTs2WEkhuLKTgbSwJKaZyvDYtlB0mzv+OZYwRMDq5wQj5rEIuwb8JkpIVrrhc/GVncxGx26ReyD5yROqWsi0blbgBh3LavjuBWeH4V63zorLmUnR0vt/dnjBvh337S6AkfEx9Jv041kdIppxhRug0Z9Qcg08ake5aqTo8Zf73TKkKFpDp0koU1qwFPUVCdJ+HNUgxcW+
 gN+8v0S4
 YMnqKO+to1MCpUGRLxHcv8Q6i+A2cocQjkeNz7e4ydD5GZ7JpgqyQVt8Caz2ZLBHlm7LYFQwtblMzkeRHTzw3+S2KiLC1//NhI6ASqRXUMVuUKbmk1SQ5M1Ddn93y/tcssAw/645x17Ef8VWgJYWBAN0x6CGoJC+XtvXLfDyS8Chc38Fx8drPthxZUx9tpRibB8XPd+ZGW8WhGIeaM4G3qFtILRCxhlLZTGscgSTA+KWYcf49E6gycRxtm+FRgkVQ+u0hXaCQsw2ykqKC3d3f1RF3YU9+N6KjzpdVrXBSoxNTtiqD4tHQMRHkTqn3BNhpx/q6RH6C4ybxObewU4nP6X31mcRMe8uFspD79Y8qvHORopafw4wMHJMj96Gn0IdwZ/OEmgOdvIm24Wm0B2YUxry1GfQbyuDgoRUj8g0zwy1CgzuZFrDN5fQwNOjL8LPJ75IRPWFhxlgrvJoAs+wvWYode2P0W7GVn9Wd6FM1CEpa46sDuknMZtN3uZuxnlvr2VWb53EWh8IL0lMrOqJ8iymRYrz3rInMTfGdp/BDqb089QrjBFw0JPqgLsJKP7xYTxm+5WHxFCiqy0hPrsMCETDreyDy7NeGDbple6N35zwTke60Qce/F/X3jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:01:56PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 06:30, Barry Song wrote:
> > From: Barry Song <v-songbaohua@oppo.com>
> > 
> > In many cases, the pages passed to vmap() may include high-order
> > pages allocated with __GFP_COMP flags. For example, the systemheap
> > often allocates pages in descending order: order 8, then 4, then 0.
> > Currently, vmap() iterates over every page individually—even pages
> > inside a high-order block are handled one by one.
> > 
> > This patch detects high-order pages and maps them as a single
> > contiguous block whenever possible.
> > 
> > An alternative would be to implement a new API, vmap_sg(), but that
> > change seems to be large in scope.
> > 
> > When vmapping a 128MB dma-buf using the systemheap, this patch
> > makes system_heap_do_vmap() roughly 17× faster.
> > 
> > W/ patch:
> > [   10.404769] system_heap_do_vmap took 2494000 ns
> > [   12.525921] system_heap_do_vmap took 2467008 ns
> > [   14.517348] system_heap_do_vmap took 2471008 ns
> > [   16.593406] system_heap_do_vmap took 2444000 ns
> > [   19.501341] system_heap_do_vmap took 2489008 ns
> > 
> > W/o patch:
> > [    7.413756] system_heap_do_vmap took 42626000 ns
> > [    9.425610] system_heap_do_vmap took 42500992 ns
> > [   11.810898] system_heap_do_vmap took 42215008 ns
> > [   14.336790] system_heap_do_vmap took 42134992 ns
> > [   16.373890] system_heap_do_vmap took 42750000 ns
> > 
> 
> That's quite a speedup.
> 
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Uladzislau Rezki <urezki@gmail.com>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: John Stultz <jstultz@google.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
> > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > ---
> >   * diff with rfc:
> >   Many code refinements based on David's suggestions, thanks!
> >   Refine comment and changelog according to Uladzislau, thanks!
> >   rfc link:
> >   https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/
> > 
> >   mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
> >   1 file changed, 39 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 41dd01e8430c..8d577767a9e5 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >   	return err;
> >   }
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +		unsigned int stride, unsigned int max_steps, unsigned int idx)
> > +{
> > +	int nr_pages = 1;
> 
> unsigned int, maybe
> 
> Why are you initializing nr_pages when you overwrite it below?
> 
> > +
> > +	/*
> > +	 * Currently, batching is only supported in vmap_pages_range
> > +	 * when page_shift == PAGE_SHIFT.
> 
> I don't know the code so realizing how we go from page_shift to stride too
> me a second. Maybe only talk about stride here?
> 
> OTOH, is "stride" really the right terminology?
> 
> we calculate it as
> 
> 	stride = 1U << (page_shift - PAGE_SHIFT);
> 
> page_shift - PAGE_SHIFT should give us an "order". So is this a
> "granularity" in nr_pages?
> 
> Again, I don't know this code, so sorry for the question.
> 
To me "stride" also sounds unclear.

--
Uladzislau Rezki

