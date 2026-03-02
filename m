Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580B6E9B371
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20E16B0089; Mon,  2 Mar 2026 07:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEA26B0093; Mon,  2 Mar 2026 07:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0316B00A2; Mon,  2 Mar 2026 07:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7607E6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:32:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15DD2140BFD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:36 +0000 (UTC)
X-FDA: 84501061512.24.2E62872
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 178DA40011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUatCUMGjSOAYdWwYL9kAf5S0UMPuz+Fx84eRD4pGU4=;
	b=0CKuVxyH24NhHXyyJKyELMAtQsls/q81iYNQ60SnO5tWVTa29Rkv19aRXdpLLM1Y6Bwqwe
	XhL20+Cm9FBMsXJarRgzpMXi0jvxdImk+1FOEQ0bDs4X2SjetQX9PyY0//458eXqc0rD/8
	1iPZHjDOCVC+Sr2kLaJt/AavZU6V3mg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772454754; a=rsa-sha256;
	cv=pass;
	b=4sBoVwvyZVXvyfJCkXnImQqCcL90un+A61BqMVmgkyPTMaINZtQGP+AKD6UFGCcD+IOJZS
	8hWUUgMVKan5Onjx/XreKkhfmQCfumkVMZ6+03NPHCpVQ5P/79nZh7jsr7i3Pmec8o+Wwq
	gL66jQV1XJEvCVSzWhyWDb1IwmsWeH0=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93F9913C17F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:33 +0000 (UTC)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 650B1140C06
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:33 +0000 (UTC)
X-FDA: 84501061386.29.7B0F3C4
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id EAACB4000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:31:16 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUatCUMGjSOAYdWwYL9kAf5S0UMPuz+Fx84eRD4pGU4=;
	b=QY70Ke1FvQjYYWlDqmbY+g4bF1rV2o62UWZKVLGe72rjTo4UtY0T3vvoRpjjFRaaLW3wUT
	iZVokBNsydsyqlanum4fDrTX9NxiOTVgw4qFWJNvjSbc+Q3+k+JyMOwEQ2s7y02C6Bt2Va
	kAs0EFCU/3zLfukMh8kTUNNBzwDD4M0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454677; a=rsa-sha256;
	cv=none;
	b=vFSXSzd2rnpdsd1Lg0URV8jo7RpWkjJjGxdBIFpBkJXaAf32b7mJZPZABeBp3qncpzyaCm
	3aF0WStgypacGf/nTput+Bkwm0tag/jIg0/Hqle5eQwD7Mcl+K2hv6QDMO0ppfKqT7+YPt
	LPuMf2eJ92Egrv4TB5EDJ/lDOOxmTHo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=MW1bGCsS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="Glqb/iX5";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUatCUMGjSOAYdWwYL9kAf5S0UMPuz+Fx84eRD4pGU4=;
	b=MW1bGCsS9DfO9X+v0DSKadvLFn+SWmk1pn+rddicrRlb+25XuZl0eJt6iP0G+BXg34cvQ+
	1Ypq8dU9/4H9JLtsbNLwN5Op4E1bl+T4qCK3Q+t4+bjDkmJqqKq1cZulRp0Q5bjxyuTa47
	wiRCfLK8Jy/Zk+I2mf8sQaKTwx9mwTzg39fMPaeuYCeMY1g5BgCHN7iPogP3geq0eUFj3Z
	1espng2OIo24NrTFZzZJjZfVEZhat3bTP91FgzcChTJq/X8HDD3/SOOdkrO038gUGid1NP
	/TG9xAya313yScFDighxypdFYvV3s2al8OVDGX6NMfe71/7TtA36WV+yKWJIog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUatCUMGjSOAYdWwYL9kAf5S0UMPuz+Fx84eRD4pGU4=;
	b=Glqb/iX58ImwLmydqxjJwzbHZqXKn5FJ/rKO/+KdO7fpIDILYZKeypk8G9y+WgL/AIWKQi
	8ZSn2D4OHrttUMCg==
