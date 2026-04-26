Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429B7FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9326B008A; Sun, 26 Apr 2026 07:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A1E6B008C; Sun, 26 Apr 2026 07:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958C86B0092; Sun, 26 Apr 2026 07:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8262B6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:56:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45D1412055E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:47 +0000 (UTC)
X-FDA: 84700555254.14.9974C5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 684941C0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpQWXeX6;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777204605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVUVTbV4DmzWU/HKfZJodrarBNnINFLhM0LqcLLE7Bc=;
	b=J2o9jy4bFWZv5JawyODy4FjMt/89jkX0Dw7BejLNdeu4eCQakOPu3UPMbBHt9g+7duijV4
	OKqu1zk2dAD4OJBcfxAJ2jKecGg4zvatBNdyC+meMDdMSmvBt/kpzwwtYw7UKcmUuN8O/w
	E/u4h8NB7kOciKocxgUyV/JaKh2iavI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777204605; a=rsa-sha256;
	cv=none;
	b=CB8ctz8g80Fan0Mb1+YVfiWhfeTB4GZ7gzLxihykwfMQKXjSJMVP1dMVNzBa9yPNWb37PQ
	dAPprDgVcwO0wJ9xjER9DgZ4Y2JIjYuJZzbRbtl2Us/ubCaHPeh7TpScDzmDsuwzUQdeJa
	9yrkBNthRZg+ZSFtct275To0U68PUrk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpQWXeX6;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72D4641E60;
	Sun, 26 Apr 2026 11:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE65C2BCC7;
	Sun, 26 Apr 2026 11:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777204604;
	bh=lShvPUZtkzEbs9UjOJnKGezjl/aC+9FCH6gTzp0HT98=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CpQWXeX6Lr0IU6cU5AKbX7juxAPZ2vfsbItLZDeWUgH3Z4eJIwsM6Gc4nsVK841XD
	 RyBWlxKyKlvt89D8DbRvb9wNjA7sy9BlqhoYEWEA699T1gXPxnXdWEY9HshDvScyLr
	 /wcTEK+Eqoazk77ZQa+RFa6yhYnubfoJ9aDQ8A1CEOgvEuBg5vSqvzkTr4BIXJr/2W
	 2EcFxwBNH/w0f2VWxqpcBbDmhGn/xXCyJ8YrAWa5106JL7z7pyPw4ht1vBqq2DDWA/
	 H2DaxEwm7Og21ULSsJFM+aMPJ8XakxjLJdvLs6wOINSuWraZnuSRoEdxsb9uDZOCsn
	 vZdWnb5DHBXbw==
From: Jeff Layton <jlayton@kernel.org>
Date: Sun, 26 Apr 2026 07:56:07 -0400
Subject: [PATCH v3 1/4] mm: add NR_DONTCACHE_DIRTY node page counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260426-dontcache-v3-1-79eb37da9547@kernel.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
In-Reply-To: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3971; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=lShvPUZtkzEbs9UjOJnKGezjl/aC+9FCH6gTzp0HT98=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp7f1zf9CTlq6JPeG4iiERHYH/s7/r/mpN6W0Zy
 r/eX9lzvNWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCae39cwAKCRAADmhBGVaC
 FcMUEADGRbm+5W/V/7ipFOu8wKZLLjr66aeLjuTR64OiEWQt/7Mf8tX1jqzZeYEGG7citRX3Ha6
 maC5/LmG+ZFi1yXJ6yPJydpPjVKgo1zC5iLxQSeXNs3k+zaBtKkeOTaFF+WgRUu9G/Uf2amnkhP
 0K3mbty3oitNjI9JoLjVd/r8haA/dNB9PNIJxPfyqrwXYvVcqEyik8JUda4+9VuuRrPsKray2ie
 xwlWxU696drZ0K1I3QaevnUL+sVlWI4sAjBPvDheanRzu8uRtIliQ5Go2e2SV9AtYZn72zkm5Qg
 28Ux5aoKw11unzRxBMixl4xS5b9V2481YKdsQApM3D8qnQkJa/if5XthtDh77SP4fyqn70x1N93
 GeeePY3fjn1XJVeyuntR4qgH/perFKxwC49yMpE4zjkW3FQZ7//kOFyJdhVCj7I0Vwntp7Gmslk
 bSNrxyaPW5Q0LFb45FcG61hDtT2ySjpw4L956modzI7heHQ+z6gAZ1MWTPvDxoJrVzXmcRMsZWV
 PZpkUcv9JUf968U/7dU8Tzqi6rAzIrJaSJ/E92quPKyck15bPAIDeEmGn5955nQ4elCIrl4/axE
 STdCKtcr1dcAg/WdZ18pY6dwBaoEQw83xXyZcoKbc00oGqqhKk/DRkkm9UU9czBD6OJ998hY8TT
 /Gc26l2XZkJL9tQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 684941C0002
