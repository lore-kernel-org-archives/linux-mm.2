Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AEA606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oRJ2XZ5e
Received: by kanga.kvack.org (Postfix)
	id C42806B05B0; Sat, 14 Nov 2026 09:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3566B05B1; Sat, 14 Nov 2026 09:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A846B05B2; Sat, 14 Nov 2026 09:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE0E6B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:48:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA36940437
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:48:37 +0000 (UTC)
X-FDA: 85434005874.01.30AEA41
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3EA231C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:48:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oRJ2XZ5e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QVDUL1mI78xGFf+VUdARrYw26JD1qxiuS2EpsS6yLDI=;
	b=uOqhw4xvGX9EQiil/JUQ3rs0YGv0ZKk/FLyTDu7KF5dYLpl5e39cRd8T+7WvYrZQ3bXuhq
	BWAOkI15+M7t9UmaR7TpleCbuIhOFSS4pZsTIXXeFvcLQq6sOQQiSq3OCMaIqDP4PX68Dh
	ew0wiNjqWzsWHOWPcgmpJjqOppDaeMQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oRJ2XZ5e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667716;
	b=7kpiM2odjUP/ON1u8Jiku45BnLckxx2AjTjmZ11HWpIFvAXY8hJzUlduOyPUJP/Ev9EPM7
	uDNck9K6OxvKkF2BcpOwOXuecMd5pE6ooFfTf+3ERsnqr9Yi+l3mBx/9b2QpfVlAqqqLN6
	hJb3lOC62b4NT8b1zWVLLPR8ljHpodA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b271e573adso1082969b3a.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667715; x=1795272515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QVDUL1mI78xGFf+VUdARrYw26JD1qxiuS2EpsS6yLDI=;
        b=oRJ2XZ5e4TtRUI1nyBpNpMkuTK/mjnvAotmquxBAH6vHivQLvYRzIBLH72lLdwLG6N
         i1Vk7ixTrkvX0V0BqPfAGV3UoYuDQhpqnUC/cSBTEgNPUHRRpSHPRtiIsJWTZbfhUjFI
         qNV+r6tL2M3DiVhzctmCJIYq9Kda5RA8cUw/6shnHsmInJQ5CP+VE+JpW5TR4V2Piy+7
         feJ4rTGMxgW3K7yCnSk6GIEqKaLaT7RGSzi4Bw0I+Hryi0u/59OtSlGF54Lox+ORbOTG
         tYZUrb8QHZK2HCUuiVnHiDBYoMBgniIe5M2EXujPZxRQ6oaFBxblx/oB36upwgvjJQFC
         xQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667715; x=1795272515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QVDUL1mI78xGFf+VUdARrYw26JD1qxiuS2EpsS6yLDI=;
        b=clTX4Teqx5EeFXOtpZFhidhGPudPBdKgXN18DBDz0Tmspyxha3SriWtOAgvq9IxyoE
         CLt2hyngfjXF55ruKkNI0bKT2ApjJo/tM1kyIHlTt/Ct+VuwdU9muoH03CkVFyEWvxly
         AxLbrQley3dURnnNyXmI9xxeWgsar0uOaJulFeLRzUxbWKUpShqfoB6fueVqtWlwhCwb
         bX+Y0R1loS9i6HgVB68QNEmxosB1U/d2iROve9vx57J1JoNeMitT2vPfKrTUjHyQ9g31
         aF3yXVLrUrtUxT4uVDvDXf1BqX0X8rp6g1YJgQ+jW7mVfpwwbKyjduAhEo4FirpEPkvk
         UTLA==
X-Gm-Message-State: APuU4Z/+MQi0LBTZJp7vm2R8dIem5PfwhFhUYqQ1ghH5u554aiQn2nmY
	LagmYiL7xInM3lOHwE+YxkXBz7yTg3GYtZePDC00efd3eS4AZuQH6VEHSnc8kw==
