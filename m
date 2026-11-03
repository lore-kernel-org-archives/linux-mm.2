Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66B0606D807
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=myprwqKJ
Received: by kanga.kvack.org (Postfix)
	id 924D96B05C5; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6CF6B05C6; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EF86B05C8; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0636B05C6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0F04A8037
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:28 +0000 (UTC)
X-FDA: 85394315496.29.CAD16B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67F901C000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=myprwqKJ;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722706;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQXnwC6eS4OMahkG4lFuKg05onPXaXP3nwABDwvIji4=;
	b=nDaYubD/3plyU55+cfaLlT5TScEzNRIbZILx+Z8NvDWlEmKCDdLdBLoxwdfo+dbd9ESfbL
	h7OkGJLhxUbmtYkUSMyNMw7o4iuIFLtikDP5SB4yBZ4obH+K5x2qOUseCgenU215jInxYc
	5f2KTE3dpbcU86jE8ZqfYk3GLbF5o0s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722706;
	b=gwxYhC/GekpjXrFE4/WSLQuXYvh01n+15aGMjqOKBpv1yY6RbGWa3uMntR6KX57Z8hAO4u
	7/Un3ECgNMnjo+/Qmcxfp8pEz2DI9V85Uj8rgxSdW+svYGF9SE9cL/yaHsKyKuMEYUQU1Q
	4pSF5CfajMjDYfGAfKPmd7C1fh/xOXo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=myprwqKJ;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E06843C7D;
	Tue,  3 Nov 2026 16:18:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793722705;
	b=cn0gqbMJlpC1TavIkqSvbB7sCHimMGZzrSAzpkIj1ekHesGRlM9Q04nFxXgcwe+RPBR+
	 lF59XJZkc3UEABH1Y94/7ewrMPFh/QYVR4AKT5Fh/Y7b74KY+py8Mjt1JbdIoyL2mC5ka
	 4o1gEp0JSXaEvo+XV5IQOkLUq5uB/pAta1ERxZ0ZSOVvPRaMaWoaEvlQdb4lYyiOBZPew
	 C9v3svsrVxHyLBl4puGaVAzy62XHP1UccS+N5nR6Lw4xjD8E+TyRPFE0dC3Wx7HXT8AsT
	 0tacvGzLkT6/fqD0Gm1lORJCuwgIjm9guSwoiUesh9rRsZh2fcsolY5I87mfAyFdm0g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793722705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=JQXnwC6eS4OMahkG4lFuKg05onPXaXP3nwABDwvIji4=;
	b=np/+XLHLJ0+/uhnYad+pt/fdVk9J2xtuOHKnk+cc4vBcFMbFNkIdghs0DanWTVZhf63Z
	 VBi2O3YALL0Jsjwtaz0tsjj818MpITFysCiC0mRie7J6O4OEW/whP+bzGjO3lJvA6gDeC
	 1F9Mh5GCnuQ/5afe6nXpaGxUVAmMc/lvmItTklsPlbSR5CCVKnRakH+KeFmp3S+Twr9V/
	 wYDpr0kNLAJZQerDPAxOTwmh7fbAia8I9H2hAAg4GWDiS/a6HCstJJ7hilzrXWejgwHCf
	 S+ZvvohGGbDnD4WSXwv8k9pygu6YDNG7VEHB1nKr/V3+zVAZgCaoIvxv/dKtvz0V2fA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 093791F00A15;
	Tue,  3 Nov 2026 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722705;
	bh=JQXnwC6eS4OMahkG4lFuKg05onPXaXP3nwABDwvIji4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=myprwqKJUkzY5GBXHp4lLRW6jJmSN88L7byXcX7kCmoT7JknqS7oxaEk1av5jbYjA
	 NRntID5mSAeNCf+q62sB9mpwjYn3cWrB5Mb8kytadWx60ph+fY0QWwkE1OKP7BSh4b
	 FhC4IA0xpzOMvgIefvPODvMiJjdZ8v0bM9wXbMzzUA9PMezT4MpxzbVS0nHyp52OFR
	 7Axkki+pNkD6iLbLDEvDFxdDL+L+0TTGLGrJDaJmq8lRzRtq4FmqVOuPe/su3nAKmV
	 W+G89WW9L47dOam0fkUV32Dq1m4tGqVzJAqjnKM4qHPuyZ3Cm1E9A7vGwdDj+iBc1a
	 WXJj3qlC9d+VQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8510546A17;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:18:17 +0800
Subject: [PATCH v2 4/4] mm/swap: keep the swap-in pressure window open
 across a batch
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-fixes-v2-4-204be064be5b@tencent.com>
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
In-Reply-To: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Usama Arif <usamaarif642@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Mani Tofigh <mt4022@columbia.edu>, 
 NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793722701; l=6777;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=fSGjBH1fBeJRrxZU6HCQNXNyuo3pc/ORVbu/vvni/eM=;
 b=55yKBwwkhKAzdV8IGn7HpK0NW4JifLakVnRvHacr3WJUwJ5VtjrDcOdX3w+8TtsXvKyfMF0vF
 dSdBt7oTi7RA8h9pLFRz+favTYHexbzETc1L16Yw6N3Iewoy+iVLBfu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: 8ac5qex8n6zwt6ifj1ae76oskjte3so1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 67F901C000E
