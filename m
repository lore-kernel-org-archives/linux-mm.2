Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F340F94CA5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 18:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812476B0089; Tue, 21 Apr 2026 14:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4026B008A; Tue, 21 Apr 2026 14:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2836B008C; Tue, 21 Apr 2026 14:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCA56B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:30:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF203C46F3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:30:22 +0000 (UTC)
X-FDA: 84683403084.29.4723B85
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C92440012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:30:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F9k32hcQ;
	spf=pass (imf12.hostedemail.com: domain of 3O8LnaQcKCLQjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3O8LnaQcKCLQjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776796221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I7gCU+7+MVJ8oLDIS9623dDF2RYQtZ2sejtpCDF2UxY=;
	b=73sHTuDbWi8yI2ihV5JiLu4Rk3tNvjbKzJLzg8G3w6NOPoTb9cykj1HDzwfh3Rhqq2OfPf
	kVsSSD6AejmO0xaZCfWwmDnFQTM6FvcLnnTosz8xBqxTl4tvNUdTLlhnZdiiaxi1y6mMM0
	u7WP7EPdwOe+P4lpT3+kNpz1+JQJUCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776796221; a=rsa-sha256;
	cv=none;
	b=d5V1T8etAWk1z/4YgHq5y46xT7K70v3gzaEvv4EGFIKTV4XwqYmAHiwu4b1YIFaYVcAJMa
	tJWlGDq8aC8uvaOX3+EO6beYXEwRmzww/grftt4qtXPh4BG4cT0hshNoSoVfpYFL7DrkW2
	jVFBnIF+tA+K3Z+NPdT0YSxpFuSD8nA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F9k32hcQ;
	spf=pass (imf12.hostedemail.com: domain of 3O8LnaQcKCLQjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3O8LnaQcKCLQjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ddd8ef5343so4379624eec.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776796220; x=1777401020; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I7gCU+7+MVJ8oLDIS9623dDF2RYQtZ2sejtpCDF2UxY=;
        b=F9k32hcQu3tZbT3IflAFJUVsbdzmIKKlL8xWY5NDasZEwruRumfVoskBKHwVtTe2YG
         gIdMO6JP5rVMDMVdBcqWRfAzbm7SU0o1uJRHBZsPiEF7xIoTO0tADD4PQxX/NqRoJkE3
         Zfy5Nl6Kz3s2eLqKE0oX52qebEl2m1MLGD1Rf2BRTVbxVhr6RjeHkZNXVoIgW7KENmKZ
         CTb2k9EPxJvPYimw2J0L+jEStOGp3LV+GfLfayBGUK+u9KlQbB2E6lSChYuz7wxcHCGg
         YJnxRsLNjsanfoGBD663nOznIKBce2qMXkh0SiOcQFYrK2Qn6DUNxiO+51LH4oY3j6dK
         W6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776796220; x=1777401020;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7gCU+7+MVJ8oLDIS9623dDF2RYQtZ2sejtpCDF2UxY=;
        b=cu2kgYjFKK4WvajHxXiK7GDg2YakuNcb4QaZPNWEszeMdXM5kgb+WlfCvnx6z/s47/
         eZIbQw7n/qbIzWMCbFUkrM/Z7M3K7dGJzHAJ68phV58NXgxgfhXfbF/SJhiXFJnxdwMB
         QxDjvHox42e5uiJcxatp3djt2jaShW49k0rHRcrf91vV2maAub75QEyjlU80fIgdXeUU
         3qNhbjnkMebeKTD8NQOJJlFF7DPeEBNTI8oo4nZ3FmZqWxvf3O0OSedPbAnXrDwPkxm4
         IZhvDrBKIbTee/mXsn6xuOA/f2BO67PdlNY+M1iTIm8uBnjN25Gx0ibNRiQN8Oi+IPs7
         G4sw==
X-Forwarded-Encrypted: i=1; AFNElJ8bqsM9vhlQSm6FMeL5Ij6gry8DeM6ZZBUFqIkwPutIyvQvwF1Vki9xtg9KMFErj/utLFELddyoIg==@kvack.org
X-Gm-Message-State: AOJu0YyeifIKml9CtacuKFm2N963dD+u8XDrtgjR/+7E7YdyCKFlzEBt
	cgcWs/CB4W41Y54Sh8BRl0WlYbFqLPYO1lv6XNY2phmkzqWUspVDXjND+85uMHK1MqpwHyDvHeQ
	V/nENp2bOCw==
X-Received: from dyclw17.prod.google.com ([2002:a05:693c:2111:b0:2d9:472c:9184])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:d70d:b0:2d3:f3fc:bb6b
 with SMTP id 5a478bee46e88-2e4646cca96mr11336030eec.1.1776796219319; Tue, 21
 Apr 2026 11:30:19 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:30:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421183000.1541546-1-pratmal@google.com>
Subject: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: akpm@linux-foundation.org, shuah@kernel.org
Cc: yosryahmed@google.com, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3C92440012
X-Rspamd-Server: rspam07
X-Stat-Signature: dfwxrwze1nwwrj9icfttud4gjg3153r4
X-Rspam-User: 
X-HE-Tag: 1776796221-296235
X-HE-Meta: U2FsdGVkX18Az3Ra7gNhjb/kMtCxHrNv5/30qiSofg3AxIf4ziam6JVzuSQEZbQrvjTPHHTUbF6YN3CvLxHS1uacSM8k/PTNuDaB9V6sVo81tTIYv8q4Qy1A0XOEkv2x3CoYzEntgDsw5EfYJIUJWdZYnkI/dp+HYMe7lYjfEiDhlyh/I8GXTSpuwk/9MDY19n4yxo6ISeVH1kJo/LLtnkyJI2soHJTm68dSyhyf7vFd1VlqFTdbmSiDqZDlFFeneKnvza2EM/Yek8H52zYJV5bP2DT211dXR58238oyIaMhV4KjmNk/gg6SKaeN66PrbYcq59UG+aoltqczehJ/xhyCvlZdts2cK8jtI3wsfWOLTdV0odoTvCb9zADQ4XEu9L/fsgd/eIiDlgyFTVmG9ii0h8426YPXIyL77v+cejL6ivXQkze0NXFLIo08q52y99KvCwxk3LkQqbi3PHBCD0YYQIwp8lgIPIgXzdY/ZlbdVzcUiXML2eP/l3OCHZW58hm9fLRTmjORr5/ARhBG3YkDIZNbmGM0BeecFy2Uu7BG3rtiyiD680oaNda3cO+BAl1bICSWYNv4jC44PgrvFkGX562UZXE7BM3NxUvXTr6qfbOux0TlV8lRmv3n7XxHCkmXLIkrK5Yggu7dayL47XgT5bQHXsja+EtTvOQwHf0YKqeKXRNdURtdqjqZreu5VkbXlfiqKd6E+6pixy5VCj3xLWe0ebAt+WJmynA+gpcWL97lNPQW2gfrabWwjum5/ZDl8sKIefMdVZ+PO3b91EHwAPIQXqhcvWKBT3gEF+Oh5DzrlW5pYW623q/QBF/uxBRMOHlOXPNiMlZgEOJEYlJ+NFfLeVHuDYofXAxUM1q5OSRW94g0pPKI6oHbBnZ2bTQC1DH2jBMw5Z7gIF1Oifq2498PbvXbSBa8oCtq1DD/QE/bc9rajw9exaphUPawiWtfhHA9QDy7atKo28S
 9ls9RLNW
 39PwVOiYE/P76N2GxJBUEiNzaSKNeHURseWqwYU2JtcO1zMKYUw5w/mc/w6artecIWrPivYvUOcE+p/puXrbMZhV5mejwJ6bKGmA4OfSJE1IqrouGv8pO+T7nz9XjwYNcoPXFaR0JqTKhKAiC+spYmXWQMWoeeYQwkY3Aio1sS3AVxrMFvehNbq8dhzgqQkMaDjVRSksXNhmLPea7COSl62Fna7Np4++Jz/CnHMzWbAv5c6yFlKfnkxwhOSbk7IiKD5hXLkGa4FfDMl0ZhD4hlx/RUPZz8kIZVM3NeLvuHDNivlp8IvHRgpWI23/kOrpraLKDpAsw47KeWffg1EPsLss7nvwvO+S+9HNe0FSXHbxlL4NFkdRPDHvaGeYQmQOx32cYoTpYlgUJJ8Tn3KOBIVJVczuQuCVAbqmLc31vGW9PB4YECt2eb7njq8HKbR9d0DaARJq51uoDAnnbT8u4WAFxQbz3jp5Lih9V/QqOXzfDobecqr3pioUctR6tjOdhbEtcYKtZbPyMNviUKJrHumuZ8BIlAoEHS8AQs+i4jo1XHpgQ5LYs6WXm7faueiq+Lw2c65RNH9x2lTL6PUyJv0ghUAmcU7JVCVAMqndhXRsXZCQHWPcZWo1R3dKsOC3U/+vS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current .gitignore hardcodes each generated test binary by name,
requiring updates every time a new test is added.

Switch to the patten-matching approach similar to KVM:selftests.
Ignore everything by default and then allow source extensions (.c, .h, .sh)
and tracked non-source files.

Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
 tools/testing/selftests/mm/.gitignore | 72 ++++-----------------------
 1 file changed, 11 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 83ad9454dd9d..92f9205d3996 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -1,63 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
-cow
-hugepage-mmap
-hugepage-mremap
-hugepage-shm
-hugepage-vmemmap
-hugetlb-madvise
-hugetlb-read-hwpoison
-hugetlb-soft-offline
-khugepaged
-map_hugetlb
-map_populate
-thuge-gen
-compaction_test
-memory-failure
-migration
-mlock2-tests
-mrelease_test
-mremap_dontunmap
-mremap_test
-on-fault-limit
-transhuge-stress
-pagemap_ioctl
-pfnmap
-process_madv
-*.tmp*
-protection_keys
-protection_keys_32
-protection_keys_64
-madv_populate
-uffd-stress
-uffd-unit-tests
-uffd-wp-mremap
-mlock-intersect-test
-mlock-random-test
-virtual_address_range
-gup_test
-va_128TBswitch
-map_fixed_noreplace
-write_to_hugetlbfs
-hmm-tests
-memfd_secret
-soft-dirty
-split_huge_page_test
-ksm_tests
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
+#Re-ignore generated files
 local_config.h
-local_config.mk
-ksm_functional_tests
-mdwe_test
-gup_longterm
-mkdirty
-va_high_addr_switch
-hugetlb_fault_after_madv
-hugetlb_madv_vs_map
-mseal_test
-droppable
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
-guard-regions
-merge
-prctl_thp_disable
-rmap
+*.mod.c
-- 
2.54.0.rc1.555.g9c883467ad-goog


