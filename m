Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835E0C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597756B007B; Wed,  5 Aug 2026 11:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548BC6B0088; Wed,  5 Aug 2026 11:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4374E6B008A; Wed,  5 Aug 2026 11:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F74C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:31:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99B71804CB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:31:30 +0000 (UTC)
X-FDA: 85067605140.10.6653C77
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADCD61A0004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:31:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DW+C9VUn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785943888;
	b=nbD9xQAex2MOLhLyl/8+GboqPVcBLZzKMhnxoQ7/0ZNkRaoHsJiqQsA+IjnPv4hQlvzYv/
	cbOw2mN1R8m4rim/3rtI+TE8uIa+1H3edD1umIQvak/m8GO7HDajYrFvYMI2ZPeRJFwrge
	6TKdykFQnr5IB3emc5Q7nY/Tnh68aVo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DW+C9VUn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785943888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WopFs36fjBNe4p827wx+9JX7Lwtk8JPVIwqGHdzA5zc=;
	b=wSbtXKukGeHs20H8uTG34gu8lWqIFDvI9s468JaNcM0iMFxoXnscR7G0rA5X3/bUlW1dVC
	eoRILbvK84yqwwQiGj7W4YuJfHdUHVOJuG0GUTn6f5jtGVtbPFfnUfNThG+OsOFwhdx459
	KXyKXq3ttyacWf4bC4C3zqnh3r0CyI4=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6ae5baaef5dso859555eaf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 08:31:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785943887; cv=none;
        d=google.com; s=arc-20260327;
        b=T25L4ZfJAMWIYfT44CJ0EduBzXKYxDU1eknEL2fkfxBIIs0/ArfF3J7TZacP+/tPQ7
         OyEWptA3bkE0NtCulV3JWF4mWjH1RF/Axg7nc2KGDC1kaRqkhbIecfidH5n9kF2lpmON
         g6TXHrpGhGFZoVtsetYDooxOKsLfnaUm5Jd7wIkjcQr+fS4BAtxbAemi28KhKIRZkRkj
         Q7qe7V58Ayg+ERdGT6f4HikPa+BKsI9BbMrCsN6I6+IlEwgxlZ6nUMt6/fAzv/TNbnto
         aQYjiiHdE3w9zM8uU4L3fTtyLuST8FG1TnLVxmvdAjoxX9FYWIoVgJjY8V5dGqiJeU7g
         Pqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WopFs36fjBNe4p827wx+9JX7Lwtk8JPVIwqGHdzA5zc=;
        fh=4ZFeHlwF4YA8Wle8uJLZ0Ya2oYw1ekGhfe7ntP3HxYo=;
        b=MUhcArQGZWWY/vaP2HBk/Osd0+NLWDliM/qp0Fop0Rq5wnFrTu5sYwuBoMJ1UR5SME
         IbDl7oj66fDRTlY16WTfUx/H1M2l2Kgc1slN05K+FEC8FoEzHRirMP9F78wWfDmQfsXY
         mZsu8lN3J5EzQditFK0HymgxN2ZwVCfpAzs+7CQkYNVBtighlkHdy/BUdOjp9wYCjxlM
         j5gd76C16teuSZ0r4rT5gpl/dk2M4i1Z/rgvKPD2l/dfatB9mgYRMirlBppk2qd5fyQR
         8e8vgJEPSiXsh3OC9WgG9gChWhLhL50/kjysypv0Syxq1oU+0C4QNSomSpn/CpNpfJNx
         58YQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785943887; x=1786548687; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WopFs36fjBNe4p827wx+9JX7Lwtk8JPVIwqGHdzA5zc=;
        b=DW+C9VUn1yDZOQVQWgYbuPFS3spRGkX18bUfqDJvNy5K91BlkWYSk4xHWSFL/uDghF
         FpCju4LkTCD5GhYczD9PL4KH8vMd6+N7zNG6H40yAUXUEUcdblR80eSb0gFDXsH7g40T
         58DLnWHn4CnhzH7di2CIhs01nLS21VUx4nr3oepCQXspuRov3lfuzg+n4FDz4BXjzjVH
         zGAaKad5IeNkEeE68PizdOUqS89IsboIGLpwij7bBFOlN4jdtoJSof9agzDonXv2hl3w
         uih1RM7z5LLfndDYdrZEjFaM0nI+0aBSGr6ruWJJZ2dYCsrJNLn8r/QwUI8kF3894srV
         HgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785943887; x=1786548687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WopFs36fjBNe4p827wx+9JX7Lwtk8JPVIwqGHdzA5zc=;
        b=Fz5OpGU/+d0wCSmc5BCoH1d8JZN/2NkQz2sQVTq79ybu8bM9jL3wMTymIcutWK/OzD
         GGFMjrWUunncn2LXVK4mJgy7B0A3MZHz2Ov0KZYdnjKsne074njfzbInLwksvbRWgAoQ
         pfcWD4Skq83XSGbKkubUhGAy7Ut0Bs9uVQL62COVYtawybhRFfobsz563DmDWMXJIFl1
         RWM5Gp4QkMOjdyBkp+h6vV5Kua4Bl4di+MjeAxJ38MzgHLu0UdP4gXhhYdUZ6GxU6Bdl
         0V6oda+DBy9hc/M3qjrm2fnXafXJaIKtnhW24SAvMS7Gi7iSk9fnRugSHMzLRCN1XLoN
         B0jw==
