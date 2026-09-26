Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE7EC9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 05:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CA26B008A; Sat, 26 Sep 2026 01:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6656B008C; Sat, 26 Sep 2026 01:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177D36B0092; Sat, 26 Sep 2026 01:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7CA66B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:52:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4764916085E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:52:02 +0000 (UTC)
X-FDA: 85254842484.13.6720D4D
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D8B91C0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:52:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qW15bk3u;
	spf=pass (imf20.hostedemail.com: domain of sebastianchlad@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790401920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yi4dRtWZ8QVTscHUglSUHWaqYAQ6yrmnxvkOKTaKUMQ=;
	b=ErrqGz7A7hMIaah7nUp43+9qKGLX9vLUrMAEVP2MCXAhGVIxMrn2iWxW4hKKylL/MNSzkW
	BsaczkYB9LyzgsLXSMo2XDL2aVd2gNBiVy8Pdnjz3Kjg+vkOpefN3UP6T9sM88HvVKuxQG
	dsDmRM9zMlG8X6xjbzG75A686m5KQsw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qW15bk3u;
	spf=pass (imf20.hostedemail.com: domain of sebastianchlad@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790401920;
	b=ZejZsvUHwAN/d0Y+7+C85mphP6ZFYxOFcLnuGfWE+IaQJMmk+e/IV4Cs1athEs69KiLOnS
	EohASP75xGMt4AN2N5tl+skkv1JH+Z8LnhO4gMz1VM/Ay5Ju1pu77sMfkTRvs/BrHLs5Cc
	+I1VaRxrCuDYgWCZF4I8twJjPplh31U=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4887d3c59ecso701837f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401919; x=1791006719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yi4dRtWZ8QVTscHUglSUHWaqYAQ6yrmnxvkOKTaKUMQ=;
        b=qW15bk3ubI9OgNgF1JoSzRKVaf2e+tR+pd8CggQVdVz0bD5wg5XnsM6ww9bWGsJ/5u
         uMPtF3ysK0Ri+/M7Tpa8F5xATcqY+uDAz+JomJEtSIELsZuSH42+sBNydLhRsuKb09qi
         qyjUAIK22rdEY/Yjxn7xQrxCg2xSFRJzfUR/1h5m4LOPyLBHCMBctx255vfXjOuiIy6B
         328owwqdQsoIhjfsfvyjLPgnRUsQ+IgNlyb/X0kzdJlhwh63rPrsncNQwAk923fnTOJF
         9iDgf3MO40y1w7mYGoBqx+/KeKY1Olhq5L8zp3zYWQsL1dEzQcSyaiKuz3etstu1ewNm
         jFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401919; x=1791006719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yi4dRtWZ8QVTscHUglSUHWaqYAQ6yrmnxvkOKTaKUMQ=;
        b=DPxPCATLs3FMu1dfFNR3vEaSTXWt1JyJHsDNTxsgWIg2QhC7Y6EiDYsdX2bnYyxRV4
         OgzmKZyLrKg9FOvfuWuHmE7DzjSitLBdAhijtL0laALT+BfdtpnoPfoHoLpyoK2DX/De
         JELLu2mYhhZGnF1zj9hhnNriPHEhP1wEKygmynLtnrzAkERIzoTGd1REIzSSO9ZQhepA
         phzi4b0JVmdTr8HEGuIEdw1CwnkMVMZfdTopiptqJnt6qdK/3HuPEedVp/SRJsRLCP03
         AW3gX+fqK6B+KrZ3lN6okUYybjvn5ryeZx5yUqPkZ5sRZDSMJUYwF/7wtTfEk55+L0aj
         AZqw==
X-Forwarded-Encrypted: i=1; AKwUvBxetKoxu8UriGi6mIJNfGxYxRqyHzXAwHHL0oxAjxgdxJVYSdmg4N+FikiA/oneQE7gbRgkAg7qhA==@kvack.org
X-Gm-Message-State: AFuF++ne8jgtJelfILf6/Q7gE6e3lA1MPB/wSMynXRi2gCpVSmDym1zd
	XirtcsOF1e+Yp8j5TIb/jqCv+mdnT8oY5M1Q17HTpcEZqhAD9DFEJbtT
X-Gm-Gg: AYBFou1Q18nQ8GlxVlS02I//KaqPywI/hm+KdikA6SF0Kll8m+qKXcjcryKf8zXgKYE
	D/p67DAuU7J8rG0dZDy/pZHSDrPFHZWC+6jdRhppAjK50WEOAJUmO0bbIcudyAFLohcEfkiDgBq
	jpbW3DMDQKLwku/Dkvwd/6wPu4yQ34sbf+3BNo6eB77nypi3ggfm7lhmNqVmfIUghM1McKIOZeE
	7ykHJ5kTR9gMMSKC8cwlovi67q30POS0X5FwxFy6zj5/LiQdlcwLlp7iNyArM1apAjz/Zb0LlM9
	dyPGHHlVeNs2XN0Q5NqF0EUc1KPDuyz+RG1MmmDNvRyCEYrCoAELB9ovxo2xWl350Y6oy0aVwPh
	zmsuwiD82yMP+w4A3Hz/d3qa5wHA+ZkMKfSCRpQpsGeEzmzqTj+f1IjYwtdxY+xvdf23DTOVQi+
	s2O2TZMc1e/+Vdzu4TH4VDo3r422dfQOMnsHdRdk9T5+e7zjD0iMyuCjj3jHA08TjJRAFDA3JD/
	RIv2vUW0JAhMUDvOfVjUfcogjAkp4csp0YfMuWiXPC3
X-Received: by 2002:a05:6000:4b19:b0:488:8882:d504 with SMTP id ffacd0b85a97d-4888882d749mr1189407f8f.10.1790401919190;
        Fri, 25 Sep 2026 22:51:59 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcc4sm12317560f8f.1.2026.09.25.22.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:51:59 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] selftests: cgroup: Use values_close_report in test_memcontrol
Date: Sat, 26 Sep 2026 07:51:47 +0200
Message-ID: <20260926055152.1684-2-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260926055152.1684-1-sebastian.chlad@suse.com>
References: <20260926055152.1684-1-sebastian.chlad@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D8B91C0002
X-Rspam-User: 
X-Stat-Signature: k9mkrgk74r5awreak6tkobisdsdmueyo
X-HE-Tag: 1790401920-881585
X-HE-Meta: U2FsdGVkX1+rhSHpQNXniITDAvrGWGxekx5NnTUuVz8Si7TzTFHZZSinJXigRySvRXR5tlRaSfNnku5/VpT42pFFPLcRcT3ZLrQWJ6RV01a7/2xEar7G9VAWY8VxCUWMm+D8zCvPa8HRUGzJNSEr32Mwydb7tydUg80L9gKyYI/BAfPgdEeqteVr6BZvK5Pps5zmKwj2P67v/H4bYuDHeoMSZtJS57r1Namo4udgUcZLjbKUQTu/Fwi13LJUz4o8QMvWlJ5tCRCyBWuhJIISvON6/u+orU+6Am78y8thUBR5eWSWcHKCtUHbPFDNUshD9Psx3NpGB54/YLQ7o9m3rR5CQvAoNnAN2grWXOmqLOH70y3F2P6tE1Ym7ozkZCwOZU0gQp6F74Gvb8Es3y91vFlB0OUD2Ly5zK4L9qNbwi/3aa9ZOCd5S5FixrtCsbXVpFngYJopnESfztKjhL/tcZVFr0osOs1GyfVqCeV83YbAq5tRIhpkZOjogN5MLSq8Xg1B+0OTzaGmy9H0z4L6aURkecwmCrj8GcQyzVpIhjxxhNykYShAPbTO/vtdxajyPMlX12qt3lru7pzYdvmNGEmvtH/2ITjvyjOHDf+rKgjm2AXTZn5L6GX1HJUglqczQd0BZxWx+dgY1S5DXUwW4sZh8T69RTV+yTLgoLzOcrF4sJStHDXfalTPfiHTt/AH1/rGLWhKfZmB62ByopcjtWTHXlWHcAwatWNejbdrNzq7z4OBp7yd6fBpb2nrApWPrdNRStfZ9Y+69BVOVBFhqrNgHQn/9aAnFAbEDSVN4Pg3kPdWbruVtokJlxHnR785IhOSdlQ7Y8NKI4qeyE0/jbjg+LhlAyQ9cv9WfUkkTooILm9NJ5VQLOxmkdPSt5DiZEHvTtgkET+0Hx6xLE1vpliatSxWlqD9Q0qQgSkYNA1I3/2u+bkcFqXZOaNFfWpsjWyt8VqtE1qP9E2sZCX
 xaOQ57/z
 7Usri+hwk2QXKYjSaDFSDkj95BuTfX1V7fcI6qFhDAQzPTmUmmGPBh0iepi68XdIlhfKB4xBncXHMeK1vtr2Ut450aN1NdYGkQ0ZUVMVv2Aoll4DA0Kab27r48IoYlCh2LS76POkOpSBVlYQEz22E8ZvpRly5Lf//IQnCI7LHP8HiliIY68LCobSmgkOZXNpgi/emUFpKa4TWf1W/O/882HReul7PYM3q8nmJJcYm3GZxxptN8yDsNHw2IpdS+0hMcpVBwW5UOJ3FbJzZEBZYTDs4xzinVrnHIE62MfMb3e/YMjz1qKSbtpwvqyO0Dd4d07kw0F9j8bPD3iUu4+T/frD3wcPAT97q3QUrwBn9q4fpTm099pDF7epxR0pQ0DkZ5DFdUnAzHSGql/FqY7YLmhk4sJeBQpFF1h/kTnYMq4WJz4SOvloKURqCBn5+Ig4y6cIKeyrnoRBgAIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the terminal tolerance checks in test_memcontrol to
values_close_report() so that a failure prints the observed and
expected values instead of failing silently. Also report the
"memory.current < size" check in alloc_anon_50M_check().

values_close() is kept where it is used as a loop or retry condition
(waiting for usage to settle in test_memcg_protection(), reclaim_until(),
the reclaim retry loop and the socket test), since a mismatch there is
expected and reporting it would print spurious failures.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..8882c7faeb32 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -200,17 +200,20 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current < size)
+	if (current < size) {
+		fprintf(stderr, "memory.current %ld < expected %zu\n",
+			current, size);
 		goto cleanup;
+	}
 
