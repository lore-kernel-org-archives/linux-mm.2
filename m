Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63692C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFB98E00E9; Tue, 12 Aug 2025 03:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA01B8E00E4; Tue, 12 Aug 2025 03:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6038E00E9; Tue, 12 Aug 2025 03:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 977808E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:11:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13F3E135227
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:02 +0000 (UTC)
X-FDA: 83767233564.12.57D0D4C
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id 749984000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FdzBjRYN;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754982660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2NvFUK7B2AZ/hfP76WElYgnUsBUffLG48vagGnvL+Nw=;
	b=iurB2kZ50iD0TthAcInt980ktmJBqb+yM5iQ1/mED4IMRIxCa7Uiyxj7MOFEShI946gqRs
	03f8EIq2K9OeA/8JkFCC2V4KEk+O9lDCaQLfguGktloWl1uGI74IzaSJh0Av4mpTfPzkJb
	BJovP2IbprES39V6Pn2ozKluMgZ+3/Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FdzBjRYN;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754982660; a=rsa-sha256;
	cv=none;
	b=ZbAX5IBsWaLlFPZBAsLdNWUqBVvlyLL6G6gLrRxE9HvmarIHRzdsFJyCr0UDb0GzenwkJq
	7FErsaB2PfdSEXaJ1DXZSa6rrfjvARyiCigeV/g8Viz+j0xFt31VkzosPLGxTX2wzEpfxH
	ZaLD1RORfdJHMqut4qYIfSABR1trgBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 615EB5C6687;
	Tue, 12 Aug 2025 07:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CD9C4CEF0;
	Tue, 12 Aug 2025 07:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754982659;
	bh=0grhLNYnray7/yhDmufcTV3HyMYYhAB+577+1do6RLA=;
	h=From:Subject:Date:To:Cc:From;
	b=FdzBjRYNZHrBf2XNahu8zJ2Sl1Z0e+ruDGUomlUxopNXjY5CyE3G6nWPgHlRfAd3K
	 3PNyHPzr7F2T2Mdd0F9X+lY6QaM8r/jYfOBbcVLBQrpBTh7CHfS+m8YW4leU/BHGZK
	 RV5IftDTifx2Wi6GfvXxUMaEr9cOGU3vSrOiD7ABJh0SxHc202R9veEllMZkwI7mrY
	 L0BlJggG5pbcaOVKSgdpfEyzxw9RwNpDGszODLjmztmb0ScJe50YUu9OJ2I/xJj2Jk
	 p+o4HimK/Uvu0a+keotly6diYuizTso/JA6O2ZY0aLRuP2obZ2f6/vNtNvpxgZOBuB
	 M8Rl0Rh49u2FQ==
From: Chris Li <chrisl@kernel.org>
Subject: [PATCH v3 0/2] mm/swapfile.c and swap.h cleanup
Date: Tue, 12 Aug 2025 00:10:57 -0700
Message-Id: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAHpmmgC/3WMQQ6CMBBFr0Jm7ZgytFpceQ/josAAjaSQ1lQN4
 e4WVhrj8v3892YI7C0HOGUzeI422NElKHYZ1L1xHaNtEgMJUkKLA4aHmTDUxuFgwx2p0iUXkmQ
 lDCRp8tza5xa8XBP36TT619aP+br+TcUcczSqZWrKQgpD5xt7x8N+9B2srUifvv7xKfmNEiyPS
 nPN/OUvy/IGNPM2K+0AAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: 3ap4ukrzjmmojydmqr5kx89h16rozej7
