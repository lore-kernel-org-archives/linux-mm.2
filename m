Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D334DE9A759
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11D46B008C; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFD46B0088; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42E16B0088; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92CEB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56B381A0CA7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
X-FDA: 84580512072.07.7FAFEE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4475A1C0008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CmtA77oh;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2Z1Bk2UCvcGZXiNOP1v7QFhik2TIkXMP2ps394L6/A=;
	b=Mvuu0y9KfAs2ts37WGO6GNSUKgsHNm6LHOUxTTMzXFNgzJgxCIyN1PYhpkLX0Lf9Npg71G
	yV7WIroyV2aXHBJF0HwIJOIZgsrsQ5qWdExTo2FQIHajS2GLFR2JVysZ0ExRkfaQTGIhVn
	JBdX+ryR1RfkWalAjrFw5gZVGYhA11o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346434; a=rsa-sha256;
	cv=none;
	b=5nYH79op7jA1GU9rXuGB9h4+47n+6PEDf59cTSr7r2DR+My5uOBV4fan8QpSRVSp9GMae9
	m8+MyfvLBtY7x5tZbzHIjNKayqJBSGj0vKmf9RthA11UYzuB5J4ll+xzJ1PZ/Gn+UmoVYp
	ZjXFa2ixS65yH/+pW3fkDisNALBIGlg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CmtA77oh;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E16DC44540;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C45D7C2BCB5;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=HUOngOFoyGHQgaZ85Xk/jo93b+mIJRl7GJuKRuvWg48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CmtA77ohefRx7XW6oLVK6YckpgUjIQ9mBCd9cRe05GAn/fLi8dYPU7tFrxUl9Zg4Z
	 xsYfVQYUr1L1gS/7t7usl8Oa/QxEGRVWuLFNcHZ0vaLiMvf+f3f933eXifK2gcu/F4
	 PnFsmApMZXOkojdPjAMpzf6kkUG5x7w5zNJBOIW04Mybay7iVRsb8kjB8bjPF8rv0D
	 33DceFVCzfRjWGXkwJ4ZkDTsL9iLqbBd7w0Cv+XNDX4zEJoynxu3sXDG9W/mWWRgbQ
	 45sn6LSOC5VdsnXvF/1i3oFEJVykqMxQoyDWMuWsRoelnPBebINulo1GbxzIDdf2lf
	 d6P+JGLMtbYUw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF8EE9A75C;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:28 +0530
Subject: [PATCH v7 3/6] mm/vmalloc: zero newly exposed memory on vrealloc()
 grow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-3-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=1805;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=LSUYWjYOjJYKYliRO3bYLhKxcMuMIBGaVN2tymO6+ew=;
 b=rnj4cYZkzkJ86bsOX6qnSlWl5dROAsN7ly5d6iDcEQPVC7kXfPVNp2+aT/Y+JklM8mQ3ukx5Y
 aizhMbSd8BvDTD8JdpVEUyF3RLaOHctT575Mvr0Wj0aLjsC/fSjn72S
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 4475A1C0008
X-Stat-Signature: ef4659sbxepfu4qocmo75ubz8653adxb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774346434-120297
X-HE-Meta: U2FsdGVkX1/MrZEtQN1tUvE1nAW9Fp//COmDZezasVRU9IX5Hf5GeFV7KF3aqJeV81F2PW8R77qTLzj/fBvvVmTkhCxePg47XyZ6N0rvHpSeTygc1b+G5HzWBGKC8ZnuTXqJlOgg5TXg25JH6r4FWl28Wwd/MFGg3eh0uQ6kI6VmCtz2ix/viiIOO1IAIJzBCmADsFD6/2ckvaGZr1UlDSNz5j+EDJwuXNMRL2uUrUymPzmOND45xzAEKGbXTbQ7EnR2eJs5APKJt+lOnfWhbnpEEMNSMZ5uhGqrgVOYIkwMg9d7PLkkNedgsUWd2GLbRwsvAayJu2YA59P2kZ2D6f4zXjsKnnN7kHnd01Rie/An+INRO3wTGYoG1c+yWkWkydv2z05m5F5Qc8BpUbFAIutGzaOEVBeeH07yKUTFRficYpNcj53JWaNB+k3P/HGuwjgnoLYIc748SexTx7TEbMB4Bqr/SDPl+bo2IL81FsfPPeoRiU3MR9MgrdzvAeGlpfRms1/Fp+nt9HjeRYjsVd5V4GUbfiTGyMQ+XOrIvgJbyYen/rQRZz7eYe4Fj+gTK86l5XixW9bKwiYQ0fdBiicv6OMRQieXqODvU3pob3eywsFzRiya6U8nwkXW9S3h4QwH/36sMU1Yn/OlGJrhcrH3tcNxTVM3vTV27V7zMBR3kk7150xcdl416F6QL0tTJ9OS/GDjwKl8eBhxDpXag/zqMMwXjmLudPPjo8qq8tzqNt56AIOxyaWFJSK1TSaDaDQoUbdqeup00XPFEfPb9g19Wa/1CXw1Lr3/9q0b/xtDgNEeidwgn1QBjMtEZ1WEVjcc433ZebGeLnl3U4uRT4Uaiac5c1F/H7Ogma53AqWG513bZAAAjuMsrN8qz2xrdPtITbSSLMCaSelPP4yiz2V0YOvwu+3wHfmQoSa96o3K8paIEAW0Nr3hgFIv+Y/kvNTpOj5W46fVjfvPEcS
 FTDuJa/j
 idocvZNdWtF056zm0fm1SpaoXeRAJ4KJchlhubbPfG1iJpFG+ULR1Chhi7RwVqe3rpHg7Kkl/Qt+06oZvwv0s/31PfjsY7K9SmVgVLrwwciQLYdT7PJ8lABZBi7WmwXtisMF0xz/yQIonXIyeiHOOwzOGHFo7l/BMHYXjo1UHBgD4jGiE+BJ+/D4tYbT5j+to0BBIN3B73/tDdk//vTAuwdAv6PddtZmGGbqzG273dYgP1a1W+gRlGJCE8i1AWElB9tNintcVkQe84F2uN+muc871JX7J0eqTMatacb/ZgVndCtJuqtEssaQBHo/hO2ivwrQNiL0v7Gbm2n9M6buztoHHF33vKDMjAhHM8bd6N4X1iac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

When growing an existing vmalloc allocation in-place, zero the newly
exposed memory region [old_size, size) if the caller requested it via
__GFP_ZERO (checked via want_init_on_alloc(flags)).

Previously, the code assumed that the unused capacity in the vm_struct
was already zeroed either at initial allocation time or during a prior
shrink. However, if an intermediate shrink operation occurred without
__GFP_ZERO and without init_on_free enabled, the "freed" portion of the
allocation would retain its old data.

If a subsequent grow-in-place operation then explicitly requests
__GFP_ZERO, failing to zero the memory here would violate the allocation
flags and leak the previously discarded, potentially sensitive data.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 133c3b0418fe..ddb689bf9ba5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4368,13 +4368,16 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
-		/*
-		 * No need to zero memory here, as unused memory will have
-		 * already been zeroed at initial allocation time or during
-		 * realloc shrink time.
-		 */
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
+
+		/*
+		 * Zero the newly exposed bytes if requested.
+		 * The region [old_size, size) may contain stale data from
+		 * a previous shrink that did not use __GFP_ZERO.
+		 */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
 		return (void *)p;
 	}
 

-- 
2.43.0



