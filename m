Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11725D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7834F6B00AF; Wed, 14 Jan 2026 06:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737696B00B1; Wed, 14 Jan 2026 06:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6646F6B00B2; Wed, 14 Jan 2026 06:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51DD66B00AF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D841B13B15A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:54 +0000 (UTC)
X-FDA: 84330362508.23.610CE4B
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 180A5100008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LvLhdk0U;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWUbb2PaVbUJH475DQjZe6rbHPDEA+XsOVjT/pIzyrg=;
	b=ccRQapSy0jjyw5zv4QWAQZeFTk/LjD10fx+4Zhcf56HNREtOvbHE12qDJFjLDDTgAP5O0Q
	xPqs1h1FGqa74bWqc3XjSR02eVIIBZMI1opVi1hKlArwCZqoPqKzp76xiMQ8Y9lx6Kp9sk
	dS4TPhneYbSv2H2eogrCPQ0IwJ4glpA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LvLhdk0U;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390493; a=rsa-sha256;
	cv=none;
	b=zajv38rOkZ0Y2LY9PXarYBQUreeqzhu7wNnBEG8LLdrB9FBtWdcJDbo1glfF0bEagyS4hW
	fnp7LgVgSWv+X/pFgx0JlTB54INxV0KyM5QiNBTj5XaogUqOMuu2cT8WWTA4GkSH6hI5fw
	nLaGXucI0sXtYhiZEe6gsVAoseIuDzk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWUbb2PaVbUJH475DQjZe6rbHPDEA+XsOVjT/pIzyrg=;
	b=LvLhdk0UApVUyxUSypnJIgJrYQ6X2IGJW+uU7OMEp1p35yOrmvZWgmAHbYfFk6DzD46EDz
	cwzGgQ1xZPkamMR256J5q//zc+X0r39cFT/v1cwDkcMkoOdyE6G1hFz6bLP0YLOayOkXaW
	omE7DlXRwzBCLg/I/OP5LO3r8Um5ONg=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Wed, 14 Jan 2026 19:32:45 +0800
Message-ID: <592f65bbe05587c01a2718443a70e639cc611f3d.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 180A5100008
X-Stat-Signature: dazys971c8kr1imb77d1czpxndxbq5ye
X-HE-Tag: 1768390492-943014
X-HE-Meta: U2FsdGVkX1+oA9gRNSPKf5aYvVCG7L6zqGBd6/9Cc06Hmpxh/69DqE4TKAOKWiXSjQbCfPRGk/XL+hMEr+yI18VT6NEW25sZ75G7aiwpQKT87loxOfYe7z56ocxZRi5kG0GJN7uvxrmYIhFhwWLyOr1Nvb5Fmm7UcSsmCEU1HqSYAITWBpdZTcdwyESh1VvObP42Scj8BKnzru+9Q5X6R3mjUPOgqeGl+lPO7xmq/oNyzAhGqsv6jL4njQxBGD7b33FYNF5AURVihrBCYvrSkS9zHR431FpP1ExzWONZY9vluCXe2qsx9sF3z3n/5zTVfwHx5HdQzdXfP57efrPJUF0gMyUkHHxGOyNEdzKGIzpUH1qfOuU3a+MSn/ttxnKaiypmyugdw5ED+kbKHlldDx4HyJ6qjmoEN7lZKqopZY8/v8/emtEd5EGN/HPUXVqyjtuaqrtqCw6zahK0y8pS2zrQLOumugBqZ9liF2TcRrgaT/vhlXs1+Rhx/pk9YkoTwueV3uP3D9Nuv3loFsEFO47+DrgK3p+wKC61DIyCJ9OSmretoPhS1mdXgWCCJAYY0H7PoVVpFnM7t5hV69bQVY9HsKIaWQNP6pWTuztUcTkzGFOIz1FAcyTWlKhZp0nU3roeS2wzUt9qPKt03lo2HJXZr/SqwqcCwBR3GSgf5spsUldKEMNajpOppC0DZ0MsUwSGW6hvnInb5l1eL5dQNJUBQdE6PDtZoalW4F3a5v0YLL1OdLXpnJFnMOYqfjAIJB2UQFQ4ZhinN5KEyZbUA2+4rqh7jozZvDP3eWa3CfuLUO7980u+WSU58kS4xyIXBakCdYKhhc+YmAlk3TO6xPWtpz7QTZiXSouO3d5u+yxSRNFb9HOffQn3H5CS96PtUjn6kj694cl9lGQPpkL64tVP629bK09IJKc+cuUTMFf3FE5ja30E9XzwhPKspT/d9FWsQjv3k+CxLXl3BFV
 eApI4Wxd
 O3rYvS0+kwKrpSEEpynC27HNgjobxgJsX+rGY3E6Eo6MLTzNlMBGR7I8DV2xUah487qdbcSlbLNudW20ZP1eL4nWEKSOIhk1BFKZFVuYmek6FJ56keRk08O0Ml4QbjtoSMcv//IS6QjKJhzZiLFan4MLrbFZR6qzvmTxJqvZdBFroZOScqf9eC5ObjsEyHSRULDQ5qdIN4ZCHJyiFU2eR+l9fS/F/baOjh5oPG3UawxjxVbYOqU5Co7BLiwyEyltc79uJ6aBnwFiPG8R1lSkXhGCwC/9qwjj+yzFm
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
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index a3811b05ab579..cd926e1c03c92 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -892,11 +892,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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


