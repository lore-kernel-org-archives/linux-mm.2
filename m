Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 465D1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616396B00A7; Wed, 16 Sep 2026 05:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF286B00A9; Wed, 16 Sep 2026 05:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE006B00AA; Wed, 16 Sep 2026 05:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27DD46B00A7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EEA1140525
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:09 +0000 (UTC)
X-FDA: 85219109178.12.8DFED57
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf21.hostedemail.com (Postfix) with ESMTP id 93E391C0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l YA4tGD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="M/lfS48w";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=062VynHgCC8xVPC31q5/ECQim7w7ZN4PLXxFdT/y61M=;
	b=aLktwzayqfYL8E/+qWr8gtaEp3MOA94wpsnbAIxTqhtpn3kBSGtG5hpDBmLL0QMkBCg9ac
	eCXMSEY8SKZXf6Q8DYwvBxpbl8bH9TmVaIrXO6FGXy0qNvmGG8ly33CFnsj9nYXanShKOJ
	ezi9yLS9yV0fmMKdl1Kk7Kn0v9L9LDE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l YA4tGD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="M/lfS48w";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551127;
	b=3NisxTbVlMoI+MN7bJh+bhf2pAyz81CLWrCBdtw2BGdsH0HQsi7iCUIx4cGStU0yGhpuv4
	uNqOlZ9JmwkJ9bBBTh6Tj2ABzsb15/BOR1EEn1CatsZqkoGr4zAN7DlRYBymRoti8m83wN
	Yn/GAZ4hYTcbpCr7ZVya4ARUHJF29+c=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 9AE901D000C0;
	Wed, 16 Sep 2026 05:32:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 16 Sep 2026 05:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551126; x=
	1789637526; bh=062VynHgCC8xVPC31q5/ECQim7w7ZN4PLXxFdT/y61M=; b=l
	YA4tGDuaEUXdSshUOBQpg3ITJw+gJfPUgJKndiA5HJok4wVPE0j1y8jR29V1A7xI
	mTCDuV3oWwpk4mX4BSPv0Pn59ZIb+lnbWWvM981rrrH75Z7PHdBN+c1+3Y0+LWi8
	hwqPghOZ0mrukMSgaq6+sKvY6NVtaJfCk4sDUNt52vsKiFdnBq/WhlG2vs8Cp6Zj
	qAiKbgW5RXlpTgsJbZhV85h+btXre8hOYJimVooZATFVQ3LCH2X1W5uBX9bxCS1R
	AEN1oRzp0Zb9Xsfs2cmmxWd9ksStBmYf0FyOnLZIAOfVFKNpsAITHtwU9urVL5TT
	cUxfwG/td7y1LX8MmeRsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551126; x=1789637526; bh=0
	62VynHgCC8xVPC31q5/ECQim7w7ZN4PLXxFdT/y61M=; b=M/lfS48w1vBKqGkGG
	Xy0GzfOd7uHnXGTWI1kYRTko4zSYLmvTQ/8JEv1Pdci7dC3U6XZG+tROk8MXxszJ
	RS/lYFft4QOzek1cPY7Ge7tZmji4DMS6oc0isresHnIVVsNA4Bmn8gQEDAareaDw
	3s1jIh1685Zn18D68dhYe8MiqdGrgDHtSyCDuD6/uU1iWkaCZeqLLu+92LhjMaTc
	QF6nmr9YNxVYZuPKh3qk4Pb+RfKJzOXL4zGu85o5wUr3VqNDLfTeR2RWF2Xjtgie
	BjeL2QCubnKsImz83eMv+rzY6IssvZGh+1RHxwLmRdQACdK4a+yvoE2mfHj3Rn52
	VNWzg==
X-ME-Sender: <xms:FmKqavZ7iUGHwKf7t4fLZ3eeNFY3tQlAkKmn5KF5DUt4iDRkpN8w8w>
    <xme:FmKqaqWK9VDNINYNAGEgYeAjPjlVccxyQJ-vN1G5Hax6YMRYg2f5OjXgvhFAvyftS
    Yty5mCH9g3QapQEjkg2SXb46LU4WKd1b0YaSdQyGQXtoH1kCoip7LE>
X-ME-Received: <xmr:FmKqaoHiGbyvTv85w2ax3Az9V_0WLiBBAmYYpm6SFOPiDOiJihEW_TsPntU>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/iJl
    lc3V5TABAj6mTg4ACFiNaYBUz8Ii5DwjGy2GmhXthAfksiDj7e70MT3WpdoHVOuJI1O8Qm
    E8NFcOwg77uMOoboAwIwRFbkhNYYpy+NvnBA+GtXFqiw+RNCVT+uCpatG2VsXQn1Z/liYj
    9GiuycSPw1uxc/sFOEUyq/kTFTl8tSgLdCzpbE+8A002Mwn9A00DlApggnDWYU1+5Kcjig
    XVgS45Kf2ceX/eI2JYS6H55MiSAxmF5DMAvd8iiKw0nLeBBVSMANNUgq6MlCA+tk1Iptix
    DikWe8ZMtvSRRy+crQHb1ebR7xk7I68EDh/Npni1h6aiblqQL5dW1nfQ5F9w
