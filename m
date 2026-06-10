Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B151CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BC56B0005; Wed, 10 Jun 2026 18:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC456B0088; Wed, 10 Jun 2026 18:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB296B008C; Wed, 10 Jun 2026 18:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0B06B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:59:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F357F8D284
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:59:23 +0000 (UTC)
X-FDA: 84865521048.13.2246250
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id E39A01A0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:59:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A0sn/NW7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEzIwJCTEGfUPAMEdjx97uQ6KkcVMIzM//6ziaFjsoE=;
	b=SxAcBBFI2/SVGN6oYnhDjMIasYlnD4hmbYuKdQBPMUIKT7pX98MD1+i4xlMh+LZOPU9zHX
	7yRur/Djpnu3GxyR2i6snzXj3demAkPHW2v6vRgeK5YLRarTE6FR0zw86Jo2lYD8tUQsOC
	vKFLemNKA705k0Nfj53qyWSkxY1u21A=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A0sn/NW7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781132362;
	b=vC879Dwnkjh3agwkemQ2DwC3tykVOwjQX2TOaDNb25a15VLb2K+AjrSbTTnbTbN8dMIt2R
	RU+mldGdx9qdDc278ti0dsReLset21Wn8U4hi4QB9+X8ag3UbEaLPrqhRBT25nNX0nWpsl
	2ZBnn9nyjOz3ygb42UAb/oMkvb2adwI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bebbc325000so965497166b.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:59:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781132360; cv=none;
        d=google.com; s=arc-20240605;
        b=hMMzqVXez5iXFoRfajYHQpeaYrhFRPa8xaG/QjJu2si+eFglXE7yxJuLlGbUrI6qXh
         9y4SITr43YAawD8ecBuxVcTQKgj9bqMpNCfjJNz5bafMKJpBNk9TX2KyhtCHf34RMr5p
         4ralkMtz+ArC6SAWRoKbPGUNVgqZR5cXbEiI38+UlitzTFipR9fOgYoxISVVwV7bAqNQ
         oXy4sUpAfMCTHQqIS8t8M6ahXIE/42xNFuXD8+ZvsILlzgNxlM++AU2DyvaimqE/Mhje
         VYOnZbnYDJDRarogRjfHn4l75lW6foyCC2BPrCGv7h7n1c1HBXSW0Krvzo2pC9GTlvoD
         lyfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oEzIwJCTEGfUPAMEdjx97uQ6KkcVMIzM//6ziaFjsoE=;
        fh=7P8QoFK5c9OmX1RmP2QjSEiptJ6UECnDcBNIng2Vw1U=;
        b=MhcZtNxFo5UrcgXwmAhlrS+bfi225evBK0tddOegbzsecY1rzUt4MceICdlMYhEoia
         geWRvskxjOLqoYJltmVrwhhqy89JF7A373cYMXPhauTLMZoGG+SFnWfNIWxi8B8tYp+o
         Rh8cn2B9wY9ztm3+/c0EkqR+0qtTPfCchOI6IgVzr7qWrdSK9SZLAzI2YiMugMpBNalT
         j4pnivCQmxyaYJYK8GQi5oJdpldZHpJDdgyNausNIHQNA3x3CB/vr9AAt1lw3yUIy+1R
         5i6ZOoq6E2Rt8UFD0GbKSSPJKRDIZBnugsOLkrYTD/tCEHwwwgOXlIq9fMst9jDrxA17
         bUrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781132360; x=1781737160; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEzIwJCTEGfUPAMEdjx97uQ6KkcVMIzM//6ziaFjsoE=;
        b=A0sn/NW7L8/xaTYD9Jm8A8huc4GtwADlpan/8/KFaxYaRmC+1KhLg4JlY4Y/FjY8y3
         mBLFB/KyOS7dyCRBkA5EwY1uGjEacN5TjJA6Ktp9nAiCtYaVzfIePB/qHu6xV7WwwTlb
         JxyWwDHp/V6cJkG+ooXQmaRp2IBGGzS7lq2l/gGsfZhWBgTdx14J2UFKZk3GnFQ7k6KG
         30Gf3XmZrOYHPNn5OGqfPTu8YkVCG0WFcYO5OWJDodxDFhcrhS0rkdd97/zIWekcl6Ai
         vSqT59rwrjs2GN+1weAu6iNWo79/32mSo6S3yyK2uo+pW+qPszeyBaqXbHvjUz4w+9dq
         cPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781132360; x=1781737160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oEzIwJCTEGfUPAMEdjx97uQ6KkcVMIzM//6ziaFjsoE=;
        b=qMHQCbXXnQfm4aoKZUSlM5RH+As4WBRV23Ht9vkfbL2chdBtMYg0PtxqBoMsjKqvPy
         qd8CvQwQBvVNMg7UAPkaL5ZTsYf7E7C5nv/OfpkpFXEMb2XVph4fnyhwv67Zg6FnEK+U
         dHGelmIeBPszW+V8s9WhqE/7XrOB1yOYWwNF6QBE0lp8dt0UlfgAy6IXQcWsR37RnTKT
         gMlcA2XImnALXHC3R2xD4pmESV8iqd/7/hWGPibQXFHZM3MEj7JEChBksr6bZg5qLwp2
         Or0v1dnV1ljJ0YkkokvJmjZe33VvoK7GJLYdJTbjBmYA+88SNNZWVHdjB6yxk9aTpnih
         LGBw==
