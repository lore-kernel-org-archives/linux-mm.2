Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7DCFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59A76B008A; Mon, 27 Apr 2026 13:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30D36B009D; Mon, 27 Apr 2026 13:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C346B008A; Mon, 27 Apr 2026 13:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3DBD6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:19:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CDD91B7DAE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:02 +0000 (UTC)
X-FDA: 84704996124.21.32CDA82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B1E1140013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdO2kRaq;
	spf=pass (imf26.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhZ9NMxuum/7eEE1gQi0nXMq4NB/M40iUHyNchfsiT4=;
	b=bzpnWJXQypeEkdTuh8/Gdz2rNmrJkxs2ZlSMUu++KjqX1gKBSYBSqNPenC7bxr5ZiCJNyJ
	BcqnDbLKbTmOxWdZoEPscdpdJnl+7peNYFiF8Nx6dRhH4DBp8RooRXuQFKlscZsc6I+RMl
	YWtWXBBR1wCBxzj+Gg41cecT1pD+Gec=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kdO2kRaq;
	spf=pass (imf26.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310340; a=rsa-sha256;
	cv=none;
	b=23mVBgiGVu1KGgtqc33E3ocyMuF0mY76US/pLrskjacxi4Aj+qbhF0Id1KPyIITcZ/lN5J
	D9UhYB4bO+34ZV5th6JmmnI7VY6sTho4BYISjhn239PE3sZJsCA09nLRU/9/Qtmnm6KGdh
	iy1uZYWca28ANNYFgan8LbGnhGiXL0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9368940C54;
	Mon, 27 Apr 2026 17:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C90C2BCB4;
	Mon, 27 Apr 2026 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310339;
	bh=VVuQn2YnZFi2JH9uh9hmEqXb1BpygsXabSyFGnhBvmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdO2kRaqrKnrRzE/uOUoSc+QuIvBLF9bEcfUYb9jTJLWJk0AT883/0gLUkpYyvhxW
	 JwKLSaa6O8znPG+ygzo4nQLM8J0f65SbAuU342P7t8CFNHOEuyufyC86uU6TKB6BuB
	 gSew3oyOMPJ8ALphDrpzU/JPmVzf88NlkSTCpSsq0dGpC1oXnkppqU6so9I0ayHunG
	 vmD6szQq9NnauXryTPXCD0GLKF95gnwZ47owOPgIM468cdafyYqaGorVn/T0ZUPF41
	 utCUjd396YBehKkYMEmrRy4GP6QkmxuYFD7L2LBro+x9SzGKxh5BvzwrXlX1jpWNJG
	 /RZq8/R9DjgcA==
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
Subject: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
Date: Mon, 27 Apr 2026 19:13:48 +0200
Message-ID: <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2390; i=chleroy@kernel.org; h=from:subject:message-id; bh=VVuQn2YnZFi2JH9uh9hmEqXb1BpygsXabSyFGnhBvmI=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxljeGSBfXj99HCNy2WTVFXXC9z/Hmi+//aE1/MbC +50nw1Q6ChlYRDjYpAVU2Q5/p9714yuL6n5U3fpw8xhZQIZwsDFKQAT2djH8D+e3yYgNP/F6xtd z9QNXjIccVycwR574E38S3tWp2uq95Yy/M9xKJ2hYJCUJV9391rVwmlfl7x6GzD19bqwZeyVdgF fZ3MAAA==
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B1E1140013
X-Rspam-User: 
X-Stat-Signature: ugyudif19617t6sep11ey3pn8zg8cxfh
X-HE-Tag: 1777310340-202164
X-HE-Meta: U2FsdGVkX18uh0d7/FypXHXoVa6tjb1TNPZfWMY1Wio2hr7ybA1yRUzqdfJwftmldN/+6t9ctvnWthFkv1Y4IIyGzN6mWuwTNeWLII+C+gbb7t5fLov4RRqO2ensOQUQ7SzmVRiSpbQceDbIUZ8GswubFI62ABJHmWS/fNzum5A6IHLvU5HEgTxdAxtA7CttljXnpttNAO/KlYOv/MkeeViSgBkmjBQkCi8ZN6u9vDgCIDm2bDSLBHnfA2PD2MqEuuzoFVQwT2jsPVieIA0xrVxSqkXG+aJdIvjotmsdRiH3/66WByrnSBRTVrz/FIur9AkdEPSEZswci21wzYbpAXr0J3/651s6f4h5PXS3pjRUIdfLudRj4t8Hum1n8emmenwpU9r0K2JnPwf8l4iJI516WtQjvXzWa2ZgU0dbGEgOaiqiU9nhgK0Ui47L1c5mYj6t713fJEazPCcpM7l+fm/yHTdpptX7uhkbrUdRanBely62N/8VJOUngfiXJXNLgQY+MUWIYmoVRUrKsi5BhxC9PBBad7FVmxjnCLr0nCISjOn6NO+F1kUCY7/Ejxh/98G6L66ME3qwbEFKHAJt/FPK7ehFL2dEJzAfVdET7Xt7jvY6c3RgPRbCLFWDCw1qVHnDej/FAf5+vE9UPsG7XMDxFxvLxUuhmtyLPR8tvJR+98iORHLCqAdreDU1X7bUo1NeonvFUXc97zYvxXtfn78TFfM120XeqfdGK+VopzNELk2BalPt985Z1Ry2kkTro1kUIHWRPx129xBZ1U/aEz9637Yv2pvDExlc1H6G9Zrz9y4EGm3tbY8b2SYqyEmJMmUf9OZamUdgpCqQ1sTQ5ArCJUB/wC4nzuiQVpabtr+E4ART3EE1OTgBj3blrAwrkmqK9HQ7zn69P7EeoNAwxvHlomALPimsu60lc4ytnORZAie1uN2x+xZ4CBmg3fHq4wZFnFG/7E10qlApV7V
 MpwmGrjr
 2AnnvVOCwoo9iNIrgyBgDm0S8KEgDo8r8uUjXO7WfV95qH1xuP/NTur6PWdB0UnWU8avMesCHEg1lODAdwOAI6pxE+TjA5iDlVjjZgeYr97S6g78+KxHH+JO1D33EdmaSqWSoF9x6a5XzOFwaXb6FEFHEuMBrzOzPY8etPEbgT1ASuEeT3/eA5G3FV3nDLsStF/s8slddsCvvWMHyRUyyZMyVdhIQ5HZVQ6mgSnsNBgrpToDupNWw3crBwocEG7Kym0bLsliPVc25dLW4YSiJmLAf2ArSRy/bkM2df6kloHUxDTMhs3KWfcH+bEvkUTJU0HWGja2iA7/6Sl1GdDkiCUJr9JOqVirwpNad
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the time being, x86 and arm64 are missing unsafe_copy_from_user().

Add it.

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a0dd3c2b233..10c458ffa399 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -598,7 +598,7 @@ _label:									\
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
  */
-#define unsafe_copy_loop(dst, src, len, type, label)				\
+#define unsafe_put_loop(dst, src, len, type, label)				\
 	while (len >= sizeof(type)) {						\
 		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
 		dst += sizeof(type);						\
@@ -611,10 +611,29 @@ do {									\
 	char __user *__ucu_dst = (_dst);				\
 	const char *__ucu_src = (_src);					\
 	size_t __ucu_len = (_len);					\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
+	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
+	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
+	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+} while (0)
+
+#define unsafe_get_loop(dst, src, len, type, label)				\
+	while (len >= sizeof(type)) {						\
+		unsafe_get_user(*(type __user *)(src),(type *)(dst),label);	\
+		dst += sizeof(type);						\
+		src += sizeof(type);						\
+		len -= sizeof(type);						\
+	}
+
+#define unsafe_copy_from_user(_dst,_src,_len,label)			\
+do {									\
+	char *__ucu_dst = (_dst);					\
+	const char __user *__ucu_src = (_src);				\
+	size_t __ucu_len = (_len);					\
+	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
+	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
+	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
+	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
2.49.0


