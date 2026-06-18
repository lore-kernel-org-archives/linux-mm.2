Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0485DCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1DD6B0088; Thu, 18 Jun 2026 12:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AD86B008A; Thu, 18 Jun 2026 12:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21B16B008C; Thu, 18 Jun 2026 12:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7905A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:52:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEF151C3B4A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:52:15 +0000 (UTC)
X-FDA: 84893626230.10.868AEB1
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id DC55B20002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:52:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LGBBOCmu;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781801533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMi7aZTxm3jxivWjZ700YzVjKsVqCe2blnMBeZ/az7U=;
	b=58taVo2NGoZhJN4CMBFZzVqp/TqrVzIlRL4xO6Qmc4fmkON2tC6KGqVxSUKzultVzYxdl/
	FC5yC1O83GruY0x/OzGiPRF2t7msoOI7ylY9LrBGOmBlI9v0R+9jwF12wrF11Ucs5gz76T
	uIVbkRBY7qPSFrvBHSFSYzhhlIB0kW0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781801533;
	b=3uLB+Ohz9Ez0MLVBGZbl4dgqSA5j45L+dSiFNdkqERMQ0gW7CYU3UqKQ3EXJfPfflYpN6v
	QvHdTN/xyBEhwOJN/Fwdl1sB7jBN1FB5tFfnXNA77t8NOfWqoYljzujNYawYao0jhzHol8
	WfmdhXeUF+5lMhozCCMh72yBsJNZ1dY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LGBBOCmu;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51765331535so3581cf.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781801533; cv=none;
        d=google.com; s=arc-20260327;
        b=DZno2K9GyfnHSEszZv1LF9uEuXKQMNe8N03Krlc2a5tMRp9A1u5Ef62fU7JUFmp4UN
         Bo9Fs9FE1DBaVOWyNWEXpeWAaufAp8Gdvw0aXDBAMamDM2jlL+531YclWA5yHFm2Fc99
         BdQqrlOyjgXxSnDRhjOfz+y2n3shiHCpWd502MITaY0NlqxTsEhOYcx7QsJ0OqIUBhvb
         +q2CUtD55H4sv3k505LXKbPxfyXQyPemsqj8EZcbrvfnECIJ+1CQlL2y/MfI3PO12iPl
         QuVSGV6AID8P2UfLHgwuJYMTQgIhzvt0pMk/Ncn9EWKCeBXr90/EYVzf7ADB2i3P3EE8
         U1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hMi7aZTxm3jxivWjZ700YzVjKsVqCe2blnMBeZ/az7U=;
        fh=rjsVJGQ+giKNZ2/LbdlWfJyxbr+EKSmjHfNM60MvHI0=;
        b=rJzSM2HQPOuSYjt0vfbdtg8e9KrI09DiMQKVbRn2CZWIblf15JFyPeegNaP2oJpwkB
         4Mbo0qWsE9VIc/nGYZZwPEqIu7TCuifkTLh6zciq7yK6Ni3Opkb2mkliUdW6JhlGevwY
         riEW4F7lAzV5iHc8njA4sq1xDjWuKC2IOS8Wj54Vclzw3YGvvNhqynwPj14jd7wihNYl
         lVHpfyeHbwBqLM0FPCRzmIrlFLJ361OjE0b5yxap+9v3kHMNZZn3rOIN6/lPvbJMrYCy
         tY01RsLu8/V6y27YzogIMwM5WbWDmkLmCOh6ug2zvnU7RPUl+Vgpb3HWyZqReZdUmd12
         EwiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781801533; x=1782406333; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hMi7aZTxm3jxivWjZ700YzVjKsVqCe2blnMBeZ/az7U=;
        b=LGBBOCmua1DJCAGY36xEsrkzsKnjJA7FQdxgukxuHBF/4w2H5zghHhmihMhM88L/lX
         4g5VWO+QoU8MIv5iLUSl+6QxYkhuLY7bJdy5sFNRRZQDibuNS/S9xUQYUxkSBDI4F2XR
         x/PsyaDLsyAFFULOD0WJF93ozgs6SmhpWcSfI75EspLTNAT0KRm2nUrrFa07zjHEclKN
         l3c4e6B+qzp61kv0at94REIMBeNtQ+Cbr0hqIWFpGzkhemeI9NZhTyBWG8Ds6/OWArSF
         gzdNTDGivMqukNPgLHCinrJHfL3RcOn/nxSyKPjry34lMnjObZC2cD5JSHPdz1OkeOWX
         U5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781801533; x=1782406333;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hMi7aZTxm3jxivWjZ700YzVjKsVqCe2blnMBeZ/az7U=;
        b=Cc1Z/oiZWO89vCYLRqgyG23GYq95XNdUEEIxJhUxgBCQS3iULBL+xEIC4XHdyQfsnf
         f9OpsfL3U5BKGywVzY5s2JXmpBYOQzhPwneulELZVTAWcWWXvqsvDZu9S4QccSWaBF4i
         x4h6Wixxw3ybY3Q3E/kRW9Knv7Kg6Qq9tAAQhlM03Px8JErc7C5KWX7pJYsE1EKzZP+S
         hMmHZIewcRwQmElKb51ACKzDSx6yDSkP+dVovh3HwdfC9ZiLqz5EXEy+3IrLK85yAbf4
         4aHM8D3xqREK/8T7QzQjPJOV5BtRDsTlLNRsT2xcQt+efd5QqfsmizN2LldLvlweP1g4
         eAcQ==
