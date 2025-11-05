Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C821CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4348E000F; Wed,  5 Nov 2025 09:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB858E0003; Wed,  5 Nov 2025 09:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8C48E000F; Wed,  5 Nov 2025 09:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEC78E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:34:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBE811A03C0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:44 +0000 (UTC)
X-FDA: 84076799688.16.E3407A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF8881C000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNEo0LLq;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762353283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6DZt0IG7jUp3M/NuwlH6S9ylXXBqM+tUQv0TZtME1M=;
	b=Ysv3msJwLoljhn3mWN5dgoDYgOrBR+DjE1pD7j3TDHIiPWpwFcdR2SRa+9UAa2Y1TVQM9a
	VEfqVZB35SKCF/NLNNKmKvw+q4pfsMTIXuHlPMJWTtBXV9iiV5NjOR+vBqUkVZZ4WNRDUe
	QYAVza9D0CGCKvaFHNFgg8iTjxsg6DI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNEo0LLq;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762353283; a=rsa-sha256;
	cv=none;
	b=1Yuh91kcju45Q6XWLQwN3aGYagPPIs2ZrHlaRfmhHdhlLBD8Nddd+LW/EYrxtixUH9shOZ
	70WmgGjtepOH0bSJ34EntDj2wkXs7Qfv8R/gGzEOHFaDE5+eyunTOYy4Z7Bb1PzdRNIyUy
	GjEwrd08ydelT+nm4ainzFcjMyPfDbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BBFC60220
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32BDC19424
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762353282;
	bh=Lws3O9Q9eWUWHaR1D9jjGEWwx/Fg3c+pD6vwOq6VklQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jNEo0LLq3y7G0kgVUMrbEpXmYb3ehE4+PvMmj5C8I1S9nenWUyQVL+d1Zs+aGQfEw
	 XIQeXrimqWy1UPXQeLY1PvoF4XjNvkwkPHuDptEQ7vmHAw7UCmMjBUyfjru+yvduXW
	 xuuuiiuemuUeWFe1ahqhXjZB1jqcGhwXV93SaCLxMsc94grTx/qEzh50qMUCkZsOg7
	 2Ar20hTsrPaQ9PWpUVZOY7Q8GNWB6zuJwkG6tkbFpM2s0cVeufBt3PL+NfSkeDx4S6
	 FjjAstVpVHXB/xMFVgow1jOqOOXKiDRm5KE6VxwZcjwWwD0iGk73NhlIhY4KbIdVwH
	 ywZ7cEdR1gxMQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37a492d3840so14344731fa.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 06:34:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUISyBng/MJq2V/GcnPle1TGOOZGWaSkDZ77W70NMM1C1sQxNxsB1+vGfWjrGr+e6w0C95xl7LtFQ==@kvack.org
X-Gm-Message-State: AOJu0YwN2dXLLQCUVY6ano1nM3ntQRVRhnVT8GTog438BxCAuoPDxzRd
	XLbSTwO5mJoeYtNNyuYtqE/bHpI5eivVwQh4/y5gCWl5CuptaNgPiMg5ijHt5Erh8o61+4bCa3M
	k+8HvXNzkb/0yxYKtZtliQFLBGJKKBtc=
X-Google-Smtp-Source: AGHT+IEx5VuhTUzWGT5C3xk1ZCwXIz0HqLNQc4gHIQEVN/RV4yl9TQkUcvj3QI9yqUVwVZWCqZOKOmWyJ6CMatr8gc0=
X-Received: by 2002:a05:651c:1504:b0:372:904d:add4 with SMTP id
 38308e7fff4ca-37a51417cf6mr11398531fa.28.1762353280238; Wed, 05 Nov 2025
 06:34:40 -0800 (PST)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk> <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV> <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV> <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
