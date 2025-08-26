Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0986FCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61FD6B0187; Tue, 26 Aug 2025 06:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39726B0189; Tue, 26 Aug 2025 06:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4ED76B018A; Tue, 26 Aug 2025 06:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B19766B0187
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:44:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 208F8139A45
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:44:09 +0000 (UTC)
X-FDA: 83818573818.08.DE990FB
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1746440003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:44:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fuVTo2n8;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDKS+KolO/eydDQPsO0aMd3COpPar50Oa0wPAykDNNk=;
	b=caq2DwSb7cKQKYn3TMVfwoG85JbkHPxiysMbPHFJH9nTo4+ZI77gHufcS8w1SMfwGETJrv
	DqMSX82CcMsD2sGH4OsAGukkWYxpECWOockRtWSn5OkOII9hx2eg+SbCBqExRUNUQohTeS
	xwjRXSHAhI3zyBU9p05VQ8SCsbDxpxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205047; a=rsa-sha256;
	cv=none;
	b=0KHF33+sqcJ7MIIZN3PY0NFN/kRGyJBO9u2BjPzYKlSZwXqSMYDPAPCZmAYcp5qflM34NB
	xK1tQO+tFRy8l3+iqhBv0EsjUpiDy9NXhq85qqpOr9WlQfDv9gkNm372Y2/KafmpHxvVb/
	4bGRPIuJlQI/FTlYUmec9gO812HSvcI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fuVTo2n8;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2462ae29714so5556785ad.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756205046; x=1756809846; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDKS+KolO/eydDQPsO0aMd3COpPar50Oa0wPAykDNNk=;
        b=fuVTo2n8II8/tLKLDTVDeHyNZzCVOZz+EEdcmA0qqje57X0yMKZjLy3OqS4BeSb4tK
         VTN8wk99FAPmeIBhtBTgFuKt5A4/MYlkgWR9M0gA7pl9znEbMefvTmSBV7rznJhhJZWY
         LgZqT4MFu2KnQRTUI6lQc6GoxpZ4o+rBTHYRDGJgulGiMm+nefcLzwacXEWItAbxA4H0
         XdPb+vfQFmqVdajipTeWhGC0wbeG9DikTx58sbiu0d/903jfeQT+DiQ4iq/mNnccCCG5
         raUom67y+i/ryuTzqQGytsRzIyGwQMaOZ+kKohP73dKAdUqUIBt5UfxHxiisIxwUL2En
         Z4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756205046; x=1756809846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HDKS+KolO/eydDQPsO0aMd3COpPar50Oa0wPAykDNNk=;
        b=Vzc3f4EVnG/bEy0uaZdvODIhEzVvI1sri9J6DhLLKZGCJ+/pJba4pdt4h6ac+NCSBZ
         TxtxlOplQO8VdYxtjGzOj6j/j6MyyCcnX+Xx1jCoEDTMp6N7YPPuz4pFzgQU/3z19+mP
         pcfX8IPel+vBpm8XO3m8xo6bFy7xtxdYbnTuZ6touxsZNLl4ESB1RNCCYTk4WEsVL7GU
         CuAyZr86ZNp64gsoXdn3/9pus7KtaGOkjcH5j8APfyeZufPbGgYWd6O4urxc+7AlQJwm
         UA2baTCuvqfaYWMu2HWd6h14kXdfaQ0VUMqHImtehxI1BXg4WK2axyjoHEZgU0gF5Lzh
         uRkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWQj9dR6nDcOwnYL2978La6aWvdC5bqVvpyvKuXmY8ynqfebRCGOo/0x8FVhAQUKY4ax1/1aE7dw==@kvack.org
X-Gm-Message-State: AOJu0Yzpegf9b+G3PrKwLttd2trlkSpajSx/tc+4ar/hHlGzTP8hopZU
	X41BbPvB6FLf3P/5bvVfQjaLuIUue8vTZqAztaI0l8WHgJnKnNULU117S14Mx03R7jxhWB6zEza
	08DQPUZ8vPa5pFBvb+m84gUIFJtvXEag=
X-Gm-Gg: ASbGnctOcSqii7+SfdTIRdTO3LCFa9p5gNgUcrVAG8wD5pWa3tHkO1AiqaX6bnxTIWY
	RxxcxhNCQZFafQpQscDLNdid71bSk0xuI/44H1UKWN1qZQ7AMHdv4R77zPzi8oPmaYK55z7QKEH
	I4UAL75NsFOBdn5kqNtD7xa9PqPINZSLZLsVqfQK46hhWOKYRoEX+e6CcmhX/fLT3uX+xokhhGF
	wmII+hboLjY4nVL4QvSkgBV7ZeYC9za+GOG9j+sOdggjzH8nIqDRLbHssCjQW+li458rM5SZpmz
	+4gVSleLBQpP8Y9dCIiiLy0z2g==
