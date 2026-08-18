Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E04BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B71B6B018E; Tue, 18 Aug 2026 12:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EA76B05AF; Tue, 18 Aug 2026 12:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC516B0779; Tue, 18 Aug 2026 12:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4416B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:11:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3DA4401AE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:53 +0000 (UTC)
X-FDA: 85114881306.25.AAA2F01
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1C7CC8000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Tn o4qEe";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k+mutLmqF7YJwLjxm7xAk2zMZy0GTxUSjKC7fhTsZno=;
	b=Yz1C8Qt/yCyfLAqMPWzVtNVIpBX8ttLM28fYpyVyoDyEiDApplGtZlrVPmdYcan4pQCfZg
	obPkNlFpwDgrhpioAO1+LTVMbeL+Rk9O+WIQyaXBIoo4aUENHfjsDaH1ufi6gu42O8Yyui
	io/+t7YZvDvw5Wp49QKu276l6Q6Tphs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069512;
	b=oepvBKdfrqXb9vC4R/r8lhn/+oN/19p4GqyoQaA9vX24hSEDgzqWlBasgSvX0T9/rc5xQY
	nPAC5FXH2aPMkv4n7/DYWcZayJ5t9eEau0UNlAOZQSB4QdRswFf8XnCk3zsTgBPFFfP4cD
	uOSsJw5QDiuT42sKXU+K4mqxxfjDuNY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Tn o4qEe";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=k+mutLmqF7YJwLjxm7xAk2zMZy0GTxUSjKC7fhTsZno=; b=Tn
	o4qEeIyGCiG8GbVFuHBCi1HvWtK7Yn3exE8EPsf5erax69jW/kpgAEJnqs9yTGggH1qGWwUJnwNeD
	Z5GEEa9LKQCjvcxx/lq3upG/oEiDWSfRTHlL1sE4vZeUDa8/V2K5pDtEhROW+hsz1RXXqO3g98lZ+
	Jfzup81+zgSiBleUDPqSZf+56zyolO+dp+Pnj+NFVL7H6sM3+l6i5x3gELn/1hysFiXaoUI2GTNbz
	9pbijUbMxmtdSV+Sg6faQ9np+VA5JJKz7LKNINXEnyHbaeYFvvYE1Dhi3xLFf02F2MLpYzBaXWlbm
	CJuh2KIJTR0NT5MUYAsxYK5of/wFfYjw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwLga-00000001TR7-1K5P;
	Tue, 18 Aug 2026 15:25:08 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	iommu@lists.linux.dev,
	liam@infradead.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	ashok.raj@oss.qualcomm.com,
	jgg@ziepe.ca,
	kyle@mcmartin.ca
Subject: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
Date: Tue, 18 Aug 2026 11:25:00 -0400
Message-ID: <20260818152505.1057922-1-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6pxnm951zk9mwj9x5pgcucs98b7d89ik
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C7CC8000F
X-HE-Tag: 1787069511-45602
X-HE-Meta: U2FsdGVkX1+bi5yL51C8lSsee4t4u4e7nNkmFFQEwHgNhvWfSBUFESYo6DPbQ0nFmXzgDqmTSBca2PmpbTK/GP8YBGfWuwWAcTjU3drQTyubaDRFJSoV1zJaKfb/YYQn3GxX2/l6T6j1DB3+zZJ4vGeGgsWT7NEhZNUpDRgjsEx+2osv7kKw9dGuFxdMdU7J8YjwVtlYlthutBAXjhqDyO8f9J6pgX7lWrcFN4Np7xCHrMplVBGFXkZ5lq4mFGvCSd7Nl2ba+FDRkSFTTwye2zaTMxn1QX1V4GAufvOKgQRFLzP4uGzKyd5kGPs6A1XLxuS2+TYEp85bhISM2w7kff1z0qWoUQXt6wq8T8vU7kXXHMX42MV9WBhv/zYh5+28ujbW97ipqt35a3yE5ykjgJBW52iGEH41W5EmMVaOzbgEBB/0wp+wvnk5tcD+Bx7DYHi1L6ielLs9/AMIA6KjY20LIRi8qzm1OoE9zb5M172nDCrvY5yfQ6dIqdT7OwO2V/sK5sIId6Id/7GeJQ4LgMor57ghhWgU0NF3wZJG7IV5IAgMHvwCYAs80qEWsC3Ltqy9roWmXertwuhhvac+gBhxbcfiM3x1Ax4o+KyHG9hBAKZV7WGWKWh3pEh3W5jNaEDzAIB+3fQ9HXxWjcgA3H3WBGBPr/rnOhUfdMSo0QJzKz3NJGCL58zqs8mHRl6RG9n/ixqkuoHmCz06CEHBFcBOr2mAQPgsT3zHwhhyZLaxw3EEeQtm3XkRN4TAJ1x8eRVpXpfpew/jJZ4prNljdypddXm09S2VoQ3w7ZRY1NWeMa2k97U0jAstF9iqVUfCIUQRzPI1Oux91vI5cLEcWw6JF/LWjfdVVfyQUrbB0JjX1070XheWDzJfe2EZlWjbPO8e4wjUSmmsBPMjIOiOE0GKtrXtFd3nbR1iUTKOkaEuKI2/10fubVpnaQYTdvcZyXmOHD+pDWy5zilZf5x
 Di204g0q
 zCUQJeaXWV3Rgr/ZBFUsIccyepGHOSviKj8tPVR1g3xZvrUtzZbvJwhWhNPnMWenzuqMsiWVX7lmbm+pngu+s/cljYo3woANRZ1CvHjYiQ6hvGtQtyUIjBc9LrCO4nfBmbev8vaYwya2/ke3wm7EOqmCb97b1ogFWTZP8SOfXTTiUIf+khGUqAvLfd6B8HIngRBdAsv+WC2IGMybkNgFLgElEFMHKornCuirgLE0XbqvNzGBKcim38FqxeApI0Kkm8JvbTISqEt7tY1w+fRHoMduedmHfpaVkfRYhlG4yu+ozpqSlrqGWd3JPSGAnm62rHpVL3Ooc8zBx2ywJlkdv1/1JhqIS4uyTZI83
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Occasionally production workloads at Meta run into the linear search in
alloc_iova() in ways that cause real issues. For example, when enough
CPUs at a time fall into the linear search trap, systems have been known
to get stuck for so long that it causes soft lockups.

