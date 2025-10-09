Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8101BCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7DD8E0010; Thu,  9 Oct 2025 14:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A699D8E0002; Thu,  9 Oct 2025 14:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957C68E0010; Thu,  9 Oct 2025 14:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83CC38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:14:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 361C0C0AD1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:14:17 +0000 (UTC)
X-FDA: 83979375354.16.2C5B086
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 538D420010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:14:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FP8YzEFk;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760033655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Se0ggIlBcEjUSR5vPSSxwDuywotTlhvRBXIE0uhueKk=;
	b=pjcggPAt5xwX2kqBvul+HepQsh0/L7CmNMEblBwfAgaRWidN3Hw4Im3qXKv3fD5WXPTf1e
	RHKdbGsq0jMmip8BOPNS9YPGLchuyKx2BZeYQ5MQ8uZsz02p1IPjt5frxz+Gave/+UpRkN
	UoFt5tdyS+7Zm2B83B6nMHLMtGJU6KM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760033655; a=rsa-sha256;
	cv=none;
	b=HbS1TBdnaasYrkEXtAw0+B1lZ8nnJdIZqM/Ts1DCbYUc/XBOtmaS8OYpIFN8tMzebzT7WD
	XfBelZLMS7XV5Eta7DF5mJS1KfVJSMgECK9+uPlH0dE0BUWdrST9did46BgbkF3gS4LySZ
	K1qZNpdIV4IN25ZDemB+DtrGx6BMXUM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FP8YzEFk;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6319dc3fc1so75964a12.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760033654; x=1760638454; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Se0ggIlBcEjUSR5vPSSxwDuywotTlhvRBXIE0uhueKk=;
        b=FP8YzEFk+AtX7y9u/G/TeTlHvS0A3C2z8Hp1kohygdxnDIjTDdXHq0NxL2OIlizpfB
         TtbowFNMwyjkZsw17Bk+srlVuOnrOe+P2TWx6Hg3JFrGjA1YlrCIjmJ2jXzrZ4USmesO
         l2haG9scibpBUEGSIJZBIZhxoZFNrAoBxVLRRoIuEK6de2061j8T41aUWp2NwgL9Fw3H
         ap2wQ/DfklX2rQh/SEeQxL+z44By5TGbz2tNsSjObsVEnS+sss6IbpLg8KBzg7R8tDyi
         ugugt4PwLjtsrvaVP8wx3jIP8+sAQxUauhm7+YfGKJiSAQtp/Hgna3DSQO+byZ+/tdAe
         4k7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760033654; x=1760638454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Se0ggIlBcEjUSR5vPSSxwDuywotTlhvRBXIE0uhueKk=;
        b=EHnr0M5r5pQvof7EQwNcWeLCWex/o/FZ2DzDo9ZP6V3iFCTb3hmi32OowAwjgWvlF0
         RLXyJWDIvHAMUO8AnoL7uR5alSta4aqvHG5wXeSqHmLFjlk2JZnVsWs90rKRlWf4LBsV
         OQC8AncRGfNP5aRTOoHegc4lepB1ycjIvPQ1k1+MTJYMXGeItlpDD4YEVXAOllqQISKj
         C3dGFldY7FaPjUOm6I+i7sz4n/vjsF26fEMLrXW1UhbwYagxVB8lSftC1fA42lH4nvQd
         6w+eaVpyI5TRzIW+qG3Of2j0vtSuhAhkkPMysMsp9bCh+gxp86n33CXPaSBBRFFOQSoj
         rZ8A==
X-Forwarded-Encrypted: i=1; AJvYcCXRB9loLhCYAchcUrzP7ZG1cATsCTCXSms3fQAMCXds4J7/F1v+UcBMIURNMWoEemOnpyl66zPEtg==@kvack.org
X-Gm-Message-State: AOJu0Yy4iicRC6B/YQetC9+a4Pfo9SBoBf1mvZSfCWnTN5M1colC8fEA
	UkBO6PkWa7t3AS3/0xp9V+WyF24VlXaZiDHDT8cnaxY1uh0X23Gp7UDyca4vakjtpwnjppWCy8y
	EIt8xJNvDyU6au1GbCu3LRoUX8Mt1iXs=
X-Gm-Gg: ASbGncs3/yGIplSq8wHJiF38hkXXgppeNKiZ3Q3PHiHpgPhMZdIFZzfqL39YDj6zHml
	FhO9vSergTagfXTj6PVbuaTF+BG/wOnuhIRLU06dqH64NgYajLr6xjFVvkmONh/SQweEG/3iAoT
	1rp8fOG95aPuNh2gkvyqch5SJ87POT8HWMeHPnfDSamrwxCOgJvBNTG/L9ddRLYizTrNjbjcl40
	3Hizn670nVT7A7HphXifP3M9TEc5kykrqnB9X0HMzKyrusuYUajSzSkc0fwE/hjDRI68SqecbOl
	l38X4akRsmRzNFjBQXwLzbZRCDcvuvRbc9EYArmP9CDuD6P71w==
