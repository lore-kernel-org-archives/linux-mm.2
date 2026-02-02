Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C74E7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514E06B00C0; Mon,  2 Feb 2026 12:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498556B00C2; Mon,  2 Feb 2026 12:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B0F6B00C3; Mon,  2 Feb 2026 12:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2669D6B00C0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:39:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE75DD3E1D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:39:22 +0000 (UTC)
X-FDA: 84400228164.02.A3F6167
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id E20EE40013
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:39:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=cbm36RDH;
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770053960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRXzbgEycFnDgk09JzlrIl+9d+Uh4VqfyN7u/QWr/ao=;
	b=oNacswdiNbMh4PCo/hZ48vw01u9Ahw+V9uEoRZ2m3vcETugO7Wrlpq71xDTWT4i6k++nJx
	bKzNjvS/NA4ZAGyE0VGSjjVGsMUF5ULr/gK+d/heNj4T6ifHhzgC/I2+XH73F2n3nzF/s8
	0yqRaG60yec4n5xsPpX8p17dkprTQwk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=cbm36RDH;
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770053960; a=rsa-sha256;
	cv=pass;
	b=UEB3aYRV6mkgeT8F/ZcNQ2n8AGiVGSrn8JpsMbjfZnOFPMweHUNTbnEzwJOmoc5G5RxnL7
	VDUHn9piaevcO400utTtcJbpcY1Xzi+L4MQi0Ra4b6dw2xjewjmpdNM2bokbfplWLXD2VB
	uxXPRfa2yLd8JYfwXMN2OOfK9tPbIxg=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34abc7da414so2939915a91.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:39:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770053960; cv=none;
        d=google.com; s=arc-20240605;
        b=hfHfTTSbJjuHDiIV8ISBtYKJXPhspsFXLHFMjrIvW9zlLlQGzXovXgQXHOfqkG3Jfz
         6TlScBAAi0Vshuurk0QJklxhel/bMmjHvYfuJ11s+eHPFAWJ/2yOsVERwWo+6oQ2OqGT
         nM/DrvJ0XjlUgKHaD79SmpkabR+gcLryNkFCfUJWBfY+7scJFe306lsKTdvYPSi65wUk
         8WGfoyW7wA30Ah7dwE/H5kao2z+ppF41WuNR3AVl2HFEYiN1K9GPTcH6srBGIOpECoYE
         gNimgRl6SkaKB3acFpFktXocNvdOU9yMnpaPCSQkDIX2wtpbfvOpxEDosdpNmEcdsYGl
         okSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IRXzbgEycFnDgk09JzlrIl+9d+Uh4VqfyN7u/QWr/ao=;
        fh=BHmCwmdL/pnA8xzzpnCivKE2YoN+h/fuG4dc0ju7PJo=;
        b=LSpxm7cLmlopSBiQoyQ5RZAqEKIdMuACYRtFC6uW5kGMlnf7X2P07sB10L8q+05y3y
         i+kHHmdD6slPPZ9vgzQE6/TBi076wD+eaa4lcQ3vkB7uFwIWdeQ53ZzuuoeJed0ZuFNz
         3pTIBQpbMxZqDGJu0iZPcU9Nw6n0cjEgz6EODbAk0CcN9cMn12BZ7U3/mC6cYxeLf6/q
         p7UVCZj7EU1DbJex5l3uGd4NqkYAFiE3XSWP/4/gb93dqm/mR5NJqMXXM6yrqXE9RGGN
         UPUdXWhpFr0dyURwbRxSOGDea/R0ogZ+8e9QNdLdMI+c+NzPuuz+N8i05mL0PD4g9f/R
         6hDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1770053960; x=1770658760; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRXzbgEycFnDgk09JzlrIl+9d+Uh4VqfyN7u/QWr/ao=;
        b=cbm36RDH2FIkTBylCSr6xT76/u33/m2L9fu0JLQ3kFe/D1PENSZiAC+UCRWxigH3NF
         z2d6bcOhFgROo+YTrN2FxAEH34fu/KuQVgbQSe/nZsca3BKlqfgcevjxf3ONhSXFH5gY
         4Grwa1wZiLCE8UrEKanGnSHYp4I8X6euGjs9CNcqOt+H9Krm6muZOdQI2/TsAaUj1H7p
         9HetosBt4fcmqfPGuDtxfmj263MlEMebKR0l5ZlpZwS7/5G/4vuIdi3+oMxt7I05M8dA
         JCTbTvwCIJR+vp0Feh4fSdnTfH/9LkR+xx+XLKOpBS7zHzvvJFfIou5zQMAlbLjDNwNa
         FVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770053960; x=1770658760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IRXzbgEycFnDgk09JzlrIl+9d+Uh4VqfyN7u/QWr/ao=;
        b=p5T44CUEMNrfPUCaanlBPpLSWk11ToxdFtNY+QKNdhurP8/sViEtmoLAo3dn7Icxxg
         rR2yMhmCrstEtrSsRN/vW707EY8s7dQXkrNAd0OCoL0F1UEj3t462neaX8eEmsyHc7Bw
         qK0Mgd/mRZUk4Fzydd7WuqW/4yayT7RbvtRXeFAgBHKxa0zw5WBqpJJHJIOPH3q4I6/r
         9Q4wWDdmzvWLQO/8uv2j4BvLwVkfSwoVHLgEl0x9mCJLA9QkkL4rKCPiPx7EuDNl37CE
         dQ+4o8rvk6Oh368dU4Iv/FWphctV4lbq5MBo51z/5ae44Tqu0bmbEMGgasr0PRT87CDA
         hkyg==
