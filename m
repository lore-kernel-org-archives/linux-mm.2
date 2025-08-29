Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00DB3CA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3B26B0007; Fri, 29 Aug 2025 03:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B8D6B000D; Fri, 29 Aug 2025 03:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8516B0012; Fri, 29 Aug 2025 03:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF476B0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:12:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9CC113A3CD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:11:59 +0000 (UTC)
X-FDA: 83828925558.11.E252ACA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2F3B40009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:11:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CZy1FfXO;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsaYnSPbY7KFZC8TOsZf1kc7VBPPfZSiAGAh0sCoa1U=;
	b=KPAC/MxRGwg3k3AhgGLHb1j3ZBxmgYQL4xMWGJR7XdWZ754Y01mdDEY7du7bgjsoSYlc1W
	vHnoMTvNc7It2exRtlDBS5pYd55FLT0DUOkkdRpJQv+vextEdeZoB6zvCseor2oEJ1R7vS
	o4zcwOx8I/EMNPfw2BxVNG6IQbwgarY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CZy1FfXO;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451517; a=rsa-sha256;
	cv=none;
	b=wKbN41LnAk+u6j8a3M9OsHwAZxIMzxt+3YMSyP1u406gtzVA6Z7UUYYv+diz82v26KXrWB
	CPoAmz7wDIDiQwfZgqNFac/hyESwbPsd9dnutswBWkNTiojtpBVbzzBEdx4Y6P3nXtoT4O
	6hOZ9CDIQNOnLvcwOmIukNMKiJPz5iw=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b49f7aaf5so10100405e9.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756451516; x=1757056316; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xsaYnSPbY7KFZC8TOsZf1kc7VBPPfZSiAGAh0sCoa1U=;
        b=CZy1FfXOTCJwEZafJfRu8wV/YsNDh3QxCKqj9SyRopH3oo9g2o0kYXi2kduEK5e4HS
         gCFIeXrnZ7l69B9WiAGJ/qP9V+IGYnOB+B/Nuh9eN19Te7WYKnr3yEdMZ0P3z1yGBRAP
         XJq7s/a3OQG2B0DqHX6kAMpNlFbRgrnQewCrJaoeVycTfv4RgY4waBCwMy8X4QUYxH+0
         gXs7rKf00L3faLLJUVpLcVbFBufAZAIYyBDhBca/9M1haliLDsbR+OW23JIuAOJ+5aM3
         ZTN2NCvseGNKCWKidBTLkfl9U+7G1jbQcuLS6R/YL3eA2TBt32IbMDcbDVEujAB2dyVN
         rVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756451516; x=1757056316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsaYnSPbY7KFZC8TOsZf1kc7VBPPfZSiAGAh0sCoa1U=;
        b=ePIMJsXwU0mZh6jNJUPD7mbhDaq5nmUOailEUK/FORlC4y975ojLSQZqb8fuyHyTfU
         kU/ZHLZt0UHiyjCPXDYSzaQoRn0UqIXxsjyHimMqPiaevsqehOskkRp4yaytaZWPJ1cB
         n9kKg5X+955HeMSSnyLZBJP6ukPb0+s5TyiHVrRNxL+jVL0RlxhRs0tJ7QJQoF03fvyU
         os4VFQKX0S220GrVsX1p6xhB8uMWNDWJWLk8WiKKfv5/ikXs/w5+/FqSzcEaETMO1HtO
         h8v+MMJw2AUiYJKg0S7jdcxkGWzmJRSPF4KgySqGvu0EkVogGSsFYyrwkMoUK7I10kOA
         epAw==
X-Forwarded-Encrypted: i=1; AJvYcCV1i/22aR1TbkHevq9/mCDmlnTlX8vNdXr4BjuJveX51U0+z7Rqd+NQQoMEhWcli+xydfa5vWNVjg==@kvack.org
X-Gm-Message-State: AOJu0YxbNKl+HXoNZ0fGBD/E2aZA5p0KWhOow50kcisS3lIDIslB6Co6
	AjByr1wuXf6sq2vqgunjIbcuCWZ8t0ifZ9iHtUTw7TGG6mRTV5nrDmqcbNL66reYaqw=
X-Gm-Gg: ASbGncsWE2RGum6rbqi0MakSyyc/bgEl7v2bHipr9sSHz2qXDVbxS/+2JA8BdDnvjST
	HKtTMoENTAXnzeCwZ/dD6b2V2rfUpOHZGyIDZf5CbdUMhuIdFqvgWiFAjW1Es0qO1fp7V8ceeMj
	iKYcfrSmeUy7kofA8fddXX0ylFZWnbwj2mEuOc1KXD77XEKSwocQFW0ep6NbVPrW83lIw/W/xgj
	QOuWfHkQYRzGdsCqSXz7N1r4ZUOhz5E3kaMW6uHJu6QxnuSIaxU/0hzUGkIKYdBP/9nMAly7kd/
	X2NlDSfvjQ3kqM0XhK31xnPPydqPqSgREZynNiDbLQkubA513rB+DF1y+eTds/ZeeBV3lQn+J9a
	ky2Y+Rf5XV0Q/JlxfulG/efHkJQJZ7UUOFC8=
