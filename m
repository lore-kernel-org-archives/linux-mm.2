Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C246CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212468E0005; Thu, 23 Oct 2025 11:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA4D8E0002; Thu, 23 Oct 2025 11:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1006A8E0005; Thu, 23 Oct 2025 11:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE8DE8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:05:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD3341A0B58
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:05:11 +0000 (UTC)
X-FDA: 84029702022.11.F1E3CBA
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CA06140020
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:05:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JXQ/NKh/";
	spf=pass (imf09.hostedemail.com: domain of sidharthseela@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=sidharthseela@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761231909; a=rsa-sha256;
	cv=none;
	b=KwNWjI89DXg+v1fwfR7WInWxKl8OlE39mdajdEemo0srhQBkBslZiBG3SlDVxfiGJLkuso
	6Dwh1rNLosMXcGu3bXv9QicO9vrtM/ZDdrF97s1Ekwmt6vM2/gHmWlHiexL5in5RcevjTd
	0GhwBW8m3Ys/tYNU8+ITDQ65379k+8M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JXQ/NKh/";
	spf=pass (imf09.hostedemail.com: domain of sidharthseela@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=sidharthseela@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761231909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0g9O1UAQmliCyOFgls7R54UMarfOxqkSzanB1NMWGZc=;
	b=k1Ei99pSN0ZJ4DktAz5tFxhmh9xTAEQcccVpqLsY5aWuidbtKZtdJWFBmlIW5rJTAsgMaU
	0xFrbhpqPiTz8v2cYzF1pzZCiM8qEQS76ZGntrUZD13dRFtOHKE2nRGt8cckR1fr48VYiw
	qmCf5RyAnR2JbfoIMlpJuEWi9bISP1w=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63e076e24f2so1973012a12.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761231908; x=1761836708; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0g9O1UAQmliCyOFgls7R54UMarfOxqkSzanB1NMWGZc=;
        b=JXQ/NKh/ByWmnBG9X0ywN91PmtDUObGplUITo3xZz1Ekt9MjWVfPTDIDnXuW/Q7NXl
         /aQhvmWLvPoneZXcLEW8vCW7atz7/sossx4fAwv9xCoUhYsT2g6DILkaMehbuim4dTeV
         /u95EVhPibpX2F+onJqZTuIvhJKUmd1agaT/mhb7W8h4wSOymi/cDkKcr9/XIkE5kI33
         +Hd/fHfyTRwCzKtuRDiIUx2OMsu2NoNTnRn6LNpZ9zomUrShjxAk+mXlfNDO4RivgfDo
         mCVkQYI2ZeRDUKGjHCRhzPR+YmEmefAYhfxLMzTHR+49QR8Gxx4xG212z1BSA76et9yu
         wtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761231908; x=1761836708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0g9O1UAQmliCyOFgls7R54UMarfOxqkSzanB1NMWGZc=;
        b=Q+9Q2TqWzgxTO1LGp5LEkYkJerB3xSFGOdmagmxSpjZ/0y2U6Ose+KZuWJ8lOE1tGq
         j/C8DQhPjfS2TbLMihnk0FVTI0EUhsaXSuLNX3jhUMFdz2kY3h45c/Q2X03YWNO7f6wh
         j8WHhl6EkQNCI1mTF/xjc+WhOLiJJYdQ179aA7gNPmd4ztSOkOootZ5K5/tS1WE0JMhD
         LT5FPxTpvqEDR7eW3Vh5nAbqT9Unm5kWaC+uKE22dOacX7Op1FICE8TYo1GJKEvMU89K
         8FzY72amuqIfz5lxwnAIGzrMbTzIJmgqDcjqCFN9jQea5mYy3zyarXO/dIBgm+WXDaku
         Kfcw==
X-Forwarded-Encrypted: i=1; AJvYcCUNUEE5OW75LaNyqiVt/FcAt3Rws1hy5sCVChuBtVRi9kmVPOJelqCFRCGYRgATC/7dBKLyzEbW9g==@kvack.org
X-Gm-Message-State: AOJu0YxZoD+ZNzAgNMM0NQjWeyhgFoC88PCAv3/6uEMVJs3ZiAsfmmul
	mXhsmCX0UXbYwZSK4lB/xKwqj56q77/UhwVMBGhc3SuRFqWE4LIZ/ImRbLuQCohlLKi1wZ9UtJD
	+ZWCQSyVtmw0yFhPLvn+ZkxHiI1cPK/o=
X-Gm-Gg: ASbGncuxFlidvzIEbYj+KvtWnGbqFNHYczNPhXr/d1PYtV0bj1E99khDnWBDgkv1pk0
	DiuOWYhrp9eNlJf17liuwPOohPLsOIwNbuLg+S7c8M8a9/FgjxUoWdnjw5TOVMTbBzRBFgKu/qf
	X5p5NbILvEVnl6qRIdRq9ZiexbioONw/gtmf23RnRoG+RAsj+mDRK1h9oAuvgu8HIcW95ITGpPV
	+Dq6is4ZVCeSV77GiF5OeAyLdIEb1JkhqyXvMTUhoGgNB42T+zQYyXoRBLlb9P1pkL5PHe0s1Xp
	GUJN6kleLgay0tFp4Z5zu18jhV0Izw==
X-Google-Smtp-Source: AGHT+IHB8B5L3u8WbMDNbmjmms33DeNsuKSJCMufZx22juNs/gndSdpSi8DIUT2dxhoELBY0BdEhQ4H+/Q41jUC1tb8=
X-Received: by 2002:a05:6402:1810:b0:634:4d7a:4d94 with SMTP id
 4fb4d7f45d1cf-63c1f6d9335mr18957800a12.34.1761231907807; Thu, 23 Oct 2025
 08:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250929115405.25695-2-sidharthseela@gmail.com>
 <486e0d6b-799e-4fec-9e6d-3ddfdd64418c@arm.com> <cb30af9e-c22b-485a-a83c-f395880cd799@linuxfoundation.org>
In-Reply-To: <cb30af9e-c22b-485a-a83c-f395880cd799@linuxfoundation.org>
From: Sidharth Seela <sidharthseela@gmail.com>
Date: Thu, 23 Oct 2025 20:34:55 +0530
X-Gm-Features: AS18NWA765vw_3LiOpRHjjahBitbX6N7WFYKyQWJzAW1GbNsAm0JUy1d7Tv4rWQ
Message-ID: <CAJE-K+D6ODXnMtS+pbQ-GpyTy8PLyycqK19P_EgnZzKbKwoOog@mail.gmail.com>
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under label
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Dev Jain <dev.jain@arm.com>, nphamcs@gmail.com, hannes@cmpxchg.org, 
	nathan@kernel.org, shuah@kernel.org, morbo@google.com, justinstitt@google.com, 
	nick.desaulniers+lkml@gmail.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, david.hunter.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 1y7bbd1jpgmjwcuc5im71xn3omj54spp
X-Rspamd-Queue-Id: 9CA06140020
X-Rspamd-Server: rspam09
X-HE-Tag: 1761231909-699481
X-HE-Meta: U2FsdGVkX1+vdH6BgA23jkOkn7N/kont8TwWqi3fMbyqntqGv18EN6aCLFWDSSEkSnLncR7XGYhWKs6u4kU8RNqZwr6BHJDH9WxQSqWyGZiKGzwA39IO1128V17u2vy9jGXOWKxn/j8F1z6bN20Rb+upLIAC46H+MwJomUjkz2a0qWlgI5cLI5zC0HONyTuZruETenWBcSPwgKUKgUxmHRNDDJPLanQf4M1TVY77gn3KV6DbjEggFMe1CP50/mOVDcXQXA4HP8dL+0ilf7U8NhzOKCGg3xp10psEEazLD6cQBBtDGHSfP4x2N7JIgV4g7Sd+pwgyTHvg2ryNPOAWj3ZUyis8sZZlK24MXeHwBzj1JN/rBXML4/kYOeIEbwRqP1LQbZ+JuvM3atbBfWB3G1jz6s91Cuq36/DsNNrtZ94RyWYBx6vdhb0yYssN9MphBuRvYo7rIAMDKvyZGTB175OlfcakC8WsMbVYQIbst6F3nB2hYtF2UCnU7acjv06SinmLeRShCP6vka8t57ElvnGO/YhBwyjLit6PGXVEWZGCcJS9rMQhOquTjfQyEyyF2SWC5whWtRBmbUAGg/uOyNnDci6hcTsWq2Q+0Qg3HvPANGwA1jkF93seLLkYsdiKY+r4Ey6n3av6fdyxqnRSWTuTXKbtgR1olfUuSMzstH5G3lpTpGnaR3j8dR9vJ7Sml+O26lLpNK1V0BrvH3W8DjOyhaJomgb1+DYegKJQgHCtnFaz8LiEJtuYQhHUvaRqMC8U/ytaQ4nDP+wYCWDPDHp0UTRxmgKjCxbOmNiG2qXgM3aUuGnu66Stu0gOWk5qxAEF1Ta39BgI22RUiMPNSHiClqSj4n9B+NhGUt+CGSQ9Janm4czYWB9YRHAFTTHAwjQoKD6vpP03F+CNZmxQaTZbIp75DL1Bwf7/sJ5mKsvtT0tmLG3O6QixfrAQ+YZgWWfgMGDvkVMGzVl4gRV
 zr+wdx+t
 XZfR4MUKWMQnlh+SFMSL1kuNImKI8/NJfLY/ZbAokvWTnn0AuVFpGnYLBU2+CrjVPNGt3mvg1HmGuXaIQar/czGnJjRwu+nti4LYN+96y30+IJWSS15p2DKzDHxStCM7Zndh/p6DbEyFc7Gvh4EbKU7B53qzOZjHUS+fgoTmVh+3f9Js9Tt5fki868oJcuW7+tBk4jzvB0JFJm1KcErrI0wmzpIS7E8xBcZFnxwEb6MXxq30GtDZ4E1orQch2iwRolfbazD+PEM8vXjEpetIFijuDUf5dcHTaAip9/1nCW/X3q1k3Ew12SDGEt3QtX2MpK5w9ZxPsNmWeMK6IC0WufNmNOjG9ilOoWvJJNnfqm/H4m0xU8hRmLvR0GPn9bIzR9f64NLkLgaT1N6iQntkLcGl26yU6uHPjFwpOLuQRwMzyNYNs7BxSRN12nGiwMEVIg+vWqTxArY4V2To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Make sure to not use "---" in your commit logs. Everything after
> this line gets thrown away. I had to go fix it manually.
Sorry, I will make sure that doesn't happen again.

-- 
Thanks,
Sidharth Seela

