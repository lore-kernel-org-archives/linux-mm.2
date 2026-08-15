Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B6FC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F48E6B0751; Fri, 14 Aug 2026 21:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EFD6B0753; Fri, 14 Aug 2026 21:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E296B0754; Fri, 14 Aug 2026 21:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF296B0751
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4E9EA02F7
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:21 +0000 (UTC)
X-FDA: 85101846522.12.A14A6AF
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf01.hostedemail.com (Postfix) with ESMTP id B649F40005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C gdQW+J";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Ku1e1ZdD;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759159;
	b=cFPXBQsfNOVQy2WH94vetyTN0X0pJcAxRsHKOQ5q3i4uDLcejylDEaOCsoIawF/iBxV9OR
	3N1nS7k74VF8ZHs1duYWYojdHzyTiuy7wC5mzDkgaplYd3Dd7GDFitq8qtEeyjY1rbpLfV
	9Cy9hMhTnL8VtBhcjMBqIH2mgQeR4BA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C gdQW+J";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Ku1e1ZdD;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgG13P0WQQyCBdBYOJL0T47tEW0jH9jShvZjUp74c7I=;
	b=RxtdLJnFBv4U0G5CFpA5+7tU7Oxw7+6fZBnTkCwqj+q4+K9itjqdI6Tt36TKmwonyJQHtJ
	3eRfG8I1l2gV7/j9aT3ksxmZl7toxTwt/0zlSBfzV9O94tVfi9OWq5rtZ6WBR+e+y0lxLJ
	0Te085Nd7KnBXSc39cCb+w5P3wRkkWI=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 452B4EC0223;
	Fri, 14 Aug 2026 21:59:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 14 Aug 2026 21:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759159; x=
	1786845559; bh=LgG13P0WQQyCBdBYOJL0T47tEW0jH9jShvZjUp74c7I=; b=C
	gdQW+JcxJmpuInkt1ol9tNRCxUZmZA25NEmIzkRIS8KKN4Yz342KBwmMj2w7GVO8
	jomEzYytrPXUhNhKQMVvuJ3NeKxvFK13xpt/kgYIE29Skm3NaxRzNwuO16CWPjPu
	S7UJ0E1joYJwL0Aj4AbekRoES+ZfNke4zfULB7Ghs3NcW4e6UJ2z3vcNKh6eZks6
	08Qgt017uRZI+sRhiF8wSfLTrX6t2FZWJHvIyhhJcPhcslHKhoX9SE+a1nAWwd4w
	8botglqSk/iDwjmIVRUWqxPJhFuLMQQGIIAy230mCI5wa8rWLA/+FIgsiJe1IfwG
	Gg3s1SlXbi8kUe+m7wxIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759159; x=1786845559; bh=L
	gG13P0WQQyCBdBYOJL0T47tEW0jH9jShvZjUp74c7I=; b=Ku1e1ZdDPyHtg2rcI
	r2U/q7Hg+TiBVWuAW9EEfj9efA+oj1zwHGR+it846TTNXWG9mQE9PjHvQP0jC39r
	zSoq7GotYkA+FzqNmrQqcuDAqzFdDhQvSaZ8G9ObFX8h2sDoHDefVQIxKm5H8Y1d
	rtG0dGQrJUNygXM1X81xmtUsTsxM1h0iLqQApO/iZHvkBhtx1kmSy7hViFuwY5Ui
	lSGb9nOweCEyOb6/vCnzB2ov+96yTqORv7Vmmk7viIziuc5vc6zCUEB/A2shzmCL
	BwPFwbX5Udxs2ISIckSJMwLtbi3DRBPXrTBphyp3sfg6fuAQvZcEdpw0z95uMjBw
	4r6vg==
X-ME-Sender: <xms:9sd_aoMmzNHKpR3KIgvtjF-Ep9J8Z2ojFA9N-m_WbUiw-kcNMzGhbw>
    <xme:9sd_ai5fdKey-Icw_BNF5NAlfZUk5HciJ2fv1trwqYpwt_mZKAuHR4My6afqJG6Yb
    uYGC_E2_39Yk4_W83-j5GtFTLZ5q91slvvbAkTMEPqgxpO59mfjJV9b>
