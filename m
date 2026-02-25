Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08948EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5686B0099; Wed, 25 Feb 2026 02:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683706B009B; Wed, 25 Feb 2026 02:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593A76B009D; Wed, 25 Feb 2026 02:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47B416B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F32CE1C54D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:50 +0000 (UTC)
X-FDA: 84482207460.28.AA076BE
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E0BDA000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svJaI0II;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98HTAgCgFMLsilH4QRkwk8a4UTEYNMYQTWZIQBuXIPY=;
	b=zqKlQwIe/CEU5YhxXMP3izWR/dZSc156G/ZchYoa8VC3cGXJmEFtHAMcLSlJeBH5EZ9Knz
	2cNw17HrRS+ile/lKqncBIw1bpRYLdSyAL7X61w2pXIwfT5jW8pgHW1co5wQ8bro7sd5Eq
	yP7VXrpFK6BO3NcSaOfqpKKtiOrQ5uc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svJaI0II;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005849; a=rsa-sha256;
	cv=none;
	b=U7PQSTgoLVVJkzQlLQNJsXpqRNtlKa5wCf2Pq3WQavGpUbu2PuSH/v4iHZjpc7u0q2mnjl
	cjWyL/3soCFtAavb4gHFHkA90RkTIxyOau2Cj5VbkU5lT2UZ/3VFmAmrvuJVjnlbyOjvML
	fQlwK2KxC5+j1UtjzDaDTO5RB50pzU8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98HTAgCgFMLsilH4QRkwk8a4UTEYNMYQTWZIQBuXIPY=;
	b=svJaI0IIUjaH2GnFILnNu368taKYEaOfgu5AfunL14OCwFYiU2jryceYra4EP2QJbKUPwG
	6EtNuXXn+eqRf9xRdrt7ciwHo93I9lyVn1GT1fiXoALEPU8zOuaWhG7e+3PgPzhcB1cQ8Q
	rijiTZlJhn/FEXvZa/6T+ZJWhOo9YAI=
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
Subject: [PATCH v5 08/32] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Wed, 25 Feb 2026 15:48:41 +0800
Message-ID: <a5a64c6173a566bd21534606aeaaa9220cb1366d.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E0BDA000D
X-Rspamd-Server: rspam02
X-Stat-Signature: ff7bu1mtdzkwaauc79ew4xsousd4bbg8
X-HE-Tag: 1772005849-216594
X-HE-Meta: U2FsdGVkX19/pbemwtRDcpVHoTgoms5CUmLeafaBAE7kpdlSb6HYdU2/hdejmD8DkCkR8UPZE3JricmOt/mSBtxQmB91TXwxlLqU2KIdaL/CSh1Bqt9eRHVFwKpkyhcwr2EfPhbdKun44vRavSbUagkejPBx1b0tOd5jWxKCmAuHfanqFpWhx9Hn6mctW2BKSfxmHvyA2f/gQwgJR00ElO1QgdnLHgYnv+LPwYSSKZ4WNSQ8BEBfmG0sHMP+tHv5f8vvJNf5gWzp+Vu6PbiSWJ1uYu8vvZibbQ3qglseTTzZyltSJP6Nm5PLE2oOfFTZn/2qM+UgOGkEyc/yu6+Xw1Vmz2eeoRfwQw5SmcSanYQ1dwr9mwLj0i6irGHNNo4eEqXgOH9OTG3sYOH/RmGhlhhSHB3GUhZOll35FLPTbOgS+eOnWPRgRBnlpnMU/N0bSA2uuCY4epNVA7xzCIplN0B5ymB1Xvsz93IWEEcr+fvt6YNLHd+IHn5zycorn0YN3swmsLpJAp4uv4C8plmQqJpIs1bofPTMW3LC7jTVgRlInhISiSkBkpYOMk5lzfx4S03kfVgz9Her8ADstGvk6/cGCacmBFEUN2F/0nwGjGTEBcO5SdWby8dAr4bbQ/gDse2rcXya1CQ+t87gKgVrPpr7BCXyIHJV/loVw0C4jqbhpjIueEdIg6U5acWj6SWb/7i8/wn8De6lLvtEb2+MuIpeUDeKHcYMSU6aJWuhVmhJAD527WAE0XQjWRgmNkepZYxzTAD+h4hCkcg34XF4t9iUZafAjmHjE6YyD2+UdT+HF8K4FyYNadvq69g7gxaJhghlcYoF/MNuZkTw7gls+rhcogU8Z9N0iILnmdCtrTqUdhh1/x19a6pxz7aCoNXpWwX42/IJ3xn2Ib0YADYdSZz5ALtCSOKJX//EIcFAEwnkdEMKhlX/i/Hq98BKlExzW6t17pkAxHpGLM2AsUa
 VocDO5TA
 k2eSY4fPk01E938tvWZR+m9cOMN3n1Ujzb9VXxnoasEUxyugKPdvkNlJO9fOU+KLLfxAcWiUNEOHNwT2jHWuob63LeeM5GqOTl9E9eTm6Tb82dVH8RWEnC3hOaTi0BYXxgNvd+GfLUw1twpwuZJLS+EvOGvibynDr+nM/Ye7eXfO8abbxcE3FcWdP5s77tY9wHpI/fvPV49sVw5PPME54rBTC49nc/0n5v8R33iP7hLb/HW2o08l4t8r+Mq5z2GisgKT7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a60b692fb75a9..4820919c0d219 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -997,14 +997,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+	do {
+		memcg = folio_memcg(folio);
+	} while (unlikely(!css_tryget(&memcg->css)));
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.20.1


