Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396E6CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA048E0184; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5F280009; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532F68E0184; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3943C8E0189
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB72F86DA0
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:56 +0000 (UTC)
X-FDA: 84041666352.26.98AC996
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3DBB0180009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=fH8drbcH;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761516775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPqmZ+cMh7BpOCrdO7SUJ5c3yBPWnI92MTbF8FZezpQ=;
	b=IBhfWWdq18o8uvnKn02980Bnopidg4BLg9JJamxoTT5kAz4AXMnbnBr7fUD5XFazJf8XBI
	BJLH/m/O5jn9JnvztSLpagBqzEdvXwFQjv3ugLzLmPqesasN/fmgG7XoLIQz9pB88+QOd3
	5ocygTeSNRotvj/0GXeFy7eyvQGrxZI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=fH8drbcH;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761516775; a=rsa-sha256;
	cv=none;
	b=pd7q4H/u17QYLGZxwY7sYsQSBmUDWCnhzjXIgjHelVHswCaLxeXCOB04LFEXAPm4nL0IFo
	gyYl3H/f9VbYl7uarYqYOBKw7w+9dgbWEpTjd4vn38NcRBbZwDx5I7LXm1zYC2x5iks8KM
	3U3tBLm2fOgQ+OyLch3d3cEyZIRwU3s=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpQ548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpQ548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516750;
	bh=nPqmZ+cMh7BpOCrdO7SUJ5c3yBPWnI92MTbF8FZezpQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fH8drbcH5SIfNt0oVQdilq+q3DjrQcT5T2rtiEMh18PSPqnhZnxuveHvYSr6bISBI
	 S3LYWK516TvBRrVow+T3RTo3qrV12T/Gjp86mihPSovvtdwJKPQ86zzKLLOvprJfn7
	 DgzzHJKBBQb7D6F0bfTS6AJQqbxladE1aljHSr6+PE/k0BNv5GwrUAIMOSTAprL/+3
	 WQmtgUuxC8U2FtcmNnhkfbJQvdCRoeO1ykiIadVWXHeDUUB6NV+ZBBk6ONK4nyTfVO
	 ArXeItD7QNahPhGvapu5y4P36wLwr97f60L8VvNtGaMD0kWZ3XYYgByZzvumgNtioL
	 YBBO4xRZ/nX+g==
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
Subject: [PATCH 6/6] x86/entry/vdso32: add endbr32 to system_call.S
Date: Sun, 26 Oct 2025 15:12:06 -0700
Message-ID: <20251026221208.1938173-7-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251026221208.1938173-1-hpa@zytor.com>
References: <20251026221208.1938173-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3DBB0180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fpanbzy97knp8ykmy4rpq6yywutjedip
X-HE-Tag: 1761516775-419521
X-HE-Meta: U2FsdGVkX18hlFg7pGzv/DALVKz0nhNF7TG/0QPye3i3Aoelq4Nnwrz281YzquXav9ZwI7GlPcTs0zVvimGLHSen7zWgJP1ulIog5r/qtOLVyO2uAuDbx3A9FF7ZsgIoY91kPCDLWAYkMsZNSL87vIpqaB6GSo7XVcLl+bmWsiO9k0pp21QNZL4oL5rz0y+3gIq8XpqLlr2b6dWQ5IDcRcW+F1C8QUH9d9zu21TuS4ECvX2nq/XEyF8wkrx6yXDwn2P3BxaLnKUvuRPpE0j+mCQeWucfCumeBlcAbrX3rzBm+aKYKyVDIV0q3VE3BNSXibp1yrRsXQG52YBEvGXFiQ4jsP+uiTracART6GSBKqQpD2n2Kut1L/N50YdmYKR+PNNKJeNzySLtc2iIb4D602a9Y4NBdcbdAlWQay5P3EPOjc06gT5Lz4x/j0XPnQ5bOa1Zck2uWKEBkKRWEaS2SjENMc8oA+kfK06Fe5soR3QRxDE4sDaXDD7B7MhTvt9aSDe9pJo49u8cCZ2HLCBSs+kNx+AW9jg1iRjwY8nOd8d2cIxZVAwWz6p4seCY4io/dI9bJ17eL2V5B5KesKPMrKe3Y049dvWzi3DzJJcyG3291tO975AUpVe8Sa2miQ5/JDZ2t/foyjcfi0FWTCTSdEGxkpeOqJXLL5PmvB/Ejm5ulxjmlU/yLP8NdxmCrYazHrMVlD8vXBedXjk9zb9ynYCGgske7d3sm4R54F1dLlG6eG27HSSubN1Xxz3dmTIGFlX7jMUnClkFBlEDpbrlK5FmTV9t+mG50MP6zTgSPDZADsgGbcz9PzXQjZyG4Nb8Z1A11uFGjbrJT0HL23nOZSeBpegWBzU/I2+15mR5/gU8uP/m5eqXCQVDI6BmuOWEp8JNkbf2pumi82eqodHnR6WN+qZkSkELtJomdfnEYUpMziz1HuS74E9NJb57Tn4j+McXiEpTHVJ5bKhM+em
 vOaY09/L
 S9uXw+LcR04tTaXchGNKznkDy7AA6WmkEJjuCCun5Ad4NRcrE2iaFwWe6QAejZoiH+2dbsztKx4A5hMZOH6Zz0bLkyS+5OGemwn8MwlE+P8XYSJSY9Cq6Z5HO1cdiFUg3mtcmBldGrOif1qcMRGq+etoiRpTGto05byq0Of5ebRFGcCoZWs4DbSNN742+CvlxYRJzk2XozMp1ulYN7wRLfgZItYE5d8D9dV/88t3gkbpDWJkCq+u8IvZPb2oE/7Qs2COuHv1kSgxz/zLLoQLClWVqPC00h/KpZKKR9YG189dQC/xtOyCUvUKxFTMsQalhj5+PGL6V43PaPa/vk8SJugN/hNrNxVIXopOJmmKK0ZKXDjQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

*If* the C code is compiled with endbr support, put one at the assembly
system call entry point as well.

Note that no endbr is required at the sigreturn entry points, because
those are logically subroutine returns and invoked via ret
instructions.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index d14eca4403c5..0ca7ca1c490b 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -8,12 +8,19 @@
 #include <asm/cpufeatures.h>
 #include <asm/alternative.h>
 
+.macro CET_ENDBR
+#if defined(__CET__) && (__CET__ & 1)
+	endbr32
+#endif
+.endm
+
 	.text
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
 	ALIGN
 __kernel_vsyscall:
 	CFI_STARTPROC
+	CET_ENDBR
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
-- 
2.51.1


