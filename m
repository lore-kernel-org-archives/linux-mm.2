Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EC6EE0205
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 14:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FC86B0005; Tue, 30 Dec 2025 09:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D366B0089; Tue, 30 Dec 2025 09:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302956B008A; Tue, 30 Dec 2025 09:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4E46B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:53:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B153C1A01B8
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:53:28 +0000 (UTC)
X-FDA: 84276430896.13.E05F56A
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id E20972000F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:53:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QgROTmHd;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767106407; a=rsa-sha256;
	cv=none;
	b=4i0AvcJdKIkUojLh+k0u8jK6gyCyFCyqZhvHRKrhEpu2UBu1s6uZsJlRrHaStz4ljWx7kU
	m9WwoJn33jIV5fZytVEEu/jX8Za96xuGrkFkHkUStMwomWK4Gt3u3haIb6JdTnhwCcjSaw
	9ma5kAGGgDU+q8eEZmhc1YZgS/daAPc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QgROTmHd;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767106407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=riYaqi0lArqEgWhtCeLrj3Qec2cHmyBPX4D058N2sx0=;
	b=Wdx2CHreTg5IlCsGKSMcGqKY/+1U+WSGXe/sh7d5Of/dHDOQIzRpi7AtFQUREPF3hgOoA/
	2BVwDLERfjPCC9RsTakIXVkKbYVPvo2PV71WlpVrXwMPNI+X0pB0c0kHhHaHEpt+U2rra3
	3DOdecjSZ5p8HUfqo6KItPw39p79250=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-786a822e73aso88833867b3.3
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767106406; x=1767711206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=riYaqi0lArqEgWhtCeLrj3Qec2cHmyBPX4D058N2sx0=;
        b=QgROTmHdDA+S6ITnnpBu8Jmu6vAI1mk18tL155QOsvDW+yuGu038kUwyi4oNiM54kD
         UNF/hCiQoBKpsneZrk8slFAOSHBFScrt+CLdzvmdsxfNFrcQSlxHhf+VyRTDd9lBqZi8
         gJxHXiEJZPAcz+rwP2tX8Iva4ZJJ12TgtOCPUs4bx+qcdwDgNp/VGHB/VMjeJPcwaEXo
         GKz9cmtSZmi3BQz74YWERBHM0AO0kWO/ptciD8VriCKcDW3as92MsNT8WeGLyyRfiXcA
         vR3YeJMRVuy9/ZkMQY7C9jGAyUSVOh0cMC2YZ/kJCrdmiahBTAg1g7I6OHS+ixkre4+j
         vhdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767106406; x=1767711206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=riYaqi0lArqEgWhtCeLrj3Qec2cHmyBPX4D058N2sx0=;
        b=asqUukQQP196FvbI22wU3Vj29BCNZCEdsrb8VBkgdsUdLexDjdp6gvmL0uuPgusi7t
         uDnLtF3wmGslJkFsjWKi2y6WAjhsoajvFEkSyncdMZKDwdMbCoFPhFOBmtKG12V5Achu
         jf0ULW4pTAzJ6+YQavcy8MsxyLbeWcFSra3QbpXOfodPwlpJgZzLRryhzq6tgRCqHKZw
         Jq27E4fBFP2USylnOuQ7ofPm8etmuZXFL9sI8Fx4mZL8nKev76ys26snifONdWrf4+7B
         WagkmIdQPWKaqLn6bIxdGzNvvZmcF/gZyRd45Zm03tYKobDR07n+l0ZBDxV4+AGHcwzf
         9j0w==
X-Forwarded-Encrypted: i=1; AJvYcCVUefOdt/aKRhE21F9MwyMbXdImVez3ySyZOYLPlbDr/JAFASsThiOCThTp/XwMRm1FqbcTCYbWuA==@kvack.org
X-Gm-Message-State: AOJu0YzGd7BoYfCLbjT4pu99eHRWbDTuXDBLfJNh6lQCeh5snfqz1CYq
	jvXEf24uoQkbMJgYS5tbOETO5KMQiRXit2OonBOcvwYr+jtuCpuRcs/ssDl2vGnqUuM=
X-Gm-Gg: AY/fxX6/m0YsJU5YBl/J8iffsa/Yj/dWm9TLUtXNkuLVhcYrKnajE2NTTbMpJ17OM2b
	72V4h8GTrp8N6eiHolqAvIoHBCNNRMYpHALy6K6XKD6mXxX38WbrGNOs0u2TdTTRLc7a9Ubw1Qm
	EtM80nKE+yxvfncLu47lxuv2aH0Q9cAiUdJMuvH3BOEP3QjtOvmjg5irpUKmTKZ8v3U7Z8oK/Ce
	NMG4fL3yKj1yBxxGbNJI/Qtti0Ds66o+Xuq9gE1NMXnny/v+lNmsPxBa6LIPmUbbUtAjhBlI03e
	RVukYtZXbDwx5Ocgt5kcR+ooBlzpaiDrOVcFgjHPMYixcyeCrUfBR3ZWZGQ6CZAjODc/wG3aGma
	xo8d07TbPTUSpBe3zyhLqe62PD/1q87L0KQvkjJMgbAQapnizXc0Aa4JO3OlyGQ/ASzHf+0gl9k
	ClbAh3GGTW2Xaqo4PSL1HQtsdFUpg1Nkwa6PwVIYhz9QaYWi6foiuHyPdwhcHsQgwAhtJdhFIaH
	iVtGPx2QGzutMwdU5wISod3zsmvB/eNZaXTqw==
