Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48638606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=auLbbl2o;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=qMqMlGFZ
Received: by kanga.kvack.org (Postfix)
	id 44E906B05CC; Mon, 23 Nov 2026 04:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4246E6B05CD; Mon, 23 Nov 2026 04:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A9B6B05CE; Mon, 23 Nov 2026 04:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4036B05CC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5DB8160805
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:39 +0000 (UTC)
X-FDA: 85465881438.17.EFB4EE7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 052EB1A000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=auLbbl2o;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=qMqMlGFZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426658;
	b=UWu0iO9NR8i7Th9NUQdehe9f/Vh4egge7GParwsVaewvQfTjnzgfvkSz1XFJT5bMTvmLtp
	DQQA9y0EpQYZNTgV+zR0m7EhS/YUTFTcB4isvUPQ84GlBq2g6BJ2g4BNkwgHCodJ20My4K
	gJJgG/LBNKtPlHqmNIrIFCVY7AMnTzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWYGWS4auZwM9Q07LV23QUYJ6/wrrSYEmZV3T9JL0KQ=;
	b=kuzDx7u8eL1B15h8F0LS9c2VVexCjVIWOtaVr1D4PeR+CY2Ml5tT1hev4bZPIrpI5hNX+E
	0ZyrDIcQ4sCIrGVo/Z4xqtsmPplTwk9DIcgOIhjdMy88TC1/nf2TTERTDOdpgs0zO6mEPM
	LAWhDZUaR9R0B79HW5JslWq+CxD4tp8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=auLbbl2o;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=qMqMlGFZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YWYGWS4auZwM9Q07LV23QUYJ6/wrrSYEmZV3T9JL0KQ=;
	b=auLbbl2oH4Ot5YpCeUEcYQ2dIFo74raPeSEpSgBeepfy72T3dv6ySqNZw8grm6xlh59KuT
	i7WWn60yQYtSqGOjySH/D5mPaenZdFLjQryxByxKOS8oKkotAVm++xQQ/BfFWq0WydplG7
	Bc3VI1YdNWooahhM59wa1198KWdmK1pmX5ZxVOlwkUPefFYYwSOgHhVMfbt1yaDxsxTQRw
	QvaT84wAf4K0nwWClg3Zan10Pwtp9aucgSxaEQ4bzDDgd19eRgjLZOyFQ8fPOY8Qe8yEg1
	B/xsSTsGNrZ0LAIMJP7x7jGA7J7+iD6ijUD8C4UHQUeo3CCHawC1aw7IuMaVeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YWYGWS4auZwM9Q07LV23QUYJ6/wrrSYEmZV3T9JL0KQ=;
	b=qMqMlGFZf4t4nwAx7Fj+UHvCQee1C2mTmihf6zAwsYxwJeLug2K+qgxMTQI0UA9bbmc37v
	oXm3bpJIAE5VGxDg==
