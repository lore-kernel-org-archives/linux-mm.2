Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 960DEE6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 20:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC616B0088; Fri, 30 Jan 2026 15:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3FA6B0089; Fri, 30 Jan 2026 15:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9776B008A; Fri, 30 Jan 2026 15:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3576B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:47:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C4461A0304
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:47:36 +0000 (UTC)
X-FDA: 84389816112.14.24CB2AF
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47230100007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:47:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b18ZmOjB;
	spf=pass (imf14.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDkPuGg5sHwz7KAxPzT1A9rLAgVe4LnrIU8HnzBCVHo=;
	b=Df7nd28BUbnO0K5N9asLbCTml8Lps68smV1CEEbUJDLL+vaPGyRQvM98mSop/Rk9ZHEBTf
	pRq8dNYMmJj+MPOOdct9BrD1dsxYOO99qG3JK/SKY0RexUALLJepNbAbC9ql06u89ZyMdc
	EmrVRMcG4IXDb4A8Oc+3WmSazXZZ0ow=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b18ZmOjB;
	spf=pass (imf14.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806054; a=rsa-sha256;
	cv=pass;
	b=W5Ve5JF7eSlKdS9iqSyRdIVlQit5fI8U/MZdQ4FBsm8kSReUaw2Ji73IbmKON65iJBgi1T
	4sl8YpPm+b3ij+ON5Itrj7azmBtGlYhFsefuUgL+7yF+3y3o6UpVHDq3mz0pQ74ftFFaFl
	zXtFGKIH7zXC2oa66qzJoYgb33tH6fU=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so1446958a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:47:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769806053; cv=none;
        d=google.com; s=arc-20240605;
        b=YHZLJaVr6aGNKePslFhYT8kVg9sYqBFPHWv+cQ7E9cgKrtlwcxRRjHr/4ere6biSfk
         oPRTQ4Van+Q7zyxQjkPfneWtgevdj12DR7kUbpdx+vcLByOfANwFtfWhReoiCs+qfN6z
         MMopGZvtRVx55BhX0SPei7Nak4jSAGu3coYERngxAzJqpXmH5+FVJgADkVNWZpsWsMax
         ilBdieYHgpZdVPs95U1PhD0QTrd5wQXGP9IIIHelMPUzy4G53Mc2K72y1Id34D+veuIJ
         2B57zzd0Bc69sEICYjXMxly9/RQmP9c631f8ygP6DiIbdcwlNy/NQH3yOedvaMqD7WZi
         rB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kDkPuGg5sHwz7KAxPzT1A9rLAgVe4LnrIU8HnzBCVHo=;
        fh=4wuxXMX4cvsYLpj7Ht0gwL2xr0dMl+U03Tv27F50334=;
        b=YPwhKPfC5FIjbGxTvxi3h0oegG55Fz8jtUAlwN+fDWGrV8yZP/Sj0HaEjwxW/hd6/x
         qOXm6UagnamcuKaPnFx9GWpRUqfMp0833TN8st62J/PG8K7LAPRNRtJOg6h9xYW6wb2M
         qxk3gH3o+R8EegVx0u3sMXYZ5Yjo3XT3PWDNzMXWk1J7Eh9OsGBJAuyNfxZlTMQCcO5s
         AYJKaPbs9OVhYgs2oCsQGD8uTwlD1uyjZMuFUdcE8XzlW6X3oLUZhnhMZY9UAxUeKqvj
         AkWvKXlbjgSHIwKL3wy1QnQoLO5HwSx21Yy6EoInfTsrD3paK4j/D3X9NJpbXjRKzTEu
         MtBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769806053; x=1770410853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDkPuGg5sHwz7KAxPzT1A9rLAgVe4LnrIU8HnzBCVHo=;
        b=b18ZmOjBIBa7mAcALOB/PiHzS2MlQINKCm52UKVQI+MV/J6hMj58TNHB7wg0X+yd63
         Vq8drANI6rcizd2YFljG5NVDC9wa8xHOoCTlB5Ks+zB4QW69ett3xNGS5HXTYNe3Nwa3
         KGutZkXPiIw9fo2YoFh5LyVprmkCfVzydloYswnmOJQN/yWRUmiuLNjyZpN6FZXnyG4l
         Jtw8vLNRlo+MvvKMJhz0hII0J7wd7aAvf22rPh4Wpt06ZhTV1+5N5u54790/h1tfy3NV
         rV/C076XxcvlLPFnF0Cd6DoNqWyEqagFx0/Nputfudu3G4NxVnwbDc1Z4XsqTukmkW13
         iH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769806053; x=1770410853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kDkPuGg5sHwz7KAxPzT1A9rLAgVe4LnrIU8HnzBCVHo=;
        b=ZGPYEthqli2GM9RYVVJvIBknHY+x8M57hy++cdcX6DzEGfivkyz8lCd8BltoVU3NfI
         04NVa1Xn3DPpkRUc37e1PAxXBcM/BgPmw1x4HkOtCmOgxs7oVYgRxZEqIwty59FpPy0l
         PTVfazmoSn9Gn21HSmHxvtqQv+SuUkZ2ZUSJ+RsfeTv1NrS0zc2G34CwLsc0khDBq9Sf
         lnirNnqtNipU8rxI9vaB6DPai3x1npbZ8S8W6+E+s5zEyyh1jKUd3E6GZcF2ac5pKpzh
         b0XLf4qTWhY4blFdrj1+IlohTz4dZM1TqmjdVg9LizB7cilmS/aq9w6lkHewY6kyfMwV
         v2TA==
X-Forwarded-Encrypted: i=1; AJvYcCUxHaabP8RLQPjukwUfkuoi4RLPwA+TIiTKPCjCXP+fOPnxyMvwd8pvwQ5hlD5/8r9NwHaddTLYAg==@kvack.org
X-Gm-Message-State: AOJu0YwRu1v67R5WrUp+Bq1lPHf7gRatAeaAIWpITUANG8JgtHsb2R8A
	BMItZnU6B+KODahhjnYAp09qqyH/ZzsPakISJ7R+c7YFFTloq58YG0uFybrTS6eYMIzeRSk+l8/
	rYgNBMcsFzXRaDdwzGe0FOVo55R/d4No=
X-Gm-Gg: AZuq6aJP67o7cgsDj5+hUNwz2lBzW3xETCIYqFfdDuzF0nAHMTK83r1ITt4XuNren8r
	iIwv6q8uyFKBLsMchGjZs1+46GRA0z2s8GFhMvymL1Qr968+ggHWaUWxcneYH5mZW3cjK58qYiK
	Ic9/sZ1YMSo1KwvyZmx8XcR7s7jrn72XFCDcAXXdMbXRA0tE+ySRyctvvl9t3nLhq/gvCWN6M26
	BP3abLQL3BYEGxQfv3J8rbJ3r1JPGN5zIDijTlfydYNHX0gi1X7/pNGLK/60fDXgt+4T5dPpTWV
	YEhMbKsOLrE=
X-Received: by 2002:a17:90b:37c6:b0:349:3fe8:e7df with SMTP id
 98e67ed59e1d1-3543b38bdbfmr3697730a91.22.1769806052962; Fri, 30 Jan 2026
 12:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20260129215340.3742283-1-andrii@kernel.org> <202601301121.zr5U6ixA-lkp@intel.com>
 <CAEf4BzZthAONGByqvk3pHRT3GaA8=fNbz+d1V1CY1N8sHEcsjA@mail.gmail.com> <20260130124242.dbb7946b3592ffddac7c316a@linux-foundation.org>
In-Reply-To: <20260130124242.dbb7946b3592ffddac7c316a@linux-foundation.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 30 Jan 2026 12:47:20 -0800
X-Gm-Features: AZwV_Qg6qiEP4IMJhs-KyomvrbnJXpik5IjgslLpgoiiekMmR439uSsS3HxxEv8
Message-ID: <CAEf4BzatC6zi2vm=acg7949nBKpb6m+L4ubvLKn6JmRwy8o2Bg@mail.gmail.com>
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Andrii Nakryiko <andrii@kernel.org>, linux-mm@kvack.org, 
	oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	bpf@vger.kernel.org, surenb@google.com, shakeel.butt@linux.dev, 
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47230100007
X-Stat-Signature: 14spax9qa1qpkug5fi45i13xq4pk9gse
X-Rspam-User: 
X-HE-Tag: 1769806054-40120
X-HE-Meta: U2FsdGVkX18lHrmJJm9hl0r8ynBNcFN8p7nt7MNguQ7xBuVLOTNPZ63NCEwiBkX8/xaKFPoYlofS+d9A7tcBBgNHUUNZKkACOfFXlHzYHdAdfYT40ooU6VsL94AYuw8maHpVIB1Sy+vhNbVyt3j3jCBhI16cw90DyWtdb5kttrcdp098x5lpHKdciIFfyEfISP/j0WXVfy5zlNoRbdRTbBwhLusU3gJMFvFwvQ1yq0cgSy0KN03NbbjWJXQNc0q1pjtcplHuVvSkPiZTDu6bB3/d5hZ0mZSANbeDR2Qf3y5Y21emhjhjAu+OYB0vfyBfoQ7/I0i+gyxoM2BBxXAtD8sT6PIC8vOUMOKtNYgP1/nofqBmQIFPOLlfsRFqEa2fyiRWSGTgPviJDFcCjFRXd4MlYZHHB3LbIGIkNQlGbkEGIdA2aQkPtTEa6lUzxXqFD/jAdRIkmojTjlyYH9bD4B1fny1VhMkjFsuKi0pkyYuMR25+iaDdn6wBgYix+fqFB6ppWhx4cbPcFcbM+Nw+uLK9HBM2Nnb+uGVUOobWJ8qyn0knUhwiIGR98t3gc7Kuht3akorgPLRZwB0YNPERZlJL+hyAoAYgfp1h56fVP9PKSNvEzEKU1I/a1jo2SxYP3iWSJXOv9NXWylPPO0cJlMXoN0J4EFI9/2rCiohA7/iHDs1cpArQRRFpnuqCbAWPMGL6B69GwKnszonK0X1OOv1hPI9H09yRJnEBZeT4f67nq2Y0UDXhiIp7NyQQW47165e6d9CPD7taalD9tK4mwlKjcLdKuYB+LTC6HZuJMykwRfHegdOsdHVau0tJ2e64vB9h2GLIwZvRDzRnH7b+gbYLhxnaVEdb6zSUByb2SB+Ffvgc+Jw0DBNxQcvS0wb4IbrPdC/rD185gNGpkAdsMOAtjOSdA8tgnzbHMwItEMshpb1XZht+idyMlyQrGSxOnghvWkHCPw5HC8DhgGi
 JKJ/EsEq
 zD2dRITv6WLuxO16x6Ii13AezH9ylCSYuIOTDgpS6arjsRWw4mJPNWlsMxF66FHOAh90V8A6ORqqviiKi6iGtS6lrGk3sCNUxUGR+wFOzu65d64bDSG9FUMWvIg8g5rnxvhlf1+KGOlJGgJT4PLKCdJ8dL736kpZ7WSHgKe7N6LtxTuNYoHlusLX2S6GoaWm0rVBbUUIY9oXqgCQGnMaFUVfwuCziF3yYHV61G6hrghvWnhL9ivrxf2AUIWzWGU9m/WwTvY9qL9ArBv7X++MgRsp1qEgvBtL67ecPBndakC24R/Q1lfdTnhTsrvIIlYxSiGrqaVKsapqJFr+BwUvBh3RG4IXp25T0bbL/Cm1S7gehYnO6VDzP/OvcclbYy9DrULqJyNJ6GsaYLPz7a91BvGlPT7JCmkpXESOyCM8rkISODq3tEsdyr4+wc48A5wRqdwtCYFaSOT6+ens83n9F37O3PY53jrjvejhTU02YwLsC8JkBugtHY9GocqwhVpqdjx12+SyBzwx33jMDa5Ga5yzBMpTjrEOnu1+WHB2c9PhvusU0BRuwKDWAlcLITAH3U7AnH0IqncZUjTAuvHHDeyk2oefmH0Sx+6VpoRe1ylF90gIJIfIdaAKSuhZwIGBB/+6vKsWvcuJadGeYttFaT/72qA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 12:42=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 30 Jan 2026 12:11:31 -0800 Andrii Nakryiko <andrii.nakryiko@gmail=
.com> wrote:
>
> > > If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202601301121.zr5U6ixA=
-lkp@intel.com/
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > > >> Warning: lib/buildid.c:348 This comment starts with '/**', but isn=
't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
> > >     * Parse build ID of ELF file
> >
> > So AI tells me to be a proper kernel-doc comment this should have been:
> >
> > * build_id_parse_file() - Parse build ID of ELF file
> >
> > Andrew, should I send v3 or you can just patch it up in-place? Thanks!
>
> No probs.
>
> The preceding two functions are trying to be kerneldoc but failed.  How
> about this?
>
>

yep, LGTM, thanks!

> --- a/lib/buildid.c~procfs-avoid-fetching-build-id-while-holding-vma-lock=
-fix
> +++ a/lib/buildid.c
> @@ -315,8 +315,8 @@ out:
>         return ret;
>  }
>
> -/*
> - * Parse build ID of ELF file mapped to vma
> +/**
> + * build_id_parse_nofault() - Parse build ID of ELF file mapped to vma
>   * @vma:      vma object
>   * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
>   * @size:     returns actual build id size in case of success
> @@ -334,8 +334,8 @@ int build_id_parse_nofault(struct vm_are
>         return __build_id_parse(vma->vm_file, build_id, size, false /* !m=
ay_fault */);
>  }
>
> -/*
> - * Parse build ID of ELF file mapped to VMA
> +/**
> + * build_id_parse() - Parse build ID of ELF file mapped to VMA
>   * @vma:      vma object
>   * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
>   * @size:     returns actual build id size in case of success
> @@ -354,7 +354,7 @@ int build_id_parse(struct vm_area_struct
>  }
>
>  /**
> - * Parse build ID of ELF file
> + * build_id_parse_file() - Parse build ID of ELF file
>   * @file:      file object
>   * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
>   * @size:     returns actual build id size in case of success
> _
>

