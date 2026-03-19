Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE0B1088E7F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2C56B03EA; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65F96B03EC; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3056B03ED; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3EE66B03EA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F3F81401F1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:12 +0000 (UTC)
X-FDA: 84561666504.08.08E6198
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3594C0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2TPMNRk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=prhXIDFrIHyS3llpIGRjcUgm0JEi/Aa89h5LBph5GvS1O7Pv0vx5I2LZadxVM3/MdSd2wU
	fPK5vEmxws5/hH5O3xe+P2Fgb/uij044j3jh/hQf0GVIDN1/SiIT4MqeVOUHzQ2jOaW5t5
	GGRg7xJrYm3Jc85YHb+CTAMqpxK/nDs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2TPMNRk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897730; a=rsa-sha256;
	cv=none;
	b=xk4b8oF2tiGmeQY5YUXCsVRD5GoPNhfcelxC/NBpfJMVTCdDOqhfkN4CubbxK9oeVPLIpt
	VDORObW878GcAO6nZFHFpM5ZjUxxM9hX/M7O33AlWyy+Nz82gSvFGvtHFPpR0SD7/Pm580
	3gv8RyzPOPuYQgCr1FhICdeiONTPpgg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 671034472C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340DFC2BCB3;
	Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897729;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2TPMNRk3SQFvWn3IXoQNGAZczLvJpdEKEPh13gBFvXGyQ4+SPzZNesS6RWSv7CfQ
	 ALMgqHWpyRzbGS3qEFMk6VvM7JhXGGU6inqSSIyo1UUsg10kiSws/FyB9tcwg/huiB
	 eAJhSr9CyB/jZNeEFwNFP623LpBtAo5HRD4+ZZzRkgoEWsKb7t2WPZPc8JOwdklpvt
	 AyqLSKccVf6ewktCkY2KfAE3aFOd5ys2HNRihi7vG38hkzS4nhfevXvUxcu9B6LYEp
	 u/WjZEgxjAs7+JzwztOKWXkzHt3wRQN9yb+tVPNBuFkxTbU11DKoVTSpDD1+nBz0rN
	 5HOi9MMGNdbWQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Wed, 18 Mar 2026 22:21:51 -0700
Message-ID: <20260319052157.99433-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3594C0002
X-Stat-Signature: b8mpct9xe8ab4ckz5pbge6w91wmrs9wm
X-Rspam-User: 
X-HE-Tag: 1773897730-561629
X-HE-Meta: U2FsdGVkX18nkhhrbKMXUxAF+OlBO6QDv3cZtpnmBlwjWnZUTyeUFvRISSi+Wi4Ydu0/IxOMx0we4njfNhduGygu3cbri5Ua/3nWewEBoaKCFj47fIqOY4Dx5qDiPVbzw9jWwP85lIHGYCqwPn2fmAtEWSfI2g+ScREcd5Hlj3vc8yK3IZFdcMWVmJeTi5fvAIA/adDFxfzEvGyNXxNUVhgByT0BpF82QtE+M+LMAx97997cObqPho2O0xRae3vLmY29DhIqX/3Gqh6cN5xDiSQ+WarCK0+sUkogETPOmS0ORLfhSAYr9KD1Nndjv80d/Gbxaa8EenN6Pme6IIOSu8F6E813W0HNgrku4DQ5KcMTFmegOBe9PRqda9qvGsIJ6Ro/f9nw2gC+QGe42Nsathtx48+GHDUUx2MkVit74aeE3BIeO3uRfra/3mPIjjCIEdouWTcM9uPBFakprudIF6sHRxEivyKcwspQ1G3qRxoyx+hJgKUroGWU2eHqAqB0N1/G0LSZauxYdbPHpR7AeXKHA/uYBgadQx769hyxryfhUAybxFeq7ovYdMqXOLNPaogu+HQ3uy/qwQizMgadpIUJuHkwwwRDjqqRjVecPieHMr+uO9Gpn/RU1qRWCh917t3/MGZYxgEVomNAKmQYab+bl7yGy1ZIDIoBMlSXHmmVgyBRxJxffLyiraFYO7hIIGS5yne9zRvybVOY5cnzi+2IW2hDIp9ru1HNrPZqdr5i7V1yuQym+s8DnvtXrnkjeyMroxsdV8Zb4PE25dyFUIfSQMZM8v8v08bFm3pCVw2oNDsdkKa7mXtRmjVw9qzoccJa27d0/bDpzbsnGPqb2XwKzYtaLlp1T0zvRChvgjOff7ic7uaVhqp5TQeh99sXhWhVcBJd4OyEW6RScg0HVsbMiEfk5SlxL87UAEuXCXrnYp4NflgaCRiS1lnSNX2wOW65xSWzydUTXBElLlC
 yiCghC3Z
 AN9jY4HbD1ym9M0HA7J//F/GbqZZBY1VHWocL2/MrCXDsGd72RWFgNJAbsHhXIDJOWKuAX8waDGhQwN/k5DlTfVYvnL9IN9t5DAE98XTtUUcWra5ANL88xPgEofRPb4RSo0Jz2cR9bkwzhBdLhO/lEz9zuyV71/FMUr7PaJTuvhzEMoQbSuGqes7R9NUGQiaEV6q2clJHBk5mp6DcwId8l8IhzN4JW3h2mLJsIwuKJoUQBfTG4seYlmf5q85d0DPbHZe1bxq60UN9wdzNP0JA66MTY/9eG/APnDiibJA88/3p68psHl6vSbo/qqJo/Ch3FHcM24T02tRESPVQ3iLrrCagIv25m/PfyHAy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index af99b07a4f565..5b90eb8e7ef88 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -200,6 +200,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
-- 
2.47.3

