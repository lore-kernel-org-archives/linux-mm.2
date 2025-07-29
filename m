Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD5AC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F288E0003; Tue, 29 Jul 2025 05:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7578E0001; Tue, 29 Jul 2025 05:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D0D8E0003; Tue, 29 Jul 2025 05:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E13F98E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:18:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B1F2113C06
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:36 +0000 (UTC)
X-FDA: 83716751832.18.57C6E6A
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id A5DA840002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mnCZLncu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppiLymWvZQZKoAHwo2gHS7E6txIDm0zCCExLuiUeMEc=;
	b=ERQtohCn3RD+1f/zkdB7O72lovJgVVYWg1ssWfuYmylzI1RYjotfyRdxLfgpQDBYPLfjnR
	xoKkELACHGooGnhm5VCnaLTVxlEr7zNCIDYQpWdBy0f16DytjHhTiVIamqGDRcY79UM/cm
	UfLWtlKj10M/el6hkXcwZrpYOQunL+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780714; a=rsa-sha256;
	cv=none;
	b=mX5cfnn1FV5T/9xUbUUPwomGoyrWlNC+H1/nj556R7j62Sedf9wjrXBTmKsyPobYnvgQVk
	vj8EC9a/F6aa+IockjSeG4c3w+LyvuH++pnu4UayYCu/jBkAqAwAhuNN4tZeaDFRWS7VQo
	4hzcNYkeH4Ao9w/49ZE0nLw+12dVQKQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mnCZLncu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2403ca0313aso15561375ad.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780713; x=1754385513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppiLymWvZQZKoAHwo2gHS7E6txIDm0zCCExLuiUeMEc=;
        b=mnCZLncuGXFaorwc2kc3kOcbStlkBe1KxjV4p5E5M8y960+RXdgXJ8OPvjiRswQ151
         w/9UodDNBD4lJYzK8ahpaolA/P2rserAounmPa4EL3fLMyOyRe1v8z0PUbFmrGJDj9xI
         ulNvaDs7yvdac65TeLe4W+YH43rL1ydP+isFsR0eWLoB+XoX0/EdVDxJQREf+17v0S35
         Cx99rZ44Q/eb2qy+Qqg4QG+RNHUhFGYpH0rkT/uEDSHM1iYswvYwimlLouYJPMPdMBHl
         o43If5awxfRSmt4MfuD6F01S9hgskJGlvJjbF3OepRrqzmZv1uC7413V8Qj40OQ76KCI
         zFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780713; x=1754385513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ppiLymWvZQZKoAHwo2gHS7E6txIDm0zCCExLuiUeMEc=;
        b=UplPOWZYVZk0RGWbMHYYmXNht5ls5gqkVNZYTuSiwi4or2DO87+d+scDEeG4GcIzWZ
         hHgWG4MQBcSwBQA+9DxheJtRNR4Y62V1fmR7ZfKsFdoiNSY+0viN88SsRUrsz079ydgJ
         lzReY5k020p5/GipSGGqXGRqb98uvFtQf2+H0u6fzaDZAS5wcq3EI/0PGTP0i1S9Z6i0
         WdUlnVRfRt4gCPBI7BszvP1L0bO/T2wzKQlBGDxyNSITb5PjLMsZUMhCXoGQknq5KHU7
         xYx8Sp+uN2xxNmRxwiufzfkJNRRNwkcSDw8IPBqOlI89x87CfO3rfDzYqRZcTU8c8IyK
         5JAA==
X-Forwarded-Encrypted: i=1; AJvYcCW6v3LuGribPtredixcBsvDCaNveGbCVO2ViMTqJoyiaqs7d9lWxVuu064gh8qTwj9va90IdJYe2w==@kvack.org
X-Gm-Message-State: AOJu0Ywq3qJo2nd+xaBhHFpzWc8zbtHPhIoOnsxgzk7Fnqc3QTojYwi0
	5fvbjQhUSSYMss4nBxzv+LGZWDYSc/sU5cIC5cV3+PYeLI/vMlGDN5ol
