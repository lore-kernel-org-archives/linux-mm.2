Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F57DF9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7903F6B0093; Tue, 14 Apr 2026 08:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768056B0095; Tue, 14 Apr 2026 08:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3C56B0096; Tue, 14 Apr 2026 08:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD916B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:18:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24E628B691
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:11 +0000 (UTC)
X-FDA: 84657063582.21.4E3E806
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6FCB014000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UITAwoMF;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UITAwoMF;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169089; a=rsa-sha256;
	cv=none;
	b=MPgA0H78Ra2OlSOuT2AR4ibZWfR9eXa+1fN4uP+dYusuyP+kiCqbNFgE2fiWiP+az66hQ/
	D6Uhy9AUetJqt4aoJSHk+aY3jbNaNKWPiU2ebxZPFacMHxZF3L3PziKh8bB1gyyouXftVS
	EdETrY6XXMLaaQbQK6jgcP95X71TTDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDNhYoEHCr9iBgF5kZ+2FPX074IIkg5lINW4SO+xfxs=;
	b=MYBj3pvH/a+gyNMO7LF0kkIoSbTW6RjaZ+L0L7iyK4n1HAFZFDK/MKph1KT29PiyUAioW5
	g5gcKxzKcM6x4/QW6rTdBmWe0nvdMsPqr4hayLrLve6zd1DoEmHVQHjagoar2goBNsQ/Vm
	XlpAJcpyyf1aBPp+4uon0G6icW6zDRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 713D4409D3;
	Tue, 14 Apr 2026 12:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4107EC2BCB0;
	Tue, 14 Apr 2026 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776169088;
	bh=7YPA18L8fjFY1nJTSkWgelwEK1EqN1mPSRVgn6jl/YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UITAwoMFYDKlmLFClHtrJUImdu8sZ2LVZE0kZhndCJoJpW7Urem4RRmUGwrMv6ztU
	 aKC/BC7nMRPDx1c5Hlblqtv6HlBdJX9lLsSPdbRp1Ywwrc/ztp+yEvunYoBtXO7A0Y
	 Anm9NjV/9bdRsC9j+8MLmA6pB/ONADMaaHbn8bo/xy2ILnME+OmIyfEJTRLkogJAdM
	 Wt4umzLDOuM+D/RcRds38pZH5vgPzuDtRc3VZQYhyRBvQSg+7KRxS+oWMFJo8EkTLm
	 5HXH6PhZhWOL6+k7WpnlWPwPYraUCxnWHa1gRaBJkXRMKahN/0jv6KC1iM4tkEdyy0
	 f1Ug8Quq9MEfA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: drop include/linux/kho/abi/ from KHO
Date: Tue, 14 Apr 2026 12:17:19 +0000
Message-ID: <20260414121752.1912847-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260414121752.1912847-1-pratyush@kernel.org>
References: <20260414121752.1912847-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FCB014000F
X-Stat-Signature: 85ysdxicwm8xixtn7g3wjpwpin1uyz4h
X-Rspam-User: 
X-HE-Tag: 1776169089-425272
X-HE-Meta: U2FsdGVkX1/nScCUBPRqmAkYoRcePv4k/WDW5Ur7/HMqGggaP5PDCFLxxBky0ATC7iGbHdXPANnIMVD2I9ZM14caQd5p7BcN49QmIO+WYCQZ0mqdKhUe2gVKj5/0FdZp3GM2iVHxaeNYoAr1YBaaQ4B5zRBG0FbQXfHSBKRzIoSXmP6HVeatuY7G3kSqtIVNAfrSCgLW8Lif7Q7FeAC1VCHCF+KktGUomrFgfRkGiGbSqnSNRKZR1z4CEgZo9ZXrg39NIH1lQ6/2HlwsIfDuFTVqhnvCkUEHKppYDBbDToDN9SEHlXA3y0qCJwzEPIHxIZqHFuN8WNP1qmRLIWyZhGI0VR2+yHmmDfxNm7HE0LSwH7MpoKpJW82oWoz/WVHR3DUC1bS7uGl6IKoY8Fs8lRU5YAfNC+ZZlh7NSBrgu3xovRMmmUT60E2tSzP8YKTKMWRlPu+mIe7Hszh8GSuO3Myl5kT0WO3pC6KBrYAr0BOgJ8/Kcpz3YrS5cdLJBREPt6xlk6UgmB1A8ezPQ7ik6V4uOSNT/iDRvyIqTV5T/rKOLZR+RJ0i5JSlamEOkTLlvrUua1DpPppM69tWguyVK0FZiHFt0VpBG1aNfx6BdRv86szAVRNhPnMA1uS89FRwEB20Dt9f4IvH70kC39YKL53Fuu/Adb+NEZAeKRmumqYlMEMUH3uVIX33cAcvJZ0DKrsLy/0bARzQzcBT2aYHqneKP2neOreKRyTCarS6dlax6WT/CThqkoVR1c64de+6r37E3wQDzVLk7k1Sbq/LTHeoZagb+gSjhosEW4AJpR3AB2tahwD6dTndDtLOvjqToXdKBZmTOM/D8g/wYgcRZ5pk7dX2wsYMrgks9jvxUuFfSXkeKf33vOTcUjXqozSwzx4aQg9Tp4cd3iMHBI0PXRck7GLQNkhPVLmYSfEuQJ1258pNv89jBjar/BMKN0GzzqOt+mDdM1LWNufvKVx
 /wK1Lskf
 hi98uL/Pl3w+CuChU34msCGEOwLRoORCixTMfk/q7FJhitzMuY0oYvZTMZN68YpZVRbPu7GlgRNzo1o4RK3TrMCB2Gb1TMJl7VqqoP6HjsyDjRx9ri+at3vm0rq8DqYbEmcefAXAGehab7x9nVcRMoEJNyyqB4+Ub7yqq5vtUjja9fAoeLgYVeebEZMfmK9XMvHirUrRrynP78Zbh/dWjKB2/PltTyowtCJ57Bp3SObJVJ9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO entry already includes include/linux/kho. Listing its
subdirectory is redundant.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 97820188a600..c1e2cefb4493 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14121,7 +14121,6 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
-F:	include/linux/kho/abi/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
-- 
2.54.0.rc0.605.g598a273b03-goog


