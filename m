Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CB5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855766B0119; Mon,  6 Jul 2026 05:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C8C6B0121; Mon,  6 Jul 2026 05:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742CA6B0122; Mon,  6 Jul 2026 05:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49C0E6B0119
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:18:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4E51C016D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:18:13 +0000 (UTC)
X-FDA: 84957800466.09.68FACD8
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D10C100006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:18:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b="TI/nd7JJ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of daniel@0x0f.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJaCVKcILOe0pMGItn9m+vGlgZ0ms+MuC1wAo8ovSu4=;
	b=bttNbs3IykRxceUZKyB8J3vzBNtDwwpGcAMT9uhXXkNJpHaHojBaU4NNLlvfipVrk5xYM9
	DIttrte1S83uz77ztf+N6v/sAEXQBCcg8sLBlZmMGCFJQtOfBKSlFxdi3aLyaQHt0xeZOP
	nxM7Uii1loT6P9A31eQ8UKdajzLBHHc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b="TI/nd7JJ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of daniel@0x0f.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783329491;
	b=bO/gcgw9dUmmFqrh3B8S+zyH+C2hkXXaD3Awl6cIK3gdA3PGyKzS2UHtpz3HZplqtITZUe
	fXfPzD26GH4Xin5DFxuQf8sR0eFm8zBElCO76BStBSMxvCdyPDb1uAWJEY/lHcnGE2YHgT
	hq3A6GNIYDXdoWsyelAd7deT6QpAAuA=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9e2489e117so1446083a12.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783329490; cv=none;
        d=google.com; s=arc-20260327;
        b=g5J81N32+PKGDx4O+5ywJgdb+X+1A5b3GPGsGCi9lKWRZGpAdyCOvy/G0fLUiFKLOl
         g/7hSY/4YbvSlucD2jSxzSncggo/105SFhhKS/88HwUVmfj97nbo3d99VKvvwxWnJoaY
         nF4XINvuXUwUAOGTfz/z8tJn43e7wqDjE7C3YhYCAUsw/BcthhSqUu2hex4GxbaDk0MM
         NHnZX0MNcDWI5JSYpuAWANaPXh4dO/7mJJwXJ/wdGypEtbyxOu+Nf+LHgUu9TvhbGw/6
         GBMiOonrgYth3jvH0TkJOrP9aqs8GtD4To8LP1+PU8Bs97jE1rN+35TK/Di+ouhiGAra
         iQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DJaCVKcILOe0pMGItn9m+vGlgZ0ms+MuC1wAo8ovSu4=;
        fh=qYU9RXa+ZiingxSbvCKzmMEyEjAhI3Pz+2hyUq93vwU=;
        b=YpX0L2BEMiRgyhj9D57xel7Q0ovIWFbI0NbCvt0IHAHeyXMWtTTujRqcMgkHJS2XPK
         JO9EaeQLmauyvRlud9AzByEeUa39+0R520/L9+4X76RyfzQSuwb3drza7wmFB7hXLUdp
         WOFPi0+BZxKo0IVSqA0KiokBdwCYjzpZiTMMEspnd8mtkwrxvsz9GHAgdBkRLnro7vKe
         rvAqjIlbxQSaEQySonQMne4kcItDJDlxYT88yKIYSycLlD9kPek7NNbqPC7L8wQt4xoz
         fG0BQudcVoGrb7m3oYFlhkkctfd4ZDi+Fe7GbS6Buz+r237Wg/eZ92gn9bm22de9884r
         N/WA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1783329490; x=1783934290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJaCVKcILOe0pMGItn9m+vGlgZ0ms+MuC1wAo8ovSu4=;
        b=TI/nd7JJqgQ86xqhvbJlYM1ny3oGHFSoSgZR0X24pmZMD83MOY9Pq5A6koIeqhEmQB
         mdUTDfjCQuK1eKcPvPnTlCSL+Sk6rIzO+pkWBpAo7SN470LSxObkSol+SjDmV5tG0DEz
         DPpUY9QpMuaxEeGfxwGjWi5FTqmsy7QiER5qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783329490; x=1783934290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DJaCVKcILOe0pMGItn9m+vGlgZ0ms+MuC1wAo8ovSu4=;
        b=muyYRSnZEwDTs30BT5dgmDYVEaWKHqGbiArTq79CyukLHDBY7bgdlJS0myK6hpEg88
         G9Cl6SW9gUnMQlyzAdfHQpW+BZj68IETY2GYqdDe3MC18gOQFDE7nck18pQHr4zUFPle
         lAhEbidnhhYFG4dv/RuS9dnE+TQEJ9Yi63ql+mBOaIl1ss+33iw3eKqK7JtWucwuY3R9
         eaOSw2Xvqad9t3JEbPfanbrQr0rhTy2/7loidOsmyPtQh34iXrb9VgyNdeAg+zPi/VS0
         UcyRV4oJIEKtoFuM5NEhnqgfPTvUrEo2ZQ2nqK4Dg2AhAiBec1O0oZ+W4ugClSyUbANe
         R2Jg==
