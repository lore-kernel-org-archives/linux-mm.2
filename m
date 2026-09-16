Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73752C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19BA6B008C; Wed, 16 Sep 2026 17:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1C96B0092; Wed, 16 Sep 2026 17:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92906B0093; Wed, 16 Sep 2026 17:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8048B6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:06:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9426B1C0852
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:05:59 +0000 (UTC)
X-FDA: 85220857638.22.E039866
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf27.hostedemail.com (Postfix) with ESMTP id C88704000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:05:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P7R2v17b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P7R2v17b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592757;
	b=m/RDlAQCUGFb9E3PyTOWBXs9K0wLINgBldwVkPRqRCkc0SQOSFQbLwAIvzAr1rofg3fjVJ
	ihId/uqWf5vuDUzXqZODnivq0loCzVoYFhZhIpLM+6QhvUK+a79Rls5Cm5kLkGacSRUjse
	ym/5gPXvdr+hR6DWXN8m4ESfrDqLqUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzgD7tpJ/TV5FYPH6ulvzWsXqYOY3DYINqe8nFmUw9M=;
	b=AY4nqI4pqh/IXdNBkgbBfjMnDa3/cmgTvBkWE8By/VQMfXvtiQHaZYdzO/NfEZGgrBx+jq
	kbeScP0MHMH7rsgVJy6nrG6NaCQ+cMjBXn5baiS+8eI/zVXgwTfWb0e3Rju32EK37zt7M9
	R1kAcZZPx8H4FXJ3Q/oxociRL1MqQTM=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c0776592e3so91981b6e.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592757; x=1790197557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KzgD7tpJ/TV5FYPH6ulvzWsXqYOY3DYINqe8nFmUw9M=;
        b=P7R2v17bAG6qwMmghDKXMpLj1wpSiwoKP3vjh+hBF/ysIZRyhTEHTPAueYhQkLdZba
         b12EIr7jtjPetM9Glwp/DmqSCSgf6BKENsSDCxfOK0Ug0+F72vA3xrAyDHGuKvq8Ol8T
         a4EUu2v3yNF8qHVpLWwunnfskh8Qnz9iu65hu6Rh64qKOXs0CnkioFGK+En3Dz71oV2O
         eJXU98raHRPU2RxlA9ftoQdjdUUaHzFqM0i7F6RQlcdS3n5omjDiWv9JuajFv+7SQ1so
         lcg0gKtYyNEK5GIk6QunghzdqN6WxMTRanga3cMCKk9nGSWkUI3Apzjgu7QwU5b1BEv7
         J4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592757; x=1790197557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KzgD7tpJ/TV5FYPH6ulvzWsXqYOY3DYINqe8nFmUw9M=;
        b=T+OgFgRKVg/J7An/7H4+nJS5joMFCSr1vCpvkTFz4xYNEoLYdHsN3ne/7WtwsgxXpF
         ty0arZAcAhNxeVMKyGvrZf3NG8y49p91VPtdlvnECC09gJjHKM3ZuBBm9XsETJkjjreV
         R/EblPnQyEqe5l9LpnLXF9i3t6gpW4oropoIbFlWhtWridHOA8y8fsaup6WybgE6Oy+Z
         sOW/CRkZA5GLHCvWa+PantsTNSXtWq2yqWDb2VZRwF2FaTM8N6lC4t+bSGoIRdqY0yIy
         XrPoDjZj7aACLq2KzMXUZJdaIQlWWTHB3/UJ0ntdsSv9QRsPkbfPcOv1jmh9zSAV2Kx1
         yw/w==
X-Forwarded-Encrypted: i=1; AKwUvBztM25YaIbYP+rBiXvvIsuIzRNTU14dJOjz4miTa0vmqrYBESccdkCPaKvvdr7HCsgjbxL6OEqeJQ==@kvack.org
X-Gm-Message-State: AFuF++lHO23MMJ5PUDOs7R1kjz3myfGFeVqvjHwu/+0JikwgwexkgKYa
	iBh6vAeYijzartVsQPBjCQ0SvE78nHn/FtaxlM9gav+pMRpfM8TNu4Kq
X-Gm-Gg: AYBFou2//tKOLDglDFkxNM5fVORnpCgW+Y4CQJnGhgnOxhCKFCYqx1dTXwvs0h9t35o
	mHc1iAY9S8j64D5fUCa3VN7h9rksiy3DAVzZCtPlrwFTgciRHKQ9Cni81QLrgYwbkBixF841c1d
	ibj72R6KYy7H7U3VXtXZ9It4hi62HYsh507gIjFC4QuJYwp+3JVTR/7Rjoo+Su9ZN0rIu9Sxo+q
	yNhkM0DbhEHm4PMfeYHtSPBGEqwYCZTKUSAyCo+A4knUZqVTf7OlY+AkYaMt+ehbSKTzJhgZdVK
	N7jxZl8/LaHfni20dmm90kX/BMZSoF8f4KRnHMpjpL4tncrG+psi4zMk+CHpawlbstmpv/RClAA
	zBt8jcB2MdQ/gADC5ehmkYNmZD00fmniq3F2eJhxVRk/LBwoJumMcfE+dxqEJQHMICwG7LhLihp
	e7d0Ofe9z88stkejRmvHMj1XpkfZ0jymnobNTGKDs4agyXIBBybtLng4uDTxoqEQ1rkEfZ6CZGq
	1DMSRVPT6JKvTFjiVmaptE3tUN7TWbzCRQgj6Gj
