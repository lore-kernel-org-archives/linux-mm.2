Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19BE1125806
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C6A6B008A; Wed, 11 Mar 2026 09:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054BD6B008C; Wed, 11 Mar 2026 09:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4AB6B0092; Wed, 11 Mar 2026 09:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4CDD6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F7C9138AC4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:23:57 +0000 (UTC)
X-FDA: 84533850114.12.BB8A13C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id A262DC0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:23:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uzzGW+WF;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773235435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+O5gf1pZ1dggx/+znLMME1fX5E2Y3EWFqOzsy2U+5bs=;
	b=uUdqOVovzhHCnaCz1YsD+cnFA9ta3qJq/xUdOmPZAe5WFmwzZy4L6ifGpAagUfd7N37asa
	hDCcC2Tf0HAwNner4vE2mEDcNjfJrW7oMI5XpDwlzm29f0CfEY4b4Y6UlSJeqGLirCjwtk
	Le8C/5MxYvet0/6ugSl9XsgNoqkj/QQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uzzGW+WF;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773235435; a=rsa-sha256;
	cv=none;
	b=cMD2II0uj2LSoPCtLEd7q9+no+49s+GKHgrsP2OUVpbKZ5TRa0JmgnC0K3IF0MxhqKaNpT
	xEjHsweAaBG+YsZTEN9NRC77MWG59zqA82rcr2nK1Cp1EXRY2eZ4qzXsineg3ew3xcpgL8
	7cDbnZa94X14n3DrmQBz2doHKg/e0Gg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773235433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+O5gf1pZ1dggx/+znLMME1fX5E2Y3EWFqOzsy2U+5bs=;
	b=uzzGW+WFtGdGvSeA/g9dYSOAZWy5btS7pFr/AbCTOXaVxDveKfgRd9c5nsvNruHi7YU6l9
	m4dsTD2fyX0n5j9uH1tBt0UfDXsAstCi3fwinWrx2F398KFj+cOVnI9M8djBB/I/sye/QH
	GY8GMOgsnH4tAyrAD2HA+KouvYGzW1I=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm: migrate: transfer large_rmappable flag in folio_migrate_flags()
Date: Wed, 11 Mar 2026 06:23:42 -0700
Message-ID: <20260311132342.3193160-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A262DC0011
X-Stat-Signature: jgrf9fjkyi58ot41uhqgwkdsm3jwods1
X-Rspam-User: 
X-HE-Tag: 1773235435-184678
X-HE-Meta: U2FsdGVkX19THQVE50L/JKpWfbX5slQ+wGnxHyx3uMFWTKx+wwDZ0+kA5gOoht1dCR/u4WhKzGAunGZBjwpDjK3k8wRkVt4Vwen64UkifzLZ+2yuH7o1fzlVyWBg5Y6iufe3sOQ9GM/uZgGT1+stmXjkh8Aw6Cwpuez50VL9PrN8IR18R/4lmTcN2ztfWpACRDv/GyziZZUCXm5G2GubEkCn3/v+zA57MBq5Wud1/7ko0CeQ8wxzeQiODvi2aEzZo4je/of9qDiuRnutWQg9DmHr2H0FLveTdn2zsXK1+XGFjDrtLYF0AgSTPtvBzWxREYAYlKfEBBjabq79pQff0/b2Rq3ni1486aace49/iJ/Eab51FQ4m4hID8pvoBZ7BNN7tWEzAL4IoS5xFhM/gpkS5jjdx3mFGjNuSXGcZ37E/v8E4A7EfR4zxDBmcbMQZkRbb5+uT8qiNJ8TwPKPfE3LIpySRbj+CXswPueBWi6IrgqF7KQ72mlf2Cn7O1ouE7ANXNZWqAt1KJlWhXVVskg//G0zXgdi0KCjs/HMctwgxsfVBE/2JmlbkDGPeqgviZmGstu5fJfTWGVCoSqQs+2SgHZ9MS3293KSJlb5b7Xxxh/OL3QQbuFVzSF+hOeJd3bwevfI3lHletxRWUmSnPDVqQdeajswZFgaT5/5sjRo4shv0XFS8FEehZnTP/ckfBsTn8J2jD2KRkUCuon3OVxaj6NeEQikJ9nZCwmenyOT5PN4CRpq0toYNkmqZUJDPGZdc4dJij/WJwz0XkJUM9fBFvVmBlJsPvvBm5BYCfUYF/mJ1FH+P316jjJyaS9TD8tDltR01VfzJbqXyXVk2YrISkZuCaUAzEDmxn4YJ/vyEmtSszCf8xjcIyK0YgDkOT9eWrNOvKhGF0rB2gu1CpR60/UJH7hTZwj7epbCmLEnzixUJGH0AwcFu9QE68a9AScy9rpkooW7YBBzXlVB
 QOFdIy2p
 HBlJvTKWJMTzivDZCBjfLlJPWYpUPe3nRzKPhDVUXhHMf0Q2P2UYbC8EIBvgFnbhAoJA6Eo4Br0jNfuAHX9hJSP/Os1E3Og/D15X2nAAJd1WhGuxJ/3arjF1KAKcg3wUhK91TyEuEvNIXNs21MaFqEnwqUjkmLH4knfmZ4X64RIEniYE4+OehyNYSnluSA3Jk2v3EUfAeqUyrZxJS7IYjHrlaajW/LfqO4/fECYXHZhI/xn5mP+u3ZCPEnlWfZTbbdxfxDoGVNyWsY5VUhcNOaPXcQ0mFjaRedGf6KTe7dy+26bmDgsJB2Xqd3XEmHbDyVUfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_migrate_flags() transfers folio state from source to destination
during migration, but does not transfer the large_rmappable flag.

Migration allocators like alloc_migration_target() and
alloc_misplaced_dst_folio() use __folio_alloc() directly without
wrapping the result in page_rmappable_folio(), so the destination folio
never gets large_rmappable set.

This becomes a problem when a folio on the deferred split queue is
migrated: the destination folio can be added to the deferred split queue
via deferred_split_folio() (which does not check large_rmappable), but
when the folio is later freed, folio_unqueue_deferred_split() bails out
early because large_rmappable is not set:

  if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
      return false;

This leaves a stale entry on the deferred split queue, leading to
use-after-free when the shrinker walks the list.

Fix this by transferring large_rmappable in folio_migrate_flags(),
consistent with how all other folio flags are handled.

Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3380021fd3db..ee1c7bc851dd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	folio_copy_owner(newfolio, folio);
 	pgalloc_tag_swap(newfolio, folio);
 
+	if (folio_test_large_rmappable(folio))
+		folio_set_large_rmappable(newfolio);
+
 	mem_cgroup_migrate(folio, newfolio);
 }
 EXPORT_SYMBOL(folio_migrate_flags);
-- 
2.52.0


