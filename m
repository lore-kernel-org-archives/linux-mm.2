Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11FFCA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7206B0096; Wed, 30 Sep 2026 20:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEF76B0098; Wed, 30 Sep 2026 20:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4956B0099; Wed, 30 Sep 2026 20:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFC46B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D34A4028A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:49 +0000 (UTC)
X-FDA: 85272245058.08.89FFFE6
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4C3A61C0004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uQBZsBIC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3CbC9aggKCLwumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3CbC9aggKCLwumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMPGmzqrPtOSz+orjSMVvFs/mFFB+41nKh4Vba0ZvzM=;
	b=ppFNrb3TgFQcAwLPxG6fU1qPwwaIscuT3Fq9q1nSTTM1TgCTG4b8H16JhFgmBl++Y3UjVE
	BnMYI/c7H1jdbpHKsKZPMYIaODP17P1rOcVQdtjFCrVXkeptFDsJx8yKyJnS/61x9QcqUc
	E13CbiWiqb4uB+nx17K5QdNO9W3X6rs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uQBZsBIC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3CbC9aggKCLwumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3CbC9aggKCLwumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816267;
	b=0dch5Imfk63ZPU6OSkasbJ4XgHzanz8Pj+jEiWneJ7JkIaegZBjN/OOuSVmRA2arGTMdwC
	1KRJ0d3QbHPqR3w44A3eehac05XJbVfzCFnFyx0SIHVAwFOu5/h8DJHMrEPolLLGMq6aMA
	uwWNQj7zKA8DmbwwNkMvExHpCBG0TXQ=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so7044535a91.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816266; x=1791421066; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rMPGmzqrPtOSz+orjSMVvFs/mFFB+41nKh4Vba0ZvzM=;
        b=uQBZsBICfUtHiA/pEh4vm+L0sxjNwU80douQ2Y0zllTh3XVanT2u0BavD3kfiAqX5F
         Siz69Fd4xqm0MhNMhUdYhE3QIRzUS0ZKy02fCZ6AgEA7jQ+NOCxcl7C6xGeCqeihQjYh
         0+CExcz8rYXRY7743cxTUkAKElr41MTbYqEIskMlG41X1GfY9bonsWQfltIgImldt6ik
         Yb7gXgjXUUPeSi5G14ZsoVUG47A8vZaavolKmlGNpN9Guam8IZkroYmMCRrM4YNiB+y3
         fLwg9IMy+bcyaetcMiUb0462hg+QOifh6XzFJ04YgxL/EDrLMx5n7onNwDJbFQO+Ckzq
         k5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816266; x=1791421066;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rMPGmzqrPtOSz+orjSMVvFs/mFFB+41nKh4Vba0ZvzM=;
        b=0Yv3gPUHicoYZXNrc6lat/Ln6C9qgqF/q7gygzd1ZPpfqh1L83axxwj21BfG5M33t8
         5m3IzXmkXVk5MJFqT6Y0P5cR+VuHkGgKFCoS09svrkZzMASAI7oKxXD6/GqxNaG3AlBq
         d/5n5IazaW34YKpfTP6IuvYEs75a4XXPDC0ck3PwaPE94mL4sN8hB4pxniuUcBRNyWT5
         bU9ClpSn74LYRDOoVCeFuJTEo7j0cMxi8D+j+ueK+S1J/UtVqkx59eukmQMIMYNvicDb
         jcghxgp72Fu7x1BPILUfUDP04qhjcRXwL0QARv+Tp8uoJPKRoqwkzCmbGyLKTkB8kg4i
         wH6w==
X-Forwarded-Encrypted: i=1; AKwUvBwwNmtjzz9cvDuqerZhDI7Vpjrg372xEimAnc5h51CTQDyimBMf6+KWwWUBdxDJLDZ/fsCYWhNgPg==@kvack.org
X-Gm-Message-State: AFq9FYIZTTqGRJdL1X9GZAVb8O5dtPeMS3fXG+FuCHY6EfhXnwSUcmWg
	m2GzBaVEQe81vWio/tRsoPZ+YUz/moIP+woKDBZgjLijxpTBd7neu/43ZzK+3hbwrzHcI6KjlYh
	sG+jaxcxWjyQDew==
X-Received: from plei13.prod.google.com ([2002:a17:902:e48d:b0:2e2:dc3d:e914])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b8b:b0:3a2:b490:c459 with SMTP id 98e67ed59e1d1-3a4d1787222mr2759686a91.25.1790816265844;
 Wed, 30 Sep 2026 17:57:45 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:34 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-7-skhawaja@google.com>
