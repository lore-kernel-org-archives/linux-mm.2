Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002A010ED645
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A03E6B00A1; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C366B009E; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B4E6B009D; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1FF26B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6736D161063
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.25.4971264
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 516791C000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KuZ/XKC9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2Z1Bk2UCvcGZXiNOP1v7QFhik2TIkXMP2ps394L6/A=;
	b=DZS5bYgxW3zXzE2ESbqoxI0eMBRUpnB6WZiBPx7pmQ9K4w5IhehIPFUtLXxAc/2izlVnwJ
	byycHQJoa5psvJodlo9xdgqinGmuV/UJArgx1wOnW4ZHSL3wQ+nCM0WJtaFa767CloBdJO
	dFqvYT+IrxVofn65knxb8KOsMz9M6Uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=B5AgH4mTkJWXMqFcKsG/fKSXk/r217yJPPeLSakFGcgFDJdkr5R66cBn/c8bT75Vj6+kNs
	2ZbZcr46j2tBa7zV2EXbCPOJSUFnZGkksc3d/BDad3ggiWeJ02JGCIA6F+BLK+/1nQ2SPG
	gjDYPBqzEoZ20kAMh4dyEOKXQvan4DI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KuZ/XKC9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D4AB43A01;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 538A5C2BCB3;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=HUOngOFoyGHQgaZ85Xk/jo93b+mIJRl7GJuKRuvWg48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KuZ/XKC9Nae+tDa7pw4bitE/mfl5R+qU585u315/GoxdAS1eBAhe/pyLwISgIbp/x
	 712A6r1i0XL5BLc4b/zm9HUGSGVn4cc0WOhZmzsa02y/HTkgXVBKuRYaGppcoguzSr
	 VTDYnIJbm0nSC6rcQDqyldT+NgjCapR80C/E2YNdDkBkEOUReadsQ2pf0pw/I3GVFR
	 3E8FbqRiDJ5KSssR3ZLU+s/+lqgDFJFghEbu3O/FVpwq2xfgOZ4UhtUWDOKto5M0ii
	 8cG5XhjVXSh0yzdHG1hPZFCZt//nHhlie0P+T53Uqp+UqcOk+/Dp0X3H+24a748I+E
	 rbBAfJGLKppBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474F010ED643;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:39 +0530
Subject: [PATCH v8 3/6] mm/vmalloc: zero newly exposed memory on vrealloc()
 grow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-3-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=1805;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=LSUYWjYOjJYKYliRO3bYLhKxcMuMIBGaVN2tymO6+ew=;
 b=rhThTDLnB57E/DBczd8HBXwMc5oEaaeJggo8YDeT6Y5MrRyp+O/EQh7sxM1hZvm1pvxDVce7R
 Zy3ihFALKZ+BT2UKkAd+06tqJ3RxfEKcdMJTVjTZPZTwIrL3lutscSU
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 516791C000E
X-Stat-Signature: 3fqswpn18gmejdbj7es7p1sybq73ajer
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774604921-121161
X-HE-Meta: U2FsdGVkX19ukrCgG3pmjrNUyMActl+MIBykb/AvyhdeFcvv6RLGo+A0N54swqVmLzeU9lddYupoU+jynEN3VCg0aYs5+AsGdOc2bgJM0HwGd9Xjo8t3sDsR5wTdI5OTztxVY7A3A1MoIM0uC3Nfbsh7jLdKxf2YqUl3w/eLQ3MN9BdJMF0gthcRahW25UKknqjdtSplreQ/9MfDXj/lnco96G8Oy4oi3bMB0BWr00rxOHMBtO39VdV+Q+nOHFAsSNWOGHUfTvnpmHaE9psMoqBam8wGz2eulaBmG5O4OXOKX4Qifa5yuVMF7gYW0QgPj9BgNCii67h1/E3sdOocNbPOLjjnXYDGkIn9fUc1aSkQjlcxE9SisEy/fxamvLekUZoHtdMfqzImFrvR680h1ZWD0Ac39PX61Mq2lNHMiwRIdJA+ThKpZOjJK1tXox1wKZxCioWywoxG+gSSKlXTfpDTdq5qR+qIdTYYBV2UajlvhiB9X0Dk8C1gso+7Uias+rFS94ZALnCyW+AiFSuh9W45BfY+PzB8q8yuVNNkBrM4K91bU+q8QzFANaDyMt24WStStftyq0ykuMfbPwI1Do8m+P8g5DEj+j1fkWAlsBSgTvL2O6cxNS8u0xLya6RSlI9M6bx39r/Te/ceHXAZfaFxZF4XPBrlqrALBJYEcOq98GheX1SdDtqIJSxYDSkOD4aGRTpOOQfw6JTZfKKSrEhiD1mZwsr+CkDbkR9g9BHZSiOEEDlIgqSwQrIz8RndebA46X2ZDxrJkKhm17AdViRcaIGDthtTJ61qUbA6dgGk3tMWpvdsrl6YqvTrSYy3JQt6njVptCVHdmHeFtc+4V/g2FeG8ZVqSF6WJLbZA9EXFbwD9VNnPLcLa2h2U1oiuwY4slRv+c7dPPlPsVrzl1CEQ/eIrO16+hhk9hGUrxC0QJZDntSKM7yUfjWLmJCRAdRxAg//keYQrDshK0x
 kZ7DdTh7
 M1gEIFvFIHINaqVcRSU2uJzonTAUwShVuUGrFcgSlWb83goXq/aWa4N35rEVlKKy0pBihpY35KmayWCPMRbTfvdJ92DifkKwNE1GhMIiF/wUYe46uQCYE3kgm47KYA7UvOK1JO834h414YIPv0ntVtv7mWgOr62uMtvnmaLrIg6bt574glSbbWrxPRmr8xWLLN5MB8AfYqaS0aCM6IPefmtXlx2G2gjKtkVUGdblOhWXEjHXHU23+z8U/GE0L81TqWoHaE1BdkvskguXHlGEahSfsnizr8vRgZemzmicN/RMVWDGDEYNaO0M+eo/gGvOF7O6Rbb5ubUFiDmm6QLVt6JrccqP53Cv+aOrdVQt9eY2SsqM=
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



