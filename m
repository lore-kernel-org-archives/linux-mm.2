Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D87EB2718
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C186B0005; Tue, 10 Feb 2026 16:34:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639D96B0089; Tue, 10 Feb 2026 16:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B616B008A; Tue, 10 Feb 2026 16:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41BC46B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:34:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC7B713B870
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:34:18 +0000 (UTC)
X-FDA: 84429850596.19.96F8371
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA7871C0010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:34:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Rk4zEMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770759256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBUgcVLyV11rqBwx714uSaH49HmuWIg+mpTyGJSCg60=;
	b=jMZCn8gFl0P62DyLEOkVnKwScaySxuTG8cLiKmy7Za4hzyfOtHPj2B5T3e8pvOeOK7KgmY
	Q6ELZTmDBauICTq1aAB9ZKY/Gm8Mpt1Q9iONgQiibQVJbZxdu0F3EAiy1ik1dqQTl3zHK9
	j8bYlWxYmxIVM+GOVmsPJ6plnQSf96o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770759256; a=rsa-sha256;
	cv=pass;
	b=WwhN+FlAHdRpgravhOxcuzy/RvrI6B+QVMr9k8a4PRtE4nuy3ua2/U/aQax7iV7yC6KMQW
	fnX9tUwS2JMk2GLYeCjxrWLa6haxSEIwkSrWHQZk9u3Jg1oHO3y7Kk4dMvWERNvKgvlsvR
	gay1DbkTyJv5u1ecbl0mOpBE1Uw6SV4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Rk4zEMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee0291921so45128475e9.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:34:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770759255; cv=none;
        d=google.com; s=arc-20240605;
        b=Z72o8yNAlbXSBhWhId/psgy/BqAFLgS8q36DrxisTbB2FiQu+48U0uYPa7JARujY+n
         w68w1Bi3E+mEpEJN6KVum0BsBwO6jPf3CtqQuELdSs/4Au5ygfZfDlrkzYQ8beoU0VKq
         LOwsNi/7k+66bISHCK9ctBw0Or4JIPP2KaLu0Uj+yejTiAoHSz1EuYSWHG1EOdXr7OGy
         HedmD41UHrVERDc1iQddd9juXMPjMAFbuzorUaXUF0MjVE95ThQMDUHbwa8xl8reFWMf
         6JhRLFrbZuiWvOQIs2NozK18sddUz8QacCGMnzYFLSBtjdHidwtdFRH54BFd0Gm2nF+r
         qf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hBUgcVLyV11rqBwx714uSaH49HmuWIg+mpTyGJSCg60=;
        fh=2Iukh1gHbwyLfTwrSlXmqT51Yyhacdf2bQYTlCuPhzM=;
        b=B0I6YiaCSl9M2tZ5BJJVwiMWEBEYlJNrYdeaw8arnaepOruxHkffWj4AJRs85Q04zu
         yVQc+By1+lHqqK/73/YmZWEbBkLoWvz0pBS7eGDDB4k6w/E6jUgKdt3tVnFNR/lQdg2F
         lPU6n7PGLIhRt9MX3LoMLrtos4L0PAK0o13j5tx9L009MiovcnZ1dylYpQ0PXgkSMcq+
         FxGddf0CYOwIGrr2aq95lO4e8HHIt6fBpEQ1BXiUH5wro6yTgRGErtblG/EZ8NAhavpg
         GT0QmpN6OY2W3DjLQmub9mlaJuSaD9cv9AO1zZsV7QD3Lpn+eL5sTOcuovItTw+iYFMV
         jqDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770759255; x=1771364055; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBUgcVLyV11rqBwx714uSaH49HmuWIg+mpTyGJSCg60=;
        b=1Rk4zEMoE23cZpESJfH5l0XIu0ruKWoVhBPzgjf+4qhPJWlJbjnBn0vDwbSksvyCPB
         V+0ghDcjNYRir8MV8tlQo5v7sMBvUsBHmwDhgr5HYuQfxtBgGpPklHu+WwQov0RCXSzB
         UqVDrFHctqikYy5lxpoTBXYq7fYzkjh5CR/vCU19Tz7811H+nId+PgSBU1F+jgKolspN
         Y38M4R7b+djA3HfRv/RCSio8vVxmPmBIILNL5Ep3YEVaFsqXrkIrSU26TciqSzgptz3p
         AbW28pSvFxAQTB6T6SdeCyxjMC4o4bVrqqBSEfDXOCJIeeSIZs248hSdQxFRcHKbiSei
         V0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770759255; x=1771364055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBUgcVLyV11rqBwx714uSaH49HmuWIg+mpTyGJSCg60=;
        b=ZhjdKHNPGYCAW9/UqFhhAuo/cjTp4R67aHwgsbfVdoiwNYnrEyAvFe1lGqHKsKmgam
         h+FlDOmTwgwzhXWAHBrnELLH64btTZHybEWHE67Ra4xwuht8eIm9S9WD55/Qg9kCA3aG
         R3mk06b5tcNl8AFYQ/sbfu7AR4c+xVmcswhzd1IRwGIlzF0R6jTbeCqRZwHpzfiGM3vp
         jpblolq6PZuCTIfaAXU5OVGLIGafIs3TrHK909LrLA4HbdFsUrs11bjcFGhLCctwu9y8
         c4nc+45qDutSNvNBm2mtJ1zo5vP0gPlqyf+u62+x6XAseB8rmBnSwI/WKbtKbt3IfKoT
         8YlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNe3B8HUzl9dmFbPoFwtoP1d+HaTCXQ8Gf01/C3b94SNqTQQp2wvhd+/Gfw82tRircxtfUUnzxmw==@kvack.org
