Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48426CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 23:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0B48E0009; Mon, 17 Nov 2025 18:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9188E0002; Mon, 17 Nov 2025 18:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4F88E0009; Mon, 17 Nov 2025 18:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9A38E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:43:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DABAE1402AA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:43:07 +0000 (UTC)
X-FDA: 84121727214.20.93C7C6A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16FAF14000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:43:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UvvdzWbY;
	spf=pass (imf09.hostedemail.com: domain of 3CLMbaQsKCC0JLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3CLMbaQsKCC0JLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763422986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dL2LiF1FldEZ/KOYQf5dYKmrAGWobpV3y8hV3ZgMVqE=;
	b=DFhTRY3l86nLmHCQhPNoUpXQ7ziT/gmmDKkwIO8ujM4QP5HXe64FE5f1BPrZFYuyChg9sB
	zDRbNm4nvZDx3upgfksrKvYQXCI/nEouaCNvw/WteuwR43JUGNmQqjSkJtSoIf7Rgz8GcH
	kpH3LD2fmQ4gPBJ61sgUCxdbIp4yCjM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UvvdzWbY;
	spf=pass (imf09.hostedemail.com: domain of 3CLMbaQsKCC0JLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3CLMbaQsKCC0JLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763422986; a=rsa-sha256;
	cv=none;
	b=Jlq79nisWfpwz+QiggZgVwdfRBut+5wyNtYvKTTqkAnHWwVyUCqaw1F93aLi3A26d7Hd6X
	AqgJDC8Lragx3GXHI8KPZZvIvox0QbRE/Es+WEC0Gm8jRp/EFTvOQZJxjBDw5Qz81v4VSE
	2zm9T9xIWgtLvx80RV7TqGq/NwTzwqU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29846a9efa5so133415675ad.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763422985; x=1764027785; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dL2LiF1FldEZ/KOYQf5dYKmrAGWobpV3y8hV3ZgMVqE=;
        b=UvvdzWbY4QUdCIQyvB4k07ITvRiRuTK4/IEKBaVVgg4JYxL3qV//hTdDRL7sEScXh5
         ngkPOK714R4VRVzbejEAb4ecEIpKxjAhZU9cV9xZWHewv2Ez/HygBdRhQMMN7TnX7Ex9
         qfFm9ayQu2k18TFVuY/Jt4u8RhPQ7GnpDz5z4MIdIaDh09gvaiMDQ8EwlGj7xHvl2LAR
         8kw9Y4IiuBhQIB1q6MYjOuiqcX3LMBG+S15AsUdzXRGaAlLJFc967zByp9mDQ5Ny7EdB
         gOoktvAw/nSfc7FPXCXRObA06Y0NQoSDZfrHou0Ts+rRsJYRONYGpevZFHUdv5PVtPOu
         RcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763422985; x=1764027785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dL2LiF1FldEZ/KOYQf5dYKmrAGWobpV3y8hV3ZgMVqE=;
        b=Ld9aj7GbTtw6NwlZuoxam5t/E2tM8Lk0Aq+VAn6n19j4YjKjuYrvPzXBLptXQqplP8
         vLQPKFFF/XkFAt4kBR4nMFl/7eeU6X1vX0m+5SXOwZrRIN4kP7eeyRooYhbmwwUpeBD9
         9r5tL0xm/wkgTn9DKj4saON/R1F6/BHBcmbWf03Y07wi5t9bj2YBNhAlsGz01lEY7NXd
         brZJ9S3ULUoPrgEp+/ihv3qVpnwliPBTxQhPmY5NXPoef6zy9Ko8poKurXk4noGvZNlb
         JiZlMqX2j1CfntQsmmKAR0+i49JJTudghAFnXAp4wCDy3+oPthUPWUOdc1R1fKRpNZ6e
         Wcuw==
X-Forwarded-Encrypted: i=1; AJvYcCU3u26oPEKyeG9F6qWOfoMNuzdvsXevOGdCH5gjtRoj4D5FTppZ7C0yZsOlCDjsBshvqUWDgKe+AA==@kvack.org
X-Gm-Message-State: AOJu0YxHqCxf0K0y5lt3i55nZaxibUKdeYpF5sbmxpU175aQ0wl4iFae
	ro3Dsbc2i/MoKqIicAaOD1apYERkxYWaqZaqJHb7UP169Ds3UXJEPrc/jL2EJxtJG5v5SWXcyrE
	XoEDEoiFLvwIJQwn713cPz8QtDA==
X-Google-Smtp-Source: AGHT+IHWpz1bcVZOmz2II2H4ZeDGXr1yKcY8vxUhe1flIg0qA+8VT3coJzci/8Ii6V7iaVk1iTvEUQ+0iPC050VUeQ==
X-Received: from plbkq4.prod.google.com ([2002:a17:903:2844:b0:295:41b0:5445])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db0e:b0:297:c272:80ec with SMTP id d9443c01a7336-2986a741bbbmr167625985ad.42.1763422984901;
 Mon, 17 Nov 2025 15:43:04 -0800 (PST)
Date: Mon, 17 Nov 2025 15:43:03 -0800
In-Reply-To: <aRuuRGxw2vuXcVv6@casper.infradead.org>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com> <aRuuRGxw2vuXcVv6@casper.infradead.org>
Message-ID: <diqztsysb4zc.fsf@google.com>
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
From: Ackerley Tng <ackerleytng@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16FAF14000B
X-Stat-Signature: sassjbrny1b5idk9pfhn9ebsmsg6hyp7
X-Rspam-User: 
X-HE-Tag: 1763422985-163345
X-HE-Meta: U2FsdGVkX19cHT67e486COWTIBMeStmL8t0bOunzovex+UQbE/DiI1TV1GlnxXqTxQeuTjbP+sW0yPxaN8HbavtpDDEoTI/2RGGLWraEtGbBCFp2WX9MfWgp8KVJultjAYqyI89e+KyfKP3MbIFxD/typcCA+8+W3E0Ph+K8XlY9GquSYegLN3aXVIz92v2tqepcIp1vS61uEE8RWsjb7tsTf4QVMVJC79jaz4dsfsJOeXEaDTXmExMCHg9F+Gg+/e8LTamtJMpPOX8Q1wMoZu8TaazrNUVfNGXRurynnvoelsKL348wO217A0h++IyldnM6K/3h6tQQmpYATGEKIMfYTSikC//nQgY4hLY9j+fcFGOdQr+V0D3Az7hP0t8m/KUAXbWQTPc+zRGcdYwDTQAw+lA61B0poUiZq4CQrl35irauGClTiA1T/+KXO5FdkPWdoed/JkNE2pzh+PVRZbn1Xfa/KmxiIY3t9O+RSu81oRHowY+7RPypvgLd1HHLod4SowbFehru8xeCzrd7zOZ7GPVh2ctIwjw5UrWsZadZv+QNHWmmPgouy7O0klw07f+Qbuovuug/ATKJyTkTXmF2iBj1XD/H3Pqq4hxZQwmDXglH56pkcP2Z1sT4Dmga4iJJGXDGjtRX3NgpYGW/O/MN/mkkWws+KD8T/535L+Tpk5zgOcqJsPXzfEjwvcXsFGs7Yp6lFW/sTRdyxwsl7G1MzmKKBQs+fgqgH2QVQzsRlZTnn8hpsrqlft/+AcQmBX12Fgw+C9h2/F1qAKgztF2lsZAAaeNyZZkNv6yFLhjN4l46b3f6wAsgW7tWFiP3MU++Lbgb3IP5rQGu5hDotcfrufwEi5m0QP4zrbLnAMMzMyirx8qT5SKroWlVQFugpDPISUiHO9tDBYXqSDYLrXVzEgw6IsZl9h265J/lw9W9VQ0BzTMNs2N+PXleGqojMiNx+L/11FrKc69VGnM
 8HqGK4Cm
 aA3+MB+kK/9Vjz8bNI0wm7lRLeVofZHJ6kCRBPoV5/VH6Vu9i6wXkUafT9VB23rrTwRPFpsPZqeVj6o1RVgg2tqP7HydcblMJXPEgiU+/srUAACbMte0V/rsKK5ddmF7h0XhBxqqDNivNBxx295Ef6UUpWfXF/c9O+EOF8H/nYp8goiJIjwxGpifPoocf+9upwug1KHsw26V8MWStARsKTDs1leZZvwTI5e9iWS0gARopE+I89UxdQqOfURmo0ewyWk43ZzedwMoBh6outuTdTqKwnpG7wQ4VAyrQVuGSC3s2jG3EnJNMJiWvEW5r/gHMUe8HpjqfVDUBt5uKdmWp9Pkyz4/VxKhl766PaBzUVLDVEkiD0aD1W1HhshBDbGATrieEjRjRjJ7ug7qZszhAsB4IvhMWmMHRLDmyO+zFKRAZQz1ywgHbbGNdGEm3X5LtM/zV+SAXENZAdcgsgfJOm6R+CgKCpLnOt3tMDFYOwJU9bx1N61cC9NEtG6u7XRwO9ef4hzXWWi+rTj0VJfX5yKEUhXmH6QtIhrW5fJQp85p5VrOymY03IFWM6sh7st9uBbKxBh1TOUjKVP5dIt2dfo+0F5+UT9E4CNn8AmlWUt7jqEzvz7hGluWFiLvop7oh0tGG9g1/TudFYyLCFKgvFCkNRdZeMjOviyg+muXcrxoN2SDQjO0kQT3Y8Owe5MV8rwIIT33vIeEM2COXTUkgvLyEcF8XNrNFIw8Dx4sch5snV/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Mon, Nov 17, 2025 at 02:46:57PM -0800, Ackerley Tng wrote:
>> guest_memfd is planning to store huge pages in the filemap, and
>> guest_memfd's use of huge pages involves splitting of huge pages into
>> individual pages. Splitting of huge pages also involves splitting of
>> the filemap entries for the pages being split.

>
> Hm, I'm not most concerned about the number of nodes you're allocating.

Thanks for reminding me, I left this out of the original message.

Splitting the xarray entry for a 1G folio (in a shift-18 node for
order=18 on x86), assuming XA_CHUNK_SHIFT is 6, would involve

+ shift-18 node (the original node will be reused - no new allocations)
+ shift-12 node: 1 node allocated
+ shift-6 node : 64 nodes allocated
+ shift-0 node : 64 * 64 = 4096 nodes allocated

This brings the total number of allocated nodes to 4161 nodes. struct
xa_node is 576 bytes, so that's 2396736 bytes or 2.28 MB, so splitting a
1G folio to 4K pages costs ~2.5 MB just in filemap (XArray) entry
splitting. The other large memory cost would be from undoing HVO for the
HugeTLB folio.

> I'm most concerned that, once we have memdescs, splitting a 1GB page
> into 512 * 512 4kB pages is going to involve allocating about 20MB
> of memory (80 bytes * 512 * 512).

I definitely need to catch up on memdescs. What's the best place for me
to learn/get an overview of how memdescs will describe memory/replace
struct folios?

I think there might be a better way to solve the original problem of
usage tracking with memdesc support, but this was intended to make
progress before memdescs.

> Is this necessary to do all at once?

The plan for guest_memfd was to first split from 1G to 4K, then optimize
on that by splitting in stages, from 1G to 2M as much as possible, then
to 4K only for the page ranges that the guest shared with the host.


