Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157B8C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 05:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743A76B0092; Sat, 26 Sep 2026 01:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDFE6B0093; Sat, 26 Sep 2026 01:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56EBC6B0095; Sat, 26 Sep 2026 01:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1886B0092
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:52:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97F8914083E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:52:04 +0000 (UTC)
X-FDA: 85254842568.04.C0458A0
Received: from mail-wr2-f41.google.com (mail-wr2-f41.google.com [74.125.225.105])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7B45120006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:52:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RE03zL5D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.105 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790401922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlS6Cm29yDumSGG9d2x8b2HduKmhAprb8xwGaPSX0YE=;
	b=t8p0kHIwgItyt0ywTPw8dSTviU3CdzkFbEPyS3iv0jDMONcypCy1posw85zQuiRP+fZml0
	WygXdkHWJU8zOFIJMzZ9+aOU2DvFHKOhhAvc/ViHXy66LIXoQDvAnlK/pZ0aBp4ssLTH48
	mZ3O+2VVlsDcL5gZhI3oZL0vLjZNLSg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RE03zL5D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.105 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790401922;
	b=QgSC4S0/7vOTw+9LsNyAicULmO85O62pizI2D8VKo4K1gyTPjtQrhiGf+mdEPpllmqS3XU
	7SPsG3xguUHnHnO3jw0C8ae7o+x4VCbgxRAnRRQ4knIm5zghzusMvd+oijQ10eWDItzFbA
	8m5QRtJQvm4e7zcKePcGBKjObgisraI=
Received: by mail-wr2-f41.google.com with SMTP id ffacd0b85a97d-4834977ae75so867313f8f.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401921; x=1791006721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlS6Cm29yDumSGG9d2x8b2HduKmhAprb8xwGaPSX0YE=;
        b=RE03zL5DX3XsUBF5Jwb7uY+7D9qfV2bWeoGYoo3EJsGAd5pzN22WRll8Jafg1bs9Gw
         EI7YTKg1NOrchsLDv8B3y4nLgv6IywyUQs6TRn5zYF4mVwz2y/rj7nLooP86D0zz4ExD
         7GwLJouHyi2Z8bC1Ht58EaeFC8hzy0arg7WC+NLgk5a7OKS72A/ccjMOVBCj40+3M9mI
         BRPAL2nJt6RaIE5KV2zpFWA28QEgK5Oiya3MMH2UmIIdHOU4cuBIXx+KVFtTMCVdvkD4
         d6XZl21q0BE9gUBZqzXTPH067ZT03i5r6Sp/4k6CemB6V3EYdMaxvY29IO5LeFrR46eq
         Bn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401921; x=1791006721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IlS6Cm29yDumSGG9d2x8b2HduKmhAprb8xwGaPSX0YE=;
        b=J/aAM+lv4JkaHxYmqFExvdoA4IyfZ0Fyw/9aR+wsVZI38wn9tRGbulIxQalwf3bGfY
         wfMOThbQqyMfoHD4LmcfSRO7dMMHehMXJFBvYezVWBJhAbdSepZ3XrluUM6ROSr0Be16
         QmSbnyMmqpsTm9EqmwMT9JnfdjMw0eiVZQeEfkK3Lbm6D/nX9skTdqz85ubLrPNQNbBK
         NfTd+xqjwhXqoCQJa7PLoR3zyUeuHAd9yfcyNRD7QfHgtM6bei9RX3jtAyJGw5xKaBrE
         pacTZcDzk7W8JdnIMpTxxXTPj/ZfK1OTeeonYC0MBbQ9QzCWymhBpqiMt2atY7w6KU5s
         VnGg==
X-Forwarded-Encrypted: i=1; AKwUvBypZaxEBb312tjywF9I+h/1Prl/4TW/XAFND3rNnP4woanJMggoztHuEv5J/gDaStREo1mydpR/tQ==@kvack.org
X-Gm-Message-State: AFuF++lx8NQn5AQMiFCjVR3V3KQbX/8NhKR6VGNZoA2j3KzAfYXk+go7
	LVU4Q+BtBAeI+RFuLXN433G5uHp0oPR7+ky9IdvHg0rW2VN3b7R75cM+
X-Gm-Gg: AYBFou2MyE/Ft7M4z1gQoe9q4g2CNvmQsffDJFZy4jsnSqN036oJcPBeiR4pYAzpMNF
	z7wQsPwm0LqJAH3rIRNVvSUBP2sLy7kSPV0b1hVgFY+uIDJDwlI9cEOuet3Z5Avf6U/KrRK6RN+
	FCydl32xoUONabOzL47uDZeP0RPI5bIli45vfURLsEw0IGDPNM5ekm0lUZS869whUfOrplHLuQG
	D2e9uVFdLD9grQcg3ey5iE4oW7hPxtGUIKQRSd11dwCGvpdZdRZGqueiNpBdmTsSp63mXPv7B0U
	E9HOTTnfG6hx/La6Nn2WR+BJxylYyg7Ie7/ZwI16UOkglAr0hJL9IybfdMwD8xUDuYS4nUT4kqF
	RO4UwXXwBXiDGhJ+ROX65qeHMhEzLVupV0R0LO1xneCmXuaor5OzNrW6/JNSqDNwuS/Or+E1dwD
	h78jUlGdGmGGQcSaGbqgwGj6qezT22GpxFMj7h84wSDDM2+L+uM1OKPSzAzce1+Ypu2W/slT546
	YqK6dSkai5/+1qL9f3WXjWtag7KMFLRY8xrtAdAuHZc
