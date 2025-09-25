Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE303CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 03:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBB48E000A; Wed, 24 Sep 2025 23:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABF38E0001; Wed, 24 Sep 2025 23:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8838E000A; Wed, 24 Sep 2025 23:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6F58E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:14:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFED5B7EC8
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:14:17 +0000 (UTC)
X-FDA: 83926304154.24.5058556
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf11.hostedemail.com (Postfix) with ESMTP id 441DB40006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:14:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758770056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=or5IIOICvBG5fnofhCOKwPGI6eYQXIuJiw40NI9B7BU=;
	b=hL9RGc94uen2dKENdvNBGa4jdhDYDgFUUQD2kv1H6yCHUAh4tqjdrj2n+I1R66i4IF02XE
	eUDpNw41Vc7QjoBBKjeR4/vCxd6SSZw1ISn2CIrkNbIA3ydMhuauglp+SENTifoSFrtnVG
	PRYoEjIyNutHMFeOZprE9MzskUZOgTQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758770056; a=rsa-sha256;
	cv=none;
	b=tYkGkJB9tISBz8RF9Tf25DGqKPCNtD4CLJcPM+4xUOvqOFXZwnZ6eYESXy3vdvydbyAltd
	hBsn0JJqW7tdrKM2yiqQazn6sEluqXExLPXvHOT3o4ThCOalvy7kx8NnzodLjfFad2JDLp
	YOoX5RUyzRtSPushxNmtQgM1t9AFxGk=
From: Fushuai Wang <wangfushuai@baidu.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<cuigaosheng1@huawei.com>, Fushuai Wang <wangfushuai@baidu.com>
Subject: [PATCH] ksm: Fix potential NULL pointer dereference
Date: Thu, 25 Sep 2025 11:13:58 +0800
Message-ID: <20250925031358.80983-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.72.11]
X-ClientProxiedBy: bjhj-exc8.internal.baidu.com (172.31.3.18) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 441DB40006
X-Stat-Signature: kiw19w4yes135pqfu6ddjguao8wu8y1x
X-HE-Tag: 1758770054-796332
X-HE-Meta: U2FsdGVkX1+pa4aYrskg6fH7iyTGIfOxRrzY57nVy2bnZ9YxLk2qyS2XgpvVIQgysMxxADhG8cDXc+6FIHAEhqr5eHRTfJhbLphnB2BjIzFcGkC0emjW8oqfbjGFHNK80sK/bgmkIXbIhJiL70XSK6ORdMRdA8r1D4kJ+SKNSEbeyx3ZLFZrrZlwSIObf5UfQ/GHLFs2onnaLPQ/qwaeTxY2+NzHbNVY+CQUynL1XnOwUxKh0a6uYJgydTXq8azEEalEMTnU7BG0g08hM8ZDzE5tqb1mCbW8Vi7yv0s4rqtiztyNE+NLEYnsZwOojFZMDS5hnrTx+0IT8bvePMK1Fd+B5vPGQaEmgyKNgs8ciDlp42rhVMeH5N/YSdbPmrX+j/w/bJo14xIk8StOzdahTgvl3W07Q2MmaYj1qwGI1QRyHnBwCoEtBomfyXTI+fnCeFjCxZ5wrVSltof8MpLjwoeNM1+UXUcZYUgw4EXJRD/Fm5Ng+6OC55CfaRtXT5RyJH2mBir+vNKQZiOnpgTvVeJzBmLgmY0A60ICaMbIZ7QADtFDBZ4au9yg7cGNJm7tSnHYT7dzbazHbLOmpmP1foQlG7jD+Z6pXsRNOFflm/azEN99mWs3nGESBauvgw6bXM1oU7NObcgZ6HY+ykcUGaOt2e0jk1YtoUCUl4YZPrs4UGiqWVreRaZHVxkkXPBlxb22AVyGmZc9fpRHqvdxZIKUUX++obSdWOi8kT6BszU9zdukARS03Bi1BQbsfJkPm4ILux/azHlAzo9hWHb6T63vOZnZeSC1kVM88rsvBlyECTDHWLBXZpxKL0rbo7KuEAeyAarPKdePmY1rSTFtmX1+qUrRxvl444oOywArGOsAel6dEEmT6MvqmiPAqs0U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stable_tree_search() function may return an error pointer
(NULL or ERR_PTR(...)). The current code does not check for
these cases before dereferencing the returned value.

Gaosheng once added the necessary check in commit 98c3ca0015b8
("ksm: convert cmp_and_merge_page() to use a folio"), but it seems
the check was lost during the process of being merged into the
mainline.

Fixes: 98c3ca0015b8 ("ksm: convert cmp_and_merge_page() to use a folio")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 mm/ksm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..7aa9b2829a7b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2272,7 +2272,8 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (&kfolio->page == page && rmap_item->head == stable_node) {
+	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
+	    rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
-- 
2.36.1


