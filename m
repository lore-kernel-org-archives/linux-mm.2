Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2970D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1763F6B0089; Mon,  2 Mar 2026 03:20:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162196B008A; Mon,  2 Mar 2026 03:20:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061456B008C; Mon,  2 Mar 2026 03:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E69D46B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:20:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAEAD8CA06
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:20:27 +0000 (UTC)
X-FDA: 84500426094.15.AB75E96
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4FB640014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:20:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTmiF77t;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/MmnzQ+uuC7z+d9fNNTsbHksWzosu4byGDS18oLwgk=;
	b=w0GUP0nX6nr7uw/t4CGGRITpRpFfAkeZF/lw4R6TKfNoiCC8G1ZCGa02SPQ2shc43zFM8+
	cPJtFNsMSJfi/H4HjAQxkSXnVrEMCo2x3HMkG6lml8RtPY4TKXNejkblYZJYzwvmgSAv5J
	qdFa8Grt0xAhspAB8iqXXYl/CNro3ow=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772439625; a=rsa-sha256;
	cv=pass;
	b=A9vx/2ZtyfY/oOVeL/91pX8Sm0M4UNMFl2+8eXKvUPh92InvLBJaVIFynonBYU3u5J7Wi0
	1GiYVxjkkJzWJtDLNIcAetagROuCB74P4DeNDS8wXgSZ7SctCnRxp/IYeWJORqBwmfc6Rf
	ItMXvB1aVAyxC1p2TtkJ1V4zksB2psg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTmiF77t;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb3e0093e3so404521685a.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:20:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772439625; cv=none;
        d=google.com; s=arc-20240605;
        b=iTqeoUSZHW7wF8KnNJ9XOOGFvzS4bw3zEaRxIukoSQY1IoAdENlxigxc4D7jPgr3/q
         Tfvb5Ok80vjT69j9Y2FSbNT/tAEu36L6xOVh4cuJ9xK94vbZNH5ZmXxpy1Jm0dNjwLi4
         4PgjTQaE7xrHXn2SXM7vQe24ZL2X03vKf+bQbG7k1e/jBHXmFNvsJzADDaqeIj8Ad9MU
         +/UuLR2mBhDuUFPU0uENzroF2/Uuid/FszS2h4vhXW/k2KIPKkKcY6D7c1aiUFCmSC/s
         YJGwK3RKi7miRjh8DL1AokFfcyEaBTONBOn+rNc6uf3KA6fG6PrdP/CYUDjJNF9ah2CM
         VA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n/MmnzQ+uuC7z+d9fNNTsbHksWzosu4byGDS18oLwgk=;
        fh=GztdLv8519j1nUK9Cz5Yl0D3oy3Cdxc6zyINdQn5JgA=;
        b=JFJjWmDH+5VqezMFqr93Dw/QtoKSHp7Eb/ekbsck5mt4u/vr0XvNOtyDmAQz5YC1cL
         YErwSzQcfIfuDyb5hNIwGZfqydMZHZRjTny3XF/BbBSUt+RbSjK3ne2Acq4q7lQ2Y9Cx
         ZSoBa8HdV0cWDy0vCdfMOTZzOBYKoIP20Sa8AlFdCFXuLPT1VHsrFEPP7yKogW8aCxYw
         0uTzwgj0icnalkmg6n0Ngq1ALBMPMpqeNFAkyzNb0WzMj05YvBwrdDYHq+kOS+/hB2H1
         rGzQL5cbTCDs3a2f/LVl/KKievYcnF44UFF8wq81tVMNarQBMn1a9OPi4HG84T8ST9BQ
         pgjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772439625; x=1773044425; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/MmnzQ+uuC7z+d9fNNTsbHksWzosu4byGDS18oLwgk=;
        b=GTmiF77tQbppqKV5M6k0a/CDkX8J0AunfMAVkiKB2crHYLsBXOOW7oiwDbSnwOgMaQ
         4TBT4ULv1lk0r43CF3/DCfBzoqRPd5lo0jj5l+UmxgEJ8rVqklvTzcx1jtQLOu5wrNAP
         c/RR9EORVKw3LosKA+iF3IRIXlQrqQOSL4cV4X4zhwff24Hyax3dZUTHUcQ8ESmbGuux
         tBhsl3HsV0T+KKOI2/5RTKsSreAdWWcyl43TxitiO/Ycimsim+2iD/ld4bpKfr2R8w8e
         fMkL4spHblYUV9YGGkQ2v67VlEYAZ69hAIL7rLRWahpUQL6QC8sD0UQQ2HA146NG6xNr
         Zz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772439625; x=1773044425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n/MmnzQ+uuC7z+d9fNNTsbHksWzosu4byGDS18oLwgk=;
        b=OiZkMF8W7ok3sN/E49NN2BlqcsSVMEhvHNavdxQ5ovCTw2wP/YQJFTsmC5rH0SQyYo
         trU97FuF4F+dfOVRqIC7TQu5R++jc01o+rfeF6ckZHRvoExrYNLHlPAnbhRBLKx3G5zr
         R0YwblvQOCwltv13ANwpqRBtMyGWyBEF/6vTAK9Qwe/EcS5bpdaq0g2Wdut4RYrBaFHr
         ZDYDD3TMcaELobRBSAxKMLnALMSZDO/GYXwHO1uMgAa56Qft1vvgEzSlQlEzN0VLvUpC
         9zfbREwYF/6C62f49OrzgZXbgnd3GIm5dEzEB5azJomeHdlfTj3Gc3EEyFRzbypYo3vP
         eZLA==
