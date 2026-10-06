Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF0ECA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 08:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD716B0088; Tue,  6 Oct 2026 04:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E346B008C; Tue,  6 Oct 2026 04:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972C36B0092; Tue,  6 Oct 2026 04:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E79A6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:56:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC85CC05C7
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:56:52 +0000 (UTC)
X-FDA: 85291596264.16.BC69CAC
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 009191A0003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:56:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pLDv+Hyv;
	spf=pass (imf19.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791277011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QI6VWWfK9pDI+BJghbGgcQFx9nHMTF0rsPh7AoTup44=;
	b=pJTqrIyATctAcsFcfpAviFH2Av/q/XmJ7rchMh9ZOmaYo4Ok6cVuFNB0hw54ItoPWjHbAQ
	OrIHHf6H2BLhvTUxvu4+OXZkvswlXaYyOBrdX10oNMo8mtqRjwvRLAmDPPCsdRXb/znNFL
	UPXaKPch/9NHGGpXv2pT7lT0tNvahHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791277011;
	b=fER6iaeJdkSm77JgGmRRCn3DGBxqk3OQMJWQpnbvUpPOr+zf/2ZQ9wtjXIgKn9pAb1C31K
	R6FW6vsEH+e7s0RECVTeLsj/FPnk4h//+aKoD8FzrjwYMRABhVIP20vrfIjk+cCyHGtblK
	XktYn5/sjAAXtD4PUIKCLG+IXtu6zBI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pLDv+Hyv;
	spf=pass (imf19.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3a4c47bb6e3so213388a91.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 01:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791277010; x=1791881810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QI6VWWfK9pDI+BJghbGgcQFx9nHMTF0rsPh7AoTup44=;
        b=pLDv+Hyv601GNy336VWYJsIchL3G7zQaV8NVCvXrvpD5uCI1khFhsVojqeBqk+wj2S
         p/ACDFFA+LSIYwF2JyviSTPjSoyyUnR3mcoY2cyBnRHqlDS4a+Cf311eFhXr4z07uKV7
         bEBJP62NNp1WR52MpPylpIEp9ldKt4JI/IdEEtVjw34zCi6V8sOrTT7U1lShgk+u+kkB
         Bp1hJp5pyHwhmL4v6jgoJPhcQ3arzrUROQQz1y5A+jOtXUDUI2rkRahYDdi/izaW35m0
         rCe5YTNOECXU74yEl84KYrmvH9rrUcvsKfX0491PsW8ImLiKddETt3uqMx4j3y4q26yA
         Pn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791277010; x=1791881810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QI6VWWfK9pDI+BJghbGgcQFx9nHMTF0rsPh7AoTup44=;
        b=yxLdRNink1guWbX2cgdUC94jb2bXERNnDmV8OH1uoUYvGv0lMScdJTgPKUGbZTEqA1
         YonDf1HkLFI6JeFNP7C1wvuf82uccSh05uZDdmKdCaBxGVZa7cMfkErA2kuthqsNUJ4I
         NX2KMmstrb688CKgb7H2o0d/9QEO4D22pp4TtSxDVhzk5rtifeloLmjSyeF575Z8oMzE
         ZHteLUu7veaAfQYNYJPkezKxwilgVaNTjuMGGA7ner3LkrAOuMsz8wXUjiuus3mvVjN+
         Qp0obB8el5iVY1Hd85NjuapCux9ygJxLT4axHTgnMqEE06+RtnN+uQsMLUArdTb16u9F
         n9Ow==
X-Gm-Message-State: AFq9FYL8CMYB90cFuzEtWy/QYWn7I+dx35vZXdTfA+W5o43rNr5meaat
	C/DcGDxClLteGaVFNVj9g5dysmWVE03uaBZm+iZnnrMPgniPwZaR2wxP
X-Gm-Gg: AYBFou0STueIdbWGxh3BGJcF41wKJGZP+fdwXyV0bIEt1h1atjaEOiYKbZqxXy2XdJH
	ul/cLBC/3cfaFQKFJ4LcPSmUHfH54Mp8gSa1AR7Ttdh9mV15YGiWZP+LlFEXLxqdQ5vIDk2BoT7
	Yh6zuvHWIX4+Xz7SnN+ZaEZEZ4kdQ6nyPOz1t7YIRnEZoHwysjoGY66C1tnhoZqY31ZowBa9TdF
	4cwVvH6Rc4cfl8HB3VQR10PfB9XtsFowFQAiFmBdXSFWsI8hzHuH8TaaYEmO0/Bb8+qICvzBu4m
	yZhdwx1vBHH85NWedxhBPGyiCfCtZbHJMF+N29qaA9oYGrv3oeVBLc8VcEpTjLign8X3uHYToSC
	eSw1cBCMaZWGIVyQ6Sgeed/XJwfaRd59FUg6DfCa8KVXgFiF7CKh7L8E/n6foAxrt+HsAXCl+R4
	GIt8DFnUA/LJaGWDnUtLEJLv8CJPX9aoeompNfg78Q9TnKP+3GH/odf0061GeqP9QjKQHmLBBvc
	9bbF1fi/zUSvRlyy8dep3wXuC/hiDCNz6CNHhh09Cvtg0Am0lOZL/hkkcew7gsHpRAJ87zXpf+q
	ifvi0xkqDj0nMxUGu+OUhezGgUbufAJcYAEEwR5ozjMDETJn9/xkGkYw5bxf6Q==
X-Received: by 2002:a17:90b:3c12:b0:3a4:c52e:8126 with SMTP id 98e67ed59e1d1-3a8736af0d8mr491188a91.40.1791277009678;
        Tue, 06 Oct 2026 01:56:49 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853d00fc5sm3931542a91.16.2026.10.06.01.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 01:56:49 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id D975216FBFCF; Tue,  6 Oct 2026 17:56:47 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v5 0/2] support kselftest on nommu platform
Date: Tue,  6 Oct 2026 17:56:40 +0900
Message-ID: <20261006085642.3852152-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 009191A0003
X-Rspam-User: 
X-Stat-Signature: owfaxeoyxubyjjichguw1pwzuaczdg41
X-HE-Tag: 1791277010-704672
X-HE-Meta: U2FsdGVkX182i/jI2CMJdsYFewE0MsYQmHxmMZ/zkwsuE//4eZCQkacDa4QKkuhKWBfVJaT4PDn1LFIMGtcIuyQ/nlENsyDaIQlmY/5hJMe0A4aCXaGBXoTzmITVFuyG5A/0yKBMbxmu3PSQixyewwF47aYpuOmbSufVDGEMO1yP+Sb52FZhD0daFkNlTJ3/TCNMHSQI9e/SLEI2ZI8DlSWSZ0kJSEQPFlO9ZZfChbLJqmUIpBfK6nsttJKM/Gp4rm0YbdegugmXuUPv0T6K5AnJwnhmCIe/sHeI3rk/GG9iUZUcucdoZdeTSQaSp3hmTU/5vOhmzXxxK7BGAJ9h1urzdZKu2C5IxmNn4cpQ/6aqKHNVbq5fAlyWKWNTbEAPpNqbGKM2RPj/jBoSpjCbCGJtgJRqg3qKvzvRgiSXimU/9phiHUlkV17tiEfvKops+KK8nSTuR6g/wTLiEbC4gPsgMTeSpXnV2drJwnZqwQ1i6EaAM1uTTjuZc4vYmy50+9xwrNvrl6OgoBb58FMtoz/zhalUYQmNnsjKwK+Mw85mS6tXfxQhAom8qKmhCadL02+hppzHKU2BQOyJW0G1ia2ajf0x6SG4bb5CTYpAoVBaW9Y1+OycX1Zz7QXnDxqqvUD8aS5PxLCgjZ771tGiJO8OUdBI9PJt2GR47htuwUdGWk/MVZCiSMyXE5CCtj6zMZ7PvV+cEqMI1EIP32H+EIoBlnbWCnPSbYgNN1WbzWPVVZOUbtGOow904JX20FRbTneO7zlXErC5UoeZLdQWznoal9ADaxZx5v2G5kVaHbXhzWnj5CHNgux68N7YhSLR+3FdfOSBDzt9O9/1bs8UDfU6XjSl4CT3kChfkKjGQ/jyGR3Uhs7VJKPKgBWZdgvF+HDsjIaMiRaScR0zGkDFTfY8VnUzYLHBmWjtIi/DkADL84C9A21zbVp4lb6qnFysmcEdE1UW8y2je0+gw4H
 9x8tUJgV
 ogCTx8zp863FpJXlUvri+oKdVpItHb9noYrtBEBBI8Y8cUelR1LLAmHUvatdvx+6SXkuLjTx46m4VNNRBZfo/4LqkLTD7FJL73oT6yhGXxn0KYIkZqb0cqAaCjNpdT9nb2yPkA6ZjJdcSNVGdlUHuQYSQEk2HiE93BAYXjb3VU2dvO7qun9zFcEabrzEhUE/TGjKIUOfnJ6VaHjhOTfvh8bEqcLGxVMULLujHjAVD7SD7SvTVLQ8jQhflImsfAVAVo5Qc1SdMq437z0X0HFDHrs5vTOYbP/TjHp7LZozW+eP/Kg1rnzWol8TQsQG2kLy3HZ+KyquGlmgkWi16cCEADJIKA50HR/px34SuwLMrf8A6cDRRElWesupx+UJdIbINxfx3/vqQQjTgx4uwMybkqZdl8k12eKH813CfZ4lu5WZ2cgXplbb1Qu+xFIyBrmD+GbOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds an ability to execute kselftest on nommu platforms.

Currently there are several issues if we wish to run kselftests on nommu
targets:

- it cannot compile/build test binaries because the current files mainly
  assume to build with glibc,
- some of the tests are not able to run on nommu targets as there are no
  fork(2) syscall.

The first issue can be avoided if we can build static PIE binaries (if
targets support it), but in our case (build on ubuntu/glibc and run on
alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
mechanism.  Thus, we need to cross-compile with musl toolchain, which
needs to be solved the first issue.

The second issue is the lack of fork(2) syscall on those platforms.
Especially the test harness helper (kselftest_harness.h) uses the
syscall, which cannot be simply with vfork(2).  `timeout` command used
in `runner.sh` never works for nommu platform as it uses fork(2).

nommu component in the mm subsystem has several known issues and having
test cases should help this situation, thus this patchset is very first
step toward enriching test environment which has not been well tested
for a while.  The test cases is implemented based on the document
(Documentation/admin-guide/mm/nommu-mmap.rst).

Initial shape for this patches is implemented as an opt-in TARGET, not
built/invoked automatically if users don't specify this nommu target.

--

- v4:
https://lore.kernel.org/all/20260929235711.2287931-1-thehajime@gmail.com/
- v3:
https://lore.kernel.org/linux-mm/20260926010819.604346-1-thehajime@gmail.com/
- v2:
https://lore.kernel.org/linux-mm/20260825015945.141739-1-thehajime@gmail.com/
- rfc:
https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/

Hajime Tazaki (2):
  selftests: run tests on nommu architecture
  selftests/nommu: add nommu mmap and mremap behavior tests

 Documentation/dev-tools/kselftest.rst         |  18 +
 tools/testing/selftests/kselftest/runner.sh   |  11 +-
 tools/testing/selftests/nommu/Makefile        |   7 +
 tools/testing/selftests/nommu/nommu.h         |  33 ++
 .../testing/selftests/nommu/nommu_mmap_test.c | 264 +++++++++++++
 .../selftests/nommu/nommu_mremap_test.c       | 356 ++++++++++++++++++
 6 files changed, 688 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/nommu/Makefile
 create mode 100644 tools/testing/selftests/nommu/nommu.h
 create mode 100644 tools/testing/selftests/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/nommu/nommu_mremap_test.c


base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
-- 
2.52.0


