Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08ACFD39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB4A6B0088; Wed, 14 Jan 2026 12:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A10F6B0089; Wed, 14 Jan 2026 12:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577466B008A; Wed, 14 Jan 2026 12:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 461356B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:49:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCFB81605B3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:49:17 +0000 (UTC)
X-FDA: 84331305954.03.E830EEC
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 012314000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:49:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ayFTofdl;
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768412956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfAHwf9akDs9TjuCmKld5ogxaBWdNsL5NTrF0XlDW/E=;
	b=maPE1fWoTDAs8CY45DaJhCSthYKCD4Qc/ojCsVEuc8MNG/p2AY2De545j2otj/JPFrscr2
	kxb7Qq8Gwb1NtpqVaJqC2uL5OhNyM/8Mhdn6vkrFspl6b32ZDw+7FTGH1CTimOePmYRRBR
	tFRy/GQhsJ49II9u2+Vz5fQhKMdSzhQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ayFTofdl;
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768412956; a=rsa-sha256;
	cv=pass;
	b=NY8MDAwSXOKKydyOrjYoYlmXfZ9XTkD/47dAxJQC0KgOvHyDKyJbHoicbr7lHPZ8+6VWv+
	Dj97rGnzdGzxV43Ad98KhJKMISsCC5XUoFgGDkWqBAQd70CEmhWyuf6bzxbpFuOIewluc3
	6dYlOh9ElfaiP9e/w3JM70F7CrkHCGk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b66d427e9so50a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768412954; cv=none;
        d=google.com; s=arc-20240605;
        b=fKseNvYZeePt2CJQoPYWSkwP9EilS5qmMAOikIQ0sqn668PIUHQoM1Ko+UUtdpRc8z
         ua+lgIC0iwdyeQNXqWb8Qdww9LkQKf8P0W/iWf+tXO/xHpPt+AHrN39hgEXvp/elbqhP
         1P0219zk/qoaHMXOfxpkRGJWc2+OZFngPqyC2cf5BTheE6xDzb0rDMJxg1ni7RlxPkBM
         rSc5UT4LtsC1ti96gRSBiTrqFaK0jE92e32A3h0bSuZUlpwN9jYA4sC5Ugd+Ov2804gv
         lFMa/sP13HqmS6kNNMJf5He4SwiQ+pawPMUlSRPGvbkY5q0p0Fms17GPSRNJSAd08XiX
         sw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QfAHwf9akDs9TjuCmKld5ogxaBWdNsL5NTrF0XlDW/E=;
        fh=bOimRvwUETravWBHh+Qu9H7XOPfa/+sURMPUb3hFrEU=;
        b=NQvE7mzA4UZortpPL8+VnyqZMLddafTzdpt96YvWTFhOPhXvYgCbRVcZnlysZO7Z2Z
         Ke8XwxvulI9oDHGNmRjW4JSO4zkCOTzLzlZM/NbJL1a7aeb4GXm8Lhgeix+qjg/4X+MQ
         Xe2I6aIHv3qP/QyzSa4PgQA0knQbqmi84oR5qm6sc9oHj/0aKoTzT0Rtn5F2EuA3IsT0
         YwyUMQEjtuHTNtVfSTYZT8BMCvfkl2d1mRk6yIJeqP8whtMUMnQCcwzB7jdHCe0OYQhP
         ScrV9DS6HxiM7lbUJl7GU4wSE8GonZE/bE6P74L847cg4lt0wD20zUiH03aCT6LY096E
         RDFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768412954; x=1769017754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfAHwf9akDs9TjuCmKld5ogxaBWdNsL5NTrF0XlDW/E=;
        b=ayFTofdlFaT/93ol9T/eSoWp2oMBHI/goL0iVKWpoHEqr8K9jGhA7Xttg5pKtC85uk
         UDq29Dmcb3q4Q2z6WwpNKajpcH28MZqzW8DpyEdTPkh4lJxKIz2kENwDgrVkSjjgjaYj
         tX4iUGWSeM9J4ZviKjdLlKZepHHmRqyHK76gSFFXwuVIWd3DbkHB8pjI8Bu6THFGwl2u
         0b0fJcJ+qwtPpE4kcYrNZhK8fpxO9lpdSiyHiTbsRfqZHTsENfBsW1+zpFTqHdbrts7/
         QAiY1+qymWHLpECHjGsXDG/VMpcfRJHVvUY+lT3qesj6DIrmXQ238gfoX+2O2hmlA9dQ
         WU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768412954; x=1769017754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QfAHwf9akDs9TjuCmKld5ogxaBWdNsL5NTrF0XlDW/E=;
        b=GhJKZ9blI38NS+uzaroxwiei/giHONkDw6G1xcn8C+ZeEK9RtmtncG5u4XQdDh/91d
         0NwiLOMOrz3SlmMJpmwXSiVygNfnTwIkfV6cIApBLKMHLMVva0Q7FRu3puu4fFvqx5fJ
         n1uL/yfDf27QbyzGHOtqt11L7b/u4MNbLpqynl5o8phXYAnURlncpLWDyOFG2fEqFCTN
         IouA+kiRH7sjfFkue7BWIFZNm/A9mxApXYGnwdbHnNdVW2RwEjBxbSYaNcaL7fajE/hH
         08n/5vM+wpqHQXIdo1zTyK89TTcOmGabeWAt830LqA+ouascoFXba5HjCaAQu33HdQGm
         XzQg==
