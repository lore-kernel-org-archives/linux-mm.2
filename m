Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0C7D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C61B6B00A5; Wed, 17 Dec 2025 02:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483BD6B00A7; Wed, 17 Dec 2025 02:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B09D6B00A8; Wed, 17 Dec 2025 02:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28C556B00A5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:31:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE7BA160946
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:29 +0000 (UTC)
X-FDA: 84228142698.12.40290DE
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 420C740006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dpym/8wi";
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ugmq4fp6u6Yh4W4K7GQktCJ98/N712HUp8zSOzWPIU=;
	b=KrJ5Kk0eEYv/hZ41q8PJ91tCHRFb9HIifmNu91y54nHFjiORqStn0G4c9PzoTw+eOrUPIz
	WME2L7oQC31vQahKfkYNFoFQrogwLvRgAgWj1e+IJijIJmKivsbsIwHCFsQRp9zKSYS7VV
	WG09rBIZO3Q5e+QSDerig5fHBG/DP04=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dpym/8wi";
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956688; a=rsa-sha256;
	cv=none;
	b=HlJWMi/aTG/YZi96NxTLqJyTlKXpXzkXMTpEwZ9tPQWmOU4ZyHIHlXsy8jB01HilH6aTxv
	qTLB4l7daX6jln7oWvmqd4ds5cbvYJwtGHF2uyaTZwqWXPLoERk9g9WXBCybzdsYARpBPF
	1Gg9tbapVC89XpMgfEB7yFh9EKKWcXU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ugmq4fp6u6Yh4W4K7GQktCJ98/N712HUp8zSOzWPIU=;
	b=Dpym/8wiT7J1ZVKeNfPt+C3A+L7GdRuNhMyDPTQKIMteFSS5QIJYRZCFJNdHpiMS1ez25Y
	7X1VGxT67Up330JCOXDXoI1rHcxe2C6xowJgyhm7GBrskvebqMmSp66/G9AOsDH4sMQa4I
	QgiaDtXzXOzyT4f+DsixHyZtIUbp+CY=
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
Subject: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Wed, 17 Dec 2025 15:27:37 +0800
Message-ID: <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7e3rjwgsppsmxr4ttrzzmjozmzyosym5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 420C740006
X-HE-Tag: 1765956687-1895
X-HE-Meta: U2FsdGVkX19grTzCo5JKX6zxOeAuNt83TgaYiDLJIeTPX4Sfc3GIyoc6z5ABE+7Cm05s2xMc8Rh6i62gpk2JT60FWiUH4zbL1UH2IqVYd1nT8Zrp1d5Luj57PzVCz3Py/z5CI3dQ7Lpaqf2pe8moq6bMwQvIq+B86Zi7/7lluaM/t2t4qC8LFlzaxuZnqBdu3X4VXMQlGxXTMOBS4Oqn6ur0VlzWvtwXlIwV6iH04ocr4ppBQ4eSU+SNJH/te9n6fh2ijIIf+3hLskC/AdcP2TqpxTBkKVAQ0dZhfq3i8OC0lb6pqZBIx7aZjet211JaiixpQVDv8CUy87GpqpbK+Y8hVyR9xjFYuJtvZbQg7UUvXkVDzvyZyfdyZdh47XrN/nP3mpjwmhzH6jrcEmfeQ1kR2PoJaWLmt7sJpvutO1DFBcEanagnjUtC41w00tRY6B66HLIAv6WHR8+oh4eoCfyrm9uv4CCs4ciJNBGicNYIp2yRPZNRHdIgc4twH2Tk+9gbRHT2lc6VH/gDHIy3mJkcFzukbNNoTeBipcEeDmDY65XUkCFOMnK4RyAO1NzNdVE5A30LffE8NMm+qA11JFkLIE8fkdvwNr549sxavHAJxWLHHZ+31mYmqnW9qGOet8Ym28Dl89fv5uHPGuIwRg6YoXlk4rmbKBSJS0CI5VgPWw9eWzenx32VgTTqTMy/k92QZ4MRgtM3ggXy8pm07PqKSEP1/3h/Pyag7PX69+2Ccgq+Cq+vyb1hxXQfxDZiDs6Ua1XgAWPh1qpAcvFWsYWarz5wcT8mkEinOVYBhM5QrQ6cEuLae30lWau5neQc8OGvEcv1aQZLPvV3glqeOCJThoBlxd9ANTfXaiRk/PTK6P9oGo34pSio/G+y14QJ0TTBmaCSndMWog69Y8fhdLyybWhWSEqJ3KcRZTUDsEt2D0DjCJs2BhFpaJpI44O5WK8PcivJPEGdQFARTc+
 4sS0qJ/6
 UfkdvZcB+oKdALeF9HVG1E3ncgJpWwts5eZ+FrTZT1jhJEMGBIV0hpr6zpP5MfbRHdJzcjaUxuZGvpBVR+V8EqjUS0INVaUoLGg7td8MEXZHO5h6aso5cPp14igSa7eAabnjJOYXDJ429IjGbExQLeC3QckBr9P3A0Uj9ML/i2aEmMkE2ol//b+UYZdwzLkW9w3Uf9bq+BDGEbVR8Xvk96eUTRSjXq9kFpHj+GDN9Axo+gS2W270D19wM3X6U0VT+U15D
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
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f606..8bcd588c083ca 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -698,6 +699,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
-- 
2.20.1


