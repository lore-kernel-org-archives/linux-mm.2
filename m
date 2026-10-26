Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB22606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RD3sTveD
Received: by kanga.kvack.org (Postfix)
	id 5DB3F6B05CB; Mon, 26 Oct 2026 05:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3386B05CC; Mon, 26 Oct 2026 05:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8B86B05CD; Mon, 26 Oct 2026 05:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EDA76B05CB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5EF4C069D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:03 +0000 (UTC)
X-FDA: 85364286126.06.4C292DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E8C2F40005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RD3sTveD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkrD495PT8KvXx+wacfeY6qqrolNrkaLFRbD+03i/Eg=;
	b=ctJcVjgtRSde9HPkTYOBKoq3ha6Z49AzsU4DXBa+z06CEXTHl0qJ6oKG33AJl/E5cMjY4Z
	y862Ak5oX7nHoWaQVJmD2a5CBHYdv04Iml/GF9wi10/LusJk0klkQvGbR2QEqlXjJV7DcR
	9KY4r1vwf5psWUh3KRtpngwGRZb2g1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007722;
	b=c+rqyn/l6fkZ3LHdq3k0UTL2nqe+nq6Kr/Wcy9Rn07+bWHfnV35wrLloOplSSumRykZJiu
	WsEfrLlsIpQ8RrEyUvXVAC322V+KFycnqRTN/USN9IGduTqiQqriS7oa/ZjoE8yQa+kEOF
	EtESLUTRssStPj25fC7RF1zU4abtcp0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RD3sTveD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D97C4169D;
	Mon, 26 Oct 2026 09:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3411F01484;
	Mon, 26 Oct 2026 09:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007721;
	bh=YkrD495PT8KvXx+wacfeY6qqrolNrkaLFRbD+03i/Eg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RD3sTveDzjGei9ZxgcQN6iTQA2b4yENz2Yit9n4466aEJMlAu6z9PFAzI6/FU/0Uq
	 Viy1tyjil7OQWK2Bz71ERrByrRIYCdxdsNg1jXWbn5EVdW6itNn9FDvhEB5raZFqSB
	 Pm/Jw76+aSwl+yZXm2fpiz1prpNkAFmwmbCFV9fhW1vhPhzn9fdD10Z6VcbexCJp5Y
	 8/zUKwKW73mJunbf5MawWUyaDKMeC0WmnlmUOx61twLF+wEYioiufl24zMwnwfqcPP
	 CtKrEVFYK4BHSmt+Dgyv/KPfH5BowWUX/6/fIpFh7K7z2CnByP+WG8cIR/CicfkbJD
	 4sGJmawRxoi5Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:43 +0100
Subject: [PATCH 10/16] mm/shmem: discard whole new large folios on
 fallocate rollback
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380; i=david@kernel.org;
 h=from:subject:message-id; bh=eBeVwVosSjmZ+XFjtnKWT7CD12JlDHJ8L0A3Idph/fk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jv0J8702rX9uabOVdKFacb/rjRxBB51rKf/cvPM
 4kpD6fZdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARNXOG/1F37ve8vl41fX7C
 LhPhaRksc95pS6nGFy4o/V309Gvw7zxGhuO2u9a26PbzzDOpk1Y/v2+F6USvNefW2Py7/9EyJVi
 ajREA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8C2F40005
X-Stat-Signature: c46noku9deojqniqthwpnfjm6gus9558
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007721-957909
X-HE-Meta: U2FsdGVkX19dGTXMCAmSgq2dGA8frANUgzJ02cOexIogUuzG7dX0Toj5xztws60O9vXxv8tQSiURzZuegh5f7xhtRjNaB7XX2WCM3y3Rl01y1Ww6s02AWnzB+ThuFSUkuTmNdseN0l4NADjRFbBPA/R18hOCVb3Jr9apHXtmShfXZXXg1z9lZfZ26P5hoa2yoifDHw3wiRgI3wdZ3+08Nxerb0OFi32Je2+4fIgKxK+Ihxoqp3q0L7Dk4ae2KOuRgZmaKq2MZ6MpfqWGDvzrZxQ+oxXc5bSU/yVldE9aL9U3PEJy+UqzwHJGn4fTw17xp65iQXK4f7L6ZQLGn9+a8Wvm9ZpOVTp/AMHFlrjxf1tC9TxNCHwmskbekjNBz4ZYM9xAQqjyfOw+Fyslzu+SwRL8GrmqG6vix1OwesNsw4GUDolz8Ujdpa0VJmwQV3oMLP7VyyhFOeYTYs1mR5NSA2LgYhVI0fWAu8dnObFLRXzqmc8uglJuYC9/sYSkVdSJzoVqTt3q8JJjuWFwDpQd38uqzGPMalV/2FaPDVLfKTzyaa95/MHtiUo32OlurH9x1hbRC6rNfYkwIc4WOhowgxKHdd2qUx7xhgYD9QQ0FR+mcSC7jfgWrYCqnEVSyiVmc/+ldl5lAD+GaKKm3+2X+5XErPCCNRcJFB68PPNVeRV+wCsDjFuDLnQsuppkow1oS/6uQ1BMlCyLmsbVuXO84TArXufGuNQW0J+e6jfZrBvRFhBNXsLSa+Cj2nqaWS/RRp80gLLZC7cT9+ORHFOY7bqok/IFPdYcGr7joNkEDV9PEei4clhVmZxc8z/VAuFnuwacc0KBWLGG7Tml8K0JhVEFV5AELu/SZfneBgGJvAObvG/hIfNIdeFfbF98cVd4l33HxOVdQX4sQnk8KHsvhNmanpUoAzDvsXb7ln5jEIcjZkZuZNJ+PmfRWYisf6tjOJ9EYSCEkF0t4dijmm+
 bzNAsNbg
 QRoobdp48YEkb1mTB3g4IGYTzjK5XuaJLvqoesTC2LUWMjJJW5wgm/bugPi3ywOxY9baP2vfYgYXf1hfjzfsPn5PRWYuPa1YEgagEnHAVgWrwR7YpppeWGvudIpz3/PYSY5O9wOnY5ySSOSnz2qsVieUhkZbLgK5hFKsT3j0dzCz46JJO3EV6pcUUqmXKJnmWA3HjwEDFW/r72L4WczVjPsgc62iqeOIXan0Y5MIXd2cKZpR7XAVdV2RvYomYRasoexXVaJuahFByQU9pZxQaC/UatZ99yzBy+BXYmJZZ1no+u4dCZH/MLZAxBLkLCM3n9Wfk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When undoing a failed fallocate(), shmem_undo_range() must discard each
newly allocated folio. Its second scan instead passes large
folios to truncate_inode_partial_folio(), which does not necessarily
discard the entire large folio, but instead tries splitting it to
discard only the requested range.

For example, with huge=always, a failed allocation starting at offset
4 KiB can leave page 0 allocated in an otherwise empty file.

Discard the whole folio when unfalloc is set. Note that we enter this
path only for folios that are not uptodate, and can consequently be
dropped without losing any data.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 938221c473f3f..c8608026e06ef 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1483,7 +1483,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*

-- 
2.43.0


