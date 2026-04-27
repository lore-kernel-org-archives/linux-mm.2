Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A7DEFF886A
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B8A6B009B; Mon, 27 Apr 2026 13:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41D46B009D; Mon, 27 Apr 2026 13:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58A36B009E; Mon, 27 Apr 2026 13:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6BB36B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:19:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 823EAA025E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:14 +0000 (UTC)
X-FDA: 84704996628.25.DE320D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB9854000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lp9wELlr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZNMFYuU8CchD1nM5e7lml3XtY3zMVnrOrvqbhM+lqI=;
	b=dGEAbVie/RKIDd7Hn8N0f+D+YLubtBybN5ILIBC4VZs3fX63LqbpyXf1UgEQ0/IzoqmCTP
	56RxJqD3oO7vLVleLdfFjIURnW5WaFO+hK9wCSDpSfDHzp2wXJQYEJwfuOlumD4b01gMFr
	+K0BCytDFFCNCWT0bFnJt+QglWqb40I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310352; a=rsa-sha256;
	cv=none;
	b=lT/cRqCJ0fT12828JvAuxDAfc/xfjbOuE/eYAUVYrsH+Onfr05EIjqaVKNlwWo1ASH+IhY
	S1MRX6wPUZYHXo6h7K/6+oKmRNKCXBhvlPLhT/bXfHsCZ5d/Y4Y6zwvaXWVjOahlBR4MFV
	cZYuG6DnZNi2ZDCppqpa2lQ4lvZuScc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lp9wELlr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5077960139;
	Mon, 27 Apr 2026 17:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAFFC2BCB4;
	Mon, 27 Apr 2026 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310352;
	bh=vbZIj5I8a11ig9c375SeIMkNInKGe+jckYb8HPag1tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp9wELlrvJvoeuCK0/zMI5UANnrsQ+T4se/gBOunN8iQDrEi1RstW5G65/9vUEPmI
	 U9UXqoktuU7EViGdT+8yzDZHjl2N0E5vd9veY8uQePuAD9x0oGHf4CotQwSmAD24go
	 gSXTECesL9+kQmgNOk7myjSgr8UboLxcnh/OrEADTLSIqRqZRx4YwXDl6QWc3wVNsO
	 sB/2ZwfKCyhos7Vj9aXXCgNggtmoXoIYLpWXmI9TjsLctEcOG8w3vDT/K6+fVh16nS
	 /UcGgkCV5vp5qC1VRJeMqVPGsaV7+wscOAZaxlqKS8j4DsLjsIu1iQmtuFIX3tL+zm
	 kvFBNXQR3j5iw==
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
Subject: [RFC PATCH v1 8/9] arm64: Add unsafe_copy_from_user()
Date: Mon, 27 Apr 2026 19:13:49 +0200
Message-ID: <5b09e58a84c9edcfe5724db5cd57e45d96a96bfa.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2498; i=chleroy@kernel.org; h=from:subject:message-id; bh=vbZIj5I8a11ig9c375SeIMkNInKGe+jckYb8HPag1tw=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxmbKDOhb/vkF5+62Iv+nzi0lmWmkWf+tSO3HK9yP D89hV+LoaOUhUGMi0FWTJHl+H/uXTO6vqTmT92lDzOHlQlkCAMXpwBMJCKWkeGFnFP5dUbGE1cO pXr18eg3ndoc9ubDcl2tYxbdt9o1nmkyMvQuDCp+FV4TvfDP3c6+r/YFCyvUNTZlcrea/2SZ/OM dBwcA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB9854000A
X-Stat-Signature: kaeob33r1uk18qmh83wufbyfhpgq1fqs
X-Rspam-User: 
X-HE-Tag: 1777310352-21866
X-HE-Meta: U2FsdGVkX1+5k0Z5qjrQ3JqIBgb4A55VpjLN5LCLjStffnjozAblxP0qHy9iHuSuJpaROgiYWcsY0xymJVcBm2QhMqsbzGDTjACsq2PPH2FnwP6L8eri1knzFmeqRYnQML+J6rykcaE1xmwX8w9d4lBgf9CYzLpU7iK91pYGOUD2tjd7i7hbR4vIc5SxZFG5LUuiGVhCa+sezY25BNhPv7REU+nUgblBkZlTxZ0xzbr8VyeffEiFMFuMm4jZtQOapVG/IRQGrdda1fE46BmYXQJQ5hVw+TrwJAMKcgK0wCWXBMrojuF7MgJx7QBMSfUB4wYSENxUIlrdLkstZLL7/QZhvqVX1DZQOJl0nJzJDNAMuBOJICmj2sLdI3MsQFEVJJuiH7XLVtLmmRcsZa9XQpQdmcbB9XLE6u18SBArX0F4Vgmgx1tIjpuMAdhXlat3lyt+zV+gDHjqteXtkyYjrQ11ZDnJPbVyoBZJbHowFfqO5uzvN0eSixhR8fr44+ybZuYuaKmoL5STzElg5ErueAwKvCGC0GcoQ0MyOwJcOrhVccJ41gc/2aTUWGTPZuexcS9x4TNNZyTu4purmMuOfFGXTXaMRei/5gEYaAxYEVwzIvTABdyeyIKrAvE36fnJaKsAEp8rXvKqEPZ77fy1PB8JTsFj9SrnlcNzlgFPmmeJbsLeNn7oztXUupn1biPuJS/D68QpW3FcLP8L48fW08/vWd+iBjaQlZ0sNrKeq/9r3+nBqHidguLZEZV3vSRSqOdlZclc73EOpklW0Rq/7nMu0vV3nlIn3GHgMo5QcNoQyt15m9YmbTDYAl1HU+S7mdjInFIj/fzEz1BORCVnhc0RiroUk4Bi5WdahUZBEmNQBT53hCx4DZNdwp4O0BOghB7ORrWZssEpJYX7NLZlYSKaIpY3h235vhrkq0gqtCJAESYSeMjV2D4O/LcCuEOi2RD2ixoCEUo+6Besmwj
 4ciS6lSQ
 z8R7Zh6g1luNIosNL/TyHL2CdLN0Wf7YU7dGXeFUY7IW6kKPXfcq3cWi72ZnKl5GlvJZVe30gGzPV8t7F8XKtn/Vvg4u5u7A6nCc3PP019LRXDvFq0sa8ghwb+8nRMguCIX/VJA9PjinO9EOzCQBCONtZsbbblOejZkIwi2zn6GBgMXY0rfZ11ozPsWwf2+i0nThi+QtbYXLua8bvbVWt7pB7Z9DJPhdpvNoLdZUbcJnJIUk9cdEGC+zok+BiDWwRpkRzPmLwZs2Za0XgBJ+FEdF5pjIBfU+PffggBDIGZKu1lyrzdb2ymUZX6/vSh/ksEkvVOHC42OwYIIJ6MoRITHpMud+1l6UXlaJT
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
 arch/arm64/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 1e20ec91b56f..adfdb52cd82b 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -437,7 +437,7 @@ static inline void user_access_restore(unsigned long enabled) { }
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
  */
-#define unsafe_copy_loop(dst, src, len, type, label)				\
+#define unsafe_put_loop(dst, src, len, type, label)				\
 	while (len >= sizeof(type)) {						\
 		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
 		dst += sizeof(type);						\
@@ -450,10 +450,29 @@ do {									\
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
 
 extern unsigned long __must_check __arch_clear_user(void __user *to, unsigned long n);
-- 
2.49.0


