Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BE2FF886B
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C416B0096; Mon, 27 Apr 2026 13:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133956B0098; Mon, 27 Apr 2026 13:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049BE6B0099; Mon, 27 Apr 2026 13:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E805F6B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:18:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9DEA1A025E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:18:20 +0000 (UTC)
X-FDA: 84704994360.12.3EBCF2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 854A64000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:18:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDwlcHyn;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOGbn9OoG8rBGqzI2kLVy+02fyWRJuxPwbq3dZ0vyfI=;
	b=FXXrwdk/vReE1eFYvM/aBWW3W6eyRUr3NOBEibHIypXZ6fGEId8gZwR/dSewTbVq96D6h5
	53/sfN4de0+kwdTXrZQ7r/XGIHx8SkflukoL3QFVV4/aStkBYe3UbzGkkuPWSk0ZoFq7Xt
	vFOLFyvPX2NP+x8//q/CRouyrIplFg8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDwlcHyn;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310298; a=rsa-sha256;
	cv=none;
	b=I2bbLeqry6G0EiDqm/x10ABSlQQpJvKwMb3WW+s1jpYYFC/o6EkHv/QKooiuI5kAUQLYUR
	AW3jt2XbMi7w2NZVxy7mdOfEAFtKwbOSQcqoqn94Oj2BGBP4/UN6UfDdnkqjjqGtS98a8l
	axZ//KRmsII5ZK3jfKSkEjgsh/EmrJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B93C440C2;
	Mon, 27 Apr 2026 17:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C06C2BCF4;
	Mon, 27 Apr 2026 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310297;
	bh=G/2eQ9TI5TAejE5IgsfdvVcfACCawPpecEdM1VXM32k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDwlcHynPBKJgZEQOCWtilxNz5OJTbEC9ImCjJuQT3RnOoZjD4+90hMORF2q1smV0
	 ZZwStmTz2ZWfCFTglmd/E7DTmKQiqUkyq6DoW4QkOcmP8LtfpYhN9V4ZMaLV1xjKUX
	 qf/gxqJdT3gAPMXuYRhHcRDH0KM3YGUgvPXpdKncm5DePPHjb0VOG6buq4s8MreRM+
	 EZo8pRxSQAzQ5kujjD1AkNCv3dgeUm7ZrfC1oOr8cnbPHFYMiYdejiO8B5iigWhrca
	 1OgKQbcauQ7QAB8qeF6Zf8CM71cpuIXWBUm7GSS+m87r+rFbtJTWOdD0Mn8qIs0Vfn
	 3JDYXNLvVgu3g==
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
Subject: [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
Date: Mon, 27 Apr 2026 19:13:45 +0200
Message-ID: <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1585; i=chleroy@kernel.org; h=from:subject:message-id; bh=G/2eQ9TI5TAejE5IgsfdvVcfACCawPpecEdM1VXM32k=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxmjMKmwhcOl/KmCyQK3t3e2vTXauaOc++38fue5J 1/fnLd3d0cpC4MYF4OsmCLL8f/cu2Z0fUnNn7pLH2YOKxPIEAYuTgGYyD5HRoZnIqUtqi/uzJzx /elrrqTduXsuSM05kFXcMu1CQyFnzPFOhv/RJewtZeu89EsObX+ieXizf2Xo8RNCJwMOumbxCC5 Mr+EBAA==
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83iinyen6t54jnxf79hggejx93sejs6s
X-Rspamd-Queue-Id: 854A64000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777310298-95379
X-HE-Meta: U2FsdGVkX19t60msYbTMkT9r6CcdRJjVuOBEL2PoMSf25+QcpRMKcFqKQDEn1G+0mRdzaCvwYvLDlq2SeenG2EYLbM68A67o1xnQYHk54TvWLrsfRWr2ue56f567lOT4gi7qbIS/tqOkTEwD2P46W8hj0WcsufBAucJOT1MaXGxWK3U2L7CSefWNm2Cbd30gbMMlY0Wfs4PqQaKtwPOdR/iTpnCm4e8p4vGxfKLsAnXrYbUTWTcu9e/xQ2VR89PuOUjjJj1RED4TaBDuBo667+yeJ9mcieU1BMeKSsXDpBiS0JUOicNIfk/QMIZCBBhbnlCBtlv61z8D5UM/2MpksA3MHNDX9pa6Sy881bTFJfG8MhJOAHgYVxt2ft0JPNxNEhZZqVZ6naAimY6Ovu6z2B17ZGNr3CIWuwxfho/nikcVOsqqyBRiMJTYJfZ/2+Y2qdo4Rx/ahjuGC3Hv3vunspcqE1SErfR+7EqF5Dj5EXAzrFxq76rgeSKkVpfAjMGfAqelusu0x/X9H5AMFaDGZcQEq1q7fkf4awwYoD4opYBpPqseKCA5M45fOoDWS53AvBwEQmX6Euhmv2vA052kxUBCSbJJhnyqMes4pPoEaftwj3IpipOdVUdI9mxcYmzN61HJ3Jv4S4sf1WtmGv56ocY+T28P1gPymCKH5URjzvEaPUJK3BSzX5Nlo7A2i0NH+jnG+zm1lckIcgkG+zNa6XolkBM1L6ngHylLEz7NwRnrtEresgDSJQn1ufgoaovY7ZKe32Y/60RHBM5YwAH4gJUqyYUEOehyGg/0SnE6EBAe52ICdI2sppS9tp9Uw3OrkPmK1WphXUQ885PH5ioFwJQs6R38XMTHtIdz37gJKVYhTGs2uzTJQ1A06z4z23NfrmKiobXUNZn6Ws1h1oHjuUeAxnbLUWpgwHH++29EHfQYkANqnfB3KFYvntdwQUyxIfP0xBSyRIT4o2mw5lv
 5ok4Xb6D
 f5ZdcBrcfGVq0IxFANyunhkfJJfKXzHchsYqTKKHh1hID/0gfgT5qgVUay9KKPXTQhPC9vW2WqFUa2TwZFmstXKDLSQLNv9FsAogyz/M+KE/M6z2/ZcItEwk9kwTq/BwordRAknHH7aNSS89z/hnGYSU3yZ21f0r16WBmZJoGIcWgvPGYwEURUqvYjyChXwAd+aTmGFiK2+9Hb7cRt4ohN2KVi1El20qj9XyHaFoT+DNNSzAiFNn/vwZFWtcGJoKH+oBzyUmgd/iSPg3zc6wPPSvKMtsXFDQ6onNP4x5DVZI+63LnyZAlr0nYY49jp2jO49U+fkuYg/7hU7n0Uxm2FTICq0sZfrKlE5Tk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today there are approximately 3000 calls for copy_to_user() and
3000 calls to copy_from_user().

The majority of callers of copy_{to/from}_user() don't care about the
return value, they only check whether it is 0 or not, and when it is
not 0 they handle it as a -EACCES.

In order to allow better optimisation of copy_{to/from}_user() when
the size of the copy is known at build time, create new fonctions
named copy_{to/from}_user_partial() to be used by the few callers
that are interested in partial copies and need to now how many
bytes remain at the end of the copy.

For the time being it is just the same as copy_{to/from}_user().

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 include/linux/uaccess.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index bd1201c81d94..2d37173782b3 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -221,6 +221,8 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 		return _inline_copy_from_user(to, from, n);
 }
 
+#define copy_from_user_partial copy_from_user
+
 static __always_inline unsigned long __must_check
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
@@ -233,6 +235,8 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
 		return _inline_copy_to_user(to, from, n);
 }
 
+#define copy_to_user_partial copy_to_user
+
 #ifndef copy_mc_to_kernel
 /*
  * Without arch opt-in this generic copy_mc_to_kernel() will not handle
-- 
2.49.0


