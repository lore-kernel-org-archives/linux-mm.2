Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27FDD41D61
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266E06B0007; Thu, 11 Dec 2025 10:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E396B000A; Thu, 11 Dec 2025 10:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134246B0007; Thu, 11 Dec 2025 10:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F42016B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:39:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC892C015A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:39:52 +0000 (UTC)
X-FDA: 84207600624.04.A43562E
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9FB49C0014
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:39:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W6Fy/hiG";
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765467590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSmYvvssQZxozIglSnRrsm1jahIJ+aVIoUH/N2Th3Q8=;
	b=QLsPjJmr0HC42RGQSEXLQpHqFvSifQG4Yjks9SRiNeDoUX4F6veGUj62Q0wUR2DOWPtP6Q
	6WkK80YdTj2v9zBm6nx1ac4cqEElcqU8WwHje8QjXMkqPHD3tsyWEX9XZ8ObTbRhN739sK
	cpZguTmnC/cQRbfS672hUFLM4joXrdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765467590; a=rsa-sha256;
	cv=none;
	b=1q096GAS5twNNMK2nUTcUWN58y1hnIR/zOz0nMjq0ycM/cZOM8Ml1e0vcsM+WXX5b6DuSl
	0go2LzdEb/1NPhcCra7K6OLPURGTDa3xou0fIq2JBqz/dgaJXiVgsb+h29tEaLVgTeltcf
	SrIt8tnz7tpdKPfi0sRAqSTzxeBFGww=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W6Fy/hiG";
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-598eaafa587so260718e87.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765467589; x=1766072389; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zSmYvvssQZxozIglSnRrsm1jahIJ+aVIoUH/N2Th3Q8=;
        b=W6Fy/hiG1qmPcHhX105fotQJF50FFeT8q0FC/rKv8fweX8S0vGMecP2xSNvhQRIM/H
         1kfarR5j7xqDdJjx3i9pm8/Y6vr30idz3iLMzotteIpGRkebTJKVEVNBuypnjrI4NU6m
         MF831c56YRtXSjPTAbc+xKZL2PLDSzNBGcJyibOeIw8kTQCQrrlPZ1+nJBQ3hZM6Mf4l
         0/X4CuDs8aEbW5Q44W84i5VmSx9UyJdGKgCVfuHTE/m/ASbojz8sClmo9JQT3zT3zJdb
         ATr8CZn+S6Fr7zXrZ0rSD0N+SD8YwCM1ptngQSpIUxUGslPjoh3fUlz7o0aJMep3ExWz
         NJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765467589; x=1766072389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSmYvvssQZxozIglSnRrsm1jahIJ+aVIoUH/N2Th3Q8=;
        b=Uq+4oz757UIA4dNjxerW8io3YI1wQOGYGWYExw8ARxCu6fGEScbwvzECTfd59qane+
         KBAHGslJ5mQrJFZtmFcZ7qP71iyO2qyXxUFb1CqJD1hoPT4gE9ZgF6LYetl4sdSo9+rD
         5GMHPVKXinLKfmZboYvi8q0cEKhm+Z5RPnkBw5GMeJBIJlI+lzoBHqy0thlYy9GULIBw
         9JpORMoXYob/bU4iVi0/6B4nDSEzY0aM3fpaJwQM3rsPOQMMfmV1+GVb24jp5PcBR7AL
         5vXkXQgS18yKs+gmlMNxkHlB4dZPVRh4otifdXbp4d21dadTy4n+37wTm+F9qMCA3KOl
         sewA==
X-Forwarded-Encrypted: i=1; AJvYcCU3HRQPms7OgWJHso62xVsK9MvWZQqUUM1VkPnKEDu6jaIidvUE8rYz+jRyQBwNujpGEPQf6XjlZA==@kvack.org
X-Gm-Message-State: AOJu0YzIoJz0zg6X3+OqlvBBL2VFOiPVELir+SxOVtYMaDTBQx7gVKBC
	cNK/koMQ+6JB+b8GNQFhz33tBgFIGCZlE1R+i5G7CJxhChQh+NzH+Jlt