X-Forwarded-Encrypted: i=1; AJvYcCUu+kZ4p2twxfvP4Fea33iRCPqQP2ei0DW9gW3XHaSYnlsLxFo5/5+bR3/Qhr1+t+x+i0sY0/8GKQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6hsW2xWFBEQwrZxn3DRfZBanOmwp3py/OPXLFM7NSgFb9qcZ6
	iCY++X2Dj4YqId/OYOOcoPrKSHSMGvtv8Ipd4zFrSigQQmQS/wvg5M+BiCAPAAMA1YWDRu6u3Tz
	FIwkAzyG/2aOSjJbyezNU7FdS4U/ztnFydsIeYXK8xgrWRP2FvQZXog==
X-Gm-Gg: AZuq6aLelS7lqmBPvkfkY0E5qvD5R1PEF0VIdnWUW3KRyKR7KYqmW2vxMDbcOLZsW/q
	Hy1VhlKm/BEgHcvRL0ACn962nh6KtdJUihVqLJ7R6+OuiwjP7Rd9947taLVKBPzzPpVw+NK5YTq
	BQbqVbE/XnX/dOvzgMlwTYdepQKohDcjfKEVhq9v/i87N/xzlt54HnyO0pWRzMx7dsXzpFgjHF+
	RP+UyfGuTIAEJOL3oUyBOpaUP6id05AX/OHUmr6nwuoO9hlCe6JK+X6zL8XXdDVDRkcfN0=
X-Received: by 2002:a17:90b:3a48:b0:34c:aba2:dd95 with SMTP id
 98e67ed59e1d1-3543b3d1056mr12185565a91.26.1770053959750; Mon, 02 Feb 2026
 09:39:19 -0800 (PST)
