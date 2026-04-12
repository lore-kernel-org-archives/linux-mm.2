Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C160EF3ED4A
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 01:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DD66B0089; Sat, 11 Apr 2026 21:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816466B008A; Sat, 11 Apr 2026 21:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AED6B0092; Sat, 11 Apr 2026 21:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 612AA6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:03:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A56EF1A097F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:03:20 +0000 (UTC)
X-FDA: 84648105360.14.54CE8CF
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CD53140004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:03:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IlT7v4vy;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775955798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/lCR/Upuk85s1KKtsj70aAhwIocyaRuQRg4fGGyx+k=;
	b=YHrWYel5BdyG6aAbnk28p3AKENhibxqxxm2Oh3zze4dKNP42tgOuUZsECJSNgicQobHRxl
	4Qq5RS7v19WRSuJKvi5sgZ6PuRahHz6cwWyOBBAk5qpa8fMnnT8t2EgjuJKPtOAoYxogsQ
	1gJQCHxMYStVRSmvbUiCZStYQiXn8TU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IlT7v4vy;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775955798; a=rsa-sha256;
	cv=pass;
	b=5CBLbX/oSrL3JmdLiBJknjYOJ3XyZt/bitbQlgGyBMO+5yfw0kyW6OIR8P6W/i7O/tdjWZ
	yEuwK0cZEeP+deH5FayWPqgpD7MdRZUsZoNAKSv5STTptCTIYA0Njv1cftL8xRsfalT4nz
	SZhsC2/QfSjNGpNyRwFL95phYZI8UV0=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cf5ad500fso2733919f8f.0
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775955797; cv=none;
        d=google.com; s=arc-20240605;
        b=IZIygg5KFx3eyGsybdzZMCzD8skzo8TIqZtUYuG+aefo3acyYeUXouIoHDCP4pYsp4
         YM59/LNTT6fCy0lLGogJL3aEBsPMu5khCVDx84xeQN6bgze27kBSpY8zK76Ci1IKGz3r
         hjgDLdpddSAQFTp+P+GK14PmuW03j8aDPt8KqkTrgGLwYQ9F7LJIQ3N5LEXXWff7kjM4
         q+vIveLXKRXb5WKkRsSOdK/nDZyBQGEl8ynjAl/nXTRmC0CWqodn8Po1zhkXF+tEe+8X
         9BPzemgbhAfXRZrozP2xwMcRX2rE+u8ZQQWjK8oVW6BJk+58rYh4HTv516aRdbAenEGE
         xOnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O/lCR/Upuk85s1KKtsj70aAhwIocyaRuQRg4fGGyx+k=;
        fh=Q6xwf3EpJ8G/AWmD7a+XYpitSPO75zla/pck3epX+YQ=;
        b=KxJa+VNb0Y3QwY7af2F6K87wuUT2di+UJQqwMjiaFdrJh/idWaUxSXMhhnaQ8Xk+TF
         K5OTzk1HPQ+WkQquYC3vUhpeMjkVPEXcvEtuX6UBrNFjQqeHeIw1tq01YxIE7IqTiax4
         2palTWqRHWXQHWGRUu11p5ztFzfe+0KymHgoqy1rsRQvGCQFMPC7L4pEqUDwWhDvxJI5
         JHZEWxqbPI3L10ztSgdY2VABcN/Cag0Hh42jqFRiIfI73z6ceDcJJluw1rxprP6Fe9Z/
         /7qWTffRJXImxgdzFcpWh0XbjiXmIQRHNKx3CYYuiA3TXMshvCdRjbkOcMWukfqmHlvo
         0V7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775955797; x=1776560597; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/lCR/Upuk85s1KKtsj70aAhwIocyaRuQRg4fGGyx+k=;
        b=IlT7v4vyr3+4qZ4nh/fY45SwMuidktyk+RlK6Flqwo2acoM6ow7Bqt3FDmuE5iEYo1
         0AiYY2OmVefosvrruirVgg7ZH2UHy3C8E8QnCuvtLDPdaIN6zxItPVltxtC4xcsYlgQJ
         FoudBqi3i6ire52j3qpgvCZMGQqWR0/jEAiatRAXrZqI6P0jZZR0JyIB1kanIiBaO/tI
         va+hL0gKzZBNXmpm7KBSxnuDQi596pJPBCbKjACvtJ62XMzRzL3n4Yg0Vxf8Y/KI+Ryl
         fPDOZdjolLoKQc+hdxCA83zerSIL2RChw6WiwoR9SO1iQNvP90FmNrWjg8Tu1ynUvfxE
         rmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775955797; x=1776560597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/lCR/Upuk85s1KKtsj70aAhwIocyaRuQRg4fGGyx+k=;
        b=MeHKdNz9n+GD8cdfchKxYvhNI7TBMaF47NLka0ZK7ZWS0lI+30gm1GXImwD+g+5UFB
         KRMu2Ja3LHPxvrrj3wwFRKlSxCuy4oHiVIevmiBjiqbY9z1GqdKIeFYFxtRN0UxI9JSq
         0nhPRvtoX5oDue4yYFO++/cuOHC8Zti51p3JUMMAVljr9muvhUbL19bV3E8AhDRBB3ba
         PZcT9/0j5qKhS+nBvu41H1Hg8ejj5+hlYhEhpasaMGyjYv8M9wmKR5nUmXX2DgTrABiO
         EJYwZz+83Bci0RVk9/S8+X8Lr7w+3Lc9ZUQJTO+TXhPUX/absa/8NnJ7XqoLZNl1PY5m
         xXgg==
