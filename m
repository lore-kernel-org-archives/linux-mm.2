Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F81CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C39D6B00B0; Thu, 21 May 2026 12:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59AEF6B00B1; Thu, 21 May 2026 12:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0C86B00B2; Thu, 21 May 2026 12:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3320F6B00B0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:22:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E9EF1406DC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:10 +0000 (UTC)
X-FDA: 84791944020.25.3591182
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58172100010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/l53IBf";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779380528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vijgKaU0lPNHdbdrYG3yt4b6w/oPC8D35ILFYzM+gXA=;
	b=8GpFQiUM3chEN/S7c15XYTr4knRsr0BlXWSdXmXniKBNtSfNvs+/pD5c+66iOTzCmI7vCl
	ZlQBf9WJf05huiJ3RUm8y3spnIQPRvzDKPhM6jn4uk7Qnp8JjGdNpU3Av5/TBFI5HvYmzo
	b6WVz1+DOSeQDcQCRn6fXiNKHoOrKAI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/l53IBf";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779380528; a=rsa-sha256;
	cv=none;
	b=BBiXjTctbPeUvVg3kss5lAFo7+Yf+fwPKoMiLRMa2NCWBHKznMl/d/F1bNuBDD+7FvTMej
	+5OiVTw8uARJXeE3PYIRdUu9Ie5cPWn/uRde7yRvOuo0+Y43qKSCGanSh1JoIGTj31Csul
	Biijjufbpu+G4E25FiqjPywFQ54NDG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98D0B43FCD;
	Thu, 21 May 2026 16:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059951F00A3B;
	Thu, 21 May 2026 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779380527;
	bh=vijgKaU0lPNHdbdrYG3yt4b6w/oPC8D35ILFYzM+gXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/l53IBfQcd2seHBXKgpwkQaIxIQvK5L+KxBbNiQcTdAS1o2SxqEpiVaaKbTUNLhb
	 rDQPADYmh5cOUHkLPD1TfK5YIpPPkAtNiPgq3GBkhXsDZ2q9IRNCgJ3d+Aj0dOZ2Mv
	 RYWrL/BBczayfUQd4P0XeDYrXgLOB+p7yu+P7mX3XpaCHmaGTpZNq6MM6/DCjlG1th
	 6sh47ECU/wMJPH7KL54zr1QAl4IjqGNlqr0rPgcxhXyKwPFicdLg9HCdqg2utaNitZ
	 HDzQCRvraMVB29FWjQPH1bpYuPOKAitRLzlae/dfRsvfMl5kfFugjoXnOzCnuvZKLW
	 zQ1V6rxoUvesA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/vma: remove mmap_action->success_hook
Date: Thu, 21 May 2026 17:21:53 +0100
Message-ID: <24b5ba4470961abd870d5fe7d180d3e295b6d9af.1779379804.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779379804.git.ljs@kernel.org>
References: <cover.1779379804.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pshhqd4utftuh44a5as45x8w3okmgi5c
X-Rspamd-Queue-Id: 58172100010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779380528-4623
X-HE-Meta: U2FsdGVkX19Sua+6XmxrUUVfWs2LwHaNFoTkcSxXRwEHtRT+kOgnpRI5dipRaH5pgIxkERYmJYD7BsnplnhMGgluJi1eu1dyV4X7HeNjd2tASjXW8A4kk6QtSks654+YBxsOv350A9itvY3zjBlDsMkiDXQ3gGtNNQDlLzJXwqtXNSps6LOI497xzV83zvNRuAX7oHfrlui0kdQxxxYivR0z08l4EPXFLNm88ErW4TYoVJaN6W1KMGELRyq6wUSvBfA+RQbM5SOUODS6YH9R9pzDnzcUYPmjF5je6jJRRobnMRnoMokq5DCZIvC0GYIawwxu7IHe1KvsJ8U5ae6LJ+HwTkEg2aCFskpFLIGsUUIVu9sDxJAkINj7bd+LkJH9yiPNKDCB4dvGviLuT9ob70ftKOACj9+/GC15HTrtnJ2EyTF40ekmRrsjPwpUkd0y5U4RMOJh6SLQHcekaEID0j9gw4N9N+HBlF8tdWQlgMi8lZe8hXwPltYid6kkg9e9MJkvuO46hMPuPylV7lpMnmOv4FrIgsZNd/uhszUMTMrqP0qMh2aYI9dIIGb6qyY1V1V5FqYGMauouS6ZWUH3pTqdz+uMZFBhkLAQram3n428TGt8kio3zGRZb2QUxDa13aFCV+j7gCIYAzFhM1V3LKUSpP0BBVTPWlxW2VXoVkibxZtGHpBJJumEZ7mFpbxSaPNqiw1c0s2A5kQHwbC8qZs3sEo3wX7XEjTuAnmfJuQ8uusn11QEr7nIgmjE8HNnCAVwLqiOa+sQQC2fn8rcQ3i7yDMuKsnadYuMfr/zMP7L3+WgPbD3YDdtL3FNNB/QkdO0SS3x2vqlSkGhpWxmpg6e4M94lUvWcDsnDFQaj1BixOLBixCNmVmaWz4DbG7xe4TT3uWbGepPiq4Sl0ky/omhzq+a7ZihShZFqa0gZgfWg3f21XTLogUhUc9DD4mTQnL89lUI+NzYifQpN3D
 9Zh75j1p
 2TpaRDH08UcYFlFfkIsZ1tMfVRF/eGACWs8EHHtno2tCqNk9Rm1fqttbl6q26IqkAhuvnMjbQhL2rr2rENcoCgMSqBdjcQcNFtG1Hxz2Ai9O+P6zFGE9oRM8MOJoXLai4mGcPfecZLbby+2/QVrN6cy58yV7F4NWrzqgdMrXcGKM251rU1DqodIwOu3bqE1Yrt1vNcTQfa0m3r0SMqcDCJmrClrbVN6zmUmTMhWCAJuvIPZsHlv70zR0uqJqcIMhXPEI4hST4QQ/YQoj7aFQOuGSU3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This hook was introduced to work around code that seemed to absolutely
require access to a VMA pointer upon mmap().

However, providing this hook leaves a backdoor to drivers getting access to
the very thing mmap_prepare eliminates - a pointer to the VMA.

Let's solve this contradiction by removing it. The key intended user was
hugetlb, however it seems that the best course now is to avoid allowing all
drivers the ability to work around mmap_prepare, and find a different
solution there.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm_types.h        | 10 ----------
 mm/util.c                       |  2 --
 tools/testing/vma/include/dup.h | 10 ----------
 3 files changed, 22 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..945c0a5386d6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -843,16 +843,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selected action.
diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..1555aa1487b8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1396,8 +1396,6 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	if (!err)
 		err = call_vma_mapped(vma);
-	if (!err && action->success_hook)
-		err = action->success_hook(vma);
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9e0dfd3a85b0..bf67a80a8332 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -482,16 +482,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selection action.
-- 
2.54.0


