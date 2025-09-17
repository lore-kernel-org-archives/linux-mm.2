Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509A8CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB548E0015; Wed, 17 Sep 2025 08:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2CB8E0001; Wed, 17 Sep 2025 08:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0BC8E0015; Wed, 17 Sep 2025 08:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3178E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:28:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F4991DF3F5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:28:15 +0000 (UTC)
X-FDA: 83898669750.18.D209C7F
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 484D01C0010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:28:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758112093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=qD2fpIrArmTyZxxLn48nFl6F/9cW6IoNw/VXQ+AiGyg=;
	b=ijJAazPrTXNdoKfBkMoZXD1gg3cHOLBTsQt7PvTGHVrOKuSMTQFn0pjFDreygchbgBc3UF
	UIZZHD43sm2MbfGkT+JDFWw/djK67yFZjJxPMNZPpK//cS5iMrhhPAz7ncekTtrx6VWsG4
	99Sv2QBIOQTDpBAk+igrBiWCKU8+x8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758112093; a=rsa-sha256;
	cv=none;
	b=lkrZ3b4WUkGqZAYbhjhlopX3aZG0UJplZCM5Rn2Bnn4qHHm/1TS0NG9Bnawjp+ngXIbx6J
	0jNcYoygl+vKDhtag3uqn56+/iAu0Ang4NJNqcALJTTvmrCvKxFFT+lsZqbmHuAiCWHyGW
	l4tFc6EvysHwI4Tbe5/wnM8kvdgPuhg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3e9c5faa858so3840563f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758112092; x=1758716892;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qD2fpIrArmTyZxxLn48nFl6F/9cW6IoNw/VXQ+AiGyg=;
        b=jDrPvoDuefKc3Y/pR31N9yppn0HFFFQJAtV0XxHNAo02EOu8J8kUoEe3653TMomEo6
         Q5IaUaHPUUOXg+X8CF6NwJEr26QI66dOG3p3yheovy2XgztjBIc5Z2298T4BH0yQqTrJ
         n7oPl21UOX7A/8QticsLAZBmJZUgtYDokVrTyPReiml6GfxQtb0Pc0PZ0GKD2iTVx/DQ
         MN9GdiTCfbGAdBCfwAmJ9Egekwe6MNCNJCLQw7piJmvYJV3DkPs8aj3yIXQvl17o9Vn1
         hUjaRt5dF0GfqFKb76VKeo0/3F0X77fy4n3zxNDyai1+PJ6lAM4BUYTvKFpYo6IcsOlQ
         MgYg==
X-Forwarded-Encrypted: i=1; AJvYcCWsSOrctCGQMtlH0OK6+bbRu+mYkGOD6+d+kCJBZ1vhtT7jcWgWV034KRcL+SVXESten22K8VrtPQ==@kvack.org
X-Gm-Message-State: AOJu0YzXBPdmjFh838uGKKAbZRoB3l4rhc068lzXyphdu1yiYjeF/t83
	zjtF8ckE9cwdqDPnft+y+ASoIcXUPiATyi2nDMOYP2fvh/0JHgvGzZd/
X-Gm-Gg: ASbGncvCtMowurYRUl36M5W0lqeowGEHXZouwIMKMBDckpqj8Km3cQYOOY+j7J2rSO1
	I9/nzQM+cKT8snDMhKnhQIV6ciFWlmRPwg5BRGijeF7NmaAUY3ezjQVmHyM0/OH2rqj90T6tUiQ
	gUblwjbrtx7V6RjMx20j8fcr03iFw/ZykJYVHd59bSqMqR9zHaz5MkDDAgrZwzo+6irtc1pv3zj
	FroFMJSDKAmhQzadV0i1UgpsJZb0MiPvfCr4DtJMcaVL7MCexjoP6FULs/xi+a47u60fK6NqCwr
	4ta6wabdvEGwJd0egaWRBkNxki1pX2SSRyiLg2np2CxGoxjcMV4X/fUBJWAvLFykCY7GP3btlXa
	v3hYkBifp
X-Google-Smtp-Source: AGHT+IEhRdB7nBids5w22yMAJVOTFKi7URkF3KNMkIzMofyDJUedOPZhjL9ZUsgPqYsxBt2TT+mIxw==
X-Received: by 2002:a05:6000:2313:b0:3ea:6680:8fa3 with SMTP id ffacd0b85a97d-3ecdfa35214mr1949003f8f.42.1758112091433;
        Wed, 17 Sep 2025 05:28:11 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e911188fb9sm16275658f8f.28.2025.09.17.05.28.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Sep 2025 05:28:10 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: shuah@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Wed, 17 Sep 2025 20:27:50 +0800
