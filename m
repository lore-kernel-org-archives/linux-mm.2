Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6976E88D71
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 22:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2991A6B0088; Fri,  3 Apr 2026 18:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A056B0089; Fri,  3 Apr 2026 18:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138A86B008A; Fri,  3 Apr 2026 18:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0207D6B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:33:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 939AB1B7C80
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:33:53 +0000 (UTC)
X-FDA: 84618698346.15.61A35BF
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 74C3A1A0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:33:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gKlVpuHz;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775255631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzu/7ISN0+xt4wDqduVVLnGl52TlATKkSUYDdczLfIo=;
	b=PheA8rxo7ON/j9HchixwWE6SNfeITvO7dF618ZRnHR8stCVGPj65PnEUAASbGV9uB3a/y+
	37lcNpfTF4naUMWMviRrrS6sK0WDd2NhSY+rs0rzQBh6/PcHlshyYH1yApv7DYsSVFBtzJ
	oJzcpdg+zjl6BiUXcN+TPJAKBBvBtAY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gKlVpuHz;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775255631; a=rsa-sha256;
	cv=pass;
	b=Q0M8Xpl6oECIASPOEax2h50c7ve/W/2Q7T00TqxnK+tgE32GEZR8U6pNQOHSSPFGYz9YZM
	/oS4xWh7Oi2gznLOAZEmNZVIwjbSzlPWnrhK7H+r2rokPGaYfidxBqvg6g2CybCeNCWsXo
	eNjwuXGr02waK3i6hofMByCXEJv3AmU=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6618bc129acso3100374a12.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 15:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775255630; cv=none;
        d=google.com; s=arc-20240605;
        b=PIGl6smGouVLdC33I6r+yvviggiSpHDAllxgbdgkKPXyjJFpLSvubSBZSH05MYT5Hy
         oAEnEGvCDoeLuDsqj0PcDzDlU1mB+S4yX3LURX4SC011ZZcxgW+0AnizUWGAZmfImSRk
         InSoFp+kjmARnT4fnplkaSdQnj8OfHTw/H3Jw3bjuObJj5UCGS4zQwytWwcxLOe068fQ
         i3xXlfftBZJgUmM1Z3RxuYzuoeE0lqGf0SIc6HFMjXBOGHFVFNJTaWS1V2ZfarNR87i5
         RSqcAJQJVPKGsN/wkM7omWi/Ny5pdz3xyfi4b8X53UJ7TLRcCe0lgK/wo57K8yohQpzO
         tWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yzu/7ISN0+xt4wDqduVVLnGl52TlATKkSUYDdczLfIo=;
        fh=kzfFjyW2GTm87XXByWBMC7DsVY+ty9/+O5xKlnDS8R8=;
        b=H55KAzHhjNTdQG9CfWmaOD5nnQR1ploK5P5hxfV0m8kFBBhWx9itypfj8afql5koUJ
         o0GOpmS0YuiiN7/w6glWYZGHdIIAXsnAq3yyLojxz9EnySY0bmaCQ1OML9obscGbpvs8
         Ry6AIPjpG02dg1tAJ7F+/BQbYD/UtESqelkDef9AWmIlnsMiYDc5wRYji1HQdTIiLBOC
         ukfwGhuZhs49smXvF3BzdgOX7FeIvlxqNvXtY7I4CAGqBppm6sa5VRvLR7Azrzx7KbOK
         RYsdrEE06i05UsQMn537ON//3Mfmw9QPK7s0eF5yONX1RGywDB3Y2onA1c6nK4P54f/w
         nJtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775255630; x=1775860430; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzu/7ISN0+xt4wDqduVVLnGl52TlATKkSUYDdczLfIo=;
        b=gKlVpuHzs8NXuNJfVFAS85ADBz7wuwcceMfxEW8zdn4cuCjvmIS5H6iwF2+uNMAlOv
         rYyNqoxLqhp214uDS3aKBe+3omiOVEnsz85rRoLK3mYdx9HoVg5U/ALO2LK234DCWW1k
         hLRfvvmOXsESuZx6n0Lf3/0B3WdKEmnS5tkwq2fgiJrlHQf8AtXZynVYVNcI9udXtVO9
         Z8f+Ri0DGYAFsc3NdEyvkHdj9LFGPsWca+LhbkIvWsiXsHEAuh1FkhCy8Re79Z3QZvkU
         X6uTjjG6UNjN8h/KYinecsm4QjP7TI+jv9cVZAljoxz+EB2XIYFJrU7PC3/bHJSo4mjc
         pe6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775255630; x=1775860430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yzu/7ISN0+xt4wDqduVVLnGl52TlATKkSUYDdczLfIo=;
        b=S/JdvwwhJ/lqUseC1xnewXCRx0MFANCk1E1Bnydkrddmt4jIRW15z/RoYYpz9fckrk
         xRbsGw2JMBUZf3Zto+pQXtaSvOkJaUUo4fLKrCFJhIJT0Ox4xawlySkxFb23PHighXgm
         yfviIuzwibGF0lFkTBJEMG5xO5H+MRpwlxMmpS2j4vQxXd9VcYipHjd8aPkoid5PmLym
         L0D9mx5vtglnt8pcS/0H8V2cLhTnatbhtG/6xeaAE1hjXJl5JaFxaIQkA3MomNUCCeLJ
         IzwMkBwOQf1s2VJo9WxbMr2r2kq75WhtDn5+JJIM+fHGKYhkAajDAkchvosupoz+zYQT
         0Igw==
