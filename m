Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD9BCDE002
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DDE6B0147; Fri, 26 Jun 2026 08:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E496B0148; Fri, 26 Jun 2026 08:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D1A6B0149; Fri, 26 Jun 2026 08:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 176586B0147
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:40:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8752AA03DA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:40:02 +0000 (UTC)
X-FDA: 84922021044.21.F111855
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9885DA0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:40:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=txY7wWu0;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782477600;
	b=XD5fnsqRE2JywNS1fasbD11h/2gIOK2K3gnHo11XpVmyrtgXEQL+66Nwk8RBoGHlIfDoml
	P3xZTxIGlDnTPwLBRqFvjHM66ei3nkzVzQLeBCc1YWdN1Hh6cCNWP8v2veowoLHjYrBPLp
	Bsq3JWwUYYiuerjzmXO9rvfr02lT0T8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782477600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E/powVa2kz95H4iGUwNMkUp/TwMZFDOhnjzy0yvsRc=;
	b=7hLaEdSnWZPNYpFnemG13yxSL+jGJYvufCJk0mEl65EKz1rtwuEdECqdJytsEF3lqhApaP
	trqgbwfA4q1tcWPvKqJ7iPac10r7OmjL7ZFljn/WbZU2sNr3nsPMKitXdjuAPQf98CW1wY
	10xt3/Q9Gk0DJB+UBZevsC/5CwQJwz8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=txY7wWu0;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6982f2dc01bso4153a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782477599; cv=none;
        d=google.com; s=arc-20260327;
        b=QsR0Cc1YU25FcI6UY8ZDX1xHqHD1hECeKGxztS40gvTWHUWSqBl9QyS2sKEs1R9A9z
         CAceURbwZJFInC5rpxfiKBcxgLTBB+nEJ1lgXipo61JtA/zT2atCfWXKCs7zo4hDFdAZ
         BdkcIAO4VkJKc+pA9NbAx9Gr4tjcNpkWcjSmi9hobAk/xUgRYXPFpnNSFK3s26eg3nwB
         gHE0nWFirZksOa8rP0DPwEZM3Vv1garW3ce/LQD7qAppzKK7FU2dyXgF130oh4m44p3u
         Ef8ibhgsgmV4nWOpgtMmTUz1L/JJz+KwnLHQAjNh06Cz1VhA5Ffxq01ZeJdh+YyitQQJ
         HUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9E/powVa2kz95H4iGUwNMkUp/TwMZFDOhnjzy0yvsRc=;
        fh=FNA5yL90xZLtFm7XSs84E2GA6+2urlJplGnt2pjGVVY=;
        b=oS+KdFjvjEhcPzK/cu6bieqGr0IqENuLspz9Liga94dd22JyzYZaEq7cHGHAX+Xz6A
         24dyIexvDiRdEhiRRyZjHPGPwY3X5xDgQIPVPAX4SqWKZKydmwaAT1JMLFt/qYWbzPHB
         SyhY6KOaleAsnfPYeSUJv5YK42dInysZivYmIuMjIE7xixjFNRBZ3X3dENRv9K3f196q
         mz/sOu1fzHQnSMer1+2tItC1uz8BuxtqH5Pdp/7m9dj1lvhLGe9uoD+czK68ClS4yHvo
         Wl/StaQ/vTK7WF1cKzKYRhiG65gIoh4V8TDCbeoKF1QUh7wFam+DWid7cXtBd7GU4W/C
         u3fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782477599; x=1783082399; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9E/powVa2kz95H4iGUwNMkUp/TwMZFDOhnjzy0yvsRc=;
        b=txY7wWu0FfwUwcY4MavFdSVVRms/uwxUkI4GGatpnvnE2iVQ1AgdraPbPJGJ5mP6Ap
         yWyVUNGtvvk8MAhghopsLQTA2JiuKYDQNBecAEWSN1bvP6lXDQMlcLJ6YzuB9OfeHEIM
         L7mMR05WpvPIoJmxIgeHAWmxARciVS7BKa0LVbUbjeI9pZsGKB0t2NdbAzGdOmqLSFp0
         utcxz8k62dJ1Y9lA8z5xQuLAW4H1+0d98SHaWmIMF+zkZB9lz/GHefpqnk5xIvuUXsb1
         cAcgiKhflPZm93ITvosUuqftPkSVapXaLLM7H6LFfIy7FfSC0wc4eL16B+fWGMazp3+9
         /TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782477599; x=1783082399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9E/powVa2kz95H4iGUwNMkUp/TwMZFDOhnjzy0yvsRc=;
        b=acptTP45TZ2Yxgi3qtAWF0I5gcZ6jYQn8/QojPkiH3HUOD6X95r8+flyVHHlrnbWGg
         S0+hGZaDyJhLTEUIVcxDBk97TFEqBP75YvvEQFTbvxlDufzndU/N5efLGP5y8i5Au/iL
         E7770r9eYv2k1X1iOa8pRAROpoh+hMWrzwuHTTr9PgAp/N8oImaAp9L3ezdHkpzpkl2s
         5dtYq75L5ZWqM7SS3/uAKub3mh4jo7d00Qrzowo2I4R6BIixA4SNbOJCDeFgrzi9tFXL
         6uOwjI3jJZauLQbf3aJd/q6Hl7z8g0NETgFDyciiIoWvyoZmvQpRH/KJbXUl9xg8tY03
         zM4A==
