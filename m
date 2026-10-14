Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4424BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B376B0098; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93C96B009D; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71536B009E; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5E16B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF049C074D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:12 +0000 (UTC)
X-FDA: 85321990824.05.1ACDFA7
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 295C44000F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c1WjLsCZ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj29K3kJ1Vz8u8FKLKjpbxQZ7NU1kf2WCV2QOxB9gM8=;
	b=h4R492knIbFXIEHfi7SSxOQvy3JQtiwWl9NlaliRQ3RMZbpHHZz2IBt9MCYFFSmZuB+FhT
	GxxKDtfmDqrDrvjQKN0OuLZXHn/85qddtl4A2bLQg4gygFbnGTk/EBlzwOgALnbAQhkgNR
	62nPsotoiNqtmD9qHbnSYbMp12XGBF8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c1WjLsCZ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000691;
	b=Mu63GBulQ0jd8Bg71mWSh3lI3EvB0US7ZsHJJrWl2cvo3pdNC05jNtSItmSpd/JxejumJ6
	Gke/HkR+hYAxNKQHwGrhyLHLzLNii7v+IjGakPhxzmcrV63WPnT1vjjuRPWpdp0qZvUU+n
	o5qTKkuNx2pzxCOQOAhicgvFOp9GFF0=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93a40a9a01aso172964685a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000690; x=1792605490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mj29K3kJ1Vz8u8FKLKjpbxQZ7NU1kf2WCV2QOxB9gM8=;
        b=c1WjLsCZ+7aygmUUp6wq/iy6V+Tfh1OROI7KecRQFVWZgtnCNfHUMyC5sx4p/fZrgK
         kxQQUIAmIT5UBSoiAQM3xmjX32XR9tyUv0hrwYw20MwVDbsdOjNc4XNqaBnG0dAipmP9
         h8SLI4ZPw5KRIqCbqJeZ84Cz8kbio5FgoCRDUd2wrqNVDYux5OoMibKLXkOd6A0r7Kbh
         FtyPuGYw+q5nDbqF3IgJzA2MoZ8H491De4WXywne3bfi5ECEMIkrPdOTpwpc9+K9FdlB
         YxTIiJoq/fEQJ6axkdx7FDifLGVKp5qZzOQgvX1QF9FtzuuB6hKGlBFjHRAvAexky/NN
         WQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000690; x=1792605490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mj29K3kJ1Vz8u8FKLKjpbxQZ7NU1kf2WCV2QOxB9gM8=;
        b=EFOPPk34SI9swpiorxj6KeSe5m5+oCzNo3luoomIlf7cr8xgHLCZ495HA0RgBI6u/0
         K7/FBJsT+8srJZsKUFgQCGTiAXvVNSTbR9qATYanvhjp1RYjDdpz6ZoMEnrVm7ruOb1j
         ABsPeuqpLxxbWARFOJgIEWBjei6UnzBYaO/ExPWOpgCIzriVRVfvlLgPxGgGnlBPVZvo
         d5Vu2CCOoKa+ImuLdWxky5MLkIYA0FOqQAmh4k1cOm0DBT5buS87jqVwuXSWHIrXT69C
         ReklYMnejcjJj6Wcw9Recj7WQLBFy/k+dk7SjbBTYUHMtbHLtqXksEtsSM1B2+Wn3qTC
         am4w==
X-Forwarded-Encrypted: i=1; AKwUvByaC/IkxxY8oZ6+GkPsAVWZSIu1DrEz0tzkxOmdOJRJOBLHZMTnQlJEGrvSiJ9ACCYE/p92UUIp3Q==@kvack.org
X-Gm-Message-State: AFq9FYI4HANS1qYOXnNFxcliUDwby999Z/gPnVWG1uzfaqFLdzOlx6iY
	nhSxh1XPMXWQcP1DtNlPXnbng3rMQabbadbMBcCeotWiHzEm8n8+lMXaGKNCzxuLXZc=
