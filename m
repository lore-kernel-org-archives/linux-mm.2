Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE89C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4646B008A; Tue, 25 Aug 2026 10:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3970B6B0092; Tue, 25 Aug 2026 10:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A71B6B0095; Tue, 25 Aug 2026 10:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0490F6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:24:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B318A3325
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:24:38 +0000 (UTC)
X-FDA: 85140012636.21.2B51EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EABF520008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:24:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSJuJPMk;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787667876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjHXTa0s8zvN8eWbsgZQbbsnAvUJrCviQOkjU8WoR6o=;
	b=Buvevu+iUVv9F6RjiEeTeW2s5vLuRPu3uerMEx6To4dHPso5GrQKd5AgSEZOcTMl9cz22v
	8D4ZvqEWZQnmSvMD2gFA02exDgU+qYY1PJ/JS1aqXaNqulIUTcHJk2cyIoy7YR6Lps1rfu
	4+Go1kpNT3gPT6GEs1W8Xjqjtp1RC+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787667876;
	b=RdPLxGWNVxtHtNthn9/zZx1JzBV7Se2UnsWqVaLq+ynV9FbkfTY5yMB/uX55a8q+tWlj0D
	ZkJEpVGa0MBI5iuuXvZK0YNwPX7kP8sMQhiV2u55RndZEGevEqvZb7ZM/iucqMFmJxKyT8
	JRUZIxDpgK49hoJUHAyPEjUO344DH8E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSJuJPMk;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D50136011F;
	Tue, 25 Aug 2026 14:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C5F1F000E9;
	Tue, 25 Aug 2026 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787667875;
	bh=qjHXTa0s8zvN8eWbsgZQbbsnAvUJrCviQOkjU8WoR6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cSJuJPMkWhZS4E2xMS/50Ko0vEa6gX59SNuYWUKf/rZlhN6uiK7pfq4bT2DZWA5gO
	 RDAgnPa4GZV0irpj8/69hCLcQUcqKtnbqd497v4e7hcPVE7SXltC4RIBI9AumZbfrQ
	 EYlEDD//W1f2zayHjmjmDYXqqmlpdJi8ND3upHF+CJNXYJ47dZATgpllmSFLIeugxc
	 oOg+IaNv+SPZc+7MJmp0l58vCg79Ncp0EFwjUAF2kGmA8VqcHXLKouMrhv6/IpEinf
	 fKdWXnPqsVh6HCggLLWZfYIk+dUmUX5fQ/ppQfjCW80/9CsduRnztcPGU/3mKUQXTE
	 Jrfk2DhjJ3qHA==
Date: Tue, 25 Aug 2026 15:24:28 +0100
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
Message-ID: <ao2jfUGzbtlW0LBI@gremlin>
References: <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
 <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin>
 <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin>
 <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
 <ao2a33Xf3U0kQmM_@gremlin>
 <CAG48ez00PjoaXt4xJn1DCNdZfmFn4faya++=U2EeW0_vcYXcqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez00PjoaXt4xJn1DCNdZfmFn4faya++=U2EeW0_vcYXcqg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EABF520008