X-Gm-Gg: AYBFou1qmPLcxvljVfy7/yaPKPXIizs40ug1/DEpKkTzUdwIkTdQ18HDCUZN5cRydnS
	XvRtpDE/LhhhBLVbdSUX6k6gD8PEpoy11oeKQM0zK9fQ1fN4El4Vh+KWS3zQ+Tj0DaDRk6pCUIZ
	WtmJXd5otuiuNtFuP6OGqQ4qGMdAGRJdAqpzLjIRUAVXoc2iQnTiZItDhdx5lZG7rq633s1mi8U
	MAFbqd42VOhRGeSDDYLF4+aPbCZGEKg3UTZZ6Lw5oFg1/Wzzbvst95OGurgxTm960c0ZL8gAlv8
	DGU9NyA7etYoyWY/MlP3M00zcj51tk/4jyugdm4ZH/iTgvUvUU4v3b+jSiofF/mqRF3zihLcMCv
	Ra91w43+zXfOZUOPyGdd2wLDOc3PwoyQo9nYASoZPrxqzdg66zQbMi2ej4ahyIwEOj3eb3edJEb
	49uG2JihKX9K42WhyUShMPbyZTkIURum3yr2vUAb5+5iJ82/XGw0VvWfnHTIXhUbu7QwhbF5473
	PcfkGYd7PhK1GLJBrHqoVDKhKYiYJ89ZgUnX1FYD5e/chSQD7FwQdc7lhZq111V8T0xn3JFqJcl
	K+urkQETxW89Ztd4+zJKqdJmSRRzWJzwtCTYaibCXwtJyAKj82Ckkh7vYo1ekXn5vadu
X-Received: by 2002:a05:6a20:4322:b0:3eb:a104:f30a with SMTP id adf61e73a8af0-3f7a70b20dbmr5602948637.12.1794667714795;
        Sat, 14 Nov 2026 06:48:34 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18c09fesm2443837a12.26.2026.11.14.06.48.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:48:34 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 00/18] mm/swap: introduce priority queues for swap device allocation
