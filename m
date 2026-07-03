Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EAEC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1403A6B00B4; Fri,  3 Jul 2026 06:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2246B00B5; Fri,  3 Jul 2026 06:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FBE6B00B6; Fri,  3 Jul 2026 06:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9D686B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:00:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 174FA168906
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:00:31 +0000 (UTC)
X-FDA: 84947020662.16.9270824
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0713C1C0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:00:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S7QhjRah;
	spf=pass (imf21.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783072829;
	b=T6qUdeuqwH0LXCUE7NNklxCy50eVKbtfUZgm4eJDRixVqX+MIJO+JK+fKUVmSGWAWJWdU7
	Gvd7EprKdhJxQVwDUeNYmtZ6HA5YbyFwo55hHhYSeHdjHxS9bs5zlpmbuyRdoIKsirFTzU
	TcRr8NJzqcQ1ZAcP5qnMfwENqA20peQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783072829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eAaXEt312UQloawJo+yaYovtDfAeaYocuuY17b1XAY=;
	b=izLTuUhjP4EfFC19RfDW2V1Zpd4i+dz6NIUYjiKw5rYgv7OGK6KjugmVEUNjMPLfVc/YfQ
	LUHt6GS6U3WA6AgkCseH4FIam490mkDwoN99VVr+kzc7TNfs1usc4OZT5jiHdWy0dctpA8
	LFk9iWUUDOiNzeuvs2RzwbLcwM7/q68=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S7QhjRah;
	spf=pass (imf21.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73C711F91;
	Fri,  3 Jul 2026 03:00:23 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A98773FAA1;
	Fri,  3 Jul 2026 03:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783072827; bh=aCTCeigzdW+DLmQcURYHBbc2LLCBHkNsbpfYvvGCiJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7QhjRah1ACbDsWq1fyjeQXt+EKdqlo9vLYGLe10grZ3du51t6ZFb4OLnHfKmugvC
	 xYIGBaOHJhM7/+St8RX1L1+kEfNfOXq3codPouX1rlw+gMBwRumJ3t0IzbR4AAn6ks
	 AEhSYO6Tc+ug7ijrNB2evf01wmU75WbW8DbnvJvM=
Date: Fri, 3 Jul 2026 11:00:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
	Jinjie Ruan <ruanjinjie@huawei.com>, oleg@redhat.com,
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
	kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
	kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
	James.Bottomley@hansenpartnership.com, deller@gmx.de,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	ysato@users.sourceforge.jp, dalias@libc.org,
	glaubitz@physik.fu-berlin.de, richard@nod.at,
	anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
	luto@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net,
	jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org,
	thuth@redhat.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com,
	linusw@kernel.org, yeoreum.yun@arm.com, song@kernel.org,
	james.morse@arm.com, anshuman.khandual@arm.com, broonie@kernel.org,
	liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com,
	yangtiezhu@loongson.cn, sshegde@linux.ibm.com,
	mchauras@linux.ibm.com, austin.kim@lge.com, jchrist@linux.ibm.com,
	arnd@arndb.de, thomas.weissschuh@linutronix.de,
	sohil.mehta@intel.com, andrew.cooper3@citrix.com, jgross@suse.com,
	kas@kernel.org, x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-csky@vger.kernel.org,
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to
 return boolean
Message-ID: <akeIK5TRCjlKbzbp@J2N7QTR9R3>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <akdp6GAu77-ipsXA@kunlun.suse.cz>
 <87cxx4mmim.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cxx4mmim.ffs@fw13>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0713C1C0004
X-Stat-Signature: t87emmobmehcd81e5q6q68nqcyr81da6
X-Rspam-User: 
X-HE-Tag: 1783072828-422142
X-HE-Meta: U2FsdGVkX19C+vsIyiAmyZZEcZxWdmtf30iV30Ca/8DnyK/422ivevBVe4nEHexogloMdsSLN/ohDP8WR98kP2jsxeA8PPeoaxtCLLciML907FBbykFIy8WVkWwl9wbeZAhEwRyEcLrqhSu8bd9ckDowGhH9sfn6UQggvqH4rNxSmAv0dIjEKpvBm0FzU7PwFf1ePueBh3nBSaMXfzGJWM8IK+hGOYtSuq3tlBrKHS/joJj48r/4neDjunrUjeRR00aMbSHgJ+3Lz5JGEctoFD1J2Y+Nt2DPFQtQugzNC1+azm3YGKXNXoFA7iyb5CHr+UKKbozRAh7cah5UoC4bcftUp/a/3s5aeYm/XUdHMB+gIQ6BdsBSI25Tirouq3KiEKyWqQJYtE0yKXaok00d5nJbtVK0ktk/6NnNueyhvnWMtXc92huBLJ/2d/lBYxmD8/OPiXo5HcfQI2nPkkmQgTwVM0xpxOF9+mmvVkQ6XCM7XC4W3CRdZpOfHkobJy+OfWFcCUmtCfYNEOs99cXyPG/emrqygmB0s+9HOOCDcp0JTTJI0SullevAGAFK0aHFuReMCmjDTtvQaPRgqGPRdlGSfQrFSLm/TeexFge9fkWxNWeoKjeC38wHAfNiL1JihNe5iMnQ2aQ2i6IU65vNBOl6LMFwV9F3BqQW46tqP2nDnoxSWdS/H+5bEaeLdbtUl1GBdhF2WjkmtBNh2tVuYDrexQqvBQ4OR8Tg9TvhVP436QVfKqGZevL3y2tG707vrOSLJQxMpDdIWXP725dB87hHnKEhSeYxlVuoI1ZwXrK+rvr8A7OGoEAMkkGmEBTyUyxKFsKr4qZRFyWRqR/VenUPxaVMF3dDVQK9iOso9oT1Ez2IgsfE33u+sjqqG0msg8kgqZ42xXzB+nfI9pN0wx3qHdX/S86LvZb/mhmJe5Jf+TavK27nULW//vpy6v4mEIFV3qzSLJl24prTSh7
 7tn5pLT3
 BSu+Y70ztOwch20CRrxMPWkcwbL9AK4kA8JNwZb62VrST/FyHDYV6yBolnsv+LziTBqtYBJhRlPvlyfGto9IM+/SqGU6HDrxhWvRB+JQ0nxoq9NnjqR7mnDqCMz+fbpJas8dmwipVettTdOErDsV3YfUx2MhCg5in2ww167z/KOu1pLATpaFdL96jJR+ZFw9T7PL6GE9PP8xX7lC+qAeINt+cdmw6yGUiAGOMPNzXGpXBwG6iAhHfJGxVbFAhCUt5zmGXkdLdUvKr3PmvHep5FloMkyqpkY3xN0eqmi8q3aH3RPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 11:48:49AM +0200, Thomas Gleixner wrote:
> On Fri, Jul 03 2026 at 09:51, Michal Suchánek wrote:
> > On Mon, Jun 29, 2026 at 09:05:59PM +0800, Jinjie Ruan wrote:
> >> -	if (secure_computing())
> >> +	if (!secure_computing())
> >>  		return -1;
> >
> > Hello,
> >
> > I am not fond of this logic inversion. The boolean is meaningless in
> > itself.
> >
> > Previously -1 was used to indicate that the syscall was filtered but you
> > chose to invert the logic choosing true to mean syscall was not filtered.
> >
> > You could choose true to mean that syscall was fitered avoiding this
> > inversion.
> 
> That's just wrong. Boolean logic makes more sense with having
> (!condition()). Just because the old 0/-1 nonsense had it the other way
> round does not mean it has to stay that way.

100% agreed!

Bikeshedding below; sorry.

I think the bigger problem is just that secure_computing() is a terrible
name that does not express the intended semantic -- it's not clear
whether "secure computing" means "seccomp permit the syscall" or
"seccomp is enabled and some special rules now apply" or something else
entirely.

If we're changing the return type, it might be worth renaming the
function something like:

	seccomp_permits_syscall()

... so for the code quoted at the start of the mail, we'd have:

	if (!seccomp_permits_syscall())
		return -1;

... or for arm64, where we have NO_SYSCALL:

	 if (!seccomp_permits_syscall())
	 	return NO_SYSCALL.

Thomas, any thoughts on that?

It's also odd that seccomp aquires the syscall number itself via , rather
than than being passed down explicitly by the arch code. That completely
obscures what seccomp is doing, vs having:

	if (!seccomp_permis_syscall(syscall))
		...

... but I guess that saves some duplication in the ptrace code.

Mark.

