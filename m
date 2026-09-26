Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505C1C9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 03:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19FB6B008C; Fri, 25 Sep 2026 23:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAEC6B0092; Fri, 25 Sep 2026 23:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E10B6B0093; Fri, 25 Sep 2026 23:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E586B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:49:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 145C8A686C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:36 +0000 (UTC)
X-FDA: 85254533952.05.90A08D2
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3CADB40002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RL5m8ftS;
	spf=pass (imf04.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790394574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5exqyQhzafqyOFiRdxT6ffSBUlENs1lok/PR/m34+0M=;
	b=lcKTB17HQa2zUhLl6WXPqVOuPpMmPv9xJHF2XXaNmtAsf+PR5uDV4ErJ3oKAMuOf6kGo81
	e6NQmtW6JyXXWjbwLi7FQ3MnUAmB9Ba1U4mT/selYuLlILhTCnZ8V1FgyYVh0ct7UWLCah
	zuYK+ulPCFtBl4Fn1hnAuS+XClwUYUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790394574;
	b=Y9R9qorwLuHQEjmfW5Y2Z6CA0ZXO8V6HfYA9vQkA2sauYDZyOlleVP+qNVjOUjDURxliZ5
	CTNEG0FmhcbPcUTFBS0T60n70XcjvclsLI2+pNwZ1yOuOYFinIOfSGGUqkJyq47fShgj+t
	IiD1T/YPwOSreRgoi/up+KMePG3qJoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RL5m8ftS;
	spf=pass (imf04.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso10448575e9.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790394573; x=1790999373; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5exqyQhzafqyOFiRdxT6ffSBUlENs1lok/PR/m34+0M=;
        b=RL5m8ftS5/ll06mzWkqk2bbsuwlDltSZPmB5vdBUvd8kcFzkNlVm5uJTnnBJMO9fmk
         sb4XoeHyNDarGIGZtkZCKNyrR8fNKtmdZRUncq+HWSS10bNrzEr5+KJJlhYGELehJPlC
         qn4ZOBe8+b5G/MVQzheLJMHNaY7+RT6UATanDddqCVjY1O+HIG5YqO/Tr73PRqOfZvpT
         rJs+jP9mv3bR7juCZhCv9oC9Oo8pcfTJ1ML+bAPyByznRPBX4ma2WJohxdHSPPmeM9X/
         4sUpSbeyL+eeT+8A/MTARMNld1unfYlwgxU7cHSlIzJDdyg6bSIJE346Uqq4/NZwestj
         f0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790394573; x=1790999373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5exqyQhzafqyOFiRdxT6ffSBUlENs1lok/PR/m34+0M=;
        b=SpWzyIDePL9iB3NbgCBjrradKhp/nJXd96kuyOZKZsr/yTSg9aZjRpB3JT1af88TDG
         NMgpXw4NyGrnMIBx4tksulUiWCsXjpgosSsYhoV4F0pAuLhdy17DkhMsb6A9H8sqFrNr
         9g0sY9yJOHDWnDkkIj02XZDhQrhaxgKU+H6ahgKON24zT33I71EOiiFE83Gf7XLhRgV+
         /s6aDr98WAczNmfI9xRuRMjRWmy3qYeRW6FxB9OBVM7Kbc6ilKrirBvHP17BsG3PEfZg
         WKM6oho0oemMThsXFssMbepLL6OJXo3+ZQCtGDd1oKAumxo6JKUgFVnQ/pkwFFv2fc5Z
         N/JQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9rLQujRG2S7pCNgSkPprM7n6Z3P75oIozWvsb+xUByY9pFWkYVCH3loh/f6zq+FkxjuhpZZchzA==@kvack.org
X-Gm-Message-State: AFuF++macyVD2rRHyyx4ZTMceYZCMDho4iRFPgY6DLt11m4Qo38ml6i3
	fvs16ULa3TqEltu0pkuD1O8j3Sm+mm80FdoPTAna1sdiMqBRzhx0zZTe
X-Gm-Gg: AYBFou1PFeDY08opDenGbUDPIXB8FCe4yAkx3Bijqv9Gns2lapdyB9i9H6MrxpqXqeZ
	jUXLCBlFCHKUB3SSfc9BW+Y4zRMyBhR+DvSM1R0GPsxY1lZ26C+ZLc5Yl5QXvoFzKVn/zDHgRRk
	IfuL7AcTfpU41avid7t9bArVosqintFvo9Uy0UWBG6zijF5WYlMSTu6iR0PU+xxLhLKopjzJF6W
	dEsGZm7wbI0MShG97DT5+wkX9cdDUugDEoaBUG6hiiSnSaJbQ6IQGjrwfz29NWTlG6XzcVKoJlN
	R6auBHlU5lIM1YKhlPXvNrpAHKt3z471+0F5RyfOz60tipsh7+Bdi09VtU9C6X3CBLnE+n+upOj
	mNnOBwGDzj1J1hVz1Ej4h3fZFAedF0jmi73L//51yG/vxUJm1vzJ3eVnNvvxHzgcEcRmP3LI0hw
	9hqb+BvYmVBGPpnYhy9VjBS/v+UJNjf82drdkQt5DitSZw9EfL3KliYbu4B7CKUfFtkKje8j5W/
	eCRBBCoVufh1KGaGqBYic5YvSMykWrsI8iEZYgzTQKJ
X-Received: by 2002:a05:600c:8b4c:b0:49e:8184:f63b with SMTP id 5b1f17b1804b1-49fe66f3a68mr132693255e9.16.1790394572642;
        Fri, 25 Sep 2026 20:49:32 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff43ad975sm116657205e9.13.2026.09.25.20.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 20:49:32 -0700 (PDT)
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
Subject: [PATCH 2/2] selftests: cgroup: Report memory.current shortfall in alloc_pagecache_50M_check
Date: Sat, 26 Sep 2026 05:49:21 +0200
Message-ID: <20260926034923.31718-3-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260926034923.31718-1-sebastian.chlad@suse.com>
References: <20260926034923.31718-1-sebastian.chlad@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r6nm3i84ojwsekfkfdgtiz3u8e4uocyt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CADB40002
X-HE-Tag: 1790394574-35414
X-HE-Meta: U2FsdGVkX198KALC1F/d+eMxqzSoKd+uyhtlPm/7wN5fiK6dbP04SWQ1+ZefvIYKt+3tKBQDzGw2+OcMt7igImCBlRCRqu0Ssbth/PiUaQOSxSYucLkpQ9P2GsDrbMXEQ5dtDNoFZ1iukkK44Rqd1TS6Ol93I6TRLnmuzJsrP5kf7JzieooGbu7eJ+T9+XBWMpMfKnBk0+pE2aVRVmRkMUv9qfNOf316UqoVZjPPd8NNsq/VBWIuu2+D9TuVdT0WUumN/123Ee/k3QnMlukpNolIponHzIVc7hKxBhmmdcdGtgsCl5n03xZNuX7nNEBvI8sOlY9M0EqEG7Vod3MpIZKm67j9XBll7MOCJe3iUgwFzwihmPSQeU9SYLnxOjzfs8tCS9U30XpClB9OUn630J+zaOHHUo+YYqTSiNsqtzVkxU4lCIlMDXeRhnOM+B0JS7FB3NQTDBbM5rkqDTLYluCs00twD0D8Tq3ofjGRhPQXhMOZprH7GQFIuqQ1T61S0K0CkBjHRXzQfYXBs14rqsnjQJb+58gXRQPqn/HEOfu1l7p0BBQ8kh0WM8ZgOh5CmNZz09C0nn+kjUwF9/8r/aeMiDHfCsvlG0zUc4igY6Cb1MCJqQ4YaL/yWl6r0cXZyGlQKxM3mMJrvivdvMCC7Kd0A7FkCRlbFWiJKTy3XtIX78boYDs1brZfssg5xzf5OSycsv6ToHZgNsxIA6g9FmDG0WmAvwUB1oQDAY07uCkcwB/eRxHc65nfzTjemUDAndEqkuamPgoLGFSdYTqAgQIDsGZtnmF4hhd8V3JDPqw1GGhYI9pTraEE7Ym5TA0TmAhuuoOsordjdVFexY8+9An1ygXUEi3BqRe8Nw6CoEwg6TVvbgdtJQc6qt9J94Oy32eQToJr6c4WfgyYB06to5Z27TBwA3CUqjITMUCXBCbxo+Rq+IM8eCnwA8UT+Qu92MrlVDnJ7cpPmYpVgok
 5fVMZqxl
 DHKSo4NOgzikwI8TsJlfyM37VFheWIkmMJGGRH3Ec+M0Y7lRtyzmpNeHIl3eiTGRp+iM09k61Uc8W0BF2/wxJeY8+LUc16nZYXQwTbdAckPriSmpXHGKUSUozmfjDwysbJM6TjYJ/jnTzXtPovenPbJivJt14dyqhb2YptIqc7VLrYbI5Htq3TV5Xd7NwjsP5iLFZYNzunpN8kqy0pD5Zk4aUaPGE2MtjMrUk1e1OMCSxSP+8F3tZ+60avDKsuxFWu1sOtw07KBK/6nlKu3DIrEbmt3uvhfnJWDkLyv/9JRfXaePjWhszqoJwZ1/PHe3cQAvm4ZLWXp8Mh+RWgZBx90Ucm2TL9f6jeD2Yj7ct0yUCe+aYSqge5189W3qECCMLhJKkpCJ+cnDVNewiF2Zeigm2fMG/iAK7yOPqiV7LSGy/SUk4zE8t0pz1k42XzpPc0ik9kQydQZa0XQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pagecache_50M_check() fails silently when memory.current is below
the 50M that was just written to the page cache. This is the check that
can trip when the page cache of the test cgroup is reclaimed under
global memory pressure, so print the observed value.

test_memcg_high() runs the same helper with memory.high set to 30M and
expects it to fail, so reporting there would print a misleading failure
message on every passing run. Split the body into
__alloc_pagecache_50M_check() with a report flag, and give
test_memcg_high() a quiet variant.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 14c0bb608175..d3b9295aad75 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -222,7 +222,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	return ret;
 }
 
-static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
+static int __alloc_pagecache_50M_check(const char *cgroup, bool report)
 {
 	size_t size = MB(50);
 	int ret = -1;
@@ -237,14 +237,19 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current < size)
+	if (current < size) {
+		if (report)
+			fprintf(stderr, "memory.current %ld < expected %zu\n",
+				current, size);
 		goto cleanup;
+	}
 
 	file = cg_read_key_long(cgroup, "memory.stat", "file ");
 	if (file < 0)
 		goto cleanup;
 
-	if (!values_close_report(file, current, 10))
+	if (report ? !values_close_report(file, current, 10) :
+		     !values_close(file, current, 10))
 		goto cleanup;
 
 	ret = 0;
@@ -254,6 +259,20 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 	return ret;
 }
 
+static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
+{
+	return __alloc_pagecache_50M_check(cgroup, true);
+}
+
+/*
+ * Same as alloc_pagecache_50M_check(), but silent on failure, for callers
+ * that expect the allocation to be held below 50M.
+ */
+static int alloc_pagecache_50M_check_quiet(const char *cgroup, void *arg)
+{
+	return __alloc_pagecache_50M_check(cgroup, false);
+}
+
 /*
  * This test create a memory cgroup, allocates
  * some anonymous memory and some pagecache
@@ -735,7 +754,7 @@ static int test_memcg_high(const char *root)
 	if (cg_run(memcg, alloc_anon, (void *)MB(31)))
 		goto cleanup;
 
-	if (!cg_run(memcg, alloc_pagecache_50M_check, NULL))
+	if (!cg_run(memcg, alloc_pagecache_50M_check_quiet, NULL))
 		goto cleanup;
 
 	if (cg_run(memcg, alloc_pagecache_max_30M, NULL))
-- 
2.51.0


