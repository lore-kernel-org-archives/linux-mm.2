Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D488CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C900D6B0093; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2D86B0095; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9ED6B0096; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80EAC6B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8DFC401F4
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:31 +0000 (UTC)
X-FDA: 84911944782.04.EA9748C
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id E75048001B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C7AZ6RAx;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237690;
	b=gk0hlZhk2ckBjY12j0mUpW+EQYuldfign/UkVz/WeQ+6tLDJp5J0wth1MM5ND65FpVa87q
	F52y6rrPUk0AheCKcUSXn2opQhiDznBy41agtlGO/+UzfULF1a1GJOtkK7KCyjZ7HjhMWB
	MZ7piMDN0jhNlL3YaMbfXZ3/72C0kQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0cD7xT/1LEgCqENdxhvxeeA9K5MWSbIZS67SSvT22o=;
	b=gy2r2yWT0dXTwOUdIODmjCHZ1+tLixjfo54xdf0B44fNyqvjjnAMbb2cdt/lebyoCF9CR6
	nhxCh2owYb2yHjUxWbqerfrYdx9nedlivvUXr5nvAg4BII1u9WWynkz94rb0ovkWntF1r6
	wyiXv/aOnikymzCKBnVJaN9mUaBkA4o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C7AZ6RAx;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e93e0a3364so121591a34.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237689; x=1782842489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0cD7xT/1LEgCqENdxhvxeeA9K5MWSbIZS67SSvT22o=;
        b=C7AZ6RAxqboF0o/EyANH5tlLVSQCZ/EAu0SjxtvptJTs/F9vupufrArh07+jSilLiW
         JCjiRVXArToSpPSKPEEryhSq1FO3roe+9n5loWwm+Ez7VDxaG8PdY8lgC5eIyN1cXSBl
         IR2cvuf1KrVqCSNtcnCX3D+9UPhQIQOAmYRiVUA+5UwRw970o4CBRxBi43lyg0sbL3wO
         VeKP7w5l0YLQzb2IQJLK04eE0U2v5Zvt3F0mYUyjPnuC7ArFQGG1g3EG0hCCrZ1niFeW
         bwUSfIPxAi3qv9C7j7TYeZeMYz9H4a8bxL2eyVPuz01lZd7lO2yIJCvXqAzEVdUZIVd+
         nR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237689; x=1782842489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e0cD7xT/1LEgCqENdxhvxeeA9K5MWSbIZS67SSvT22o=;
        b=fabM8LiHcEl5d1w8a+FS2NAxJB2+TtrPgfpbh2MhDHBp6gzPokCna72v/tgS7uQgQH
         jSWeUPaHd5fET1ZVnoz/oRucfx7PGslhYEiJhNpAnn5Yoy52qeTfrWmMDGITqmlc+6af
         6ZXakIH9Q/vlN7cmdH/+/3OVw989c1w9W7RT/c3/Rk6bDqPdPcxT9OGW5uurtd9QBz/6
         +c6IPQN7z9WJEH1k3GjKEMycnDFlkAUW1O3txp9soKXs1BcxjM7FbskkjEo7WY9Brgq9
         W/pjInrXw2CNRvhhAtMqpQWgJUP4alwfR9lu8uAHdF0Swy6E4cD9JZQxibSAiUDAHaAF
         NaeQ==
X-Forwarded-Encrypted: i=1; AFNElJ/SVl85CbSikTVn6eR1NNNgef1ASDpDjH5vR6GaKGSGNtnoesjwUObKuugpZCP1nyfGBGgb2A0tpg==@kvack.org
X-Gm-Message-State: AOJu0YwT3qvPeDDOASGsOIfGEpoHXXBJzFQoSUeX3mAZupDLVGMnfz7V
	iwesO1XtUp8DZxK2SIORBLRg/SrzIXLxlS9BQk47dJSEiz5+d8lnP0AO
X-Gm-Gg: AfdE7clHkK7QY4QTkQPcDyQkYrGxNfo1gZjzFZwX4ljcGdvKfYmHQ8I8DwgHcaSOan9
	kKH/HiTBWeIas2DUgew+04qSpOjnPxFuWJom7qO3LZgRzVDEcdw+D1buefRpI1K+4TZ7EjwrmGK
	KBwoJiBRZZO8BsVchxABdCH/A3Em8dTVih49JHMjpu6NpLq7ODSX++ieu2CRiF0EnEtiR7FfQ5c
	oZvNLSqQGWCmJD6DF5K6WeiwYVC0YbMDB+pf1++8NzkI9B1EDCxZ/3nDeBjVja59FV/XO4fm7kR
	Hbfy9yngSE+vIjxZ1AbhNxDxrb7IJsrVDDH3tJyZQqn2MSPcotSFiuSdoZhH3ZSKkjtpesekTfo
	gPn7i0rxUh6ul41mwBxEzDArAjkoOcd/dBdql97EYHPknToyCb4mUbV3EznnV+Ua65g3g2ndZ8c
	YPGPl9O6dFiRxPaGE9cStbWkGzCCwYy/YnGsT+LiShDQ==
