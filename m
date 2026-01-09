Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE01ED167E7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2726B0088; Fri,  9 Jan 2026 04:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0416B0089; Fri,  9 Jan 2026 04:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E936B008A; Fri,  9 Jan 2026 04:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 161076B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:43:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62E76160411
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:43:47 +0000 (UTC)
X-FDA: 84311938494.04.DCB27A2
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F0A0C000A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:43:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OfSy/0C5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951825; a=rsa-sha256;
	cv=none;
	b=m885CK9JYIe8DTVWe59n+vfZKsas1puCCrFfXlUQKzW7pOhvEOZ4UAcvX3U1qCTpnrQQYT
	I3GfuhyddyybDpqCcwVUwHpSm0qnG/6SpeVlAQ3YFkn8w8ElmluinldPGHoryFhPEPFXh/
	sC0PHBPSMq8/TSOE4FwKIS5lwLDbGxg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OfSy/0C5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fVR++7bqwaGzshLDMxL5A3NUDG9yGpndgGQgdOmBwC4=;
	b=DIfhTdiYZK48QsE+JYH4n9rrAeWhPQltspqd6xJhc14B6C8VDfauqIwpvsshIajoAYzS8j
	r8A/UQf9M1R3pm3unhbUOnpMr3qQZ4MCieT/axMlYVRMXclPTaO/VxZj9rSMZG8qWEiBDt
	kyErxEqx9QsPRcRK1VNw2r/T+oxxwP4=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2ae61424095so3759273eec.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 01:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767951824; x=1768556624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fVR++7bqwaGzshLDMxL5A3NUDG9yGpndgGQgdOmBwC4=;
        b=OfSy/0C5qKmzU+7p3xDz/y2TZYVzfH24UW+oVHuV/YNhck+X+qfBHjlv4TN14+vAcM
         Rto2owteWbNeKmSFEmDDLeWHqDfthRYOPVT7vjjo/Ye3BqLavpwhIrgiAtHVsmpPjvOz
         Q5j4GioDlpSrNODT07iTqnWyBM1x43yruUFbtg519iVn/baZdYxaD+cTZwVuN6pq/1JS
         UCQuZZ7HQfQEO8vRutheB3sbcdt7FPypUWtJRz1rbNj0QVU86ZzOclZIPGvyPxbuIVYv
         3MvkGYrqD8L1+Eu8ej/7xW10J6FkzWTxp0RbfqnS4KQ4zNeROIlX/PMn2FemH2i4oeXi
         YPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767951824; x=1768556624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVR++7bqwaGzshLDMxL5A3NUDG9yGpndgGQgdOmBwC4=;
        b=sd3HhxqgtSpUOygH9lrG+wyrCFo6TaMoAvpEy3CmnVHFJFU2cr28IyBcFJV9G4SNJd
         spHrGFRpsLmVUCGolA0e6b3LMBFB6h8WhTo0KaoOXuRF2Gv8yyQCHSRQO7YtpgjFwIzR
         0pUpSN9+N+nn2PwMidZK+uuSOITY+ZW+xqBgkOVYxTM/hsfG5gQ640hj2ISoH7SG1O+e
         yZZib6TFSFbbz63/OMm94jeOfOZhRN+CGUVlaVVwxO84VDC7l0TZX8ME3jlPFU0+4fxT
         pex2girANKbNDq4or9jPmvRd0nvnEOqwyI+YfTJ1WgwsXROSaH9K8gls/r2Z5eCanv5K
         sLtA==
X-Forwarded-Encrypted: i=1; AJvYcCUoIRkcBHwy/mHkvNuPnI7XGVgbFJCK77M7vstKFSttKlc8/a+1s5CjtVbwwKAnbPjCigfTFuywAg==@kvack.org
X-Gm-Message-State: AOJu0YwI01iLCqHhPGy5m4KUIaefIezjucOMGek72XUqbHsvRL61TD4o
	t+PBMg4xpuj0U8CRabdPjFiKRMLod72EP/OkHIWxmat7D9MVxEyvMzd/
X-Gm-Gg: AY/fxX6qMKM9jwIw/ao0FmT4n3dOE1jo9EWyp/bkaWKvfqtW/5TWxrtFXrMAK+zcX8j
	sWOG9g08z1eb3jSu7htHmK3cM2kXnA8G9zONQXnXaS7/EJpM98Pd4Tvh7yN303vdKrEv1qpK4Ac
	v89bS7hkhW7Rb2KcGMlw/sIXqedhVheXuw4r5I8xNi91xYMomZWCeYoF4Dh2fIo7HG3njmVEe7w
	knC6y+K3rulAE6i9ddry2xAdOJQqj3DupkEOiIKllvZlEI59UIx1ebnoYP7vrNtQ1zSNDJTGfkg
	5bKlyuXAZXdeC0QJABzZs2X8uyDJ7t/bhV6cg015v68xR0mBCnlX22B1QVWdLEX6ofOl663TP5U
	Bcrdr616ZRR0aIigdR81UWrge/zeXSWBlCrXYsnUoV/rq6Qc8sYB/6+6O4Lmtd0mkCZShR4xeJ0
	FmWyjIV0cnyPVrBHYTiLVdFpt5OfSa18zKUjIFuaCgTaz7k7V4fD7TKA6HnZUeKJKoYtM9GpcJL
	lKpIlLE3zwMUg==
