Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F3BC44501
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984756B00B4; Fri,  3 Jul 2026 06:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DF56B00B5; Fri,  3 Jul 2026 06:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D55A6B00B6; Fri,  3 Jul 2026 06:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5170A6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:27:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9351A047C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:27:31 +0000 (UTC)
X-FDA: 84947088702.20.EE7719E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id C079E40004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:27:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of msuchanek@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=msuchanek@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783074450;
	b=tYUbqBWnfYti+MhIMMHBYWDEH23ytTRMqIrXN6DW5XKASmLk2NWs4gSwY9pCUhEOuw6Izx
	tG9dBurFGuQbVQuVNCZT635RT67MXCHOxVbkAuEDwU81puhggdYZh9PXV+tW6CSMg2GtsQ
	N2o/Oyi9xA06O3new1r0+OfeaNx7rKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783074450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzAgs/BEsj7FHZopxvIm9zgUiYjF8OFUBMNpzRJZrjM=;
	b=yKFBOlqLAkYtwtZFa45CrIJX4Q+fxc71rD2nJ59tSlaessmBGR++Mreh7DmYdXrONXGzvb
	ksqYUQaRvTcKv08cjj7LisfwRI+S7+QpDuupK9f01UsFgEZFFr9F3u9Sw93THR+0czJw2w
	htLOPur1DfLsR5oxuEd6vdlIshIJbug=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of msuchanek@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=msuchanek@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F70A74890;
	Fri,  3 Jul 2026 10:27:27 +0000 (UTC)
Date: Fri, 3 Jul 2026 12:27:26 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>,
	oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com,
	linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com,
	will@kernel.org, kees@kernel.org, guoren@kernel.org,
	chenhuacai@kernel.org, kernel@xen0n.name, geert@linux-m68k.org,
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com,
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
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
Message-ID: <akeOjqMy7HVgRRCr@kunlun.suse.cz>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <akdp6GAu77-ipsXA@kunlun.suse.cz>
 <87cxx4mmim.ffs@fw13>
 <akeIK5TRCjlKbzbp@J2N7QTR9R3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akeIK5TRCjlKbzbp@J2N7QTR9R3>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C079E40004
X-Stat-Signature: o8ix6t31d4kwq7twih95aoatoi3ydj6d
X-Rspam-User: 
X-HE-Tag: 1783074449-463087
X-HE-Meta: U2FsdGVkX19PLoifDgV0nK5VpyzmCIdg4dGPP3rWPKS7N0Ne9/ywCeppHrsVFAn/6ozueO2O/tEJ3U55gz/WAfXPLPiCqW33GMMGyJB15/4V5xlqR8V9GSjw82pxfNUMU/ojPxG3ZPpj9JALGf4xPgwrdl8vy0aNihIBFjVjA3aQfgvKtoHWzLSUQzp7pi4X6v5wlgUvATkSyFQTc83NCWfLQgVRuxNiRbmiIP4AnHwMlINIyrL7yrfVeNzAnqbxpbtzIt1VWjZFSccHT4g8ylx3xFA9wgA5zemeMBxuzTvXFrH1mV5uK14jQHjXQENVPw44JSulfWPqPYvGpcJLEVuDSmz3mdSQahcn9IvQe18Rh5IhUVSK6WAQoCklB8lFR2Hi3oM04S94E61Vem2Y5bM8r2zOhUQT3+713XTJy8ly+x1BAz8IvBNrNg0g/YtPwT0EZtZTKTj07jqbTqvF0MBiKPO9wCmT+hQUfQnpWFLZiW0lni2067+7IrpTggc95Tup/jM6Z2kvTKxl2o6DM8gAFeTnMhGLhpFNjzLEZJIBLOGzI7ua2YrtOXfDcOKdjrtP8SiyHwE7903ZlpaoYl6fqwfI6w1qHTdtT8ZubeQRBczGWlCZ+BeYBr2jLddv8DNmpYJrZhdM0BVA09sexdQstgikCI0zXWnblIfXFi8opRP8eNo4vdZ2sf+K2cA23cAWQ7Tbr+aLWhlZQhbeVnNbmb64qazfE3Bpl0ap4CcdI9C0c9laauwTTVAcQXpdjJnbOMK+sFwMfEQyUqC/d2H3iKYtZk5ZY7gR5CgVNmIWpTx3bGsgu8I7/G9yX3cBTwZPHhk37Sly+SRMa9h0Sjuu0ZYiMxm0wlXZvxqAyzCtDu5y6cpV9bBBYpHFjkd2vuMhGKOfDXLCwmScXlE5mDSmumGtHozgTp5EhBmAnVz4WA7A67MdIttHby4BbwUoPfo85BRlL9UtLZ+fDfY
 dEfoVjYp
 wfn1Br+G6SOIZKSSaPr9fVRlVnwi2vGG7QkHSViCf+XBxCw8212KBplxsXl1/EpIhaFEIon4d3kuQV+tzzADo5aydUQ7f72seHXajqoDoyN4KhOOcU4aXifCRshqJymCYm1z+XN4oKST384qJBaH6eeFUT0bEUroaVSjB/TU9Y/Ec3A10a/AqPR6GRsvGbN7QQJ3KwVHUipiLuVzGA7T/edXOhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 11:00:11AM +0100, Mark Rutland wrote:
> On Fri, Jul 03, 2026 at 11:48:49AM +0200, Thomas Gleixner wrote:
> > On Fri, Jul 03 2026 at 09:51, Michal Suchánek wrote:
> > > On Mon, Jun 29, 2026 at 09:05:59PM +0800, Jinjie Ruan wrote:
> > >> -	if (secure_computing())
> > >> +	if (!secure_computing())
> > >>  		return -1;
> > >
> > > Hello,
> > >
> > > I am not fond of this logic inversion. The boolean is meaningless in
> > > itself.
> > >
> > > Previously -1 was used to indicate that the syscall was filtered but you
> > > chose to invert the logic choosing true to mean syscall was not filtered.
> > >
> > > You could choose true to mean that syscall was fitered avoiding this
> > > inversion.
> > 
> > That's just wrong. Boolean logic makes more sense with having
> > (!condition()). Just because the old 0/-1 nonsense had it the other way
> > round does not mean it has to stay that way.
> 
> 100% agreed!
> 
> Bikeshedding below; sorry.
> 
> I think the bigger problem is just that secure_computing() is a terrible
> name that does not express the intended semantic -- it's not clear
> whether "secure computing" means "seccomp permit the syscall" or
> "seccomp is enabled and some special rules now apply" or something else
> entirely.
> 
> If we're changing the return type, it might be worth renaming the
> function something like:
> 
> 	seccomp_permits_syscall()

Then not only it is clear which way the boolean value should be
interpreted, it also pervents the accidental inversion of existing
calls. Overall great.

Thanks

Michal

