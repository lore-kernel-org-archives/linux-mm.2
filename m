Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A75CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9152E8E0002; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C09E8E000C; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7881E8E000D; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 605CC8E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D26F812CEB0
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
X-FDA: 84100698612.11.D296FF5
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id C79A01C0007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="iw/i1w/6";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922305; a=rsa-sha256;
	cv=none;
	b=8AWV5+iFSg0+SzPp971cRwU2xWoyQivPgd/XcGwBBFFIjXfvT+2uW5ifyMCt+hT17Ycgwr
	gvX42n+92xe/dgbzTw1SksiLvwEZqXryGxQ59nTagwy6oyWwnLkQGnOWndV5VjKiVq+nr3
	+ExsUorK9XHxSjXxizHbyb24Hsd8Vuw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="iw/i1w/6";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImePh3VNFlRKFA3aVONVbSvh+rUXxcMoLlx75oRDw3U=;
	b=cBtk+Qa7P2gmHOBia7qLkel+jdoIKcSdaXkdDmf5zpYgwl+B/KW26YgTltGta5LubRotBl
	6ZguOqqS0CCe0wvY0kMqMwVZHdkzeU8Nem5Nq/PLP8bZZEHGGCJRSFmZBK9/ZCIYswTZtd
	erqwSIaGUUg8XHjEpIv+pEq2/h8Uizs=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDP542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:40 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDP542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922262;
	bh=ImePh3VNFlRKFA3aVONVbSvh+rUXxcMoLlx75oRDw3U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iw/i1w/648NO7TZtCXNdO62MSSpNC6K1+hE9R5NtDidCW6k9qnjNhaznD8pRuVvHl
	 inwQvXbsqXoid94hh0p37hwVISa5fBqQ6m/LB/7GMOB/J1iM2W/w7UhmaRP2iKvv36
	 FPseIA4s0l7kbhlvxQfDsakhZjjv/n/uH1TiXHbGO7qybMS8oxy11syPFpkVbV6RXL
	 Hxgkana87okfNBw22VrS8kJuMDZzMp52rSp8XDw7vJlOWbUjpTJ8LBzHJ1jSElJksA
	 GaSzSvzUTlm+gcUViJcyCi2Yk05cF3RMdv/SWx3aGtCsuukwDw9v8zFzhuBRVGTdZo
	 GgsEyvfvOeqkw==
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
Subject: [PATCH v2 3/9] x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
Date: Tue, 11 Nov 2025 20:37:21 -0800
Message-ID: <20251112043730.992152-4-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C79A01C0007
X-Stat-Signature: a9qss94cyzp5u6yyaqbwdunfn1f5k7y1
X-HE-Tag: 1762922304-476790
X-HE-Meta: U2FsdGVkX1+oXgkmeKZJF/nJ2hyxfSsab4OntDKYzjmKLFcuHl9N4AbfpGluPQGoLJxBwj1GizngnzYloYkhmyG+ausxwP8cwOU2F/M1FGo/rguaviIprCgh0JmYkHiAtblyX1lAgx8T8mpgm3J+swoF3nCLiGA4p0rtihN0P53VGnyvEZukbDcyMe4i18JRSgwAS1M65tcs8825sCgh6i5kAxBwtvY9q2+QoydjG8wbxbbECQn6kRkERgtj+azc5dRLcjnn/7W/XxkaoSOcUuv+wYWND2aKnH/PQTSyT6/+q4uEXABRjeeSINzxBAW8xSX6Km9fka9CGL+cHdxRu6rN/9myAsy/1SVNO7tn/3Ogn7GBU14JlWRG0wvmcxlezaijURRhEYTen1aJOosTSYZrzI/XikuwezqDKHEzcH9frMe3ADaaYcgIDy0HBPPEQ4AGzKHfgDtYcG8bIxGA5H+Cy5n91iLOdxdiiKO3aAQ46njxI4JIa5AAxwwMyioMAD4YUwW8lOyTGHx+YCWE8eOmyhkflN+BluYcW5iBPfKvjiQ5COftDutd9BqNaGDjKHxaWbUD47gz50Xv50pgqS6aQCPKhq45bqHmDe3Gn7iAoOQzhdmBK9hGkxrnj7HNvwwkDE3IXOxXjUK7RmPaelbIeq0KVuhcrYrSm7R9WITjMLMt4aX7ure1GOq7/RPMLWkgbnv9ffS7CkTabl2M40GzPbJFhgKAiSw5z5zhJDuSBTcts1DkbAwm80juDMmQgjjob2+lJdQYV1nDr5S0qv+hUKlI+xegNKlpHSlr8RGULO3ZfUChvqKwF2ZizNsZXI5Vj8nsBnl/6yIIz1GSHGMk1MNmlns3yS138Boz1qRduDVG/R+iQ4utbtpmkpXKetPvd/u550COOqMNTD8SlP63CYnw0tbA7cyoEsWDMzRtsGtXcD4rpdNDIGIXAZzSLRTKUUCcMRzbtBawPCB
 nbsxMgF5
 ZVPoavyZ3JxTfo0m70K/O9zX3KFZGJpPZxgZArz7jwP9t+/1ipkRtVJCFJWNzVdb9wPb438ttnMVpN88dEh4cv5HIgiEEZbZJ9uTCL8yRH7cMqYp0422Aaw2ykjfDjIzbj6NKtwWWRXeBSpqGtXXjK0JzxivzmnCxuTnQlwqK7PZUPosvoq4T+tS57sZ9MRxtlJzRajO8lXiHh3uZQZjsZiZWJir0dEtzigDF2veRmy0WtDKWJOgMut33dNnuKBC6wQ3wXUGvSJkitCB9stj4CsjR2b6m5YEzZSeObolkBqAj9VaOf5Fc8Jbik+ihX5OH0fi1hknuHywtjfy5WXe5qZ2ZpQ==
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
2.51.1


