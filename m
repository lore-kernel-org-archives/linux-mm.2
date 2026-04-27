Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D25CFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53256B0095; Mon, 27 Apr 2026 13:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03DB6B0096; Mon, 27 Apr 2026 13:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19A86B0098; Mon, 27 Apr 2026 13:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE7BA6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:17:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C4FFC06F2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:58 +0000 (UTC)
X-FDA: 84704993436.22.10714F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 672A840006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dWIdgH61;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310276; a=rsa-sha256;
	cv=none;
	b=sfU0nG7zT/BQuOTaI/bBgA9fiSe3xWItkQNQEmav8NnflDxUtBYJmodXtZieDaQL7pUwgs
	CQEDrOjYXqoNcM6qORiTyAJgPhmfghaBh5YWMhA2pxgBHFlI5lWBOLFS4FnF0yxD/8PRA8
	680z2Zt+fcSTUk82Q3WlBwsnVZrT130=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dWIdgH61;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMiFQ9YDeWWeAvKmml+uHoGAC+wRXXMneJLs8f7ea2c=;
	b=R0mESnCMZf6xz6DtkkR/BHQtqNF6vRWLjr2Xm/Ux1+qvCu5Xawj2mrcz8Z2ujjeWVHiT7X
	37IsHVqTzbdnMU7pfTXfrQpIjvY/0tXKrrVEyquPRXEzsm0SZfv4mudfSgL3kButQOkjZT
	q/428wzKdkh+riNtlpkzuo9LGFi3LBE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6C426024D;
	Mon, 27 Apr 2026 17:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B91DC2BCB9;
	Mon, 27 Apr 2026 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310275;
	bh=W5kkD2qOaf9p6y+JEmiY6YQ2keZoelr0Bif5djAA9uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWIdgH61f3FZjJK5/4M8qA2Z3PdTv2PxzuZWcauBhk9DdVxbBkauIdrH8T66hguCp
	 RKByLYUodinjcBlbYhttuH2LGK1CACi5Chox46drqrLCValqYMs6iS6hvWfa8xjP86
	 SRX8mzMn7HjzzZ5PMWVnIWvrJFLR/iyEIDn4Oi2BFSrDeboqSnIrX7WfhL6Ub+tY2g
	 I0hH+wNzy6c//f0TkDzcuax+fX8WXY8rTh4FJ51XM25PFd/tzjClOdpIOdXk4NjGqA
	 oBIlgUIOAdKFgg5RvdKRR4Lqk1Q+lbng1I1sXXDqtORIX/zFE6g7Yv8vrz97KbzGDV
	 XrdmpG3tF9W3Q==
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-x25@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [RFC PATCH v1 3/9] x86/umip: Be stricter in fixup_umip_exception()
Date: Mon, 27 Apr 2026 19:13:44 +0200
Message-ID: <9e8e43d4f81d8f8b6f68311f1c6f859d718d36e4.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1000; i=chleroy@kernel.org; h=from:subject:message-id; bh=W5kkD2qOaf9p6y+JEmiY6YQ2keZoelr0Bif5djAA9uo=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxnda1Jdur5TX+RgO1P4hHufdruHR358Lz3BYPORx G8pRRuZOkpZGMS4GGTFFFmO/+feNaPrS2r+1F36MHNYmUCGMHBxCsBE9kkxMjTtX+zW2RH44ELN UZ/TjtH3Kj+Uzdh01e2y7qEZTgrchx8y/E9kjcpJ3dj/tNZwXUT0XHGmyS9k3dX75mj427u7JaY VMwMA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6hwdd8jkgye8iaa9x4nj68ej39dh8ja
X-Rspam-User: 
X-Rspamd-Queue-Id: 672A840006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777310276-584375
X-HE-Meta: U2FsdGVkX1/aP35QbmfFdm/DpD7hdaMYwxZVarSasOYTdsIHoVSb3fPENKku3XFP/AphRZZR6lRJH8x0OLqSwBC2X0UgbG9KJuYtvZGYvw7N3DpV9YVAbi68XKrbcdmW1yHvKjzOICSTDHIVpWsjAPtozgK+WsJK8rXFY2x2tZFWr36RHhgtlrkpLu6Rtjrvo/hiHhj48EJR2IVVrlvuDjSlsoNlZ3kxgNg7kjzqPXzBadCl9UURowPPswFmBQolesGVWLBfcDttLiNdvp9RMQXAQuBsigmKvDYZG7Bicu/L/NYE4kI42zXYGBDzb9s8JUtQOM6w01EgEjzRolo1em3hIiw5MMrl4LjdDyIjJiGibGFfO82qmY9MRYYVYbQl7k80ru4DFh3ozezIFc5BABDd39/xAIFSSCT1eV389OzYitSAo4nVokRrnhQXY54TwcTvklxDuz89t1PHjkQIn2rsZIRISM19USm5YetVtiwqEq1KOIqaXhw4/ErwpPjNxu5oDblGujkOKQI78L+Rd055MDdlLa8lgn/Jpdi/kWQnoVQfv+mlklEZNMQw27QXRKYVgw9T1HEjfgbImdpQjrrmrAtPennsOpoThABFlH5DgXge7PDLfYixwNvGdpfdWMkL8fwHfTizE2YhPoaMnaf8qnKLjyJ8IWQqSJCFQ5sRYASt7xJqbYr77MEIXmaCgx3vzFApiOSbCnir63ApcBUL6/b9vgCJvtzfnMC1KwZ8XErWMrG9emXLtbhqcEsSZTOyDU/VPBtxnBn5qPx97yWssD7B968d4qxWX3VQ/eU2VCMF/9A9rePy+02ZQ7JTD59m23O6VhJproTzxPlO8OXZvFzTOl+POyx7gD9+1ysjBOQEchUElRqVGexqegwJ1Pk2PHtYuFr61IeMmufyjmzTq+Vjfv3siF2JxBOqW85gns5MO2U94/qn3FrxDwG1x2grvarn+LIxGpDLYRF
 y+y1Cypg
 NG4XiiFLHAVhLZ6Ow8uV0d3HIYUiKQRTI8osCTirvZhFo1XybRnjDKe6h4Qv9PDmi/7htCABxQKIapHFelxIcTp0v5F5HnhHCeyyLMzt87vOS/MG58eXVMm4qXyEjcEzRzidt/GDiwuCmFPXOPhg+mg90MCF7sA9kk83HFpz2g6a/rgtileTu5AhfzUhHBAywlFcWFoutPyTWmOuZCvucPooyCel1nQ6YZBw3NYAl3pesucsUOs8P/0JgwRBYh0LqSF5oQGJ5ipgqlFH+Htz8MLLe6/i8eHB8/zEdZ8ElSzx4/b4GwkJXTVZp1c3Stm6gJxnMzAmynk6tdDMEg21+I7VDUnXDz2FTCipDRQOFeQSGPwSjF01dda317Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fixup_umip_exception() calls copy_to_user() and checks whether
the returned value is strictly positive.

A subsequent patch will change the return of copy_to_user() to
return -EFAULT in case of error.

Change the test to checking that the result is not 0.

At the time being copy_to_user() return an unsigned value so
'strictly positive' is the same as 'not 0'.

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 arch/x86/kernel/umip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/umip.c b/arch/x86/kernel/umip.c
index 3ce99cbcf187..dfff28ea1dea 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -409,7 +409,7 @@ bool fixup_umip_exception(struct pt_regs *regs)
 			return false;
 
 		nr_copied = copy_to_user(uaddr, dummy_data, dummy_data_size);
-		if (nr_copied  > 0) {
+		if (nr_copied) {
 			/*
 			 * If copy fails, send a signal and tell caller that
 			 * fault was fixed up.
-- 
2.49.0