X-Forwarded-Encrypted: i=1; AJvYcCXpJhsilsf+TpWHEtsNU6sodkKUehGy2B2efvBC2jUuCFFYFIRWllp0ziOW3krlVWIPdKdrSBfy2w==@kvack.org
X-Gm-Message-State: AOJu0YyfOX3HsdtH5mjXBEZNlPFO8XUSss2IawIf4y8NAjw05o5naYiR
	/Mbq6UYvmtOhNuV4PRAaQfpbCj5QtC6U8azeGAy2Pns1E3mhRA6ie/W0h6EpfCP3wFFbrJFni5G
	6PtP/Oz8f2bNrJegvrAgIRXRnw8nbGA9QoPirx0Rf
X-Gm-Gg: AY/fxX5K1EKLCuCyC9iY9OVyUDSqkWcN+wU1CQANdRiERxB2Ym5G0wc63o1OxB49Ltr
	VMu3mvAIRdr+f+sZcRgxxYLdGA7zwhF4eqdz4IJgu3SksD+4YfKJkBALs2A4jafPncmlRpkTYqx
	6wrFU2LYnxiwdas2I18xZQp0X9+S5J5LW6wIWKTmmNXXaL2BdGWdrvcpQce34q2Ecb7ZVnD2NZu
	IfOq2mBXrZgQ9zr4xERGybpnlq3a9YOKez6scgSzlLce4DIXVMq8o4i5BZrv/rpCZWw3/jCbsDm
	D28Iy/od6fbuwmEue8pJoN4etQ==
X-Received: by 2002:a05:6402:a252:20b0:640:914c:ab91 with SMTP id
 4fb4d7f45d1cf-653edfa4867mr40223a12.3.1768412954114; Wed, 14 Jan 2026
 09:49:14 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
 <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com> <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
In-Reply-To: <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jan 2026 18:48:37 +0100
X-Gm-Features: AZwV_QgQrCMj7rVFwcEIYN2XaYrMiNOVYOr_gFPb_eDYR7jjssOW1CyNII9XLhY
Message-ID: <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fdoj6srkgeb6iqttnjfwyz9jcs8euaqx
X-Rspam-User: 
X-Rspamd-Queue-Id: 012314000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768412955-426296
X-HE-Meta: U2FsdGVkX1+1Iur3GTz6wu93qBkg51AH94MkJai8oQspow/u4DXzjnHhxyZmXOgxADlPhZea1dcxAtGig4XhhSE5LHv5CqhDMEMYqAg3VRYXard2qC0pc8zRXbaWlhS2gt4mBDX2Jx58hJ7tED75xCxLzgVrJ3/j71Hd52uu7ccaZd1ul6e7X+5u48Nlt13D5rBHKV7sIZ9lceP96YikXD/FwGTcjIyKCxZ0UCTZqDArFaVNHDY/mAmU13KT77KLbBtIbd2Y+4gaJJSqjq7kzddV49vJcGo5HRHjhIMPKEp/gzZdU8KioU2YKk+9Y6YYucbbSF5yR0fEAtfWJRLa99m39MDV7qFCJ0JIdtMcB9AoG4a8f8N5pKqFmPpzfV5C6u4TUVNa7nTXt2C6NqdtY/f2gQqOAYhz9AxcpFfHJBKPxegU4KMkvWhjuv9Ys6t6FHyP8OI9kZ/d9OPTxUGPHhYZgJe4mJeZy8vO9cJ+KyBMJ40/riFPsJQxRzOjDrJ3QFG7pwL65AGpm3nq0eP/D7uiydil5aP3Xa9KxvWJFHSWQgsxrryhJ+8A5f4sc7jBP7YBDIG1Xm1WlrxlrkEqd4srhkrd514bvJNjBAIxY5hBjuHfpTZZ/H3tg+ApddvUJwq8Sy2pYmNAPg5kREzcRv+1Sdr7QlZFJ/g17rz7lHv6sts12rh927lPSBUbuesVaqMYKtkEEEIPnxY4uV7VYD1XJSGkOFecO83nywMsIEaA8DRJm5PRDZnA+nJkR4IyuDrI5hrh1yqFAX1Rs0Z0PrZFghzO3imXc1NZwN+kyN08K85ciqjb+U5HbKjkSf1d0cM8FGMp5vo1H18nPyuUpW0GOkNeOIzJKtoMmTOh5shqFo/y/KxZ6gDRDtXWHXWWnXWvniKhk/7cBXFHc8PtfwrbZ1KGP22l/gU1possGamzKz/gfnlouALbf/2OYPOGReep9uRJCP09iGc5y2g
 A1F0X8Zo
 QUiqLMjW7P/OZPO7QXCDap/RWtCjtbG34OcwE6fGhKH7cMXuGeGAxf8QNChTtW/Oa+htORxrrSza5nTMHf01zITNbsxz3381NPutFz3fWkyT02muvgxrfDb2L/FNmmyj3J7MN+smrZ3tIWHpBY2i6blp+g7nt5f55pkMhwyU20LUb/L3y2GhRyqCDgBkdwLo8No1NpVA+5X3BNdzdEOc7Xd++x2SDbwlNViA3WTyZxcxFDTTz96z3W1+SKuHo8VVH3KE1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 6:29=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Wed, Jan 14, 2026 at 6:06=E2=80=AFPM Dmitry Vyukov <dvyukov@google.com=
