Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC72E606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ut1o4jiM
Received: by kanga.kvack.org (Postfix)
	id ACB446B05B1; Mon, 23 Nov 2026 21:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C3C6B05BC; Mon, 23 Nov 2026 21:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B90B6B05BD; Mon, 23 Nov 2026 21:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70BB36B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:08:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4CA1A0ACA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:08:24 +0000 (UTC)
X-FDA: 85468378128.01.3C2E431
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf12.hostedemail.com (Postfix) with ESMTP id D69AD40004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:08:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ut1o4jiM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795486103;
	b=10yZi2dei2kSvWa6jHKDxHQqIKsIlSojKHyT24VDSlbeml6Irh+ZHzMm+csdVMXFJlshMr
	vNE7VicPKGJFt/kjz03E/vZ/uDPV9Q6noMRQy8FeI4VONm+ZXfTlu3xowi3M/k1SBswNMT
	t6o2auJCOiQEZg+FMESEEWADrCD6lkk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795486103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0AqVKsAtdki6JZs+byxSKnrQdzA51H0wzKx3ZaPefvc=;
	b=P5rxd2SDBwDN5Y2Kl/9zA/B1UOV8015aicJLcX4zT118QByE/tcyR9vIetLTbDix2/GyRC
	URDVMCNlPm84mOFNYvodb+NnzkwX/ip6G+Yty8xCu0VyvihEWiAwc7yJV17fK6wNOXsZap
	jZyiYwPv7E/1q6jfcS/+bfoSe8CMtV4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ut1o4jiM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IBL50e1Vg8pdC8zxUxK65YEfsAT24ECM54GeoK/ohd4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795486101; v=1; x=1796090901;
 b=ut1o4jiMuOx3ZVaV3U7yzS5Oy1dxpxwxL3H8yu9Wb6NBxcn7d4KYARI/6iFxmWrLjpNXsMRp
 30/i6aKlPolOd8rkgwNpLdMYgZpejUz0pg+B3MJ7rtSUSRjw9zJgXmgWRLSeFS6UaicD27fY2V/
 69yuU4e5VV/f2rT7aMs+LG/k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 55ec52b9cf4f09b8;
	Tue, 24 Nov 2026 02:08:21 +0000
X-Mizu-Trace-ID: 55ec52b9cf4f09b8
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: warn when memory cgroup IDs run out
Date: Mon, 23 Nov 2026 18:08:00 -0800
Message-ID: <20261124020800.2313930-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D69AD40004
X-Stat-Signature: f6t3tnnn7e1f855umgwzm6shdbh6ttp6
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795486102-157132
X-HE-Meta: U2FsdGVkX19scsCym1w50N8AGciV/3Yg8m4l2f+Ac/f4YizMzCtefl3fv3Wk9mU0PmFqZsUfYQarOMxpypIfakrhOjXa1tm5QlZdnR+DSm/aqVF/o7TegUadl+X1D7I4ZL5oGLPPEIkmvby7X2nbPDJBlAGHkKcvHJOmGFw4Mk5qb/ox8mK+5tGzi+NTPe/pJCiwAUEsMP0sJQVdHcWERySaNRVFc/VsWRWPZ1nFigLfDpHez/sHaCrJObQA60et0uKp9Ar1VoihEans7N425wU/35syrFA1mzud72xKEkrbJx+sUBlmr0oECP1NjhGMAmWzglfyl3juXHqXR/pTsMe3K8C9EN2KageJyDumwcDpgXuu6Xxl7C70a7hdZ038ooMTab5qmPlcdyDF6O9lxAlg6hEtguNAhCHSqDxsqs3g9PWPZjZ8+V1f8wAKHZgpiG4HMZDGSPYch4wYm7sgf86KgmZHq+syJYqyh5/mRSIJSN9EnM072N1/isjyukNFjLRRmoHWmsSWIixbyMJ8rL4jYaYp8QpcrRUu4bgOWMzwHA69zjBCP3l51zEB5CboBglAqgInEy1INLRvIMTMjpVULb+GD0gqos2JnPLHtYh5cXZuRHFUsPMGRU9EAyu2zxzS5aPc0EfOo48xZ8h8WJIIMjYhOzlgR2gWcLkSP9uohv+v+xygUiN0kgzemvRvsyhbKpG/isZw71S7IQpB5f40/v8MgxOq8wMREjbmPiHL4rCxf+fJrRLHPd0cjpnXqdE+KBOGsYtNE5NjMwGGE5BozQYzIOTv6dEvfFpa0x8UpUj6bqNJRJdrzlQSs3/H06cizL+2KhVZjCCfryLhkTa8xGIVox64Vu1WrCM1/JsC7QYas6r07b7fBizd5jKr04gZbPH+UHBG6FuiAi0K7T8CykOxigrC4+bwMn9NW1m1AYNaQotWime401DyD6SlF8ecncLIfr8jPrd6836
 smHaSjSL
 YjHIuud7MWIIEDj1fch4cgIGlqyiFq74o8mvKxDYm0qp7OPgN747yvzQQ5pDI2N+ITpa4S3dFFgEPoIKKMgBii5eQ2PAdFlQuVSx3WNkyEr0OjVLdDqvsNXIGHvdxLSa6mZg59KlsP9QzeoInY5dTAj7PJabnU+tB6i9kLwiczRhAAMKBtebQPKaKl/AnFHfwa7O+CNhxo5M4wbco3uhk3iTApoi0LJUNAoRAGhUQTw7z7gnrWH3BJwxEaEmJXl3DC64MigBdd0e0ewUtMJHBNZGKt41icEllaENiUHKQiTTPei5mb6GwQG8cp430z8Eb5smMYFyCKrY3PD9xz8IbiaFKPLx15GhkvbAITgKpZzLmH3Uw8Vy780e/j+/WAYpHH2+EE2Tg/2FLp+tFEr7pxwSEMDp0WDRmSV52Iz22WgJOYhwTkJ/LXx/tqQYcv5f9c8KZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memory cgroup gets a 16-bit private ID, so a host can have at most
65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
as long as any swap slot still records it. On Meta hosts that create
many short-lived cgroups, dead cgroups held this way filled the whole ID
space. After that, every mkdir of a cgroup with the memory controller
failed with -EBUSY: systemd could not start units, and container setup
failed.

This was hard to see:

- Nothing is logged when the ID allocation fails. The only sign is
  -EBUSY from mkdir.
- Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
  objcg"), a dead memcg is freed even while swap still holds its ID. So
  nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.

Print a rate limited warning when the ID allocation fails because all
IDs are in use.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..206c910cf3dc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4271,8 +4271,12 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 
 	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
-	if (error)
+	if (error) {
+		if (error == -EBUSY)
+			pr_warn_ratelimited("memcg: all %lu memory cgroup IDs are in use, cannot create a new memory cgroup\n",
+					    MEM_CGROUP_ID_MAX);
 		goto fail;
+	}
 	error = -ENOMEM;
 
 	memcg->vmstats = kzalloc_obj(struct memcg_vmstats, GFP_KERNEL_ACCOUNT);
-- 
2.53.1-Meta


