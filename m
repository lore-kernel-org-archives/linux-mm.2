Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959D5F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FDC6B00A8; Fri, 10 Apr 2026 08:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B706B00AA; Fri, 10 Apr 2026 08:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A476B00AB; Fri, 10 Apr 2026 08:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C99E46B00A8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8965B13B05E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:22 +0000 (UTC)
X-FDA: 84642551364.06.73CFFCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE6BE20013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VM13lKS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823561; a=rsa-sha256;
	cv=none;
	b=tPljqrKkL25ufwSHO6frPw8EjFb42+zpnmBzv8gKAk3kpYYBsIxtds1XMmM+w1MIVjP5Zo
	RKmZEfiufEsJ2ElLIVulaslGtR9XhPzzfHrB+osREe0AFXQyqSNwb8cKBj/LpcoRtfJ5E2
	CboiQ1PyVrzhLNoeP983zLyVgfj89Fo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VM13lKS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=M9a5EG3CG8Udn3B7jIZCxrZ3k3coZbiW9xz1Wj8kXaE=;
	b=h1MpUkBFWFezcBGKNClg5F0nPDHtctjY6aFxylFCH7UDLH6TNnjB1lUxngPWbrbGihZPct
	5l9fEI+Q9BJt0QVxDEhthciRo0YcwB1zsmm8ipKKb77O/W1DyL8HRxrDbE/q+mci/wbX0Q
	oLFw3/o307O4B3xBCeNG2Jwp4Xp41C8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E547D4047B;
	Fri, 10 Apr 2026 12:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E7C2BC87;
	Fri, 10 Apr 2026 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823559;
	bh=p4ul6fecafqSjuz/HWiW1SqReHpNi3SQC1heaf7AtH8=;
	h=Date:From:To:Cc:Subject:References:From;
	b=VM13lKS0vi1Fampzs2SOJUSl5pFNtZPRrbRXrfYUkEg7syYn7CVko7c7egIdexCfj
	 MaRLNlopnK85+N7I7i3OZHuHcMdHWNGNdlJV5bSYYI//COctIU1M1ukOOe7R86fGRN
	 QQ/j+jjVi+CYY1R1j+UlDL84K4FAOhCbq1OrkH36o+f5XviRftg90dsfUTYhZvjNV5
	 hk3/t6EuYClXGdWJA1CVm0r4gv7+Uuy+bWtd/uVuLx4/iO4+bV/Z+fKbXLcG7tmKkB
	 b/7xC9trAvx6oz1zNsW6Ny9Eav33gyvB9AokHXFATxUfQATArxGnp5TkYcwejIeG8o
	 hkZquPfDoH+3g==
