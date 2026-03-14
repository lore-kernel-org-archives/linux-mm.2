Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688A210706E4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF19E6B0089; Sat, 14 Mar 2026 11:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EEF6B008A; Sat, 14 Mar 2026 11:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DD66B008C; Sat, 14 Mar 2026 11:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 892266B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FDB08C2A1
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:25 +0000 (UTC)
X-FDA: 84545042610.15.E8B1345
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4EC622000D
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ipioA9bG;
	spf=pass (imf03.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9NVTfVmb6N0l2OFZbjNDjAuiMDfwEZpK5jgMzMH9pzI=;
	b=dlwegTaLDFjqTfcAQl71JA0Y5DtokEuzJo4KEyjs1IrB2CPlkAoMwkuaSEkISGn9Mnnqof
	+S6Fqa7pTfRZgV3K4zANZbQ1krY/NWRFgAdOillqMXWnAWPZ4hhKcTcZ0szek+fuTh+yUc
	FTMvgC3rHswLqIoYXQ/s7/lPCh1DAj0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ipioA9bG;
	spf=pass (imf03.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501923; a=rsa-sha256;
	cv=none;
	b=OtjMLsUNxMELZeu/TMw9i+57MSS2TlaBnhFn9eR9pCN+5tWT3C8hJ9+lLEtkC6tgFbBF6D
	/R0l+aU800FHloq0oGrXFlno5tgHjsgK+qv9YAb6xcGBsM5VPE9tcm/cq+I5eDhPFvJ8ls
	fRQZRLNw91sJ75/tPfsS0ov3TFafXZ0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439d8dc4ae4so3265503f8f.2
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501922; x=1774106722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9NVTfVmb6N0l2OFZbjNDjAuiMDfwEZpK5jgMzMH9pzI=;
        b=ipioA9bGlA81YP1D7dedAe+nX/MurXdTDihk7JnL9S5TSNzZIISQ8c9w3f6OHw0I16
         B6rjIdMFO1rTsA1niwNKGAk+1ORcn/Pv4pwUUZgBTp/cnpIxUTI9qkX9tgaE+Lg+hKgy
         SgKl4ci+a8JixZcJqQOLr0Ls4Pw+XyuYw/KOqIFEcziJjUO+OhxIG9ngox7ISUIG7Gm3
         BJc+WKoUhHNVQx3YSZd45rcPbIGN4ySE6O6tNCwp3wuheBEUMUrHTyAbWnYZFOBJZL8q
         TBjka7bmnKB1DVHbse4Vm0HZgUuzhWMRNBhFgZVpiRfdSjpKs/sxwo7ZQ0IIyciFZSKn
         Rc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501922; x=1774106722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9NVTfVmb6N0l2OFZbjNDjAuiMDfwEZpK5jgMzMH9pzI=;
        b=c6IfZrCd5/d8m9fnQ7URjoJeyWTaeEEh8bsadAZ43QpAtC8vwfzlo3glgXWmLP4tb6
         o0oQAwwghydwqtblFkJDH/2YIQSXmGtSkzm+pkpG3EBdPhQQTNbfAzK605WNKkraU964
         q7dqgHq1qmoi7sKq0woGTTNLmBpIjpsXirKnBE9+XPeLVGCCWUpx0Zf+ETdtmo6csAtB
         /U0Bf7el+SVRuaqNm2u5kEAKvBW/RCrdD9y9aWnHW27NF15WRSMshYmuPrwP4Bh1qRXG
         PhlR8sm/M/nQTYy0BJZQMYnhUerYy5A0CGUk4VQTKnsrdlDkQNE8xcIeKTW2PPdaCgnV
         HEEA==
X-Gm-Message-State: AOJu0YzeRDsAMMky7So8b4gBqCcD1I4NF6q5FCE9myqoXw2t4g/sQaxV
	n8tvVn0gGLzGuH0SjMILnL640cCxk7yaZw1ecW2bU/FozmIo6Dy/qIxo
X-Gm-Gg: ATEYQzzdPMdAowMI4MAWi50+0nF0AfpGJRhqeupdG36hBZsxDRqpiqiGBTNAJKzyvKL
	uNjlqFpcujTYgR8DJqm5QO/RFi7Cypl30q9+VPDLWASF80iN3SFrUQFBN5CnujiObWE9gKSOuN6
	nsDCax872X5TBTNB06usEJMyk99LWi2e6+rZYW2nYVplGdEhCfhWZl9EyYGZCY3JHQHSRRJrRfH
	xaiewcUlyVbNd2NXQdEMt0oi0e9ZQ2z5O2ni+N1VyNuAJoQDj1k3so9uEZbvSX4fUPOFceNKlSo
	q1+AN2HgrGB85b5A6CDe30mPmvTuP1TEQnf4QQajVesYkbulkNwLW5Yn/BQlQuXyF3Ave0XAnlt
	XCil1GDKpDuWdJhkb/C19BjfhXQ3mP+XRDGR72G9YvUEfRbGux+uM7Ax9JlcJNwobSOfyeXTZkR
	W9syFOgjl9+oBWpp5Qa9Ge0GPUuvGfjgL8E990Q4DkzwNn/9Um8sj3KK1HkAvGh0vYTf3Q8NxHH
	XWOOiOCyEtbs8YHD2LRItopf9Aah3irwYk/IC8Z
X-Received: by 2002:a05:6000:2406:b0:439:b522:37ee with SMTP id ffacd0b85a97d-43a04db4c63mr12781586f8f.27.1773501921112;
        Sat, 14 Mar 2026 08:25:21 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43a0b2e2c71sm11187254f8f.22.2026.03.14.08.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:20 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document the OOM killer
Date: Sat, 14 Mar 2026 16:25:18 +0100
Message-ID: <20260314152518.100194-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EC622000D
X-Stat-Signature: ozgji3z9u5u19ubsp4cputgx7m3kir3e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773501923-460863
X-HE-Meta: U2FsdGVkX1+4XCL0sFrlpc7B026mb14LWmO45mShi2fTHeoHyFZhVEyfpHKxDBwjlICDqvQJRQpt2v8T0cPQ9spIjL/+fZ7zYqNtSCCtgorrQLd+jsEIPHSw1swZpoce2USvfRBle9Om1I5MwOHlvPvYU0cYUtleTVzGDR6ZKcT1ruTDACd/QK2AGYUijSPwBnWHGIKW5/FMjzAhA4NdXBZu+DoSconel5thLD2JEirbHRLqB7vM642ocWbimif7IZU8KpEJy7Ie2vUa9Y/FA54WU725DRdPdVcxwJ/hb8ghIKxRtLEknOa6EokuC8JCYBngdOxFO9B9AS43mfMpJwK90cy6lWUXIRpXdnW7V4T0CFKX9zLHMo0BjEfCydz40bis9xmV5Q5Dr6qRJASXHoRvP9YLJKVVTyKJ0kTPxhkqyG1si9kvFEZ8U0h21am3zmUR/2I7y3Ydi50zeza1sIsyR3U6TmkRChF1xkC/1igAIE7VYF8w9F0Ps0MnPASZIzhi1hzMb5aVBhk96Jmzxu40Mi6tqZvmXNlwb6/1LJiLigqq4MXY/gzGV3BgGJFxJBRsQV6JpCNRgFic+6P9vTltmULKEwLUKE9E1d2J9ggtFGRN+TaooszEp39JmnIEn1+PQ7JBCnFpeX4Qja8hpTVmxwCZi60y1AQHTOMJkuRtlvjfKlxdF9JAY2plaIIuPbvK9f5kvhIa2ME2k6wmNmoiyn/T3/2/Yxz6YW1v8TK7fFOreh2vVzLtufOBgQqPOjX+BRlhisXN0/mq0lSmF9RcQp8BmY/qoUNDeb3SPAqja8n8rYA53YWaJJ+oicYwsM58qcfgpco3SzAXiSohhQPv2bpxuFlZZBZKHQGRtXRKVDGjhC/N5i+4RbnuN5GBB1waC8kLtc4abAHxNwz3sQinkQKpckD5Q7yzKb+yxS2Ol/f8jgJA4HU8CwZ3FD2V55IFXc8CnH/+Y3W1O8q
 l8EBxghc
 GL+oZqn6nRwuckFOdJatoXogYtZZ+uHfHTw6mNohgpUbSF0nRmQb4GLFE7Ww0f8cWEo6VV9ZksF2tkZjvtFeHLmGhCXYQZI0nLCV9hT3dmprifbH1NWPjh+xi1kcYWskNMBVkK0M2GgBjN3EV2LgtHzWbLGf6UuOfGX2sB8ZptgJuQpE3U7bmyD+E/DA4oPFXy7W0Zp7Jz5WjnYyaVkGT4Sp1jt7ZIg3rBh4O47izL2AYbn3hcsobiwbZpqnuAvDgTuHObb65TpV/3ECqNUCIipBkKWCccxC7M5q+RbT0q4Kdm+rJbiGNDrb7Ada+Qag8hHs8NrR6q4/JD8moEHxcCPCaztSRw+KdqRwu2QBv4eC7J7d0Tp69oTNFmdJJcftIG1UOPcRlBx/G0wuMDJX/kEEJWY9Z2cEloX6b/T7NlSESA2lwrgeEE3enHHbv+GB419cldbR/jkqjzj1XOnUgHj5UzFBLCpjozrBSOUBYroLW+ePjv3ov5+NM+86fjTXUJlkXChKKBKuuaLmnAFbQElkvI9kImubJ2GIRWiPcrh1bWLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the oom.rst stub that was created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of the structured
memory management documentation following Mel Gorman's book outline.

Cover the scoring heuristic, allocation constraints, OOM reaper,
process_mrelease syscall, and sysctl knobs.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/oom.rst | 67 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/mm/oom.rst b/Documentation/mm/oom.rst
index 18e9e40c1ec1..2259f871a4a7 100644
--- a/Documentation/mm/oom.rst
+++ b/Documentation/mm/oom.rst
@@ -3,3 +3,70 @@
 ======================
 Out Of Memory Handling
 ======================
+
+When the kernel cannot satisfy a memory allocation after exhausting reclaim,
+compaction, and memory reserves, it invokes the OOM killer to terminate a
+process and free memory.  The implementation is in ``mm/oom_kill.c``.
+
+Victim Selection
+================
+
+The OOM killer scores every eligible process and kills the one with the
+highest score.  The score is the sum of the process's resident pages, swap
+entries, and page table pages.  This sum is then adjusted by the per-process
+``oom_score_adj`` tunable (range -1000 to 1000, default 0), which biases
+the score by ``oom_score_adj * totalpages / 1000``.  Setting
+``oom_score_adj`` to -1000 disables OOM killing for that process entirely.
+
+The ``totalpages`` baseline depends on the allocation constraint:
+
+- **Unconstrained**: all RAM plus swap.
+- **Cpuset**: memory on nodes in the current cpuset.
+- **Memory policy**: memory on nodes in the current mempolicy.
+- **Memory cgroup**: the cgroup's memory limit.
+
+Only processes that can use memory within the constraint are considered.
+Kernel threads and init are never eligible.
+
+OOM Reaper
+==========
+
+Sending SIGKILL does not immediately free memory — the victim must be
+scheduled, unwind its stack, and tear down its address space.  To speed
+this up, the OOM reaper kernel thread (available on MMU systems) proactively
+unmaps the victim's anonymous and private pages without waiting for the
+victim to exit.
+
+The reaper gives the victim a short window to exit naturally before
+intervening.  It walks the victim's VMAs in reverse and calls
+``unmap_page_range()`` to release physical pages.  Once reaping completes
+(or is no longer possible), the mm is marked ``MMF_OOM_SKIP`` so the OOM
+killer skips it in future invocations.
+
+Before reaping, the mm is marked ``MMF_UNSTABLE`` to signal page fault
+handlers that private mappings may have been zeroed and are no longer
+reliable.
+
+process_mrelease
+================
+
+The ``process_mrelease(pidfd, flags)`` system call lets userspace OOM
+managers (such as systemd-oomd or Android's lmkd) trigger the same reaping
+mechanism on a dying process without waiting for the kernel OOM killer.
+It operates on a process that is already exiting and performs the same
+address space teardown that the OOM reaper would.
+
+Sysctl Knobs
+============
+
+``vm.panic_on_oom``
+  0 (default): kill a process.  1: panic on unconstrained OOM only.
+  2: always panic.
+
+``vm.oom_kill_allocating_task``
+  When non-zero, kill the task that triggered the OOM rather than scanning
+  for the largest process.
+
+``vm.oom_dump_tasks``
+  When non-zero (default), dump a table of all eligible tasks and their
+  memory usage to the kernel log before killing.
-- 
2.53.0


