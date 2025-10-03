Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2BCCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9E98E000F; Fri,  3 Oct 2025 12:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09ACA8E0005; Fri,  3 Oct 2025 12:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBBB8E000F; Fri,  3 Oct 2025 12:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB33D8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:54:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BB6C16085A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:04 +0000 (UTC)
X-FDA: 83957400408.03.EA4D05B
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id C866640014
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eCEknGtn;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmuFZk4/UAW/wxAkzYqRFSTRE4mQotQ2IEfc61WTNZc=;
	b=X2lntR7TbQhGHg60C3kIDawNHdKmJMlTRPL4Nz8F3cZHrvLjbJPWyu7pr9DeIYDanJybqv
	FIr40eaanIeKAgp+Myh66eaE9SGYwWoc0h2VCbwQvsnjdyR3aknP9SOsSK39AZjgS439a5
	x7Pz8F6yAE7FO8IlRRAhUvwCaphD1OA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510443; a=rsa-sha256;
	cv=none;
	b=deLM33Ln+9ozyTQYET89FxozROdZ6a6kvx8eWDEHkE/iQzrEwa6GBitAqACWNrfW7Y3xOk
	Rv15cHkq7gi26Wr7yqEyh0esy3T/Pa3tOO6G/FmLRrGNUiTpwyANug81drZyr+c6HzUnn/
	y66gyffd5/KivEIb+BxKlHJD/iF6rlw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eCEknGtn;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759510441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LmuFZk4/UAW/wxAkzYqRFSTRE4mQotQ2IEfc61WTNZc=;
	b=eCEknGtnpG1txOB/xuohDbik3Bh3/mtFYzYUJHnoMppqy0PbH9ce2dCt9hDtS3WpkkGqjG
	IiWtXzrD2fA5/8OzbDiUi2/VtABzaS3OI4k7w5ComIG1Sw9goA7F3o0QggxvKWFb/R6Mdp
	h58jJLc135v47IBEBxLD/LPWvNht2Ko=
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
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Sat,  4 Oct 2025 00:53:15 +0800
Message-ID: <7bb571c217c3c14c47e86706a50c1b792e88b4d6.1759510072.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1759510072.git.zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C866640014
X-Stat-Signature: ujnyjoth8maxt5q4qsx8mezcetkmxbyx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759510442-218551
X-HE-Meta: U2FsdGVkX19LEc0OshvHrSJg53C9XLGLGMYUnEF0xTTjftydB+V3buAUgHuGf2hekqNORgWaEYeLAPXJsyK1Fzdx7/7t5xlpIyp8okXer9iRNWdd9SBcihOT+2uvaUcVFFgHomrFHvWCppihY2VBSOQFVfa/nE+vGApJmhnKkDq0NO3+sCLu9Gd//u4Ex2Nq61g0tFjoXBv0SWn4VMJ5isOPlP6/ZZNBtAwebGHaflt7oMK9zMfCsw8s2JQUeGDq+niR/95W/gC2q8rDyzBcYaY2ABXsaCOwqEkkp7Y4jfF1yqztuHY2bF5i7ZpjF+hIx86rIMfo7+PX8iFvv/kqwj/txBWWO+ULnHTDShkSWjT6sAFQ1zgPyPc5ZonX7yToL/ijHdzhBSpTGlXtu8QNHLQV+Bt2v+wwg02vled5zQbVjFrQmK6Xg5iywsZCIgdAZE4U/D/tjpDxk8aV+vjZ+VmftbejBfepnNDwG/6oU3g6afsjm0GOl7P+UhcG+rThOyrfJtlgh29BglwTOoYGHCFzGauBaaNOcImR3PLjsm641YYBz13yY5xtS6WT+SQP0RkU+1tptyF5gDjVTD656740fToIMdcFbQIM4YALmdjM2Vcm/kwIg605zLqu6cqcoihPaGSi8fDXs+6ySAgFaoAXKTRSTJB07HLZvV/5XpGKrsNvDGALZxttt05MYehlkVn+B9T2v75UGnPthUyveIvaifeqJQAfTqFDe0lJ8T+NVfaGLqyeuNKrneYfXvnGEYTjnIR0ICQ25kJeU3Fb0iJ854dr1s/AoYE5zLBH6i9WvLJc98HB+U9KOVaW8pYkqGJAGimLwwyVwBI52Nn17Om6gZk5DcNDVSBx5sRRtW9PrVpNswj4UpdjUTd7NXXIieyiP6oA9G4CjX36vMNCWikZpuGbeGQEjqvxPNogYIFlsyl5G+h28/5TW4Zde4qGuJIyTQojRYH0kbatAze
 7+W47YZR
 G1xB2lSuyQTUPUvJV/3AOULrG9DrhVv2GoiW04ALiEZ3jSqgz8mbiK7D8ScjzYMZSSwWUSeqiRI3tJBie7Xcd7MqNed/9cc2PjupYDxgJsa/g7jmd/f6/tR/oEjt4icpflgCg0f6HV9ju+G7EbpBwQ1tGZXT799x6vio8AKXdNineCZFXKTgsZVTWLac/nkhxewVcPP/XBtiwTEIqOGKNayzsepGhyOcSWMHTox4wrdmPLICqmqCLmXHAT1AvzuG7E+K8ycLCre/Q8vwZRRBIwcjRJcL/PNuRV8+km4sWxkdxHFKCz2atI7h37FmJe2ty8kKnG480RmLSCgt7UYhhAGKQH7dfT6M5ceTDRFBBPFhAdkHYJB1Gyv7/eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225f..6db24b3a57005 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