This series indexes the iova ranges in a maple tree instead. Its gap
search makes alloc_iova() O(log n).

struct iova loses its rb_node and shrinks from 40 to 16 bytes.
The maple tree keeps its nodes outside the entries, so total memory
use ends up about the same as before.

Patch 2 handles the one thing the maple tree does that an rbtree does
not: erasing an entry can result in the need to rebalance a tree, and
allocation of maple tree nodes.

iovas are freed from atomic context, and GFP_ATOMIC allocations mean
the erase can fail. When it does, the entry is marked IOVA_DEFERRED
in place and the struct iova is freed. The marker keeps the range
reserved until iova_drain_deferred() retries the erase.

Ashok Raj asked on v4 whether the marker store can fail in turn, since
the WARN_ON_ONCE there reads like error handling for a case the comment
claims cannot happen.

Code examination shows that, with the current maple tree code, the
IOVA_DEFERRED maple tree store will never result in an allocation,
and cannot fail. This series adds a test case which allows us to verify
that maple tree property continues to be true.

Only a corrupted tree, one no longer holding the iova at its own range,
can reach a store type that allocates. The WARN_ON_ONCE is more of an
assertion than a recovery path.

Liam Howlett's "maple_tree: lock checking and clean ups" series adds a
WARN_ON_ONCE to mas_nomem() for a GFP_ATOMIC store under an external
lock. This series is external-lock and GFP_ATOMIC by construction, so
both stores would splat if that lands as posted.

Liam, is the intent to disallow that combination, or to flag callers that
cannot tolerate a failed store? The iova code handles failure on both
paths.

The code was written with Claude, and nitpicked by myself. Don't be shy
if there are more nitpicks remaining.

Tested with the KUnit suite in a VM, including with PROVE_LOCKING,
DEBUG_MAPLE_TREE and KASAN enabled, and on an AMD Bergamo system with the
IOMMU enabled. I know of no way to reproduce the linear search soft
lockups at will, so that scenario stays unverified in practice.

 drivers/iommu/.kunitconfig |   6 +
 drivers/iommu/Kconfig      |  16 +
 drivers/iommu/Makefile     |   1 +
 drivers/iommu/iova-kunit.c | 544 +++++++++++++++++++++++++++++++++
 drivers/iommu/iova.c       | 561 ++++++++++++++++++++---------------
 include/linux/iova.h       |  21 +-
 6 files changed, 901 insertions(+), 248 deletions(-)

---

v4: https://lore.kernel.org/r/20260624030853.2340880-1-riel@surriel.com

v5:
 - subject prefix iommu/iova:, matching the file's history
 - put_iova_domain() takes iova_lock across the tree walk and
   __mt_destroy(); without it lockdep reports suspicious RCU usage,
   since a MT_FLAGS_LOCK_EXTERN tree checks the external lock
 - explain why the IOVA_DEFERRED store cannot fail, and check it in
   test_marker_store_needs_no_node()
 - deferred erase is now patch 2, the test suite patch 3
 - rebased onto v7.2-rc8
v4:
 - reduce the size of struct iova to 16 bytes
 - simplify the (hopefully rare) remove_iova GFP_ATOMIC failure path
 - test case for the deferred free code
v3:
 - switch to maple tree (suggested by Robin Murphy)
v2:
 - clean up selftests (thanks Jason Gunthorpe)
 - drop the search-with-alignment, since most iova requests should be
   of similar sizes, so the worst case behavior is unlikely to hit
   once ranges are excluded by the augmented rbtree

base-commit: ad8d485e665829ecbf3c97b22ce251f8ff5f8037

