Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5349C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD056B0099; Thu,  3 Sep 2026 03:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB43A6B009D; Thu,  3 Sep 2026 03:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9F86B009F; Thu,  3 Sep 2026 03:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8D786B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C542C046C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:31 +0000 (UTC)
X-FDA: 85171655982.13.B49459D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99D37C0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wnd6QEH5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3zO6Gdlo;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzk8S7GGq/mqM3W6SmaZkZnDg7V0wPqYFRG/WWfPRl8=;
	b=Hn8e1Vg7A25mR5rOvHikHgNxPzSeSswbGaNSjrp0McZ4mb5FkTNeGUHaJtqFSXvWhDPdN3
	B2nwE5DZXmkUnvM+btaXoQwPFJMKHalQwf8izOvEq82BWWpp1tFyrnn+V6LoEuV3WKXEj+
	4CCQfeGI/5aVPs7jY6vi35qBeYCitWk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wnd6QEH5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3zO6Gdlo;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421289;
	b=45oML9xOkFNQl1QYT/1vntu/BBjXehjlZMHqTGn1bC6UE+Wg6hZ62BW5exAf1QvqdlZ9VM
	wQbdL09PyqsPqyqFd3nVjKYxWbi9TEjasvQZPbUE0g7keA1NOJq9WNZIAzvCq0iSKvFOIz
	sI+iOIX7MrJSHmVjf6l7GsYs5lrXuc0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzk8S7GGq/mqM3W6SmaZkZnDg7V0wPqYFRG/WWfPRl8=;
	b=wnd6QEH54/BjH3IqL+NmsSLdPMkIm3Ol4UY/fevb8PsoirNu25dRIf9FyoBeO21n7ryuiB
	4q8W5smEU5SP2xUhtsmAPB8t1AyD7BOnfk9PMF61YydeJW57H9S+LagF4bPuQfR4881WRX
	/4oCAgEv/Lb/GUwIYUiN9M5C/Nq2KJrUZLyuYIxmNF/rXmTaHpNExOd8dL/nTrYG1A8nqS
	1IJmvplNWiUa6b0Q2weqH1mz/Kn4SalyfB2YijMQ8/Vpp2jtuXuQxHZdB3BjakEgFTGG1+
	IzqqSnX5CGvvZly/aH0pQFeEH4/dWYMPZ/63MP3uHm5VaD0VlSxBYQTUsX1SgQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzk8S7GGq/mqM3W6SmaZkZnDg7V0wPqYFRG/WWfPRl8=;
	b=3zO6GdloI0RIRQIUARPzBVJ6Z2WmANTijL9R9i7Ce0cPzMjNreKcy1VLDJ/BIWuW6HH1xn
	nh/lWOAWzbhNpfDQ==
Date: Thu, 03 Sep 2026 09:41:17 +0200
Subject: [PATCH v2 02/15] auxvec.h: Move AT_VECTOR_SIZE definitions to
 linux/auxvec.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-2-5bc32a71e3d8@linutronix.de>
