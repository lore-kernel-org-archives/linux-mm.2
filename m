Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A64CD6E55
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 21:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3903B6B0188; Sun, 31 May 2026 17:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3197F6B0189; Sun, 31 May 2026 17:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E09F6B018A; Sun, 31 May 2026 17:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 059A36B0188
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:21:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48F0F403F5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:21:46 +0000 (UTC)
X-FDA: 84828987012.18.02E2238
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B4554000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:21:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xxeqz5tV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780262504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
	b=MGxHz9GMDElLs052t7FDMW/ZdDhPZ6sdp46+MHzQRMxsllCKrkBMrWuWEswPXeC26sLgak
	cZxreiioh9OoKFVEWL+8entQgn7AlaoyRrrEXh5mTDHfvcl3BiUdFyx3a7NFO8ozkBH1+m
	Y6FLzpsVtv0FMhndoyftnyMRBYl4W18=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xxeqz5tV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780262504; a=rsa-sha256;
	cv=pass;
	b=RFZEZ7dPcXfBu4LMaJPtuKbd50WUONAbONL11hINy7BAtN4UGRQczG/sDmo5fnygrsyPJJ
	mpop7LVO4pLiQRf3FzWHSmQGwsv4hjJXIbgf4QuDbmDw8XMy6bTWZvzqTwIMad7J0WiAeS
	FbNpiqWABuJ26lxDA00GkY71X5bfJ/s=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-68b73f1a8ebso5490093a12.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 14:21:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780262503; cv=none;
        d=google.com; s=arc-20240605;
        b=hX7yKoTPvH23qfrnbCR681ihVOjs/6A1V8Rm//A1bNYEBSfheWEHMTKd5MPL18SlZh
         Mkt2RAfKHqs/zwYCdNLkhOKy+ToS4o0zLERN4WfZMZcfe6AsPgH3pBcxe/gklctAy34W
         lNHv0N/GrNYXkamS4LrrvIHeHdd8Z9t7zcSZyFzGQ6y55xur27h6NxVLAQqYUWLs91GL
         nRPma091NtD+gYHd7Owi8gyPWfbgsLBzFi4ULnmy79+ZvgKIsNm05TaL8mn3e1DCzCiE
         44x/OzrvykBg2GSvvb8iILR8eEBJftSD+lC9IvQZ98fV1MaZOq9otop0mIBvSUtek9Y9
         cGIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        fh=v4VNdVskbyb3d2uK5Q1uKnX2Z0tfWYqfewsPi1rDFWA=;
        b=QMCE1yJBL9606pNrXoiqccxRKLTHxtzDkK7ilpK0M1itQCaIcM+1bwcYYzS+vsjNXt
         QF5JOO8YqZ9e1IN+9tBh53CZ2kLJuHELutntz9V9mmkhDXnmWccC9InX/dqs/ITYLNOs
         zIMtH5pVWTcyd/NOyQGk0fi8CUPZ9tQW9ib1oDBNXDM4cHGEgAeNjSR5prCNJt1dJLjR
         5XsFMLSYg/5tqvW0r/YZjk0liLYGT9/MIPP52OYOB1TRP5RaR+4HUMdDc+wnmRxNjZlV
         jDNQ3d5LFFl++fLWHXXgkR/Obb/F/giTJLv6ljHTvSHZDve6FBBEVEZtxBJh8aFwc01m
         f8EA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780262503; x=1780867303; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        b=Xxeqz5tVJxKb8u7BjwlOEcstGkIIuioG4TYC8vrS4UdAd1Hpucg08NXPXzStA2/4Xq
         TyXOnklUWZyAK836Veua7Qcodbf6kAYb/xGSBzbV/njcJwJl3bCIdwLESzO4Q56dnxMe
         y/IZelFp1MqZhj7AMxFon+YZROJNT/nUMlTNbV7ccm0LqjYppSEXQV0jgiin6yjfIMVO
         yK62RKNLXu+y0SPTQfueq3NvunM5+Sh4F4jKSfyrYjAO4fTkH7Bz7z/gUXvSk7xuAM5V
         xW5wrnp/aZR+WW2+Q1PBh/TuaJvln4tUYdfm2PHYuvKUcT1S9pofCiahGv6GtiTS75uR
         Q67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780262503; x=1780867303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        b=Br28+SRChBcus2+VIy6H5GBwO4Ldi6F8P/Df/2k1xxEfBaH4gHUwfn2imPeY9uGSfA
         r7w1MPAVS1p99ErMuzc41k9Y3NdcUw+JRPlgqlpa6YszwPNBTW1jDBq4yurU+iWABbkn
         J8UBADutzMJlH+/PNUos/7Hz1r8NSiOeyGt2mx/4zF9/fjAR09+pkapAdPRvBaVx2YRm
         EjwH85FRF4HzOMXEJVHEM21RPM/N5170eo29aQJmSlqgru1nE78ONhW2Cmn1I21UVLoQ
         6qEFvs6vVEM5vzno+2t0bqrtw8CkAR4ZjcR1ULzzcx/hqyJznucwPJygaSkK0jnpCnrs
         Iuhg==
