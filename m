Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E461F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EF96B00EC; Sun,  5 Apr 2026 08:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F906B00EF; Sun,  5 Apr 2026 08:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E426B00F0; Sun,  5 Apr 2026 08:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0316B00EC
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37823160A69
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:42 +0000 (UTC)
X-FDA: 84624506484.17.4067E6C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67E59160006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KmUR6Lej;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TJ3Bj0XU7cO6WKSJAjWpCQXgVQz+8UMWhX8sNdkyQM=;
	b=qb6V7Cy5KYTfOGvJUoE6SUYa83DL0vLCiu4P580VkVI+B+ZfQsFIi+TOWmpjS/YKU5/Jkw
	vGG1nhICoeuuqwOw4fICeqVySXDTaoC/AkHhraA3N9E3JlLEeh9Jj75D1mCWy3LrM7nOHV
	haO7LqDqyo1EI5tJkm+AA6ApfRx9JoU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KmUR6Lej;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393920; a=rsa-sha256;
	cv=none;
	b=G989VS7JJcDM3zzDj6znEMYNp5NodGWfTFhCcY0icOPQ2cgFms9S9uLEMofMJzuMvxdWh8
	vQM3VCihZUxD9+C1UMbV8Py64cigvUHXTBgwnhYpdqCNSwB3D42a44GCWJug8XnABHd/ij
	Ub3z4tjU3VU+IwkUtn10QSJLVCwOmDI=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso2820032a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393919; x=1775998719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TJ3Bj0XU7cO6WKSJAjWpCQXgVQz+8UMWhX8sNdkyQM=;
        b=KmUR6LejPRMK08b9VJuvdTLxE6IccjaiFNOcU23xQ29VKq0pa8muvA4/pUF0kNwtuw
         BZI0vNb1FfzmEIDfyBNGcylNmdec7utN6wd8ZgTnS5461oY5M4CJ6MngZW31NOX29KOu
         4XPHQFtxK+29QE4coDHY3wQHIg/Yf/pEKnLsEPznxJqmv5jAYlEunVHJ1MsjktxOJefp
         bfNuEkwLt75UIr7tRpLnxnh/lhOMhkqYFU4Opq/AvA+mOWeQmFwQItzZz/jMyi8k9Sff
         2sINeKnHxiATJ5z8vZN9uQHZv1wbz/DRxkiuGB1XNKpZ2l9WOD+flGEolFy6/u4EQX4L
         Hu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393919; x=1775998719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4TJ3Bj0XU7cO6WKSJAjWpCQXgVQz+8UMWhX8sNdkyQM=;
        b=mcGzWUINVM4lF5mjlhhklPDeXEgJiGQNU+WWLUG/Rg4fYSNIfT+alfHJ2bdU/vKbRp
         sM2NOjf/dnfMMHtC7Vk8uFwFtBs5MhHhtzwF2AxSRDPHSX+rhHmg1J5iiV3uwqZ/576n
         vj6ecLts4SGszR3qzUiD5BmPfboimLqvJvlGYyrS7oYAkLT5Lzhi8DnB2LtAIlhNs23n
         N1hDdQnW9Zb+UmbPZYLeZAlbnRc+OzqJOeKMHS2moGxj8x19T1Qh7JShh1THszbOkB5K
         15LKp1wwQnBTMcbcjZD/Nj6Rv35ze57uFL93iqOpDGOAD4LBpA+NEyLq0ZAd6qFODub4
         xnuw==
X-Forwarded-Encrypted: i=1; AJvYcCW4YmbQ5kNRFdJlltjxdx0Jjv1LnL6/q4jOFi1QzX7UekgFofumDdrKRQzOMgwhwvgHDNmR/R72OA==@kvack.org
X-Gm-Message-State: AOJu0YzYIAKbcqvax4oO7p8AXKgKhwVcQtbeAgzSBPwh9V2zDMVC3bcB
	hlzJ+l3n4DRveT8ec5ZHxIe+5qn48QQtkBaV1fM0501kmOlKrTTksR348v+cF93tK6c=
