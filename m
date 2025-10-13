Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EE1CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E8F8E0036; Mon, 13 Oct 2025 17:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE2A8E0031; Mon, 13 Oct 2025 17:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE028E0036; Mon, 13 Oct 2025 17:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 365608E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:33:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 990DF13B76A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:33:39 +0000 (UTC)
X-FDA: 83994392958.03.35010D5
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4239180009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:33:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PI4yogNo;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760391217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZUcfu/lY1a0PBj+NQhiKBcjA+Mj4IzkP02rncu56NU=;
	b=z/fiBSqfFgWSaCRIvmDcnfwOZj45pGIjMVz9KgdQk0j0qs+Iss39pMy/H2xs2W7OHd5IBU
	XMalbIVHfKkH5a74Wh+ruavbFAZAvv+JmCDeU224QGL7xRbeIcdjUMSTvGSF6F3xz7JeWL
	9oAUGz38VVPrw2F/sOpAk27DXoW6x0o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PI4yogNo;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760391217; a=rsa-sha256;
	cv=none;
	b=LtlOFEw2ewbVJgw7Co/+YCE2UD1/iMKUAJVFc1L3SP+ngaOCfa42bnSgSH7PvE25arLI9W
	61vGyanKpzpmW+rfz7lJBLnFmZBWgaMY2SUbHCXySHqUJmAmy55ScWQqCSiCOdoGr78PB7
	GwMp0ReqhsiK8a/LXEB6G0Q7GpCbSPQ=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so5134113f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760391216; x=1760996016; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZUcfu/lY1a0PBj+NQhiKBcjA+Mj4IzkP02rncu56NU=;
        b=PI4yogNo4QxK9U6w0lSztuUJYGtOPqph1HLKu2T2DcHOgpRdN3+KW7VIwymX6Q/kY5
         jN/7mfiiPKMpcz+2n+U5dPsMIJyJOB9r5e7nBRu05efVDs/oFE2cudU3gruYW7MAmNY5
         M32jq4TFHzzgg55WIx/137X5PuKXS2PB0dtXOVqb1XcYwMh05DO8OnXrhpwgELlFhJC+
         HK+TEeYbVKsy7R1S4KSlYZhraPp/JSVuR/FMgfnOcqoEMq9kRHDhKMZGVzPFdpwVBQLc
         w5xdCXBCEgbe8tyOh8pCpjxh8ywY8THu18Q0sjKQ0WqHMqDSLAck0YFxAx3bmnh6p2lE
         fgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760391216; x=1760996016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ZUcfu/lY1a0PBj+NQhiKBcjA+Mj4IzkP02rncu56NU=;
        b=jGpOTNmVnyMQYl/TQnYkDYZa3CPFvfJ4mV8pZHyIKDMeOfXjYZ5yAVq1o82i/bogXy
         6YgoJVzlTQEy5woVBTKrBGaKXlKfdkuQXS/hwxxYsQ6RvVZt8wJwN6W8Xhg4ycUN7A6E
         YR0fgpxFpyIQtp69VZbaYoZZkR1e5Xpls+3cgX2ZKZ8LlpfbhI+QdSCvIwkJNX2j1krK
         E3L065NIKAzwZB2URtv55qFv557RIlyjOwFmJIFR0QnB+ZAK/nbyJiOQsZ6P/RBdd2n8
         A+SAmWTtDMdcU8O+7bke3VXZLI97AQL1CrUKlED1wEnPls527eznqNniqYltvv5tFEpv
         LM6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1NuCtON7pxWUjqFMG3wK+kUYJWNhaKuXQQ+iqxLLDX2ECgGx9MgZuz4L6PMaParMzUeCLYF7zTQ==@kvack.org
X-Gm-Message-State: AOJu0YxBygA6jcdoEffZZmpTz1GBSV8jVm0XQ9bPMU/08zqxfpApgl/x
	BqB5fFdkXdsjBiDEQ91ZZkaMC2ThTAPhg56cvfR78VtqoYtSEFkajn/DortFbb9ZGGDygBXp8Mv
	/HfAr/Bc2SvG7qQLZ23U++D0PWJdv14I=