> wrote:
> > On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
> > > On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyukov@google=
.com> wrote:
> > > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> > > > >
> > > > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> > > > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > > > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > [...]
> > > > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > > > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > [...]
> > > > >
> > > > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > > > >
> > > > > Reported by Kernel Concurrency Sanitizer on:
> > > > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W    =
       syzkaller #0 PREEMPT(voluntary)
> > > > > Tainted: [W]=3DWARN
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS Google 10/25/2025
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > Hi Harry,
> > > >
> > > > I see you've been debugging:
> > > > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > > > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@googl=
e.com/T/
> > > >
> > > > Can that bug be caused by this data race?
> > > > Below is an explanation by Gemini LLM as to why this race is harmfu=
l.
> > > > Obviously take it with a grain of salt, but with my limited mm
> > > > knowledge it does not look immediately wrong (re rmap invariant).
> > > >
> > > > However, now digging into details I see that this Lorenzo's patch
> > > > also marked as fixing "KASAN: slab-use-after-free Read in
> > > > folio_remove_rmap_ptes":
> > > >
> > > > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > > > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5=
b.1767638272.git.lorenzo.stoakes@oracle.com/T/
> > > >
> > > > So perhaps the race is still benign (or points to another issue?)
> > > >
> > > > Here is what LLM said about the race:
> > > > -----
> > > >
> > > > The bug report is actionable and points to a harmful data race in t=
he Linux
> > > > kernel's memory management subsystem, specifically in the handling =
of
> > > > anonymous `hugetlb` mappings.
> > >
> > > This data race is not specific to hugetlb at all, and it isn't caused
> > > by any recent changes. It's a longstanding thing in core MM, but it's
> > > pretty benign as far as I know.
> > >
> > > Fundamentally, the field vma->anon_vma can be read while only holding
> > > the mmap lock in read mode; and it can concurrently be changed from
> > > NULL to non-NULL.
> > >
> > > One scenario to cause such a data race is to create a new anonymous
> > > VMA, then trigger two concurrent page faults inside this VMA. Assume =
a
> > > configuration with VMA locking disabled for simplicity, so that both
> > > faults happen under the mmap lock in read mode. This will lead to two
> > > concurrent calls to __vmf_anon_prepare()
> > > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
> > > both threads only holding the mmap_lock in read mode.
> > > __vmf_anon_prepare() is essentially this (from
> > > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
> > > with VMA locking code removed):
> > >
> > > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > > {
> > >         struct vm_area_struct *vma =3D vmf->vma;
> > >         vm_fault_t ret =3D 0;
> > >
> > >         if (likely(vma->anon_vma))
> > >                 return 0;
> > >         [...]
> > >         if (__anon_vma_prepare(vma))
> > >                 ret =3D VM_FAULT_OOM;
> > >         [...]
> > >         return ret;
> > > }
> > >
> > > int __anon_vma_prepare(struct vm_area_struct *vma)
> > > {
> > >         struct mm_struct *mm =3D vma->vm_mm;
> > >         struct anon_vma *anon_vma, *allocated;
> > >         struct anon_vma_chain *avc;
> > >
> > >         [...]
> > >
> > >         [... allocate stuff ...]
> > >
> > >         anon_vma_lock_write(anon_vma);
> > >         /* page_table_lock to protect against threads */
> > >         spin_lock(&mm->page_table_lock);
> > >         if (likely(!vma->anon_vma)) {
> > >                 vma->anon_vma =3D anon_vma;
> > >                 [...]
> > >         }
> > >         spin_unlock(&mm->page_table_lock);
> > >         anon_vma_unlock_write(anon_vma);
> > >
> > >         [... cleanup ...]
> > >
> > >         return 0;
> > >
> > >         [... error handling ...]
> > > }
> > >
> > > So if one thread reaches the "vma->anon_vma =3D anon_vma" assignment
> > > while the other thread is running the "if (likely(vma->anon_vma))"
> > > check, you get a (AFAIK benign) data race.
> >
> > Thanks for checking, Jann.
> >
> > To double check"
> >
> > "vma->anon_vma =3D anon_vma" is done w/o store-release, so the lockless
> > readers can't read anon_vma contents, is it correct? So none of them
> > really reading anon_vma, right?
>
> I think you are right that this should be using store-release;
> searching around, I also mentioned this in
> <https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMvtGiB7wQs=
P-G1jVg@mail.gmail.com/>:
>
> | > +Note that there are some exceptions to this - the `anon_vma`
> field is permitted
> | > +to be written to under mmap read lock and is instead serialised
> by the `struct
> | > +mm_struct` field `page_table_lock`. In addition the `vm_mm` and all
> |
> | Hm, we really ought to add some smp_store_release() and READ_ONCE(),
> | or something along those lines, around our ->anon_vma accesses...
> | especially the "vma->anon_vma =3D anon_vma" assignment in
> | __anon_vma_prepare() looks to me like, on architectures like arm64
> | with write-write reordering, we could theoretically end up making a
> | new anon_vma pointer visible to a concurrent page fault before the
> | anon_vma has been initialized? Though I have no idea if that is
> | practically possible, stuff would have to be reordered quite a bit for
> | that to happen...
>
> I just noticed that I tried fixing this back in 2023, I don't
> remember why that didn't end up landing; the memory ordering was kind
> of messy to think about:
> <https://lore.kernel.org/all/20230726214103.3261108-4-jannh@google.com/>
>
> > Also, anon_vma_chain_link and num_active_vmas++ indeed happen after
> > assignment to anon_vma:
> >
> >     /* page_table_lock to protect against threads */
> >     spin_lock(&mm->page_table_lock);
> >     if (likely(!vma->anon_vma)) {
> >         vma->anon_vma =3D anon_vma;
> >         anon_vma_chain_link(vma, avc, anon_vma);
> >         anon_vma->num_active_vmas++;
> >         allocated =3D NULL;
> >         avc =3D NULL;
> >     }
> >     spin_unlock(&mm->page_table_lock);
> >
> > So the lockless readers that observe anon_vma!=3DNULL won't rely on
> > these invariants, right?
>
> Yeah, that stuff should be sufficiently protected because of the anon_vma=
 lock.

Er, except it actually isn't entirely, as I noticed in that old patch I lin=
ked:

@@ -1072,7 +1071,15 @@ static int anon_vma_compatible(struct
vm_area_struct *a, struct vm_area_struct *
 static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
struct vm_area_struct *a, struct vm_area_struct *b)
 {
        if (anon_vma_compatible(a, b)) {
-               struct anon_vma *anon_vma =3D READ_ONCE(old->anon_vma);
+               /*
+                * Pairs with smp_store_release() in __anon_vma_prepare().
+                *
+                * We could get away with a READ_ONCE() here, but
+                * smp_load_acquire() ensures that the following
+                * list_is_singular() check on old->anon_vma_chain doesn't =
race
+                * with __anon_vma_prepare().
+                */
+               struct anon_vma *anon_vma =3D smp_load_acquire(&old->anon_v=
ma);

                if (anon_vma && list_is_singular(&old->anon_vma_chain))
                        return anon_vma;

That list_is_singular(&old->anon_vma_chain) does plain loads on the
list_head, which can concurrently be modified by anon_vma_chain_link()
(which is called from __anon_vma_prepare()). I think that... probably
shouldn't cause any functional problems, but it is ugly.