X-Forwarded-Encrypted: i=1; AFNElJ8dezmFd1J2fhnwWQo2Z0WfPcv7aubiscRFr5pht9lqxaQnSWThuDtmTkk7dHtJOrbVc8h8FZNAWg==@kvack.org
X-Gm-Message-State: AOJu0Yx3FQhoyOziaADGHUONECl2BAu2hRTXoMcRSAxhX3jXjvYbNZYC
	QdlVERbnsCVar3ST1qT0GxKVmYOhis2UMVxEHj7QwETyWb0Qtd5BnpfT2bBaZqkcr7fw/1F1bTb
	IzMDdElQEorsVu4m5nDaldJ0GKh1boptQAH0XDR6k
X-Gm-Gg: AfdE7cndWN3cM81dNHdx3yMorh8ImDW2j8LzUZ3dqCZ64kG/qEBQ16J7Jcz3Es7sY0a
	zrQZfEqtwKW40Bh8Y5cVDLT11lUUf1zjfZxdy7glOhMK80U5l8m/a14skxA0IRj7dakgvARxMYp
	Jp9yV+aY0xmBmj65+7CxKdR03zzfXUxAZynRZHAVcHDugvTB3H3aQqIS7wxn/uLz/YsID5118yB
	L8KuDwDka+mrgnrDArutpsuAecoOcWWnNZF7FCri9hKZDdFAi2AEhjMfnrJrAzTKwLdV0lra8LS
	EIqYeJ9lwy6VHYjc8ONI43bOUA==
X-Received: by 2002:a05:622a:2cb:b0:516:4f62:85ed with SMTP id
 d75a77b69052e-519c67370aemr11157381cf.18.1781801524859; Thu, 18 Jun 2026
 09:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <202606181547.617a6967-lkp@intel.com> <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
 <ajP_-zqVPtbzvc9j@lucifer> <CAJuCfpFed0GuMk+dE-Xn0w45Mn1Spds-pc2BE__FUoWm6+R7_w@mail.gmail.com>
 <ajQbXthzbr9xgUIM@pedro-suse>