X-Gm-Message-State: AOJu0YyOLJGFeYNSFX7tdjaIyCeusYNiYCCba1ES83bw9OduK9DQk/FY
	OjboU2nkmr2VwvvsB/Z+2N4asDU6UWyI8G930fZ/xb/9dh4b4lKQUUQZOpYLiQAet3H3rSybsgE
	DonvOGH33hVBrkY0nHpJO6s4Vvz9ngeCDWGPhGxtJ
X-Gm-Gg: AZuq6aIkM3t3MeMa8kD0jiPATygWW3lwmwwGTzd9Qz1hYSYT2U/IycYsLWBeET9/e8l
	HJufXVffHH/mdtcuzBiuTgL2HUeaq7WsBl2fortt3MaDM2/Bfu7ve5Sm/ykFPeX+6bjqVdvSYhg
	5urynvBRehI0cUEzQDQWDy6isnxy2nqVqIt0Td2mrbIOb/XVvbtbsPHTXgWumgNL8Glf1Zalqau
	+zv0isMsiQu7DYa6Zb7DPKDKskYOvgvIlbSCuPW8as1oEMZBALPKPSB/C3h7S/c5YuIO0CEzM3g
	56DNFRwyODK5HPpJKGNUusFgYLujQAcad/6Wxw==
X-Received: by 2002:a05:600c:37cc:b0:476:d494:41d2 with SMTP id
 5b1f17b1804b1-4835b941188mr4236605e9.29.1770759255120; Tue, 10 Feb 2026
 13:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org> <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
 <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn> <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
