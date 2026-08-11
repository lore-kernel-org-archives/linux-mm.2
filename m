Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC309C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDCD6B009B; Tue, 11 Aug 2026 16:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5CE6B009F; Tue, 11 Aug 2026 16:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63EB6B009B; Tue, 11 Aug 2026 16:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97B046B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1162540250
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:36 +0000 (UTC)
X-FDA: 85090136712.11.115B459
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6545C1A0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4KemcBI;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMaHE95s1N2ro/hCTjeuWjiZbKrQjnsN0zD3VNnyWTQ=;
	b=OlgzXIQU8f8NK5QI/nf1cOFDWTd2WSmTau/jMBK+zsPJeaJcAIdA4vNT3KKDN7HSE8hgJR
	2HwtFAOyupeUrgR2xwptApd+aqa4xlo+QJ5Laax51TonEUP8Yo074PqYuCXA6wlZZYIMnC
	DQrnb5pBGaZcA24rj5kuHyM1OPy88hY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480354;
	b=Wjroeg9yjDvykieeH7n9gA4E8IkuxnsbL6drJsGuFlwek9OSibVT6rWtqLQURakthN9KFN
	eLFcgWXAL+T7RMBbZXZrqBQwilsf8ZmIbp+TTN4FEp81lEhKkxipHW/Is7ZEXzLvZOptbg
	YCnKXwpbZ1I2feU9r5oT6toXS6s3m5M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4KemcBI;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kMaHE95s1N2ro/hCTjeuWjiZbKrQjnsN0zD3VNnyWTQ=;
	b=q4KemcBI3JXk3fWT/q8wUMtoNfqZJlPmQG1Me6eNlskfW+iCFIzGJNVvpEBAagPzCazkqR
	7ouS09BROAyYGe5iZK9V1kMaN3WFVRXDwVzGHJdmOnVN3t8huWXWZkz6iU6N6bskDEjHJb
	rATBlfgk6qxpHPSnQq6bmoh3y+Lo5WQ=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] memcg: remove the soft limit reclaim tracepoints
Date: Tue, 11 Aug 2026 13:31:58 -0700
Message-ID: <20260811203203.3456029-5-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: s5mnm16k3jg9jf6e61p9iud1nwxk7417
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6545C1A0013
X-HE-Tag: 1786480354-273816
X-HE-Meta: U2FsdGVkX1/WbBcJ/DGO/3uyRl/T59omKXXFslvvank3X4K1pFFAs+TKjzK6Jy4/yR60qrWQObt3KbisGKp5Ge7qO27ZMwG9UiI1ZzSOCllOs32R2hOazZjSuthRXdgl8VHlGUVnqKWFk208F+byLDZtA+mwXSAEOuagn6pHFbl7UJgR2cNT0jj+jnsksTrOCc7x6BvW9DcwQls8ocoEf8iRg6ZR1q1TyTKrt9YsDvICr/lV0O05MzOmy0xqyVtN/FwcLhk+mKPmQD7CCU6ut9rZh52daWtDkFqZS04FpUPLtuV5q3W9wrIDV/opA4z1XuZlNF4Ls4/6pR5eFv+QEzORtOrY06/Xi6xUJZW+e9NmGyrcnYkpCzr/plvjq7CcIIEBA9tJKMQcsrVLqVAHG4p277fSLIOF4uoPXGsY00qrFKXCkdd8p+63KXb2fyNqVADvbxwU1rFCwpIZU8tLiVgl35a9oy7gB28EKqAMVJQuynY9kGkWcOxqQ9zg+n6hs1CjXgplkQaSjabs4L1tsLUEUUYtKT9d+KEL8H1T17URJRTVwnXIPBCHE/+Q/+QRMSsXPLDBu0OBwu85yjY5lwPiJhl8lFeXfF+d5fMAXsttDTJZN7zlGuz78kdsz9pw44x3u9Oe/2aHWL/19OQO32Zg0sKF97C7j6EyJtqPvA1z6183aAwzwXbZ5Ln5Pt/SZ/9WIF6CyMIWBBDMFgfz8It7k8LKcjgHNBTQkY+OynaescfIvWDmSrAe99GKjIrHz2dZSRUk/GiYT3i60OBiYcecgh2Xf3GPGov5d5McsezMmm8A2BpCwUuZmm7kQjlCwtxUTpsfX/PMthzWORHxpJX8viSUaoSsmHUkLLESeJsv5X03qkeAhBqh8AUJGn6ert75WqXbs3Q7snPel+D1buBNiYm6pfFLkUwPB6J5CSKOm320BUhTEz+FqKApoVjggdnbPcTlc+1HVSbWtxr
 NCKZSLf8
 6iwlzvdVZ/TcSnJFsPEkEm6H5CuEZUxi1Bx9LW74TKSuG+d+z5vFPCMTnzYK8wnXDPJCKSx7z5UGkTgrhqErLd7j1N06korcjG9yrsAqbBy3JVQ1ARA+l7emB5WZBF5FbF2Fg+NF3L58+YjER3d3SoNl7VWQzP+XWO8XX8OB5FztA4yltaPMUPiPWeQmipo3kFQzyajUCv1cPpRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/trace/events/vmscan.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..8a872990b4be 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -260,13 +253,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
 	TP_ARGS(nr_reclaimed, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
-	TP_ARGS(nr_reclaimed, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 TRACE_EVENT(mm_shrink_slab_start,
-- 
2.53.0-Meta


