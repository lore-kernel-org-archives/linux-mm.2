Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3966D12662
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 17:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40496B0027; Tue,  2 Dec 2025 12:53:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18E96B0028; Tue,  2 Dec 2025 12:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955B06B0029; Tue,  2 Dec 2025 12:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858DF6B0027
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:53:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B23A9C0258
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:53:28 +0000 (UTC)
X-FDA: 84175278096.25.BB34417
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id B9BA58000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:53:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzBRdJCN;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764698006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6jsZrBPDcS/UOD+OkMyFY/e+taiTAsFgh+Yy3cAx40=;
	b=mW8r95hUXxT92vrRqH15L+zME9bMwxUq6f4wu4sQF5ycowsyPOzy/OHGJv1f6wNZESPPMb
	U7oZ3gVFI1hi3rI6WF7moRZsX5vGiTCNgckKpovjqNVMj7VwqA7do4eOv/QMwrZJZY0RUt
	hKtuEIIZxEWsA0PMPfmFsRnwwydZ0wc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764698006; a=rsa-sha256;
	cv=none;
	b=NriPnf4HZmyAslPcvsmT8UtEq7L4px001WEJME3gY1aDrXYmmmqdO81ZB4GdXJknQRQk1d
	yIH6Qz9aIEtLxKCulemXSaKVyLjiqiDhdsgMK7wry+OgAWLOHpVA99r/Xr/2LL6J6zl49V
	JHyH3TdVwanKZmExuprpQNchb2QnBR0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzBRdJCN;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so3638183f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 09:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764698005; x=1765302805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6jsZrBPDcS/UOD+OkMyFY/e+taiTAsFgh+Yy3cAx40=;
        b=BzBRdJCNWVQQ22VMeORzFYnxGIrnjcGyOlmOcd+n7CobfAFvnA+Cy4OAzDDuVxlT8K
         8NFSWWhEGPnLRBXguT3ujS9znPMXsmRVFp41ei3HsiQGz7QZd1Ji8sMpVMAovJbyTaob
         VpwN5WB9YXPzOsp2XCgs60YrUUrgDnOJxnXNb4MDqe8ZMMtfMhoawSvlAWtHIfnWTOJV
         wz/aNGVlxr8qlvIP5Zr229/CRr6w7UYxsHCFZhX+r9OdU4vvv72OhnR0U1z9LLMOnS9+
         4CJK1PtcvsZUKkJeMaxw/AiL/73cENDKWC6yEk6mM6iTm3MubjF69pq8dlaFnBNFg1HM
         rxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764698005; x=1765302805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6jsZrBPDcS/UOD+OkMyFY/e+taiTAsFgh+Yy3cAx40=;
        b=YHvQsrIACbZUjVdkMagk+soh4iqVm6uvWPpWaIeWZGv5cSBPMFEjATgelz3LsvkY06
         WVKKhv3HzYbbdtJihG5rqNTf0+JRpMUiH1EFkUyALlItTxXhs4tuXwS1MJXNTldaXXVw
         wfhPHQ33beW3JjhQFm953dgkDaBEvijzFPNLoTC4g/QK4Zzd8mBmlZSOmiYtzu77k66M
         p9x5oH0hq775s0gstHfAm+djpb3przdTX1xAEO1hbEkSf4ChlGhjzkw2X28F1dVYZj9O
         F5dkiVtcP4U6/0ir4KI9q43+Y990i3dtiOoHYkpEaG1MHKYDCDDmCKqkkPvf/40XckI9
         ZnWA==
X-Forwarded-Encrypted: i=1; AJvYcCU/UIiMKVPmwZodjG7Ibl++lir05ASK6nMhu4lMEkCTp+6UvxsmbhN71QAZvGWjIRz3mMq0NcRMGA==@kvack.org
X-Gm-Message-State: AOJu0Yyiq1dTbcQwLEg9eMd0JvyTfolXzgaxTZRL7nTxH0k+4MjRXOSl
	zpauYkpvVe8MuiWxK4iRH/3OBMeXqRfJcsjn35aivINtHknEC5SYxTiGYNMX27455UGbXsCKa1k
	qQjM4BEDIuO7/tx97uXoZ/SG9ZA4tKXY=
