Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D0CFF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43F86B009F; Mon, 27 Apr 2026 13:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1AE96B00A0; Mon, 27 Apr 2026 13:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C316A6B00A1; Mon, 27 Apr 2026 13:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2E676B009F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:19:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4540C87919
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:27 +0000 (UTC)
X-FDA: 84704997174.19.9D93122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8FA3CA0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8kV5Zhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3Z/nVyoovIhD0EOyurWXqapA3Ve0yAERyRow/fU/M4=;
	b=8XoQKhWJWzEwIrZVnV8JWOavmms38VsfXqj04d6tmn9yAW13c+GGOKR2vrM7HACT6lvgG7
	wir8riTy6JOtzQoBO5fSLaoj1qAd2kUjcVWDfT8/+W0e2wvK2iYo8RBxeAJW/s7MdgXvg5
	nJrCWVdHGL2ByVqg6urM4mJcvIc5y+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310365; a=rsa-sha256;
	cv=none;
	b=pkQIO0IZQApXR1BemijBw0hcNNum6y8bSJR4GDym7L30AhvfXvdNHcngPM50N3sLs98uaf
	gyUgUrxNktnRSAw0xVNPASGDQ+unUzfDhoGgckV7zypVmV9fjb9+XMK21D+RSvD6Dtw+4M
	eyygWoQaFCI8Rfjj7G+1FYotnsniKqU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8kV5Zhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 180046024D;
	Mon, 27 Apr 2026 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25EEC2BCB7;
	Mon, 27 Apr 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310364;
	bh=xblTv37x9V4gU3cvmA9ILfz6xXNOv0sNe2zU9C6a5nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8kV5Zhk7HZbxy8X7mxqUL5UgTTJPPuuLtSKHKOe5PwbIiNodL9/7ESxRbcOMv4dB
	 NN/pd897F5mMQZv6MW+RM/3mikWvqmJGQCtupbd6YHiobStaCQu79RRkwt3Bs1rL/A
	 WmXtcy3vIzgejB2MGSu6MrKJ33itreKKdFlemNypyCUExoUHGXA1bHbqFqaNX4ujdd
	 iXZiXWTV/w69yfgs2V8e+zdWAilhhtsvDDxzPIT8CbbievjXPmrPwVloE5aoqLKmYP
	 ca2+sf92YJQm2mLHcpyNlGd6mMQP6QhUed6Hx8vk/CloBjO7tSgz4fayv+CeXka+Fz
	 NwGM6tvALNVmQ==
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
Subject: [RFC PATCH v1 9/9] uaccess: Convert small fixed size copy_{to/from}_user() to scoped user access
Date: Mon, 27 Apr 2026 19:13:50 +0200
Message-ID: <8780eb2ef80575931a339e5225bc80eb13e9be6c.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3638; i=chleroy@kernel.org; h=from:subject:message-id; bh=xblTv37x9V4gU3cvmA9ILfz6xXNOv0sNe2zU9C6a5nw=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxlr/n9yu2DE7uwkCZGbl0uCp6Y1JLvZTPpz+P/PY xNqPMoaOkpZGMS4GGTFFFmO/+feNaPrS2r+1F36MHNYmUCGMHBxCsBE9HwZ/ns82Ho9PV2Q+7Pp 5fqvs6O/v3YN+3EgL+Wk4b/co1rlkZ8YGVZxmDl7XFiUcmPSTPW14WGSHT6/1u4pcTY2cjD0U7P bzAkA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8FA3CA0008
X-Stat-Signature: agwdrpz45gq866r3udokkdccbwn5ofwy
X-Rspam-User: 
X-HE-Tag: 1777310365-672777
X-HE-Meta: U2FsdGVkX18lMGlajTssOt5+X91TUFPVz1DPnLRfTaXo2uqdareyRd1+KUZPyYLzVziNN98fRSvJAbKfnoPCn0C0L3kxZZAO62Ck1ZRqSdJX21VmjoI0LS9MDnE8vyoj+nqooYomM2fAGgII0EDC0RhTDeyAlAigtteAUyWGmisXq2jyMHwace0m6KwRNPlRZ5rVS3L1CVj0Td5EAojmkmPpwkiYDnCPTbvoY80A/OtHjDXO2z+VczCLP0EQ9IypZJHuaKPbmHsVPy+A0nZY3y90D1ph8KqGMS3ns8wL5E0LZP2cOGJykV3OkvT6fhEv9jtVgcbck2TfTHebk5uYiZOcKmJKC+cl+YNT8xpVL1FyIaUlNsJKBILy4fT+jjMICI0Z9yMYh0EzF5cg6YIVOsOfAjGm6PaqNCLarC9wk0k0Y2oeUFHzqoOMNxbDUT6BF9PBmtJMndjrHHr/hZlBmE28ZVXXDkuXlCMSt7ZhhtpVyibk4pCNw4lrUuHGkTRHtJ9ltNhbtRZElPPHbAdf+5rUFqxezXdO/hEZ5L0enCKVujon8JIRXpFf4dgUxGw7ceW1+XlfK1ayC6oPffwm7jEGvnjkQmZC1LXVP+mHY0Dkap4Jzxp+dPQwRqbKImWvnECuFvVEh3o+YKDD2/4BLZ7P/k5M/ijHSpXRh/+wba5VbyG7hgWIqQ7jRNStxPlGbJwi4r9Ud4ZMXAp79NWG8PaVPYQzsoq5DiTTDRJP8uRQAMbjsUHyMcHnY0DWYpvxzvQwOu2JTs4kbV987oL47+df9Yn6gE+hNBmXeelkCxsdRdLxBzydd/MFBDPkBYbm59/R+hz1sRJUY1sYfXtDjg8KLqjSWgmK33rh++cU/ymlDbnARobl7pjjg8gAZpGlKS537NuklkYMhLNRUly9AydAsX+mPH61Fzy15nnqI2hnZUedN15nsp/nV1XZS6eSvBYOuvoju527fTK22kj
 60ByIHlq
 ZKOt+L9Cj/5m0aYrQicpBKyuEL6dseWIJsAatPPhoyrfmjoAUAu25mWonFqRgFtMt9XoHHpfHuLOC6K2Z2gXIDnvNHGFmFfqNV0TNinxHs6NKPUptHwAgcH8bRfWdR/ml/i+D/VDmrZtKJcXRS1en8U9+P+yQ2r1nIWzS20JYnSbezMddRXVgzJoweKqmgZtqbbg034GSRa25FfLOUG82ksgtG3tmlcwRApiAfIIHtsQjJ+RmrzTmcd+/6a/zctPx/SfUDSjPicJH6gc47GRjtVRl7QhWemwT/PTWxYOHHVwqFPx3lEFimRe+UlMfjwqEejY+QI3wWxTvGoXaQstNgU4ZpwVMsXv1QrgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_{to/from}_user() is a heavy function optimised for copy of large
