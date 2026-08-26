Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41112C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205816B0088; Wed, 26 Aug 2026 12:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B62D6B008A; Wed, 26 Aug 2026 12:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A54F6B008C; Wed, 26 Aug 2026 12:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D42716B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:17:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6685CA2B22
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:17:50 +0000 (UTC)
X-FDA: 85143926700.06.54266FE
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75E05C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:17:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="LzC8/sq6";
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS8Isqy8j1V26xF5Dw7K3OrDRfOCKejghaID5rQbMsc=;
	b=fO1eS+Rtfa8CyOvRq7KnIZwYJfjoeN3v6GDEVW8OKjXfB/+tN4FbrbpxkbfLSs0My44OsN
	sbY+pVY4Q6RGCBg+c/HIyNsbMR23UtnnJjoU7L/zyHV/TZxoQnHySYdNteiektwx48/Uv9
	cYcwDD/WX/Qyi+wXsjyoriPAxwjpdm8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787761068;
	b=ltb5qWfUpmFozE+MnGLURZxb+PoqhCqUcWs2jsAJISVX+83qvvj7SYBKfdGxPldQxbGWLG
	WvAU1W3H8JA8oUS/v0b4EK5LVNgQn3sk429PJ7qo9OaWBruYcAsCplMt+9K9os7smKssfH
	UXt9oFub8teeNuD3LsUicY1PXF5sCmc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="LzC8/sq6";
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b445a84fso125415ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787761067; cv=none;
        d=google.com; s=arc-20260327;
        b=UzV1JEx1OrpVdpUXaZ0GkroX6zW7c4gEhNlKsPUXt5LRfjc/3/LshYQsrxrZpZOFgy
         cZyCiomJNJKtBkWUe8IRIbiwWIsaOatWXYjaudCSnRaCJ2X8FE0aFOzl6CqNUMjdaBPr
         uwFganPAYzuMHdZzzmckgoqnRH1Oc2lPJ1RiLksJykzz2jxmpl2LVGKx7Xrap9pEgvAw
         ImkOAfE3Io+f5QfkcTbYZALKXMZjzXidAEK1ZNP7uwKiJ3BT8fkiRcMKjb0LAzz4JAo3
         /yRsbcPILlA6w+N04YjZjy/aItbpanNQ3Wcssfv9V9LP7STFRywomQM88kOF91cTUbXP
         R2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wS8Isqy8j1V26xF5Dw7K3OrDRfOCKejghaID5rQbMsc=;
        fh=N6reYVPZuW6wBBizmJ+W1oe3GZZn8FCxfawMQz0ikKs=;
        b=WbRy+T3SzIvSaOp423EyW7DCHvYPMgy9BRov1SMOpzEARQ5rTWtAiq2Z6PT/JFbdyG
         m+AYtdnqqyMqwR2bbA4irwLXNKCWTS8xIJ87mDH7mSNl6+TjKG25dfdaO3RPO6IetI0L
         r2dhOWUjDEVJOrCXrX6iQjSDEi6Tb/j3w2+6XPpSxGCPhNVSNJfeFtvZvW0Xur6tpM4X
         Mr4+9QiLGyWD9+j0q15ybf45Ou+XGal2dVxlYrbfoldrEt+Y/2P/iXQX4YvpWBsMI8GV
         bNdHvb2KO7pbVQLxJ1hxTZzxYy3AcUn8EjLad9prGYz8r8ja5iGksxxn8bEwm1jG+yRb
         Bfew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787761067; x=1788365867; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wS8Isqy8j1V26xF5Dw7K3OrDRfOCKejghaID5rQbMsc=;
        b=LzC8/sq6CFFQueQvOerPOmFdYc1P+16OewCGqKwU4QaLHQquNlWoXAEvxNRGE0MwfY
         s3gIBx53QQ0YA7ZzkFb0ipHTj2325f44t5e36Fgym2a/8Bzb5XCtn/qhK/wrlNEngmpt
         LTLFqP+vIsTZlRxI+LCH8fyOCER3Ni8ANvoEyVdpD7QeI2doRXpZUsFqbKtPGEanmmY+
         p3I4dnHDbHWPWJkdEIBNJAOIoUlfPrjCr6anR0tg3MaJlGUfwJqkCblIdKVml8linLqe
         tME+FjOimCxg0XoI4pXwmeStvblWsd6Ze7a0SHeqQXxC4DYgXv9IWpKCVo4iC8UyDvxt
         uuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787761067; x=1788365867;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wS8Isqy8j1V26xF5Dw7K3OrDRfOCKejghaID5rQbMsc=;
        b=XefOfHLt34Y2bYhIL8pNakOVrD+PfZz/NOqzIPSsITWEpTteljkO/Kb3bLtKlOBIEz
         yPkJqkwnR7Axit49iK/u3fV32uOMGz6L9VkXTZBwMobQnzhqVKhXdBfIM61UfQwYRQMK
         9acTMNmAORP8m5Y5OO2Hg89GtUI5DhHSmL9xOaRlSDxKX9C4qEJR6qO/MoqyYtL+uMnL
         +Q0Z3wmzcpa4KM/Lw/kn4/WV8UP55bGG8MvE2NBIglpQXj0BsKODEpckOevN352/qneN
         ojLoHWy2ZsJdHmU7X6DGREooPjPrwH6QccZzlu9SZfdhsQobnNEBajreCMudhD+QwR7u
         DmSA==
