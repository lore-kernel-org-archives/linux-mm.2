Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADA9CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BBA6B0005; Wed, 17 Jun 2026 13:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCEF6B0088; Wed, 17 Jun 2026 13:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBDC6B008C; Wed, 17 Jun 2026 13:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 936096B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:12:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E33EA04ED
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:12:09 +0000 (UTC)
X-FDA: 84890047578.02.73F00B2
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id E688D1C000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:12:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HEF1TXyD;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781716327;
	b=aQHDALjIE/s5tIEoUekfNieQw8ZUSPPhHTLYfy5pqB51s82GeZ6LrUvHtWiX3K7wm4m15q
	qVwQkowGZiZltfAtt53SIP78eq6IVs4L/A1qAITOJbeblD+Vx3OT9v8mt0Wmp1p/yBGQkd
	Rqw9wx/eigsrO5XvnoDwSWeM+2BsKYs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HEF1TXyD;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781716327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBgVYCVjdYfk0aVRhelrtdNC3fQCPGI1gI+8jkOtitE=;
	b=HlNHCJhLvQAz80xy0vDpoylth7TGthHPDpTt5yabTcuZ71GSLTZMhdYSqrUHd5H2q23dpt
	pk62CuJtT2LiVm3sJ/mY7L2UPrw1QGIf7wTewN41BlTBdDD+kkDYcP9qQriAoCDCvPPjaF
	Ebd1qeqIuSYGIog1LU4h/yitMueIix0=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-460662fcb4eso53209f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781716325; cv=none;
        d=google.com; s=arc-20240605;
        b=VzuNN/nNjgeAcZhJ8LxYxzZBY4HaQjc4ga8a8CjlJnioKdW8Uk3aYJTBiCxwpRT4AC
         3ZKrV5irfjpsBWdo1PvasOvmXBFC8mkodT8mLhSeBJ/iJkt5SIOg1Vx7YSv20Cj3eQdb
         odrDQLtcRUVVKInO0XhD6/hhS4N0/SfYa7VlazsM+fLnbh89AG2l6YzQH2Qg3TlkAtnN
         1BXXK5IYXLHF3qBdUsNbRenxNs8lVXQ2XB/mMIs729ovghU6wyPq22rQ0NYpsmr69qL/
         TnJ10QZWBqDNcUXf95RXot72l4N0t1YMIUKxRUS5cYqxK4hcx3DfXrRJevMGfsS12bip
         md9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hBgVYCVjdYfk0aVRhelrtdNC3fQCPGI1gI+8jkOtitE=;
        fh=5lPIAwLoC7nm362ICfc1QOG5Etcpz5u9TosBcRhsOkM=;
        b=F47xyPoozQk0fyiYuaTg62CCtmp60KkzV41l0xrEt6JC0gr5jH4p/9MTZmV358kAZc
         LyJY0UJoB9D/hkmcQ3OHTXJTtlIwSZ38PkIQSeQzx5yFVkO3zwb9inAiBqomtGTTKtog
         4V5c1y73wRLrsEpu1cTLdRrvdT55vXVR2e5GuGQjcfFVU0JrtDds5FcvsWXWFvGyL6Q9
         f+dTgGExJSsxY2R7rKcG/N3Wct/s/G3ug5G5+0k3LxxHNU0IXzkunJaj+xXYVubgj0WY
         DI2y3aWC4lcTeMoQszT++FlbwzTuRUwP0GyIKzAQMeiAeBnfVaKczRTU5XxdgDu0VnOX
         Xizg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781716325; x=1782321125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBgVYCVjdYfk0aVRhelrtdNC3fQCPGI1gI+8jkOtitE=;
        b=HEF1TXyDkg/jNJbmX3Moa25NKdYUZBXBSK6jmRo3GyCFpt2sQ0OItSQBtjGxSB2VdD
         iGF3KA4qcE19A3SyjnK/vmZSqx7ntdovkDBkeK4cDN7vFEGjvf98L/I3a9uVtlWdtnGJ
         XX1o9CmWdwErlCiN+ztSq26wYDMJAsgQuMp4Kj1axtbzceBg/dXNo/eQ3t8qp4L2dGKN
         byDAvS9SlCtTbNcLzO4wVUzteCBDgCVsT7j/B3VUDSlEU+VN0z1Y++xoNoXOJGuJC4/2
         WsjVsNTa39M1rklxxZeNxvUQ+FcuwRRmF4NC2Ugy2FyflSFtAc9aipyJHp/3gYN3d1Zr
         Anjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781716325; x=1782321125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBgVYCVjdYfk0aVRhelrtdNC3fQCPGI1gI+8jkOtitE=;
        b=dAZu149Vl3eQIXSZL51QvxIwUWOFNAEFm8aG9blkorxcacOfePzMO13kUVlgh3zrxU
         IoKSeNRygRESaJjiJLd+buvhigeOWaq97p72WrZ3TY1v6nvGMFL4RXEvvQ6UR4m97VFl
         XVgjZLbR0GoDIU+Qrfh/T9VoXBUB687IutaAA8sIVVmHpx9LWRYtPs3f+aCzNf+cCzR9
         m+BtnSB7hzCIdjKmi5omJyfn0aDIXM6vW3mzERUJIJRzYpUjN1Rzulp0NA9oCNm6tPgl
         QS+Un3enW21SVDf0oYhEUhDIw+ARF7wt4Y1EbLoGn2c6DLynY3bfZFAYGtoEfo8BKwaP
         jlnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ThPOAwy4XhKPjEC4hefUes00Qx8lM4MMdggvDph9MCd5FTlWynAPFgAhMvwG56QUU139jtzLfKQ==@kvack.org