X-Google-Smtp-Source: AGHT+IGrad3h+79iMHJNzOjhklTvtjDTUtj2Edb2Rh/iq/Nv1ZRT/p5CqZ37Zsd8+CeKMbmOvEWoCw==
X-Received: by 2002:a05:600c:1d87:b0:45b:5ff4:2f8f with SMTP id 5b1f17b1804b1-45b5ff43124mr143219305e9.4.1756451516100;
        Fri, 29 Aug 2025 00:11:56 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e7d23b7sm25444935e9.1.2025.08.29.00.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:11:55 -0700 (PDT)
Date: Fri, 29 Aug 2025 09:11:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <aLFSt1uId1B-AUk_@tiehlicka>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
 <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
 <nwh7gegmvoisbxlsfwslobpbqku376uxdj2z32owkbftvozt3x@4dfet73fh2yy>
 <bcabe7cb-d09c-4789-ae39-407b2e0653da@lucifer.local>
 <ip7al6pv3nm54raaptrxq3v4t7cpilqgppkezowzn2sfbjax65@qt72zuotrwnw>
 <oogiwonpxtqurkad7rt2zxc3ffgeujtilivno3ibcybzucsliw@ym7jm6r5kdil>
 <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2F3B40009
X-Stat-Signature: 3hzbu4h4wrjpkr8qs8tgc1qis7tkc6j1
X-Rspam-User: 
X-HE-Tag: 1756451517-903907
X-HE-Meta: U2FsdGVkX1/otDfQqyBMKC6BF2XQ86btO05Klr9dT7thZjpOy3dxK0jlaVL34tcYqpRF9JkroTVSOKUSkheQFAjVesN8cBab0AUpdvQforZXt0evwoA2HxY50p8vHkWAEEemwJw7gkfnFe49ddvmX8HSrEoedMATOIvyXXlDmw3A4Swglsws/qby/p73XIun8vp+55Y7dWN4CmRjhTS7tF0LE4tDBgFr+qL8QlUswyaIzLv+puKnyV2AVCSKYpza89XkueA0F0llj9/X5SQpBlvnSeQehtkxlYVBbGVdZGuAerQIGUwknrJQ9S1f5ckELI6n0s2yNf1y9320QbCcDT8VP9OGyOvN8E7XVSJNZifvtCXdwO4w17rwhNtC+i/8s16sP52E8d+cnMCiIIq+Twxlo9ltK4mOlszKBr4nDogcuUdnzVPMsrJ2QAy4viFo1kZK+TWtq7y3GMoCrzx7X0OKEWeNUqFwf7Af3Wm0Fv2J+9irfV2e+4o+Ex6DdqRVC647hfmiDRWLgcHSav0BcZ54lMQqenfp4xsI/z4bOsVrtuSd/foXfeKWd0rudX6LX8RtXbUPdMXifClyiUqBDg4MsBZd26Qn0w38qCCIFb78q4MXSnlppauhFykHZKsoZsQMTEZYdj5qvTdCBh2tTBhK9uz/T2AyoC9k2OgX/3tNmVojztdDoPWOpvJr4qRKWksE00W8tpezC5YpEHiBj5E0gqEGqUgLAXDGBBQR/LJIZ5y683gI0SgsO6vQ46NcYOlvgt9wbJGE1txfJghYE5anoQ1c2nXq5Xfi2j3hVJ9utT+0RsS3YStjnvCHQsD9pJllxsp7i6tZGJumrOwEOihm6EABedpVId/CiCTI4VJ7p1SYj48tspY/7cHD4Y1Cz8IMKJ1TJ9VKt2qICO9b47y1R+TxfYOocxu02gZDce0/5PYSvwD4qYcvEtL1CxmK7eGZMx2mpjerbJipybo
 ujtU0mAA
 ooLMxFWivXCq/JAR0X4V/fQIPmKSaPPrsHHE80ag3X2CltuXMWv4QW32w4zI/2vXIVhmFWWjYYC0WmbhCWYGtKSiG7hheaINw3oLLHfNiKIRGD13ROMsTaJ5u02/bTv0wIsxrIicZeh7szrbuZsfJt28MyQkg9uZOqzBR+3Sv3Do0kgnIJJhipOOE6b8M5je2P03L/3bi7gZzxyTkbTvdEoLx4xANNJYkXk1X7op7JfrLraWlB2xJjgtRXsZxfuzxHVHswedKOGca3s3PuAAqr91gbHcRYvQVPMQT65wcCegR/cqYSadu6VOr8DOz2pSpvEGcGcnntsUSa5VPN3EQq3g2I2JXcD/Yja/ZPt3I4qd/4Z0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 27-08-25 00:12:34, Liam R. Howlett wrote:
[...]
> > > I'd think using MMF_ to reduce the race
> > > would achieve the same goal with less risk - which is why I bring it up.
> > > 
> > 
> > With MMF_ flag, are you suggesting oom reaper to skip the unmapping of
> > the oom-killed process?
> 
> Yes, specifically move the MMF_OOM_SKIP flag to earlier in the exit
> path to reduce the possibility of the race/contention.

MMF_OOM_SKIP is a "hide from oom killer" flag and that means that as
soon as you set it up the next oom killer invocation would kill another
task while the current one hasn't freed up the memory yet and therefore
you have a potentially pointless kill.

-- 
Michal Hocko
SUSE Labs

