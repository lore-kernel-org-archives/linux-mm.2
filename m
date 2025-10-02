Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7215ACAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57CD8E000B; Thu,  2 Oct 2025 03:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FD18E0002; Thu,  2 Oct 2025 03:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DCF8E000B; Thu,  2 Oct 2025 03:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9126D8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:52:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 588DD86450
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:52:15 +0000 (UTC)
X-FDA: 83952406230.05.1082942
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 39D0740004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:52:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=lHyyTKHM;
	spf=pass (imf17.hostedemail.com: domain of "prvs=363256128=acsjakub@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=363256128=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759391533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2SGvgtfExrVMKD6QFwY+i2a9wnruIxOwASxfKxqf6S8=;
	b=PL+QFV0OZgFTKWvzqTO6O3qr/g+QYyUbCKdM1/BnXgB7A9Lescv2pUwm6OaImYrrqd2EzB
	8a5GqV4HJfxp1TQr17kTM/8m9dt8UI2f6gfBaWTU4hysbtlEVcd1HrJ072knpxD3YATeXY
	kJNRaztCCy2KqWyULfgdZxKUUFO0MQU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=lHyyTKHM;
	spf=pass (imf17.hostedemail.com: domain of "prvs=363256128=acsjakub@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=363256128=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759391533; a=rsa-sha256;
	cv=none;
	b=lpXEenwTzTEfmVW5EWBt4EIIdg+wwWejBvdJKHSR4LgHvHdmeruDVdfAjAgJMRqavYyauM
	ZKTvcZRSCR1BS32AEQDN5/xe6pN4jel5Gjc+I0VVV2aflzCfAvFuKxzVl9vJ47kk9N4oa4
	fM1b0KNVsE0tPmclDbtnwNnZfiiQjZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759391533; x=1790927533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2SGvgtfExrVMKD6QFwY+i2a9wnruIxOwASxfKxqf6S8=;
  b=lHyyTKHMyKILxgGICHNtJvrSY5gAj2ernYm8bTTDq8SnDjM2B3J0hNu3
   a7w5P30+8Kplrb+eKAbuR655/9BOZKrnyhevbpT4SeZexOG9I0JQcVGRh
   S2H1lGzegduP0N/e7UqyH38TOrUHzx7nF/niMhPoylRT1TkUKa2RzUq8i
   ik+kT9HLQ6J31zZW4GxI9182donavLVQ/zrAJI9PHW51Greyjc/kDL/AV
   Xx+WEYLbuQdEaOqcXhh0NlFcJ0FRoPJgWbHFlbJ3RYw/u+vbbZKAFRGcG
   uUazTGJVBO8Hqgl0MnwZvwEszc0kRE2NfTraw7GkJ2M2ZMqmgt0j29Tds
   A==;
X-CSE-ConnectionGUID: hzfbE5ZsTnCi/kS8l7dAKg==
X-CSE-MsgGUID: fDs/5FZ+T2Smfxg1JTMupw==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4137127"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 07:52:10 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:24445]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.71:2525] with esmtp (Farcaster)
 id 4a555600-ee08-4b41-952a-f943cb84732e; Thu, 2 Oct 2025 07:52:10 +0000 (UTC)
X-Farcaster-Flow-ID: 4a555600-ee08-4b41-952a-f943cb84732e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 07:52:10 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 07:52:08 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-fsdevel@vger.kernel.org>
CC: <acsjakub@amazon.de>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
	<chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>, Axel Rasmussen
	<axelrasmussen@google.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4] mm: redefine VM_* flag constants with BIT()
Date: Thu, 2 Oct 2025 07:52:02 +0000
Message-ID: <20251002075202.11306-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 39D0740004
X-Stat-Signature: pu7mhtmauuz6tux3tyatt176rym3cw7i
X-HE-Tag: 1759391533-309976
X-HE-Meta: U2FsdGVkX18qO2+c8a+8Ov65Lh/aIh01gnh+Kjgbfj0X0ULT8yYsrk/bSKc/YodCr+l94lfMqUKB/3flHh7+LzlmNAXt0fPnH2TgnFILNjl1S425O25MR9g4vD/mGQZUsh5ibcSDUgh6CtUWT8EJJSJqZpgWHm1lLaEp33b2hl6tPqTxfs0hYFmhxW4Xj4XlUar3pX3N9izO9/DRthCoaIjZlHRakxaRmd6nekBWGnQSF5pjVsrCsSVWMr4yWOoVp8Jv7GqCJ+1Yx7hJ7TzrChpvxCnwQQCa7IBoJQ728BZwOvYSDQsK9oEd3KvMQ7c9eEKoD1+xh0do2KNfCrg4eM+9IhqdwphtitZsP2wFs+uIyYYDgCb9uoPhdbL7Qtdj6Som/HoeRtYUtCCzrbiLw0/bEX19E3EXl7H29ZI4IyncGagMIn+EGp9UV2iSRdo/4Ma8ldrN00BXg7vwsX5jssD+XVbeCWmHxuidph+o4XefRnZ4trgyiq+Q3dj9UH8hVMIgR1ER6Z3lKQ5httYRp0FFuHM34bGQ8FdwMDryskXthnOMh17ufCJj3u9yiSMHRR5L8Ip58QsMxLJyJazcYwcS1N+XWNt8NoH5X5cCENVoX2Pk15MzKGxcM4NHnOISKhed+MS6YixNOZqd6s0jBMr9C72UrOvdtWx8tbDZHGDmussyUaZBHKgUD20eo6MtP02MhCSLmXTs5t3onNNyKaj+Cml/in6tdUt1lZKVszyeCpJwkWlGuWS8IuIGIl80u/DNcLJ7lLRxrFumwBwGEyEVbPAi+gUa+HFvkf0iEhxW88sahP+e+8tGz/sUwTvUtSlrMpTEOU9hYtf864uX/8MbMQ32oPWMYvBJ/J9zTefLWX0Jfu/3snvIgNgNyHvTRCdVwXbJ/kVyNFQivZXYcJpGvBOlO9iExAhTACNTUmk/dbjjFwiVCs0AFDB/To0uMLVqRJq1nT1aI9UZuWh
 LVYU2Mba
 jBwiXpN6gULumxgtrmMj2EMXLOBz++FGxiVUQkhcL8mwgrnBkat1Dh5x8Jk/nIdLQhhQtzrPwURvFKFrF5zmqy1qaPZDzWc+gJKPSQS4qWI3/KF9HXNMNr1jgbl+B/cYLmrNo/RhFqBaXmRdGf6+sylUoulJzpgobKN5S82kdf7OtRGbmQ14ss8z0+8kCnFGaE3BC+LQvISg9jDCg6MUczMKKfZlS1wwFVI1rWUxMRfPsNjeW//J15xVGFAnpk58K/nhIHBA5Tds8NplXAIfhOVDJmcJhS2SUNBwPi0cXhEQy/H4K1YG0hWYOUIwW8Vj31WGMIBwHnLoGbQ/GmnQqf+eTBA6lheUz6BgHgNNraVxn0E5ERqoA8YzqM45epTDOZwlumeOAaKu0yN45N31VQxopbcILQVYEObQPop84tcHKMaBDQgDLr9xq8GH8E0l+LP+GzcffwQUwqWrxZkLf71woXfhlsIjIiQudaMyUdhMA7xnqPMecgeMLy8tYYrKM5a19R3S23lssAUcYKhPzWq2bW0G/JIBhh0c0nksVxRefaFArUhO9RdM7vijByfE29qy+kJCuD60PXAACbP7KDKfM5tN4k7gl9ehwse0Q5Q82ETNSb9BVZUNDBAnrfqN5u+HYlqsukoBJ/6c50OtYO7VVHW5zCMu7DZJdHFAcChQoDXqr06v5kKLIyaMBG0yET5eDxtwJxseaIC12n0vtvN5dC5MpwVJvAMBz2cNbrfBkeGuxvzdhN4QpyWlpZvdQFJpOPm0hs0rwlFWksZKNYlp5iTz+sVchHGnqa4/IL8WMh7jIYV66O699wA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make VM_* flag constant definitions consistent - unify all to use BIT()
macro.

We have previously changed VM_MERGEABLE in a separate bugfix. This is a
follow-up to make all the VM_* flag constant definitions consistent, as
suggested by David in [1].

[1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/

Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
v3 -> v4:
 - fix VM_MAYOVERLAY and VM_PFNMAP definitions
 - send outside the series

This depends on the following patch:
https://lore.kernel.org/all/20251001090353.57523-2-acsjakub@amazon.de/

v3: https://lore.kernel.org/all/20251001090353.57523-3-acsjakub@amazon.de/

 include/linux/mm.h | 66 +++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c6794d0e24eb..cb33f967d327 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -246,56 +246,56 @@ extern unsigned int kobjsize(const void *objp);
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0x00000000
+#define VM_NONE		0
 
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+#define VM_READ		BIT(0)		/* currently active flags */
+#define VM_WRITE	BIT(1)
+#define VM_EXEC		BIT(2)
+#define VM_SHARED	BIT(3)
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
+#define VM_MAYWRITE	BIT(5)
+#define VM_MAYEXEC	BIT(6)
+#define VM_MAYSHARE	BIT(7)
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
 #else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+#define VM_MAYOVERLAY	BIT(9)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
+#define VM_PFNMAP	BIT(10)		/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
 
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
+#define VM_LOCKED	BIT(13)
+#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
 
 					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
-
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_SYNC		0x00800000	/* Synchronous page faults */
-#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
+#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
+
+#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
+#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
+#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
+#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
+#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
+#define VM_SYNC		BIT(23)		/* Synchronous page faults */
+#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
+#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
+#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
 #else
 # define VM_SOFTDIRTY	0
 #endif
 
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
+#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
+#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
+#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


