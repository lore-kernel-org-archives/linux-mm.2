Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A6B2CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACE46B008A; Mon,  8 Jun 2026 11:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D106B008C; Mon,  8 Jun 2026 11:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424976B0096; Mon,  8 Jun 2026 11:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E04B6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:02:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4AD6A018A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:02:46 +0000 (UTC)
X-FDA: 84857062332.14.7696AAA
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id B8E5020008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:02:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvEJmMJY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780930964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g51x3Dke8m4hq5BD7mWP1JIENWwriEm4dzZwpkBeih4=;
	b=pUmXg2ZL/19/TOmXi5LMnkUPPKH7JXPqv+doXHxo+p8mOK3Gh5dlnzAshRvJTfahCd7xRr
	ZM7QlUULs++BtHHioZahKHWfR12d4LNw2sNfzfH+HVGDRgoF+SXvM0SnT3tm8HsXI1Lirr
	sT2otK8/GUxqUvQebDt1GdFiCnj21Rc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvEJmMJY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780930964;
	b=6NLOF0UpcRIueXveIBlWLwVb//KA+ei0NodERrj9IhIq/OaxfdE2YWe6/CkHBkVPtx4wTv
	5AILR87slxWbrHpGzBqqUAj+ZFYHiOgQSCv0kZplLU9to9WCm7q4+r4REciAPCQR0UWbd5
	CHds00pRStYUNUL/gYOM79yochzIoF0=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68bd7ec2371so26893a12.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780930963; cv=none;
        d=google.com; s=arc-20240605;
        b=ad2Huxxy446FJ23vvpMwsVdTAwO6O3P4Ov4/VCbQiweWcrryp7bvTr2/sXhKQoc09w
         gOfe0Sbe8m9XD0w7wtTD3RFa+WBWKn9JdVaXz/E4WgMKoWUoJ/uBjiBcpBKkPesRi5zX
         PdpLquopyvAnyNyhhktPeSKRG+OgxC0MkgNna4yQbptVCe6fmPGZtoMSU0dlMHneKmeY
         qR7mCbeR59KbrUXk1QBz11PmcnkgYzCIHhKbl8Vak6JWKvNv9ZPga3aKEO1zj2UAAwG8
         GNgwYGmrumeinfn9Dy+rUID/Z27dwWmHjvj2in5x2tyS8xtp/Jk39JHD9FoO5iP1t/ds
         usFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g51x3Dke8m4hq5BD7mWP1JIENWwriEm4dzZwpkBeih4=;
        fh=9n43TU9+ga5hJF/U2wLAGfPL9ViF6V8PqpOKo+H+kIQ=;
        b=T58uIndUuxr1x0s6IWUFCU8cFAtjIyGekA9s/GBw0b1LIfJETAabCdvdACXFig7WVe
         g9ZxiINQMALCssV7plExVXBGAXiJUtu1V7RHiTxpsNrhXCPq8GseJ7wqjk22c70qicYe
         w7GfQDD6f8XA3VKV1FDg8pVWS5+nGKz65fj31+qt8r6A+binKdZK8TvF3bwL2tyT/ViT
         ImcQAx7e9OF4IYst6Nhm2UvYxvXUbJFFp/0OPJJSDcNibYZ3UpZzVdkXs8X5mNp3f6jA
         2hvkiG/Ib8cvHnrKnE4OlQdXzlNZJmyKmloZ3Ddqv5MhPcww8guV4d4XSJn89uV32Gn4
         R8gA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780930963; x=1781535763; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g51x3Dke8m4hq5BD7mWP1JIENWwriEm4dzZwpkBeih4=;
        b=AvEJmMJYIkHn6SgseYHPwGDehtxgAs2A6CMrqAbE77uaz95Q0ST6fBFvBkpRj0LeoK
         g7YnRqhMcE4XKgCOduVps9oez98yssdE+1Il+SCQbquuehzA2vHJTpl8mPRGs6ccp3nS
         HdpRfa43VQcf9k+29uR3cETyoDBglmqHKSx3CyhdpIiQDj017qf/ADn0/GFu44Roeltk
         6QnhHwvdbwtaTKyZ5IxhhCbHK+FHjeVaTt/e10UURW/nSRuezR+mHSVkjMeBoRgVk5gV
         j6TT3QET0mewTDCFbG+WBQ+u2DagDQgUJP8KcFJkCAUoOjp60RH+25piDzggca69marx
         lTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780930963; x=1781535763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g51x3Dke8m4hq5BD7mWP1JIENWwriEm4dzZwpkBeih4=;
        b=f1q/9I3KsjxJjqAvDHqGRSGeOnnKgOo4d30Ut8zx7+SUV09/U+QEkkTv+3d2rdk9ZG
         ikV+8/f98x5MrxPzlprJCF5gBqh0CD3z1EVmJgyDoY/cEoGvWLFIvSL30selPCKDppS+
         KQtqVRta/pprXzyynRB+BtEg+lpGtGpMoWud6s3wrJoD4Vgdb979WbrkfkeZ46CL2crD
         gTFS4rfRTpjtZlTtjSqIiPcihXWEq2fAb682J8q/RvL/0sO2P+ya9O9Ge4IrOg0IBUni
         jIfQ7OdL/Mm8TAkSmUZG23NrNtW29ma+kcUJc4VkFlh2xI+jlGo2cETjUdPvfrN9YLmj
         YJKg==