In-Reply-To: <ajQbXthzbr9xgUIM@pedro-suse>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jun 2026 09:51:53 -0700
X-Gm-Features: AVVi8CdV8JSYSx61wMIbmgLKcoU5jz7qQB1U1gJgsDUd3AobdGi4EL9lK9NNRxM
Message-ID: <CAJuCfpH_Fp=J-m-kVZ3VVmqH0cAfNX6CQKWt3XmAJq1Rp9sFwQ@mail.gmail.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
 45.8% regression
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	kernel test robot <oliver.sang@intel.com>, Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DC55B20002
X-Stat-Signature: jqjdbt45hko7bny1ia4mneu5ohr8p36s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781801533-886628
X-HE-Meta: U2FsdGVkX19LLYmHBiyg2NVDTmc3RUhyj+poNk1jXpgs3aEOAeoYiDMx4izAJs/YBdw0wFpUOQ1FUja+jjaVHUxl1A7RC+4TjMf2UUv0JE3wpdsWjDlX5nINnAnlFocDr5a831lQzlQ3SAHEZq7V5Oaj8269NB9XfVkIuiMChxbBzLOWyj9Dc+T7eV+U61xafSW/2PY6uHCrctCMVlwj09ygF4e5KsyLguXPdqPJ2AAyakP9IZUAnkeQuR3Hy/QFBFAN+OMctiJnLLp1wVawuhJYzsZuWWlesORz5bwMiT1TAlJ2wqEQxS5qyuqDY0Sqdf53RTJU2NqScvutvE10gBY5mlu641D/18frNRQpQzm2H+ZdA922PHALZPVe5DDY9P0ecOKTyDFzsW1uoLw6c8Oc0lvd4FCFZ+uNIgO6tHCzwaGYEmciUnDAC58Emx2CkAtuMIJFi8XMpaOX7ZeTwB4K6O1vQQyhiORAU4XsQaO5bPpHRVGTEk4O98UwYm5DquBh8uzstsERXHoF4WysEzGwxtlXfzKQT8agRj2vWjFf2L0PqDMmicBYIdEYHnvq8lCqJxBGGeUrCuP/BGZVZGj2Vjek+58kf/yOnanBnUtOxgKefIYt1aEraXYkDiIIPSAAX9LGcj3RdCGpvB6+QK8enWSmPJ6ytFP22qXnEoaTDgernHcfk1FBHySQzTK2E3wWM+W8I55wVhuHlVFleYsMRtKhPZ7WhtuR303lF6rxuB6ARG28QRv9sU3FjO38Y/7R65GXJfw4k6Uguy054SACpv2nnG1T4zAC2mBtGv3TSjLGIS92k+xNAnIRbEdcsh/YYB19lq5qBeyWA6DVtUQg8zkMg96yi6R9FnGdMek6ARu+p3fDe9/r+zDWu4tzTKHGRgRLzEQYBA3YTeUW96z+snk4pVLxK/bmWSeOsns2agPWOuDd8zZA/UhDR2JQrZPkyVuGZaE13TbZ5g0
 2PRT6WDE
 OeOVugUXVXI6SqsMaQ+dnjsPOLgmdR5AFjksB2+IwRFWXbiwoGagwB2mBhEP+hnRwI7MUGoZ7PKGskEqui5mOzx1PZEa9VTU2jikMDqMktzOOiVtpznyI6tl9TCukfOPDMEH/JNeTSdq9wj2d7G/UimUFkcnVLrFnUyJFCzYfdrby7tnrFkMn3i3Sx/sfCOBE0d+FYRgEGZWyFWaExleZkFAO+P0ks+cmiDT2oVYYbwB5IDLMN8cKskmC3mJ46EdD523ZVHBsnL3tVqs40vqg3zNIxw31ov8ZG/Ya7VcrQK0x0LaD98jfBFSe7yQMGNXLRqeaFO/8KhdcFP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 9:32=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Thu, Jun 18, 2026 at 04:03:43PM +0000, Suren Baghdasaryan wrote:
> > On Thu, Jun 18, 2026 at 2:30=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > >
> > > On Thu, Jun 18, 2026 at 11:30:47AM +0200, Jan Kara wrote:
> > > > On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > > > > Hello,
> > > > >
> > > > > kernel test robot noticed a 45.8% regression of pts.svt-av1.Prese=
t13.Bosphorus4K.frames_per_second on:
> > > >
> > > > This one looks serious enough and real. It would be good to figure =
out what
> > > > happens in this benchmark that it benefits from the readahead acros=
s VMA
> > > > boundaries so much...
> > >
> > > I think a revert first no? This seems pretty huge for something that =
isn't key
> > > to the kernel, then a new attempt can be tried with this issue addres=
sed
> > > perhaps?
> >
> > A quick search yields: "The
> > pts.svt-av1.Preset13.Bosphorus4K.frames_per_second is a benchmarking
> > metric from the Phoronix Test Suite that measures how many frames per
> > second a CPU can encode using the open-source SVT-AV1 video encoder."
> >
> > If this is a video encoding benchmark I would expect it to explicitly
> > prefetch the data from the disk before measuring the encoding speed.
> > If limiting readahead caused this regression, I suspect the benchmark
> > doesn't explicitly prefetch the data...
>
> Well, commonly video data doesn't actually fit in memory :)
>
> A quick look at the code (I think it's https://gitlab.com/AOMediaCodec/SV=
T-AV1/-/blob/master/Source/App/app_process_cmd.c#L821)
> suggests it is progressively mapping the file data for a given frame
> (or frames?). So the old behavior would result in page faults for a given
> frame starting readahead for the next few frames. This looks reasonable.

Yeah, looks like it's mapping one frame at a time and even that is
done with 3 mmap calls - it maps luma_read_size and then 2
chroma_read_size chunks which are consequitive and could have been
mapped with one syscall. Seems very inefficient but I guess it's
legit.

>
> FWIW I suspected this was a really weird case regarding mprotect or
> something, and I'm happy it isn't; but at least I had a suggestion for th=
at -
> for this, maybe dropping the change (for now?) is the best course of acti=
on.
>
> --
> Pedro

