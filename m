Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAD9E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 04:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9B36B0089; Wed, 18 Feb 2026 23:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353D16B008A; Wed, 18 Feb 2026 23:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2560A6B008C; Wed, 18 Feb 2026 23:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 118D76B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:00:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829F31A0422
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:00:32 +0000 (UTC)
X-FDA: 84459854304.25.358822E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6785140003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:00:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o0BLpi+Q;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771473631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TYvGuBd4REV27FP0K8plWKPdsV+sXlwsPB/KlfQ6c+E=;
	b=SUiP8Zwpqbt0nFK0gzYA8XVeFBgnQ6oBdIaYuDnvN0VJB4uvAlAkdrsKFQTADwD/rpKwcu
	8Rc1uBFOAp1MPq74WTTEaXpn3Qdi7IrEaqAZhvoJETGSDQUVuLxJwG/dFlNKmBl2RmLP5a
	E/E0nJD36FPTwWwCEoHzhTxVoOp9eYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771473631; a=rsa-sha256;
	cv=none;
	b=MjvWEyTe3MfPyRVPoIP3s6vnTDgLUgIw2UV5wSi5XYKD9YXkSkQQWbZEFKvXbnqCb0+wr1
	5qAfbX9ZNsTx+HLoRwGYgEuj6zHOn0Dc+PpGcD8sbyG+MrTdmKjhif5y81fmzUJ8nxTYZR
	ygKEE5Uw1H9LbXotZf02moRs0OM6weI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o0BLpi+Q;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC2D407C2;
	Thu, 19 Feb 2026 04:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2058C116D0;
	Thu, 19 Feb 2026 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771473629;
	bh=NVmzFnWHsP7QdLgTyaoYyFR24TYNfXKtePeyAnEAO88=;
	h=Date:From:To:Cc:Subject:From;
	b=o0BLpi+Q3qTZWfh9/tg1dLo1MuIcjF+j/+1TPRxle/EMGZuMHxawU8x3GrnhZnSaL
	 35cn2SNDvXj+FMjKXzYoTIy58tWBcnalyouHqI6P2pLLwak8lD4Bsw7UZrGe/6h1sT
	 0ANSDpQEcpVH382TNPFzEOjhSVsYLaUcNgpvqpt8=
Date: Wed, 18 Feb 2026 20:00:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 7.0-rc1
Message-Id: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3oepn1zrhyns4cufi4dhctwt4dp1f58f
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6785140003
X-HE-Tag: 1771473630-204382
X-HE-Meta: U2FsdGVkX1+Qhw++BThd6yhyT+bgHcWwranW1ZO1ylZfBdrkvuR5It5gB0p158zZO4pqQJ+wCO7ZjbisgaYPvXfo/ank4sW02Ib1rBdoy3MSn6V49Lq/jAdNCkkF6S3iZ+2PArOOck3W8T7AGujqNYQHH1TR957tuFuQYvnqn9DPMMBOlgy78hGG7iTLkmUtQGQFFetOEPeYKdC9MW+wg8sQp0Fg9EbnKN+VyLqepUTm1he8RC6hsandH3/AAVGYqhEMYYZBiLeuRNEerRMArFEiRRlFuVWER3ysd/ZTK724cB9MVnzS0m3PY5pDwFSJcPBr14mVANTuo0ek+mh1FlqJPydo1m1FyvHDdXMAmyyz0a3QG+qDJ8Vl8jKi0coH5ddnmoI5iqBJi8ND7MWX8nYmpMqpd0xpKABkhRjEWety2VbqFzCx4I53MfR/e6+mhJTmd0nFK8ODxjeTou14fQgu0CkU05Tgg/yBENVZ8cQqTKPXQHh/06uVBFU0Y8YflvXQCmBzK86T4GYLDOrVeqB0JyUCMod1F20mJA4op23eH89yh7Ngpv+TpI8fA917TpHmOa02FjiU1ej7tK96Iv4hRhx8F5kXRntitErv9+Rqaghheq6Yn1DjmNnsbxh5s52apnet92r/SunYd4CTDx+QvvRAnEhGRfVVvEkYtSFPT5PCa4mhHzwb5t3aNe3axUxltQfnyLE34kDl2GpRLzZPvfZyE07sezceFLy5Xu1LgFEc4UHJdiGf2CBnkHvymfbD7zkxKdeGFxItPw1QAvSLTtPvhqIojazJqROSNL4/EhuEi13pDTjuQVFNcxcEWTX5N+Mjdp3Zfj8vd4MrQDoGpnGx/a1VcY3Nzr/3Q8hgxjhuwY8LGRVbjpO2pI1e2zoaa8PlOQL57OJNjLk3Dp5sjebdDHDjLJeVKMVUMwbV765jvqhK/qiwcXi3XvcG9RpefK9YxvRCg7hLG3d
 jWK6lI0w
 kLJCbmMsen4tRf58RtgCfR43H8TD2LgX9vvD1KzXB9gSKqsj4XR6HguA0HDGtFc56CDMBC5LYrXa3itwvAkLeRkP13HCVNBiAutyTx2Ftf61K5wb7lJ6764jvzs00EIXDBOTii3BM59V0RpmJPNJ1SvVvITkU+47Q+q1BsnceDMrnjea1xCQy6Oj/FM2ax1gRZGhfx8xr9AXoci3WiqsQq2p1Tt61HGLPNrIDDfgHupKds0Z4lqAwgfGiNUqoG1yI4DsQkx628EcIjbmADo1qqlmSNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this second and final batch of non-MM updates for
the 7.0-rcX cycle, thanks.



The following changes since commit 0dddf20b4fd4afd59767acc144ad4da60259f21f:

  watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency (2026-02-08 00:13:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56

for you to fetch changes up to 90627a1e08e602b8b7bea970d7d5007626be7527:

  lib/group_cpus: handle const qualifier from clusters allocation type (2026-02-12 15:45:58 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-stable

Total patches:       7
Reviews/patch:       0.57
Reviewed rate:       42%

- The 2 patch series "two fixes in kho_populate()" from Ran Xiaokai
  fixes a couple of not-major issues in the kexec handover code.

----------------------------------------------------------------
Aristeu Rozanski (1):
      selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Arnd Bergmann (1):
      delayacct: fix build regression on accounting tool

Kees Cook (1):
      lib/group_cpus: handle const qualifier from clusters allocation type

Ran Xiaokai (2):
      kho: fix missing early_memunmap() call in kho_populate()
      kho: remove unnecessary WARN_ON(err) in kho_populate()

Seongjun Hong (1):
      scripts/gdb: implement x86_page_ops in mm.py

zhouwenhao (1):
      objpool: fix the overestimation of object pooling metadata size

 kernel/liveupdate/kexec_handover.c         |  28 ++---
 lib/group_cpus.c                           |   2 +-
 lib/objpool.c                              |   2 +-
 scripts/gdb/linux/constants.py.in          |   2 +-
 scripts/gdb/linux/mm.py                    | 173 ++++++++++++++++++++++++++++-
 tools/accounting/getdelays.c               |  12 +-
 tools/testing/selftests/memfd/memfd_test.c | 113 +++++++++++++++++--
 7 files changed, 301 insertions(+), 31 deletions(-)


