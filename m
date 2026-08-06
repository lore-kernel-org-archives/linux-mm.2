Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080C0C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FAE6B009F; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9171A6B00A4; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8591A6B00A7; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61B156B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:32:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAB5E1601AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:33 +0000 (UTC)
X-FDA: 85071841386.29.47CAF97
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf07.hostedemail.com (Postfix) with ESMTP id ABDD540007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTJMsHdSs44dSpJSAFGcjCUEz5K9OSA9YepeBwc/pfI=;
	b=5mF+RhQ/LW9ogLrYDOgWYlZ2y/hQGQZ11W4iBXyUKVgl/nH0cS0kUIluBTgpAxAtI04488
	Sh7hUT6LZbTZZBN1Wag0CU6c1watU168UGp4W17bDFbtQJH98ziPDcq3Wowd2FVOd1XD4t
	XCmyfvqz/fgOAYWKquoSpLQxwG/x0qA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044752;
	b=K60kRnJ4O6yFC1y8XsB/w2tE/8wLakCG84jTns9m6ERHsgQMQHi0vdD5Xi88ugkyocU2tZ
	Q5SAoILEwLBbYK3rc1f6qJc0ZgfELVM1nf8vktTNr7dB71bwrbUij4T4xSHfUWqtspKR+O
	elPh/QSVHnvBVaD+OqXPAip7KdBApqE=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 7 Aug 2026 04:32:28 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] mm/swap: fix stale comment on swap_info_struct::cluster_info
Date: Fri,  7 Aug 2026 04:32:27 +0900
Message-Id: <20260806193228.458685-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806193228.458685-1-youngjun.park@lge.com>
References: <20260806193228.458685-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: atokqqswdj7kzwr3t1zt9kih8zdiwgs3
X-Rspamd-Queue-Id: ABDD540007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786044751-170971
X-HE-Meta: U2FsdGVkX1+EWapbzTPolAAgElbcrHKwt8OrZy26nvpZiTtFpJ+IcFq2MaJUsvPR/h/TMLsMA2wpu74CEHFsh7XYxZ3G3GBsvJgFaTHzviqS6R2W/7em+nR70hw2Rl7OFjUOsLZg2/f0nhjKuA0QX2/29g+d90VLzXnKCKwYoIx5GleanhTxKhUn7QsoC01TWAnzh570f0XIcmzJb3GFt12pGQVOuWZ4mImWTS381tSgosoyKRqGtfgzyULUep8nS5jcySCvdt/Vz/24UZyL2Sl5PQOBAB943PcYJFYgPYQmhwN3h4Fgg+sHTwAJYtpIkY/tqW4FZkkqb9WN/d9SkVu7XQ9DeJbhukt5HwhizfPXvmvO9fnEOlWovRAy2HBJkWeZEgDa4cgCJNKVpXBrldQ15I1jk2eV8ry9Ni1APkH9zS+gjUBBgoOkkrupCH+Dk/giuBnFdQ6g3IL3UzvQnsTdD5LxL669RyTDyLTOkNK1zI/V8A+Lpy8YW9/Af5XqWp7ezSn9EwLzwhapfb/XI/IeSCL9Oa9AhcIm77niozBCLIVyqL7d/8CyjCaAJg2xObNfICjoDlWy04UJaAfOiNyAHPoHTo9Zv/AuKizv0rRkwZus94kg6yac/+h0OVcjGgSIxVGpBzBl/HA00FYoGKqoZ78hT8dcxCVamSwYUZlVoYxAgEjHs9kTuL06oHClmp1PRulJUkK6yJA7JYRhIIAC1Vf7XhwDihV9yQ88eLCezyfr2wiLJ1vTSzKZt/YcjXcGePYaM01pHxZ49LN8JD6/x38I+qI79StAJuMAgd4I8IF3005l9mOmPoGSqTLvo1sSusJmnHtBDJtpXyrT01U1Xan5ifH79upvUyGKFYH8JkviavhzP0ewVIJRLLT/UB6GzHrf0VrTqQm79f/aOhYDLQGC6UMoEN6apEP2Z/++Gml+qTH9Ktu0qSZqrUnKge4lXTyriBLUJXH7kND
 D7zKapXg
 r8Lf+Y8YKkM7j9Wc5QnkyCul0ToK7rtt6MDw8tjrKbKOClJIf43++9TCsPqf4U9y/jIHhO6sPzZsDd9u+2DqAV7J01AaVLvsdYwpJRARltmO+vVKzYTrSKjRz++vzEFJLECyOdCXBMtUKtk7umGD0xFE3BuSU1b1IZ4h/d5Zh/SQ0zxLYkzXAPxh/ADZ6vPB8RLzpwI7w9GTkk4N0RElRxkBgBxnetN4KADEQ9T6gSsyFSp1k5ZtHLmk1cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_swap_clusters_info() allocates cluster_info for every swap area,
not only for SSDs.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2cb1d29307c5..2b14e2e9673b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,7 +246,7 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
-- 
2.48.1


