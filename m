Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EFE60A4AF4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAvaUwuv
Received: by kanga.kvack.org (Postfix)
	id 9C8626B02CC; Mon, 19 Oct 2026 11:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D8C6B02CD; Mon, 19 Oct 2026 11:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FB46B02CE; Mon, 19 Oct 2026 11:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 595B86B02CC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF79DA079F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:45 +0000 (UTC)
X-FDA: 85339813650.30.2ADC7AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0924D40005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAvaUwuv;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84kciOlrBZyXkODv4mERfw9QO7WVRKrOSp1zoHtEMTA=;
	b=DW23lFcNoLCW/a61mTzriR2TN13OxG23TV1ODCJhZDPEpUn3v+9mGJI7pnItM7kh+YPSdF
	30oRx36Igq81Nhrl0ihLt3TbJP6XLMLFgUw/fXzTjJcVnjlDCh3Wd+KDx5DT4CTQ/ypqqb
	dF8F2D47RnZRXizj1nwp83gU0yCgPqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425044;
	b=so5sKbxCitU31h2ilTfpXlnbkBVMC4zTYj87Jvgec5LB6AxojhIllcqfuV/uw7tlXO06tm
	EsaIScAEWNOWU+3+4mkxhH1lFocH39MrBlkxgcwYkAmxvyT20xh93OLHibPbG/M84ZQkfs
	h/noGbRRfVd6t+kzRj6284RscNidSQ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAvaUwuv;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 971F360A8C;
	Mon, 19 Oct 2026 15:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23951F000CA;
	Mon, 19 Oct 2026 15:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425043;
	bh=84kciOlrBZyXkODv4mERfw9QO7WVRKrOSp1zoHtEMTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAvaUwuvUUtLmjHYM/vxdlwjRnPCQd/X1k+Vw9SNUtMs9+NZJtqXQVqXvKPce2k/1
	 NJCVygj7XBwelPnvcCM45nnXhwbK3SsH9e9IVmctY2H78WSxBaR0KvtZQxDtJVhM17
	 tUbFh5QkQYMGYUQCuePulKhNcEeHnBHf9kgposV10ZipNjxU5anJqHBNeBJ7GSrOAA
	 olUj9GyXxCNMHqHs3XuQYGjJB4l9U7YTvaHIy9wob25lR4PgASSai9U5/TRjt79Z45
	 nwyrlNUis8TN0J6gKu2LQN37WExB0MjiBdsLWM3gp0uLGZba+NgDi5HEvv9B4EnbkQ
	 ZFkS8VWRjlQ5g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id E2028198003A;
	Mon, 19 Oct 2026 11:50:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 19 Oct 2026 11:50:40 -0400
X-ME-Sender: <xms:TDzWasO60PQvntzS9366fCY95rDVfKeIR3NJ7ADs4wV6sTUJjpwbGw>
    <xme:TDzWaoPKS8FIYC618DvlO3pyALvXKjKQhn2vx3rhkDA0tTDewfl-I4kdm13kD98Tc
    23RDfK5vMlPpiz-hsQaC_cfvN6_gIjd9p4KxXJBbaQSouuBtIMJHAplpQ>
