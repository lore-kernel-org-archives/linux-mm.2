Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21397CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB8D8E000C; Thu, 16 Oct 2025 02:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792918E0002; Thu, 16 Oct 2025 02:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8458E000C; Thu, 16 Oct 2025 02:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 551718E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:42:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CA52118BD1
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:42:30 +0000 (UTC)
X-FDA: 84003033660.29.73AA386
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20D014000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:42:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f4bJPn/D";
	spf=pass (imf17.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xwymle1RI5deN1YZysEWyTkaWWkdCc1UvMTlc0d69Rs=;
	b=7WS4JxnFEJ04P1XwkRJf94jG/n/Z6LrZPmys2nhrLOmuzdQawC5jrsNlJTrurfKsn2gd7x
	VfHDNM5aO0zvktlxRiuOIUadYjFpM0rewO56f02/Xzg2VpJntprjBhjT1ZsPuyKCqryhbc
	EE99SGhfjnhgjcVlO1nxO6gosJiev8o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f4bJPn/D";
	spf=pass (imf17.hostedemail.com: domain of guoren@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=guoren@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596948; a=rsa-sha256;
	cv=none;
	b=DHjiTndNS9DqCBcIAgY6AmDKhq0M2eiO7eZg8NyREb77ScddSRdu1sxyZgMYRyuGUXjAjU
	mAcOeZuV58r4L+hZTv3w45cnayfi6mjR8iyGOLGy6sc7cj5RrjnbvDI3OPMYH9osN1aTH6
	H2GyvQd+eyqBh7GGGKK5Yxwm4bhR79o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19610407E3
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC778C113D0
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760596947;
	bh=Xwymle1RI5deN1YZysEWyTkaWWkdCc1UvMTlc0d69Rs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f4bJPn/DpnUgA7kotw1MXERFp/4DM7MKCgNaU6MFBEUIc0ONsK0C8ggnZbDxnGrgF
	 tR2OtQxrBnPYCWinlOtBtwtDjSl020CPuvLETp5fANNiTf5Bfs6Hzdnoyl9CKyrtgQ
	 NzrcYMsDv/UemkZFTBxEg8VFiAxfpttKdmCV8dC8nWl0zkkLZay3Yg35RkRyqRTkyT
	 J85LosJyuWOck/ArSWO8v8f/gMj+bHLbA4LL5uK/xViAQyWaWRTYfCGAM5ZFR9Y3e9
	 Sb9riU0oWUI9afqOU9oSYVjpwZxELTn2HusteZWC1lYj7dzuXvGR9k8oX05iQj5nt0
	 9FsKAr7t4tSJQ==
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so227625f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:42:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVbgQ3UNUp4Ff/A3GdgHXPhBzGKkqfeHbLr60wSAaD9Pv26uBFb8Dx9sf8i6EZEKur53g7X/dfEyA==@kvack.org
X-Gm-Message-State: AOJu0YzpyKy/T18cNHikTLb+86ZvwIKVUXatz+oHvCqLSzgm1ml+PRFd
	EiZdHRWQOoPDL1IuUyJm7mW/+FIkHP3cmrRC7w55HyC/CrYTKvX7cWvaA+13llgFv2IKOhfAN1b
	c6PFZxkwsMvEhMs0t5A1kak3HoezWEvo=
X-Google-Smtp-Source: AGHT+IGMu6/5tkdwgl3TJA54YC+DSQnG+626+3ajWtF+4ixc5KZNJofj28aYCYE+Pd1fkwBRWHURZ3ViZoPyv4GSZyg=
X-Received: by 2002:a05:6000:2385:b0:426:d57a:da9d with SMTP id
 ffacd0b85a97d-426d57adaa3mr11257702f8f.59.1760596945568; Wed, 15 Oct 2025
 23:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20251015064759.2993842-1-rppt@kernel.org> <CAJF2gTTgG2DhqLC2B6URsNusjzcwCaxi-k=MUZTc1FTEHbaf+g@mail.gmail.com>
 <aO-O_2lhxZ8I78cl@casper.infradead.org>
In-Reply-To: <aO-O_2lhxZ8I78cl@casper.infradead.org>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 16 Oct 2025 14:42:12 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ0mcU56XKFcXcxDPv0bXGWm5WXHHpTP9YE2GK67XF7Pg@mail.gmail.com>
X-Gm-Features: AS18NWAu7sEuMJK-AO5mkdGBB98AzUtrOqZ7rI9LP75NnkmgevB_U4njX0yf2U0
Message-ID: <CAJF2gTQ0mcU56XKFcXcxDPv0bXGWm5WXHHpTP9YE2GK67XF7Pg@mail.gmail.com>
Subject: Re: [PATCH] csky/mm: fix build errors cause by folio flags changes
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20D014000E
X-Stat-Signature: r5za4bexa3wa847pfwq1nfu6a1iiui8g
X-Rspam-User: 
X-HE-Tag: 1760596947-510458
X-HE-Meta: U2FsdGVkX18PPsH3n/+ZavoqscJ50V91fDnKs5DlaPNzgUK1USxhxYAXKUT2BRqCMqfWOkFT7yd0Px1qIuUfhEKWdtABWD9Bc+cq1W1W3Wln7w96yN5DA7LTlKenT86k1duxyx9gp/QYJA/201R+U8Gdz/4fvcc0Z91/6nmKfEyoliWUhgs2dTDMJh5gZNMJoEKZtO9abJXGTTNV4wP7F+6nIuJr8FFqZVJlaW+6eW3WIsfxSqbbVz3oO/XJGk09XazObhVT5n7K+pXcvB8fBh0eGcMBy3vt9Tps2xPHmUK/2JpLd4K9UbChabwKhvCPkfeF6kTkbqhPasVeMOLrDCQ89Z+uKTgCMX2Ntk2p2u1ApTkvGPS/liQt9MbxSf5qrqJCqTHdBXgN5EVTJUo9XZCqqUjfrOQAlVzJiSeY7sf6ur9TOsPaZ9Nvy7qyl+20LJCV/dH1HHbEGRPGis7eYE66atgiAyRvUnY+ClpLQkarkv7+Y1O1eerJrjmCVeNJMw4yNqrb36OBxNNNf3OHi79rk6R3JoL11VxEL2eoRRVEm2z0+pCRnijqCz50929fI5a/nzf2XBA9oTruWpJrc77WFbWQ1EXU2QTAD1Xtz8mhpUAVzQvQcXArCOebzQPBNSaOcX0WGf38rw4s9oCggI0af4NATTSc8oax7vcOh4NmBbnQaVpkxdTkj+63OCuiJkKiJC314zM7YspXRjU/bacbuiygoCrur8FeY/JWBkrzYU1RAV3+7sU89Zdi0Kpuaeei5qKWRGyFPyeC8z+0s4sOywnXxQdruAs8iQeWcBQ+p1vYvCn/eRoDrNwnclN1C3ML9nSAupzIX9radCofUmCeEoMH2Doi+3AAiMTN+O6+35hmEd2+H+jgnGZiv0aq4C0gjfW5LSqeKfmSPZokaN/aJzrPhU6ztQOd3vz6ZI1qN+5EDXLNEPkzbQiu1h88/3L+DZW/UQ36ybG+pFG
 8gPDpnrq
 eYKPPMRk7WXbcUcPq6q9eWJv+c7OWugMOy9wf710EJL+loyZXc/zU7ah/w2nVUcOwXtDioRLQPwTbfXtVbmMssX2u7blkgyfRyOy9hSqJ/S6ad5qW8D0qSsFiHQJvRHXU8YAHfLvVpQvPKdk7CFg+yAwL1M6PnZ9UGYm4ajJFA+7hTZctLDALR6rJhkThVEHP65gTFiUHbqfZ521ZJMiIR2nEOniDKzd42xhOPhFx/fW6bHOFpp5KvATfVrtp+1EawGFzH4ORY+92hoB4YTEOTrCQs6Yn++39UP58gjzq3ATBWAjKbcFvBGPftmmI95uIKx0l6bizfpksvwq0IjKcpnACTogGW2oiif0wNilrdlPEjIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 8:09=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Oct 15, 2025 at 03:51:53PM +0800, Guo Ren wrote:
> > Thanks for the fixup. If you want to go through your tree, please add t=
he tag:
> > Acked-by: Guo Ren <guoren@kernel.org>
>
> Why haven't you merged the original patch from October 6th?

Sorry, I didn't pick that patch up and just replied to the acked-by.

I'll investigate it tonight.

>
> Message-Id: <20251006-csky-folio-flags-v1-1-a91dcbdbf988@linutronix.de>
>


--=20
Best Regards
 Guo Ren