X-Gm-Gg: ASbGncuomGNnlmcwPd28j3oYE5nsxYAcToGklOEW21OaABNnTpuypMZAGAdbd87rGCI
	m3l0Af+uvVva4x0M3erq3n794ITVBS1UEsu3MIjDZg51y2fHeCvUS1XpKvcUUllAyyKDYL4dQjX
	Yl49ye/OW0Y54CjGbDDnNGHxIgu2wi62K+rzeyFwn0nHee+RWX3cGDFfWb2jCt4BFQirvids8ZI
	93KRorNUaJN7C8LoqsnHXpAB6qCBVeZtdenX8cuvRHKWeaNCtCRRfABfBnCF+LOTZOcJL8=
X-Google-Smtp-Source: AGHT+IFrgraba3BCEhhUVQOm0wFpmC6g4rgeZvXRe1qP1GI+ppgAe/IgJJ1pyBRsVvvYFlKkMWbUF996rHyZe/8mb20=
X-Received: by 2002:a5d:4251:0:b0:42c:b8fd:21b3 with SMTP id
 ffacd0b85a97d-42e0f362440mr24724906f8f.57.1764698004929; Tue, 02 Dec 2025
 09:53:24 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
 <CAGsJ_4xZPPE3TaAYU96srZKe6aKZmV743kQ97E48ZWh3BQ5Z6Q@mail.gmail.com> <aS6H1b4MHo9HAPHS@MiWiFi-R3L-srv>
In-Reply-To: <aS6H1b4MHo9HAPHS@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 2 Dec 2025 09:53:13 -0800
X-Gm-Features: AWmQ_bmHMWSj5VXsGCPrAdDQEP8zUtPFVMFzmBda33lG2DysSjjJwm0gszGE8Uc
Message-ID: <CAKEwX=PUW_sbN-GQXAh3NHGGuN8LOSFy_8qWRUUqafgwW4JB_A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B9BA58000D
X-Stat-Signature: 3ytc55sragx168tcuja18p4bdwydykup
X-HE-Tag: 1764698006-356573
X-HE-Meta: U2FsdGVkX1/POz4Ib1RsNp4EAVpmlsUwaDil8BCLscuPNHwMDPDi0ykE0IVxNcSlOD3019tIH9mu9VIj6Oue7U0PZ30SH4uexhTSdHaEsOS9vLFXU5CgOAqltPGaW2vLYRfwTH9SS9jUxRU38kAkaciUQtvkA9zVf9C5z5F+QvDtbshBESfCotZ8Rg7adXpKvLjz6/gZvKTkiUT5+WV5X/RMWFDRW5uvc6vvAPhEXNex0jWN9OpH/eFKf2Mfw8NBZ7C30RLWngG2ozcaE/CK4TPc5QiwhJ6VHzyN2UnKojEox7wXTenXVJSaX26QDd/TBvaGN9qkPdsdcmVwcFKfPRR+T8+CnpI9NN5dQ5h+P5SHVY9XDabovmPgDjN+f61p6dcpCz5wamTKzZwoun9IOZyih4iMgaXu1BCnNkLy3xFhwNHe5np77cQV7WRfppYLawro6pfnslVqsw2yFYKhONqCExtvZ2+B52YtJt0OOrNzjpGdef40RYKCWXwHpCBxH+p5fHUvbjm1gac7M+d3ahm1a93M+KJSXExf0jbRLAbQIBYKiTfecEZ5lUzI6D9XKUCakwtrvlQ1sMXWz1pBnhLHaBOJsa0Mudpdwaxgquk2jA0TkLj0rSFo0vEsMLvwR7tsqor8ElxIMxnvxh6ogGgXlWqDD60o4M67VLsfkqjnqgB1FiMSF+IsRl4kpP3xvJmUdObS/oTfOYQLDzWbvjXfaqLIz0AcRKfSmg2acJR6Y/+OhABCZbYLnx9c6ruKDqZbM/gdyuO9t/yuDgb+mir5QpqRJUdfMmkQ4X3p6www7z0ifB3z9cZh1f8PSDtyVDS4YF3JSZaOfokm7U6HXjyVzbzkcLeoXEf32QnPwCUeBVSXdyBH0GD9nLWCuhkPmdRpGQ6feTz2GSCc+pTJOl48tDz+zZL1rlYU0aM6gf6WXBFcW0FXwp4nWoyWgYMltyyd7UH0O46/jyzRMGs
 rdeY3Lbg
 GyKa3n2+cFZMy605Ca02zfRJpI8zRBLCRIm+yPQNd9SGwNTQ1BPLBaCugA85E81At0WpSGdu+/27RyWfYL3O+nMg0igPCwi8g4Rn//jzTTJjdxQEOB6Zkw+2wxVewqmUM/uJy3aZTu0BXuyss0R7MiAiq3QFhLwQrIpi93eju/87xVd9E9UrkEf8J1uqWIrXS6K/SMYOUGGqXmeT0s5C4or9yyAg0TgewLD9hQYn8jq+CTZWv4gTwDxr58DJmxdKfW33LFbBQ12voWG5Occ1cU3fV7C8j40B1sXVJ6VEgXIHZrh0rNLrdfPvjiFMmnaosbNJISKhJa+z7dg/gxowpQZ4jbEVoyvefTEgqc9+N0C7ARAzfQbAguVPZ8YzDWn2+m2m8+k4gNRmYJmhYiL4xJAk7n3oD6y7tZbD0JFMcM5PX9EE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 10:32=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/02/25 at 10:56am, Barry Song wrote:
> > On Sat, Nov 22, 2025 at 6:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> > > >
> > > > The current zswap requires a backing swapfile. The swap slot used
> > > > by zswap is not able to be used by the swapfile. That waste swapfil=
e
> > > > space.
> > > >
> > > > The ghost swapfile is a swapfile that only contains the swapfile he=
ader
> > > > for zswap. The swapfile header indicate the size of the swapfile. T=
here
> > > > is no swap data section in the ghost swapfile, therefore, no waste =
of
> > > > swapfile space.  As such, any write to a ghost swapfile will fail. =
To
> > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > swap_info_struct is set to NULL. Ghost swapfile will also set the S=
SD
> > > > flag because there is no rotation disk access when using zswap.
> > > >
> > > > The zswap write back has been disabled if all swapfiles in the syst=
em
> > > > are ghost swap files.
> > >
> > > Thanks for sharing this, I've been hearing about the ghost swapfile
> > > design for a long time, glad to see it finally got posted.
> > >
> > > >
> > > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > > ---
> > > >  include/linux/swap.h |  2 ++
> > > >  mm/page_io.c         | 18 +++++++++++++++---
> > > >  mm/swap.h            |  2 +-
> > > >  mm/swap_state.c      |  7 +++++++
> > > >  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++---=
--
> > > >  mm/zswap.c           | 17 +++++++++++------
> > > >  6 files changed, 73 insertions(+), 15 deletions(-)
> > >
> > > In general I think this aligns quite well with what I had in mind and
> > > an idea that was mention during LSFMM this year (the 3rd one in the
> > > "Issues" part, it wasn't clearly described in the cover letter, more
> > > details in the slides):
> > > https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGB=
nfisCAb8VA@mail.gmail.com/
> > >
> > > The good part is that we will reuse everything we have with the
> > > current swap stack, and stay optional. Everything is a swap device, n=
o
> > > special layers required. All other features will be available in a
> > > cleaner way.
> > >
> > > And /etc/fstab just works the same way for the ghost swapfile.
> >
> > Apologies =E2=80=94 let me raise a question that may be annoying.
> > I understand that people may already be feeling tense and sensitive.
> >
> > Despite the benefit of compatibility with /etc/fstab, we still need to =
provide
> > a physical file on disk (or elsewhere), even if it contains only a head=
er.
> > Personally, this feels a bit odd to me. Is it possible to avoid having =
a
> > =E2=80=9Cghost=E2=80=9D swap file altogether and instead implement all =
"ghost" functionality
> > entirely within the kernel? Ideally, we wouldn=E2=80=99t need to introd=
uce a new
> > =E2=80=9Cghost=E2=80=9D concept to users at all.
> >
> > In short, we provide the functionality of a ghost swap file without act=
ually
> > having any file or =E2=80=9Cghost=E2=80=9D at all.
>
> That's actually what I would like to see. Just to make that we may need
> change syscall swapon, to specify the flag to mark it and initial size.
> People may complain about adjustment in syscall swapon.

Yeah that's another design goal with virtual swap - minimizing the
operational overhead.

With my design/RFC, all you need to do is:

1. Enable zswap at the host level (/sys/module/zswap/parameters/enabled).

2. Enable zswap at the cgroup level, through memory.zswap.max (you can
also size per-cgroup zswap limit here, if you so choose).

and it *just works*. Out of the box. No need to create a new swapfile,
/etc/fstab, etc.

If you're unsure about your workload's actual zswap usage, you can
keep it unlimited too - it will just grows and shrinks with memory
usage dynamics.

One design for every host type and workload characteristics
(workingset, memory access patterns, memory compressibility).

