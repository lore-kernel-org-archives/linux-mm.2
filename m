Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469E1606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oazRdrN4
Received: by kanga.kvack.org (Postfix)
	id 561866B05B6; Tue, 10 Nov 2026 00:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535C76B05B7; Tue, 10 Nov 2026 00:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D92F6B05B8; Tue, 10 Nov 2026 00:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 079486B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:33:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70085A08DC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:40 +0000 (UTC)
X-FDA: 85418092200.17.2B2D83D
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id B5A7820004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oazRdrN4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3sazyaggKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3sazyaggKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAYYED9s6VIKDZjcRjIjaZCDlTGf5Clzal9D/XmtANw=;
	b=Bz9aIfgFbtzw2gYndV1H2gMyIZKuoBGIXU89wd76mEIWcJOIMT6lWoteOH2fwXxX7/SCSt
	34q09U+MBpSAMnzs2b/5Jh/ynQEptGJMx0n+SRrKRQvhXDjaAHkrGzvkROTez4X+bPhIob
	j1rhgSpnPDmWO9bCNFdTL1Y/WHWWBtg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oazRdrN4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3sazyaggKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3sazyaggKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288818;
	b=aXpN7zFpKUD3c7Sx2CIZaxhUzvYsQ9stWkE4BkXeCxBVBq+aNFQmBRa7j2fp2Pr7iPO0bm
	27sUYVbyfsPPTqENRO1GjN2/m9dbcAm9Q841SohCPViHHkkGPcta/cB7hf9ITGZ7IKhI9t
	EhWeh+1Y5oFuwWov+xm78FEAB04rX3g=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdb869327e7so1490636a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794288818; x=1794893618; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pAYYED9s6VIKDZjcRjIjaZCDlTGf5Clzal9D/XmtANw=;
        b=oazRdrN4cyjXtWxdDX4PHatH9sTT0FHyUk07jhxNN8xWve7tUOMNJkiqeB0x93hNCs
         qInIE2Bq7Qvzmm5+ZgHeL4UPLOLkixL/38jG0av5115UBFzb50brcnP2H+oggaMLbaiw
         PHwgjjoG0zMssjWYIO6RqT0+yw6cQE3STOqendI/I4yy/Iau1rRbamoKoa4ode6OtTLA
         fMV+K1ILksbpRQ0h/l+V/csqje9ml3M8DsP5Gnf2dkD3MFkMhgL4nc/qgxkmGOSP/BqZ
         A24O3iSwm4IM8fhXURtr4DM1zlxqvqG9WPVVI3Uq+AIoavvQqhTfjyqmoFqKgq432W5i
         YyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288818; x=1794893618;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pAYYED9s6VIKDZjcRjIjaZCDlTGf5Clzal9D/XmtANw=;
        b=IUrS1IR26XJVjYn0FcxKMC+w2hU3TBp2bu44MGvnn1s/NpoTu8yvZJOXxohEzfKzxr
         ZWqBvDo/o1Myi1ads6iwpbttbAL/bFPmdvGEsepOsdQrg+o5NU1n0r2dbgbg2oMnz7q3
         z0tW0CqInVOJdXKXSAD2GEq2vI7SpxUGvi6Iz4yI5ckJdsnd5V5BR4NJ0dGds5WQP+nO
         0sr4y7ZAFiqzDzvuCgLZNj+dqrkDcb0UaaheXm3HPyb/wUnLnr2tvaGkEiextXflCcxy
         oplCcmOaCb9Kl61It5tze73U0oArELAkgmTMIPNNu7vNYl76VeGBv9Pc45az9uhDopFd
         3BPg==
X-Forwarded-Encrypted: i=1; AL+hErFkO2Ly7GmVVHYDTCRbPrDu2YmWqOA7Ob+e86B5iemopAY5KMWOnLVEN+VFyLamz12ad6u7IvvxeA==@kvack.org
X-Gm-Message-State: APuU4Z8v2udCUcSRtCq/IUea+bCec7YgfE1AthJzWOva2y13hYvSpEaD
	28jiFWHZbQB9KOpfOjAw7Qkg4rYbckp4lLo4sWdOWQdCPx01mcqpqZbCAykhYfsYgOdbpx/Ae5k
	CL2KvUFRKqLwGhw==
