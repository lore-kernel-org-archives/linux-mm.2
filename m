Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A937EE94108
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 10:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCA66B0005; Tue, 30 Dec 2025 05:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AE96B0089; Tue, 30 Dec 2025 05:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F3E6B008A; Tue, 30 Dec 2025 05:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6AE96B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:14:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 513691A1929
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:14:53 +0000 (UTC)
X-FDA: 84275728866.20.1731A6B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E2DE160006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:14:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ikuMrUsq;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767089691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQooNBO9/nbI1z3yswqtit9Ay/A7mvKF89wR8GBnPGE=;
	b=bnJxwuG8bP3e3GivYu5jpsWVtD4M7BLLruv1MhIW+O1c/F1ylKxLVW6hq/869FrDtaqZNP
	lfzvpQNewLU4HLq9ONijrFVJA3b3fQCse7yAA6gy1wWZNz9NA8mp8ATC3RSEr/gA3QF51l
	9D+GcUdI+ALgHNZM8XpaswggNWI7fX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ikuMrUsq;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767089691; a=rsa-sha256;
	cv=none;
	b=1E2Kc8ayuIMzBQCGKiEYVMcugYdgVsBzv/oAQ2BuSnG15Ov4T9yn1NhAnIPPgg1GpWb3yZ
	OJKF7P8EWhsa1AZWP2yyTkP5P1uJPe180wsUxEBXhZj+2w3DMM22EF13UbNNs1CEtu5xt1
	Lz35AvwylfFZh1bC/YDqbpGfQUARLys=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a08c65fceeso20142025ad.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767089690; x=1767694490; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQooNBO9/nbI1z3yswqtit9Ay/A7mvKF89wR8GBnPGE=;
        b=ikuMrUsqN8bedFVeUlDXw2Q4C/Z2XgjqTwf1oirBDeMz09htUJYL8tGyB0WkTzVaU2
         e98GtLSfxtgkTGza27T5m489PnERhtU9uTGHYLSjBvVXsqvyUkXbHNECbaH0tWSDPlUU
         mt7vBCBqK90iFQ/T1KRFtz/ZTitbsOL/GvT/eof5hGPTiCyjZPpdUbjqOomoGvdPUFMO
         lE3a0eJF8Sr2cGQNkVO9BlNed2RWGSuqh9D5TOaSw3HDSB/f9v8CqGFY2zPlBFQ95UYV
         MMLYsXFG23EyJAF0SHBstLQEWk1R6K7f4X7Jt/rLwXshzY+9v0R8vwOFMwJMs3IloatE
         Ln8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089690; x=1767694490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EQooNBO9/nbI1z3yswqtit9Ay/A7mvKF89wR8GBnPGE=;
        b=ADtZHSSqN7MMI+RTapXMxf+O8+9HqV/HIhFfmNzewruopueBhOTeqYr3KUExbx7K7z
         Xd6v8QD7OSEHKB3oNrvTSAOFXxufACzefc7Tjj6sbC8q/GzVZObpcTEBfh9nYFKiGmuC
         qVvd75os9dq0VZVDQxI6KTxyAyU7bo9BfkqKDzorSEGoetzarkRgqjSIhimR87Vthb39
         D+IGKyFrhHuQSrV23WXnPiL97pXN3OCO3uu3fOVyty8kqlyXr4UT4V8uKpEZ1mNlrrJR
         BsTaybXn9zc3KxpoKczCXySatQYhvUsnh3H1lc2aCbqhcJMmYp+/KyxOFTGfO0KLo+sf
         HHag==
X-Forwarded-Encrypted: i=1; AJvYcCW4uZG9Uaz36x+iKwnfyOJi31MjpD/A+3mPB42J68r+sct2P4GclTpIEDNtIVJfZGAU7VSkY7Y+JA==@kvack.org
X-Gm-Message-State: AOJu0YzI/zZ9jB+e9hMiKwB443541ld004N4zZHd3r7uyShNAOnLuEMz
	rur6Rj8/PWfq5KgtvmdulswSLDz2ALz5KROqRoB+xBX9Y37n6rRrvv81Zw75nfMKSnsmxrSDDAH
	3pbFCMIduXqDOV89TX1pfGsB4xxLheUw=
