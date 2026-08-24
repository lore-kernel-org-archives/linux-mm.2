Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A4FC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C4C6B0095; Mon, 24 Aug 2026 13:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675306B0096; Mon, 24 Aug 2026 13:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BE16B0099; Mon, 24 Aug 2026 13:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25B546B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:29:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74AD21A0206
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:29:04 +0000 (UTC)
X-FDA: 85136848608.21.CCF5131
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86882180002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:29:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DeVkg3gN;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787592542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfDdC/RWyrUaNw5va538e4PXp9Bi22FQE/a0vb8LJJg=;
	b=v7GVKvMh3jZQc2RM7RjK+6t4e/nyfZn3e9nXfeTGlBkIIubymIBfHPVFBaNGf3lq6sylPf
	/ZTFgm4O5Ys5ew7Ils8mA5NL8tnrPZNbSeSYD35X510VRaqwi/izECgpD25qBb0vIw/Ut9
	fVXHLAKmL1w8dfVRdRjheL4FgbTXn/E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787592542;
	b=vkQzg4wZLr8kR9MLgSIeACzZGQJFf5q+7I2HF2HoUSVKrYjNNwEYPo1erhdchE2PYykx4C
	oGSg3vD6p62vIZ+fYu19noGiHPF/GB2Ja2k6mFthUZUHeOWXZ1o+4crJG+PI555J9zn4jd
	7qSxsSkT0M8LfhB6i27WCpUBfosGJsE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DeVkg3gN;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cede6375caso11355ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787592541; cv=none;
        d=google.com; s=arc-20260327;
        b=mE1L5j2zo6ahTeMuO8uA/oCfQFzZ1ollXqTe6r1YEmRCkMUuYLgozLDKxejqRCBlby
         9uZqpSWLDfNRK8QuZdlSAORU7R9dU5+Z640kRzif5YxqMhOBQi7hL+DwXL+gLQa0dPCw
         fgDmGqC3sBsDSoEI8ZvA2rXzOQsYx6EaPeexSpJ1vZ9vk99JbeWx1g4BNqTOSQ12nLzf
         fx1OAHHJMYEx9yKoTFxUG0u5WGIea94vcCk/bTyY6KFYqMsD2qiZCidaod5ml7wW8gKs
         SdRkbsXRCnNwzP6GX4DEP2nwoj8XwAbZH2XeI9OOQPAJsIVsPJIAKBAY2v525MHcGhya
         1tDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UfDdC/RWyrUaNw5va538e4PXp9Bi22FQE/a0vb8LJJg=;
        fh=C1QGJh+d2D8qZmLo2GKChiZFvSA1DhAvNlmQXluFJWI=;
        b=HYvNn9jCd1N0o+UCDii3uOn07Fvr+rGXtYjUJyE6K5A4nx6g/GFnSBwZamaBc1VRCE
         ZwK6Glpd2KPmiL5iQsJG4QlQArsGZHQSHgHl3q9v42KIlq5JmosylFhMH+/8G/TY81lE
         a+Zwtp/9lKZfdr5lfamojqdiZHl1gHbWCB8ZLBxLgLX/fc9pJYeja79J8Ek8dyT4J0oU
         hXIB7G/ukcmgHaK6ELuNDo7pJ5ZIG44AbgTbn/t6EkiNIwbFhXMzcm2j7e2x4+GZdc88
         MR4V8k/darA/jBAR6smye3xbVZp2XhxT+GEhfSPuVDo8X4meQNpHogYXwoQTYhcW7EbO
         3XIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787592541; x=1788197341; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UfDdC/RWyrUaNw5va538e4PXp9Bi22FQE/a0vb8LJJg=;
        b=DeVkg3gNiYRwvyNbQHawNgmi3c3zo1om0DwsFZWE/5sfnMYgD29bZpLUz8Aa88L5+E
         +vZ9Whjn3q4qzjw7/QzdEevSa+3U5DxFV4k7WOZgelw5EtFFvyiUMHaFvI4fEmhJVOYt
         k/hbsbbBhdzKnFsTG04gdKDcE5UOKAFtkynZRS6WikEPcoL7Be3w/bwJQj3SBrGibUMr
         hlchjUPGKklGpGWowtyBb63LgeJTYGkXEHVtpu6D6gKPJEB8ISPCE4XBZwS05f1jnenT
         Y9pvIxFfvxY28AwcmfNbVsx/IFXF2DehJJ0BlbhxKjNM2khNIcjesrkkoxZh6zNtPWnK
         3VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787592541; x=1788197341;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UfDdC/RWyrUaNw5va538e4PXp9Bi22FQE/a0vb8LJJg=;
        b=SYHtf9rdqzI9CAch0cRTW7cqPrqtihyV+P/LsgV4prgGHlqMiSjdpjHBUJghLdBU2V
         NvHcG1GgazKd7TbYIPmblgWKFWwAds42TT/gJw4OtAnkbqLU8BEUQjmSPnI0bAKzCEhz
         N4kT8XwjApydZisc7kTMM5YUc5D4U0AjMlnYADC7gj8sqmztiHx7xN37PYq4GVd+4dxF
         Me9+FnYbEe4dPkGIfpvg80eTLSB7FdVJT0vFTPyJX/aUqbkQDRh9KbZqDti6Yas6aSR8
         PgbTJcYz8+pr4avYPI91jwxPLdxhJgnOCTCQ2ViGz9FIcLbxkDzZvtCHW0k4kkJgAUAQ
         aJ6w==
