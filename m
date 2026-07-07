Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F522C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384756B009E; Tue,  7 Jul 2026 11:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C2A6B009F; Tue,  7 Jul 2026 11:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AEA6B00A0; Tue,  7 Jul 2026 11:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9A2A6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:13:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77115120427
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:13:55 +0000 (UTC)
X-FDA: 84962325630.21.0896CF6
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf09.hostedemail.com (Postfix) with ESMTP id 899EF14000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:13:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=y2D7U56W;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=A66O33Om;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783437233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yHnAHFidDo8khkFB9/mnK79nGDjqLvmK8s2Lu6YNrRs=;
	b=LwC63lnqRMIH8pUGhQLEEExaO7PZIzbDgtC9jk60YS/Jh3O1qrv8Oc6xXB9v2gS3qjSfUo
	4a5TzNkvQeHm4+9N/I5c7IZNBYGS30OR2EtVSUu94OcNtMLWzG/ROa+cbc42dDaTXe1vMs
	9DngvR/B3LarWltKr2gbvnpJmTGuTKY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=y2D7U56W;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=A66O33Om;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783437233;
	b=Y+gN30im+Vjq1K/vzoHAzusY1uk1EV+O3zGmNMJv2THzMBd/IvwO99bge0X71VURrxhbGg
	l2bxdCh86g6AeWZydKueeHnuq49rR1I+NpY8AF3bvldFM64pg2P9Dho/A+MJ512boqy4qO
	+L5F1w0aKRRD9i9jHTWFYZQlCHwFIXM=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D32ED1400060;
	Tue,  7 Jul 2026 11:13:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 07 Jul 2026 11:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783437232; x=1783523632; bh=yHnAHFidDo
	8khkFB9/mnK79nGDjqLvmK8s2Lu6YNrRs=; b=y2D7U56WVBDMlVcDzkgqSe6iKR
	e7AQUoz61t1hrh63gYk6Yj7Sz9d18qx71ARnOEDBQjMYdLORasIoVcSX6RfdTuPp
	GDSRPhGMh5ZE5R4bRnlKpz5Bbi9KnRcFzUyea+u0LsqGB+kd2ZwHg70iquTSB7J9
	0iG2V5D/Mt5czH123UjK2P0X4pg9xXuEtaaLK89OPilePHyTHcfOEIXHjoSWaJaq
	zN6wfg/3lpKuTKz3RorO2DrYzs1BIWZt3eqBv8BRUCHEa8dcTpCMM/3ABuhI70h5
	ahH862/XE9JLV2IKinfNByyc5l0LD7wIXcgvJ59H0oXBKsNIRheExFPEbaqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783437232; x=1783523632; bh=yHnAHFidDo8khkFB9/mnK79nGDjqLvmK8s2
	Lu6YNrRs=; b=A66O33OmsHTi6Doh2SSYWo+yPNwdtdfNPgS7NfQAYlSzrjbEcFO
	Bjm/ysBPVxPycknpsCqZg6UnhTBfAn/IdH5vAQq3K3Jng3jWCv34bJvA56oYfk/n
	NT40kmBDgTzxq7dLxHNSCObZDrFV2Jip15W29KgszzXJjOapHtooB3ekwqE/QjNh
	sKvEYY1l31Jpcs76ad8JLQsG9zAaQk6DnAGPRWWkpjjk2HLs7r0RAVE0lfTcUTrF
	7BqfN9JZiTyB164PjNkPwm7x3vryPZ67gTPss/m4qjn+LgZPNovzM1BYiGeI7BZS
	IJBCc8IxV1oO7AThCwSdWTW+jzjZc8v7rvQ==
X-ME-Sender: <xms:rxdNaqWubJlzNtUGhx1wVQ4VQZgvbwrUZANDClSPY0Xku3B1a4xLHw>
    <xme:rxdNatj3LSPPGJ7P84BieoAQVBzc6dHLrYEj-JNsUOpsda7RIJ73hi6SLabeM-1Yx
    8Brvhwwdp8zlMxUGQTYhzMSB2E0pzLJ97yjBqLa-NtRBF9HEBg2tyiz>
