Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFFBC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0BD66B009E; Tue, 25 Aug 2026 10:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95106B009F; Tue, 25 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984776B00A0; Tue, 25 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9396B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:03:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5F5BA39D6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:03:07 +0000 (UTC)
X-FDA: 85139958414.16.EBB71E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AF7820013
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7veB8l2;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T32td7y5ccdnhZesB3Pf8GJA69ToD/C95AdlirXQkOs=;
	b=lhtQGk8lNapqImPiT/40sl0rzU2wh1+eQjK9BfuoC2Mq77/R5uegZACrajm7U6eSsFVtWc
	uAT25BniuhkOjhr0Jcc0zXLz9cDmzNm5zAsJ9TuKHQs6GybySqq8hmS6chI7dCbUALo7U3
	Kly48vYUDheWE1ZWkHOjEvATmtWe20k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7veB8l2;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666585;
	b=Mt95IqAn18+UlPMX1BejwaM4jXioAIa6G6F/CsIOCZAjxWgS5wPoKka/HfzLtmGqO1u8bS
	f9XedCtA9c7W4A0znYxPfV7wnK8Ppsj+lzImCN58I5gmUZaA5Wkj3ARu1RB+a+5LsqKD5b
	rbSN13hr802TJJYXNcZaf3y1+9c4NX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0B540BCD;
	Tue, 25 Aug 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20AF1F000E9;
	Tue, 25 Aug 2026 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787666584;
	bh=T32td7y5ccdnhZesB3Pf8GJA69ToD/C95AdlirXQkOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h7veB8l2u74wR/f36KIFQZSKVtGKq+qmae6kMloaQFEc/ao1ue4iTX/6IJbhtJcy4
	 0snjrsBT3sbND7D++wQlUx8vx5FUwua8SYx9Q1ad0PfZAS3at5Jk6BEtvXG403jgpV
	 lhnQ2fTG+jNRM6oyw8O5UM3GTaxsclZjpPOqcjSVCvg70tbK8yUPjDD7cg8sSjP7Dc
	 Ld28Mn87ZSdFL8iEHOYTFNcti3FSy0slLpAZOpC8RIRaTQdG51gVvpy+SJ0X7vE9YE
	 gO991L1ntARaAvWczPLf+mbv32ln2bNQcbPoFrChaUM1xaKUr47Mm8lHFvvqT7NvqE
	 0OLUod+yYUvQg==
Date: Tue, 25 Aug 2026 15:02:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <ao2gZQuyfegmotS8@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <aoifijlkCRzeO4bj@gremlin>
 <CAG48ez1HA30JUi-R=6KydkQy2P3_ineM1ZzRMQC6QP1UAwjewg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1HA30JUi-R=6KydkQy2P3_ineM1ZzRMQC6QP1UAwjewg@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9AF7820013
