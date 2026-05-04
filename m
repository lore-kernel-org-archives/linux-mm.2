Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D919FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580236B0098; Mon,  4 May 2026 05:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558986B0096; Mon,  4 May 2026 05:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8B06B009B; Mon,  4 May 2026 05:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 266686B0096
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0C101A0372
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:40 +0000 (UTC)
X-FDA: 84729225000.13.0C6E34D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A78C10000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="19x/oCdJ";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="M/Uov3tW";
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRvGlWmW/ojdtGAUMoSosFz7deYXy8s7phdrC4jCvnM=;
	b=VR4XuHY4HPkwu4sK50Rq/cQ4lOWyACB4MshA1vM+l9VK0YrBiI8Fscl57IiQGLLGYHxyB6
	M0UrBmdrZ3pnSApoJ3wSoYeCJfagGH90+SnrZkFIXM2A+LyYGK/7VN3gqRcRpKyjuzX+d0
	dpepRPeiM/w5vw1FES5VY3YypHk2oQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887219; a=rsa-sha256;
	cv=none;
	b=iWA+Rd4p/w489jNcGRFiUm6NdcdYJmUZD0IwTSfF5g6QJ985uFmU+MUnAnxzBM/TbImUTN
	rvRCgEiNZDBkWNsE4msj4TCZms9U3iQwwc/QGiECzKNGV3pF8j1Zk/wzFB2WE72k/0fqNK
	Kptrj8sF4rDIUA9Ktb3wSzIRPi8hCeo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="19x/oCdJ";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="M/Uov3tW";
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRvGlWmW/ojdtGAUMoSosFz7deYXy8s7phdrC4jCvnM=;
	b=19x/oCdJuCt3sTu3vTApdQLhjebe/Ydk01U5DhSb0hNZkgEx21FnNsIhZxOGJVCESPAVsl
	LzmeqpUq0Jonmcm2OK6bLFurYJcZRvp2Zb3fWKq/tQ7MSfWRIa9LD+nzJsmxGiqUfVc7T7
	hWa6B/d+4MdRYx7xvQQ1gJpCmIZegN7WvktTAaNeJJWzg1vwJYyEWaBoM3QCehJvhrcG5O
	XquE6x/y7PPljUh1TVkHsvCuFRLtoXCA/mzNbJUkJs8YoVWAFs17BuyGjNxgL3z160gyxq
	K8xpIPXKEWoaxzoPb4lJOfD0jpiS3f5PLcBLsf2V89LmCRScbpjbYMAkD96Qfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRvGlWmW/ojdtGAUMoSosFz7deYXy8s7phdrC4jCvnM=;
	b=M/Uov3tWwMt7wja+O9d7V2NBb3AAHuPbGWW1qRdr/I9g5F06chKUTbdH2eVZUEigPOs/sW
	5rX+5REI0NZEUOAw==
