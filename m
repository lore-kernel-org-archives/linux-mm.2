Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38568606D83E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqDXnEfg
Received: by kanga.kvack.org (Postfix)
	id 491106B05C3; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469806B05C4; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F586B05C5; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 114376B05C3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:18:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BBAB1A04B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:27 +0000 (UTC)
X-FDA: 85394315454.17.7DF404A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E2EC140004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqDXnEfg;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722705;
	b=5hXtV00e4mEwNpx0pUkpxVJtxvQHpG/1hxa5bwzCTSwvHOASvS00L6IuL40Ber9MLjFF5v
	j5RhI3j0qkWgDIMNplxvh41l0XWgQSCarUyyxTebQEobaxR9X+hGklmbRwzey/du7hz8fK
	ieTTn9ICq5k2H7z1Xo78KOa/Xddk93Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqDXnEfg;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722705;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baDKtCJ9t+d8m3jVmL4//Dt0e3tyXADcCTg7kZjMSAM=;
	b=fxER7ZbOritvje59k/yCZAXptvZsbrMPcovs++kE+aLCDKVxdH5/OM4661NCY+815EwI1b
	oe4dP/J3hoRfdEM5yeL3PaUELGhI0fhx4ghz1ENn6ioR8wO3x/k5KCgVbbIbi1UEhgew1Y
	NDfQPdlkdcXka5HEm6FAXNGOBt62wSg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B24ED4172F;
	Tue,  3 Nov 2026 16:18:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793722704;
	b=GZqf7tUAI87DxyTV9plNbnG2EV4NLJD+InRnsqb1MAiOWuNqMcAWkGK8i1yOPNwObbU2
	 az1FRZP2HdsC71IAllN7uU/ADqoyE70GDP/ZsxCf5r4Ns/blTlF54226cP6od7Ric79aS
	 Nr30ry/+nq5bjmgfG6bufMggzSGevW2vVgAkzymMq77EjmTGBG7YIfYCfDiavLnzQzErH
	 4ORLFeDi1rnGnq4ePyUb0b9lcoi5wq+pY89oxeJgf4yM8WBYaVYcCDhFJVKK9xxqMCrf6
	 7mp5Ddm/AMcXvb/EekL2jjQZWnGT84rJIQL8UmcvHN7+Qut9LfZbeHj0Cx+4dF0SFvA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793722704;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=baDKtCJ9t+d8m3jVmL4//Dt0e3tyXADcCTg7kZjMSAM=;
	b=nfer8XsDnU1UGO9dtMFsVpQahH2Iloibaj2OrgUmL+JLaIgIYkP6GlxQSwrsaVy4OjEx
	 k23fS7EbgYrwd0meoA/t5Lm4uI+JlnXQlW8zZGX/VVQ8t4KOsa9P2iNUDa8L3gmL+oWk0
	 PtUM3u8/6bjHXFOJ76NIz25jDbixOzFRdgwtaUrVBLz+IyRDn1rll2RrxmScPxiNkeEsU
	 GlxYKK7ZNYWeGG9hwn6PhSupE6m6nwHT99c28c6Ec7MWPr1wv31d5wW7EPJdLWffmwxM0
	 rP2Z9uFq15zRzN3E+6vEEQSIYYKIunBKTBvlVYKzrZJdf8IUEeyS8cwRIbY5O8SXf0g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F1EED1F00A02;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722704;
	bh=baDKtCJ9t+d8m3jVmL4//Dt0e3tyXADcCTg7kZjMSAM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=eqDXnEfgPvmo4U8gvGC+06k2HbXaFns7KOXb19VXARJLA/lKs8ZJqjKFMeVDQx0AN
	 kIoP3xJZNZd30aGog2qQA9gO7OzbG6lDbjK7s/69WRFh46YU2KhWxI1yzNKo6lyzbj
	 EnQRHmLQ7EbqX5qmGwcIbJGnhQDTcdMbmWNU1qI/2OcWD+Mi4DxkDdXMIdVGYqTq5F
	 /W9OjbYM2d/R0r9Cntt1WdgsFbmrdfOZMayyv9uby/35zCcgg4vM/UAIF3ICv1jtyw
	 w8nUV3g9xUPqa3DrCtBbx13l/BtXXRHfuIo0rIAKdW5bd3ucbnpikDRPi4ayRMYEIV
	 cuMDUVNYhNPxw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7806F46A13;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:18:16 +0800
Subject: [PATCH v2 3/4] mm/swap: account synchronous swap reads as memory
 stall
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-fixes-v2-3-204be064be5b@tencent.com>
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
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793722701; l=2186;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EXepoBL+1i8g0ScofxnsUXgOf1Zeyb2RF1ZMuEP4wQQ=;
 b=II4HH3rBWCxgpZOng9GIJ+6uCPttS6S4t02mNweB0XFK5UOl5u1wHuIEznK3U23AF84mthrvq
 X9BtcDxwI0TDydFmucET7Q1DfJg4CsVZ6F7uwkwvGmEHFmGZWwKX9BB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E2EC140004
