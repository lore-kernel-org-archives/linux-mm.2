Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20BCC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1CA6B00E6; Tue, 14 Jul 2026 14:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91896B00E9; Tue, 14 Jul 2026 14:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA0E6B00EA; Tue, 14 Jul 2026 14:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3C4C6B00E6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:23:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 260784049A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:36 +0000 (UTC)
X-FDA: 84988205232.09.512EC14
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6578116000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=khU3hjdP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlvBm4NItea/+plJuhWRRJi1bfhjVkmixX1HjLGBPlA=;
	b=YQfFhmogKb4hEnVO0C84WU4H2Z+h1TXx2KpeuEJCcR9+jZBGAaK/NlBG+5ETtOVLEjKmLb
	zAtp7fUCvaoE6uQPTj2Y3Ocb/eENwg4zTKCHVqHWGW428hFR5Dkv+UnKVM++y5NnfTxqNI
	3qZMkDvdtJMHj5hxDKiGRxGdJuP33TY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=khU3hjdP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053414;
	b=qDMP9AD7tLubo51W/6p/UVRUidRxQefoKh8EJzCXD+FmXaGc6gVJQ8PEusoAdj8hPWlBY3
	Sk9WSjo8iBF1KuP1Z5iCB5Q+FelyyK1jjVNcxNfjo2rDrWVZpye7ZydjWANSnM5GPGgoSq
	ekMH3dyzbfAUjnb9HBjYlgbvcvk6X2s=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9063b380982so22585796d6.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053413; x=1784658213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dlvBm4NItea/+plJuhWRRJi1bfhjVkmixX1HjLGBPlA=;
        b=khU3hjdPGRfkd9nG5QNXQXCfM3VOg1MIKIqK7TGFkM1fXubCxpKUwle+sqta0Ygqw2
         IBv+1rMqVyB/qFLPJo18jOEYHQCs0/KlUWjnNppDHapelDwLXGNkhiiMaOq6eVpZahYQ
         jpjcJuqOKeKO15cDM7JCOVQDBrVzEQXEvcqeQjGlyPt7XulBDRttRw4tQ3nmJXvmr/PV
         jG3jQT5VeRx0xbvyAz5hcgmdZ0rRi/R98M56qNV3H1qXgU5dl5SyUfaFuArZE2Czah8V
         mgoaOH2jI5eUFPOSrw5LWauI0OnwCAmJhJ1RpAoDnTC6t3JhjkmNF4waJIpmZLLG03LZ
         b33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053413; x=1784658213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dlvBm4NItea/+plJuhWRRJi1bfhjVkmixX1HjLGBPlA=;
        b=fHJVGqwvA+lUcvJIed3Z8ZYS+5rv4NQKLBrdDQtc9viSaBtNMFMcUO+wmMSRZfYwE0
         eMoS9/G+H7lwoClGxVhiezpw6gOFqs0mFwVBasS9dITM3MsOepqRqGtn+AGbCecHEl2V
         L6REa9YZn8CQazMOvuj1KQfMbuVPUe7Rx1WFNg76yddksar9SPmTGe9/0q8GLFFnJQuC
         eet5Rmu+xipb3IuVJe9v7zwVhzxaFTsLvxCD6IuoigsxSWm6GVMOp2/fnYwftj6TdX9+
         9iCfMnf7jwcdqzqV7HlooiKlyJYMn1sVf8bMr3SqzliiWWUlBlDOw9oJjzQcpbtbARgf
         v9Zg==
X-Forwarded-Encrypted: i=1; AHgh+Ro/uU6NYXWJ+6318e1HbQz9fpCANX7g+RKsJ2KWMQBQLATlAHJyqYXcNLrq6YHV4nSl3J/iSJasvg==@kvack.org
X-Gm-Message-State: AOJu0Yxe7rnKKnvnMuq01fzNpiAyMoaLQFnk6lucNHmAZMsw7/Lf0Vdv
	yWYDag6S1F/pm+zZ3zaJZNJzl1ICff6Mal72lwTWiHiiBknfbSqThEr+
