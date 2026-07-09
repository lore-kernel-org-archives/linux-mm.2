Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401A4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7B66B0088; Thu,  9 Jul 2026 03:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0783B6B008A; Thu,  9 Jul 2026 03:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83AD6B008C; Thu,  9 Jul 2026 03:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC42E6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:17:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4339FC26C2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:38 +0000 (UTC)
X-FDA: 84968382996.03.976FFF2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 779AB140007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=PtIuOfMn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kRB50jqQ;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783581456;
	b=gl3e4Dre5KtxvJORSevEKlNxRnUvtnc2nypFWK5SEfF1rvqSmmDAtXUTTL4k7LJamFhQ8C
	l3bqm5LUzNEqmXKDTbT8mELw3hSM+2ScWKOSLKFOqW6T5ZN8rYv7rKRVhYGEkr/Ewq3Et5
	CH90fWc2DfTQ/JuaHesDqI5I2VwTU1E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=PtIuOfMn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kRB50jqQ;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783581456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9SKBxLhUcVP1yEBFgHPNey4vuoMv6f7r4rXayVZwUY=;
	b=iJcNlZ32wT5c1rwDESO4v+EskUR0Qh5vi6KYTkEnTd8681z4ZE6rr/FKk/fjnY+0Id9ki6
	4d7LxNGBWJhT+8lIGH3f0G+2UZ5ryTbEW+iADmLmQCgpIQXmNORgOUFM7drQgHXcDDV/lI
	9yTyRBPZ+NO1abPqcAU7D4KhJrSu5bs=
Date: Thu, 9 Jul 2026 09:17:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783581454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9SKBxLhUcVP1yEBFgHPNey4vuoMv6f7r4rXayVZwUY=;
	b=PtIuOfMnH+4L6RK5zWDYM9QxZ7qFIDDANU9HKLo3euM2pysXCVMwAa7n0WM9qlO40a3voh
	DuJIKMU8fzWSzXZ9l491Z4XBQ0KTIpmeIuhHSzlg0CK5YvnKbZ7s/RIGLP21o2M9L0o7Rj
	zSwnXdwJoMA72KBAhb8rJmxHHKXCqXO6C0wmhoPJoAi3VMyrmMFTka6l8meEuom7fPLR+m
	ZKJ+2UBpVHoAgJDHaBFHf2d85mBPBBieEtIIpIP4KHv9WbVlPQOC6fsZp4ZIgta2kndNxF
	O5hotz+4KOFHBJCxuyk1T/BLRhXpjFxIvYbJmL/KCdibPRgi80mtnrAOWqSnIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783581454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9SKBxLhUcVP1yEBFgHPNey4vuoMv6f7r4rXayVZwUY=;
	b=kRB50jqQviKOML8rg86X/o/Q3HTiZaVrhqXPi05nX1mZw5SlYEe6ldifyk1fa0K1jn//2f
	uWSs1Y9MUuicx9Bg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com, 
	linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	geert@linux-m68k.org, tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, 
	glaubitz@physik.fu-berlin.de, richard@nod.at, anton.ivanov@cambridgegreys.com, 
	johannes@sipsolutions.net, luto@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	peterz@infradead.org, wad@chromium.org, thuth@redhat.com, mark.rutland@arm.com, 
	ada.coupriediaz@arm.com, kevin.brodsky@arm.com, linusw@kernel.org, yeoreum.yun@arm.com, 
	song@kernel.org, james.morse@arm.com, anshuman.khandual@arm.com, 
	broonie@kernel.org, liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com, 
	austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de, sohil.mehta@intel.com, 
	andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-csky@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
Message-ID: <20260709090525-b1e5ae06-1fb4-454e-919c-6503dcf3d073@linutronix.de>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
 <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
 <21875fb4-434b-480d-b68b-e2ffd5fff5ae@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21875fb4-434b-480d-b68b-e2ffd5fff5ae@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 779AB140007