X-Gm-Gg: AYBFou2Eg14sD1aydX7/DtymMzcjqDTceoaWz4miOaO3dQc6nsp8i1szmfMVOxaTK2n
	Ul0ErtH6JqVANf++QzG/0JdvaisT1q33qLS70ZeSAoFqZZGN47i1qD2Nv8T5QPdejAk1UQbo/2v
	Z9t2dy+dEjInxrTLJYyWc7nA5we+X/3NNGNE1StovtxcBLkASjL2l9D6hJ7GORNoB/iDLygDZ11
	Gb0YqMgXkRoSGLmkYQyrZjT6Fz/q1hwFpQTeVDXyNe8Feoq1Y9mfF4QvwUpJM0GCWt/lZZiWBlZ
	OG8ouxZuF23STA7WCnjYWGpy/YHQAGXeCH0vxaBmmZKzb9mgOfk55woC4oilPfNeSqYUIyYR6h0
	m7Zb2rS6f8oIOSTfOkSaDUk0Fg1wMKbJhKhZpiaEhyej7C1Id5dM3EjgkgRDrXr7pTxcjdPdbkL
	zwp7kSXuQc8blUN7ZOTb3Pr7M7PDiZ5bO/STWxKNB27AqNAhvaR6qI1/A7LWi04MU/EHMCDTgsi
	VTj1Vhr+nCIxHZ5Au4JhzObYNR180CXCGWIV2IAiyN9gEQ+CI454VawLGJj
X-Received: by 2002:a05:620a:444d:b0:93f:231:9ff with SMTP id af79cd13be357-93f02310e8bmr565290285a.27.1792000689161;
        Wed, 14 Oct 2026 10:58:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:08 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 3/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT range handling
Date: Wed, 14 Oct 2026 13:57:51 -0400
Message-ID: <20261014175756.2035176-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 295C44000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: qrsebz1fxgeqsb6ph4ek51fj5raq9iue
X-HE-Tag: 1792000690-540220
X-HE-Meta: U2FsdGVkX193y/tMDN6OXhlvCxtmrbnBHs3KxbAdYeQWxV1EuCh2xwZFHUQYv6foWLP734XdG67y/gWJrgnppZjzGV/SaM4f4bD0kvytmWeSEzMLXGo0YKhMd35DG3h5Nh4WMouxoK92RcJMfwM5ZSsepX9uQ5WH0WKepAc1V70+O8O8ia2cEz8wP7U6QuknV3tzK88Z8Eys3kTdZVI9zpV3TIi4ldNqxLcLaKiDVahNO5zEdKVMlmN/spQNpMOVRb2jVFOiD7q9IhOF3gFUv2Vzk3selSMu/65p5INjqSHX2B3Pa0JA4PPVzk1C2tusrXk/EgOmc/RtVLyCUHeqgxq0tk5a2LfBhcs7cMnBsyzMU6QuhnRt7jxc0Q+ysz0XqtEgbDR3sBxUG1bitM9vJWO4m+9CJD051fIhUIgMx8Zx9p1gWfnbqm9s1CDmA7+7HxHXJfel6GIg53mPsuzp7Ua1StLPX3eaX43GMEIF6l1yLTkl54byH7oRw2JbEBvmDJk5WZqRlsFZV/sGRZGTiB29sBp/uJKfDWo2HUByOINP8LwH4N02pgmc9TDGzlHQaU/Hf+i0kVrSfj7FCYG0VTlg8Uh+C7wxRCSdOuvjJguDb4QZVbRqwv9JgOFUFmcgExTHzp1rzyB9uBM/NbojLbruVCbUOTp/dZvBP//Uad3sYwbFrC7zK3IA1DXPkrmGFsywC8GvJILMhkJbPyzB89Woj4dSAJMsMqIvXn850gsdbhsOcqK3Qfjifspwj/OgZwj8rClOZ0FihXwsM29tL5DdmMKHxrMXgqvPB9mmeEHhn5q8VbsHyX+1UPt+Fytwcnd8/sdimAWcV6M6JbSQMVls5dnJbfiJRZP+kNpRCkEyZhfzqRyRH2HAu8EITnA+fPBas1CTwMiqqYd6Zk8YOls7/kQ8jkfT3bv3iy+09OvKwvBlyN0eqhk0YNHmbtJLYvhcmRPsAYgDiRhp+qs
 s106HKR2
 1sisWsdjH5J+Dm8iFT41AJ6Ds/yhO/GCLGb73JTl6cb6JRZ/5q+klHOvkJ/+y4n17EfRrk3FHELZXjsDPMo6jWS7qxX2LdpFt4Dx/Z3UUwCgs0XOBpcMB5moXoYH1GpxEWXPtQxaKY+8AgRDnsmhbw/DSq/jyVGIbql47jlMYwSH1FRCqVva5tISdPlnuGFpfkFtpv73lO6wdjvcOg18QarrJ2kMo50bfpIIOrgrGL5dyT9BTSGO9UThr6siowmDGC0aJG1jJoMLs2wljCKM79ogiAutrTghFma6pA40cAwpeTwK4N6EdCqtUusNK7dcbxKuklOJ+C0aIaHzd8J4LUtwuC9ZE0HvYNMQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise(2) accepts a zero-length range, rejects an unaligned start, and
