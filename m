Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0717EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA866B00A3; Wed, 25 Feb 2026 02:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B196B00A4; Wed, 25 Feb 2026 02:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAD76B00A5; Wed, 25 Feb 2026 02:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2735C6B00A3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:51:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFE4D16046A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:59 +0000 (UTC)
X-FDA: 84482207838.03.4637933
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 26AB14000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSEBfFCo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005858; a=rsa-sha256;
	cv=none;
	b=BNNvKiF7N5jdMCdoeTJIuoaLysztLKVd1fVLGeTKumn9HKygmuPTOHT/IfEwUbtzBTpj5X
	tkwKKcScUB1Ef6v28LpJSE2U09AdB0HGDlydIynb/RnjLlSynitSmurA8plCiRDEu/+Dvv
	fHTVf6DTktp+FZEaA7N1ejNoeyt6L7o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSEBfFCo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/198v9MPJs+KJCrWZ0LWBhkz6feBqnUHTx73TsS3q/w=;
	b=KC9muunDdo7KZdUVJjB4BFdSDYI642do47nscVtU+7t3t/ygGPKth8Z6NwKpW7TMVWQX4V
	AA2AGdcp2BUIKT5bEcEVCiRuKkw+rJ/SRyqIeFTUKASbgyDjbXBdLaN8Ux9EAkS21jy7Aj
	SjqMnwik8O320g3zdEzH9IyMHwBFZG4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/198v9MPJs+KJCrWZ0LWBhkz6feBqnUHTx73TsS3q/w=;
	b=kSEBfFCoTY6CSo+CQsjXZoqRgLSgNwJWY78h9wNrmHKn6b/6//0bFsi9oatIQPlm7vnmuw
	WwZHqyJ2P+yL9L2FU4sopSApUmXQa5/JAYLF+u1OP9VMyfvoyy1MFfFq3fDOdFft5D3F5j
	8d2j7c0gJTd7CDPUvCebJDj4XiKh1Gs=
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
Subject: [PATCH v5 09/32] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Wed, 25 Feb 2026 15:48:42 +0800
Message-ID: <d6d48fdcf329c549373ac0a1c80fd9f38067e34e.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 26AB14000B
X-Stat-Signature: 7pyj7gie6a5nhq4i383ksuhogfe88xrh
X-HE-Tag: 1772005857-98792
X-HE-Meta: U2FsdGVkX19bos94Hd8AzWFUE+zCofPoGY8JakrvrJGNMATnW4R1Yjkig3s5AuFZ64QQ8qqmXzejuSfEubf2KtBDoiDp9w/QasLXosCK4g3K1vwhSICSWYdSCnWSIAYj5pqDknGRi+0AWCKCh6AXJtKgAVTmKec+AvFrCgMRDMnzgQFfq6uoXkFQ1Y08Lk/lM7FmuVuT4yYwjZsYSLFmP5xEOQUKgjydxqKgSIuGECmaFeUSFctBFG3dKQjHcF/b1pJiJiUN7SRmdDNIgSAyMejUJfd89+ggKT/ZtnlIJWjOf6whVjz3XVJ5QSAoJLct8kczS/Byn+jgMh8M6kU46qFPDlqC81FUUuhBzo3nYnHE8VHgOaVBFjCewf4fE22kO+tH1gaVYNFj1UwUq1OeFtZiUeY9V3l+zg0ye8cDQeaA/Ovjcs1Y/GKp5uxNKR/q89wvSdsHagiwRyTA0g73AIFPDjnBac8QFw6lZ7tuZP7+Msnp5IqFNZ6ImLXu/QKRCHTtJMTzF4uG/BnFaSfwIZO9LTv2ZhFgoadBcNU69d7ZQGItynlpXUbzsMf2R2HyfAN/7KrmKcJGgsTi29Y6AnpCTS7tJzIf9eIS7I53ex+JImjWl08TRg521WafGrj/1UAEFYJdSFeIUQWCumcOZt/UR5LBhfDgNoqta+9Sn0NKE+uMwzQA2eKdD9tgVuQF7F3okStIyo/AAEMtQejKFqrJlRYbpsWywnYuDoMyOvcPVsnSys6mWe1jz7MunzoDjTvIs772ZRNmD3ah6dkMTkAISzs9SmsjQlaKUhRMq6VJmfhJBaEERgjFBLP+utkO0flTRLFH1cdhofGoBNOMnoAwkLQQZVIKJvmxuar2l4NyNSDzoPEBVMq9mSSiCCJ59KaNZhqJTQDk3eSImA0NChK9cF7p4XFTTzXIe7Fkxe62RzvdmiPe3/HbEmff9OYuQZ1wmetCFpyxjBUOVxG
 jF7jLwXU
 udktgHeBncXbe/bujtF4OYE9VNQBEZCBkYPYvt4khs/2UFbo0BZtYyGiR2KkcFKKvxcHyGJUsoB4Yvq1hNolUlZYyOKg7IuwJeAHK0PSY9BDDWlH+YwcjeCKsHUtfWs43msAa8Y6o1dXnP4yc979jDdYvEDQOP4AIyCMIatNizL/fHo40931iiO7u+dlDhv/pHJTNHILG7fisVqGRcreArW/+az9cm8m+Lr2mGPZqKbjo9vlMvZk6M9W5BOxIOejSS+lKcBKjuMx6S1nKUFwBIoDnYAmVHFniqdMlgZ7ghBtZzLSxxYkWvgPkWOOLvHh2qa2G
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

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba574..343c97eab9e57 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -922,8 +922,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -944,6 +943,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


