Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18DAC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE5A6B0096; Thu, 16 Jul 2026 20:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8209A6B00A3; Thu, 16 Jul 2026 20:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1486B00A4; Thu, 16 Jul 2026 20:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301026B0096
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:24:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99918C035F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:44 +0000 (UTC)
X-FDA: 84996372888.28.B4D2592
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDB0F140006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kdSYHYcB;
	spf=pass (imf23.hostedemail.com: domain of 3SXZZagUKCPQhejghckkcha.Ykihejqt-iigrWYg.knc@flex--linkl.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SXZZagUKCPQhejghckkcha.Ykihejqt-iigrWYg.knc@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784247882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YNf9hW6w/Xci92rbeL0bZAjWiyrFwINX6SeGZd4Qiuk=;
	b=dsNJFGaEIjsiOcBIBCrRIeeW/rjW46iJ9ilfW9d+/J/zdnR4Pcd88WI/P6gKcZzAA7N9Nv
	U02x31gRi9CvWciXFENtJyBqV7Ie5L9Vtk+vBmq9mkLUUfZMiTOwd8ygi8RD76mSoHFLRv
	4fHMoWgBU7SZHm1cMzi3SM3kzCFOlrg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kdSYHYcB;
	spf=pass (imf23.hostedemail.com: domain of 3SXZZagUKCPQhejghckkcha.Ykihejqt-iigrWYg.knc@flex--linkl.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SXZZagUKCPQhejghckkcha.Ykihejqt-iigrWYg.knc@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784247882;
	b=4jDhD3mCT5ypi7TMQseWIqPhNYw9buKU16JAqKNmtG2BVrgYxuq2QyuORZm1Ph2Sk8ew69
	4cTkM/E9tytdk5TDr0lQmefLOJrkRom2HvGLEkIRze29xOXrS+3nyjx6ZlVypjY70wPEZ/
	YwwKjEz7CsbaEbtT3Zaid6q+SVxGchU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c88da04b719so3565237a12.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784247882; x=1784852682; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YNf9hW6w/Xci92rbeL0bZAjWiyrFwINX6SeGZd4Qiuk=;
        b=kdSYHYcBAbOHr0r1B04AzzVEuzWTXUZjettku/W2ccvvdHgII7w+HZNbP6VktI3vhN
         v5YZdakhE9T6IFAggtE2ebcvL2bJZhwBY0XH/GpFsODy1mcdh8WTFpkd6oShg26l1JUs
         wGlLmsZjqdbLLPvXix8fJh0HWIGpp1+Bw/p1xEEgl0IDPCh9ABPZnz8sAPII2YuPl6fZ
         pXRf99RsIZk1GVXe8SFWIugb+nhs/zjxYCSv22EGP9hS9BoQgXqgCvxBgYyL1vDCOjhE
         apvReQ1ZfeeqCeQMHjR5vXIJPIYi00SF1Cy3Xg4u0OqIhD913fF+WGzv6SUlZ/BChH4i
         iTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784247882; x=1784852682;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YNf9hW6w/Xci92rbeL0bZAjWiyrFwINX6SeGZd4Qiuk=;
        b=p4peXRQrgLAF2xSzXCSrmu8sCJ6EB5ENnZUghHHUyBGQUmR0nsTE/23VzA2AjAqPtf
         07m2nBT+CIcoOhkpOcaF2BUAqY6+Apj3j/HH+OV3TulzSTpDALR6YTDgHm2IPMkLUnWZ
         kIjgPTIRORtDcdcsbkONax5q3F3TLoHkyckyiOX1CVZRIogvoO3RDAK6bhZNv0BBlZ/1
         iruq06LbzJw/DKQDGZ/VoFe5ZYkZ6HQs35Sx3z1uNMURymoKTjlVYJPhWAgunnl4RUnX
         tlQHoQF2OJjmNtEdMJrTchBe0VznZfFqGGjxjdPNFI3g3t29e7usrp5ZmbqMO9ibsN7q
         j66Q==
X-Forwarded-Encrypted: i=1; AHgh+RoM3K1WN0zfLLcgx5xbZDEbwPnuNqVxlT0ZY8nfz3aYf6XkmqNPomG6FbhUltSSZAOFc+irYb385w==@kvack.org
X-Gm-Message-State: AOJu0YxzUkrmG2X+afSg6sblWcxDtNpRi0XgRXh6p7pPxoL2gJ1kCNAw
	JTgnQEmCduWi4s3k2BhiFnhpdIe9j7PR8OarO8ELhxItBuKKQY94lpt2u1smc9T040kx8otgT36
	HXw==
X-Received: from pgbfe6.prod.google.com ([2002:a05:6a02:2886:b0:c85:6deb:ee45])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d4c:b0:3bf:b0b8:58b5
 with SMTP id adf61e73a8af0-3c3ada18310mr197568637.36.1784247881450; Thu, 16
 Jul 2026 17:24:41 -0700 (PDT)
Date: Fri, 17 Jul 2026 00:22:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717002311.681748-1-linkl@google.com>
Subject: [PATCH v2 0/2] virtio_balloon: fix Use-After-Free bugs during PM freeze
From: Link Lin <linkl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Link Lin <linkl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDB0F140006
X-Stat-Signature: absn1qoiqji9co771odad136e8k5jr6j
X-HE-Tag: 1784247882-276922
X-HE-Meta: U2FsdGVkX1+3QAVe4sphEwMEzpoMVQ/5x4m6/KzhpPI0U77EQSxsYirfBHZeWBFxDu+XPPuLaN9NEfgAheKWAufLRB4RZow/eyWtnQgmW3v42psEfVEYw+9psvkwVxkCqGLY1K3hs2GTpuAsXQbhPgxzsjq/11eJU4p6eiCJg2+q5KlEqN7LfOGHuexWu50PvdpahxDNLt3fK3d08zviTZ0VF5qAMi/YLSkjWAr1zaucmjNDRCF5bGBHkl6cJaUg2hpsK2Z+ebBeooXh1EjTz4gi6lt5rnRT0YY/tRlwNSWREhyW5yAg0wM/9NQ97cUknDhlES77p5v2UYfcrC40tGsbkJAshgwthuUdsSBDB/qC3hMZlJMzoRRo9EEfFt82ddYZsoaAY8Ve1C93GCOPEiac+y5SoNF3/clKsNeU51LAQueq4Iqe8hdDCIEryl4zOaubSzblFsCIzGCQrHJX92cg+/W9A0GPy5Vtc2kdVSub8Oj+zF1swMg+5tpZmUFQxcV6XbYD7xVpwfVLUEN66N9KMQWYwWDCiMMYkZwRomDxIjE1QY49xMJRjOeRjlUC6F+iCQ0jIeioF24SiIXtrLTzNARBqMUnB6lhaOF5JlVLLwC+O+lCar5/APdC8IdoQuyjNDOLE8tznX12q2khpIxX9RXOQWPpB9PSr31rt86iRA57kQsboamFwvwEqd0K8NP8DiRW9zaqJQrJKSSFnde/d0n+DTntvO/lzlGoSJ4BFOTpY/2fgTnQM6QAtiilaSoZjLTzS3IGY/rh50tR8yhacWik2Vle+DZoqxdxFqABjV8KnKvD4M8Gs/8K4ZU0RSbU8z1NjOSJLvPjhsTxn1Fxy6xRSp2Zb/HsEXh6U94IUqNW6DTT2Hmd5yXykpfLUB7yfcBlmtlMfctgqCgXzgIRmCJKYd2NP+wTutVNCplx3tenbUf/KLUSHbjx67YHjNq3Xrg3ltlTkskIiFA
 MbjX7rz1
 6CcAod4pbc4Jwwg7D+N4i3B/mpso4CZ+rBNQ8Z1i6ShfyXRcVNORX7jy5PiM+7z5HCVyUkpypvstaE72p3W7P0FNmhgiPLgkeXxoh45RuWyGoqYYpv5/A1JeySCnYTDhzt3T8WBHdPFr5bgObePAW9iGG5ZOreSUMpkYkEHrSFsQ1litL0Iktroo1oj6Zj72VQu8VShbrd3BKHdCxtrqFDjBZAW4qoy/TnEJcgD3Xpw/219mJ4I9cZEKNRhZ1dQ3zSu7kFZOTtcueJUyryBvmQXmqIXD/1xjTLK5vN+lbvV2ez7P6O0bPmn49uajxpGN21Zxt7HzaHKd+ylT+A9ZSxWqQ5iAqz/y1oOgTF44CnRB1HlQ8WZD6/QVaaZjp4ugOnVx7F/P+Ti3ouIxYtoN9rt9aqQkxUyiAd5s9k9smp0aDDlUgGRp530uYXYOxlSEGlyNGE1x7f2WIIRKAXxfNJojapxj2ufvogh+VxfClD0k4v/uD43TC+A+3neR78Xlhj6lXHqao0QzfgsbGDknCwwgqq3682BKC1q064HRikW7hdu3ALizjgD1zw1OpjnPVjxl4gDSY+zBBFxgOEvBE2GHio4ZaN7VkwmGJxU5xcZK1YEVqx+BOQUfJVzdSIq7lR4lT/u37F3IkzaTQhajTruPOHyH8eJKeNxjxCM9YpHcBXM9+l2n4MvIuzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses a class of Use-After-Free vulnerabilities
in the virtio_balloon driver that can occur during system power management
freeze (e.g., suspend or hibernation).

The core issue is a lifecycle mismatch: when the system enters freeze,
virtballoon_freeze() resets the virtio device and deletes its virtqueues.
However, several asynchronous or event-driven components of the driver and
related subsystems (Free Page Reporting and Shrinker) remain registered
and active. If they trigger during the freeze/suspend process, they
attempt to access the now-deleted virtqueues, causing kernel crashes
(General Protection Faults or UAF).

To fix this:
1. Migrate Free Page Reporting to use the system_freezable_wq, ensuring
   its worker is frozen before driver freeze callbacks run. (Suggested
   by David Hildenbrand).
2. Avoid shrinker execution while the device is suspended by adding a
   suspended flag to struct virtio_balloon. Wrap lockless reads of this
   flag in READ_ONCE() and writes in WRITE_ONCE() to prevent data races and
   KCSAN warnings.

Note: The OOM notifier (virtio_balloon_oom_notify) is also registered, but
since the PM core disables the OOM killer (via oom_killer_disable()) during
freeze_processes() before device drivers are frozen, it cannot trigger
while the device is frozen. Thus, it does not require a fix.

Testing:
I have verified these fixes using Google=E2=80=99s virtualization infrastru=
cture by
running continuous suspend/resume iterations (40+ cycles) while=20
churning memory using stress-ng (stress-ng --vm 4 --vm-bytes 60% --timeout =
1)
to constantly create free pages for the buddy allocator. We also set the
page_reporting_order parameter to 0 to make the page reporting worker
highly sensitive, forcing it to pick up any 4K free pages. This=20
confirmed that the UAF crashes are no longer reproducible.

RFC: https://lore.kernel.org/r/20260709224330.946683-1-linkl@google.com
---
RFC -> v2:
- Switched page reporting fix from unregister/re-register in driver to
  using system_freezable_wq in mm/page_reporting.c, which avoids complex
  restore rollback logic for that component.
- Switched shrinker fix from unregister/re-register to using a simple
  suspended boolean flag to avoid complex rollback logic. Wrap its reads
  and writes with READ_ONCE()/WRITE_ONCE() to prevent KCSAN data race
  warnings.
- Dropped OOM notifier fix since it's already protected by the PM core's
  oom_killer_disable().

Link Lin (2):
  mm/page_reporting: use system_freezable_wq to fix UAF during suspend
  virtio_balloon: avoid shrinker execution during PM suspend

 drivers/virtio/virtio_balloon.c | 49 +++++++++++++++++++++++++++------
 mm/page_reporting.c             |  6 ++--
 2 files changed, 45 insertions(+), 10 deletions(-)
--=20
2.55.0.229.g6434b31f56-goog


