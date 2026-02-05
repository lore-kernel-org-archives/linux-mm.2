Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 521E3E91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6B96B00A9; Thu,  5 Feb 2026 04:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77B96B00AA; Thu,  5 Feb 2026 04:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76C76B00AB; Thu,  5 Feb 2026 04:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 936CD6B00A9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6061C1B1EE7
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:58 +0000 (UTC)
X-FDA: 84409813236.24.8F7E135
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD83E40008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1OtdHXU;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAOP1V+p8DjZyPt8ukquYlqE0yR6eZreaGxjmoz7+YE=;
	b=FUuL2ZwgkKXoi2tQikL9bKCGMk6iNB8asWVr2b05kWleZ1XSgajeNS2x5JX7GZKVgecOdU
	5CXT8O6BQoP4/ddTUKiqWT840jIvO935M7U9KzsOX1Q+U6ECS+LvNuXEvz7MyOD9TJouph
	y271VRk2Mh7r2YAOsTPMo3dhbp19E24=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N1OtdHXU;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282176; a=rsa-sha256;
	cv=none;
	b=PyO5lgCVpi87vNrcJGwcE/vgG7KX6TLllpONMLao7efGOxRfoVjeLHIgDp0TBx81eplUOv
	/AVQnGo5jmHIYfAfjKhTxS0+9y2piUsIX2vOJjG4pOCYgXDQvwcV1PXxd8CYj/6RHQpxci
	Y5d50zbF07uj6OpC1HkPsRmykaZGGWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAOP1V+p8DjZyPt8ukquYlqE0yR6eZreaGxjmoz7+YE=;
	b=N1OtdHXUihchpXMDHhkMzio44iCHxAJ/sdu5PAUUE4RMn3vsydl6nFRilXucTN4RWSP5wV
	5hr1bW/nlblRcvODBSzsYaD9LZof+CH9WmtVPFwBlhQil8sxsyyDyU7+8ymQOqEF0Wpim9
	VVLGOTTpest5FZFx6sSvie04tLkSvHM=
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
Subject: [PATCH v4 13/31] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Thu,  5 Feb 2026 17:01:32 +0800
Message-ID: <4230a3381da7605324eef432c19e24eb6dd3c0fe.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD83E40008
X-Stat-Signature: 3csinoqhphj8wqtcyonxmixpsoe313qy
X-Rspam-User: 
X-HE-Tag: 1770282176-474597
X-HE-Meta: U2FsdGVkX1/MUCsuFTXt2bPZbr0ogFPIwPQfU0E55yRFtzpKwg7/wgSIYSTpaL1ZjNfrpur4ovDt6jJZMJFJpfU9nQffKM2+QvKDBmgL+TaSCb7GevgY0jmxjXwQA2/Of2512e66PKFu9kzog4tDQY7ml6zAu0qZudqiTZT8/dnpaSzMjoGW/rwKgEddlCYWe6DHUgLaKVQAQXLaXyZV2FKsraxrQUvwMGxSqQ5GibDJkiu0v8AkGf183e5NhrXgYS+09Y55kbbrXbkkfj+Ma5y8inQeRBpp6f+aOdD2a3ydHodeGyIhJERQtOvdfSYDv6DlCcntIrzBi2UvKD1/Qng9DTbsKKzCS/1p50la4nx29WeRyTda5C5+3CRe1me2V1uDXtkbw7hyjCLB7jOtzlAIxRSqF7v3YY/Y4G+JKdULTxToIBf3o92RsXKvIL8vhqoaQbavmL/yY3B8oqm/Jn06zczNXvi0v8gtX6mSZdkTfJzLxx8M+Kyv3IajbFAXsVTSKF5bYtG0GSin9kR0Fkq2orPGNIEiMirmTL/AW2mhGOj1YQeblvzMg5EM2uvN2xbloeK6sRDwCL5IghOjNCPmEwFs5Exxq2lBOU3zRK9ph8oHw17mMzko7jJi4MsSyw/9By50rI5mILqTLhQ6sxoxCLblbXV58WhxHql0ImVA51977XzDOIJciTsUirgntVFnj8ytxE4qoLSOYXwg28mTlUTN39GwTg70fm27M+hokAwICUPYSBf5cysKU+s9sqVnI2LrZwFPZ4JqsyN24kZ7+dy9Z68M/t3ifnNgab4xC5hJ0ANRy/To//6r0W9UrFLQewO9gs8MmefxEHwL/iP7LIIUHjAbDKDmaB0NP74pY6Gy78uh1EGyIlcCE+fwo7FSCQmHGt/8yD5cvj6IObK40IItMVLxNeRwt/QcuqOhPnD69Oo+DjL0CA+cBy0VsOGAc+8MbidPrEOlzJC
 lkoDYeI4
 LR8re5RhSLdhnRyK4Z0LgzX5hEtEa7anCAnFRkxikQvd3QKxHiIN6w0jCm0dFajwqnW6pon9Lldm/anpQwnuhKpSSxLV2lmCeWmw7jaMG/3khdu93g3lRwYRQ54DhgSMEIWAKUv0/uSJq0HiNJ9NCNtlJBcPTWTu38oOGEZSfzRZGyWZwL/nxxnM3TEpQz1itgmmMzqG+jMz73TiKVNvqE2LW+vYECowWdBLI9uTMoD/gRQRHcw20M5uKB3+YGUJ6zUnnblsuAgsAbfkGeiiNrP6kmV29tS+spQCS3cPaByhilyM3MBmd/GLFZw==
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

In __folio_migrate_mapping(), the rcu read lock is employed to safeguard
against the release of the memory cgroup in folio_migrate_mapping().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd4..45ba49af2136c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -672,6 +672,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -699,6 +700,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
-- 
2.20.1