X-Forwarded-Encrypted: i=1; AFNElJ/rPBqC3eH19NwXA9e8sdMaldThLWPXJvriU1//r41GT+Z1non3OvOqziwntPYczozxwAwOVs69VA==@kvack.org
X-Gm-Message-State: AOJu0YxKEI9Kdws1cStkATBJZfPJI1PkzghMDS45wtkR9vo5tVFJs9B3
	bt4/f6Cg/u29qbZWpdZBC+JJZhogStf0rLkAuuE2hB6Zp3Wo4huAAXUz53RbrRDHJxI1cNADY9l
	xo00LTOfdumrFknIaw4fOHGZWFN13jdVdZMWy/yf+
X-Gm-Gg: Acq92OG0910NJ0TzxtXQ8E/POvfHJv80byZTfKaJyOHXtgn3ua2IsE3z3FYtMa8mmXc
	TqFDkIik3tw5FPiTOxC6u/L/pCUaQpc9AdFnu+KnmTf06HjXYdPHCvyxLWW9lMWpFhUBCf9dXXo
	Dmx3O/Sb1DpECG3WQRYuuWC6KdXu4o2U9Ae/PB/ucfIuijLBvYhWhasjgYpyap5WBRtKOKpndC+
	KbGMOF+NYCJWlrPnFeGhQA87dy9qIUO2Z3cEWyGR7z0awqcdaS7tYMdpUy9Bq0Xc0mrdcA45OkV
	Ftv6srC8XGa5Gze9jzdBGRLsXbca6QB+6ArjduBJrB+qNCnT
X-Received: by 2002:aa7:d848:0:b0:68f:d41d:ca5d with SMTP id
 4fb4d7f45d1cf-68fe907ab8amr167661a12.11.1780930962621; Mon, 08 Jun 2026
 08:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260528095235.2491226-1-me@linux.beauty> <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
