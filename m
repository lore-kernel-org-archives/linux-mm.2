Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCC6D3C920
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 15:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB4F6B0005; Wed, 10 Dec 2025 10:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66ACF6B0006; Wed, 10 Dec 2025 10:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A416B0008; Wed, 10 Dec 2025 10:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413796B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:43:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D89EB60388
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:43:14 +0000 (UTC)
X-FDA: 84203980308.18.4B6C557
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8C7D40003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:43:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="i/rhQmCy";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765381393; a=rsa-sha256;
	cv=none;
	b=PjUgjL+pVHCtU7mabEfOlqX310KCl0fQ8GArz1h1SHo5TMrkIWRtryEPCljkhlTlQAK8PT
	JN2fqOHy66NWsIbwhM+BLcdw59p3aYVkelCvmHM7oQ9b0tdkgWwL5EVwFe1AgUE/agFNx1
	dK9VCxGwCQUw3LzjGtwEdKHFdJwmJqw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="i/rhQmCy";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765381393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RK4QBOSJ1ETPPkTsE5aRaLlAhXzJmTbjPxuvjBfxx3M=;
	b=IBNHhaV05e5g/LKor/+zf2T8IjWOQhyNIplr+tXUTXC8TUKg2eVo2lng/aaXU+dq01dgUT
	TYu8Xe4u9MgvwOB3+Vv5tf0Mv9HKKIYnbn8RDNS4AV2p7HJavh1CXB615bFYz+/qoPCRyd
	iCtPNoG9hZStntpcYE57TrkgN5Vzgso=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so20616671cf.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765381392; x=1765986192; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RK4QBOSJ1ETPPkTsE5aRaLlAhXzJmTbjPxuvjBfxx3M=;
        b=i/rhQmCyTFZ/dYojsgPShDK+9TLdcMwhQ2fD9ZeMymjj8Ha5Hr3D09OWSlMyaCrThL
         M8Oqp28GpqZWhdgfGVTHqaQ/uQjocUbcxTLph6ubrcEOwYaF0xPIx3zcSzNrwdlVFB8u
         Hru4h1E82X0t2LGPV1CpXQgmjEdxQnHQKbxP/8xLcxhLqhpu4WAhHqe+wlAqbZqNwxrr
         pQ4eVCdxFwFlJrB8SmPkq6V2k4WZI36R1rYJuCCsLmQIlG+YL2QLe/u7FREbXEWnCHvV
         R5efribEDyXwDG8ndHzuOHu5qlDjw+UZSbpB+O/2OPi/0eCoMy2o7Hr3mzkO6YnK3RkJ
         Hojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381392; x=1765986192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RK4QBOSJ1ETPPkTsE5aRaLlAhXzJmTbjPxuvjBfxx3M=;
        b=lYlSfIcPmhDpUQHjb0qnEKeZ/VTYmUqVpiweICHY7lqeeQmfc91LRjYMA6OZeeJ3P8
         X4bDxSUZAf6HVeSNAtz5kouaOsO4B1iDufnOXs9pxKsx+OeSwalHvx3TX12cmIKhpD+2
         GTwZCRIMaEutS/6ipjukeY/Vdims8h7cK/Q9Yz5eegTm7ZV0ffqKB7Bvg4ULzrC8MpSn
         r/69PKhrr5AkmZDQEGkaHT3Rn/3qtNt3e2LWKXb7aVt+zf0YjJuiRwJU4d4gw625m7uo
         Ifw/moN0qRYef5SdzqOqE089gJYW4y1Quw7ON4cDbnDvfIe/6z9JwmVQCu7Pi1tpn76B
         2VMA==
X-Forwarded-Encrypted: i=1; AJvYcCVApSU2UkMBg3qAAl7LDO8sd/IgNggmKANO6rnRnbWq8hOlJ1EUC5jhsqXMaM86vyS+SYDsQeau7Q==@kvack.org
X-Gm-Message-State: AOJu0YwYLgWI2sxq/gnMYh0ASYnyrtjFd+e/tCcDnC3SsYOW0RhLGNwx
	BITCCSOiZotmUr/URGRXQiodIZraK6994QVy8Rpzv00BMlvSMLugXKCqTKzaPNTfFeU=
X-Gm-Gg: ASbGnctM9vUctK8Que8yCybLkPngteT6gaAb7hH79fWowk6Cx33LpLNuiJiwDsKtEH2
	t/KW9iT5rQaF6a+h/JUKIcUR4Zh/v25SaBU+9ndgGO73V9qVkim0WXnHqVJSw1hxqZ7btZqgjVy
	tAnGhn+xlDjVKFxa2OkS//AqLemA6ZovBN6bTp6NFFUUhebkO6E5NjYubnVItlxhZSeMeKh5W/B
	2/ajS/cSlMMYgOrDvJK8MMz+FBftdDQ1AXIyxBKYc6jctf4Ejxy3qwFx6OGPqrUh2iNgCAi//GS
	XWvIYicMEZG0Cke1Doj86wlxsj8fGg9i8dGYZ7bQ1mGEKKICj2P2M2uaqvw7qwmzS3Tf/p/ktja
	QNvat0Ao7AhFS16RliAIggs9dvJfy/qLwF6CYr3I92qvhqpdLhYgXCa2CI2sZ10gbNNMdZeupjb
	CFSk1c2+W22Q==
X-Google-Smtp-Source: AGHT+IElOjLE5rbcqYu4F/R+HCfn9jPxWZdNKUhuhWsu8mUAZgrglF0s2qhg7pSLqr7FMjuEMrobIg==
X-Received: by 2002:ac8:5d14:0:b0:4f1:ac12:b01b with SMTP id d75a77b69052e-4f1b1a7a156mr37209431cf.38.1765381391629;
        Wed, 10 Dec 2025 07:43:11 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-888287a56d2sm162353706d6.29.2025.12.10.07.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 07:43:10 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: memcontrol: rename mem_cgroup_from_slab_obj()
