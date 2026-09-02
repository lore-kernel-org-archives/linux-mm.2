Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFE9C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CEF6B00A0; Wed,  2 Sep 2026 04:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E296B00A1; Wed,  2 Sep 2026 04:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E764B6B00A3; Wed,  2 Sep 2026 04:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2BF26B00A0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:56:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21E121C0042
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:56:56 +0000 (UTC)
X-FDA: 85168217232.22.6322AD3
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9F5B4000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:56:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=gq3SqGV2;
	spf=pass (imf27.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339414;
	b=N0G14ETqs0mJZR4d1cjbe7vMlQklu+wSeHWpf2gybpXbeG3eXs5FoDko3ADh5rAPwIrxnu
	TFCaigwDbPIzPYhooaWCPwCP96LvLuI6zlL1DhoXVm0CMn/D1dgf7JNu+s5wf74fDp54Kz
	JeGrtmbw6unesM9ylqz2kCBDhVM5lkI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=gq3SqGV2;
	spf=pass (imf27.hostedemail.com: domain of liujing@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=liujing@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Aoz6sjZrHtAXKr+PfysKugCq74iLiuRekQtXRcCy4Cg=;
	b=u7lPOAdJhbvmXIkjNEUd6naVdnqfG1LS2EjeTTQVwYuqyl+y47jcT/IAg9T+qdACcTFztb
	NzpAFDIjWHQ6p+jFdWhop2/8WIdLd9qTvtm6IGZwan4vJdR4GUjavY92FHuXpSKjg7y96I
	O0qbdmHQtu8msFDY/0kY+4KQpHZlyms=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=gq3SqGV296OiYgRyLEYWLllkhyp4j0ROUzfdbKC/QmIJZ66r0eT+/lJDLeX8YrOdr2TqV69dQMHIc
	 HCoFNsOkd8EbSZ95H/qqnrlECaYw5olhHZQL2U8bmQBWkVGsdmJkFvv6VJpbAEhV5UBzpAWfd0UDE4
	 LLr+E9Aa8lUZBgqQ=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16a97e4cd3b2-7a91b;
	Wed, 02 Sep 2026 16:56:45 +0800 (CST)
X-RM-TRANSID:2ee16a97e4cd3b2-7a91b
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.98])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36a97e4cd79d-f1852;
	Wed, 02 Sep 2026 16:56:45 +0800 (CST)
X-RM-TRANSID:2ee36a97e4cd79d-f1852
From: Liu Jing <liujing@cmss.chinamobile.com>
To: glider@google.com
Cc: elver@google.com,
	dvyukov@google.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] kmsan: test: check vmalloc return value before use
Date: Wed,  2 Sep 2026 16:56:43 +0800
Message-ID: <20260902085643.16309-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9F5B4000C
X-Stat-Signature: zp4cs7qtu3g5dctbfiu6euzpsmu71zap
X-Rspam-User: 
X-HE-Tag: 1788339412-465117
X-HE-Meta: U2FsdGVkX18/uWr9BTas/bNtVQkDEHYIitAkChJIfxvkdhs3DwSEBhga9PKzPSi2BJsSfFWiZDxXObbny4TtjXqe+vo8c1tL42ejKgCI30Ky1JbcEDxXmG2HCc/z2aAB3kHGVS6Anci4aq9YOTSxzQ0GD2tpI7h80zZdGHPQOV52mDjmJqnzTJSaiSp6oTOGKw+PvqRsSZgQCXx6KONiivwgFzEW/hvlPT39YJqz/Js4plM8PS5Vbg135n7fuwrgZufhLcO7SNtkW9pYk6uq7tY5+er2Pvkxb+zyhLB79tXfVx5/o1mI2NHkMApy1Hv6IGKNoryYVVHKb2hzgHfDnPh7MITsBiqRhewxEslA8TnvaNHyG/KZNk1PMTvM4Lqq7PnYgE4kr+qsWb7MirgRD/3n++z7hcGPVHptBxvSG6hOxiwP2x3k2+XTKOMM8ljOmnmkvdDXzEqDn5F2LW5vdzjP2tKxtyNNz3nZl/qSlDem9FQqce73XACYIiktu1c7XtfGmZFKgXFQqpEFIJv82XA89+MqNhS9vkkb41cTWV9M9clcE2MkY9FEGds7qRAnGfDlbzxSu5rk3qjceHPu8JlCT6bchOeikRtB2OHJGY8oPFQzGOVwnrrplDPGI7Rb4ynMd8NXCUG8QDqF/k/IEr0gKxk4v1hjIeDH6cetX2Q7y/+ftE6h9fpD/ksxvs4Z6y/F1ASqW+9+bdrufDNCkkj2H1RsFmFUxnuSXatdAxsbfSVNguZBTQFUMqiIynZsEc03aR4pxMoXU/tz1Ah2FriXN3UfmETTppAqMDlq7+Fcig0loM0GzjRk2o6OsPC8HLyTYXH4aHSVcuj0M6hZp/VXZah0xXlAD25QyJEMNJK7o+acR4qjSsA47Z55+q9rtd15PWy5KHuYGMi5CqEaazoHgIazSYOhFUphtw5EjFmjbZYGaKdIVkQQbxpQlEIQYdNSc9PIc2HQa8TF46J
 xkKFR9bP
 Aa8wrdFk31VygF0bKyzFyFBIXKiNjG5JPnf7oM/lDQ6FWhRzNQN1PsztXJV44p97aFEPzsHLlgq3KArPCLcEFEYUbIRKNl3O9D6I9tCngDdZsFteJdhg5zWj8pSkpAszAA65qGu+FyBxcvsLAkNEP/5GRCGfuCMUV85inGYubhBhAOOa5Q4fFSXFycsOV+T8/hNzyyqzBMPkcrrqNdmGtSxVFh5amFgtz4S+UmAwrZU0Js7sNhh/UIvLptRrl26rrHVjzAVoAiJArWIfmm/vQ7JAeAfJo+TilxMBMZpUW4qjUBdGoH7qGjf16OrKJwxxotqqM/1F4Ol6jnEsW1KfuybjDn5wPinIivVi4Cp1l+TCNu79BF3Gme16Q+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_init_vmalloc(), the return value of vmalloc() is used directly
without a NULL check. If vmalloc() fails under memory pressure, the
subsequent buf[0] = 1 and memset() calls will dereference a NULL
pointer and cause a kernel panic.

Add a NULL check immediately after vmalloc() and skip the test if
allocation fails.

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 mm/kmsan/kmsan_test.c | 6 ++++++
 1 file changed, 6 insertion(+), 0 deletion(-)

--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -352,6 +352,12 @@
 
 	kunit_info(test, "vmalloc buffer can be initialized (no reports)\n");
 	buf = vmalloc(PAGE_SIZE * npages);
+
+	if (!buf) {
+		kunit_skip(test, "vmalloc failed, skipping test\n");
+		return;
+	}
+
 	buf[0] = 1;
 	memset(buf, 0xfe, PAGE_SIZE * npages);
 	USE(buf[0]);

--
2.43.0