Date: Mon, 23 Nov 2026 10:37:20 +0100
Subject: [PATCH v3 15/15] auxvec.h: Drop fallback AT_VECTOR_SIZE_ARCH
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-15-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=772;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=JAUB4d6w3tpvVvnJFyNZBhcXBgmmxi5dKlrBgo20+M4=;
 b=kCgAOd1xOlVd/uE/bDzZYB74ed4Qvm9zJWmY1xGZI3IKoxs4346rY6+SlaWFSlHZ/Fy/xnAaO
 7YsjYIIefxeCjUKx3kra6gHNuGjcu1KYMGOdN3sVIQWVAqnwsOe+Hdb
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 052EB1A000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ctjpr9ncz96w6amjeyi8bx68ir5q3ba7
X-Rspam-User:
X-HE-Tag: 1795426657-333585
X-HE-Meta: U2FsdGVkX1/xkUq4AUTIx2tvugoTbJ8BGQgh7W+iIsVhKAo1x1OMICOQgFd64HSIbhEUsx5MRnqAKEVz6CjeKkiYgTPWxDr2ERR7stOMlIwkn/ZObI6W2ZcdFJP5W8HaTamH9jSrFXGhCJQoKiJTcSHLuTvt/MQPYQKKD2yUdchfcqIJnJ0w7ZCBr5KPMe8Oyp74HK/IXOzR2fC2h8RJJJXw7s7+SpNZt57isqkjWzf+RW323aT9Y5VPLjqNsVm+/noFhQHapIIAGHZFyK/dpOnQp0nmpCdHW6fW/BxABYwO1NEJUkq2k1AHDyzaZQ9qfI32XVr9cg4fJAHpixXZgYXDJIsfqd/ByPvrycv7mmZJ6auPkaTVfStdiqRimIh9KY5yYOFnjlLzceT5hvvJhMo291SrWpEPOfBGkpUjO9uy3DrOup+P/cp7X6w7qWqaJPdMZ8sYVIfEowbKsJ6MO7dfeoNSIubuJsEvgKuegHgvE+dYNtal9YaW3ihqORAPvSa1PGieQ+LjRP7wqWEqRPKylK2gRb/DUmwIe5sJKNDCqtgaCrjVCReuRkqnKW4OCp9KL+9q93fFSUnB/FD9eoSbdk86hLL7QifG7cVcrWNn0eHe1melZyX07WnMO1dN4aYK5X0gxIOeZKGI7tonIINLUdrdabKKy/WbmNdDsvl43glC3EYvyQR3ciuKQ/IIV9x8WRbFEk5Rr5NjCv+BzFktz22Uj5UskCuzONlTQCvJxjIOPpPVjNZZt7bLZ2s1lJz1I6lu9QhhRkdIoxG5QjibmXJSnoggZhT/+E1KnQwFx2F6SsRP3MwCMFxdEXOOcnVJw6xvreQAr8Pm5QIGuwdcVX++7VG6EO3R0FLv5h2/1ZlQJS30bhyqWOk+EhkVQdWKI+3CicXhSxQE6HSswuh0hTHGvDjdGfGNVD1yVXT7EPtsjLaZ14tNa2BouzBBCmHHCOJxtYGNLlCIj9v
 aOLJwwzv
 Wn1xHwL6/3ipip0RFVBj8fBtMhhBvRzkOouXkicUZaFE79i9H8/aaOUmVV/guiJzTsYE4tsCUGY4QkVA52QbExPexHpXxS4lLzgR2ivMhNl3l+e0l2iwMyGOVi2JVWeKUaVeMljHgvCJH74d9FMXz7gM2xXXUiyBgHDpai/Gfij4A1dYLqyI5QGzAs7qkp9tQkCxE1YZBPqhcIvY4bZDqlX9weS1RHdVGscnkGk/Hc7PaPdkooapzE4SE91NG6gnxe6OuQlQ9PJksVwgbCB/B5Fn/PHu3jqM4vZvYPejl03LvGRnvfiIFfk5vBVUZHQY6abyyKQHWxZL8haXZ5CWolulLTce7elBrAY9wOLdXF2VdcH13OEs93BN22TWqCQODvpPHC69aAgPTCVSU+mt33+Mn3CNQRed/mmX1UrdqmeCvORBHYeX1gFxC/fKkKlT+Qo06ZPodnmV7js+A6yp/iC8ceH7ufnIeA9svMnThCfwzy7HqbEHsQJ42Djy3eFEKFr5WfD9fWRKiZYgxEnXiFawQey1R5WIjG0BI1qgKmhDrvANf7NOGYytXkCiSldh3VSgTwq6BFPksbw+UahgANefySMAPYaWPiA79GcUOPOilwF5tD1UECTANMlynOsvDShbxvlJwyTRndd5tXzYuWK3KcWzBwZjiyTInDIMetLNx4XcrodvDfSd/yzPFf1BDbAvocO6lnm42OZkXBYcgR5J0yXUaC0Q0I7kNjj4nCeYZCN3jCD38NwhxgsmIRSwo7Ws0thWwa+nqz7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All asm headers now define this constant.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 include/linux/auxvec.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index de1c33c4a256..f7ddea1dbc8e 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -9,10 +9,6 @@
 #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
 #endif /* _LINUX_AUXVEC_H */

-- 
2.56.1


