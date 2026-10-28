Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BEE606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PM7+JxHl
Received: by kanga.kvack.org (Postfix)
	id 656F86B0620; Wed, 28 Oct 2026 01:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E08A6B0622; Wed, 28 Oct 2026 01:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F77E6B0623; Wed, 28 Oct 2026 01:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24B026B0620
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:11:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AF4980258
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:16 +0000 (UTC)
X-FDA: 85370861352.25.5853B99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D89CA140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM7+JxHl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793164274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3pS9CAQrAJLVnQcJS9FSWP6kxBvqhToAiMsGHORpn34=;
	b=LmSzHm7OP+L/0Jx7TlWIJarl6r98U5uoSOpsY8AnaN5oBYJ4zH+JUDSn41FjL5HcMhYamN
	TOjRazU1z9nmvzhJmU/s5JlIH4WH+5lzrxSTld34lYA4JB0OggyfOe+6f2s8gQt8UVESxN
	ysIMYNAd2/Vhy2mJL7jpC44L+tGwrXI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM7+JxHl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793164274;
	b=ta3blz2ZxAYrwVMYBGHuzbNJe2ZAQp6ZeMoHJjBzaeRKAWrUXZftxCuR/pWwQHi9vNKl3r
	6LS5t81KW9ww3Nz3LRyriT4eE+OIb70kPhv5/Gd1lI4vrfTnG2Jd1n2iISPU7jJdArSamm
	zYs6R+eIE8R6/Ai72pd970sGJ8F+DM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41A2C43BBB;
	Wed, 28 Oct 2026 05:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0B71F01828;
	Wed, 28 Oct 2026 05:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793164273;
	bh=3pS9CAQrAJLVnQcJS9FSWP6kxBvqhToAiMsGHORpn34=;
	h=From:To:Cc:Subject:Date;
	b=PM7+JxHlWTwo2Ik9zg/BlT5FVYX/ie60vqdCZjcrhWFWWzCyH6ykp93wUbG+o75oY
	 Gw4ehDJsaYvSWssTO51ia3ZeKLh5GLLECO+RywpdBtah8+lTKRGi1sPTl831Oh5lYI
	 s9xLvllWJrbMj41XwUYMZM8HA01P/b4u8j402n6/HSWn+IxVMJz6pzrxV62U0gGEd2
	 v2w7WQEu+DIORlwX/JNamAzGpntaT1sfC2kt7UlYqHnt03DJwms9HUGsa9TQoMABxM
	 SxfsPp3KrIXD86L5mFA2JA0QIFA4RQeRIZDHfP8wFqy5D8ivgigHHXgmzDOwPW+2RN
	 3/zasmou6Hcdg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Tue, 27 Oct 2026 22:11:01 -0700
Message-ID: <20261028051104.154232-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D89CA140002
X-Stat-Signature: rkde5a5abxwuq49b5rnmws4gctuatw9q
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793164274-180350
X-HE-Meta: U2FsdGVkX19dzj0e9YZoiC29bZsPBttb4u7g/9j2buL8i4+SAAV3Nghos5ESzZ/hGB9YhIR9OvwzXkXe3BFIHk061lsFjVglT3h6C529alSqRgUUY/PXYm0HYCGoN+18Aygcs0YChomcz6mOn3oTQMZuD6LsZol43nrLsdno70OlKq4On2hZ6tT68BEOARSpt3DScImO9sCOSlKjEhH8q0lpPqixfzCtnlrGTEVB9y5q34OofMZLtpiUcDEYK7T/Q+bg0Acrvmu+dg/eyjhNw69mfBUcJkndkRaW6A+54bVQCz9slm3ykadE+znWH7kWNvsOqpy4BZ9gV7mXQfXX253Q14hMJp7O9bdmXQzRUa5MlRuf22+PwpJbTqDI/ekT2cDo0HUJDAAX0Y/333etTcCUy4AF3bxUSRmv1SiK1Z3TGjEsQZZeXGyh8w2wh+V8Em1+8Tz8yf67MXAF4CDpzM2SGewOVfSLmRcIZYbA29myU7K6OMH4fZ2RiLxPsPuT1Z5RK/CJQ4nKuQ1t3RWhnNzez+uS5WSgTOyOlgkLNXY3LeZ1ZBjMPttKLo6vJEr9IYah35329DY8fyq/IKn01kcO3m0a09JBDEXAM5pWwj5lewOPVbEcItclhXInqN63cyQSIGIWWyIjvcnwLATrOWPPZq9+FsjGaHzijGg1Hj2XStOAnB5lKYsooII5pNe31DVZ4+Xb49Bc6Epq+fsnLLoahC/9roKuGDYmt65i6YwDPvLBvrxMpUKSRiZuY1Gd03aV0B+7N7RQ0rkGUumktE2xJgmfYpZn6U3OSGMcndFXTHgY7wf6HcdaKyv2M5amNtT4HgANNkkSPd7WEnMAMJI5NtRW1M8ZYLN2QAyb77/GWYuzolN8uZX0hakbGmzYtvhG8MHettkbRU3G9J59cThXRwGChKyo2ONO4ho0y5mN6CdkO9rLj0erzNRLi5RZ+rJXy2KxIilREAAMDbT
 A+7ox4MA
 ktEjsbA8TINrOPgOeKGaZrTeKiCyKNEMDbZ+tRJeX7++eDYp9OEXHp570mum8ZVDxAbpTW+CHmvi5vXhhlVmsztJQmLggCr8JziVkWmmjspazyBdAFmzOvIjDTbUcojaX7lwHM/DySdSTVAsiw3tc/rpnwm5SdjbKcdxe7HEyJBX6RNCW9wsMIFW5eyDxAryTEtEDm9tfaMG4Mok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 969f73b24b91eb0b5042d4d7b26b4bece1f27d18
-- 
2.47.3

