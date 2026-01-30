Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE34CD6103B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 07:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3D46B0005; Fri, 30 Jan 2026 02:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176F16B0089; Fri, 30 Jan 2026 02:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079FB6B008A; Fri, 30 Jan 2026 02:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC0F76B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:02:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77DFA14052C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:02:44 +0000 (UTC)
X-FDA: 84387737448.13.2D8E5DF
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87EA0C0003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:02:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ilytkKYY;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769756562;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INMf6UfFQjVVnORY/K4s0FguYtBlQgR4+GC7Az9nAHk=;
	b=dFAg5LBZQwcVmfvCXAp3rGqsCLOZcejRnKNFxXj25rOa44/4b1ClKL6FhT8rSgv5xWf/9h
	ta3XPaKpKR3A4OCdJNMlOATRxU5exnk+G8t5VSdnqstx2GuNDh5QxtMQXvp6NVGyXgWS/g
	d9YhA6FLRRFoWBrRV/ahAXlwW+Lu1sY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ilytkKYY;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769756562; a=rsa-sha256;
	cv=none;
	b=Rg829QYxh22PMy0PPGWHvxASvRVfqKT4P5VXq9SITNjCUJkg/U/uToWVhp2G0pgiSV2vZq
	xgeKwx2rJwhqd8TQg6q+86LpO0J96VoO8GcBs3PEjQlgIhva+O8GS4boyo2moV8XZi/YFw
	NPqD5fUgY1F6/IoD2QlRI1S6CHKNvBw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=INMf6UfFQjVVnORY/K4s0FguYtBlQgR4+GC7Az9nAHk=; b=ilytkKYYIb15hDUYvk/ktFurn2
	rIoSaVvuwrv/jNqt4iR6TROJ8IeZlN1PH5whhMv1/AbdXFNN++4wyTyv7KF0rsVh9LyisYV+v2x4b
	8QcYgnYdrwmOBebbLAj82HRGHPg83XKl4d5ixnZQP3jnt6qes1l7NJpUU15IRRrSd2OrPbXiWuF5G
	1Usc1/YAHY1hTXStoU1uN95rtw2ejQed+PicyisANY6LLn93TFaRsRfhXSowFrUo7Xjyenb5oA8gy
	k3TEBPyYB9WuLgY3oozldImd1hRSvpxcR/Ekx3NPG7coY7XpmsUV6OouYMej4OWnhCk8fo8Af/yTI
	OpDd5jSA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vliYK-00000009qV4-2BjG;
	Fri, 30 Jan 2026 07:04:24 +0000
Date: Fri, 30 Jan 2026 07:04:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260130070424.GV3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87EA0C0003
X-Stat-Signature: iispny8k4jaiz1rof6j98xhns4u1nnui
X-Rspam-User: 
X-HE-Tag: 1769756562-85408
X-HE-Meta: U2FsdGVkX18sZFNlyGoI3DikFf+1e1t/Ov3i8j+wNimMKb/c154A9KeCHA88fiJsSWAHEcZ+Kz3PuLxbVdHKghnFi4w3HNFTCLsdkcjGGpWb9U/R97SlbAyC9kH6gSU5mUAUdiYllcOZLnZVJ53WaGTfbxCjLn1f2wSjq55C9PKI/2WxKXjKJ5aVr/SYq1ZJviCTDYDTXAvnCiqgLOe8VyP5U/5uKaF9qgIiN0IoQTz+OqXRYWf8pYU01xMKZR3zTnXydcGraSy/PD+64Pu9glPmvCsnBbwjOBxnaU8mhzu10Op+hhpWavcSzbdRhmfhPiYkUJPEqBQD5Kfb1Gci4cxT5mX1Ixib9cYTAW10qHUJ/GUA7eGSAvI3ozdi1wSq7SVan4rwO/JU93dVqssHFAWDaRNMtm2lEK/twuYEEKGnpy9qh8O3TJQKl3XyXnfVuaQ3w5k/L+Bk/b/AKsJP95hext/Bot9ZYg031hugW0YxMrV9DYvUs76jDmjLfmFmLrxpUD4taAakRahovEvqdg8D+riN/SZoEwPm5uPJGO9HcQH/jB/Q0AT56yJ289WY0hawuU7NapODHAUj+HP89yspaokzpHaaSJKiNRaF23xnn91iAZVtXdHkZ5YvGdTlTWoq/vdyRRqVoduyPmgULm0+KU8WHkrBlSGRoQUXBzrIV/AzVK1RqPr1TLrHhTuC275oHaQ7np/TTO2df/ZXkBHPrr67E+328SL3UWAGV2Fyk9M/lEzcYogTHOuuua8Bb3ZXiw8ZFOPjsN29n1Edmt5LyQMvNM6QYIOnHd+6/HZ3E5XjaTXzlsPBwMvtOfgPVB1DKXtfcKdsrazdr18PNqX+uVDo14Indb5tM3z26RbYZ+W8nYSXXLFSRsN2ImeSiqaUXV6j1rISBIdeEGbWoP0d2/zM0gWZXVWBYXoRAn/tgPkT48GrlKmhe4/vuVOkArUGQdwS9CMXuYq0VWI
 t6EMWK1S
 wo3Ya/0CHTYP/A+nk4NVpE6aoingbovCSG/BGKU4Aj2kimuljVunk7f16wy1dq7eFFZ6DPeDwZlB2ZGGxgIW4XstAqC42lPh0lOxVdIixzeupHP04QZPSEnrFMH39C7KYC3ZcBCP6fOB0ISDq3oOgJPc1TGfA/hLafx9+99+HcKLNTo1VCcsQjX3OVDw6Vo1nGzZQX0RG+pazPE7NnS3Obnunx0ZHrprBhavcYbG7C5Jg5FskrZbfTzLq6g9e04jbJTZahknTINWYzTtsmdiwDLTO5FBT+O4/tpabMMgbvTAeQs62GW7St4zuyBSF7nOpb/pgimFRjhSTWYs7ydSzn6n1Fbf1+cLFGJ2UcxvHWbgsos8TGImDGkDRXFcyP5I1NGrBVPAckx8n3wMecgSpOV6/lO3fXMWr9WsKIrCSvvflV8XQP1ubibKMwgiV5zXS6ECmLtVVvPCitIK+4wBfXwEUdmfDdTGKuJ+eJLzRIXO9a+tEzjNH7kzFMX6Foa+HXPf/l4amB0RW5a4L7m/CzSWtyF7i5kXVl8gNAe4KAW0EwpU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 05:16:20PM -0800, Samuel Wu wrote:
> On Thu, Jan 29, 2026 at 2:52 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > > Sorry, I hadn't been clear enough: if you do
> > > git switch --detach 1544775687f0
> > > and build the resulting tree, does the breakage reproduce?  What I want
> > > to do is to split e5bf5ee26663 into smaller steps and see which one
> > > introduces the breakage, but the starting point would be verify that
> > > there's no breakage prior to that.
> 
> Ultimately, same conclusion as before: 6.18-rc5 with patches up to
> 1544775687f0 works, but adding e5bf5ee26663 breaks it.

OK.  Could you take a clone of mainline repository and in there run
; git fetch git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-wsamuel:for-wsamuel
then
; git diff for-wsamuel e5bf5ee26663
to verify that for-wsamuel is identical to tree you've seen breakage on
; git diff for-wsamuel-base 1544775687f0
to verify that for-wsamuel-base is the tree where the breakage did not reproduce
Then bisect from for-wsamuel-base to for-wsamuel.

Basically, that's the offending commit split into steps; let's try to figure
out what causes the breakage with better resolution...

