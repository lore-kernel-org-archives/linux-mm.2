Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CECD29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008FE6B00AA; Wed, 14 Jan 2026 06:34:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFECE6B00AB; Wed, 14 Jan 2026 06:34:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B8B6B00AC; Wed, 14 Jan 2026 06:34:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D17E36B00AA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8525E16046E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:32 +0000 (UTC)
X-FDA: 84330361584.09.342AAAD
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8BDCA180009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y7jeyurN;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=em4Iy6O35b1A8UR+0FO08xHRW0BrOK64xODkveylgXo=;
	b=CTJMy55khLvQDQ2O7YRe9xP5+QLX4Er1wPOlPlCSG0l6pCvHExINPkyalILBwEXJnQgg2O
	TAWvTVIdRg/p3jm2n7wOwOqE98QnumK7SeKq6XY5cxyt8Z1e2bFtkK7kqN6QfPMKwhppy6
	cmB4XqU050cbLtgYZDGdwXuZJB6KEl0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y7jeyurN;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390471; a=rsa-sha256;
	cv=none;
	b=4oWphkpm4GA9GoAGr9Vs7eRJ5NDisGq3WYzuzazVpE0vFDg4YOXA5Nh0usontS9Xtgo/J5
	LerJW/ph56ObQAVGgyUG2LtDvmNYUxQ5PB0ouTBuuvFOqAzYrkcvvsRrVloMlRcwVRjVL5
	/lReyYrXsZtHLxNR1leAmJorVrh4Xlg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=em4Iy6O35b1A8UR+0FO08xHRW0BrOK64xODkveylgXo=;
	b=Y7jeyurNAc4uvEAfTJbTgqIYsRk+83DVSW416xY5r0eDb6iv3XH27yMYQ2bGbyNYhYd72+
	PYMpbf/+shaKQ4FIyWr49L4PdVygdOGf/27V1nmPR89IlgW132TbT8c2ORTn1N6AVBlUfc
	xP0YLXfIhN8VvEXDrmrtOeYrYTwrmV0=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 15/30] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Wed, 14 Jan 2026 19:32:42 +0800
Message-ID: <3e739f195644611749093c8dd2c8dd2cea1d2485.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8BDCA180009
X-Stat-Signature: fynntbqyxc6zmij4cczneceuem4qp3kf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768390469-150136
X-HE-Meta: U2FsdGVkX19feDnRLIyGcaaOPvlh4sx99VCIz2+rhy8ZSHOHXj08JwYAh/8khRhdn6Isampu2o6YcJVqrFhvzPd2EjPWUvGRmpW1rBZKl/FC1lTarcf8vi1QDk06UKNaJ8qb7n60xdCNlTzmF0VYWtEyfl+4vU4+XnAgikKqlU4K1ZYGCVMITh5iXpThisFLITGVUNHu9jWOfZcR/D74H6R1qb93GG4nIVm9pmMGzb+EhzVK9G9aCdELeYici3vKVT62bEeG6gcs+tkz7n/sdiIepf9q3QtraIUjGMaK6JSmOdvm2Nz1pEaTMIlAybMYhtQX0vpkbKLCF6hW8Y8SB/nxu77xPYD4AghR4kag5HMVdm5i7zfCAk6RlZnQ7Kgh+mfdY10mdtGC8M3x60G9Iek1WCYZEgUBHpU360XJLx/tMvkhc9IBE7Z6S6iTr4D7q/H9dQa1P2nhb3RPyERaumXpQC6gbOU7/cIKNfVOtMAw+R6C0iGrA6NFJDQNC5Zim8W/0K9c+zNJR0zuGdwfAMN/oDdAl+iQtLp6VLGMsbnyE2pZeJhBNUMPP1HD1Ge2t2sUTFFDMa3MKwMZ9/vkDhlnroPEctYSMps+zcK6NETiAHsFKfK/Qc9BAtXjEkRQAobApfglpIu8ihkaShYpMi4jrMpv6wuAm7K/1vY2TUpZSX6ep/hBiPfKYFYgKijlButETsnyuolCjgG96NZXOGYTynySCX8Xwo9qHcFiTe6LXIVYQpXVpcJRXn5he/aQtDR8MgvNlIrwCZ+y4UOdJDqb4SCjMLqagvV/+zOIEruz0iNo9y+SOmfvPkbEg1Q0ibXU38DOERklpRJLxjMgkhKOjxipIzAufw3I4+caBkS2N0LLu0QKkhEbvEcgNiU4TC9RYT54vTiyG1w2eeByGZ09nj4YD14PNLvQbbJI1ppE1qAl/zvOA1WBKmiBx9vCM/eDeA9TjhTE20J8kTg
 NJ5wrwdM
 UIiC4CWFbBPv1EE5elGemGkoUujvSck1AvhLf9Z4KtU3Zw4GWbeYd0jSniuN9ajqLwrvav949KmqxEZLktUg+zUyc3Pf5SxNZUdzIDhufaDA4LvTB6y080oH9+G/n+i8rPtFD0NsPgG4KF+AfuQIOOr9rZAovx2tY9ILF9JljVVOXGRP6/mVA3zrdq1+ya+TyxK+aTB+6bzszhc1UECzHl4u07PijWdQSPg0XHEd7EhNBKoM9dDLDn9wi2fRRMczX7gq8xAyDsrPd3LzmQUWpsUvx8lxcD3m2eUAn5lvcbbmsPDGjLsNpG5PBDN4CdMdhR/jv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
against the release of the memory cgroup in mem_cgroup_swap_full().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b5d4139ea1aaa..548e67dbf2386 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5283,27 +5283,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (!memcg)
-		return false;
-
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			break;
+		}
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
-- 
2.20.1