X-Stat-Signature: e6rymzka4rpirjorgzumpru56gh85e89
X-Rspam-User: 
X-HE-Tag: 1787666585-527906
X-HE-Meta: U2FsdGVkX1/9gZyIhqxwqwuEDLK3PsJfFLpxoPNKS3t293dCiApgCO0tWOZ0UHyIauOM46zog/p17TPD3qWnL5gXyjzmrd01XzcEbI/emfVcprD97BEP4XkPhJc+Y/aPv2/F+43C7DYFTRkFfkciolLuoJfUVO9cDL1asl/QVy3LhWgPuDdeqnbrc+uEWTRHOdFh9aUuWgWQwKP68A7xG0y7a7FqwTu9dbLG86X/2XLHDvboqp8ZNm6uTN2feLmG/8vhy48Qy1ro9OPfHvSi0IlAbRzX++4DLUUNy4sp6kw7It+h5p4ctp/GUBmxz66anX3lNQDxmX1tVFV4VUI28iWqrEnJTObJYleUq5Uyfg1fLiVGUOMNbM/Je0JGr2iWKUmUcD833hzMWOrKU5ZREPeUS7y/yeV1sB0ATNwc6+PfFODjGEGySiFKcwesPCB9rWv6fkWyiL271NyDkn6/p3K2ID4GrDE4iH8dZCTQaW/BjjFnTgVKG8z408JWnIST3fTvVNqTnwBQvNfT92Qj+K21Cads8NYZSo+MuW4TBDQaNJqAn0tGflVErtUZ6kNsGy3c/MRFhFG/jBheJp2auwNdmBhW0WsGHsw73vE8BS792DpcSdkuiymS9om1jiTTbJ+QC4MQChFxDFRXRxx98+dtBkpy08kP1unHR7IAdGSWzLRajG5mHTK3WkN7eVJL7SL10oHWh6m8x9qMjslve/eTH4dmQWc/EIq6+l6nct3c/7ZRsTbgM1YJvNkuSIoxokJXVWPWOeC/Z+p3JDRE65kFFzFMLoZXvwr9BtJhP+OQSKMOjxOVp0Ahf/ie56+1rCPmeH3Li0uaguNkhcizkeecLs95ePUscnQHR4fDuVqG9WaLo04OZZtupaR2hUlTsuAfHzgCIJS4vFJOa228nro1WxrJO7JVBTMFVdBOQp2WYRySRtPhXia0xCmvt7N4pqclkSFVyiOWKYtgNF1
 erq/fwDa
 Eah0p0Ag2SDh69yTfn7nXZnYuYu1l+/dVlGiXgbHbl6/hjZNp1/jin7m4H+4udSPbasVYQHsf3+uWqHy+7w5jw6ZI1LyQA/7lzyuAbuZKyx1BVtT3R4P0DmWUB6qz2cLstcEWUUKwoy/pt0Xo7QzNVlhFsOcRXBgxz4/Zp0XnWIKjdmBXSymqZX745/aIdAqiXlJ1UaL1WoRyGaVqfX2yJ15BQ1WhbVaCiEmi5LO0Ijtio6/lGPQtj756dHZNmCl6+unK/qSx61shfK89EeF/VNKjnYlBRLCEkHUWNvunkzbysP2JEc18Eb8+hhZkWYFM82K+wCnr54XxAu3NvpW35zSKt+BXHJDnekI8+LsmiAe6St3HgANCeASHlmjw68+gdYJPtFSJFrDb7wuMqpNdIME47ddacdY4cvJ94E3Y0tl0/qiXS00ObvsGZYw82kxZyybk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:28:24PM +0200, Jann Horn wrote:
> On Fri, Aug 21, 2026 at 9:00 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> > > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> > > good opportunity to block a process from overwriting read-only code in its
> > > own address space through FOLL_FORCE writes via /proc/self/mem.
> > > The security_ptrace_access_check() LSM hook is bypassed when a process
> > > opens /proc/self/mem because this is considered "introspection".
> > >
> > > This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> > > that a process cannot create executable anonymous pages.
> > >
> > > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > > accesses are only possible when the LSM allows ptrace() attachment; but it
> > > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > > environments running lots of third-party code, such as Android.
> > >
> > > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> > > such "introspective" accesses.
> > >
> > > Signed-off-by: Jann Horn <jannh@google.com>
>
> > > @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > >               }
> > >               return ptrace_active;
> > >       default:
> > > +             if (priv->introspection)
> > > +                     return security_introspect_mem_foll_force(file->f_cred) == 0;
> >
> > As per 3/3 I wonder if you need an additional parameter to cover the fd -> some
> > other process case?
> >
> > Like:
> >         if (priv->owned_by_owner) {
> >                 const bool is_remote = current->mm != priv->mm;
> >
> >                 return !security_fd_from_owner_mem_foll_force(file->f_cred,
> >                                 is_remote);
> >         }
> >
> > (I'm not sure how LSM hooks are supposed to look :)
>
> We could do that if we wanted to treat cases differently based on the
> identity of the writer, but I think in general that's not a good idea.
>
> In general, if you send an FD to some daemon, and the daemon writes
> into the FD, this should not cause access control decisions based on
> the identity of the daemon, because it can cause "confused deputy"
> bugs - the daemon might think it is just writing log output into a
> normal file, or something like that.

Ack yup, variations of a theme of this, I think I was overly confused by
the fd-passing stuff vs. the key reason for the series.

In general the thing LGTM other than the naming so a respin should be good!

>
> > > diff --git a/security/security.c b/security/security.c
> > > index 71aea8fdf014..d0f790a534eb 100644
> > > --- a/security/security.c
> > > +++ b/security/security.c
> > > @@ -595,6 +595,21 @@ int security_ptrace_traceme(struct task_struct *parent)
> > >       return call_int_hook(ptrace_traceme, parent);
> > >  }
> > >
> > > +/**
> > > + * security_introspect_mem_foll_force() - Check if introspective FOLL_FORCE is allowed
> > > + * @subject: credentials of the process accessing its own memory
> > > + *
> > > + * Check if FOLL_FORCE is allowed for a process accessing its own memory, which
> > > + * bypasses the security_ptrace_access_check() hook.
> >
> > This should be updated to also explicitly mention the fd case. As surely in that
> > case this is not true? Unless I'm missing something.
>
> Yeah, I'll clarify this comment.

--
Cheers, Lorenzo