X-Received: by 2002:a05:6830:210d:b0:7e6:ed97:ce5a with SMTP id 46e09a7af769-7e986a0e11bmr74036a34.4.1782237688802;
        Tue, 23 Jun 2026 11:01:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e94424c93fsm10349972a34.14.2026.06.23.11.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 2/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Tue, 23 Jun 2026 11:01:20 -0700
Message-ID: <20260623180124.868655-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E75048001B
X-Stat-Signature: unygbbwgbeorrjq99rehtjpfzazjck6z
X-HE-Tag: 1782237689-802810
X-HE-Meta: U2FsdGVkX1/pLbWuOF4M1KLGqX+mPJMROu/MXEPR9S+MkqGu78a7htbwyL0AdgHF8LuHF03fHg/729vcoXz4ISCOLwWQEeeASU04NqQFC8x2UsaFc4x2CR0KCHM1JxJPNhnxA+rI0TP6hmH0qg12BYSdNCB5tLbrcYKJNJEhZDrq3HW0dm+WngqkVRjuzEo1p4E+O7HQDSunn6tFd8a7ugFh+xk5AIJ7kNgLQuF9/q3Fr1lIS2Bst7Yrqx41Vel8Gq57q3old30X8gYX1+WehzNibAsWZGSrWWhFUp/Nejhn0xRMfplpZj9YnaUvDtECJWu6icaUR4w8BFsYk6679tc/YdWkltfYMh2RaK+isXU2o9O/u/vHxo362n25JcFoJYzy4zpyBuVv1cGoo4xY2yS0ipKJ6u+sDlWMNObSyIEMYa+KZr96FVHV3jrzl8rDXa4pm2QerIcppWQK5I2dP98ic/utrhacNAQVNIBbN6ASE0gWKFD8LJaFOV3sv8SjKPtZhoagF/B4J1Lzp/Xek+v9VyLPmmlBZ0t3DwGdnsvNqc/bgahKhx4omnNAd+wenMyhPyRraqPefulytPXDKkIrorEPSyXJCgVNyVHXUatp2mmH5Tluah/nLUAFAMHanzEbC10yJ/sqnyuQD/rfxYTNMu662I+ehGxDossz+60RQcU62DhcT/G65swN0RK+3BmaJkGLZS1qDQqDn0wzbDv8cTHByePJJ50wDw9G9neHe0Kdj8g1dFm1VMf3/5PoJvVTvoa8BEAEj0aTSsHMDjnmXg0DNLHsZTA2jR1SjSz+63aieAQ0+J/v3uNPVl3EaQWmGTIhBXeRfxuUlLNxhwPPlClWcjsQ+iJIQ3c6+pbQYaxebrDYxKWhQg5OMrX2ITrRwoxiA8zdrMBdjyoXgYWX5gYxFpbwWQI1IVsnTSRPr+Ai2Vj6uA4mmg1Q6QunHWz527LI/fhO2YHwCih
 NUUY+AsI
 9PqBOlS4VoLNaupPKiDDVH6LQ5TAd4l7sZYQYvlQLMiuL/E3pOQdwBUp/QOx59AoK+hoWguXThWkcwQOOhnM3epl7wV9GSdFWIPPwE8bnIVOP9nz92Ux6hOCJ5cVTHO70n6lDCdsYpw1ijXb8RBBJBWpSJFCjyWXUP4rXEp6RtNWmpgHkboVCsRgjFPJB5plWSBMyveKxqtDqPP4udHeT4xtcBSF+qDS/aYW/QFbeZGzuccCjwyRKMNYMAgFDLSHEigqM6VWUidwxuBAHlfF1iTIXo3YMkf7f2N7+axnw+tdoe/1H9GKs/2oGmQX8JkK4jk3uzrZ263yktz6waICTrpXAH24Ej9OfYUGXBZg8smldFTcGn7T+p/3KJTqRsaYlAsC4s+y2H9ifokcuEE9KTtWA7llbmalMlbmTPJr8RWy3KpLEdSk8o14LByoyRdCcf64j96j/iDMRovLQuaC821nXs27/aLjceBy/Li0+s8TfaFjHPQtIUB7J4DeCHh5GKukNTFSyx9oc4Ol6Xn/+oKzElbhVtGbgWRElUg9/pMb+Awo=
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

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af082326..306658fd55512 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2616,18 +2616,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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


