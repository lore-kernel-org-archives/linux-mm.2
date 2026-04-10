Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9E5F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1F46B0098; Fri, 10 Apr 2026 17:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293006B0099; Fri, 10 Apr 2026 17:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AC06B009B; Fri, 10 Apr 2026 17:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 066CF6B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D458E1B8511
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:56 +0000 (UTC)
X-FDA: 84643883352.29.827DDA4
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 107F740006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EIGdT8Ly;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPucxgysmex46OWvxebyn8gwYFbxkYWxk7oOg4s3POI=;
	b=ruIyGaCuxjgi9Vv8a0btMlR+SSnO2DcPKqE9OTYZx3xXrsq3QT48rx9NIwnQFKT84KRCAT
	lFOXNOkM02nlnV555R5QaRlOnbh7O49sc+XxtLCD3491V3NPjop+xkz7Ry1cV4kg8+t15H
	RsTXiCVh8BDi2LsDdcH29l7GZF4m3/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855275; a=rsa-sha256;
	cv=none;
	b=lw909FHdLwy5OTwzsv8Vq8nVrnZgrgwXuruYfMCW8MYeQejM5M814ek8ugUhCAjglSQb/7
	9hcOw8U59qXPhcOys0H0v7uZ4z7fF+rl3e/6VvJT17EI6MmK+GNIjuFLnU28djhAPVlSgo
	ZPQYP1nUeXGoCnqyrAx0LasaI7BrGNY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EIGdT8Ly;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7dbe437b072so1375469a34.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855274; x=1776460074; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPucxgysmex46OWvxebyn8gwYFbxkYWxk7oOg4s3POI=;
        b=EIGdT8LyLrgMplUfRPxz7Rz5TKcG5Q+CXtugGhCPjDvwHJPDBkFdFLlyVmyqtjHEVc
         uA6+reMeevLz2LDb67fS5e89QlwtGDdz6nNCnR0Z79xk/b6W+fqJ4+/Zx9PBf0Nfr2pT
         nAi/8EFXfCkGGFVsZdii/iDQkCLw/UCxggJLTqee5I7AMns87xG7Vu2+e2oBdP9lOIbR
         3a15hQNLtQDnwOW5JofuPZeg9zUM29tI3blFJTmPYOJzAhjwsOStvcJQeCOqesg9tYt1
         CqRFp8GSutVYKCeu2INlC2PJJapi/AX1bI6r3WYwxx9btw42vJuxsYMbFBYX2Z7a+88E
         8UbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855274; x=1776460074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HPucxgysmex46OWvxebyn8gwYFbxkYWxk7oOg4s3POI=;
        b=SpylvRJxqzMO6dZs7XkVpPgcWxAoF6cS/tOmwxhqiveF0dT+W3vFMNGvxoB8iGlaeC
         ouuyRYut3PaW4litp3f1DQcV+pjTkY4mW7K5qEOWOxfUssptryOKxPjHyoEzPOt6wPss
         devWucwm3z3ODQnlbA9eyQ5zlR9ZeutbcPvTIKmU/zYYyrfPfd0mEXbLVXLosmUlXVNl
         GvzBI61nWJ/UyIgRs5X1bUUl5Osay9fgHQxL1uP8sbNFBH0Td6IXO6fGGsdcVN9I3KUJ
         8kP0wkx03XhtfTwiROX+X8tNt/Mox5ZVw6pIl9DbvQLerg4MpN/v8PQrSVY996lIeeI5
         w2jw==
X-Forwarded-Encrypted: i=1; AJvYcCV+QsspBa/ShrOhrW+8gn23hqOrByYmi+d82/z1omsiDYTqBuxIajGw8Iww1pymEnageSrnlt5eaQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7b2uvW1w9HDqerpoD8nofVvwKX+udxDpAfw7CSHrP5bpm8geE
	sNkqRpTC12Jh6WFG0t38zCtWfcUN41rhpNE+AKU4jfb7TLwFr0Ng7nYY
X-Gm-Gg: AeBDievmzEF4U1AUaibDMB8wTQrw5u+HSsY+/in6wvnwrOolrvKRStMNEyMqyoD/LdX
	j04k0j/fi9MPVYlyST0xcNBPalr5GclcjRc2DfVWrSw5xBnRkaa0eCM8SBNd+Izrxv1WtOzwS1I
	L5cVZeVgV12JZIZ6cGQd8yZbFMU+Mb7B+PYzPpAb/6DTcPh1D2w/IozKZyliWi29j7NI4x6banm
	uDwtb2loflvHtHiG6lZaE/ibPzDxK1CjFhvDcyRkn7IAFQGiExS1ArGGA+RNZPTP+8gdWHm6TZY
	wVQFAGMCxbptLvnR/CHbNyGICU6Es4PrCx8gS8m4VQqdeFqX3+L2W6pOtMlpnUcM/5HOKUQQkfS
	swMLSzgUMqOQfq2ze6TpdtAmsh6cwJ6kDikaLx30VxmCdgW3MbLtYXoxkbM7t+401lTmikKfTH6
	IcmCUNho8tWHfW+FCq/apc9929+QVoOmOh
X-Received: by 2002:a05:6830:828e:b0:7d7:5113:f83a with SMTP id 46e09a7af769-7dc27e4ed34mr2752617a34.25.1775855274137;
        Fri, 10 Apr 2026 14:07:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc26576d30sm3085434a34.4.2026.04.10.14.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/8 RFC] mm/memcontrol: optimize memsw stock for cgroup v1