X-Gm-Gg: ASbGnct5Qx5Zdk5s8CC+ZxetROF77lqgV16j6fyHsr2FdIFbSvS29fQa22Mw6D4Mc+4
	Ldwy8ufp1p7jHS5tjhrdWFO9pCdgc0LChjoGm5uTXz8228QPyYuhSeQYmlmDQB0DJ2THhogpT7M
	NPRtV/w33Rt1z2o8SiuaMb4J8PiZTTEUwFv7juGtzUctK+IvZiNI7jM9cea3QrC9PruGkmtBzgx
	Ss7ecCWqqdx2fqwQN5yoBTAMb6T7P6mSyZ2rMBA5D/ZYtz1D5zRyIgIFtgWVjSp1Prsx/kKACO7
	jS5+oDRGqzuMrqPrPgS63QWJmeSAOmoJhrXNuOwFYDkfFD/1BPRVC47bDVL0ez3jOw1XcAtM7B/
	iuEKiSbdUiOK62MzT1/L/LKCdxTow+/EWpgbNEWzJcsushKZp
X-Google-Smtp-Source: AGHT+IEmJR2qDv7n2cDcVzpa6jNA35+tHW9Bqxks2Hupnyp8O0mzOmJEtUetiEJoH+weAU1qoN50AA==
X-Received: by 2002:a17:903:1b6d:b0:23e:ea0:63c0 with SMTP id d9443c01a7336-23fb30e5e90mr226336635ad.41.1753780713322;
        Tue, 29 Jul 2025 02:18:33 -0700 (PDT)