X-Google-Smtp-Source: AGHT+IGGPYXRNsSxfchYlEX7hmMR6KUS05w+/U5AckCkquWjVaqc6cm6OPP4NlzecvU0kbAiqldhBLf3tX6fgvs0CJk=
X-Received: by 2002:a17:903:18c:b0:27a:186f:53ec with SMTP id
 d9443c01a7336-290273040acmr66870915ad.9.1760033653987; Thu, 09 Oct 2025
 11:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
In-Reply-To: <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 9 Oct 2025 20:14:01 +0200
X-Gm-Features: AS18NWAfpscSsC1ClYA_YRgf8xWotiQcbCSD3SzI9XzV_-V8UQWJVV7bXNBwDfs
Message-ID: <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: psb3qkpsoswh16j919okd1rgb83sjmtm
X-Rspam-User: 
X-Rspamd-Queue-Id: 538D420010
X-HE-Tag: 1760033655-442540
X-HE-Meta: U2FsdGVkX1845RUyD2DvhzjYWTqX5hjQYq8EMYiXdmfhMT1MbbAySi6xiNtGUN5Jj2xWOd2h5eENnSCunmGk8peZvf4VC7ITizN89v8BLoMWqvOlRl41bfHUpVPe7Z4ViqTYu+3ArXtOEsY9xyHxCoNuHYFF7qyKFz2xh4GdqYSLS54cl4aDRi9Gs92oDRl52utfrPFP1TXWHKHdN11yyCODVVgw09guRgwh5TmdIRdcic8AJt99yb2WQSok4hNnS9lzYkOE4dhvaxgUWLTo18k7bL0nfcdcGDk7+GEB2EKtzBBdUbOi22thMwhZsnrtJL0cwwH/PCvj3/NFHNN2mN1864nX0xT7L5Q089THmycX7HqwYl6BuZUqLeeicvb/1Gf6PMNOV5egJxVtN9Ry6CgRHWEXnsLWDMczekJpDeux3NgWSWX0Mq/r5RJs2uGyTj8yo3uqIpqQwOJlYaat0a8zuNm1aJQpJcZ/5Ab9pLQyP/yOdQtpaPgvxwwoU4ra/HKbKU9HM1/AtbwBouwSn0UXejP9jYtFjCowD4KTty7iPH2vM9G48TETYkmU4W5yio/g9Kh6thaiIfSJ/PxORcg3wyh34pSU495IhGhpps8WonXMY9IWNGwwT3884ndKLDD4iy9ZTciX7ZRyfQQV5WQjvxoeR9QH7eMdO7g6mNARB41nsrb/fCmECYEDqK2cw5Bl2zKR8zQ/hai8H0garUjljfIOQCNt2mKjyOvyx5PfhRcSNqQiakADmTQA4HTmyB2U/YMI+W03W0ttHE6De8qFJMCHBM8lHinP716PwlXQRk50iPoA7P2612z1vtbI3od0nluJJo9PqAij4zniepzJEogknUeIGdq3L2nd7/m0CrUvjQ1YB4/VDGccGBcPxCkq4X/WyeUuF2U/P1mHuH11gs4ZkZxjPINHBYIC0qD9QT5zJfEO6dD2O4ZqfDk/0+Z2pO98LY+4J3IvdDZ
 a0MQQouH
 wkSYb9323c9Aa7YP0xDdVyr/4g2f3Tomhd7usQO6BEvomP93Hr1RTDwDtXIx/jeXaibl1eK+Xs8L7GdyU01SQe1hJ9FniYCbrXb7IGG64XS+LVudRtE+ffr8HzqJeI7TDisH2r9RCbg3HfDVGLVnEmTTD2uFC7nAJgekjc+1godH4KPz24uTnwyYLOexRLWfbnbbE9Y+I6h0X2dPhE7QTkkmFqDus4g5TDBlPG/wnOg6giQ0xroWJtpxUK3+KdzyBxt1fKxT+szG22pmeyYxstbZBjMwyBJBPJ2qdT8WjtBOfSFEjh3X+/E2mqVOocSnaqLtf3kKRHNiVns8kvyLE/td6d5hcm5sRU0n3jAvXb0YeSRevr9iX30NIecaX2K4EbEgIFvW6jW9o3mYZvadMx4fKV24YXTC2dG4zo29m/+DOEUOKfJB4mPs9niiub2wZns+HruHzwzHdRXkbltagUcbsj9F4vQTrpi8Yj/zZ54URvq4m2BhLfPEimw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 8:05=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> Alice, Miguel, please remind what to do about this?

We can either define helper constants in
`rust/bindings/bindings_helper.h` for the ones that the Rust side is
already using (like last time) or use `enum`s on the C header.

If you have it in a branch, I can prepare a quick diff for you to fold.

Cheers,
Miguel

