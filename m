Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D627FC5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 20:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973756B007B; Mon, 10 Aug 2026 16:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94ABD6B008A; Mon, 10 Aug 2026 16:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DAB6B008C; Mon, 10 Aug 2026 16:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55A476B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:20:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E82011A027A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:20:00 +0000 (UTC)
X-FDA: 85086476160.18.BF85BEB
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5BB640008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:19:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jidhl0aj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786393198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgIF1kuc19iuRlP9zEQcOp7zPTO65a3duLKsT6ITH1s=;
	b=QjGq67z1oj0rEkArqUY9NQo2f60QTDPWwT1bXtaLiX3Dd+4wdZW2rMwq8cYYHotjqUKsQQ
	LJYjygIXSN/uD4KnfY2eHDSmidAZQHoynOLEcAUXNYmlnfZqFgUbIChhryz1Y4j1Brent6
	iSope57mXC0X6RiP1/ug3ROFE+CULjo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jidhl0aj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786393198;
	b=Hp28s/i07YTQ+alD/nLamyRdFEKzOiNSxR873JZtiW7YTQwRRLSUUFESSMcLXxZt5kOd3Z
	xRNjQhEIkLXTrOYhnYY43C5jVUZbEsUmE55YvafoZc6Ghr222ToEQ2xFMHGNWg2i/63X6b
	6PoaKxZy90qwGzpTjVO1x9WvaAGcmPk=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so2942525a12.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786393197; cv=none;
        d=google.com; s=arc-20260327;
        b=Vo8dEAICRqhNkCCx669Xx3xLy3wCaHAXYvnQBVCgHBpD9U0N4oteiSoYuFzbDg7uak
         89AygT91RznTYr6r3EltjciOwA7Lw+9j/2QilK9MoXRCHuuGyd+UOZ5/yyOAU4wj8wQ8
         D078/JUvN2Mq191/tFPpnk0PnKAChYMCUIYN8+2epwNaqQ07fiXLvQDrJVJYOVzJKPPc
         gxiqsOz9MWtyWbonlJChLgKTDW//gCC8fXhQjWMmri3zEIcllpgi9hs4u1A1SusnzQyz
         Q1qaTJUrrdI9CrWMr35upqenGGZxPT1fle917CyAxOh7y67MOuX4N1ymW17rMS1a8Xil
         nSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=UgIF1kuc19iuRlP9zEQcOp7zPTO65a3duLKsT6ITH1s=;
        fh=vbKm88QzV2GguLahTuCRXjvXvg0bhK4EhBMMe+mzh/E=;
        b=JumR5m4ck0OFkXkbKdUC2IC0x27STtIH+ZXYJ9lkNIKTy/l9OwbYMmEa2NCr8sp0UF
         7+XPM6ZrtCQzVISZdS7RwJRInUbdpZ54XGSZdCr7WYHRS5GhXwMsgK0SmrsdQdyyUKkf
         ITr2WwsLI760rB2Ji28iB1s2qGJd+JJW/ukw0DSu2fCV4NoDUZub9XfoKABJjpSJmL80
         zxhFFLP4MKJiHGA3aFK0mr0D+HQorBG/mD3SLvDyLS+DSTHCGNwlXbObayNBpKO56+8N
         y/BfXk7zlrYOViSKwUHfYNQqDTf26pPgsf0yrC9cLGMRMztfI+yeSWtqQW0LKJ7TIGEm
         wcig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786393197; x=1786997997; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UgIF1kuc19iuRlP9zEQcOp7zPTO65a3duLKsT6ITH1s=;
        b=jidhl0aj2bmzYlccu5i+jVeqhWmmeu/hvaRNjS6q09lgxQsujmAwA1zR9r2JWbEIBv
         v0iupiE88AEjIBKnnVck5zlRjx2gbyCzTrphVfAtYgME6eUqUTlKgxqr3wEzn3mrLDuZ
         wg7/p2w9+vIEdy+PR6fDaVzjv4Mlco/LDNapCiaUYpn7Cc6UwhFl9wJpByVRdK0vaR7A
         Ew5X/rLZJwz3e++TjxVJpjEizUKOoxpQB+8qP72aMZ+oF65lR2wP9hs8zUgF2SWF/iR+
         sGxalvNAoUoAnRWwMCnSoYnAeiwc2fcwuh3ibFsJF1H4apRKVefpkmFjTQ4wnPz5LZvN
         XY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786393197; x=1786997997;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UgIF1kuc19iuRlP9zEQcOp7zPTO65a3duLKsT6ITH1s=;
        b=UoED8d7WCm4Y0SjEtFe759TerJKchgoe7y2WtwIZNWgM/FOXZwZX9wxSZ5PGd0migQ
         ncOU5I3iIvCznn0C0FiF9Jz2VtgyOaarzLYCDeRKb+zunq9eH0NUTDP60/LZfBPnax4x
         KYQOYuD8vVHdOqI5KSWF6y/zL4VqZwsiyePCjweK5Iqvx2Fsf/vgB/xqiV2ORcEz6tj8
         x2Am8jGYuFrUs83XvQBs0LQTx/dWdZ9KVKNq9cZMg1JV6ldcHSeAH1cdJqOsDqBQwSHD
         03addDZts/QaPRWF2zNewen9WBhj3LiWeUdgNF/hEKkkB41CXqWOwzukh+JTHYEULIlL
         p2gQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGmEqhuEsm66ReOvcedyQDRfG4hjk/o1Bu1R2HIH+vJIEACK9Bkymr0+niJ7K5uC6/Vvmb5bF9OA==@kvack.org