Date: Mon, 02 Mar 2026 13:25:38 +0100
Subject: [PATCH 14/15] alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-14-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1621;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=1k5fCTPjgHXmT1wIddDgmvVMNFYPCfoGbNYiBvOaniE=;
 b=+emcoOjpmCtOGbRKRilDXun4wh9rZo8IxjTkm9zYNPepV3X+fcHLumuZs3KaZBdDmhAbmZz3X
 Sar6SiZRFKiDIiijEXUFkxsbjuuwCItZ6i5gyRlwHoXVec8Fv7oUaT2
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-HE-Meta: U2FsdGVkX18B61TOzWQjvX67ddEh4Bhm018HaHsuHRQgx9matsDbOMooqlpzSl2AeOWEEKFPhBg/lMgC68PC0U7G789xY/jE074a6lgoNBrbZRGnUwPG5WDxM7skh0vGs4um4q1VvvHi/3MJppH16RgnHDZqhyt+yT+mmDPu+kuykQq15qJUA9YLDERrckq3metDEUCoLPM1enyuFUw2AF6/X/2oQ0ZNq07OveFiqKvjy/Yt1wGKxu2MrhwFGRVuCUogdsZXuDrMg4wZ8oa8A0M/OgIXuBaDyChPXnv/PpeJJjSrNjwHpQFONvqzDDyg9ycdzGq6WRCEitT2Rw3PSpnTI/6N6tyV1QFsMtelVCwjsxtFtgJcFzpiVW/LQf0puQUEXNanlsR4jZcv5d7DCV6hwkQomplKobLSlkGo8DcIpnO9NIsG/QRfs5+QNMOD3/6LUdBfuezsVtm1I4NRUIfbNy3bDejRknkC1IECIiUBJT0RChTfqkMaPlgUpY9cXWBZpVFMoPedF+LOyqVAnyTsZghTVvc24/fUyB0GTfU5MtKdkTiSNsxrFcBWR8Qup7f001EAlzVu+orKO9RaubNi4t6QbVjO30C0CIf0HUrJz251rhrsN07IYNjDR90r8oi1oUl95krnLS9xTZe0Ltc0oVS98Qj4xvfoNvYeGr1zLM9tWlBWGpCdG4XJZ6lLGinB7iChX/c0qbDiNbKSA954dv8COFNtgVBAJCth05yKaePQhH1JLhhCQWEt8ooL5O2BCRM97W3x6TLpf1eT9zEeAH2TE0/tNjZH+mXOzoWVRH89z9d6rPorSgcQuUbq7j4K6awfCgvHg5gs7Gpvwv/N8uxoS31J+Ho+CqK0xDm2mTmE2RG/HeRJJWc7+n0RRAzdbYaPE1S1ihk1Acu/4TXzq8dCf/LGRtw+Qa2Ok1+4ZKA+d9lIeVSFtPaqgEP42yWBhV4+Ja2u6+n5n0c
 jOI/lHLo
 w6kGdQLrXN1q35eWc4oooeVzVR1zGK/M6gTIR4dJkHDPge2BOPZHdxMJZhplOvs/fGD7TkcYri6r/GRCR+6ltzOHUaSWeIU+v1z5nbxNR89vYuC285ZA0xpzzftc1kA0PKuHeN9iMUIma7rHk5WCwb4+elcjhVYjRsxtTugeh5wNX74yFuhM67Yp2yFEoTijoLKOnNkiwZJjsk/zGwtbh08rsOJEIEUFCRTJkqK5s8d1wGCqc6xGrmW89SD8uL+E1ZqVlwhd1CWMAucxB6gvhkkEclBX7wenwYvR4IkXXuz6R+sDLB5tzufCgzkgn9tlD2o/Wk3KSO/a+JdhhRdGfLcno9uq0y2TYiyh2+hRsNUgnZFwFthhR/LEXE8Yx/NnzRh/1X3D0Wd/Ex1BZF4wzKJ5SBzhvbifjnjTggmfLAqs+MhQDtI4Ik9gXkYDhKO0/qwiHkqQBAs8O1xyfRfKyY2ZLEJAt96JWSBx1CrkG3hirKBbl5iqa2WSIMvKKs25aJvz7fnSqZIluom8=
