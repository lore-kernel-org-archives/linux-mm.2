Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94643C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A081B6B008A; Wed, 26 Aug 2026 12:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9936B008C; Wed, 26 Aug 2026 12:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0876B0092; Wed, 26 Aug 2026 12:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655686B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:06:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4635140189
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:49 +0000 (UTC)
X-FDA: 85143898938.12.82C2E1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15E5710000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:06:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6Ip0lEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787760408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qzCRwQtZ9/wP7Z02N7Vz+vk0AFHWhteXZEZwfRjGIOA=;
	b=zdFZ4VwmNg+91lgZx+T1a1FtOLRarJWpMpmY8As2f6oIcUUtNcaL9E1Z1QIDCYBKp+UDGr
	gnoE/eDPxSuVzPy1cmdv3oJYBcPWORKT24s4nQ67wBjeRDevq93gyn5iVLlRVNnIiSICV/
	jSqCT7I0MsAdhxqMf/+dkEahENLHpRQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6Ip0lEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787760408;
	b=IghjGeJxIgiaPnkasp5shnQpeqs7SUYxVpCuyaXiGomT9koDpTo8hMpm7ioHnMQzsmPKI7
	OEVJl2tIFed8RXEQqTtoFUusCNYiogVgSyfOv5uGcsXQ8FW90sLPD07NMTFnOGIGg9Q8f1
	KowcXubF0Qti76gikBvADdblELdvvFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF24D6001D;
	Wed, 26 Aug 2026 16:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8E01F000E9;
	Wed, 26 Aug 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787760406;
	bh=qzCRwQtZ9/wP7Z02N7Vz+vk0AFHWhteXZEZwfRjGIOA=;
	h=From:Subject:Date:To:Cc;
	b=D6Ip0lEqBo7TaC0vEm+4INQXvt0ORtVzNxM0nL9cPiyvLdL7frUynU9l8nVrh5Hbi
	 0DZOfCM9+5b/Vcu2UMnl6mVjQzxwSIy1lFeyN7ApPIueIAThUeKE2Q0S+xVYxRAjGE
	 oJlaVUf6Xvy9L97Re2YL+83yOceM8rQLqjAwTsD6aK2RunFMDywrj1WllEmuoF2gkA
	 tD5KYw8TK6MEIiuyAAx/X3AcTlG3KIUWTAC1VwROaBRfNJnwriTuOQzWUwVEOD8gGg
	 um0nJVih40tK8jMVuZBOsdUj1qcuaS+l6xS72VeBbqm5Ae3ZkcqA4RZcJAfxeSrqXQ
	 tcRvDlIEmmeGQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] powerpc: remove spufs coredump support
Date: Wed, 26 Aug 2026 18:06:39 +0200
Message-Id: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zXMQQ7CIBCF4as0s3ZIIW0lXsW4ADq1aCyEETVpe
 nehxuU/efOtwJQ8MZyaFRK9PPuwlJCHBtxsliuhH0uDatXQajXgO6Q7cswTowuJxvyI2JHsHEn
 d9/oI5TMmmvxnV8+XX3O2N3LPStWFNUxok1ncXE8VFTsq/qioE9i2Ly3jLmaiAAAA
X-Change-ID: 20260826-work-spufs-coredump-4e14ce185587
To: linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Kees Cook <kees@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1820; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DLaQXXhE3GPjz/WkKul8E4zcEVrz25q2RRBTZmkJ/Y8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT18wvLGFte3TRnstVy/Q9fUwR+BztJKG36qChdzPRor
 zMfA8/TjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIksvcXwT/lGGFtVRkNJQt3E
 M5lHJdmWTOFgqDh38P1l67uyboI7DBgZzv7X/zd34swfVvwGk+PO7Pb+/mwHv+2R3R0Nzld2zLi
 3iQkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15E5710000C
