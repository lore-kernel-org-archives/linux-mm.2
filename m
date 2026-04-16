Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA2BF8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245536B00B8; Thu, 16 Apr 2026 14:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7156B00B9; Thu, 16 Apr 2026 14:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C646B00BA; Thu, 16 Apr 2026 14:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2EC76B00B8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:41:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 945D214093F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:41:23 +0000 (UTC)
X-FDA: 84665286846.01.3DF0322
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E16FD18000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:41:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF8FabWV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364881; a=rsa-sha256;
	cv=none;
	b=SM0UqvGzCwm9ERPFj201IIUYfjjI62f6GbpE5qeevlOk6mFj9tSQ64KinwrE6Cd21NGSTT
	z0myEceCftu+ZIVdBd7ZjVItwVSJaLV++i4evbXnAL7Xn9XYsqtFUkmsul9MhuCPTBxSNy
	ZVBXEQlWzneUYWWLWFEwlsogfZtfNaM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF8FabWV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oL7zBRmplxTWswaOuMl7XO/94JJ3smq/qsLtxmzpNrQ=;
	b=o2EOxBjC/+/orUigiKN1U4azB2ZQ2O4d3gXNLPkLkSaC/ui/IiwTOcw4CVhUiTOM2UH1J4
	ev5JPM7Rp+WF/+R1PHADBBa3lk74jA0GtKvXQprxG4FO8OFYCYVMrfzQ1saLVpUqXVkLHZ
	LcpIq2NV40OdhvS84O750lL0AOL9aqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33C1360127;
	Thu, 16 Apr 2026 18:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E768C2BCAF;
	Thu, 16 Apr 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364880;
	bh=zYcqHhJWZbVqOZVOHUzK1fIX7tx53Tj7PLzpE68s6dY=;
	h=From:Date:Subject:To:Cc:From;
	b=nF8FabWVU5taY3Rmp22jRYNPLxtk9RBQEVKWLAlYvOvzhXsszdn5AURtxhjf4oXjh
	 v2jZW2D3Wc13XbUQuOhpDw8bGZCbZ4b1C14zUEcpmgwQIyR6ewWDwAonk6RpGBNQTb
	 gl8plMGNRgKNW2XrYV2gXw4fIgy6kzjKSw1qpnjWs39rdwDtRY84cV5bvrr/GhZwBp
	 SDV17IwxaV1DEVEq2K4cp4zouTdQVOdKwKC4Twc+YbkWoNiE8UFCXsRxxgt3VbGjVB
	 Zduq2Cfu0b56XD4WYTX1gq7tR11B1f/J73SdRu5Y4NkUUDboCb5Qff4Z7X2jCT/npm
	 MPa3RgzryDNxA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 16 Apr 2026 19:40:56 +0100
Subject: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
X-B4-Tracking: v=1; b=H4sIADct4WkC/yXNwQrCMBCE4Vcpe3ahCbUHX0U8pOtEI01TsqlaS
 t/dqMcPhn82UuQApVOzUcYzaEhThTk0JHc33cDhWk22tX3bmZ4Voy/QohwjzzkJR0R248utyj5
 lAR8FZqhza8VSDc0ZPrx/J+fL37oMD0j5lmnfPwu95s6GAAAA
X-Change-ID: 20260416-selftests-mm-proc-mem-always-force-5ce1b26022c2
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1433; i=broonie@kernel.org;
 h=from:subject:message-id; bh=zYcqHhJWZbVqOZVOHUzK1fIX7tx53Tj7PLzpE68s6dY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBp4S1NrKFPxkSkZOUOGYBSWF9G/cKzW7FGRGif9
 Id/7HTmuaWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaeEtTQAKCRAk1otyXVSH
 0CvzB/sEoiIdTrIBx0hojKsFJPKr3NDVQ+pdSRoa7QczL0nxBjRD17152+PsXmgLgq515DjRt+g
 B2wQ0Yj2fz3msXDYnX2V2+lh5eP1iudpesIJekF6/jX6L6xcgYinBKGv3Y+Tj9qJF0kxKJiEY52
 5dublecK4tRkujar0tO5gD5bbqApWDpSoJBI1CLqO4LYtJfTu99SIXQa33oB28qDcgtf5oPTVQG
 rnUJpRviG9eSoB8vIZ2ZQceKPvxN5HK1eeIVSCCNpIXgZngxQgS9YbA8VMYrKlT7OfT/YXubGK0
 skcAP8Z4b/vIvII1KJDyvq4HFIlFNvsq/A7sR2ZsbnlriDxZ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: E16FD18000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 99wewywcim1y3r77wyesmuwy34ipg884