X-Google-Smtp-Source: AGHT+IHB5QJdD5AO07uoxln1g3xpAtBnQnQZAQqVFp/MRhQwe+YcNlRyAU1jyANGoSCE9ePUYdnK/g==
X-Received: by 2002:a05:7300:ec09:b0:2ae:2bb8:a6fd with SMTP id 5a478bee46e88-2b17d29cd36mr8621603eec.24.1767951824225;
        Fri, 09 Jan 2026 01:43:44 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1706a53f0sm10743499eec.10.2026.01.09.01.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 01:43:43 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] selftests/mm: ksm_tests: skip when not run as root
Date: Fri,  9 Jan 2026 17:43:13 +0800
Message-ID: <20260109094313.52307-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F0A0C000A
X-Rspamd-Server: rspam06
X-Stat-Signature: qn6j8z3dwzgr475jos1m4nt5e69pjc81
X-Rspam-User: 
X-HE-Tag: 1767951825-867716
X-HE-Meta: U2FsdGVkX18Yn8EI0IiAdwxchd0UQ0H0OzDn41orVNvI29pH6mJJNgGRtW5q9Fm8ez+ENTHXh1cLG68+sG605XfhVcoOnpcFK07nHieJC8d+PGCUNLF4Dgdl37c0SnWHTfvDaC1q+GheZpgw8Z3JVMC6oNaaPmSusq1RcTs/AI+oAEg1SYFE3EuRJft0PubEgeLQsQ2AS1EFSPJLz4LdATOUEjMhCpQ4uLokToFwKNk0NsjmT2GCDvwzBRASXLpHp8Sf26SAs5yW/1WF8R1gMaLoqC3Mslw+/fr9xMdxLoA9wlBy6t4HUFiUBHqFnkJLQjov8NPD79S6eMd+2bbgTUBmLx0aNhfsF6FonTquRQxTYbjjCLbPSaeq3OYD3ZaSvbETcQrsPy00P6ydQWfw6igi76t0sXwsLwdTFLTDW3CBftRvJ/qYk+XIpVlUmHqrFcC2N0X69b7gGkavreL7x9nMzGiAbu1jU0hoESpqNR8P9aB4KyDSIH3QFgOXZpwcZ59O2xs3ZtIGz11wz45V0ffsBU9A7xQDjEJlqiIVg8MzATAa+MqDcBTjoUSu1rBVe/Pg16oe0LGq50KN0eQJt/miYB+/gFZKdym7U7zhN2Ylx06cmtgNU/pmolVVk91MXcxhIBlBkOPMeP1Rgk7JcybUJWkv8Ijj8stnVW7PUZlNq6/5gnZgnuVEmZB0GqBlYfTI4sAmWwXuJeZvpOxWvFbPIRRrf6y4viQEmHNxs8+64OsAke902IXW6rJZmhtFCDyJK4E5HIlRDUwjYXzNi5taKfCFuC9unkeFg5dOd4TIfdOoRANHnpWOkduZLTLlMfTq1k163FMgWx1dg4K+jyK0vqv6kYFHdZ0BeU/ytzAXXNN2VDGV246iDbKmvrkVedOqodYDwYgzxXaOtP1fNtECX3JutPGg4t8FmM7g+DHRNcQQVOPaktpXLzBQ+D7bfVaXtX+cq3Kc2cONeff
 6o0YcXs+
 M37LPRBIvAKr2XitBFiBtVHCO4J8+UwUjRP6UFiSy4301K2zuIbKZ+2glyMPP/jnI7XWtjQ97BSBKW0Ke6qI6CVjXbSH8ichZPfiPuu5KNaDyPMkCRWWIluAvWGt8F2CFvo6o4OzOWI6CvOLBNg+QMuCipuDkzOw5mouXBrZ55jakPA+cbc365hRcpneKLHzIOptGAW9CjN/JV26teo7/npUM6b/4GzG5ba7Ss/N4+2viWUPgzLSggB0C8Ep+hxTgvTMnVKylgPOUy6KmZzblZX72VkL8ZytZ8pJYJyS3afC+Nx+fUEuOBgWLF9Gz1qOz9F99JSjGa8x2NlBRCyCCQv5GA0lyNxxb1lq+E5M4zcUOP/OlIHWnkq74IKuMZaDnVjn2xGx2AKDGn/bVNWsAGn4/biCnMTg99O5HmOIESiJG8f7iowZWC7gLRY6l7S0qMN3CwTBUQKIZGKiCWZxO/buaw6Kic0+OMNhicqN9ZmaPVC6QuaOgGLsbgJDW5ztS0LFToU/YpYeE8ihULZxtn6ziGlV/g47CtHM/Kfs4PS16tVDOs01ROWybvguEI+wwD9yMnVjLD9t9vaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksm_tests writes KSM sysfs knobs under /sys/kernel/mm/ksm, which requires
root privileges. When run unprivileged, it fails with permission errors
and reports FAIL, which is misleading.

Skip the test early when not run as root to avoid false failures.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 tools/testing/selftests/mm/ksm_tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a0b48b839d54..c22cd9c61711 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -766,6 +766,11 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
+	if (geteuid() != 0) {
+		printf("# SKIP ksm_tests requires root privileges\n");
+		return KSFT_SKIP;
+	}
+
 	while ((opt = getopt(argc, argv, "dha:p:l:z:m:s:t:MUZNPCHD")) != -1) {
 		switch (opt) {
 		case 'a':
-- 
2.43.0