X-Forwarded-Encrypted: i=1; AFNElJ96PfXwfDi+SsNZlovAKQrsfYAz/Q9iSgT1upBqpDixLROv4p9VPgEUlaXHtTl0nj9y3p6opJpc8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx9JsYW3vpTtg/+Hh3LUMxcSpqyaDHxaSywqLgJVYo/c2qlLQar
	tRnzhlKykJNycyjx7BduNXDHBXFGb/7OCFP2EMCWd5HSx8a/d/nckBh/k26RPjBFsd1do+LfnWS
	SUfxqgmXJewlPunrEkTkuUB0RtQn15j0=
X-Gm-Gg: Acq92OHFGJg/MOzZsSS3q5JMuVtmy6Ihykn5P/6XWx0ozi2dYY9mONimHMupPAepHDi
	dc/I+pQim4asumd2iREK/tTFlhMiAsf6/MkfxJzv6JJKQu+kC5dZNP6V50GBLSFBls0zaOSXfWP
	tYUVuyRYYJDw9nZuybYDBDRGby/RF6XkFyHK92k96q9+TlOoi1OKt4PBqPSXG62rkKjO+v7Wx6e
	jUmCeMOUxVpJLlFf+Sa79MxJDtQ+v5xQhyzrA+A7G3zywwa/Mm98QxlsXJZpM46u/HA/7Mm2w23
	PADQjcDNLsPr728FQIWORSzPtnPxqJ8q1+kD0tAOzLivswd4IA==
X-Received: by 2002:a17:906:6a1c:b0:bf1:ac1d:94b0 with SMTP id
 a640c23a62f3a-bf373eec601mr1347239866b.35.1781132359944; Wed, 10 Jun 2026
 15:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260528095235.2491226-1-me@linux.beauty> <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
 <CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com>
In-Reply-To: <CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 11 Jun 2026 00:59:08 +0200
X-Gm-Features: AVVi8CdthNiQaFys6OtVKdO_jwR53Q5mhKecw8_q9iDf4OCUN-Dc5Jgmeo3bc0c
Message-ID: <CAGudoHHq-AKfWwRXuVbmz0B3PPK=Z7gW=HeUYOe_8k4fvPJFHA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Li Chen <me@linux.beauty>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E39A01A0005
X-Rspam-User: 
X-Stat-Signature: fypoaajn364i3f3o4tjomupfaq5ct9kk
X-Rspamd-Server: rspam09
X-HE-Tag: 1781132361-809464
X-HE-Meta: U2FsdGVkX1+3i/roGhfp/AqOFeOIy2FEDhVDuys2Rz02yq0p6YkpDjGjFqeucOoFXQNuhvlpdDYtVDIsmfit+dZ1Nw1RedRUMhUf7JCCXbAinXbpEWGdJ5KHs+etIIaC72HmWLZq4VRHQwY43IK59sMwEkhOBk91jqRrzBHlrGOfuqGU8tVnYo8Da3kBANpAqQThaujCXegbmkirNrknoBF0vOIil5NyVrPkBbgF9Ec1oVQHxySp/YGjx0LnxwymjeRqL+1EIqeUgIoKL/rMAr3Wt6qCENtrQ/Zb2O9dE7/LrVPbxx46lhQxJ/JzErShpZXu8xLk5w8GO+JHzzUdNqbqj4hx1P9OWvJ3cndQkEzjuP7lh5oB0sDYBTctOBydPejMZ4aOdaZETd6VRGToKUmskb5WUKoUAPM2JzPkQxVkMTqiq/Mz1h30zZHbFBWVHXgmn/3EA4btz4i1IREkVmIMUqy4QHQl9BO5sr+239LED4DEe7LJkHErSskumpzIDEnR7CEkfycJ+DqH+Bx3WzjydkeKrLWYcDtqtw52/INFDFDrxMvm1FY51n47/+2MPezDnLDaIdZKaEhyW084PUdNlfQhy7+YbrvRtjgk05ij1a2Kk4RfS/j5a9414QUZzAeP3Vpx+u8Tr+W7Ajhij3tsMUyrA6qQJkxuuTsQRWTXv3iyivz+tDrAyzPr46HNEJtrl3haJyFYMA5y24F6D7fvZtWYEkk9o/6S/2XtsqzGr5WRWHc7kQhykqQuT0HZ/YPJa6SFDQimFZ5hDugnlssV/R6Kw6rb1qJ5Su5HtgUVZVjqQNhYMcqfSw1B6kQASKYiCxklKABFnyZbGjz/Bc+YgbcME/Csbhg3zLBDYGYSJK9NLR9Gx747SqLeuUI6qrvFzAJzJmqipSWmJaWnjyXTI0R1Q8XoIw6E2kq9/JPdYdtrkF3kpzOqKlWdef2v1tnGhEchBsGBS3polHo
 sGDR4mTI
 DUIpPXmUOB1htlsR0GCW/0eFw/725nK/fmtDk/ak7P3TAQ9zho4559WM2HXy8PfovW5C6XWHlUK/lZWHaeILos9JtsIZHX/yuUMshUm6/dYArotWTIbwfy4HLnEg9Oo0DufpkzzH+a2vXzHMVo8Gl4OXyT5gqwSxM9kqBOscSAobS30Ab8K8xRYpl3kRRHh23rM3UjApxruvTDQd/H/iYPuMnEOiqaIEDuwpT0oS7s7VowsPaU/ku11M0xcih86kXga4VbIS8Oj8XNQXG2ooUx5lCpoOYc31R64GQLjO8zLTQVABQcPSu/IgmE0iDXsMZfXJzYyZTtatPsjoJDVRi5Mo11i+J9+JbzlCpiLZ+paWDWg+4y+Bnm4tN+2BG+9jf+M34VyebkaENLVCD8WkyR82eLQdvh/Ih2lzt8WN5H3lz/ov2TD0ZJ+S9Y9Vy1D23d+Ba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 5:02=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Thu, May 28, 2026 at 2:55=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com>=
 wrote:
> > This problem is dear to my heart and I have been pondering it on and of=
f
> > for some time now. The entire fork + exec idiom is terrible and needs t=
o
> > be retired.
>
> It seems to me like vfork+exec is a decent UAPI building block, on
> which you can build nice-looking userspace APIs, though I agree that
> this is not an ideal direct interface for application code.
>
> > Additionally there is a known problem where transiently copied file
> > descriptors on fork + exec cause a headache in multithreaded programs
> > doing something like this in parallel. I only did cursory reading, it
> > seems your patchset keeps the same problem in place.
>
> I think we almost have UAPI that would let you avoid this issue?
> You can use clone() with CLONE_FILES, then unshare the FD table with
> close_range(3, UINT_MAX, CLOSE_RANGE_UNSHARE). That is not currently
> implemented to be atomic with stuff that happens on other threads, but
> if we changed that, and it doesn't provide a good way to carry some
> FDs across, but it feels to me like this could be fixed with a variant
> of close_range() that removes O_CLOEXEC FDs except ones listed in an
> array.

Suppose you want to exec a binary with the following fd set:
0 is /dev/null
1 is fd 1023 in your process
2 is fd 1023 in your process

You have tons of other fds and you don't want any of them anywhere near thi=
s.

Clean interface from my standpoint would avoid any unnecessary
overhead and would allow you to clearly specify what do you want.

In this case whatever the interface it should provide the ability to
map 1023 to 1 and 2 in the child. With the current syscall set you get
refs taken on these on clone, then you have to manually dup2 these
which is separate syscalls with extra atomics on top. A fast & elegant
solution would allow you to tell the kernel directly where to install
the 2 files.

Also note in practical terms userspace likes to closefrom/close_range
anyway to get rid of unwanted fds which happen to not have the cloexec
bit which is yet another syscall to invoke on the way to exec. A
better interface would instantly avoid the problem by not copying the
unwanted fds if not asked. For viability for use as foundation to
build posix_spawn over it such copying would have to be supported of
course.

>
> > There are numerous impactful ways to speed up execs both in terms of
> > single-threaded cost and their multicore scalability, most of which
> > would be immediately usable by all programs without an opt-in. imo thes=
e
> > needs to be exhausted before something like a "template" can be
> > considered.
>
> (I think probably a large part of this would be stuff that happens in
> userspace, like dynamic linking.)

I have not investigated userspace, even putting specific APIs aside
the kernel has *a lot* of avoidable overhead.

>
> > Per the above, the primary win would stem from *NOT* messing with mm.
>
> As you write below, I think we have that with CLONE_MM? The C function
> vfork() is kind of a terrible API because of its returns-twice
> behavior, but I think if process cloning with CLONE_VM|CLONE_VFORK was
> wrapped by libc in a way similar to clone() (with the child executing
> a separate handler function), or if it was used in the implementation
> of some higher-level process-spawning API, it would be a perfectly
> fine API?
>
> Or am I misunderstanding what you mean by "messing with mm"?
>

I was not aware of this functionality, let's assume it indeed works.
You still have the file issue described above.

