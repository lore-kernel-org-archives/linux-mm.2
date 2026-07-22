Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10BAC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE4D6B0092; Wed, 22 Jul 2026 05:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F426B0095; Wed, 22 Jul 2026 05:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796136B0098; Wed, 22 Jul 2026 05:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4C96B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C82201A0386
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:39 +0000 (UTC)
X-FDA: 85015847238.24.660D772
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 21E52140009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t5D8ftkW;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1wl1scoNU0/74tbSiLtLPJ9c+az2Kc4PP0hpIC7IMo=;
	b=4EPwSJ/suHY1WWECcpheORT05mY77o+HTwUHUperkca0iH1jBGhOPhbI41p5Wpelsyaesm
	B/ssR7hdOzWxDFwlTVWwoD3uhuT9njYF32r+pb0cd3RV7trI1nJnLCKZPRSJDjE092SJxo
	ohhbmBoTWbYNDGixJjAohGRMr+l2DK4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t5D8ftkW;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711558;
	b=Osnkv1Js8Xap64NeKs44CN6CMzQh6gctc5fxARV29b/0EavfoYTX8ItBZdz+dksH/S79Ri
	gfE/iyz/aECzVYhpmhWQvPJMifVkjRuCZBQUmu40hwOUHoHijJuZ3mwmhZ+3Vk/MftOGmA
	JIeK7FDzQvrRBm/a4Ww+aP7iucEFvbU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0C641595;
	Wed, 22 Jul 2026 02:12:32 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A48E3F86F;
	Wed, 22 Jul 2026 02:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711557; bh=FcfLiMt+bHeoQiYgQH5BUPvM3W4w/RBin08nosAKQeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5D8ftkWCpH0Wn6f4iz0gui8c3irSjSWBII9enx1vmobNdM98AaccGRsapWj/3DAU
	 pfkC30kUr7+goUvx4twrTbq96meG8jPrtAXXN5JszxbxqQSc0afhMFDQJNGLOpG7Ij
	 bA8RtIE92vtzRZycWvxm89X05Y14MVWCt44pZVfc=
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
Subject: [PATCH RESEND v1 3/5] selftests/mm: skip khugepaged swap tests without swap
Date: Wed, 22 Jul 2026 10:11:37 +0100
Message-ID: <20260722091219.61504-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722091219.61504-1-usama.anjum@arm.com>
References: <20260722091219.61504-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21E52140009
X-Stat-Signature: 3gis9e71pe6rrpnkiirrwepmywnry5j3
X-HE-Tag: 1784711557-933393
X-HE-Meta: U2FsdGVkX1/nxYzYFJeLLKxe7nRNcB4g7pYo576opUJctrTkoJuAIEfE/miE7AdWgjyAlMsiq8lR8Q+MZPPUZX0J+ZU0zTb4KKdSarOO+sdYKVUuvgcnkhwXQztQXGnkfHHWnZnFyKvLbh6/myoLmPopM7w6zdsiCqTjEdlqY5rB96/A/35RuvmDshL7snM9kQ9Xo9YPEdULE4Lh6WaRu/mGFxkxC2ltzoemByORXb16KwFa2H9kxyeKxByDmEgfUzjtfZlPwzX/GBBeWYrkfR+IjsIivDAMfUvMf62OpZUX/oRaZcOyZULQ0TFYNPkaMlZINPC8uaC3Z/va8Uin9LqJmUw1tXR5t0EJWW4Eypch+9mr6CMRuibH7MzcpWHnYY9W7+wZFZdn9rAZPIGmuN6hhEvO3FPX5vA32ZbGlxX339G99BpYwp43aciGNssz0jX3yl7wmponekxnU5yPhi+ANNcQQJarOQRyfFKDgTdhFEPMLYezyuTB5suDXSI9w5+gIuUokfrkCl87fb8Yk0GX9Hu1rkpAKYIfeqk2X/0o2YylMewx/TR3t4Xnu1bRoKABAkfhKd8X2rOYgQK/jfu4/PSIDowMTGEzLIHHOzT6wQhJqbcxZZw6XQ9BHBCEHJtJV9c7TVthL7cSbuNnMjyUk04YNMy1wnND2VgtwO4RIpRdiis51H6pl8kHZkwGLMhKFEgXOmeRfqD+fv49d1FaBilkxe65MRqRh+OP6gISxv2fcBKr6WbftA3uZQXkNREfyncoP4e19fLSC3iRjN+fAPXbfMwQPfqCy/k0sTNXjBGibAnSxIH6NZc1mNXGu2Z5r4U1efYzJqtWMgP5WiWguJ7wwsRRNitmBmtIlF/bAzNwrrV5brT0aEWkxg6IKGiFX38FWJQ4WaB+tySyvkTivAEfYve4YnLwoMHuXpXvvUatlgGCsHSeluXO/niHNt9TLqRTX/4LWJH1aO9
 zhlrfN9I
 C1l0rP4054AjKFjAZurYmMnCi07ExZAFwNWPUvQBG6IXTK1TTrM023Ds28bCfsUVLKuhO2oZzKt+hOzhGbOAn3S4g1Z/xiJttRY+m4bRzSeblTxTnJ0Yn1eOjaKyeMoI08bQaOyutQkZieOy4zTmM0J6wyNqpLyrZbE4sByH+bJw3ogIRWfAcCsTekw/pqu5zY//YyVSbtCJx17Uhm23luMKX91/f/z3baXlGNHxLI0s4dEXLpn8iUJmshLjvNa7NN8Yn0lwkthFlOa9ZssYlXbYdMB0bI97zNgWdRatHxi8TfYR3+VmwxjKzneTHd8dFLjot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_swapin_single_pte and collapse_max_ptes_swap require
MADV_PAGEOUT to replace anonymous pages with swap entries.  On swapless
systems there is no backing store with which to create those entries, so
check_swap() reports missing setup rather than broken khugepaged behavior.

Swapless configurations are common on Android and other constrained
test devices.  Failing these cases obscures actionable results from the
rest of the khugepaged suite.

Check /proc/swaps before either swap-dependent case and skip when no
active swap area exists.  With swap present, retain the existing
MADV_PAGEOUT and swap-entry assertions unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 34 +++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087d..a152cec59fcbd 100644
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
@@ -734,6 +756,12 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 {
 	void *p;
 
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
@@ -760,6 +788,12 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
 	void *p;
 
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-- 
2.47.3


