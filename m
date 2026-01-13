Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B09D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AEFB6B0089; Tue, 13 Jan 2026 14:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686BC6B008A; Tue, 13 Jan 2026 14:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C44D6B008C; Tue, 13 Jan 2026 14:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6956B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:24:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE34D8AD0B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:24:37 +0000 (UTC)
X-FDA: 84327917394.16.EF7BFFE
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0DADB40015
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:24:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jspSbe5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768332276; a=rsa-sha256;
	cv=none;
	b=ATbO1UQ3lM/nRg9/Hws7IEp3ZUm/7YlVjlmPqdE2KgVVKm1eu+lb1qym6dv9hz++E8oEeW
	rjFEnFNzKVwY+B8sROQzBVL4X0DAU//OmHS0chnyKtykUslIlYeNeLGBySfjWiq/zqMyzN
	a7kFoZwE6g4XF/VyNoSeHqUFXMf19J0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jspSbe5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768332276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OiWidXDlc9SIxtf//Pc3bF1d2VDX0rCMR5B+TBktRE=;
	b=L1bESIZB7lTxU9YS6f/JLxnlxeYcsI1TlvTwdZ2BRRaHDqKrLo5KerWnp+urOmlbJ/De3d
	+Xm8xE+0IAhwwG8WqpaL/ULJboq5GqBxxD2bhXLPBRzyij/o/l8tcsJbmmkBMfDMWBj1FV
	AfH79sfzqcZF+JSSnMTdGCbsJLU5d9Y=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb5810d39so4169473f8f.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768332274; x=1768937074; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OiWidXDlc9SIxtf//Pc3bF1d2VDX0rCMR5B+TBktRE=;
        b=jspSbe5TaM+desTNmQVWdD/pbP7GJlFxTD0uKXzBobJ+5GF1rLCXzpASh05gbmc4Ux
         PpPAqSrjMFRD98NP74lsK8PVkMIuoREM1YYg+OOwJaPdDmHzKz5WW5b0PMxBEdOG4UwX
         7j+6RY9Gr4Xtpwsrp/MaDXWXRwxiLf583kMj1AuF12RkKr5D0xFZW6Nk6dlru7BvCTo+
         26Zr/APU7yLJ5kelZfo40/Zctiy8MoTEbpL0ziizKI9xKXhN+cvUEXzffaPmzm/uWkiT
         WpUYW/DKD3fk3tW3bdFUCtQ/CIgZ2z37m4J/QIYu6lw+msfbnYtvhJ8GbZApmyROE/fe
         3zsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332274; x=1768937074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9OiWidXDlc9SIxtf//Pc3bF1d2VDX0rCMR5B+TBktRE=;
        b=bxE2GSYOCtr5yN8d2AW7k8SajU/pSJN8cKMJwR2pMPQO1wCNZxe9vS+asr2kyLPkiT
         dbcK59Sp7+iuQXeEwnDUMz7cH+5OgbTADA2D6+TocQCg1X/+0/MT5xCNcan84MPt3F91
         TYyXXZ3BwG/fNm/1xcmHYWMCgzfRUJ0BqOYBDhkSQZ/5m2yJW1rx7xsT60r8NvGvi4zB
         Qf/siU02pUrdGGXl7VxnqMn/zGPiMu2Ctm4h3gFUnSueo81JTxFC1Idvwx3HPqteyIZG
         8KG0ZeCvQTd+frEfcYsVmb5isQh6GguuNwvKxFVEjkjHptu12FAGcdIIW3UiicfSiEkr
         j5tw==
X-Forwarded-Encrypted: i=1; AJvYcCW3V6x/M6DuiiHNZrZD7Jvi5gHpCmFg8J6Zd/jk0IQ3EvPIH4yzQXOwHZFUueB/DTT5f4ccgmsmZA==@kvack.org
X-Gm-Message-State: AOJu0Yw+n5hDaEI33k/1M62N6HY6WfMpYRCM4idrOWGOEDo2PX7LycUA
	w57xmluG2LA0VTKyFilOrWS1u6Z6LOio2lJDKNYKQOk+8UnHyh1FTmNb
X-Gm-Gg: AY/fxX71G6YFUwdvHdvsuudoF+LD4dHr3UVVG1DBPBX+7COHGWLcqJwt034y/oIHBR0
	MbXT95Uec8ZaDRpcovbzzPpR/U/TWxIvCK+XGod2ebHIUBiusy9uy/kN7+V1zToP3gTI8cp2IPf
	vc4TIiwFmc7BdWUgL01MJjscD8QJ+aQYG7AxHfIKR904mcnQ2yA37SbkJrSlTUsshPRwGuoiZRb
	owRfy87JP0ERFXVtg3tIfZAA8bhMPtJKH1veFBukTcjz46WM+WL9VfUI8y04hpBG0IdzszNuWe0
	cpzN9GdVLwk3K3Aecvu+231+i3yoo1bUgGZMc1vSEhACvttJK7nhDO/WdULm4oc8aavmXRtp1TU
	UCNYHhvSxcjRzMFI8AuwCUKgDDtlBy4Hk5bDxYUmKTeYW7PGZT4riIKsLzXBrc1z1b+3zf3myso
	QVbzbab2OmKiBJnQTZNYt3ewCvGK2T/FtaFWFKr9FT+IJ8X3IMRrieyXO5mv+o9nY=
X-Received: by 2002:a05:6000:1a85:b0:431:67d:5390 with SMTP id ffacd0b85a97d-4342c554c46mr10986f8f.54.1768332274380;
        Tue, 13 Jan 2026 11:24:34 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df939sm45481323f8f.21.2026.01.13.11.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 11:24:33 -0800 (PST)
