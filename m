Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D72CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64A38E0008; Mon,  1 Sep 2025 02:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A388E0006; Mon,  1 Sep 2025 02:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04878E0008; Mon,  1 Sep 2025 02:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEA098E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7847CBAE52
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:41 +0000 (UTC)
X-FDA: 83839662522.25.38EA292
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8EA96180010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=djSYqf4S;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707159; a=rsa-sha256;
	cv=none;
	b=djWp2XCkLfP3Sy0YMwOMeXEpukFbMznGHkASmm4Kya2O7VNG5EHPRXgTVMWE+0xBy7EK0n
	3RNsfHJDch3+qvYBJUwFqaDtbL392UY91XYSYteVOaQqA9VNMAFcpVLitqw8IansBcO2Xw
	rXvARvoj5K81FozsGIcgB+uaPnnHkS8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=djSYqf4S;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR4oy7Zb2IbSctYsSrVgfFfpaXt7ypSRTmIBa0GxRUo=;
	b=EyHWdW3eHH4uWhNWuDE7YmA9V/tr9hTuDmeDAoG6eJ9FHQkjWWS0jVcWwdFg1Iy01wEjsb
	sQwSGtD6tAAhu+tfKLh1Srif4U1YRa735KcTQzVIm16GgDmhuIBXe86XTQgKJFxQ3+Jbxe
	12qU79P95QLIfvysGpiMUpYvzLGKwec=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso6814395a12.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707158; x=1757311958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR4oy7Zb2IbSctYsSrVgfFfpaXt7ypSRTmIBa0GxRUo=;
        b=djSYqf4SfN6SZY9dLNI6zIOi/J3tAxHriNF7wBFkdtAHsmP+zrWVpzy90GzL2WaC3I
         eMqs9seouWGRYTG2ltFQkLGLQofH5M1VcnkYc/FPv2Y5DQISNoooD+ZRa4mu04+Z8ElL
         QtkizkIW9dYzgHBUrbSVLJ2QMTnieBrHJ3AqvYjf2KwXTgcdtuBM4pnGG9LmxTOVt7p+
         X0DobRHWwD1mHtz617I6K7XFrwybyvmlDVLNvY6PvR6VzcBlrPBYkDR+fuQC286DEuEU
         X5IzhUnIEho6uu/ExHlViDD8TvlIV403gEFvUVwYIEvHMToAMW2linfih4WjN1s7UgKc
         cRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707158; x=1757311958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rR4oy7Zb2IbSctYsSrVgfFfpaXt7ypSRTmIBa0GxRUo=;
        b=AYOV5bA8j93F5kBCUghkAAwmmKHnUVPnWDtrDi2IxoHGZhpDoxUYsgphdHBWgcbt7V
         6AyZtxCUWLLeCTNHwhgyZjsYlTE4bLo9ORAyTYKGnjNM8d2Wo89V4qqfBXTtjq0ZdRN3
         Yz1o65i65lZ5oogom5BCj48AA+FolQi8ahVgccc22edhAqAM4RZDE6atCydWnQe1nSmj
         8Cs8cCtWZN+GdzKzts42AHwGKoXl+KLqtp1gVNpJSQTVEtpk2h4l0ZFjUTA99ZL20Pq/
         SkSRTyCCrRR+XADEVXnlpSD8MY9VQE2uGLFfvdgAFS7exFHfBf7x7DUHe38bT4kR2Eqh
         csIw==
X-Forwarded-Encrypted: i=1; AJvYcCVFgVWHt255yOc4P9BdqCgaj66VtwqAbZOXqAsPYWzgOEcVHoK8Ynn8lLh/Zr/2MLa1XJ49v9Jptw==@kvack.org
X-Gm-Message-State: AOJu0Yy+f4Q36i5W+SP+XnlaAKC4ly32pd6HqokgVxKU5vr7DTg310K+
	xNPIdUKwQty+aGo4jTHT/wsUt/+nCegl98Jsh7mb3O5qRP54BJBUSc+FsBBGZoHmiHQ=
