Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7E160A8C3D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwS8eLLR
Received: by kanga.kvack.org (Postfix)
	id 1E9AA6B05E0; Mon,  2 Nov 2026 10:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C24A6B05E2; Mon,  2 Nov 2026 10:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A256B05E4; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDAF36B05E0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 399AA1C1C1F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:11 +0000 (UTC)
X-FDA: 85390509582.02.0CF62EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4346140018
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwS8eLLR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPYegOcZnqJKuxWjm10FaVpCHZ3NA5+s//M69XaIXpo=;
	b=QN7fTnYsOiVqyIjM4j5Dj+TCmhwj6UpImc+4HKDUJvVeJ8f4ff9FS1Iy8dfT/J0tqBQN7G
	1G9+a5rTftOce38E+ANcRIzBlcUoQwpONvcYRH05jLACpNdk3FdRIb6DMP80+OQrn6kpI6
	4XSlzxgG3IF5cWs3J+yiSQ7GoZEvfSk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwS8eLLR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632089;
	b=2I1Gy5BmvOfP6sVTuXdYE/+9CvFiYPQzorGM7KDGKunTr5IBcIjouQt3K+7pd7ETGtznn7
	yRuueQ/34UuHzN43K53JIQKLufLWBuL3oKEwbq6Ie9bh88mHQ5EnD6FrxiivONOjwlwpiO
	1CAfCEOZhKdgydDmK72tbzigylvySCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D12343DD8;
	Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99591F00A1A;
	Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632088;
	bh=IPYegOcZnqJKuxWjm10FaVpCHZ3NA5+s//M69XaIXpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwS8eLLRWF8izmiHdkYNq5LjxdeOp4umkkvwQYcN34Z9rw3DEKdCxVIm/QMb8A7gR
	 t5+m5d83T/fIrn5L0b2ZAaN+8jZ8g1DjsOy4JByu0FIJyt69c5MfIXSvrsAbFBC0Pd
	 ZAtpp1vQf8YD6BCFoUNHZYkpQ79JLWhYVuCXuNHc2UKBv7hCmoi0Q7AAjw/MixKYxT
	 uvmWxbyVmaVI3iozvmnI9cOQjZJEhATXkZoWZ8/1z9nyAElTJm9BLKwMSXMPyl9gO7
	 EGmzLkuetYZj11k9JWy7s0gliO0ZEnlRkK04QqGqiUkHfFbEccHQnJ5BsvDFUF/TAU
	 e16s1CFDecEtg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 7/9] mm/damon/reclaim: fix typo and grammar
Date: Mon,  2 Nov 2026 07:07:54 -0800
Message-ID: <20261102150757.93058-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4346140018
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b4hirdpss4ojmwgfykekzgbg468u3676
X-HE-Tag: 1793632088-387831
X-HE-Meta: U2FsdGVkX19xfpYioHuUkcsevHXB3pa3ejASzDT0LRd48S+3bYcaluLbv+aVP+rDjF9+PT21Uhnah0VmJ8GD0PZqd9VOrbtr6bUIP+zzzgwH+m4CklB6tBrk/jF13yMd07Dewn1zKhKZyf9MDEs98RILqYPqNMkBdlYjrsiHKir6rDA57lwFZfMucn7VuQaAwmPq6VBzC8el4ZnO/H91WKJdfZAGL1zKCN2QtLWi108sV3/bTFABDlY7mvQtEFFUmyz8eIv0yCH+CT14uq3uBfrQredH67XVABWBNsFb2bI7AwspMC7I7R0gLHrt/fYKhJ/xayKDFa1Ycst+Ip71lHRh06/4bGUcX7pMuZZYJ8AUzBLW/uZXNNDruKmTv3zdGW4GtdhoAz6FTTcNYjU3rLs+EnE0n+DdkTiqJ05Yk/C2I1uT6a5I6nLb5WHUy3CnoFcghTl2amD6G3pA/tNgE0mc5UIb/c3zIbAftZUDIcVbp1Nj7+pTZfcrDiLL0V2qPnF405R6wSodbJHOpG/upsmKcYQVfPeNRJIfnhh6g44TWtpuw2WtztFVuDi7ycYqcfj4s4eQ5XyWRjvv+uFTIjdcnSjZqUdaKd6cALLjDi9SfAtDLcT7Ig5WsCL23mMRy70/nXuQk7+Hn+4xyeefQMNm78QHfY6FVJBFra5ZQYCi1LzgXW4JTx3S7CML+BCnYa8Y8ubOxko1FXjkxq0XGDv0Yeg7tSrSrQ3wA3q5LJD0hQKg0Kb8aHlOFcIjwrF9vgSGz8M3yU6O4yltp2a1x9vuy9ErfMY26FCdNT4C1nQav/wJg/FyQqF0uoYq/odwWvT8YM5aVF2yx+wEPyWEXcIAxjPHIaITOpbHGgTAlX3iCG76ZF8QaIQ7Sv2ANkVIi2a9TgWEK0dFb37PctPoiRLPCzIza/aNDxAG0AgGXHI82N/vpXH0TuEhaQLazLOm7pAOLKiUee732852JR6
 o6c9uvwN
 byp7a4dvprqNyO+6R4Qk+HkV3JFyn1Euk/9K1QoWbmUVlW8TVebOwBrCoQ91xLEKePUrFSBeA0PvN5dGXyx9gGHUVsCg57EZdyaTyw3ebNrPlkbxFqCa3fYrmm0gGKuViOWwLuMo7oKQ6yeN016WfyLhU2pXO3KEzVnBmBcyTOtcBv9kZSp9+ZYDOtJM3I0kRnPDveNbFWOltKcXfceZw4sb37fKMFY1JQVoMytnNZseqWRn5z1fDb29VQxM8Ljp6ZH53eGbirl7Ckl8PCXHAWOJmEIyNznrv2O5INk7foMJBz6TmJnSYW8G1SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Manuel Ebner <manuelebnerli@mailbox.org>

DAMON_RCLAIM -> DAMON_RECLAIM
set as -> set to

Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
CC: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261008162010.4010682-2-manuelebnerli@mailbox.org
- Collect R-b: from Enze.
- Update subject prefix.
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/reclaim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 014b0779ea6dd..a84cea070ec76 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -19,8 +19,8 @@
 /*
  * Enable or disable DAMON_RECLAIM.
  *
- * You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
- * Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
+ * You can enable DAMON_RECLAIM by setting the value of this parameter to ``Y``.
+ * Setting it to ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
  * do no real monitoring and reclamation due to the watermarks-based activation
  * condition.  Refer to below descriptions for the watermarks parameter for
  * this.
@@ -31,9 +31,9 @@ static bool enabled __read_mostly;
  * Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
- * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+ * by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
  * of parameters except ``enabled`` again.  Once the re-reading is done, this
- * parameter is set as ``N``.  If invalid parameters are found while the
+ * parameter is set to ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
@@ -92,11 +92,11 @@ module_param(quota_autotune_feedback, ulong, 0600);
 /*
  * Auto-tune monitoring intervals.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+ * If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
  * sampling and aggregation intervals.  The auto-tuning aims to capture
  * meaningful amount of access events in each DAMON-snapshot, while keeping the
  * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
- * Setting this as ``N`` disables the auto-tuning.
+ * Setting this to ``N`` disables the auto-tuning.
  *
  * Disabled by default.
  */
@@ -151,7 +151,7 @@ static unsigned long addr_unit __read_mostly = 1;
 /*
  * Skip anonymous pages reclamation.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+ * If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
  * pages.  By default, ``N``.
  */
 static bool skip_anon __read_mostly;
-- 
2.47.3

