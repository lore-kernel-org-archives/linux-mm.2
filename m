Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97518FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2D26B0098; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645B86B009E; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CC86B0098; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 373B36B0098
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E99865B16B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:42 +0000 (UTC)
X-FDA: 84574154364.24.061BCCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7663FA0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4tXJxPI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG0FiHq3122N0rcYK4oCE99i2nUfs/WX8BknwBpkd04=;
	b=KOgqLWYDFsQr8Uy2TQZEj8Prjm7O1owKsG4QxN5jX2WDWPIRrzsp+OijHQlpKwNrTOi7eM
	WPK3h8E0lm2j8VZauCgEkoPwF7EC86gviQDdlDDedzooYSQOgvIFxi2a1xvp+ofQMVyvgL
	5EzjQsRrsOxZ+UXPiHMcMhvs8wuR6TE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4tXJxPI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195061; a=rsa-sha256;
	cv=none;
	b=Hq3cMdPT+w1e/MIVYYuLD7JUMbBqbgdwDKFPPxdDCmPDGBbhw3IBe4J3qHHw7rWFisO5Fe
	DR0kcnCDfuI7Vuy3j4CJOkSRVQdLN0659j/+Yx6TF7DbjCEO9TYC1edpMycVoX2o5ziTXm
	xz5PZENrvMw//I8FKsKlsaUWj1box60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9887644708
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B00C2BCB9;
	Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195060;
	bh=O/0+EEFKC+kJrViTx1hpFrUcUp3ITetgY1I7Ly2ASvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4tXJxPIPrgz0CadeeV7+7KT1aMY9uLIhl5HCKpRzpqzSGjW12GXNEuiwIXCSkVdI
	 G+GbWzUPAPKTpVEDQ94rIl5J6EUQR52cqdL0OlkhbkTs2Zj3nphXZkaJ2TOusMXTV9
	 4TtvRyaufrJ91n3SSgAIAOqgM+68NVJCMhPx4EFexaSQWsKIji6qElSsdmKH7lLrHg
	 xKSQ4MEnOuG8/l4dZ4ItJKs+QbigXNWfx4KnROiF3wXYYOzDcPjsIZDjdzQ8vV5Bam
	 WDF+OecFSRN616EZtOHNjvFI03c1mQgh3Bj5ZufdAV0lgEiSdb083ZfkvhAWiskfeu
	 hg33jb0OmHBLg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Sun, 22 Mar 2026 08:57:23 -0700
Message-ID: <20260322155728.81434-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7663FA0005
X-Stat-Signature: hfbqnxfusc61fbrt71697mmnikfo5fps
X-Rspam-User: 
X-HE-Tag: 1774195061-146391
X-HE-Meta: U2FsdGVkX1/mA9BWnYIsRg4A4uWcLTiQiTD/qBljxe3bu683YzJhNqJR1E9jsDIk6uID2Fr2Uu9K6ttBCm1F8AHp1HjZzpBSLqF+fpXSmrnWf5XB9A2ppjO05PNjr1ntKkdP++GAFw1d5H9bQIW3I3BfjMGUpHPiQFeBmIMacQt8A0qKMval/zHDNHQNwQlNfxQPz+uKsw3QcmXs1WccITFDEtnVtQPdos8pA5qaHqV9hH5XPrlhjH83cLpaCyInqaWvtMOjxkyl0wkJGVYiJ/jrG/TUtBxzJJ4KMQxX5dwqDN7f4/4nDquI+pzsLPp6hOsOa2ijBcr+Kmi7An8fKCmSTzCcMvI1/lb2LgSBYFSKBTrgCsNhlJCqD7HvcimvFPCbztyEL7Dek9N1jKMNxd2vQbjolqjuehJBfSTSlTWvzi5/iugj599O9CFaRr7BHwzj1ZDRXuLfYOrJXJCLWYcF6iS1Eimqu6R8rqmBsnXJ3HFyNifV6B40L7QP/6h/RqOgh4Ta8RfUYNcjmyPvv7XTx07t168Uuij336vNQDXH5hefR+NJbn+uZrW7hifoVHPJ9lhFSz6Awwiz6HSv2OWKhIxZ6MhbVEH+000Hgvr3ZDyzlkc/upLLB4aVs5kunCyMsfkUB9iJhIkahLYi6KHnpo6l0B7Trtj0BvBqtnsC+FzRLr1pFuXbcFJjFDYx6hm9TPvDsS9jN79JbUspO/J6JupscoCYJjjnMPWWNRDUIz6Yt9vnpeBgnFIPM+ta7TmSPnsvl9H41XXE2k5HTSbcJfG19amB1CXkOX/V/PuffmZ1DtGSRI08eajrYB/h17UzYc1Q5lXXH2N/S6CJKHuDgSMc2Uuf+r8xAWviqi3TGhGJEMGYpe8Xqu9IvzjECgouantyDpfQYdG46H0R4gbjCvhRXIgHJjiRGogODxlpj0PQLh/qxmG3dRaKaCtqHOH6GK+rwg1x3owJRu8
 wBGRsTLd
 iDHckfkgeBAKvaFAQ6NxW2f2UBJdWQFP76PFfgDUTu4hKLhim0HGpLe4zeM6velSrzzTXsYhgI3dqn04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py tests to confirm damon_ctx->pause can be set using the
pause sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3aa5c91548a53..e6d34ba05893f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -190,6 +190,7 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
+    assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-- 
2.47.3