X-Gm-Gg: AeBDiesY2EPQ0nwLwrxixKNhflEqtX+jLLMRvRsmuAYPdjNffDLuVrf7xHJbax1wTek
	TP+G57VuQsfABUl9NoW4e+QQqMhFKpEZEotLj6Ul3oe+jkwnUN7eZS3DtaNoEfh/g3cHfZdy18W
	D1adAtg7tZJxG7B9Vk/KnQmY3rt8xu125N4RJ3k9asvhQ6Diieu8RxrNtz22mz0Vyh712Jv0FuH
	0d46vNeWpgg500dfD40QTPisCr7ZMDcZRFQIdMl+Y0u5r/53HB6QeKOmbGtLyYL7rxg4sQRECJa
	JEfgDEE0SxVCewH3hc1D3LdNBDNj6QbjfRUCErUCs8IjtSku8DDAEdlYHIrKPRW353067WzcOa8
	vIcN8phq8SHV9K91Uk63kHkW7ffG069zNhwSgfh/f7E4ItJLttBvyAVRC5oj7H8XPAMToi4RWWO
	Vh/xuJgTK2dQtqdQjUCRS4+MCLI1ZMA8+z3j9OuKThFlM=
X-Received: by 2002:a17:90b:52c3:b0:35d:a861:36de with SMTP id 98e67ed59e1d1-35de691b394mr9081749a91.24.1775393919158;
        Sun, 05 Apr 2026 05:58:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:38 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 47/49] mm: redefine HVO as Hugepage Vmemmap Optimization
Date: Sun,  5 Apr 2026 20:52:38 +0800
Message-Id: <20260405125240.2558577-48-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67E59160006
X-Stat-Signature: t4prn19oi9xiwcm33khdaqi7zr74q64u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775393920-264973
X-HE-Meta: U2FsdGVkX1/eCYKqHJ+BRhcubBZ/uIFibYhLtTxg5Fyfz2zLsnHgAUH4x2QBDmAjE93TQtB2ZOPitsWqErkpGVePydW14iuaD3A4qXxb/8BMWmXvNCev4boX1kcfJt+ODDN61wPzdtbotb79cszlPrYiCcH5ScvicYi+PsOBkjP8q67JMMq6v/cT5sihjMv/n60RDFBQPiAX/3C/vmH62ILIm2ZNrPrz15RwN8zf/1ZqTkyNJfQc6pE8lxdHfgClJArhoEqZtWOgaVIOTpW1wdflgjfJ3c+oi68KoqVT9piV/5H2PYgUP80ymFGW7jvQ6+oA/b2wCavrbDZs61vy8YXvUJk7gFfSWYA4mn3dpJkdd/OeJRYEAqPRn2uz/EKZ/ImzXEKb9yml1vaK+GDMsf0oVuEjnAc6elh1Ruzp5BmORfG1rm6iDwJYSQWGs6YwnYCX/uEBOXZq/PyHyU7w8910Js48seKQIkrvlB5OqhgKfolumI4H33su/sKPHmzBOZ0qeO3tcmtDDNB2OcfLr1TUlk1S5XmDFflMsy+2S/3Eqfz9zEHYdJO7v8Kd+z3gAfrJeeVoux5fbbIWgkq3lk08U5In4N8giklS/PaPCcgPaPH/aSeZmWN5iTa3GurDAZVsmGVU7okfQcS3ZV/WKUuXNk2Rhpmc/JP/ynbTUJhTTtdgqvqKzHeC+ZelPg018Dqvxlf+TUnP5gMuPETu8AvyzC7wSuoJ/rCUrN+fF8u6lVnAoD6PF1lJFLA91rErhcR/H3ht9SOfMIs8RhDDd64XY99d2+e3DX2lUQglzMMHXHAuj3c6EqjGCbpTpO5nK1FM+ty+Q0ep1iCN7b18N6WpPB/MrL7v/MRv9P51zrIZpSD1fTCiNs2bRgoot3fpL92UAb3J73FAljYF2Fe/owu2NMQ4e2v2E7txlJhxoKjaGilPbnRSZQ2UwxydlyjXsWZAkmQuO/lpkOy5fmd
 o1t3Dovj
 u4vXi0c8pWZkra/lKGYTXaDerTbsANlpPGvEvPsj9KA96sUBlL/U4H7bkZVGuwg8wOzxPGvAWlqn5C0Dx40qSuhqexmLngtcMMJTzcpq3Wq0KCjbfVdLQdL5G+6mjSFBgDoKeif9NVAR33Suewr0Khgx0r6lfC52KM19vkgGSsjS0fRKZ2C2yVCIqgfwyQQO0LloAfgt8LYAk7zTettVLoGBdwoUtwQkAQSu179XKnwDac9ea5JMNuIv54BefjjfZFlIMKH06KV6hzdTKpgP+s//wD6dnSHjGSZtPm++XKskpSPFu6HcI0hl9aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmemmap optimization is a generic method used to save struct page