X-Forwarded-Encrypted: i=1; AFNElJ/U8XGRZaUvxrAoLQ1B80j6vQw35zxT204AtlEiwF1DifkjajQlEsgg6GIwVUCoO/askq5MqsC+yg==@kvack.org
X-Gm-Message-State: AOJu0YzgI5qkVWa25Dvo55qBGl+4BrRJZZdx5LcAVwVC1+UM1i8nj+IA
	EmeZs1QRiQwwfq2k+0vZRDBTt+gMaLTLlbHvQianUFDC8JCpXVCHZJeg/uhQEyDb7JU4+mKCWAb
	vWx4xzO2pEhQGSdVcLxQ2iaRicTCTees=
X-Gm-Gg: Acq92OGRPz60GTeWs/O4pQMSKsZifK5N3bT+y8kPUg9CCVeGjvSzIqq615bZ1fyCqrK
	xZLUx3NrKBFfX3O9OSeftLnVCMvMOn1KsEwGzSUmyNMT44QtJ++UyNfO5qI6GpC5tcxK/bLDUYh
	xzLwPv+X4GWCgYWnhfCJP2jMWqMLXBANG23xWdLwY0qWv6FDE8ZQHIa+CKLS0hjn+Qmh/fJAG9d
	q/VXgpMhSQlt/A0ZpbUGLBKofjjCgaOEdzkqLWBSyMzhxvaFNjKy/SzH1Qmojy8rkRhqjOQc+T0
	MAfogz3rEYxCi99Fuzj049wQIxaN
