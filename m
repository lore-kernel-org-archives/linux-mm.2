Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9464BC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C27D6B0887; Sun, 16 Aug 2026 18:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599B96B0889; Sun, 16 Aug 2026 18:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0016B088A; Sun, 16 Aug 2026 18:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15EB46B0887
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 832BD160601
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:17 +0000 (UTC)
X-FDA: 85108620114.17.8689D8B
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf23.hostedemail.com (Postfix) with ESMTP id A139A140004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 5giir+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GApl5JHf;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Xh3qJFy3fUbrlN8Fy5RgHt7peoEA3/8bbzab7kXN/s=;
	b=uB4G57YKSPj3XK5ZIojpXldnUO13GEG8VWuPLxJNrRePq3EyMYbptjAGZ470rrQp1GFP8b
	COUL4cFPmQC5op/9nCqQil4Z44ypd3q6a5vLSbKBoHWbEUSjzVMIszQenzXW9B/LVAncCY
	IqSAhKDX8C9k6Z86DnjtsaIWybGTmrM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 5giir+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GApl5JHf;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920435;
	b=etNZHQHpQ+z+E0VvdxtZS1AINY7QCmZ1UtWzcEaRfJ4yMv90gex4pT8beCAnyz+nZe0N77
	invJZNTmTy+x4fpvy1LJajZOqGj3V69xCbVfoKvM62/Kx090rt84n4LSdAuQy8jUk8B2sR
	Q5DWolKyg3Vm9Ki5W0KBt5umlWsiLyQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 38940EC0242;
	Sun, 16 Aug 2026 18:47:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920435; x=
	1787006835; bh=0Xh3qJFy3fUbrlN8Fy5RgHt7peoEA3/8bbzab7kXN/s=; b=V
	5giir+FskG5CJ7dclo4ePNvd6SAwJqQ4yiFRkHkuQgTdwtX43TgBGCcujN18hpPC
	RtjvbXARIqnkKrr2hpRHpBYlBOeLlSJ0nyu/Al0vs+246WUCf9WlXUarCqwF2kFE
	omjK4nbjMDwDvNu6N7pPXuHBG7/Ey3yVmLU6Zv7W1ayBFV4aSyKwfQ5N04Xxtyjc
	u9glyesF+QjUFHPyqBM+qiOeyYSuAQTTlXgUCAUuC0mSsYGk9W9AxivavcATJvxf
	Gr42crPrhx4gE+UqaTqeT7txuIL8NINf/LYmAUQ8Yr9ahMsFyPw+ilLbnPy9ht8X
	RgDOoqXtnvB7pw/3FLNMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920435; x=1787006835; bh=0
	Xh3qJFy3fUbrlN8Fy5RgHt7peoEA3/8bbzab7kXN/s=; b=GApl5JHf4d23ZEorQ
	EMstbMXZUb1M4UgrkGwCFZMAFdXcPxOT6ROYUSU/cH8dAgE9NiO09jAP+z9H5Xhv
	VEABoGBQvAtGiWNxDNEfau5NaGo5dfHGNdJv6fzrB6LNxrLVw55XJQ8RwVn8UiNR
	haN8wb0Ssgxm8r44TK+Kw9fwY7ZWiUvDWxZA4ElLSbfgNDrymH6sIj2P10BWjvVv
	IADR1Ntgw2akgUPcVEsyf1QHZDh+sFA5OpHEr8RISRW8FjyO7cQR1zV2NE6vPcJc
	Fpi39Ghn8vQCcTQM+xAHBOLTOWKjWchajHE8H0BYbYn6GXdfYf862gBGJ+iaZDDI
	+BTtA==
X-ME-Sender: <xms:8z2Caq4-OBD-AiIgXEWjU9hWbNHj4kVcsm9hvUsvbO9s196q3igM1g>
    <xme:8z2CapM5HufFBu0pZ05nLf5hL2AEshucIhiVZS9TAODah5Xa8IOFaOUho9WF9zGS_
    8ygme3Kzere6SIzB2bayDsQjnz9ChkzeQPCYD3ed1UBMVvDwAFZyEg>