Date: Fri, 10 Apr 2026 14:19:16 +0200
Message-ID: <20260410120318.253872322@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 10/38] arcnet: Remove function timing code
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: qdu3wam9763zf8pzweuqbwuonrrjuqfh
X-Rspamd-Queue-Id: CE6BE20013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775823560-925863
X-HE-Meta: U2FsdGVkX19LW1AtOcw0OnIEbUyKnj8WbOtLg5e4wdF5rUcJbUxhs9t5STsMg9M0O9kz6FSQwNncTjv2sY/D3JEz66W9Un9wCY4i8YIkbdv15ZEbqdZJufAIAkh+8miRXJGWtb5G/6WMQNBy6S1SAlknVxJ2JmdWLRh4KFDuWnzHWH2tQLy00zW+LGQUwpKtWE+ruyNV0OCbQZuY78PWiAGBu/H73x05kFbNbHlg0j/8g0gmHm6tbwllQuUaqDjQ/NsBOYOlUC+KUl/nwoDnlzt2Ab1D07P4gHj/tj7Fgf6cOplztnvxWsuHmpjRvfx0X1//3pwNBN5Yv+vJy8/MJNz8QloADtr3PSWDF02PJEv3vMoCmO3OwGienZPpEIVw6jhx44FlaDZ9kKhu+pHxyUyS2v0u36qUk0Q+7SNqmwpCzgIA5bDwlXTpSp/KLAMVCZJiz2YOZUVV0BS5K1jLIlh1rhCt/2DasBl4meU6E654SLJjWuMfIhijeWgT7Gu3SLXtSBVSYd1K5+8N7r5owxyvrW6mkyAChyDwZdlbpMtzXuBlHRyf9zdmbS+o++a5V4bDskm53TfpEddGCCRjdbxHYszgKV5QUA5apguBFF//YlYhdUlvRwy3PGVGvhq6J8YgzOkeXrjjtoI3XbUdio8RnZ3c3Cuqx2DWNrK7ImvDrWLXLT9KaUwutLuy3z0yr+1swc1ccfJpKNcHYPUNPfMMq0fsqXOKZHViyNaPQqN/IWL9mQibnaIvuSkryYuGQo85y2YuzX9Gu1eJIMsfIaprZ7e4MpGZdntqppnrZflCWyfTv5GeTsi5guhkrUklYNbx4n5vPcuQziBw/Bfz+04UDFsQkfF4fxp4GTPOiOZ45jTYOf8A2sghgkNs1TVoyVcNoTJfuFV0fy+LPGqUGsaR8DDhSru2TdZhNF28W4qNA1jx5Mzt3jWMRS/U6RYQuK8knk35WIXPgr/pz0I
 ml6FR/Z/
 6TADqOlOHeD/iZh35qBOjKv2ITZfEeJoJGrXuerMDSfz4zP57Ht/UNjGnbzqZxH7rdJxpmObZtD/sA3WyWGZmvfng7MX/LRxrfpp6jqgCOxsWAqF6yQjXd/pzzYGYSggV9x2TIYw01GyFzcwKgpFYFJ803lRpzWdwRkqKPXLP1pmzS8pU4UtVDrnHOo8vrxUlibYw9a5ZK5uoUdGOmPSv98ldV35RuDefCaw285Mr75MDGxVCUTeSYjivbIJ8ndI5YbVZbg33Fenfjii9MkUL6Nmy4pNQ3PuBZQnPH1abJV98C3OVGhowrT4AD9hz29Bqbldz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARCNET is a museums piece and the function timing can be done with
ftrace. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: netdev@vger.kernel.org
---
 drivers/net/arcnet/arc-rimi.c  |    4 ++--
 drivers/net/arcnet/arcdevice.h |   20 +-------------------
 drivers/net/arcnet/com20020.c  |    6 ++----
 drivers/net/arcnet/com90io.c   |    6 ++----
 drivers/net/arcnet/com90xx.c   |    4 ++--
 5 files changed, 9 insertions(+), 31 deletions(-)