X-Forwarded-Encrypted: i=1; AHgh+Rq0Pm2R5UdDmSNLKYqj2kt/BOjptuGsMCqXWiaLPcP4i3fOZjyVfu+/VcOtuLUj9w+ExYHyvLe6BQ==@kvack.org
X-Gm-Message-State: AFuF++kEc0YjFyQmmvoc03g4k7Ui807GgRJzRCg+3IBQ0/w2JGOExN0I
	o3oDi6RVZBxiJ3HhUTxEQujhpJCZr0niFta5ueRa3mzl32C9ztk42KrY/7S+O87RTpvSP+rj451
	ALyjIgVnMQjANSZG+UJs86QCXz/91U4PhZ1CsERbE
X-Gm-Gg: AR+sD12wFLDEsdlGjBkGt5XfJZ9sn9dkenb/W1w8SNDpQ6sXwEB6PKeHF8+PqZvhvHV
	i7w4nmVBoGbkM+6Yygs/ZBYyGP8dv7vkp+w5aXP6ZNutjqpWM6zXyLgCqTJOHPENjJc9gbwQ9Hs
	WvqnbkVsIYmVGOp+xnyp0NtFk1Lg0/04VrJVdCPdSZwTi0SulgzTnIDRy1ptKSkCLYbWlx+ZKMe
	SZQqNMfSyo//ViO+xoK8KKfq27VksUJeiD7PqpYOMERzCSLUFTohJKSCnzOQHIpAWgYqHCCyNOy
	nJBV6Fp1TAxEK4x+w6V2rgb4zybgRdDZvRkRzc9HlqFjvFf0MaR7bEXco7gFohuS0C3w5LFfP9x
	sVk8Ux/80xi/DDPc5ih1he9BCXZz2GA==
X-Received: by 2002:a17:903:1a2f:b0:2d0:1aaf:daec with SMTP id
 d9443c01a7336-2d7105043bfmr5843385ad.9.1787761066499; Wed, 26 Aug 2026
 09:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
 <CAG48ez14F42BgHm5dKeP4g8D_6CNhnAfF7BXdcBwa4NdtFiaiw@mail.gmail.com>
 <20260826-juror-energetisch-hackordnung-83810c82adcf@brauner> <20260826-rotor-heterogen-wollust-2091c20f5e30@brauner>
In-Reply-To: <20260826-rotor-heterogen-wollust-2091c20f5e30@brauner>
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Aug 2026 18:17:06 +0200
X-Gm-Features: AcwNN1XyOejgP8xhG53At4w9H1ZIts9vwM506J2nZcs81pxFYrfApeUAbMczaOg
Message-ID: <CAG48ez1s-=GB62T6k5NFjkgsLYJN_eYhDwT2U9UXeTTCZBV_UQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Christian Brauner <brauner@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, 
	selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 75E05C0007