X-Rspam-User: 
X-HE-Tag: 1793722706-888450
X-HE-Meta: U2FsdGVkX18zCMi/eWClWnIQKiu5+wIO0NMazBf+H6QyFrs6vNEFfofjnhtnSpVMyZU2OzSPrfrFOpMjXpx1hl+xremorDCviFQPgUfn2DbejbF42mgY6caAaqPVPqRR630NO66p4lE7/HoHEshRV1WYw22PB8zKKzHVfLRpXGTzRcnSLRwu8Jjg5b6P0WSaF960pX0xAUYco9aOMLI5di4BIiovWonnLdBNo71ajs3iwPwqadQEi1H3uroAPGXfWv8hqJeTyAw6PBVTO/rOcvA7urAHty+2jav0vfDhvIo/LlgUFhdQUmtl9uuQmkFeR6zgWUfpODFziTdJ7+41d0BsrWgurejy7H7UjeNRKLkG6sLx2ER27CFYtX2Wbx+u0Ec6izlR/CgAe/LE/P61ZHVvupaV6cY5WtlzH0sAywYaErXWXPPLixJxY3/A111JIC87xlRQEVK1RmPWUON6GYFjNte9xH2cTjUh3KFkteyxNIKJuzPkN3/6FDKsygO5VdWoqVOK/9joSD6urLuTyWo1x+wKnsSLympxGCEFU6akEagx1w39DVrtRXU0QSC5ha3myGFjx2R71xzjcK0sgJn5kHwE5NHVo9O4mW1ZeMBNoWDEcCrFn7ZmRvrpeCNj3Y6B15cOwVZXsBSsQBuitCW+C3/Wz6aWlSaY6PDn3H/pqH5hs1DDSRLu9b92/K/zXZMMcXskdrjQzP7nMhepLF4Lrl1OKVGwx+3AWVP1L2m+JDFahnc0bo9pgsq8ockC/hdkmdKxfwrYakeNa8DIGqdGxF2BIKM/XBRM1T41gZ5+B38lNKQ/2vGdUhGWZawIQYG4vf4q7Ej/Zjfe5Qj16gWpaHZDiU2qA5NErui+IoOzDzIzrQRbc9KYiQDOXqtenpMO6vgAAij0AT0qSnIrMQsYbYnv810P0dqUmxRURaUgHzNZD8G34yKsSJjI1Obzg1bHveiRhKxw+1Hdiih
 nmGFKX8h
 27Tpg/CIVN/txiMGWfF0FIzxQ3n1eu0Mcq3P+JqNvq2JnZaVqnd+l0GMSIHaTHBvqSsi3/oWbsCFdzHbHQ+5UmQypB2RBmFuqJq9fZZ5pO2vklRpxgnavZtZbJeNS7KXxaRTdEaDcsPuFeZke0MQ1I9RhNRQU640Gx+xGRuMFBkoWgks3GQGUbNJKOh0Tsjv+lbyamI3DJULZEt7YCbgMtYC/x+g2eOBOqezN3SkngYSQSn5Tr6h/azJLul4IIqUnaAkmFAs3uf9FvsV93nfSDAL3cVUkHyWpl05LA7A4F6gM1cUhkZgrvDiQu1eWtR2VJtXZBannSK0a2CzDDdr92kJWCNbgcRDA5/XFwz4oG+lR1BSwBotVF1C/hDjz4urp60U+pesl1hKR5lMTfcJCmIBIuGo0nrVx6KhixNv4hbYiyPgffY/3/NAhnV4+Ezrur+CXhdlAMfig0fL0TzrSM2DB+6W6ObcFRS4CmDCEJFOw5+1PQq8qt7gmUZamwn7jq9omSrAsz7DiJL3IonOadVASuqNWx+7XSB+21J+Jbwjx/szvEq0VHITH9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Johannes Weiner <hannes@cmpxchg.org>