X-ME-Received: <xmr:9sd_anwaNcXs-0jK5liElml7gwpEFZnCT2CK6vPrRw7y9tjS6w5p_3y8nn4>
X-ME-Proxy-Cause: dmFkZTFkzjFsAsDS7jWvo8tVKWpCqxoPadMTBhe5gqM9L8x58RJwkgUd6ef20LiiZWkVJ2
    5XQFhBj/83jOdOO/Ql8fjehU8OJYV5xIu11NhtpuSlnR0oerfSUAVFPgI11Kw5ramX9VWq
    n08yQGhgo5srNyqhq1wQoX26nhsBi0/kG/kW3aJyoHPyWIE8LEdKOQSb0eQSt/HvnaOXE5
    UcIyVyC42WtFkuUGaM3UI8X0We8hi8iW/Yy96suQXEqLNayQSzJTP+/kt+gGyLyNBuaXQP
    ClJKWCE1EuRQ5KlZV/VIT/qKrfIiWHiKuiXCdDyNa4K7qcq8xZMDqhI/wNpN/ytfSmuiC9
    ASDF64uDYYbJcKpkthtCvX+lL6hbpkE8rcBGht8D6sa5z3Wt/7XEw1SzEiJdE326cyseW0
    C4UxUzzt/UaE7luBGDD7sTDLHv5DOkHTzgs1a1G23kMi0QipbeAo+uojtkKGEyV1ttU1E9
    2GwrULNZCWkoidglMm4joCnVsrGWrN5jEtdvnnC7T+RL8Kbk0g5h1XcbA/vJJ6kuYy8+Z5
    xtj/YfjsvJRrWkzRquVToRNe7Mj19b1w1lZ+y9a7DsIoR7l6OOPPWlQJWwhPyg2WbL+EyR
    U4MTWsj3igdF1mDl5oVUQW12b2JHGbnAWyVl/npAQUdDcFRMPj/i1qntecmQ
X-ME-Proxy: <xmx:9sd_aqS_kxE9i6az5uQab_w0lSvATkW3XHyNfFBpik-3teBjGuvqyw>
    <xmx:9sd_an9DDuxqhVQ1Len7gljMBODwLB-li_-7S1iejOcrnAyi0iQk8g>
    <xmx:9sd_avLoE63So8Jpq8E3DY2eHj2Z4PDhakZKr6FLjswcO4R_s1YOFw>
    <xmx:9sd_ajvBzH8PHD1wcLkYqKCUfAMDXcmnyHjowzyheWQI0m5UUzOaag>
    <xmx:98d_alAv27ZZQCZgCJcAyFsH5ZELwd5bFK6zQ4eCq6SRc_qSoVQ9w5bZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 06/19] selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