X-Gm-Gg: ASbGncvft5E4AqCNICH52UCagLTvBAILTNOdc0sHmwfPMOMZEY0j6nTZgQU+6r5jJr9
	ClhtXdV/MYehll/EcHPyoG6vktigxDACmD+fXfORScvXgf2JIuB9228KnRYVTD6oPuG6kXvmCgz
	fT0m+ojaTPjHS7r30eTMbfBsRJ36GxckuNFysbBwL15RpJP/QQMr3FHgFK7pzHB0jfgY0PWNbvu
	rQ7otTBmhhJG5BQJx9B/3Dl706OCEGVweSZsGgha61NPyECbJSeSRMKRUgRL00guaSG9A==
X-Google-Smtp-Source: AGHT+IHlObtCjPy8HAxyLJKUgyqBPTd1YCFgsUa+Y+27KX2893URbWswd2YijWA4M7gHzOuw6MrNZ5TM7a4jhudubqU=
X-Received: by 2002:a05:6000:2c0e:b0:408:d453:e40c with SMTP id
 ffacd0b85a97d-4266726d9famr14296862f8f.25.1760391215858; Mon, 13 Oct 2025
 14:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <202510101652.7921fdc6-lkp@intel.com> <692b6230-db0c-4369-85f0-539aa1c072bb@suse.cz>
In-Reply-To: <692b6230-db0c-4369-85f0-539aa1c072bb@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 13 Oct 2025 14:33:24 -0700
X-Gm-Features: AS18NWDZt8nn8SNzaUniYFQxsv0RyUfuDnFuvS487pngygUdhSUHcYIgCPrXOLo
Message-ID: <CAADnVQJLD7+7aySxv+NtS9LMFgj-O=RhSjkF3b-X3ngwzU2K4Q@mail.gmail.com>
Subject: Re: [linus:master] [slab] af92793e52: BUG_kmalloc-#(Not_tainted):Freepointer_corrupt
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, Alexei Starovoitov <ast@kernel.org>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	Harry Yoo <harry.yoo@oracle.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4239180009
X-Stat-Signature: nszj3c4rpwfc9yfdszngktsywx4yzdjq
X-Rspam-User: 
X-HE-Tag: 1760391217-125091
X-HE-Meta: U2FsdGVkX1/DWO2laEZ8txuqkLY0Rxy821E8/xXCs7M3N1ad2BRZC2lUiogx+U6Bd5609cghfgz69Sk3od/Usr3kor46SkXU69xgHBgNFPqrXaUAjOxdHbkjBodbEvoH4fodLE+JbJyGqwP1CIU9J2F3o4jQXS31rCvYldGkDRWOxtYiyDFo4w41BHHH5gS65QXaNS8gSwIfGw8SkBCULdPYgPpxLX4pONXcOeclsOTyx7SVWHOtHBNcAgSCfYzLoC+yBIZvTNPuz7GTcZr+Tt31azAjUrekQyFBIYTunS3LREvfvCbsgEMWV4gePIGHsHSlhueoSK/n4xkEiyiUSi43IprWN0gCqYPZJpcoDCMbxxIyjARj/toeiJCbN1zWeyoO+J8630k5eW2w7rzzguN5tsneC69KcxCVy+PQ1WrPRQv8Wd9jiU+EgjJuskh2Hjrws/q/3T3OgupzIYq7kzpSCEqV4gIQZyPHO7nPrcpU2ESXTFiVnJ5yv8Rwesws+yZo6QZGPHymZz+tCMNIFvPLnv44esJOIJoQas0poUIM5E45JqegrogbA9B4a9sngksTdVM1K9P26VdSftxht3Bp2iGw7tfAMdbrddGSvWsR42ss6UPnwYP2jMRxxTtHwf72Yh1VoZ+wAXxW96mQChX/7mxEDj5PKNHq0tpIcXwOS/rvZdHZjREKhiZnInOfTnYOaddQbE1KFoSL9U5GvAih06psF5YgNxZU43+YiaDj8fcxYCqWrSjy6FzLX8Jc6UH+GlI5gYFVhiKXGsgbAJkvA0LKKKEptaQmLUhRD2gQH18q4vxiaC8QCjPnDZESnqNv3A/tYfaIMgMvnhBn96j49XXp99Qty2v17zVhvF+ns8k3lc7ENbIEwn4WBSLFnCgCIdTzOusisxfBQW9bBIL91zkHS4vjiLTSK7ECb2BKOgyHFImOhWo2TwO44thVF/A8UE7akos5ehzeSXO
 Jm0sHaME
 e2UOokTkinFsozm5kPlyY/yZyu8HRzBQsV3i10JaeZcLlfabN38u+/bMbvkDu/uorM+/irsNYjsLrbw4zru5pICkXZnnpWWVjntnQeehn+7qpN+pH3+44mS2pik0tgDoLBn6d8TIPAVQ8+AK1vOkLIUPKCGd/YPSk9AS45fsmOs3Ag/aKS1JIGemvU/nMcnY4uAIUjow2Dqv2q7aazFwlgpr661jlt8npoLK/kNg7lC8ddt8IImV9kMisY9KmO5tfmzTY0StW9eRvVTVH5nsLpNs+suC01hK2AGu8tAOJGe1/VULDvxdOOCG0o1ywc+0ShK7DSmeB1ttCN6HykNHx4PIR1MRYa3l7cyEH3978pgB5NPRrYZHPF0d2Xf3U0a7Lf0MWJiu4bSN2n82gBhNxoM++87OhyTApIk+iqlLsoZaqd4w3qk8PHHVgW0POorkr3sVt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 7:58=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/10/25 10:39, kernel test robot wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed "BUG_kmalloc-#(Not_tainted):Freepointer_corru=
