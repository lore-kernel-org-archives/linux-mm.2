Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF584CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660C96B0005; Thu,  4 Jun 2026 23:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611826B0088; Thu,  4 Jun 2026 23:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500776B008A; Thu,  4 Jun 2026 23:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C93F6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:10:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54A02A09CA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:10:25 +0000 (UTC)
X-FDA: 84844380810.26.F6171DC
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C65F40004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:10:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jUGw0dv4;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780629023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1ZEmz9CjR/k1fq+15RyyqofRsMPk5Kd3zOMwojBu/vU=;
	b=KpgjvhFpwYox70nqwp4c/2EdDD62elNXQK0jC1DdQGkcPneha9jSi6Ynkx5Xr0yxaNDOt6
	e+uK/Yyv0FFeRDi745GaKXBJTg70QTekMVBa9tGSB3JBjBRdIb1/DlyvoAgLYlRO1hrCoz
	+8FR43I9Cw+ctH7L2kp7zVoOduHza/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780629023;
	b=eUHrtfqGsGGFHvB+4hSewlQYVlJk80bAOTSKSxJO575HYqk/31BjQabbuBz2zziOPoac/A
	zsddtNX3gDyPd23c+egPa7UNpkBU30zJNboUqVIKstsFDTu53uNdQiUV1PpLpyzNsADG2k
	CC7HEUge2Vp+b61VP2OaBEsO9TBJBzk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jUGw0dv4;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-36b9ec98144so885876a91.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780629022; x=1781233822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZEmz9CjR/k1fq+15RyyqofRsMPk5Kd3zOMwojBu/vU=;
        b=jUGw0dv4c6f78TBeHnn6ngU46KjpQ3JPojLnmrsDlnLLYYrl4Alc+0tZUcVEF70YEg
         vUQjCK3Ms7lb/6tPVCoxjbJ0EM8Gk51ViQLgAuo3ZqU2OQ1DAMykX348MiDChkKEnFVT
         R+z1B+LhN8DEcME6ugeGtdx1rvSUIWLJS1U+CIzaEAMcyDAhS43g1KdgoWpgRa/+J4GV
         0Vq5QSAzlCLM7Cq7YiRqQ0uIiUK61t0TgPz+XBWLbU7B8whT8+bw4//s1sZlsqiOOxQG
         rbBWx/osB2/tR+Kvf8cJv0I0491aOSDR3OXlSjbIo9tt4amfzbw1koucm/QzLt52JLqc
         7v6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780629022; x=1781233822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZEmz9CjR/k1fq+15RyyqofRsMPk5Kd3zOMwojBu/vU=;
        b=N4/hd1Pv33OTzm7u38NRw1VcXmhMbqfSK+wyfFfKa2ZSOAYWVLQtbyVX0gxFImAzE+
         8lm9OJdvtX1717Th3oOuQ+YpL4ceYCdJJHSWbkBGOU44vL+DoBUuwHDewizeTXkbHFHK
         2VcA8SgXVDiySlTbX324ak3K0Kxk821osi8Y72GTdBITLjU9LlUGz01LL/OdOj41v0Sc
         FwxJQu/mMQVkFtLyjMjqgMBcpgzjTSeDB25oSsOZoa96Xbg/ISNhweTTsBSsMJBfDPjy
         Qzc2GwUpAvNTNJ+MXE0kBYrxrwXpdoJdbgH8JsQ4AxDNGnBHZiewUsujGk7zZwn2XsDs
         C/Iw==
X-Forwarded-Encrypted: i=1; AFNElJ8XvCQ6hZHHS9yBRgDgPw+fH9eZZ6XfMVHvHEChBJbnj/wCnv7Y4U6DrticaKKiy1wgVrGr/tRdsg==@kvack.org
X-Gm-Message-State: AOJu0Yyj/7XKGG5rbtgVWY/IMut4dgu8DINCD5B1ZVjtTVeDXpw0iS1I
	zS1Dq0/2RWpmTFFLU/g3wZH/Bdatk/Ttx6vwkzx8vmWWTuj19fzKCnpl
