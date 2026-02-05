Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FA9E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F196B00B1; Thu,  5 Feb 2026 04:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF956B00B4; Thu,  5 Feb 2026 04:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9E76B00B1; Thu,  5 Feb 2026 04:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC1086B00B1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C803C1C8B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:33 +0000 (UTC)
X-FDA: 84409814706.09.BE474C5
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8FA0E4000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XBGsBzEd;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/MGG1ZszDY15CWQQf1XHvW0YBRAfzPGexebmplBHBQ=;
	b=N2RL63knHQ7gsXymRxLeJJfU4FIlJzn1xWZVM2X1fGg5f7HYi6u9VHUZNrgKJmpGK4Fg33
	FP8plVTui2Z9q6vu/0v3I8wsujnkV3wZiiZUNI8ye0QtLdcV1L6cPxnI9Bn997lOexQvFa
	+iBubBJQ3VDKnH5QhTJubyT0WIW9ovw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XBGsBzEd;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282211; a=rsa-sha256;
	cv=none;
	b=ecVcY/RzTBtyJIiglyw4OxEwu/iKcvheVtlear25Sxg2nntTQbBe4zNET1DYnYh4MO00aX
	VD8MrUS7MPKSsLycy8UNjESblwalJ40QhhBabB30Qts8FvNSS+xHFmNMHZaC2sOwDUot1g
	ajRqFk2iufnntDGLHMma5WW+DglSsG8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/MGG1ZszDY15CWQQf1XHvW0YBRAfzPGexebmplBHBQ=;
	b=XBGsBzEd0UfEMySGvkKeEgj5gLXMK/+CJicc1EAfkZTyTD26W3lWjmlmr0JiCkfHf5Kjfb
	Ge9XSgIpxU5afrmc7eYxSNHA2l52P7U97Mxx5x+MOokU8LRX/hkbEQ086mpUzPqlCL8KFu
	HZrNiX90GF4i1ljcO3ZdjZ3skawPJvA=
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
Subject: [PATCH v4 17/31] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Thu,  5 Feb 2026 17:01:36 +0800
Message-ID: <c6672bc05f6876ead7f2f1cb5c5cfd7ba918a72b.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FA0E4000C
X-Stat-Signature: nyogdbikp191ho1gkyh1fiy1j7fkahid
X-Rspam-User: 
X-HE-Tag: 1770282211-407076
X-HE-Meta: U2FsdGVkX1+hibYRZQ15mIfTFm/kyuPXfQYIBKxIGl8jM9Uz7ybWz2nkARZIUmfN6EVZ4eHnSFGCovmDhL1eAWJkOKQUXiHaBYdMvYiTfnyBBeOYd4WgxSk84a32KsHJqaHz+S4pKdU4l/wxeiYaxYrNPyQEB36w2mSMlGokJCjljgR9aF3n4G0YuKAT34YRKIki6xJAN1jXr7YEEv0xzpcSrLrTYldTqsPCEeGnOYoMhDQlsU2sq3yJGuBwF85CjzyzAaVk2dVbRVfVBe0S8qksddh2CB5s6Zqo36QtswKILP6sOBhf+L0QUG3YLpLZiJKCJ18QNn6KocyfAUVGPW5MDPTs4k3K7vUgyuIGnRoxuIGFyXnJ7PbSZfD/XHpiKhVuiFZe1W96yPG/UB1Muimmyzsyl+tUYHpdnyo5RZpP6lX/xuw6I5H6ELgMsf+dsH60ARKjVusxlJDEiBNiNai1h8fGYRIftRBpwe9jwojTmZGzQnAaFHxDGbH6BQpZwSOApGAeRNVpN62GP14PVeabahd/1Igk+DGP1vOYrIHJPghFqj/CjR5Fe3OcUuwb44cDLxrJ+cSiEh+f6fMFtqdnEv+iPlm+Qx+qmmL5yYcJkvdk37QzRQOJ7OEBigRkPP5mnllnBcKNiA5q99xwvpw0vWku8OK4yeYhJFpT2dY/aVt29lJQLYuRdkd6hQNaOfUeNLg5ybJocISODgZeffGvYbia7aNyD3ABCjfFnt9DsirPKs/5c0hbs+owCGQ1t0HqQ+Hlbq438YHHkzn6IhORVEeonnq3bcy5PdeFzSlmuuVWlW9YWJ7Io/aorqGaQJxukY5vbTwu6KJ7vdAfe4KlJWbN5TkFsStx6UYwMDtomTcFxYzPjDm1P6/D7RYbBiusSoGTo3bIm8MPShhCsIjS6TYxazvYO5j24/uPBDoNZLN9hCadMoDgU7IzZv+n9V/tNwbJ995FYrcSIFp
 XANH5jyX
 gxPyhONttpNvG2DNHY96Jbwx6zA3nx6OjTe497Wx6l95JblPgZAcnWV+FQlLLGDC62tWzic/3XK2/YfOnLVh3v2dUNaNtOIni0BuFoS/hfwYDsXo8pQjQAgYFIAbp+1r4hs3Nf1ucmk0rScOu2vxu0cRjsqDFFOjTXlWtP5f6dbyt49Z0T5xBRV2bNEOL7s9zcpxGK6Q5Dc1YgGWuX64XymHryLo7xiUvWtGpDVzGLK6x5VDw/Cqw7233JolgU3pPTroDLkNLiV1URxQ7PxlxJCQ42B8MF45QkwSvFDD60wR89I7cEUgj8d0ULQYXh1R4w8KCm1UFkDb1eWq98cloNWz98F5Tb7mCtbI5ypqlxji/XIip1iSXCy2iqA==
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
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/huge_memory.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 580376323124c..3f6675240f9dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1154,13 +1154,29 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	/*
+	 * The memcg destruction path is acquiring the split queue lock for
+	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
+	 */
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
-- 
2.20.1


