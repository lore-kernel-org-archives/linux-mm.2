Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CD3CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB3F8E00BF; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF1E8E0045; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0238E0094; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67F578E00A4
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10BEB13AB91
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:14 +0000 (UTC)
X-FDA: 84057495228.02.B70D934
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 28606120004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbmv7Rn4/1R4DyrnY20/lvULMdGMV6gKvE3ptARpLvg=;
	b=GwuuQsls1XOJrkpqvizyrOT/IDkYcVbxOYGvn/bFlzOC09IcG1L1s/aSkvX0WbH5CQJQDW
	3003T+WGLALnC8RvdruD/AeZTRTBmLZDmwhVJ4X6DZWYI7tGf7f2R62hk0q0MXSwNhTgQP
	T3elcj8lWDLVjw7x6wrUUt4lVOznikk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893652; a=rsa-sha256;
	cv=none;
	b=rS6G4NHTv1MaYlJ5gxk3+bfh4BiIsg4VhnEVogSktFfWKjtAOy+3gBLn5GHgrxHrqUEEJJ
	cA1T15kvW3xB9ShZPIF3Dy0+Ej8YCA+DdtgLgQgXCEDnmZ1/IUeZY99rrlSgMEImHWlEnz
	zmaGYPZjEBQ03qqHml5CDLC/NKJbbj8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:07 +0900
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
Subject: [PATCH v2 1/5] mm, swap: Fix memory leak in setup_clusters() error path
Date: Fri, 31 Oct 2025 15:50:07 +0900
Message-Id: <20251031065011.40863-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251031065011.40863-1-youngjun.park@lge.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28606120004
X-Rspamd-Server: rspam02
X-Stat-Signature: zqk6x78meq3cotmxhuimjoar1z1yn5tt
X-HE-Tag: 1761893650-307949
X-HE-Meta: U2FsdGVkX1/WkytocIiBJxzh6eiwxjr+qUFJsD4rdSw7nm13cclhcEykTGkz2urAD6A/92L29fhyLEIrhwQ064sSOe70lg6sI8G3/PI/dnGlPZJy2mHbiWYYQFyl7eZf6J8gvtweNDJDO7ELEkjQLKkp+8tQX0BqcRb79aj1vLb9Du8ZwPNoCcttWF6DL+BwQg8wpFyuAeOfME5TTy6UFQTsjsCmJZI/xlrXX7ruCCh/vcG7tmtfm7LsCTSnqJ9DS42ku7O7Ow9EFE514wwjegey2q8c0ktnsMw2HtISzyOEtkXwbsrCcvSkGrQGF6UK0xiwUfb+4Xm4borMVdpOq7xcuOU/D30xALE/LVTygrifaOtj4qIprQMPRCaTR1gGjLt3bfTa+xXgr2KXF58szOKjwIvhXWFcpYyA7GyShX73gB/QobfnkAeKIFVjXh351ecN/UUcwNQR1eFT6z+a7ho1kHC2t6Ls/pnUUrZ+IRN4LjNto0PYe1dNejZs++L/3AZs3O0+X6k2MBg4msF+d29cYJ4e0s7AXHVFVPrQOXeULkMc7bA+zyw2s6SCGQY7dK2GqM/qj+RI9/ymirhi/7iPfdChSAH2jlrRjZOAdc9uFmjibuVC3XV15G9KYWYoEFXK9r0cFTi1jg4+iiJidDbJ1k5IYWUuplkuuoiSUwRH+W+9KGRi40iJfrWaZ+QJ/WECiuzWLG+Oic3hsEE6e37erfqDiptajCuEUvWyFeau3gRjp2LALLOazHx53jMIIZWrHq4vJt05zDQfbZLQUjuVTUvj0O6wKadZKsuP1YfiXEY5LCRzOrzLUz18qh8z7zhcXNkwpMV0h83v+jPfapaEl2aiul7WChGIlbbre9nTMyy7p+vxpDkzU0RZRmtd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The setup_clusters() function could leak 'cluster_info' memory if an
error occurred on a path that did not jump to the 'err_free' label.

This patch simplifies the error handling by removing the goto label
and instead calling free_cluster_info() on all error exit paths.

The new logic is safe, as free_cluster_info() already handles NULL
pointer inputs.

Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c35bb8593f50..ed2c8e4edb71 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3324,7 +3324,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
 				     GFP_KERNEL);
 		if (!si->global_cluster)
-			goto err_free;
+			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
 		spin_lock_init(&si->global_cluster_lock);
@@ -3377,9 +3377,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	}
 
 	return cluster_info;
-err_free:
-	free_cluster_info(cluster_info, maxpages);
 err:
+	free_cluster_info(cluster_info, maxpages);
 	return ERR_PTR(err);
 }
 
-- 
2.34.1