Message-ID: <20250917122750.36608-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 484D01C0010
X-Stat-Signature: yo6ahcfi9ozn3j9z6sti7fsb8x96d1bt
X-Rspam-User: 
X-HE-Tag: 1758112093-969291
X-HE-Meta: U2FsdGVkX1+ZRJEfiCORoplqzRh/vzU6zHmAG4dmRSNI4NmNLKTfJVrQ2HTbTvK3w8pstWXnfmDXLt2w+dIWzQKsKDg8j3GBNil/a6qx+I9GSSq//ZrQn1FgvLSfRhKv0NnlnoANFIyfamVWHgOz8otDpwh/0lli+njQL0IACj+CrRDQhm8+sWxsIaH6AMxde1+UCkdwctTqj1fqYLh1xmUQFpoTA5t46vStrzRAHAS9YrxeVB1x7j8rCXHqhtTnAWDSitP+WS97JX/85hpuwzNd0mZv/oXLH3YzPtkbYCX/r6vqzV4L6iPtKeEaVPDk9R4HUtoa4j7LkWk1GE40jHAWm72zBoKIa1oGTNrVGnrGqwl6+okIticSRX3dPwzUnx7h+CIaek17Xn7m5qUaT6brwdoc/bWExI2//E/jmH10qNpKt5/D3QsvLaY4idpGr7U5f8NmNxtpKuwwgOhQCD0RhpJ8tKwoUCsz3H64oaU3FMzERFSY8Ee5dPknvU1+u309XBE9qR4s1sif8EC2OA+3RB3WTP5E7zPrHjmfIqaPk05g3VSdFOv4iOJ+M2G+m2Fkox9ZmX125MwyTojhIUAweiTsHOLL9iugm5dJyaYqawu/lwJSF7Ji3f0vB2JlCYLS7uqXNKm+I21xC3TK0X+INrwWFxwG5Nt1+FBhz5lWxANQFbqjr37PjjOrUUDNLeWuDGeVEjERhUae47EPRThRxFKJRne6w24IjQIcYawHPC+A4gcaj8VnrJRfuQFnWOAI4/3vv/I5e6bAwieSNXnqwUwtkh5bfpKvv8d3Sn6cviF5fpRyO0kYEUifbpLyizAfMNOVgeo/xKrO81eRQz3hG9+pRwVKUCplAQStnav9iW/hZaG0QVNGR8N5/Bfwrx+BmDzEcyW+XoHKBYhADCreoK6Co4wli/4siUq01fcSeaqlNHTkSuseZESjZHTcrIf3ud+TW/rPOjzun+L
 9S/F03q5
 DRvdSLheV1viIKZWbjhwgxNhmwJUJ5szY2gqQ0jJwoxJdcaIGqNnQ3iow2ZfpypkK7z0mYQz1+MuVDgQrzrY1Htc2kEkA8pHkxq0qxA0Y5E/Nb3wGn90w3WzHsZu0DgP9Hx9EJBfiN+JB70/JUpKBkhW2q3rkOEqxXgYvBYOqSJEhKlINd6x4C7DA6aaSgcqTS+kpc8o2+xl3wQMcyYgU7pwan+ZI6j5vN5OQwPbYejJDmVQREpxfFMeeiV1o7DsIAwtyYlCjSNvm2B/Q6HtrVuramIOfJsdxK0AdJazoJ86FKCi24nIzZnJaY83LExvH89fCmnBr7lW2yq1Iio9fkM4eDh9ZKLADaThLf1axWPMUyPXwE3OrEuBYHFvFMz50eijsjUfOKeaEl/wIyNHeb/G7GPyJR2RPKIvb/S8fb3Y/u6n0ZxP7qgoj5Tg/Wag+Gba3vrqned3fMBKIv1gNKzLmrcAX2ekY1qFDloi1Tn/N/fv0TYOcYeaJqI5cf12wi1LQkfCqLRiwDm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The madv_populate and soft-dirty kselftests currently fail on systems where
CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Rename softdirty_is_supported() to softdirty_supported() (per David)
 - Drop aarch64 specific handling (per David)
 - https://lore.kernel.org/lkml/20250917055913.49759-1-lance.yang@linux.dev

 tools/testing/selftests/mm/madv_populate.c | 21 ++-------------------
 tools/testing/selftests/mm/soft-dirty.c    |  5 ++++-
 tools/testing/selftests/mm/vm_util.c       | 19 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |  1 +
 4 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index b6fabd5c27ed..d8d11bc67ddc 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 8a3f2b4b2186..4ee4db3750c1 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -200,8 +200,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 56e9bd541edd..ac41d10454a5 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,25 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool softdirty_supported(void)
+{
+	char *addr;
+	bool supported = false;
+	const size_t pagesize = getpagesize();
+
+	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	if (check_vmflag(addr, "sd"))
+		supported = true;
+
+	munmap(addr, pagesize);
+	return supported;
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 07c4acfd84b6..26c30fdc0241 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -104,6 +104,7 @@ bool find_vma_procmap(struct procmap_fd *procmap, void *address);
 int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
+bool softdirty_supported(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.49.0