X-Forwarded-Encrypted: i=1; AFNElJ+3fDFrairZJ/78IE7wJtp9PYGxA9ralQAoTvtwTzd49MV374cV3P4LpAzq7zP0FFLBOCGq7HeJKQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4wcb2RGMxi111aWVqUpzbej7wPQgmeH03SF8U2f7Zm1fXMlFG
	sBEh1QrW3W76JnCa5nCN4ah/2GnjYJ4T/cUNtWwCtuBJAhlRx9v/IVRhD+APVwVm4JrR0XBxf/H
	c4PN4sFxeMvatx/cIU0n5fskDzKLWjIw=
X-Gm-Gg: AeBDiesa0XsWCjqoUjGkY/+zpVpC99iqO/1J89uP+tu0vtyrc/922nxW2L2YUGmPSpl
	7xUiyhZIuezcqfSc5gfiieFrbP1ox9jAbUfDKicbVKoJ9zOuGm+WmBxyvUhrGihbvAgUvgOy/3g
	r91Fvr2osR8kRBugrbaABY32aCC6I54FwPKTKkyh65fYxH7TT79lrOBewm/dXvRI1C4G4XNeK4F
	0n1C3hRk5TIv1zZlsHUnW6DlyWmVqgNd7JfHDmyn3ouCh/kt1RRWyAAdYFldNwhIL2mc83Aq+RH
	hME27eqy9Gd0+MCqrVO08kFbJdNwbpOGV6e2zQ==
X-Received: by 2002:a05:6000:2dc7:b0:43d:2581:3053 with SMTP id
 ffacd0b85a97d-43d642d9d6fmr11425935f8f.45.1775955796453; Sat, 11 Apr 2026
 18:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com> <acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330>
In-Reply-To: <acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 11 Apr 2026 18:03:04 -0700
X-Gm-Features: AQROBzD_Pt7K9MF5OX7eBfMwphwrIpDFPvFIpxySkOPErMwdGQw3LLfvFpdgRuc
Message-ID: <CAKEwX=Pt04pYfhYOwmtXJKU5OqcxBC14SAf1wpBxBo1D7rPpGw@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: YoungJun Park <youngjun.park@lge.com>
Cc: Kairui Song <ryncsn@gmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: bxc9ho7rtbo4mi63bi4xtztifaruom9g
X-Rspamd-Queue-Id: 7CD53140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775955798-96849
X-HE-Meta: U2FsdGVkX1/keDwNnlK8E7ZnyD6PbmjuAPrRLzopw2sIot8jas95NBZL03VQDwisypeiEZ9eNwfQeKbRjQ0b6jcMBQZ4n+8u69lAurmB28IvaENzGb0tfGxvIRPp4L9iq79QHJwv+r1IqIY+0+AguNesXfOyTBN3bHPBuKQanpKJ18Qw3vGZAj29OzdXrRQtB3+/ovN2cSUw7rhojHEG7XJ8X+8ltPGVInqNfjHwARWGqxt771i3fU3C9IHQYCx1IJPIz9MkdF/9ur6HWCXsAyHOkaevnkSmdP4aqTKr1UVROoxc4dgQUKJd8QEPbHq5AECiJoIW780w6dzKEFGYnqztc/mnVeZR219TiGAKUi3FsZUOXrwg8cC30agaJ9viCkz/TgbdloYTT1DwPFmPlIharTFkEUbhJOma83lOlVpd6l9goTvUDPEfGl0NCUpk+n2Si4gnB7yK42WspmhdFQwz8uLOvnfZ4M8e6jjkXa2mKaET2VoM6303Xu41Tk/frUfBSuAW+bBELnGRusNHwLYDgK9sT7udMzWGH9ZqrEwGvj/bIZudnZDPjrf1HOZO8hECqbJ72eENF2NxLsLC+vegd1XrtrLHJ94ZYw6rEFt6bZdk3gzm3LHhKLkWhVtfIV1MPZXKJ/6XhQEFrkWzHVh+DyPFmxOcztdV5NuC19voi2/TMoF6gMeU/bu/mVQ+oM+yPXgOEz5+3ZanBjbDnZUzaljgT62FtuP8aRHBJAGRS2dHI2VMrjmmuA8uikq6JoWUPQtFKRlWNQTDgXQp7EbCYwwQcBzsG+hSkvfc+Z6kwkQ9LNd4mhiQ6SZlj8nK50CCSvPqdqCU1TNStKyAQgtijImRBBkHAk1/yyNxIdx4oswhBA/itGvZPD3n+Q+Z/CywMDlMFMQ4rImtKGRRbPrcrrlOovsnWg+oLUO3vza1SCy6HPZKnHTh3q9cvKiO+g/UeyMoryxL8RYtmKx
 kYirbj+g
 WMzdCr067NZGHVjfWYRsp9IT9quT9n3QwF7WLkxqbxalHUgw5FqHLmGWHM29mXPQMeGpP5N0BeNHOXkuwPnxkdfAQny353AAjG+YOBhPxjoRKre+cdV2tWPENxRJZzm+GHgYBMexCFAqcrW1aGxgzmc8h7oh19xhh/GVG/bAT8BmgfZ7BKCEwhpLNLgHdSpIxaBBt58ATmlML1cXygTB1kZahJ4B4fVCrr2a/Tjr4z8V9gS4j99XrSBb6CKfn/e1ui1U2cGKWPfU6MibPl7NBvaadDrKp3q++cRHJji+PPLC7ogKWtpwcaZqdL53PNEh8EGwksF5jwsfFZyoD86fmvCsUtA297vg7UtXD4M3jC84wXJ1FOIDvveUFClonIbQ5EOQhU8o9M6HR9mc+CBHHg7QcZwdrwi9LkYeIkx8U7fyHBELTOaSQe7wB28Ngl2qvhJP+AlWd60hmSLySTQ/Okrq69YoJkovO/J8xe48PYtp6b9VsAuUsiYG5iR+1I22u+/PU/gpnhrMCBfOdlvLVP1jKM9Nkk+C+seY+bGi9oxJikSUm4PpWXc4hIeX1DPnIW29sQzP2/pKEPStPvXimCpKwSIq5n7hF+i3pwfeAD00L4vzViPtH+pwAJxwd24MWAcTwIyzsCBfPjHhqhNHU1jA2wLl4REQohqQxdKa1rUonvhCo7Mtbj15UxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:53=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> On Mon, Mar 23, 2026 at 11:32:57AM -0400, Nhat Pham wrote:
