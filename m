Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A22C5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86CE76B0095; Mon, 27 Jul 2026 05:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DEF6B0096; Mon, 27 Jul 2026 05:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7342E6B0098; Mon, 27 Jul 2026 05:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFAB6B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:52:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2E6D160651
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:53 +0000 (UTC)
X-FDA: 85034092626.03.8B20EC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B7AD1C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l4Nr11uN;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IZ5z+tB9go2eRh7hY/hXww9tj8Mkml0dXjZEmFzd2M=;
	b=2Rmln6B4IQTSQpCEfyBHqn1yA2T6vNIWN/YGtTU59LgLFed2PAOjFJnIPSV/Acf6r+9Zc+
	/vOX8eldWiZtXmqAEa8ZFmZkE5MuQFSY13bLZV8pfasOtslCKGmrV3tAN6PlPyr0BbMVCb
	1TjrIKkydBYy73H+s1TBkJx9uvbbzaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145972;
	b=Tuf1R4YIifW70ulVOqySkooR9onGhEaxZB1267jnvDn+XcT5JuF6tgw8Tmjin8tvRu9V56
	SchblxWKcwnP6rKhlNIo1Qu4z8ggv7fXhuA/V5aZrf3jFOaruYNp5pM5MeZ1995bxnA7NI
	12u3CuBNwdTujJKk7lrO2XaMWEqiTaU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l4Nr11uN;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11CDB1576;
	Mon, 27 Jul 2026 02:52:47 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C63E23F66F;
	Mon, 27 Jul 2026 02:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145971; bh=MakI4ukXwu0PoXIFZ3JJzT172oQaQ64yT7zlKhSuUTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4Nr11uN1OuFHZODoWSiAlMlYWwpwMmgl7omnWYnHVW9MPZSu4mAqWGVlMrkN/hIm
	 05gcuiU/OPYD61hoeQiZaiOUFhsoB+M7h/n4jQo82V80fTBqDTytKPQESR22EfjgoA
	 w5U4+NiBNMbFDCZq6FL/Xisjb0ynfGjNuXp4BGbM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 3/5] selftests/mm: skip khugepaged swap tests without swap
Date: Mon, 27 Jul 2026 10:52:19 +0100
Message-ID: <20260727095225.372655-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095225.372655-1-usama.anjum@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B7AD1C0007
X-Stat-Signature: yg64ztu4ez8ufx14jrycgmxdb1uciqdm
X-HE-Tag: 1785145971-232172
X-HE-Meta: U2FsdGVkX1/OZArRhDZeFEbsmuMqZ4/xG2yCUWBbaxP514lQEipi0KXSxKrfzbjW2KzEEd3FAO8WucFwfT3OwqDyUmnl4K+o3z9qYG4sHZIdK76KEC011PIPTsTM8o+V80TJhR5AzbzqtOjyemZVmlzSUKsHNdHw5MGXDyygXZ/zW5QwiYlH4s5tWxnWvFyW26EGzluAViXQtMBcDAObi+PTKTsq1qt74dYlNPOElTbECRmUWA8SSv70LM5d2YufHlsMdSaeZL1AfNsXw5af/UJcO45D2+HPAAQ3m+EfqDu8+A1RnNf/b4kTn76GcO+eq0jk5ht3x3PHu0HrrIMhEIWpSYt9Uo87YNNDnX+SYI8PTVhQ9OxzWHE/4BkyuLzsC63vB1gIdyv3wjImEaAQGxF9Q6RcI2SgvzEKCPMY6V+dgPzyGN4bwYuUOXEiIEHnuCOmTsIPL95u4WCiLFkZq5/bmYxvQuWHcAguFLsTFNAIUJfRcdTeYIP7RJ04u3a4W6M1Sq0yE+/PnI0d5nibyiTiAAUk2WDjruXiE98qMlzd3ihvUp9dv236xWCTommcj1O07C/i5O3+oLhrW51ZWFptfXkMJrfzuhxMVllXPFlj6firZHdqrSLB4Cqgbmx0WoruKb3hvKRoIn6FSzhK2L1zt3RsOnC915Y/jWPQBO96JeBDfN2EeMLE5rt9Mcl05qOAHcP+a/mtwY6rcspwuBh1CR0xpCQCALQSjzFluwOJjYUWFJIDGdnh6w3XcKE2t974Eh/dQijkNkq2N7O12kyW0dz7j4iceWBTevX4nzgAWzwMsD2STQZ6hjrxjycE9yJg/W3KDSQ81BknvxG12duVQ3fiMWQB2RjopUKPA/A7rm+7eSQskdHsTxEdUMKDdOps/AycgTV/PEvtvst77WFwWzrSxBXOQq3TkcwLj6BKs7WDJt1cy5BYddzSqZhtf6RZbIUYuh9cqaPgT00
 CzTiUzq3
 oanN+tt2DmbxZ1nSVhhhOwtQ1/iu5mtIcpbAsbjkyaSHg0cIu5xB7d2iYTUujq7XwO1cdzRvyCHGgv9nJhh7cz2kc71UFyMb9xU4qKd28llkG++Z7PzlHXg4ivcGHVY6MBAK/Pm26dvUqOgj6VJz5pzBtOvCrd9WoDJOselXlpVcScGp9wZ2JMfDP4Z8j3pmFYmBBNo0sMug0kLVLVkUmDD+dhOj7Dv5wO3GOOmwua2jEzM95WyC7S/1GXPsxbURgpnDC85FUUpHJfGhluq/MrDFaRbyjRGe/ToKdRIhYmkrx2xBfj+hnmYxT0daVv98EYrOi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_swapin_single_pte and collapse_max_ptes_swap require
MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
systems there is no backing store with which to create those entries,
so check_swap() reports missing setup rather than broken khugepaged
behavior.

Swapless configurations are common on Android and other constrained
test devices. Failing these cases obscures actionable results from the
rest of the khugepaged suite.

Check /proc/swaps before either swap-dependent case and skip when no
active swap area exists. With swap present, retain the existing
MADV_PAGEOUT and swap-entry assertions unchanged.

Print each existing swapout diagnostic before the prerequisite check
so skip() completes a KTAP diagnostic line instead of emitting an
unprefixed message.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Print swapout diagnostics before reporting no-swap skips.
---
 tools/testing/selftests/mm/khugepaged.c | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087d..54e888eb48bbc 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -100,6 +100,28 @@ static void skip(const char *msg)
 	exit_status = KSFT_SKIP;
 }
 
+static bool is_swap_enabled(void)
+{
+	char buf[MAX_LINE_LENGTH];
+	FILE *file;
+	bool enabled = false;
+
+	file = fopen("/proc/swaps", "r");
+	if (!file)
+		return false;
+
+	if (!fgets(buf, sizeof(buf), file))
+		goto out;
+
+	/* Check for first active swap entry. */
+	if (fgets(buf, sizeof(buf), file))
+		enabled = true;
+
+out:
+	fclose(file);
+	return enabled;
+}
+
 static void save_settings(void)
 {
 	ksft_print_msg("Save THP and khugepaged settings...");
@@ -734,10 +756,16 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 {
 	void *p;
 
+	ksft_print_msg("Swapout one page...");
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout one page...");
 	if (madvise(p, page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
@@ -760,10 +788,16 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
 	void *p;
 
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
 	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
-- 
2.47.3


