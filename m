Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A249CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0613F8E0029; Tue, 30 Sep 2025 02:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038818E0002; Tue, 30 Sep 2025 02:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91268E0029; Tue, 30 Sep 2025 02:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D893A8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:00:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BED5C05B3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:22 +0000 (UTC)
X-FDA: 83944866684.12.1FADFD3
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7CF771C000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUEQZNfh;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIx6JtRigPCSTkRZZksmLfb/7I11NxpDSXp1+H8RPCU=;
	b=oCjqHASMM00j9yAQzTcl/XRn7jJBSyJwNRTPElc4q4xsRksUKMzWrGgIR999+hVYP1Lq/s
	J9lW04Lo0fZ27RgwlPXosHLnwyP0qHsmafCo0+II+AlP8SCsboAzxcwnPOGLa9Kdb1TkVB
	4Mmoj1FMydEGvwnc2aGVlkCIANVl4ZI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUEQZNfh;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759212020; a=rsa-sha256;
	cv=none;
	b=6mq8WThvW4A81iv9PVFNSSTF2hkdSvmgRJ9QcQbC38g87YM+rlGv+YzRVczXfc9isdnWvf
	DozErzMKNCGgZIBj5T1e726qjUIaWCWwiHV4HywdwyXsGsgNMeggukCQzjcqTfRVRTuRgF
	+mzjpaYSdladqgvzTcxirDyiyp62lMU=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b5507d3ccd8so4765304a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759212019; x=1759816819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIx6JtRigPCSTkRZZksmLfb/7I11NxpDSXp1+H8RPCU=;
        b=XUEQZNfh9okMA9+G6xPDfTlTmuAOW4D0S0aHL/J9OgMT/K2mWxfMwsLfkMjKwWPg8F
         4SadrDyULbpgKggbE9hN8shQZCsprhcf8ewSPnJPoSCTl34jlCIFOpy4RnymNsLwJNqV
         /gXCyT8VEBsw/h7rQsTkQQEpTstloqT0o4pNbUZEzS6YF7e4k+WB4ZmeoNvWeusjO3IF
         D+mQEwmrfisGBlRgRQdb664rKzwxKaADegNjqQWuxNxydsYScN9eF3NnUtFyQ/2fsJO7
         eWnaMljnyGV13QTCBjIbgLn8dRFesLo7D6BiTMLMjXHTvRlxWgHkRk+/IvpyWSFAWDYK
         6seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759212019; x=1759816819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIx6JtRigPCSTkRZZksmLfb/7I11NxpDSXp1+H8RPCU=;
        b=LHUBCYu5daRwASbGQTyEO5eIh1qjJIHJmDlzufVPRz9xBJ0nzUcbyFxoAAiAIrv+PK
         3p1ZvDcpr0mGuFSdq2j9+JLAVVKIj0mAFHgJPXihFCl43boGRP9gE82k68ICjZ1Bh0+U
         XBa10hykGrhIzyEB0Gj8KxZhdwQFzUYps++ZbvqVsziy023CFJEFKBWg9pYyc9g85Wzl
         aWD1Z7gq63JDPG9p8WcVURieWOX7rFwVN/QseBMae+Gs7OlBc3Co0cBsahTnW2FuJrXq
         TYKNxq4GRRpqIQE+x4MMFQY4NkZ5MhuroU+QC1yJfZPaZBXbs1stSZewRDo2Pw5pa2l2
         2AYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3Y15Z0zzY08zic1bhYvRE6VNTBBqLjWkEmJACFi0fug29gPQm0ef07cHBCQhWqaOB9Y8UbZbUew==@kvack.org
X-Gm-Message-State: AOJu0Yyb1wL/cvEiUPWkq5OGua/AY1yYOxekmubg4ysWtwuPSK5VtdWw
	ZS2zX/czDPidqjQOi1aCMS566zaMgwEHmf7SsgF2iV9NVdhkVYqKC8IS
X-Gm-Gg: ASbGncv42WQBJqsqCk+VIZUXa+jBBwjLIYtNoWM+3mFotYU1096DuYNqPGzpsPRpCAf
	LCqg2/2Mkktfcny7mTofeY3K6MXBAWCfhiTXOk1cskJ58xMqJdx8Uvk3mbamwgNHuOphG3nGfLW
	YCVo59x6m5myA5CVnv7uZBUyG8sED4r9gBs7E//AN5kGWTofopN8eVfUXRjQqX44g587Mcgz2Dh
	jEuun49hw5+X+k5rKrqqdKmz520x+OzbC720dhShNzZp3j/rFqYQgWjHE1dXaR9NmIMcOnUlT34
	NeBTjgGHabmD5dyHG+Ze474MIwokVu77nF927C7SeiOI5I1qVpmreWETtgjK5SaM74EZKqSPJhm
	zeVA1xH7n+zf8aEq1thA4CEK97dbpdUfdj2lv71SI68wQn2/dOVWdhY3epICZjHoWxBkCt8ZWvY
	mZ9HfE2KFi0qqw+gPSaPfT0xh6YAcPwulbM7nv2A==
X-Google-Smtp-Source: AGHT+IFMF0W1qCu4x4cjpNrUn5ZcQpDe9+QCy8Fcn/EjOKLeyug2Wicq+5aDDzqbHXeIKGe4nnQ0RQ==
X-Received: by 2002:a17:903:244a:b0:25c:d4b6:f117 with SMTP id d9443c01a7336-27ed4a3de3cmr218087635ad.35.1759212019034;
        Mon, 29 Sep 2025 23:00:19 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.23.00.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 23:00:18 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 09/11] selftests/bpf: add test case to update THP policy
