Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B932D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FDF6B000C; Sun, 30 Nov 2025 21:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C03D6B000E; Sun, 30 Nov 2025 21:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3898B6B0010; Sun, 30 Nov 2025 21:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23EBE6B000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:37:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D703C160F5B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:37:14 +0000 (UTC)
X-FDA: 84169340388.24.B63687B
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB41AC000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:37:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jnTBDyHW;
	spf=pass (imf22.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764556632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFkZfLhbEuJjG2XjBKILxrbYWoZsM3wmEgCHEVtwm0k=;
	b=w0XBg9gVipgtjkT4di1CKDnN+KoSpD/v7E75xiFhYOJhCuXd86IFu/HIzyBMmc35IlpXp2
	7fSBItE1d90/lfItvQSh8wb1q7KZd79cyjg9wUoIMti0ae9Kac+YxsI8bckHD9f6UvE4Kh
	Hz1voFqCpfK9/S36a8lyskaIeRzBcJ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jnTBDyHW;
	spf=pass (imf22.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764556632; a=rsa-sha256;
	cv=none;
	b=K7QxUsh4HQWs40pFEMJFoynR9KwqtAOPO4QwuT4TX7xapg/60DxWZDP0Gk+r9mHdUQx1Hy
	keiwcVxION66euAgiCy9FSec7VtHZs3sddkj8GSbMYHgx0Y+WkU/vMO0pPgbXzkYzNJvGy
	eswVRCooso8z9BM+aNGNlRrUo1GfSZY=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2984dfae043so30494585ad.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764556632; x=1765161432; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFkZfLhbEuJjG2XjBKILxrbYWoZsM3wmEgCHEVtwm0k=;
        b=jnTBDyHWMsC8cA4VTf2xb6/FLME7rN+hSTleKi2dWYUYPk5PCbJCLn5H7LKNb869iU
         +Q0+JPwnHgN+1nd7Z9YHiWxnYRZC5K8GKCnyuIiAMCFW/Roswerq94jfKf8KCt9EpEBz
         4Tka4XKdpsbicKgEtwi54NPaAxeRWSKJ34uPnFNwZOs99VdrgVf65Yg34rnGsObiPdN7
         t4hi3trNx0FJKgkxbR5lablxI/jefGpfhBGyxXnPYjm/Gsq7yUM6keg2Rs5Q2eUIYOk2
         TqFuUiK7mxgY+pXjmiteSuuYfqCveG1kl898gdIHicFP1kvfmrYONuFRLsOYoIFjnolv
         HnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764556632; x=1765161432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jFkZfLhbEuJjG2XjBKILxrbYWoZsM3wmEgCHEVtwm0k=;
        b=mxzTkxKyTf+Lv5j226fOU/0g0KdtHDusTDMbvB9/f5VABwoipfXhY3+3dX6+fx90HB
         +BYv9YsIWn34cCpgLaiDccySY8IwTgWUSFh+Yjoc7yQ/kgqYzemGNbfFu2bCPrkROmUL
         t6a0FpuRn0bYPaBdSS0PwT69A/xxoJe4iV8EDbqtIC4Wy4VZ8UWkEr5ZD5U0hEltDSRw
         0PQco7/ZozDWBZNCHApLDyuWxIocNPX+Yjz/naZuZCnlLJRw7t/VMfIUDVsWVJbyffnj
         U7OaKdhskuzNCu8JFj5wvC3CdVcBX2K0VEghZrLUD1ivCS7CdDJWquzyXu70BShkzro+
         PoOA==
X-Forwarded-Encrypted: i=1; AJvYcCXgfNN4/eEAIyxptm3RDItv7ncV+4p7zj+R1kw6MD0QSSQaF6ng9/OQl5TdswHsMfS833iTO3hwOg==@kvack.org
X-Gm-Message-State: AOJu0YwFZcdbmyORCdXwU9uKkUww0FnOBA/rzNFE5D4tNa+waOe5VCQj
	Wl40x8/A2eRtdLa4XHlPpYPZyJwlptbSRUJJxq6tEa92QZeHu12bdAR6
X-Gm-Gg: ASbGnctEZIbV9YEK3sNWh11+zI2d4Ayh4cfSa6iLulIElJhdeIc5ugNvmfOAOf3DIAU
	3u2i5m2+QfNfIMB8Wk3QzH3aQaBMA3W2JijhyP7/Gpblkg8cJ0wI8UrGRMkkq1QIDWyi+N6VM1E
	hKvwClTj0CwW04jN1K0fAgMQ71BPd2xhPBKA1IMG4e08ftSyEx3tn2IcGunEPPBlo7AkYqK7R+6
	XTZswWB45C/454CLUo83CK1I0KRerScUghtIMHUpoVXtIlOLGNhXO2HjgUApBsuIAZzKq0DJcMY
	sTc/MMUNnYjzXHUV+FEaz7jXlIuT8zXGkcF5qAjXG7PLl72djA+udqqinXeeRGWJLyCiBceYINl
	LHMXP/YA0gOamagGK6S3S2OMuZks1CeVSZnLzz6lAygRDWyOt/sUOS2PHdiU/e2BqTsuQrczqBk
	Gg7QRjuCD8IUMy4TXbdLfltm4SDucbkDnUQu2WxA==
X-Google-Smtp-Source: AGHT+IFXzgy6dEz9kNUZ4MEjK9R+DrmBL8pPlDjf1cIb3KeUVmSfGSrGpe4FpDq6OELyqkWRLqO8pg==
X-Received: by 2002:a17:903:2f8e:b0:298:46a9:def8 with SMTP id d9443c01a7336-29b6c3c2b70mr412505265ad.12.1764556631546;
        Sun, 30 Nov 2025 18:37:11 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:e08c:4f98:bd50:f87a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce40acbbsm108013825ad.11.2025.11.30.18.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 18:37:11 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: vbabka@suse.cz
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Mon,  1 Dec 2025 10:36:47 +0800
Message-ID: <20251201023647.2538502-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
References: <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB41AC000B
X-Rspamd-Server: rspam02
X-Stat-Signature: aextn9nfc5awkoh9fmqucu38w86ptrj6
X-Rspam-User: 
X-HE-Tag: 1764556632-758028
X-HE-Meta: U2FsdGVkX18gwsIs+ExUc0Q7eykH4rgYnxMY1Kz45+Fv1JeBXTQfi+ju4HsCXkOt85P9qzUKtlYp6ovFYQLKyYH3ScA+O2deqigikMUVgTNZsY6GBadOzAzYEmAndQ6haqy1YbwG0pqld/Nu7yjDTMzAEQGwQlcLk87tltPN5beXOJNlqNPS1NnvA99UwNknck/3uTfRZRaF9eMBMAuvIhLgY8/gaXg4ZjDNNSCYROrVTR1Np49cQoqVDZmAUz4lQVjyyHIeUca8uM0ShFqngEE4MKCdq3cAF9pfXNBN+VALGde9gCdyrbTWowEH3vBxP9LVE04thaVwr+RRazLaLeaEYvcMTCQt5Xs1oaGcVS4HXLwZa3/yRtGWRq1N6isdG8nzMxD55NUqZvSZrcAkT8t4xWuLNcFk2Dl0ONuwEIQAoSdq8PPC2gkjyMeBu1xSUXVCw1Vs26EbPPMPiY0237nqMYZZqzA956Dk3uQwT3PT91lY35Ab0Q0c5LuqjhOVGRBoQjDuGxiQYt4+Fgbj4aptJdc3dzjIPUC7duy0JHOmjcDHtV0I3Nwt59zjoUrZScITD2Kdo7MFLaQ/Q6RHwGnREGW3ThpSs09N8ZmIxl3PRikiwiHRiRwxpXGPEeM/XUONaptKkmg4baxlF0dRqDjltcR/At+PAA+OIyRlghPndSJzqkVl+k4C942CJlimgG73KpTHNdNgr3RJcO1nZrnz+kTkXPm5+SBsNeM0hqUd2F2S/pvD3XDuian/GJ1gIgAMj9oCQz8/EKJlRq8jmmNJM4KbG6Ec/qSQUJZ0TjVyfaErUNNG1aPUNvzWhmBJUTX1bktVXmpgbf6B1biVbniAx4ZvjWKjVUO+JIggpjcPGGFQ5KvutGUhqeIFMWSKEE7SvCPM/b5wGs9MKz1ukKOZAoZd75EiGtBe3eVMUSuKMK/3WJtJ5hSzy/9+/f6oE+kwmADcrQO6LeLEruB
 YrrYzxwD
 hiSGPHXiYen807gQSFeeraWWR03vAfhySaWBm+lgkGzfp6vasYvtMAUq8sccnPH5ZcqrwMqMfYdxS6D8ati5BoEE6nkb5eA7yJBCApuQPpppRsjasIhLc4aS0Dv7MC2fwWKbc6iJU4cQrzAXD8AIeYk/hsxFQOijZ572zMihhBWBaTlhsyUxjlyCtLuzCBVByWvaaEi0uvWM8d2uYCNNLwO92cRNQItvNH0g6+RLpAkOOwwz+wksMZbOB7QMMGg4nnbxcupV3Pw8N+S2TsZZySLCtb3fSKCHS33TffmKE0OwZlA9xnmCabb5DrFG1a/CE4s+dhDqCgZ87QtkubzAdFXw+WXM1Xnn/z4+Sj/Qo3uEkcjjdOX1L1pZ/8qpHpUlayWtBf4YZXrz13QCh/769l0r+F+IFiWq65vHnRr5T1kgPjzUP/ERKuEjrcaL/7Iy5arOG5zYUXHiD9LvWv6Bj+nhlR3KqVrfDFB8vf+Wy79j7rF/CeOrzEkPUY5Nz5uD1WXmEsXemzfCNpDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On mobile devices, some user-space memory management components check
> > memory pressure and fragmentation status periodically or via PSI, and
> > take actions such as killing processes or performing memory compaction
> > based on this information.
>
> Hm /proc/buddyinfo could be enough to determine fragmentation? Also we have
> in-kernel proactive compaction these days.

In fact, besides /proc/pagetypeinfo, other system resource information is
also collected at appropriate times, and resource usage throughout the
process lifecycle is appropriately tracked as well. User-space management
components integrate this information together to make decisions and
perform proper actions.

> > Under high load scenarios, reading /proc/pagetypeinfo causes memory
> > management components or memory allocation/free paths to be blocked
> > for extended periods waiting for the zone lock, leading to the following
> > issues:
> > 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
> >    8750 platforms, reducing system real-time performance
> > 2. Memory management components being blocked for extended periods,
> >    preventing rapid acquisition of memory fragmentation information for
> >    critical memory management decisions and actions
> > 3. Increased latency in memory allocation and free paths due to prolonged
> >    zone lock contention
>
> It could be argued that not capturing /proc/pagetypeinfo (often) would help.
> I wonder if we can find also other benefits from the counters in the kernel
> itself.

Collecting system and app resource statistics and making decisions based
on this information is a common practice among Android device manufacturers.

Currently, there should be over a billion Android phones being used daily
worldwide. The diversity of hardware configurations across Android devices
makes it difficult for kernel mechanisms alone to maintain good
performance across all usage scenarios.

First, hardware capabilities vary greatly - flagship phones may have up to
24GB of memory, while low-end devices may have as little as 4GB. CPU,
storage, battery, and passive cooling capabilities vary significantly due
to market positioning and cost factors. Hardware resources seem always
inadequate.

Second, usage scenarios also differ - some people use devices in hot
environments while others in cold environments; some enjoy high-definition
gaming while others simply browse the web.

Third, user habits vary as well. Some people rarely restart their phones
except when the battery dies or the system crashes; others restart daily,
like me. Some users never actively close apps, only switching them to
the background, resulting in dozens of apps running in the background and
keeping system resources consumed (especially memory). Yet others just use
a few apps, closing unused apps rather than leaving them in the
background.

Despite the above challenges, Android device manufacturers hope to ensure
a good user experience (no UI jank) across all situations.

Even at 60 Hz frame refresh rate (90 Hz, 120 Hz also supported now), all
work from user input to render and display should be done within 16.7 ms.
To achieve this goal, the management components perform tasks such as:
- Track system resource status: what system has
  (system resource awareness)
- Learn and predict app resource demands: what app needs
  (resource demand awareness)
- Monitor app launch, exit, and foreground-background switches: least
  important app gives back resource to system to serve most important
  one, usually the foreground app
  (user intent awareness)

Tracking system resources seems necessary for Android devices, not
optional. So the related paths are not that cold on Android devices.

All the above are from workload perspective. From the kernel perspective,
regardless of when or how frequently user-space tools read statistical
information, they should not affect the kernel's own efficiency
significantly. That's why I submit this patch series to make the read side
of /proc/pagetypeinfo lock-free. But this does introduce overhead in hot
path, I would greatly appreciate if we can discuss how to improve it here.

> Adding these migratetype counters is something that wouldn't be even
> possible in the past, until the freelist migratetype hygiene was merged.
> So now it should be AFAIK possible, but it's still some overhead in
> relatively hot paths. I wonder if we even considered this before in the
> context of migratetype hygiene? Couldn't find anything quickly.

Yes, I wrote the code on old kernel initially, at that time, I reused
set_pcppage_migratetype (also renamed) to cache the exact migratetype
list that the page block is on. After the freelist migratetype hygiene
patches were merged, I removed that logic.

