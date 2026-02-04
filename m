Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B43EA794D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 23:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFCD6B0088; Wed,  4 Feb 2026 18:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD7B6B0089; Wed,  4 Feb 2026 18:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC676B008A; Wed,  4 Feb 2026 18:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57D96B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:58:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EF5E8B07B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:58:42 +0000 (UTC)
X-FDA: 84408441684.27.BFAFDF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA76514000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:58:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPdNxj6o;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770249520; a=rsa-sha256;
	cv=none;
	b=eN2wT6t/BVmFezdGrEdfKxDmYHTGLoEBuhiEueFIv239ziqXlaoWhVVxlhPvgq6Kcmhlu/
	LGqZHzSEYB0lcskbwV0jS3r+l4sL3JGNTCltTThAKNY6qxM1DKTH6Gdbwy3U1lG0ji9ZwA
	EJiM9A+5RRn73dXpXoGwuSogpJi3I/k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPdNxj6o;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770249520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MiRexgqTDDIOxaPs1Ef1g1/xNGI9KdtcZR16ICtelJA=;
	b=N79LrdSza2xyXtlkjdJt7fNXGJPnPzw4blNQk4IRBDI6fEhL6XZ8mOvr2I/XQiIGE0NG76
	suc1KExHC79kozZxDFjJj4fqG6bUbpQM0KtFmR5SYpH9sQzc9nEwswkCYO0xXo89h6AuBs
	2L0fEc0d1csfQTLDkbCTGDqlWux5vCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8FC660054;
	Wed,  4 Feb 2026 23:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BB9C4CEF7;
	Wed,  4 Feb 2026 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770249519;
	bh=0+q5yBjEBxCWAnEr3neKDH0a8j6BW2Co3pHAtWUQvLA=;
	h=Date:From:To:Cc:Subject:From;
	b=IPdNxj6oAVxasjCuy8JPMWwNu4FtiFC26S9z2bxvBUym0W9iDE4aZFWngtHQhA5/V
	 22r5ux8MtPJStsKvm/LSVkMNMNOJlWHc8XIuFr5kZ+RM6HwVW3It4EWNAFg8q7Avu1
	 cCX87zYpogJqAsju+OkFc4pBl138N0ZBYSsyUihc=
Date: Wed, 4 Feb 2026 15:58:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.19-rc8
Message-Id: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA76514000B
X-Stat-Signature: 1pft9coma9rnjegdjxrdp7r6488oketr
X-HE-Tag: 1770249520-576071
X-HE-Meta: U2FsdGVkX19R880K+KwCzxqdgL8jfNTtaY9VdukL286YJHYlMFLwN3XSpLRnudQAAwAdGHcGygtW8o+xutFgGN7SPOK7wdrOZjvgNV6sGH2BE0i0UbQoXFHnJS0Xh4EipDQOVG3oAPeYTlOXq8/tcL9L1xn6PV1OqgCjjTOSNM4pFqfcghnpolT4/yztwfDjKvOOUuWF1ef45fG/bvB36RKmmQuCFavQuTZG/gSziQd4F+aj313zNgLJJQtMLl/jJFQRPo1RlHdOzoZ4nZKYwpqSSE5ULlN2E3xlHj4UdbUcS4fTMvKRo9yIkoTM0Rz6xADb2/FYNnmyaJtZFamhkdj46DxOtOkOuUQaANw254FiW7oWeH6ftq8sbLuheRM9TIQr7wcNiusY5xUiADCbJ2udGledXEqSXBqptI1MtYI7n5F+cqJf61Zj762MJTmX4iy3/0qSZiYSPSyEHDZzij/LR12TLCa68xeg+7Ed1fNBa2Jqz9PZ0o66C+RCv9ugH2rrXzdw8lT4/kHoBLE5ih0K1NkNIZgWEotWCSqPOp4fDCFzTwMFWM/NGVrGIMN/TKpCrpXdvNpLW6cMvmfTKLMY51vJS2vYbQRvX3mEoP1xEfM8UVyu2Xef1KXnitp59JeY1A6ZGs9cU3PHNDsxfRqUUDzsjuXkK0/nlovodUct0w6jlHurnLYRXlQrgP0jolf9APNc6ayRw25+LvofHwfX2zV8QEnf9cFz7xsaB2sgdTnxVmOdn43QLvoxgM8id7Jkly9baa81lmuj76Gzb6D2RZaRITSSinKup3lnVdLTbyGnD6z01l1pmzS7/leU5c46pJo9ba03C98X5go+wrvA6WSGkJcqNhXOaMK6XQhMOpbhAnn0tCuWQp34Ykem6r0/8TNjsRIQq43h+jGnlI2s39iu2zRPx5yAq7Mwuf24yoPqOIlSBxzz29VV1dxzZodFDKTRkuVegw4w3Uh
 i0TfzhZa
 bxadRAxVo6t9ViGT9D+eSSl4eyRwSNtk6/x3q1lfhMT2cfk7sWqIK5s5lzLDfjtmbODlDQPRrNDYnBG/GV/xVMOnIzQQPU/x9Ik6ZtQS0B//waOsEoyAkRg0Zcuy95SgOSRWKr8ufjqJto5iUPyFbT6zMWABu8p6ysaBH6C5gZ8/sfMSvsXx0LbJhCsxzCZDSYyrjtlAJfmIVxyJMbArZeaqWDndl+Wve1+dL5f4YUGJ4bnC1m/ivtRGz5hiNavc2TFuUlLedCEHz1qs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this small batch of hotfixes, thanks.



The following changes since commit bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55

for you to fetch changes up to 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab:

  Documentation: document liveupdate cmdline parameter (2026-02-02 18:43:56 -0800)

----------------------------------------------------------------
5 hotfixes.  2 are cc:stable, 2 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexander Mikhalitsyn (1):
      mailmap: update Alexander Mikhalitsyn's emails

Andrew Cooper (1):
      x86/kfence: fix booting on 32bit non-PAE systems

Kairui Song (1):
      mm, shmem: prevent infinite loop on truncate race

Li Chen (1):
      Documentation: document liveupdate cmdline parameter

Pratyush Yadav (Google) (1):
      liveupdate: luo_file: do not clear serialized_data on unfreeze

 .mailmap                                        |  1 +
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 arch/x86/include/asm/kfence.h                   |  7 ++++---
 kernel/liveupdate/luo_file.c                    |  2 --
 mm/shmem.c                                      | 23 ++++++++++++++---------
 5 files changed, 24 insertions(+), 14 deletions(-)


