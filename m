Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A67C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 03:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BEA6B008A; Fri, 25 Sep 2026 23:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F374A6B008C; Fri, 25 Sep 2026 23:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E263A6B0092; Fri, 25 Sep 2026 23:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC4E66B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:49:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2CCF807CE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:33 +0000 (UTC)
X-FDA: 85254533826.08.02DAA1E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf02.hostedemail.com (Postfix) with ESMTP id E007C80005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fvy2TO0i;
	spf=pass (imf02.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790394571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qI8gzoG27aGncFin1uBlOK6ZBd9hIaPKhApyur6iKoc=;
	b=lLl3qtrauEZQlsOWSnaHes/1dIpyykX+Oqg8TKdtZ2azDGfbG5jGkzdXKvL8S1Xuppb37D
	8fc727rCZJVFpIHdPLNYoGvn1RIqCzzO4Uy5eqzdeHncOLEgLvpLnzoKH35QZVBDpdcwpL
	WCuvsMrOWZjDuHI1sWQTApa8zdWnc6Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fvy2TO0i;
	spf=pass (imf02.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790394571;
	b=f9UpFKszMHa005lk0BjCjaIOLRrhgaCF5NKIWw5tLLP9F3bN5vsxwIyOzM+EDL29RpHhSi
	oSsOpyEzvVDHKDuRm0t7Hj06dvzqFE62ULNslh+eg0bs9rDSTQLQjn2fch80RBDMqpHqwA
	WhyMAeshUdMkRBnWTsdfj9cHROFWlxI=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6351831so806736f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790394570; x=1790999370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qI8gzoG27aGncFin1uBlOK6ZBd9hIaPKhApyur6iKoc=;
        b=Fvy2TO0iQy3SvXcyv0nICUP3Let3i7kXjUG7ECxBBVvCWkT3a07CXhFqD/WZzdy53I
         lTHIo315fT2IofJGqMkwGSoFFZBzi8E2VCpEaaxhGU5aJMgSUXff7p9zzQeUsqh6mbBX
         75jPkkvDngJvsk6dApAE8HnPV8GAJeAXwEHHZuNUxnD8glD6JqNlFz0tRe5K6zjFBZUq
         /obrRcUCMMzCha7hTGDk9UxZY6+T35cpeeluP/uAKEbbge5CBb1DNdxYZK9Os9cEAjMv
         1nazntnaW9PRHTb9v8IWGNzehlV2tYjH401Ks0+AIvwvRslQsDZtKQ3g9/QD026487Ma
         E7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790394570; x=1790999370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qI8gzoG27aGncFin1uBlOK6ZBd9hIaPKhApyur6iKoc=;
        b=u8oG4Br7QVrwuQcA8hrqIULy9wOHVeLS7/l+61epoAe8jQ9GR4+PyKimCc1l0rQiZ5
         QA67c/Ix6iJoOF1jqZ7D7f0/6EyJ0jyX2vwetLGElMJeoHhtvi5d3TFxKVXSwSPzGxQC
         +BK2UCKnrkT58Wrr+LhL5/s1O0SDJ5K83AkA/pUt18VTPwZqKN8/tGVGkG0Uv9p2HGxl
         pHfu7Mutcyj0cfx/cn0/X3C5th2FTYXgfOxKaqgbRFSGDL6ECM3JwgtxJY12PWv7DJxB
         IQveA6BEBZE1WwNa9sOYoBauydimiqKz2o1P+1E5rjR/Q26zMbiQgKuK89XbQY+KFMP1
         fbng==
X-Forwarded-Encrypted: i=1; AKwUvBydSFlr6SnRIyKtrT8SvYZZUvgXTklF1o2PJsQuySvOaNdO9uGu8n71jdrY9/8PJL5deOatGDdV7Q==@kvack.org
X-Gm-Message-State: AFuF++kmXCLcaOnpRFSfVuq/1K4cdjzmYXu6hphZtK+0KtsALBlu9NMa
	MKH+zfI/AcB8IbzIr9iOpe7Wi7Oam5q7e92bC/zN5TZXAQ18J/jSR29DSCHJn2ve
X-Gm-Gg: AYBFou3rq5QzZPssAkPGJo4Iv0eCbgTVj1DC+TF2ux9lKcDrwfVlfaZ4QyAK8vZl9nS
	tGRcWaUIOZ66ohXJq7AsaRnyao0Zpm1ubOV2e5WW/tPZjTaEgmepEvkq6FgR2HyJdfjJmNeggCO
	fR8AjS8xYd3nvivohEhaJkspURZMNgE5l98hSmHHDG8LSVQRZLaqWLvhsIRJSL2yump9QM3+tX1
	ZXYbEMrJ7uiYmGUQB3W+ABR/xwuz0JVYZy6w4sc9wullls365Z6w6gOk+f3QpGiUoC0oCFePiWn
	+1L2c6Qjc0KxAyvVsoxfJS1gCMhMVCPwy/+DZ6b5O8rmdT08ue0WXYy9HudnSE73InyMLNyxHVY
	YJYZ4hf2e7517atRgvQghQvmFrZ7s18JiSl9M333PemM/EhktOlaM8tQSNeuSQ2WdxozBA+cYZW
	8XQ9w6lw0k4db83JOpjeKBpb9PUITNAZ0u2+E1maYZDF8mRl79coCQJLvox2fqApNLS6D54EcWL
	L8H8Yc5pQfMm5cOK/YgKdUkuGDPviLptsNYoxgyFx49
X-Received: by 2002:a05:600c:3b1b:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49fe66c8a1emr145611675e9.2.1790394570582;
        Fri, 25 Sep 2026 20:49:30 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff43ad975sm116657205e9.13.2026.09.25.20.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 20:49:30 -0700 (PDT)
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
Subject: [PATCH 1/2] selftests: cgroup: Use values_close_report in test_memcontrol
Date: Sat, 26 Sep 2026 05:49:20 +0200
Message-ID: <20260926034923.31718-2-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260926034923.31718-1-sebastian.chlad@suse.com>
References: <20260926034923.31718-1-sebastian.chlad@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E007C80005
X-Stat-Signature: 3yngtni4ta3geq6wfumgm6ur6smgf46z
X-HE-Tag: 1790394571-374370
X-HE-Meta: U2FsdGVkX18HNYL2M9vCERAM1PzLt6+xxeuX9FSlFAp3k6v5nzcraWbJ30mRJ82Jb4+bAkqcWDNUZi+hewqembGqRu4zF0h3sIuuPwyMSSLcxN3j+HxyU+5yQMwWNE1Zl7Wv6OgLAWrCZxcgRL3/jLGzPxtBCjeaFIYsXqqDlhbKNo3Mms3p1eA2RxM3iPnVScnzKbEpNaNp+urGp/L9jTwDjewd6za5fT5s+BbI1IsD15uIPg9gmuREPycPZQH0peNYqNrTwcawOt6Fz2BXZGTjLnF6Ts93RmQCXgChHdA5C7NRKl/xOTl0s9lUbhBKJ5DkvU0I0bVHfgkpfjhIyjG09zXyeZmHQpyf6KaZ0rX7QOAJ/PlwZGZrintir4H/fhnnPJCZNe1SY5gCjKUdhk+C6u3bLBWLkxGwR9+O3PxQ9yRBmdivSkNVLxGjWjhpTr8jI2+BOiAx49fAeinNNfQkIS1vS6XaxmOLZSRi+f0ncxZQdINcnHrqr3nz1XJJFNYxrVHmkyTU7Y7syyOSbZCAA4LxWesD8Ls27spL+XSMEjSEYhwMgJCo5tMUlEpN6JxHNPOT95LZe6bBNcGUWrMQU99ZOGNTYMBcmfvVblXPXkQ0eCKkL76JJm1tbSEbkoO6D2Lq0i4xdNku7p62I07aI2tOsa/trQyL0CzPWGRO0EPtfB20vmdcIsA/HBYfl0ws8Xf1Hz2VMUAjctRrAHW9uQgvkJXHEnEshyWFTd93tp8aFOT3oPF7gyje7ZD988MbXED3CcgKfMuYjGXReybtk4s+1Uvp45dgoc7rnHE6s/cWxGsqgUz7jKIeWeuLDjTgydYcU4QFz9/+sK29L1GViRUCSDrC+d/XE86qgLcPcu+3bZ1omZ1VFsqZlyb4Mbn/Vuc9QNmR+bA20QiUgqK0vG8dlyNYyAH0pYWN3L2hQVX8oQpELOmt1b7OQpYf6QS525G3ZJULzl7e3Vh
 ywqrCaxZ
 Qj7yQRS5x2g/l0M3AY0cgcnPJ67hYGSU48lVsWmPZMCOQ/1fAUxlzUyOZ3g50JsbBjN40cESwFcqBzdt3AoztvVMFG3rRMjK8r4vGbHm2CaCdqMB1ThgkuwWWtk59OIn3cwwCabt1peczvlbGFL4y/Yjh8JTGmnujVrRWupdoATByBXzaWQqLsYvhgWiGTlpMl5Wj+utVjqrnqsp97IzfXGl+kBKlQAKyltPdT0//54DxUIi6GQ4esVbMaYg9zXdnHVZo8eBirJjMs2iSPxyXX4jYTzWFpun7mS1UJLilykFz2qo8D6qGk9jBf13UsZC8IrPVfyhkWj5rGfO+ILe1tQcnGhvzhzuiHXrX9W2VhgYVm8sHHuzFiABgD6Vu+vf4DwWY16HwbnE+iKCx+A4S6rmfcNZmIHfK4W71iHZ4UBkwU3dnIq7mMQcTijl0sjaqpUmdtmDguuGcPIY=
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
index 0ed82347044e..14c0bb608175 100644
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
+	if (!values_close_report(size, current, 3))
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