reports an unmapped gap in the range with ENOMEM while still applying the
advice to the mapped pages on either side.

Check each of these for both hints. Around the gap, only MADV_PAGEOUT has
an effect the test can observe, so only MADV_PAGEOUT is checked for
paging out both neighbours, after a control page shows that swap works.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 103 +++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index 42cc08fe45ae..f122154fac05 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <sched.h>
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <unistd.h>
@@ -51,6 +52,21 @@ static bool pageout_until_swapped(struct __test_metadata *_metadata,
 	return false;
 }
 
+/*
+ * Keep this task on one CPU, so that draining that CPU's LRU batches drains
+ * the folios this task faulted in.
+ */
+static void pin_to_current_cpu(struct __test_metadata *_metadata)
+{
+	int cpu = sched_getcpu();
+	cpu_set_t mask;
+
+	ASSERT_GE(cpu, 0);
+	CPU_ZERO(&mask);
+	CPU_SET(cpu, &mask);
+	ASSERT_EQ(sched_setaffinity(0, sizeof(mask), &mask), 0);
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -111,6 +127,93 @@ TEST_F(madvise, locked_vma_is_rejected)
 	ASSERT_EQ(munmap(mapping, page_size), 0);
 }
 
+/* A zero-length range is accepted. */
+TEST_F(madvise, zero_length_is_accepted)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+
+	ASSERT_EQ(madvise(mapping, 0, MADV_COLD), 0);
+	ASSERT_EQ(madvise(mapping, 0, MADV_PAGEOUT), 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* The start of the range must be page-aligned. */
+TEST_F(madvise, unaligned_start_is_rejected)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping + 1, page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping + 1, page_size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
+}
+
+/*
+ * An unmapped gap in the range makes either hint fail with ENOMEM, after
+ * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
+ * an effect on those pages that the test can observe.
+ */
+TEST_F(madvise, unmapped_gap_fails_after_advising)
+{
+	char *mapping, *control;
+	bool swapped = false;
+	int retry;
+
+	pin_to_current_cpu(_metadata);
+
+	/* Make sure MADV_PAGEOUT can swap at all before relying on it. */
+	control = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(control, MAP_FAILED);
+	control[0] = 1;
+	if (!pageout_until_swapped(_metadata, control, page_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not swap the page");
+
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	mapping[2 * page_size] = 1;
+	ASSERT_EQ(munmap(mapping + page_size, page_size), 0);
+
+	ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, ENOMEM);
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	for (retry = 0; retry < PAGEOUT_RETRIES && !swapped; retry++) {
+		ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_PAGEOUT), -1);
+		ASSERT_EQ(errno, ENOMEM);
+		swapped = pagemap_is_swapped(self->pagemap_fd, mapping) &&
+			  pagemap_is_swapped(self->pagemap_fd,
+					     mapping + 2 * page_size);
+		if (!swapped)
+			usleep(10000);
+	}
+	ASSERT_TRUE(swapped)
+		TH_LOG("MADV_PAGEOUT did not page out both sides of the gap");
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+	ASSERT_EQ(munmap(mapping + 2 * page_size, page_size), 0);
+	ASSERT_EQ(munmap(control, page_size), 0);
+}
+
 /* Neither hint may fault a swapped page back in. */
 static void check_skips_swapped_pte(struct __test_metadata *_metadata,
 				    int pagemap_fd, int advice)
-- 
2.56.0