Date: Sat, 15 Aug 2026 02:58:48 +0100
Message-ID: <20260815015901.1236937-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B649F40005
X-Rspam-User: 
X-Stat-Signature: 7yu57pq1zh7kg4x1qt6az3rojdo8dm6c
X-Rspamd-Server: rspam06
X-HE-Tag: 1786759159-315807
X-HE-Meta: U2FsdGVkX1/NS3FxqGWs4f770zBnp88Zx75lSOgMZg6vqSbHDYQx6L89oB37UrG6L7RD/0o3BVr/0sa5jylhiXsDtmcQshBCWlGW6y3wNVe/toxIwUCfY5Iy1gc6ddkZKXqlkv75s6kQozTu8lzlLgYK7GsrQDjVgiq5Lm0haLL6qA1K4AWmWuI3Ruae5ntyLgxzYI4XnvEcWEaKKZB3QeHi79YcvPLhGMWjk94TAhZsa6ydjEGkYxyIFdi1OXpikkBXJ855CxcC45vK4gajQ3ZbfR9C2FHO7HdPQRaIPKdbUtT47PXaJK+vMPZipSEVUWerAdZgUg/Njj+w9cYPHqdlzbxhnhmXkCXc6jH+eOd2eGn/w5t/BM5DD7cdjkdJHOYdU9v7VbJnWJgPRYk2+Nw1wMWwAoNqJf0Pz24hE3bnslewzpfLcyAAdPkt/9GyxODXz9P35YfYCzUJBHPFu1nWghJJjwyHZIn868lcsv1Ww7L6hgE6tE7JZ7Jk3Y3CRgJE1TrPNr41AYdCCpClQiZmHC/TPYYwPnlj0zNlCsWVhNa/uqjw9ujkf5vtzPNL7I69tdwQjm5b01LckYsLrdX4Rz6W6M8B/83Xz5D3DvoHFMuirj1E4S/yFN+X4CnOWN3m5Cn8Ms6nxnRkAAxwCGphEYyYoad26tJNFVH06VnZggGm4XCBPWIvbPYOBJrNYS1LZtXM31oLqOuhcI8fro4Q5kW34i97vGUftiJd2qlu+YYLVMxBlfGoNvB6TNzcnrIXeEECgjV1KZbltgLwM3G5Vs4CWT+RwBUp2Q2dVYaj0K5GWeLpKPftg/qKUAzrEiPExqHr4MgQ/wGU4rdD8wIbCk9WLHTEOrC0yiwkWDzqms15wcUTlKq+zvj/vaNYtbE2bwP4xGG6MrujcgE+cVl5awOD4khYTN0Va+XaS/4zU8z3z1t0qdOgmVcXoREDQdmry7ym3akgDWNSMXM
 wvKprjhJ
 VI+I3tkVnfdBN+HBbbODlqZhjZoKT9s011V9UklOul3qzMEA/I8RAI91N5hsMGgKi1t4wm7zgU03ecDtYZkpTIJgfa4SoVjYe5S5mngeCgon7aCypMfalP2opFrejNRq4JDKDQ+EVAkDEWqxoTnZ7J1uEDEtKNB0L9CdSsQW4yk7RIh5jHDRU3eHJbmlcC7ufLVBlzNLVVpzJNrkzyxTCnkW0gBIXFefsi9t0gwwkomiTMS5or4iWWh/Jnh5sUuaKBgxnmMcaJ3IHCSks2sR8t768kSBZiav2yOxXK8smGCYS8DR6lDyt+Ru2Ns6ipdAr4SvMm8ZwcEwtlyg0YI4mI0IX0eM0jeYM7+3XqfIu9v7RzPGo/+R5OytC1O8l4Vsj/BsL689DqMDPpHaPu104DqZftzl7lDMJIKl9oOhvVO/VegsxFPNxxUtVVDbUky1ChJ8v361M6BIKMI7FS7khd6tqnAyA6dcEEhvN/PSZv9jnjw5DTjZUKcyAjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
It clears the global controls only, which is no longer enough.  A per-order
control overrides them, and -s leaves the source order at "always", so
khugepaged collapses the very range the case is working on.  The case then
fails on a collapse that was interfered with rather than refused.

Clear the per-order controls too.  Set them to "inherit", not "never".
khugepaged honours the global never and stays out.  A forced shmem collapse
takes the order it builds from these very controls, and still finds one.

Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 7eb9db0005a0..0008862e7cbc 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -550,8 +550,8 @@ static bool is_anon(struct mem_ops *ops)
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
-	int ret;
 	struct thp_settings settings = *thp_current_settings();
+	int ret, i;
 
 	ksft_print_msg("%s...", msg);
 
@@ -564,9 +564,20 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
+	 *
+	 * The per-order controls have to go too, not just the global one: a
+	 * source order left at "always" -- which -s does -- lets khugepaged
+	 * collapse the very range the case is working on.  Set them to
+	 * "inherit", not "never".  khugepaged honours the global never and
+	 * stays out.  A forced shmem collapse takes the order it builds from
+	 * these very controls, and still finds one.
 	 */
 	settings.thp_enabled = THP_NEVER;
 	settings.shmem_enabled = SHMEM_NEVER;
+	for (i = 0; i < NR_ORDERS; i++) {
+		settings.hugepages[i].enabled = THP_INHERIT;
+		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
+	}
 	thp_push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
-- 
2.54.0