X-Forwarded-Encrypted: i=1; AHgh+RrL4JpMSnixvvz9ivkZos9Jy6encL9BBhwLzDvgDRSBygPnZWKKkRMk7O4XQBFbNHQPudrK07geaw==@kvack.org
X-Gm-Message-State: AFuF++k728/spzyza1R0a2eMHa6JxFuLTf3WYhNdcHoi9xHPoEx7oULd
	SGTrzAiopdsL7nacyw01ihsv64sVHqBVaEaAlPRMBPkCNLeeIjzeHS7kCgg4BbC1IoR1aiV1UM9
	9ylVQQdcHhvD8lytGOIjFIWV1GSe4Ud/bq3EJAaAH
X-Gm-Gg: AR+sD13UrT5RPQNOxBdMTCfUyYaNZT+LE8MWnhLc02Kf3HVLW2cgBanzy/YOpr00tim
	HT8J8xUkP1Dmk9cnZScw08Fzb337o129BwB6uXuJ5fwjm0WF35tmgd7YCPz1Ue0iznIYORnME92
	6e/qd/dxmYJ81QtLKbrF8x4GgvNLbC25U0FUwiH/J5YztUJQbLQmX+LoB5+pU6Yol5xWnuYrL5Q
	r7UPA/Jru77pVfAaX2dhxX6m6Ad+sUCPYsF27Yu0q0CB1rWLGf22X1WhW/gCd1dNejhsJgtQSPN
	Ilev2kp/uiX5eLf07Lw4RU2BTKM5doR3IG2R47/kbfGpbFAGZSYrrWVtI370sepJL4I6kBcuY+i
	WmccQmOEd0pYFoH7PA1dVxUBNb34WdQ8=
X-Received: by 2002:a17:903:1acd:b0:2c6:a078:bfb7 with SMTP id
 d9443c01a7336-2d673b9b705mr10399295ad.7.1787592540643; Mon, 24 Aug 2026
 10:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <aoifijlkCRzeO4bj@gremlin>