Date: Tue, 13 Jan 2026 19:24:32 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro
 <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <20260113192432.25a799f4@pumpkin>
In-Reply-To: <20260113183346.18ef7c74@pumpkin>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-31-david.laight.linux@gmail.com>
	<62097ec5-510e-4343-b111-3afee2c7b01e@sirena.org.uk>
	<20260113183346.18ef7c74@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DADB40015
X-Rspamd-Server: rspam06
X-Stat-Signature: qr8ucd3xbhmq3irz8ptqxyxmg99mq998
X-Rspam-User: 
X-HE-Tag: 1768332275-647181
X-HE-Meta: U2FsdGVkX19Dtu+uw1k/AaPVxLPuTXbgwUb/3/Ieokg55eovKdwoDYejdi92O95UfL6JVAXaPlGSp+ER8C1GhKYVb0xydL7BnuJ4s0S76zS7wQNZnuyF5y6EknnLuRAzS2BiSI9MiUJUiBvIpucFMrzgeodutLqbBHGKrsy2DmVp9AlOR63f4vWgpR+AzRT/M1e8DeFrJhRNA0kytIwG7S6JYElWp7ji1BkG8Yoa14mZAAkuF/PyoJqc4uY82aaeigs19KYPK96NxQ6UcyppeFPxxpsBN0nECV3A0W+eoud4VZkaQXvHyhDxrOHlLOdafMlAgp2cbDCOoy1bBRWFqnxwd3WCcCfHMVxp+AFJwKe5pTQjTME3oQt6XtPkKeKhdWZyFNcvIMu93hm6P82BMzbZR7neqU5MMyWjSxQV7woNVMUp+sEU867k2OzPbXul9pGLu0FNVHgUFDQK6X4qTK0+jOnU3mwxyMyp8zRe6zoUf8haWxAWdI5Ah2tmZwV1e3YD3njCnlRmGaRfSjGRZ2tqISvojdJ5fE0fxn/qpUgPihmeQBEMprT7Zg44r8I5RSFXBY83w7Er7UD3j3PiYWZNa7FVLsWjUF9MNIyazrLZsKSwep5Ej39WD9wIz1KEZxtZ2CmjZ0Vc29P5NSoQ9CPbPjyDaTismEhsI8Lz9LINZehyG/v3lCpf5FeBAevSFbR5jMar4Ho64XPyptxqV6lNL5Qc/9yIPV0ZlUueAFccUPKkpw3jKJLs0FwdwJziziMmJShDYzQXg0Xy5vC6Uwi0poaE2DRiMTWzTPOrueJEdHuw5XfAo6NnDmqyGzV61VdNDThujka1tdOkZF947QI2O2YioDiaWliOyInr1kDmruMrtQ+un5x1F4fNg8nw7mMUjPgtxIngL8YHj6JsYDCK/55wRiN0gYljk1NHtRuGWBDH1oBg8L1mVYMIpPDnwP6IBU3cY6HZ1VRi0wX
 Zo+JlGFJ
 psOv5qZg7Wpip0fhWfH5v6HFe99uIqxKZlGvcgsAF6uwv73SR05D3hVKKq0LEqsexSH+BpD5ptDKH2wxMIAi5KSwVL8/K1QutZjt/IHrDADj7Jd1Zxp+QEHasJxvPRoz2wQZXfpX47zBO2ty8184ETf4hkFgrG4UT0DC2OIv4iJl86JVkVLxerExotScr/0yIUJ4/P9kwk+3wHiCMgZRgBXcso0+/S4KTPe9GX+e623H2mH/KP8Wz/+Ih+5ws6ZYi0dtgI6gsGbQNyjBm9c2ZLZJyCeY/RJ3cxqpOAQ4sh3NOSg08H7xi75KXbaKwznPOU+b9jsMX1NLBCE+++8nG2YQIBJIMYI9qCcbQ1Qab7GRhid0XAjqwAzIWZfZPuQymdrcMGviolbB9qWR2oFNqMb07K4vUgocMOySsfd+NtjVa0pWRrQcsE4yHsL63BxxJtsWB9BqBxjXE7VPgOVE3nDjTMMUar7rvATNazA5d2DJZPyHClHjCpcGgLzHQ4NWSbl51Uh3EJCxrj7g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 18:33:46 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> On Tue, 13 Jan 2026 16:56:56 +0000
> Mark Brown <broonie@kernel.org> wrote:
> 
> > On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wrote:  
> > > From: David Laight <david.laight.linux@gmail.com>
> > > 
> > > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > > and so cannot discard significant bits.    
> > 
> > This breaks an arm imx_v6_v7_defconfig build:  
> 
> I hadn't tested 32bit when I sent the patch.
> It was noticed ages ago and I thought there was a patch (to fuse/file.c) that
> changed the code to avoid the 64bit signed maths on 32bit.

I've just sent in a patch to fix it, compile tested for 32bit x86.

	David

> > 
> > In file included from <command-line>:
> > In function 'fuse_wr_pages',
> >     inlined from 'fuse_perform_write' at /home/broonie/git/bisect/fs/fuse/file.c:1347:27:
> > /home/broonie/git/bisect/include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_434' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
...                       ^~~~~~~~~~~~~
> > /home/broonie/git/bisect/fs/fuse/file.c:1326:16: note: in expansion of macro 'min'
> >  1326 |         return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE_SHIFT) + 1,
> >       |                ^~~  
> 


