Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49E3606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ka+3Z7Va;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=+3FEC2I7
Received: by kanga.kvack.org (Postfix)
	id 872D06B05C9; Mon, 23 Nov 2026 04:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842AB6B05CA; Mon, 23 Nov 2026 04:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731E86B05CB; Mon, 23 Nov 2026 04:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A116B05C9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8C7080416
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:37 +0000 (UTC)
X-FDA: 85465881354.27.4E5A9BD
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 416C920007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ka+3Z7Va;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+3FEC2I7;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426656;
	b=22iZU0+QAbTrhg8u2zojk8YbnU7BWUukY5wIZMwFKl04W05c3/NXvdkFNdmgk7hpdYAXIh
	uJnZ1+ri1KztzyshhfIrDD97WlZatm0O13OxLt3vKVQw3SEN9zOJbr7e6E+p7hODu1eBKq
	d6j7XGrC1gAbk4FpBdc0ZY1i/GwW528=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWddYtZFRBih+2kOOV/tz3cfLiO8YsvFVYLjnh/zs0c=;
	b=8m8lBGMKrtnn5ILnOxXJ8WXdWtYb32nqsCqD8kWIOSdd9RfKqSM/b99CqWxbYszjieuw3Y
	3heCZgDxc9xadOUFpBYEclwEfsRZzG5quS5YuESAPkYR80tL26BmDKvBPu93fsAGoFlLJb
	5Hw+k8GVed3KUCZI17/QVIR+nHqcdC0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ka+3Z7Va;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+3FEC2I7;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWddYtZFRBih+2kOOV/tz3cfLiO8YsvFVYLjnh/zs0c=;
	b=ka+3Z7VadWdisEHx0nhlsSjM+BJx26vRfZQSKZBaNmkldRHN9izmYdiJ3lbMxC0OucilQO
	x4wajeyPaG9SYXCOYo0mEJbrlyo1Qb6odgIgVyt7RHwE0LwAcOrEw/9ag3SpzJaSdD+/50
	cf84wqq101c0Y7SjIl9MAYkyB/NoCBBDvkAzs3gXDM9eKkDoC5J59Oj+2z90qtXEsKIYjb
	6NCDbIjwyDXjHKXIWzzJogKsraz1G6QbzIpx7dekdRzxvdML7vicPUoeYiNKxgM4iAtCSw
	txYM5rGc4MljvQElOkPCMxyj2ftSGcr1+DILod8yuYSdLAYTq5uXJQbNv9SkwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWddYtZFRBih+2kOOV/tz3cfLiO8YsvFVYLjnh/zs0c=;
	b=+3FEC2I7ganDyUkYlSgk8p5ebQ/W+4z9rJpXxo/+Q6+NHLP1FitfABHLjtVREnjnKzyYQa
	inDCvMd1nvmg6DBA==
