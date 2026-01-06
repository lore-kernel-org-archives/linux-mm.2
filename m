Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAE4CEFD12
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6C96B0098; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B923E6B009D; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACED66B009E; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1C26B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C082CECBE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:12 +0000 (UTC)
X-FDA: 84302807064.01.1758B19
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf09.hostedemail.com (Postfix) with ESMTP id 982F6140004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=HfvJFaa0;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf09.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734410; a=rsa-sha256;
	cv=none;
	b=aSc7GYvnv2DqNdTp2VkrK0JEuK7unIBe5mWMDTyuojyyr1uR9qmk53xMFr5lE/Zler7oTr
	Z/zZA7E8QERwlY9bN7e2dlXxQMWl1fUZShtTY/uKBkWBsOxLm9VMBsxTOTHtxFGvhWsyrU
	ysL1HwWgKyzEC9MUBhAn7ZMOvuzQvP0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=HfvJFaa0;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf09.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVho2iKTMWzAOd/OWaBSJbTv3DT5W1zC1/L1M7eea/8=;
	b=xyX2a8cn0kaY1YKLQ7dZxIQHPkjdGTKrqgnnasUEvdE+bj4rKqDbE4o2/HzcNvcgclQ8XY
	Wuup37/EXh9Dq05zBR0uqYuKMmoTnM9WjhF49M1Ct6xNVwE2+J/qmoQpzlB/KWAjapNCjr
	ha8SOjYmeRsnK77qww5VvJlz5nx3qKs=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDs029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:01 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDs029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734343;
	bh=VVho2iKTMWzAOd/OWaBSJbTv3DT5W1zC1/L1M7eea/8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HfvJFaa0gTbb2tkyjNL++bFb14gaJoaIOQQF17n1QCVepF2wHwBcovxKULPWgJ1O0
	 cApUL2Mc+6QipWb7uMwNJtevej0iVB1RpTlNLOeM1Wdc1n3Y5FawDz/hvQUSdtXOoG
	 jg7VkzjgGG+Pq//POPW/584bX2WXOJ3SD65xbBc/UQ040ebf7I41FAqcN18XClAnwe
	 xAfdpgoYDGS6dtDkoQFtnr41Km6KUGT/969P/ioHtKK3CeiSyfVUZpU8FNQsBovCNY
	 ndqBRuF30ldODoUvo8SiHeGJKcDKMfejZpXuZilgaSKiKfKHHumAPGmal9NtF2kzJI
	 IWS7NPMNNV0NA==
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
Subject: [PATCH v4.1 04/10] x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
Date: Tue,  6 Jan 2026 13:18:37 -0800
Message-ID: <20260106211856.560186-4-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 982F6140004
X-Stat-Signature: sg46igmjmj4ft4j9yw7conewjrjjzt98
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767734410-956906
X-HE-Meta: U2FsdGVkX18bOmreCWQeyUr0YFBdBkPjtOxOgpVyTKrngeF3VjQLnzZ2tey5h5NnEVfGObKxdEE3L3W3P6WWoY+JW9PpluH8LxLLqKocgIx3M06/u6NPnXDXZkdsrKw+e2r1QUZfgHRQ37m9RIPSf5+/GQ1UD3rcsFgWyS1trfmF9l/w4zJqSf84JVOdrmYeYftHhCgQafQrSlgLMkFPALbAJ/ERf6nNdQ6Jt6RPizwrVAS7TQHFCCnA2rX2d07hSg4tcryRz78h/nUdIdOdmoQ57DRBMbq5lmnOWwD2+3y0ATDf84JUmXUsohPaKJ3Hr9Dgf1X7LTkWzLjEgTWInQBfNnwFTZEPBiWNgUqtj667QrfWJLK05US26UPAhPuUHe3vv+GFKNgcvRNnVzVng8XdBWNOsVrq/6K2KBZ6l20li7EhzkJIKExJV/vpmE0w3VGHezh+AuX7lnnMkI4ko0L8wslYZIKxSdTwGaPt20osT0f62mY+z2o6LsSNMMMelAf2inLC0HHNAcloN9cfwc2aox8aIAR2LDOec9yylwLF7RbnCJifcBt/7hgjAw8GCSlSBaZ7nvKMhIh2VusCbD6H/HqaW3HuiUZi6VmXWT9AF0eSzp/azII1dnUYP33IjUr/4F3JkHc/GfFH6OihMA+G2xXHPZBEB02yM9nDbiR6Yh8B+E2zQlH89I2V+4vPX+/9mBDbCVY00yUbA1hwcNqcWNqS6V94m+1gSGV7JM38kIfADJAHClyGw+pSZ4RREfw6TX5W0Ae8I1JcctDoFyikpCXF+HxNmr8o831ejCi2SdKjIxUrv+1lVCuwKXbek3fJVFuR/URy/H8YRcdW3hfN1A4yXY6W8cehfxhWo5OUVmt6xa5V+juYjHxe3fcPtVmml4bliKXvDTi0RsX9pLMMyzPad5JOdOdlnaNEXltw0FPGLix627pcVPjyKPQFDMScn4YxTc23Nqwi6SE
 gMi2aT2f
 1L4ZOwkhda9of77JXKlvRzgxhAza4GstvuUF85tJBQGtlQH6hjINHHR1/kIsAooyJM0IZr9pEo6V/ApHyQI53uCkwA98P8vR0y65K/mtsZwnV7T14nZ6ZXcnsIOUrjm1P0y2lrXvaiICJzGpyZMP2LML1GzQU2H4E1/KgB2S5N/FMmulwp2q5isNN8ufojDBpDcC0MFGc6ePTTPKtHb+OiT26WFvuDEheMeF9+ai7pTn57gJbo1CCq7GMKg5XzLA2lOSUsjT5lQWSkpddiOS75L6ri98WhAg5Z3BEzYfD5GEPmvX+eiynh4xj88mWh9MzhGEwkxfseG00W35WeZ32aiwC2oCnNZN9ZobmtQdT7BYnZgY=
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


