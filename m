Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D821FD637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236376B0089; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D4A6B0092; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93276B0098; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB066B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A614140823
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:57 +0000 (UTC)
X-FDA: 84226619274.20.8256C08
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id E38AC120003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=mTWPV4T3;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920415; a=rsa-sha256;
	cv=none;
	b=KW2V6rod9KVn5sFWyUmmesvHkJMerq3s5uY0Zco3+J5sSNam8p8QznSqSxDgGoj4dL7gKM
	U1G8wgB1alkrK/2O24sQLSfj6uoy003liFoNEMyK4Cgc+LNnbuMtB4a1pRqzLXAu4OeQrB
	1B8tQ21k/cqVU6iGZ1DxWZr83Gfcy3Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=mTWPV4T3;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVho2iKTMWzAOd/OWaBSJbTv3DT5W1zC1/L1M7eea/8=;
	b=etxH2+7+kHDUD8LagDJTLuNSehPm2/E2garU5dL4JkKRv1QSto32d33IQNN/DeBYV2U6Am
	y6WMRYh7ioB96rLlc2T2Qq2r1l1XEYmPVX/4tJzI+TsT5IjyQFLdVjYANeBLTODCt6g4I/
	RFPzn84jpYCPt9H2bWhuWzbH2zl6qTs=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC232563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:21 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC232563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920382;
	bh=VVho2iKTMWzAOd/OWaBSJbTv3DT5W1zC1/L1M7eea/8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mTWPV4T32LsdgIUAUxulKyJglC0lEQQXWDC418iZYLOqAvtuXY6ej0zpaZWqkTR2g
	 D/OnQat9s8GAKwoNr2iJvBGFXzev6L1K5B53TkCBa9p3LoIQxqQycnI7jsjfHZFzHL
	 m/j1YMTmAlI2wl/9EuM3it0PXKftu3FveJUuhKuguhWu/zDlFBSrvC2r5aNCR77eTN
	 P4SfbARzVQVSPMKHLWaT8oTc/sWqxaxQLyHdAtiVjgq0hW6ZXgiI7lCROF5b31Q/b4
	 H7BHHvSAcKo35c1tLY8vqdxuRhqHCZgFQcf6lAQJzRkDgEnTf/7IKK9Jdk4x6lkcD6
	 TKADZ/12Kud+g==
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
Subject: [PATCH v4 04/10] x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
Date: Tue, 16 Dec 2025 13:25:58 -0800
Message-ID: <20251216212606.1325678-5-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E38AC120003
X-Stat-Signature: grahikx1oii69eebm3gi6o9odhhwxgps
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765920414-622058
X-HE-Meta: U2FsdGVkX184mIL+LGAscj33GCiHZHS2qi3e1n0pkYvHTynxSx/Cx7jqBzlRN8jYpMwGSRst6GcVvqu9TD9CzrlfmXG4JNQ68jVESsYK37oI0OS/GpzwVORO09KByHg26Y6YUYStFJrnmg/WZ0yVW5ORjknPGOFXzvBoA2ij7FD5VpJxZtK5ZpyODjJVcSAt2j5oFjhKlmkGI2DHsO5QY4vJwmBP/k1jJxFnPa5UnygsieAbClN3CnFJm3BQkjX5E/pSHcwf78W/llgyQfSSGXYy6nQvqyvqyfnJCZkcLrRi5wgsnEpv5GlMUFa5oV+rscMAkEFkN9YplStibscIjuOFSUkNXi3dDw8fx+lANxHq7kwusarwgM2Xmud60LFt6egeit1IvD+WKVg9vDVQG6n0VHNZn2swdE9UmpNnXEx2Q2fYZVUxAaOi0mNi8T+od7mk2l3s9ZkNg1lXRhZ1AC6I+6NA6o7WgPfxzGVJ8CrTqhKaQRDMY+spZkCyX9lsO3uoGM4LOCshDGkLg/QcRwFGKrnyHQ5WwrYW9lnWWwGEI9GXAUctXH60E2nVvEwFEpZHvBy/ay5rW6fLRMV+4G+IBqa9/TgfPWEs6LjLq0J9nQursc/vbd/lVrmKiroho/QXh+5cD4UYI+8OuG5SwG4OxDBZ144ov+fLebSjHXlhOBbjoA6XFgjuopaeUc/LUmq8hRqBr+eWaJKsSlDJN8bRQhimm6E/ZNyGhZizlMh/Didy2b9DJSjvBxP4jlcVwpHN8Glw3gs4AdlX1N08WyGnmMQeVPF/i0wrll7Adv5kfFDVyC3AQf0LWTOu17sd7X+gG8ygmCJ4zsWE4IkM4//oKNZ7MWy4p/SUX8SGI5fjm2hi+VbrdVpqNO1Pl4LN/EniWnCHJONxFv1tgn6D28PFmCdYRir8VzGSs0AkQRhkFqG9az1bv7vHGkWJPay56TiTg+pZED8naCBYvn5
 NJkK5x7q
 f6bZsvtnNvSvLhzabfaN6TWOsO/sEFAjE0m9drbXN6HP9pmSba82eD0L8qZHuG0NEp3OctPwIPXBQE8HcK1scKj0r8M4e/A2ZbhSFSMnnyJXYQi6sX7Zk+2vrj8xd1wVI6CT6tkXb9pH2DvHzk/sBdpIqsiD4VJ5BO88VFPeGVG2l5Qtht0JO+e359JXbJq4+66cH11HyomJY3ANDeX4hl42nJxT59Dl+VCE6bRfH3yaMY1mYyWavIstji9WhpVYQahYZUk2ZDdKi+fQt+H7SwZbV+tNrRSzxXcp+4tso9Ik/5RUTB7JT+7Uo08mGJylzNFC5VPusKC05eMbdz3lRvC50yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no fundamental reason to use the int80_landing_pad symbol to
adjust ip when moving the vdso. If ip falls within the vdso, and the
vdso is moved, we should change the ip accordingly, regardless of mode
or location within the vdso. This *currently* can only happen on 32
bits, but there isn't any reason not to do so generically.

Note that if this is ever possible from a vdso-internal call, then the
user space stack will also needed to be adjusted (as well as the
shadow stack, if enabled.) Fortunately this is not currently the case.

At the moment, we don't even consider other threads when moving the
vdso. The assumption is that it is only used by process freeze/thaw
for migration, where this is not an issue.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 8f98c2d7c7a9..e7fd7517370f 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -65,16 +65,12 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 static void vdso_fix_landing(const struct vdso_image *image,
 		struct vm_area_struct *new_vma)
 {
-	if (in_ia32_syscall() && image == &vdso32_image) {
-		struct pt_regs *regs = current_pt_regs();
-		unsigned long vdso_land = image->sym_int80_landing_pad;
-		unsigned long old_land_addr = vdso_land +
-			(unsigned long)current->mm->context.vdso;
-
-		/* Fixing userspace landing - look at do_fast_syscall_32 */
-		if (regs->ip == old_land_addr)
-			regs->ip = new_vma->vm_start + vdso_land;
-	}
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long ipoffset = regs->ip -
+		(unsigned long)current->mm->context.vdso;
+
+	if (ipoffset < image->size)
+		regs->ip = new_vma->vm_start + ipoffset;
 }
 
 static int vdso_mremap(const struct vm_special_mapping *sm,
-- 
2.52.0