For asynchronous block devices, swap reads are batched and submitted later
since commit dda8fb68b590 ("mm/swap: also use struct swap_iocb for block
I/O"), but the caller submits the batch after the pressure window in
swap_read_folio() has closed.  Batching is cheap, the submission is the
part that can block, and that is no longer counted as pressure since then.

Keep the pressure window open across the batch instead: swap_read_folio()
opens it on the first folio, and swap_read_submit() closes it after the
submission, also when the batch ends up with no folio queued.  Each batch
is then billed for its own read.

A single workingset refault marks its whole batch as stalled, which is
fine here: the batch is submitted as a whole, so its submission holds
up that refault too.  Before the batching, a blocking submission was billed
only to the folio that issued it, even when it also delayed the refaults
queued behind it in the same task, so this might be more accurate rather
than less.  Synchronous reads are already one folio per batch after the
previous patch, which keeps their attribution tight.

The same hole has been there for a swap file on a file system that submits
through swap_fs_prepare_rw(), since commit 5169b844b7dd ("mm: submit
multipage reads for SWP_FS_OPS swap-space"), which started batching its
reads and deferring the submission to the caller, so this covers it there
as well.

Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Fixes: 5169b844b7dd ("mm: submit multipage reads for SWP_FS_OPS swap-space")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/linux-mm/auOz00OGB_8dgniC@cmpxchg.org/
[kasong@tencent.com: added commit message and slight tweaks]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap_ops.h | 10 ++++++
 mm/page_io.c             | 79 ++++++++++++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..d57b95931cd9 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -17,6 +17,16 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+
+	/*
+	 * Pressure window: opened by swap_read_folio() on the first folio
+	 * of a batch, closed by swap_read_submit(). Mirrors per-task
+	 * state, so the task that opened it must be the one to close it.
+	 */
+	bool			workingset;
+	bool			in_delayacct;
+	bool			in_thrashing;
+	unsigned long		in_memstall;
 };
 
 /*
diff --git a/mm/page_io.c b/mm/page_io.c
index 83ed0246ebfc..a57cdcf2892d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -350,13 +350,11 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
-		if (rw == WRITE)
-			swap_write_submit(ctx);
-		else
-			swap_read_submit(ctx);
-		sio = ctx->sio;
-	}
+	/*
+	 * Callers flush a batch this folio can't join before adding it,
+	 * see swap_read_folio() and __swap_writeout().
+	 */
+	VM_WARN_ON_ONCE(sio && !swap_can_merge(ctx, folio, rw));
 
 	if (!sio) {
 		ctx->sis = sis;
@@ -399,6 +397,14 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
+
+	/*
+	 * Flush a batch this folio can't join before adding it, as in
+	 * swap_read_folio(). But the write path opens no pressure window,
+	 * so there is nothing to order this against.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, WRITE))
+		swap_write_submit(ctx);
 	swap_add_folio(ctx, folio, WRITE);
 }
 
@@ -470,31 +476,44 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
-	unsigned long pflags;
-	bool in_thrashing;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
 
+	/*
+	 * A batch this folio can't join is submitted before the pressure
+	 * window opens, so that each batch is billed for its own read
+	 * rather than for the next folio's lookup and decompression.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, READ))
+		swap_read_submit(ctx);
+
 	/*
 	 * Count submission time as memory stall and delay. When the device
 	 * is congested, or the submitting cgroup IO-throttled, submission
-	 * can be a significant part of overall IO time.
+	 * can be a significant part of overall IO time. Reads are batched and
+	 * submitted later, so both windows stay open on @ctx, and are closed
+	 * by swap_read_submit() after the submission, also when the batch
+	 * ends up with no folio queued.
 	 */
-	if (workingset) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
+	if (!ctx->in_delayacct) {
+		delayacct_swapin_start();
+		ctx->in_delayacct = true;
+	}
+	if (workingset && !ctx->workingset) {
+		delayacct_thrashing_start(&ctx->in_thrashing);
+		psi_memstall_enter(&ctx->in_memstall);
+		ctx->workingset = true;
 	}
-	delayacct_swapin_start();
 
 	if (swap_read_folio_zeromap(folio)) {
 		folio_unlock(folio);
-		goto finish;
+		return;
 	}
 
 	if (zswap_load(folio) != -ENOENT)
-		goto finish;
+		return;
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
@@ -506,13 +525,6 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	if (synchronous)
 		swap_read_submit(ctx);
-
-finish:
-	if (workingset) {
-		delayacct_thrashing_end(&in_thrashing);
-		psi_memstall_leave(&pflags);
-	}
-	delayacct_swapin_end();
 }
 
 static void swap_write_end(struct swap_iocb *sio, bool failed)
@@ -725,10 +737,19 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 
 void swap_read_submit(struct swap_io_ctx *ctx)
 {
-	if (!ctx->sio)
-		return;
-	count_vm_events(NRSWPIN, 1);
-	ctx->sis->ops->submit_read(ctx);
-	ctx->sio = NULL;
-	ctx->sis = NULL;
+	if (ctx->sio) {
+		count_vm_events(NRSWPIN, 1);
+		ctx->sis->ops->submit_read(ctx);
+		ctx->sio = NULL;
+		ctx->sis = NULL;
+	}
+	if (ctx->workingset) {
+		delayacct_thrashing_end(&ctx->in_thrashing);
+		psi_memstall_leave(&ctx->in_memstall);
+		ctx->workingset = false;
+	}
+	if (ctx->in_delayacct) {
+		delayacct_swapin_end();
+		ctx->in_delayacct = false;
+	}
 }

-- 
2.56.0