X-Gm-Message-State: AOJu0Yx7qEXfVbQJMf3AEPAt52AfPZ9RYBeJAa1ROu/YUsporGvDgwGK
	GWoIc95V7PYgfImgsItsMVXwpwXMHRkQP+dHEcWUhHGqX7yNjFJGg88xsP/FK/p8CVL2JguoQV/
	1B+4s3/sJKF42U1Goei6q6C3dPrJ8IMY=
X-Gm-Gg: AR+sD10S/0zp2ec/pRM9TazV3sYjYFzGyOh9Frsz0QOO01XU9uHMJQTGs58tesrIoS8
	Z2Y7F/xeSKGFlNMbdYV9vb8OWrAcunuej4nh+41Hgg6Iqhcr22qUhSY5E5hfVkLTiNz1Lh2V2+X
	JlvgKyTu4WH2eYI6Md9H6tYH4ta/XeVy0PAWGR9OqvrCzC204WbqBAickXVfC+t2Eqhkc1ziAwX
	LvkYFMAoJSuCKbwHkVUC9ebWaAru/V9fzNoxrT/yV6peOpX7FSQk/ZIE4dmHSMdultOaY7wAstm
	Ee33w8Q+ztdMOdHdJE6xtabT4XyjuhChNaf4xqKBv5I+bA==
X-Received: by 2002:a05:6402:51d1:b0:6a0:d40e:9c0b with SMTP id
 4fb4d7f45d1cf-6a14f1448femr21365486a12.16.1786393197284; Mon, 10 Aug 2026
 13:19:57 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 20:19:56 +0000
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 20:19:56 +0000
From: Ayhan Aydin <nsd.project.dev@gmail.com>
In-Reply-To: <anlByPDZmvEhWeXI@casper.infradead.org>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com> <anlByPDZmvEhWeXI@casper.infradead.org>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 20:19:56 +0000
X-Gm-Features: AUfX_mwYOvXHj1CH5NXEpaVzNk72oIsQRcr9M8up0rWun7RadURAT4-q_8yOC5Y
Message-ID: <CAFLp9PEHKcdAgt3LX1m_0+H=foY+Va8gtSv6r7Gp1RVcKZ7YiA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: nyxn5mabedwjsm6xjb14r38ez8gw8d9b
X-Rspamd-Queue-Id: E5BB640008
X-HE-Tag: 1786393198-906437
X-HE-Meta: U2FsdGVkX1/YZlz2DBVAmW3TJKj+34Ye9Qr5pJbZAPFTpfB3V4l90EtwU/D84K56GEe/EuuHKbi/GHj17hRGT2x2tRGNIxVlVLYyTlWP2XVjdJ/srxYlwm0jvh6649/WRU2OoqtUxuPTc5BkFw01YJDLeT4eJ/1oiL7UDJZAsFTHEXpzGJUX0qKc+4oCCp9iUAi43+ushnLD/b7U3q/RsHWkualKCmE/s1Ln2/VMlhhRKDTrrfPByET6yVMXblbRmxtK6RGatPXW5/kL0gZ4D1qdfrTB6KV4rtGo0OcLPTkdyhix0eRMZ/nyNDhxmbeS8xOSJLnt7m3h7NFjzNGqvG1mLMQ75/Pb43IGYPTXN+0c5OImmwyEFf8E8L7F2izoGAIOeYkta2iCA+nOxWbekSRE9I1G81+tm1qNz+pX6jIzwkNKkGxKXSER+PRmcf04uu/528tiYSN4FzqEyp9hsq0txxRICcgd7LKL3nwVjlVtB+/1zYjyBD2E3xh9Npxj8+91L5HAM6rEBX3bSrDWgAXhS9hCgQzdHPZOFkjAnMIofa4t2SFamu15PWJCmsvRCs0IwAzbeVHRt/liHMwDlZ1HU+xzxpFLbJCbl+4sVIiiay2er1SxkF09oi8wqv3tqB1M4JCKUIjE9/3arf16CY+flQ6ecM0ZU0QBNc4u3+QO2TZunJLkF1avGMK1tTsJckdgsozv9heQos1LV+3dLdOXtYI4zwfaUcMA1PT6mb5o0i2NsrZYRDWULg0YsVwgMNtS6f2pKAJRqxyWzctG4WN737itLMi+qLrf7SUpDUUZSM7aZf3AVLY+n1YTUceqJTea3G+J30X8jqlYE5WApicI9V/Law6r9isjcw7I+hRAfMr7VSLYDRhXjF+MJUsZdH7LC1KTX42lh2JXlNo45ffe8A0tK0I5EPMPIdP1DKswqFTPGVeMp7YruZvlejyPza0kIZCG0yF8RdboSNc
 +VmGPlZ1
 XuAvQ4mURYk1rKbOh4idpkPf8XIvFA1YU6JnoqCDjRZ6FROX7V4cIHymvH1WM7cGpiNWChn4WqY3CSJ+rjRSSOBYFpzdR7tBNBTvOIo12WBj51nCf/tDIUA9wYi8lALnHnhGT09VwfvMXGZYX0n2wRpCipSypo3ZXjQpNycyzlyTozsMbiTlOXml5xs28c6kSzhOL95TBG33mgaJNs6tpV1Ml/XKqwfc5dCsGus6mZ0xzDvp98/y9J11FCLVjEkM1mN81UOtvpPTbNRsDsOfeMNolERALi24ux5x/73pTuM+Z5JF4kEl82Ttzn3len+gZHdlqOvAZPP75g9NGjhAydfvNErBYJalEcMfoFDlU6rqCazdMhP6b+PPifjvV9fCNFJ3mmAJhRnmKy7ViMIjtRR0ta7mvdj1NvCRQ4aXKF2F8yaK8G8Fu9j2T34GzxCwjaKvk4YGMyDK3/VCjGQ8T3BaElxnYA6xSFqCwrmhvPIvLtjeboRYE0Jl/wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

