Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABE4EDF031
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 04:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E278F6B0005; Wed, 11 Feb 2026 23:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB4C6B0089; Wed, 11 Feb 2026 23:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D656B008A; Wed, 11 Feb 2026 23:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B51BC6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:51:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B5FD59AB4
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:51:32 +0000 (UTC)
X-FDA: 84434581224.03.0E12154
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id C794E2000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:51:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1ADgQcx;
	spf=pass (imf13.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770871890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qoLkvcAtx2WTrKtSPpoAsMeiJqeenZRH0jOzHw3uF5Y=;
	b=UtG4Ph0q7NXZ/e3DK9k/tHpp2/GRMsrKvhSXd/d/9WlfciINupURbYkdUGoHjDB4YeWQ0r
	61ZgUkyhyP5K0vLWRUpF3IM/01LSqa91GapXPoU+WOasTCveWMKaPfCfiBOu28bcG0nJH2
	4zny03KJkGTo74QER+JaBvsJo0jm8OY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1ADgQcx;
	spf=pass (imf13.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770871890; a=rsa-sha256;
	cv=none;
	b=TlQKjMooiruTlpuL6YZ+8C/xgvvVh+cb2IOCniZGWpA5L5TI4cnnnlbM15yp5oCRRYel0z
	VqgH+SezH2rjY3XIPCVEikSBoNTVHiJGxXtkv6g5cidNQV+ebCVVvkOtkwUwXZ+YcrUq6z
	4Ka9107RZ+/mNM3R8vlgMJcFku+IdJc=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ba94dbf739so2640697eec.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770871889; x=1771476689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qoLkvcAtx2WTrKtSPpoAsMeiJqeenZRH0jOzHw3uF5Y=;
        b=F1ADgQcxCSQzAWdjJvsLi1yrLzq8RrrGJh/0FoMN9C15g0METogsNXrv42C/Wh/h+q
         sP3+hY1wkFrdfgzIRmS4RViTka4pLLNytffscQYEwqAdiUyASQMpOmpVa2DJvbte01e5
         ICrU1bTx3EkACRgAu+Eg+IxxM4qVoXGQ3/LJm9CnswI9BpYGjxrd8ZyM1ZX7fOM/IJzT
         gCezO21xOFHwNm584R81lfeZhh3bvJmV5tPrAf8YFi91XM/ehlUFLmRnyCJpOyFSaUMJ
         pswqYM00ry7s+BkIwGt+dOFNAfAvj/6RL3GFP5HyB1in32wq9Iw4FWIZqJm/80gD7d2f
         qLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770871889; x=1771476689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoLkvcAtx2WTrKtSPpoAsMeiJqeenZRH0jOzHw3uF5Y=;
        b=Aoew8ijR59Xzqcb9OOWUq2ygMKeEuZLVp8jYyrPGAujOG0smeLmBH/Z22H8NP9MYCI
         Smc2xFc1FIxJHBLLUQkYm501QIU212/L2FgZ4CYfb6LxpcTDyd6+zek7nGtKAcoREb18
         ECllgQe4t9oYdsay+Af66IcueSzhxweifQAvqU+dEdP9g7iTSJiWsVr6OZfwS32Mc3V9
         XyEv8HshQYZ83WpBUyRWOEcpT+I3uVU4WtkYFq2BaT19DwD4Bal0DoIh++LYK9kYhgbN
         N4xXfJOS+Kv5nmf+LDI6zdh3AKtKtQiOMkWlfgfGyfZcJ8xkBeglkQEhIOABcsduUxeJ
         9/MQ==
X-Gm-Message-State: AOJu0YzqIEu5WevdiGLZtC0EeTqnIoClC28gqBjfmNsOupB0/6rGVkRd
	BozcECDThuEVIU5umoQoa1+FzZkVoc4pLiq+XBY380nURoHyEMqS+Em/prqUsQ==
X-Gm-Gg: AZuq6aITTIsfkgnBJen/+spwkVhsQEgFo1oeSk4DOigK7Wi7pUeOXCrFaxXi2OULQcY
	loQ9kE7U61RjBITf+6eiJc6JyqCIXe9JxBsEpNOgEWy5S5pASFa0fKHuQYuPKhEPEtCgaOeNZIe
	fQsYr8UyHvaDA3Yv5qNGYXdAdk/HSIxVTFlony3+JcWpS/xcm33zjx5Bb4G8zVuGIPOf8WFYiiz
	PaN+MT52zTCy8mxaOOv58emQshU37hG9GPrY5QmUiObAy8smxafiHs5ctrHLWfnNcGq0ndZ2iRI
	M6d2Z/mp2WUUH4bMmM76iD8iGuc3w+Vc3D+7nBrFLFqu9Gf89hwjuh2a8zXWt0jTI4emf2jC4qk
	FYw+b97PZkg5NZx7+m1HR3TEGdO6DZE08vl60KwUOQ8seHjXrDQAG/fxyZibrACBZYtfyXTjwDH
	FLCsd3f44VZUZp7Ev317nWBll8a4Du3MkPF8xI7zyXM/SB/QJdeQ==
X-Received: by 2002:a05:7300:1907:b0:2ba:a3f2:958c with SMTP id 5a478bee46e88-2baac4769bfmr331153eec.0.1770871889305;
        Wed, 11 Feb 2026 20:51:29 -0800 (PST)
Received: from jpkobryn-fedora-PF5CFKNC.lan ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9daa6151sm2878699eec.0.2026.02.11.20.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 20:51:29 -0800 (PST)
From: JP Kobryn <inwardvessel@gmail.com>
To: linux-mm@kvack.org
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	mhocko@suse.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	vbabka@suse.cz,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH 0/2] improve per-node allocation and reclaim visibility
Date: Wed, 11 Feb 2026 20:51:07 -0800
Message-ID: <20260212045109.255391-1-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: wyhczpq9egxyrs3aypj4em4igzbinuij
X-Rspam-User: 
X-Rspamd-Queue-Id: C794E2000A
X-HE-Tag: 1770871890-725697
X-HE-Meta: U2FsdGVkX18QoZQRwsLzWacgbGmqCas6DMxKDDc4hTtHnPeSbNfV5mbhJTRugKB663HrzE/J4zPwYAA4k0n4KRCKFhmfeHVNwKbOgBDW1TiLTACjEZiyojZ6lu1CCLejo/carpSXvnhUzTpIGX668r2dxpE+ozTqGhtifnLkXpyL/M0KUYMEo72l8Twy9U6m7iOKGHs0/7eUrg0Vorf/rbPGw+JIPvMuIiJid4xkXSIde/hkmTFA0TTk0njgeJVdhWzV1pk1btzh2dxFx7Octo48M16hO7WdsyWEHP1sdJV+reV7DQ/+pVoG4XZtHNYtHp8UD1UkDWmkONueMW98P9L2DNmz4tGnon9t3xGkyAMhFVbNRei8R0hvgokgQNOJo4m4jjYgpU2h0mrGBf9l0uLTTMJSD6aaKozCf/QNFKo9WQQb4k5Fahyl6aOxIPwrVvnl6aij892JIER2MhebLH/voyufDdZlc1W56r0acJKupt5UksqosC/4q0/DTElnX++G2onwYdWdhM+anbyQ0NSwOLNJJGegh5xt13gyLrl63ao7DZJMJwCLbzyj4JiU3LIfwTiDevFjw6hLFVUiGGP/ZHApfo16YFLMWPPQxqRpUPhwgu7QS7y+jwFBTuITo7Omhk5oMX0tjR0WgF1rML76KQ0A+ykXUtuSqvyFMyrw7/aAV0Ak87kwm3AFcvpUf50BkoALFPmZUbAlppG/8X6DmRN4e8JqEHKCfWl9GXEgXUpW8duo7Kap23CBjFEzIC50jsFurAXXMozHhG2oTdeR0+CnqtPgJEzwOuw+PyHjuMDYTyhyPzvYEeAaLbU+YAE3hdft62q/bRKNWjCeIM79DWLltw6FOZcA27HZkm9Eu8zJk4W64Whm+xs/ZmMnchWZlpN6qXeLzUAwMYC6oHnwVB2BtCkjvzzSLzsX/IlIZdl4M0LprROiKI+8+GSDrI4ckjtrSBx8qhwit92
 NK2E6lIb
 8s0ckQO7UElZ15Xk6n0+obJLr0HdKqFTsAORr+85X3//lQLJZDHVfD/IOHTrpSqvu9Gak5YBQenFJM/ZyT8olYxS486CBPGJCY8Bdxf036f9tOB8RPT4skm1K7RUdXUbE3s6zXoRs0WkEJO+waCM3jrIuTnVfaZ7E/4h+pIYOD8z52UU1q/4W4Ov0Q4wXNoG9Q2lFH03gTzGX+N8w0fzcFYzf/JQ6WjX6ZMNkpkmq5YHGlZXHqg42ilcap+VxPro16MQVgE2E0spEqCA+FrXFEp0PRY1rpvelfH0621sujH3UFMlGuzcpvi0S9GFvtnXDQUzn03ync41TaPEmwFp2fdZM6bc/87i1vHRPOCgQWa4p8v+Xx1gGfxaQj6hvOp6KuOKLZa84XNnNURYIB5eRfWplKmkCtQ0mJQArBklYXf7g0/Vc3w/bS3H/oSeDqvBYuEZzd6FMvX9RwGIfC1wjlHH7o9NOJrMfp0mtybw1cdc6Qvht7KOqQDAA8G3RC4VVFd8S8AQAYWKpyKDuGgX9ABQMDoMX7kxmv9JYUhDPoCZTDxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We sometimes find ourselves in situations where reclaim kicks in, yet there
is free memory available on the system. One possible explanation is that a
NUMA node under pressure has triggered the reclaim. This NUMA imbalance
scenario could be made easier to diagnose if we had better visibility.

This series aims to provide that visibility by accounting for the cause and
effect of the imbalance. First, the addition of new node stats allows for
tracking of allocations done on a per-policy basis. If a node is under
pressure, these stats can help reveal the cause of how it got there.
Second, the stats associated with reclaim are changed from vm_event_item to
node_stat_item. Having the pgsteal and pgscan counters tracked on a
per-node basis reveals the effect of any pressure, and allows us to quickly
narrow down the affected node(s).

JP Kobryn (2):
  mm/mempolicy: track page allocations per mempolicy
  mm: move pgscan and pgsteal to node stats

 drivers/virtio/virtio_balloon.c |  8 ++++----
 include/linux/mmzone.h          | 21 +++++++++++++++++++
 include/linux/vm_event_item.h   | 12 -----------
 mm/memcontrol.c                 | 36 ++++++++++++++++++---------------
 mm/mempolicy.c                  | 30 +++++++++++++++++++++++++--
 mm/vmscan.c                     | 32 +++++++++++------------------
 mm/vmstat.c                     | 33 +++++++++++++++++++-----------
 7 files changed, 106 insertions(+), 66 deletions(-)

-- 
2.47.3


