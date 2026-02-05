Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B780DE91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242E66B00B5; Thu,  5 Feb 2026 04:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D95C6B00B7; Thu,  5 Feb 2026 04:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D90F6B00B8; Thu,  5 Feb 2026 04:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1A7E6B00B5
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B81B214043B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:53 +0000 (UTC)
X-FDA: 84409815546.14.71B41C1
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id E38D018000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KVfh9JeK;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRi+VmXiW8HlsHjnS6VBfEapdpTlECLdprrexkoF+xY=;
	b=4NYX6Izhtk21is2XyGQodfu/TtrLJkZ848Lzgq5rCByLGYbeeY9TTJKJLtV2teQRKaNsWJ
	nbpfIrfHUBydQ7dEGrnqTPMWVl7GBkQ3jVT53wy5MdJt4j/iScr4ae3JiooTTNfpuW+Jmf
	GNkkhFAiULnDmQSdUPgTtCrHLrB23Dg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KVfh9JeK;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282232; a=rsa-sha256;
	cv=none;
	b=U8RSn0qRp2ZVbVvRP9R4h5o6P3TplpfIs4uEkZ/pMBAHQ8elzdzm8aEmfDObl/3FAYVRAG
	rLyFqt2aFy7a/zXxe1HKCM0hq5+CHNvcOGm9qdD4HVxio94YqIWZQc4t+QtyPQwtzbjxTe
	fxlFZicdyQS8qgCwaAY7TaG+tfvnnDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JRi+VmXiW8HlsHjnS6VBfEapdpTlECLdprrexkoF+xY=;
	b=KVfh9JeKpVTMnjxhHqZOl5kWuMUmCKOj23QCvuPn7hKW652FwNQuQF6mDdpkeV27rgECqr
	ynr8o4Zuwu9IPgsC5o/cHoZT05/tLITASawjRLQR1CHWrNimtaU9i0/mY5LECvobbPE0o7
	bP7KqOjQmgjiuffVgrpXepU4iPO8vxs=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 19/31] mm: workingset: prevent lruvec release in workingset_refault()
Date: Thu,  5 Feb 2026 17:01:38 +0800
Message-ID: <20da5d43b253f4810c939aad5ebac0141438271a.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E38D018000D
X-Rspamd-Server: rspam07
X-Stat-Signature: pckupg3qjgsapxyex4o6rc76cn5oi6rc
X-HE-Tag: 1770282231-675695
X-HE-Meta: U2FsdGVkX1995awAC1fK1VkIlyGEL8sq6xOfWSBtvbB8Nv/Sq42bQt0aFo+Ohvs2Z+JakN5TBEYKM+rImiPFoIYBoEqF+N7f1wz7HQBPD3Q1XoBiUxI1mchjjYKHN6ilBUuwPlLd5UBlISZRTqLJxIC2RU+QF0/NuWI7kW6GB/TLfJwfLZOVa0JTKB2oIScU9Sa2aXFh/Scq6JOOCSwYSH45UKt2N92UzWGNhMwuvJUUgVebsGcL1WoOIKFiS1ZJ4QqZ2hG0lJl8hQHQAauvL6GR5iF2JsZES+2F0vcacUz6z+1oG1sB6NLfPusKTyo1jGBNuarYN9Gy+QXwVz6dt6qynIphmNrlYCJR4LRlupAB4XlfUqN7dXm9i7SUTbtJmZGd1j1+SNl8FBTwBBAUxLlEk5kzAcTMCsu67QMdJODx7KqI5RxAcuyikO8r1fD2GYY4uUXGm3Bi9ZumBxnE75waFQEyCYTL650KoY9DlwvNSTBPyZrVvz8286JVcb4UeoewSALURLDW66iJsI/x6QK2k4rM8vRGwJxMmeXvrpynZQD07TtPPPCo8MAFpDW3R4JM0YFUcZxV8UtDRWyuMYZtwglB2MOOXFMe9CZeM3jw49g8xJlKQNAmMgbNZjasLryVtM9FQvucDIEvCT6UHCAe2pHPEyxolC/zIFkg+vP8ewRIsMyZIIV0sxRyBR5eOUlvOU0ayaHC+bl93XMOqZ8lj8hKwuYD+YmYfQZzVakQoyaO6VsxBr1wzrrNjjYNsXNOD1SB4yHULX4/dJqjOpVJnasfNcDnxBmrR/voavURK9OkULFcl/yK7IJvgfvuXSZPXU/HkYOxyw9ViAApYG0AbkDqBUdIB6fKx1Le5uZ3tWlzIaIBHdGZggQvJTtXWzhbMB/b5pTlKnIY+H+UlhEpumvOdJTEYp5wZV7HteNfRQCFX9EIDog3A9jPOGWzZN0VDix4kG4BwubA5QS
 QlRC5ESY
 KkB0vTMzk3xAPHGPjTGxMRjmRhfQtPf7+Nx4koS73BtDSCKHALWogGBe5h+DonnpLgrqU9OG3lTRdMZeiw1I+xg4h4sWyCXS2lndlMblCl8PeLJkkfizOM6sXfwBMehVeGelzXTWJoFkmdxwg/hoPGjXM7gQnQAKHs9gvERgvjHJ6jgmxLJ9nFpdSNNggVA8eJuaJEENJKOAJOWfMeD731PbSpZb8F3v/JdMxyX7gsScaOg2gsiwYH0VHC0cyi4m/iQ2i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 79b40f058cd48..5fbf316fb0e71 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -539,6 +539,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -560,11 +561,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	lruvec = folio_lruvec(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -580,6 +582,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	mem_cgroup_put(memcg);
 }
 
 /**
-- 
2.20.1


