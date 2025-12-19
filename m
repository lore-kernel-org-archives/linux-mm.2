Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFABD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB056B00AC; Fri, 19 Dec 2025 12:42:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BBA6B00AD; Fri, 19 Dec 2025 12:42:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B486B00B0; Fri, 19 Dec 2025 12:42:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8D456B00AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:42:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A87DB136434
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:42:28 +0000 (UTC)
X-FDA: 84236939976.26.A21689E
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id C61901C000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:42:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b53bb7RM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766166146; a=rsa-sha256;
	cv=none;
	b=c05SGGKlHRcwcN/2gn3r7MkBDgUkAQF+4jgU5Ttz5Jg/YOimNrNOfsbWF/wTpf3BEtfOiE
	V/OYDj0qGBTpgmPOHO0F5eXKJm60fbu9hhvOsi8tm98DGCcmoOdHCASeD9RI7PO7Fde497
	MqOOyB9elOHJuDuEBq9ivblicAPzGxg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b53bb7RM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766166146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JW8x981xzKG4MFNW1u7R47ZafSPsRMNXeILtwJPy3Eo=;
	b=lpIxCeSOcQJDUlgDhQaLCTtcQaWLXzruTHJbn1YvQZWAItcqkkaPc+dl64tuvg26GRCa8Y
	ox4TeRuhDZ8ArUuzi2RHxi1HVpykvk+yvIi00MH6guqUOeUxiETvAJpO1pBNAE5dzPBPRF
	wJP92TTagyDjeeicAs9pK5sjVnYQwwc=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso1610712a91.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766166146; x=1766770946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JW8x981xzKG4MFNW1u7R47ZafSPsRMNXeILtwJPy3Eo=;
        b=b53bb7RMN14m4/Axo1UF/ZHmxClY3vhdnL7Joym/D9n6tyx0G43KwvILN2+RC9B1aV
         l4cKBe9awPVnolmLOh1j7fkhUdu8s2UJoTxy0Uu92l0yYLFh7lgPlZYlzMWpFJ5FPesI
         8crgIU/9pBLGIUXm98gNxx3d37r0quinNUAyiJ6FAnlO7spMPcMeSRvkstat3h/G+gtU
         e+D6qKJOh6ur6bf3x8Fl7Zr6svtM51Xm2jyFjQz33slWDnxpuIaS+zex9XMBW0ZCmnGZ
         xKs0tiJolS1dRWy+tcT6vBmbREB/ZiIs3Px/UNI0S49qoiF3hzALxqGYut7C5KbiPduk
         F+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766166146; x=1766770946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JW8x981xzKG4MFNW1u7R47ZafSPsRMNXeILtwJPy3Eo=;
        b=Ce8f7kEAkXG/+YGXXigHuLp4roTYWkxT0v6KDQkxcJAK6/euLR1tqEi3j9wsK9d7gb
         TtxU4UQl0wY9DinKixpEYmHi5DR05W9U2gJJpBhQ32mRD82RNZxmVbf72cai1SJ/hj2y
         e1mPryAkEsq1ApX46z6TZTWeBmub1GAHWtchixl5jfwWK7flo20g3oCZ/eKfw42XjCMV
         wXvz26SvTiB88/eNhxhN8Ngzp1RUH+2RIcmfhgziZ1Gu3Kt2rCem6de4N0gUmKseK/OX
         QBsV1zOLAl0zY1Ek3Rf48LneNIiWpubsmWt7iDU4EikZwJlmjgkKq9/Sy9k9rmg1upYH
         qXZA==
X-Forwarded-Encrypted: i=1; AJvYcCW9ebVSkIfIV+s85wob3bdPPYbuWB+ouFSHGc8rbsE3ABNpOpZq73IwfgwYweECngc+wwR9jKV2wQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0/fmvFvWcUWwTMKVDgOnjOSJJOTn4zccVoobOAQlu8+pC4+jE
	VrREWHMzvtoUv5J31s/Sz4ys9MBcNVmxO60llDCYBVH8hUlB/IP2+pLmLPaNiDb0JSkdSC+b5cX
	UgTaR0DxAqZG3KUEJVDCEh0+mPJaWw78=
