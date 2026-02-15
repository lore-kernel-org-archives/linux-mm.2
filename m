Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FA9EF5870
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 10:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E186B0088; Sun, 15 Feb 2026 05:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063C26B008A; Sun, 15 Feb 2026 05:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7FD6B008C; Sun, 15 Feb 2026 05:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB3D26B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 05:25:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 723FB1B4027
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:25:39 +0000 (UTC)
X-FDA: 84446309598.12.E77D6A2
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5CF6F1A000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:25:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyGhpJpQ;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771151137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5ZfG29FZ8wVjzGY2sY5PX3vPhnOYrCYILyRw0LteQc=;
	b=6uE7o/WPN4jd+4kOdEL0nT3hRxKLXqniIw2+QAGPSr/8v/Y9/jCgJLw7L+PHnmmCxaMPXo
	0O0fiIf0z6M+zaI+p2ARZiGCPPWNWYkHKHwW6cYfPxdeeKkGRShVEroaueNK3NkvYRShyS
	wUpBU887pF2ivm2QNcEB9vDYKd20CdE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyGhpJpQ;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771151137; a=rsa-sha256;
	cv=none;
	b=wrU6XaN1TXvYP13RjMOyKzZ2KJ8QgU+IxSLAAL6OHPxwjalfzVT317Wbfzbpm4MRWly09z
	ffMa2jQzX6eY1BPvxXsmPYHVyg+70u5DMCurM6pPgi9TMazg34sQohxqiTePXzuYjlyZ/a
	GL9IVr6uxNGZIvv8v8C5ebjZiV3+mi4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad20007c73so3068175ad.2
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 02:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771151136; x=1771755936; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M5ZfG29FZ8wVjzGY2sY5PX3vPhnOYrCYILyRw0LteQc=;
        b=NyGhpJpQZktJkUTmXA/K4L/ZS1cVNvtT2aTTA3IgIoI9/m+4s5TZhkt1DiG/YxHJFT
         XX+HWhHBw7NxVaQjS7en5i4cbCLX0iFePgmyc+PvdrNExwC1pClb64vqTyLoM8OQWowa
         tWy60cfnkB8PFYCsw8pn38fCSqvQuHAA1dP0+1aZG5efdfdebkTe6xlEjDOUHFRxJo60
         IawMs14SgnpDlUNuzoEHogLkr1nSMKLXHH2P74BXK9bOYcKk++9e1P0YpkiwIbg11eL3
         tla5Q+dKNHxASPfxa0GsBtagyQyV5BLHuaJCvpw7bq1P8rf2bn1wQN55Iyx4iXXu4X8i
         Jyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771151136; x=1771755936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M5ZfG29FZ8wVjzGY2sY5PX3vPhnOYrCYILyRw0LteQc=;
        b=fPbfVneFA876rwcOwuLPy4k94enpTVkBPHrzqwuWb3mstNPDpmV26Nuhvsv9O0fLo0
         lS56QYeWtWhBZR+fHxoOXfVfIzk25iWZ6UvEWLBLVCF50Qi6BDTzQA0cHTBHiAamYAus
         HeEnXgw/zknJvpN/VuJMyl3ULq1gmStsQ83qzeGtPn+HdlCxuDXLlVj2SKZl8pLe9sUI
         4Fed8fRnCMKyT2BpmTdDdEK0LedTpyXVbEg8uiBeUgnPK3UUbAMJQiiyuUoJHkm+kixE
         pIjrciczxUQqetPu4JayAb/86LCeLQhS1jZZwXtkdJzvtNFA5jweIcgBk5slLwWDD5/P
         ApJA==
X-Gm-Message-State: AOJu0YxUWXC4t5a2oNw68ua5kDaks4SJmEyaWyG9isk1B9Y+uu02OE06
	PMMFMMfMpHINZ/NqhwhyLYQOS7abQH1EPeD63U1aTXholsCZsylS0VCZ
X-Gm-Gg: AZuq6aLsjwQ+njtIMBcpKVyco/cPrkfsVPKUSnIenDHjBTKhZ+53oVSmBO8g9yt0hsH
	6Rg17SJUTQo0ve+7XO92sXdU3hWkl3gHZiSIw/XxGVKIC5/I0TTNe0byNklrhbhceOB5bjXnOr8
	aI884lxwGPhNJuYtihT1u22xGbp9qX8WjANB1MUSmbkZajANLEU/X0lsZi5nNDc3GAwDZFpT6LT
	AbZ4gdbkosHv3CbB1lEr6BYhTegQzaL7S8HVKn4zIEVQg+CDuliCLX+6Yl4F6iheKSLMCT9XYEQ
	XkdHP+v4YtjKvAeRL7rryaMyf4uJv/fkGHnFE/uiO0tgdErWxpYLVikK9mr+EsX7hW5seYOT36l
	qfc/ACEred9zcvbVQ04sxggGKqOmLS4YEBdEzE/7Lq2p7Mg0V1A8oV3dFoJiBgPbR7zmXm4+dc8
	s9CK/pXCgD24HdOXhcVThztXSsZXVhGDI2/o6qp4nCnKM1wsjjE44g01AJws6d
X-Received: by 2002:a17:903:1c2:b0:2a7:7872:8f52 with SMTP id d9443c01a7336-2ad174a9143mr58528075ad.26.1771151136229;
        Sun, 15 Feb 2026 02:25:36 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a714786sm41862045ad.31.2026.02.15.02.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 02:25:35 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Feb 2026 18:25:10 +0800
Subject: [PATCH 2/2] mm, swap: merge common convention and simplify
 allocation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260215-hibernate-perf-v1-2-f55ee9ee67db@tencent.com>