X-ME-Received: <xmr:rxdNajfpTcRiKYdxBFqUA233bKF7SXj45KcYU8vi_xeizaOyxyOO1ujPVX4nZg>
X-ME-Proxy-Cause: dmFkZTEiLljjhqgaKKNY5aZiI+jEvjyU81SjON7V5vxdWCBsAwiOWcMHlYKbwS5Zrkx5gR
    gCjHbuYgokG++jJItBiQhtpm+cB6FDJvAvsG3q/4/1cmcnN6cGUCTkXyE0xgArRFzlE5El
    kS57rEdf6c7FRigb6EVHz5I8NgITm5hE9uU5jJ7Yy0irnbojHwrL3UqHqCzYahdFhlp3Rn
    t7tNdtwaznApTVOOTQhMcpm/4Ym1ibGsImDL4LHR+9hUOdo4v2M8+/Y81ukPPhJYW+fMNY
    pv5tppNMfiOEsQWUahBzzxe4IAVuG3YnCsItoPUwYN+1xRunHaMkQ+CwbvNWVkKR95zlPt
    YCT+F1FZFKCD5Tg3l0hb4zMza38/aDkkI3ZK6OPxjcDlPI0/0JKJ9UmdqBCu4jaBnupI46
    Ztsv6YbM2s/pnJVI+tQ2H9trktCIKFhZ1JM0yX70Z2AsAYadbPwRWrshFkNMsl//LcWKw8
    bFIY/9QtE3iqHzYDXJHUVBmv+8jE88fejHKnxY8Qtkpu3BPG3XDETKgib08Zak+XLSNQxD
    nydTe/Gvou4YUXtei3MSI5dAhhZr7CSiu9HSAwXmthzvyvnEMaGbomJyZ7sRCzyylZeLwq
    4PwUVXGvwBNLB8rTsbYk+4evVXYRmejH+51UsudB+RAaGK2gN+Z7tMhn7V0g
X-ME-Proxy: <xmx:rxdNaofuHWpKuAMadg7GdAasb6KLzqSzA5nVG19B2zpJcaXo0VHerw>
    <xmx:rxdNavXN3iO5BThnNRlkyC6GbyzxCDrntc7wXLA8A9ERf740pKgiVw>
    <xmx:rxdNasemlUMOaGffimLQbepO2jFqLJRe1OBYd4OqfZD6wBJnuIWkkw>
    <xmx:rxdNaj8VT7-LKy3y86yuBhs_CCUY3256GQ3-JD7lAqPoJQGXTz8OAQ>
    <xmx:sBdNatrWZXAHxK-M-H1KwytAJTNxX4CVK9ujGU-u9tp6uVAvi2p_mHRS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 11:13:51 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org
Cc: usama.anjum@collabora.com,
	peterx@redhat.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Tue,  7 Jul 2026 16:13:49 +0100
Message-ID: <20260707151349.92143-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 899EF14000F
X-Stat-Signature: 1tg4h118abwh18jtk31eyzy7kztin5b1
X-HE-Tag: 1783437233-705721
X-HE-Meta: U2FsdGVkX18gIQgowBeqxqmC4yJb4FCHkFJSXLS1shk+OcCBvucViElV7QwyKuNYqyh5Y6JVVEiwmhEOaILAclf6/AWTkh1qWHW4AqKs6oKLOIu7i1wr45VrYbLCiu6vUWGSl3cfcktOukEqz5rDBkz7+aIprm2K+9XAbCJ6gK1eS4WG91pLlR+mgPypeOZGrY35MpOcGm64S0IYFORxmuvDs1RbORBEcevbiqy7EmEAb1A84iAa31wmdpCE+9uNNqBTLjBmlM01B3u+rTz5TYho5opX8cbmytzLeZx2Bw4SYIZUmSVqiVg6+K/mlLFtAoQt2Yq6lUC/e/kFo8KGgkSeVXHLY+ZGQNMELo8GjDpQ46rYbKtQHC8IGCGIixrnVNADEfOYaO12/g6oli3J0nvuJHbKrBOv8cqX6OleKk+d1nO32G94V3MekC3exBTeGm+slduuQUbMGQupj3Fw6A5MmsC3B5k1KkjswBh1rn2hUfQj0TlnttjWCzm1jds22FEuPB3m2EHLnRQD6tfqHQXLh+Uet2YpbVbfJYjnYaZg8MXCpDDu11Sr1TDjoZeEpbCmzxUbYjr6Y28l1QI1vn7eFAnKpaOqwpLQLWojkFIQvpY+d5PnQzrYNdvySrbVikVqlXVjvZKg2xrfUBEm5L94lrfRm/QxqjV/Ps5L9qyK/n13sNHtly4MQCr4CxXxtg2lniFW2pEKUrH9M1LtE7UchCSJ3zzk6Mxc0SsOyMXOcEjix4MOXo3i0QOwSPtAFLIHKP+3BM63qOPU7RJJjFGNaMa7xhtueUDRHqu1NPcuQY/iKVxBjSLhueLyXOu5osNQluJH1G6l/Qm/ehUkyPw5vJFwH/uryE9tiAbcZKjmvRb5r6B5w5zjeF9WG9oQB2yzznBdlbGKCdAPJv8IhGRNsyU/5G12MZsQ2Cds0+B/j0e0XvaIWt6r3HYOwNb7k/yw8dp+SVaQoLcJLpO
 VHVdrAsH
 dJIEHieCMi6OhrddT43PKqWvxMGi4surP57AfWxkmisZasYr+kGdQjjz8LcrsASmGHCAPPvIFDzfNmidaoZhhuCFiKXkHUnzUk73IKvMJQTJBypDt+JGIzPb9FM0ZSuf0rtc6wOUXpfcuG+5ycQuV565c1x4/35wXcAS0m6A8zDXrhG6S3hurLpGAgoEjyirOY973gktep82NivWobBOF3OdVWMXqJ9tXapSUNEt8kvcDuuOKeOzrjg1XQbKSMuEABi2ZKuVnqdcRd7O9zbdauj0VG2SAfSoFasWa9jPf8jr3I/F2+F+Ek8eDOWNQ5A3rtKgpIEidT47saVKR4Sbg5maUjV1CsafrZZFmPeeVYDT55TWL0284fKxD+oKLg1Vrha8zbJjroiM8IFIDNMTXUcxP6iCpMf21Ygaq95BJAfJzp8aoTrJQ04qhJBzTA/P8EGIZMfaDO1m9nfvie438ACK+AItFyzwMgTVtsBCNN2m3yaFm7ejq9yyN2LQIKnWXCeBpHrH+uLWQGF0BPteLni5TH7nOQqDdTbQuKBaushxkgy6+r5OqOWAj6vfCiO8nBW8IgXlqiKj30mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

