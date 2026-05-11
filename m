Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD262CD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1136B0098; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A406B0092; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5BD6B0098; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4B16B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB00B1C03B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.26.65A046D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE6971C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Svqvc9K/";
	spf=pass (imf18.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jpyXxK+gNufvfse198GGLm5KrV5HUCG0eul4+auP9g=;
	b=F5qRN1jTKbEfTXMHT+GUXEinkMR1n2mq8R9btA9hW1WVnBpfn6lZimj9juM5WhR5KVcKe8
	OTqc3G5F3KA1v1bA6ZzHKc+I7dm3+EYYAO3rrIFcXitgihBmLidmeX1loOWFsywhDIBp1E
	cOIxUM8ANvSNOYJJz5npdYFC8POAdfE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Svqvc9K/";
	spf=pass (imf18.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487461; a=rsa-sha256;
	cv=none;
	b=gWSDxoOeNZWCQdUgHOdzOIVCtPFAjQJv2uJ93Er2Qokpf29JE5/xFwhj0urdhnXT/kOdNT
	hzl0fTcEELzU3suwqIcDoZdsHPTVrt0pwwHwyMm4oB21npuDnrZMv5LMcNh9yGbs/C6jXS
	gHrO73MZvqyf0bUpJ+flyNB82iKkKxE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1B464457E;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AEF81C2BCFB;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487459;
	bh=xUL2bCuAEjBLi47uhpNn9uPzuF0H6sC9FRHMffmSW3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Svqvc9K/dl9Z59pPFhtjJAeWv1BR2dP4BLuy18g+HZo8t4ptRnShYy51NXx6RYgEj
	 WMLCb14SXAjsuzM53yBQp1UHU5kCE4scpHcTZ8SbsQx9BxYD54wzjN4lrU9/qcvwxb
	 TeldGvmBuJz+ypLly2Z9EaLb3n0Bkuwf0nS7so4aeJgdPlONOR+P9q/ol4Wwm6sQKN
	 NDtATn2MLUMtVcz8fZa6juHv+Llp9358sYeLE38S9wIKJr/8jHOXTRW9+OzERyOv1X
	 Y4kKaF7NbxupanvhxxK0TQrTDWT5Dy/VyYRKj3eU6Bb8lKM7QdvgC6gmdnY6yexYvw
	 QJjO8m4/t00yg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E6CCD37B5;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 11 May 2026 13:47:30 +0530
Subject: [PATCH v13 2/5] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-vmalloc-shrink-v13-2-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=1768;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=pF2aHwJ46DNqTh9Jbrwu8jcsAr22gjU+XXXuqkw2DrY=;
 b=/1HUHN2N0cHnc5KsBXIpLCF/Nv2737vresqIEFbzYyMmpLDgFkQuwP5OGqt0ILOzvkenwBOam
 CVxhPglvCogDrj+ukCvHe4S7tdA12+gSmaIWXue6LuZoPsBRu4wJLVM
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE6971C0007
X-Stat-Signature: sugi8yg1ndg7swzhsz5zjq8pqw365pgj
X-HE-Tag: 1778487460-326650
X-HE-Meta: U2FsdGVkX1+Djp7uf2RMGV1QUpiHnQebYAXq2F6UHKrVz2ug+XaHQiv4ziXr6QducvHAHD8z3+HdqAcxMZOAu9bO6rQozc/VMT29xWHskFAEfZtLpX2hGnGFxmpivd0SNM69BwGeganuAlWNzwbXjwoFKRezyH8n/vBOBTX3kS+R9LgTeRttgmj3FyDP49sO6vCXNM188lfYMKqiiXkJw87nS5YfT0RAkGYzLJl3v8qb0lvrdDqJFqR+dy200o9/YvN+rbIITF75bRZCfPakZBKW5kF34L43u1EjWT7Qi26LazdoNuBSCfLdxC9CatKWN8gzqQfpJ3IyRVJY9/b8yMUGSfBj8dYc875oAbE+V6ljLJFUCN6qs0z4bfDhV8+ihiPWiqnNoB4Or3rtUJM7yOlfEam1nnR/s5UZ3JW826yT6pzTr+5+iRQ8KnBFmXBYycD/bHnKjCKyHoNv6EJS9+c4jAsU9yGfTGjrjeQ23MLfvHWVjUbirN7/HHGHKoS0sczDZN44Bj679OKd6PVBhM0QOR2gwSuB2qaHwdRIjIwd5Q5mNUXl0AE5avRVlXUYQyU4BCmwVQsgIz76s8pbMFgrdAbWAFWO4LHKO6RnFWKRTauTaeVMHIfKNMwbAWJFQpI2M5Zg//xaeMsfaE1p4gShDRR+cpWAXp6ijAixOOcBtDRavu2iNwYxEKwc4vXKVmGR/1ppomrv0XnxsfbtqgfqDd6odyocCkWG74RQEspPxCJiV4NQwgOgiR99qNv+mF977Q2SMvMHmn7BkMErS3b6lwbbrUUpHe94Tq+YpWiJ/Gh7EPvkkOU2jY+BX5NtXHEbPK65JPmSSU+5AHMOaVTjmv5Q9uhQV6fO1DxsRb4mGmy/0mLki24pfnwcu3QHdqIxdO08boBuaDog7NI54GG4yEgoO0pn7xTiMTgrvOKeL144akn76M+Ze0aSdnUwr+Yf1scrD3U0xGxNjeb
 7yI/YMFk
 G2ALIxim4qbHIVtdbbYAxArHxp4ghx+CJHT+OvtGhl6qg7dxEy4NRZVfilW4x7+STGtT0zV7LcBvsloTDvMpFzG7bUBpKB3pmZvQozEFSTQvHNfA5WUTvQxMf9dPGmq0Fw9L3UypPVrq36EutQv3pCpW31YhqSr3Ruq2gwHO7iypxQG9VtmwfV+RVBV7SX6oI7KFaKqA8PS/v8r8Ce4VfKfD+80RAKSxcZ4LFlVyAioDK/AZbuxXg88MjZLeNOdbSlbIhHUthH3PNRe8pdPE0QGGwSWnaOmdxXBtL9bJIKLQLJmlpqPogaL9t6fx2il6Qa5KxsysMm/15nC3gn+BuHidKYGM3oxm3FYdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 19a16e6f4014..87278cf2046e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