Date: Mon, 04 May 2026 11:33:22 +0200
Subject: [PATCH v6 06/11] kunit: qemu_configs: loongarch: Enable LSX/LSAX
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-6-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=938;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=/OTOG/yua90Lm6N+XVb5eKq3ag+BtIQRvIkh/Uh7nqY=;
 b=BSBfbeny5Sp+nXeipSJPWFZtzmTsbG6naZ2YXu+Z/Sz6yPYCeqEBDHlnUD9xlFYWGXf+e9G0y
 2o11zIf8DsGDWXZYcZrsJ54Mn+Gvgit5Ozs+EfUJF5lomDn2OlZ/af8
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A78C10000A
X-Rspam-User: 
X-Stat-Signature: k9zz8zt1yf6f7a3nt9jy66jrf9pjfzpz
X-HE-Tag: 1777887218-84862
X-HE-Meta: U2FsdGVkX1/4dXddTng/NNRrnwt82356kLcAgMdhmWHKemcLmSIOA9Jj8k8+v9k0cKSQcGg3l5AQhcr6jCMmKoTrr+Wehfft+HzeZLPcbzhjspe2olM1sIUVkVOHxTY75ufe5bhmVYhjnyjeMd7zpH8f0AlxpyBLiNmQ2YvY1GHtRMOIuKSVUI7Sfra9wPvxuQq6k9+wTBK7iMMPC2guSmdDom2M560ehZrfN9lJ4fcEYmUs3GCAs6gajepSQkJen9OMVH+FppAF6o2dUU578d8t2tc9hmHNazcVNLSDmrv06cDQdze/u4EhbMbRR+8VGlPnuVAI0POdZoyEGhLSDbKHKnlNvpD95i/5+eQSo0lO/Se7lF010LHtlWe4C/Nt2LscnCZTciBBsk8xx6i/Ubq+fknpW48VumCe6/SuUWlxXfGaAhEe3eC5yfBtSwxX1IADec5oO4s+5z2yvgN0dMqU6B4frD4LjxE5aHTDcQiYwvtnGR7+NcWdCssYvA/8otVgjV+1qW8I0HvxQGzzexUDQHpmJqOvceH2zMaUj/QooGzlnJHNT7J9MKeojf+C0tOcb7ZQmPnrfDC8IWS5qsNBVlnKU9yWWNL9+1YW5E9zSf/RRsdZjKPTGfWr2fg4IpFoHv+nSyCrtee9sLAqgif+MRe1p+ErclA6RgjTPO5w1DfoLF1iEXd5gFZjh322uPwc5N/cejwPFbEQ6oxPeXgWoW+qTwZ4eaGS1TYndpJOQcsVykTOBgtBgjY6L4yAW+au5S+iumONoedv5ZaxJyTGHqqabx6DZDfDG6e1xaHArxApB4f6bKyam1pYpwrn/hPCX1+46NiD/FzppRcse6CVuz27knZr7htLnvoRNOTElMwfl6OYbUrR9Et7YRlmizqYjsWqLxVHDoLFrY44G8nZNgfbh+S8ELcAukh6atchkFqmqfqsYi7APIWSagceNmMBDoq29Uvq4otGSv+
 t/TyfTKd
 kV3q1dRxymb7+RGvEq3lvXxnzB6mHn9Ykl2N5rtzXaXfsr58f6Kp7sH09Sz4qzd3P8GKPN5fGwbH/04AINZWbBaM60yewYaixDiMkVeZ292OKI4C6y8pjMmtLD2MGEcLFb1CLfz4SKo/8ssw7JmYusPfLvaoBfCPxZGmAFNJsYnueygOaHvo5b3GXQn2+daz9l1OoEHodPjqHWumZkUjYWhUeFLylyso9q68RQxUp7jyMPESAAgNJD5h3rakQBSk2WLWYDL9uMDIorWbkotLT+vWs07ziEuq8dJWEvbg3NhcgfxuZupjIbB4h9GPiTcqyK1FpYNo38TQjv76N6wbOu/ccBLW1TAux2QzkY5e1gtD+UN9X9SWcIx7oSFVAvmN/5ZOBGYvMmKT+9x+cLDPV8OTa5z0NgCEQH6p3ZNV2zD8Ku9AGshAnaX5N6XUcq0lkR2oWVUR3FLqKbYNSqtmLZ5ZYQdI8qmRdUctknMtXaFTdB4iAifBJKRTjefoJ+6wOpp11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming kunit UAPI framework will run userspace executables as part of
kunit. These may use the LSX or LASX instructions.

Make sure the kunit kernel can handle these instructions.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
---
 tools/testing/kunit/qemu_configs/loongarch.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/kunit/qemu_configs/loongarch.py b/tools/testing/kunit/qemu_configs/loongarch.py
index a92422967d1d..1dba755284f1 100644
--- a/tools/testing/kunit/qemu_configs/loongarch.py
+++ b/tools/testing/kunit/qemu_configs/loongarch.py
@@ -11,6 +11,8 @@ CONFIG_PVPANIC_PCI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_CPU_HAS_LSX=y
+CONFIG_CPU_HAS_LASX=y
 ''',
 			   qemu_arch='loongarch64',
 			   kernel_path='arch/loongarch/boot/vmlinux.elf',

-- 
2.53.0


