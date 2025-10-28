Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5300CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8E38012F; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B34680132; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A9280131; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21C5F8012F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBF5E4907B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:26 +0000 (UTC)
X-FDA: 84046969692.17.A898337
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22CDA80008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=KWo7sg0H;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf30.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHYEc+7bFZ9SQ8uNEgo4nVYWQFf8fTUlITvRCThhJdI=;
	b=v5I9OQfnpqdfGomGHwijI4zwL1/4JbLjhJAltg+M8y9d9EameE7BL1FQfoBjqKu4hW99vg
	72Ir+aYgfvZKFxAPZRhW3ExhaQ7R8BfLaeq2g3Vgy7f48gGlcgzPEPxgqWthgEV6g6k1Ov
	3AA5RFx+bW/C9tSpv4FjvAF1cVhYieQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=KWo7sg0H;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf30.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643045; a=rsa-sha256;
	cv=none;
	b=njXNfKA8nwgRFeQoUtOHo+kAHanX0VnPeoK76MaxkB6Avp+Qsufu02Z4WOk+eQvh3ZF2ki
	jAI04Fft4omK/EcQkNwQPfs6AR2MtHO6ipeHciUi+Sb00GPbnCX8vqbVrOAG9iGWlMyIZ0
	m7E5wNoAM2+xsH7DuantRlcvme71KWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643039;
	bh=CxIHi84E4Pt5K6l2BuyDuvOD5HSJpAj9jMAXhBrWhPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KWo7sg0HDLVwuJxbMVa0QVJzurgJIyDK1zw+ebn5phBhr3C7MAG7cMyz7E3fh1y4e
	 avOz7YrsLk6fYH4IO4FdkTI/iNgikB3bVS59fqSLrIm96xlRBup9wuuqLoQcjwrxJc
	 lbH0wPaZH2bjA7cpHu677LiCQ4taEjaAg3HuaoXc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:43 +0100
Subject: [PATCH 08/10] um: Remove __access_ok_vsyscall()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-8-e930063eff5f@weissschuh.net>
References: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
In-Reply-To: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=1320;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=CxIHi84E4Pt5K6l2BuyDuvOD5HSJpAj9jMAXhBrWhPI=;
 b=indsseQNY5fyzet23byGMfRz3iZPxGotar2HG8qPmnBRDzv8C40nHyUQRT0Da3oxy3nlZoEEs
 qs0pIYidKlJBq6P+Kh9ASIbrA6/scKN4tp4chTLKNoVkGLy5/Xl70ij
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Queue-Id: 22CDA80008
X-Rspamd-Server: rspam03
X-Stat-Signature: sofe6u1ue451xhar5k8i18n7cmtkfafq
X-HE-Tag: 1761643044-514694
X-HE-Meta: U2FsdGVkX1+B1Ne0JTKdLIEy/HZN6DnR6BQBj21HI0T4yxCx5y6i9Pdr1YpT2N+zVgWrR23RuX8BiR3DSrwIS7T3JF+Beb1OmkDPZMiGkglrMngAytuzaSl9gtPZdkIw8R/KGXMrb6pLMiGEv3y6AGKq1/FtyStuD8rI2UaErqSCZjFd2r09iWK2+gvWAEycyY4n4ukI9cBKYHshl2kn2lE6sFF9iRgmw2AjQVTOP36RvsItaJTmLJJldQ4sHF5GBETXeppZh1xBcrGy1Vizdo+MXeAXHsuqfhCEgvM9dSKkwrcgqTSTkNZ+0Z4/Iwl2Y9JJPGJTHtPpt3QaMdvbbQuiXel35W83JDAJJ18kCUp079YxsoHbjLTU4hysDxrv/GzC0A6S4urWPgUxVqVfGeJ4X8stDSOaANc32DOE8c8PZquTj/R+zx1FtUWY9c7NenDk7uj5jQWRStwGfMX3g53Dui8xeXX1rcJirgJP4ft53Tl6vLw3KXSo0jX/+ay5o6gQmZ9qgA+FuKOTsxxNlrA9DgFQtMrne+RWNTPCJ/WDwwSQ9ApbgpBZqWTR9tjr19kZ/8MooOTJtSgtunUEDxNzsDHfogKklJVrGGqMwfrqrr91rw0B6KqF1UbCxuQyJGrXiGKq29a/xJGts0SXbCBySp9gOePAx4nymJNbTG3ZZObNz41I4X1XMLs/R4xuTtAUCitjaaaCkcq9UK1HJEvGxZbPyNzFb4MkigWBFFFx9pDJ3DFJniEAVAHNYA7s0TQex3qXjcsgzakSVuUSxshN+m3++7CFSHt8YljcPYO27d0Q9aJH2KrlUYpiOMhcG6xZholPsjRHGgBZABavUrDIALkvY3t+hlJG549Vjut4X9qlVBkP7OGP8yPOpgwj2QElbBWywY8KV9h1H6I+NAC3CckuuHQWSf3qD+0YXpEYcT+5Bn/Q3VA+nu5Z1p0mLj1+LC9lloThBx40utK
 GxGc4lJ4
 CD+z97GWsL5FrcJZpeRlRuxpaZdBHZaLyT2ofll51aZTKRwTazA3cKUQxxSvhcb9IOBNRNcjtkzRGw7OUAGqU4F7MDU7fbPRh8oOe09ivdarVdPAqP325g6eK/2SSqGxSHYvJWSZpTrVjGGw7qpToOAeqBrD175HiHRVaIuGnSNPvatxIvtdbpLFLgbPSbvmRPpHRJYAWVM7tRt1u7ZaG2zelQVivxOQMzsPwPHdA60gOnGST7zam+gmO08KESPd+Mm9PvKhTTBduz+icE1l4jQBxQfmgtOp+n2SoEULXLGZHbSnKkWxjxHnzi591NmcV9S70nU3H+ImJxKOQGkVEZNjNMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FIXADDR_USER_START and FIXADDR_USER_END are now always zero.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/include/asm/uaccess.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/um/include/asm/uaccess.h b/arch/um/include/asm/uaccess.h
index 3770bdeee100..0df9ea4abda8 100644
--- a/arch/um/include/asm/uaccess.h
+++ b/arch/um/include/asm/uaccess.h
@@ -15,10 +15,6 @@
 	(((unsigned long) (addr) < TASK_SIZE) && \
 	 (((unsigned long) (addr) + (size)) < TASK_SIZE))
 
-#define __access_ok_vsyscall(addr, size) \
-	  (((unsigned long) (addr) >= FIXADDR_USER_START) && \
-	  ((unsigned long) (addr) + (size) <= FIXADDR_USER_END))
-
 #define __addr_range_nowrap(addr, size) \
 	((unsigned long) (addr) <= ((unsigned long) (addr) + (size)))
 
@@ -39,9 +35,7 @@ static inline int __access_ok(const void __user *ptr, unsigned long size);
 static inline int __access_ok(const void __user *ptr, unsigned long size)
 {
 	unsigned long addr = (unsigned long)ptr;
-	return __addr_range_nowrap(addr, size) &&
-		(__under_task_size(addr, size) ||
-		 __access_ok_vsyscall(addr, size));
+	return __addr_range_nowrap(addr, size) && __under_task_size(addr, size);
 }
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\

-- 
2.51.1.dirty


