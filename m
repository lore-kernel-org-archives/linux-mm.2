Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22055606A334
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AQEJ1Oz9
Received: by kanga.kvack.org (Postfix)
	id 119266B05B4; Wed, 28 Oct 2026 07:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA016B05BC; Wed, 28 Oct 2026 07:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA166B05BD; Wed, 28 Oct 2026 07:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6F9A6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:36:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABB2D160BFA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:36:32 +0000 (UTC)
X-FDA: 85371832224.12.78C4D4B
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7ED2C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:36:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQEJ1Oz9;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KJQ5MFQyAoYK4/IEHk3nRAEzowJdeSnGgVSxIBuPHzk=;
	b=A0rgEUkruVgPuMVTie6tupQYcOH60p4NoEexa5ctfxhxmYcv9+W6HqkhVpaAO01nmZH//g
	Lr8gdgfIzQOM4mv4YjXc13UeEMMF8L6Y1WR871pGMBT3fRSfHQ15z6gh0zPav8gJIwluz8
	7b9IH9p7Mpgyy45xrp386FVovFeEtp8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQEJ1Oz9;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187391;
	b=zttEMaR3VUFWNXm+fPVVpqcGRGpSeV8j0JfCTIeU7Gz8hLN/OC0wWtFIs/dCyqPh6+/ZRJ
	L1RTiv7W8KuQMA1umc0+JeTGfNHM949NpJFfgSZHaBIkCDpN++fWZ5v8LZvdKb3BUzWs6i
	9go0ar7BhXID4qi+ErW5CpVbzaLEaZA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kMCNGJJYpGz5x7c10ToMLdnciTX84LaiipX1h2aokB0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187389; v=1; x=1793792189;
 b=AQEJ1Oz9qonlO9wnD+shAr0CZf+DRW2FBdnkeZQ/L6EDrrClmEze0FZ/gxAIb9L8FmrWN6mL
 +0fF1JPkhKLSYWtq2Nbpmjw+mP+wG3RQ1obOsne+2356nFX6wJTXaNF59siH1W1JuCKzjzkFUwn
 qle2y5Ay+dE2nlebMb82tqu0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0fbe3d682f9be5a6;
	Wed, 28 Oct 2026 11:36:29 +0000
X-Mizu-Trace-ID: 0fbe3d682f9be5a6
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/zswap: fix double decrement of the LRU node count on writeback
Date: Wed, 28 Oct 2026 19:36:19 +0800
Message-ID: <20261028113619.38752-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7ED2C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qhexsdyn499f7ghgq6stdmf7cd9y9r7t
X-HE-Tag: 1793187390-675929
X-HE-Meta: U2FsdGVkX19lsOVbLPIBtbfjS4t+ENUiMhkR42HQdWeA6snPMlx9xaOM3qqqV9y9RZystQVGyRmk3JVcMm8KFrTxiybuJLF1XDD5EvCjEJOCjZN4YdKSSXBStvAVJJHcn1zqJRtAexCcOLXW2VW097BLGWXtU+vNyRtaoudVlvlBSRbB0hRGA/2LOIOXBby7nu4HdUvPWIQeuLAbzwuGAkAZXv+GWgfindbG075F159WEY/QuE06/rZ26lupXyPtLgMisSH6Km4SIfzqVT/10Seia39OoA1Dp1DBumS+fXPmAcIuwQke43GGazkNJlNfR9Jc8S3DcGOFqo9WVP+JAxJkc6RP4hPqvS/oRVHDmnejSa6lsLpe3ssIhg4BbuioEyNIUlgD+Mx5utbc3+tEPjLMQz+q/sWm4tb1g/laXqg9Lct+qGWUNlRR9X9pQt+0OuyOIJQ0SLJejzOTG8X9tYacULbnhTEFMX8G/o6+V10pjKPQ4VTsyCY1mJfMuRG6Qsiw4nMv3TUyK+uR5DDRoZ8woEyIIjQuwbTniv8fTjkqEHWYZuDxmFgANxkv4qjr0RMMtHRhrbdn1YmHMLHo/bnp41XzMOb3YXNqREifc5rsmk5tgEpzJ/s+Fo6UeVEhQJlE45ifYPxOyODSfBvNGzna/0NDIRbrn2tS7LT6gkbTu1n8YsgmzEOS27nZvAIe9iwWOlVh/MsFrqNawkEFazKtcEQv++3vMlelJoZ6JaL4WXCC7LlwPtiix7prMNr0aCfCX12urwGsFBEpkTZ2YMRxclSptn8gOz8SPu7HCTIkYDk4EGUS57vPWk57Wc8QE8snEH7SspshbAJIsTdqkfJtvJqAgZ6P//cm3un4NCRMSGBv8pYbo/jToASWkneX9OBOZZyD+nuVzGs2UEoFz+e9Z9MxKgXmGFXLJbgyH6njDmyS+YeQ8y+9vUhcPHknr9y3/fDSKt8D4Xl8HSj
 pSqbQBXx
 ykS2Dn6Tflk4mQaoYA4lPLrMIseGLghlp2P0PDryNEHo63RHaCCTl7DahfFTGIgFvEtCFdLSIAMJCTx5i8jq66a7VLHNZhmjnJEntR+q+Y+s3ymJOYmueFgeiElTkdLEiCxFZhfPRMv9QyRBvEea5UToLfg+x7a29DdQ3dodjjGANEUVsTE2VHT+zmXcxZdhKFVznwPc2VprLw24m0K3wGRptfKRRtUfy2SSGV71d/fsADY3OZ5D6/Ehch5UxbF1RFFzsvhOsJEhC1bpgj56kbNN7iii4U6vFTkG4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Successful writeback calls zswap_entry_free(), which removes the entry