X-Gm-Message-State: AOJu0YzZS8X4SFAVbSfkYGNd2uYKh2Zxrt0ZwijTj+quPqiXzxMkDQy2
	Z0ak1b6i1qlUPTrLozy6sjLEPreKofRXvnj2D9SU0Y+mjeZ56r3JQLtAc5Y5UI59czMPrSYejD6
	Yc4X/m1adGhXiuC0HXLetqvMNha1eVsA=
X-Gm-Gg: AfdE7cn2+Pfgsfkg46GDoLBAlKAgN5pBFu0chL7PqK9NGssXPNY3LEYPDvnQvxFqeaT
	5wQC66OcMBGtZ3Nn2C/YvivdpJ2HcRJ1x8MR5DNj8I7CwZme08QkZzCWBRcr7h0yS1CSzmpEKP7
	/oXy+ixGF+kNsLe+BrKBIPQOj1f05egaC2s+PgONas5Ly3dtpPrHVYvrevCsVrrqLjKwzBQuOPf
	hU4t0hgQmT17qznjI96MlSmKjpTCbO382pPF+JUb9wqqxoDKSGyF4z13uStg6Y51p83RQg1AFXn
	Lar4kF+1ulwDK/Vh9VIdx90HFzmzr1GP+abNNxgpHA==
X-Received: by 2002:a05:6000:238a:b0:45e:eaed:afd2 with SMTP id
 ffacd0b85a97d-46233069660mr8853144f8f.0.1781716325060; Wed, 17 Jun 2026
 10:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
 <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
 <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
 <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
 <CAKEwX=NyfxfXhHESTLyirAgdVA6QaYAcam792-vSZdmo0Pz+bA@mail.gmail.com> <CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com>
