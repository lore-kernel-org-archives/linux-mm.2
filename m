Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45299C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2826B00A8; Wed,  1 Jul 2026 09:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E737A6B00A9; Wed,  1 Jul 2026 09:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1906B00AB; Wed,  1 Jul 2026 09:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B82036B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:57:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36AE3C1D76
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:27 +0000 (UTC)
X-FDA: 84940360134.06.E7940BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72A5740002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TlVDab3t;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914245;
	b=jOzyfgQAeBt45+MCXf33rcYMhwawGNZxdxDmJLgY/AOqCkxDX6212n9vTJGi8K1vraWQQd
	8ODATKYfzbEshUftTwNRYbfp5lngshRcDnDaXzCGbaSxPTXXVcxv6MvW4a52kIDUHY+nvf
	djJ9dAG95971oQ49V/Ys8HtxMRkzUXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zag35WAocY+5o+OvST/25DSXMEyjKxN2j2GDhfTpF5s=;
	b=FNtBp3BW5yxr2mVjmIDM7+BixWgVN2N8FD9Jmash7NQx71wNlvIlj2ka2xWimXXYjKHfpM
	rcZPcvmf2baEWniTuwL8SRWUIANMyhT6OwFvWx0Dt/ShR8Er9ua3q52Ois46QzYf9lPHTd
	Eqaqb7XgqeJHKT/bN82LaN9i9mq85Lo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TlVDab3t;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7182941252;
	Wed,  1 Jul 2026 13:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF371F00A3D;
	Wed,  1 Jul 2026 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914244;
	bh=zag35WAocY+5o+OvST/25DSXMEyjKxN2j2GDhfTpF5s=;
	h=From:Subject:Date:To:Cc;
	b=TlVDab3taKef0cAHAYzvZWbe8q1YtiZZL2iPNyoLbK/g1DgwhDk/Gg9XGmwG9yKBF
	 PnWzy//tKPnrrbIuL4frm/k3LfXeFGF2iCiZ2yEZWg2OFMYpIXXwpiqEGDdeYqHh12
	 FxuPhn3YvDMqXdAYksh7EzEe29c/SLkcjH6s6U2CkKGL02I4pNZDh36BF+vzSNse+L
	 4L4BLyrOyvTeZB/fzHFqta9oFP7ZoXHXgsn7JsvszUlmHn9T2thGwzYpuKnFPY6iZ4
	 /hQnQLexd22jTT31Sc43CUIAg/Usjb6WzwhcixRdNrLp6OWItHPtroKWH161IHgwTI
	 elkTYlpzGTUfw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] drivers/net/ethernet: replace __get_free_pages() with
 kmalloc()
Date: Wed, 01 Jul 2026 16:57:17 +0300
Message-Id: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL0cRWoC/yXMwQ6CMBAE0F8he3aTgkLQXzEeumW09VDNLhATw
 r/b6vFNZmYjgyYYXZqNFGuy9MoF7aGhEH1+gNNUTJ3rBjccHcuJJ00r1BhzhGbMLD3c2Mt59NJ
 SWb4V9/T5vV5vf9siT4S5XtWGeAOL+hxijSpp37/MWFb8jgAAAA==
