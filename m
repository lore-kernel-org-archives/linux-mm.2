Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFF310BA436
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C936F6B009B; Fri, 27 Mar 2026 04:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A9F6B00B7; Fri, 27 Mar 2026 04:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81046B00B9; Fri, 27 Mar 2026 04:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A25EB6B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:02:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FE42B8E8C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:02:20 +0000 (UTC)
X-FDA: 84591100440.01.ECBB3CA
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FDAC1C000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:02:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxQ3CdCZ;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ep9g2m9wnZ/qw5uP60q9XJwKT04QFSPHpz8SR3TFGU=;
	b=Yb6CG6/tySnpaspUI8F0ehSo1UTFugm2bW4ZG5TS4cTpKON0IndzeeCQTSrh/c1UTGyYn4
	aGHLPH9xPB/GCIWH3Ihcif1QzqJ1s8QiGwrPB3HW6DLn+bpa3Lfja+HVBJASTnt+IxRVYr
	ln8Tx0cjaLOkF85XT2alktKPTA0Vos4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxQ3CdCZ;
	spf=pass (imf20.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774598538; a=rsa-sha256;
	cv=pass;
	b=h4zEkZUr+0DWDqKjEDVVldgSyExzwAiMac9Cimk7C7Zze5Mhsg7XgT4nU7HoSV7RH3K4Hk
	0NoGtLLvZUA1O5tUx1T+3qmcc5c6x6R7TYfdC1shDy3+zN0v9oIvDbpU2xDYUvi1qTp9WK
	lePyC8seEmmpmH7al+Duw1/EutRI6XY=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-124713e4244so125119c88.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774598537; cv=none;
        d=google.com; s=arc-20240605;
        b=Edt4JDXNJwWrti72+nmHPTn3SjcsyW3XfBrhEn1WdQDjxEGtP2a1QIxsjqrSeRbcSr
         zG+kkwfzoXdGCXTa9Ad6j4u3o9tM9gF4Caj4JOuhoSCBh3mpbOb+4nlK21nvBje0WzQg
         RUlUXV/NUAPzhG3WtBmMIs4xbEeFSWS+FeVm5L2aMr/q26/pfdKfr5OtL4cd21Ei/doP
         Ow0fO1y7xN2q1eliEesPsCZH+GfPQKx+SYwJkIXurnGWoG7wVjscCksORow1Yrpy3xlS
         dxrcHtgYIzVetKY9YNLQ8VBG01b8PxqTs/xZN66ibKIZankUgM23DCZikiZB5wSaY2U2
         doZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5ep9g2m9wnZ/qw5uP60q9XJwKT04QFSPHpz8SR3TFGU=;
        fh=KRjnemEq5fktKLBP67beoiTEvWcpEFAGoQd4vDOIuEc=;
        b=aT6oy+Fnw0TcmDSauCwKJTYFPCHFxiJrNnekBlT11JMeNulYnEVVed3Y5QbJp5sAAX
         HUKC9Y5zIxMdT09Yj8dTVDq3Jny78Jr7DhEMggc5loKQxUi0MQnSLWK+8TbqBDx/3zGC
         YEwYjJlGw6cIdPw0A7eTRf/Qa/ILq8JyJNuwiDWKHdFPx76QxuFQD7ntqjF1x2xgSAHp
         NngHO0cQRt7dXfdB7qMI8p+pMLTwfufLASn08brLLw0IW6AjHdNZeRscArP8GVeALi2x
         TU69qufAEZUMas808cXao2Smhryv/iNYfX+CIVzPElLr5X8CG9QluhCfQN0jDh9fJfqH
         8H9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774598537; x=1775203337; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ep9g2m9wnZ/qw5uP60q9XJwKT04QFSPHpz8SR3TFGU=;
        b=BxQ3CdCZWrjn5FSpP82cvY4YfMcnq01CKQ/KSEILAsQQeQF+jBYVyqrjbjNB6Sj3iH
         O+LfqQ1o+/ykomgOeFGT70wd6uUyVGtZcq9deKnZIYOeRlkIiIeSN4Emm1OdXdEfJOSG
         bM/xSu/M86xYCNCNjPVhAx1/mfryRRG5Ejwwg1PfSQTB8Fu9Htf3t2rSwEhIN2Cw5iv7
         eHRAL+3fTiJpzbdZ4Bd7XVZ1DM4wt7GNM9sD3j0oT05NobD5wb/15aJXs69YHTPFIVcE
         /sdhjMD9GcIdZPNlvE3jvJn1DQ+SZOt/e2vGzaTUjyPQiK+EVQO2lacwvNcKqH3/rzAW
         VAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774598537; x=1775203337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5ep9g2m9wnZ/qw5uP60q9XJwKT04QFSPHpz8SR3TFGU=;
        b=caoXVOk7/ogS1jEmczegF8MmtLJgkUmYmwitUY7Q83SZJbx3wC9B9MXbOsZfGJ3FEf
         j2C9flDdJ7FNWvEmtck3cAYmtNkLJmrYRPZfmwDv1f3YqeAbCY7xXiI3w0GsOBWFxpSR
         efkq92Nw36nW/Yo9LeZUIjSyGaAdQNUmm91OXY4RdZlxYm/VMeltAvXkuBvHgGyXkGHQ
         y17rto6I8SsyO27UTI8Fd1AyiJ2ObAzozMO3+a8k5dCSBSypJ89kFVwlFvH6dckyfRmj
         zhbJSQirgepaGEm9ZeXNyyA5BJtp7z6VxHij3yDxHH6nYNM3PYGes3RMCFPPdJBNAead
         LUAg==
X-Forwarded-Encrypted: i=1; AJvYcCXEIq5AzLcVKB2aXYv1sHX3xfwjU8w1SOaAd3aFNFL/rPcNJuztq3CYCFwZdQ7ftGMREVPMMbQ8vA==@kvack.org
X-Gm-Message-State: AOJu0YxG8oK+eMEilvIiKpHJ6A3VduJldInEohZzp0qCDrphP26BZ4EF
	c6hmgNRQs1yrl62fmXiaiebgOXrysD/EtBthTS6VUCTprIGXe3hKAlQ21xoWoDwJ19rZfOSEm+L
	mRbinxAQbEPBXjjHPcdLqUpg5meWrZJc=
X-Gm-Gg: ATEYQzz2nJ/F8Je8JUIu95fr+h+q+zVxlK1cYmXdZY7Ib36Vw/XdmHolE8euPR6LQhP
	/sw3LFSfTUS92lISFnz8j2LaPPGT6k8fw7pAxD6d2vA5K/QIkTQqXeqIpwrXrbCcFwFQxRKc107
	Y9KvjbuBmDiOnWfeB+MdkxEtSUravxlbGef77OxlRQs+y8UEuTiDUscW8fylxWmDPi1Wcw9NB+E
	9i2aPkVKssk5TKYWKGSncb8ahNP1Jar/KVO6wSPGHUPNyPwAcC5ABToURhmUf/tiKXlVu0hApIp
	XtqOMOukSzFwaAHuRJmvBn8P072KmSFef1ePdz7gizvk03x4u9eaJiTsAWUCOOuHB7hdxcIIu12
	nSpv8/h3hbk4kv8lWQcmh3ho=
X-Received: by 2002:a05:7022:618a:b0:12a:6cde:fd0c with SMTP id
 a92af1059eb24-12ab2906c98mr371178c88.7.1774598537022; Fri, 27 Mar 2026
 01:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260322194616.89847-1-ojeda@kernel.org>
 <7ad8bdf9-5eff-4443-ad15-c05355d793d1@app.fastmail.com>
In-Reply-To: <7ad8bdf9-5eff-4443-ad15-c05355d793d1@app.fastmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 27 Mar 2026 09:02:04 +0100
X-Gm-Features: AQROBzCrGdIlIe2CkDWKMkYFmP8XiqVc047zlhYRt_gjOqAGZtEWFJuOGnDO47I
Message-ID: <CANiq72nz6zB0jGahw4Eh-i-Rew1kQ0g_qcZ68Whw==MyjhYaJw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Arnd Bergmann <arnd@arndb.de>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Danilo Krummrich <dakr@kernel.org>, 
	Abdiel Janulgue <abdiel.janulgue@gmail.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Christoph Hellwig <hch@lst.de>, iommu@lists.linux.dev, 
	driver-core@lists.linux.dev, acourbot@nvidia.com, 
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, David Gow <david@davidgow.net>, Gary Guo <gary@garyguo.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Justin Stitt <justinstitt@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, Russell King <linux@armlinux.org.uk>, llvm@lists.linux.dev, 
	Benno Lossin <lossin@kernel.org>, Mark Rutland <mark.rutland@arm.com>, mmaurer@google.com, 
	Bill Wendling <morbo@google.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Nicolas Schier <nsc@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Richard Weinberger <richard@nod.at>, rust-for-linux@vger.kernel.org, 
	Trevor Gross <tmgross@umich.edu>, "Uladzislau Rezki (Sony)" <urezki@gmail.com>, Will Deacon <will@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: oo1ptgba6k8kx4iw741413z95jkw5fju
X-Rspamd-Queue-Id: 7FDAC1C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1774598538-836282
X-HE-Meta: U2FsdGVkX1+Lat1cwdfsntubRM5sZ7BCtDGGgNosi9uiZIcFNifIU1b/TmUV8wXO6gvA2yTAfhgHJbaoTwb2vDvlI6BP5nKQNrt5nMLm4HqLYAZAzVufXcHfdcOMHfRJG+EftLpAlj98Gwgd7EeXKmQTNz1l7LA+gs8IcqDeNyASCKLYYbpl7WYn8hyvGP+UqOwY+dmBylE99h34Jq/EJsRrSVS6sriXyxPj/sX2kvhcsYJoqCp6Vpml3euwEu1tjgru3tcjX0utu1fsUncNVoczxUwVE5yRoYxwxADwkKz/QTTFvwmU/v8CdJJ3GZNeSahpwk7CuUsZEL09W8025JsTpPm1+yaDn+SRycoldbXI0BiizQgG34lHGEAUZQ8UrKmcI/cpeIiY4MOGTXQIyrWdPRzrdEErXSaWfDSAmMwKYXJPvJT5EKNfTT5WORcVBXCS2+jZYn3POCBtuL68z4v1iA3zG0fMT/tRRQhv4/1y514YMiJVkql8SULisHxkrgmHr5TDQFixT5qtngzmUeGkL1+GcQvEamknnKehSpKkVt5Xf6ZtOh5WEsg+5K+GS/8BDZ/yYKov61/h5fi1ONcKoHv/G7RRg6ejIclUdNEqykU0eEEknwRR4tpJ5oi2hbPZ5g0NcWbPyNAM5Fb64bDft2jQxYDwVQZDlkbJWEFwOu18i9Q4DQ9tGcP3rpn5IrH+Wrnq6QgeohR5NZnCaNq+Sk475vjX7KQbPDUNap3SQMQ3TrbFJvXLz4O32uXZIpTaXKbZ+daGqQpRXaD80ZmSoGhpIUSsDMLAXYBvMbrpaEqCHfDbnYdyQRVlMKvG+3ZJ/6x785ZPpdq1UH9Q9jeG94PW/ytuMGEAN0U/bE8zXijSl0xTb4TWF5LMgiPgt9PkySQ2nL8SiUxRLMmqU7x7jurkgumOKfLnEohkY+VK6tqqaf9xkqAeiuP1kP3iNdrocmhh+2xczeJ8ZMS
 2j9TU5dO
 IfkVV+xC5datObYZGag2PO+uscUTmcvPEbwkUV3XjUiS1xdawwxgQl2Ld9jeLuftkJXJOJ3QBoVOV3oUvX/3+00uE2tdfrG+qxalsn6Na8ST0RarKMAr2M5SC/Lf8nL7Ot6Yad5XmfODXQOoGtxvVSCf3ZKgzideeeArhFiyDR5RS65XkuddfnzaIf5ik3rj1RdhJAsN3aVbtz3OqZ9YUxBdkO8nTc1aEKN1jhxhAoHF8hVXhXJi7kHhPXpUx0iT5IyU/dp2Jr7Uj8/MN+gZTvJrTHGRhvvQOTDXqePDuo6iS5TzQ3QklE+5+Z5JnzNWQOU6j5NnzgSFGWcMxevwaLrnrd/1Uq84fU5+XwG65//D3k4eJNVCESBmTEIKN4HVnU1QLhJIPaClXkq6s9ZncbVNM57rM8KcG9ozaIrGg2N0PtAJOCO0tlv0h28TEQ2jmrek0r6ojuBjSGID7gz6GBJxB9xQmhaRcoozytQccNpey/A0rMIDOrXJpF/G1jOJk0m+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:13=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrot=
e:
>
> I have an older patch to drop CONFIG_NO_DMA entirely, which
> may be better here, since we know that nobody cares about the
> empty stubs.

In case it helps / for future reference: the patch I sent to Marek is
already in mainline: commit 2cdaff22ed26 ("dma-mapping: add missing
`inline` for `dma_free_attrs`").

Cheers,
Miguel