X-Stat-Signature: uhc9kgapy9cmty3wopd1rrhn39tmeyod
X-HE-Tag: 1787667876-276715
X-HE-Meta: U2FsdGVkX1+5eHSGwzT/xFVbfYwEO6VVWJ0mgRXP3g/Ck0fwiCPkCs0hCSjtjHDlEDSR7LJfHvj2pFZLNOcnvKQTI9uQL+WVGvnfXvaNSZfpb469+37QqWTSGv1lpKWwzSaTW9G57JR3Q+dGSyX9q4CWdbUTwIaYyxxaudeLS4ge4ek85pzHImN377Ks+BxMjLFrD3rEI7Qy8xfbUcG1F+u98RbYoN6rSCKdlsbGOIM7wslZXTBr9UX8wLolf/+pSRjvWBDMTew+i1BpRlksqoXEwZtzdlnQuFKyU5XkukA5PL9xb2iHquY/qedPipBWDRBZ+TJTlA/blSgo1h9c/uTPQ/q99dymF5z946KWcZ9J48l3pNFvlILZpHcXDMGLQA2cP9ltjo76WnHLUwA7Mgw+h0oqdBR1QEZUf6uYsDuhrk4m2Ry03QXbrktZr9fHZsPVaMK8vQ45KtkwIq2Rn2eAlU7qq/TOTO/IZdpvCVBYUpej6JexjHwXlxizDDDyGrH4+ngfCqCllsp2YM8qCD8qzFQL08XDwLzsez8/MQ2Z+Htc2s869+3qFj1jZTmY+v2xnzyU5sVmYAtXNS/EGgP40361p7glLJdP/vkGSpECWx6DiYMnYWN8R4n+LG8pRLHUr1PeaHamz5ssLsp76Ou0ZYia1PHr/4pYtUjbM1qOlcZ2pja5U3qvXZOrgSNSWy68VfrrKa1q6WeLDxp6lUk0wtEXX1q+wjGBK87k9es0fAAg/MO5focIhXoRc+We/Dw3oCvj3TDCtVm5Eq3UgWXAv9lRUO9FB0/MnFhFc9HqciaruWhHck6rmi5q6xnafYnA9gTmZISCfRN9DWJ5T96486UkE14AA5NZP+sKPJWH3SOsXqgvcy6fXrhV6QB4tVnBMopPC+lwjwmYVIyEodJP1xVcoKNIVSNqWGSbKlQivJJU+TkMQwyADEZUY/6VDjvHVlFTGEI8NEc132W
 cpisxT07
 AwO5BZ1sXPmwLE+A582B8nZD8hx0uS/npFEmVfOmIxk2mXBgDjkiXVZqN9+4FYcacyeFYfphPw3UthaH7N4xx52/a46yEQO+pMDeIo4re7OQD8PC5CvcS8zIeY6/5iiw19sDQoHvcRxnN+2AN71mg9WP4/kF8l9I2CgTURtFTTk8APhGI/cqIwBJHKLMHgAjefJvyFVWDjNQkz2d2znuu33G0gZzO1+iUfsovr2xuoHcYxHe4+iWNvsbUbUpl2OKp+v8g41Nxe8QHR6ErRDBnMMI9pMM2S8GlIyKuCOIn3XAAJSYNCbc8EEWg1AdBQzFQRf1AtD/pbgCGii9NbNZygRLr0XgcxpauTd86M+VLaH+lyo0uOe8fnz1/vQRK4IDkq4oKETy1TkHNmg6ngJAc3pswxVbi10MnPUky8ntu9KPNSC2qMv4NYv/VpnrUhOUJt5Sk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:08:42PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 3:42 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > On Mon, Aug 24, 2026 at 07:43:02PM +0200, Jann Horn wrote:
> > > On Mon, Aug 24, 2026 at 7:33 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > > > > On Fri, Aug 21, 2026 at 8:52 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > > > The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
> > > > > > general :) but I guess you have to protect against that.
> > > > >
> > > > > Yeah, it's a kinda weird thing to do...
> > > >
> > > > Yup :)) but I guess we have to account for people doing weird stuff...
> > > >
> > > > In this case (I do mention it in a reply elsewhere I think) it does seem
> > > > like perhaps you should separately check for current->mm != mm of (what was
> > > > originally /proc/self/mm)?
> > >
> > > I wouldn't want to do it for this access check, since that could lead
> > > to "confused deputy" problems.
> >
> > I guess if it got the decision wrong somehow that'd be a problem? Or wrongly
> > OK'd it on one level but then that led to the fd being passed on assumption it
> > was OK to do it or something?
>
> The problematic scenario would be something like:
>
> 1. process A opens fd1=open("/proc/self/mem",O_RDWR)
> 2. process A does lseek(fd1, <address of libc>, SEEK_SET)
> 3. A sends fd1 to privileged daemon B as a "log output" FD
> 4. privileged daemon B write()s into fd1
>
> In this scenario, daemon B is just trying to write log output into a
> file descriptor. If we checked the current credentials on write(), we
> might enable FOLL_FORCE just because daemon B is generally permitted
> to use ptrace.
>
> This illustrates why, in general, the "ambient privilege" that a
> process has must not influence write() access decisions.

Ahh. That makes sense.

But I mean in this case the check would be that the mm is the one belonging to
the process in question so wouldn't you need in the first place to have obtained
a privileged mm anyway?

If the check is literally mm of /proc/$pid/mem == current->mm?

And wouldn't prilileged process -> fd to /proc/$pid/mem -> less privileged
process be a fail in itself?

>
> For a similar historical example, see
> https://project-zero.issues.chromium.org/issues/42450869 where we used
> to do capability checks in the old expand_downwards() logic, which
> could be reached by writing into /proc/$pid/mem. That made it possible
> for an unprivileged process to map virtual address 0 by providing
> /proc/$pid/mem as stderr to a setuid root binary.

This does raise questions about /proc/$pid/mm as a whole but I guess that ship
sailed long ago...

--
Cheers, Lorenzo