X-Change-ID: 20260630-b4-drivers-ethernet-b5e085b98ab1
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Manish Chopra <manishc@marvell.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, Mike Rapoport <rppt@kernel.org>, 
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-net-drivers@amd.com, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: cgeqwghki39mybftybaeeoffe65ud7u4
X-Rspamd-Queue-Id: 72A5740002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782914245-274973
X-HE-Meta: U2FsdGVkX1/4OrK8/OidWm+WWfEyBpRFjn8qbX4yQzbZ98QChjawfLFXKM5Hrng2zkmlM/x+djr4/65m1BWmbyRn/J+tx1qidJhrnlkoRiFii+pfP0sQnPk9vkLMfACGQ6FhzL7v7DMiabXPlXDiz1e7MHv/xKh0tsSY7b3mJE/mNiOYCRejple3cGjtUNAu7lb8AfeptC5uCgsQWUKFS6JxTfJGnbVHAXfAgQaAzDuC0r+BI4kfNTr6JfMB2RJDvNq8VWP6aiPqNj5+Wr17AusgyNhA/GWms6abHTB//8oHNqPrxMagqtAlu+NmERLyyr2LSRhYJXjWcwNzknKsg/XXVF0fIbBCoy8k+jgGcAu8U1hD7CmnrFn7vFIT7s7ICgR3iPlmZnlsc9f+0FFtJIC9Oazd4ry3CRhK+3skVHYyD9BrnxsQ5nHrWcy6BXRMyspC6UDi1oi4+3wXLr7bU1t6WCcx1oVbvNbLAPFtv03S8BdxtFb3vi/fbYa0P00hUjjCzPOqwYcPbKCHruOBETkuVCRTkvQdfc0EpiFaILnHpAXOXFN/mC1LC/eYIGTRTNFS8Ys/43ERlF3UDxFFrNedkDnpinnbKKO0kZqh41T2o7h3QmJNEvQe0wpFn36gSF0vtPjk+QTdx+x8ff1C4Whhoh55UnJ1Hg13ugV+Dnqewqd5QjZIcEvyg49C9E70YQztnCmlCrEoL3+TvZTRMhsnJgISGNz5RZdeANER2EM/KMTGtHkD1uxjQg/6QcwKyFFx14Rn3VgFuOqr8QIU4g5ddDoaveEvhQEnzvCVCGLFvKBlya6FHiIOhVkcrq7jIIIUvxJjbsggR4FL1x8Jkrcwjlg4SLkz/aJTymK8tUCt5VluM8gcikSLAA2bJ00aHiOBulO3qGbF7yTdiXStvnM1VwUjvpR4u0TcPDf0q2Uo9QVYclvv7Nm106l55s5fjbe/dO/Ph54C8YpJuVZ
 oicddrOh
 OKfwPu0sCbkEBOfC6KQ3kgvHjFUAIBaPgToDONcMCaKOQk7yHk3hN6mTc9IvVP+osl1kf2oD6SBETzhKavpxP8ELuu25K7Vq30m2y7Serv+xikaF2UDDo/NIJoO8BGxxgA0M47IHqOpMJs34qp2dQWnnOryE/G8Ejs0lPg6wHPTMltCiucaTw/zxGsamd3Kni74w34ZSBGPUv30IXOF5CHNVYzsN76Fjvr9cmcIRSJpnKZuVfBDDQU42HBz6uPH97BKQQ9YcfcBVEtkcgggPLvUHJac6u41McKZXndUxSTFPNOpSC3o/roTlZaGiEKk5x6Zl96uM/nvlALcRhPsFBBvZ040RZ63jbbQ8YDRlaLK3j0itd83K0t0y9WKjYuU1Em5EoQPE3MOlRjZ5uXMspbvvUG0TMoY3yrXfyzAXxVSLEvA1Xkw7/8k6OEcUj8Jk3twPT5rChU/LKMUo1hHDeytZc15vK3Rqf2NPNnyHY/fHc3RMDML1xJMm9lfU/SU9ZgZ765ScagxCXVe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-ethernet

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
v2 changes:
- split out ethernet drivers from a larger set 

v1: https://patch.msgid.link/20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org

---
Mike Rapoport (Microsoft) (4):
      bnx2x: use kzalloc() to allocate mac filtering list
      ice: use kzalloc() to allocate staging buffer for reading from GNSS
      sfc/siena: use kmalloc() to allocate logging buffer
      sfc: use kmalloc() to allocate logging buffer

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c | 6 +++---
 drivers/net/ethernet/intel/ice/ice_gnss.c      | 5 +++--
 drivers/net/ethernet/sfc/mcdi.c                | 7 ++++---
 drivers/net/ethernet/sfc/siena/mcdi.c          | 7 ++++---
 4 files changed, 14 insertions(+), 11 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260630-b4-drivers-ethernet-b5e085b98ab1

Best regards,
--  
Sincerely yours,
Mike.