References: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
In-Reply-To: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1309;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=HWrppGtlxN68+J1EvLurdbOmIVycSJ5y0ost40gYay0=;
 b=QtuUd8ndQfte3MxNSIPeA1ceK7WkBDpTjXLL5fb4pzWRDNSz/qxqD4exzasiSFQC/0O6qJggd
 TikOW26FC/0DEludcoZTMbhvBJm/noFxtE6Oqd7XYz5ZG5OybqRL4sw
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f55ae3ri8ymdkoz43n9kbesnz1mmy8kj
X-Rspamd-Queue-Id: 99D37C0008
X-HE-Tag: 1788421289-780140
X-HE-Meta: U2FsdGVkX18c2fr1ev2Y61BfbxUyBeZmH7tv80lMORgt0gFt8rDymzsYRCNCKIK8rU5HU+rlUG+wUlRrNJXMA75eU884c+1s00+VWT50mGxA/oR6SsEsgmig/ayDEfoIJ5K7WCMZzcqtj7GDokjz3gnIzH0Q8exeoefRhs3F8IN3plSp6fj52JcOXuK1aCaPV9uUKPxfYq1Bnp0VOSvyDml/hdYZekXQssTohPoUt/IhGTAKLWJfSTTnlSP1dkAR/bOd7ycSbeEQGT8Ldbrf747JAbKKMCeahvmpyxGGWtyIpVhI5l84a4xO2E9aqt+XYBAuNqBdVDfOiXhEaDxGK+SG6tBnuJ2rd+gJXluR7jvv0yem1LNhX8uM7XfQF5lMuk63CO6DNbBh4/2hHgfrMWCxLhARLin+IFXDQtfdkpmgUTVNb5XxSD9ZY15lJzvLkagV0Mq+hI8kAxIMagxR8lp3rEBIX5NmvbaNzAX+yzwk12Dw2P91hH5YCehddvWGpF6OdvZBH7ERq2rcZcxS34MvVu0aJW7NvRnr4qN4184+QbIIlA3G5MhD3rJxhzEGGUzj9P47AyO9gbSYfjqbUyc1e1X+7cZRjbFEhQuVvHSa6ayDPH+hD3fAhcWeRPSEdAynDmkHpvJxNV1soMakNew2kBx72Z6+yCkxH6Mv6Jbk4K53tEp70I/TGu/IPEnbSJ/dM/Xq2BDgaJjNBAFD3QC4kPRQj72x0fDnnbJSghh9PISqoZTZJt6O+PcUaKM+0A4YTZ0/QaqsvAa7rdkUrpLfJZ2Y5y5tBDRvPBq+csZW3N7DPAN5GZ5uTHq60dLPExsWrZ9fWAd5W1y8yIyJ5LjsEYR4WMbXIqHNpptURg2Jud0gKncrimVjtT2Zr8LZJSX37hRSH25zzhqE4SxKjGtWCYa0u1PkV9zMPfK8QF+8LhV1J4IsHDjLPzwb3dVbO5mbwtGSM2tw43sddmB
 QdPgJvcB
 VmQBUa/8hf3Q9F1lTbPU/NUtT4ddNMgslYxS2suslmLTSISJZosQZJo3CpOrevgW3GUxq/2RTt8QXeieXE7iFJmE5txUMJR8VgqS2v2j0cMsUNhcsjfJhahPB8tbhBA8SKWO8sWD8/b9ym76D+P/U2Mjcr3ra6HvSCGTJ9Tsl/xV/svBuBTi9nxoV3uCpQ0P9yKqReXg7jTt6feSMvSyCOKd8zy0A2vk82WSUGF6avnlvvy7sx1sKB9UuyG4Jc42mC2kGtGa54flMCKwsCmrTJlLtfGhxC9hJ6am+SBil8yyRlwNRpP/2L5coSck8/m63AZ4IXBQmcd8SyHHv6PD6A85dn8om/FlwZeHAhputfmAdqypBmkuhwUzIB4/hzyI81j6Wg0Z3hwrovVzHwTy/eqnPJvVW7e3tzot3Sk366dUQ8PjTfzFWgDuMRNjvhs079RVJnfqpD+zASXZ+9Kjyi83/WsLVxhmFVa5d5BVw/nuoHzR3N9A1MMQ/2i71TdeCW/h+ayGyJU3z09o3qXzrIlbAsysLv8BVtsoJjDSKtns+Yy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The auxvec.h header is a more fitting place for these definitions.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 include/linux/auxvec.h   | 7 +++++++
 include/linux/mm_types.h | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 8bcb9b726262..4b364e639f08 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -6,4 +6,11 @@
 
 #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
+
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+
+#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
+
 #endif /* _LINUX_AUXVEC_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d815f6440c9..08a06b26375b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -26,12 +26,6 @@
 
 #include <asm/mmu.h>
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
-
-
 struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;

-- 
2.55.0


