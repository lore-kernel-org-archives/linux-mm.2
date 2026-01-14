Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A19D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C096B00B9; Wed, 14 Jan 2026 06:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239D26B00BB; Wed, 14 Jan 2026 06:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1181E6B00BC; Wed, 14 Jan 2026 06:35:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F25556B00B9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FEDB16048E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:29 +0000 (UTC)
X-FDA: 84330363978.05.4FCBCAF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id E3E66100003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GkQroMKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390528; a=rsa-sha256;
	cv=none;
	b=weClWpG2Yz8mV9S4C8+7V3HgksCBpVXFHwQOaT3yCSi36MrCvI7aJxslC7UGyc7DNVUV8Y
	/Y/5s2ajv4JJZA0SfJaQJEza07+9ZtrrOyt/OzZALwtROZt5gqlP+FuvuhSmWSfWMkFhLa
	qJHyovffcpKcAf/cF/BRV4UTY/dYC9U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GkQroMKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z51xqOUPrAhoh0O0GpdBH64DgayE69nJ4AY48cemOmg=;
	b=sWTY71V259V3/uc9LGjXXRdZ5/O93AXckwhjYsKlIdjdHKeGsFZzMwqH76ZB8xsCrPAW7o
	vVlH0slcjtwC3QXBGO0twuci7sOPU+0b3AGZOkZBHxH5SLYDYnGzHb2nAr1OJp7qCTT4ag
	ElIUJXIQKJKbhlBVWrTEJq7YmRcCrcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z51xqOUPrAhoh0O0GpdBH64DgayE69nJ4AY48cemOmg=;
	b=GkQroMKgudviGh4+T3T5BnePjIc1sCeCfGOszqh4Cpf/7jz08mH0bGrBlPoQrr20CERWHc
	S1ty/PC/trZydeZrWsSp+zOKUJ65SUr5t1kUkrueBtRe+npVCrQ5t5mroPuMDsbzUyq1TH
	FuVn0xlRBuYmhx2Pkoecm8EYYvDz7b0=
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
Subject: [PATCH v3 22/30] mm: workingset: prevent lruvec release in workingset_activation()
Date: Wed, 14 Jan 2026 19:32:49 +0800
Message-ID: <a610afe2213e83d2e50eac584fe38fed453307f8.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: r6ogpier1jtdcze5ydxgafm7ybb1pmhx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3E66100003
X-HE-Tag: 1768390527-450241
X-HE-Meta: U2FsdGVkX1+mfomaAYw/EireJgU0sDFv5OJHugkSYtvi9gOh3ZFeaRjHQ6xFAkqKlmboE5js1DkT0rOQScZ2GDnP5dqz47uETzTXkKzgLtVCbNvky6DS0aj94FQVdXQ/WTZvwhA1799YwDVnx9+qvoiZO7CWLqLY+f0bMZRAAa6Kv+roMoJW/mV2dVJKU3W3698M32+lfoi1XspHE2dwCqQZocY54t01abDh7xSGqlP7I9EfZKAGjKlEQ44bmpZ9hQ6p7YzruEevqvvKHrnM1Gzq9DW23UmvOFdKWxhP3SG+mwfWHdvZSfJ/2OUQxiMpatg9Aqg8k4VpNhZ8JvdN7ceIOz+qZjXOrxGbGwEdGiFW2b4eZ5P+fijefuGAA2iLVE/E9hFRF/a/cm6GjC03+La4ETFD+LC6BXs0RYHgNkkkLXl5Nt8os0StqBR83TUrnYUx647p0EG+g4v/dJioJukkRkpgv5GcbSgtL+uHt8WvzwiFlt0T89AlII57PFveJhlf7izDeOsq0+LMGUr4pvUdkl/hKwanrB0ghI0c8HxrhuB+LJrtG01i8BYKXRWTCxj9peXBnz5AuJ/woIn4B4nDkHZ1ez1qS00FNUAbK4PchjDamw4u1JAotktQBJee18DjfOrNaISmPd5bUGA5I6Lc6F2qljwb6MOP2rq5HNgwiHrynf4GcZinEuoTQmYKQz/vpVKIpVFQd79APPzMtTHVIEbKOAYlBZlsiJfFyViNB2kEjVcHrWGyoetrkGbAWQZ20DcjP89vX7x58+7D1uGwL0LUA3cxQS4nM19zyqDsGdlGMWhUMFioQProqASVARg6L67Ae/qxNtlSyY9lW/SHT6sRVZOfwhBBmVZTaNlDKnRNazcboPS30s0stn0UBWWm9gQVxIFJAXLAtugm7aM0fcGT8mmFRR2GvgQERW6ZGWfC5UxQDN/THIKXiWK1FxZL0nP+gSVx/sH5Tpo
 CO8PVJwu
 Saq66QVYzzAyPhBOFXJzTntWWYLixPWF/2E+9VFJZ13EndtCt45iG8Rto5pBRj75Hn1hSOB1NeynkXio3WsMCMTI6Mib9MaZWm/st+JoDQ8kQxFNhQDO87YEv5JjySbJ9ylP4/rjUvdfK/+AbHGwZxrV9qqujmbzgwD0ISL5I/6lW01C8fW+CeTYtxutduCAU64Pfqx7NGwkXpAegU4aOgTI8/2UdNxKmiZQ9eCHw6DDVfNxXddf/AZ16GQVV312P802azQXl5XEiFRVWCTL/xmTjq+YCCzyJ7S8Mkt5BXsOVrDXuTUVy9CBavj3Azq7P/Fkq
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
against the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 5fbf316fb0e71..2be53098f6282 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -596,8 +596,11 @@ void workingset_activation(struct folio *folio)
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
-- 
2.20.1


