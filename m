Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0939DFF886B
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702316B0088; Mon, 27 Apr 2026 13:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2546B008A; Mon, 27 Apr 2026 13:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2BA6B009B; Mon, 27 Apr 2026 13:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE576B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:18:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC604C118B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:18:48 +0000 (UTC)
X-FDA: 84704995536.03.9298429
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F27FF20014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:18:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YS9v5ort;
	spf=pass (imf03.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXNNHxOKJNxC6UbQGAQkWPTYQLhbBO1PUuIbA1i3jbc=;
	b=vnAyhEBFSnd3sxQKiuXLZgkBffc/RAehW9CMlDgPg0g/9X8b1bfNMxkEYdPyPm12VzC9K7
	MDXSf/hFYmllHj45pZQQJkriuujY6Rkdv1c2ewGE5X5j2dlyCnPIKh+CcjQPv7xY+r4fss
	e9W9GlgBa5ucHOEHF7ELav+JQbOT55Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YS9v5ort;
	spf=pass (imf03.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310327; a=rsa-sha256;
	cv=none;
	b=NovQyuLZBVnlkETbqIosnXPjAPEm71Gw+st7aUBq4EeE5tHPr4LB3Iln4yUeY37AnbH5H0
	XGWY25HaPhdtm6aVo9ljyhc2fKUwgtn4oAuXBG0bXcashbZXljZfW5IG/PMIGCbJop7EGg
	Y8f7bZp1PV0Mt1YXwvcoNDsY7oI9eIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E16F243CD6;
	Mon, 27 Apr 2026 17:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5390FC2BCB4;
	Mon, 27 Apr 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310325;
	bh=x+yz+Ptlr8yUKihbRCrYsj2OzN4+HDHdWj3mTkeeywo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YS9v5orti9jIm2coPKy7cH4iQCLjTYOH2T4kGrmAKw1lk2UpD8UcWDut4XHtMo5CX
	 290KHU3PNOVzMmnTKEL1o/OfzgOnzBVsJnbuGicRbc3HqjVsrjLo1DZ4Ncwz6tafWZ
	 SG8/hG1Ct8pUgSHrDrW4chwaJ34uCldA2tlOQo4bI8M4kMxsW5bP0OLNOAC7BeTwPk
	 Mil/pgBJA2/iCGWwmbEh5WNZZrQ4Md/gtqmnREocwFdhobkWjiqhIB30lRO/GV15k3
	 DZOePxOSt4vdcYmGqKSVWX7R1FegGyxqEmqkjMUEcFWkKzHsBpXNo8/6bbP3EGANbq
	 KZwGUUWEURiLg==
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
Subject: [RFC PATCH v1 6/9] uaccess: Change copy_{to/from}_user to return -EFAULT
Date: Mon, 27 Apr 2026 19:13:47 +0200
Message-ID: <1a55107abe15dd78450888e2b5327c3a56af29b7.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2416; i=chleroy@kernel.org; h=from:subject:message-id; bh=x+yz+Ptlr8yUKihbRCrYsj2OzN4+HDHdWj3mTkeeywo=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxkjryH88LzkjscmK202zhcwuOPhcJTlidTVNdtCP 9vs/VPG2lHKwiDGxSArpshy/D/3rhldX1Lzp+7Sh5nDygQyhIGLUwAm0nCN4b9/yT75hpDtr4zk 9XPfORmtVO2p/XH+8bFg730PPNfMvn6dkWHDjsJSC09Vr9bDobdrxTgfMm1ckveKR+Rkud3skLM HLXgA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F27FF20014
X-Rspam-User: 
X-Stat-Signature: pnf5zt6ahmdx5wyoco61666g5iwi477r
X-HE-Tag: 1777310326-476587
X-HE-Meta: U2FsdGVkX18H5eTmtg6pGbK8K2bQVnBAw1RoUr+exf5KE5FPVzPVWHwLy6OfN+LQaRTy1kTQPzQBhCdUMa1uU3f5GQYdVIE+t1RDd3oBNWtrFyeOQVAXGJPSP5la4pnBC0tqGz6tJtnxYf5hk/wCPDwiLLe2ZEbGUI8eTK7OtIn/ArfaKnbLow+T1P8IuvBVjdwFt+DBh0o1W5GDDb7f48XXZtchScYbJRK9Rooe1MqtmYLAlhI8zoan5ESN+pQ9vUkZMhS2djKlaZPH8d3oGKBjHDogCCsO6gN4foLLGyCywOwrpVjlg1lBfEzzdq2FyTYzdfJeXqRV2ROavKu1ObgemvQh7BzPfoVp+GURar4mYQ/2MAheXHQ3vJkNhaaSIIFUrKrL2eFNJugmcqao9xCAT6HTB1Lw2wvNdJcEWJ7wFiedIebXrjzXFms+mYASuJXewqEDdoBQT4PsOFRydBm/YapP51PC+XdiC1eb14m3Ag6wSpV0Uo9JXkw9tGvGYNURf+tpYVzgEIs6H+QvjIUrbYyqoF0ILMCVCBMV2nHfpxtbokn0FTSj8/Jv4G6sfNGVB1nnI1ZOUJ3FchTefVOwBpF0onD0JDU4GSAcHcX8+iJ0cujywwWNd1PmVVXytttP6fXop5LJk81PPDFUn6W90TRUmgfv/ediAVzbypkEpQcqHjMqS+2YR3pkzDz0kaWY4oZbG0Xm+V+XSOwB6hDUBuuFyHzI/y6baqXes656RaVDy69HXdyNA1q8INFUQGfmHlKH90HTOgMwFc3tsrcAzS9vGSOkNxy0SxEg5UaKv6uuqBLYJjyi1lcyn1CQ7pdXsuBfaY9RNbAg3OpngFviMIXnULm5jNLdvVyB2u4HfWMvHuh9Eydjji4g4oXmtWja/qJdsbS+pPF5xDj3HKRyt60Y79v/9wSXbVYi3XGL6APJPEEHkp3rgtJlJ0Vw1ax8IdBRNWZ11pURonS
 o03dc3on
 seJ8ImEwXEssObTI+UKI2c7CvVsSJ8hnIKgRDO8rkATtuKARBb1XJBX9Kr96BCQairFPCQDpR7MoFHZCngkZvRugp9JPhg9A/27uPt/BZO+hlNSaWRhiOYnpKfRvckKHPUDhE+t2XUss5FZfidrUBhPfVtnlUGHgUlBA1LfzBDNCxm0mCGd8pC5O9u50fYVSGICl3Md1Bqc0oDroc9unbx7MjGp4W1DLmVWVcF/2TWAyoZnSWCon7febG8GFj7kzcjpYFmgsu1aI6dctcilUeSWR0RyvUgkXNBkX0owQRBiI/4Wy4N8yAPVpORsuqmePUjbrO0SynnvuKlbeCLzu37y672tjVERs1Qxon
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that copy_{to/from}_user_partial() are used by callers which expect
partial copy with number of not copied bytes as return value, change
copy_{to/from}_user() to return an int, and return -EFAULT when the
copy is not complete.

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 include/linux/uaccess.h | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 2d37173782b3..33b7d0f5f808 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -211,7 +211,7 @@ extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 
 static __always_inline unsigned long __must_check
-copy_from_user(void *to, const void __user *from, unsigned long n)
+copy_from_user_common(void *to, const void __user *from, unsigned long n, bool partial)
 {
 	if (!check_copy_size(to, n, false))
 		return n;
@@ -221,10 +221,20 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 		return _inline_copy_from_user(to, from, n);
 }
 
-#define copy_from_user_partial copy_from_user
+static __always_inline unsigned long __must_check
+copy_from_user_partial(void *to, const void __user *from, unsigned long n)
+{
+	return copy_from_user_common(to, from, n, true);
+}
+
+static __always_inline int __must_check
+copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	return copy_from_user_common(to, from, n, false) ? -EFAULT : 0;
+}
 
 static __always_inline unsigned long __must_check
-copy_to_user(void __user *to, const void *from, unsigned long n)
+copy_to_user_common(void __user *to, const void *from, unsigned long n, bool partial)
 {
 	if (!check_copy_size(from, n, true))
 		return n;
@@ -235,7 +245,17 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
 		return _inline_copy_to_user(to, from, n);
 }
 
-#define copy_to_user_partial copy_to_user
+static __always_inline unsigned long __must_check
+copy_to_user_partial(void __user *to, const void *from, unsigned long n)
+{
+	return copy_to_user_common(to, from, n, true);
+}
+
+static __always_inline int __must_check
+copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	return copy_to_user_common(to, from, n, false) ? -EFAULT : 0;
+}
 
 #ifndef copy_mc_to_kernel
 /*
-- 
2.49.0