>
> > Interesting. Normally "lots of zero-filled page" is a very beneficial
> > case for vswap. You don't need a swapfile, or any zram/zswap metadata
> > overhead - it's a native swap backend. If production workload has this
> > many zero-filled pages, I think the numbers of vswap would be much
> > less alarming - perhaps even matching memory overhead because you
> > don't need to maintain a zram entry metadata (it's at least 2 words
> > per zram entry right?), while there's no reverse map overhead induced
> > (so it's 24 bytes on both side), and no need to do zram-side locking
> > :)
> >
> > So I was surprised to see that it's not working out very well here. I
> > checked the implementation of memhog - let me know if this is wrong
> > place to look:
> >
> > https://man7.org/linux/man-pages/man8/memhog.8.html
> > https://github.com/numactl/numactl/blob/master/memhog.c#L52
> >
> > I think this is what happened here: memhog was populating the memory
> > 0xff, which triggers the full overhead of a swapfile-backed swap entry
> > because even though it's "same-filled" it's not zero-filled! I was
> > following Usama's observation - "less than 1% of the same-filled pages
> > were non-zero" - and so I only handled the zero-filled case here:
> >
> > https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.=
com/
> >
> > This sounds a bit artificial IMHO - as Usama pointed out above, I
> > think most samefilled pages are zero pages, in real production
> > workloads. However, if you think there are real use cases with a lot
> > of non-zero samefilled pages, please let me know I can fix this real
> > quick. We can support this in vswap with zero extra metadata overhead
> > - change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
> > the backend field to store that value. I can send you a patch if
> > you're interested.
>
> This brings back memories -- I'm pretty sure we talked about
> exactly this at LPC. Our custom swap device already handles both
> zero-filled and same-filled pages on its own, so what we really
> wanted was a way to tell the swap layer "just skip the detection
> and let it through."
>
> I looked at two approaches back then but never submitted either:
>
>   - A per-swap_info flag to opt out of zero/same-filled handling.
>     But this felt wrong from vswap's perspective -- if even one
>     device opts out of the zeromap, the model gets messy.
>
>   - Revisiting Usama's patch 2 approach.
>     Sounded good in theory, but as you said,
>     it's not as simple to verify in practice. And it is more clean design
>     swapout time zero check as I see. So,  I gave up on it.
>
> Seeing this come up again is actually kind of nice :)
>
> One thought -- maybe a compile-time CONFIG or a boot param to
> control the scope? e.g. zero-only, same-filled, or disabled.
> That way vendors like us just turn it off, and setups like
> Kairui's can opt into broader detection. Just an idea though --
> open to other approaches if you have something in mind.

Yeah for vswap it's probably going to be a CONFIG or boot param.

But in the status quo, we can always add a swapfile flag. That one
should work already, right?

Thanks for thinking about it :) FWIW I think zero check is really
cheap, but yeah it's just wasted work.

(ZRAM folks - do you feel the overhead here?)

>
> Thanks,
> Youngjun Park
>

