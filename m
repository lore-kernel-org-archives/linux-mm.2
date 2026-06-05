Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958E3CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864426B0005; Fri,  5 Jun 2026 04:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814DE6B0088; Fri,  5 Jun 2026 04:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703F66B008A; Fri,  5 Jun 2026 04:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA766B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:23:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD9791C1D78
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:23:25 +0000 (UTC)
X-FDA: 84845169570.04.5A3964C
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CDAF14000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:23:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNtX7hml;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780647803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ncylH/iADc8ME04RgleGvGv2QOfG/3EuEqLEAZ+XWA=;
	b=ZqurqSms9EAiHonoe/+GHoN/9SFXTyRkH5fEllp1CF3OS9iCU/WPqlPJuCGLNTciWvnE8W
	lwtIIerTGDj1MJu9RgMx01Yzr/iDK9jy60o419z91+THqMCMWDXmYuoYgsNmUXKhoYowyK
	rRxWSxxcoDJ9koBWgBG0fyEkeFJy6y0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNtX7hml;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780647803;
	b=7M7vOnTtx6kueBFk2RkG13zWC+MS+/SMSRRZPC9TAOjUxhxPPKy5CmQXUW24zLUi7D2DQA
	VX72AYdh7SPMhtTkMLMDYLPM23u4g34u9SUxROYyp9Bo4qG3LSXN99w6tRfLsyPq76kZxG
	koniXUu7Chqcgszo9wgEd2/ivks9bfk=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so1119648f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780647801; x=1781252601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ncylH/iADc8ME04RgleGvGv2QOfG/3EuEqLEAZ+XWA=;
        b=pNtX7hmlYHK9e0gSPHz69QxjiKBNsSlnfRztXx6eVHdWFbBfme3Po6T0CLZBWhxRo7
         gTWTFAPKxRCiPW5nyASoQiI2HbRL4auu7ZcnsrEFcUVHqVt6WpCNnjJEzwmc+lmMQcIa
         X1/7Liwme92CSlICi89geGQomsOyVd9G48fRMa7B/m3psHnBRjomAVMl/tYdR1n7V61/
         E0i/EgfnCRByJTAEaztXGd6bUE0EbwJ9ug9lKRCRQSn6Qm+4gYsCsUv/cpSRi2Z516+m
         ZUdQ+TD+FG+S5tDvBiGHhuJxrrBrweInQcgY8C0NigAERInqhiOIjvidqLTEinZkv/jK
         J4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780647801; x=1781252601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ncylH/iADc8ME04RgleGvGv2QOfG/3EuEqLEAZ+XWA=;
        b=s/1H1IIZM8oxjQOpORgdYHaIq8rF621mYg6i+8uZq1sk+th50kCbe517u0BF7YtPNA
         EW+VNSMrq//FeBIMXVMDY3l0CrwVSIFVaYsJyLstz1AMF1EgAGQbyd3eLGXauoLCUKFr
         DF5W10uO/RNDnyjrQBbg2EqO5ZUuEtp6/Upn2diqrKAD9wMOKv5M90M4pgvhGLrXRGub
         np3p4asTi6FqzKVzvI3NcmGCgyqhjFbBOml5o8vmB71DXecUNzGZR8rgo4evE/5TVL8w
         uXyzmZXsAyOxYrF+1JClerJDRoMQ7nGGJU9bwmJNvkJYRNc1Qx9Txb3YQDMn65TRyndm
         JmfA==
X-Forwarded-Encrypted: i=1; AFNElJ+OgsqNhCy5vcm4vDNTVHU+eGmX/4mT/7xkVpnChVDUTE5lbD33MG11Iwr50+Tzljci2jUERxd1DQ==@kvack.org
X-Gm-Message-State: AOJu0Ywu6GMqSKnFNsEQ6LSThY3jP+5A9Tp+Z3pXvJa2vFYhQ/+FhU4z
	6ffYRBKH0WMuFmhooKtWtb9wO+bVkLUPIGMbhF67h1EmHTSBI/1FoGwd
X-Gm-Gg: Acq92OFTFiurk0moFmmg9hV4fNwWUBzh07JXDeQJa0w6LmIfLnAmXqW0fkBtx+yx8bC
	/vbRk2DmN1ZbhlXK80Q5JJ3m8hBvDajffFWOu7LM1d2wP6E4Hj5czok+LDbAxGvK3cJ14KtnI57
	4hCjrTEowuJDHve4KM8ZAfkCfkkr/fRDlFewVGvdv2yrDShjMnq3C7m6WcYZO7+tfxEoeAhwaRT
	JVURqkGOh03pSIDg9PQN10N8MtDSXHNamF1F3haF0kR5rJdbmc2eYXzQGSHUhw8HzawGjcnnZGu
	OE+12eHJRFLMUhWMrnum80WK0uVi4Jkm+XVGZ7GIGDF370jd455/IqmdXHPvNtEjX0YYfP64r15
	yNN9sNeijc0m0ezxVnJdju8HzTI5VD71hs+GOnAiU57n5ClNtuoA217RVXHKY4XaoVhAaONZXCc
	wwTNzwZFIq46ZnucQRS51gr4gEYCADuMOMrfNUxGSk2s84Iwz6tJXjCHrKV5qqxp1sAd7RWg5Qd
	OvR/i3MpA==