X-ME-Received: <xmr:TDzWal47R9QK2HPBOM5PFWfyKY1_XY1VmGEp4Lzi0bNCigy9R2QEHqVo-HA>
X-ME-Proxy-Cause: dmFkZTE+kjgISKw/D5xbtovMvE/5+MXw9OAGtDBfqR9Zk5dZNOqhNWGTcEGO5Lmn7qsaMJ
    P+2+K5eT4SfShSSEvxMo9+0NhMtUrbV4W6Uy0A3XpuEB672w8089GbqFaxEF0wWgdpl5Mt
    ZGUplA1E9XDXzNgkO2MrFgMfcNS4u61SieDRP0v46gjH0l2eZ2DL9zme+jYfCIiYlLA1YJ
    nvbn1HssXPAJFHKdL+OCiEp78jaTWZC2fJHjA4vCnfghQrymIXyUGAHupLMJJEm2bjt0nv
    kEsuBoXYnW/I4u0Q3SZjAxl07Y4ERxrcHOAeD/N6wYko4+jO11wXgs98kOmjLgJ2rMOJsz
    18DGIkmN8sCfzQCV7sEJC2pxZj7RC8eMNg1UeU3okF34a7lwK/lwdys+qzGdOtcOrJ/aTC
    NyiQb2ojE9CGVMmdY3XRIUnsiIK+vh2Qp4y529vGZS2ky5yIHL3l90Z6GWGm/WOIIfg5oK
    Xg26A/pynhkh6hF6E3O78PaDtNLzaswXz7QJDAJiscbJuWQaSXJGKaFS8MYUIp92Gs9Bqi
    sxgAWUCcGgxBqOARvxJ8DYrqTKwa3N7LrLH3zC2I6q2SQjdzl3j6BRuxDXQTf9D/aeV5Nz
    GTRyl5naroztNsJRmBnZqOQ+gKUFxhFup+Qqs7PCujlpUVIZc9ZejZctTQDA
X-ME-Proxy: <xmx:TDzWakbXGWKb0c3p3qtVBjmRHsel7_XO7EfjIjy1thc7dBUfGuN9jw>
    <xmx:TDzWalEbCtrJtH572tDLhZDb3-jkcyazOMqru97D2XXJRJYZZP1pjw>
    <xmx:TDzWagJ63Zx6R_4aGY5kpVgF0g9Bk1oj1YxX5n5-KI92AYhlhs7V6g>
    <xmx:TDzWasf4QkPNubBlQgrobPTuLwGYevPvVymd_nKbfx0w0xeNw8_t-Q>
    <xmx:TDzWalb8VXuZsly1wZFHr7B_OCOMH-ACacB-wGS81awYqeXdWE6YfBfS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:35 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 12/18] mm/filemap: don't defer the free of folios of an inode being evicted
Date: Mon, 19 Oct 2026 16:49:05 +0100
Message-ID: <20261019154913.1765974-13-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0924D40005
X-Stat-Signature: rgd9kk5foidf5f77486if5yq95gngzwy
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792425043-532347
X-HE-Meta: U2FsdGVkX1/LuvBeZb56OKx7XWQ2dMtzQMSHlD8f+gV6XIb93BSzF8hkiazmEOa0Fra010wAmyf4DUaK/E2RoyvAlx3xPnD58i3H6GEBseGFgbMPqd1EahNyzC6y7msmc+mLIMGoVNSzixsNTnXNTgdBliOWgPtxUb2AnJqGwixE4Dm8pEVnNxrTNeb00f/ItxsGVCwYTAh4lW6nFMOg40YcdTSt4247gi8xPt8EvCXR7Purn30YkyzDGbcJOb9BvTIZG48lTWFAIul8/N6/elYxYA0hNDc4bMeFv5zF8sPwgPKOXQUxyDZRomLK3GA8ruZc5ufp7+8VYXtdQFDabXAoDKiCX3lmoiMP4VBZJncAX/YUmmpQCejvsn97AAy+GVIB4B65I2VCKV1yGxOk71ufkXhvxzy2FXGPH6t64287PDAYddbfq9j+hX7dpFiF+e2tstR3LNe/hS6UQoIEYADbD/6qmqa/EiIg1qG6sH964KWGN5db2KqFzP2Ycn6hbB15yGToEOivg0MWoAVdeF4FMKDXAOh/Q7wLAFuvl5wLLf6B7pUnkDaz+k2t9XSN1TN3+wfV69Zk4IIofY8fFV1jFYmF5LaWglyVXjjZbBRoeIodCH7FUGkuK+PKYbnsycTrEn51K2S2dEPZW7jiGgs1YT5j2UhoIycb6jxwN3PJIGeneldSd5BqHMSCnWg4AqrAqxwV5swTbKetPxLK2WVaMrsPQkvWB68m1d78qsld4X3cYmKzYnstFmewQiuRwk9gyVJNS+4+KVsO2hu5UTXdRV77Eeblat/glHubyiUwd+oRbpIpio7Usw9t422joEAcNK//wG1r/VPN6HIvuVJb8Ii0YjbhzlrWPwA/XDLaSt1ZIDoLGRcNj4GumYyt86en8DiUjHICUt3EAbvG3/vwZAlh3oAv9rglUBVrAIZkAoyVDhvK91ieAKADy1Wt5cqVFs9SfMJWwkfZ70V
 FbLbsUO9
 KwnFR9ietcSFQeN5vJdFMDjsSqZCCZj/GaZ6ab8/GtXFqmfaCzuoH5+6qvwtprtkFn5fi4u1mscp66rxCQs2N/kOPXvo8eLcLQ7CCMzHSKwS1rvpxIp8iWI3Wgs+LLX7s9UgTfRASBtLyWlSfgJE0lPbXZnfD7+Mt+GNy5u+0Gdvz7cSWtx3MIb/fglOX0mETy+bp92IDJbIS1BQHGPuO+0GyVsHDwij2zDIRdkk5B06DP0oNF8mW/IqBYzmxk0U5oOW2nuiMVcXL7tKHXbTwZ779ed7frvbLp6+fCVFg4APcLYATTKcpl37JKX1yzVE9P5VUgvo4DDO/JHsMQbveI0694SB7Cy7h8HVjfleG5q3L0I3WrO67z2Qy/mBeKqnPbqYl1AJXUyLglD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A hot folio keeps PG_rcu_free until it is freed.  Deleting a file that