PAGEMAP_SCAN reports an unpopulated pte differently depending on which
path serves the request. The PAGE_IS_WRITTEN fast path in
pagemap_scan_pmd_entry() reports a pte_none as written (and, under
PM_SCAN_WP_MATCHING, arms a marker); pagemap_page_category() returns 0
for the same pte_none. A request that cannot take the fast path (an
extra category bit, category_anyof_mask or category_inverted) therefore
reports the pte as clean and skips arming it.

A range that was populated and then MADV_DONTNEED'd reads as written via
one mask and clean via another, and in the latter case is not re-armed
for the next round -- an incremental-dump consumer (e.g. CRIU) using a
richer mask drops the zapped range and stops tracking writes to it.

Report pte_none as written in pagemap_page_category() too. A pte_none
carries no uffd-wp marker, i.e. it is not write-protected -- the same
condition under which the present and swap cases already report
PAGE_IS_WRITTEN. The fast path applies no VMA test, so neither does this.

The hugetlb and fully-unpopulated-PMD (no page table) scans have no
PAGE_IS_WRITTEN fast path, so they do not exhibit the per-entry
divergence and are left unchanged.

Add a pagemap_ioctl selftest that populates a range, drops it with
MADV_DONTNEED, and checks that the fast path and the generic
(category_anyof_mask) path both report every page written.

Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---

Changes since v1 [1], addressing Sashiko AI review:
  - Report pte_none unconditionally instead of only on userfaultfd_wp
    VMAs. v1 left the fast vs generic path mismatch in place for
    non-uffd-wp VMAs, where the fast path applies no VMA test.
  - Strengthen the selftest to assert both paths report every page
    written (v1 only checked the two counts were equal, which passes
    vacuously if both are 0).

The hugetlb and fully-unpopulated-PMD scans have no PAGE_IS_WRITTEN fast
path, so they stay self-consistent and are out of scope here.

[1] https://lore.kernel.org/all/20260706104308.34741-1-kirill@shutemov.name/
 fs/proc/task_mmu.c                         | 14 +++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 56 +++++++++++++++++++++-
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..d45c729ab6bb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2432,8 +2432,18 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 {
 	unsigned long categories;
 
-	if (pte_none(pte))
-		return 0;
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
+		 * write-protected, the same condition under which the present
+		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
+		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
+		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
+		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
+		 * fast path applies no VMA test, so neither does this.
+		 */
+		return PAGE_IS_WRITTEN;
+	}
 
 	if (pte_present(pte)) {
 		struct page *page;
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 762306177ad8..550d1f2c059b 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1051,6 +1051,57 @@ static void test_simple(void)
 	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
 }
 
+/*
+ * A range that was populated and then MADV_DONTNEED'd is genuine pte_none
+ * with no uffd-wp marker. Such a pte must read the same regardless of which
+ * PAGEMAP_SCAN path serves the request: both the PAGE_IS_WRITTEN fast path and
+ * the generic path (reached e.g. via category_anyof_mask) must report every
+ * page written.
+ */
+static void unpopulated_scan_test(void)
+{
+	int npages = 16, i;
+	long mem_size = npages * page_size;
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	char *mem;
+
+	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+
+	wp_init(mem, mem_size);
+
+	/* Populate, then drop: the ptes become pte_none without a marker. */
+	memset(mem, 1, mem_size);
+	if (madvise(mem, mem_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s fast scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s generic scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == npages && slow == npages,
+			 "%s unpopulated ptes reported written by both paths (%ld, %ld of %d)\n",
+			 __func__, fast, slow, npages);
+
+	wp_free(mem, mem_size);
+	munmap(mem, mem_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1559,7 +1610,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(117);
+	ksft_set_plan(118);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1737,6 +1788,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	/* 17. ZEROPFN tests */
 	zeropfn_tests();
 
+	/* 18. Unpopulated pte scan-path consistency */
+	unpopulated_scan_test();
+
 	close(pagemap_fd);
 	ksft_finished();
 }

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0


