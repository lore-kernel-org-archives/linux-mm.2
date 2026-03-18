Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86E6107761F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C146B0341; Wed, 18 Mar 2026 17:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D876B0342; Wed, 18 Mar 2026 17:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204B06B0343; Wed, 18 Mar 2026 17:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 058D26B0341
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:54:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F05451601B3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:54:32 +0000 (UTC)
X-FDA: 84560538384.07.AAB62AE
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0165180009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:54:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h94QZ0Mr;
	spf=pass (imf06.hostedemail.com: domain of nogikh@google.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773870871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sq8Zef88wTvL7ftUgVRmtnJy4V92j/A/FRapr/18di8=;
	b=UC4maCW6HmH2EXZ50qj/CceUkVrKVVUQU5r4DFKSfAceXv0yYENHOnDTHSCSJ1tk6cQvoS
	9prPVfnZEPLqjC+Y9h1+kvu2JIvZlMuRZR2P8G29Cqhrx3BR5Sx30yXiG74x7pByi4F4xM
	zsVOr/YJEgz6FefkLho0vJKNcSEzxX4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h94QZ0Mr;
	spf=pass (imf06.hostedemail.com: domain of nogikh@google.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773870871; a=rsa-sha256;
	cv=pass;
	b=N3dnzlKpnjOaj65LNFCouItTGJBBlNwg7TWoXebv6U5UVj1uEfPh4O+nJun4TStZIQlU/1
	GT4KU2AH7Z8amBmNtQp8Llr/+C5cyn1U/1DQx+c2jDu5FawV+coc50dGlyeLaq9ywpDxNr
	l/+Kiuwt+WeVZAXRmn65QbdAsnAazF8=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-463a0e14abfso35320b6e.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773870870; cv=none;
        d=google.com; s=arc-20240605;
        b=h7SbVZY8yg4KXdSsQgNvpTAQKQEUAiRZwQmHn726uThGAxmUUCnIExqbP7t58rOGBB
         Ce/EfJQsPfl1BuyyTjcZs7QZZwnVoHElkoK9FhmXcl+H1k71j35+q8dViTPexiK48UqI
         BIm2AUp/K2pBkaUY1qL33CAp4VLd6SW9kE8esZyvviGeKlkFcPuRptn4WOW/JSP4OCYA
         dwrgk3E7nB7iWdTkmilj05qUh4g4riLIuXV8olqoyS11K89j5fcoyCzjLVWlyf8RyFoS
         XUgEZFiconnRNmj3X7kq4FBg4O+VU6YaEiLNcPaj1md4oiAARj9LlcPx5kjM+sTRV9l8
         Lz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sq8Zef88wTvL7ftUgVRmtnJy4V92j/A/FRapr/18di8=;
        fh=9CnjQYffZsYwK3BIr6HMebYkBxQKHV/qz+N7l78dS6Q=;
        b=a5Zq8MKITbhluf4jk+S4cmFR5uli3EH5ZrcV0yL9jXbQJNf7Ki8+Sj5IRsVmEZTBRu
         +ZKyX4gCX79WkKAf5Kjgy65AaEoC87dUJr0P/DHzKB3/5cW3m4/I9lO8jc+nvXhMSiHo
         JLYp91nF7jZFFA1/BUD2LNZW4N1N1eazWQmVEx3EG1sJbn4LWaKhK8y7fJ0UCHks7GbL
         48TG80dXfS9ePEVzd2iWhU9X/Y+at3xlxfuHIWTbHQgVtRuGCXuTnwKGuIZgJ13HGea2
         tBtUdBrmqymmHiBz8GhFJ1t+DHlJQQJBxJmX9K+kDexCg0bcoT6QzVYOeykc56C9kPhY
         CTGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773870870; x=1774475670; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sq8Zef88wTvL7ftUgVRmtnJy4V92j/A/FRapr/18di8=;
        b=h94QZ0MrVB6GJrTxwvf1uOGCL5aOI5a65aWrsLrWvj2aLaCpzHXdY6+lI1f1KoTJ15
         vB3vts34dWWAluhL1TMH09vPlRjmrgracjJSX/pCrK5PkXR8HO4wK0VkjAsFKE8wAqwl
         dnHwI8JO5YuePfnX7N3yyGdK8KWugrehzN117ow/qsy8k4hPRXtvdt+MXmJDsdheImge
         giJK+rKePK/aJVCA4beEiIKtqzt0uiKYuhCP8MyhePfU05k02yl1+t7bD8OkLf0qQyXA
         adNd8Bps4IFct/LrKxemCHEFcDmDGx435ovEXqQTc1h4i9BHR8I3lsooe2rDihybuwTU
         ezgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773870870; x=1774475670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sq8Zef88wTvL7ftUgVRmtnJy4V92j/A/FRapr/18di8=;
        b=dMecJMNABsNAjmpnJZbP2cGlXhonZrOruUw3DEqzyfipR4ELd6Vla9PEVpAjbpEvHW
         r3ZUQXoEJhxf6/clY2YhN36YvzsKFCRMw/15ikEi9QjU5PSSL+ex3tzf+B5PUtGkiCbc
         2gIYyvZ/xd4pvekp68DCmDKfhTX24id/94o+IKJY6X1XUy6l1qH5rF2MCKGgihLOdgwg
         9PcmLOh6co6EdIahysS9sxqGalNLU8i9ABzzyKUeyja/kNikhfCQ9xWjPL1V4SnB5Gc+
         W9CfW5ILj50GOfs0eGkOyBOCgO0lcxGjXmAJprpS2w3OEj9gizA4Uu9cnVs2WfgRjWkV
         oarA==
X-Forwarded-Encrypted: i=1; AJvYcCUgr+G/U4lvqx6ZSpbWmfNoFHBiJ12UyocgOHM5khHHPwJey993pGC1slnUICkiZY3YvRwL7xMhfg==@kvack.org
X-Gm-Message-State: AOJu0YwTFqNkkkg/HflD0wwlsGCr+UYdP9kox0DzQVIJK4BS5AXNOmzb
	dNye9INUSb2tQJTrAbXNpKKViZNdZiATnIUxZrm7LoAZMVHDWV5O+4ByD3qqGX8l8IH9koob7hX
	5J9uf3dhLYG3p7aJb+7JP9r5vJFTRGpUarB/aUJx+
X-Gm-Gg: ATEYQzz1Q6dPCarwyIyoF1j746mYMY4sSiJ3ba4BHlbVh+uMa1OoG2g/aYcrzbbI+Tk
	LWHmv9YXlhy5Phi9/fn+ui5zYIJJERLDCYu4fdlE6bslbp0aKGEzhapz/rGJK95gflgPOsSp37R
	7ySjnUns9DWM9HvXVdxoxnyYawblmQMsjiGVP7abA7mxoSSNnJijI58Nq6K9jEIYdOd3po0DidT
	51iJu+akxYP9MpHiQfzrfhQcT1Z8snFyvR4hVhW25YgzZnwMdcZzWfIgpZVgCELCcZjnCUyIZs7
	ZhTEE6zP8CsUqDlrLj6qtUvWxrDRmyHASnd58ebbqVaNdDFggL4mYeOM/6XDEu4ybrMjHkd4
X-Received: by 2002:a05:6820:81d4:b0:67c:c44:1e8f with SMTP id
 006d021491bc7-67c0da8f663mr3479585eaf.17.1773870869097; Wed, 18 Mar 2026
 14:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com> <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
In-Reply-To: <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 18 Mar 2026 22:54:16 +0100
X-Gm-Features: AaiRm50624O_IH0uXYUCOonwhumdb9n3LmcPRxx01Jf_rEeK04VvVJwOxndQ6tQ
Message-ID: <CANp29Y4f0sd6fbsR9MhB_bqazLe59rsC_uRU5CH4h5wS4HficA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	npache@redhat.com, ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com, 
	ziy@nvidia.com, Mike Rapoport <rppt@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F0165180009
X-Stat-Signature: n39bic94czwkruyxame5nm5k57s86o19
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773870870-656572
X-HE-Meta: U2FsdGVkX18B68z92mEGnPxsrwyfnAnCDSqvUjzDMAnkOlckOTD7gaX5LJO6tMjyKLnPhnI1BZtLySX5Dh73GGq68lVzGXA1qk+r5naffTZ4rklyY8YtpnLSJQGYJDLSi3EYpfcHFgA1YAjMzMrveU238m1MpaIuNCfW2t5B9yP3MIQXe0ftzeYA8Tcu5z1j0MzwQiPLUQubetMFWKyrTI8fJayPoWMkxCY8YUCFyge4pVjNKhUD5kqytUabCz7kNwxkKYFKk9+xUzFhlppFE4pfdWaptnJHK6dL8wAp6PQLyOlQmji5dGgc+cYYRrwhnOazeWRIztu9TTbHEW/DWygHZ/K4ug9o/ZSDwtAfM3mmX1K79EpvENGS3d9TbMfWagm4zxG7nfvlLAOEmxFFFetA18mNMxMeqLTOm+mflwTFsgvQAuvN1J5o5sVm2ioOzgepcS5eXXCwaPS3qPSsrF1Q2xCxIb6lj04wmDAwT0RhrksbgAIg7+EFgVMsIOhtOSN23U278/H0iF1fCawxoqOWx6wdQSQ/EPsGxCQsDwGZze6wD2cVyCQnw8IohgGap/QUl+I8WGALahMHFHMNCfc3GfgN0h/dS6Ggdtyn4AptN5zO/70MlFrsojUnkPkARrmdJ0ua09F8RydM4MOVCpYYBRkjvYBf9CTVcISc+xQs33XurEk814NJ9/OSwwP+mCoT0QXkPpPTOy9DdaN5gAvvVXqBnuD0btwUhng7+hOdoeLmTt+bwoYxQhl4nBIr3Hh2WPN/BCkCX01aV2VxRBYFA6FD4SqLAy5s3l23Xq0MIKnd8JU+SN0SgNLMYH0THWn80q2PBztK24RM7s+N3CvgW44l70TgqY+1dNuieFksK+9AcrBDYzF+bjoB+fq3UzznER4kUTKZnfg+l/eljAcXstv3dSDmIhAFVaX+NRcrMUUWWwCzIdPcSyDjOtWPChPtl5XTG8Z7XmPqvC1
 tKW3mFEs
 j4PFZRHqV+oxEDOggR3T67uZNHIZqwjBv+6/3tslwgaVsvYyL5e+r/woMNe5Z4SKD0U6ErvoKuXIW3FGpEvMbjIXERwfDT3iwEmSfNmmAYtd/4N6/SmP6+MlsOEPTLohLZw/TitbrLZ5iKk6QMdoL6FMdRyxbOBO9TtzRzfQUH9bwVL4uRGG1nYlwJfTHNUElHQvwyx5wi1+7Dl+kR6mAMu5+Y6Tx1rouTV5eYsZTrVhO6bDa+yvGOYZA9tPcBF5XWab/zjstXHSb9GaS85oTeGg4MWt0nWseGFRPlFpJHa5ugzXONGC4DnyuxCbZPlM4gtTLA7009b6a6bFoOFy0Fe+n0C1KP7dA44T4O5tcMvVP0z+jCHUzAbpyt+ZT58c3jryeBvTzjGt4wPpOKT+CWVxeU/hGTA3WSdJykARD+9b0mPG3u8yCudEc+0+Gz1WrbLyxsDLNFIDfOiTV6dyhRsV0tRyD6sT6wBgVb+r+HtXhjxv0C+Wg/B34x8UDHfjFiwaVRip5zAwT1pAtxgC8u3AEVVUTVVc2wa2LGplxfmeldG+oLyIORH94D+LYYiXIvPatE+yKN2WfUxe43f3LyOgpBQ5fTy1vbCXPxIs8sBhZGjuvFjlbwjsry9T9n0ZavdPNFkKOBJSsxg4xudfac63Oe9ny7Rx9Vf4qxhi95yGbd2J1cBDvYaaHwimwrsnD2XwPeMIKH8xkSDAfNLjYND0VFmkr3vZD0PwKmgAZ0k4FtR5eziNYD6ujf193oMAyAxryUxvr2LdX1V/56Z0e/JX/iruIx/a9EejQJe5xtTDU3FnfOSdI5/02XhIjslZqoB46Od3AkNZbsBmdMqm+4eYo1pTt8pib3cguvWiz+tgK8sKbwc497+WVJ8huw3zoz4Uo9G6SOfe7ZfheO4oeRKxtjjFw297HYzp1/G42d1PdTULijiH+4ePKQJtWybon8M8UQqXO/tKh/khyOH/RT9V0tcxx
 279Ut0Jz
 b+MzTcaUGTJRJzOqQjEpuEy1IANOKn0iy9V+hhUa8aQ09N22SNlKF07YP/UERu3bTtuoXRVB7vOn+YkDhuyK3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 6:26=E2=80=AFPM 'Lorenzo Stoakes (Oracle)' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
>
> +cc Mike for uffd, Harry for fix that also resolves this, see below
>
> On Wed, Mar 18, 2026 at 08:03:22AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
>
> For some reason I have to git pull --tags to get this... commit hash loca=
lly?
> Strange.
>
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D119ddd52580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3De7280ad1f68=
b2dce
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dde14f7701c224=
77db718
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e=
25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D173b44da5=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1537b8da580=
000
>
> @SYZKALLER guys:
>
> Note: the repro is incorrectly labelling;
>
>   //  ioctl$UFFDIO_CONTINUE arguments: [
>   //    fd: fd_uffd (resource)
>   //    cmd: const =3D 0xc020aa08 (4 bytes)
>
> as UFFDIO_CONTINUE (0x7), it's actually UFFDIO_POISION (0x8) as you can s=
ee
> from least-significant byte.

Hmmm, that shouldn't have happened. Syzkaller normally tries to avoid
mutating one ioctl into another.
I've filed https://github.com/google/syzkaller/issues/6950.

>
> It's also stating things like mmap flags wrong e.g.:
>
>       /*flags=3DMAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK=
|MAP_HUGETLB|0x8c4b815a506002b2*/
>       0x8c4b815a5465c2b2ul,
>
> AT LEAST MAKE THE NUMBERS MATCH :) this doesn't help with debugging.

MAP_UNINITIALIZED =3D 0x4000000
MAP_POPULATE =3D 0x8000
MAP_NORESERVE =3D 0x4000
MAP_NONBLOCK =3D 0x10000
MAP_HUGETLB =3D 0x40000
rest =3D 0x8c4b815a506002b2
print(hex(MAP_UNINITIALIZED + MAP_POPULATE + MAP_NORESERVE +
MAP_HUGETLB + rest))

gives me exactly 0x8c4b815a5465c2b2ul. What was the problem here? :)