X-Forwarded-Encrypted: i=1; AHgh+RpYtFxkgXFszWC+MM2e0Xz06D4hwbrSq7T4vLOYZmhaoB9UggZed4t4AjvvKTa0Ly8/KE/eg6KwVw==@kvack.org
X-Gm-Message-State: AOJu0YxlmUYA9a9+j+Rlp2oBXFk7UwdLN+YDjkwZbOXTYslITLr5mx4n
	QI59bi6gu7Vdo4G1q0uTRFszogGY0HBU7VOW9MQs17II7xYctCH8B4OJQt3DM8ip29bzsZYS176
	xifUb31Rj6V6oq5N/0iYRHwNLrvMS5EEkF/IkZu7x
X-Gm-Gg: AfdE7clu4ng+Sk4KOahWlJbHUv6E4h2p42s3/VeLJK36OT63DpwxaJ597fb5Wou5rEg
	ZUT7fgDPI6zBomEGVHc2qSF8XXTJkqmPodASAJonLrf4DovL6COke0x20XwR65cZDMWIAICAuI2
	Dkp6sX98GLcu1cSWcCe7JOSQjNWYWezdBvwoN2CWnXxriCmQ9R1V+txV0PSWyQfGuOIwH3uBqeB
	Zcn3LH7EFVoKJgo70wBwmo/Pf9EbI2SMTZd8pDjIttD+5kQhkapeaYIX5FhqARkDUp9+lk7wFa2
	pFWVE3yecL0EXSUVIXAwSC8R8+18Bd2y5wJFFVjGQ48rdaaJhRp7d7XOF2g=
X-Received: by 2002:aa7:d3c1:0:b0:697:9254:a66b with SMTP id
 4fb4d7f45d1cf-6983795482bmr2913a12.6.1782477598491; Fri, 26 Jun 2026 05:39:58
 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com> <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
In-Reply-To: <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
From: Jann Horn <jannh@google.com>
Date: Fri, 26 Jun 2026 14:39:22 +0200
X-Gm-Features: AVVi8Cfh5sgf8WRo60ET7C02KjqU2lxAfQoevMPof67z3PBX1H-BhFeEjrTW-GA
Message-ID: <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
To: Christian Brauner <brauner@kernel.org>
Cc: John Ericson <mail@johnericson.me>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	shuah@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-kselftest <linux-kselftest@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9885DA0005
X-Stat-Signature: hbyf5zg9oksyme6ogxqpd1k8rsxsywu6
X-HE-Tag: 1782477600-338779
X-HE-Meta: U2FsdGVkX1+trzcDv/vxDoIfQ2ZMOkghvdEWIHdjatzBUjP+52qKWHddxSzMHG2FPBwWgHfGCxmvD4WtpZW1WhnzANbs+AMuWkLgqizlPu617YQ0yj6ePflTQkpzUYFhegU6+x5/fF4HE/MdGy6IhEru/0BTVh6Jdi0wkmP2yZOHd9bsdxr8o+cqnNzrjSPdUHaqGpBy+QHysZVtSTuP7zWY8dJfLR7i2bHPU2lmE/6DfYsbPLafKi/2uM1xHGf8W8Q1/wZ2C+2fNiwnjD4IHFnP1fe6yCZytUjpxvMCaW3oLOKKefeYQ4CUeeZFXZKb+boh9Pc7dYVfoGZt524Mx2J1F8Y1E0qdkgSlNrPiClbtJgH3hQvkaTsTaN+HZzdUwvQAOzFYlxGdIEFUD08RYuGtHRc6IvqgWs45PPA/WAgop6O2ESlRPPeMQP2OXsdJQEVs7O2LBb4MXj2Gx0XWMY3jklbUXFwGpWovHSrWdn3B3aeoBb98kwyi0cDYIj1mo38BeWSyTONP37ZPkhZbQEUH74ZGP0/EJOax1Mdp2QwDzk55ob5y0d0B26TwLNQG/TMpCwDfOvU2fyDVcsWh2/EvFa/mfs/Cg3AA31b7KeXSGx+Lgr51JR/ZFlKlt7yga7yqL3wIwnDR0STv3XfsWw0iJKtPqSMbD6NxyQDiROV2kSFRSTDZy3ia7E2ssKMQRABwi1W0J/Qs5j15+dCg+fLg3GiVnF/5f/ZDvQSaF51qtSjWJVZgmpjmwlOk8pffCcMMFnweQZ/FgCbXvKqhQmrQd8r84fQw5hs1ttOgX88IUG3dXFHWLSZXMeSjaixKQLPn2Dkv2Mf3lFBkNfxhLzHxImp7dCOLKudHn8sttYIthFV8NTgKuwoXGrkyL2gEsLH2OBQhWwMyhW/Fw3nhT1TlwCxyIPQ/GGpKVRbvoT7VJOXNhGsy9sqg2sjY5OaRFTtryKT5ZqwNLE8ZQKM
 33uvtIOc
 VXkx2Fv6kFHfhwmghYVhoWzsHhdx9M9tvbTHXx56D16yT7YRPdiPvXNl9CZEE/cQc+CtF6zoRgrRXfq6vhnqe2WKVgGmsPqLVRiBQy6D/V9SgFxZV8iXWWx3eIkrN61SYo+C9Tg+KJunNrZQuiSoUmZNuNuzL+tn9nkYaJSGG//+5ReUPRGpI6q1wWktoBgIdZfdH9wiqaVPDxjtZRbK7r9SbA+DgJ1/koxXCo61RsWmBsx4EjmghKJAU5lbIdVQW8hI9f6UkVkZd52nkbyAfJ2uG4XhyfL9mn+N6VXkvqRb5NZyhPnqP/Fs1d+LncSswJR60aYoSdhhw1BatSMwMaerApWJIvRF1J5r+e3DLdeGMVpnnrzzWopV4GEqye1OiDa2B93mXPdN5F88Rs5ZYZ1tLeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> The arguments I have heard from various people so far are:
