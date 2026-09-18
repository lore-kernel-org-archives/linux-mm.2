Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610A1C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E786B0096; Fri, 18 Sep 2026 12:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2286B0098; Fri, 18 Sep 2026 12:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604B46B0099; Fri, 18 Sep 2026 12:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C74D6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:56:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC982A62E9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:23 +0000 (UTC)
X-FDA: 85227486246.28.A7839C5
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 195BF40002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aevWjTrC;
	spf=pass (imf12.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZ4B6fQ0OaE27qFChHjfflbajHqzh3JOUdhhP8Vrl9E=;
	b=I7v5t5Pv3/wKWG5NYDy+d8mSyXVk/XbUMG4hbjU0+wCRdPycvos86VLbpPeOkPrMIZo1X5
	e/avQSuHuChQa7kT7FhI9x/S2jKeHqtPyrwLexj6zLDSSoYs6unW5CMkZ5/R8/BSDTCaWb
	1dU7S0pK3lzwmBZghkeGgvc5GJJtJjQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aevWjTrC;
	spf=pass (imf12.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789750582;
	b=grDjA94six1BgJhIt0bspVAp0tRXk8eWbPxZTyBPrURflFOMHGH/i3moy0yX+0U61Srgfw
	xX58o/PE1rl5rksnhX0nulvFgP93NiFcXFPmwnV7M+yufbnJP85ZyovTe7+8NhPjxwV/0i
	zq+zPDIn2PlJk4+S6RVN8pvo8ruTyw8=
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddb44ad1c1so10264635ad.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750581; x=1790355381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZ4B6fQ0OaE27qFChHjfflbajHqzh3JOUdhhP8Vrl9E=;
        b=aevWjTrCIhN76sqmSI3lASFWL+8xhgWAR4d4avDpy7f0aSIOUSM8jmN7ILIGJaRuNl
         SQBBQx5PGS6wbICU2Rm1L2B6cfFUjjmMqOJ4wv1BEmcVljYZ7J87BGY4gNdzQM6t0w52
         C9fqqZ5DItKudQKQqnmJg3gzii98f5B4autSi6D/QiuNH7kp+9uyC+/oKLh3vcWEVbvS
         XL5cJUQj4MiYhwE6+MM5a19gcO7wbN97Ca3cRtrHtKHCYGJxJwWu2o+Tf4xv+otn+djM
         wWuNToFIdepC2JWlLrxO+SRJdlxoNlvMQ6cxh4NvGwAyMVdPvRiH3r17Vsb3vJ3byATu
         XnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750581; x=1790355381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZ4B6fQ0OaE27qFChHjfflbajHqzh3JOUdhhP8Vrl9E=;
        b=Imd9wviKvx6SN2LwOreFs6uY8TN9jnUzgkhfiApFZwGKdRD5xMSjeiUhENENUABwyw
         GmJpwfE1+ZI7tRiUP68VHusr194lfbXZRNWo9N5cZiIavaVHZ90dQx2Aw2fWNVcxN3oj
         GF0bCvy0tdX7uQ4BrGzquJHHdE5GmP/pWK+Lw0Pc9/5xoanUxbg2GlIgCyvw4SpRdRF7
         w4p8P8basv+c6+5eQXemPoAZXMXXXGEMmhPjtdzVUFCx4sC6uNy4cQ8lm7PW+moN0m5a
         k5v4M+q/MA4wBhXyNd5kdKIvqlrnAUN5cQCMV450HpXq3d2Z3/7wqrvGg9zliq20J/i+
         BcXw==
X-Forwarded-Encrypted: i=1; AKwUvBwee+1bvdMa14ZNf79YckX+wdqnAyk1d4JX6rGu6CkjGv1balVqx75piETZSrNKi6o4QekQKhcwWg==@kvack.org
X-Gm-Message-State: AFuF++nShbZPA1KgpmQl/uaPptWWfhFyo+eS7n5CenzgvQdNwPSBF1ci
	V3ln2MTgYuMSUUIwaLH71mhDeWwKHotTQrQ32YqWVdxxYkGcWM5EBdk7
X-Gm-Gg: AYBFou01DCqhxORT+9w3d+915t0VXF6Mzxg01azD2evR40BpvmbKAgIel0XzvTbQjU4
	t22OoW3YCMM2oc/8vLFArFpszvW5IcXGeJZ9/rT0+Yem6wq2iUvjnrR33oKY/uLFuPulplyKD3h
	gxO5PdxxYtQlEGIS3+nSNsaCtjtFFIREdreXq7tUXEpd7ig0j0+8K9t8kdf2+ZBQ6elyiK1R0gx
	a1M0XOkon6+cVL4s2GbtE0wEiNl7U1X2SmFPtB9S9jPalPbFhWoBkNTxG2nr500JBLudDeh5xZt
	DbhH7OSTx3KTSKHVW87nv8sZ651uWPJODFFEOI9S0qGW8icb+id17ooW2QD5WISCKO+uIfzl9IU
	XMQiO4f96lOxxDX3uz/XjZ182DU4121Gr8HsDZhX2Q/R2cZuNKNcz51goeu/zevHgOt8Xdz3mBW
	ZPmoXGG4RhDODsHd2qBR9SBvb00FE6qBOd6lKQlH0CdpFgcbsOFH5iY3Tjnj+ap2YN/7AsOzO5P
	RA=
X-Received: by 2002:a17:902:d2cc:b0:2dd:ad73:c982 with SMTP id d9443c01a7336-2ddb1ba0faamr58779045ad.26.1789750580884;
        Fri, 18 Sep 2026 09:56:20 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
Date: Sat, 19 Sep 2026 01:55:58 +0900
Message-ID: <20260918165601.1014666-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m8prxqj68p3ow69eu99me73yodqboktx
X-Rspamd-Queue-Id: 195BF40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789750581-320968
X-HE-Meta: U2FsdGVkX1+tfJXKGAs1G30G66jrFQeNLXJ2Vn80AIXocT2JQ6SgTTw2iEb0kzVn8xg4OP7iVXLTzgs/4N+irxfcWT4feLsbuK2xO1BZOYcWwdWIayY9gjG6vlxJy7SpVXBhKDbdF4yhznUsgXcEoF6AxRqhJQb7PMBUveXTuHLOZIBx6Q/sDNPpE3IgS40fIOBQRkHtoVAqWlUZBxB7y02TZasy7Do5nA6rE1VZNxyLEUE5gAp6OsalDZPznWirKzvrAIjdlUb07MQdDMG1DZMfF5Rj7I2pqQosB0pyIGTK3T0lopy8VZOBCk0JR/vRcB48raLnwdEGP+HreFW9hPLYcMH6YmfPxr2KNZr71giZVzYNs2Vx65M0JlxRoOlO9+S71a5tHMv63pZx04XRMLvKZRaJ8fWO64a4+4KElwSjZHVV7w8lZSiyj8GQyhrlxgjkeRh9Qzj0E+7TibJtT1KGJWjIThVs3A+OXQn1BSW+0CWf1M9QpyKj0rntQFxKNhBTqTcnJnvXFVfIicEj5sp95ETxsplmQexBSeven+laXjz9T9y7J5iSmw7tuJiv6lLUarAB0/bF0guOVLuYTAku7VbPYbTwJmoTsupsxsQAQjPSwz02ZPmhBoLB7yOmDeyOVAzkjIyT61XFPnF07K9iNP2S58V+TUrK+ZsteWLT6rEoE93gBp1tRbF/s7v+7FaYoIIcpW6ty6dasqJ8CRvKmtYvCA5CgxGOid8GIx8ocb+T7UG1CJQ7RfpF0/x1h93+zJNg8XI/1flefaxfLjJ+BGgTPPL6EW5JZ5N80ZjkOLe1oWr/EykFUfSbLqf8l+d/5Npz3hbXHFhNj0xMnZztCdKyAoAu0blhUPJrVeGcoWjZWewwebJlJNsYJBDmEPu/T+hGuyhk3HIsHHkn8xsPq2EPhCirZ4MUcXSBO+wp5K1O8OTh/2hE1EMHuEm4fIntluvOg18CPHY/X5w
 bqtv1fTW
 7B+RNzvQ/k3Wd9sSAWnwz1QsU+16E664T/kzF0C+lXw/GxPI46iamd25Kgvbs8jQAIFu+ht50Sq4M0XbJHwpasq8JA7MWVLWikkmsin9sWtiPsVj1VytCX4WkWXN+MQCJl0tYWuSO8wvfeo0mGkEAm996kNDnuSsbDAFkCsUlmFUv3eYKRH8L+SM45Mj0SnQqXCV1MVaiZQYyjxhtdGPWjLmbvcKORTNzkmQt6aR0VK+xfOv9TVg29WsHQMbeJxwTjxcbzV5bpOv2XhuWCETDEEgGrhBlGMQfrj9ObndRv8+QabXmXLCwc50t/LUGfqsXwrrw8fFgSSLbcMObscvWjdsIRLVooaWKWvYzhkF6RT+SwT96ehmVC/kD8l2He6IdkvuF0arZ5Nm5TaoJVXS8UcEfOKCxBOlrApifgV4jY2dvW0X8jE/r+8/j5zZe7CgbV3VmgF8BVx1yfLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
vmstat counter"), mod_memcg_page_state() has no callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/memcontrol.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b57a74617b0b..c0557e1e3d21 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -949,21 +949,6 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
@@ -1396,11 +1381,6 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-}
-
 static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
-- 
2.43.0