Received: from localhost.localdomain ([101.82.174.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30be01sm74337015ad.39.2025.07.29.02.18.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 02:18:32 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v4 1/4] mm: thp: add support for BPF based THP order selection
Date: Tue, 29 Jul 2025 17:18:04 +0800
Message-Id: <20250729091807.84310-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250729091807.84310-1-laoar.shao@gmail.com>
References: <20250729091807.84310-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8jejkg51efg89yf3wmb5rc1qwmzm3ku4
X-Rspamd-Queue-Id: A5DA840002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753780714-319182
X-HE-Meta: U2FsdGVkX1/FRMzrFbMrKErQiwPKD9aazE4N8KJiitxPr9YreIASlcI9WgHrB0yfE2MvLt2SRN8yMvGbN5/5YXBGh/HW2BKgXPM7DQnUMBCi8UrgyvYK1Ev9CLotm5hXFPdjIhNZBot9t/xC0jLk3/WF1l1QEP1+xHOW7Zs0w9H+ZUNwIMX4+mjunYSyLR9BtX0NpQTYB/sLLD0HjzkWpEU5bYUnhjdRDFu1AlaT99yEM2Ke5f2Ys05SZAu2B5L6W2FkIQEfo2ti7grOkuJUaW44QbZDmhh8kx9nLBwYeJTAAIUipO9PCb6a/LGqbOef+eumRanZLsE/kCMUFfxYZkZvk3T7+lgNR/9KMnJLJWv07uC7HZ/4wZGDQ1OPPwGIOrLr9Ix/PfG4HH42iiTJtW5QXENfSp482fSJQJHrU6Lcqz0lxNz2MOjPebPaVayRBYStRNumD/gsugjPjxz2qDZvrJ7oZDrMEPnPpsvsJM4NIb/BmxQptwlbiYzFxKXL9Uy5F0uUYpjowYTJgOuXhmqDiPiUo95CdZfnEEpnRIFV50mFE5P6sc8rCRvfZkfLplgrtMIJX8Lq+KDACe9fZ0oVHp54XLBFl4N/d6GCNHQ5PgMVd2IkgsmcjlmSsCTtMDC93OOhwRcDLeeS1pJEVVXtu73aofknjuIS1VdMX819w6NruDQKv0An8ci/856ShM1/XkTvHq0D/BNlxr3+iefy3usHYPuN6t4jN+ppFcBqJm9Uqt5UARzjiHzIwhuIZ7fXxr+yUBlNKBHvqAyFb0KCrZQxfjW7VvH8fFAsLCcRZC306yTWw/j3Ow4U6vPPAT7Yy53LwfEp3YH3G4g5l9IJGra+WH5KhUnsnoL7E4YevqnvX6Z2Hz+MekMqszlekev3uY7WNBmsECfBpNUcZt7JBDEyozmHyyB233dDC2xSye8KMtWRBoRc507VuAz0whp0Fg1+g1RPqCf/mQh
 lqgcpgvN
 YO8KHHxz0GSoOKz8++oBqK9OX3g/1qnbhZkOf+T2EFhETpvRP+Kv049MoAvE25AAnzTFm0me8Vq2ZPzosUuiper9jhEyr2VHuqLcgd+3ZpmqMI+AcMCc06K6eMvl/3pknePLQkr3HnraT3bLETJavAYL5M+iHDTfMXt6NE9ccz9H8DVrL4nbKbzFGEfqDGzJ+wDJZlt9MiGc4QnfDc2ZCpF7wOGkkEFvhRRkeEEru0Wtk4qEy+wZKU1aEvSBc9xuDBMhMMDnHAilFkUrBYIIWk4W0hINQu5mcdILgxeNz3JyVNZr/XOvytGFnEQPiVe88Va17Fuxkz09GaqwLAyeljgE6/rQRtll8QNiA9XMh4tYoIckNbT1xxayEjnpVsMsCRHrpx0ojPGWDZ7DLbQsOnznHjREBiKfK6Zl5mlMa5SVrq6Jj4FsnErf7N+RChh1lxJcEdBERmTPCkXog3mOpB9Wn3EpHUQYVxxMNg8WBZN79kY4od0oqbWiLSjny0Rco9Q4IJJ6DEVQ9FxJ6BQzTU7rnYyy1YQXaxnuLCVOHYNhgEgdEGG3TmiCqTWpBmsLkhyGfvvXy3eJMBLQBhs1DLoJGRwM4CPi/6BYikUgthX7ORG/UF9k6efWvirquay97SaODJLOP22iY8fyTVuQPiMXqQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
THP tuning. It includes a hook get_suggested_order() [0], allowing BPF
programs to influence THP order selection based on factors such as:
- Workload identity
  For example, workloads running in specific containers or cgroups.
- Allocation context
  Whether the allocation occurs during a page fault, khugepaged, or other
  paths.
- System memory pressure
  (May require new BPF helpers to accurately assess memory pressure.)

Key Details:
- Only one BPF program can be attached at a time, but it can be updated
  dynamically to adjust the policy.
- Supports automatic mTHP order selection and per-workload THP policies.
- Only functional when THP is set to madise or always.

Experimental Status:
- Requires CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION to enable. [1]
- This feature is unstable and may evolve in future kernel versions.

Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redhat.com/ [0]
Link: https://lwn.net/ml/all/dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local/ [1]

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/huge_mm.h    |  13 +++
 include/linux/khugepaged.h |  12 ++-
 mm/Kconfig                 |  12 +++
 mm/Makefile                |   1 +
 mm/bpf_thp.c               | 172 +++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c           |   9 ++
 mm/khugepaged.c            |  18 +++-
 mm/memory.c                |  14 ++-
 8 files changed, 244 insertions(+), 7 deletions(-)
 create mode 100644 mm/bpf_thp.c

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2f190c90192d..5a1527b3b6f0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -6,6 +6,8 @@
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 #include <linux/kobject.h>
+#include <linux/pgtable.h>
+#include <linux/mm.h>
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -54,6 +56,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
 };
 
 struct kobject;
@@ -190,6 +193,16 @@ static inline bool hugepage_global_always(void)
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
+#ifdef CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION
+int get_suggested_order(struct mm_struct *mm, unsigned long tva_flags, int order);
+#else
+static inline int
+get_suggested_order(struct mm_struct *mm, unsigned long tva_flags, int order)
+{
+	return order;
+}
+#endif
+
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index b8d69cfbb58b..e0242968a020 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
 
+#include <linux/huge_mm.h>
+
 extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