X-Gm-Gg: AY/fxX57BfiBtWIUKSpFGYTBoika+EnWjzyMQdN1MWqHQqt5OymVX6JtN1r2CyLbBbb
	7oAVEzfKgCCNPqBvCGQs84gy/qdah746mf1RgHN0ocJmaFUjYum5aXFFOUD3TfDl5177mxrPRoN
	zLA6DRnq6BftV7349pHktDMBycBhdOWH1VS6oDeogrwj6rikhlU05Q0Ut/J+UwacReAuzLJU8qY
	mCz6cGLnxTDFkD01qtWLtf8tC1wcs49uUD2h+4N5hXPnIaIaHN3tM9Za2VzwYbDdWwjI//hDn/2
	KpXkMU23DaJWLiVK9+ADtBctuegwZH/PbDFkgmWVoHqrZjY2uuBs9zQXtsSPhi/Tm0/YF9j45LB
	yaFjj1RyUbQnr
X-Google-Smtp-Source: AGHT+IF41PIsxbRrwF/2Ikh0B42Bny10GO5CEeoMYAV62DMDkBm131qGKK6V1epJeSUCc/0Nq6cjM0BfxLcCw51ZJf8=
X-Received: by 2002:a05:7300:c00c:10b0:2ae:5d59:3ef6 with SMTP id
 5a478bee46e88-2b05ec8546fmr14162320eec.9.1767089690063; Tue, 30 Dec 2025
 02:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20251230094841.76830-1-bshephar@bne-home.net> <aVOhfWmyJBxD4SUa@fedora-g16.bne-home.net>
