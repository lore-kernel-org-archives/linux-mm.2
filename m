Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E37E87850
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECA36B0098; Tue,  3 Feb 2026 12:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AA76B00B5; Tue,  3 Feb 2026 12:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099A36B00B6; Tue,  3 Feb 2026 12:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74C06B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:36:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BBDDC21A3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:36:59 +0000 (UTC)
X-FDA: 84403850958.16.F0D8ADE
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id 36F4D1C000E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:36:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=PLmnOTM+;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770140217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaL2K556/b29Zc7mgPhyn+Wsge6D4MK7+AfuXFYE8Tw=;
	b=mI7vf1BB2DBLe+G7x3iMtMAJLI/+L0QRi6uDyaEIx5GDh3+wLU5o44TAvOw7u6ZFenGbK/
	o7Al1DcL+rU4A4jSbNePFqu92lmGzWIF5o06hPktbKCT7RIt6At+f1Hf6iYhkbIPPMn6rv
	LVuELrmVRRMRZeZACedT9x41Hwgw8ok=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=PLmnOTM+;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770140217; a=rsa-sha256;
	cv=none;
	b=UTApCmb9Nl+Hz1qVfIwBAeiFha9R0QRyGKGSngBKgyfIOJqUNiDzzwV0N+Jyyk7Zm42YOU
	wvvC/O/nk7oJMgkxkU+JwmXiHcO2riQdrSZZt7UGtcCq9/YtOsMP02JlGAOnKFzBat9xfQ
	KMGfMDoxd04TtD0CW2gyGygy1cQrM74=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 613HZcQG3503354
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Feb 2026 09:35:38 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 613HZcQG3503354
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770140140;
	bh=RaL2K556/b29Zc7mgPhyn+Wsge6D4MK7+AfuXFYE8Tw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=PLmnOTM+d1xnyLW9FTtb9/IJ/llB539xPwkf9n9id/lLbVqgxVwDhm16DkKJDkwCB
	 v/VqrKIvOSdXV3PP0zdH6jhkbHgEvtzah2DGnqfB8WLbn5sAERwaawtqcO+3ZDFryV
	 Kr5e8reRQydFNRfJ+r0YYMagJoxb5BsmywUyoYP4ZETc1vGRhE7KPL7nkJpJpnonu5
	 Xx4xZ0u7BuS1sIhZ2N9okj4b6vaVWvTZ9DRo0yFhvcjLfVoJ2M/6Z0MVhgRd6HJIiT
	 YH2816M8QHuCDD8U2wXu8NSIbEIATo0EG0tNoO1ZBIqWGdr6O2KFpl+alfJrhzNuyg
	 DBWsBSCV+A+6Q==
Date: Tue, 03 Feb 2026 09:35:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
CC: Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v7 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
User-Agent: K-9 Mail for Android
In-Reply-To: <20260203171958.1522030-3-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com> <20260203171958.1522030-3-jremus@linux.ibm.com>
Message-ID: <F16410E4-43A2-4CC1-8049-AFB803733869@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u3yopzxqwkp9bs1dqa4tpms3df6wg3eb
X-Rspamd-Queue-Id: 36F4D1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770140217-836348
X-HE-Meta: U2FsdGVkX19ihAFZObdeVoP2WpR5gQGzRI7p+PcRUVZvcwXb4zs2lmIcWlL78AZxCl63VyxIgLMGRUwEQgxovucWuQHCifUreC4U4UlgQ+ncRB4A+7kgWvW6biNZKJAYXUrwwBF2iuVO23lq7528G7shZxzcuHXuDv/J3WSFfji1m9Fsg0MQcC1+vrLonISa0zSzZL84xVw5kRB3cb2TAs0aSNbbLCitnR8643huXFAL07H9GIaLwYsuXG+nyzD7kw5zxoARpbAhSI+mS24m17nMHYGogYVCLKCcGsADbbDWs17n2nQ89PcxSxJDPXwph04m+eOMdL29HiamSsEdIcO+K66cRABtzoBkx1lfDMDKhHLHGBXaEH8akdcGfUorK9atSU02r6yzYVqehA5dIo/CZZzKzxs0cIjVmS9NpEViYzWMrxu4PmwlM/K4NPgf9Qb19ZyadKMEUA/eEU19YMIC7Gam4TH/V2CbGeUBkYCxBanMyMxxwcPt5h6CFOzW6lDSazNF1iBY1zleVXmPCJ+EGexL6HBoXFdKjfTk8eDb4tkcsX0DiLe6eXUnUvyaMCwIZSzqnB4B1Fpf+eaJ2BQlpNnycM7hPFW1Nzbm68VJFfWzghc4E0QERKbtQ10kic+GeNWWoXCeUzaItznO/bpMes2QLMeq8SlKU29yVJyWO+cMROT1wxlRGLb4Tj8RkYumG82fZOd4Os1ir92HiKu4pE3f0HMLI29Cc8CMPoHHQlZCTb3wAv/OEyiyZAHc5YXqaGJ3b5gZPgFoxTJikytdTbJ046CcgBC39v2dtQPqkTPKNjeRJS08dSLiYiRzslZilo8ey/yOYcTFWxYdJIPpJVkvAfX+E0fJX48PDMKogct3mwF/8GIXxZMVzZfT91XZTFuBqFS7p0Z2FNbIw1g7UtbKbz3vzEkzfMoMI2BdP7mrle1F07GGnCIqRfBu76JiXN8J70QA2YQzeZT
 G/SYTvha
 OnTT+5GwiImvYHqe+KyD0QKoNmzY8l6WesIQKCXvHcYbkMgwMh/8XeN5pVJYSk+RSTAj5UDdSI5dZU/u7RKhcNB13AsVWytqJ5oOecedxVZntBcm3b9IBHfySW7uK7jv6+gvp9jrvfCFQ/DZXg0YpzoNn6Fnt+HySaOKTKSrk1jV9p96slSiXeqguDTvNyzZpOruC4PprYzZrCgA2F4nizzcvgIk+jUpEExpb9kLhzwmCGWiQBHh0RNolCUnXFYFxQcHOnk3fDA5Zw2rQTTKNDJs2U74RcRij5YtM8lWNdz2TDHXt6F308lRk4M5E+at6CBGCDwp+W3/mASklgFMSu2QqGGXw+6vDPe/o8fr1rbbxSNPvGJaaatXCfZWj4ZUfOox8OFf89axI+t+yKqWw/J485w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On February 3, 2026 9:19:53 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> w=
