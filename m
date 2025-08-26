Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45E9ACA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3F38E00B2; Tue, 26 Aug 2025 03:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB8E8E00A8; Tue, 26 Aug 2025 03:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C15B8E00B2; Tue, 26 Aug 2025 03:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 689F48E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 393011A069E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:29 +0000 (UTC)
X-FDA: 83818063098.14.F283482
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57AA6160004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IN3aD/73";
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Z6Bi8t88rSpzG1T0oB52bwNWI4uzeIhbuID9C/28XE=;
	b=gen33hkC1yXm+S6dPer2eYtA7UL6z9iUtt/6vYUNCROx7cBvVL3IQPCj/8kTpIk6zGsrZi
	ClSbArf7maMxHZf6Nmyr+KnczO1MjEPnd7C/TTfm/2uQOxPxXXw+lH66gntuNEoITciL6V
	rEs0PbkIM+89ObvHIrZXvLvPHE1bNho=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IN3aD/73";
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192887; a=rsa-sha256;
	cv=none;
	b=PSvKUliXwcsHEYgk6NByLjtniwiUmOFSkChC3rAMDaFOQSYzGzijjp9gVIAOKflswtPpb6
	Uw5hQH7Vh6NnBGWHVd3V9PPeUgagcGyXfh9imHV+LnsVkQcpMMckTMFWQk3zBW1dw1VkUW
	z66NB5lmVjfaLnehO6SBDf78lz9VHwU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-771e15ce64eso1393074b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192886; x=1756797686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Z6Bi8t88rSpzG1T0oB52bwNWI4uzeIhbuID9C/28XE=;
        b=IN3aD/73lhAHN9wmC5cQZhy2tixf1Y0CI1DH0sVShZTeAwm9ieRIEKLL9ESFBBN1ob
         9Cifgl9m43bOOOeLHFCcPCQlzXqkPIXOxAWIvouDhAfFBhju+di6kIRCR80i+iEy9uhY
         9o4j/sw7wRBfDrbwKh4XMPgc/3CTuN6JWr9RtZxqpUqyM0Zmf/Ab+TWQnzkC0gmLO99T
         pobonWqWUvA/v39YgUewA9C5skID7i085+wAgoQ/I5V8Tbl+3sbcmrLiufVSO+F1qfhA
         fvTAuSK8QcAGy8gmhEiODA/Qdk71qpxyCEOD2PB8lTjjRCJ2fFSZHiekwAlbXwcduWE2
         vJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192886; x=1756797686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Z6Bi8t88rSpzG1T0oB52bwNWI4uzeIhbuID9C/28XE=;
        b=g0Ex+MyA1ZKXins4EsIgoPByDFKMnBF143QAMCjp2Atl5Z6n6o7w/ilLUges1ZJqFA
         rQDqNTmKRYY5WCPNixbHv/KGU5EFHQavUrUaGEwWbyJ5lZN49iweAU1o4qkxKLRBhmtB
         kwqvz7Riz45GDDpwKCIIvL1fagaO8cShDbsZsU1dhSzvT5tBP4adnYgD2Cmznq9G9moP
         obd1F/DK/MWITV9fBhyIb34JVLJU5eFEJBvn1Ct/qWqfCq+lHCScFE24awsvh8qsUS3e
         t9qFoej3eJ/L6PrX9XPoKm1dK5Oj5+XNr9sj1DKXk/t1iL1AwcrNhFy9/OWYuKyqJEoX
         S22Q==
X-Forwarded-Encrypted: i=1; AJvYcCVvAqztMGPk8pqp3ZTFh49THJ+zc8ebdLXQlPQdmAJANcXGb10Ziz3K6W0ckrZlefWMBQ7vWHcEqA==@kvack.org
X-Gm-Message-State: AOJu0YxZX6vJ3EpDjB04euq0TfmxYLO3VLQQplhp/BPUoFMHz0+SKDGQ
	Z7/6IHS4LaDZpwnbOnoaJglprwmUUitI331wSUr/pWSOj35SxNAvjZgc
X-Gm-Gg: ASbGnct6kR0kicU/ncvMIpmL59KFisHtqQ+6Aiyl/J2AJaWRr/EzvioIp8bKCHS+FI4
	oojEWAkaQMQEG/CdUrXkCFmuFIra0HyGOSuBy8WWaYAmjkm4rPrfLdqPeIj7qIGu2RT05oVAQR1
	DkIQ3bKBkHZi2rNhUqr4XwAgVhRTZ+kMEv92P+Ap8kv9ZVWKQTfpUDqV959rMonYGP6BM9/0mn0
	47eZY8qlAuDx+6UPAVi2NM7unpoP0JIreZd8IOYfw+wPutsWoqzTJhbiBq/iOEtMKVt6mJT8LXL
	sOqI3w4bLn1X+WMzBbSgCOVkBfvDMlQ+uyLgkW0cKlAI/ZAEMviujKO6AR0nOOdb0lCXPHK0vQ+
	nvTjUFpT0NL7JhMI6mEx9PFHDyAWRfe5AOn4r9NsdeK3JhCB1joWmhUawu8MmS7xy5rDyiDHD2o
	emdl538wbIV+Vp4g==