X-Gm-Gg: ASbGnctA69L9FSjzTDLq6G6CKbfdr33ZqbPNCmW7QnVYSTJM/Ayp1ynfNjHXz0QZsix
	plj8pfsIHpHmZ6WA0My01z7WKRn0FHrE5tiZPjR318KJxXe5+xn5LDqK+FoIvMkihKUMPdRH1SH
	uKzeaskRdUmil//rulrax1tx2QI3OPCcHgjiAwDRkFzUzWJ/6+fJYRcxtFNraxwV87OZlEWsfay
	gOapy2waHo15Tcz1c8EIp9MvIWdzFbxp+lbh+rBlrPysM5SzofpcgLVqfQpebkr1qWGSpj/ejdC
	dR5rZb9i+zSdkpEt+I5TY4d4O18JNkJXfAyc4f7L6HRDrORF510fN0lz8mW6SEqKT+soqp6yLYW
	QZk2hCOLNYThNIMrju4Ror1G+MGswVsOnQXr9933jPZy78FYQtyr+mWzisqLpHzXFRaxn1V7kNi
	gMDzVMfWqyJ7F9tunQblI6Qw==
X-Google-Smtp-Source: AGHT+IE0vif5vuTCMER8ckouleyP96Gy21extBt5jOZsdMhAFo++wMW7N7bZ+f0Dm6MWmYncMh0vqw==
X-Received: by 2002:a05:6402:5c8:b0:61d:3d89:7826 with SMTP id 4fb4d7f45d1cf-61d3d897bc9mr4041138a12.28.1756707158085;
        Sun, 31 Aug 2025 23:12:38 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:37 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 06/12] mm/util, s390: add `const` to several pointer parameters
Date: Mon,  1 Sep 2025 08:12:17 +0200
Message-ID: <20250901061223.2939097-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EA96180010
X-Stat-Signature: 3xpep19trdw4wh6hwac9unyzxgfuqksn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756707159-133944
X-HE-Meta: U2FsdGVkX1/Shunih5MhMCaQAgLfAtwS88M+gO0O2sL+mTLv0F80SkKJGhb8xsO/MsVZ1ywPY35pHn0nb2TqTeqNz5mfc+1gPDySZ4uN5aMh3Bpntv+CE6ZD9GjApPfzN5F/hR8o1koFYGZjHP9h5+XHDLTIN2sr4KFNPqQvQpw9+AuZiIWHPE5ky4JJt0ZlhPPVB6zNxNtXNF749F8W8NxUyLP1j1l8rQW8Y4M8Lc0yYM7aZU6fleSTrHZjqoCu5CRUSi2jhTf9lqXDrGHnA/Lh6mabTQdzL8zRdY+emfP2mwaN/QWYJqLV+RPrBXcRjidHNNDbxvKiMLxT6cj56bKyebcd0KdXZ9S6yhHzZPsvQ7sXS6kH+Gh5GwHAD2PatqjiPgEU7q6n8GkHX4hysIJua2ntFDuAaJAs/sBKMQdusTUiiOiJThHr8PFfdRgEPxv4O031agxgbgPbkMDiR4wKD0JPeTK6FjY9ZRFuKsg2mJRa4zEG9KTpthj11MnT+ja8sfskvB3UhjZwCJmNgycJP0XWpBdxQlP1fJ6jHAzHJN6TFMaF2ZwF6HuDaAZsuAVmWtCmItx9TIaEE7QQC/ZFcUuptFFzxujm57G5ukscpdZntbciBl+Of1bBs+qB6FesB8sJcsSmvAOX379MxX8+zehcAfmy0gYAF8k3/sB6542TuxzOSrJiViR7ZSXJ82N/s5yZCr18U0XNOq58Zk/vgm54UCF7odmNekXbR44EfaxPoyyrUpIMGN2orsWL8aK5cuVSouDRnprtcWekJcGqfcNPpfYZT8IZF+9YQ75woDge83ZiocB320vnGm+w3ptCPfnFqiMuYoORa2Jhlad7AGR0GgnkyKVlVBpXNcHKYs5N00zFhZ3tUs5cb66JtbEiLYH0DM3aLIQTiEEA8FdDY7/xOJhPhMVgwCYEdk2bPsph0W8iB0Zx0al8iJaGsWa8+X5u4YmOwOmvJkw
 e9aNYQmu
 uPTQv7ij2nSxursNZWi4JUM1rqmEncYOXCakXpCdl1UGCUb+zImiNwEkxCDO6GP2+aumm1obnKzqA/HdsJd+49ifojwqKQgD/bba8T3bnFETKmfNre25CaQvbJ6FLl8t0W1BuGT7Npg5jABnn3Jk9LqgbTBKpJ6CBxK7KR8CUVJ0VSTeVIE7xbnqGq8nKXNtoKAFF+lAoMb6OMwqxT5rVfV1v7HdHhAyWCv4C46alWQHBr9pU6KoeRNyq7ekzLWDbNggGBZck/Gdk1NSVKUvOhTowG3CeMDZiQ/I10N8AXx3DNhlhQL380kd3s3eZiy60rL2onVhFxLye0+aTUYNeEHlQPGTm2r2UKN9UxyBcwM6Pa1MWrgHSBd2cbCKzi/wVo2lKwAwHEeJnnOEYSofrPd54uPnFh0fwq0fP9me4O0uLJheZT27XTpVaAvygIDHn2guVVRoovC3n9wg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