overhead. Currently, HVO stands for "HugeTLB Vmemmap Optimization",
which strictly ties the concept to the HugeTLB subsystem.

To reflect the general applicability of this technique, redefine HVO
as "Hugepage Vmemmap Optimization" in generalized contexts, and
"Hugepage Vmemmap Optimization for HugeTLB" in contexts strictly
related to the HugeTLB subsystem.

Update all generic references and comments in the codebase to use the
new terminology "Hugepage Vmemmap Optimization", and modify the
HugeTLB-specific ones to "Hugepage Vmemmap Optimization (HVO) for
HugeTLB".

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/admin-guide/sysctl/vm.rst         | 2 +-
 Documentation/mm/vmemmap_dedup.rst              | 2 +-
 fs/Kconfig                                      | 4 ++--
 include/linux/mmzone.h                          | 2 +-
 mm/Kconfig                                      | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1c8a16309270..ae711cd7887d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2125,7 +2125,7 @@ Kernel parameters
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
-			Control if HugeTLB Vmemmap Optimization (HVO) is enabled.
+			Control if Hugepage Vmemmap Optimization (HVO) for HugeTLB is enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (7 * PAGE_SIZE for each 2MB hugetlb page).
 			Format: { on | off (default) }
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..886f5e78686f 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -665,7 +665,7 @@ This knob is not available when the size of 'struct page' (a structure defined
 in include/linux/mm_types.h) is not power of two (an unusual system config could
 result in this).
 
-Enable (set to 1) or disable (set to 0) HugeTLB Vmemmap Optimization (HVO).
+Enable (set to 1) or disable (set to 0) Hugepage Vmemmap Optimization (HVO) for HugeTLB.
 
 Once enabled, the vmemmap pages of subsequent allocation of HugeTLB pages from
 buddy allocator will be optimized (7 pages per 2MB HugeTLB page and 4095 pages
diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 9fa8642ded48..44e80bd2e398 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -8,7 +8,7 @@ A vmemmap diet for HugeTLB and Device DAX
 HugeTLB
 =======
 
-This section is to explain how HugeTLB Vmemmap Optimization (HVO) works.
+This section is to explain how Hugepage Vmemmap Optimization (HVO) for HugeTLB works.
 
 The ``struct page`` structures are used to describe a physical page frame. By
 default, there is a one-to-one mapping from a page frame to its corresponding
diff --git a/fs/Kconfig b/fs/Kconfig
index 9b56a90e13db..0bcd5b5721a8 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -261,11 +261,11 @@ menuconfig HUGETLBFS
 
 if HUGETLBFS
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
-	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
+	bool "Hugepage Vmemmap Optimization (HVO) for HugeTLB defaults to on"
 	default n
 	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
+	  The Hugepage Vmemmap Optimization (HVO) for HugeTLB defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
 endif # HUGETLBFS
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 846a7ee1334f..a6900f585f9b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -97,7 +97,7 @@
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
 /*
- * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * Hugepage Vmemmap Optimization (HVO) requires struct pages of the head page to
  * be naturally aligned with regard to the folio size.
  *
  * HVO which is only active if the size of struct page is a power of 2.
diff --git a/mm/Kconfig b/mm/Kconfig
index 166552d5d69a..33a36e20db3a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -411,7 +411,7 @@ config SPARSEMEM_VMEMMAP
 	  efficient option when sufficient kernel resources are available.
 
 config SPARSEMEM_VMEMMAP_OPTIMIZATION
-	bool "Enable Vmemmap Optimization Infrastructure"
+	bool "Enable Hugepage Vmemmap Optimization (HVO) Infrastructure"
 	default y
 	depends on SPARSEMEM_VMEMMAP
 	help
-- 
2.20.1


