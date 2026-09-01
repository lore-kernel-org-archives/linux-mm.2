Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9785AC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601D96B02A3; Tue,  1 Sep 2026 12:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B996B02A4; Tue,  1 Sep 2026 12:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454396B02A5; Tue,  1 Sep 2026 12:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09C916B02A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:13:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6472DC0479
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:13:21 +0000 (UTC)
X-FDA: 85165688202.21.AC3A05A
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D7DC4000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:13:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=laOFvJ5m;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UrvqQXAc4Rj6TaVLaR+TE3DlGs7BEo7vSNB4Ui+eyI0=;
	b=hD+LUycbsSkLNZt3d8pT2EibcljJzcQTUjajZO48oBebqgtbm43o13MF2rNwQ/kfcO/WBn
	kjKqPpga5izEckaDbqRDsVyu4WmOYDvYkGripgfAftoKLDnV51NGCyD8gzv8LTMOcj2MmB
	3Z5CIPkVUK+2QUPbiSf5Cr8PYQkBzGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279199;
	b=fW3F/CsAYptnY0KP91TY4IfpaE5WoYML3NrAt4MaqpEAMfx6TQgFei4wT8VrDrbYmM/wCT
	PzK2cHjxgHXKERBIZgDIFysPJvWXQftA8blyXGxEHQ0cimcZw3Ld4pHtuWm/uq6480qq9R
	rPzYe0B5aQ9aKzezTR9ErwV/SEh73Y4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=laOFvJ5m;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-469d76ce704so17424fac.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788279198; x=1788883998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UrvqQXAc4Rj6TaVLaR+TE3DlGs7BEo7vSNB4Ui+eyI0=;
        b=laOFvJ5mSXCs0sZxBzs9NBXiFmf14AXXWzZJknG12saP9xDJFz8yY2/Z0igAsO4dON
         aWMp4ssrQwqdimidJkN7F5P++Q5R4PeVnmya9OBunvse/EmcNwvIDsGP07MbOONUjxl/
         8CApYpe9BoI9Fm8QrNkHOoZVQuWogNuf4Q+aIZ2M8oMfzGqlf5S+VmsdFtl0JLXkXCeF
         zn+SSgPERUO8Tnnqjqs0uA3EMHtPfNHUBznPjt0eUQ6opqKxsdK2bUrm2aaPfC6RfQOP
         6MHHl0gSmENLJEoEoFzvdWfs3FmIZvAnNGGnHkrK1dau8LsxS7SNvSbe1em+8dsbzdDx
         nR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788279198; x=1788883998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UrvqQXAc4Rj6TaVLaR+TE3DlGs7BEo7vSNB4Ui+eyI0=;
        b=cN3vJkrwMG/NmJlTWfrTyJ25OYb2KyYkLnMxSoVrBd1tJwwkENPu9n3peiAGDX/cA9
         qJwT88okt5LSHP2hpMtHWHJG8P3Ze+rsMkamxsU4v5dT6Zcp/zT446qI4075uCjxd2NZ
         IHX97V3k9MoYWOxcjxbFzd7zKwyiu/JCXw90/NSuIfqW06+AU93ZjQ4MWoUrU0zXMEqh
         QyMVIAW6vBEfPoLb/HDIW2hVcBSRTNLU83KbGk6FD4zvWfvn3uaRemNo0glm/U2DZMfp
         ATD9FKyNILp1Lqc+of92o0xj1yE1sJojvJv1awspYZMMBPo2FJe3uMoNNYWfL9yVUmA0
         5oeA==
X-Forwarded-Encrypted: i=1; AHgh+Rox/01qDfiHaLt2QDuW31pC5GKknHhLHpLGUFaE42e+zjdsc8EUrvOw/HZLNjeZPw7rR3Nw8mtkgg==@kvack.org
X-Gm-Message-State: AFuF++m3mEUVn1/XT7ye7qXaCovLK8rtsbEFcJWEwANiympvcLz9jisU
	49h9ATYailIGrcDRbDOYzfOFrqGJrl9BenLLvPSkbtIhKrFl80O6zPjL