X-Gm-Gg: AY/fxX7FgNQ+3D2iUODyXysxMPGGXkZOrz8VXIvtUcyZ3Aqn4JDHIG+6QcojM+9CdgT
	RC9RiJ5uLbETXE6yKvVWpEmmRSsaogY54xH8YB7Gjn8idb/DJA9wMT4+C7TMFNysgxratvRXPrB
	qxeYSCniAUXQ9mrG16uywqiQZ+aFKVobtId7Tjhy+oO7q41uo1rF+W8oM3p+Oy+jywWGYqLh5Mz
	sBIqv5J/P987FXtJPrqn/CzfY5zvoGRnnfX6ERVeCbDQjiyAsnhRbwjN3lV6sZ2WL0GKtf1iz7K
	BjY4lGyk7jyfP1xnAVFZQB6+nUrae3uwcSpcS8WtU45KP61t9k5k8y2fZ0vdsOTw8GnyXmVBYJi
	oQf5XvbmrWe7+RPq3ITiIM8bAwRLuuxM4K7XS5M9coUcbZKR3UrWe
X-Google-Smtp-Source: AGHT+IHv3xZhgmMvGAEJd1hJmGS586Qi2hutGjV7z2xzt2j2a4wtG5YT7+kCgwh3pvXzfvK+PykaRQ==
X-Received: by 2002:a05:6512:4007:b0:595:8200:9f79 with SMTP id 2adb3069b0e04-598ee4cc9eamr2253993e87.43.1765467588352;
        Thu, 11 Dec 2025 07:39:48 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-598f3197e0fsm950502e87.89.2025.12.11.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 07:39:47 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 11 Dec 2025 16:39:46 +0100
To: Ryan Roberts <ryan.roberts@arm.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aTrlwpeQyvM9_FX-@milan>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
 <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FB49C0014
X-Stat-Signature: haxkyhonk8ds78sc6ad8zu1i8bkn9afj
X-Rspam-User: 
X-HE-Tag: 1765467590-276421
X-HE-Meta: U2FsdGVkX1/397x1q0DFstN6819Jf0VhlkBJWigTGYyg5wZ3Up0mgqc7Pl/mChUiN61mgNrNKwUUdDzmugupdVBfFA4bFaHqGxu+K+SEA5r5r1eqKXcixf3yiG8K70q8ZNnuHnALKbF6L7Jn7ljnuiJr+zRzAcEicqga+MM7vyMOVopT1roqr+b17hDddSyouvk4aBM2oMxF9QkFWVKdwj69m7laGu1BmAI2AFDrixXKVFDv064QYq48GRPwxyf8HVwuXbRNCc348r2UfdU+Ospp/EpgSjdUW+W4qhbkt4wLTylflZ5nB3yA0qLybh+gb5G81dAfq6S9AStrv0TwmzjaoeNr5OH5VPgfzGegnQR2jHsj6nsTxt4QHusECijr9Qjlzwm72VwO3fyNYy4H5qGWi83fPIzY8YzWjU0RZt8NVvIZudQwR/dW3xxTKW5UNHUmBkrJAIztTBo0STqpBt965quu7eMSDTRnQwUx9AGHIKcxAciaxB3uf3/qvMZ9+xRxTnirnzdW8ffSbwmK1jmBQjcN7T69D9qdlKNnrkxU3Yf4jTxHJKZI7u1otk34iGI92gTeL1M9Uw9t0py+8RHKu8w+e5xkf015BUUI488PojUletkHxRA6BnPv4a4mGHyfEHWcTvnWPIRclygaAb3G2blt+BRWFkAOo8wPhxHVeMbbnj9ARtkQ8p8h/dZCHLx167IetVUeghm/NeDJVk62tLGk2SdMR2IWUAJFz8J7y66hE7iJ17w9RXczTTVOlklJpX5beDLk3Ro8F6lBWPfoebVC6L/RxAcrWGJltdjmJ7ljoVwLVkugLXpFOkUy3HLA8hvguAu3rTOrH9Te0xuu6bqhzF+aIQhInGeTKTd1foUmIKpoQmj0eDSzSLhuxZgnvNUOSDplGJnOBW0DoybLw74Y6GCdo/8PuiwWNuKXuMNjTK+NZFTe2QeCYgKLQlPtJ+RTNZYV8UOT+/q
 U/gPjKe7
 cmpRvNyKfnEHLPrqupEahOzJjBuYI4bZTvml+gZE5qhs4A2f0R5LM9QQG47iNdQflymDwIvz49FAmLdHd9cRdyRsB8HoDxuYudu4kD+WD4IS4RMxYDjbOoXp9z9jLW/cyKjFkQ/TfUshPZo5UTn0zkGA01BYp3WX8K/it9LjENhNtkoirlAw/bpzLe0zs7OhsIZdNJjbnqBz1FrTzNiNRuYsGGS4euCjqQiZgtHidsxnu/MvFbxw5MOPqJjTm/sVAv53FbVpWvIcarvwIax+23oZD0rKxvu+FQgXuM7kbuW99aHGgzCFy+RPE3+EmeDbUrn+BG/2e/r9URQEQLEPO48xsBgKtXdNGTp5Yz9YxCbXUuEKbMFPodUGOpe4lZx+GKMBkLOe+3HV7DUAnKVsOAwEJVZEiQEmeAIUjHL99/CsWKkxwEsxUM5q+v4nAO8Okj1J4KpaVNLIKb9maBJx0cj/sbXNauHx/gUZYNNJIz9wQBG6bNxaLX2puueF9Ga0GCixRTbNZMqanlfwJ8h+ttA8X29I+mktNqbn1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 03:28:56PM +0000, Ryan Roberts wrote:
> On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
> > On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
> >> Hi Vishal,
> >>
> >>
> >> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
> >>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> >>> allocator. Rather than making requests to the buddy allocator for at
> >>> most 100 pages at a time, we can eagerly request large order pages a
> >>> smaller number of times.
> >>>
> >>> We still split the large order pages down to order-0 as the rest of the
> >>> vmalloc code (and some callers) depend on it. We still defer to the bulk
> >>> allocator and fallback path in case of order-0 pages or failure.
> >>>
> >>> Running 1000 iterations of allocations on a small 4GB system finds:
> >>>
> >>> 1000 2mb allocations:
> >>> 	[Baseline]			[This patch]
> >>> 	real    46.310s			real    0m34.582
> >>> 	user    0.001s			user    0.006s
> >>> 	sys     46.058s			sys     0m34.365s
> >>>
> >>> 10000 200kb allocations:
> >>> 	[Baseline]			[This patch]
> >>> 	real    56.104s			real    0m43.696
> >>> 	user    0.001s			user    0.003s
> >>> 	sys     55.375s			sys     0m42.995s
> >>
> >> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which 
> >> bisect is pointing to this patch.
> > 
> > Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
> > are expected for how the test module is currently written.
> 
> Hmm... simplistically, I'd say that either the tests are bad, in which case they
> should be deleted, or they are good, in which case we shouldn't ignore the
> regressions. Having tests that we learn to ignore is the worst of both worlds.
> 
Uh.. Tests are for measure vmalloc performance and stressing. They can not be just
removed :) In some sense they are synthetic, from the other hand they allow to find
problems and bottle-necks + measure perf. You have identified regression with it :)

I think, the problem is in the 

+   14.05%     0.11%  [kernel]          [k] remove_vm_area
+   11.85%     1.82%  [kernel]          [k] __alloc_frozen_pages_noprof
+   10.91%     0.36%  [kernel]          [k] __get_vm_area_node
+   10.60%     7.58%  [kernel]          [k] insert_vmap_area
+   10.02%     4.67%  [kernel]          [k] get_page_from_freelist


get_page_from_freelist() call. With a patch it adds 10% of cycles on
top whereas without patch i do not see the symbol at all, i.e. pages
are obtained really fast from the pcp list, not from the body.

The question is, why high-order pages are not end-up in the pcp-cache?
I think it is due to the fact, that we split such pages and freeing them
as order-0 one.

Any thoughts?

--
Uladzislau Rezki

