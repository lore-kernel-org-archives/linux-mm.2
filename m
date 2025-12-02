Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C680D116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70616B0012; Mon,  1 Dec 2025 21:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A486B6B0022; Mon,  1 Dec 2025 21:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E4F6B0024; Mon,  1 Dec 2025 21:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 811656B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:43:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 825414F65A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:43:41 +0000 (UTC)
X-FDA: 84172985442.13.6BDF4FD
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D1E340012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:43:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S57dnSyl;
	spf=pass (imf04.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764643419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y088g1etBw4PmnSJUWOG0AeBEE+rOBC5zfxeDfguw3w=;
	b=nCbUax6/eTrwx4Sm+5foJi7lEwa7ieunWwil+YGZdwZeTgAe1MBFh57+pWQsptF+8FghJT
	i8ZlG/hr+Zg7Z13c8U8vexatfFCz7MOqjIwSnGU9CIJsreDz9G/xWgwQ8B94B1Z/JTbmtj
	NedQ/fIyiQ/ugRUlp61djOwEJvn8WCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764643419; a=rsa-sha256;
	cv=none;
	b=bwlZQ0UhZiuMz+IXqSIJn++3BI6PM9hPXYsA2crisIOglTemd/KxZVd3WTNUiyLMiJhgL4
	ACK67WrXms3U2A2Rk7mggQSJwD31JkLqwYgbrxHHsJ/lXnXFrXXBpU8NVlma4wAOLB/D/E
	p4HRUiuHTkCEy1kEKrW/rLOKtK7rMVI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S57dnSyl;
	spf=pass (imf04.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso5657745b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 18:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764643418; x=1765248218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y088g1etBw4PmnSJUWOG0AeBEE+rOBC5zfxeDfguw3w=;
        b=S57dnSyl/9UWO6FGkvwA4UW6cK9EALvPOGR6nRm8ETg30LQbkalIlGIyzTAOKisJqb
         hO7WBlrwQazj/D2jv0c606bJTFUkGXWSNAJeuZyjhEvbC/RTR0Iwvglxd8rOqjJe275I
         o8y/mMd8btIlNFmSxKMxKniZEy/YAVnjDCg/HlCAl8mRYMr33JHWmxnzY5FRa4dd11H1
         FutSbwABmYnlOAjAiZg2xnF/X3BVswOOkKFVmAPNYASCJPJVNiGgM01I8YMjtpvoHR2H
         iZYAKI8pHU1qOEhBYaMGdNPYDxUPs2ToZiS2WP1jZDtfR9Wdqe3Dy6IAi1G8f1EQGxR5
         5M1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764643418; x=1765248218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y088g1etBw4PmnSJUWOG0AeBEE+rOBC5zfxeDfguw3w=;
        b=CpJ9wyKNISKKja42CyZ8AouGYlHjvq77GqzGsm+NSkhz2NXC6nYvDcqgQRJwBGwVNx
         ThQb1YmT9vCEjFEVwuyLQnYmUWP17XR7qcO919zNdlPW5Qu47rw5gkLjMpPJJPvbhk8m
         2puimdrw5S4Ql8etIv5mJXeKESsW0/l01/41TfqzNs2dUoQ3T7PX0mFHCyERuqxvVeGk
         CWC4R2ZKN0M8kiGriQIQ+E6IqHywifcaTy/v85n9eUYAJo38GOr9uUNYzWw+RoktEq7K
         dBN9nLY/QtQSDeUXneVzZDsSETOqgqZFD/4inIpGgi4HZOI6L8zfMao8Fe7zGlXqnkuA
         NUOg==
X-Forwarded-Encrypted: i=1; AJvYcCUvdpjS+byGN+97jGnoretKBhLieDtn8aBbdKieeWZ8G0DD3SqdOBh+f1GwgK8y6Cg7Ebb3cseWIA==@kvack.org
X-Gm-Message-State: AOJu0YxLNWkgbFI5BT4+1Upq2QSDdwx+hgtmLu4umZk1XFW01I+Ukpvc
	Nhw6n1Dx7YiN0blUu1mzf6vPr7cbXc14+M9KPpHMP0rv2MGSPzA9uuiF
X-Gm-Gg: ASbGncsxhEMZfO9H6SuRXWpJZTmtR0LorC2ypK8c/59isnJsGqTO5p5csZviSmeK21Z
	s3DKub08dOFqxbHGhkSypEt5zXF2FVfc3OwXfS22ljRpDeks0Vnnr5CIqS1aFDh9mZBDPemI0u6
	5UOfG3LSclSINEMLBIY4LCF14kC8iiSeRs+zKe5OSil6FcVS6yK9/Mwm/WvDN5FhxDcPNUka358
	2EKR8vHlS5uApudGl/aeVM2Uc2/Oa1a708r1FmMsUQhVBdCWUrP9LLZse8BNCWjqhk1ylAvjCtI
	70+gmGYsg4e1AYW7T5H2401oHLoxy5VaA4N6YSAhVNeUGllzkaKWIThKGH9fJo77gEQdou3ICpm
	NYakOp+srjBLSSHy2opb8kTltWkHTfCW/Nzf4ZE4s+4IgjnBsSfxqGJrPNcrGS3tUIYVKpdD+i3
	PsPY88BV9GtA7WyrRRO49Rro3JiTI2alJKgHjTBuPxJlYWJ89Qaw==
X-Google-Smtp-Source: AGHT+IFdi85AO/pmFM/ZPKNJeKlJ9We6XZm6cuiws5XRNphVkV9eO77SGZuJYndfnqv+mi3B4H3jcw==
X-Received: by 2002:aa7:88d1:0:b0:7a2:84df:23dc with SMTP id d2e1a72fcca58-7c58e604ffbmr41968807b3a.28.1764643418233;
        Mon, 01 Dec 2025 18:43:38 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:b8f3:d910:6512:1367])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6cdcsm15058883b3a.20.2025.12.01.18.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:43:37 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: ziy@nvidia.com
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
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Tue,  2 Dec 2025 10:42:59 +0800
Message-ID: <20251202024259.412069-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <760FBDE3-2724-44A6-A874-BD87F0191C57@nvidia.com>
References: <760FBDE3-2724-44A6-A874-BD87F0191C57@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D1E340012
X-Stat-Signature: e83hgmj8asmduzm1qsfbh3rwxwp9khei
X-HE-Tag: 1764643419-281129
X-HE-Meta: U2FsdGVkX1/MI+3DgoeyD58s0wntZasq0jYC52B8pXzScVrycOvcpcj12jdpQYVXw7RyCb2ciXiP6OTRYK2SeJS77zTDjXlHTY2/cc1VSdhJdURUl0uwOjkKbh2Oy/XEsaGolDSzBmtC9l6h1GrqWHE8GMoiuDyaUrtiI1hlsWtGUQKqFp+fU4Aj7ur/Bzg1vL19vZ/ywUt0j0PVRuO+zUb05hV88bxA41utdXkMAMmkt7/eIASstNTuiI6xnOLu7ZUwgWnJs+lCcTqFR9EmR/LWCIKtb0GqKnvJ253EE/SP0nijWTRObq4UzarV5T105Dg9x3RJ5fVq2kX0o+Rxo7KjCJ0MGGKBtgPMBpWe5iBK6xhK7o9cb8ApUtV6Fjppgdm4Vu/L2LozK79Ocnq3KnFUrpRcqO7KFWqQVMWq1zcVoNb+d0oZwstKDesfbhNAAM4jwUGnL9RgtySJRu5sONDJpBXDNSHytbU9G4IbJPPfCfEg7C8Wh605RTNl0etkcjajJrZnF4Kc+sSKi4ymhqKhx1DAjcdcF271/FDyPPCT4+j1ojS+1P2/onKDH3SAl/gVoTyGhMvIlNczut4DjrFFK+BD2g1phsRijFO3l2McAE+Y2Sdiru3QKZufkKkzogLW2hUPPxNlu7wACpBmaMrF7lMFDODrREgq6kpcqrKFHFLTWDmnfLT6FRAHIr0377JP8e3P3+LXfc3AkoWa8dSe8e5I4T3bN4JMgg2M/wHeCzDUcAStb6s6svIqbhhbeVl6QyyIxqKbDMyQYLrhCTl3JMGfi45S0s+XPQOevwzLdmQ0cThxcvgJ348+7iZMK59y6hYTqyZO0zyI1zlo+bFob5+3JaibXAopcQGbas+a0ox28xFjMvIUSpbWSS5cZic2hp3oVD8zu7d70GKwnY5ZO0ftlHIU2bRLPZCB5CTvBVmB/TqOqCjKWqNtH8wdNIU4HLgD2+AzsySYDZY
 gTayvcyE
 SgwzCm9G8fsFgU4F+7wkzS9mC+EFbyI+6qr/gdf+YNzWDbGLzEXYIaWI49yevnsYuUaOEHBQGbq0TLt1Ox6cHHytVyFgkYYKI/MmM5Xmaz18a03Q8udaprIX6gUnt5EA5CJ6+3rLpVEAo7+CTOwlyryUGMTo5/FPBSDa6NmM0M0dbltyN3K/4NjZJbp3afnnlAerWp5Dovb6BzXVyLxPQ0gKUpOOybwsK4hV1ommXSd3OMsk83iGE1qcrg5Pn7wHUYp6NHNVpf6EVcYavxIq70VXzdwFPBGYkGgLAm1KF5iGNcs/CN5Tkg5SsG/kJd7LhJ+BjS2ZtYCZIVwyqKUZe55kDY7XKCRaPH3HRSk4B/sIw8ygAufjLklkYOc5Fpq6xxPCX9evhwMhd/58bhvfzC8qWZyr4FNhJD/lf6yWSKM6b7QLuSV6oxwAu9ZktJz6q5hLOwyQEBWibTOebf2L/Ag0U7Zg9xPQVq1vHLUrccCgnzi9xWN+DJsrVcyeYeYJSin/72ekh+L3xr0kkCHKb1mugT4O6jPay+4LK3oLt2DrPsaxsahnWLuDB3Hzs7noA8RxQtxygUHTtlHFth6OD2dvtngw5ngWWpmmpSfkMTSD1TCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000053, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Despite the above challenges, Android device manufacturers hope to ensure