Date: Wed, 10 Dec 2025 10:43:01 -0500
Message-ID: <20251210154301.720133-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8C7D40003
X-Stat-Signature: 8mcaq6zame6t5rbrsyfatg8nrud3jbf6
X-Rspam-User: 
X-HE-Tag: 1765381392-536407
X-HE-Meta: U2FsdGVkX1+Mu7ldqx1UombI8NBr4KqEHXrE9aVa+BlHQQggJNO+/1atBNMJ9IQ7KZZTDmOn9GvZNzeHlMd/4QwbGkujh9o50Om6n0mtuLxnw3HvIL9CkyIQRfHpUZexn/NYtOwZRW1wQaifieY+bjlVwHQTixg2Dxf/3TBtqcIuBo2ur5MKkoLQ5+tmjf8JitBYjprGYExhHXBtzUPpA3H4TBtinSjgVLBstBDNORp/igiSrfRKCdgIZJGWQg0uyz/khkXRMrZXmJY2kgWzsp6sWdYWRTyz0m6GYoH4++c5JgPozhOzlXHXQ/cJn8wqWiDhF/HMAdDTKnyL/LEoE1AkZi6/4ymo213KBocQvwQ4cKviqV5cujU/pn5bQU7n4oxSQ2dSzJfxgbVf93NJ9P6x30phSGeBn/vES3vYhCvEm5E59TDOQa9NNe3buWvKD+lg7A7GO2lIssWPXFTtE7putOIl1nMZcqOEt8GhAeYa0kkSLKA4V5nLQz6YI8FKeyzWjto6CNIEPfPFOWS1MGDhQWROlR2kr0OhZmCVN1WH9LYP/Y9aOr7kKGSVQddOtZZBxvxTTnMqHbv5esADVikO6+haNKwXK4iN7OBkJWchoXdgnZM/Gnld+6sg3mIIN6qVULhcQzjs93fLPFXyR/AduTP+bsMW3ViBt5+/9vu5CWXFzY2624Imgx/JuknqmTwWs4v2RGM9HZPAf0bmtu4M3HKHTOCAeTOsO+oOYLUCwugaGVkOFEo9Up6C2ziWmd3Xi/JZOP1MLSAdykHtgb96joWIwXRx3gc8lc2fwY2EgdFJ3CiYFf4+arzsffb60dkDXDh+Tf2PTNV3jruUGn8JzjmetWckp2BbnD2bcbyuLgMUrZT5ul2Y3sCs/jymaAEG8zMP+wgyNcyOGzP0jkJvSOV8sKyRejwUrEgJo5YcxIbMIUCSYqVGb0DObP+6dpMIBsZRrHydxamVNji
 3uDX+DjX
 6jVZ3lNqdFvbIJ94UJFcKEjOdNtJTOMNYCkNP2undFPCemKOmOcDfupSy2jtMUZIMylTuYsp87Sk96nDJvy7EqroLDyK54/fAWqJjf421UitxgQaUNQudk/iVxf4UYaDAQ+pBQ6mCEkDUDbiWXTnXXzArnmaEVtBXclQ1llhAOt0TF9vLd7+0uIrVb23rEbttBwWKUCs7KB3v3ZcpJe85pMiXmK1U4yCNroOWCe6lD+S+R4eSC7xjg8Y1dA5+OWlc+Wyxumw2JUEUkREFl5lH8uPP8DIKtzEjHJoiQH80WcMgiBftsH2vPnC41A7TeBfl6QckO3iCmtWx1pHTFDvXr76oUUphcRMzB1ZOOSULQpT3bXeWBVRAp59UvWQOSCSEJVzwQRmMyl0sW01DvzyUDlIOEbahvAKnII4hjn16PFps95ud+ppRC0+vSjeLGMZjV6K2QIX/8EuAP3EhTb7A+wOUUy8DXMlR/EyBLpOn80Sv0yg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In addition to slab objects, this function is used for resolving
non-slab kernel pointers. This has caused confusion in recent
refactoring work. Rename it to mem_cgroup_from_virt(), sticking with
terminology established by the virt_to_<foo>() converters.

Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 4 ++--
 mm/list_lru.c              | 4 ++--
 mm/memcontrol.c            | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..17ad5cf43129 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1727,7 +1727,7 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
+struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
 				      enum vm_event_item idx,
@@ -1799,7 +1799,7 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 	return -1;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
 }
diff --git a/mm/list_lru.c b/mm/list_lru.c
index ec48b5dadf51..37b642f6cbda 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -187,7 +187,7 @@ bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 
 	if (list_lru_memcg_aware(lru)) {
 		rcu_read_lock();
-		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_virt(item));
 		rcu_read_unlock();
 	} else {
 		ret = list_lru_add(lru, item, nid, NULL);
@@ -224,7 +224,7 @@ bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 
 	if (list_lru_memcg_aware(lru)) {
 		rcu_read_lock();
-		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_virt(item));
 		rcu_read_unlock();
 	} else {
 		ret = list_lru_del(lru, item, nid, NULL);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..e552072e346c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -806,7 +806,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_slab_obj(p);
+	memcg = mem_cgroup_from_virt(p);
 
 	/*
 	 * Untracked pages have no memcg, no lruvec. Update only the
@@ -2619,7 +2619,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
  * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
  * cgroup_mutex, etc.
  */
-struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	struct slab *slab;
 
-- 
2.52.0