blocs of memory between user and kernel space.

When the number of bytes to be copied is known at build time and small,
using scoped user access removes the burden of that optimisation.

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 include/linux/uaccess.h | 47 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 33b7d0f5f808..3ac544527af2 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -50,6 +50,8 @@
  #define mask_user_address(src) (src)
 #endif
 
+#define SMALL_COPY_USER		64
+
 /*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
@@ -191,6 +193,9 @@ _inline_copy_from_user(void *to, const void __user *from, unsigned long n)
 	return res;
 }
 
+static __always_inline __must_check unsigned long
+_small_copy_from_user(void *to, const void __user *from, unsigned long n);
+
 extern __must_check unsigned long
 _copy_from_user(void *, const void __user *, unsigned long);
 
@@ -207,6 +212,9 @@ _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
 	return n;
 }
 
+static __always_inline __must_check unsigned long
+_small_copy_to_user(void __user *to, const void *from, unsigned long n);
+
 extern __must_check unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 
@@ -215,6 +223,8 @@ copy_from_user_common(void *to, const void __user *from, unsigned long n, bool p
 {
 	if (!check_copy_size(to, n, false))
 		return n;
+	if (!partial && __builtin_constant_p(n) && n <= SMALL_COPY_USER)
+		return _small_copy_from_user(to, from, n);
 	if (IS_ENABLED(ARCH_WANTS_NOINLINE_COPY_USER))
 		return _copy_from_user(to, from, n);
 	else
@@ -239,6 +249,8 @@ copy_to_user_common(void __user *to, const void *from, unsigned long n, bool par
 	if (!check_copy_size(from, n, true))
 		return n;
 
+	if (!partial && __builtin_constant_p(n) && n <= SMALL_COPY_USER)
+		return _small_copy_to_user(to, from, n);
 	if (IS_ENABLED(ARCH_WANTS_NOINLINE_COPY_USER))
 		return _copy_to_user(to, from, n);
 	else
@@ -838,6 +850,41 @@ for (bool done = false; !done; done = true)					\
 #define scoped_user_rw_access(uptr, elbl)				\
 	scoped_user_rw_access_size(uptr, sizeof(*(uptr)), elbl)
 
+static __always_inline __must_check unsigned long
+_small_copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	might_fault();
+	instrument_copy_from_user_before(to, from, n);
+	scoped_user_read_access_size(from, n, failed) {
+		/*
+		 * Ensure that bad access_ok() speculation will not lead
+		 * to nasty side effects *after* the copy is finished:
+		 */
+		if (!can_do_masked_user_access())
+			barrier_nospec();
+		unsafe_copy_from_user(to, from, n, failed);
+	}
+	instrument_copy_from_user_after(to, from, n, 0);
+	return 0;
+failed:
+	instrument_copy_from_user_after(to, from, n, n);
+	return n;
+}
+
+static __always_inline __must_check unsigned long
+_small_copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	might_fault();
+	if (should_fail_usercopy())
+		return n;
+	instrument_copy_to_user(to, from, n);
+	scoped_user_write_access_size(to, n, failed)
+		unsafe_copy_to_user(to, from, n, failed);
+	return 0;
+failed:
+	return n;
+}
+
 /**
  * get_user_inline - Read user data inlined
  * @val:	The variable to store the value read from user memory
-- 
2.49.0