Date: Fri, 10 Apr 2026 14:07:00 -0700
Message-ID: <20260410210742.550489-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 107F740006
X-Stat-Signature: wagyijux4ecs5nkct6aj3da8fnppnfdc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775855274-529260
X-HE-Meta: U2FsdGVkX1/SEkkrqW4LhOUkMbF+NOGH/CstStzl7dkRRgL0tsBUTHoZAAy4n6uhPWnD1C4v7LTB7hoK5cQ7R9HUN5CWQ2HHHqNVjsBV9YBpSG814Q/yvDNOJXapgQvzOdJGMWuVzenKAutwBz09rxGf7K44tiGQo/ZoJypbOJEE0w1OezljqtOPGQA9dUzLDuvm+tgWwaa2No/5UUeqnSN1j3Z89cABCzyHQZeARdeTZUsFfUNfr6SP1wvc12JarUbTz3ceTFZYZxmLqS5Ts3YhHDUfB82CnyHqUCiM3FMYrMkfpFxEqogu6a/YaaOe6WA14q/GcrfcwlX75ZySGsaO45Da/+YzZvriEy5R3YQPXFsitfeLyxjpnw1d6tejJ01T1nY0bNRv7EqvQT0ZV9vPAbI5Q9J88Uq36cA2VhJRJaURCV/TDJ3ckbPe6IdvM3cEySZptax+r1lXbOxeS3dmTasN9lcL2nV75qSWqM52J+BSSTdtHROZHNvZJ10do/OoPiMMPD+FcQQrW2XTd5zz/AqjWCEfI/Q5+qbPrzWRTd3HQNwRAFRijgaoddUzW30Vr3vWn2++WmuqMb87OB8UAAktzVj7O3rIZeMEG/dlpZP6LY5gXWJvH7Ri3xIYrXky+jAmvIVBuDNadDhrK+zGw0aIYoFLvP2QV7DWx9UJ+s+l7ZwCMYAT4IMwG8rLjrURhfbRPh117Zz7H92egMZkeLMIJ24iobe9ySvLfBHDy+wD9yJ4XKUC6CLf+2NCauMgDn4jUn9UuOJvXUpvKr5GVmoqS6mgH3cR6IAPOHrjMUm1/BVbxz1A2OO2reJaO3s4+zNtuvRDKo/fO1Ft2vijNkRTKky5Lsmi39mzSpI10zP3khBHDs9Ns5i7vMBQwtBvRJ+OrNHbRYoNLkE6BGBUpOIPs+k+waHFt+JIuuZ20z+l+oyS7p1g1jq5rTAEBn+GaoAjYGE82EBWSnA
 8EfSZoBL
 3IaZdlG7X+W2LWRJy2GzpJGsvEr84z4+hUGNk1O/ONsV1tMQ963IksrZqQMI9/SAc8AkuBZtwkF0Iit3fr53r9PSUFi8l9IgUUmy4DnjsA3cCR4bV1Nl1UDk40dq4sY3lDRshLSWhmsCJDMnO7zeoZes10FnklndWe5lZ+fFJuY3hRBkkc8XWG18WfA3K5nZGW3hnFL8SFy5aV9wOSoAAj8GGk15b+Tsqjd8hng1nnpzsicUIkW732DFyAqigQf+3W4opojk4n1n5Qj9e7SPDY0LVMfYMQD0nbRVAwWOfQEqWSD9ZiCb0oFwwCABYKBlOCzRU3gO0muSTuoJGIGCao+rxZLSNUKVIq5G4CEXqyzH9EvyVr1qLFfCJhA+wZCecIzrkCqi776ktIOjNkrKmFvZmITN99+2g2E2G7wrT9TgIBVlpimYMWmzdLBKU0DEU2ZAxcyZ83Uqc1UmjZs9bKAPQoOORp4Q/aonud9OR7rs5m+ryuLTsWuwKGAR3O1cxUERAbcnjPwdACCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, each memcg had its own stock, which was shared by all page
counters within it. Specifically in try_charge_memcg, the stock limit
check would occur before the memsw and memory page_counters were
charged hierarchically.

Now that the memcg stock was folded into the page_counter level, and we
have replaced try_charge_memcg's stock check against the memory
page_counter's stock, this leaves no fast path available for cgroup v1's
memsw check.

Introduce a new stock for the memsw page_counter, charged and uncharged
independently from the memory page_counter. This provides better caching
on cgroup v1:

The best case scenario is when both the memsw and memory page_counters
can use their cached stock charge; this is the old behavior.

The halfway scenario is when either the memsw or memory page_counter
is within the stock size, but the other isn't. This requires one
hierarchical charge.

The worst case scenario is when both memsw and memory page_counters
are over their limit, and must walk two page_counter hierarchies. This
is the same as the old behavior.

By introducing an indepednent stock for memsw, we can avoid the worst
case scenario more often and can fail or succeed separately from the
memory page counter.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 27d2edd5a7832..6d50f5d667434 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2245,8 +2245,10 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
 
-	for_each_mem_cgroup_tree(memcg, root_memcg)
+	for_each_mem_cgroup_tree(memcg, root_memcg) {
 		page_counter_drain_stock(&memcg->memory);
+		page_counter_drain_stock(&memcg->memsw);
+	}
 
 	/* Drain obj_stock on all online CPUs */
 	migrate_disable();
@@ -2275,8 +2277,10 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
 
-	for_each_mem_cgroup(memcg)
+	for_each_mem_cgroup(memcg) {
 		page_counter_drain_cpu(&memcg->memory, cpu);
+		page_counter_drain_cpu(&memcg->memsw, cpu);
+	}
 
 	return 0;
 }
@@ -4111,6 +4115,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	/* failure is nonfatal, charges fall back to direct hierarchy */
 	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	if (do_memsw_account())
+		page_counter_enable_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4175,6 +4181,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 	page_counter_disable_stock(&memcg->memory);
+	page_counter_disable_stock(&memcg->memsw);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
-- 
2.52.0