>
> (1) Userspace would be able to clone a random chroot to /woot and run a
>     binary from it without having to set up a complicated sandbox
>     effectively making dynamically linked binaries more like static
>     binaries in a sense.
>
> (2) Quote:
>     "If you debootstrap/dnf a chroot to some location in your
>     home dir and try to run a binary from it, that it tries to load the
>     libraries from your /usr is a pretty unintuitive and not at all
>     useful behavior."
>
> (3) Quote:
>     "[Various remote execution things run in locked down containers that
>     disable userns, which makes the sandbox impossible and hence our
>     builds wouldn't work there."

FWIW I think someone also mentioned to me that it would make things
easier for them if they could build a piece of software in one
environment and then bundle it up with all required libraries and such
and run it in a very different environment, without
container/sandboxing stuff and without static linking. But I guess
that's kinda niche.

> I'm discounting "Oh, userspace already allows this so why not the
> kernel.". I think that's generally a bad argument. Kernel and userspace
> aren't really alike in that regard.
>
> The userspace ORIGIN concept is guarded behind AT_SECURE. The kernel has

(To be pedantic: The userspace $ORIGIN concept is only partially gated
on AT_SECURE - glibc has an allowlist of acceptable library
directories, listed in "/lib64/ld-linux-x86-64.so.2 --list-diagnostics
| grep ^path.system_dirs". But clearly we wouldn't want to mirror that
in the kernel.)

> to enforce the same rule. That means the loader now depends on the type
> of binary. I think this is a rather serious issue.

And annoyingly, the bprm->secureexec flag can change in
security_bprm_creds_from_file(), which is currently reached from
begin_new_exec(), which is called after we've already opened the
interpreter, so accessing ->secureexec state during the interpreter
lookup would require some refactoring. So I think this is a doable
change, but would require more work.

Or we could take the easy way out and say "the kernel always rejects
this unless LSM_UNSAFE_NO_NEW_PRIVS is set", which would make it clear
that this can't lead to privilege escalation and would serve as an
incentive for people to stop doing stuff that relies on setuid
binaries or privileged apparmor/selinux transitions. :P

> First, it creates confusion in userspace what loader is used. Second, it
> means anything that any build/chroot that uses AT_SECURE binaries now
> has to use the sandboxing solution anyway or risk that some binaries use
> the system loader and others the chroot loader.

I think we would probably just fail the execve() attempt if we see
$ORIGIN in the interpreter in an AT_SECURE execution? Since the
interpreter field does not allow listing multiple alternatives.

> Ignoring AT_SECURE, LSMs likely will need a say in whether that ORIGIN
> thing gets honored or not introducing yet another vector where this can
> be overriden or ignored.
>
> Also, we change long-standing kernel behavior which will be very
> surprising for any userspace that might implicitly rely on the fact that
> the system loader is used. So even if we were to do something like this
> it would very likely have to be configurable in some way.

I think the proposed patch will only change behavior if the
interpreter path starts with "$ORIGIN"? That wouldn't work on existing
kernels unless you have a directory literally named "$ORIGIN" in the
cwd, because "$ORIGIN/..." would be interpreted as a normal relative
path.

> This makes this all ripe for malicious loader injection attacks. And we
> need to consider this possibility.
>
> So I'm not enthusiastic about this. I want this to be consistent.