X-ME-Received: <xmr:8z2CaliN6nn2m2UACcbQtY92IouTMO_yENw3iTs1cSQcjBWDMx84pc0n9h0>
X-ME-Proxy-Cause: dmFkZTEDk+RLLWMQ2xmtz+SLrRm4SAAyqR0dcBO/jFiSra6UqVmtacLBiFsIEc4u4O0k4e
    TprFkQPKvch8mvItdBrQvHbw0cB+L9AXDq7j8E1YHObaRHu/NhSSUGMahPtwIv/D6P/2Ck
    /ZmAzcEVmv8/4SK/QQlss/OdD6ZYE8aT6ou3Os4qcrsJTku67URPEU5YsnAJoGYWAjn3Up
    7SKj7HM1m+Bk9heCO7PBXLylkVDNPLNBQlGmsET8D8iA96BjDQqliz/FRaUJqsbc23hZYK
    6FfmpWMzIACF8l0zIVIJGtLfQU4v7CVbie56C+ilpPey1dPs7ANiSUKA9aUYDcXfVHEKIB
    CBopL77cQG0VLaTu2WtaEqdiaZ5xCAD/3YiiT0Lq44Ym9vdIpYdhzK+jQXietixt7epVkB
    if3RNtS6b9w3JJ41Es85ighZoOawaKfc83t0IoYu4uoikAtuRK+JbqxDq/gaHo9YYFOBBq
    B65m56HfcLycTC3OwAjrSioOFCBDb40VhLH64PtRBYsZjA0+1n3CrhGCunvVAvf9rb6dEp
    0jfbxFptvtcfTYM69fB3mqD0o8Q3g3qeOYT+NVvJ+WlCKBClxubhwGBnyR/4vMG7vwnYjS
    uhnzb4yQEXQ/H5n2RPqlQYRsWTuxmq3VmvuT/9rB2mqs0kuK37xxe+LH8GWw
