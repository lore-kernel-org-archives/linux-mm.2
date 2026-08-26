Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5FDC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAC46B008A; Wed, 26 Aug 2026 09:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2C06B0096; Wed, 26 Aug 2026 09:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA126B0098; Wed, 26 Aug 2026 09:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD04A6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:05:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24D17403BA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:05:38 +0000 (UTC)
X-FDA: 85143442356.10.5F69613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B7AC40014
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:05:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zq552cgH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787749536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+jsu0lhi78E5xkQq8F1dBDw1lbQTSSd9M9Up6CaIOk=;
	b=bUsanJxKtNBHZRuo4cXtGW4sINaz/2hhA2Eh0esSW7yzLEfWffPlJn23n6dsNIQadflO9w
	ZMJlDqIF44EnM/yso7/rO9l4tFryctf8HMQ7drktttFMxsAFSdyJutNgHSNyINoJixd1/H
	MZM5diGFzYDO77WeCpdwl+edbCXuXh4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zq552cgH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787749536;
	b=5rokDNh141gG132qdxAMXyzl0WohDEDzzXTlhoIqhx2QisjP0XAYKx2MCPlqUFCzxRoGLw
	9VpQXAeF+V59C/an8ZfMrY6qmf4pU1MMR2QQvUAE3HYBYFccyovuiFCBEWq1yGhCANyBJ0
	GyhzwIWVk/1K2pEiDCE8wnJSau6sKXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B740541461;
	Wed, 26 Aug 2026 13:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F211F000E9;
	Wed, 26 Aug 2026 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787749534;
	bh=D+jsu0lhi78E5xkQq8F1dBDw1lbQTSSd9M9Up6CaIOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zq552cgH/fW64rLpHxyP+jZPyvi68lU3UPRiKW3vizebFmpkYA0+o6/BdYm8hZQnc
	 Mcaj5S+qf0xpv+1mXLhFgSbHAZLCNmlfSHz5gGmHZdlnU6e4vnupk1WZZXQIGJ3jYC
	 aPQSRfNK8CFXoHkrZusouFLfgyU0cKd4yL0kc0De+eCBzYKbZ0qz5izyW9sq9XGc01
	 rlfZgCjshr299waJ+mL0SkyS8Lx3aHJuQG9p73ee1k9CTnRqP3GU1DL3bT5HWXKD1h
	 tbNxqCZnGYQUP0JRCGf6XO8XSvFWQmVkz6swit/PDeCQJT2/cqL7v/Ln8PzkKyIM86
	 3UFVDpL4IchqA==
Date: Wed, 26 Aug 2026 14:05:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <ao7khhTMwYEGLAXC@gremlin>
References: <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
 <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin>
 <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin>
 <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
 <ao2a33Xf3U0kQmM_@gremlin>
 <CAG48ez00PjoaXt4xJn1DCNdZfmFn4faya++=U2EeW0_vcYXcqg@mail.gmail.com>
 <ao2jfUGzbtlW0LBI@gremlin>
 <CAG48ez1ttTOf6wobCpRK+upYJqU82jgmxGSX_e7xWuxU7xYoYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1ttTOf6wobCpRK+upYJqU82jgmxGSX_e7xWuxU7xYoYg@mail.gmail.com>