X-Forwarded-Encrypted: i=1; AJvYcCU/lpPWDzORyeveVP9JVS6XSixjbkDl8AqIT8UdMq+Jl+n4Md2nbUBS1X1QPHoN88bRqaEQM7bw4g==@kvack.org
X-Gm-Message-State: AOJu0Yw8qPz0NUjr/rP5zlO5Al9+7uRZmf7i1J0x01Mwlkgj9zlvdTy4
	j3emRSrnQhvmLiKQmM2LeU5ZJLEQckX8oo9erAkSDT2A57MvKTLUSnemjsCHdvp6FKFL5TEcG2T
	xSthzK+eAygbUs3DqzzqqdShPA6b565FqzGx/FY6luQ==
X-Gm-Gg: AeBDiesD4SSMxP/dKvk7RyscGBFPvcLET+qADRliCkOv7S3Bs3Em0eroCFdAX/il3sq
	gZs9J/+L3Dzc7X5PFubDRX6JfFixogWMUt61SnmCp48B6463DdhFM2GLZ52jcReczSIHkLqVPkD
	blVSw+yg4e9gGrHssj2CnPlvrYAspGmpFdEHUYm9LSXk+31Eyv1v1/LrGMlAd3T+cFXJyruKyBk
	4W5A6PvlO9yB0D5VP2+J0IpoJRsOWOKS5+A0rrBGFAtnhxrNtEs3gVkwbcRbN57pH7GKqiasMDx
	iQDVfdhLLCGdXFNLzKAzq+A8zyhiqOWukxFXTQ==
X-Received: by 2002:a17:906:6a08:b0:b98:44b3:7e95 with SMTP id
 a640c23a62f3a-b9c67b7fdb7mr227433566b.40.1775255629620; Fri, 03 Apr 2026
 15:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260403194014.3704180-1-pratyush@kernel.org> <20260403150801.f42e27896fd2da5db6ca3425@linux-foundation.org>