Subject: [RFC PATCH 6/6] iommufd/selftests: Preserve all the FDs in a batch
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: etrudz5pgbeegqbucqwfyyatjxeheomz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C3A61C0004
X-HE-Tag: 1790816267-658359
X-HE-Meta: U2FsdGVkX187O0Fjn74mwdXBMNoeFT+wkqqCzIdwTXoEP1MN/1T8eoeQs7Si4u1gBT41NoMmbLy3GLXTgZ0lLReTmCT0qXo6iPWdIcb17Fg5k9B3h2MEEWIc/amlYs1g60+SETKAStITpaBJtjE/36k+3IyVNnNl40TgPeZel/BDGyKFeKP0NgdzlB9ve2wZFtvbSXmc2uKYisCC16ihkSVBpC88TLTahN++o7MCP0ugBiE0Sr+HOeNc+3kr3AvsFzLPDAIEHdMm3mlTP9R6eNIEb4wFqYAXrrmcgDSe0MYvv8iUiFI7FgfxZtndSK7gGOMFAY+QSPq1ZdfPiY50wEwW4bUgPjegQumfwg3awlGp/h3vcFsawg7YENY6k2aAzNbxsUQZ/6uWVY8rsa48rjDDUbbhGeNqy+yyfW0p6go36C1EtaQT+4+LIBoYfGxzrtQCIc+QrZ2uH1qlK7lWq5kQ+fQCQCcwAqMfbYdwd4TpL2DRq633zc4EUsAJIinYeF4LI29jaGm6mkI8ozlz5bgejpM4lQhCThInW+1Iyew15a0jEkoP1GVdhaZtErXGqCTHEfIW8es0rPiPXEeUKqeZvypI/Ed2IoclxKUI9MYRLyfrZWdlbPseYtVmBp/AHPYWtLIdohwwhdePwFGLaAjKIGb9GFczYz6woRxbgo9eF6VTWm4m8JPi0Cpo01Socw+KHsFJSL7p8lU1NnWkGSSjv/blFv6FQgcA6aAZR/24JYtGAm58pGobpFyiJSuczJXM20mX4g4NIFjd6ZhDI8cgmeW8oRL7WiVPCeOtUbKCnV+PSNwp0S/vdp76wXyTX7VvhWoOuyC19ep9gVkLDUrsu60uLF7Nihyex8c32frh9LqHVcpgtyXhwgnfbzhik/XOXhXVzifnW4xiz3BeEvEzhAd1x76m5/qOxi4VdXSj4WCn+gyniD4kmefRy0zVjuK/3SbOgf4LEtRUps5
 ySqb61Vd
 vf0uwsRHajCmSvqWViPxszJdVzNolndT7x5bf2USN6xehIwjGcyGX5fVJGWg8arKxqf3FkJxRWDC+d3lYcRBPf4qK97/Ce1ctMsZqJe7pFW+qclrKaidsCpOE1FShHm7CxyLc7xwr8yrm3od8afjJXMaqA3sD46cxi6qdVbgtLBQPorp4SS5NckkWC58ZIgc+aWHl9Fksx23FBpq9zlt1o4pkTE1Jf9wWWZoCDt24iPcmX9iT2I7dMuZciQZwmpTR2O/X2b3TC7/+RRAtartLhl0Fhg8ii/8Rrhw9x9nIMuBMUPKur3hlG1BFMX00jFtNRWklZeArlCp9BoseqnM0wmeXa97RiesZt7m/8ralvZn5u7407/6w70/a4Jf0q7YVJ2sDzmK1u07Div/zEMLihS1JaPkEpl4bsX2sVXHlduKqxTmNCYRF47bokKkeZ3v3y/z6r4NtM6n1QQhW5lTfO0VCdHayNnY2ASimQ4Bbpk1UHgqJXCNbjADVDO41z7+TB9V5ddY7bZGmOiF58EAj+PGu3VAaxAxw48vkBTKlw6bkerCZzUkXYUYCiUtEkC0nuEAf+qrhbk9t+DqfoFV98Q6iOQz6VwMPoaMEfqXKyzZ6p/Zz4xAvTNT3oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the luo_session_preserve_fds() to preserve vfio cdev, iommufd and
memfd together in a batch.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 .../iommu/iommufd_liveupdate_kexec_test.c     | 27 ++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd_liveupdate_kexec_test.c b/tools/testing/selftests/iommu/iommufd_liveupdate_kexec_test.c
index 26c7e15b6187..3ce282fc1a33 100644
--- a/tools/testing/selftests/iommu/iommufd_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/iommu/iommufd_liveupdate_kexec_test.c
@@ -153,6 +153,9 @@ static void setup_iommufd(int iommufd, int memfd, int cdev_fd)
 static void before_kexec(int luo_fd)
 {
 	int iommufd, cdev_fd, memfd, session;
+	__u64 tokens[3];
+	__u32 failed;
+	int fds[3];
 
 	create_state_file(luo_fd, state_session, STATE_TOKEN, /*next_stage=*/2);
 
@@ -174,9 +177,27 @@ static void before_kexec(int luo_fd)
 	if (!luo_session_preserve_fd(session, iommufd, IOMMUFD_TOKEN))
 		fail_exit("Preserving iommufd without memfd should fail");
 
-	test_luo_session_preserve_fd(session, memfd, MEMFD_TOKEN);
-	test_luo_session_preserve_fd(session, iommufd, IOMMUFD_TOKEN);
-	test_luo_session_preserve_fd(session, cdev_fd, CDEV_TOKEN);
+	/*
+	 * Batch without iommufd: memfd is preserved first, then cdev fails.
+	 * The whole batch must be rolled back, including the memfd.
+	 */
+	fds[0] = cdev_fd;
+	tokens[0] = CDEV_TOKEN;
+	fds[1] = memfd;
+	tokens[1] = MEMFD_TOKEN;
+	if (!luo_session_preserve_fds(session, fds, tokens, 2, &failed))
+		fail_exit("Batch preserve without iommufd should fail");
+	ksft_assert(failed == 0);
+
+	/* Full batch, passed in reverse dependency order. */
+	fds[0] = cdev_fd;
+	tokens[0] = CDEV_TOKEN;
+	fds[1] = iommufd;
+	tokens[1] = IOMMUFD_TOKEN;
+	fds[2] = memfd;
+	tokens[2] = MEMFD_TOKEN;
+	if (luo_session_preserve_fds(session, fds, tokens, 3, &failed))
+		fail_exit("Batch preserve failed at index %u", failed);
 
 	close(session);
 	session = luo_create_session(luo_fd, iommufd_session);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