X-Rspam-User: 
X-Stat-Signature: p1sfqyikstyobxwt7jnhyxkk84115cr3
X-HE-Tag: 1777204605-273576
X-HE-Meta: U2FsdGVkX1/GJggMk8HYXronftF0klvFv+foX9C3MhlHp+tS9Ct6z4yvkHoNYYGesTGPgjgBM0rvlSG+kymaTJRDkpkxQ3PEA3JRlSWwzTCYDKuU/8H1/lE1797QWPTpW7RCrXXsjZEJVqIlTzhObtYMSHWRCE6NpM5GsVojJhvgTAIfoLTbSQLXTCeggJhamsGn9Je/+jhq4ch3KxBc0HUGGmHpl3Xo08vNA4k2hcVqVtX0A15jJsn6zUuozGlTZshHAO8CqcecR5s9i3Tx1FEH0Q7QKFIwCptVfNejGv2/8an/gI9gegaWF6eHdxPeSVpXoAftcVsRRznAiO+4h9uYIBkY+cjQ6W+svmIwubCME48cOvIWej/tosM2+06t/3dXOxUYnvVR9uuJ+6cZxJRmvhmDUMJUKL+o91811qdQMnEL8NEY+0fW3mdFUysugol5AKe+uymEN4duFfpjNq/GZZaSku4qWJgqCUH5FslgZWy5uPjiVR9zhyNMziAR1GIeEhWIbGQqPTCMab74bvL4d0R0sVQBx96zZ+rne0rJWyaUHnf0uzlsfU5LcRv34/r8DvacFbNJOcAz9br3bp7m2Jc0OalY3/0AOrl6uqEEOWerwrTstN9WbW8ToxxGK8nQw/RNBQAr+1gvXLJ2hiLQpf/7Dn5Qq7bnsFqDXILDwQoMexYIfvOGfNeIiwebWBgQU2gj1V3GqmAHSl479OMskOnsIt5J/bLp51pFXUlHNUSCuld0w7iePLvdUc6RJuGC8oE2Rz/wV4uzmBdTVZzQhCpcTM4pxuWg1a/rZHMiYIPpRIDUoIeAYYIVqEWjAKYMaSYzbL6mzQFWVDOw6ucHwLdWuNWmHpry+7BqnqNV4x2ASKA9VQ0Jb8zXb6b6KQoE+OA4UtuKbWREoQjoPLq04bhIfEGO1UydpdhfopqkgMyQkOkb+Hw+hq0Kg6AXqgP+T/ziadcCtg59lmE
 06EhY2YB
 nLcrWOXIxg1X9lGV4uoTsjn5Oyt1hBHsHJi0Pb9YC2pvz8MN+V6W5uJ5PEF5Y188aiXchUrVjilU/SYSx0WmAjAWyIYwBnc5ub5Scz1SNnp0AdmKszufht+3zwNNKiSoORgUycSZd4MxbhX6oF5MXJYI0Ar0yJsKkRPWCD6HVEBmZFnjBnH2qxNaZ/uuh2XyIZLUupM9D3+cJmh46qeZ3Q4+EgEI/hl7W0IaE2X9LnYK4l4/CCM6Vi+pUckr5gbyUU9kqYEVGGWJCmuMqFCWzQK8HIQsY/PcOKQ8pvItgUlpkB8Udd5H4IfmqVK5B7OrgYeo4ntkkYdZS99yQY9KgIT4HzHSweP0MB6M/IYxxXPZqZ2PMY/7HwA3ZJgrBBCn9Yk4bzI5+sMXO4/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-node page counter that tracks the number of dirty pages with
the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE writes).

Increment the counter alongside NR_FILE_DIRTY in folio_account_dirtied()
when the folio has the dropbehind flag set, and decrement it in
folio_clear_dirty_for_io(), folio_account_cleaned(), and when a
non-DONTCACHE access clears the dropbehind flag on a dirty folio.

The counter is visible via /proc/vmstat as "nr_dontcache_dirty" and
will be used by the writeback flusher to determine how many pages to
write back when expediting writeback for IOCB_DONTCACHE writes, without
flushing the entire BDI's dirty pages.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/mmzone.h | 1 +
 mm/filemap.c           | 6 +++++-
 mm/page-writeback.c    | 7 +++++++
 mm/vmstat.c            | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..ed9cc61c7627 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -259,6 +259,7 @@ enum node_stat_item {
 			   only modified from process context */
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
+	NR_DONTCACHE_DIRTY,
 	NR_WRITEBACK,
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 	NR_SHMEM_THPS,
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..45089fde5150 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2052,8 +2052,12 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
+	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE)) {
+		if (folio_test_dirty(folio))
+			lruvec_stat_mod_folio(folio, NR_DONTCACHE_DIRTY,
+					      -folio_nr_pages(folio));
 		folio_clear_dropbehind(folio);
+	}
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 88cd53d4ba09..e1df93fb3e3b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		if (folio_test_dropbehind(folio))
+			lruvec_stat_mod_folio(folio, NR_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
@@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	if (folio_test_dropbehind(folio))
+		lruvec_stat_mod_folio(folio, NR_DONTCACHE_DIRTY, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
@@ -2920,6 +2924,9 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			if (folio_test_dropbehind(folio))
+				lruvec_stat_mod_folio(folio,
+						NR_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..c3e5dfadb9a5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
 	[I(NR_FILE_MAPPED)]			= "nr_mapped",
 	[I(NR_FILE_PAGES)]			= "nr_file_pages",
 	[I(NR_FILE_DIRTY)]			= "nr_dirty",
+	[I(NR_DONTCACHE_DIRTY)]			= "nr_dontcache_dirty",
 	[I(NR_WRITEBACK)]			= "nr_writeback",
 	[I(NR_SHMEM)]				= "nr_shmem",
 	[I(NR_SHMEM_THPS)]			= "nr_shmem_hugepages",

-- 
2.53.0