In-Reply-To: <aVOhfWmyJBxD4SUa@fedora-g16.bne-home.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 30 Dec 2025 11:14:37 +0100
X-Gm-Features: AQt7F2p8HE-4A4GyPdNNakuI5GpD0xhbJ71lZfkkAolIhUEE_Y1X8nqw_Gg8VpI
Message-ID: <CANiq72mdkb6A82oy0DoUWn=jv75-R7EHTNvJRW7o=JeNa3eeHg@mail.gmail.com>
Subject: Re: [PATCH] rust: Test page_align usize::MAX boundary edges
To: Brendan Shephard <bshephar@bne-home.net>
Cc: aliceryhl@google.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	ojeda@kernel.org, boqun.feng@gmail.com, gary@garyguo.net, 
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, 
	tmgross@umich.edu, dakr@kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: trmxyxtnwd8fy1mwro17dy8mjj81n54b
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E2DE160006
X-HE-Tag: 1767089691-56255
X-HE-Meta: U2FsdGVkX1/AC/6j/eMwXgaiZ1S+EnsVMqH6CQKHY/BoHVsW3lm9FVwnhUllPCLGK6o693wdjotZbXU3I1TSUVtsWr98lDimPzuMWtE9j5z+zbkB5z1+vkM+wYZdn8Wkye0i/7hKC2iPaPpbiZ7eagxB95+32CvOnUSeYsAZzBVsZJNRNlSL9pL8d/AFChsf+3Oz0vT1K6uh14DOmpYIV0VPf8Yy+Jhs6oJB9gipjfb5D5uiPm5KBnDFFMsxDy4fQkPLGs5wBEDT8SW2AlQUogUqGK0NE5RPFDcKYWg4WoRNa2pZJbBQTJvhwJdcq2A00BHTdDsqsl7v7g4mwvQqC/sCcWqlhQFANBAPjqgy9b7ePNAJ66QX8b6YSXfX41CQyS3IzcZmoajyrQRpgWuZzK0c0D8KJJmPY5HWATp8UTU4yWOFepKOQ8uijlbXh7KUqdoJOtPEtvZJW68UIReTAdbRwbyLbYUE5pV9wu4wqIBrAkYN35OqcdbOL6A3OBVZpAC13l6Q20Hg9Aez/+oEZOiJx1dnWEBkvSANE0cln8XFMZtR90PIm5/pIwzb176di25B/d6HBASQOz2vggTEPY/7ZZMKsONHcBufqL7cgChsut3vlgC8RDjwuI+V87TlJA9w2WnTG0OEIKT0lXkI45XSe1m1jH8XM4gLaYWNG7/TWNJy/tIw3ZFDDQ2WcwvU9hPrcUxWpe2SlesNeFAIm+bvKz4ofBEDs6xLOtMHhLrBZfSPrkRT8rwu9ndTbiUL1rRtTuH62KXjYRolAN/6gXRij/ih3mGi1xZ29oaHDkgm7cB1C3R5xe34AET7dPlmSj81HI13bHAMvy8tKMamLh+VqiGoZHjHe0no6MqekGPW6PbUr0/JaKb+zEeX6WMTOAJ/AcpVodOLRRVfvAeN3mQYnmIyjffWGU53J3vFcHNpLmNf6XTB0ZxrOwXbmOHg0pIO+94ISNQwzkaAx7j
 kAY3sJql
 Xf5z3Fk5zEosFqKBrbfwmqjFVbjbJ1aeRLt2y1T1vjdHb70D8y8Z7EQqnZR073J3QirfvCX3E/yvpNDBYvdxvHs5qX4dq96xWjbSPaJbr1dJ//syptwJsGN+iJL7npGkZPjPIxBCW16S4BFsyQpkuwPIrS5J20lLVK/IyG/E5V8xeaaKC5ycFk8oxSbbNPFzQ9SYFtO5TGerqE/SwIz7NpURsjjP5cicF9vlmrwyEol9iJ93kqDbwgiJVpqZ577WXLqonkHL2x3ri4cy31gP2pudqd6eH8tjQ2CRu/GaDGiDan8CEmtRz4AD+o1fcrn2krW7CK+ebSqNvPC7842OfDSlbLcfsa2lw9gkOjAhGzIX5JYPXl0udt/sbl4Lu1cHCXj76VIHo1ByEf9ef1sGOa5U76GIGe10+DNnophrChBOFuxhAM3dA2Yq8kK/r8VdIEr+KgyjT46L82P73aFq6qvKQO5dQG/Pc/FTwHVDg+jXrtuLbVQShhc9Ui47JmsN4X4yM6ium1Hb9bfyImAFQXuUu6z1cGK0mL8p+F7eQ9SWyzzIbQeri8Tdg+JLUELBMLzGAyp2OuUO0jA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 10:55=E2=80=AFAM Brendan Shephard <bshephar@bne-hom=
e.net> wrote:
>
> @miguel, Thanks for the pointers in:
> https://lore.kernel.org/all/CANiq72kcMLXz=3DxyZeKC0=3Dj_e0BzJEY3wGpBTTxfJ=
sc6EZhCnXA@mail.gmail.com/
> https://lore.kernel.org/rust-for-linux/CANiq72mLPvB_6Ow3bW5-V4-km=3DRyA59=
chQ1g1x9qUt2P-zZweg@mail.gmail.com/
>
> Let me know if this addresses the points you were raising in those.
> Maybe you just wanted usize::MAX and then one over? The first test
> case might be unnecessary. The last two do a fine job of illustrating the
> point I think.

Thanks! Yeah, either way looks good to me. Personally, I tend to like
tests that check both edges.

By the way, the original comment mentioned "overflow" explicitly,
which was good since it conceptually links to the main docs which also
mention it. It also seemed more aligned with the other two comments.
Perhaps you changed it since now one of them doesn't return `None`? In
that case, I would just remove that bit e.g.

    // Requested address causes overflow.

i.e. I think it is clear that the first case is not the overflow one.
But it is not a big deal either way.

By the way, in commit messages, we normally don't use paragraphs like:

    This patch is a follow-up of: "[PATCH v8] rust: Return Option from
page_align and ensure no usize overflow"

Instead, it is better to provide a lore.kernel.org permalink to the
patch or, if the patch was already applied, refer directly to the
commit with the hash and title. However, in cases like this where it
is not really important for the change itself, I would just move that
line below the `---` line so that it is not part of the commit
message.

I hope that helps!

Cheers,
Miguel