X-Google-Smtp-Source: AGHT+IG6aQUJXEtDcs/28NN3mbhDEeScCWUs9mOeS4mE4fbbBXX0Rzx0eSQVRgAfm6s+Ib5qJwPIPQ==
X-Received: by 2002:a53:b549:0:b0:645:6c99:bf17 with SMTP id 956f58d0204a3-6466a8afe74mr22491541d50.52.1767106405631;
        Tue, 30 Dec 2025 06:53:25 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a8bd6ffsm16306220d50.9.2025.12.30.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 06:53:25 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pratyush@kernel.org
Subject: [PATCH v2] liveupdate: separate memfd support into LIVEUPDATE_MEMFD
Date: Tue, 30 Dec 2025 09:53:21 -0500
Message-ID: <20251230145321.1512630-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E20972000F
X-Rspamd-Server: rspam04
X-Stat-Signature: h96mbhwrfxsse1it85oz85mj86cgjjnc
X-HE-Tag: 1767106406-342702
X-HE-Meta: U2FsdGVkX19wMMGqHPRSRKWs/+StosiCKO+EOB1ktrPIdKSiTzWwtLFse5pswF14aJUz/R0ZsxqBJX3i2DkObgdKKNrl4bw8PIZtv4ygV70o3F8pac/J9+EbPumTVzcM3n8bLBU5hIJwPk9/PamCLtb86VURHDSMcyDHBnvoa8GR99ol+xJMR0/1wqpum133mm846pjdZ4g0TcppJ+5UX6XT2yw94KulMRKoRwi0/03Kkhm8nEtCwfWyLmjehRhDIi7mxnkSrE2fFTS0WtBBB6rJv2DwHHwK6omOCWZ5KfgqxGDMii6qh2LXMxCtLbEP7HbJx5z4gnhz5Y/pFzQ0SXzswKhcGCb7AAL5KWnUqD54xLLpVvvgBp2wLkjTMl++5Sx4VoSOP+mAcU/Xj7LlHrE+tZdjD7coiBx4XQuF0k6y2s2heirsLMLS7LcTHkjNFnm564mxF56n7l6cu0BqYR8yped+0yzt/VMlcozueSUwIcdqa7nvydGvmhNvlUMA+fuLYi3w8MSR3y7rvNZcM00XEOcBpPIm7fMKEkK8Ca7vr75ARSsLdeCWl9eW26j7/B/iMoRX4BM8Qh5+dMUUc3Ia9V9Y6FvN4joD9ow689sGL/ybeX2HrikS6+pnW0zqbainvn2ckr73Luo/g2iWhTj9kyqKwvmm0gIcyP4Qya+iKZK8zDDAeD5w0S/6j4bSsyTPIW/fVproQ5vZJ4oymTkqKMfyAdfyLIlFT6XPyKZrJvabKotloo7KMh3/NzpZTejE1lC7PVJtIZpz5Clund6EkEnXRsAVSk2wMJtn1N+wAX7hTlLrH46hku9xmkhjl/Xbuk82mEL07n3HOQONhilO+psxlVKPJb4/YB9pkmVEjlKMgpqP8BP3coG1X5H9OgTIPlW9O4uhWuq9iBjsJ/byWQ4yBoqinrC8Bn8+9jkc09p0coy+hOoFfbR4C34EGgM0yIKr9kQ7qNRglfn
 bhv0tVth
 9dciVJh21+gSWugx1h8DS+wv/VWdkVYL/yH+iCJKV2STpxtBvLn+VfuG8dLyWkzovxnivM5hiZ4Lr75Wp+BQPU/dvdIvB/9UkR57CWowgI4fINijh45DiFM/fagk/TP8F8hmcoJNpqL1S0GYnYYJkZ5kNtYjdui/DY3K02OonNEUXUPUODq/9c76LTbLtGB6HxHcP94PFE1v8JR+YB9KGM8KOfmN4i4aXxGCWfHYUwYkix7WdJsvwwoZhOYPw0aZJ1JmefPBgKzZ/S/6nYUjduDr9UCqlk/tCRwqE8JdtdG2STxiXUdGg4qMa+N2vRnxNuo575lH1zBinJ8jbBTbnDNhH9GR+0Kh6sGjlSPmuzQ/TDcY3/ABwXU8qpX6B3TUR8uewN7M0Kibtb6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple memfd preservation support from the core Live Update
Orchestrator configuration.

Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
Update may be used for purposes that do not require memfd-backed memory
preservation.

Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
them, allowing the base LIVEUPDATE option to be selected independently
of shared memory support.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
Changes v2:
- Updated testing config
- Added review-by

 kernel/liveupdate/Kconfig                 | 16 +++++++++++++++-
 mm/Makefile                               |  2 +-
 tools/testing/selftests/liveupdate/config |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index d2aeaf13c3ac..9a1a8cdcf16c 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
-	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
@@ -73,4 +72,19 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_MEMFD
+	bool "Live update support for memfd"
+	depends on LIVEUPDATE
+	depends on MEMFD_CREATE
+	depends on SHMEM
+	help
+	  Enable live update support for memfd regions. This allows preserving
+	  memfd-backed memory across kernel live updates.
+
+	  This can be used to back VM memory with memfds, allowing the guest
+	  memory to persist, or for other user workloads needing to preserve
+	  pages.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 9175f8cc6565..798f04233d71 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 91d03f9a6a39..1bfc708041bd 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -5,6 +5,7 @@ CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
 CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_KEXEC_HANDOVER_DEBUG=y
 CONFIG_LIVEUPDATE=y
+CONFIG_LIVEUPDATE_MEMFD=y
 CONFIG_LIVEUPDATE_TEST=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
-- 
2.52.0.351.gbe84eed79e-goog