--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -291,7 +291,7 @@ static void arcrimi_copy_to_card(struct
 	struct arcnet_local *lp = netdev_priv(dev);
 	void __iomem *memaddr = lp->mem_start + 0x800 + bufnum * 512 + offset;
 
-	TIME(dev, "memcpy_toio", count, memcpy_toio(memaddr, buf, count));
+	memcpy_toio(memaddr, buf, count);
 }
 
 static void arcrimi_copy_from_card(struct net_device *dev, int bufnum,
@@ -300,7 +300,7 @@ static void arcrimi_copy_from_card(struc
 	struct arcnet_local *lp = netdev_priv(dev);
 	void __iomem *memaddr = lp->mem_start + 0x800 + bufnum * 512 + offset;
 
-	TIME(dev, "memcpy_fromio", count, memcpy_fromio(buf, memaddr, count));
+	memcpy_fromio(buf, memaddr, count);
 }
 
 static int node;
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -11,7 +11,6 @@
 #ifndef _LINUX_ARCDEVICE_H
 #define _LINUX_ARCDEVICE_H
 
-#include <asm/timex.h>
 #include <linux/if_arcnet.h>
 
 #ifdef __KERNEL__
@@ -62,7 +61,7 @@
 #define D_RX		512	/* show rx packets                        */
 #define D_SKB		1024	/* show skb's                             */
 #define D_SKB_SIZE	2048	/* show skb sizes			  */
-#define D_TIMING	4096	/* show time needed to copy buffers to card */
+#define D_TIMING	4096	/* Not longer supported. Use tracing instead */
 #define D_DEBUG         8192    /* Very detailed debug line for line */
 
 #ifndef ARCNET_DEBUG_MAX
@@ -95,23 +94,6 @@ do {									\
 		pr_cont(fmt, ##__VA_ARGS__);				\
 } while (0)
 
-/* see how long a function call takes to run, expressed in CPU cycles */
-#define TIME(dev, name, bytes, call)					\
-do {									\
-	if (BUGLVL(D_TIMING)) {						\
-		unsigned long _x, _y;					\
-		_x = get_cycles();					\
-		call;							\
-		_y = get_cycles();					\
-		arc_printk(D_TIMING, dev,				\
-			   "%s: %d bytes in %lu cycles == %lu Kbytes/100Mcycle\n", \
-			   name, bytes, _y - _x,			\
-			   100000000 / 1024 * bytes / (_y - _x + 1));	\
-	} else {							\
-		call;							\
-	}								\
-} while (0)
-
 /*
  * Time needed to reset the card - in ms (milliseconds).  This works on my
  * SMC PC100.  I can't find a reference that tells me just how long I
--- a/drivers/net/arcnet/com20020.c
+++ b/drivers/net/arcnet/com20020.c
@@ -70,8 +70,7 @@ static void com20020_copy_from_card(stru
 	arcnet_outb(ofs & 0xff, ioaddr, COM20020_REG_W_ADDR_LO);
 
 	/* copy the data */
-	TIME(dev, "insb", count,
-	     arcnet_insb(ioaddr, COM20020_REG_RW_MEMDATA, buf, count));
+	arcnet_insb(ioaddr, COM20020_REG_RW_MEMDATA, buf, count);
 }
 
 static void com20020_copy_to_card(struct net_device *dev, int bufnum,
@@ -84,8 +83,7 @@ static void com20020_copy_to_card(struct
 	arcnet_outb(ofs & 0xff, ioaddr, COM20020_REG_W_ADDR_LO);
 
 	/* copy the data */
-	TIME(dev, "outsb", count,
-	     arcnet_outsb(ioaddr, COM20020_REG_RW_MEMDATA, buf, count));
+	arcnet_outsb(ioaddr, COM20020_REG_RW_MEMDATA, buf, count);
 }
 
 /* Reset the card and check some basic stuff during the detection stage. */
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -332,15 +332,13 @@ static void com90io_setmask(struct net_d
 static void com90io_copy_to_card(struct net_device *dev, int bufnum,
 				 int offset, void *buf, int count)
 {
-	TIME(dev, "put_whole_buffer", count,
-	     put_whole_buffer(dev, bufnum * 512 + offset, count, buf));
+	put_whole_buffer(dev, bufnum * 512 + offset, count, buf);
 }
 
 static void com90io_copy_from_card(struct net_device *dev, int bufnum,
 				   int offset, void *buf, int count)
 {
-	TIME(dev, "get_whole_buffer", count,
-	     get_whole_buffer(dev, bufnum * 512 + offset, count, buf));
+	get_whole_buffer(dev, bufnum * 512 + offset, count, buf);
 }
 
 static int io;			/* use the insmod io= irq= shmem= options */
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -633,7 +633,7 @@ static void com90xx_copy_to_card(struct
 	struct arcnet_local *lp = netdev_priv(dev);
 	void __iomem *memaddr = lp->mem_start + bufnum * 512 + offset;
 
-	TIME(dev, "memcpy_toio", count, memcpy_toio(memaddr, buf, count));
+	memcpy_toio(memaddr, buf, count);
 }
 
 static void com90xx_copy_from_card(struct net_device *dev, int bufnum,
@@ -642,7 +642,7 @@ static void com90xx_copy_from_card(struc
 	struct arcnet_local *lp = netdev_priv(dev);
 	void __iomem *memaddr = lp->mem_start + bufnum * 512 + offset;
 
-	TIME(dev, "memcpy_fromio", count, memcpy_fromio(buf, memaddr, count));
+	memcpy_fromio(buf, memaddr, count);
 }
 
 MODULE_DESCRIPTION("ARCnet COM90xx normal chipset driver");