X-Forwarded-Encrypted: i=1; AJvYcCWWr/0SwVkROlwZNSl84d6Mm4qVYqOsBEy2sJqqe25AA8LIOZOuwC+1qdtKhyC9waUdhqnr14ay2w==@kvack.org
X-Gm-Message-State: AOJu0YwYzxNiKFhymk1zWXc4Z5R1Noqh4N/fQxkYmYpNIHGjCDZimXae
	6g1JXoLHzV5zzWbXAQkUQnr0SjsLDYQIttgjJkh8HBe6ZoGkbb5o8hZugoaLzI2Nr/Tjay/Ayii
	AJgwqJVhCM3rtEPYC4SpvGyNwmj15bDQ=
X-Gm-Gg: ATEYQzykjBFeYse3swtdouOoHNaV8+Ez522oaKT5DAiIE9BsGVCkJ6wJT9c5vtPZGKI
	iX7baThJnolAtCWSzquanTUEGHxBttfYTgjZ7cBAw3t8mkZ7lovVI6AanoIw0eMNdM/fmu0QU9L
	4uTcPZi4W5yUpFInmtPCH/1zERsLbH8WZcfTS3rjlgHig4YJ+rfPM+4sG8fEz6zfa5xIdIJ55Vw
	BHaDPJScr2kVbuAoDX56iYByPetcQCy+nLJDzXNYhuXSBSVo/c+i143KF+yjY2+o/7ppFuVN4M/
	YGMTDw==
X-Received: by 2002:a05:620a:458b:b0:8cb:baea:89c0 with SMTP id
 af79cd13be357-8cbc8da8367mr1334054585a.25.1772439624508; Mon, 02 Mar 2026
 00:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAGsJ_4zAY+1feahcVHhJ0NyKHxFZZHJpey1Qd=FAnSnHhh3Yyg@mail.gmail.com> <CALOAHbCtYoBLbbzX0DU2xuTeDehW__LiJfd16ZrUBG+TijfH_w@mail.gmail.com>