X-ME-Proxy: <xmx:8z2CajshiB69gzwXiOvYVO9qyylDxqLk7a1iMxVPicc7T5J2EtjA9Q>
    <xmx:8z2CakZplhn4MASd4j_fbvSMDjNcFNoG-kxxMVx8BZeQEYZMcibnFQ>
    <xmx:8z2CaiXVKNiJfn49BNdWc7dKEb2CWa8_7MN9bPZq5EEHwfv1Y1r1vQ>
    <xmx:8z2CanJTxqkiZtjkNB7JUeWLHOv8BqFBkd-p0oirHcfgTrGwRT5-fg>
    <xmx:8z2Cas-SLvdtpXL2o2h3H4eBUjfSmnIzbxFWh5JZWZwoTqql0Tr3MUyX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:14 -0400 (EDT)
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
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 30/57] mm/collapse: name the max_ptes ceiling after collapse
Date: Sun, 16 Aug 2026 23:45:42 +0100
Message-ID: <20260816224609.308019-31-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A139A140004
X-Rspamd-Server: rspam07
X-Stat-Signature: qtnw1d6xy46rqth5xi37o764px3hom19
X-HE-Tag: 1786920435-606754
X-HE-Meta: U2FsdGVkX1+hVdvH2AlFYLWr8eMS9XA03ucEuTHV2yFpTDKWoJk9dKEwU0Blmd40BYMXLrgovjXjNIR+IfWYu9sG6hP4bbWqP9PSh7KUv9GmoPulN1MdFMxG78An8l+HWuV4AKCW7FGNKru3PeQkAss/mZgpvqA/V/HckKduyGZTePG+GYSwvEy5k2570UEfLm/TwZF1URWUb1wt4QUqRVXqUf1v9DbmTf3rApsP7XMqMwh266Lr4zPLbKMCmdLTDeyNirLVMveesgiVvi4JP2n88TSdSQP+QZA22ZjdWDX/e44rs1j+vwD6uwRcymm5ujVNLginSNUt/rhLh1HvN6zXPqp/6YEk44vvcq54PDeFlB+9MGLemGtIJGs+QfK0m6LXaIjbUmhpwXOE9eIOdwaIEY6ddzeqKEJy2CVaIBlpU71MRaIl/FkMsVcHNvR6WcHDQE27cdp4rQ5+x9QEHDSXniwKz7aWZB/svu5VuHfTCged8GqdJRgqx2YeBYDvyW/xsRRTKL5HdUGgBLUFHD4O0nJTUvTq2PYcDCxBCipDiiJAjjLKepl/w6OhMurCMuHoUXK96gLR9bCknl8z63/RU4yDdrOWbfwyrjLSs2gcWpuM8+e0wJMglmsMg5WDnzijDX0deI/6e+rAaqoBemQmz+SWvxt+UiGipHJj1zjEgwJiK2nNhW2XMtw1Srci9Xip33zutd98j6X67fDt2g/4qUDa/cLUk9Og/w81lZB+os8nNNpw4DyTRMjMC/Mpie7glwlBaCxcbzxOQHG0nUAUS9jLKQd703d9P7x5MEl2dqt7uW8ZNB78lI7wf3ezxLh70iU/qWjzr5kzxEvJLeSotNM1/Mr3VXWf2v7xQfboAMqY/EO1UMhsq9xSwdTH2Eygtv//fSXPg8jJI12OZNDAF29Ur+ZiJ8+i4LHtqtrviaZ7/vDB+yOFG9JmFZE0KhNRO2r+hu3Z/ptyZk8
 hw9sm7gZ
 it/9iK1wDCjCZ0w3ZeInj57a6VhEccheqmohAY5A4ASmXE2hjNk7n3fu6Y1m//9rsWDRxRJLtyrkVncmUOPw7SPRNv8C9Y10TAGIaBcpxiRrZOUDhYuwkhWGVa4cwKotqNtqEZBs6i/hXaRYWN1MPjWkywcqd5gLPky9lrIrtIoRHGRroyysZ93ZSZLEA6AjTRl1JDMg00to1PGeU9Aq7oyHmW0QT/InZSKp0BmPKov+UuES0sMHW4mvldJBA4YGqRnv1JOEY5NXuAtG/SgZx8Ap/sQT8QPXPw8gzM9kCErUhwGkMRo4xKq+3S4GqlTRElDYtDwsOEQZJKnydzKKTXJ3ucjkBMxoXQcxT57PH5t0aeATSZX3qlUCZXhX/kSx/y0KXGuM7NHHaDI9wDR+qEKMhfjfd3YLH5G6Y+Ck8I32t/5+apjhc/XhawPwuFQ3Ffve++WrwMTms5KlZ/rLZK0d06L2ejzGMLuykJixq/4HceliSJkIV0wJLtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The constant lives in collapse.h and is read by the limit helpers there,
so KHUGEPAGED_MAX_PTES_LIMIT names it after one of its callers rather
than after what it is.

Rename it to COLLAPSE_MAX_PTES_LIMIT, matching the other constant the
header defines.  khugepaged keeps using it to bound what its tunables
accept.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 8 ++++----
 mm/collapse.h   | 2 +-
 mm/khugepaged.c | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 43a4b771bbe1..ae7c2777b279 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -193,19 +193,19 @@ unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
 		return max_ptes_none;
 	/*
-	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
 	 * scale the maximum number of PTEs to the order of the collapse.
 	 */
-	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
 	/*
-	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
 	if (max_ptes_none)
 		pr_warn_once("mTHP collapse does not support max_ptes_none"
 		     " values other than 0 or %u, defaulting to 0.\n",
-		     KHUGEPAGED_MAX_PTES_LIMIT);
+		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
diff --git a/mm/collapse.h b/mm/collapse.h
index 2fdb6418653a..94c11051f06a 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 
 /* Ceiling the max_ptes_* tunables accept, and the value meaning "no limit" */
-#define KHUGEPAGED_MAX_PTES_LIMIT	(HPAGE_PMD_NR - 1)
+#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
 
 /* The smallest order a collapse will build, and so the finest window it cuts */
 #define COLLAPSE_MIN_MTHP_ORDER		2
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 26c0e961ac9f..8c770e251c22 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -214,7 +214,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -239,7 +239,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -265,7 +265,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -330,7 +330,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
-- 
2.54.0