In-Reply-To: <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 5 Nov 2025 15:34:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEt1i=4iGaum9MoQWMJT55LYxUd6=f+x=NKGCgz5vL4TQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnxYKD_q_DEqIXXuAAuvtynWG7mNNaOqPYQs_wBysPbMIk9Lu8V4S9c-i8
Message-ID: <CAMj1kXEt1i=4iGaum9MoQWMJT55LYxUd6=f+x=NKGCgz5vL4TQ@mail.gmail.com>
Subject: Re: [PATCH v2 22/50] convert efivarfs
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net, 
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF8881C000A
X-Stat-Signature: 85hi6s1aa49cadoqz97a9ckgr4ywchoh
X-Rspam-User: 
X-HE-Tag: 1762353282-873318
X-HE-Meta: U2FsdGVkX1/x1WrVLW26DcU4wjOSGwAZawAtldQdiO5yFzuRcru6Bha91cG+TlbX86K9pR8M2U8MOB0gGvxzca1sNvz4i++hUt0cqgChUaWhcCR1Rlo881MXmsQ5oBfj8PxATdU7PgDVEMwCZVXCqDddUSHRYxLOd4PPmxWLXqQL4Et9iGa04/aZ2lvSK7QYQ/6fMzkbZukA8M4qpRBIavKMbF6hYmR7V12oJgGrHOILh5BcxJH1UenQvE/wrzLtO0C7xJnaHrQfPLzlyCPSmlPYdaeZEUNopmVTgw91EKR9gfVEZb/4v3+qPRuLWpXWbvT4eJm/p8C5xdur33qUDgvPGIaNyDg4EorO8n/nIv1XLf0aFl8cD9vpO5O+Sp1FkegVUUB2dFvbqt7CSL3iVGDuBW5zFEcJMeC3LN4BCF682zJ+XeBHaNi7vWHxMJOFCB2XvCxM7F2aH4TWvf/oacFaaL9G1uzAYA1xTIIFSLYE4UjhyMJSckC1cR4nppLw16oJrIVLlII48guvBbwGOlugJMeZrwzJxl46o/52f9nYUDdLxHBEsrAx3/4t1iUVlWWWIM7NqfoaycavdAO+yl4Zm2HCekcIAs0PAatKfNHAh3UCyONtyHs4HZ6e9Vy2zcc7tVtXUnm8b41YjT6sEJchpVCr4U9F82D0p6g981U2Phn+MbqoZqccsb3JxM0s5GJra1WL/Qt/5cY0ejkHVuEPr3r9PD5YsmUaOFpfg37tkRDgn39NEDb+WWeNUWtnpTQLZ52Nmb/fQk6C80xp3moM0x1N/QnEUg0a+ltHShxeKWpBStg+mQWbT4Wf0x2ddPyUM9FtspulRMsdJXVFpSjeE/lDImfG2oi0moT2skmyQW/X5/bguFGj2yv6g81IYHd0UhNezxS88UCZOfyqehxVBK0YHjIyD8ELVDEjdlWUmZtv3CDiFDr3yAD+DDbFtuViVnBcqKrkYiDNnGd
 FGLvHRfM
 TSN0iOX3QxvEQBzTXLKz2br0A29L+wsexZlsEYIuoKKYBBwv0ZUBXfUchMoEcGVVEPUmKC5tn4g17prx5mGFqkPdqwYAsIp+srIxHzZcmDKK3oiUDCoo4t7xzrRK/2S1hRvnjjV1KgfabDg8ccEY5gIT91SGjlHWPw3Q3JWiU6iMB/LUxck3byPNJQ0bL8m544sb5/cNhRus9T6Ivf4UNjuWrcJUME99kdu9+iSkg75tnH4fs2Cbz1LHWh7wLfY3jwoGi+j2UlFzaEmv8GL0jmxGXg+6inMyMIqG9/5fuL1TVk3VmdX+HS+CjPcL/T0gmUVp+KEhZ5DtQHg5sJFfno8o2jw+PwoeX+le3WYKGleTxfTTUO/WSbnlDZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Nov 2025 at 12:48, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, Oct 30, 2025 at 02:35:51PM +0100, Ard Biesheuvel wrote:
> > On Wed, 29 Oct 2025 at 20:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > On Wed, Oct 29, 2025 at 02:57:51PM -0400, James Bottomley wrote:
> > >
> > > > I think this all looks OK.  The reason for the convolution is that
> > > > simple_start/done_creating() didn't exist when I did the conversion ...
> > > > although if they had, I'm not sure I'd have thought of reworking
> > > > efivarfs_create_dentry to use them.  I tried to update some redundant
> > > > bits, but it wasn't the focus of what I was trying to fix.
> > > >
> > > > So I think the cleanup works and looks nice.
> > > >
> > > > >
> > > > > Relying on the -EEXIST return value to detect duplicates, and
> > > > > combining the two callbacks seem like neat optimizations to me, so
> > > > >
> > > > > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > > > >
> > > > > but I have to confess I am slightly out of my depth when it comes to
> > > > > VFS stuff.
> > > >
> > > > Yes, ack too.
> > >
> > >         Umm...  FWIW, I've got a few more followups on top of that (see
> > > #untested.efivarfs, current head at 36051c773015).  Not sure what would
> > > be the best way to deal with that stuff - I hope to get the main series
> > > stabilized and merged in the coming window.  Right now I'm collecting
> > > feedback (acked-by, etc.), and there's a couple of outright bugfixes
> > > in front of the series, so I'd expect at least a rebase to -rc4...
> > >
> >
> > I pulled your code and tried to test it. It works fine for the
> > ordinary case, but only now I realized that commit
> >
> > commit 0e4f9483959b785f65a36120bb0e4cf1407e492c
> > Author: Christian Brauner <brauner@kernel.org>
> > Date:   Mon Mar 31 14:42:12 2025 +0200
> >
> >     efivarfs: support freeze/thaw
> >
> > actually broke James's implementation of the post-resume sync with the
> > underlying variable store.
> >
> > So I wonder what the point is of all this complexity if it does not
> > work for the use case where it is the most important, i.e., resume
> > from hibernation, where the system goes through an ordinary cold boot
> > and so the EFI variable store may have gotten out of sync with the
> > hibernated kernel's view of it.
> >
> > If no freeze/thaw support in the suspend/resume path is forthcoming,
> > would it be better to just revert that change? That would badly
> > conflict with your changes, though, so I'd like to resolve this before
> > going further down this path.
>
> So first of all, this works. I've tested it extensively. If it doesn't
> work there's a regression.
>
> And suspend/resume works just fine with freeze/thaw. See commit
> eacfbf74196f ("power: freeze filesystems during suspend/resume") which
> implements exactly that.
>
> The reason this didn't work for you is very likely:
>
> cat /sys/power/freeze_filesystems
> 0
>
> which you must set to 1.
>

Yes, that does the trick, thanks.

But as James argued as well, this should not be an opt-in, at least
not for resume from hibernate: from the EFI firmware's PoV, it is just
a cold boot, and even the tiniest change in hardware state during boot
(docked vs undocked, USB drive plugged in, etc) could potentially
affect the state of the variable store. In practice, we are mostly
interested in some of the non-volatile variables to set the boot order
etc, so bad things rarely happen, but doing the sync unconditionally
is the safest choice here.