X-Google-Smtp-Source: AGHT+IHLwUH1ijQiPQrQUCBsEKBb4EJG1bUTZX90lI8IkidK1MmC5uPmTYLnP5pDhbJKCobTBp1VOA==
X-Received: by 2002:a05:6a00:2d20:b0:771:ecec:519b with SMTP id d2e1a72fcca58-771ecec60d4mr5472496b3a.12.1756192886218;
        Tue, 26 Aug 2025 00:21:26 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.21.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:21:25 -0700 (PDT)
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
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 07/10] selftests/bpf: add test case to update thp policy
Date: Tue, 26 Aug 2025 15:19:45 +0800
Message-Id: <20250826071948.2618-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6nqn4w67saic5qjmtwukyersneu1asx
X-Rspam-User: 
X-Rspamd-Queue-Id: 57AA6160004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756192887-776008
X-HE-Meta: U2FsdGVkX184aoSa9jW4uqZrsi5j6hvsyfjoaivpUM3Gk/+RyjermSY0duhxPV8uCnAqDfVsUJZNzoD1urW8pE+2mJev2Je0xsG8qhujaAaFf50E+kJ+UzSyZHxXuSRkNe8CbbuNS4Loi2G5gd+5fcGI8skQmko/zFZHNRXGk8FKEWmzD5iqMqfuBnTvHNXj7nJkxnDjfGKEHMgu6mafQoEpiPIe4G6noVBCO2m5bAYvqpjBnlw652rm+HA7No+A/Kj8EscQQfav1WrGZ1GG5rsAZT1gysRGOFqaTkZHjRA52DqfR/TMojKNFtJQ/3LuncdxQM6ag1zrUduKbLFVTrxQUbRSZkJ7WXwffXWnutbkMjvSvkSyCq+DJo0avmVUIO63IBkc7cr4jwkx2xq7jRBzc0/3F4xZC6Xa3CB0gBegxW0MtBli6GfUZA9VGZMS5o5RJvkWKLcvH8zM6mn/DMy8R9hfY4u4pk6AfRb1JUr+QDxysthOBQllHhSIJgIyiLZ5jt8nDP67ZAHL5B4+F++uHvvMxJ+5NH6//vl5dkjZaUb3E1t5z95jlNa2zUVtznLsF14JIxTqyeIQTuTVokCkypYLnKC1HP/kzZryvWVa16YysjFWvCrrH2ZkZMmzAIuAEFauRMd2K7vTnUi9fHDV5whwYG9WCXrIDp4NE6xtv/8sJgpIquoTzHaIYjmgXS4hYyOjn2zIJqcPRlWMKeWLUxKu9EJm/oOgpYTOyFH29dDOFMKufYhvRZ+r7pzj4oe8US+FqD2FjufdOMxXa3szC9A3gWMBq4SyzSqg90R6zJNoBxm7WUon2O92xQHP8p7yUA4pgOFzqLjLCun//JyTEa43V0As7CDeHBL6Pzdr2e9OGEB2vDjfX9oX30C/bAvxVFz9navFfFQS9brIuUCN/iYWj1j9D7+CyJA/rTKHE+lsr4dtqKGRCO3tbrufHGCFJOxTk6MlyAuVFLC
 8d7F+3rt
 7MSezAvk9fgIB6eiwOaWpL/vQ0zXRvWT0NJt4gzdRTkoGC45ri4I4/Hx4XNsTV/7USs358+DylXocrdDHiBIq+TamwmDtaRPFwRMSs9czRJxggwlcDj3+yr7Mw1n6W73XkmhmwmJUiFduxviHWhreBfltM6Upks0mXISiY3JzrGpxV/0wiwiSSu9DbMPGJvQNVtWmeAh1aZx4hAgOYDBiNk8R2q9hVn8PqhDB0xoZfb9ol29xRw/1Rrs5M9ym98WBErypcC/eftGPekCjMXB/UAkIzyoou0DFO9ydi0Wk3p359bl/azjq08EycAJlcSqBL3qzqwPEtgQgrCqzTrsv7Qu7m8pfgtIN8KsC5dFzwgKHjJAAJXTuK5d5lW0fARQWBDxMmRHTx5Ly7x3NTv5ta5/73rUkbzoe1DRGRBEHidFhQ2eRDVZ9wnc5oDq9hkrWuB4aHoE5U6/5FwodmS0UHPeoD7VqBpwRwFuaRB6jGL11k5i8gGNexbUlHxH6jpWtnkpBKNw2IMttpx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EBUSY is returned when attempting to install a new BPF program while one is
already running, though updates to existing programs are permitted.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index bf367c6e6f52..6e65d7b0eb80 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -227,6 +227,27 @@ static void subtest_thp_fork(void)
 	bpf_link__destroy(ops_link);
 }
 
+static void subtest_thp_policy_update(void)
+{
+	struct bpf_link *old_link, *new_link;
+	int err;
+
+	old_link = bpf_map__attach_struct_ops(skel->maps.thp_fork_ops);
+	if (!ASSERT_OK_PTR(old_link, "attach_old_link"))
+		return;
+
+	new_link = bpf_map__attach_struct_ops(skel->maps.khugepaged_ops);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	err = bpf_link__update_map(old_link, skel->maps.khugepaged_ops);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err, cgrp_fd, cgrp_id, pmd_order;
@@ -308,6 +329,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy();
 	if (test__start_subtest("khugepaged_fork"))
 		subtest_thp_fork();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
 }
-- 
2.47.3