X-Gm-Gg: Acq92OFOV9gSnU03kLSncYTAFz0pNSl6fv1dYHg7ZAagUpQKEkN0z6fGHTUiynHXwoU
	XW7seQbQekqlzi8/tGktSVtU6JEEKVGwLrxTlkF0IDpKj0niLEasP363YjqagFGtSHD8C1vtq6C
	7nmSCMgRDix4uaS20BM1okdZuqByOiX65R1arwuHKMAmMcNM/TEuhYdZS/uh/yEw3Ouuuej5NLk
	nF7z2XJqCKSngMKUtk90CriVP2xnvhdUJUxK/sXQnAdCbzgC6tI61HeGJcAxw8556FJh2fPGJXv
	TF98TxGMQcHgu6QwQFs0cgLaBSq1cP7P/20Qw7q1dbSA60BXvzgmhQdl0331rL+Hlm65NRAVaw0
	9W0JA147fn4zydk3Hm3odOnkjlvelF1kKb6wGcfkw0Ut9KAWCeaGHSibxsVY10dX2BGwuKk+gaZ
	KT+Nm0ECjLAHPGj1TMW/wkltyadLkbzvs=
X-Received: by 2002:a17:90a:fc45:b0:36d:a510:f8eb with SMTP id 98e67ed59e1d1-370eeff1e46mr1595157a91.3.1780629022034;
        Thu, 04 Jun 2026 20:10:22 -0700 (PDT)
Received: from kernel.. ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37133082519sm295006a91.1.2026.06.04.20.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:10:21 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH] Docs/damon: add TLB flush policy document
Date: Fri,  5 Jun 2026 11:10:08 +0800
Message-ID: <20260605031008.397328-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C65F40004
X-Rspam-User: 
X-Stat-Signature: un6h7xttcdhtjroi5atpingh9neino8e
X-Rspamd-Server: rspam08
X-HE-Tag: 1780629023-235635
X-HE-Meta: U2FsdGVkX19ayQz7tBprQ1N2QPYDQYNNoIX8l1Cscxy9WYdRYf9AKQZcZBwFxRe6sSaVzfXYVTRbrcVw+YkjdWG5/BKzfTZYc872r/uNWbwZx+u4K8r0kAaPmaOcpQMJPceEr/gic1URdOoEqBFMRwEYlMlG3o2VrWsBZWfhzMqQXM+a5m+Qtk2Z3R73uQtd0HqDQ4JlTbSPeya2QjJfNJDexqR/eR+/ooOU3Vs3FgqktDtdf5rLA4Ig702cnd8D7nlIFC/jbxNRVJ3pWL/b3RrsGBY+PRElbDSI+Kjq+o5wF99QYkgwAlAsLnbfv1CmyB/9mawYo/kSrMTLlZ8w47/6idqXotn+4f6fdIPC/bmpS6GD8eEiJNvCwyOp8j0SsAc5UzYrpKz8TbIyKNfjCqU7vA5qu8ytDxB7MtGeXZ9CuOuV/LBbzv4s4ELidUY+AI0n3+HZ9CUcUtluTzVTzAX40ypYUZE4aOFd5aagBbE8D4aCHuuGYQROdIWxSHaKouqO5m8KT6/zogBsMq3dCvcFl5u4hfrQSSjfyi6JqHlZYgIzmJzpKQR4UiZScpcX3ElLGa1vKOGD/ScVIGmqOpyCsntJw+5uAFCwNIRUZIX0ie1cOQk2f+7lYT23dJ/wG/m2mBDfNUdplRH9mHB0CMkRIQ6idMnNkA/i1FZkIwk+sFQSwyk4K/hVllvqgskzlYgad4mr6ien30ldrXjCq8Z5aZMYrNJCXgDQEWW2G3l1sx2IGuHcYXeNMo4l5dr9jAfDr/QezDzBfgDS48uWwaRA9vKA5L/FpPwrhMZrvQD75zq1RqDiyXyS2fO8KvZYiK3uD7Ez3UMLAIBOWgZxH3dn2+n+a1/fonWzzYa6Wd4TXS+UgXjxH5bYVTI0JlB4v3nGPmQUianEMK3XVN7wRsZZokBL40UQnoD/NhmuGhxZ+l2liJG4Mt9Nj8lWCZfuvOOANWGoGzyx/xdvQsB
 siXGLJE9
 gioQNnXy/GqS49FYxeKndS9MPVONVKaGUiP4HvU/Lmz4Sjm07cCfh7Vxw3NRsVM+zIMBuGdL0hUQrmJvTuAhS7v4uY9shQLUzCRW8yxBC+TXjFx1BlthHvWBTQCwWk5MX1gBcflhg6q0FemDaGEMhyjjV3vDUgMm3r9K9xVp2Vuz9N2cZKJlGZxo676vuL4u/+6WZ6atq1inLADLcePl7tlEe+dBry8vFhkuj1xObYfGf6R02pFdRWWz8oBhf95sQNjeA4at1Afv3/Gsc7g1lVRaCSaahW6y1/dvKS0X3CILkVqBw/uar8w/UO+ozCRmz34yGzUFZ99Y3OuTWiJ71LA/FGOYJOGQc3vgq58dre6ga3hNnWnxCDkLHRQ3GCTIMKv5YYQLiDvPVJKqO588og7nG/s00FxYMwg7/vgVzgk8spcYeVDyfYAJCsEFfrfxoV4p7zuC6Kp9B13dz7eHYnkTWExe+bqgeDc81d4yVDvUSGFaqMMds5Ryb0gKrsxODrk3RTOsKypZlNH8nBOdvAJGeoRkcS1VflQRDT+jPoG7JYNSH6oFNJCQ6OkU7WGODHpBr+NaPi0Rkkxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