X-Gm-Gg: AR+sD1061qRVaK1cT66Qseap8w0Rvd9Y2sFZzbI9rjkingHeY2MnDJzrDMi+CWr+VIh
	KaHHhiEHnAQzlA4dyIutyqXFhzfnPBMFzJog6Osy9F67cRvNC1k49PjQ0SSTyGZoFlyPZBk2U9U
	2kxAto+NtyM0vdA81bu7o0sLpBw1HPn8O7CLtR4XyuQPBxx/6qD076h8vmIWRv+H3oGJCVXYmB5
	FNpxp8jhChdDYf/ljRSwVZHgUeYJXEQD4j1HNOELYSwPhEoe78wxa31jzPxC8jOb5OIYiRDGbty
	VD/JWeJaAq7TwLIEtO/iCr3wxjguAYSKr4a0yva3fbFDdWwi4d3t3MFi8ZdyQsFFeab4022KLKp
	5sYKDSTqzwUcl6FHIpTbJBj72svgRuoa6yAnKaA1KMD5cHK/WKJxcF638pOUhETlaVd8oxJ1Uds
	KqrkyNmmanX99JHHghcLCpMHY9SlAuuIwLuWjPueGTciBW11kq8min6BIaejIRsjsfCThcd8YB+
	oyuTaCJd5uzn7jPaHaEKbpbcUaCYQg=
X-Received: by 2002:a05:6808:508c:b0:4b2:8da1:3be4 with SMTP id 5614622812f47-4b398124cc7mr41327362b6e.9.1788279198361;
        Tue, 01 Sep 2026 09:13:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:28::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b3a19949c1sm11563412b6e.10.2026.09.01.09.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:13:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroup@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] selftests/cgroup: Skip test_no_invasive_cgroup_shrink if zswap shrinker is enabled
Date: Tue,  1 Sep 2026 09:13:16 -0700
Message-ID: <20260901161317.3468233-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s9n4dpf5fekioekb97yajx4q6xa4gjr9
X-Rspamd-Queue-Id: 9D7DC4000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788279199-815100
X-HE-Meta: U2FsdGVkX1/M78WG1Mq4zJ4wWEtk+We6v2CcTqAE3nSK7GtlEYzJk03kTtNeSsbSzaWHLmKFzsgnQO6J19K30SlrkZmZcNoqb1y/3/flrJPd0nyaktcsqRr2fUMACdFC/yEJoT420ozzvXD5ZLde32DuSuuTpKJ+kvNWWo7v8QK+SeUgyAF84WW7RrhIKzGlLWSzVzRWY9YYccQ1kaMi9B2y5r8U26qKqy7PYNiqDZf/iurSjHDyzOZ5XmXZS+K2hrAIHk6Z4lsXVaFSLbCEzylAvAXnhXbL1nI+OvLVSXTB8m2vlc7jY14WkCWIlXEWzV2hOBHlsikU+2NJFg/N3u+S2ui0u5Mr0OsZpTCrQ0fozRYDmxH/KgrSzBEQR+/Z4Faqis1Dow72Dg2TFqqL7AuquxmPYzBM4QkGH5EtotwPjcguSdQ3geHyoJacvyqn0Z0Iplcmgt72yhd6a5ozz2Bv0xLbujG2ti6pZ1tbzTvEWkn0vQQWji60NMAB3H1jp+76Zv0Ez3E7bo3ojCyNvhJHukQByIvzF9QY8ai9wIxt0OL261UZGTL7Q85JYOK/zsvxho/AzT8fpv1nrUqkr//41tEYIznqkpT13rD2belSfVtqv2qaXc6dou919TLmuscMwOPyeM6qDcMhibg/KmyynlOTc7tZWnFdXtARxOx8cxsQiNHjOMqYU/qFlWK34GwPp7VIRqnyspJ636zoKZbnWL8RW+YnDypaCiIGoJC7cqCbz4Eyqd5rOrbvODs20Ig2AUkxnTkQGRNgkIAoIReZL3KUOh/lh2p2sNdTykHU+6aVXHDwnzZg/1UUIPPK8TW+9M9if8k2NPYw/nifme9foK1MxKW27kEjB76KWLOSOofM7z0LlVGoFlsm3aLnIk1SBKbhzF4UIa5l7iXKSQTtFhevr3wW3hvR16p/7DmeZD242Ea21J0i1KH9tDVXThMLDGh4W8TjzdMmWoM
 AJfT85s3
 l8jK2b6ymlcH9wG7mrASndwLre4iJNgaH0BPDrIZOYgmPIif7x8Hadz3L9P1isdC+H5TC9pL+ejFcQwgu9JEpMmszHBFcff0eeOZRruzoUASEsm2P5MPT/PH8xRv/AVcLpQkqCX0F43Sk3/Ujzzyir3sQvAnTBVWw7LUrQ30HNVM7v1sEUGSpMLz93Hc/NH4EYUc36XIbchfTJt7aWLti8ZUSad7xCxFjuQz8n5G2JCi9UGxRSSLSK6XAR+TqJFra77IQ3UjZ9neHkUYNu96G1VaWmNTM5VZgQmMvKNtP1gnRTpkBl3KuF22wY80jhSQRSa1eb5nmR7Wo12jtoticXC3LxGC9dmHt9v2uqhi16YC5UVdwsjqIN+aGpzExkRTVqo47IaLsPDz+Ts+hKZWiiCN5juhakPUx11RROB3seOh/ZTyofpHCtwEa+q4rLuFXW8O9bznuxcIOW2ZHaUiDb6nl51SffVhvKMSkSX2XZ/a665X1n3S89pk4OPZ7/bcmIR0PucWQGKaNNVqog1hNMQFRnqhkBJWTG8CzoX/GE+T3OcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