In-Reply-To: <20260403150801.f42e27896fd2da5db6ca3425@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 3 Apr 2026 18:33:13 -0400
X-Gm-Features: AQROBzCcDPnwZI0D7T5sCVdRGDwIktnyvWZTlqb0GhyONyozrqjrEuFs_Tx-qQ4
Message-ID: <CA+CK2bB4nn87FtaH_1VZjZYKFzWFi9gDtHngKv8bkzCqi6oLyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] selftests/liveupdate: add memfd tests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74C3A1A0007
X-Stat-Signature: 1jhqak38hmujjkuonwpqji886ojuay35
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775255631-58693
X-HE-Meta: U2FsdGVkX19jNnKg2lMsN/5q9vUjIOC4Zf58HSS7U6fcO27Eh7Usw15weWeQ60PWVCaXBZza4fVcp9s5ERTFDeYZscVRSYUqahrXIuqb/r8qWusFAo9IeEcXbySIKK4RP7fjLxZdnaN3/eHFzqubMIstGDHtwoSUAheM6j5an5bAG9yhlLqzwqe3lZ/kpgkdPXBIj0I0+iB1SxJdS330w4DF5di7hm3NHr7ydxmmOE0xyobQNbq5Jl9+ivMWOy/gN9R9Ox6rVCQ0ldeL6gxs07itQfoeel66Et6QCimRIxXUxCv8C0TQ+cFNL5ie9JUf9n4aFogPBKV4S/ld5xsF/8v5TyCc4SwGtnPFBEgqvNCRBA47u22YVMudK2EO2wAcWqjMIRwoXunp7s9x+Yn6/rfGDqPsw9pzEZQOANjSaUDhApJ5tpnjfWMO6lTRr7tqxG+zsEwl7VCS5+xMws6H+eWycfH1vPwirdsrJ8R9bUuEfefK/Zgz1vdABjGHazJ3uctLZC40YveJFTZg80yQanBwGo+dehJSnK9FcnqtDd4oJX7hf0G1e/LfCTKLYV6EgOLQJiUYvLmaL5Lf8Ca83ih9NhySrMvkxIVwf13dKZA4/qsjKJpB0/+b4JfPan/vv4LRRFTOp1N8mRoAZ55qJGIC737XFSCcenJSzn5XeM0lAHgw3n9NNA/M6rKGt16j6lkdAz6+p6zO3PGvDvYgO2xxtstLGdF/9PZkjLh2GQVtp7PldMBZmBC0pTXkqh3BPDlnbfi/x4OeX3mTEgowz7pB+M2MQaVgN5Ls+l1UMtZymgQHdiPaMyH73mAQMQ9zsFtaMqlmN/Phv42D3Kiym+b7MllC/+JyHgfQEhLYT6QFPDqmaKsG161+RhN8pJkoRvDvtxd8gML+6+uw+9fTbaZZ4vwOs/cD1lzVkbop7ZNHWuNIU0UW/WA5rEa0aMG69Z8uDL2UTFwoXmSAOwd
 GF++4wSn
 XqtItvbr/IqaCo2QVweVD+3rLuBNnexVOkLRv8e4bz5w9TQHZqoeF57WSQPE7OXPyfilfhAaXgI4OqfZ9nTeXm+bsI86RHwM5JPV24Zg5WbzZks6L0DiHT9NBQXKSxzU+ByBuH4Dl8srzU4bL0j8V9Rjen/ZTMCszduC/szBx/98kzlkNHw1xUscheBNlS4rLxpqZZcrAC0ylZccuhbBfQEZuqk4qLU4yZ89nLQc2Omdx/WMLlhdZag0bDUuf7yYGjAG1RshXgtCHINXZtb73RqjQoonIGDsxqqXChqbyfQhufXsohRjNvbw74Z0caQpoNEhjJMKLImJI8sNpYnLpgUmNUPQwmEDAJCTnUbvZu2HltDp3cPyyE4Xi6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 6:08=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri,  3 Apr 2026 19:40:06 +0000 Pratyush Yadav <pratyush@kernel.org> w=
rote:
>
> > This series adds some tests for memfd preservation across a live update=
.
> > Currently memfd is only tested indirectly via luo_kexec_simple or
> > luo_multi_session. Add a dedicated test suite for it.
> >
> > Patches 1 and 2 are preparatory, adding base framework and helpers, and
> > the other patches each add a test. Some of the code is taken from the
> > libluo patches [0] I sent a while ago.
>
> Look like a nice series and it comes well-reviewed.  Maybe my "we're
> all full" policy-making should have a selftests escape clause...

LOL. I noticed Sashiko is uncharacteristically lenient toward
selftests; I guess it sees a use for them as well.
>
> I see that the malignant gaze of Sauron's eye fell upon your work:
>         https://sashiko.dev/#/patchset/20260403194014.3704180-1-pratyush@=
kernel.org