X-Google-Smtp-Source: AGHT+IHy/EFT4NAQTm/VDalLdL9wyv7Nfx5A+2q25XWbuNpKH+YzA8fCrpu4i2ytIGN/IJVVqj62gC1+2NW2EOHuzos=
X-Received: by 2002:a17:902:d506:b0:246:b1cf:fec2 with SMTP id
 d9443c01a7336-246b1d002d1mr61475435ad.4.1756205045763; Tue, 26 Aug 2025
 03:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250823130420.867133-1-vitaly.wool@konsulko.se>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 26 Aug 2025 12:43:51 +0200
X-Gm-Features: Ac12FXwcIt7AKSolN3DwtlXw09gRC9vffEcEHqjr33ENcT1V7Bz1nEJE6ebXjz8
Message-ID: <CANiq72kQv9nJYyiuHvTdaJs2SvZ_bFAnexoEBgjb0CDzPjBTYQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, Bjorn Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1746440003
X-Stat-Signature: m6ui11yzwtk6qnhminwxmrg5is6ifm1y
X-HE-Tag: 1756205046-257898
X-HE-Meta: U2FsdGVkX1+tW1dzBmqL7lfHwWO/RENYj/s/d71MZZkliMp89dx0mIPXYQxyZrpAlse2rnn46i0c5TVHGc+axjG0JhUl+BOoZO2DotlJq7yzZkAjl0shDX/ZQ8Y2AahfcTZpgNxKTuw98aFNbMaoZhjj74nEm6mn6ht9AwO25VPtGz1fbUAB1L4Oute3gFvwBVJX0WoDGfxpvvhhDYDrr3l9s91Q8QH6esXt4R55KIt5QtLskbMBBg2tuQU55o7dv3+B2Px8DTxLFqQ8VgRly6y5yZ+iqqqMmMlwiaRbwvhlr0in8WIHopTATMPJf8cQ9MSkRM9JHI/ZzvG/hjolKwZgJF9hxJ6MudaBiZ22x/JboWHmSLZdUHdS+euU7/QxBaJvgJVyGhsN3tTHYSTmV2UIoBxNg2ak4dTXy5n0uze7xuLZ7k8lMMp8uWbiieC/ewqyptU5fHFMsmpDZJpQKPcXn7TKPtOVq6VN4XCNdFmGi2xFW/NfZ7+lbMyaYQ+5OQ0I4ZhdNx7JEj8il3yFDxSmr+oZA5y51OrYm3vd2N0M22mucWFd+pu9k89cHseDUnOwdqLVhY9b2ewM9R5NO73yX0lcXYXSuC9+Z8l5Cyz6ec4oMT1peNltiNfJpziHxkvqNSWrLlc8a61Lo0HN5Gurz0WNtw1EH21ta6nA7K9lPEUHWJEWZF7mU6EMi07CFyvywFp19QfRC0xaUPkfhDA+Mnlz3MBS05LxczpnQmlbTAfqj9F/vtOnt6JdlkY5u+g1R/f1/MWaER7Bvaz7sPOl9qgRJ1rBE+EKRqI9xnO2Pcu49xu2PLwFW/9uZ6lGVAb/4YIsn6TPeHKSguCk+insTb6yw3XlBxl4B594Th2yNrs4TdKbK4DQawsWbttoidxonJETQs3l9mVxKxfakAw5zt7yDGGlGmeGM8zAD28a1LLaCECPRRq3nJQeJ7IayjHJgrn2LxmuQLBld0c
 R1t77O5k
 pZZ5TCj86RtU32iQxcFwut8LgUuSzlcLi3doWyIcxxjDRkpC0s+p5gLRJe99mcHcGbzWV/l4iZneHZlAcOer+EK/PrYKC252UJkwrXpd9Yg75nzGxV5zJ8NAzRvfkmfNgj80zV4J0UsSyYInJxrrpae4hWQ+b9gSrh+6OtW8yYKMzwqh+4n6719GKf6INb46SpHqpMQJ8IbG0TBD0hXQxvrqBwAy8bLlSIs0OecR0rVGayC1GHvzcx3O4YW6HnVNDS6ybLpRlIKrrtRq4UZ7OC9wFwUVU3QLI+FEylVExEysycQO2yeemNSy6k3eC7gJCsG2EXQMt1lbSoGv+bCLN19v+R+DYt8CcHSRkppXoWK5qCHu6MbFtn9+r+1JSHOL5SEWUr5T9pGamLAMxcwtn29g7XroAYPmyNG7ik2S7zNGbiL13/mgpakFgN5qtX98ymkXfK85GKOr4Ae4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:04=E2=80=AFPM Vitaly Wool <vitaly.wool@konsulko.s=
e> wrote:
>
> This patch provides the interface to use Zpool in Rust kernel code,
> thus enabling Rust implementations of Zpool allocators for Zswap.

In v1 the usual use case question was asked -- could we get some more
details in the cover letter or ideally in the patch itself?

>  bindings/bindings_helper.h |    1
>  helpers/helpers.c          |    1
>  helpers/zpool.c            |    6 +
>  kernel/alloc.rs            |    5
>  kernel/lib.rs              |    2
>  kernel/zpool.rs            |  338 ++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++

Should a `MAINTAINERS` change be added? Was maintenance in general discusse=
d?

By the way, the diffstat here in the cover letter seems to be
generated w.r.t. `rust/` for some reason.

Thanks!

Cheers,
Miguel

