Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53D1C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5776B00A7; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD9D6B00A9; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985696B00AB; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 721F66B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EE30A4418
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:34 +0000 (UTC)
X-FDA: 85171656108.19.C7886E7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 51C1840006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YUrsKLYp;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=aK0JbXjU;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7w6IVovisCb503Pkoci8pxom1cMDymO/FBqfuq2HGI=;
	b=63WfFErXF5hbsRbONIwutqHxJsmAbaWgrLvSkuh6EJ2fOve+1AGubiyTZbU+WQhhMEXBWO
	2E+1iNwySaUldyfCmFmihdbuEOiPhZ3acG1q7nw0KiHwV+J7wZ1cST655NReXb9JBaBeKo
	+gw1EBCfsR0YVp7mxceT1EfBe3+OOcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421292;
	b=XAyqFH0FzkDHLs3KVXuqvFxP21R3zPw9askyDoL+FJ3xItTGWeV0PDhEMhWpba6Gf1ZdBS
	CclqhqMDingWCP9RBwKnL0opKG2MLM7PsqXebzFPUqOQqiFJl8SXRQhPJC+QzfKeBjt+O5
	oxvVHKC+ys0EuuK9UE5Kp5s68K1jl5s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YUrsKLYp;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=aK0JbXjU;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7w6IVovisCb503Pkoci8pxom1cMDymO/FBqfuq2HGI=;
	b=YUrsKLYpR6VZq3FjSZ0tcH1u/iL3pnEqPkHzaoQflyy4+wMTPZ0gzLpbw3vB+4VDAnG5PH
	cZALG1imAlcNsXtsBsfkzXXtDu4/CILpTvEnECUkH4/6Eymd0VAAx2OHa8vO4HJB9WC50m
	pwxutgnUIdRLMt9P1NVK0ydGcpFQDiUaCW52VKIUOqjDwMcTn5pjVTRZhVUppMT8B99nvz
	MIRuXE5wp91zRf3+wqSlZ56x3BykPmTc2e+RiC/SINOmaTjzLo5hN58eiHfEc8+gpMUebh
	HBcSCjN8rFEv5nUId4u6Gcy7+jfPttRo4pHbHkYZ7T1rTYgSH02AWQdvWf6ZOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7w6IVovisCb503Pkoci8pxom1cMDymO/FBqfuq2HGI=;
	b=aK0JbXjU6gNUAZ7CUfQcDDU1452O226LFxU7OBZ5JiSzeBepGLdhKq3cRUyVBT8BcLiF64
	nYPh4Hh4QgFfyDAw==
