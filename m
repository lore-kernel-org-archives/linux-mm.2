Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72ACFF30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD32F6B00AB; Thu,  5 Mar 2026 06:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B286B00AD; Thu,  5 Mar 2026 06:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96456B00AE; Thu,  5 Mar 2026 06:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B99186B00AB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6534A1A0949
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:24 +0000 (UTC)
X-FDA: 84511856688.30.EDB7EB0
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9F20180008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FxYOARU5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hyqbb8F2NRNHHFp77Ms/+jViunOCmw3TEFzht4PTD4=;
	b=YUYGTc3A9jGjDgRXwvbB23iiBt1Ch8uug6zj3T0xzNojPIvq0aoJOvlsc6kykctMTy+6vL
	P41XiD8S0Gm0Otgh4tg/65FTHn0JxdxuajlOExuydgBUaA9knmcX9hwH5FLuzvVCHRd+j2
	524/kWaKcGRr8ETk5G9OHIOg1xSDIhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711782; a=rsa-sha256;
	cv=none;
	b=nF7zmtffO2RMHJrAqeWyJXHa+00KiV9ZBDDpFQ7QaAFI6qMJZqdnqIahipZ+a4hmpFzPbb
	35pEInDXTRXWnSnVF+2D0HG9BKZHZQ1Sr2fpe+g+Kr3Ytdv6i9flolitdf5opzOIwPNltr
	FKzHjcGa6fNSD2RnEcu+BVOGcfnF4/E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FxYOARU5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hyqbb8F2NRNHHFp77Ms/+jViunOCmw3TEFzht4PTD4=;
	b=FxYOARU5x0g+Zna+Ay1ysDbQ1ntMsGhY8lLL89aloYuqaM4oNBrujP2pa/q0wx6LwQTaci
	fEFYT5Sp4lq00AepmhrB0Hut0n4GXtU8qSaP1MKimCke1uJOslo9LqbnfjQJFz5e6dfAeb
	K7bYbN5wfpK5v5eB3OUoXcoLkaNQKDE=
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
Subject: [PATCH v6 13/33] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Thu,  5 Mar 2026 19:52:31 +0800
Message-ID: <0f156c2f1188f256855617953f8305f43e066065.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9F20180008
X-Stat-Signature: oo1otiq97jigkfmi4xo6y1nm18k3w6zu
X-Rspam-User: 
X-HE-Tag: 1772711782-587344
X-HE-Meta: U2FsdGVkX194beA/ejvEozTGE52kPZN4jUVBtX6aWTnGgximAx5U2ZHIHsMsthSS2Tmab+7mPJdZRQ5un0Hdcx2zwBkJSdIGv93tTJT6VA6S6K1g74P9yDkLujhPPqeLTHkkXwL+1oBCUKHlUryLvuEEaSBLALGYe8y81ZVd+9auHdAtTQD4F5IRlMQ9HNxwo04QxFZxevxN8wEwsgYWgv4Ngl0LU3tW0JolqYo7i51BPJUlhSmZtkdq+G4Pa1hOhkunfvduQz8byv1e/6Ol+gj7TclpIPq7VycuOecZIHatBWeNp2MxDnS+l3vLKX44Lupdo4WdQt6nVpR7zlUpdHFKrOG+y6SLYrNq6pdtftcYV1d0mtsKyPKpkGKZjXk9LQyvDi+YmprWNP72eeyMUDu5udFz7QUN+VwoVJFJgCecs4ukbvBGivo4EpIllRFEb10kg7Y4xcCFbHLCila2WIavwP8SL/1UWbsBcPtqnj+Pi89HbDs3sm9Hnn3PUOJPuOWUVxU7gZPA+gl5N07HOC2W/LTxV9+i1KT/ol1yh9q+XwBlkQbkRR8sKofwuOtm8WWGmKfgKXOtdlVQ8N72OFyNLTW9yrDVzRCfkMGGyoTSJ4dOwfTP9tC5NwbnNJf6yg92lCkTN2tzp2+A5oI6+M59+gYPI9hDMUrvbkTldfm/XgdPUnt0VYsJAmNrisHg4vmtWrgEStImk4rOeB5Bx1NwS/ukVjpoYelSar+6CS7nn+3JaDhgGJHprX9kcXNWgQgkDb91LppqpFlYalUY3oFsLvoF0WRoWyrJXoY0EKf3kQJWNM0PudCcC1e+y2FjrslBU9kYDl7njSLWuQOoD6MgFS2b/dzQt0eHJJRByiAM+T/FoCrB2lMGBVKUTZa58Ts3Ln/PfAvHLVWuafaQExdKU+wYg3FtTtXdMfRCUs6Ki2N6YaCZ1MNJRPFF0v2k4UU2FQJEqVtdhSWpGF8
 WtDcag3R
 37BF0UU8Sx7+8JXWYzv3B3IBl1DOwoWi7KTci86XrtRjt6BYvuAC3eiTAoazE3lmpOVUm/wZVz0JNJe0YcjX+4bjSPhoA4+8fhWgvMH84/A6NBglPXgjapSKhAmWQCBAlnSA4Qm59XdCYKdV0QXgZcZUFzx5JNEGFSVqVw32QMrAFJVAZGb97tuDiAbtkVRCbL9rXp6sQat7rR+Fvp4j6xnZ/xQqcOUMfn2nWBvyvDcpP6rV2aplVdgNLzpVfxC+QJQpODlKNw58Pp0VcrAcVYoSCLePICrNCj/wSyo3Rlx4NOo/25MadRO+Zr8B0hHSoHkpL
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
index 6cc654858da65..27e6103037c29 100644
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


