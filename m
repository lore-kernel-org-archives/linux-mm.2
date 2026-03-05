Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5FDF30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197DF6B00BA; Thu,  5 Mar 2026 06:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BCD6B00BB; Thu,  5 Mar 2026 06:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BDE6B00BC; Thu,  5 Mar 2026 06:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC80A6B00BA
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:57:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B69AD16076D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:51 +0000 (UTC)
X-FDA: 84511860342.26.D743439
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02F9AA0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oWqeSw21;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=ejX7l1jJ+3zZrpw/s0MgoEX0ZgSj4YJxaA4fQLy6+XQr6Ji1YZnfmSeoB32ocKMPyX2Lgh
	Vzl0UNHHSI/RyIvSW7K2aiXaiMx4FFtOw95ssVZKVCGP5pgT/6v157ZfFFsXbjtKFp8pKd
	iaI/frtGLgh7RQABU+ZfhHeum2hIqhM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711870; a=rsa-sha256;
	cv=none;
	b=YpZlnYg3c4GSQrYteU69Ck0vulsqUZwB+WWlM/LUGHpa3vXSbXnV2SegM9S48GvI9sBt5G
	B3s5026yqKqK6VzEBK7FTKSLzSVDS1IPep4olN9bQJTJRYoaNDPpQ7c2EGwLRScrrItjNx
	4osRSMPQLvg+EJirGfC/4+zNZ7AFJ2w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oWqeSw21;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=oWqeSw21EVIisf+Wj+u9dXY6H5MlWHP/u/aRWPVeg4N/9LvC8U7YDcY9wxveLdQ3v0BfUa
	E8sqMktWT4x/T8OfAXV48BSFpMOvHwZPJVZm55nALNnWmslbD3f9FJ4zhCQyiZ4svU0plW
	AxWzHDpEn9gcI+cA28kiHMl7w8XkEAU=
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
Subject: [PATCH v6 21/33] mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Thu,  5 Mar 2026 19:52:39 +0800
Message-ID: <986cd26227191a48a7c34a2a15812d361f4ebd53.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: us8jpt4n8imcyyzg996p56bdkm85hrej
X-Rspamd-Queue-Id: 02F9AA0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1772711869-781450
X-HE-Meta: U2FsdGVkX1/XSuDXHMHfKXmQmwwPaxE7s0MzpRl8vDSvt8WpFz+Duhmpw6P7YDhrRoO+YD8dE2rBTs8uO9ltCn1xjJTuYf5kW+RqM2aWqVENGoKw/T/Xe17msJqiRg7eb8C/eOL+0DnlgRxBObjsbdu4AvEtKXDjZlWlTztGOSMO2RcmsGZWRDPdSSkhaGzq2+FGQJRSpgFAfVfMr3LAIKW3eX0NMX1KG3hRbLhbxNd+oOfFPmtEtXcgWRhta7Znmw0E1nO4Nkt8tSY2MqYIgqY1n1vYehnBmz0V1QWr7jSzX8W4l4xID2VDd08HsO3jwPMec7k7dMDmXcsNYFQOK/ZdsdBLnm2iWGp/Dc6k5q/N/9Tuh9Eu3TjBEXZxgO8PRHr++p5uqYD4iKGm8rnVFxsCQJC3WDmgItvRllBOYgZ9mqMBicZugwZLlFrcJKTvoV5rUT+oHVdrQkyfSongyr5xCWwNmCoOCCk7eZzU6dYs+mVLRD/KPo6LanyQjTyGrkIkyi41HlGjGLN9r4yrKN192mI+Ec8bK7gRKRSLfzniqqT1v0pMox0Pq6qE/sUold1m+Nmj36JkuxyQ9XKqgYDZVhLWdR7LxtcqARSo2s6OzTi8TlrCY2Ed2CpK9VunsZ2kP2NwuZFCAvcYrKBZHVU8tjkOIvck+Jp6Pe/zaN9IqWcKJyYAHFalqAzptv7Wv0ji/4k5icUKH/qsJMu/SxnfErK5C/o2QiO0rJM+T8UUfnNTClhxiQ0gNV2OSJLYrCqQ33JfN2uJn/O7/Zou+GlOVTAx4qyv39EK8ZaPAjHflrEulNhAgh2bSY8N8UcpN+UL6l1Ke7aU6nSBzMf/oeWpBdIBzTPE9NOIctVkaN59yzYjjADO5FZk8c8QqkjFKTJ//uM7Kr8PjNg9WzeaGukoRxBTDZ0oJcZ3u7uBgKnFd3pfFJP0XFFqj1eUIemtgQxs1TjpciSlfN4RRmj
 jLTmsG2n
 Lmsj0a+RkuQNvT23Q5ydOCDuUJJO5RzWdeNMQqhYmHfc+QvJEaN+Vs/m2coEpBudVj9sK7kf8fzHPPoPcrt80kMJvofEt8xHDurQkoxJvWeZ3Uk0LQf7Lu1ooU0LdGndNt5jfuFcySXKJQH9lq6YX5Yi4jNLz/Ctjc1we85BuUIKJDB0SYbQh6KyP31oyrNTwCsEB4st77a4zd2i4x9p9voyVsZLGbBnfa9LeVYAINthfk9ILbdE4mkNVYMwT+Q8UTLCp4Q1Ezx1BSsI/z74MiwUQs0GGNWU32KKupKEJFs8Pz29UgbsakG2s6TtPRWY+zvP9
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
against the release of the lruvec in lru_gen_clear_refs().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 245ba159e01d7..cb1148a92d8ec 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct folio *folio)
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
-- 
2.20.1


