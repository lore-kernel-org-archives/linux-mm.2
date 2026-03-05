Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F567F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5EB6B00D0; Thu,  5 Mar 2026 07:00:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C849F6B00D2; Thu,  5 Mar 2026 07:00:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AE56B00D3; Thu,  5 Mar 2026 07:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A67A86B00D0
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:00:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 544A55B1D1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:00:06 +0000 (UTC)
X-FDA: 84511866012.21.0C7BB25
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89E5D20013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:00:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULgx3CO2;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772712004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME0/F5y30Uv1s+QbxgHUtCa7ObeVmIsWm7RG/5Co0FY=;
	b=Ez8pBh0PBAond8bnqOp8gQ6R8rAfaRFTzifXPHX2xvNOIyiYVgpK0+1zdV6+D5BOneTkSV
	8kjZ3FN0+1Z6ylbF8u8IqAE2PkjNg5wuEUx69WnlL/LTESOgl+qHJLUggG0UrAw2T/Lq2R
	6SrMVCjDgmd/sq0xBCH2W4FYdhG80+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULgx3CO2;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772712004; a=rsa-sha256;
	cv=none;
	b=EDkfpVNhDR3jZ+BeRPUB5oCDAjCEoeObQM8IrmOolBsaWjtil7YYQ7tE3EI7vgSQs0Y4EH
	26kCOdMvKINptUw1b297or7gEARH6WN4gBN7/F96LLP/wI+4wKviTQgKCnJFMougivfvPU
	1iK8EGRSQffByFwxdxg9bbEtRK1ae4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772712001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ME0/F5y30Uv1s+QbxgHUtCa7ObeVmIsWm7RG/5Co0FY=;
	b=ULgx3CO2HqA2P9ywrhLXm8b1vwiy/kInSpCXg3uJ+8iCynQKk54mAUKR9fYwxk8bU0lEzd
	4GHK8veV3AqtbXGyEWzW4/c86ienIwVtSTyWnY5zODh2lVJf13R2dG+oU06J7xNhi9Epx/
	PZGWtvUyHzmkZptXFjRRD3J4kQz1/Hs=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 33/33] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Thu,  5 Mar 2026 19:52:51 +0800
Message-ID: <2c90fc006d9d730331a3caeef96f7e5dabe2036d.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 89E5D20013
X-Rspamd-Server: rspam08
X-Stat-Signature: bc4ozssbm6kae3fzzfrk113d3unqk7oj
X-HE-Tag: 1772712004-761657
X-HE-Meta: U2FsdGVkX18Z60AgFiO4cKvAHnR4n4A0N+fxOXCoKYbnpAFeRIu1EDU+yscRcelt4g1IPI3OvVArMiiXnW8ijQX1M2hBIO+NLfZg9UccQONjFkUEt/1xVwTvXgkbK34IZ2UTVdBcCP0E8Y9NTlONFawThNUPDnzPdwbleN8b5DhpawwwwjdXkV1c69AXAegl9gFCC8ec+l4seXC7RQV+TgMwi4WfMdPhV2vGHlW9Q+NbWFkyi9pZZ1GZvy8NvNpAkW3trFLyAJgZ2gCI1vp78LdTsXgNEbPj+OGG2PEhcIicwCWzqP+dCWRrNHS3PgVVbu38qOZm+jvZx0D1jlKCr6RvrP5SNzi+OwvWFwG8QxDC6armtpgmCAqX3NtNHAB3qKm8l4aNDg77oXAArBs6u0ytHlvqn41SrMhbMtoiZw+1lAa+NWGNA/RLFm/pnm2cwZNtz94lrQO6BtL/m6uLd4t7B8cYOMIkkUNcXE8t7tAKt3OFNY2umSEHnchigQcGlP6sur5/zTjYA3GpmVRrcnAexudMR+FYPQ059mVNY/BV+Gu85JXYtDHewQy3hhUh+VQxuIAf0f+D0mSoKOfq5Nop8tUH4kWZbYja7NPX/jOGe2bbbIaLxobZFWYFLSFBmfF/wxmMbvEHc6HMnA+xTdOQn/jfLU/OaQqCjbYpYr0yYhA2S5M/n+0a62lXjQp6eKGPjA/efYMO0h8UTFfpTjRn0i1LTNGHsfOl/YRhRDeXL6irViXlz4KhwrDg2QrQGd/dpQPEcoVIITuVlCb7/86bsu4M+hmM2SY6kJuM+2nGnSxpgXGy0u7HKbuc+9Um/biDt6n4g7PI2vh4TjT91uX3nYHniOAHobfdDYtN1LP054CYPhWLICoPyDxiPoqtUKKXmW6v2S9L7OueufUmQumetAoRS35PYn4CsSEq+MOYcaKiXf6BhIOAdO3OsQPnpVCaaCSGN/Z5vPqp6LM
 n6MAN4zl
 GpEwnopJSZSgd81DS245jDzzBVCF8GDPTKSh5aCytUQDa2tFXDyRUxTU6FOaIFzItVT8NsDHhW2vptISNs5UPA5gHEhDDUEAp2ofc/zsFMieBHmFcyXFYgQNlZEpFyBYZnKBMAJgNC9jqgCo5kTFN1mH5cU0PI8s8t6fW2cbcuGYU+qtu3X3T+mBnP+xUFTg+lFEIHot2VWjvNAUekL0Gp+F7OUxi9X7zT7tZ0FreC6H4FghPDbmYwu8pTQE0utarVU8OkjJqdpuC9apK49I6b/Dk/UKssPTO0FwM7QQsolzPYprr+uMYPi5CKPDiLU2/Fsee2gtpCa8JIlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

We must ensure the folio is deleted from or added to the correct lruvec
list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b53..ad50688d89dba 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -342,6 +342,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -356,6 +358,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -370,6 +374,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f9f66e0b40e1..73bfa93696a27 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1920,7 +1920,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