In-Reply-To: <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
From: Jann Horn <jannh@google.com>
Date: Mon, 8 Jun 2026 17:02:06 +0200
X-Gm-Features: AVVi8CcAEOXMmuMTSZ94akkMqWU1PSwZDT3Kns1-hWwyFL18yvP1h0y8fjumjnQ
Message-ID: <CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
To: Mateusz Guzik <mjguzik@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Li Chen <me@linux.beauty>, Kees Cook <kees@kernel.org>, 
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8E5020008
X-Stat-Signature: g9hzh4b37rudttbjf1w8qy1pk4ff7kzz
X-Rspam-User: 
X-HE-Tag: 1780930964-649072
X-HE-Meta: U2FsdGVkX1+YIfaEFhwO7GUjdUBtP7RTi36I8u2cYhRzCv2hgbmsUJlM6J96zqxcmcGNC3ag8WB9j+i0GXLcPJBwiHtApvhvJ/FuZq+NsXE+WLm5xplah8wlgVo/tb6DZ1u4drAlsH2IwjY0LbNJUDkEa+4Oj4SXCoMnT/+XQEkPTtdJvsOtRXAlE9/amWtORokni+mHqN3wVapseRCCeuchSFFxrFEnhIJ1zJZJ8izAkKskbH5tvA3yTBKPaq3Tu5CqGo2eEc3SdsU0VsKByCaRWrGKtUdbDt0oHsUd7b5Y0yvwQcBf7neejSAZD7IW98yGr0v8k+5tsjEtw2/OObhdBtlTBw28bMmSXbOulNBVjbYtkhd482Tgy3v+EGAXn8/JLsSqYSK2qyRhWHQnahpVGT//T6txrGQHAhi8g8VOS1M7v8EJ3DD3pBn//3WDlyRyv2AzesNl1gCryZUxyAOFNo8MgD7a4PBW1fe2kDQzymMXWgHiOWVTbCVA+ftDByJlwjZCcSVBwyQlRJl0gSy+9XIPZKkdTs+HrLaeDDZbrnd19Hf1jmhT73dRU90rX51UYQn9MkPowoctFv5+9fR54ClddKdlzr8zz+C7/6wPOJxlaGer7nQRcHH2RWLz7vfGFJxlykkbzPzuS1gcKVXYE6jp8m+V65hkojAS0mbcKRIZGXYSAtQO7GWo2sBIybSsT+RDi8+gXgnE4yjONuRavOKbg0B2F7rBgn4KOd1vApOMPpVUZfOyXXvznx0wQt/wZkVJnNZ/WcXTdJTm7+EhG4M/rp7ZDM1SCRSt1a3ZP9kH69au5M3sxRdIU543jtKveWCPsy3OJBG/DF5tq4b8jCmsVkGOKs6xDsOHEDzeA4LHRWohIeo5wLyTuxUOmckN8L0p1Te8zD9rhGDvuOqLceeeeOBkNDI9Sogag/ZCZYjdW8LcM0KXL5Sb04a190GsR9R+3A68QZDiAIf
 yXvAVbNB
 b2xi4rBVTn+kaGOh6GneHOj6f/24PwpURp/AxM8uHfLeLEE0vShgvWqZcWN+Tjy004EZxq9rVNWjqO1M/wn+US1JSUqG4Lxej23gTy3VHvKPwRhWyeJR0M4scPZxRYEgSeskcMMBNDcqUsyBnm+Ki0TtJK4xHKksGkq95/xlrRWuwQyAqczrUImwxppw/Ej0fbhDo1gtNRJCW6SRmR0WRNj9QeUu3clkUrfL6A99Mto6UjsXrm2arZJI1lpI/o0FB80kOIAOsVfJuMhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 2:55=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
> This problem is dear to my heart and I have been pondering it on and off
> for some time now. The entire fork + exec idiom is terrible and needs to
> be retired.

It seems to me like vfork+exec is a decent UAPI building block, on
which you can build nice-looking userspace APIs, though I agree that
this is not an ideal direct interface for application code.

> Additionally there is a known problem where transiently copied file
> descriptors on fork + exec cause a headache in multithreaded programs
> doing something like this in parallel. I only did cursory reading, it
> seems your patchset keeps the same problem in place.

I think we almost have UAPI that would let you avoid this issue?
You can use clone() with CLONE_FILES, then unshare the FD table with
close_range(3, UINT_MAX, CLOSE_RANGE_UNSHARE). That is not currently
implemented to be atomic with stuff that happens on other threads, but
if we changed that, and it doesn't provide a good way to carry some
FDs across, but it feels to me like this could be fixed with a variant
of close_range() that removes O_CLOEXEC FDs except ones listed in an
array.

> There are numerous impactful ways to speed up execs both in terms of
> single-threaded cost and their multicore scalability, most of which
> would be immediately usable by all programs without an opt-in. imo these
> needs to be exhausted before something like a "template" can be
> considered.

(I think probably a large part of this would be stuff that happens in
userspace, like dynamic linking.)

> Per the above, the primary win would stem from *NOT* messing with mm.

As you write below, I think we have that with CLONE_MM? The C function
vfork() is kind of a terrible API because of its returns-twice
behavior, but I think if process cloning with CLONE_VM|CLONE_VFORK was
wrapped by libc in a way similar to clone() (with the child executing
a separate handler function), or if it was used in the implementation
of some higher-level process-spawning API, it would be a perfectly
fine API?

Or am I misunderstanding what you mean by "messing with mm"?

> As in, whatever the interface, it needs to create an "empty" target
> process (for lack of a better term).
>
> In terms of userspace-visible APIs, a clean solution escapes me.

I think we already have relatively good API for this - you can use
clone() to create something that initially shares almost all the state
that a thread would, and then incrementally unshare resources and go
through execve().