was read a lot, or evicting its inode under memory pressure or at
umount, then defers the free of all of its hot folios.

No lockless reader can be in the page cache of an inode being evicted:
the read holds the file open, and the open file holds the inode.  Clear
the flag when the final truncate removes the folio, which
mapping_exiting() tells apart.  A truncate of a file that may still be
open keeps the deferral.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/page-flags.h | 5 ++++-
 mm/filemap.c               | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a1e52a1f8a52..4916b5713a74 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -608,17 +608,20 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
 /*
  * A lockless lookup that sees PG_rcu_free and then still finds the folio
  * where it looked may read it until rcu_read_unlock().  Set under a
- * reference, cleared only by the free.  Not for hugetlb or
+ * reference.  Cleared by the free, or when the folio's inode is evicted:
+ * no lockless lookup can reach it then.  Not for hugetlb or
  * free_pages_nolock().
  */
 #ifdef CONFIG_PAGE_RCU_FREE
 FOLIO_TEST_FLAG(rcu_free, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_SET_FLAG(rcu_free, FOLIO_HEAD_PAGE)
+	FOLIO_CLEAR_FLAG(rcu_free, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(rcu_free, FOLIO_HEAD_PAGE)
 #define __PG_RCU_FREE (1UL << PG_rcu_free)
 #else
 FOLIO_TEST_FLAG_FALSE(rcu_free)
 	FOLIO_TEST_SET_FLAG_FALSE(rcu_free)
+	FOLIO_CLEAR_FLAG_NOOP(rcu_free)
 	__FOLIO_CLEAR_FLAG_NOOP(rcu_free)
 #define __PG_RCU_FREE 0
 #endif
diff --git a/mm/filemap.c b/mm/filemap.c
index b732ecaa78a9..53ec92279977 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -138,6 +138,9 @@ static void page_cache_delete(struct address_space *mapping,
 	nr = folio_nr_pages(folio);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	/* No lockless reader can be in an evicted inode */
+	if (folio_test_rcu_free(folio) && mapping_exiting(mapping))
+		folio_clear_rcu_free(folio);
 
 	xas_store(&xas, shadow);
 	xas_init_marks(&xas);
@@ -306,6 +309,9 @@ static void page_cache_delete_batch(struct address_space *mapping,
 		}
 
 		WARN_ON_ONCE(!folio_test_locked(folio));
+		/* No lockless reader can be in an evicted inode */
+		if (folio_test_rcu_free(folio) && mapping_exiting(mapping))
+			folio_clear_rcu_free(folio);
 
 		folio->mapping = NULL;
 		/* Leave folio->index set: truncation lookup relies on it */
-- 
2.54.0