X-Rspam-User: 
X-Rspamd-Queue-Id: 749984000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1754982660-538402
X-HE-Meta: U2FsdGVkX1/NLzNXHeCj3MV7VQfHyH/Cz7sbE0rvUwz2DG409QgfHGZWBHRc/W1pRXSl3toGD77r9TAM/c/909XVAjtUDO4gBzsVJnzWpLojekpNm9s3VSpkYtECEE0+tWvTf4elijKu1YoDGvBZk5d+HxU0545I5lIDQA2f1vndCM/k0j239EUuSx0wBIdvUkf1gPESXe4Nrr65/cEXLdome0kfBNNCZQVfWr5Wrq0jCQ4+fZyY1370jf7gLdHUqYLe0mTwfxaWKMt0mUWyaa3XRNqJ9KLWCj2zw5oBYLZU5BXEpGfS8UFQSubMehnYZr6WyWzTF6WLJl4tT2c1OxL95ui5s8JvMOiwKzx3MKhtsv29uQilmYnXBTYFgrgPsdHJorAZusmnXD6WSb9rytHMNFJFuN4Di01t/RMAdDPwle69yD8GD2loB9fAaXMnV1rQBo63O5xlf7g0xQ351yeLjvdyrdmbl01z4+FrnKhMmh5PuaaEBt4bjnc1vn/lMEqrvb70TEnaIpDPMG1Sl+wlaEMGiRKheaQmwL4I6wFmGJ4Lv/aiRLd7755Z96XmZwDYZqikOiOqUdugALwdo2nTGMmoi/E6OXHK4zMr0pvbV27ZRM3Qezlwe28/I+VdnOFvxW+ufqGoFk8/3qqnWT0+ZzoFiJncTo5VBAuYtpxGXroeYoHaV4wT+SZV+cKwbosR4iOsGidN/XBPSJKM8Gb8FrSZS0GCBfyGPL4JZIubjmQsNhdrekl4ZKMiMGkNCy74pNehHZZxrL0ExxouOJHFD04DsfKKudc9+bJ/1z4itWkrFCCXf7vm/wzNOq3WtWZTI8tHRwJ1QGdBoifMrQy6gkR2O0vcITsJTbe/8bv8pSdcyVTH3WDG47xRTrvbn3LoWzS4gL1lbYsUCko/FGG5zbvTVMLeDszYF5iqzCDFpJ6GugsVUyVal++wTOpGFLMAm/pPRlQ74C0JN/w
 sPK1+72V
 OJgIFh4ky2FCqHnTGqCVwlwM/Frb6OSTYsLXhFqIVXHqLFEljppO8//oyDijb4B9KHYm1gD9GNTFtl2YhdXgC3xCyCMoiPOeVFNhkHm76XmTbSgoVDsodMVB+iScuatgullSxQgIbm798MXCfqFSjJEMlD0ijd4I5jSr198fJjVbZX0ioiOGcXsbR5rc6MrgZCASq20CqHJo3x+O6LJBGhsyOCTordstJRC0XBtzua5JbD4wei8tvcJExtXwPMZM7OXISmCWZduO9WCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series, which builds on Kairui's swap improve cluster scan series.
https://lore.kernel.org/linux-mm/20250806161748.76651-1-ryncsn@gmail.com/

It introduces a new function, alloc_swap_scan_list(), for swapfile.c.

It also cleans up swap.h by removing comments that reference fields that
have been deleted.

There are no functional changes in this two-patch series.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
Changes in v3:
- Fix a few scan_all argument to match having while loop or not.
- Update comment message.
- Add a ptach to clean up the comments in swap.h
- Link to v2: https://lore.kernel.org/r/20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org

Changes in v2:
- Adjust change base on Andrew's feedback on int type and break out of
  loop.
- Link to v1: https://lore.kernel.org/r/20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org

---
Chris Li (2):
      mm/swapfile.c: introduce function alloc_swap_scan_list()
      mm: swap.h: Remove deleted field from comments

 include/linux/swap.h |  7 ++---
 mm/swapfile.c        | 86 ++++++++++++++++++++++++++++------------------------
 2 files changed, 49 insertions(+), 44 deletions(-)
---
base-commit: f89484324d5876ee10765fa61da0332899fa1a6a
change-id: 20250806-swap-scan-list-2b89e3424b0a

Best regards,
-- 
Chris Li <chrisl@kernel.org>


