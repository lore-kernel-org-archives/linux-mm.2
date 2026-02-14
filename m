Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B486EF99E1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 07:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D396E6B0005; Sat, 14 Feb 2026 02:25:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA636B0088; Sat, 14 Feb 2026 02:25:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCB26B008A; Sat, 14 Feb 2026 02:25:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B26FA6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 02:25:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C056BB2AC
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:25:48 +0000 (UTC)
X-FDA: 84442227576.12.BE2FEC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1673540009
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:25:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWmCGOCd;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771053947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/5PK4rkavh35ky1bcJgSCkfgDmd43mRfughXfesREJ0=;
	b=Rbu0sx8DdtdlgUq+0CtMA8e2+xx/4kHHan/Ycwn0vUvuwe584au3njbLNlC7cMfJqO9aYw
	xxMKQVU8V544EbBRwcBJdqBCmsc2ZSfcoTqvoZFnRQnanQnnNW2+QOTe03QncQ75g6Gfre
	2GnYV5EJwDIDmyesjY5Wl40bS43QgDY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWmCGOCd;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771053947; a=rsa-sha256;
	cv=none;
	b=Ff+HjUzMQM9QqcbciEO7T6i4Mp6nEGv36IpHgZ9QmQ6/qn7DKbi40ufc/J+enJZ5Q+xJAl
	yw3TSUSiBU0Mel7+jtdX9J/R0+fBmiyrRAF5Wd2AlUhVi/Kw2cQe0UmAiSAvu5jW8OQyQg
	8i1sABF1O1ERbmNXFZNQlWXF6iAU2aE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA76B40B34;
	Sat, 14 Feb 2026 07:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F022C19421;
	Sat, 14 Feb 2026 07:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771053945;
	bh=tuqsMbh1p8jlfKMkzXBIIp942vE25ye6hfGa+4w7SX4=;
	h=Date:From:To:Cc:Subject:From;
	b=lWmCGOCdrxZSKj9rtrInLm/7C6miTki3S9Hi61RUEOr5oTwlLnUh15GRlIcvi6gqS
	 5rXu4XawTp/4PHetdyruZeXyfH2zzrvfINQyxVeub13yAveQwkZx0xOkFy7b0mXHBQ
	 NfpS3BD3OWAabUplIYp2qFovficCj5dIj0xVzGgislxfqgleNQZ1Su0r0pbmmENslK
	 tWFIhS0Ri7Bawb2dLaKHc/yx96U6UllkmVyJ7SXmr9c1OxHtATN8yfj2V21XeDGhWD
	 3ufqHpxZMLXxKF+qy5JA4wrwtVUHZ0g+uf0vjrFx41QRXb0dji9nZy91g0utNQI0Yu
	 ZdILbEEqrNDMw==
Date: Sat, 14 Feb 2026 09:25:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kevin Lourenco <klourencodev@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock updates for v7.0-rc1
Message-ID: <aZAjczlDqWkg2fpt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: d4ag46bhxfz4b6nkhzeuwinw3d89emgn
X-Rspam-User: 
X-Rspamd-Queue-Id: 1673540009
X-HE-Tag: 1771053946-77911
X-HE-Meta: U2FsdGVkX1/lHuqKeuq+B1eO0z8zZ+qEJHxalURP6NcKHWORY0l9L2I8XG9SURFcrYJEWy7d7CoU6nESr+0hhYEZblUIWUvHXuku87WGx9ytTfqMTCKSqFdCbZbKmPBcHR8KE2Xhi2anmVzqvozIfzcdzh5MVVJC9I4nDg1ul9CuWn4jXHfYeXuiXFD2SHc5St3sfWaHxJS/qiSsQFoMNvJUM0xnIMzIF067w9cDZgU6UoQr4Yohh0rCsi089XTBQMk1aX7IQHnbuiFYjF5o+el8dtc8CHj+bwVVKofaAidFTnbi7AsjIoq3iYR3U2nPeQuDyZydLD7E5g/jpmureBnvH09BTzsPQf04oDLfnt0/QD5y3LdM4pmJzDVS4JZwDSHA/sQmA71E9ZO0mH0foqSbtQwPCkwhgoRmcKIhf0uWPx9v98O9LbNCM6/j5DlBR781MYS9v9+GaDFhAiybc2rxm7F+Eu5vtL6ilpo+l9qi2WHZVcvRPUmcWokdHhsA65U2EzQhiMufp9agxsRS2An7sRaR3F0XkXixXO35zIJjnZbyInJbVzF4FbupwEzrCcNpD52nSqFLlmwx3b7BWDZ1MhrDjh64qCSZldpRTeF4D3cQs79DEhmXtg4uC5p7kTI15kmEdh1LY+ki1ho3CVgtmA6co6P1CIHpHUsvCUWpPwXtBAHZgfS7796n6nkS8giogzysp/k/0/IrIEOvC/eRGJNn4v+BzYnsaRX2QrZjrb2DbKFTMowTQpJkobg4b4WTUNRxioz2R+I8Vhjv0oYPGsOp4IS4Ejc5Xn6Ce8cKTAHtfSBZfEmrCcMNJ86uicHSrUkVqKBxigWeF9y+Vqgw3RsrsooYDZIIEBSMvLoYxUc4Jpaf/nVs7uF8B1NFb74yhWvW357Z2NcLwLRDcsEP8gVo8Iayytx6GcqERaaPWpZEYenLsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.0-rc1

for you to fetch changes up to f56ccc32468ee7885d3a9175e7d2cb608d301521:

  mm/memtest: add underflow detection for size calculation (2026-01-09 11:53:51 +0200)

----------------------------------------------------------------
memblock: updates for 7.0-rc1

* update tools/include/linux/mm.h to fix memblock tests compilation
* drop redundant struct page* parameter from memblock_free_pages() and get
  struct page from the pfn
* add underflow detection for size calculation in memtest and warn about
  underflow when VM_DEBUG is enabled

----------------------------------------------------------------
Kevin Lourenco (1):
      mm/memtest: add underflow detection for size calculation

Mike Rapoport (Microsoft) (1):
      memblock test: include <linux/sizes.h> from tools mm.h stub

Shengming Hu (1):
      memblock: drop redundant 'struct page *' argument from memblock_free_pages()

 mm/internal.h                     | 3 +--
 mm/memblock.c                     | 4 ++--
 mm/memtest.c                      | 2 ++
 mm/mm_init.c                      | 5 +++--
 tools/include/linux/mm.h          | 1 +
 tools/testing/memblock/internal.h | 3 +--
 6 files changed, 10 insertions(+), 8 deletions(-)


-- 
Sincerely yours,
Mike.