X-Received: by 2002:a05:600c:4fc6:b0:490:51e9:deba with SMTP id 5b1f17b1804b1-490c2615a5cmr34498005e9.27.1780647801274;
        Fri, 05 Jun 2026 01:23:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f67c6sm23925419f8f.16.2026.06.05.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:23:20 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:23:19 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Askar Safin
 <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org,
 axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605092319.5a1bba74@pumpkin>
In-Reply-To: <20260605015724.GA520134@ax162>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<20260605015724.GA520134@ax162>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3CDAF14000F
X-Stat-Signature: qm7bqk4epx8ei1krwocsuac6mhh7q9cz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780647802-763296
X-HE-Meta: U2FsdGVkX19F771G6PInkWP2TakKsppduJCSkxi0C6Cb7nTzze+JzhcXcEGEyjk/vGJ7Ipe4R3RdzagKq5A5PMCSZtTor2iBImYmwcW0sxc0N+IFXMLtPYwXf6mWcO+Anfeu3DgTHkpXir+N+0f6NN7Bf8Nd0/nc0rxod1LtOwOpmXCE7uSX2AQ8qAahEb6MMDuMNEq0MfmicPgULPQGNLKnjDdt9TFxcQRDjqE1tR6gyFdmHSRttN/0cj9ONY12xYbh43m2o4fpf2jeJa/BpKSt0xUQBwgNTrSphuprKFwbIH+6oHL29iDAlPL//cJWCpf2eX6qrba2LTz+Zgh1BNy8FQdvZEMLNIFZ/FAdKnHfYU570ikspd1UDZUXFj0Lv+AaonV0DyhYcpk0+1d1kGfj73ZUj4UiRDbv9mS3WYFieQPgGILKACAUgiYxND6B2ULsgrEMOJBGVfYfO+jDT2pSYiAdh1AeXwgs2ZZjHdHzDAmSP6TjsNdaa12q1K5sLFaTxzMkaZa+leHLg53BSBpd0lf/oyCxyxbNnz4UyNnl1rH91iPxrymv01eqLA4yrfUJyEilV3+dcoC+BNwBxXirK6fWlA+tgqWCoYzgvJQZIMX/81f7F2GV2QHG1DOjf84C+0rSBdmduCt/fu8kYsafx0DtiICnxnRjVHIFWueyU7fLHjAglmFPMEoql/oPrzjdX12rmXg/6XO4SCRHo/ljmwWHoCnlOBaaJA5m7EZPbNloT9hERr0l79f42sKf5DXr6qrL59+5WO3TafoV9mBfrsbtNOy44zDw8FncsaFKWN61cPUDT1bU7t8754pY0fntiuihiVTlgKw6p8Cjln6EGWclDtiwJEtAxnIe49+2gThZ3AKVggOyzu7vJ8YuAk+qZUC1e2WL6dvsUtu+j0AYzxZ2gaWvp+QJhIp7dgfAqkTFHnMzKCp1g8WNtJAe13lflRLDXwFateVSDrY
 Fgm/PA5r
 N6XsLA3Rb63zPqsHXoPDJQQq8Yu3mTImi0Y7+UEY8Y+ZcKlAzO6EePLCYgX/LV8Kfqrpuzri0OnvnTPPKzpP5Fb7uX3+6IiDOihfp+laf2vtlWr1bkFVUhzWpTP0e+q3Ij6ICZO7Xg2K/iBP2ADBkTEt/UWly4wSU3iYEMT7C6Q7lsZnpiMgAIw+6U8Z82/ZtJg9SdU9O3kWbTCmQxnLa9dLphjmlWYv/s56Gzzug1Potsv0VETx9/jehXmJvhgJwYPL8wEDdNI0tZKQoyya/4e2JUnKx9zr2C/38B3gSrPK46Bd7jdfZ9psu7Pq4I/6teTduFnNvA6e7gVkakD3WQe/zuTrf+rmMYEbC/ZjHuSMZOcr6WNPiQP8OBwex71OqhuG9eaIX+77t0NAbVJ8G0YbIeLiXonI+jFkOd3WsFupPqtx2hH7uzGkBOMXQw/MG9b59bRFlXahyeOH8sLvcAXApRzKt2PnlQdVCHDpgbYKX+PbVgYEImHHuZ2TMKKgiKFgh0/V8UQK0fTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 18:57:24 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> On Thu, Jun 04, 2026 at 10:32:16PM +0100, David Laight wrote:
> > Talking of broken compilers, had you noticed that:
> > struct foo {
> >     int a;
> >     char c[32];
> > };
> > 
> > int b(struct foo *f)
> > {
> >     return __builtin_object_size(f->c, 1);
> > }
> > returns -1 (size unknown/indefinite).
> > You can't use __builtin_object_size() to stop code running off the end
> > of anything referenced by address - even when the size is constant.  
> 
> That is the entire point of using '-fstrict-flex-arrays=3' in the
> kernel:
> 
>   df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
>   https://godbolt.org/z/bvfrh7W58
> 
> Without it, all trailing arrays in structures are treated as flexible
> arrays, even those with fixed sizes.
> 

strict-flex-arrays got added in gcc 13.1 and clang 15.0; it isn't supported
by the gcc 12.2 on the debian 12 system I'm building kernels on.
__buitin_object_size() itself is in gcc 4.1.2 and clang 3.0.

Neither are flex arrays mentioned in the gcc docs for __builtin_object_size().

Someone might have used (eg) 'char x[4]' as a flex array to include the
padding, but no one would have used anything that extended the structure.
And the chance of those hitting __builtin_object_size() is even smaller.

-- David