In-Reply-To: <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 10 Feb 2026 22:34:04 +0100
X-Gm-Features: AZwV_Qhr-YCHMLD4rSruxN4k-Vr0ksUt_3x_a0henm6mi-euQSTrj4jjyXJWnrg
Message-ID: <CAH5fLghKwNEdVeRi3H3LQ9NTPYprpAeY41-jgfq8YEST9PaGdw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
To: Tamir Duberstein <tamird@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA7871C0010
X-Stat-Signature: he8rfoderym8dr9oxf9wesddtu8wmbt6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770759256-915676
X-HE-Meta: U2FsdGVkX197hqGpc3H3UOnsXK1XOSViJGUIvuIUR+GTMbfDi+TyLAOChUV+mn9VYfjiwHMfmUJOxOWPgE1lxSkKCP63U53FF8nsMaaNrrF5x1LoDsIyiqN0XOBF/YYIzd67AYRegFblAu5sNlOnu+42ZMf8eX4r/SWL1JkL2ChaDE/tZsIdIrpz2ZaVYDUv5jThxfxaMXb3TY3ZnqZs42p6uX5mjtc1iA2bZJPGdVgr+Lyp35AK9BEC251/S5xpEYSEAf2m1TisEOwgeexu+vfnCZ1Z7WBkOu3H2jOvliWoeB8qNckYJy+c9m9NKIhOlT3Gxv4qMbSZNitxpnz9LM0y5sTnlDJT28NonsjSCQxV+0Z91gOTQLWMVQhrQz8N2OkUCwJQZ7eRfhbG5do24jHgt+bWC/5k7GUaOcauZ81LCCSsv2HF86CZCggiKf0eEboL+mfxcLwz339PDaVTU6SdI3kZHU1tACRYyN7aoCcCCZhJJztR4wSZP0yeXmw7iPQ/pCe9DURW3NH9bArJvx+gmp0DMoPTVHK8oh5rwVqeqS+1NDBPmYyp2HPiaUviMTII9PrenzrpEvunefjEdzaCsbsMVsJwmuXSsMTBiG2VQ7tohLHsdEjaR033Zh0YA4yqt02C7MoggfYy21w2dVjbT81k9L3ArfJVp1TyQ46ZvkQhaEUpbtg9lZUktXMtWzfP+nFKt4n7MZj2v5D+u3VHfBMd9TwzfKE5lIWMc6YzBYPKJPm494KiDqJ7wR2cy2a1dSWuky4drJjc/WrAfTv/2aAZajX8rbWjGKSUDt/3pdgJ2hRQAA2vLKbk7EDtJNUcnh6oZ10A128T+/nWO2vB2dsH9GhFc81dsxsTpO2BQKdvQBnjhmoQZ6vZtH42sux6vlhIiHL2g0aY9Fi6s7ZGk/DZiBkWxFQbcJlx1g4a4t/SGBZWgUXfr16WxsLbH7D+ZChaZxL6NzzEait
 QMKc1gdE
 BdWpvsNDReIlrQGJPwG2H7xw4bTXcKtFUqub7QL3sbxANRfZE3d9Cpdq/uYRW2fZFtw8JWucDJ6N4LfrxvceVqbjweDd0jTQO7Grw4U8UJYMWoNb93dcPcuUo05ckEqJ3EvRY4M10EXoJrnaIommm9sbpNy5IpMsqKgv6+3J3PKqQmnGQlm1/foL8I5vieQ0TCXtkRBXb7Xmcma+ltqQmhxQLRZ40guk/8kNRq23rWDwUqj1ub9bt39L82PzwfzZAzapyEjg5UBm/9KyUnolrUo2+Km7JAw9YUOLfEvbG60TPtAWvuh0NJTRmjy4G5N4b5U8Z5ISYnniEgFlKna/eH90jBmCEvkXZxxLlcGJ+jed9FfmTXu39MU4LDcn9vYCWlctiC8x+A7GjUNdDzyRoJW1eG9H084CBuleXJs6XCgHCF0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 10:23=E2=80=AFPM Tamir Duberstein <tamird@kernel.or=
g> wrote:
>
> On Tue, Feb 10, 2026 at 12:59=E2=80=AFPM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> > Is this a temporary limitation?
>
> Maybe? I don't think RfL has good abstractions for RCU yet. For
> example, exposing load directly on the xarray using xa_load would
> require a way to guarantee that the returned pointer's target isn't
> being concurrently mutated (e.g. under the xarray lock). I'm not aware
> of anyone asking for this, though.

It's relatively easy to add an rcu-backed load using the RCU
abstractions we have today. I already shared an RFC containing such a
method for the maple tree, and it would not be much different for
xarray.
https://lore.kernel.org/all/20260116-rcu-box-v1-0-38ebfbcd53f0@google.com/

Alice