DAMON avoids TLB flushes after clearing PTE Accessed bits for sampling.
The overhead was measured and found significant [1].  Production
workloads with large working sets flush TLB buffers naturally, so
accuracy impact is negligible.

On systems with large TLB buffers and small test workloads, stale TLB
entries persist across sampling intervals and produce false negatives.
This comes up repeatedly on the mailing list and in private inquiries
[2][3].

Add a document on the design decision, trade-offs, test environment
problems, and recommendations.

Link: https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com [1]
Link: https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org [2]
Link: https://lore.kernel.org/all/20260526145034.91594-1-sj@kernel.org [3]

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 Documentation/mm/damon/index.rst     |   1 +
 Documentation/mm/damon/tlb_flush.rst | 131 +++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)
 create mode 100644 Documentation/mm/damon/tlb_flush.rst

diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/index.rst
index 318f6a7bfea4..5e239437dab3 100644
--- a/Documentation/mm/damon/index.rst
+++ b/Documentation/mm/damon/index.rst
@@ -19,6 +19,7 @@ DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
 
    faq
    design
+   tlb_flush
    api
    maintainer-profile
 
diff --git a/Documentation/mm/damon/tlb_flush.rst b/Documentation/mm/damon/tlb_flush.rst
new file mode 100644
index 000000000000..394f7b86102a
--- /dev/null
+++ b/Documentation/mm/damon/tlb_flush.rst
@@ -0,0 +1,131 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================================
+DAMON TLB Flush Policy
+==========================================
+
+:Author: Kunwu Chan <kunwu.chan@gmail.com>
+:Author: Wang Lian <lianux.mm@gmail.com>
+
+Overview
+========
+
+DAMON monitors data access by sampling PTE (Page Table Entry) Accessed bits
+using ``ptep_test_and_clear_young()`` and ``pmdp_test_and_clear_young()``.
+These functions clear the Accessed bit but do **not** flush the TLB
+(Translation Lookaside Buffer).  This is an intentional design choice.
+
+Questions about this behavior come up repeatedly, both on the mailing list
+and in private inquiries.  This document describes the reasoning, the
+trade-offs, and recommendations for users and testers.
+
+Background
+==========
+
+DAMON's access check works as follows:
+
+1. Clear the PTE Accessed bit for a sampled page.
+2. Wait for one ``sampling interval``.
+3. Check if the Accessed bit has been set again by the hardware.
+
+If the bit was set again, the page was accessed during the sampling interval.
+
+On architectures with hardware-managed TLB (e.g., x86, arm64), the CPU may
+cache the Accessed bit state in the TLB.  After DAMON clears the Accessed bit
+in the page table, a stale TLB entry with the old Accessed bit remains in the
+TLB.  When the workload accesses the page, the access hits the stale TLB
+entry and does not trigger a page table walk, so the Accessed bit in the page
+table is not set again.  DAMON therefore fails to detect real accesses on its
+next check, reporting false negatives.
+
+Flushing the TLB after clearing the Accessed bit prevents stale TLB entries
+and eliminates this problem.  Functions such as ``ptep_clear_flush_young()`` and
+``pmdp_clear_flush_young()`` provide this behavior.  However, TLB flushes come
+at a performance cost.
+
+Why DAMON Does Not Flush TLB
+============================
+
+DAMON intentionally avoids TLB flushes to keep monitoring overhead low.
+The decision was made after measuring the performance impact of adding TLB
+flushes to the sampling path.  The measurement showed the overhead is
+significant enough to matter for production use [1]_.
+
+Production workloads typically have large working sets that flush TLB buffers
+anyway through normal memory access patterns.  Stale TLB entries that could
+cause monitoring inaccuracies are evicted by the workload's own memory activity
+before the next sampling interval.  The accuracy impact is therefore negligible in
+production.
+
+The following table summarizes the trade-off:
+
++---------------------+-----------------------------+---------------------------+
+|                     | Without TLB Flush (current) | With TLB Flush            |
++---------------------+-----------------------------+---------------------------+
+| Monitoring Overhead | Low                         | Higher (flush cost)       |
++---------------------+-----------------------------+---------------------------+
+| Accuracy (prod)     | Good                        | Good                      |
++---------------------+-----------------------------+---------------------------+
+| Accuracy (test)     | May degrade                 | Good                      |
++---------------------+-----------------------------+---------------------------+
+
+Impact on Testing and Small Workloads
+=====================================
+
+The lack of TLB flush becomes problematic when the working set is small enough
+to fit entirely within the TLB reach.  This is common in test environments
+and synthetic benchmarks.  In such cases, stale TLB entries persist across
+sampling intervals, so DAMON reports false accesses and monitoring results
+become incorrect.
+
+For example, on a machine with a large TLB buffer, a test workload of a few
+tens of megabytes may never experience TLB eviction.  DAMON's WSS (Working Set
+Size) estimation can report 100% error (all regions reported as accessed,
+or none reported as accessed depending on timing), and DAMOS schemes may never
+trigger correctly.
+
+This issue was observed in DAMON selftests and was addressed by increasing the
+test working set size to simulate production-like conditions, rather than
+changing DAMON's TLB flush behavior [2]_.  The selftest working set size was
+increased up to 160 MiB for this reason.
+
+Recommendations
+===============
+
+For Users
+---------
+
+If you observe unexpected ``nr_accesses`` values or inaccurate working
+set size estimates, the cause is likely stale TLB entries from DAMON's
+sampling without TLB flushes.  This happens when the working set fits
+within the TLB reach, which is uncommon for production workloads but can
+occur with small workloads.  See the For Testers section below for
+how to verify this.
+
+For Testers and Developers
+--------------------------
+
+When writing DAMON tests, ensure the test workload's working set is large
+enough to trigger natural TLB eviction on the target test machine.  The
+exact size depends on the CPU's TLB configuration.  The DAMON selftest for
+WSS estimation uses 160 MiB per region after finding smaller sizes
+unreliable on systems with large TLB buffers [2]_.
+
+For out-of-tree tests, gradually increase the working set size until DAMON
+reports stable and accurate results, then use that size as the baseline for
+subsequent tests on the same hardware.
+
+If DAMON reports unexpectedly high ``nr_accesses`` or empty
+``tried_regions``, the ``diagnose_empty_tried_regions.py`` script from
+DAMON selftests can help determine whether stale TLB entries are the cause.
+
+The existing DAMON selftests follow this approach [2]_.
+
+References
+==========
+
+.. [1] `DAMON TLB flush overhead measurement
+   <https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com/>`_
+
+.. [2] `DAMON selftest: increase working set size for reliable results
+   <https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org/>`_
-- 
2.43.0