Date: Sat, 14 Nov 2026 22:47:48 +0800
Message-ID: <cover.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3EA231C0005
X-Stat-Signature: 9soxagwg9xwhprsgey5hcepdfzdr7ya6
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794667716-304812
X-HE-Meta: U2FsdGVkX19axpS1lX0MwV9iQEptiL4Pe4/PYFai8vEtWZ23x7o6uAARwf1NQGt4qKwm/KW1ScL1Dsd33gcBR1BWIoFxsPD5YnYpDORHm1u/O8E5C4d0tJZlanzxx/+nkng0NJOvgnqqQ9RTyKRJZTMunjLWAK/8kdW2EJ5ktNpKQYf6jbSLKSzYgCoomAXiN/ELLt+rxnEfpfDRAqFD/KGOUN6KopPflxa/+iK9tuOp1Yk5CVA19ha2F36bXyAi0MaF5uXGK7NQHS8k+xROvMH0CfhefMKBRailpHNEUFmzpOJmw6ujyJiKTB0dMwj1X2cyVmUBpAF03DMI4XI2QUqOES+wPKCIn0fd/JABoni+MiGcKVQKsOW3bf2TqeeBNJ/9tqx1j9oGUNgTlc+Uwnp88KW+8rAPRvlCAm9W/tWZLjrq0Nfyb9DyR8HjEfZw8BvGr0/e4M3tZZUkWmbSBcxUchtxnwYKIHh0lmNtozqWViRhhS6KoiHUbtvoHTrpzrkmwW9tZZTgB6Gub1eIAAw732n9KMJ0MgW1fpSwmp8O2tC6ZJrm0ma5vEWMEutBy6OHIC7t0V/jkqPqMn6ZZlptsMa16+Xg+IR8TWk4oMimkGHYYg3B7Ne6J+lDkmuVeVknZQt0akiEHzokZ8qbWL26/QfEcB7VBxPoI36SQXkAo8xz7iTN63yHxFg9+q0B/q152UtaztHrHQV/YcA7IaWqnRYegMkV+GX2GCFv1Vwxgd9GYN881JRUElKFkJxL2dIsSCqpfMHnkTmseKYwBdYhVNp1nXwPTBmjueOT6LWA6wFVvTXwn+QCtssdWhO7fS1AHS0tXbR69d0XDFpB2ZmE8dB3U4JgqbadTQtyb45K+RpS0V6V1PH6nFxtwTFmJuPfRiGnOwyILJUaXvrdPbjPMd6O7GPynBscnN5k/8GhsRWSvY5F7xTm55ibe0FwvyFtq0N5LYSnB46CVCU
 FfFwgrqX
 XEnoredMvIbvlaU/0gHIyslkrlh/j+nHRKx6sEq8MOiutY6ETKTW9JuE4Fic2gGLquht21rPCM+HG0akDTrCaYTv01BLj6yOe0M93CF1yAQlu+KaJhYUNqlq48pwjl6xGGS9uMYm5R2HLU0X+y72i23pVwlploUS6pv3Kblfz52+ktWQwRn7IqZ+oGijjVw5I8rShpv7xR8yNKbLfd3QFSZq+WYOflOzSrxe1QUEk4TUIUCJws1K5+9QhSQWXw/a8wMICgHW1w75OTAD06fB6tbsiduBQSaslmwiDnAHpa1wPqJhJPn5r/hDcaUGCNjxS9KrDZrQB+a/5YkjfO2y0Dq3Jbzgi8TYFE0y+NI3XCPyWaJ4gC1rtMg4AqO2WKS2buUVSkK0QQNUS2Y28gYBfCXKN07gBMPMg3kkOtS5K+3FQGatb8AuPlyYl4RUGGN5SEZdcT+ezprnB7mNxPNtetShh6VZNypQGX6JjuwKGZASr81E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This is v4 of Kairui's swap priority queue RFC [1, 2], retaining the
original authorship. It separates device selection from device-local
cluster allocation to support integration with the ongoing swap tier
work, while preserving existing swap priorities, the swapon interface,
and memcg swap accounting and limits.

The global per-CPU cluster cache couples device choice to cluster
locality. Moving that cache below device selection gives each device its
own allocation hints. The available plist's shared rotation is then
replaced by a priority-ordered array of same-priority device rings, with
per-CPU starting offsets and quotas. A task-local cursor keeps each retry
walk stable. Rotational devices retain per-device sequential hints shared
across CPUs.

This remains an RFC. The current scope is global device selection under
existing priorities; no tier ABI or per-memcg device-selection control
is introduced.

The series is organized as follows:

  01-04: Parameter/error-path cleanup, device-state boundaries and
         iteration helpers.
  05-07: Locking, writer-serialized publication and accounting.
  08:    Restore per-device per-CPU cluster locality.
  09:    Keep cluster metadata population out of direct reclaim.
  10-11: Introduce the safely published queue and remove the avail plist.
  12:    Bound order-0 synchronous discard outside the allocation reader.
  13-14: Preserve priority-aware throttle selection while removing the
         active plist and unused plist_requeue API.
  15-18: Reuse reader capacity, advance cursors directly, bypass singleton
         rotation and redistribute reader phases on membership changes.

Changes in v4
=============
The device-disable and discard paths have been revised following the
review of v3 [4], including Sashiko feedback [5, 6]:

- Complete writable/off-list/availability transitions before releasing
  the management lock or topology writer, including intermediate patches.
- Run bounded order-0 synchronous discard outside the allocation reader,
  holding a live device reference across I/O, then restart selection with
  a fresh cursor.
- Handle discard queued by late reclaim scans, with at most one
  synchronous cluster discard per swap type for each order-0 request.
  Preserve large-folio same-priority retry and split handling without
  foreground synchronous discard.