X-Gm-Gg: AfdE7ckUvStqvRRVZXhgnkwVCpIQo92TbHdnOshgX6YCTqvvSvCaCdRtyWrQhQSc2k5
	DM4HAW9qpGp1NERsCtlwEKPb5CfEEMfyzw/c6qg74aHMOqbLlX57H98avdW16MMfvVwQZ57nYfp
	wGkugzwdSVLX151Acf2G0xnyX7Mcf6w9TVyDGJH2L0gei+RD+tOqgkfhPMyi2I+hHwQaZ4Df2a/
	iJe8irH74E/DXqJq7vLnOX+FgShHVHEU5A+As5GNnk6IY7C9QVAA/Z2hTvBBlu//OVnvcG6RBqX
	TmoE2d1jELiSGvIt7qu84EEvRUs7VRF/kIJqTypKffxtGO1zDGRH5U8LKHYH3aIS8rPxBDv+h6m
	nF9AkX8w9qPzZnwachvEbghCDCbmElDXNDH4iraXxHNNYvmThihBItW+B1IiUc6byh6T7NPS3eG
	yXg749sqvI2CLWWKTQt1X0O/hHOA9DN0Ti0domx9MBl49ubZyG/d0=
X-Received: by 2002:a05:6214:5913:b0:8f2:2e4e:f5f with SMTP id 6a1803df08f44-90401b75879mr187179916d6.45.1784053413454;
        Tue, 14 Jul 2026 11:23:33 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm173753776d6.0.2026.07.14.11.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:23:32 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 03/13] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Wed, 15 Jul 2026 02:22:33 +0800
Message-ID: <20260714182243.10687-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fhssawk1p71kiwhizs8a88fp354bohk4
X-Rspamd-Queue-Id: 6578116000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784053414-790004
X-HE-Meta: U2FsdGVkX19UGo4s8gHCKpyXWdQdeUrJ7eJfMbuypcWR+yo3HjC/mHIaJOXTF6ZUosR7hK7+K+d3Kn3ndx0O8JsIz2vjDrqZ5pyedRlQ1PoLkyXMmqqoDxa+jyriCSaKzngY63wg65Z4jokBr8V2YSUjYNlXDINCi8A9qjfhaxJhtHi679Al7wKZuZvayPu+QNmrI8tX5mkN9CoMZ+lL9vmyAWqv3m3vHH6YLt2i8J61CXzpEG50Cuyi1JN77Vxsn0lJZT235RJUprzll+iQzyISsb0I5hDI/qZEtUAiEaLZMmBQkf1UUZkbiqyIaf9qlV6Czge5Ht4oSrMDJ+WWfKlUT4kn7aWVIUSUN9iDRgWp4VvN3TWmk55nbbRliwdVUGzEofndSfO/gjHDTX3Ukwf/ZQJEgadAy9p93jaxy3gIn7odHdh2n6MAupU7z2yiGG5a+sCtQb41uWujKzujKnXqcwfiKL19OmQgh0mKx7/2ITR5VB186rEIgGl+h5eQuJnc+fLRMYUgVBvlNblJs/V1FV6G6XZgWA7kvagxi5tfSyRZgFcHOjqrA0SjxgsHsV4XMGH6TSe34L5aMVh2oqoDDGFI8GdAQr4WZMVPh3Hh0v4efvHiO7uvGgLJ4dHv3MR00d32fqxhFzsiC46rnMUZy9+sshU/0vXFTzDecYrojiyMc5oXYkY1fJi4lK4j9QMZaPfpoW1alJpMoU+Ye1ZCCNlGieS7ciHBdj0I+ClJu2xzZHBk2Jxhokw4wEF5M+6nrMi52291eOovfoWK5hrIhaD8zr3yg4Op+krS493cvHenSgO7BelFZIkEh48R4QyDof3++36G6dHDR1TcXv+yhNjTqQ24Vq0CvRNpWhGDO8GrO7UpAHodOiWore72oddN2TaVlr5bXWivwbsusvJwXjDjgRFrRRap5Qls1ulFrxbW3AYm2pDbC6t5JuN5l/86MYyzPpQNWjSiqlD
 UiXovHg7
 mAcbbz9QO/2YHxr7CIsnRSo5LPCwYUOprCIh8tFogAeKicNn5PMcGigMacjuOO77f7pKfvEnEqajb+MbKyt3uP0fT+eYkx+0IVHMhK6cJVL5xYJ7J9ciBjBfxHFrEyyYQ+sRXKBmnbmi6p/KtS29BDiWmptrpgwRL3kmLZKBon8bQh+wOnXS0K3ImjZP08rN9JqzthMW0qEgndl1W6Prz3oqVCG+mqki7L/jmbetnPDKLNqNqJgVPXeXTWivC/iP1QQwTkjkJ+bX7gprXi9gH3MTjvqorhf1iplRbESvHFtRC4KIDPJg2q2K8ufehicSTJX/QpKFHNemSBadG8CDDtfSTlSiKioG/AigPrnGrKKCHUr5fsFQ+pfG6IqM71wcBDCTliUFeX6uFL+biJK7wnDlCjC5WW/S4sDrwOOzp48T62+h26EzsNSM+AUpOP5nKpMDJ96egSrwboYjXQZ7UdkLCZ+6hncZy/yhPDv9y+MnDnUClhosGDp08LqYtekhJnqxDpqoDG1EFxqs2wX2c9YfI5TUcO9ubdbbN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new arch_reinstall_hw_breakpoint() function can be used in an