X-Stat-Signature: 79owcs5fgeru3rinaxt9ti3sp44uzgfh
X-Rspam-User: 
X-HE-Tag: 1787760407-431377
X-HE-Meta: U2FsdGVkX1/4cKFHID2Tni4X5TfJIZ6fZ+UPLZR3LqSV5SKq7J53p+Qn3RoZlkI8fdCWFrWqyv2XiILVBK61bzq7+BQXKzIXFB/VtpwNkJf7C9lmvf8mwnV9GU/KodtDJ5INYcqJjurrZgt0Bv4jmyr0e/XNTXrRGeiFzI7cNaJMaUrj9q3a8KFcEj89JkRm6pBgdkB/hVuRFAmuMCiJAxsT8jyLbVwqrXM+LBddIVU2SaaKmQcjd38gHCUOZb+xILnxC1rOQ30xnhf31oAhdJffp7rXKCZ/ZMd9aXEFheqvroFzYLMr+If8KFQWPMy7rrPzr5WC7rxBy8SJCJs1TbTpzwz8ttFVAptM+ZR5AMwTRgfhhjiz3nk6APu8VYzQIIDwsSCj05+XvJDf2lwNXwYmD3VekMs0tEH5J/XAXjn2jAt0lx7ECaEyAa94B7fXe67KceEIi4fhdInZiZiWoxeom5rmq3aYskTpUjHuULaX5lIrBKb9/4BVuSS4uy/FtrzKVA+hCNhc+Vyw9wtVwnBAktv9UxDX0yNaRGV7XtVLMje6BPZoxOS+kYVPlbtqUebvfO4nVmycifzk/cGOdUj94F1waAXhnZX1HaE5HVfry+flAPjanUEG9eoUaAAcfN2nRRbBBAhnIVFUxhDrB99+fljjZQUCHENmau1gWnIRv1kaxzrLkuikxfMg1B0+64yuYDuN9+rqis+LzvJRGlXXVAJefyLdfY6p77tnOopDyw1Qx+MFwz8UpG+ylQclb3a7pixEgX1ym29qxC1gPsmvI9Nn3e7JlpOyo9xzj5PzcwSYiDi2RJ6l/PmQO+YkSPGf8phv/p+G1w05C429Y78frVkzBwwkGTCeeUTP9ueAlkdkQsp9X6vNts+ES2E9MbGT8KXz37uFpazRvw27o8GkdcUlASsU/NKqInpzs0ZKrdExl3vwMKE11SOGrjaGScCD0f+aQcEX2mHw690
 c+rXVEl6
 CAS7tet5RNShVJiWbW1KrVc9DAgiOfbS/CpixbgnWxKN8fEdEMAhDYcuEvSTuXvMB+1ofutZqrdrODkFbSFcmN9PL7poFIz59bdHaJ6K35wxRH26dpzCImyg0Oc94yV2lbRyWRYLH0ja8VtboVi83skDgsXqp8gMBqGL6TzRKpa7grGNMp6ineq3xQkDvt0iMhPbiDwfJYim55fRtaImI4KG0hkvzE7IcgetVmwMQhnczfDtC11o+EdEgWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A task that dumps open spufs context adds a bunch of extra elf notes
describing the SPU state. It is the only reason do_coredump() unshares
the file descriptor table. We could make this conditional on spufs but
eh.

Nothing can consume those notes anymore. gdb dropped Cell Broadband
Engine debugging in 9.1 and binutils removed it in 2.34. That's about 6
years ago. So no program can actually read an SPU note out of a core
file and probably never did in recent history.

Note that the IBM Cell blades that shipped the Cell processor were
removed in commit 05bf59fbeef3 ("powerpc/cell: Remove support for IBM
Cell Blades"). The PlayStation 3 is the only platform left and nothing
there produces or reads these notes.

So remove it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      powerpc: remove coredump support
      coredump: stop unsharing the file descriptor table

 arch/powerpc/Kconfig                         |   1 -
 arch/powerpc/include/asm/elf.h               |   6 -
 arch/powerpc/include/asm/spu.h               |   3 -
 arch/powerpc/platforms/cell/Kconfig          |   1 -
 arch/powerpc/platforms/cell/spu_syscalls.c   |  20 ---
 arch/powerpc/platforms/cell/spufs/Makefile   |   1 -
 arch/powerpc/platforms/cell/spufs/coredump.c | 183 ---------------------------
 arch/powerpc/platforms/cell/spufs/file.c     | 114 -----------------
 arch/powerpc/platforms/cell/spufs/spufs.h    |  12 --
 arch/powerpc/platforms/cell/spufs/syscalls.c |   4 -
 fs/binfmt_elf.c                              |   4 +-
 fs/coredump.c                                |   5 -
 12 files changed, 2 insertions(+), 352 deletions(-)
---
base-commit: 66498c75b4f8017f62d720d9b59675bdf3abce91
change-id: 20260826-work-spufs-coredump-4e14ce185587