Thanks for taking the time to look at this. Really appreciate the
detailed feedback. Adding Jan and linux-fsdevel to this reply per your
suggestion rather than waiting for the next round.

> Architecturally, we're only hooking into the read path and ignoring
> the page fault path. Was that a deliberate choice?

Yes, deliberate, though I'd frame it as a starting point rather than a
final position. The read path was attractive because hooking there let
NSD observe and build its access-pattern model without adding latency
to the caller's path. The benchmarks I mentioned (18-19% wall-time
reduction, +22.6% throughput) are from that observer-only design. The
page fault path is synchronous and latency-sensitive by nature, so I
was cautious about touching it before the read-path approach had
proven itself.

I don't think it needs to stay excluded, though. A lightweight, sampled
hook (rather than firing on every fault) could let NSD extend its model
to fault-driven access without sitting directly in the fault-critical
path. Happy to prototype that and bring overhead numbers before
proposing it as part of the series.

> It would be nice to replace the existing mechanism of marking folios
> with PG_readahead, if that's possible.

This is the part I want to be most careful about, and I'd like your
read on it. Right now NSD is purely an observer. It never touches
ra_state/file_ra_struct or the PG_readahead flag itself; all actual
page insertion is still delegated to the existing mechanism. That was
a deliberate safety choice: with CONFIG_NSD off, or even with the
module unloaded at runtime, the kernel's readahead behavior is
completely unaffected. There's no state that depends on NSD having
been loaded.

Moving to something that actually drives PG_readahead / the readahead
window would make NSD a lot more useful, but I want to preserve that
same guarantee: the kernel must always be able to fall back to its
native behavior instantly and safely if NSD is removed, even
mid-operation. Before I go down that path I'd like to talk through
where the safest integration point is, whether that's advising the
existing ondemand_readahead() logic rather than replacing it, or
something else you'd suggest.

> It'd be nice to be able to detect backward access patterns as well
> as forward access patterns.

Right now the predictor (Markov chain / frequency-recency based) is
forward-only. It assumes roughly monotonic access. Backward detection
is something I hadn't prioritized yet but agree it's a real gap. Happy
to look at extending the per-inode context tracking to catch reverse
sequential access as a next step.

Let me know which of these you'd want to see first. I could start
with a writeup of the sampled fault-path hook, or with a proposal for
how NSD could advise readahead decisions without owning the state.
Whichever is more useful for moving this forward.

Thanks again,
Ayhan

