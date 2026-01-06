Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7BACEFD11
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFCF6B00A0; Tue,  6 Jan 2026 16:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6457C6B00A1; Tue,  6 Jan 2026 16:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363716B00A2; Tue,  6 Jan 2026 16:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2081E6B00A0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C1165D00F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:14 +0000 (UTC)
X-FDA: 84302807148.17.C93242E
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf15.hostedemail.com (Postfix) with ESMTP id D23DCA000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=PoMpztMT;
	spf=pass (imf15.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qflYDEYSfpEA8CgU+zw+8+XYOHYFRgGv++82XjVNC1o=;
	b=aci9yS7VeASkpaziQ1+YiAALNCxtson1caRlRMlSgIVl1k4WBnMAKh+OVZls8SWDC/E/Hi
	P39zsMR7WB9G9TC1mlcqGrL5rik3SNzjPzXuNuwxkPaKVRBsNf7YQNXPw0h3NIIZBqW7rz
	lbQZVtuKKzGbnzrRDI1I8X/gk+N2W4E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=PoMpztMT;
	spf=pass (imf15.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734413; a=rsa-sha256;
	cv=none;
	b=dmgUlq2YYwQ/7RM+USqEPnI5mh+qfYyJnOGosKdnfYVyFOMD5wQhj6gewlauAMh0qfPey1
	4rI6tjJFQJx/XCjD+jkeLLdB+dA12ku14eVK87O6i8m3qOBfr4gVETTFcnq6dw6mTEsn86
	n4iyrcXIxL0Z9HFAxDMVB/aJfShY0SE=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDt029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:03 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDt029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734345;
	bh=qflYDEYSfpEA8CgU+zw+8+XYOHYFRgGv++82XjVNC1o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PoMpztMTNEiy33udTg/19xCcwh38wxuUxtCCxlW3m5DrqTNqz/7/VGpGoCcr4iFB4
	 KerBCArQdhirHvPEyFqef2WGKj0pYtLEvpvnIqAcisoOF/cjagdNK0QzQGLWMx4rGr
	 ZQ4SJKuHxDxwxHNnpP0/0GujYD40OUvO2ARBBI2s4hqpdN/0ILFTCI6fhohUhmFyW/
	 p3BB4e1Ph6gl6Zso4WaOasusd80fg/tXBrTXYO5YzCDgbild4Yr8GYi3gJ6AFXNuC9
	 s/n8SqLSC8NkXSz58gxfpmXC4NnWcslKmRoQFofKouOFLT3LsJEoyM9/2G4EhALABg
	 QbEHXNwK07Piw==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4.1 05/10] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Tue,  6 Jan 2026 13:18:38 -0800
Message-ID: <20260106211856.560186-5-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D23DCA000E
X-Stat-Signature: 11rtuapc7whgns3oxe4fykg75ibw6h46
X-Rspam-User: 
X-HE-Tag: 1767734412-292576
X-HE-Meta: U2FsdGVkX187ikvtm8kXwVADYWcuLFDqktoJh3BhG7kSjx7LwmlO3S5wq8uIqXjL9KfjSzS1QWfP0v2pSjgw5+EXyc7aukm/QYcbzjztBfR5hW3343EaTRwwNAH35Y2L8SAHjPBwKmlg9Bpr3ePJQ81d9xfY7PEnRCqte/zdwubOeCqlfZnX7K/rdU1v69nPzAB6X4RJXywIlPv7p6hNZWwxOttN21JPJN3acNamd76QlUPfUzLq7VfdxDqLcfUxcX92o0ojMUN87Pei8xG+D4HsKd/q6+a9GoKbfDU/LVEyVCuTVlr4M0jzNeQWqZwwXlJO5MWaYs64diU40kVLQWAHbC1T3aPh2psQxDcLrVHkt5Fs/mYQifAWgPfTY+6Cj28Kj8ggMQw4yL2nBfeLzX51FwqMwkthwBmSaVC7ZkuYikxtZg8Z5VjQQFQmVYcmEiPXjDcniAByyrYEgTWMBBo79VP7vzV5gWUqoFdrkv/D2da2cFSFpbE0Rl3EHi+wn6OWxOYanYJkcO05FFK3q/44KEx0p0I8VXBjcwJMHiS+xuGciGQkn3XSU3ENNz297bDeMhwalgw+PkuaGqyck8vCLa3LK2tkPortluXayhtGWqmd1STw4iKDlUJJHFQiwI00CbqQ8YKu5PpsWungJMqjRuHizgoEbgcnd2uJlmZROwbxMnPNf+t/46bdKZcDJX1Pm5VqGN9OkbVG0BZE+yCRfY936PB0jc2of7583p8d45+g6AzkpRZBHJEd3radBlIJ1M3UkA/RLbqoKLMdy62z0Zn04FDGB+/uNT6H3C5m/X7bx8l2prv7MpoAkBZ9sfhchAmwZwlDe9L5OlCUs22UP2qebIIu0jRQ8nOMJz2IjwQ8x/+eKJ0ZRbGCMCw5PRs1rbOAnnFqn1SLFI2mN4qeZV7uEw2tg6GhoUT2OiGxCOQuKpuV1GacC/DSFbdCXN0SxCpbOIPP1VsKzX5
 ctuiNvlQ
 00sKXeLgdS54Nme1xVx3UXFZDrqHJgoREidEVpq8SarFBv6T5IEdlbfKjj08aHHBXAQD+gviDSAVUW6VPyRNVaNdfSYAL/lqpVzJAYWZR7OHA6oejCvgPQzW6MhXMcgTgkOGD4H4RatifmoMrTvjGhbc2IK6MZM7XdZa3DFMTPMhGqbwcHAeRUm+WFHhOwwhdA1nfkDZEv2Xer3LA8jeWhbCO99Fckdp7RFAl91jnW5Att+OobKEj5Uupd/Ml+1jtfFBc4PnV4sIstBp1lO0pHuEW8/yp6FxhqYOmWUWPvGRoNRG7/5PT0Te1so3+pA28Gm/9JUZbIWIlyHNCZWm1Li2iWUd3FU8zcwA9a28cGIfkHpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A macro SYSCALL_ENTER_KERNEL was defined in sigreturn.S, with the
ability of overriding it. The override capability, however, is not
used anywhere, and the macro name is potentially confusing because it
seems to imply that sysenter/syscall could be used here, which is NOT
true: the sigreturn system calls MUST use int $0x80.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/sigreturn.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S
index 1bd068f72d4c..965900c6763b 100644
--- a/arch/x86/entry/vdso/vdso32/sigreturn.S
+++ b/arch/x86/entry/vdso/vdso32/sigreturn.S
@@ -3,10 +3,6 @@
 #include <asm/unistd_32.h>
 #include <asm/asm-offsets.h>
 
-#ifndef SYSCALL_ENTER_KERNEL
-#define	SYSCALL_ENTER_KERNEL	int $0x80
-#endif
-
 	.text
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
@@ -16,7 +12,7 @@ __kernel_sigreturn:
 .LSTART_sigreturn:
 	popl %eax		/* XXX does this mean it needs unwind info? */
 	movl $__NR_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_sigreturn:
 SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
@@ -28,7 +24,7 @@ SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 __kernel_rt_sigreturn:
 .LSTART_rt_sigreturn:
 	movl $__NR_rt_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_rt_sigreturn:
 SYM_INNER_LABEL(vdso32_rt_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
-- 
2.52.0


