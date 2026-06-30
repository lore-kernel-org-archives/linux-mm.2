Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B40C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30956B00CF; Tue, 30 Jun 2026 03:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08306B00D1; Tue, 30 Jun 2026 03:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6A96B00D2; Tue, 30 Jun 2026 03:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0746B00CF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:34:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E84011403D4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:27 +0000 (UTC)
X-FDA: 84935766174.13.56899CD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id F413020002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:34:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804865;
	b=DqFPyr9kjZSJnB+DtyK8XI8/MiRSubwlOKXJlk8uRBJpjecUxTwUXhgxvLQmzoE/w7C//g
	Yu2h57La0p7Q5KLIb2+zPG651R6dWecnR3iGSJRNwT/oZ5ubg+jmu9HjhhJb8b0CaBeleL
	oqCKbkRLNmrNoXzbtJ17GTBJjdobKOU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tg/HrCXTfMducdMWvKjXOqr+HfcD3Cfk4Jb11bsmKEY=;
	b=6PMER8y4gUOmxmWq2IkHDrIVWfXKdHP3tWIMkAmbGbRvfmeNNDG+yANSTb3/PRzief+lmt
	xJy/m0UgtGISbKrYBqDQjke7sflSyrVU5MKVmjNTJE+lPdEjUOkxIXYZhPBl5sj5RWQZ+t
	sBqT0vkKQV6t428GCS/FtGdc2GDmnRk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 19a6a636745611f1aa26b74ffac11d73-20260630
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a43a2026-2ec8-4c18-a1bc-7ae873c12289,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:a43a2026-2ec8-4c18-a1bc-7ae873c12289,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:eb726f43a3c14b19a355e10366444f9c,BulkI
	D:260629183425GAVKERIR,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 19a6a636745611f1aa26b74ffac11d73-20260630
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 437073982; Tue, 30 Jun 2026 15:34:17 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	maddy@linux.ibm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	zwisler@google.com,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v8 3/5] selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Tue, 30 Jun 2026 15:32:33 +0800
Message-Id: <20260630073235.3802271-4-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F413020002
X-Stat-Signature: 3xgy1gfo8qx7pb9f88ebaebcams171zq
X-HE-Tag: 1782804863-866768
X-HE-Meta: U2FsdGVkX18I/+zpMwPVdkENwWr2/ScIvPIUoesPDmC+FcGa1HJbQp90B61oWsXCQQ5qxrI5yWh82vj6UAT6BXYPxb46r34puyNQbQiboxk6RhY4V8RvGJE2bnLFSZ2FkCF4cJqSRxXU26oLSI4Pzicj5UxRWwrvJOZuc8HYWrfWozozq4VIEb2tVsnKsv9WPQnobbMLI+yGvNSt/9cYj+fJ5CmQUPaom2HXYJgykjp2V3LwN5Ev3Iz60XwabifHXseqYh2wIGMiSDZ9aNuAnneQuv8FNRJX1OJpNtORQGwo2CpRgmiFbFYjr4qDHfne5aAFGxmED4a15saYJeNzGhvETAiws+zxw+V67imlAIMKwyS7JzCt1OM/OpB2XaAiKr2BOVmls7YCiBEFLaAPaDBoL9ZgzEHrgDj9s0LDBCVH+qcwtnodAQ6t4mpNrEP0l9Hh7xPeEexK/w9zNJdp1j2H4atnPh7Ismx/7CDE1fjKndn8LVP0BC8Fw1+D+XKGkKt6MXkgoSbZ0DqvwQxEKOY90yuel7cT1IvUU+vdM6GRRzgqxECfNX14aSqQcksQ0E6ATd1kUwAOHdksWlR08EPEZ/kVwKGxGD3zwfL0etDX6DfiFZHM/3gVJ0YVGHBXv9Qy2K1Py0QT5I/AK3IlfdKmLzHL+4VByPuQ5+SAVdbEH67LOdO19PR27hfac708Z0M6ahi2sxb4yfk4k2+22D+t2Ih+bbg5OXzSEDkuA3Akv6674jMllUvjTK5Rl7LSEk8L5KX2LSKSz7nTbl4yzu6HlYfd7z41oPkYVS8vxA0te+9OL4q6wbfWSxtYE31xYXlDSWTndVVMj1Ar3oKkkVh/2jORqmZTi9j+IRPXjiAOIc8fkyGqKpUWCPifbRegnjOYipPRapLpJiz7xdTfKYDni0rs22OSz2ErRtlZj66Pe/PCn18hnQo2p2fQl48fHqNvJS/1fis8SnOW0+O
 PnXupr8K
 JPez6d+c5gB9bHevQgYeMsrmfQpdvjTtRtJbJ0qsNYBhud9iaDT/64/hOeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.
The old path only printed an error and continued; the test now exits
via pkey_assert() on failure so it does not hang or proceed with an
invalid child.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 085e771227fb..882928f2912b 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -506,7 +506,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
-- 
2.25.1