X-Forwarded-Encrypted: i=1; AHgh+RrwBKQLHHqoZa2Kwr0iBDzW4XZNGDS5tWbMidxPfZKCWmnG0yMV+1Ho/96xH/XwrE1bjC1CK4/FeA==@kvack.org
X-Gm-Message-State: AOJu0YzKdQta+OcbJtv/Yqc2f76AMxnjHwCqE93sLByyKJYY+JezuKzH
	KS9NzkV572YwFuy2JQaUU1Cd4YF2nwFyJ4ewcYZt8FOf6lnwF+s1wYOGHkenyqeaWMgmfAAesSL
	xhgvptOzV+op2aN4Wo3dxyorPae0978KX7/RBC0HKnQ==
X-Gm-Gg: AfdE7cnBT8XRqDcRPtK8REcfQ5jvbW0efPTAmLielluK2GHfKMsYhy0NYjO9m0U9TOR
	4n55l4I7TjLYkMsI1BKaJSDj1IbldFUF/X02ndDrHYWFYtGU9kXjDm1hXEvobYDzAN6dwAF58W6
	hQlg1QUPp7w9X9XO9SGXN6zGgB1nSo0bSftU4YRLY+ZVPt/RU2bEot0Z78ZhoMeYhivkM0OtTFp
	gCdHymGt1Qmn6ZGvg1+Q+avtS1y/sjCXfv0JJ3udqrpWJ9MKt6yUpZCy/WirnBWJS/31Q+oVJWN
	sPZRKdDN1Eyr3UjtmeMVp6FMyzEZBYg=
X-Received: by 2002:a05:6a20:d70f:b0:3bf:7eb5:9459 with SMTP id
 adf61e73a8af0-3c03e1f82c6mr10101920637.20.1783329490121; Mon, 06 Jul 2026
 02:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260702012546.665383-1-thehajime@gmail.com> <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
 <aksn5J8Nr0JIsVpQ@casper.infradead.org>
