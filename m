Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA6FFCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266CC6B008A; Wed, 13 May 2026 08:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217576B008C; Wed, 13 May 2026 08:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D566B0092; Wed, 13 May 2026 08:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 031256B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6DDF1C1B82
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:18 +0000 (UTC)
X-FDA: 84762341916.16.3A720D8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDC5314000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BY/0guMd";
	spf=pass (imf23.hostedemail.com: domain of 3AnAEaggKCEswnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3AnAEaggKCEswnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778675717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B/yiXTDHFLW+/gAvDFdorcnDwM+eS+wmsY2xuPhgZn4=;
	b=Qdomd9BuNAaec61J7HRLnJV7b7XlpCIYViGEjY680wg8eu1lrYs5Ial6HIe6q/EAKyNplL
	itC3Uq06CECIpvvWeh4TRPWea7fphaKSabFKwY9XTAuY9f6MptiAh3elGMyZDm+RGRjsF7
	4J2VquXbWGbqIPEy8qzJuaFXi6VuCAo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BY/0guMd";
	spf=pass (imf23.hostedemail.com: domain of 3AnAEaggKCEswnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3AnAEaggKCEswnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778675717; a=rsa-sha256;
	cv=none;
	b=MFE40tDEXLCNLc6E0R5zREF6NbYjCyHcXh+CMJ+orW8mUmcz9Hib2jRUio0715/q0LuA8H
	7mIruTvhixa3oFzz6L4ghmMpOryvmJ1MYHYGAWepzPDqI/ey4w/x9ApBaqDXHaJsrO/zhC
	pQFJbjRZ9HEtt9eEGuZthcHIO+hkkPM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd233d1e2so3646555e9.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778675715; x=1779280515; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B/yiXTDHFLW+/gAvDFdorcnDwM+eS+wmsY2xuPhgZn4=;
        b=BY/0guMdPJQT3pEoXM6eIha2lZfOryqo9vJwsZzKNBoS9TiSa0rxxCJMFgSKWsIAW/
         sUpW103C2iry7nuslDdcQJNJmT08YOPCHngnX/U4c+3zE67UBKrVEji7cCXfQPbgX/2F
         uEYq5enm1zX+iFlIMFw8KeGs+qwxigP8YIBgEzI0yFhgwIoG/nte63omdXkD6C3bLWgT
         AMrTlmjf1AMzOewOxf1i/a9lY0icKTHYLZM1GDAudv5VP2qOC0P+aldYMbu5c4K7SQze
         873BUvQ7yUFqz414D/0J4+7gvo68rhPzDDWTdIC3MUHNjpON7UXIr8F1W3c/UCeCAnYT
         Svbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675715; x=1779280515;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B/yiXTDHFLW+/gAvDFdorcnDwM+eS+wmsY2xuPhgZn4=;
        b=G4Tlh6RrLz2ISUvPQLGNJEAbhl64AhOiiJt40LyI0/4cJSTBQmXEjU0m4QFlOhYmxm
         +CLt109JT9Sxu+Nj/daTICf47CoijBOtLed+Vgr53KoqPpBJvW4pHa2Wbz+RthXZqckr
         xv0gsvHVTadTYk8NvE/qRbAiRMMiQhpluRCGmqen7v6nYZoQAaZ6h4JTpt97NXOAHoZa
         ia2uKEHmoM4JC1sH4YTB1NUb2p7aacJzJHmevCcP6C5pRoWPmZCOMFMrhRFCAKjtOnMn
         DE9IZeXS/f+EDIYXhDsSJF+225KkDRSJiUVDnszovNkcyZqF+DWXEmosBD1b3Fh/+ta0
         sobQ==
X-Gm-Message-State: AOJu0YyyaVRT0CTM6HIQe4qgD36IseLF0ln4EBpQvIo5nbgpcn2mQ+0a
	DRRDYEbIrJpvt8anQx6WtlzuMDUp5VOxipqKCkHm51bLaThnA5hopHCyZqL2JLClLzMgnajLfsl
	VXzCH/wP+m6QMqQ==
X-Received: from wmbf24.prod.google.com ([2002:a05:600c:5958:b0:48a:79c3:d04c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5303:b0:48e:526e:101a with SMTP id 5b1f17b1804b1-48fc9a1026amr54832845e9.12.1778675714891;
 Wed, 13 May 2026 05:35:14 -0700 (PDT)
Date: Wed, 13 May 2026 12:35:12 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAABwBGoC/x2M0QqDMAwAf0XybKCtOMp+ZQyJbewCroYWx0D8d
 4uPd3B3QOUiXOHZHVD4J1W23MD2HYQP5cQosTE44x5mtA6VEk+0rlvAPX9JlSNqYcUwEJvB2zj 6GVre5CL/e/16n+cFWecZZWoAAAA=
X-Change-Id: 20260512-page_alloc-unmapped-prep-c3ae0381d58b
X-Mailer: b4 0.14.2
Message-ID: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
Subject: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDC5314000D
X-Stat-Signature: wze1oanemfha5pqse3gctbpwduum6oda
X-HE-Tag: 1778675716-954487
X-HE-Meta: U2FsdGVkX1/WZqKgGI+I0xV1YdZSbvQCYwQOG5Mw8Odg/o6wftyGrPld4UUybBtG+z45a8soxHUKVQEms7RsEiWVCC9jsnq6HVgRmrJmU5gOqUYj2K4B0U6e7bnUHy7ufXrC+QVbvEF41zXFSVTAUprIz4TasGMbUkkcym0gqGYq1qULP1qDnmH79Fx4mkg4dgevu3JlkbnKBdhfaFJTj66cBp+yiht+wLDmygVcCLFCFWzlda4fMqA8/qxMMGxAZ1FU21+MRGzleU+EiOJEUN5KvGoUilXehSwU451gmVpfZ4fXRgggIN+txZWkiq/+iaKAwMDJCpS75r7uHzFZ0LN6AOCLNgOrNnhmgB30PdaymwTHROYleDTvHdHkOgkfEP7VlRlW7Yr08aC7j+GXSYLURh0UKrqozbfmY5GX3gq5+CMvOBETi9u8s6QwoYa+s0+c/j969VmPTrVFksv7+Pieb9C6hgYEpHFCajJiI37tEF+jmibgh8WZvDAbyotlXESrdeL7wN0CbrFO4zevQKJqBSwCvMCQ2DcFIkhJTPRj098qNOIm1Pqgn6Ld7xJGNSHVXuyaSVD02+UKG4xlJuSRKesKLUmoxccBjI748QAHmtkTHutWi6b0CaDINdbW07CU4a6Ffbg6ER35xLdtjP6ipzbgxAT9d2DH+yNS+/cg5NqkpSK/n3YN94rpncFCh9S/2jufY48nF8WFukfpygMzucQ3HG9mP0QU3DAPJbJAAreFWXAIXfgRN1q7fC8nOx3dU4nrXDOUz+x/PvuaxtdsPY7/gG5W3pwke+NtE6srI5Cbt0qtzg+VIxLQ/SgNP27LgLOf0V6JdOpxG0IH1CROAGoVQ1Mib3e/VbddQ+E2EWdoc9yxW7vJSmzZ7OolIMiptwURaqgtC0uOr8WGobbixMILGYxrjaluD5UzZvndhl/3C3nylJDLMtkZgAis6BKIX3VwAWE2VdA4UtV
 0UyN9uY0
 STSZhngKeiLcC31T6W2CXtzP8TpQ1O+xeSn4O+TILCwKcS0bx0ckXAWrZxkxGFLi/soUi9f+KxQ85Ai/Wbt9hzY6Q+AKTEmgCA0GP14XjnZrCiVz1yPGGaJk+a0no2ynSBuczdX1G21yG3rB95PZsXvxA90R2XIPGfjsEFemc8I0Qv6b3gCg9nTuxeNXNHEPJsO9s6a4YhtlF1pGGZgk8L387ZtgQuJ1snAnlSvEaflsDlmiFzEiGm3+95QAgHKc0LUnJoROaN8LvHI0Me5VumJhdF9EsKay3Buk3XP7VRnwrVh9cetL9DNKYVJ5odh/AToZTUat6Y2IV35dc9ga74lR0d+AQtZxCABxVgHrjDBmBv2CrPkvgjHBfpjseFtyHcetqoEj3pS7EqHtSYQLXW6c7RGYTC0k0SAsFYy3zNyzbO8jfg93Pdpc29Sp4EghfetV12gYPU+KAUk7N2SH5r3xTKRWpLMrBf9B9b0v9Rvvgnw/liYBtcq5IfljvRFcGBgwfyhQKNpCNQoqrOM7ywX1LsGeW4WZCzCfjDtkGTFUkR72LLr0g+oiPSlpf5OM0PD0F7aP4mH16FdKxs3pRX+NygOHntwB8ozwYfaiUxzC0chFk7pjiBFNi1N0qVRakyeQKcjb5QjlABuuB7i+iqp0I63KuqRUKlykLm0plhGNEklw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
could potentially be merged as independent cleanups.

These are all independent of one another, if you think some are useful
cleanups and others are pointless churn, it should be fine to just pick
whatever subset you prefer.

No functional change intended.

[0]: https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (4):
      mm: introduce for_each_free_list()
      mm/page_alloc: don't overload migratetype in find_suitable_fallback()
      mm: rejig pageblock mask definitions
      mm/page_alloc: remove ifdefs from pindex helpers

 include/linux/mmzone.h          |  9 +++--
 include/linux/pageblock-flags.h |  6 +--
 kernel/power/snapshot.c         |  8 ++--
 mm/compaction.c                 |  3 +-
 mm/internal.h                   | 14 +++++--
 mm/mm_init.c                    | 11 ++++--
 mm/page_alloc.c                 | 88 +++++++++++++++++++++--------------------
 7 files changed, 79 insertions(+), 60 deletions(-)
---
base-commit: 30424114b17dd65c098749cedcaef301c1dd2f86
change-id: 20260512-page_alloc-unmapped-prep-c3ae0381d58b

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