X-ME-Proxy: <xmx:FmKqasAvFygUsChjTJgYRs9cPBqkVEB1OZ9-NwlnxUIEE0QRYrHYeg>
    <xmx:FmKqaoyHhXjlVPfPlkFxVOX3qaQc2qt4a0METJQfuaxZOQ8KViKd_g>
    <xmx:FmKqalAa20JpAxodoELlkKOxprtGwfnGq9JR9A6ZqNKGEYay_sXX7A>
    <xmx:FmKqapAzTT2qfNRrTtdFYUftEcAeSCTau4IVw2_9xK6jvoCiyUNn_A>
    <xmx:FmKqanbs2YAgfp3NtGJyCaIqutSIoejsNtD20YkaJtWtFk3FocEBpXKB>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 07/12] mm/collapse: name the per-table scan reset for what it resets
Date: Wed, 16 Sep 2026 10:31:34 +0100
Message-ID: <20260916093145.4022188-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93E391C0002
X-Stat-Signature: d541nm9paog6pjikr56511y3cz7gy7is
X-Rspam-User: 
X-HE-Tag: 1789551127-532347
X-HE-Meta: U2FsdGVkX1/b0A2THqNFDGps/IjqVJk6Ck7HVpn735PR1B3D5dcB6IXokmZcVO31VNxlQuI/nzJrU1LumnHwmDi4mQsoHT2jNxgqoASYVBUM+XLLULvLo3TDtQgqLwtcooWzy/9rPxQx3grmX9HbLbSk/qjqhJJpfaMKtAASzIeVlm/n77GMcByWB9qNTKP+NL4YeSxmI9BtdUU7GzxHAVSiBQiajhse4vk33J7w4kWeal80DboWpe9kIDf0XquaKLKx5c+oQSnoNEGheXT1x0lrCTXesmYr9sBzsMrfZDA+ZzTSzOTrkHKuizYu5h1hi0JQyX4xLgQ1a9rfNOZWkoPWJoPW7Nu1xGQPGIK0/t4snP4JTsdez9Zg9OK8k9hd6M9uLJ48sHBtkDKF0IAksffP9RHQ+vIKTtpXX34f0XqqLFiroZNyiYmKwwU6k0vVbTemigivRBak5jFR9c70R61G9ySgz6Ja5hjd94rkbb1gtrRPeREkTwSt/3/0VFlHDjvLpS0kDNE5prfjrEKuDbYseUlNUPFfs37XvgVFjBSubNipvRHnrgm53D+qnJlx7obFLrw23k5Qhv+T7bOqqX7U2B4yJB5Bd4dqSBh9O+8BW0ukn6eOzREyGKbBTfMoaXL5d4Lm0MbtQsJ0v6AOa4rXSrCqqZfWU99y8/wzvDHWoeypjfJd4M5F5pnxr/zY91+ZLqsYNG0hcDiIO8koarhXoTo26rM5j4BopZYiDULhmskKorD/qNnGDv23x+3yhNtXm8+RmPjkBd7v7aAtsN272oNtf76qfHZDP5M+nktUl4JXY/vy1oLlp74+HJ9JkIrn6kgWIPNob7eyK5LLKxkAUZRQKzfnJAIOl6N/APV2IvWViNQ6e/JOwuwnIw/nE/82ATvpU4aKfNJ92iBUFwTcy2zZq/M7bA+8ToFE07Wjz6Ewoy+985bppFhtZlhUaAD9oQAdfdToUTKECzr
 ZBQQbVBq
 m5vXeDwBXLY6jmlVromeKa38Go3BMYGz136zaJ53MIWs4g3CqS5lu3cuYgvwVWoYv6qgeXxDtH05EeLFOYJ9xCW0XBAr8+VtQCw2EbC237EeGP6KuyUlxuz0PWDbnHmCE8dW0IhgXofflAul3gZL5ia/63NZuCEC9T3OHy8OpWu3ykmuFPRhRFlMOBxxNAaWDmLZKe7ImzLK8zCeOZNBZ2U/73dGdqtcURAbh2Si2KB4Ku7T0s1Q27bssy687P1IfdVMkCELge9W4UQ5e5Grkr2rlxisDRU8dYD+EDFKu21RRJWnBh3vlbw+CU8TnlM1+bCtoUGuiCdGBHTh8OkAkQ7jTGvXNWoCb3qjCTcjTH/rtwVy6riFvI+abyfsl4hKUNrbMaEdOpF14+g5YEjJpbPfOYfA7/zwB+1PyU0VptRY9pANjM/9CTSRiIF6ARzBkBxDZi1alv2L95fag4n77EX8FP8bKT1DrJFqWLJHqTfayZpKKiGzGkTWcQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 62bafe509bb7..ff1756c1255d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -550,7 +550,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1579,7 +1579,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2657,7 +2657,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