from the LRU and decrements both the sublist and node item counts.
shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
to decrement the node count again.

The affected call path before this change is:

  __list_lru_walk_one()
    shrink_memcg_cb()
      zswap_writeback_entry()
        zswap_entry_free()
          zswap_lru_del()
            list_lru_del()
              __list_lru_del()
                atomic_long_dec()  /* first node count decrement */
      return LRU_REMOVED_RETRY
    atomic_long_dec()              /* second node count decrement */

Add zswap_lru_del_nocnt() to remove the entry and update only the sublist
count, leaving node accounting to the walker. Split data cleanup into
__zswap_entry_free() so writeback can free the entry without performing
another LRU deletion. Other free paths retain their existing accounting.

Fixes: 5878303c5353 ("mm/zswap: fix race between lru writeback and swapoff")
Link: https://sashiko.dev/#/bug/linux-68d2ca49-23be-4504-9a75-b8526ec92388
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/zswap.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..d0c98daddf2e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -719,6 +719,22 @@ static void zswap_lru_del(struct zswap_entry *entry)
 	rcu_read_unlock();
 }
 
+/* Like zswap_lru_del(), but does not decrement the node item count. */
+static void zswap_lru_del_nocnt(struct zswap_entry *entry)
+{
+	int nid = entry_to_nid(entry);
+	struct mem_cgroup *memcg;
+	struct list_lru_one *l;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(entry->objcg);
+	l = list_lru_lock(&zswap_list_lru, nid, &memcg);
+	if (!list_empty(&entry->lru))
+		list_lru_isolate(l, &entry->lru);
+	list_lru_unlock(l);
+	rcu_read_unlock();
+}
+
 void zswap_lruvec_state_init(struct lruvec *lruvec)
 {
 	atomic_long_set(&lruvec->zswap_lruvec_state.nr_disk_swapins, 0);
@@ -781,11 +797,10 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_entry_free(struct zswap_entry *entry)
+static void __zswap_entry_free(struct zswap_entry *entry)
 {
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
-	zswap_lru_del(entry);
 	if (!WARN_ON_ONCE(!pool)) {
 		zs_free(pool->zs_pool, entry->handle);
 		zswap_pool_put(pool);
@@ -800,6 +815,12 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	atomic_long_dec(&zswap_stored_pages);
 }
 
+static void zswap_entry_free(struct zswap_entry *entry)
+{
+	zswap_lru_del(entry);
+	__zswap_entry_free(entry);
+}
+
 /*********************************
 * compressed storage functions
 **********************************/
@@ -1119,7 +1140,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
-	zswap_entry_free(entry);
+	zswap_lru_del_nocnt(entry);
+	__zswap_entry_free(entry);
 
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
-- 
2.53.0


