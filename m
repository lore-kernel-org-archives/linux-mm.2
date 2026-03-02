Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D70E9B370
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595746B00A1; Mon,  2 Mar 2026 07:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5284F6B00A3; Mon,  2 Mar 2026 07:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9B76B00A1; Mon,  2 Mar 2026 07:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB216B00A1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F1855CBC5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:56 +0000 (UTC)
X-FDA: 84501044712.30.094DF41
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id B87ED140006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bjv0a6y3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BYfC3Feg;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gk+DNY1FnX2Is9++3W7weFVsUWOyhOhif2Eu1mxTHc8=;
	b=wM0hnf8FaGXHoxwkiHdA5gNafyJcvaG0DrML5DlKtS6tk5L1DfPnfu2EkytaR5mvtKQXOS
	hQSNHr3DHqCXQpI4Lku/M7mlgtVCdcw5+wrnley2YvVzTS9gqRv2B9Z+/P9f6D0emG9W1h
	ghXpApXc2uQliyhuxUbCO/db9r1A9k4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bjv0a6y3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BYfC3Feg;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454354; a=rsa-sha256;
	cv=none;
	b=1xb4HIQWJI+mKbYESqqJFV/KWMsMMRF0Anr0+V9DSoCxO6/ZUSj7b/BUOkr7KEiUuRL7ah
	WivydabZLmxbuDfwr1yc+gz8Bx9istx4tebJAvdNw2pKWyVS+ZV/a8WyRsLtkgKqlEqPKv
	yzPQyHkDfdjtsimEQrA7AvX0SsRXyEw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gk+DNY1FnX2Is9++3W7weFVsUWOyhOhif2Eu1mxTHc8=;
	b=bjv0a6y3jCZ57+M0uFA88aCV5qSJ4Nd0obqTh1cZRZ6IaeWWNg/CTFwcAHwXw//lfMMUVu
	m1Mpa8otbmrWDJUuqL59FPydBljYCAaaGVif88nsL7FmUoVnPZ45eBu/dbmrRuw0f6Yo6w
	v9eNArcvNvWsTi5mM3dGszF37CncJy76utUKDIR7HGZiggCkaqipBC1lZDaBI2haLxXiKZ
	M35kORuqVQt+esRy8qf4cdpa+eJ/GDFoQkajHSv+QyO+Ky0KkAVVx8uVkOXMDX0AEguZXr
	nuJHkW7DK+/9SJ98zVgc7fjaR+AC8titmzEOvetbJ5VW1vSlFpSMgU0fO2yfFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gk+DNY1FnX2Is9++3W7weFVsUWOyhOhif2Eu1mxTHc8=;
	b=BYfC3Fegaop1FFBF9oem1OjAUVs0XyTKiFOs56Iip+kmC013SL48mBu/X4JFdKO5qcaRVH
	9OQ9T+TEdCCCwCCw==
Date: Mon, 02 Mar 2026 13:25:39 +0100
Subject: [PATCH 15/15] auxvec.h: Drop fallback AT_VECTOR_SIZE_ARCH
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-15-a11f03ba2ca8@linutronix.de>
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
In-Reply-To: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=730;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=3SgKzX2uaURwdk6BulOU26vMp194sxSrGIKk7+4gH+o=;
 b=vht2sJN2rUis/ZgzV++4P2sJ59ygy9DcT8yNfNbBA9oZ/PokJlfDEb+BAVSUMWrI8Um52Kvy2
 /R46rtq58zdC0ybNyXouxNGCbUYsNmMjl7tobyboz5eg/Pw0p7lpe82
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: sqakjwfgefzoweq59ampbbh91q6a896c
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B87ED140006
X-HE-Tag: 1772454354-166633
X-HE-Meta: U2FsdGVkX18qmL2r5uexMCkFkWbV0ikWSUTGBNKCFJ5JLPGXulQPI7paT2FZ5J6Bd4895Z19w2/VLIgGo0vFwQndw/v68RVbTe1PatltvjnaAJLt/hW/N4tlmd1ITA4yg9TEFOC1RxmLrph/jHsj6UoUgxzH+lbAFJXkqk/A9r6YUIWodnqZR+awEJS0fD0D9cfCcaOA0NNXHmD2ssYDZRNJe2+yBeZPRMV4TH359h/MXJAEYHO6MsWF7qjCJINwz6XTB7je1Fj03peNyYsqassmboE8n4Tg5HTqXB2Bg0kmwjy5eHjSZUKJIBlPwNK9VakjWUHG//1UkjxdKwl/qxn/sBmDnVLBVTzHhhJJ3awXizCZAK364zILgsZY6wkTtt9qmtCXMAocqDeRNYGxpkeaYd4Q/TjtSpdjTnNWtm+GZZxBMQkQTL+jBzrQ5lW+4njD8498+S7aD7tY2x/6XCH16UViRYk3PNvn+Ps9RZyaYIYOR0GiwcHCLk64BOvsfjPnkYjYgnMpGIowAPPVLA5acGXGkRxqTMTI5VC8SziGq7fRa6A6x3Nvq0uVFIeHaMV+03QlzUkQpaIzpV0ABmr2d4CXMjHSLMZyFxY4XWzObQDOAN+vG708efsA4pWVUTm0q3MvpLiyhfDa6guRVVPsI8A249z4ncFowpZHUHhWg3wSlZ6ogt+0l+yWYd22BJULFWpKWPjOTBuxRwbGvs2FDjcFu0zzjGSn/j+ImvWzGyM+f1xAJhagVfjuPvXyv12zLXb+be3T6M/FTrFVVpYyfyZu5dFmoTnAvkknI7F6TysxNxv8FO9X77cay2tY7leL5Y51mCK/yR2AyulEEnwoRZsajnW0zFWbInmud2cq1ooIKdVcDEnIYWTESxx4XqkavgaZiFaqZxAmbedLa7kYxGGgAoxtm74Vt7CAzs7KqhHKR2cWEjW2CCRj6XpnsQgWFqfGszqTqLzk2T1
 1r9Y1f0t
 Khz5GtvF0fyk76NLWbgu7RHIRb5p+AISiNqCpubVBVOn5FcMLav41IW0M4oQLdNmVJ+eKKZTsI0bCuj+MotFm0/NsNGEYm6hf8txndF9wYpQG3pD8jleybD3HVfFTElSunXWxZ98MNj1wu3skl2HEIcSKnBwIccpCWiIoB2BnUENmiXoBzWD5XMrisR+iZmL3U/pldGdAtsoixULetuBgG9J5yImMgihtSDliOiXMBXsmeN6vthhuzxlTw51G5Fs4RSzYPIZJJbJkry6KaY9yX38hMeKMjNZFGhKn7NbxeC0R8CKD5zLeQMKWfh5nLm1MHU3+y1WT1iOcazN0bUxtIDXjuQzIyOX9ECcolCTbT86Tmq/Zb0B2LWt1e6FziO/TWswIOf/NOGFB5i/AmTBQsbKLWfnJCvrZTn1P/oPyzl/8b9ZRTQmH6PwfiSJDNAQQ3F1L1rE/uf9It7ognvEiMrx6I0gvEFubqymth+g0FrcwSopRg19J+XFepbGqsO/NEmU2M05kjeJ05xxiFLuVfCv0oo+EJorifKXfkgG1vnbIRNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All asm headers now define this constant.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/linux/auxvec.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 68c9d6b118a9..814f984726d6 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -9,10 +9,6 @@
 #define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
 #endif /* _LINUX_AUXVEC_H */

-- 
2.53.0