has zswapped out more pages than memory.zswap.max, that it does not
trigger writeback for other cgroups. To do this, it compares the
writeback count in a control cgroup and makes sure that it is 0,
and compares it to the writeback count in a aggressor cgroup who
does expect to see writeback.

When the zswap shrinker is enabled however, there is an additional path
to zswap writeback, which can happen independently of reaching the
memory.zswap.max limit.

The writeback counter cannot distinguish between invasive noisy-neighbor
driven writeback and the zswap shrinker work, so the test becomes
invalid.

Skip test_no_invasive_cgroup_shrink if the zswap shrinker is enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 22 +++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 9c5bd503c3f73..6f9b5c631d030 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,8 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_SHRINKER_ENABLED \
+	"/sys/module/zswap/parameters/shrinker_enabled"
 #define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
 
 static int read_int(const char *path, size_t *value)
@@ -446,6 +448,16 @@ static int test_zswap_writeback_disabled(const char *root)
 	return test_zswap_writeback(root, false);
 }
 
+static bool zswap_shrinker_enabled(void)
+{
+	char value[2];
+
+	if (read_text(PATH_ZSWAP_SHRINKER_ENABLED, value, sizeof(value)) <= 0)
+		return false;
+
+	return value[0] == 'Y';
+}
+
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
@@ -461,6 +473,16 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	char *zw_allocation = NULL, *wb_allocation = NULL;
 	char *zw_group = NULL, *wb_group = NULL;
 
+	/*
+	 * The shrinker can write back zw_group's pages despite not hitting the
+	 * zswap limit. Skip the test if the zswap shrinker is enabled since the
+	 * test cannot distinguish invasive writeback from shrinker work.
+	 */
+	if (zswap_shrinker_enabled()) {
+		ksft_print_msg("zswap shrinker is enabled\n");
+		return KSFT_SKIP;
+	}
+
 	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%d", page_size);
 	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size / 2);
 
-- 
2.53.0-Meta