X-Stat-Signature: ykbjb64sxo5cokr747wkckrqyt6gzotu
X-Rspamd-Queue-Id: 178DA40011
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag-Orig: 1772454676-550703
X-HE-Tag: 1772454753-789102
X-HE-Meta: U2FsdGVkX1/ousgzmB47WyuxcCSgRw+C5A+rsEu8Is5XdXjcmzq+oHeFlf5JfywG1wFHH3DnDndhH9l0QhYXMwz6xOQRdUoZ0RfjOQf7hKYrGeBaS6FCpqhtxO3XH93e8RTpr14cXGjE/blE5cNTjPyzFYcvDQQ4WqGAlN3wYGzkHunmB+4TZJ+CqTs4ZNBhC69NW9jAL9my01Jqso6DCE6se3fWx+svDnpGrjNBO7ZapHc9L43kPolxX84iUSfffSmHu6qJHZOD3BsIg3GTG777+8e8WcCaFzmmBBoeKcK2+E/uedbn/wvQWCM2adnrD83tFN2zryKPkGmHzUlEeuTAZebdDZBUXwdkPeOKt1X9Qd8swzUc7v7ZxCEp10YMHOTc7KCIjRDsT7aKD0LUt7rhoEdgRRtfAyJCgYlwThbg+ixJWW/vd8hEyLg5PriMMb9T7niEMnxuF/OmBqE7roG2e+KfE7cXZ3MIMaG3hgFWVOXiUBzkM6j9x/6n8sfKJ67qq+0ZClyoeaaWxQcdcLmIonY856U2ljJhF3d6YIAoMngSFPflf/qdLlORIsyDrjhmw8R1Lj3g7PiAs5ri9YGWC2DjTh1KYZDT9cVMplXklVTKQcaAtVJZGwI1I/pQyrYaK54czHWLCrPS0MkXYVx8DXiyQ3wwyWlhLPMl5svLWu3bt0F1OfxzPnFtPkm7Qfrwkt5Lz4IrcvAl75dcyVxcrWokJ8TEsAhL6HXRqRZuD+BzuT11ErKRkM4E1aX2rVKC62RnA2O5EU595QSm9/LdH5gX8QLFnz1q6mjMFYrV04hjg0Qh1vNfnRgVZsQURpQXAd2RU5QE4C65dNBu3v09nf8ps3aOkGIRM7PPBhMuy84aGwnFTjg/KQ3OCGsGKoYaLF9E5cn/wLLmzfIUwWTqLdiBNr5eWeVRWNYZOkIKFCB1rHjn7bmD1mvIZuB45ugLAeZyzWJEvMmfHDv
 FPUlPvkm
 QXrzybs96ylE+U8LHayxHznhm0Jeqpccjil0HXnOLLW6YT8xxpPF0OJDj1qQ6xyAAcwC5UGrWYZHyTgZoBXXaxvirF1BS8DPkURPfsDYhJTyemd59FlvEOtLi5ihFFOBrItbhkNmKX47zttcaFDBlqb2iLmRrieEVZB+S1GOhkR4LsR72zjqZBOwBWHzXcpDCb2bncL/QgjPN6EMtub5MUTxizRWq0Cc6LtKAot1Ndk4CP6Y4Fpji7YrlKULMMPwQmCTuzNcdlap7mqOJiniAhx7GpUbHqUmDwvPh6L+RCbrZ3sCfPot1PMwATrl++jmeHweEw2LQ+ERWRAu13el8RyWN/LuVueAD1NrFiIRgam2uyjnh4jl6LG8QDCyHB72kDHxxNh2wOWkAU7FmRbPSiACFtTiZLfzZ65jtbZwbVa2DAvppDGhBWp0YfTfD7M3x2KTrexMfbJPbsC6gbhEYGLOR21fPbjdpICiz/0Shn+7CrqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/alpha/include/asm/auxvec.h      | 7 +++++++
 arch/alpha/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/asm/auxvec.h b/arch/alpha/include/asm/auxvec.h
new file mode 100644
index 000000000000..fa90ee4f899c
--- /dev/null
+++ b/arch/alpha/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ALPHA_AUXVEC_H
+#define __ASM_ALPHA_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_ALPHA_AUXVEC_H */
diff --git a/arch/alpha/include/uapi/asm/auxvec.h b/arch/alpha/include/uapi/asm/auxvec.h
index 57cae8780d81..d21b87b6730a 100644
--- a/arch/alpha/include/uapi/asm/auxvec.h
+++ b/arch/alpha/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASM_ALPHA_AUXVEC_H
-#define __ASM_ALPHA_AUXVEC_H
+#ifndef __UAPI_ASM_ALPHA_AUXVEC_H
+#define __UAPI_ASM_ALPHA_AUXVEC_H
 
 /* Reserve these numbers for any future use of a VDSO.  */
 #if 0
@@ -22,6 +22,4 @@
 #define AT_L2_CACHESHAPE	36
 #define AT_L3_CACHESHAPE	37
 
-#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_ALPHA_AUXVEC_H */
+#endif /* __UAPI_ASM_ALPHA_AUXVEC_H */

-- 
2.53.0