pt" on:
> >
> > commit: af92793e52c3a99b828ed4bdd277fd3e11c18d08 ("slab: Introduce kmal=
loc_nolock() and kfree_nolock().")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> >
> > [test failed on      linus/master ec714e371f22f716a04e6ecb2a24988c92b26=
911]
> > [test failed on linux-next/master 0b2f041c47acb45db82b4e847af6e17eb66cd=
32d]
> > [test failed on        fix commit 83d59d81b20c09c256099d1c15d7da2196958=
1bd]
> >
> > in testcase: trinity
> > version: trinity-i386-abe9de86-1_20230429
> > with following parameters:
> >
> >       runtime: 300s
> >       group: group-01
> >       nr_groups: 5
> >
> >
> >
> > config: i386-randconfig-012-20251004
> > compiler: gcc-14
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m=
 16G
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> >
> >
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202510101652.7921fdc6-lkp@inte=
l.com
>
> Does this fix it?
> ----8<----
> From 5f467c4e630a7a8e5ba024d31065413bddf22cec Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Mon, 13 Oct 2025 16:56:28 +0200
> Subject: [PATCH] slab: fix clearing freelist in free_deferred_objects()
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index f9f7f3942074..080d27fe253f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6377,15 +6377,16 @@ static void free_deferred_objects(struct irq_work=
 *work)
>                 slab =3D virt_to_slab(x);
>                 s =3D slab->slab_cache;
>
> +
> +               /* Point 'x' back to the beginning of allocated object */
> +               x -=3D s->offset;
>                 /*
>                  * We used freepointer in 'x' to link 'x' into df->object=
s.
>                  * Clear it to NULL to avoid false positive detection
>                  * of "Freepointer corruption".
>                  */
> -               *(void **)x =3D NULL;
> +               set_freepointer(s, x, NULL);
>
> -               /* Point 'x' back to the beginning of allocated object */
> -               x -=3D s->offset;
>                 __slab_free(s, slab, x, x, 1, _THIS_IP_);

Thanks for the fix!
Acked-by: Alexei Starovoitov <ast@kernel.org>

The bot spotted it with CONFIG_SLAB_FREELIST_HARDENED=3Dy.
It wasn't part of my tests. Sorry.