Date: Thu, 03 Sep 2026 09:41:21 +0200
Subject: [PATCH v2 06/15] arm64: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-6-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1590;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=yzUJPF4+/uSgsYkr+YJKb+Uz3ZiMTGZCOEBRakgLSTw=;
 b=DdZRWT9PaRUgrbKuk0FccoE0UqsO8Wy2gW0MV+ISuIpLSi+dZ054rE9E0nfEX8/hbjKwvu4k3
 XkEx0oppmjkBBuo9UIQSI5eFpWB/CFJrAubMUD+gSbssc81nC2HqkDn
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51C1840006
X-Stat-Signature: 1nckk77n7i744deqz1a5t8twxoieub6x
X-HE-Tag: 1788421292-167768
X-HE-Meta: U2FsdGVkX19mvRTd/pRxlnXMsCFZB/ymlHzYUjnnI3NzX5lDy1pjOm22TSxxyPOf1C6Y5U5TqIQHGJBFjL5efIcX9UEamCKHEMqaEqgRfJrVpmfnfDLGosMNrFOL3dKz8shMbRfbjYcTODMhkDz8faZoqQIMiD15YZ+OHJsbX7OkJ7F6P7++KhYkpT9GCHFosTtNTjYwTFOXd7kMDQ6+iTr7vJaKNGrlFjHLd9yilE5GuoglM7ti7Wqn1z7iM0ipVQxbL+tonVc0kOoWf2hWJshn2Ku5EFXEJlt/hGriqdd+DjQn3NcF0N/VVulqrxDfmsgaObUegekQvr7m+O9wym+h4ILTw4YEdK92xXvKVJu53NrAMWolAJ5UIsjOdGIXGCL0M6+raVr79kurLSOU8nBFtDQsw2cbsDMMjm5wYLckhE+QstuepfSCg8bYKe5miHY0DkBJb/FisP2ocRtiRi3ztIR00lPWqkYYSpDsZq3tEcoXEiWzrsKSl7g5FlInaDzk63gcRwClAYerm4ZIOl+f/uql1kq6lq3kQZjrsqW7wNuF2kimrU3qNNi/tpzOJpdIJH1muDypGOpvswmoCgPHw/A4rv0psSrwCysMIsEpeZKDRIce3x0T9RRs/dM3e+ttV826xEgrtCjMB2h29b0w6henZvGks9Ag/qAcTEolPQD3/ndNQHrNf3ULR1mhR2Rf9dTDqRrq+uKoo9b2NYf1/MPiafNUcriPUQx2xKaqhhL4mxpmR4waXKaPsnBomh+7dcL2eyqZ8/FBobcQDpycKCAAbffayuswasid0MPJfBVSWIlS55chsSZkL64FRFSr4DiKuQ+yRfqmxlVTQoo7CxtXTqz2cHJRw9je60duwnysgzfeGjn9hJ0DSqhmrS8GdF9sml/lNDULej1aIf8jGxF4TNh2p/fPrb0iYc8YVWb75Yo8/EWEyAVkgo82+ZmYpTHrJBNMSAjhx36
 jSF5KVWC
 JLTJ3/5WgYn9yT9X6zQ2s7uAuiY6KB0ROSKV1zrucN2RxIcvtZaZODmta8dLy1AajBbH8DCjkgUH9838qjHGvVGdOD40+YF8i2Zj4L9W4/nnonaE/eLIOIJIj4nH4shyOz2cobidKBm7RTMQXE4+x+t++AqOhFQ6zQC0F4mfCNDJ/r02Ryy0PVO3SZPfDmwD21UrH/M5xbZoCeXVYm81YSuh8aQePR/H4JU6MTURlG/DFguT+y1GjOoAQKMZnmqax6RAYfIiZAwTDjO0owiDy7A1u+9o6qAl9XwH84RXvZZoCpHuwmH2vo8veDz4t6AbQ9x4HbtJY1wcTjPWHgmmf/+5uYkCE9iQUQcwSVb5adNn68Cury5t589sylCrRfkZTFxmTdAWW2kou8oy6ujobJTntamTUSmLvIB72CFz67C9MhCSm6wXRtAr3GqWH5oq8lPt06u8cZnX52Tk09J1gtWcNrmgUYoeLAygaYgMwonnareJLacGlVn3felP1fsPpLVzMgSBB1knkmXc4rwEibqrSww8bIXNltekoEVc0KsZucLwdsbi5Htb5lDl3ceeppWho
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
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/arm64/include/asm/auxvec.h      | 7 +++++++
 arch/arm64/include/uapi/asm/auxvec.h | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/auxvec.h b/arch/arm64/include/asm/auxvec.h
new file mode 100644
index 000000000000..de24eaaa06e2
--- /dev/null
+++ b/arch/arm64/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
+
+#endif
diff --git a/arch/arm64/include/uapi/asm/auxvec.h b/arch/arm64/include/uapi/asm/auxvec.h
index 743c0b84fd30..fb51e906813a 100644
--- a/arch/arm64/include/uapi/asm/auxvec.h
+++ b/arch/arm64/include/uapi/asm/auxvec.h
@@ -14,13 +14,11 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifndef __ASM_AUXVEC_H
-#define __ASM_AUXVEC_H
+#ifndef __UAPI_ASM_AUXVEC_H
+#define __UAPI_ASM_AUXVEC_H
 
 /* vDSO location */
 #define AT_SYSINFO_EHDR	33
 #define AT_MINSIGSTKSZ	51	/* stack needed for signal delivery */
 
-#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
-
 #endif

-- 
2.55.0