X-Received: by 2002:a05:6000:388:b0:487:24a:f3ba with SMTP id ffacd0b85a97d-488716a63ffmr13631454f8f.26.1790401921483;
        Fri, 25 Sep 2026 22:52:01 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcc4sm12317560f8f.1.2026.09.25.22.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:52:01 -0700 (PDT)
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
Subject: [PATCH v2 2/2] selftests: cgroup: Report memory.current shortfall in alloc_pagecache_50M_check
Date: Sat, 26 Sep 2026 07:51:48 +0200
Message-ID: <20260926055152.1684-3-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260926055152.1684-1-sebastian.chlad@suse.com>
References: <20260926055152.1684-1-sebastian.chlad@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C7B45120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nyz7hkpbiqpw9rojwsckzfbobtiuzd4s
X-HE-Tag: 1790401922-724573
X-HE-Meta: U2FsdGVkX193Q2yXTv8oWKi5yVbFPIXzXzGaouOfqIwn3SNpmekWzJleI1rh2NgeAhCsAZTRCBF3M+dQbFI39jNsAkIpV0m9D4SnnHxYlNDinA5CjdlQqBHGwpCyNMXEXzAuVwJNQXVJaIiedb6DqTciTFLqcPGJvzzpWIPcbGlkjJ4/Ga2iJyvrz6y0LRE5gSMftTtovB5qGKWl61y3Mn58ji3eMJ5cSFrjtYD/9fbZW1wdi2gmPy/a2negaHdC01aL3Jcgmh7qTEo23lVUrRErnN+HEHhH/N9XvT7XCvlSo9eMqLSp6E71DjlHDDClAP92B9LkDk7/8/D1Z8tjxFmxEqfJY5KhRPDxVH32Jf2gb1joNtOi8xSpSJW0eSUZYYTF/6v4DR5rKgtp8j96b4SctAGg4TObgdzX7OUsH3vNvJtmlXkqaP9J1Ir1WdZemQV8MI/W5uhM+MQ6o1pZn2sM41Q/lcoUoKJL+1hWHBsztsf3yg7D+vREIcKlp66+Vj27WF0qqp2x0HdqIvu1Qw6K7ew0ZQHgAq9n54jE2t8qrwWJWUc2KyM30BV8Yr1V258NKwbu0iPzMqW/HCEhJyiE0CnejxkJX+29wGsnGaiSCGcHoc1mgI8hHMQRzxvwLqj3qwYwQR/Yj/zPmVaifarsNJ+dz8KX9Fl78Nxni5EYx0wXX7aTP5ZaQsSg/6j8ZKW4gk5L9DUex21mjLn4fxIHbFTqNps7PJGZYhDo+HhkdTGi3idt6MxAjEhijdfyjj5IV9k89z4ifYc3zFps2basptiQWVnjjma/YtNL7OXr5dpURZ8rMeZLRuxAh7uqerTGohgH/Ojragr8E+dGc18IUH99AgDgfcGunEmFk0Jh3ZczaAa92fX3ptZnR7F35OmH9eT7I2cnIGNzfto/QhQXZm1EI4mOFtemivYezDQCaPeUhvWLjHv7SkSz7IkGSt/Z1sgSU987VDwAG04
 Ijw9lQXE
 hExUGbcwlxUF9Muxgj6MkFWOeboW+pHI6CL+vsKA6zcKcC2u/UUh438HXvHniuz7Rlf2grS6lP+rTqESLTIx0vzpjiR27zoMFRGGnGIexlTcNaHsHzcHpqEvu74deJBe4XeO4YBzqJWX+/WzaOnpifQ470v3YA7n+DN9oe+iuwHuf4GEquPr74uh9ExPooLNb0p7IGQ4ka7Htju274A8bCGbWBn2iotuOPuUpjMfKxL+kQRgmj4Qe500CWYiZ8FdldevK2TQikgI+g0KsHxFtSvVDkoZte65pTfsP3CBpBsyXH4POGC26DKw93U43wKAvLfo/jOJN8GdqsT8tE78pGw4+FNagx7ubx6vXEiPvkXHaF/4320LEdz7DpvPw6xOFpAhkmDiiHTD5FMsPQvPelMWd5WNaGqBc8O1Naz1jjy6N0viTGVW73VI+l7LhlXlyZ6dDun5ilr/b0u4=
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
index 8882c7faeb32..759e1640746d 100644
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