@@ -20,7 +22,15 @@ extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
+	/*
+	 * THP allocation policy can be dynamically modified via BPF. If a
+	 * long-lived task was previously allowed to allocate THP but is no
+	 * longer permitted under the new policy, we must ensure its forked
+	 * child processes also inherit this restriction.
+	 * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
+	 */
+	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags) &&
+	    get_suggested_order(mm, 0, PMD_ORDER) == PMD_ORDER)
 		__khugepaged_enter(mm);
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 781be3240e21..5d05a537ecde 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -908,6 +908,18 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config EXPERIMENTAL_BPF_ORDER_SELECTION
+	bool "BPF-based THP order selection (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
+
+	help
+	  Enable dynamic THP order selection using BPF programs. This
+	  experimental feature allows custom BPF logic to determine optimal
+	  transparent hugepage allocation sizes at runtime.
+
+	  Warning: This feature is unstable and may change in future kernel
+	  versions.
+
 endif # TRANSPARENT_HUGEPAGE
 
 # simple helper to make the code a bit easier to read
diff --git a/mm/Makefile b/mm/Makefile
index 1a7a11d4933d..562525e6a28a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) += bpf_thp.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
new file mode 100644
index 000000000000..10b486dd8bc4
--- /dev/null
+++ b/mm/bpf_thp.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/huge_mm.h>
+#include <linux/khugepaged.h>
+
+struct bpf_thp_ops {
+	/**
+	 * @get_suggested_order: Get the suggested highest THP order for allocation
+	 * @mm: mm_struct associated with the THP allocation
+	 * @tva_flags: TVA flags for current context
+	 *             %TVA_IN_PF: Set when in page fault context
+	 *             Other flags: Reserved for future use
+	 * @order: The highest order being considered for this THP allocation.
+	 *         %PUD_ORDER for PUD-mapped allocations
+	 *         %PMD_ORDER for PMD-mapped allocations
+	 *         %PMD_ORDER - 1 for mTHP allocations
+	 *
+	 * Rerurn: Suggested highest THP order to use for allocation. The returned
+	 * order will never exceed the input @order value.
+	 */
+	int (*get_suggested_order)(struct mm_struct *mm, unsigned long tva_flags, int order) __rcu;
+};
+
+static struct bpf_thp_ops bpf_thp;
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+int get_suggested_order(struct mm_struct *mm, unsigned long tva_flags, int order)
+{
+	int (*bpf_suggested_order)(struct mm_struct *mm, unsigned long tva_flags, int order);
+	int suggested_order = order;
+
+	/* No BPF program is attached */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		      &transparent_hugepage_flags))
+		return suggested_order;
+
+	rcu_read_lock();
+	bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
+	if (!bpf_suggested_order)
+		goto out;
+
+	suggested_order = bpf_suggested_order(mm, tva_flags, order);
+	if (suggested_order > order)
+		suggested_order = order;
+
+out:
+	rcu_read_unlock();
+	return suggested_order;
+}
+
+static bool bpf_thp_ops_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_func_proto *
+bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
+	.get_func_proto = bpf_thp_get_func_proto,
+	.is_valid_access = bpf_thp_ops_is_valid_access,
+};
+
+static int bpf_thp_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_thp_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_thp_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	spin_lock(&thp_ops_lock);
+	if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		&transparent_hugepage_flags)) {
+		spin_unlock(&thp_ops_lock);
+		return -EBUSY;
+	}
+	WARN_ON_ONCE(bpf_thp.get_suggested_order);
+	WRITE_ONCE(bpf_thp.get_suggested_order, ops->get_suggested_order);
+	spin_unlock(&thp_ops_lock);
+	return 0;
+}
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	spin_lock(&thp_ops_lock);
+	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
+	WARN_ON_ONCE(!bpf_thp.get_suggested_order);
+	rcu_replace_pointer(bpf_thp.get_suggested_order, NULL, lockdep_is_held(&thp_ops_lock));
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
+static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *ops = kdata;
+	struct bpf_thp_ops *old = old_kdata;
+
+	if (!ops || !old)
+		return -EINVAL;
+
+	spin_lock(&thp_ops_lock);
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags))
+		goto out;
+	rcu_replace_pointer(bpf_thp.get_suggested_order, ops->get_suggested_order,
+			    lockdep_is_held(&thp_ops_lock));
+
+out:
+	spin_unlock(&thp_ops_lock);
+	synchronize_rcu();
+	return 0;
+}
+
+static int bpf_thp_validate(void *kdata)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	if (!ops->get_suggested_order) {
+		pr_err("bpf_thp: required ops isn't implemented\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int suggested_order(struct mm_struct *mm, unsigned long vm_flags, int order)
+{
+	return order;
+}
+
+static struct bpf_thp_ops __bpf_thp_ops = {
+	.get_suggested_order = suggested_order,
+};
+
+static struct bpf_struct_ops bpf_bpf_thp_ops = {
+	.verifier_ops = &thp_bpf_verifier_ops,
+	.init = bpf_thp_init,
+	.init_member = bpf_thp_init_member,
+	.reg = bpf_thp_reg,
+	.unreg = bpf_thp_unreg,
+	.update = bpf_thp_update,
+	.validate = bpf_thp_validate,
+	.cfi_stubs = &__bpf_thp_ops,
+	.owner = THIS_MODULE,
+	.name = "bpf_thp_ops",
+};
+
+static int __init bpf_thp_ops_init(void)
+{
+	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+
+	if (err)
+		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_thp_ops_init);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d3e66136e41a..e504b601205f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1328,6 +1328,15 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		return ret;
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
+	/*
+	 * This check must occur after khugepaged_enter_vma() because:
+	 * 1. We may permit THP allocation via khugepaged
+	 * 2. While simultaneously disallowing THP allocation
+	 *    during page fault handling
+	 */
+	if (get_suggested_order(vma->vm_mm, TVA_IN_PF, PMD_ORDER) != PMD_ORDER)
+		return VM_FAULT_FALLBACK;
+
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 15203ea7d007..d0b6c1b20342 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -475,7 +475,8 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+					    PMD_ORDER) &&
+		    get_suggested_order(vma->vm_mm, 0, PMD_ORDER) == PMD_ORDER)
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -1448,6 +1449,11 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 		/* khugepaged_mm_lock actually not necessary for the below */
 		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