Date: Tue, 30 Sep 2025 13:58:24 +0800
Message-Id: <20250930055826.9810-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CF771C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: y4icpqdnc64sc5giom1opysaecrsb8cx
X-Rspam-User: 
X-HE-Tag: 1759212020-997909
X-HE-Meta: U2FsdGVkX1+Kum1xuGOyV5/FuPt9ci8mzP6oF0mBE6LxxW3LZ2FwFwFcyHXVyxgRnjit8Iz+JUy+YRygQnuYmDdjo4ADsRvAOVdaK++RhHRnz8wQ+c7jH153igxRR9OnrTbRIxXKdVEcMF2sVMgmG4mjL/py1oxvZks0rfRGNeFu8itprahvT2YJJB0lhcCF+E2TuNfzladmulj0ekyTMT/CS/E9V4yyq7o4IqeM3MS3pQsNu6o9fUgCWoXv2P+LkuXaBgI6F94aA22p/Uq8g+9aFMvJ1komHat7p285wpI14WUH+45SIgqw+yygacLsIuE+rPVzyOBESN3iScIux/EnvPFy3KRl0f5dHEy3kC5BqNxEwCYhlUP0/kBcPol79nnh0UQXq00h22wPiQtdPYS30Tu+01+MqyvYaFZKktMkKKgMbAkmsD0FTO7lFXFKGh2G6rtH8gL4DdMur9k1bO2aVY++i8roRDqLi+nEZEyB4bxrvyIljUAf79JbjEMF+5oBJoMZ2KzV1STnFcYmz89aoEcJ5hpIS9+D20bmJ3qCwZTEPBwHTliLqQ5lp5PqPEWDhutNaODW6u9e3vbRpEq2iTMtwxhtOQAlJqd27x5UoPWTHwQ5EM7PEeNWBNd7OCq2uHYFVU5utMjJIDpf7owp8k184zxItrP6FS9XrQdzU7wMLlTecWqWNGC/sdxfZv3EcvByWDjnjL8FpFLPgzPaUkXyBruvpKUizMu+itQBJ18aDwnkd3wn4GUIXtS+FWKBJwbE1oUWax6xZqg+C5qyxsec5Y/WNAZaHg0ILaMgpo5iXalYJazSwoZsdT3h30oznEjCew8peVqBaXC5BjN87mtYUeKM3AotyC396t0DaSSIveX8j1Zt5zvMjOB9kvrVFH3aWgkkZpGm/w1CrzsROeD8Xn0Z73m+XWoHF5/quiyRQ0w2K4wNRDfi58biFmXARB2WhfN8fafYObx
 ycE+xGhg
 dgbTi2ed7vCauQ6aar9ol8ulW+IPCUqCzdwA0qnUVvayt3kHzQFwyuXhX8WkOPUaMM048uSrbGB8NESyFkBNwYTTHF+oA8KmFC/FYPUWDfA1M/Se3REJmCsGADY676bfZFy1WLSKxv0OJEtVhl/sqJgT8cy61wIx8zPz/JSHDVFT33zseJyn4RDSSwz6L0rdRWe0+3xzY3ELsmWG4bu+564gsO3wWdQ7HKujWn4KGgml0sbQr3IRiEuY671Wy2FLC7NiLZPjYZH2CGiY7jb8d6X2np88J6huubDzps26xRPUWPVqWvv4HfujU7MD0tX7PoJaf5/MQCnYQsXEDrXmah3+2iuQtnOuXlWOezRjKVuuelV//SpU+2J5kP8u5exrHy7MXgQGYCAe0DHYXT4wjtYf+9lYO596aLEpOuplvjNGEP6Y+6ZauUxWT31KhjDm/EAhfPxNxiIBX5vuno2MOFrU4KWUphsNxj9nt84auuj4V3ah/1WbVXWzOJ10/oUWigl/UZuTlXeoqAGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case exercises the BPF THP update mechanism by modifying an
existing policy. The behavior confirms that:
- EBUSY error occurs when attempting to install a new BPF program while
  another is active
- Updates to currently running programs are successfully processed

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 23 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 14 +++++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 0a5a43416f2f..409ffe9e18f2 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -207,6 +207,27 @@ static void subtest_thp_eligible(void)
 	bpf_link__destroy(ops_link);
 }
 
+static void subtest_thp_policy_update(void)
+{
+	struct bpf_link *old_link, *new_link;
+	int err;
+
+	old_link = bpf_map__attach_struct_ops(skel->maps.swap_ops);
+	if (!ASSERT_OK_PTR(old_link, "attach_old_link"))
+		return;
+
+	new_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	err = bpf_link__update_map(old_link, skel->maps.thp_eligible_ops);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -252,6 +273,8 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("thp_eligible"))
 		subtest_thp_eligible();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index 74ad70c837ba..fc62f0c6f891 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -39,3 +39,17 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops thp_eligible_ops = {
 	.thp_get_order = (void *)thp_eligible,
 };
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_not_in_swap, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	if (type == TVA_SWAP_PAGEFAULT)
+		return 0;
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops swap_ops = {
+	.thp_get_order = (void *)alloc_not_in_swap,
+};
-- 
2.47.3


