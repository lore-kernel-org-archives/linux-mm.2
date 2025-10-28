Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D421CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAEA580158; Tue, 28 Oct 2025 10:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37E18013F; Tue, 28 Oct 2025 10:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C002780158; Tue, 28 Oct 2025 10:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB9AF8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50A1788865
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:35 +0000 (UTC)
X-FDA: 84047690790.12.B1153B0
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6CF2E40020
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbNGCPjX;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oMNhuRAi27cTHrhaZltmQus/gsvCkLckLS+iJA38nw=;
	b=F8MwftyiZ5XjhCrjTw3LOahPeWwER1N1tOP0y1ioW9FMZ6LJalZ87Kgkw5mZgnvshBuvk8
	VhV3yaOTHWDdeMLI/N6z0pKvxnMGez2MckwhTOD7nclBDjy0DIIN/0xxynvZZeWR5M+Zgg
	AUudYJi39dI+JNXt990LLGVlZPEpZ48=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbNGCPjX;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660213; a=rsa-sha256;
	cv=none;
	b=ErwA8X3C0d7prsn90xES9kR8AR6Fbz6ZTiMGUPPZl1cEVWLYJArToUyWZgjrC9rtTV6Y3L
	O07PPQXGRsXWeJpplbp9IDY+GGGtmngYiHzSE87dq5S5XiL8DbWeS2Wk1mfMTIa9mU97k3
	7WSugDWtUL+xIB+dl/zLb2ovOaKmTpA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4oMNhuRAi27cTHrhaZltmQus/gsvCkLckLS+iJA38nw=;
	b=MbNGCPjX2eMT1kl0IeUIiPgzGhk9+LXl8jF+2FbuFvx9cFOCbfxtLGhzIX0YHs43F8rw0q
	MOMy/qbzVn5dCpvh5smAIvBZR6AFMi1nbijvzmHsPNRZR6Crox1yE20Tq1CRzKFdbfjJ5E
	/C/lzYoQFfNgDHCjcMQg1QkXB/WzS4c=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Tue, 28 Oct 2025 21:58:25 +0800
Message-ID: <2ff7f2f1ac1d3884c549d9b5134322df21703018.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CF2E40020
X-Stat-Signature: wtuoh4yd3dq8utrdsubqic4xy7fk1w6i
X-Rspam-User: 
X-HE-Tag: 1761660213-725993
X-HE-Meta: U2FsdGVkX19GtX/r8g+of3fYTzn8WAvKEHUQC66r1bXiOyAOOELjEh7h1IX+mbw16pRloCTdPnsMMIkbN+GVfK2jcTgRL39UbmHU2qqJ5W9eMmf77bUND+bqaLx7Hw5vDrfu7udu4cHI2FDS7K9sYXBx5UdbRMqUdoZJnj9uEkXKb1TJLDZEpNb17/2LUTHrotzOX4pkNeBpPXaS0+vhh24p8ea1+iawsi52paE6CdMJS5WRA4soNHDMX2GTrmYLUFjfOd+oHxB6MrrA5h1c8M+Ia1ugPKmZzv2NwpM+ZdTO6Tc5GnB9CpU5GlNc23lfIYXpWQZer2a51S9kYNIoZoGqwOcoje+IyHeLGvDq4/1Vq6xnTfYHsSdgXywx+GdQqnktybV4/BbfQT2WDANlhtD81qMmIfYBYPvsZplRhjqPfcoL8Sp/uh9UGDVTaB5bg8rhvVg5khzdEDv/2jKSxvOIJjTuH5l9Pi4s9KFSKsxXMXqfihCMKW4ZWuJPuTXmbFpiLGEuTJTo+UW1FkD6qU6xuC04JXIloT4wttop1GEqLaYsZfft+9vo0iXTHCkZdgeJC7Uaus3PEF8vbinaqJQnyQjD/DR/xSnpp6VlJQVfQeKhWfqEXawOAIjp3jcPotkcVJg66ObnMbWISpTqQ4XHEyiPftw/VWnNU4BCy4TF7k6YMORWBjAsHJlysSg4iGtqEhRIRKEEOvA+s6NUqYAVHid+EaFVzpbTbHO0eEbRymb1dPGLsVyD6W3I7gcQBM8SZa55x5Ay2yRsu6ndkqvSGOQCi/d0F+KD8q8WJNLhxba66pWA6SEii+OmRt1jAtPJyGznTyZs2EyKADqPmhWZh8wN8sA4XYLiAVDdh/MlfsriFmYvUJO7H/jVTVBS2wUKrYp2pBpjgBzPiNV8wQmJcjW73HgHb7It1Ca+m3/9xKXM6VGTuwbupa7+lFw1kqAt0wRYCr/TTveBM5o
 qWzNqrOb
 DqdEbPAwUY7UStlak/MquJsMMWfKtwoUngsJWXQHmL98GVopCJdmvI9qp21ycCKwcmBPx39qX/HvhQ0ln8olWUw+hCji+KmgFgp+VFwDb5NolpHps/NTemrLpUnb5TLsdip6Gd27DDnRFnOGx5G+3wQmhPgtNGHfvCESf4u4/Eup1JOZNAoQQWJn2cys70hg1Td22b23VdFMpwcR/rYzvV+g5N9SEZvHN+YjVvnS65SHXUW4n/dgrWCx7AkkoB4S5oEKuus64cqoe7qc=
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
against the release of the memory cgroup in folio_migrate_mapping().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index ceee354ef2152..cdab1b652c530 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -664,6 +664,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -691,6 +692,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
-- 
2.20.1


