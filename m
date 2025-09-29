Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD7FECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED2D8E0026; Sun, 28 Sep 2025 21:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB7F8E0006; Sun, 28 Sep 2025 21:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5D88E0026; Sun, 28 Sep 2025 21:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6B18E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BA0C85821
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:59 +0000 (UTC)
X-FDA: 83940493518.28.F183417
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77567C000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IaSfjQCW;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ougWc4G/qIZT3q+j2o8YnJ0ye/FPwzyh3Yh9OeHBEk8=;
	b=idtrzzyrxE3nrsz8i+q1Fi4GtfBJ5haJRSLrv50/5bfSNymiSt2t6QfMHtSZ8AcPKmTTbh
	v346jDHiKDPXYFR7neZmfJBL/ne5B5RroeurKvq87vmIomEoGkSQY0WvDQu8Fbjp3R3nco
	N+IKljeHDykOV/pv/w3ZOXmccS3nP5c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107897; a=rsa-sha256;
	cv=none;
	b=7aDq7EaZoJGE0kDkuxCm/EIM1/NO7XB6RRfGAu1ZzCEtabRbMCLZN+z/woTPmBarIwgokY
	LPcg99CSdCbUsvtuqEs7qsQb7gs/C+fJVjsiVNorhWZsSTy3ocaEtl0+kHm2Y5ZT/lzARx
	3smWCVdTkvndlllHM4TVPl7uFVXIwWI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IaSfjQCW;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4df60ea79d1so14514241cf.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107896; x=1759712696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ougWc4G/qIZT3q+j2o8YnJ0ye/FPwzyh3Yh9OeHBEk8=;
        b=IaSfjQCWE5+IDYoJskKcw6/IK9zef9hEtLDaVRy+RKCt34kBsWFVNZHBWLhyq4jAqd
         KFg1hoMCZvq70On5ZPr5yll7lY01zPiBpHuBFDKJdSHZWwP44n6sXGKrDS6e95n5+ZEh
         dV1UWuY9FYyMUEyc4JYuZZjUBhTuhT8QMWIikeMxnfxajcqnpjmUTy2OBVX+sr3Qypzi
         1yx82kQ++WUjqs88RG+ryBQCQkC1JTQQJ+XYUHYyffLiCyeJdduzpDjd4RQpjqFtClP0
         9K//PeoS7xjYRyR4BRcoBMCPNln3K6kwNo8YHyWMz2/7Dh+rip9Cl2vM/Vz6h9mcHaj1
         jijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107896; x=1759712696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ougWc4G/qIZT3q+j2o8YnJ0ye/FPwzyh3Yh9OeHBEk8=;
        b=GKEvMdlgJ6yJvORp4IS+Iuu6/rf5p20QUlg7pVu7WoX2U8zVGme4wkC4T7GVRDgDuT
         LZCl2ycTEmYNYyce5yqayr2ToDT0b/kbnZcjnYW9Ep+Qxdr5srh0QMmzAhavBN6rm4Za
         Cv60r7DJNU6CWD4+Hw2Em0G+SUcvZyIBIDORCMPtetVfqjDlyoKtJrN9IA0YZxqmvvzt
         yH3T50c8eTbhdGadj9//LgBzIBa2ibeXUzOvh8KLoe6Kp4N76KLe3sh8gco5o3dsx1mr
         4gRO4ZtlznbTKFJlf+RYODm+3aeDp0FWJ7u8hjSXAdHknhhpyXA81nTl46H7wmwLkkHH
         RzXQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0hIpFE/Q1eLYvpw/A23A3cHZlZt0OJdtl1yjYP0pZREr65ojydun8453nr1BWWhMoQWHiq3mNcA==@kvack.org
X-Gm-Message-State: AOJu0YyKu/i/sG7D+RrA/Eh9jCHC3nnD3Fr/vYfYBBwhe1vOc89CMYBb
	k0pyortz8deTTkCDiebY7I6FpRq+3Tzd7/XzGMFU1dGUCNCE7KvDlDqB88T2UU4MWT4=
X-Gm-Gg: ASbGnctiXz+W+LO4zTvKSg1BnHN7lGhobeGJ0Vv9GBAHHKFmRopGtxY99fUoZgtfzyQ
	FKw33QaxOOIWPEke+aC4kXFrrQDSRLS7SBj6jaJtAyjMOXZjI9RmL9kvFwhZsR/D0PC2w3Rdw51
	2IBF6fazoFdclXEsGCdaBJ3uv5Yrhqfuc7rrcq+55ZFJ6x7B2QOB7aUKlXNWGXYlfkOMqHCO+23
	cm5NojKGL14Tknp2y4HZrQCZgUZFcJIbEjBOX/Gts3NmuonH/QBkg83b4DKIzyydI7hf25kTjN1
	Uz85eenpjZODXEqaQYyqOsW1lRp3LzuKgQE4SwVYwNsY312m+yz3Fty+6TWoieeFzguNoyBAXaP
	/OyHYlNtS4O0S+sq5YBJeopUcucavozlGYrgZ+/PkExwxkOlfzgIuWd9JTbU7n5ENeExDCcjN/N
	qFMPP9g+U=