rote:
>From: Josh Poimboeuf <jpoimboe@kernel=2Eorg>
>
>It was decided years ago that =2Ecfi_* annotations aren't maintainable in
>the kernel=2E  They were replaced by objtool unwind hints=2E  For the ker=
nel
>proper, ensure the CFI_* macros don't do anything=2E
>
>On the other hand the VDSO library *does* use them, so user space can
>unwind through it=2E
>
>Make sure these macros only work for VDSO=2E  They aren't actually being
>used outside of VDSO anyway, so there's no functional change=2E
>
>Signed-off-by: Josh Poimboeuf <jpoimboe@kernel=2Eorg>
>Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis=2Eorg>
>Signed-off-by: Jens Remus <jremus@linux=2Eibm=2Ecom>
>---
> arch/x86/include/asm/dwarf2=2Eh | 51 ++++++++++++++++++++++++-----------
> 1 file changed, 35 insertions(+), 16 deletions(-)
>
>diff --git a/arch/x86/include/asm/dwarf2=2Eh b/arch/x86/include/asm/dwarf=
2=2Eh
>index 09c9684d3ad6=2E=2E7cc30500c095 100644
>--- a/arch/x86/include/asm/dwarf2=2Eh
>+++ b/arch/x86/include/asm/dwarf2=2Eh
>@@ -6,6 +6,15 @@
> #warning "asm/dwarf2=2Eh should be only included in pure assembly files"
> #endif
>=20
>+#ifdef BUILD_VDSO
>+
>+	/*
>+	 * For the vDSO, emit both runtime unwind information and debug
>+	 * symbols for the =2Edbg file=2E
>+	 */
>+
>+	=2Ecfi_sections =2Eeh_frame, =2Edebug_frame
>+
> #define CFI_STARTPROC		=2Ecfi_startproc
> #define CFI_ENDPROC		=2Ecfi_endproc
> #define CFI_DEF_CFA		=2Ecfi_def_cfa
>@@ -22,21 +31,31 @@
> #define CFI_ESCAPE		=2Ecfi_escape
> #define CFI_SIGNAL_FRAME	=2Ecfi_signal_frame
>=20
>-#ifndef BUILD_VDSO
>-	/*
>-	 * Emit CFI data in =2Edebug_frame sections, not =2Eeh_frame sections=
=2E
>-	 * The latter we currently just discard since we don't do DWARF
>-	 * unwinding at runtime=2E  So only the offline DWARF information is
>-	 * useful to anyone=2E  Note we should not use this directive if we
>-	 * ever decide to enable DWARF unwinding at runtime=2E
>-	 */
>-	=2Ecfi_sections =2Edebug_frame
>-#else
>-	 /*
>-	  * For the vDSO, emit both runtime unwind information and debug
>-	  * symbols for the =2Edbg file=2E
>-	  */
>-	=2Ecfi_sections =2Eeh_frame, =2Edebug_frame
>-#endif
>+#else /* !BUILD_VDSO */
>+
>+/*
>+ * On x86, these macros aren't used outside VDSO=2E  As well they should=
n't be:
>+ * they're fragile and very difficult to maintain=2E
>+ */
>+
>+=2Emacro nocfi args:vararg
>+=2Eendm
>+
>+#define CFI_STARTPROC		nocfi
>+#define CFI_ENDPROC		nocfi
>+#define CFI_DEF_CFA		nocfi
>+#define CFI_DEF_CFA_REGISTER	nocfi
>+#define CFI_DEF_CFA_OFFSET	nocfi
>+#define CFI_ADJUST_CFA_OFFSET	nocfi
>+#define CFI_OFFSET		nocfi
>+#define CFI_REL_OFFSET		nocfi
>+#define CFI_REGISTER		nocfi
>+#define CFI_RESTORE		nocfi
>+#define CFI_REMEMBER_STATE	nocfi
>+#define CFI_RESTORE_STATE	nocfi
>+#define CFI_UNDEFINED		nocfi
>+#define CFI_ESCAPE		nocfi
>+
>+#endif /* !BUILD_VDSO */
>=20
> #endif /* _ASM_X86_DWARF2_H */

Maybe we should move these into x86/entry/vdso/common instead?