X-Forwarded-Encrypted: i=1; AHgh+RrRdf9/TgnyZTDuMNxfLHlZlgByJ31rOr0zEi1WeDHh+iglmFJRsHqgDNB60GuuikZWuPP027MOAw==@kvack.org
X-Gm-Message-State: AOJu0YwJN22tzx5eyMte4haDPYltnF3+8bxU3631HEbm1Z4Jmi7537AD
	IFEkmr57LzNZaL+zN4d4AdJTC/LT3OKhIwPoZdG0F62ZaZ7r2Az7ThGa3TBZInToQEofZTz7wmY
	bHKrybSRVc6SrLDNUSWDVfXMjjoc/CQ4=
X-Gm-Gg: AR+sD12HWzv9uxkxIdhKHmDiF77bvajokNNMTrFZX9gJxYvOz1x5STyKQ7LUzD0Ll6X
	rzNXSPz5CEOPSx7Xira4QEX15YF3fQyvOp/qHck2lE0F1QNlbpnevU5+FwXgI6xUS4w2cOYgiuE
	ddxGzUV1A6ZlCQH1lKDdCpmPnfQVTwj9UoDQ5paZb/B/fEBGLMACHuSd8Lqbtjv4r7QK00r1YBD
	gjtpBolk6NErYd7Aj1wZ5ZGJGzbmquQd++hVNN4UoGTobtU7lWA0yJLsMme1fe6kP3rpEgUDbLZ
	RURhSth9CiXvexNK7iAAUibGXSOUfnAWkXRyB2DIUlI=
X-Received: by 2002:a05:6820:4b04:b0:6ab:19c3:370e with SMTP id
 006d021491bc7-6aeaba25ae8mr23166eaf.1.1785943886510; Wed, 05 Aug 2026
 08:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
 <20260730-work-binfmt_misc-preopen-v1-1-4a0b0da71f16@kernel.org>
 <178571387898.1880415.17662890925792360904.b4-review@b4> <20260803-notunterkunft-wildtier-restaurant-1733e9660017@brauner>