> > a good user experience (no UI jank) across all situations.
> >
> > Even at 60 Hz frame refresh rate (90 Hz, 120 Hz also supported now), all
> > work from user input to render and display should be done within 16.7 ms.
> > To achieve this goal, the management components perform tasks such as:
> > - Track system resource status: what system has
> >   (system resource awareness)
> > - Learn and predict app resource demands: what app needs
> >   (resource demand awareness)
> > - Monitor app launch, exit, and foreground-background switches: least
> >   important app gives back resource to system to serve most important
> >   one, usually the foreground app
> >   (user intent awareness)
> >
> > Tracking system resources seems necessary for Android devices, not
> > optional. So the related paths are not that cold on Android devices.
>
> These are all good background information. But how does userspace monitor
> utilize pageblock migratetype information? Can you give a concrete example?
>
> Something like when free_movable is low, background apps is killed to
> provide more free pages? Or is userspace monitor even trying to attribute
> different pageblock usage to each app by monitoring /proc/pagetypeinfo
> before and after an app launch?
>
> Thanks.

AOSP:
https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/core/java/com/android/internal/app/procstats/ProcessStats.java#:~:text=public%20void%20updateFragmentation()

We have proprietary algorithms, but they are confidential. I cannot
describe them publicly, sorry about that.