X-Stat-Signature: 4krkz5mhthghnx9ghjzow1u8mb1xn6ga
X-Rspam-User: 
X-HE-Tag: 1793722705-139272
X-HE-Meta: U2FsdGVkX19BzZkWxMzOXNqsgTAop6a73JUjBKyxgFnLAhv70JXlQYwewZB7DWgHO89Urryv1+klpk/yopGjsNUuEXOdQCAWMPozma7bqkHy6jZLaI+EgDs72lBh8/Gy4xcwfK2D0v1m8khZ5al536BQGbSjd8XHCOhLh1bwPppkRHAqOc22i9fm31BgEJbKcoUvFYqtyCUPeigqRZ4fLrgCgyLEiDDpvViMOi6rmC6Uiq4zztILiJ6PmMSh2CBOVIPdoU4Gx5WhnbevPEldqYNxIep8jsNTn4JNLjoCQzbFOfnwID8zvLwMCWdg6pyVKaj1nlcQKvz+4gNkw73i/10LpWc/pIqpjPhdElJiNU6aKIjbvkyyp+6G5rP5ek9jpGTVFJNuOrZ7ESiCQscaaPDJT3Sg8ibABFAEN7RKx4BKP9DLVZM+AMoobekGwK/QkR1wKwu+VPwVlVf+oQxVv1zaubgmP7FGj36yWkmdoDWY+kLOG4lM3JSIPJxL2leOVhS3bcE2jTqTlBA5DOfcIJlghrgXp9YV44XE+2qomkM9xr90ch7ELoL50owGugDChu14Vpx2SsPffAufZWDFgBhbkGS0Cdv/BUhHtrRg7jGXlnBy7LOaCn3wB1NCwQ0/RZBI/PqEaZDP48F2X9K/2hqzv88+Ft3CSoRf7b1SNMfhI76oFJZZCiAQoqLa1iEBUqcH36+eVFCIYb8vFt6FyTvaul+13pF1RSBymmFxf9U5mHJPzJkx5RyfOiBwiZ57KXn6ayDkdvfLLA+kGHL5t9/Bsnu3vURDJMkrcyeFmcz2fajlV953WppNrj8VN17eIQD2Wsr1+Ut7Icmi98hiwE0p44cIQjypSzbgV4QnUmp3plR+8FVZEVb6Aw7n5iTlwNqTFR5Hu5CmQubQ29s8I2/hEINRrIMQCo/Q+rJ4G/KDpDLFsTX37wAHU49J7BawLTV28Un57RqFKRXGaEH
 picu0Gyq
 kt9eyMfRkzswj4aTUL/DkXGa3H3xox6Itgv/x7aGDewHLF+VT6vX8b72yNrwfymhrVdI4n/ADZpPPF2b2Z4dA54OIU2hOtZTns/6LbVtV+KZNoeGA11Q9uRnletf7LM+I6YJZC5xxqGDHSciwrR47PVgxxNv3PlA5a2G07v1o1LcXMt4qdvbOrVzpRASLGO8de7xJMWuinzP6GKedChIX1alP3WccQOIpFR2H+v6jkDIcAtA6mGp0zSlSosJvvcZUy/2Q9gIXUZB7DrH2WIW6YzAJlFvhXDgFpIyyMXbghVs3fzgz+h4nti/lceMh3nw78b80PqFtodaXod4uRL0yRSoWhPiuftMY05v8pwuNfqSS7i8NYwSYdZ3ZfkQLWaP6fsBmoP7b++8SzNATjoSEN3QycGwPT5TeGmvkp/Do66JW+P2u71luHtxfqscN0akicb8oBZ8NchFtyqQv0r+t/5VR5/ttKgboNc43qfNWifkKIfyEzpRXmG2jsVVpkJXE8lroF4dxt6hkyjAfhDlMogNby5o6/W5YmJyMBLaTzgPmqPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
counted in PSI memory pressure or in the swapin and thrashing delays of
delay accounting.  Refaults of the workingset from zram, the main input
to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
become invisible in /proc/pressure/memory.

swap_read_folio() opens the accounting window with
psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
means to count the submission time.  For synchronous devices the
submission is the entire read: swap_bdev_submit_read() does
submit_bio_wait() and completes the folio.  Since reads are batched in
a swap_iocb, swap_read_folio() only queues the folio with
swap_add_folio(), and the bio is submitted later by swap_read_submit()
in the caller, e.g. swapin_sync(), after the window has been closed.
By then the folio is uptodate and unlocked, so the fault does not wait
on the folio lock either and the read time is not counted anywhere.

Fix by submitting synchronous reads from within swap_read_folio(), as
was done before the batching, rather than from the caller.  This gives
up batching of readahead for synchronous devices, which do their I/O
inline anyway, in exchange for keeping the accounting simple and in one
place.

Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/page_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 65681eed9c80..83ed0246ebfc 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -500,6 +500,13 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
 
+	/*
+	 * Synchronous devices do the whole read at submission time, submit
+	 * it here so that it is accounted as memory stall and delay.
+	 */
+	if (synchronous)
+		swap_read_submit(ctx);
+
 finish:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);

-- 
2.56.0