In-Reply-To: <aksn5J8Nr0JIsVpQ@casper.infradead.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Mon, 6 Jul 2026 18:17:59 +0900
X-Gm-Features: AVVi8CfUh6ouCKz9hCfs57K7cnl0ajbJ1mOn9xdyopsccHICCksdZ-krRpRQ9Ys
Message-ID: <CAFr9PXm5nwPMkDfG-L4Ai_9DMfUn3hhmwp0HQ70UvZx56M4C6w@mail.gmail.com>
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hajime Tazaki <thehajime@gmail.com>, liam@infradead.org, 
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: trqhm868dngorxwyt1361a79pwoxy9kr
X-Rspamd-Queue-Id: 6D10C100006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783329491-255028
X-HE-Meta: U2FsdGVkX18XvKhS0YE5DQ/8yyBJCEVrA1dw25HyIoMNLw8S2IUU6JufuDOrY5JCwEzjfR6JBV8OE/0MsXHgU/nJDDSiWHS1BrU6vNyl8JKAKMVSeiMyqdLEEOS9++JKRLGI+ZOJCMWJbQ0aXoQ3Ap+0P5ZHn8BHuGNs3TpJg3twuY8myJtyqnzg/linABwrCzOiMhLbQLGcjJ02JyllB2YqZI42wGm5hdjvVIJNCQKFu4Ad9/V5FjPzYixBfBSZejYtMOBayS7qv/Vco0YCI+tuvM+f5lyU/N88kQaxJzm8sD4K73aLjshm/qM4MDJlSFzfwmtMHtKrX/CwakmCSVuzfv0AoFKjH3KBlP+WdHIOX6D9cWYwt+3fTELXeDHjg0/YioUk2jAYYMMrrix21Jgl+t2LwKCt2j+zLjlSJ9xTGp0ASTmRVs8hJJ39yIoAaQS1bR6XUj62eBTmlXAUfIeWLWqrO/xHCKe2uy7z9TKIVJeQ9Vw3Sg7QRqAJ86KRoCSy+3SJrjA3xeiVnP8eLGisv8lphM7XmSjyyaK2dAZIA8frqc4Kg5cGwmWJ6mXUitdYhSrQnr7ZzZ4NITDx0YouCStQgaqtrOnjOgQLsmKPfCulNOCSbRDCgB177OEr2RQNbvGn8QA23GoHzvEKVmR+Ts0c5ZKmFny9EoJgtm3eeNnI0JSHRMK/XgwG/n5TAGX7ab1ZuYhhZuqN0KUnMYjnNI8CAFNDoHX+DNLgQ7/FHCLqe0vAbx47hgBfFTJ94hW1E2LVBTndMEfLQ3NyQk5tw8IhptRsDh2xDnDc3aOSV9qu6f/yzyiy4FQTn7liOJXzFhIYIm6izM6ozq6jRIQig5LDDACiK7fRdmrVsDbgFPIoVqNy982VD8d+B67YvX2Obzu+2ijTkfMTVRx1E+v3HDJfPNEiRuWTRry070U2L9n4VpGY/GlDYydnea3Km1DdEdno24dd9Ebd03l
 hD85nMFf
 17pDq/6+kFJtJYZ/HlVyiu1xd7WNBMBQDZIWC5DcsXb8MkoVoZKIuY3v0O9qlVwaLeHJhApMIOopM9FfvAOF0jPT7QjR+4L/loRqpm6DlnkDcg171eW0Zl5exqc+CbPe0jkYcmB6xMS+vMmfhTJVy1rYHB0o+zaj9DXuGF0ePfZiEx8xtHPN+/7ULf/LUP8d2g3VL/AKJhZRg1MjU0IXbdqdBlOyvc0oBmGJvwA0VRxbzPfAJrGjc4/ezziM5XbM/znt3zdeDoRT4oGag2lnc2c2dPB2rV9IVXTr+B1FomHJm9wddh4AbsXfuAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

On Mon, 6 Jul 2026 at 12:58, Matthew Wilcox <willy@infradead.org> wrote:
> Should we delete support for NOMMU?  As you say, it doesn't get much
> testing, or presumably usage.  I have this quote from #m68k a couple of
> years ago...
>
> : I looked at nommu very briefly when I had my 68000 board on the bench
> : but didn=E2=80=99t get anywhere. Also didn=E2=80=99t try particularly h=
ard. I think
> : you are better off with fuzix or OS9 if you want something unixy.

There are a few of us using the 68000* port for hobby projects. After
hackernews saw that I got it running on a sega megadrive I got some
emails from people that are running a really old nommu arm fork on an
old mobile phone and are considering moving to mainline. I think there
are people using it in real world important stuff on riscv and superh.

I'm not demanding to keep it around for a few weird projects no one
cares about just saying we do exist. :)
I think most of us don't/won't notice mm stuff until something breaks our t=
hing.
I have asked the ones I know about to at least send the patches they
have so people know there are users.

> (i suspect Zephyr would also be good, but it doesn't support m68k, just
> arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and xtensa=
)

I think someone suggested this before but zephyr is really not as nice
as Linux to work with.
I have almost mainline linux, almost mainline u-boot etc running on
68000 with networking etc. It's even using devicetree.
I've been working on patches for nolibc for half a year so that it's
possible to create ELFs that run on mmu or nommu m68k instead of
porting something linux nuttx because the linux experience is just
better.

Thanks,

Daniel