X-Stat-Signature: 14nbnfzxkb9fg58zchmt37sr5q4auqj4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B7AC40014
X-Rspam-User: 
X-HE-Tag: 1787749536-936736
X-HE-Meta: U2FsdGVkX1+mzpENZDBFcn4WSsAMMIaUKFOVlNd/plCZFGuucuIv63loNLNN+Dx3o4bRGpM8uJzPb61J/rf3DqEEpr/srHvzdo+YDKatUvSEw/cw8AkzyYwfg4kB8CL5bEC61sVBz4x4KDfDdsONl1y7EOyT+yFO9GhdKe4wZgAgbAEOFrXDY2QBIs+J/qjHxT1JM9xzuty/rnvDOJeWlrS9EkOPmcPF+CJgslcRd/pnpgD/BDxvL7bYDsMzTD5F6C6E1C4KXFul8sR+Q8ooISPBvlSAcouFtbeJBi9tSbwdPjduGTzsfvcA6K+1YtXYRMqD2ZykVK9GGOWGsFqkCPwZwTC0+zcDLN1da4AtW1ZQx00DSUJ4smKjZ3OdZoCDF6JTMfuLFqculz6yb3uAhNydQoN3s4pEmLOTH9WlNRYwy7JiLebyUSW/rkQn1S98KHtMt9mFSOhnRTqSC5KUQ/KlJp1nn4AkzXgsCQfhFaUSuQt/L2bw1dvKSlN9D2ATE73f4PwzFJ7jefD18gqloXhagwr+LQKhNiIWVSw63xqhuYvD9AbElLcLZZRJfmYdInVm69FINvj4qaaqKY89YWPAcWlqSd/zDrDNM/pU70qo/vCsl9hwoHaZQaYiVTaRXlysVfKvpabtQohOFSapnvz/9jtntMnSrArANp+eXVeJth8ui/f9mcPJZ7aYwUy35Jere+sFvQR7ERSNk/cBcoeahf4yepZgpQVcEQhuec0qoi4uzfZF2pZCvOJ6Ku7JjTTtzPtWmmz0QVSBZfy/jOdtT8KmzQ6oO0qN6ceSAaRk0WgRyNdjtp55C05fLDPEFMgI0rcqi1e119O7nL/i//2B/CA2jujahTGL4xRMAAW2ROvXr02V2kdheld8hmPGjqUldMjd3av2C5jWh0sGDMSuMg89bvblaJxP3QsfVv16q+y71hYH+vim5xgNG6G3xOWvUnc7OhZkMSjdA9n
 P1Wd286z
 8Sabck8MvMkU7k1BhweOyaxFXXEmRTjTuu8fdo1fn/Ah/u2Q8aMxRzSyTAnFpgHrhOSaI0EFt4thq3o2ApyQ2MTrIw5MRZ2gDc+WoDi8cuvLZ9Q8oCoDDXEOuj6zkPs0+KuFycTmM9hKz0kSm/q1AF9CKhIKlydxfqi5PvQoJsXKe27EESsMokmlOHj7O7eaQ2b1Dscmrmr2VACoqnfiQz7z04agCXmpncV+4sqv5rApzfbOKY1bjeula3y7JMDzd6cUTg2vw667GeSz+oHqPwJ+HCCV9pYouHdYOlvYW5BxVpXzneOjqDIZ1+BRGijZ5TqDcnIiCa9cEwd55lYBEl0WOmb5F0VBoDctRvnG8O1i8eckwb173dhGfy5CO7va4ISeV008+NG/dylrycq6rnejntFcSKGtHGrFr7Np1uUNp8b8wvYxOWTMmRTZVSGIHkFv2rkal5JkqPkwIYTPUybtjtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 05:00:59PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 4:24 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > On Tue, Aug 25, 2026 at 04:08:42PM +0200, Jann Horn wrote:
> > > On Tue, Aug 25, 2026 at 3:42 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > On Mon, Aug 24, 2026 at 07:43:02PM +0200, Jann Horn wrote:
> > > > > On Mon, Aug 24, 2026 at 7:33 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > > > On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > > > > > > On Fri, Aug 21, 2026 at 8:52 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > > > > > The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
> > > > > > > > general :) but I guess you have to protect against that.
> > > > > > >
> > > > > > > Yeah, it's a kinda weird thing to do...
> > > > > >
> > > > > > Yup :)) but I guess we have to account for people doing weird stuff...
> > > > > >
> > > > > > In this case (I do mention it in a reply elsewhere I think) it does seem
> > > > > > like perhaps you should separately check for current->mm != mm of (what was
> > > > > > originally /proc/self/mm)?
> > > > >
> > > > > I wouldn't want to do it for this access check, since that could lead
> > > > > to "confused deputy" problems.
> > > >
> > > > I guess if it got the decision wrong somehow that'd be a problem? Or wrongly
> > > > OK'd it on one level but then that led to the fd being passed on assumption it
> > > > was OK to do it or something?
> > >
> > > The problematic scenario would be something like:
> > >
> > > 1. process A opens fd1=open("/proc/self/mem",O_RDWR)
> > > 2. process A does lseek(fd1, <address of libc>, SEEK_SET)
> > > 3. A sends fd1 to privileged daemon B as a "log output" FD
> > > 4. privileged daemon B write()s into fd1
> > >
> > > In this scenario, daemon B is just trying to write log output into a
> > > file descriptor. If we checked the current credentials on write(), we
> > > might enable FOLL_FORCE just because daemon B is generally permitted
> > > to use ptrace.
> > >
> > > This illustrates why, in general, the "ambient privilege" that a
> > > process has must not influence write() access decisions.
> >
> > Ahh. That makes sense.
> >
> > But I mean in this case the check would be that the mm is the one belonging to
> > the process in question so wouldn't you need in the first place to have obtained
> > a privileged mm anyway?
> >
> > If the check is literally mm of /proc/$pid/mem == current->mm?
>
> Ah, right, true.
>
> Still, I think I want to generally avoid looking at the current
> process in write(). If I did add such a check, and the check failed,
> I'm also not sure what I'd do with this information.

True it's not a blocker!

>
> > And wouldn't prilileged process -> fd to /proc/$pid/mem -> less privileged
> > process be a fail in itself?
>
> Yes, true.

Yeah just food for thought I guess :)


--
Cheers, Lorenzo

