Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B38CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279CB6B00AD; Tue,  6 Oct 2026 05:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2524E6B00AF; Tue,  6 Oct 2026 05:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DB66B00AD; Tue,  6 Oct 2026 05:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E12156B00AD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2B7C1205DA
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:51 +0000 (UTC)
X-FDA: 85291669302.26.6658B33
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5760B100002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EDh2KI2S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsGaWTTmfRvE+RVxxeynnzEh51QeEHXSJwUd5zhoWFc=;
	b=JzhSZy9NOPxWqP7yLPTcLHUcfLxiXbZEX9YrAxVKqhC7fcPcCoNme8ocQGugESx2aYyG//
	eA+CTZNBbuA/4o/iM8gXAmLpcUWFAAgg5znFrA1G9pOCVH2V7SCyc35S5+mYmweq38//Fp
	1s9AR/43ghA9HZYVuzzI0tsi57MGkIQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EDh2KI2S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278750;
	b=IfU2veOSu3oiaUR0SRrYaaVOmqfiOQWjLPEmFySqQ9wgFZHWtuFWPHdJv4UWalAhEevQug
	wBYvzBo3kbnMPb25yf7DaMtenMmzt95Jmujfk3VQloOBFykAOB9W1VcNhTnnpN92BgTOld
	PvAwGDSJgfMrkPR05eDMLmxeGUOoSR8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 391D01477;
	Tue,  6 Oct 2026 02:25:46 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D22D3F763;
	Tue,  6 Oct 2026 02:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278749; bh=OolFXI5b6+V9IEt20PEAQ7kIeCNm1VJ/qc/YBSWvXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDh2KI2SzR/LKPdePGNyU26dIpRXbMZWkA6BKKpmjHL4USo1QLLvzerD7DrJ83McK
	 8F8EYKnHqrkAPqnuFr52pd8p4rEG8FkELCcrNQcvBZQYxcYQK9Pm40w01kAdncQps/
	 qH0mWl9UgE1dcOxT134lR+ONDnZ/0ZDK1ZdVTHR4=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 05/12] selftests/mm: mremap_test: skip test when userfaultfd is unavailable
Date: Tue,  6 Oct 2026 14:55:04 +0530
Message-ID: <20261006092511.145776-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5760B100002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wxtge3pgdtsyxomxdnqnb6oi1gxndo73
X-HE-Tag: 1791278750-814048
X-HE-Meta: U2FsdGVkX19FeeGFXvZeUc3SaB05CjGrOC75RsCvyV7zuvlL4U1/ub+3Py/fOSdEBM2kdFBSz9HxGiKgb7tLzBIwTe0X8hosJ6m62gOZfbjs55lD/7IEC5r2Sh9Gr0LhA7NrN3+c+4pPFW9sqKrXOyZc517/h2NhWq17lYnHDlgJKbUXuZJzS8dYd6W78UeSu2sXb3G/ItFkTnNS/knCrjK4p4EwfFuGKUyBJs/DsSOUBP7DsQZWVqAaFuI25znOfHpUPOYRk0LBst6a7JcFWscu7yXXEiyr/371wmsjdc6piAXOtw0w4D5hU+c40NxYZUz05fMG+tsu10tXZVGIZkwedu4U24dwPtmASTlwO0Csc9g4FzJT+/BGNO1zm+NsNlwtWSU+tv+E5FxLvvUXVEufn/AkUQ8RWtEs5oBmxRkPSn/Al3ZlzFKrbs32Uo3u1V1H/5IExcQStvzz0Ulhr7ytjES5YFbtTP6nGaKH9w9+Dy05g91xrJ0zv5/cu9EJ6GlHWsreAgCTcfvN70ROhHuFA+TyVF3v+ouHEjZYlKBP13FTS2acled51IghTc2yFKWLLM3rrjX5JzvoLM7RldfXemHXOjkqGvBPTb0Doz3k6HeQm8s84grVTDqM66/m6nYlCWYlhOb05iA+U/UiDsdxJhP00dF8WGMyxo4ic57rs8AofrGyIN2VI3P0OuHhxLvB12h7+th3yB39JSWSg5bIww3VuV49sZMrqvo0upIGpFOL/PKEUbvoWOb8/R6Iro0J3uNTPcCbFDnwhVTp+z+K89URuZ4VS3Ik3VmzbeSmJowI0SkP2A0H0iYawogcoV5KjXBdj+pnWz7yUu+fGUot/Xrps8SpjdTn3U+r1NkCtQ8SVz+ChUfth5cxsLpwtTYE3V5NfGfTv6bGCst69kHLf68f5u/X4aRp85P4Hk1UAxuRten+F8jVHOITdgAzTPYEMYZVJsWZucuin5Y
 yAWkqf+L
 VcxCXaGo8t8twjw67C6eAKsRtiFlMkPmidQPbI21u+kMdSjjU4ooRdmXbQ3lClAxpiprKiv7qePQW+tT6dUzf9etCndaLnFPEKmcojPfobCCF831LQZk2VtZGGzRn53bQyuaqP9/fgvzJ1Ce3FCl5QyLRAH1M1XoZYzNCPiQPRPInrhdfGLM5hYL/TNOIXnAwezq5WZF4T7LA5UuMfx+Pw7elOEJhOR+Owa9nFX5Goq7nCbcZCt6QeYMHtqF//ghAqWTXapn9tKOgkjqjY/WOJ5enITQuw2rjtZeGPkQLLKhjHRMTZ1B/nk/oUjNzTn6qDG+z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
defined by the architecture headers, for example when the kernel is
built without CONFIG_USERFAULTFD. The test currently skips for EPERM
when the caller lacks permission to use userfaultfd but treats
ENOSYS as a failure.

Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
test when userfaultfd syscall is not implemented.

Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index e17edbc23325..0be47348ecd0 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -711,7 +711,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
 	if (uffd == -1) {
-		if (errno == EPERM) {
+		if (errno == EPERM || errno == ENOSYS) {
 			ksft_test_result_skip("%s - missing uffd\n", test_name);
 			return;
 		}
-- 
2.53.0