X-Rspam-User: 
X-HE-Tag: 1776364881-528811
X-HE-Meta: U2FsdGVkX184YuCdUkF4EyILU0JZe+kHiIWyMv3XWxSKeHRfjcPBpcLkihFbWXIRQ+1lMsxbGxfyJBzX/DbYm4JsKFQLTA0a88M4u/O5vfo5Mze5AF9yxpkuRQJPBbgNp7wFzDTCUTj5xgyi9MsA5IK+8k7LzjNFwGq5rVYOUWnEz3Tn+cFZGkw1Xh0x9382vfvMizvgDN332abO+LitcVURoX7aOHKJAr0OWprHIJ7uTjo95AWQgZr4cJMCcZ8ivhosSsyjP7a9DMN0Z2ktNgS74VQCotVwFlR13nxKgpPFjdcxYZpymk9jD3lrwLx+wt9xDlYZDUoxOUVN9y2lTMgQNvtlUcELbxlBDRJAhQlMrMxHo+RggQSBPiJtFzHgvfWSpqzGYR+XzbTjNdiv8N11mxKDKc8D2SDAa1uEo8RX+VASyrICIFdv+WkCwkNxhjttHzNrOMwnldLEMc52aT64u8QHM3qvdy1KwC08zkB4h35T/QCfnGAknt+Pj/1bH8oIO/exjnphfpKr7yegLrirwdDI62DGLcYteaiFSnlnH4/u5tRTqPEQCg2ye42LF6RnaV1RlW9XsB4q2Vr5LGca/TAfGB0JaBLrzTL+n3noSaCSkZxwd6pk/sY9Hok/V360QnICjahR2HEd0A7I4yS/jhSs5SnIVCjuO+r9qag9eD4aCLMTapRxCb89SJRqcebCNC8YqHXREhyhSatrdgOZ0XSUnk4RKGDm0mRcF5ojYihxk9Sjp8fTKATXtur2t++mx5gXmnD814Yu3T56osDrchvHVRmV4IgBfovvri59ZM45Jwv/qIUJoiUJyBi35ffbFZsLupMbHKhKT5c3/CPA0XO0+hPfImTvrtUaCcTwa76nULQHbBAMVG5leXfluzifqJOEffk7/WoguKLD1mEZeAq+m55ToPZZtWjv5UCdfiMB6YzCCdIBmS96jUVSZw/9EF40qxsOkK3C34t
 s77FfiC8
 XaAKdQiNQkUPHVj44r11cyN9reuKiknHcpX9HEiLcuV7+kZo37eB2Jha6xcXwRvQ05eiHO+FqRB9kwbk0xhgE8fp1HejXhZxca697MMucp/sjafOflusOphaNkpWCC12PcWETyIW9565+3AIDe8ajcYQG77l+O1Gs7agZOPFBhPvWJ+zbKfgsFs+PPC6b2LyVoqeAGlDKOqRndBEIwXYCf5/E/dEy/8nf7ibrLPE8didCV9kiMfL/DYTJ4oyFZ8eQ47xYoUNPhuEjteQfrxOsje3ScIjTVFoSeGVwRlMSnVGsbdnkYQqLY7ux38Nx8z8gRzyeCrgZ6rdI39ttaeheU03KpJ5xs6ziu6qC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several of the mm selftests made use of /proc/pid/mem as part of their
operation but we do not specify this in the config fragment for them, at
least mkdirty and ksm_functional_tests have this requirement.

This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
the Kconfig default") that is no longer the case, meaning that tests run
on kernels built based on defconfigs have started having the new more
restrictive default and failing. Add PROC_MEM_ALWAYS_FORCE to the config
fragment for the mm selftests.

Thanks to Aishwarya TCV for spotting the issue and identifying the commit
that introduced it.

Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/mm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 1dbe2b4558ab..06f78bd232e2 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -13,3 +13,4 @@ CONFIG_PROFILING=y
 CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
+CONFIG_PROC_MEM_ALWAYS_FORCE=y

---
base-commit: 599bbba5a36f6de57ab14c373c25881e2b5273f5
change-id: 20260416-selftests-mm-proc-mem-always-force-5ce1b26022c2

Best regards,
--  
Mark Brown <broonie@kernel.org>