References: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
In-Reply-To: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771151125; l=2753;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+lKDO9BRU6kc51T9mv3KyI+WElk31bKrGwbPt/FiL4w=;
 b=mc8fhlhZndV1qntjOVtm5dnTc05MQRd1xhCwdQbwILalsMpHVxJCLtTKLY8kHpgNXluNOsPei
 GAN9PELyjVmC94zru8UxwPQxV9dNA8wexNL6GEtskSPCreFXRwSc4/4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: qhiwjce1y36mb9omcj8jcr9uqfw74qrg
X-Rspamd-Queue-Id: 5CF6F1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771151137-404040
X-HE-Meta: U2FsdGVkX18Er1cN49yXZV1q1AdjvCmLmmN5u1ANXGdy54DlgKZ2BIhAhhqfE3y5wrnG3ab1bUbqselmy6I9m9ELgjplcG/T0O/8GExOCJMrSfQLgEBtWb3QKslbnmrK+0CeyPojs2CTzPQ/9xEcCuFr869uSdaneTlR+rpYw+Zt8DM68/woCUD5RsWCpP69vaWBKSUKMlPGLK5NIHk476SdYb/Bo2NNPWb6Vh2N0w70gVjQTsg9SY4BjZMh+T18ehoUB5EgwmcUCKkRi8SfsAxgKsPEXCpwhGXNxGBXitBGMy1uQ+w4bizo54Qi+Fpoq1I5Q+FLx9yalI3ELUBkO4pvUVZ/pYNmDLKuDxbFFwpKbYchDLFnFvgtTh1P+FdjnCN+EnRqVRWYhNFRDJVzRo3yFkGSIeb+EJTMhsAuSDhgXZ/SxwEyYQliTWJRA0gs6umDvJKeUaigzE+aq3B653urEkHkTL9EQ8+QcQ67aAS2kngtsNZt67+9alMkle3xcOW+gKaRBUWEciVTHXRIVbkwcZYidBwTmhM/iamGylTl3n01KaRgGaYy2hUKBTkVtoGd6dA2dTk5izF1AEQM+5UWYq0TZapgy0ybJ24QK3S6hHIKMjpNlmEswRo1QMOk8VufgIR1yP+zO4W5oBikBLd8Aj4DaK+6yINCOSk+E5wPeiV2MO0a0iPbdSoIOsB/CRmyRaPjxzRY8TG1wYX66JY8dHoFOenDIsRL4/9vyuuZygihh8381HKlDTwxukW9G1ptyaqZwPjmZVZrDO0UtH5X7FOmzrkiYOhSyePq5WeoeDMCdeQ6o1nLCksVGvHMKoH46q/8mHVSxeyJHLv458Q2dIJFI9bliiSWRlRy0MEBtVWy2rWq4rouBhD3kHT+b7ilFWzcL3PtoMuRKBbK1l7WbRYmXL54cTP6C+rW3RnmGR8QGmF3pbVK8CMjBnIkreFzjI08G/005xgHbqN
 zfCRWQ4c
 gljus1vgrFMUGLxbMSNWZbqcK2gefZ14uCSrlP8zGmGyGemkgLndOGexMbohQwVmz3xTG/KxM5aJhJZWELR1uBt+j9wZg3oncb7ALvrTAdjZ24rlWK7qLnkz7w+8qgxTDddkE8NfgTcAbzumVAUd2hvhkA4ODfphI6gBli03a9QdxnPFt4l0HIPvN9VdEa0KAUIdwgaI9KNXWys4W2tsMZPnWEtBnlv3tf3ECO/AmUOAxgF/hrZkscCYMHWb7JA+76XMzhSxvQNx3D2hfv9MetFbjyWrSecqyrubqnxocrTPvs92/P/VgRO/+bNC5Q63HtXc4aLOEnBr/o3SB02cMx8suW/17Ei3fw7mWTLNETwqT6PIojR3EZ6qgbtJTZAUNJinOI4K8xSw6Iu6i7Nx6npgZSNAiRbBZoRD7FIBZApQiDTSJHGx8C/36Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

almost all callers of the cluster scan helper require the: lock -> check
usefulness/emptiness -> unlock routine. So merge them into the same
helper to simplify the code.

This should also improve the scan slightly, as a few callers didn't
check the emptiness, which might help reduce fragmentation in rare
cases.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bcac10d96fb5..03cc0ff4dc8c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -923,11 +923,14 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON(!cluster_is_usable(ci, order));
 
-	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
+	if (!cluster_is_usable(ci, order) || end < nr_pages ||
+	    ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
+	if (cluster_is_empty(ci))
+		offset = cluster_offset(si, ci);
+
 	for (end -= nr_pages; offset <= end; offset += nr_pages) {
 		need_reclaim = false;
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
@@ -1060,14 +1063,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto new_cluster;
 
 		ci = swap_cluster_lock(si, offset);
-		/* Cluster could have been used by another order */
-		if (cluster_is_usable(ci, order)) {
-			if (cluster_is_empty(ci))
-				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
-		} else {
-			swap_cluster_unlock(ci);
-		}
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			goto done;
 	}
@@ -1332,14 +1328,7 @@ static bool swap_alloc_fast(struct folio *folio)
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
+	alloc_swap_scan_cluster(si, ci, folio, offset);
 	put_swap_device(si);
 	return folio_test_swapcache(folio);
 }
@@ -1945,10 +1934,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 		if (pcp_si == si && pcp_offset) {
 			ci = swap_cluster_lock(si, pcp_offset);
-			if (cluster_is_usable(ci, 0))
-				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-			else
-				swap_cluster_unlock(ci);
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
 		}
 		if (!offset)
 			offset = cluster_alloc_swap_entry(si, NULL);

-- 
2.52.0