In-Reply-To: <CALOAHbCtYoBLbbzX0DU2xuTeDehW__LiJfd16ZrUBG+TijfH_w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 16:20:13 +0800
X-Gm-Features: AaiRm5243XNSYhMXT2sA0lhvrFw-9VM2oeEvbeF59YP5pBeK27c2JH9dkBT4sLc
Message-ID: <CAGsJ_4yR8_xr_XL5Fnemn27tc4GO7Y6bw2t8Bkw5r5StzD8ZqQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jykipa7dao8anseauiubxf5wamokjoeq
X-Rspam-User: 
X-Rspamd-Queue-Id: B4FB640014
X-Rspamd-Server: rspam12
X-HE-Tag: 1772439625-126109
X-HE-Meta: U2FsdGVkX1+WnWEZj6XnlfGwdQJXkkSjq+y7P/t5wMfGrqJFCshIUTIcmlukEz8r4fY8YgNEBxaQQrVCJArmLh6htOZzr2cwlWEfPEwh2FLQqg7Vvc2WvumjhIHUj2ZOt7tzWmd9c6uRw5kCvtruC6kN9NzTe9PxHb0oinGA190Hpu4KONki0t/mg817OemJSFxzegy6V+3jtEUUpfEmnR0SZZtLax01SCW3pgkKAbhnzhVQx+/TC0Br4rJjY5mZ83GszIJeXTuDBRWgbjFzZPTJiHilMvIA70aoHrHXFMSHGp/MfeGWCISymwIrYH2JLFO4wQqMiChAwC6tsIvk3zSj5+WYoc/nRoUWBhrKAXgNrhVNuL056Zyah9eprF0UT8h0JbZi+hOMTvQaz8/dnbcGplVcMz68rvox0DD6WR564pqRuesYX3R+OwXor6mpO6sDq98/WJY9FcA9UzkOEMJ2k93NMxRzyYKb5wpmyphhnMSp748dSpgD7AVyz5Xnf1gOIMGgpXuSFvagM2S7Na5Lxi27bFipoRIsej/iQtpoM2NzwppZX+MMYWxWyz5tvoixTpgQK0312cj9Mq9H3JmPS5BPqdUTsE6+xch+z1POIt/FkkCuoFfkZsH6K+Zvu7mfPsSOg29cMOsS4fRffIh+njUAyX78T4En8vsP2U8BZF6MxM2kmmlVe83WhHtuQZWV0nxUN3Xd5B3EQ8Cr1Bgl6v6c22qHMf9kuIJwb/2hr3R/mVWDgNT5IWuRA39BFLd0bVF+/JyHf+BVZRGdxk8Nq/no7kUhKYbAkO9axfx6uubovbc/jX1FyYx83GdIPhGXUCco2/3gZUU6+T1x0P+8qwpN6Q+s9rXgPIwIxPQDQlCGabnGNus4UVhoG+zqzdyXgNyUTgQoWt4VNeCjsHtj8q64HzX0hgmUevNr8hW3nSdwyfqZCd+a+DuM/DouXIk/bZklqxnHYdfa2jQ
 W2W9TUbJ
 zRDnxRKbG9V2ZRrt72rEBLRt6GEvKoPtsJq96U+7IZLw8qRUMd55Hy+1bmpxmjB773uDS4QkRmBkvWLJW1dLPT0I0oYVbaU97Kwxs8TSBIVgtXuC1YYewVYgBCgOrkXs8kezf6KUgZpk0kvGAxx5NzaVfMv5IyfLznUZqwQUZTxuY+m2HwCXDGXeggWmf+7M580Kj3GFYRXJ89VBxa77zX0z6Bz8/zHYuTTFe+nUOaObvs6fuVISHJxez97Orij1UlpFBGw6XKSC5dv0K+1a9yRqbmjuukBM2C0bYlBF+sHk8vxN/0/J1Fx05rx6F5y8WmbasJz3mD3lzd+BF+RSAmpU3PCTyriGi0xyNlNSNwGjV2vCZgFgIxNYDKBPc9CKkgQpcrLc2wXWVeOAQQ/gSOqewEPaPwNofwhqPe/kFqZtZ/zoSSuUVQVxGrEpAPVIDtq+Qo1gMZGGm0kOy3aK5TenyzE5bQ038+3rS2EJC6gFfqSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:14=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
[...]
> > > > If we want a per-workload LRU, this could be a good
> > > > place for eBPF to hook into folio enqueue, dequeue,
> > > > and scanning. There is a project related to this [1][2].
> > > >
> > > > // Policy function hooks
> > > > struct cache_ext_ops {
> > > >        s32 (*policy_init)(struct mem_cgroup *memcg);
> > > >        // Propose folios to evict
> > > >        void (*evict_folios)(struct eviction_ctx *ctx,
> > > >                  struct mem_cgroup *memcg);
> > > >        void (*folio_added)(struct folio *folio);
> > > >        void (*folio_accessed)(struct folio *folio);
> > > >        // Folio was removed: clean up metadata
> > > >        void (*folio_removed)(struct folio *folio);
> > > >        char name[CACHE_EXT_OPS_NAME_LEN];
> > > > };
> > > >
> > > > However, we would need a very strong and convincing
> > > > user case to justify it.
> > >
> > > Thanks for the info.
> > > We're actually already running a BPF-based reclaimer in production,
> > > but we don't have immediate plans to upstream or propose it just yet.
> >
> > I know you are always far ahead of everyone else. I=E2=80=99m looking f=
orward
> > to seeing your code and use cases when you are ready.
>
> Don't say it that way, that is not cooperative.
> We've only deployed a limited BPF-based memcg async reclaimer
> internally, and it is currently scoped to our own workloads.
>

Don=E2=80=99t be so sensitive:-) When I say you are far ahead, that=E2=80=
=99s exactly
what I mean. I truly admire your work on making LRU programmable.
That=E2=80=99s all.

I understand that you have only deployed a limited BPF-based case,
so you need more time before sharing it. I am not criticizing you for
not sharing it yet. Please don=E2=80=99t misunderstand me.

Best Regards
Barry