In-Reply-To: <aoifijlkCRzeO4bj@gremlin>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Aug 2026 19:28:24 +0200
X-Gm-Features: AcwNN1Vx1mdrG-hGZfBBtnczl0hD68Qs5NDgSLNpjnU_6pjoKXhzXOErcbktMiU
Message-ID: <CAG48ez1HA30JUi-R=6KydkQy2P3_ineM1ZzRMQC6QP1UAwjewg@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: tmmfyrrjami7jg4p4edgrg6tyzaqs9s4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86882180002
X-HE-Tag: 1787592542-486430
X-HE-Meta: U2FsdGVkX19I/JD/FlbMIhcwqzFWcJeTxKK0dF83nbXa0g4sz62SuZayJv3jctPGjTFnyzNnBP6y/Kuiqk8Ba/SejKBQTOoF9nfMjO7mLn9i3VreBz6wx+rKIyth4jmeLLjrVdN5cOcDWby7cdbV8+m0rPu2Dn1msSwS5XYMBkAu2Faj+1uLbRh7goXSD6gUnr4AKiRUjKZC5lF2PdIdD5oaOiN7HpxUMriWVny3Pi9SOFSW+x5dj+1EkplFKCy8F3U3lvPhODBZqHc9A8Dgbwn1XkjRNOHNZl4KoEZQfpKCCaMx5+11wYHI3xqEn5FrqBt8IuUxhYvWA5UJbesriWoMyQ+KQsqS+J7ZbYY0AQpjIAnpXZRC5CX0EXJNOOYdaAvOPbyLpl1w2mDKxKRJvbDG/J9TQdpuTQW7wx1M1TicmXe5GhKYMoRkMbvWfLyWt+qRO5Q1/5eUdl7rDPHms8kE9Qxec/BdiiNcomQnr74m+TBdSyO/iF9HKrVz++s/Oe1FX9tt/aNETCH7o4TE5eas5pWeM93qu0hE7Gr5UbMuYaKWgbKm5w3v4Z9r/i5GkTb/WsHmWjvAV0/4TBkZDm8KPqB9bfJhACXS50oIM/WCZ4T43Y5j8MxH7jHfu7qQtO+mymmkjPZC59UP1cg37VFXYXO66ltjPo0hw5bxxcsN5QZnochRsVxQysGbr4amm13pSDFyEpwpT/rD+leoZFsdbSd+5237MrLvGW3jpXuLMc5vMT6wKRFe7nilV3neP6MFB6NcBAYI8O+Hkcs2NcrQBt+zBTdILTxcv+x+mNsKpkEVXJ3zuu7VdSZ6QyAVmhueiwSRj4YFoRwlGNxVt50JYFemyW8ekLes8yd96V/IgWKC7zmxSBdXVWRNWkXEKcj/a9fEM7x+JKa7Lgvko2KD/PpDurKkhWmPBwJO656/jwe3N9MwUpaAf4mKLrhVOUo+kT3YIFNrB732diw
 Iz3nTVIO
 8fNpGnYG3G2Ytcnpg5ek7woLIQqJJ2XkcTjPQfmOIxfHNq60v3wBhs3guIr/JBKNsDjlfk4F1cIvNFO3pZm+hnngP0t/sAqpXlN2nANLCIsepPnWqRf/JpWJfbz3C4cpkOwOGoPMiuEg6O6oaRXhXO1+2pglhPdf5zclk7J1BkGUfnUze2euO4SeJbJrfrtDtVRNE0CZzVJEtDhPOSb8D7Rsr4ulc0RjM9SYcM+dbf/n8BVS2Wf4RO84AmY9n0AZN+rYkhhKFUHbD8qkAZmqFjg5IZHBpLR9bM/FOfhSipLvP+8GAXjMs7LT4qmGH1L/fXXhgeWPRhYVRULMvO/PypU7YBKTj4fWU/PVBQbMPc9tPHtk/oCbb5dPJ697Ru08QRr6E1Ws+ZweJaweIF3j2ikoNVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 9:00=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently hav=
e no
> > good opportunity to block a process from overwriting read-only code in =
its
> > own address space through FOLL_FORCE writes via /proc/self/mem.
> > The security_ptrace_access_check() LSM hook is bypassed when a process
> > opens /proc/self/mem because this is considered "introspection".
> >
> > This causes a hole in SELinux EXECMEM enforcement, which tries to ensur=
e
> > that a process cannot create executable anonymous pages.
> >
> > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > accesses are only possible when the LSM allows ptrace() attachment; but=
 it
> > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > environments running lots of third-party code, such as Android.
> >
> > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically fo=
r
> > such "introspective" accesses.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>

> > @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, =
struct mm_struct *mm)
> >               }
> >               return ptrace_active;
> >       default:
> > +             if (priv->introspection)
> > +                     return security_introspect_mem_foll_force(file->f=
_cred) =3D=3D 0;
>
> As per 3/3 I wonder if you need an additional parameter to cover the fd -=
> some
> other process case?
>
> Like:
>         if (priv->owned_by_owner) {
>                 const bool is_remote =3D current->mm !=3D priv->mm;
>
>                 return !security_fd_from_owner_mem_foll_force(file->f_cre=
d,
>                                 is_remote);
>         }
>
> (I'm not sure how LSM hooks are supposed to look :)

We could do that if we wanted to treat cases differently based on the
identity of the writer, but I think in general that's not a good idea.

In general, if you send an FD to some daemon, and the daemon writes
into the FD, this should not cause access control decisions based on
the identity of the daemon, because it can cause "confused deputy"
bugs - the daemon might think it is just writing log output into a
normal file, or something like that.

> > diff --git a/security/security.c b/security/security.c
> > index 71aea8fdf014..d0f790a534eb 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -595,6 +595,21 @@ int security_ptrace_traceme(struct task_struct *pa=
rent)
> >       return call_int_hook(ptrace_traceme, parent);
> >  }
> >
> > +/**
> > + * security_introspect_mem_foll_force() - Check if introspective FOLL_=
FORCE is allowed
> > + * @subject: credentials of the process accessing its own memory
> > + *
> > + * Check if FOLL_FORCE is allowed for a process accessing its own memo=
ry, which
> > + * bypasses the security_ptrace_access_check() hook.
>
> This should be updated to also explicitly mention the fd case. As surely =
in that
> case this is not true? Unless I'm missing something.

Yeah, I'll clarify this comment.