In-Reply-To: <CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 17 Jun 2026 13:11:51 -0400
X-Gm-Features: AVVi8Ce4F6qbwirh2XAnhjc2JRmFEEfVWsLJJms1CDA7q8x1ucZACpOoqMz3NrU
Message-ID: <CAKEwX=N_jcaGaPYsUvVi53+35mJhZe123a+6T2J-MsMQ+-cSGw@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E688D1C000B
X-Stat-Signature: mxtdue1is1c8bq4mpr1n7tsic79i5msy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781716326-487966
X-HE-Meta: U2FsdGVkX183AySwoMQxFbRKTH4/1I5QsQPVXbp/7GijRkrGVhjnMT2pgKOeeVK/vt2VqEo9Q1wx2M9xL0eG2PVTm/MiF2bM3oxm1MKgOyK4uZPOCKcr0/kr31e2mPnqT/hbjq1YT2UEg9tAMg63aLxrPKnC1NtFrVKi4jliUYVJk3dHRdTiNTqoWRv/xHMFT4SRp8MgJYWLCVdGpylDfU4CLDZlIkvsHPa9sCwREMqMScXxxWHgL914URU409GYS2PX3GYAjJMRJ6SlIV1Ejdjzu3C8SKNw1QoqD4xlVA+9IoJqX3CqWCwJaLNdUkWX2QizabSMwdpGinGEyZw3McUs9kck0we4N+/+LE8EjdRetp7RSBcCh1uB3DgPwpzOF7y+U1aN8Foi4SjBDkfy+pr7LZea1+J9wUacvA51TDSLNiQ/ksnvmD9bRSifytt08QxIfh+OlnEMetdO20O5qJKgJpyG0VL417Ap5qnRu4pIvsTW3pooeGVyQaNGdONYVQYlLF20tFK0Sa9H2DHBOMolTKfcBEXoYqm5Rd60KMWffPUKQJVZpKcKOBUuNHolnpUIHzVzu6rVLpm7QbChjrrta6B9VGYlfzMvGZ98ddH9ADzAlNMoQhRNXnN3DiOrlKf0vpk4tQAZyoYtCK/cPWoq9f7Kbow3WUD9C52MF7hc5CjeJHOg0wLGlFHS9xUuDEysmUWd6/4ZMKVqJtMorX7NhHgvbaOhga8PFEZaVG1jwGmqeIYEkjUox6RFJVf2aIO2Dw6w0L9YnawBvJbWACBw5IHvELxYMMmSaeEMigodg3QAkBV2rpBZayEofM7IjzkgAz1dXEl91gYIueXpd4jCGJYY/j4fOyQ3ay6/aJwmmkHPz1sGFcZEBY+uhsOZp9zPVnysL6lm/P+ZhlNw8WUyDE8i9zKGnp56G/j1X/E5eKLBk6ERvyCfNiW3mxom/HlgXDS4tfwMRGFJyI8
 Fg0f9gat
 rl6gfROGwJXy1jtDSaPJcLCayaWaE+R6UedErLE7JuGgUkMslOs5RQvKPNt0FblS638Nxm8XuXToEqIfxNSDUORMy8bcx+/THpGpzJL6NV3tNMQM+VLk4a3tjvMtpJ0ZCu/EQqCG2fhyGGiMKwoW2mVO02N9oMszYX0PQm+GEIkopIobEYp0w+6WZ0X1apcsdKCL6BP0d+DvfO1fWL3bLpn2HjUYZbvZuIJKtCld1B1fQVJobrugzzFhqyqIik69p8pjWBj4hOLhdljsXOs3c/IuYyIquhrTw0hACAauU+9MEzw0p8sH2zTgwV0FOI47k3fQb/1Inj7qe8bCA9jr+r1tW6/Spc+6D5f6pLcC/ZHuRJhtOgWvpeGpcwVoxzs9EFHbKyge0tK9dtMh1hwIEN1FvqWenlLiFBwj+819X8GLrNaAqM4/y6O79zQ2dRLVLTVkgVD4whGgsBe8IQDWYElMysKpgB9K7SwsW3oUJEZd21EJjbXrQJiKDAwC9JUE/8u/NeAs68VEZm+9908144aqUbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 4:27=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jun 16, 2026 at 1:24=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wro=
te:
>
> Ohh I thought you meant we shouldn't allow zswap to be a tier at all,
> not the *only* tier.
>
> > Or are you suggesting that if we set zswap as the only tier then we
> > can allocate from any swapfile (since we're not doing any IO anyway)?
>
> Hmm, technically having zswap as the only tier should be equivalent to
> disabling writeback, but you're right that if zswap is the only tier
> than the memcg is not allowed to use swap slots from any swapfile, so
> zswap cannot be used. Very good point :)

Yeah the coupling of swap/zswap makes reasoning about these kinds of
things so annoying. :)

If anything, with vswap, I'll stop having to explain to folks why they
have to provision on-disk swapfile when they only want to use
in-memory compressed swap, and that's a win in my book.

>
> In this case I think yes, we need vswap to be enabled to allow making
> zswap the only tier. That's one gap between zswap being the only tier
> and disabling zswap writeback, the former requires vswap while the
> latter doesn't.

Yup! Anyway, I think Youngjun sent out v8 - let's take a look.