X-Google-Smtp-Source: AGHT+IFYNaFG7Jc9+8mczCUfL2NG5AxHH54S3++B2bClP4OT/C9rMlU+s2JYq6QncxNId85tdheqhw==
X-Received: by 2002:ac8:7d43:0:b0:4b7:90c0:3156 with SMTP id d75a77b69052e-4da4735376emr195893531cf.9.1759107896425;
        Sun, 28 Sep 2025 18:04:56 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 30/30] selftests/liveupdate: Add tests for per-session state and cancel cycles
Date: Mon, 29 Sep 2025 01:03:21 +0000
Message-ID: <20250929010321.3462457-31-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77567C000E
X-Stat-Signature: napom9iidhmdbqzj8ib1sojsosr97jye
X-Rspam-User: 
X-HE-Tag: 1759107897-215756
X-HE-Meta: U2FsdGVkX1+fYx0NsUPnCxagwC0acaigAVr2F4cLAzFFdQ7XNisJNZ269ux4/99n4SUlNtPq977iTQVoEYHDzsETe/HJCT46BQ0ZgyuRLIT0mTN3nTsPB5ItEQ+ukwGyQnf7VBNzQjR+ugzsC8Bdhdf/Rvo+6qfiaSc07uitPoGChllqHKcyfxtesICSvYZ3ps+mbFfQ53f8bmrlL2J+FkzFTEXuFu9eI+m/7VmmuHdsRVsaeRSFQECjeE76tMxQl2I4So1qCyTTwTziB82wUXoUOEoAEBM7ULUwN1eJ1QJ4P0mJxC24Ao34oJAsoex2GlMBljjr5j8xxuwgTKyk98LKVgo5omBP+ex0qtffqDagi+5jsUScRgsh8ZRmJKPc63r0tpX8F0FUQ175DipVw5YxSxBCCBCgGOsIZVjcMgf2L7tiHPauCIu3NpImMNS7UpSYRN92EAjuVmcbQq8ERGrgpAABZMUUCk2j4oL1axgVv31Nrx+sHwthdZK/XJgCgMZlA8OrM8E2SEe3wnBjEBpS6ClY6qIpPm6HfXv5GDdRHsahODKMC+RETLOb9UQgqHPQ/1eqXtSO+HsHOmsXgtXtC3nggNaTs9YaDEJSbpEoKp4fiU+alEhyEQ6KxTepjP7CHCo5lj4AFi3GNOn8Bh978VW7yzmVEvolOeBMm7zRabIdUkimhDdk9IwkR3ObY4L5g/F+VWQfCufLVDYhz3QoOKCMXE7HlOcmBeT1RhuFYCUEZjq5mEyzP2ZKTGptyGrToCoUOnrGKOTb1DnA0BgsriUlaWsBnALJo9NZKbPFEMiRdDdSWCbPnDvQn1KpAZyPSlA8bWoEdIjvaJKFtb2BZ49VLAqOVyn6l3dN/LDL/zJn/9yHT3MHViuGKTe6xxkfvmtci0yTK2oUVnu5ZwU2MQXIy4H3vQOWc37j2e0VPlf1nG2167vriEhhoWHD1SAI/jbfg8OQXZtcVPe
 MbqGp3zD
 6e6H0EQZ+DEyxGvxg374xNqX3eadnaLezzpHELsb1Kp/FgSDbEHgnLHMtrX/z/JqqhUGRvvDE1aDgrP1jEUlnXFaGHbQqgIa+S6H6u2PW0pMWjL0LVtFIeiSOa2Y2fx+ybFT9hDFoGwFliM/OgVC+HQ5t8k0wgyZAwZJaIl8hzl4RGc8LfviWH0oLQ3O/p3JPoy137UA1uJM0wjoIZqNUrqGXKhwk5YQfZ66PnAqToRoWrnQsbh8wI5W4oJlzI1o1NTBOsfBnsH+CCPQSZWGD+VxofyB41nUMcRI2P1p9z8unBhjjPsZXSEqjF7oqPEjYTNjIcPcd6fo2Osw5F7t62vSDwLlt94zcb8FzaEpX36Fs0/lKecNfRtifmswvXER3nVTwox7ROuclKFO5W0IppxFdNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce two new, non-kexec selftests to validate the state transition