Rebase
======
The series is now based on mm-unstable 24231596edf2 (7.4-rc1).
The base includes 53a6f71c147a ("mm, swap: stop cluster list scans once
swapoff clears SWP_WRITEOK"), so the former standalone scan fix is no
longer required as a prerequisite. Its si->lock serialization of
WRITEOK changes is preserved.

The metadata allocation paths have been adapted to the upstream
allocator-lock reacquisition and publish-after-revalidation contract,
including -EAGAIN handling and the tableless-cluster relocation guard.
The upstream free-cluster preference and hibernation-slot semantics
are retained.

Test results
============
The tests compare the unpatched baseline 24231596edf2 with the same
baseline plus all 18 patches, fbb87083afcc, on the same x86-64 host.
The kernel configurations differ only in LOCALVERSION.

The kernel-build tests follow the v1 workload: eight 8-GiB ZRAM devices,
make -j96, and 12 fresh-output builds per revision in each of the 2-GiB
and 3-GiB memcgs. Both revisions built the same workload source
(4dbe24720eb3), using x86 defconfig, bzImage/modules and a fixed toolchain.

The BRD case used twelve 8-GiB devices and a memcg with 24 GiB of memory,
64 GiB of swap allowance and memory.zswap.max=0:

  usemem --init-time -O -y -x -n 32 1536M

There was one complete BRD invocation per revision. The BRD capacity and
memcg limit are host adaptations; v1 did not specify those parameters.

Mean system CPU time, seconds:

                         n/arm       Before    Queue (v4)     change
  kbuild, 2-GiB             12     4372.4983    4417.2192     +1.02%
  kbuild, 3-GiB             12     2314.6025    2322.6550     +0.35%
  12-BRD                     1      143.5700     137.9900     -3.89%

Mean elapsed time, seconds:

                         n/arm       Before    Queue (v4)     change
  kbuild, 2-GiB             12      168.8092     169.1100     +0.18%
  kbuild, 3-GiB             12      136.0650     136.3500     +0.21%
  12-BRD                     1        6.6500       6.5100     -2.11%

For the BRD invocation, mapped throughput was 7391.28 -> 7550.23 MiB/s
(+2.15%), calculated as the requested 48 GiB divided by elapsed time,
not as a sum of worker rates.

All 50 invocations completed successfully, reported no memcg OOM events
and performed swap I/O. There were no warm-ups or profiling, and all
samples are included. Before ran first on a separate boot; the 12 builds
are within-boot repeats, and the 32 BRD workers are one invocation.

The kernel-build runs show small increases in system CPU and elapsed
time. These descriptive results do not establish equivalence, absence
of regressions or a stable performance gain.

Cooperation with swap tiers
==========================
Device-local cluster hints remain below device selection, so a future
tier policy can determine the eligible candidates before those hints
are used.

The current revision keeps the refactoring under the existing global
swap priority model. Integration with Youngjun's tier infrastructure [3]
remains follow-up work. Device membership, swapon/swapoff publication
and lifetime should have one agreed authority. Within-tier priority
semantics and reader scope need agreement with that work; this series
does not define a competing tier or memcg policy.

Youngjun and Chris, I would appreciate your feedback on the integration
boundary and ordering.

Link: https://lore.kernel.org/all/20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com/ [1]
Link: https://lore.kernel.org/all/20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com/ [2]
Link: https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/ [3]
Link: https://lore.kernel.org/all/cover.1793106426.git.lianux.mm@gmail.com/ [4]
Link: https://lore.kernel.org/all/sashiko-outbox-188132@kernel.org/ [5]
Link: https://lore.kernel.org/all/sashiko-outbox-188141@kernel.org/ [6]

base-commit: 24231596edf2c9d5269d8efbc7007512026672f5

Best regards,
Lian Wang