Date: Mon, 23 Nov 2026 10:37:17 +0100
Subject: [PATCH v3 12/15] sparc: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-12-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1455;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=vD8CGJOm5QnknC9kSQAkUBhPNwBGIfJ1kH0awZZC4RM=;
 b=ZqXe3ujMdbEB5uqjyUQ/H+vOfXjC40uRBW01eTcsRo6t6/9jooGMDQTmAxN0GFYsNBJaxy0gu
 pb1295uByM8Ac2cxiZxLoRuOrUYtiCs9VE19YvlZd0nouwzkUZeW8Zd
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 416C920007
X-Rspam-User:
X-Stat-Signature: rj9wmo8osq8uh773jfrj3c1m1easdci6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426656-436654
X-HE-Meta: U2FsdGVkX196Am5qKVXLZTdK/kH7LZrHpIi+zocf0IsO0yCsw7aySP91MCVUyJW9mi8vRPNHNF0+erd4aPqa/OSH77HR6RIfoFBETPXYmKKH9/DeBywLqrXlr6D02INt+6xmya6qaRIqAS1MUMriKyrCtDkH7Iimut5GHtm/GgziKagi6yXBXOhIsBQakToKPcAMr2malEU7SA/xB1HctQAjz94kMlzv4HoP1DBjsqJ0P6cv6c9ZG7bLvk1jbX+qgMNt2FxODjH0Yk58tfc0fzqSmIcfNWjQUGCFBKj538GL60lWvtZAt5zaV5YLsYvSwDTz+YMshZY0JC1V1QuPTx9eS33KFnmuCTf205Mgr0/zRfN5nRHQTeHqXOoDM2SraIbSQlg84psyW7HOa/WwvBDTO7VhPt2iJ/UhzvZNO9gmOu9k7RS7RDM4SabT7d/384SPXlL1i8uTgADVVwLVC6LoL0lpc9Mx1CSI72GdusT5/RZZ2j/R7dChMPIsFD+lEqaouO0EEUA6c86PfYQUfVi975gTBHfTKe23eO8M5gDDOZfxFhs32CrZWuC+SDet+Ux/RNBv5bACzX1emSe7xUojUZUSkUdRPN+xBFtYkQ8Hz1ScBXOCFvzWEi45CSu7hm2NGhWB72+nI+7k3CbWGsgIlG5CyWtdertBiCUAYneofBafpPCwxsYPFgocUupmf/KzrXMmjylcBKh/s1KMuVlamXkceiUOn+cTY+tm9xFRn9o8CWdSlo2u534roQM3hBM2/iSonbI61yOnfk1tGBcbl3bigCNQW14k39ANdBvsVqoxrpqqpeLLRkQNW1bSUQScfIMlUnP41wolpzHNAKiLeWOQsKhqBg0jGK6ImvQuPyM9YN3WAPn3clACyjkcRBA7r0qeVrvOOdwesW2RQEJn1qov9zdmIqXlEeNnXGXixhMPqgT2jPCx7jog8xrkL7/82cfS1Wie06z+HZK
 aFRtbqYl
 OgpnrAMm8AFCAqTMhx2L3dSXzQRBL58SL97C8qDx4nKCfdnVg7eLrAHlg5Chrg5d32sTjcXtv/s8hQDvIYX+gnOJ58rBqKfW02xW6MQMrchmAIRMbSD5ipeaRPA11YstgCaVKUQVl0mPJMV2n0/vjmVlZsaH2aLCfxPHH7+63n9NWN3KC/HWw+2f0/AJ9tNHZq68XlDDcghY2jRcM822iKr80fnP6QBTSnhB5cUaJ+EZ3SKB5sjtTTzypoS9/lFXLjUrdIvK9MZX20BmAp9PLa7C0ySP715Emcx2JroTqcp1QrOQ97rVcO08RyIZqNwXUzhE1HclkSBUlMDG2bXgi/StCWZz2hUFFT1uGXizdr+4us/fC7/j1uDuoJOQfdDDvWrCf4hKOViE7ELgIQxI4IHCn8e2wJyfGmM3OwMq9NpJ9tDVX2TuPDvAKpMq5SdQpZS8RtQ9P15uaNQhEjNTh3OkPDvSoOA8mGEj9uyj1Smt30kzrSnq3+BChyKHnidsQEx9WS+cwM9eIniXlOJMTx/UB8FBdp714e7Cu+NWEWJJnnLKpFOw4ykbQgP2o9/gBFamb3z3XXOhJZHowxTg8rHR1ihJ0IToDFtwfPctiKQ+OiuZfe5NhB9XIHcMzPLFCYWX4ClHG7BZEcZzquBRmcgRBbK8ozU9MyIb9Jjgb4muBeUzTfo8lQV0D+e8Y1T9SyKoHLzGVzOi6OzAsADEBTPc9atj3bvGvv34goqzFFVNOaQaCw4EGaQPh4IYgB/nKWaKsoYxTLZQjAjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/sparc/include/asm/auxvec.h      | 6 ++++++
 arch/sparc/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/include/asm/auxvec.h b/arch/sparc/include/asm/auxvec.h
new file mode 100644
index 000000000000..50c249a8bd17
--- /dev/null
+++ b/arch/sparc/include/asm/auxvec.h
@@ -0,0 +1,6 @@
+#ifndef __ASMSPARC_AUXVEC_H
+#define __ASMSPARC_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH	4
+
+#endif /* !(__ASMSPARC_AUXVEC_H) */
diff --git a/arch/sparc/include/uapi/asm/auxvec.h b/arch/sparc/include/uapi/asm/auxvec.h
index ab8780fb9df1..0fab3b29148a 100644
--- a/arch/sparc/include/uapi/asm/auxvec.h
+++ b/arch/sparc/include/uapi/asm/auxvec.h
@@ -1,5 +1,5 @@
-#ifndef __ASMSPARC_AUXVEC_H
-#define __ASMSPARC_AUXVEC_H
+#ifndef __UAPI_ASMSPARC_AUXVEC_H
+#define __UAPI_ASMSPARC_AUXVEC_H
 
 #define AT_SYSINFO_EHDR		33
 
@@ -10,6 +10,4 @@
 #define AT_ADI_NBITS	49
 #define AT_ADI_UEONADI	50
 
-#define AT_VECTOR_SIZE_ARCH	4
-
-#endif /* !(__ASMSPARC_AUXVEC_H) */
+#endif /* !(__UAPI_ASMSPARC_AUXVEC_H) */

-- 
2.56.1