X-Stat-Signature: qc7o366didxojhkppyrndzfx5txx77b9
X-HE-Tag: 1783581456-909773
X-HE-Meta: U2FsdGVkX1+/ic1eD15IH6Svpov5VkuvaR+Kb769LMb5B3vkJD2VoR5fwAclMjyBndf3tqY45vHw7k48geN+xlOEwsvmKR0xauOn5aJSSmOL4klCR0ZrYqImy2+S9iXABePSm6lI9ul/61KTFKSAG2FDFXlSq/oE8NBmMEl9PVamLt4aVjs441DE3uweYa5WjdsHMEN1UzKcdUH/+1c4tX/Xk+8QlnhDnCg9qn5MgUe2//iTjh/Z15jyer0NUEVXq00hAJpMp+zbPiba/qOBwCIrhYfbGCtHBzeVGAY6HeKWUmoo0hEOvQlq/SWaHTJfBaAdrE8yhgbPVaOcRbPQEIpiHxqreUly7m990/jRcfkmtZ8vT8McK/AEo3dmnsnShG3ZuqSUa/ieX8CJsxxYFY/ta8H3QaB8F4bgvgNQ64e8quhqRNPTmWgP62DSKiA4bA613Ex8qkLo8FYCHCGmok82weT8UpovBfrtbAlnLjk2Sx59w52IxjoU01xly+VMQZtzs/YQupwHFgKvv/6M/jsYGLuWKpv1NNpxo/tNBJObCZHpHrcI+0MGlgW0dKaR700pj+wOGs0+wq9Et9RlykHr5e6qUFkHjSo+UGL8ZLcS3QX8xo3uRsT2lZoGTuc2xsW7MEsYrxjcyovjdOv3llV5gXz32xxMPrbxJ0ZAArfCjRo+GKG7SrZbFUw/znEqI1zjaYeno0wMv10KG4ODFBUJCpDaK2YM23TNGj2R/VbdWT5JPssjqFVd2zHR4z2GclC24djaG2osJLJwf8sXjBOu12n0TMImrU2IRxEXqy6crsx+35IaqWHtvIq4WKW4Y1iBEt1ORSaCccyWjXhgQ5+ZQWpRrlXLINmBgppLBmy4SQuXeBWzGg/83S/JbzPok2AQKuoIlCteX+501dDs59MUcsrgO57926D+5xdChVBNix1RxfK+YZxuxt4pgs6u66AXiaUzmxFot0CBJpX
 5hHXzdKW
 h1sTYHif9Ki9qGTZKLVvntWmlLE8aSGZ9kVihOQ26j235B+437DFBPvMV7yVCd83d6lHZcYfNFCVbv6jRqeH2uBCMi8ne/P9lektTmhTNelQxgHR7W+BQ54fVqu5ifiTjCjVXf2jWxSka5XibnpyE1KdewuSPqZyyCUkb+wit+yGQl97Ne+tfKKm/t2k8ovxGCdiXwv7mnqVvZ98PVDyWMY5tSxDw3cYqokXTBQlzjLOjAs3QRELYvPBVKXANI6AeXF7OnEbzxD1CKn8mTb4Z2ObfAQAxps5ml0Ok4x/hc8npxYztfOVXJWfyqLiIJWplnV8vtV4mZ7m0SAPcvvfsI15Jl0PIes5LlsfYDQRqWWR2A9FLkoWQpjdQR2L3rBT7AsV5X58FnlzgZHm1zpwcO20fS7L4AWL2zUXs1CLzuUkAW+Cwyc7kLnNtQCCK89XfOgt4nVuc5zi/zrSnPOjzuKiJdW3wSBMnZ9BzWM4ZI9Is++cYOk5nO2biqfjsBFVjFWoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:37:05PM +0800, Jinjie Ruan wrote:
> On 6/30/2026 11:32 PM, Thomas Weißschuh wrote:
> > On Mon, Jun 29, 2026 at 09:06:16PM +0800, Jinjie Ruan wrote:
(..)

> >> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> >> index 592dd8668de4..5a0314a3c26e 100644
> >> --- a/arch/arm64/kernel/vdso.c
> >> +++ b/arch/arm64/kernel/vdso.c
> >> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
> >>  
> >>  	return ret;
> >>  }
> >> +
> >> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> >> +{
> >> +	unsigned long sigtramp;
> >> +
> >> +#ifdef CONFIG_COMPAT
> >> +	if (is_compat_task()) {
> >> +		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
> >> +
> >> +		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
> >> +	}
> >> +#endif
> >> +	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
> >> +
> >> +	return regs->pc == (sigtramp + 8);
> > 
> > Instead of hardcoding 'sigtramp + 8' you could add a new label to the 'svc #0'
> > instruction and use that with VDSO_SYMBOL().
> 
> It seems that the modification of __kernel_rt_sigreturn() is not recommended

For the changes to the object code of the function this is obvious and
well explained in the comments.

Such a label however would not change the object code of the function.
In fact it would not change any bit whatsoever in the final vDSO,
save for a new build ID.


Thomas

