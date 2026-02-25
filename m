Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A256AEFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B0E6B0093; Wed, 25 Feb 2026 02:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EBF6B0095; Wed, 25 Feb 2026 02:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DE06B0096; Wed, 25 Feb 2026 02:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D296D6B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88E4A1404AE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:16 +0000 (UTC)
X-FDA: 84482206032.01.51B34A8
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCDB910000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NCnR9f4t;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HAmieQx96uUJHkqmiULZYRo0O0Tag2Ie6J1oo57wFA=;
	b=TKKOGbjKEvEL0ng+RQlFgmVdPl7PoRluNq7vrRQBwJssdxUdQRSqqk4S3Vw9z3rNYcxxVJ
	6LvK3opqkDamCELxgkR3qZbunOcG7+N3LNG+h2JOWEB8ElujQ/S9p+ApJNvGAjOfZEgpZE
	c72euR0ZuiWgYDeedsi3RLYsSGBmPWI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NCnR9f4t;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005815; a=rsa-sha256;
	cv=none;
	b=X6ZcTuv2kbQd2iwnVTIF9SwNSO/157aOe6rQe+kpF55SUWyHDk5cXbv2nZKuDgOOel22HJ
	LCzP/s1+dsUdtj3q5appBD4DFKqSefAcn8mjGPa0EeV394nz2JLi+RHIH2g602BQACiD5C
	2sULxJnHJ/3N3OrMB55yBXEm+YawEQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6HAmieQx96uUJHkqmiULZYRo0O0Tag2Ie6J1oo57wFA=;
	b=NCnR9f4t41tnLyZIMNtwlBFw7ejRjvtobpnuJm8KeUjpFgAngQJZJesmHOgR96X6VYQwuR
	6p2EsqIMCTGStMPoLFi1+V93HVsUAq36kTiCMDkgWGfqEokdiXUY8XamHk6qtbIm6PPXYu
	+6VVmFQpwvXQB0Ij8MyTGdn9TSYTsD8=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v5 04/32] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Wed, 25 Feb 2026 15:48:37 +0800
Message-ID: <b3a202f1787b0857bb6cbe059fffb8edefaf67b7.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 87inac1k689ff6zdzjpa9se54kwwkba3
X-Rspam-User: 
X-Rspamd-Queue-Id: CCDB910000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1772005814-402871
X-HE-Meta: U2FsdGVkX18qqnHJBT0Yh8gaihCE55BYP9q9LNl0Dwh/ib+iYuc+1mDasRTra8QGl7pAj0QKZGctYlOllAKVz6oxtNhKKgVW8XyOXu+/DxXPdK8FjynzLZ4g5iwo3R1t0H/78EnXwlY8aIS9gX+mJvuZ+mh53N+lJGO1ZO+oDJmuqv1pbcojI8fmF92s1los56WshT/wN5E+Ds5ojE4DfDkRCytqm/jGvCpeoSR8R3bkEaRHUMEvizh1mNEbLN+C16yq1Cl33Ik6AOv4hRv2+EceBMUYmBLnTPoxnFMYjG2aOMM2HCsctvVBNTDpxb1ueW1NRkrZa5Kb/zR54CLM6Kztd6ge+GAUobhIWxO64dTDS/xYfO2EhJl/08u4jFhXEpbhGcEo147X/1OgC3gmcDzVahUGmaJGX6UuMZSjOxu7JRya672AJQR0YB4z1u3v0lZE1nO+L+s7BaOI1clXrV8+cBdB8YH+CzTyEqjGXnzHkkhSy3VkLzcpjUGPi5mjPIKRDZ9RzBHs87eSwIqjCgDyySUk67UOF89f6cvghUtjyETTnlTnUb71MWDNo0Rsp/HvHckD7nuAmQPo8Ekwx03YidQ4r7AZmjEk18jvg/eJA7q3E2+XJ/ht8HWfFvO6FD5r+mxmnBtnOdN9aGKpXImNQJwGD7fjCBFVvp0Dclya1fz26NJk8rp7w8rNUIhvPsq17TYHs3g9FpnkhquC87St7Ka6vLCzmnpQJQUNnNcbslJ5zSbXMZXfOUOLByp/4cDZ5t79zYUZ7y0ORtO7uQd416YlqqB7PnXhnXeKf2NGuyMuRuG6GC+9mIflUhFtAOY5Gg7mGU8BfMjau8X8F6QG89b04iMiSf2DDiymwx43ahhfsKxMT00fbTXvRSUwRewb9iotYIYxHneh00aJr1pymKfTi/qLgY8wIo+W6cL/rOrupgubW5591YLW1MXLPUigmn1chkWzbcZSE4I
 o7DbHneg
 KkkFcIVxl2nRz0a0ns73raHT9DoI2SA3ktbWbNbpS/odMQFd/82nFo447JKkvtmCY6GqJYgKyRs2kLyjClhsUiNQuif5ttcbazcNk1efdZUc2RpG8+6h4Pn/wL3rE52SDfOQpl/sRuNhUuJzCeIax50wlpJA5dBurDleAl7TOPrnJlMxSVg2UQ8G9eLi01kcG0Av32hLovzXALNXEcG5/buuRn+2G7DLYxsc2W0PwWFItEbx3DWzeVfThZyeeFjqxk92btTae7G7HpJYqOQDPaY7NgItkgL9eVzpfKK4UR2XyV1GGL23JBa5I6rqGCdjmMFQUs50W3lD6ZBSTEA3PbGilZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Once we refactor move_folios_to_lru(), its callers will no longer have to
hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
evict_folios(), IRQ disabling is only needed for __count_vm_events() and
__mod_node_page_state().

To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
mod_node_page_state().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 223d584421a9e..2a32dce8d8394 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2025,7 +2025,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
@@ -2171,10 +2171,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-- 
2.20.1