>
> AI hallucinations?
>
> It also never returns with an error if a syscall doesn't work which means=
 the
> repro can run 'ok' but actually be failing on something, this really slow=
s down repro'ing.

That's an interesting point. There will be corner cases where a
syscall is expected to fail or may start failing after N iterations
and that's fine, but the idea is totally worth exploring further.

>
> Maybe hard, but be good to figure out maintainers based on the stuff the =
repro
> uses uffd -> uffd entry in MAINTAINERS :)

It's easily doable, but there's a problem: uffd maintainers will be
CC'd whenever uffd is used in a reproducer, which may not always mean
that it truly caused the crash. We do minimize reproducers, but there
always remain some weird cases where unrelated syscalls persist e.g.
only to force some specific timings or to get specific file handle
numbers.

That's why we mostly rely on stack traces to identify subsystems.

--=20
Aleksandr

>
> OK rants done :) got it repro'ing locally now.
>
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/d=
isk-b84a0ebe.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmli=
nux-b84a0ebe.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45=
/bzImage-b84a0ebe.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+de14f7701c22477db718@syzkaller.appspotmail.com
> >
> > Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000003: 0000 [#1] SMP KASAN PTI
> > KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> > CPU: 1 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 02/12/2026
> > RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
>
> static __always_inline bool folio_test_anon(const struct folio *folio)
> {
>         return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) !=3D =
0; <-- NULL folio
> }
>
>
> > RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
>
> int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                  pmd_t *pmd, unsigned long addr)
> {
>         ...
>
>         if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
>                 ...
>         } else if (is_huge_zero_pmd(orig_pmd)) {
>                 ...
>         } else {
>                 struct folio *folio =3D NULL;
>
>                 ...
>
>                 if (pmd_present(orig_pmd)) {
>                         ...
>                 } else if (pmd_is_valid_softleaf(orig_pmd)) {
>                         ...
>                 }
>
>                 if (folio_test_anon(folio)) { <-- if !pmd_present() && !p=
md_is_valid_softleaf(orig_pmd)
>
> Yikes. We should probably put an } else { VM_WARN_ON_ONCE(1); } at least =
above
> this...
>
>
>
>
> > Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c=
 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 =
74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
> > RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
> > RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
> > R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
> > R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
> > FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  zap_pmd_range mm/memory.c:1990 [inline]
>
>                         else if (zap_huge_pmd(tlb, vma, pmd, addr)) { <--=
 here
>
> >  zap_pud_range mm/memory.c:2032 [inline]
> >  zap_p4d_range mm/memory.c:2053 [inline]
> >  __zap_vma_range+0xa82/0x4bd0 mm/memory.c:2093
> >  unmap_vmas+0x379/0x530 mm/memory.c:2162
> >  exit_mmap+0x280/0xa10 mm/mmap.c:1302
> >  __mmput+0x118/0x430 kernel/fork.c:1180
> >  exit_mm+0x18e/0x250 kernel/exit.c:581
> >  do_exit+0x8b9/0x2490 kernel/exit.c:962
> >  do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
> >  __do_sys_exit_group kernel/exit.c:1127 [inline]
> >  __se_sys_exit_group kernel/exit.c:1125 [inline]
> >  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
> >  x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.=
h:232
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> So this is on process teardown.
>
> Looking at the repro (+ trying to decode what it ACTUALLY does :) it look=
s like
> it's installing a PTE_MARKER_POISONED at a PMD level via hugetlb, because=
 since
> commit 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbf=
s")
> this is supported.
>
> Normally this would be handled by __unmap_hugepage_range():
>
>         if (unlikely(is_vm_hugetlb_page(vma))) {
>                 ...
>                 __unmap_hugepage_range(tlb, vma, start, end, NULL, zap_fl=
ags);
>         } else {
>                 ...
>                 next =3D zap_p4d_range(tlb, vma, pgd, addr, next, details=
);
>         }
>
> But for some reason the zap_p4d_range() path is being used.
>
> I got a the repro reliably working locally (not sure why syzkaller didn't
> bisect) so I have bisected it to commit 7d4d4de3ac3e ("userfaultfd: intro=
duce
> mfill_get_vma() and mfill_put_vma()").
>
> And.. of course, after spending (wasting? :) a long time on this, it's al=
ready
> fixed...
>
> It seems it's fixed by https://lore.kernel.org/linux-mm/abehBY7QakYF9bK4@=
hyeyoo/
>
> Before mfill_atomic() would initialise some mfill_state helper struct lik=
e this:
>
>         struct mfill_state state =3D (struct mfill_state){
>                 .ctx =3D ctx,
>                 .dst_start =3D dst_start,
>                 .src_start =3D src_start,
>                 .flags =3D flags,
>
>                 .src_addr =3D src_start,
>                 .dst_addr =3D dst_start,
>         };
>
> BUT not initialise .len =3D len
>
> So length from then on is assumed to be 0.
>
> OK so the repro, again, generates TOTALLY incorrect labelling:
>
>   //  ioctl$UFFDIO_CONTINUE arguments: [
>   //    fd: fd_uffd (resource)
>   //    cmd: const =3D 0xc020aa08 (4 bytes)
>   //    arg: ptr[in, uffdio_continue] {
>   //      uffdio_continue {
>   //        range: uffdio_range {
>   //          start: VMA[0xc00000]
>   //          len: len =3D 0xc00000 (8 bytes)
>   //        }
>   //        mode: uffdio_continue_mode =3D 0x0 (8 bytes)
>   //        mapped: int64 =3D 0x0 (8 bytes)
>   //      }
>   //    }
>   //  ]
>   *(uint64_t*)0x200000000280 =3D 0x200000400000;
>   *(uint64_t*)0x200000000288 =3D 0xc00000;
>   *(uint64_t*)0x200000000290 =3D 0;
>   syscall(__NR_ioctl, /*fd=3D*/r[0], /*cmd=3D*/0xc020aa08,
>           /*arg=3D*/0x200000000280ul);
>
> In reality this is:
>
>   struct uffdio_poison poison =3D {
>       .range =3D {
>           .start =3D 0x200000400000,
>           .len   =3D 0xc00000,         /* 12MB */
>       },
>       .mode =3D 0,
>   };
>
> (!!!)
>
> Which in the kernel calls
>
> userfaultfd_ioctl()
> -> userfaultfd_poison()
> -> validate_range() -> validate_unaligned_range() <-- would ordinarily re=
ject 0 len!!
> -> mfill_atomic_poison()
> -> mfill_atomic() [ hits bug]
> -> mfill_get_vma()
> -> uffd_mfill_lock(..., len=3D0!)
>
> static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
>                                               unsigned long dst_start,
>                                               unsigned long len)
> {
>         struct vm_area_struct *dst_vma;
>
>         dst_vma =3D uffd_lock_vma(dst_mm, dst_start);
>         if (IS_ERR(dst_vma) || validate_dst_vma(dst_vma, dst_start + len)=
)
>                 return dst_vma;
> }
>
> Here validate_dst_vma() succeeds trivially as len is 0
>
> BUT. The rest of mfill_atomic() uses len, not state.len.
>
> So this results in ONLY the validation check using the bogus len=3D0, and=
 works
> with a 12MB size.
>
> Note that in the repro, we try to map a hugetlb VMA of (weirdly) 9.36 MB.
>
> Because we align the hugetlb and round it up from this to 10mb we get VMA=
s like:
>
>   0x1ffffffff000                          0x200000a00000                 =
   0x200001001000
>   |---------|------------------------------|-----------------------|-----=
----|
>   |1pg none |  2560 pages (10 MB) hugetlb  | 1535 pages (6MB) WRX  | 1pg =
none|
>   |---------|------------------------------|-----------------------|-----=
----|
>             0x200000000000                                         0x2000=
01000000
>
> Because of the len bug, we happily try to install poison markers into 2 M=
B of
> the 1535 page anon WRX region which is not hugetlb and then BOOM.
>
> So Harry's fix resolves this, but we should handle this case better in
> zap_huge_pmd(), I will send a patch for that.
>
> Cheers, Lorenzo
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/6b3d7ad7-49e1-407a-903d-3103704160d8%40lucifer.local.

