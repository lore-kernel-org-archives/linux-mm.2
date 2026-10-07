Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75CEDCA6007
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 09:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770D86B0092; Wed,  7 Oct 2026 05:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9966B0093; Wed,  7 Oct 2026 05:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1516B0095; Wed,  7 Oct 2026 05:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301F26B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:28:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DE2B160166
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:28:13 +0000 (UTC)
X-FDA: 85295304066.04.2772CB5
Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED793180009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:28:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qKwfi/J6";
	spf=pass (imf24.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791365291;
	b=yZEcN7jbbT9pJbTA38tuu0dhunyjXIeZsuDOP3fXGwBdhbNfh7f+VLQ14xs0hpz/K5F6k1
	S1Y5RtorGjVK4T1iF2/loQ4UEJkQIvsGjYMUjNFV0KJljTMrJ5j+4BVMuSZUPzpFCA4p3i
	D5D+PRsZIL6sVsab3j12gOITIGJnWaU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qKwfi/J6";
	spf=pass (imf24.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791365291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aeP9LnNMW0XFzFwn1LZhyNEoudM26n+EG4TxrN/cfzc=;
	b=x2wsK+BAOOhBIRlqXi+TVa4bXUcUjj9xD4yMQo9P33sQeOZ5rq4eehnizONzwZxWATNM/Z
	jtYyIBIaA7/nO17dONfGbsCJRsghjwMNxM2z/WI1LBd++l67KqWlY+qlfYVhuqqLK/FZts
	Pmf0gJC35ges/y2si3Jcije8DZLLL3s=
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-49b0dd21eb8so9189615e9.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 02:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791365290; x=1791970090; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aeP9LnNMW0XFzFwn1LZhyNEoudM26n+EG4TxrN/cfzc=;
        b=qKwfi/J6BL787essDNwnrfmLs+RczGG8xuvFK1VfIPGY+Nr+6qoS6JUG6rTOssV7JC
         8rQhQE0D1Njyn2iwU4DuDMErlplx0iyR+H9+f25zINO1/6KflL+7dIw05+wnEmbki0CI
         rgNsnYu0DJEUNQkl7q88sWYegEivQHefk0qcRFsYwV5Mp7ux/Ui0w7cGS040F/YYIOH5
         JLAflD0z35F6UPTxxfaBPn+gYfpJBEbOuTP/itlUtbG6Sb2mh4P8LEb89BvLRmIgFBZ4
         mu4Y3aTk6XtKFzkOcnbolg51ETGja3s5F+u724liVqtsZg1OUYutl9z6e3RSoW87X/i4
         NkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791365290; x=1791970090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aeP9LnNMW0XFzFwn1LZhyNEoudM26n+EG4TxrN/cfzc=;
        b=EvAjf0Wi89bNoatuugZdmIxzvuLR+/G2FASCbTMSjfRfa3EjUApAxBealeEBjGYycp
         MA1wO/LhfxRZaq1phsS2Pjssnsux7PfdowWh0nBgskU4dPkHB5MMpt7w3V4munW30Il8
         VE8osnq05duXF1Xwh0I9+FRM+tMfYa3GvvKMPMjF0Pb0inYO/cCHykTKFNfiFCeDLdCq
         kncLbUVoDK4l9GdgXysdeKzOABUOeyj80QaQF7w+ZyfFAnWAT75gYymgAJWVmMKiUAn9
         2TIRm/ryZxDGVpu/ntR88E0cJ8CrmSDeBIPyQJmxf3o+YBzmWvhFY2yJ4IZslKm14QVB
         bmiA==
X-Forwarded-Encrypted: i=1; AKwUvBwzuvPZDQvgxzgQhR76PwjhHyJ1cUgL2g7YDh2xWyAB0Zu2E8R5Or0BfjnDnJSGSwCMfhGBS+kcXw==@kvack.org
X-Gm-Message-State: AFuF++mMRbFQ/TrN1LMqLBMgumtu8NHpeWZib5f/XdWqyb5laMbvGwao
	RAsI1gTDZxTGLQ3KmMOGSMA5191RylsBwTM0iuVfE1SEJrOpQ9lC8xCT
X-Gm-Gg: AYBFou2NY1gSPs22rlKquRRH7Vj/dZHPx89w5eO0yFCeodR8atrt588mBt4nAMM+I5O
	fHrKj8jEVUE/17DRDrULOHF1wk6ojYs8V/AvAH2VitjlRZeROWCXIQpGlIcF8g7qejsJKeoBsl3
	lBqmxMXlzL9BvHnnUGwz5xnr1Sc/tCaRd/KrJJmLMDP+Ntx3POAipS63ep6WDhgI+3DvvpBrGJg
	qN6vryFs4mbdKjSQxjVuc3TZCujqQEADYxRkVA7oyy0K/f+YG/VCLnTtql0d2X3LlsTirSw3fLM
	H/G0BzE2hCw4fWhmBRpz8JDWn3WVtN4ODhuIgZNiyOf1TsdEPYOC8qyxBBszaTj8MWxDqIAaBHK
	4Lftb5c4ZYjzkxxatirhi9gCecL5imUZlkKS13c9VzmRCzYzh1pzdlh3zlVPart9Zke/1oOPClv
	c2pcCf96KAAxKb+CgfN1ZwlUBnh3/Sc1+tdjZ7fjLurnVsyuTBnEzAUVeu69GQKL8Hq72Nz5Qgy
	O4YyrBDeUkqd35XUloKRuoZXaDgCTnFh+0oE1SZYj0OJQfJlg/rXGYmyCyHTzNLG4o7QeZHiU8j
	PdcSU3KB2PXc1iksX8qjR0xdK6byBMoS6w==
X-Received: by 2002:a05:600c:1c0d:b0:4a0:1efa:c74c with SMTP id 5b1f17b1804b1-4a18043c6a5mr29814735e9.20.1791365290293;
        Wed, 07 Oct 2026 02:28:10 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-220-212.cable.dynamic.surfer.at. [84.115.220.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f557bcbsm81016035e9.9.2026.10.07.02.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:28:09 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Guillaume Morin <guillaume@morinfr.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
Date: Wed,  7 Oct 2026 11:28:01 +0200
Message-ID: <20261007092801.35649-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: isjo9csahwnnxoz7jmapmnoee85u83ku
X-Rspamd-Queue-Id: ED793180009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791365291-98522
X-HE-Meta: U2FsdGVkX1/K7vSdr7FN7o5URbDWV1SUFck3XWcUiDgPZaBUCEJ580oRrI9D+WWkeFupNT+34N9HxwMbV4dYMWP75NG+0BRkGcfXCC8MiGUlb4eEw+7Jlk5BwH2PPg009SNmKd+Qju2vLCslfbalwrOTLqNs0R6JlqXcsbta5LP26ArWHj0MQky6lW2BdTWrcceAiCbMcV/qVqo6U/b1oq/qb+8maVoe1kCFysX2mQcuM51BViClqVt7vbX9ZAfXskweBsSoSE8sccq0NOK18ITJ27OOkfNmaPvjVVBhyaOa9L/pnDNtRsf7+Rfvhf8cLPune6ozUcKtOELeYI80ceYAPqZf0gNmfzgZSdG3PNuhtXxB7zpnv3wee9vxmluzEIWE5sVgnvT+mlaZ2MKZzKit6G8T5XVoswcQC8AE+i3MtIkQike/jr5w7K9YxwGDemeFJQyMsNJQQFPrjkoWR2riKRTlmBPvHsrC7jJAhbNqemQfvQhOCBQvRpQTC6B9HrzQWAjZVfpMKP9JidCqb15kY4EPYCeJT29hw7RtPOS89/+v1jb77WJNwKcie2STTx1mg01oHFVBd+ciEIc2yMcugUXZ9i/1zQz7PPZPcGUp4x0RRmAdWNAx7sgFmzf0O8981qCHqmlgXmE1lhD2p2jVm3KybAopr7WFntPKnAioVcZ7KUpaivndiZsueKmPqJeoNA/1S9iHL39L1+vMx6HV3cfGG/ni9kKnQZgs42anecZuA9RuRwX8RuC4XkqND6+SCM06GvHEDwKiUDIG6sovfHU6KbtMu5LrwBuNICeP+HHsARvXBYTz2Pdx2vNRsi4fdULy6pquNf5lpkDFce7jXm9p6PH9cMdPAk1SQPzfWKJmuuVVeKmaRdfPDLFUIvK/pd/UVM3MhXod4Mdyn9nQ+RevxTOHlwNptP6/Jt82ksCHZgNNPfR53QFta/RfC0Gz5tvrBBC/WKY7k3D
 3L2fpKfZ
 aION3osqEKjB9KyOPxUIgDGXLdsELX1/toTB9+KvBLhDCa4zfQSdd3rQDbut3bvMYz3MSzqCHbg/aQKKyIg949PXc4+i5iJrSpvZuRTRJ0sqOzxfPc0pIk6SRlI3Z1zPcsI9Rz9kw/6VDBd+qMui2JVvVRwYwDbJXpmuTYSIqBld1mq/b7LyWcemkKEAeCTRTuTuqbS923kkunYqTz3ELBFEN0VDmdwj3D5Vwl2bt2e5rCzgPqmRNyUoiCdV9+QJSVwNGVAD5cmOCUa/4olua1hFleaMMhQ0K+Zp7WJPSCF0WqnO2OOX75BnE5Nav4SKJ2YZYlfc9c+TMYcuTXho2OaBUqpoGBiKJD596ApcuFB5HbtpNQ9z7EDr3PHDBG7X4kVwgxFzW/HGEFec2Uxpos0VTjeJrYWdyw10nQh7vfXWLG6Os01QQ34anI6sa37wYwiCZg3sTXMWOGE1sWTM3A64VDkg3LL7i7L6ytmm3muGNBZQmo7eTjLwtk6vchH2ONqmysZ142zXByNKfVR9yKP8Fqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The plan was raised from 1 to 3, but the HugeTLB setup check that may
call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
failure reports one result against a plan of 3. Move ksft_set_plan()
below the setup check.

Also, when the underflow check fails, or munmap() fails,
test_underflow() jumps to err_cleanup and exits without reporting the
remaining results. Report the munmap() failure as a test result and
skip the final HugePages_Rsvd check in err_cleanup, so these failure
paths report all 3 planned results.

Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
Changes in v2:
- Drop the duplicate ksft_perror() and report errno in
  ksft_test_result_fail() (Sarthak Sharma).

 tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index 1d111f42dd59..0f6afb834dbf 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -168,7 +168,7 @@ void test_underflow(void)
 
 	/* First unmap, this will close the vma */
 	if (munmap(huge_ptr, mmap_size) != 0) {
-		ksft_perror("munmap failed");
+		ksft_test_result_fail("munmap failed: %s (%d)\n", strerror(errno), errno);
 		goto err_cleanup;
 	}
 
@@ -203,18 +203,20 @@ void test_underflow(void)
 	if (waitpid(pid, NULL, 0) <= 0)
 		ksft_exit_fail_perror("waitpid failed");
 
+	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
 	ksft_exit_fail();
 }
 
 int main(void)
 {
 	ksft_print_header();
-	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       hugetlb_free_default_pages());
 
+	ksft_set_plan(3);
+
 	test_madv_vs_map();
 	test_underflow();
 
-- 
2.43.0