logic for individual LUO sessions, with a focus on the PREPARE, FREEZE,
and CANCEL events. While other tests cover the full kexec lifecycle, it
is critical to also test the internal per-session state machine's logic
and rollback capabilities in isolation. These tests provide this focused
coverage, ensuring the core session management ioctls behave as
expected.

The new test cases are:
1. session_prepare_cancel_cycle:
  - Verifies the fundamental NORMAL -> PREPARED -> NORMAL state
    transition path.
  - It creates a session, preserves a file, sends a per-session PREPARE
    event, asserts the state is PREPARED, then sends a CANCEL event and
    asserts the state has correctly returned to NORMAL.

2. session_freeze_cancel_cycle:
  - Extends the first test by validating the more critical ... ->
    FROZEN -> NORMAL rollback path.
  - It follows the same steps but adds a FREEZE event after PREPARE,
    asserting the session enters the FROZEN state.
  - It then sends a CANCEL event, verifying that a session can be rolled
    back even from this final pre-kexec state. This is essential for
    robustly handling aborts.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |  9 ++-
 .../testing/selftests/liveupdate/liveupdate.c | 56 +++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index ffce73233149..25a6dec790bb 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -16,11 +16,18 @@ LUO_MANUAL_TESTS += luo_unreclaimed
 
 TEST_FILES += do_kexec.sh
 
-TEST_GEN_PROGS += liveupdate
+LUO_MAIN_TESTS += liveupdate
 
 # --- Automatic Rule Generation (Do not edit below) ---
 
 TEST_GEN_PROGS_EXTENDED += $(LUO_MANUAL_TESTS)
+TEST_GEN_PROGS := $(LUO_MAIN_TESTS)
+
+liveupdate_SOURCES := liveupdate.c $(LUO_SHARED_SRCS)
+
+$(OUTPUT)/liveupdate: $(liveupdate_SOURCES) $(LUO_SHARED_HDRS)
+	$(call msg,LINK,,$@)
+	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
 # Define the full list of sources for each manual test.
 $(foreach test,$(LUO_MANUAL_TESTS), \
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 7c0ceaac0283..804aa25ce5ae 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -17,6 +17,7 @@
 #include <sys/mman.h>
 
 #include <linux/liveupdate.h>
+#include "luo_test_utils.h"
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
@@ -52,6 +53,16 @@ const char *const luo_state_str[] = {
 	[LIVEUPDATE_STATE_UPDATED]  = "updated",
 };
 
+static int get_session_state(int session_fd)
+{
+	struct liveupdate_session_get_state arg = { .size = sizeof(arg) };
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_STATE, &arg) < 0)
+		return -errno;
+
+	return arg.state;
+}
+
 static int run_luo_selftest_cmd(int fd_dbg, __u64 cmd_code,
 				struct luo_arg_subsystem *subsys_arg)
 {
@@ -345,4 +356,49 @@ TEST_F(subsystem, prepare_fail)
 		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
 }
 
+TEST_F(state, session_freeze_cancel_cycle)
+{
+	int session_fd;
+	const char *session_name = "freeze_cancel_session";
+	const int memfd_token = 5678;
+
+	session_fd = luo_create_session(self->fd, session_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(0, create_and_preserve_memfd(session_fd, memfd_token,
+					       "freeze test data"));
+
+	ASSERT_EQ(0, luo_set_session_event(session_fd, LIVEUPDATE_PREPARE));
+	ASSERT_EQ(get_session_state(session_fd), LIVEUPDATE_STATE_PREPARED);
+
+	ASSERT_EQ(0, luo_set_session_event(session_fd, LIVEUPDATE_FREEZE));
+	ASSERT_EQ(get_session_state(session_fd), LIVEUPDATE_STATE_FROZEN);
+
+	ASSERT_EQ(0, luo_set_session_event(session_fd, LIVEUPDATE_CANCEL));
+	ASSERT_EQ(get_session_state(session_fd), LIVEUPDATE_STATE_NORMAL);
+
+	close(session_fd);
+}
+
+TEST_F(state, session_prepare_cancel_cycle)
+{
+	const char *session_name = "prepare_cancel_session";
+	const int memfd_token = 1234;
+	int session_fd;
+
+	session_fd = luo_create_session(self->fd, session_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(0, create_and_preserve_memfd(session_fd, memfd_token,
+					       "prepare test data"));
+
+	ASSERT_EQ(0, luo_set_session_event(session_fd, LIVEUPDATE_PREPARE));
+	ASSERT_EQ(get_session_state(session_fd), LIVEUPDATE_STATE_PREPARED);
+
+	ASSERT_EQ(0, luo_set_session_event(session_fd, LIVEUPDATE_CANCEL));
+	ASSERT_EQ(get_session_state(session_fd), LIVEUPDATE_STATE_NORMAL);
+
+	close(session_fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.51.0.536.g15c5d4f767-goog


