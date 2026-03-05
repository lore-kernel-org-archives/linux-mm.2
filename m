Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E960F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D946B00B3; Thu,  5 Mar 2026 06:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0178F6B00B5; Thu,  5 Mar 2026 06:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86AF6B00B6; Thu,  5 Mar 2026 06:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D94786B00B3
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:57:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABF591CDE2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:08 +0000 (UTC)
X-FDA: 84511858536.13.6DB7174
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0640D80004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mDHzNUEq;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMHHbOrsvMEf7fKsOGegfWk7YRVFbtR0jAiLvTiMweo=;
	b=iigNFF+K439Lz95lM77xD93YORF84OpmZ1jI2f9cVpOc8HekSRKODnKZuuH0ZHdGZBZ/5Y
	vqnhi6AFj5XVPlTtgzTdj1Z7Y2QYlcuZjrNYfBy47HBTochT/P4qM8rPJv2JI3g5fJcwPg
	UArpH2puMuNAMr2Irqa9q5A9L4Lw5qY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711827; a=rsa-sha256;
	cv=none;
	b=XC+t5Jv1U+hswHy5F3swkqjo9GljqlE4flCB5jXuF/QXWQJL0JPKOxpSUzti0zR3YmbMBT
	KbNBgpdcbthoPgAP3WHPiNGaW+LyAx3c2TbNEBzg1zGSfmfE7/Op9lOPj7jtP5brA9xvj4
	FKc1YKeyoV4SCn0l6AmNyfUWrCy8bx0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mDHzNUEq;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMHHbOrsvMEf7fKsOGegfWk7YRVFbtR0jAiLvTiMweo=;
	b=mDHzNUEqAQqp7SL0gmqequ7wqLe6seQrDyt4SxyM3fHn/DvPTQvI5jYPRoQYMnXXn+LlcW
	wmz1cq6L2WlD5784mqCaAOhK+e8AJDvNjI5x1EIKMdRyQDa/cS71gR+Lr6mLQ9MVqyXQXs
	07pwy8XxAKhcCGpQBwjvKf2U6ifeoWw=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 17/33] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Thu,  5 Mar 2026 19:52:35 +0800
Message-ID: <ca2957c0df1126b2c71b40c738018fd5255525a6.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0640D80004
X-Stat-Signature: mn5fdsffd49kewz7e1guxp7fayfyam4p
X-HE-Tag: 1772711826-920150
X-HE-Meta: U2FsdGVkX18R7BRt5aBpdSxIPltcD+1uGQbvMNizWn20vA687kgf4aycPDPyiNZ3ksFdXU55E7SftHxBNg9hmVg8+Xm3xTg035l8/CAKttzHYvgiNE1C5mm22WT4pKidLXcgojG9s4uUbXBebxKhfDg2uTIvZXg4s3L/vC5lGa7Ks/9KT0eCE6XiZjp0nw9BrlNLyWsCdv97hrbJsaerIWdHWGHpBlsM4QgfpWqZpMIs99aYti947T1swN2luk3bqURGgCZW5x8+YyJD81dsoPZ0oPwpDHDTixrMhcxO8pBberU47AxSIcujYRl3p6up45ArhDWAv0akxd+UajpHEUqx3V8Oa1J0Ljloivx+8UAXwd34ZiObRuuc/5tcrTGFBvOzG0THTMaUclTnF03PqUdJnON7XyptGYsvT7XoGAhdrtg5REGx3mSOAah9a6o11mwdsTtpX6wPj1usP0qMxHpDgS2g8oD7oKqLW66hCyA34wfzhZGNCWW6ym48cV43Eme+0FQOHLp8yzNWRXhlv/ILyCjbm3cfrqKCRiFNwo6cwLNPsVpiN/YIXkZ2sUm+FHmvxJhxiEvfjOJjNVkotHGaWEJeEDUBYNU3QESI1iM8hvzw34jiT1RxVUPNvFFIqf7acpOwwwJxc4iQNzFLNT8QsVKczxAiSOxefGEwm8XLwk2FCU6aGHKW0iwL3ilEY6WbuiiDxaRtPto+kxi+Gf+iHznRlwjTNNR/uN1xzjOTkgm09M/zBexW3HB1X5802pvxFAtEsBVo2cgciA0djnE7IQidRSWViSLP7F5grJjtEeXTwnD0hJTKYFnZObaxP2ZW0OltmUKa62RD7mIaa/hY+fYF6uTt0+z58FxEY2aynMUoES1tp3P7YzySJSviIkmlMvjURtu9cEFw7JNoCSW1xU2h6Q15f0+LOjV6JeshXXXCRRWiLQVRs6IuFjTy1nn+xZka/g7//gQLHWc
 QqwPG0XR
 btnzWb5gaQdrtR58iopMxupgb3ad0nGUV5wSiVlhhwJ6SxjPpmm0K0wDsxE5Vnm/yttRtNbzAkbb6rGgiN0FBX5Rb1xoKMbKTDOBJDEJZZBhLJ2s2RyBTMIko6n3NMQPswn2P7JxxtfaPgzAWa30VGEhAv278Oxg1DsES5GdbZ0YMo1uTXAkD4oYHPB1nBei16cAGwy632b9gFFrley3WMMvnkVeCzZ6xIpEwBwoURxzemE5Jzh0eDREFWX69TEIBfR66pvIQ4OJq+tqVctiBHoH89hCNcGCOiNO5rPgPBSAQo+ToUqz0d5HDNa5e5QUmHBY5dI4i1sCtzhtcxdM/M30h4g==
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
index f6c0a86055bdc..56db54fa48181 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1157,13 +1157,29 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
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


