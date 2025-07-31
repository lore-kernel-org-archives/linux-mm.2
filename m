Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBD8C87FC9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 01:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587FE6B0088; Wed, 30 Jul 2025 21:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5369F6B0092; Wed, 30 Jul 2025 21:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C636B0093; Wed, 30 Jul 2025 21:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF2A6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 21:53:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A24841347EB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:53:01 +0000 (UTC)
X-FDA: 83722886562.16.E41887E
Received: from smtp153-163.sina.com.cn (smtp153-163.sina.com.cn [61.135.153.163])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7DDB9180008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:52:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=oMwMOpe8;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf06.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753926780; a=rsa-sha256;
	cv=none;
	b=54LwEDiGPBuzY/36kV4dWb430MCZ/bKjoKATzQ1lyPUADhpNxDFRzAZ25mxH3d8cxqZScb
	PryXbfBYjDGgQPnaYwAIuSyLQlvciRKsVTlhdAVw4z1r2CnF0wRp5BEaWWODtKPSe86jJq
	GYl9O+SGlXzRef+j6aFrJ4yFislZSbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=oMwMOpe8;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf06.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753926780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROXTcu3NC59udh5UXJspljhoslQrPWl0Sx4aF8K9Emw=;
	b=ZGmbhCnvuYGiyyygKox4gi5XHQeC+0JZtYvaqyUp+oao5YWh5FwP19S51b7cwFvPElgpB3
	sdH+Anu37Sz/MD+kvkUi0h+TCoGaYj7I082WFke8CSccI+ezSiBJOrsW4lgXN54vEXxwBT
	n0wbV+6Wo3kjR9mNuIGiUts8iOYzdKU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1753926778;
	bh=ROXTcu3NC59udh5UXJspljhoslQrPWl0Sx4aF8K9Emw=;
	h=From:Subject:Date:Message-ID;
	b=oMwMOpe8GAGbAs5N1qlgsPbfS3W/142TLnJOqQN29NYwUagZOwFeDyuCCNzuH6Nxf
	 Dh6Vh9z5LhRBA8ZMt+50rfz2kiNEzi/hNJytokfFMTiSGM8gL/NhWKDK90XM56heqb
	 PVwixV3SVgQtlnZLdc/cUJMnA3iDrCZSLzB5cPrE=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 688ACC73000065B1; Thu, 31 Jul 2025 09:52:53 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 9109934456634
X-SMAIL-UIID: E9F0BA989AA444DF88B0D3645AEDC517-20250731-095253-1
From: Hillf Danton <hdanton@sina.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org,
	peterx@redhat.com,
	lokeshgidra@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a THP hole
