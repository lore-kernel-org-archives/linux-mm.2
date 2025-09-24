Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F1CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 23:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5ED8E000E; Wed, 24 Sep 2025 19:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396848E0001; Wed, 24 Sep 2025 19:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E408E000E; Wed, 24 Sep 2025 19:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 104078E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:27:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A16FE1DD98C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:27:14 +0000 (UTC)
X-FDA: 83925731988.17.66DF123
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id EACD516000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:27:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaXA6Mre;
	spf=pass (imf08.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758756433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJ1sgli7ptqR62/CrqjdmqyeswCTgFuJHQ9m7NV2USY=;
	b=0wHgRvbaI3ZzW20vSjkwA20oFn7lu3LID61IZUAjd7ZRfkd+dHtW9BHzKTNDvEtUBt3PBw
	Mf7lTB2FdgON73EsxxcbsDXZM1fx7ZhbwsD/pkU7YhZBs+wkbC6KC+CEeBEtsrRoDLfLor
	d6w8YvL9714Vync7ZdMep/VMJdAa0CM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaXA6Mre;
	spf=pass (imf08.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758756433; a=rsa-sha256;
	cv=none;
	b=bps9lxYDSH8dCH6IlkaQFEqVVAgUgCsOOvK7TurEcNWIxaZz8+oUPrTMoV9lEWP+jrp7WJ
	ukpfQC9WRomr207NmE6A1rCJC2JEScgcz/UqI2h5MI1FR3CbU1ffS37wUnHuCq8KEpCepH
	At7gps/YIIfbfj44W/YmxLfR2bYcD8A=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2570bf6058aso5803075ad.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758756432; x=1759361232; darn=kvack.org;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJ1sgli7ptqR62/CrqjdmqyeswCTgFuJHQ9m7NV2USY=;
        b=XaXA6Mresz8OLOvosFyECQtlK6ZtJxGUFXO+tt4+M3gLSfN2AdvtYjmqqBOYuRXCoA
         vNi+L1vIiFqN/JfFtgg9qf0gPmRrIl9UlT4eSW8+1VoGCAezvxnUNE5lpCYNPcyILDYC
         +3zFavP2sQKPEuG2h3JUj4kWjHcYHF5gd9qTLy/8VLVc25gNVZi/AvZQbOs57tke+pwo
         QeC0LNb6EirLurpGWlFLuvpju/xIxXfduK1gybTumJqpZ4+JyAnTnnfBZKpZN9pfN0kD
         arjNjerKBTtaVNTnDVWrZo1QPm1d2ctbLHrKM8pU/ytLOgfAHUtyx/mnMzCfnPVJTlxV
         bhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758756432; x=1759361232;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJ1sgli7ptqR62/CrqjdmqyeswCTgFuJHQ9m7NV2USY=;
        b=aWNxX7sdlnNGLFOFE4JPKf8L+h3B/GOhdH/V2k4UMydIk+N4UfbAZDsvjRpuxyYzp4
         z+eAGeg3gH8i4KXZzCBti13y5AwXPiFdqtXCDLtij/2SnUqnFT9Kekb+BPlrje+WKkqU
         OSlr4zlh005sPa9IRIy7+aeSeWtHo+VQR2tQo0huIa5Ng6qT8mBZUozAvMtVtf6t8FZg
         pdjSyX1qAZ5vhp6AzWT0XnvU7HBvlxiPNFFDUs5Rq1R2gNECvsBeYvnIiVrEJ9REEFFB
         hbyJO5YMsjX9iScpy/uwCxjLrvBWPDznOotWY5j4adtVP75bRirSdjFpAuhj2I7bZ57L
         6wCw==
X-Forwarded-Encrypted: i=1; AJvYcCXt9dTVFC/euVE239GeZYg71QaRh0mriqNtmyE1iK9MAYe97YUKrcj6AgoGgJnOzaLuHqt4IMjwfA==@kvack.org
X-Gm-Message-State: AOJu0Yx5hyPy61NTKYxT9KZ62Loc76XK66AZPyFr6rBEh3E5GfiLDpbf
	9YRA7G0xWU9avP/rfFTSZEqXAvuWjs0D5LPahkeahgv6It9cUWi90UZY
X-Gm-Gg: ASbGncuoxAvs4dwUWtsURH4mf83xFTT9XJ2hGO3L5hn9f8VBauKOBP5CmaXlQZ8s2Tc
	meZh8YDYpCRJLVDEi2NkD27lDxb4UCdTUEQqapFR309N3f/ds7a6FPyEwvoeObz4Gs6hvD76t0n
	f+dPpaUHTS+8YQZtb1eTyI8YKDL+4j0JxaLI8KnAPyYp+yhV+vl+6jiogKhkfBt/dK3yDafLXQE
	aVurBSJPoQxps9K6nRDnvjVoclm7mqDPYjX7lkB4dBba+8vr0blxM5qNY05mG2MG7+xG2igRbOy
	1qfJSIaZ3TWrkCcSiLxUTGD5pJ2U2B7Wl8iqJJt7CXIGnkjeBc+EGP+I6Mh8LU27fC1CW/ChHg+
	lvQoIFpU6nNgxUruQ4I32cYBRNQvgmRI5IvV1rSX/S2eTpTT0Ce84aHjbgh45kJMPOFto8aQ21t
	Ok2tWxMWwaxngDVt0y8dY+tQ==
X-Google-Smtp-Source: AGHT+IH/KDLvQBQ7UfQ+ug7/uqqc5vZ4hRiu7RY+Ut1AjNGo+pZ/b3uV5AW21gKl38+5adHmTwsrgg==
X-Received: by 2002:a17:902:d507:b0:265:982a:d450 with SMTP id d9443c01a7336-27ed4a492e2mr13671305ad.40.1758756431589;
        Wed, 24 Sep 2025 16:27:11 -0700 (PDT)
Received: from mars.local.gmail.com (KD111238238118.ec-userreverse.dion.ne.jp. [111.238.238.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ab64c7sm4012795ad.130.2025.09.24.16.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:27:10 -0700 (PDT)
Date: Thu, 25 Sep 2025 08:27:07 +0900
Message-ID: <m2qzvv77p0.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: arnd@arndb.de
Cc: johannes@sipsolutions.net,
	geert@linux-m68k.org,
	linux-um@lists.infradead.org,
	ricarkol@google.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RESEND v11 10/13] um: nommu: a work around for MMU dependency to PCI driver
In-Reply-To: <b55251bf-625e-48c3-8c60-eb4f8358f397@app.fastmail.com>
References: <cover.1758181109.git.thehajime@gmail.com>
	<4a9dde10c586883d20a8201ca7d76e6d7d52eaf4.1758181109.git.thehajime@gmail.com>
	<a58620ecefa207e141a435c36492647c3d5bd3df.camel@sipsolutions.net>
	<m28qib8g1r.wl-thehajime@gmail.com>
	<6b1abe384237c8129e8043ecdfdad77758d2fd2f.camel@sipsolutions.net>
	<m27bxu949d.wl-thehajime@gmail.com>
	<CAMuHMdWAdhiY=MiG5JtboffSo_=D7TD5vFM6Ui5E8eS_VJiJ=g@mail.gmail.com>
	<23adb61e95275251e459513a03ab7d2bcf1f2e07.camel@sipsolutions.net>
	<m2zfak7mnd.wl-thehajime@gmail.com>
	<b55251bf-625e-48c3-8c60-eb4f8358f397@app.fastmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EACD516000C
X-Stat-Signature: hurssj3zpdyrtt1kcxt9gr4kucih4re6
X-HE-Tag: 1758756432-512088
X-HE-Meta: U2FsdGVkX1/HLG9cE2pqK4SuLg/MtybOEQ6kHzOVtSMGAddt1Uc9Mn/NRvS49QzSxqxFW5pasg/L1nu5ljL0gP6yLaRd9UV9o5ZzhUdGX+ymcbv7ezIZpVeDFlyUPig5ZpvHfSUT5A5GyUmcY2v+tbQbUQyAeK7sVSpCu9+3yGkdmuGbEu6rbbF2gTzwnVhLx5eEYJ07gvNI0DmGAOhQhS47oKffR7GgxnQTyk+o9RPX6eXaHy07DNY0QK3tTDjsuRJm/wVCyKzra69Y+fXhB8ckbfn5VMOPEuF4WUGTfd+Z/mqVtC6muyaFJkMJxsW/wXmm53HPv0SoqfUNUH9a5qaTJMRAnlc/77uLTZ2AJIkthIDeIV5J0jdtSo7JBWhKnUD3jFsTx3JBtle12zb74No4ElpvodSn3ZudoOGJObUl1GTm4rhW/HFHMHIsAPwjr+pX1usWd0rELzLdjaqGt+u0qmB11J4RYL3wVxu6/7igM3wZDahvZnPCMcfWd68Fda8w3bkwtPnzsbzYIJYK1WMKyMv7rcRyKQRjXmNvgfFYvV/FRqP7wfogwJuUaitaXOE3UQ2bYLaQIW8mMy5/pgrfOH8eZFBQTYQOSY3TUowlQW+FS97krOGl2iOyyjqaglCQcaDDzndhBtzt7wIqHqo5OEoRoluC/TexhxYSe6mi2rgAh5To/yg9LifLGVtjiJgg5j1aqDCj91LCgMylR36pndSUax63lEPA0qHyi8X9aN5dscFANqETMOdjCoB7MdvStqG45pw0juF4Od9R+1PMiy06sL1hQvIo4iLDKzi2zwPXHapefE2tAOi3cnQ842KHha8JLXrink+x5uNZpeZ8NArJvYZ1/idZsCQs8DuqNqt3X/f0B43Dq6DcvRS98iNZo/tSPWkhcH7x8Q39FQaXkz0ly5RNXuNhZTseoBs2KOZXtd8j2niQkNeRUJePPtEnHblK8ScvqCcFUyo
 MlWrKt36
 jKAd3qeJ+HzHIn0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Arnd,

On Wed, 24 Sep 2025 20:03:11 +0900,
Arnd Bergmann wrote:

> > currently nommu UML doesn't come with using PCI except building under
> > kunit (ARCH=um), but I have in my mind to use it under !MMU
> > environment, so would be an option in the future.
> >
> > and this series doesn't include PCI w/ !MMU.
> >
> > so, I would propose the modification to revert the MMU dependency when
> > time has come.
> 
> The reason why it's currently disabled is that it was causing extra
> work to fix build failures in random PCI drivers that individually
> have a CONFIG_MMU dependency. Since we know that none of the NOMMU
> boards we support uses PCI, this was an easy way to avoid work.
> 
> While there are still developers that care about NOMMU Linux
> and test it on the platforms they use, the NOMMU build failures
> usually end up in code that are irrelevant for their use cases,
> so neither the platform owners nor the driver authors care deeply
> about fixing that combination.
> 
> If you want to be able to use PCI drivers on UML-NOMMU,
> you can probably use
> 
> config PCI
>        depends on MMU || UML
> 
> so it will be ignored by the build bots on other architectures.
> You'll still have to decide whether to fix driver code when
> regressions in PCI drivers happen, add 'depends on !UML'
> to individual drivers, or just live with randconfig failures.

thanks for the detail information.
yes, when nommu UML wish to use PCI drivers in the future, I'll take
this approach to be able to use it.

-- Hajime

