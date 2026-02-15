Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765ABEF5868
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 03:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32AF36B0005; Sat, 14 Feb 2026 22:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEA76B0088; Sat, 14 Feb 2026 22:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACF66B008A; Sat, 14 Feb 2026 22:58:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 067596B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 22:58:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B168F1B4BBD
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 03:58:14 +0000 (UTC)
X-FDA: 84445333308.09.D753572
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 457BE140007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 03:58:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AXEQZIue;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771127893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZCuFX4wLWSbnn2ULZdbzI2FlhLkmO20FWopmI/RY+50=;
	b=vJRYRr4IDitY6JRfA6TDI/tuA0nDeWGUe9/cCzfIuPkK5R5KCnZndYqUTMYPAtP2EvG4J3
	IcQciBKsMqcO4LjOiDq029dwR+kHKLM/BOFvYXhSmlJnJ4GAqqnTH6ypnxPCYezzCfnb+f
	QWYr/ecQ7vZ/HHjDII8o+J6EG6w3ZXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771127893; a=rsa-sha256;
	cv=none;
	b=SrYIgTlZ13CYWyhQpguHY6cEZBR1AfUrEV8wwpCCXOJrSIDja5yOnOceyxGJ12wsSYg7PH
	0RleX/f/TBVafGYxqIDiJRNAu6yh3vm3juZ7MmntASqsmtJaWCIy874qOtev1L4G6LWRpT
	g/Mix92V1pVHPjVcwIW6wD9yUc5Rimg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AXEQZIue;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D5ED6001D;
	Sun, 15 Feb 2026 03:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809A0C4CEF7;
	Sun, 15 Feb 2026 03:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771127892;
	bh=jsM6rUIEAwjwmIUoIADEtW5CiHC9ZcogfvHijHZpuys=;
	h=From:To:Cc:Subject:Date:From;
	b=AXEQZIueajJ7DSzROwzTv2ACIB0cWHnp8cKrN44oY7F4k5wUfahMoqA1vTzqNfbic
	 RwRxyMU+tZqNsGzixcYy6Ki0Qfr23XH4NNGEbFTo5/8YzsXtaSCg3EyCjZYPvGq+nn
	 7HXhlPR3evjZ+YVDMQV+NrTqlGmIDV1D4j+kMXdIgp95bsUYdMg3Q3DWAMcTQKsZji
	 zS04TsnIjwFpvY09XV8HoOOTzoZ5yFJ3X/3byZt7Ur66jeGGpy7QAsqqBb6hXRrXBw
	 b8j+qnMVgtbnVUUoDY5Py9xed73WuybqloJ/+Mc/QaiAlzD5jqskm8p75qTOXUul0E
	 mSLg6dyP46nLw==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Date: Sun, 15 Feb 2026 11:39:44 +0800