atomic context, unlike the more expensive free and re-allocation path.
This allows callers to efficiently re-establish an existing breakpoint,
and x86 advertises the capability via HAVE_REINSTALL_HW_BREAKPOINT.

Since a REINSTALL may change bp_len, setup_hwbp() must clear the
slot's stale len/type and enable bits in DR7 before re-encoding:
OR-merging the new encoding over the old one would keep the CPU
watching with the stale width (verified in QEMU by reading DR7 after
re-arming watch_len=1 over a len8 breakpoint: 0x999906aa merged
without the clearing, 0x199906aa with it).

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/Kconfig                     |  1 +
 arch/x86/include/asm/hw_breakpoint.h |  2 ++
 arch/x86/kernel/hw_breakpoint.c      | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..5be698db0241 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -246,6 +246,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT
+	select HAVE_REINSTALL_HW_BREAKPOINT
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK	if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index aa6adac6c3a2..c22cc4e87fc5 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -21,6 +21,7 @@ struct arch_hw_breakpoint {
 
 enum bp_slot_action {
 	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_REINSTALL,
 	BP_SLOT_ACTION_UNINSTALL,
 };
 
@@ -65,6 +66,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 877509539300..4221dbb899f9 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -100,6 +100,10 @@ static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 		old_bp = NULL;
 		new_bp = bp;
 		break;
+	case BP_SLOT_ACTION_REINSTALL:
+		old_bp = bp;
+		new_bp = bp;
+		break;
 	case BP_SLOT_ACTION_UNINSTALL:
 		old_bp = bp;
 		new_bp = NULL;
@@ -134,10 +138,13 @@ static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
 	__this_cpu_write(cpu_debugreg[slot], info->address);
 
 	dr7 = this_cpu_read(cpu_dr7);
+	/*
+	 * Clear the slot's stale len/type and enable bits first: a REINSTALL
+	 * with a different bp_len would otherwise OR-merge both encodings.
+	 */
+	dr7 &= ~__encode_dr7(slot, 0xf, 0);
 	if (enable)
 		dr7 |= encode_dr7(slot, info->len, info->type);
-	else
-		dr7 &= ~__encode_dr7(slot, info->len, info->type);
 
 	/*
 	 * Enabling:
@@ -188,6 +195,11 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
 }
 
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_REINSTALL);
+}
+
 void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
 	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
-- 
2.53.0


