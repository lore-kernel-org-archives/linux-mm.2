Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67566E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAA76B00BB; Thu,  5 Feb 2026 04:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA63D6B00BD; Thu,  5 Feb 2026 04:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5636B00BE; Thu,  5 Feb 2026 04:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6F226B00BB
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:04:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A2EA13AF6B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:19 +0000 (UTC)
X-FDA: 84409816638.19.C6C87C2
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97FDE180008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bMMa+8pR;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z51xqOUPrAhoh0O0GpdBH64DgayE69nJ4AY48cemOmg=;
	b=WiAr3uiqjD6cDzrhMGy6HBJLsKQyk3jqsze8kL5jd8ZMIJHpNs3OLTKPw+dpBRZTUP7oFE
	0+N8OXWWxssXzmqTfWEuSUAK7AEdGDtdSRwpZxo2ZpsGDID4lX8W+afUW3r7cP3ypDAy1E
	DWZbhrLeNnvZzjI/+3xGZh9vax7Xuec=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bMMa+8pR;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282257; a=rsa-sha256;
	cv=none;
	b=1q82jtoOF41TJPg4+qefnp6U7GkPiPaa88YgvWoF2mEVgBgzZT5wceXKUz6DLh6N27TEK3
	FAXzuOC/IFGF3IxQcT39QoU/YgzRyLya/gxH9MC+Bi2HQpftSrnic0ZWdNSgC74TyhsFCk
	oonKssQNDNLfskuL6p9ttJ3G5SidjRo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z51xqOUPrAhoh0O0GpdBH64DgayE69nJ4AY48cemOmg=;
	b=bMMa+8pRpvMevU5o7P6NsU1IxXKTc+bvGFohw4xmiWOB37yVdObh8wFaj4uWDIL8ZP0Ajf
	l25CZigM/807YogavESysrH/Fa5HpUiF38wM17snFCM7yXjs1qL4CKd9xHKhMhXOz1dkqN
	aorEwUkDMctoafCw7zpiPl1aPvRpcS8=
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
Subject: [PATCH v4 22/31] mm: workingset: prevent lruvec release in workingset_activation()
Date: Thu,  5 Feb 2026 17:01:41 +0800
Message-ID: <bf23527003ac7578ca1adccda86252470f139e76.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FDE180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 4z8af3cj7u4a8zbh9ai88nh19b6f5aek
X-HE-Tag: 1770282257-778634
X-HE-Meta: U2FsdGVkX1+xvpRG7i8xn53z0U0VVbGQQG2ejd1R+r5vVIRTrv8fq9o5GPkdCTgGE58+rFyRdCxUjt2Rq2IHNmmOvQCUrRwET72HLp3EtzNunkDnzflikoJoKK8VXEBw4z51WwMdLkZv5U5iyKDeBOBmeY5jl7mJGbOjzQW50AMNSeonZKRC41jkamCChMdYp5hswcMOAmepkArLsQAbEuDveHEMZaaFTC92jpaUgRE3km3hR90vlHy7NJvD59DRPA6LS3GTHjv9LF4SjJCycbM/pm1CneW+CxfhSHkWdnzfQTTp2xbyfOmN9PmhuChlyQSJp3D37Pt0qet73Y4+BfP2WW20KGSyJpwNvVNEc6ZngyQ2T3YnEfiK/MXs1Yq8fc4FbKQeikrhf6LL+LCGL8sMeev9Cty1k8qazPJ+96p/clo2Q6QGhKJYNbkhpC1TB51aLMbwOSNSnhoBPayqchU1Gr0RyjxqC9koRvcoAqeWpG7xRCyPmnnNC0wz98ik0D65vpEZLXyfHGOus4I2wJ9/PetfIczolPAf4QIm50dHPzAHOtNIkZTXElgaAwILcIQzCKiiRg/Z5M0ssz7UCSE4aDLAjfBgQLV0JA7gRekMEAnxqEpwVLA80m8twFPegHbEJyEG3fWIFSvp48hHbAHTcpzduFnBgX/+1N2Hx0J5xc4f+hdpMoIzZlrRuGvVuMjBEubxIV/c/2AHeGtstSkkQzyvpeOaQloaZ2v0hDEUl/yCly4lgAsYocYsQ47eWAFjMGZNnPtKpjwpPOS4rSD8mWGPq97jPo2dEXV7X9oRgdGqULi/68tWggUGHU0Xx0JfYAcZF82ygFCP7b29iRKJdqGA0m12r6JH/hwD4YmAo9pVyx53y2XVzWDQusCLdsdtzZyAXmnaxQfGKeHsL7rnq4mjzlR/y3j7Gg5PERdG+22cA8sV936skofEq+MaPzwhYHaCG6cCmw1pAe1
 6bSWPG8J
 kACUnoFAQ5s8siC56ZMcLp7+COjFZBWkggsd0z5AgyhRaO2uhYFfEoyF0isjrYI1rlc5L2ASUqfYVvF6hHSc96f0I1bKPfB9CCriew5SbueYWOdzsGrbVyQRewCl3GK3FSMejf8yVlUMduXehyWCgC/VOLJNBd+TObq8JT+PjWrzDFemRYS7eqx48VG4xr9DrD4XgHmoQO8bBeExKx2JNbWw3fnR1xihmIJ2jDQjVwUSWG8Bqw+aXWMNiLvwBGINOCzXmgqITpqBy0vkOs4hhpwz44yB8IMQou+C+5BbHLfXM7BKMUQUMZ0Lw6g==
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