Message-ID: <20260215033944.16374-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 457BE140007
X-Stat-Signature: ff17zkjjb1daso3956p33qkfpotqgbgw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771127893-954221
X-HE-Meta: U2FsdGVkX1/DOZwB9x+hDt/C7B+GFdUdxVLFUxIZKGL92N735dgu9UquHVtoELPEy0jtVxTxYbCYe6uDuWFfkD80g9jD3YFhuXjd8rowF+rTBwvdFAqm7zqrQESJPCuIEm9LQ9Wnz7wV2xQ3ZrquBudave2uqs348B0YAmvYYtIPVRM5ER2Xn4rynRlatJLiOKLYXoba4J0A8Sv1+8IXVD0ZMd6MHgPm+JJx7Z39RhTWVjI37bCb+zMpXmQiP7/F0C2O1NdNDCTbx6sj+9nWCcNpj9zPWmA4I4M7fqeLsSNTZMnU4zCg+3HEr9rJyCrs8PfzCgDxGcU4kVl/XP2baWpFYVzmfuDVdlQE7lzmPOUAOq+0LZPhjUYAEaOgf4k+B/DZNoN6uz1ycStR4YmSy6eC9dPKmZjt/fW7QMAoBYXwsC03Fpz+tZV0S95sOzi/3CqGDiRkCmMlEANGqhnXUi5kRBRMPfd1UilwnsFGWTYz4nMEV0bz0FcIJvFonBV8IYdd6z0YJ9hdNKONEnhe7B4S7tLeyTwHfSyMAnX3RyxdRezuZoWmOpmrtqr5THmLd6QLwVVMn2jaX6o16uu2eT3bwAyfUCfSYmHZ71HPtYlUZpS0diDro5Krs39f1iK3oOWga5jU9+AztMZw6KWTmgwda1kjxXeLaSGagJGdzJjILBdOVoBPDQXXub3sztTqDdnKenWfyQZP+vm74GgusCwuQx+le1U46mnW1xFEyaPQRea9L46TqPaZeOz/rZsek9kA5T4cwAFjRuS+O+UJLSk45csQfGhfH9SKb3Zu9aN36BlMSEOU0k4nbKBoYFM/6zY09Y2KtPDu0ZLoFWEIM3HINZOdyBYRXbZBhmbPT1XZ/D8Sg8/L6ibmsJCsuPiovb9CgFBWp4fO9y+MQVoWP9mApd7Ira81y5L1keCvSJlsPW2ifTZKLXDMQPBya9GYYIeem8Lp0QytBl5WALG
 j8rh5LpM
 JZ3NOoLHdJh4HbzSkKgsyq5Opudh3O1Kpv36mEa40Dw5UKgxvd/e5Och1GcWsD1H4k18yq7Z4A75p/S4NvKuxpeuFNpN28LvYH9y1zwVOP0mcA2N0mfKtWODpSof7Kev2wx2pprfvPfNjbOBr7hKO3Any0P/SiKLy3S+UPVRuG/2A9sEPPNexLLYzWvXK/fQ6VAvrVA6CS4LmeriXEWguNXwAeItJHNlFzGTMkGKGcVA8qhlq+TmiMGIRpe5wVXq7OtjQ+/otODQW4My8AQf3nVsSkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It turns out the generic disable/enable irq this_cpu_cmpxchg
implementation is faster than LL/SC or lse implementation. Remove
HAVE_CMPXCHG_LOCAL for better performance on arm64.

Tested on Quad 1.9GHZ CA55 platform:
average mod_node_page_state() cost decreases from 167ns to 103ns
the spawn (30 duration) benchmark in unixbench is improved
from 147494 lps to 150561 lps, improved by 2.1%

Tested on Quad 2.1GHZ CA73 platform:
average mod_node_page_state() cost decreases from 113ns to 85ns
the spawn (30 duration) benchmark in unixbench is improved
from 209844 lps to 212581 lps, improved by 1.3%

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/arm64/Kconfig              |  1 -
 arch/arm64/include/asm/percpu.h | 24 ------------------------
 2 files changed, 25 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..5e7e2e65d5a5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -205,7 +205,6 @@ config ARM64
 	select HAVE_EBPF_JIT
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_CMPXCHG_DOUBLE
-	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index b57b2bb00967..70ffe566cb4b 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -232,30 +232,6 @@ PERCPU_RET_OP(add, add, ldadd)
 #define this_cpu_xchg_8(pcp, val)	\
 	_pcp_protect_return(xchg_relaxed, pcp, val)
 
-#define this_cpu_cmpxchg_1(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
-#define this_cpu_cmpxchg_2(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
-#define this_cpu_cmpxchg_4(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
-#define this_cpu_cmpxchg_8(pcp, o, n)	\
-	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
-
-#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
-
-#define this_cpu_cmpxchg128(pcp, o, n)					\
-({									\
-	typedef typeof(pcp) pcp_op_T__;					\
-	u128 old__, new__, ret__;					\
-	pcp_op_T__ *ptr__;						\
-	old__ = o;							\
-	new__ = n;							\
-	preempt_disable_notrace();					\
-	ptr__ = raw_cpu_ptr(&(pcp));					\
-	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
-	preempt_enable_notrace();					\
-	ret__;								\
-})
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
-- 
2.51.0