MIME-Version: 1.0
References: <1840fe300392f962e0bd444941c24969@paul-moore.com>
In-Reply-To: <1840fe300392f962e0bd444941c24969@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Feb 2026 12:39:08 -0500
X-Gm-Features: AZwV_QiBQLAbglCMvo2tNwGlwgJGTW-pFRFhiaXYWcBtkktHOGbkuygW9A4h3fY
Message-ID: <CAHC9VhR80ZipmG8PGTdfvY-GpUsvX_UzND-XV6s844hbmO3BTw@mail.gmail.com>
Subject: Re: [GIT PULL] lsm/lsm-pr-20260202
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E20EE40013
X-Stat-Signature: n6hioteojccm1mk1ztqiifmph1siwncg
X-Rspam-User: 
X-HE-Tag: 1770053960-974408
X-HE-Meta: U2FsdGVkX1/tlwOM7Olhmk7hNHDu32II75voK+p12rxDSiTuZrZuUOQNEdo3Mw0s8qwgCfFumYDeb+3bku+nod/OggwetEcFWdIg4Wr+XicVhdAhIPD66A/Y7xZ/ElF3D1XGFAPWg3AiHTarTAtGR1WYHsdQbUqACSNMg1583+djNjd5EbhIyB+NvcIIAHdvZTeOzDSgtLV1FBGe1qygu8hm28UuERlr6n3tmY3WExz5vKvV60cFssTL6xwA+lzPiZj7bZzU8ck2oZU+vb3arwgwl6cUwwexhdEjcopiNeAF6YO3WMfl06NdzgDN2Il/sDbW8kpsbVuelg2scGKL+TaeGO3df38PX4yHCRYFUQL3J6Az3Jj8toFXMHlBtCFeymgMHFBixQMbJzqjkAfYGxcw+o16vuYebgYHmEqTh/EXIk7dMX3NBbgt3ziHo2pkP8vPR8A9MwCEZqdyXEOHm2XWD86LIO4YAxAwsYo/mL4GmoL6C1xM+KpUwKedYSdRZ8IAWoZ1iGRoUqym1d9h7TYbgzmf4O7aUMaduhNCsxZVLPSMiJ5ECRTwHvrSCZoKaLkDJ00ug2DnmQjqvBRRXZ7nNj4mpr4ZW07bwwGUy64jGU0DzAsHuDEgLTfm45Z/xMr6xlPpV1ctsORr9XEEMJNa7PsdiUrUVtsx/jGpL/Z/DDDDfJJ3bLYHLuEZIwUMCxt7kbesg/0SApVtEMpZ+72wqr82qF5tW91b8jbqLhwZuKFF50AF1T1WmPm1AP0Ug7MObiZMjK5qVBJeFMPDAizI3WPzw3rYxsfs09OCAJDpFg13pZQbYW6Kd3uJxi+bXYnFlWvLJMgyXjltN7+ccgQ8Ocafluyw7MxwfU7F6GFonx8gZj0IuLHPpvXJoUkNp9S++/v9ONuArapwB9oOBbuW1FO1feWeJbQE9FwmTJdrf0a09Z1BWoeH8A8rCvPLM/8xYeVt/foYfoaED1O
 fd3ml7/B
 DXKlY4uPtweJ1Xj6F2TEtpotXnjFZ9Kn0QIJXhUBCa4rB4ZN9QNnxIRR5tpKq6qMDmgdx20i2cOuk0FQga37pzYrlVP0ck9DYqp8gWZBqVD1Bc7EnTykot+fwArqLYsT6GbsvhG3CjZ4K1Ike9CHtQ9zz0a3QM/xTr0vGhGLdv4+ostwyo1OsM5SimV4CZgbZ3W6aF+0xHdUyPHszn0FOjcvIVl6U2Md7FoRju7zQgJQUeRcN2Wnm7Me26vcIiZ/n9D9Do7WowFXW+PAOp7vOGjFFLvU2XuTAKNkQonrhRb+mbb0P+YZGcpYaRaazCWQuubefjJMBYQnY0Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.030543, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 12:37=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> Hi Linus,
>
> A small LSM patch to address a regression found in the v6.19-rcX releases
> where the /proc/sys/vm/mmap_min_addr tunable disappeared when
> CONFIG_SECURITY was not selected.  Long term we plan to work with the MM
> folks to get the core parts of this moved over to the MM subsystem, but
> in the meantime we need to fix this regression prior to the v6.19
> release.

I forgot to add, you'll notice a forced push on that branch, but that
was simply to add some additional reviewed-by/tested-by tags this
morning that I thought were worthwhile given we are currently at -rc8.

> --
> The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd3=
77:
>
>   Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git
>     tags/lsm-pr-20260202
>
> for you to fetch changes up to bdde21d3e77da55121885fd2ef42bc6a15ac2f0c:
>
>   lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
>     (2026-01-29 13:56:53 -0500)
>
> ----------------------------------------------------------------
> lsm/stable-6.19 PR 20260202
> ----------------------------------------------------------------
>
> Paul Moore (1):
>       lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
>
>  security/lsm.h      |    9 ---------
>  security/lsm_init.c |    7 +------
>  security/min_addr.c |    5 ++---
>  3 files changed, 3 insertions(+), 18 deletions(-)

--=20
paul-moore.com

