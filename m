Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3829FCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF746B008C; Tue, 23 Jun 2026 16:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F416B0092; Tue, 23 Jun 2026 16:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C953A6B0093; Tue, 23 Jun 2026 16:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9210A6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:35:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D8FE140122
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:35:19 +0000 (UTC)
X-FDA: 84912332358.20.63ACB38
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12C11140008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:35:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ElBkhWbb;
	spf=pass (imf26.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782246917;
	b=yf0DC8VTOaujD68jfU3XNeEbcXhF/QsmTQ5O9MI41+b3aadSrcx6IA7Og5GwTQAwy3b1Ql
	lnycePpu6hMTC+IPN/XBL+8sWRg0qfjEgJYdc/HjGL8zvaslf5nw3tU1H5bcJWShd/cIzE
	Su/GZKUKPjks4d6sYrKhePzSMsbSJjE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782246917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jn7ncJBrXK948Ro9HzPmcDhz0jzCr17fg/cQrz5PFQ=;
	b=8UXGlMfKETPbrPIGEFj2CivL6nkFWxURRSoQIoZ3G/NlwYHyxTqrxn1RZ9LT+RJMcuSjoT
	WVs4mPTMpqivONh6RxEDp/zKrEQJhp9TbBsPXWY+r75igfaLpK1cw1s59mWWWC4AWlLRh4
	6E5SLtuadlgaXnpyz/B1bD+YUGo4trk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ElBkhWbb;
	spf=pass (imf26.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-48673dc56a8so305224b6e.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782246916; cv=none;
        d=google.com; s=arc-20240605;
        b=ceDiDeKuJWQzmJer3TGKhHWNL+Hb1vxT6ZLDEB7XePlyf+ibXSn1B8WMcWCHzk33GV
         JziyfKovUFb5TBca+d45B6hHy9U174lV9lLB1tBxC30Ng4PCV00UNcaxyJ9q9WSM81id
         JUgj12uRZeptwjDXcf+5+6Q2iblH8fFFANsYndWE4dwEybO7qFRDkVSUOSH5tLjthDtc
         NAHa2N7hMjJQ1pGYe+qG+mrIXkbbZhmE0hHOQSVOH5QzRzwUwKjdj/BsqH6j/sNmRTvl
         9z0i0mKm50CgtGjmJ7/hK7uDL4xqTYAJ6JLWFYPtxpXiWNkIEX+/LFT84cSqHriPFNSC
         XbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2jn7ncJBrXK948Ro9HzPmcDhz0jzCr17fg/cQrz5PFQ=;
        fh=Jvx2SK/zkIYy0SIq89q2B7nxixY1+b9Kai26GBeXdCM=;
        b=HxhesdmijfM+A+SPhG0cQIDs7e7vMjMa0ChGTEqM/kU/zakNpRW+2gQyF5sZ0SUFzd
         A+64c/zAxO1XKPAXK0SC3P4otvBPzMWwQZDRqj6dTigwt94C9dRPs+qIy4eGUUcnBas3
         0XUuoyxDCESirNXyu3Bz1Y72ZssFx8835P1AkCoElLf7DM274IBBJjSs8OWClc3wh678
         2w2AilfCgqPXd2R60lI5Kx6cLo75nSxCPzZ20ZIHB5iqkuVPVh8k2aIAk0JnRNBLjWtR
         oKCnhtTGaaHCjASkExdpojSR6HQH59oCTOMTIfm5SBmFJS9NQ4YFq/o8xrm5wRgnmrXL
         eBFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246916; x=1782851716; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jn7ncJBrXK948Ro9HzPmcDhz0jzCr17fg/cQrz5PFQ=;
        b=ElBkhWbb0XmW843rwluQk3XpdvFwV2gk4I7RUPSvMWEj8lONeOth72/H7mie9TrP+n
         Zh6I4CjSHBPfNeDmddZFJadXDbsJqGbE5X0GzB4ZBUJWDQK+6av3Fp91n+A3eO6ybmZN
         hhipxiaOYe0isz6nnhQ8A/BkS+//Uk2jnm3sVl31gedIq+I2QhAy8pr/VBKlHKK2Vwz9
         sYLvguYvmDOQcGJkN1ZG3BvXMCsqrrghY2vZxqFsaWNkiYd2pi69tKoF7mSzRrZs/apD
         89n7pBaDVjIJ0whi4MSBQTXXP8HbtWFz0CBS5p/GmJCOBh3/g6+F4X1wFQ8/bWi1AJoe
         sStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246916; x=1782851716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2jn7ncJBrXK948Ro9HzPmcDhz0jzCr17fg/cQrz5PFQ=;
        b=Soxe74twIpgcsKwaFlWf1t6yIhm8e64JOIgFFzb+rxFAocDyGI7N5vsQe1AOGoHp1h
         YJkHRc1CMp2SYmKAvZauPY1s+CpOyALRrLkiL5S3j83x5NwRsVZlqznZlQjH/ZpqjOZI
         sSiRZBhgiNNDO4uFi9F6JR0bm0RMJSMyRjBM0tc2olh0Fo204iHqMgY26cIH6BlOYXvC
         up6Ka6PxpYG9ruyujeQTMQJ27i39bgkfTV1OVg0oYe0DRPh+2pdiyn9lMnwEudAME11l
         SBUVXlUk1kR7RR64KD9RCwmMXFixTwSDgIpuZbuVjU1Tcf/fb3n+jm0pM66hZPwnQsks
         rqRw==
X-Forwarded-Encrypted: i=1; AFNElJ9VBcm+nRCbkLcqwRKPRTh2shMlaKtSd4ofg+M4pSYLlalTHotX4AcJfGPlS+QQvKDUl1eKHoy7Sw==@kvack.org
X-Gm-Message-State: AOJu0YwyIHbdR3xcXCIbEbEBfTG5TdQMwyd4doP1PnwCOl9sZzqPZXml
	WRbrBXi8ddo9HaP+KYn3fa+HwrO+OuL6jaIVXaX3ShOS8sEOpyDd02KITbGFv5MntKIYNqzf36O
	ZzVfEROaOmmchB3bV9HGOUyVYdETRkCQ=
X-Gm-Gg: AfdE7clrvrhmy/hXwIOCtWdCQ0TokjH4e72d31xwrikDPWJRT4a5ZRj4RZGw6cMqW6N
	MPrSmQxeGpq5TIfzvtHHBRCu8UakysAeL9Zz0N7YziWZ9xli7G6ugqJ1jxZ9iqsCDxUIHcbhAU5
	Sn9O09bvlq4XfgH60x/kY5Yk1gdWzKqya/W5HFhfebU54cNyzddOfyCjIi/G3pl+TGhk/HWbFoJ
	Zhb1lbW+pAJpIS2iqQkL99EqRFwsN/Iv50SHPoK3iR7SkxzEwCt6uk8DApFjujX6odv241Ei9Ug
	LHNaGy1AxhzmTqUuA6vU1oqXYI3OgNNBDuQJnrAg
X-Received: by 2002:a05:6808:c185:b0:48a:aaf2:5b67 with SMTP id
 5614622812f47-49079496167mr265841b6e.31.1782246915981; Tue, 23 Jun 2026
 13:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <20260622043934.179879-2-farid.m.zakaria@gmail.com> <202606231236.325C882A78@keescook>
In-Reply-To: <202606231236.325C882A78@keescook>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Tue, 23 Jun 2026 13:35:04 -0700
X-Gm-Features: AVVi8Cc6baAOrvpg7bti2txnm7y_PAHygqiZFWgpLTsnuazHS3APcFuR3dcSQas
Message-ID: <CACCo2jmyExCoWyWy7VKvm9nVpKi1Oet6jGaSsNs0Wddr3Hu+hw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: support $ORIGIN in ELF interpreter paths
To: Kees Cook <kees@kernel.org>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 397c4nuo919akgcecejc4kfiwagxc5rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 12C11140008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782246916-543233
X-HE-Meta: U2FsdGVkX1/4itOvUEQ32zoGww+WFa9NGKHs7R1cKWI/sZ29RgGGMl9I+5HxJASiNWzCxGaS3MzpTirwDnIUe4qjhrtUQtojh8yzWFQOWXqo3tD4jGhYmkw4sIDug3cXofwF0qu4cEu9NX6F5TH9ou9DpibqFQUwkjkkqLaEu/8+7nVZi5m7WujSuTW5z8jzIFW1Zybldh1LZiWJHnKtwzbMWXkwC55BMx3NI5NbE7eByzFXzTYIzZJXWYqt53Sn7MPWUbK+jMD7hH+kVf/XNKwuL+feBBaKWjEgqfMv7kYtp2VCvLEKsDiOTSlMg0h/3Dn0XCb15zdA8IP5jU9OLrfb+hRpq1Pr7KDkU+K3PsyQesbSZ6glnNaN9g4nHWgdcFeswyd70mi8kEE/jaGXyVeEMXJqWntm2KOLuKoI97K5eOBBwpimsg7swTK/He3NscAO9gFp72+2emDpkJf6bbnpPvhqF5Ac0TvhAhN7RUgeoE7soGMm6thWi90tGAIxjgRi5ipTGDS5ZB2PL6S7mkZrv0vOZ50be0SY/ex8C2u4yyT91Rd+7oErLViyTOOQ6AcZl1dJBQGdoKYELzS1nZuI9WjUsfRjSOa5xfG6Gm0U3mCXz7LhuzXjejbvu9IN2+gcR6pZIcXp+EJdC17Z3vKu2M8qlNoB2ebxbpZ5tIjAle3JuBq12qsxuSLr7o92gxFO1HORWsooP6zyUyKO9pjkGeRbk3ZX/UWMz7KYu+hQGY4SSPLcp18N5z71Zc9NuaDIYxVAJ9qii59TNibMYI4cv3/BaS4p4dMiLZXFSw9KjeSbem3qdp39btvhMXhWfoHq5IRbOnklrE3shsgU8JlQyVcS+pDWApdPHPIsohOupYjRg9r+GA2UzvfkkeKH8/iFVcRbJPm3Kth8qS4rUUZyHGJscHcO+aCh+RZuaD+DwRuG4d3L7pPQZTuwUN0mtTjYp+j1RYM4Fo8Iljb
 JB1SNV62
 YjrjwEU2uNleWDUO1ryCVTDrBP4bxyGnroi4QLY6C0H1Ra1zLT7PPYoqFzYwS6IMc2aMT9bBkwZ/3bV1o9oRc4np/ytmV+wCy4xHK4Uvxyz6P6rbyFMop7RT5p2Ha59xpkwLewjWGzneRbKEFvOaL5fHQplDxgUWADQRYy77d4m8fvaEz+Lqrg39H6Gv2RSHJ2L6xhv9beydaJK3CIgoXEtOaq4gmPUa3WMsqPwTm0RoaMYnNhG62kyv5ETyFkkhb697XnrW6zK+B2AMqrvku/YwSwOqSAXFQh86t13e7NvUj2AEyGmvXVvZS3pX+NHlN2uP4LKjJ0azpFIXZIouf+1dzzGq6usRsj4LPkpo8l+r1sQucFUe8AD/zhSOeUCDN12gfQPA30emyEpLJbB+YZhKykjGP2MbcPJ3ypfmgNKrHC6fD3vQMJVZ15ZX1cYBr1MMOcMxDG3BkJ9yZrHWjvOjQBY6mu0hR9mQGQe0qR0hYRPl4BDpvCDb1YEhbltYewMYANk7Li7fLHpCj4cPovlfQXRjDBQP1kJoY96GHflcHsI0qmzvhb/jTcuHo6jwwrisLsy8/pXgCE3FAiG7cV12uXvGRM1UiFJqV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for all the improvement suggestions.
Yes, I leveraged an LLM to generate the initial code (open & honest)
but I'm willing to keep refining it to whatever state upstream
requires.
Thank you for not dismissing it outright right away.
(FWIW, the initial code was even worse so this is the product of me
intervening and editing it, despite my lack of C expertise).

A few more attempts at convincing :)
* musl also supports $ORIGIN
[https://elixir.bootlin.com/musl/v1.2.5/source/ldso/dynlink.c#L911] so
there seems to be strong convergence on the concept beyond glibc
* ideologically, everything about a program should be portable easily
from one environment to another (the goal of systems such as Nix).
Userland has allowed this support in nearly ever-space and the
DT_INTERP / shebang path from the kernel seems to be a missing gap.

We also have the shebang patch ready (CC @alan.urman@gmail.com ) but
we wanted to see the reception to this first.

I will wait to update the patch based on your feedback and Sashiko's,
if you are convinced just to avoid spamming us with more patch files
:)

Farid Zakaria

On Tue, Jun 23, 2026 at 1:14=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> On Sun, Jun 21, 2026 at 09:39:33PM -0700, Farid Zakaria wrote:
> > Currently, standard ELF and ELF FDPIC loaders expect a fixed path to th=
e
> > dynamic linker/interpreter (PT_INTERP). However, for systems utilizing
> > relocatable dynamic interpreters (such as Nix/store-based environments)=
,
> > hardcoding this path is inflexible and breaks binary portability.
> >
> > Introduce support for resolving the $ORIGIN placeholder in the ELF
> > interpreter path. This maps the dynamic linker relative to the path
> > of the binary being executed, matching user-space origin resolution.
> >
> > To avoid code duplication, implement a shared 'resolve_elf_interpreter(=
)'
> > helper in the VFS exec layer. For safety, limit detection strictly to
> > the prefix string "$ORIGIN" to prevent complex parsing exploits.
>
> Does any other OS that implements ELF support also support $ORIGIN in
> the loader? $ORIGIN isn't even part of the ELF spec at all and is a
> glibc extension, IIUC.
>
> I'm not excited about path-based string manipulations as they end up
> being racy, and mucking with loader path seems like we're inviting
> trouble (since the _binary_ specifies setuid-ness), and we've seen
> issues with $ORIGIN before, even strictly outside of the kernel:
> https://seclists.org/fulldisclosure/2010/Oct/257
>
> > [...]
> > diff --git a/fs/exec.c b/fs/exec.c
> > index b92fe7db1..0978ae613 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -2024,6 +2024,48 @@ static int __init init_fs_exec_sysctls(void)
> >  fs_initcall(init_fs_exec_sysctls);
> >  #endif /* CONFIG_SYSCTL */
> >
> > +char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *e=
lf_interpreter)
> > +{
> > +     char *pathbuf, *path, *slash, *resolved;
> > +
> > +     if (strncmp(elf_interpreter, "$ORIGIN", 7) !=3D 0) {
> > +             char *ret =3D kstrdup(elf_interpreter, GFP_KERNEL);
> > +
> > +             return ret ? ret : ERR_PTR(-ENOMEM);
> > +     }
>
> But even if we did take this, I really don't want to incur a universal
> penalty on exec for it. This is doing a kmalloc+dup (and later kfree)
> for all non-$ORIGIN execs. So even if this gets added, it needs to be
> handled differently.
>
> I would probably say this helper should return a struct file * instead
> and have a fast-path for the common case. I think a check for leading
> '$' (if strncmp doesn't get inlined) would be okay here as far as
> "incurring common performance cost"; that string is almost certainly
> cache-hot.
>
> > +     pathbuf =3D kmalloc(PATH_MAX, GFP_KERNEL);
> > +     if (!pathbuf)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     path =3D file_path(bprm->file, pathbuf, PATH_MAX);
> > +     if (IS_ERR(path)) {
> > +             kfree(pathbuf);
> > +             return (char *)path;
> > +     }
>
> This still just _feels_ like an info leak or a race condition to me. I
> can't give a credible example, though. But it creeps me out. :)
> (I note the blog post also says "and the shabang" and I get even more
> creeped out about seeing that patch.)
>
> > +
> > +     slash =3D strrchr(path, '/');
> > +     if (slash) {
> > +             if (slash =3D=3D path)
> > +                     *(slash + 1) =3D '\0';
>
> This is not idiomatic string manipulation.
>
> > +             else
> > +                     *slash =3D '\0';
>
> More readable, IMO, as:
>
>         if (slash)
>                 slash[1] =3D '\0';
>         else
>                 path =3D "";
>
> But does this match the glibc resolution logic? i.e. should it be:
>
>         if (strncmp(elf_interpreter, "$ORIGIN/", 8) !=3D 0)
>         ...
>         if (!slash)
>                 slash =3D path;
>         *slash =3D '\0';
>         ...
>         resolved =3D kasprintf(GFP_KERNEL, "%s/%s", path, elf_interpreter=
 + 8);
>
> (requires the trailing /)
>
> > +     } else {
> > +             kfree(pathbuf);
> > +             char *ret =3D kstrdup(elf_interpreter, GFP_KERNEL);
> > +
> > +             return ret ? ret : ERR_PTR(-ENOMEM);
>
> This is the same as the logic top of the function. This repetition smells
> of the LLM. :)
>
> > +     }
> > +
> > +     resolved =3D kasprintf(GFP_KERNEL, "%s%s", path, elf_interpreter =
+ 7);
> > +     kfree(pathbuf);
> > +     if (!resolved)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     return resolved;
> > +}
> > +EXPORT_SYMBOL(resolve_elf_interpreter);
> > +
> >  #ifdef CONFIG_EXEC_KUNIT_TEST
> >  #include "tests/exec_kunit.c"
> >  #endif
> > diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> > index 2c77e383e..17419cd3d 100644
> > --- a/include/linux/binfmts.h
> > +++ b/include/linux/binfmts.h
> > @@ -150,4 +150,6 @@ extern ssize_t read_code(struct file *, unsigned lo=
ng, loff_t, size_t);
> >  int kernel_execve(const char *filename,
> >                 const char *const *argv, const char *const *envp);
> >
> > +char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *e=
lf_interpreter);
> > +
> >  #endif /* _LINUX_BINFMTS_H */
> > --
> > 2.51.2
> >
>
> So, I guess, I'd like more convincing, but I'm very happy to see a KUnit
> test included!
>
> -Kees
>
> --
> Kees Cook