(Even though seemingly unrelated, this also constifies the pointer
parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
the function exists in mm/util.c.)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/s390/mm/mmap.c     |  2 +-
 include/linux/mm.h      |  6 +++---
 include/linux/pagemap.h |  2 +-
 mm/util.c               | 11 ++++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 547104ccc22a..c0f619fb9ab3 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
 	return STACK_RND_MASK << PAGE_SHIFT;
 }
 
-static inline int mmap_is_legacy(struct rlimit *rlim_stack)
+static inline int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f70c6b4d5f80..23864c3519d6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -986,7 +986,7 @@ static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false
 static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
-int vma_is_stack_for_current(struct vm_area_struct *vma);
+int vma_is_stack_for_current(const struct vm_area_struct *vma);
 
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
@@ -2585,7 +2585,7 @@ void folio_add_pin(struct folio *folio);
 
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim);
+			const struct task_struct *task, bool bypass_rlim);
 
 struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
@@ -3348,7 +3348,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
 
 /* mmap.c */
-extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
+extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1d35f9e1416e..968b58a97236 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -551,7 +551,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
 #endif
 }
 
-struct address_space *folio_mapping(struct folio *);
+struct address_space *folio_mapping(const struct folio *folio);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff..f5a35efba7bf 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
 EXPORT_SYMBOL(memdup_user_nul);
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_current(struct vm_area_struct *vma)
+int vma_is_stack_for_current(const struct vm_area_struct *const vma)
 {
 	struct task_struct * __maybe_unused t = current;
 
@@ -410,7 +410,7 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static int mmap_is_legacy(struct rlimit *rlim_stack)
+static int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_IF_KUNIT(arch_pick_mmap_layout);
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim)
+			const struct task_struct *const task, const bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
 	int ret = 0;
@@ -688,7 +688,7 @@ struct anon_vma *folio_anon_vma(const struct folio *folio)
  * You can call this for folios which aren't in the swap cache or page
  * cache and it will return NULL.
  */
-struct address_space *folio_mapping(struct folio *folio)
+struct address_space *folio_mapping(const struct folio *const folio)
 {
 	struct address_space *mapping;
 
@@ -926,7 +926,8 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+int __vm_enough_memory(const struct mm_struct *const mm,
+		       const long pages, const int cap_sys_admin)
 {
 	long allowed;
 	unsigned long bytes_failed;
-- 
2.47.2