X-Gm-Gg: AY/fxX6tQycwQ/9yV0F8OPRK9hpTpTj/A6RqZ9X2pRIwuwagTKRNpjdDtvaWmGFTHXQ
	1IF6auUNTQGCgkhQgLCmYEnSOG3U58smQ7aBNOq5e4fK0W0zdhJCiJCaVDwVaNDXDRQCoAyFWko
	EL0ZJGHo4sH4kxzVzBSRHfeTgFF1041e+K3G8HZGnCDSNOofkSfmXsgQmcFExJAzj3i//RdTOff
	5VwgJ+d3nM6VOBdmklMn/oWGLWMPZX8PA9bcgIDpVohOVz5yDhDdq4cLN8Agzo8vK9OQSY=
X-Google-Smtp-Source: AGHT+IHpINJuwfKifBLEq1prr5FrJkIDHltFeoo+6LV09TLdfIop0tuY4u1d1V1PT4Cd13YrZszjS9knwymVFnKkxe8=
X-Received: by 2002:a17:90b:3c8d:b0:34e:6e7d:7e73 with SMTP id
 98e67ed59e1d1-34e71e0910emr5359098a91.11.1766166145554; Fri, 19 Dec 2025
 09:42:25 -0800 (PST)
MIME-Version: 1.0
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org> <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
 <aUTPl35UPcjc66l3@casper.infradead.org> <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
In-Reply-To: <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 19 Dec 2025 09:42:13 -0800
X-Gm-Features: AQt7F2rfNtQWCgEkml7MtGjiHiq38CyNWFSgjhPC7t5q8T4gXasMjJ76tzv38qA
Message-ID: <CAEf4BzY2YYJJsMx8BgkKk7BG67pj52stv_GRGwZkj3jnuipw+Q@mail.gmail.com>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable context
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Shaurya Rane <ssrane_b23@ee.vjti.ac.in>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C61901C000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 4z99ckyqhb738hqw8mgtwq9cwd4prpga
X-Rspam-User: 
X-HE-Tag: 1766166146-23782
X-HE-Meta: U2FsdGVkX19BYVF4wUYGOnlISVxmoQwI8kqEIzQHQIeKrDgrXA5mDcN99ElCEJj7+b290asPZkDecPWjPUI/cVDnwga8Qb/LkjstPf7xJl7oyjk0cHDdtixUCCEx/WOZyvCWwv0LSHbLeGyPtNpO6V7Y7T83mQZrCCAXJWXdnSb5whpxh24BLclsE88OTQBsmrkmnRbZji0Gg8MihyleSPf4ygJEX3dv80xY4koRhop5Ftwyn4EYK3t0HpGhd1e7ZRN84moJwfK9pj7f/4RzrRj1s080WWCpormSmtNbR4kZOLsvaqdZrNkgqGWbo9UwLsPABxNl3AL+rpMOcSgcvQsSG23SCHLjVmM+ZfIJg08YK8sa4NTWY9EFcovQg96lqaqvRTpt/BKWNLaCeiIdTd8fSjbhbGjjskN42NBiKCHKAJMAvXoaQwl8ODGLaW4NTSMxzjvVreuU2/c4U36mZbvnog+Patx3eRCkHTN5jYPkxdeEQYB2kzoqqnxaaQGuzrGwcOvnn+kFQTKCxJckO8C/eGo2X4/neJfT40hzbErLx3LWY88Tk0ZoaFKYmuatAlQqyRWmrno2ZMZr0i9FRZ1/Rtj9HAI/wpgiEzEwJiWyauyEf3UsKm+t90a1QdU5k4YBfljT4MI0A/lxGNQT8uAqOZlS3bdX20+fTu27AsMmyCd+G3eEOspxxIvSICbQWJdGZRTUBTv+hhEuUwLRR6+S0jUk5yErbNxqq2R2cl5Ucn2aNgiBhvMqkh7+iKpR6HQqYmYw+gdDhZueUH1e6emXlFwgVCRqjqaGdu4iFll5jOeRY18REkWHm68ouR/wcqM79p3g3PxMDFWAy/24VSUyw1GL15NRJIAOT5ihsqq4FLKSplfUicEj75I+66m+DH4hnboVeKd1LmUbB1tpZp54zz1QRkV/ZvcMq3NQ86sfiDC2kqA2okbE6D0LI9V6vQpCNPKkyg7tRLAdDaK
 JlgRr74n
 72EfAZDfir4fChtOveRFvMWBS2pYQCAEzYaxpus6E15nCItVKiBDwkk4qZqKS7if+U24HZI8DxaJCWGGtZmmVyXJsWEl/hGrz4FO2stM/EEMj1IsaZOx6+GkgZGR/SHyAY3D91hbWP/Qe3bMSuI5Y0Zppoh6XaLIq0aIzp7w2kTiU9IDNfghDHVWBUFznnLWv94I4LXnDKdh4zF90Mk4tl31iejSWAPJDst45xYWFlg7Q1phHI6cYIkXZIUBh1VCw8hf4mTswMb1BUg1KjuoQMvEPlpIHVDOUQCH39GonxV4v4qHj8w5km8qHXQiEE96b++IwdOMEHvsGR4tWYWsXIqcu8ymBb20M2rZSIbtCWIZN9iiSRiUEfhkJIGDfa/sFslJqGpbLtHwRq3igokEiHWTGCexrBEN4LuMKMYVX2cG565UyARaKzxIBa3sf3sRo9dJbZ5zaUprzPonaa4IN35bHVcxOtrPtUkTqtxwrvGcfxoSpQlPtHW5ru1zDnxnseTtdH9W0/FAplW7ljsSdL0cuug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 9:59=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Dec 19, 2025 at 04:07:51AM +0000, Matthew Wilcox wrote:
> > On Thu, Dec 18, 2025 at 04:16:40PM -0800, Shakeel Butt wrote:
> > > On Thu, Dec 18, 2025 at 11:55:39PM +0000, Matthew Wilcox wrote:
> > > > On Thu, Dec 18, 2025 at 12:55:05PM -0800, Shakeel Butt wrote:
> > > > > +       do {
> > > > > +               ret =3D __kernel_read(r->file, buf, sz, &pos);
> > > > > +               if (ret <=3D 0) {
> > > > > +                       r->err =3D ret ?: -EIO;
> > > > > +                       return NULL;
> > > > > +               }
> > > > > +               buf +=3D ret;
> > > > > +               sz -=3D ret;
> > > > > +       } while (sz > 0);
> > > >
> > > > Why are you doing a loop around __kernel_read()?  eg kernel_read() =
does
> > > > not do a read around __kernel_read().  The callers of kernel_read()
> > > > don't do a loop either.  So what makes you think it needs to have a=
 loop
> > > > around it?
> > >
> > > I am assuming that __kernel_read() can return less data than the
> > > requested. Is that assumption incorrect?
> >
> > I think it can, but I don't think a second call will get any more data.
> > For example, it could hit EOF.  What led you to think that calling it i=
n
> > a loop was the right approach?
>
> I am kind of following the convention of a userspace application doing
> read() syscall i.e. repeatedly call read() until you hit an error or EOF
> in which case 0 will be returned or you successfully read the amount of
> data you want. I am handling negative error and 0 and for 0, I am
> returning -EIO as that would be unexpected end of an ELF file.
>
> Anyways the question is if __kernel_read() returns less amount of data
> than requested, should we return error instead of retrying? I looked
> couple of callers of __kernel_read() & kernel_read(). Some are erroring
> out if received data is less than requested (e.g. big_key_read()) and
> some are calling in the loop (e.g. kernel_read_file()).

From a user perspective, I'd very much appreciate it if I get exactly
the requested amount of bytes from freader_fetch_sync(), so yeah,
let's please keep the loop. It does seem that ret <=3D 0 handling is
correct and should not result in an endless loop.