+	} else if (get_suggested_order(mm, 0, PMD_ORDER) != PMD_ORDER) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
+		mm_slot_free(mm_slot_cache, mm_slot);
 	}
 }
 
@@ -2390,6 +2396,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * the next mm on the list.
 	 */
 	vma = NULL;
+
+	/* If this mm is not suitable for the scan list, we should remove it. */
+	if (get_suggested_order(mm, 0, PMD_ORDER) != PMD_ORDER)
+		goto breakouterloop_mmap_lock;
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
 
@@ -2407,7 +2417,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+					TVA_ENFORCE_SYSFS, PMD_ORDER) ||
+		    get_suggested_order(vma->vm_mm, 0, PMD_ORDER) != PMD_ORDER) {
 skip:
 			progress++;
 			continue;
@@ -2746,6 +2757,9 @@ int madvise_collapse(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
 		return -EINVAL;
 
+	if (get_suggested_order(vma->vm_mm, 0, PMD_ORDER) != PMD_ORDER)
+		return -EINVAL;
+
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
 	if (!cc)
 		return -ENOMEM;
diff --git a/mm/memory.c b/mm/memory.c
index b0cda5aab398..ff3e4c92a2a2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4375,6 +4375,7 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
 static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	int order, suggested_order;
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
@@ -4382,7 +4383,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	spinlock_t *ptl;
 	pte_t *pte;
 	gfp_t gfp;
-	int order;
 
 	/*
 	 * If uffd is active for the vma we need per-page fault fidelity to
@@ -4399,13 +4399,16 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	if (!zswap_never_enabled())
 		goto fallback;
 
+	suggested_order = get_suggested_order(vma->vm_mm, TVA_IN_PF, PMD_ORDER - 1);
+	if (!suggested_order)
+		goto fallback;
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(suggested_order + 1) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -4933,12 +4936,12 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int order, suggested_order;
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
 	pte_t *pte;
 	gfp_t gfp;
-	int order;
 
 	/*
 	 * If uffd is active for the vma we need per-page fault fidelity to
@@ -4947,13 +4950,16 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		goto fallback;
 
+	suggested_order = get_suggested_order(vma->vm_mm, TVA_IN_PF, PMD_ORDER - 1);
+	if (!suggested_order)
+		goto fallback;
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(suggested_order + 1) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
-- 
2.43.5


