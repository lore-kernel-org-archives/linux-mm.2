Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E24606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ECoyWcuI
Received: by kanga.kvack.org (Postfix)
	id CB6CE6B05C5; Mon, 26 Oct 2026 05:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69876B05C6; Mon, 26 Oct 2026 05:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F316B05C7; Mon, 26 Oct 2026 05:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 897746B05C5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12D8BC066F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:43 +0000 (UTC)
X-FDA: 85364285286.07.A93EADE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33F12180005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ECoyWcuI;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIB2Xp6FjBPfWS9jhb1q/bROMQT4vDagtnjeVLmjTUM=;
	b=CXPVlZhlaqgUpXP6PL/PiuUAo2+hxTAlO3MlOMQ+VxMn4FaaD2BQJt0zE/QFLkxSkB3MSw
	1f+c2qPICU40SPiabh/bbodaX9g8iiGpHxCgtoWG2c7J8dX9RHrAJsXec/jbQ5sDVA3esG
	D5acBcfRfmP4ipgc1ZxGTIErK/MVHlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007701;
	b=5lGPp4Lqm1W712u2uW+L176Hz+KvfmYQCycquku93IilP8dr987BA+2MEwnkVBncRLHK7F
	5nSfigL+262WsuTy4WA3ICOxYBBdTHfpz5nPtRywlPicv1UzbGLwyWTI049vzv7RtC4V/0
	Qjg08elSgAWuKi9Bdny6mtfuPY8kxXA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ECoyWcuI;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E5A040499;
	Mon, 26 Oct 2026 09:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795881F01829;
	Mon, 26 Oct 2026 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007700;
	bh=CIB2Xp6FjBPfWS9jhb1q/bROMQT4vDagtnjeVLmjTUM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ECoyWcuIHIReO2k+iIdaYY8Ll7Js0j9eSWRMUmexY4LkObZJB9hP5F6W2Sf52Ez+j
	 d7v5vtc9JYSvQ77qguCbQNaO8inCIjJCWinneteD/a/f3f5sxFJeulAfMmHrIvrawz
	 jfOnrUqIRvThcVKmlmEE+1bBUv/XTSs+eCBJTDtAY/GxTxRe5kgUwfXfTNjocEgQC2
	 HqO7Yfs+JKPBWc8amDBDjnkOqOcdANQo111hNA7EdURwvoWplwz8huG06BMAE1cZR2
	 XFPKtSoFJU4RtMju6iioBaePP3nxY1YQJ/lhQFvZpBmASO8b71VgXje83CGrXq2qpa
	 4vrTGXMchv2aw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:40 +0100
Subject: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; i=david@kernel.org;
 h=from:subject:message-id; bh=huOOPo/PWB8ZiXeYAxEnPQiR96JDBCTCFnb0WNlFItU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4glHA5bnhB5xEfO8sQz+YNnknYbB6eKbFz5daH6i
 dTFx/bwdZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRzCJGhjOVyzrbvwl6W++e
 MM3xz7Oc07mMHpqMTjlfjidf2J/UXsHI0CCwJeda5c7tYgk/vrNGTXsdIXIt+/znJerbPjzlX3G
 tnA8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33F12180005
X-Stat-Signature: 1nki5y6quj1ibh3fp4mmz7n1m7en9dwu
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007701-382445
X-HE-Meta: U2FsdGVkX1+2vYQs+gILZ0fUOP27YKeusO9OIJwZR3TeRfKRGfpcbOfVHvdwy2t4WPL8M3axRVYrb6+Luozvd7Hp7E0ETrYasTeVQwqNhOU8ihosAqVLf6OrWEkNcRtmdDyIVboUpyqqBwMDojsImU7OaPjzEb0KYd+zDpCZduuWjv6XbUvetyOIJGa/REsOsYIC5S9P6ECsZb7RS8kA2kzQ4Q5UF++Q5uEdH9okvrVMSjSoUQ6UvhKUgYHMb7Tp3QOedBn6M9rNlX2yTwZu2bHhY73+OBHpQrHrLHYyIiwhKrsV/HI8nohzBtJhcp4PkMGWCcO1jsuiTp28sRYCdmx1AaCNecwHNvm0kh7gWWMcBDdpyCpmc5NsUvnWx8qN1lU78cDGkRrfj2QQMQ8DJXMnEClD7I/K6KyjjMK5TjVUrCBo0Ef3zDYdk7JUnBQ+azqtqICUWK7XSxZ4s5qaiQlKT05gUi0RG8qN0bWSsasNXemhM2gawrD4T0Dq0CrdA2xaWMQFVl2LYGSXhxpnyORMgoxqGDE8CmUNLPFetag5MA/I9ksTO7CBy27vW5AjhG3Pl883klO49IOxH2W91K+tbva39oqqQR7/0C4env1O9nBaUYVDJnJK57CVe9RRcLyrSrPP9oF3xrhw7h7Wq40lnamqHuCZUYJjYScreuVEFvAiOzrjh1oQL6824vgjLenFesIMg032LfYHy9nWxIo9/6w/g+bmtSZeHnoJdQRPzADe9zFT9nNnH5PuLVE2HOEUlWWJhZYac8qxaXF++p7GIkMtnbX/3vbU7rpMxNDwrQS8yoEISniSslrxz8dnNRvMy+kI+4uzapLKmNO5xVlfwZDyz5zKsDrplo3jmDgztSmf3/W+ID+DB6Mv1g8ukg/q9j39F9YXqaVfmKKIMdEqvF28HBGw+SHJ8s0A9+PxFfZqZdTxMc49v7uUG0SMWXX4K0Vj/Q/UdFznos0
 f25x05Pv
 DJM02hbn/g5xIJdVlN5YbmQ3te0qgDLXoVImZCwIcLwMRVux8iniw2rNaEJedbWiiHXaBi2nTYdWa8gjLeYqaUmpCly/yEzWGj8rrXJm59RPX0HrY0eirnCE1YUGY2DuzqfuwtSzeG5v/QkDov62YZdNLIzVoAoLRxDwFTywL1oGO/kAUX2uhbEQ8ZgMOb/GcTaiE66BAad8B9RSI4uM/YpWFlSKFpr/f7eggecTsDoXT9EiDcJxMeH5jJc72KsmaccELOFPv/+gSU3o0UjgiGZqlhTjlzsbztXsiQULIxIiM/xBBynIo4RMiP2FHzhopzNOe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A nonuniform folio split can fail with -ENOMEM after splitting off some
smaller folios. shmem_undo_range() then sets start to the end of the
original folio, which may now lie before the truncation boundary.

The final scan can consequently discard data below the new EOF, or
keep retrying a large folio whose split point lies outside it.

Keep start at least at its original value when skipping a folio after
a failed split. The part in the truncated range has already been zeroed.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: split fixes, simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c551e33c697fe..2410ec46ee1d1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1388,7 +1388,13 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		same_folio = lend < folio_next_pos(folio);
 		folio_mark_dirty(folio);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
+			/*
+			 * Splitting failed, but the part in the range is
+			 * already zeroed, so skip this folio. The failed split
+			 * may have shrunk it; do not move start backwards and
+			 * discard data before lstart.
+			 */
+			start = max(start, folio_next_index(folio));
 			if (same_folio)
 				end = folio->index;
 		}

-- 
2.43.0