In-Reply-To: <20260803-notunterkunft-wildtier-restaurant-1733e9660017@brauner>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Wed, 5 Aug 2026 08:31:15 -0700
X-Gm-Features: AUfX_mzXyERgbDVMxdqUz6VFtphDyebsN972OxffP9NIbYDefxKewbjkZdrOpws
Message-ID: <CACCo2jnjvYVG82cgwq-UcEU7ZLRaMp12xG4wBLM=zNHUqqVg7g@mail.gmail.com>
Subject: Re: [PATCH 1/9] binfmt_misc: let a register string create an entry disabled
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, jannh@google.com, mail@johnericson.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADCD61A0004
X-Stat-Signature: m9re4azcmt5cbwexuzbcbf8f67cdgqiu
X-Rspam-User: 
X-HE-Tag: 1785943888-421184
X-HE-Meta: U2FsdGVkX18y1293ajVVqC4ga7D8jNMm3mx7P38nEDrADjV3gWBonVHPHNWtPD0CFnI3QXIJLK+QExoBZo2N7jKghQqiIOWa0c5YYc+8Y4X3hJxzczAQH2edZeKRqtRHrHP32pkTXjpPlRTNfI8lsgmuWw8Z6LP4l+9C6AIBWABCpfFP4/27V8SVo03qfW3wl9A88V5Ztes+cYRgPjPPGrIVtAjCoRFDX4VvcOB33hgItwbmGJMBcx1mS2v/1KjUf8pGk4LiFz253n6Ljz36ZVndwpk45BBHU7198cP9Y1UMkVE91c7eQONWdHhtDvF5GSOCx+QW4vtHliZWfX84bm4suGRf6pAjXvbZlZqok27KTCV2rlBftY2vTJzR2OniaJkn2MkAefmi0VQRFdNRHWcdtP8Yi3WxIUmxkZFsSAvPxTBIwPFSBQwhe1TPcVL0HgUCWesnIYkQPOnZNy8FTmEh4ToaFYysLG7/qz0rCrga2sFizwZZJ17QcPu4nszra/OLIQULhtM4TGYoFels/7K/rHVyfeyu2Y5EmSotJUiji/Y2vUAtTlGiPjyOBsqKoAB0+CnzmIt9hHmIVagrJwSzv8RadN8sEU0vTCLD+EKR79XM0KoJSpeAEWPQa4MFnNubQJlumg5V+jj8yUWawp3iYuoLg9msRRhfeHj9CD6rHnRYM4ktnGBOI2KDCQIUo/R8+zDR0wHGCpP5/TEJSdiTe6ycS7Fg5CRXU1TMpwXbsBFdy79s9W0ojkcReBFm2DvWNnp9OPyKnRVuY4nIL9NzXUNCqck44NnhYLUOXDste7rJbndF0YA0VAA30N0181YesfYbuivURWTROjOMEKAG04RY53GJZo/SI6QUgKWXctM27oiIfvhEi0/J9rXGEwASi5Vov8D63na1gU+fZj5/fYUKVVGa9b07AHka+jGdkU+G5g1Iyjc84bp4fFJbU2K6LqFDKeAik2XolM3
 af67LCVX
 h0SkiAgqTXRXMMLGmTYL1ry7CT/9OpQLMVDVIdGAp40Aj1xe+I3LG5eAP9J73UOXAtEh+91fyBK2WnJwH/5Ni5Z/cO69baCyCQ/OLkP8XGOf6Pxu4graOHmd8+oZn72BZzK6embP7ZZ5OG9WtkGtT/ksq40WO+BhPatWJc3F5A99q3fOQOhzNJkWsz/2T0FX0/3omOS21SQFwfqfhUPevEEt+j+EKqlwK5S/4R6tLS51/D0pfBr0ypiT9Zen1CZwYyS/gay1rmHZysMJ+mH1ZPL1yp4fNT6w+fuMdQ09YeClgC728+7UyyS/lNRogHmPTMRRGb3KHJl5NyGvQR87JKYfdXXaiDD3IkJmxnuneS/6NslGc8UYXfWo6o4Km6Fn9B7hzdEqp3gah+z1ePW4PWlqnevTiHr8TzAQz38N8b/r2TNCKX6amACtsHmRsQLgNZVdjzntzOYU+LazZ64fmy7E4ZkC+2S2BP785SHb25mj/P0c0fSlyqTVeKMndwgkPEgrHAvwEGKIDr1hoQt6/dVP+Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 10:18=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Sun, Aug 02, 2026 at 04:37:58PM -0700, Farid Zakaria wrote:
> > On Thu, 30 Jul 2026 15:34:03 +0200, Christian Brauner <brauner@kernel.o=
rg> wrote:
> > > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > > index 707f8a14f8a6..ca7840b01a2b 100644
> > > --- a/fs/binfmt_misc.c
> > > +++ b/fs/binfmt_misc.c
> > > @@ -75,6 +86,7 @@ static const struct binfmt_misc_flag misc_flags[] =
=3D {
> > >     { 'F', MISC_FMT_OPEN_FILE,      0,                      "open int=
erpreter file now"     },
> > >     { 'T', MISC_FMT_TRANSPARENT,    MISC_FMT_OPEN_BINARY,   "transpar=
ent"                   },
> > >     { 'L', MISC_FMT_LOADER,         0,                      "loader s=
ubstitution"           },
> > > +   { 'D', MISC_FMT_DISABLED,       0,                      "register=
 disabled"             },
> >
> > AI brought up an interesting point that this now changes the set of
> > valid delimiters which you might want to call out in the commit message=
.
> >
> > For instance 'DnameDMD0DmagicDDinterpD' was allowed before.
> > It might be a very obscure feature to pick a delimiter because
> > https://docs.kernel.org/admin-guide/binfmt-misc.html does not even
> > mention it beyond 'where you can choose the : upon your needs'.
>
> Yeah, I can send a separate doc addition for that. But that's kinda true
> for any new thing we give meaning. So _shrug_.

I figured but thought it was worth calling out.
Maybe you will want to reserve A-Z for non-delimiters; the
documentation seems to point readers
to #:;- all sensible options. I don't have the history about this.

Having a growing flag set and arbitrary delimiters seems odd.

I am headed to DEFCON tomorrow but I saw a few more patch series will
go through.
They are getting a little more esoteric for me though :)

