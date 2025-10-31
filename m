Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FCFCCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607278E00A4; Fri, 31 Oct 2025 02:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8028E00C8; Fri, 31 Oct 2025 02:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019D18E00C3; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDAA08E00A4
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88EC3589D8
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:14 +0000 (UTC)
X-FDA: 84057495228.19.3496BEC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75C7080004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4o5NqWFT+SN/V9NMc/VvxRjbFJJYlvHWP1Dj26dBzi0=;
	b=xXb/vXxmpddNi0HJOFqePH9eh5TVJcFFVnSbIkdQ3iMAxImw7OmbXakXczON2wiGRdT9Xn
	DkuVXdKF1lf17CCPQC74pl+T/o6cbdWbZBPNfeuHWODn61K4mIgxxAlUeo1t2rIIK5cbyj
	6N6IItEcXtqJ6JpnUGVx1FFOXoKXd6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893653; a=rsa-sha256;
	cv=none;
	b=L1OrZu+e2mCkylaoboiVAsPoAd00V/zNEdo3fBSPkzvKgrIYE+0SdI/j4YVpf8zJmH0b4U
	96fumXX0V/rjmfLiPWVNNZuKoFR/nsPfHvFDm8dfvUaeh0b7OGkW4QCo9sG0PgDDC2kcpd
	S21VljO+ubtqXupIpUPGbIsjRzpx1jU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com
Subject: [PATCH v2 5/5] mm: swap: remove scan_swap_map_slots() references from comments
Date: Fri, 31 Oct 2025 15:50:11 +0900
Message-Id: <20251031065011.40863-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251031065011.40863-1-youngjun.park@lge.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ptaibzmiwsemqz3wj9t7k8hppjuxa98n
X-Rspam-User: 
X-Rspamd-Queue-Id: 75C7080004
X-HE-Tag: 1761893652-25080
X-HE-Meta: U2FsdGVkX1+Bupsg2Z7iov1T/pOMQAQVwj6Iv3rlX7YLqUjbKsMr7yyrXEG91YVukuiPELALUh/lXKX0hqeLFFh0phUXaLd3jjz220qH/Y0Tvk+g2+W399U1OwaSIiXqWbh+jUM/uOqJlromAZaj7jwcSAIu1liGxiqnMejpOhuHXi5lzRlY35LHlMpSHBmUqWvSCvga/O/aKEbwy3qh2WzUELOjrGgUr95cCruJZHUgr7MIKKUHE54bmZp90PSJ9qQD5HZrmgSRTY2xc+AJm/RfJqlaAVuPVvWl97X/v4nyokVb2cprjHhDjYwW94DEfpXjSw4xprpfWDIM8uUaWCWTn2WWRU4g6D6vbMdN71qx7phyK5KNu3+SaY5stN3jcx7DeYQFy3PnJ+nO9L/hZ3oZfqN0Q3SoakCDvtp7YrF1xLHCZDFVqhU9xDhCH6iuK2wAej9iIaBsskJ+raFc9NCfW5DI3eetVCEiQFMrDA1SVhBzCg/mhO3Y+Q857QGv4/n7yIB1PdHBIXL2Zs6NzQA4XA8CkJLuVER8JzDvDm7g9DKbN/+NrngaNqMr3NDiQZERb/xBgfvXq33sR8VnRGgA8rkBvhrGiwBe8kvmOUL7ww35AFKVVeh16okGlyLd3LSQSGcoEELQcUDayQQa4z0kxIg/Nn90B+Pqqqw+NNP6bNjdXbVDm4EkamV0UsMtdoFoK61LcFET/qD4HoIvbm7y//dnsqko1hZkK5W+cqeoEZH14O7azKktf7ni6fscqofrGGpTh9PDHEdd+3j02ufnnqAlBR0K0Hs0BCs7mJ8Efx4MLsr4GoM5xmLaEeBLJegD2NkuWpr1QyNOgEgQAFbg0J0jQlAeXY2HFEVlsKmAheuLeR8/Y8W8h0NBMfzaXhbXyN96Qp0mcV+9asgutWo/BcfoM2wfeGbJYF077wAii0V3tUKeI7eyO7US6gdutnaoou5Ags0WDMnK6Zj
 3x9FAdxg
 0DQPExMihQcvpcyQmUhuRTgZQlPTGBAyoyCfvkdax1rco+8QmjTxZnrgZFSc/4Chfw9/xYWP1PEFGMrBDCPzhf9d0UaqszhUU8fAz6Wwswatvf7XfAwJqWD33warp3sCquwjvouUWvFbZClWbAQDY8YTeFHD3adSmKWdZHxWViXDgr9dVdd9YcJamDPkrMerD0JgxIz3SGbjSyPs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scan_swap_map_slots() helper has been removed, but several comments
still referred to it in swap allocation and reclaim paths. This patch
cleans up those outdated references and reflows the affected comment
blocks to match kernel coding style.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4f8a1843262e..543f303f101d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -236,11 +236,10 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	ret = -nr_pages;
 
 	/*
-	 * When this function is called from scan_swap_map_slots() and it's
-	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
-	 * here. We have to use trylock for avoiding deadlock. This is a special
-	 * case and you should use folio_free_swap() with explicit folio_lock()
-	 * in usual operations.
+	 * We hold a folio lock here. We have to use trylock for
+	 * avoiding deadlock. This is a special case and you should
+	 * use folio_free_swap() with explicit folio_lock() in usual
+	 * operations.
 	 */
 	if (!folio_trylock(folio))
 		goto out;
@@ -1365,14 +1364,13 @@ static void swap_alloc_slow(swp_entry_t *entry,
 		spin_lock(&swap_avail_lock);
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map_slots() can drop the si->lock,
 		 * multiple callers probably all tried to get a page from the
 		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock and taking
-		 * si->lock. Since we dropped the swap_avail_lock, the
-		 * swap_avail_head list may have been modified; so if next is
-		 * still in the swap_avail_head list then try it, otherwise
-		 * start over if we have not gotten any slots.
+		 * filled up between us dropping swap_avail_lock.
+		 * Since we dropped the swap_avail_lock, the swap_avail_list
+		 * may have been modified; so if next is still in the
+		 * swap_avail_head list then try it, otherwise start over if we
+		 * have not gotten any slots.
 		 */
 		if (plist_node_empty(&si->avail_list))
 			goto start_over;
-- 
2.34.1