X-Received: by 2002:a17:907:d02:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-beab4339068mr455362966b.20.1780262502221; Sun, 31 May 2026
 14:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <ahv16ogY8Zx3Rtox@pedro-suse.lan>
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 1 Jun 2026 00:21:06 +0300
X-Gm-Features: AVHnY4IV40jpJJDRQFbdKVprCBGPqL0nWYb_1HSlt6FzSI1F6gq0u1bXknLpLA8
Message-ID: <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B4554000B
X-Stat-Signature: dehitbw38u4twjwdysfrfg3ozq4yzf63
X-Rspam-User: 
X-HE-Tag: 1780262504-597652
X-HE-Meta: U2FsdGVkX180c5/8SDatq+enHZtRpALUGuBJlLtIwFsIXildsgj+c06A8LUDW+MYOOkX5Dwdws3Ak6LDks5OsECxWmlIqm4sqHIm3Nj0ize7/4the64iUdeIx4nB7HBM4FbQyya8RjRQgNMzyvG8I1s4uzkbjJPIGv68gX/qacFplCAW4/mUOWCWXvk5uG94BKXqg5i3Dro7rT64pm35RIs4IVP6Vw/HbjMhW/oeF3cLxkmUgWFqpZ7A8JCKxg/i+KBbwF/0nvi5hriz2OGSSyib6TN63w69zHqSd6GK+hX6Tzp4i8IjOuwUkFuhGQGzwiONmKYhe+FqTs9Lk8GMQ2AKCHgeqYP574tMDcF7djf54YocVN6o0zDrGSjJfC3QiCA5krvBbHTMYyDZDvxaGnHlPLESkXoXepiK3DgyJbSBsnZ3hxDNr9+DCEGa+C2yuv7BlDCj2n8xhWymi12T07BI7/ppjJ2TRKumsQx30cxH5Lr/Hzp2zEVyTtHNd8wxPlxTveSGTEhhyEhDTR6VVOX7JgR0o88+qiI5ZzPDpc4SOMIHl7sRHfLljf00bEPly26IYLfgSbSNhwG2O+pYOh/6evTqpBIGjr0yKv59C91v4MV3sydqh5IsLwVHMO0Cs01LoOzRdNam2FBIV1eOobTRzCFThgggpltggAYahFHkewMIElfDdYnp0rksg5/uP1iN4WNdR4nnqUyUBE2NSwTqC1MN0ioDVljoY36Y1H4s+GqoSYWcnSmm4LftNObxnbt44kK58gu7SAAFZCIpshjCCyIqykDqfaXFiAHqRQ2NbkI5FXoKiy0m4wIW17xUAhLESuYYPvzG6YxLCxu79vI5iY3uElkVgsQJFuT4ErzKBKeMhZkpajJDIfeRVufpopwYcitgnViekdko1rRP1ModKOp9/eSTB8Cbb9VuzkE07k/yNnsvumVgxe4/gYQ2KLlHXve9J3PMGOpEBq+
 YTq3fd3l
 c9CUxabpXXrWdOpetjGuy0v2syZzel3XJnE1ftZQ7qPKoFGP4giLAUf8Osgo0qkYwQDbZMpkVIPpcEWAvg6M6I3YSuCdgoWv0jiDYrxFYWzliEshv5k5QMXWM8WQ4PmqebX1a8ZYA/V7WOvovUnvEZwXE2jBnc3XDdT//3J+gSuPRzAPeWv1qcybRUjDialLZTupFahkyHbVArRJ04V09uzNNdz4emtlLmuaJArAZjD7jcAsToh2hvmEMOwFeoQNPdPn5kZyMSX5WgIckdHgxDV0LevX3cnr+jZh4EcbVtW8egac5BHrQhx7ipNd81Vl73KQDtXElYF9FaW52Ix1sKi/VZ928xN8dW+crTolKs61GujFC0MP9z0ARxYXg2B0MxvibYsY9cDKA076ZYe8pFUgxRTGNl/PLI4akwjdaBW0oLtc780c59xGhckMSMTHtcw0HCFQF+AMl3OLIQDxXxdWkSli55ceM6GLo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 11:54=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> w=
rote:
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patc=
hset.

Yes. But I propose an alternative solution to this problem.

Brauner said in discussion for your patchset:
"So I'm not very likely to pick this up as is".
So, I decided to submit another solution.

Pedro, I'm not trying to insult you.

Other kernel developers will decide which of these two solutions they like =
more.

Many people in discussion of your patchset said how they
dislike splice/vmsplice, and especially vmsplice.
Hellwig said "vmsplice is the worst".
Brauner, Hellwig, Horn said that they dislike vmsplice.
They said that vmsplice in its current form should not
be used, and that it is broken.

Despite all these problems nobody managed to fix
vmsplice in all these years.
So I propose just to effectively remove it.

You may think that I just saw a recent discussion and decided
to jump in. No. splice/vmsplice is my topic of interest for many
years. You can verify this by searching "f:Askar splice"
on lore.kernel.org . I simply decided that given
recent vulnerabilities now is the perfect time to solve
all these vmsplice problems once and for all.

I explained my position here:
https://lore.kernel.org/all/20260523204100.553125-1-safinaskar@gmail.com/ .
Nobody answered, so I just posted this patchset.

If my patchset is applied, then I will try to deal
with splice-pagecache-to-pipe somehow,
probably by removing it, too. :) I decided first
to deal with vmsplice, because it seems to be
easier problem.

> > vmsplice(fd, vec, vlen, vmsplice_flags) will
> > be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
> > readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
> > writable pipe.
>
> This does not work. https://codesearch.debian.net/search?q=3Dvmsplice%28&=
literal=3D1
> There are users.

Yes, they are. But my solution is compatible. vmsplice is simply performanc=
e
optimization. vmsplice will work just as before, but slower.
And, most importantly, vmsplice design problems will be gone
(nobody managed to fix them anyway for all these years).

--=20
Askar Safin