Date: Thu, 31 Jul 2025 09:52:40 +0800
Message-ID: <20250731015241.3576-1-hdanton@sina.com>
In-Reply-To: <20250730170733.3829267-1-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b14e3zcmpnqw8iny9ae7qismr44kyj8y
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DDB9180008
X-Rspamd-Server: rspam02
X-HE-Tag: 1753926778-153978
X-HE-Meta: U2FsdGVkX1+n24A/fQ56dZTnGrYu8xmFbvOs+rH8ThUJuinorJbfMEBSYXLiswgvo1BSiSfb9CTb0wNhdpdOPJKSv7iNz0/oJcm/K8U1K+AhtLrFNH5Ba/Q3CiMOrX/wqOANVphClSfF9tj3UT30ZHpNNhDRQL3d+9TAIo4o6SyoPl8E253HWr6xCjv5XbLcO2b8MbeRfdAlrmzSV+vgvRdgnnSZhb/c9kNNYkeRGEn4V2UaLLOsxCBwzKR4UC/cdj6bs/owKtqxxbIrgG3CFqpleHJ0iaOQ10KVcWw/sssMH+FoQQ84vdVYU6R0upTOFps8nBcG/PdjkZk5jUOHZh+8qXe/COjbS/lgU9sec9+FSSvLnTLvgcRAIySsn6O86LMEeHu9ysglGU2saFF23BuwEBVDEaFfog/K6GZUgf6sAoXTY5ToaYEQQ/N0x8r+jkKGmUhSTbrbLiA2VMqRPKBe5gnLwE/QabldQGpossVPSv3OUQ+1ApJxN2xU4WgNhnPrRXB94bPH/IVl2A0hA35MiCZx5sObIyrA8ePx4lSKkOaR8X4Zh6yBlv1FjWazY+mgzfL1HHzxsCOReecPG6QspBaCUiL8WcVIJFJisB9SK+YSHqd3RXpqxVXbX1x72s6fFMF9QCbebyBsOwxN0ejDWsrDx742gEkfHiZXLq4+hthDS2NEaDlT2m4siSCzehuByj5gsgaiv6TrcfTb2YII7b7JC2xlfVArid/0ZHpoA2ZchRpU4We9DikoejN3MTcR9Iw0EXScAWC0vKmwJbbG5SiL6S10SGLL16444MwbEiFbTzOIRBHsAtZQhmqC40zdAX6SsLEN/0amX2FwxkX3CiUk5psgz5UX0rsQyypzHWel6RXniLqROzBYrjxsLXXKk15jJwcQsIcbloS5F4pv6CNGFU48CUB/oNqL83So6xbSsT07xVmcWxby2Wws99pGHuPqhNRpZ4eOhE9
 x+zkVSGg
 07lhV2qUoHoQpGCuN1BDG3sGLtnQsmGIFG1tUQZUJExOfVLcW4Mnru432uY4RrIhw7LyIuV/geKtTknAvSGk6Ip/6CdRDgk4c1ACBS7A6MRa90XD3oPsRMhLoQbZfLrcVRfuDMpxfUKI7JiJZPUGtMcSKUYeeQQ0W3QJK3AYlTPHl8amuTBw7jWQ1e1ENMLUAvuPCaXlCT4FUWYvtHP7p2WCLuWvy0wvFnMltVotixUbxPUFS5GyXqo7pmi7n8QuBy9Aqug4ibjZi/qPdkIDmDhhUvZobGgXKCLm3TcaIJnRArOBjTSuXZLK8dEMzG5JHvGhY0wu+fWwtHeo90ggGfmdAkvUXpAuz32xY+p+l8AyT1CsmO69Wo1wqaskZfle05laR0hdAaFA+jcw/G8OGiyK9cKIWgUn9i3F3qzpxqbUsGxi7NYCOO8wuAVp78ORUjFA/fN9PEiG6+qa5rMjiVYzQD2cUvR/aBvGHzISQWGbljq/8IVBeBz4wd3mDVS8JzaFNylh84g14vmEeH5BTuTLGBUzGcPjBYwPFft+xZ5zFv3fQFcMWSGfbdB66XAQrEPptlqF/6O+RABX2MDnTwicx045UV6SxQuOWLCKFuCoIJH3udwDTZHKHGCtYmdag/LIE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
encounters a non-present THP, it fails to properly recognize an unmapped
hole and tries to access a non-existent folio, resulting in
a crash. Add a check to skip non-present THPs.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
 mm/userfaultfd.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..60be8080ddd0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1818,27 +1818,35 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 
 		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
 		if (ptl) {
-			/* Check if we can move the pmd without splitting it. */
-			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
-			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+			if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
+				/* Check if we can move the pmd without splitting it. */
+				if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
+				    !pmd_none(dst_pmdval)) {
+					if (pmd_present(*src_pmd)) {
+						struct folio *folio = pmd_folio(*src_pmd);
+
+						if (!folio || (!is_huge_zero_folio(folio) &&
+							       !PageAnonExclusive(&folio->page))) {
+							spin_unlock(ptl);
+							err = -EBUSY;
+							break;
+						}
+					}
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					split_huge_pmd(src_vma, src_pmd, src_addr);
+					/* The folio will be split by move_pages_pte() */
+					continue;
 				}
 
+				err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
+							  dst_pmdval, dst_vma, src_vma,
+							  dst_addr, src_addr);
+			} else {
+				/* nothing to do to move a hole */
 				spin_unlock(ptl);
-				split_huge_pmd(src_vma, src_pmd, src_addr);
-				/* The folio will be split by move_pages_pte() */
-				continue;
+				err = 0;
 			}
-
-			err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
-						  dst_pmdval, dst_vma, src_vma,
-						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
 			if (pmd_none(*src_pmd)) {

base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.552.g942d659e1b-goog