X-Received: by 2002:a05:6808:1a0e:b0:4c3:7695:1177 with SMTP id 5614622812f47-4ca497b2b58mr4346226b6e.6.1789592756726;
        Wed, 16 Sep 2026 14:05:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4c::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d796b64sm891126b6e.15.2026.09.16.14.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed, 16 Sep 2026 14:05:47 -0700
Message-ID: <20260916210552.891730-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C88704000B
X-Stat-Signature: zd5p6ufnmjia3jxqph5dm371xydcxfpr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789592757-231643
X-HE-Meta: U2FsdGVkX18h0QZRNyG+ZP0Ef071hPLUTauHIkjQRvG1kDLI3bt79MVCXK1Yh0M6jE7qJKM8lyWue9uGjWujtxNOgKYIQP1TCgTWZZ5lcz3v+CJMUM7kYpyZFlfkS4W4SdY3c9ieMaZmEChAzEM0cGZVaBO8A+dgrNLUdpecA8CLZSP44fYjkcKcin95OMFdVCzLqZN7tMk4fR/T8LkrkQb/YmdGyE1POu62wazTH88yTYaPqcs6flcLGivC1Zew8iu5adBh8VB5PSXbEgtmPI0OzBCplagyLoP0WQPJZFEdbNmgE3PLkfoB++N1LJ/3dqgq6JvL2AgdE1IfZ6mIWljl1eCkATY3jHUIQWdvG/z2jqYj/kMdf+JmUSK1ey2IN2qQBmnasaRpbOKz0xfvQt2I4wTcPiBVEqxOLr826WmaVb4LHqYv2jimFitrNlNp3E1Tsw76wyxstbWRPHc/Wi5BoXOFuYFYemr4Lb1gXeZWdSte99Fg6jkxhiZPcOtNeVJsPwV1knbby3qEC36oCXRMIIuqc916JwFtY+sn0ostsfwIerggO6SZtZQl/pWpoENclXsHhrxJ+OJH6IlyjuD1IgHyYC87HCAYWKGtVZinT1GOzfh7+TjUNNgHpPBB0jiwUyWl5Dh234EX+VMhdMlQNubws4pBkISRNGxwE5t5GHLcpfoGOMiYe4CVdE37Ly28Qa19TpCnfZS0/BTA9VQHIFQcsAc4fklGpT9ArK1Zlnwrwt2dBZUEjsp3LpiejMONrTAi/zmmebGYineeQotLxy8acD6iFLHih4UNuzVwz6tFoCu3rEpFLXzz/fHqLCbfVHHosEZJERmwEQo7smoLwCSFjf5hNnOvPQLe5l66M1+s44Ayiwc8NC8avyspUIEQh3ifh3PhoFrzC5qh+GSbtUEnSGGZOcBtRqyvlWl8LQfWnMeiwMCXO7eTRPpGt+oSxUhsK39+WRtelS0
 6mUPoOAb
 jfT8cd++zS9e5zdm+AlOieABaGb4+xzL0UNCGIAfzrEDdpt4AZtkrajWJjVxrWCtJWz4QOD5xQyDt6UNgsq9YZbXWeld99dr+MQwz/r3Nvv3TG4U2dQMtb45drHG7lGQAzvQy7crJXHo6MoLFXt8NUzSEA5d9ZScq144EOF4ZYFUXbJRSsVQzdENRURmS+LMxw64oD20gVtvvRQUEdxZqlpSanlcrUHP9zDS+wCPoZeu265OaiU59pcqXQIP8wjOv792kQQtSIiUXoQZuHIWWR+Hdmw8s34vMO6vzZHkozlUZpUwH68nNfu04PoQY+CuzLaVYlJtXYB76m3VO6z9Wkh2J4xlqBJrv/ypMpW+d167nrCpKJZ7e51LZCaM1FWm9g2XsNCXfrCxW5F1FGjba9Du/iP1byDftMwAZjJeECKlxF79xAsAIAwupmWbEFj018FUq0X5IlEQKiOlfxfehcwdw0s4c6WtRC9s4RxaWJSkRpSu8nAs+4c12wYEukEUGp1mMPGIyWhLYeAXDS4reJntji9aUqQKRaaPDqRS/i1S0SJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588e..48c475909e6bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2707,18 +2707,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