X-Stat-Signature: d7dhh5nfkmmg5szbjndi9uurwrus3t6c
X-HE-Tag: 1787761068-199968
X-HE-Meta: U2FsdGVkX1/Hrcho2mwnlK33L+OcWDhvlyApcAvbMOoElCWqWUcmFb4kXsPwnGZL/vJ+x1dJJrKs4fRE2mKkXwbhejecARBpdEvNqZHai2taazjJmD41Z6Thc9e3FUgo79Dg7qCrR5cQ12snQjfBUpUvKDGiPw3bWsSLwrsqntDfEtoaae8IJPSFCzOEETt4ZQdtSMeDXEqQriAXoI+FLS0UsLEGdk+4EmwByThqIs5ze/1uXAq7zrrK0yE1qSI5VftBJakt6/L+j5vLIVBBiJdbhq0LBv3f8ZXOxc1DOzSShiGkIzQ8qjpGSF9xUofbQAm2qBzdt482qjJtKIBx09PeQMZ+2ESyTr5ydJNLDHaSuiZpaI/nkzCFlqLA4JBlPpPhqnKFeFfMJqmYG/8LNtLnYKuugA7DRaJGtM6OG5nKIzHGcHy1w02eOT9lkVSSH7DQifcTi1CXWNPCxs8j666Ed+3oewJYmGVQd9wnklsaKa51j1O2wA++koGvXk/mCkH0Zryx1pUw0SG2oJEJuThaM6HV6699nzeBpcxiqa/QbZXuFLNgyZhbCTejorwV2gjgCQG3NRFiNbQCv0ccoX4703AMpDWeWoI3QS3bjck8gSNqianocRjrwocNiut/sCHNdFQN7KCMyDK9+Gnx7su64ZQ52GToe9gbZWXWsLXzvMCwfZS8IZrXPiNz1UFtiscrsomE7nbkx1nqxIHzvY9Q0Fmz9QXpyDFY23tcEMrIi4o9/k9n+OVKT1Xuhy4vbTQvYVa/iVPF9xXqLCub23mNYxBB4YSUzS2sOOBvxxGyMvLfutwQRjBuKPdpbTd0aqlSvamFfGULmf1Bp6abfWHjM3stH/wf2tdzWaV3BxKFI4OLJ4tNPEsyqRhG3AAhUVow0p0Op8+3sqS6Zv5mO+cPIGGgXEMcozc3bga6Bh4aHIUdlJtbwHoQnRc0RDo5Wo8hXMuyphp3kHgByyE
 snP0HD6s
 vJmMT47/NcunJfBeCLaENyXQtSjilBgBgJvuj3j+8M6JjP8DVoZjuLtr9sehd2hbllBl+yc3tqtWxtfFdrrDHa48Mqz5DWUODTcU9/IiBdJsQOnq/InwKCKV0AjYuv4abnUkBySW+xhfPSiyiPK3Q4ZVC5C0fRfx+hf9PPnFjsTB2Ssjw92CCtoIQZ0VJjvT1Rauk/cdwqiM5XNWALv2sEfOUlp0B+19e52HjqXIKGqzsHhn//D2lmt8Rvm7KVs+RE5msSDbx1NQqyAmLgQSmCokUcOuCdZMTPrUlE9MZCc2pYwDuxeFad7Y/4p7xQuUOpzO5q6J+ZwId1iYRxKTJIf1SqZ7Is/jc7IPeMAT/O6MqfCq4BfQ5lrDfOifWOBwcipOs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 3:01=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Wed, Aug 26, 2026 at 12:29:14PM +0200, Christian Brauner wrote:
> > It seems odd to just call a hook when it's introspection denied.
> > And if that's the case why not also have a general hook in
> > ptrace_may_access() itself in the introspection branch?
> >
> > I would actually have use-cases for this btw.
>
> To be clear: I have no quarrels with this going in as is. I'm just
> interested in how policy decision such as this can be made more
> meaningful in general. If you have thoughts around this you want to
> share, please do.

A distinction that might be useful in my opinion would be to
distinguish between read access to memory/registers (like for
collecting information after a crash) and write access to process
state like memory/registers (which would only be needed for actual
debugging or fault injection). However, ptrace() makes it hard to draw
such a clean distinction because resuming a stopped task can inject
signals with arbitrary signal numbers...

