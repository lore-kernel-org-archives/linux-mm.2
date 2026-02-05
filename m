Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7EBE91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE9A6B00B4; Thu,  5 Feb 2026 04:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DC86B00B5; Thu,  5 Feb 2026 04:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4EC6B00B6; Thu,  5 Feb 2026 04:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E98846B00B4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5D96B9873
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:45 +0000 (UTC)
X-FDA: 84409815210.15.1E0DE34
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 018CA40009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLJ5ufLc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282224; a=rsa-sha256;
	cv=none;
	b=H7eA/1BfWRzWU8F27Dgh035JcxPvt4ecxzw5mNL64UHZDKgOk4aesP5wBdRrT82eVDpfPB
	86QcqbHoG9h4KP/v/IZ4Vs2wEVd9wYRux29diW23cNcd0xnuYdcyUFo7Pjd0JkTxALDKtq
	XkxSSX7lTtiI/TtRqmB2sZVzLPwiMeg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLJ5ufLc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqV/eFIkaVw38X0p3K1tJbQ+i+hlw2eit08Kykms+G0=;
	b=lZ7T7igIvOTLOJCHs7OgMR1d4OB/2cOF+hhNHBMpg1YuJOVIEjTZtCHij+TBd1fe0vq0su
	n4+bE2NB6PC55mmfg2TflA3unFLCGaL58u/4WV0/cnAEI3T0a4j+P4QdDqPHAYZKhFDuBZ
	gcheI/MBO35xobT49/eDC8EIiZMXkDg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqV/eFIkaVw38X0p3K1tJbQ+i+hlw2eit08Kykms+G0=;
	b=oLJ5ufLcBmOC0W58tNfEk/SWtVxBvwf6YpmAA7MPKXSHoBsl/kJzc8x8aS/Xl7vbcpvF27
	V9uxjFkFhqyVBhAoKOkPfotQ8ZKgneDa+F8pOwkpXmFP7uBeBYTIIJZwEqDY4GtTCCMBJ5
	iLof/J7EcVNubqPGy15OzHdDN1ELBns=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 18/31] mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Thu,  5 Feb 2026 17:01:37 +0800
Message-ID: <2dbc70b6cb57d32ae5c888b5623329aecec8414c.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 018CA40009
X-Stat-Signature: kq6s9efxotunqjawed135d71e9te11at
X-HE-Tag: 1770282223-35167
X-HE-Meta: U2FsdGVkX195QSX/ATW+CjdDz+pSFFlzSQBTjdWl5VIQ2Hq4+2ZMcHp4LFE55hj1yHQA+RYql0NZHPCEwo9HJUi/xfjNeTfbG/5A5Rtzu2sQf/dgT+XsmqOIjTr1/IXavySbJk8TY9xp0WJHrS1FFej2VI7o7+gheRmuU7QGEvSAEYjPw7sxOT0w412gOpCtE3c8hxerntImJ3niI3ugZb5ZReFm1BCzcQ4K0CVL7OT0MUtJGGyMwxmmvdv4T1LFnh2/70d/UaQCqDzl2jxSyXkAGZC5UafQG3uB0pgDm9rwOj70fiAN6Lg5YXJsCiFEvmNFZCCqtb/Ns57K5F4DRvEW2pPHeexg5IW6qjVC9nbJvvz8uSAt3ZZVHcuUt3Zu1qT2swQxo8On5uvit+y7Ey/u58Uy8ado1nsO1/Hpql99xunzLyvBWS8TciQyADEb0MfI7u4an3QNcZFjIjkzoKWEVTocaQ4yoeDrxsFBHZR8eoV9p/wbIjkDZ9oFyNWLGdaCpxIUygqcAA2oVhuFRvtEeix+U5nBZSr6yzkeln35KOtIGK/LLUxFlvcH6e19FP5yYvKC4iRnE24qKrL8LESpbehIHF5ybQH0bYYrVcHwT1KuFBTeml5OzD/Ztp4ihQGldN++YW7Usb9macUAGdvZ4tH4mCXdTz63gkD8ImGCEzwuQkOTn1x2Ed5VUZIdHkM7VDEwR52QlBvILBZWDsmC6fDR6OEoMlhz46nPNcgpsL90PF971NdDeSwbXn8U3OYFTebyEruRuklHh9L94iujIZcrG8neYaegTgVEyfGRroYJ/aSxvjALpxfCGaLUe3rY1V+Knmtp5R+hJ1RwKuaYdbVXG05qgMGqou8TXVb/0ssI/9Rl/eAWYnBEeamewa+7/mOqpfcVFP8k9QGKtHvbb+2YrIpE5QGUUzty6ZSe/6LRV+OCRNkxbqwFx/nxYxslu+QEB6SQH1aqBuh
 nJvxcQ4+
 ZItd8LatOq2Da7ZZb9G/L5npTIlU2VEzxYaMBxAPC1JvOGwpHZta0LfX6wX2g3lIE9hd/2F64J5HTuWOgUcQXWK5Osgc6FbZhdyp6jjZjmj9ADwde10LcOuBp5UvOmvVQcIap/xzEkLR5bXCA2ORkBouTuvch6AlaQp8eJ9fVxPZ3tb4Cdl5fZ4g65J+0ChOA2lqesJtUL8XpVOnNsxTIknF86MYSKPETxcLZCNdhTVKp0cliN+AozxeqIWMeY5Fv0z8l1283DXOjG5zieChBG65pgxDvqn5jOA7qJ6yBk4lwbusnFoFXE6Y/Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in zswap_compress().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3d2d59ac3f9c2..a9319ecd92b4b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -893,11 +893,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
+			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
+		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
-- 
2.20.1