X-Received: from pgfd22-n2.prod.google.com ([2002:a05:6a02:6556:20b0:cc9:f7f0:57fc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7907:b0:3e1:bcb:1d19 with SMTP id adf61e73a8af0-3f1901885e4mr1393542637.67.1794288817251;
 Mon, 09 Nov 2026 21:33:37 -0800 (PST)
Date: Tue, 10 Nov 2026 05:33:31 +0000
In-Reply-To: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110053331.2708996-4-jiaqiyan@google.com>
Subject: [PATCH v7 3/3] selftests/mm: add hard memory failure anonymous
 HugeTLB test
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, vbabka@kernel.org
Cc: osalvador@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B5A7820004
X-Stat-Signature: 9o719tmsxuryuqoythk74hujco3asjw6
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794288818-175389
X-HE-Meta: U2FsdGVkX19ys+BYlKJW9J7fuBt3GZA7+t7BgNX9Gb60NfElj2GbAliQ9Ok4mz+zwVWW2I238mtGd0CGzeRT3UFa7C1WphIPa4fZaCcjrrObtuRrqk7TrNdzWqbmPB3zJXmy1+VpRSdbRegwzrhsrLwLmSCzVG+L2lU8l0DPj/8xsXWn6oIF31MwKMKn797841hBBMbFiDrhNpBJcZx4oi/EviU4pFWOISTAIR4J/QRT9+nihIvl5gr3ExnU8hSwFZ2NJfX0xx/R8hx9TRty4xawEyRcvb4c5tX1cT/Wvdrby2MHfArSUrRFfwkjY2X/7dqspr2yRrxQuHhavMc/iy3B7riJnYhGV9ej5VAaR35iC5jRn10pjxFfdE5JvL8cfQXRq9xp37jyzlCUZkbtJVpv3vsxNmyFlmaf4FmhTdtQkr9eWPl46W7cMNc7eAdNtRhpE1oYGNcc6tNRJGhpf3gT579RCn8CI1VBSIGfKGdrb8JZ2CGjLZt4ECPWy83+qYMw58vP7grorCPa5eISgIDVCVJ/MOErO7tyKVFZg2GlK539QJhHIl94jHw5Lci3Ca+vDDbyBiTDvA1pGccroomGjHpBPHBluZEnjRAmnCHFBFySGCtTPr1iS6M4uX98oVgXhkWR1L1q/DXaE5rgX2Jxj+Y4NrlYiWDreU4sAv/UmrIAFhtA+lEzEcCxlmd5WPwcJJ54r14draK+UN9gE2nEEeL+tMymj2xObsXeDrFSMZFp+M5ZidF0vWEjvemc3lkPLx9/W/oBoADDxSestjSbyJnRusX63Nn9QmrCVeSexbMjKCNRACf+l4DM97iOYaZgv7qJwvGXF36s2+VCaXVNaHkLCX4yarRLbKbt7ftzFlO24kDcfVN7ZsQKQzjvRogAdtNFPYngRxUgUIvQZybFzg1G/iUqCLL2Lv7yg1zNCJH4tAsXVBH/rt1u7/bkIok13+9dG/kDzmOW7QK
 WdbYR/VZ
 mOW++5/VnChpMfDwV8Ny5rxo27VnApsOCi2qRewuX4HxolleATVysx99Qs6UYCqTuuF/QXLaqxOUyMzvxjaGwoCvYCrdJRZaRjCvdRfdKYzEsCxJhzure2RwPSvAcKafmXsgqkAOdLJrAawyo1LeNrniyOWd06irmCqrgfHOFGXp4y40N1WJIjHCkfNINWC0MqgiVJygIDqzIWA/lcXUoWlke5AUbTGOCkJVgZs21pHLtGFdKcUwrHN3kLP4a71d9bYKcWkYNh9cqneAQNO9Q4KqWw07GMSfgC4u4LqBA5l0dRUcxD1BXn/l0lOrsdNARBz/8RZ275Nm7UcnINysjf2jImz0CfndABdRza/pYJlkR+8uG9kLXUztcDocqBTtABWNghbVmrC6KYKDZ9V+ESD9m9/3mIBU8f7qEIc5h3Zk7Y8h6D4sfEOeIidsWcWz5IMTzuAd+4u6izTtkPsfGnO9uwu0wr+vd5NkvWuTA+Bttjo6UB1Cj5rHS/OQ7BU1xPCpFJF8xku5/Bc5fNBIg9mzCZXh5bxVqhBA+Io1M5diFDZPZdDhqer7k0qLz/ZHjLR3w1/r+S2u88D1Z2HG+e5NkqhwDu8+FOA/+GvMM8jS4XtCYlBlA46uETTxGQ86SkTGWxSW+DakWLBCdGs1Y4gNRqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new testcase to validate memory failure recovery for HWPoison
anonymous HugeTLB page, including proper SIGBUS delivery, releasing
a HugeTLB page containing one HWPoison page to buddy allocator, and
isolation of the raw HWPoison page.

The test uses HugeTLB's default hugesize.

Although can be added in future, this patch does not support testing
the MADV_SOFT variant.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 67 ++++++++++++++++++++-
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 135a2e8069ba..89fe137ea0e6 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -27,6 +27,7 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_ANON_HUGETLB,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_HARD_CLEAN_SHMEM,
@@ -44,6 +45,10 @@ static siginfo_t siginfo;
 const char *pagemap_proc = "/proc/self/pagemap";
 const char *kpageflags_proc = "/proc/kpageflags";
 
+/* HugeTLB settings will be automatically restored when test exits. */
+#define NR_ALLOC_HUGETLB_PAGES 4
+HUGETLB_SETUP_DEFAULT_PAGES(NR_ALLOC_HUGETLB_PAGES)
+
 FIXTURE(memory_failure)
 {
 	unsigned long page_size;
@@ -52,6 +57,8 @@ FIXTURE(memory_failure)
 	int pagemap_fd;
 	int kpageflags_fd;
 	bool injection_attempted;
+	/* Number of initial HugeTLB pages with default hugepagesize. */
+	unsigned long nr_hugetlb_pages;
 };
 
 FIXTURE_VARIANT(memory_failure)
@@ -155,6 +162,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		  void *vaddr, enum result_type type, int setjmp)
 {
 	unsigned long size;
+	unsigned long nr_hugetlb_pages;
 	uint64_t pfn_flags;
 
 	switch (type) {
@@ -175,6 +183,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_ANON_HUGETLB:
 	case MADV_HARD_DIRTY_PAGECACHE:
 	case MADV_HARD_DIRTY_SHMEM:
 	case READ_ERROR:
@@ -187,8 +196,15 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
 		ASSERT_EQ(siginfo.si_addr, vaddr);
 
-		/* XXX Check backing pte is hwpoison entry when supported. */
-		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+		if (type != MADV_HARD_ANON_HUGETLB)
+			/*
+			 * Check backing pte is hwpoison entry when supported.
+			 * Although try_to_unmap_one() also installs hwpoison
+			 * entry for HugeTLB, pagemap_hugetlb_range() doesn't
+			 * parse swap entries at all.
+			 */
+			ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+
 		break;
 	default:
 		SKIP(return, "unexpected inject type %d.\n", type);
@@ -196,7 +212,19 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 
 	/* Check if the value of HardwareCorrupted has increased. */
 	ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
-	ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
+
+	if (type == MADV_HARD_ANON_HUGETLB) {
+		/*
+		 * Only one page is hardware corrupted; the rest should all be
+		 * released to buddy allocator.
+		 */
+		ASSERT_EQ(size, self->corrupted_size + getpagesize() / 1024);
+		/* HugeTLB should have lost the HWPoison HugeTLB page. */
+		nr_hugetlb_pages = hugetlb_nr_default_pages();
+		ASSERT_EQ(nr_hugetlb_pages + 1, self->nr_hugetlb_pages);
+	} else {
+		ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
+	}
 
 	/* Check if HWPoison flag is set. */
 	ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flags), 0);
@@ -261,6 +289,39 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+TEST_F(memory_failure, anon_hugetlb)
+{
+	char *addr;
+	int ret;
+	unsigned long alloc_size;
+
+	if (variant->type == MADV_SOFT)
+		SKIP(return, "Soft offline test is not implemented");
+
+	alloc_size = default_huge_page_size() * NR_ALLOC_HUGETLB_PAGES;
+	self->page_size = default_huge_page_size();
+	self->nr_hugetlb_pages = hugetlb_nr_default_pages();
+
+	addr = mmap(0, alloc_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory or hugetlb not supported.\n");
+	memset(addr, 0xce, alloc_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+		FORCE_READ(*addr);
+	}
+
+	check(_metadata, self, addr, MADV_HARD_ANON_HUGETLB, ret);
+
+	ASSERT_EQ(munmap(addr, alloc_size), 0);
+}
+
 static int prepare_file(const char *fname, unsigned long size)
 {
 	int fd;
-- 
2.56.0.506.g506a7eabc5-goog


