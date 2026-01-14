Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F179D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FB96B00A1; Wed, 14 Jan 2026 06:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D956B00A4; Wed, 14 Jan 2026 06:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BE56B00A1; Wed, 14 Jan 2026 06:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 921B66B00A1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AA848BC0C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:11 +0000 (UTC)
X-FDA: 84330360702.27.ADE7BB6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9619714000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YoU4Iky8;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=642wzt5sbJwBZzq4cokZbiQed5LcU+/gP3D7+Nkqfps=;
	b=6f5h3Ri5hMrIj5TeP4alIffxU5R36lpmkJUgzoonHAU6MBLv8k/0gX2q4X+kpB1Mm8eJN9
	+RdBrctLO7y55XAXoRnpGFIIK15nF84wrGEWM2QtlbIVctaZyYA+O6AdRpi5hotJqK6qwX
	KwE6DMFURbTTCqTB1wgnJXOLdm5wfQg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YoU4Iky8;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390449; a=rsa-sha256;
	cv=none;
	b=XFU0eeOSk0rGbMCYlO3giM0dCy56afrOrayXsf8AITIPxraTP1XB+OdEqpgl/wLPlYj6YZ
	j9e8KOGxlJH+CPluyGe4nJXe0PKIifn15NW9mhKvGxw8CzZRCeflMSaIZbfDCwdczsNwi8
	xjs9uIj1SrS1LaF6J8Lne82dH8IvJcg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=642wzt5sbJwBZzq4cokZbiQed5LcU+/gP3D7+Nkqfps=;
	b=YoU4Iky8HLVffHiXRoGwvgVGzlVPeumBdrWGgRX3FHJHeSUAOcRyplIqVBvX9ZV4PECp/m
	wVNVWs204n5weRpItm0WRWIOH/sVQ0v44YN9b6egvXft4ZURKshYA+NNhwh95UbPIEutz7
	4pgDms5mDpXAR/EA0KbeGFqdVrblkV4=
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
Subject: [PATCH v3 13/30] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Wed, 14 Jan 2026 19:32:40 +0800
Message-ID: <f25ed2b09f4b6d5e72354249a516248752cf4f1e.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9619714000E
X-Stat-Signature: 78hqpci44wrhkiiqbefrbx59trs1p5oa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768390449-673696
X-HE-Meta: U2FsdGVkX1+8TXZiApPdftr5OMtFeHaWNeoXmIjij0Ga0JbKZgWGCV8HtY3bby7UDSxs21Hv2gzZ/Vb+7brAZ7I3Kryck6uvyWnRNhDkB56yDsf2WVjaM3l37OvkwNuAV/+g6iBVzcxg1jCmT4CZ50iqqkkM5nI9gDzKJydNqGd71tASocKLtCKV6r9bZHzMX8mnpt9cW6qopp7d9aofYVo5if6MRJMSYYGp95OZL3V1muTBC+DnMUVfTCCgpasOqHWlCNUUsLgh5iAFi96YEEtkwk24Qopo/lqSunJO5BdiG2R+PXX0nGStbrWs489C0gxLoKBW1tw0lOUZ1JIkmn8gybHlAxvy2tIlhOETffw0+xa8fe34UNITqCm7EbWeNrvnBreYQ/ZQOradS2AYrSkWPzA37E23sNKtBSaeOfZDjr/yEfptLTjx/6GkHFAG7FYkJpZWGxY9yLScQcoaXLj0xEGRRovGlUhfRhprByo3syPXLx/NHa1aaWKZvTeuuI1lruKfQ6cfs8KKCH5qCtvD7W6xzkc5niBgTAZV1Zf6Ppcqo905sPBcL0jmsiESIBdsD0V1vLFFOnRj5oKTf9a4VJ0aYWZ8lsYeURVBUUcc7SU3Q9EYcSbSXVd/5CKbywzpDTUyTdpFE4uqa8T4UF9u2/gE9mTt2OmKEA7sBfv+5DkQBNL7ZhwpG7A3v/6AhRAIYAdjJoCcQ+NoWHZk9ry+zF23QKjvBqH8Tjd6E7ArjC5e4AfpsLyfn8B4cMhGb+hJm/cat61MwndHnIKJdojAUMqUvQBIipS4c0JnFbxH9PPMxP04Y8cH8z2nLhTWrBamB/yod6FQLRNXkJlBBOkYax7Kng97T0coPWVz7PvHNi7WXE2yRC8PQ1nWKIPjl2DbejW8J/4jmpbsh2G7LeysiESE9UZ8lJv34Ytq75aiTMe0b1F/98Bx24lpGFsl2ozhAUY2J0Wh4vMFQeH
 TghsC7YH
 QaWkG1EdaaJyGI5I2RxPrZHxniwBf0Urrg8feZWK8Ksaa4gAmw1qJ62uDxw6yMSnTUwr9K+l6zDniBb/bpkHuIPkbxLiTmNS7TUtVvvhi4+nVWzkMQpT1qhnq5EEulKVHGMgNHinaEqnRKphmNUt9wYyV06WmbcMENiCg6iDzs61zhwDnildtUiaT6exgRRN6ULa9TxXN1/FNKvkvLlSrjN9FKVAAcXx2FHXVuqSGrlZFroGJDGDKG/bOx0S+5kOcwoZEI48dZHlLL5scyhSYKkcYQLVMGa73sjHUjMcPSBvghm/ojd/Rpe6pRczIpJhZv66h
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
index 4688b9e38cd2f..1aec3f5509538 100644
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