-	if (!values_close(size, current, 3))
+	if (!values_close_report(current, size, 3))
 		goto cleanup;
 
 	anon = cg_read_key_long(cgroup, "memory.stat", "anon ");
 	if (anon < 0)
 		goto cleanup;
 
-	if (!values_close(anon, current, 3))
+	if (!values_close_report(anon, current, 3))
 		goto cleanup;
 
 	ret = 0;
@@ -241,7 +244,7 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 	if (file < 0)
 		goto cleanup;
 
-	if (!values_close(file, current, 10))
+	if (!values_close_report(file, current, 10))
 		goto cleanup;
 
 	ret = 0;
@@ -578,16 +581,16 @@ static int test_memcg_protection(const char *root, bool min)
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
 		goto cleanup;
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	if (!values_close_report(cg_read_long(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
 
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(29), 15))
+	if (!values_close_report(c[0], MB(29), 15))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(21), 20))
+	if (!values_close_report(c[1], MB(21), 20))
 		goto cleanup;
 
 	if (c[3] != 0)
@@ -603,7 +606,7 @@ static int test_memcg_protection(const char *root, bool min)
 	}
 
 	current = min ? MB(50) : MB(30);
-	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
+	if (!values_close_report(cg_read_long(parent[1], "memory.current"), current, 3))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
@@ -691,7 +694,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (!values_close(current, MB(30), 5))
+	if (!values_close_report(current, MB(30), 5))
 		goto cleanup;
 
 	ret = 0;
@@ -1006,12 +1009,12 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
-	if (!mem_current || !values_close(mem_current, mem_max, 3))
+	if (!mem_current || !values_close_report(mem_current, mem_max, 3))
 		goto cleanup;
 
 	swap_current = cg_read_long(cgroup, "memory.swap.current");
 	if (!swap_current ||
-	    !values_close(mem_current + swap_current, size, 3))
+	    !values_close_report(mem_current + swap_current, size, 3))
 		goto cleanup;
 
 	ret = 0;
-- 
2.51.0


