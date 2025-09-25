Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE53CAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897A98E0005; Thu, 25 Sep 2025 14:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F0D8E0001; Thu, 25 Sep 2025 14:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7367B8E0005; Thu, 25 Sep 2025 14:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA978E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:11:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1857A58FB9
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:11:08 +0000 (UTC)
X-FDA: 83928564216.09.C340940
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA3DE20009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:11:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iODXrmuS;
	spf=pass (imf13.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758823865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbmL/lOVeBA4opARTfrAg3LXciWcnWLc1ZjFspAkmC0=;
	b=FY9P4t/IG3JF7oKuRC+zY0CpdX8/tyryLF3yWG7d7+IaeatbVHDiIwoJKV8AnBdCD0IKv0
	t7Sd04SSPS1gNyGGjg/9Gfb+vvYFxUzo3sJjz4vz9r/MRfT76BHhFCtJGnNmd9dWPuBL+x
	fwhRpRwoBTjoASyHiPyCxBihuj39tTw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iODXrmuS;
	spf=pass (imf13.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758823865; a=rsa-sha256;
	cv=none;
	b=OxxaqK5uIfw4MF8SuA/WxQt8avYWOGGkjmQuWDviTD79SA1DBbleCaieW0vCC0IwFSYegy
	b3DlNSQs5nQKSPipt+OWF8kXH0LW9m6YVPa4makzE7zyBetIVF9epyiqjIMl/HIoh++Zdx
	fZkzF/3HZWSxCLHW0zb80ERVODsSOzA=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8593bcdd909so129606385a.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758823865; x=1759428665; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:feedback-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TbmL/lOVeBA4opARTfrAg3LXciWcnWLc1ZjFspAkmC0=;
        b=iODXrmuSTj2APWCjw+5YuCJ1pg7fZ8jU4wElBLrLGrpzGfNwdT/4PzOXCP6aHQ5ft2
         bpqde+m7oTvBxS8R2QJO+TcIQ0hRxn4Y5wusrijd5A6ohBR/KdOkSQ1dQAZQYBuetRbI
         v9oJkpmc3kQDedP/0gU7Mt/is5Cka86Esr8R7sxAaMRd7qvCWNypSq3XaEJODDiI8zdu
         vC/5nxvDoteQUvOMZnhBHvwbixr/TpHRXlFPyR62zhY3vcQ5KK20YpdNNyxNDJpXXmBP
         7gid+YfFDeB923PqulE8ioIR21GH4NSeCEwzTGG2JAClx5pl2E6i7nLgIMbzTeibaFCM
         A/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758823865; x=1759428665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbmL/lOVeBA4opARTfrAg3LXciWcnWLc1ZjFspAkmC0=;
        b=LGgSRKk8fOgOvGGLlQw8rXXMWi48wBbgW78lMnUXQmrLOFhH8/DOr02E+8nDWqqQEd
         BJHgSLpYl6mWJzwtToKRNhhCtsESTuEBe3zKB6TNZAmGpxs/Vx63UW01vkcjWiZo3RJj
         RgFHyeJ2Xr8wb/iPjldqBaOfEeuXLtb11KjV2m+VaiFt8XZWZMMWVDKOD3j+34COERQG
         xtFOKCXFLA+yxp4N+smhZYry2Ol88Es9xyMDcdgzwlZk2Azk0jXyCpWzoTpoEzgALIvw
         GEH/L7xGiDqNzzyZNMYPPBJ7yjqvIbTwrNWxHtdpsMkBvU8jLzg+jUWbquyYeKJECL8T
         lN2w==
X-Forwarded-Encrypted: i=1; AJvYcCXhflk/cMotBh350s9yXXtPNDZNGtIzJW0z6K9Saxs6UsIGt+/I2sxMg0uIA821U4O+EuO0sak53A==@kvack.org
X-Gm-Message-State: AOJu0Yzp+xznKJWo4AouHmqfMEVVAk4/lYHYPy1ZCjLglG+COxZtoOjN
	UCJihjAsfeOC1mtR5jd90jBnxDH3Ahjhq8lMaHYk6gWhNpocj48KAPXQ
X-Gm-Gg: ASbGncsRnUxmMBgqFxy22YMIZiK6m1JFL0EfIhKIjyaXnsBSufGfvliCPA1Ywo+bE1L
	6uvcUQ59AopduZqcwP8OaA4/KudpGc+4vXoLLeLEJQ0iFSfC39KtS//tgvIJ6TTc5Z4YTmFSSFq
	sD/4mw4Xx7PTnueuzJ2/Q8ntZ7+1sgbV46/P7UzwP/ZRfDBrPV3Iq4d7rnfsjhZxO3303tcnQcJ
	pqWzcKV0LXKg1TK/Ze8Vs5R2+CJKGpqEMhR7ZnqJHYt43Zfgze2CPXtr8p1amnljiE9Hl6aYRum
	PDyOrFiqHpnmnr9P+2o1WBh6oOZO/ZxQgM1vWwsq5V0hrupTj16MyFT/YCxlTAcCrLnndySsWQk
	diDIk6iQrC3SVpvHLAKVG6zbE03iR0l/DEwVWQ1VLTI1sQt2iyEuy0mfm7Zwl0BXuLsf4O+tg4p
	yOcjqeWEy69pqD
X-Google-Smtp-Source: AGHT+IHQ4u8Q7QaxnbcTmiHnMGLELyzBn8pkY32qfCMHB+rNHNHO2LejsPVbJxF+ySJ7Pt/+BCn/6g==
X-Received: by 2002:a05:620a:1792:b0:82b:2bad:ba33 with SMTP id af79cd13be357-85adeb4db0bmr521702985a.2.1758823864667;
        Thu, 25 Sep 2025 11:11:04 -0700 (PDT)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c288a0f7dsm150656185a.17.2025.09.25.11.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:11:04 -0700 (PDT)
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7B3F1F40067;
	Thu, 25 Sep 2025 14:11:03 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 25 Sep 2025 14:11:03 -0400
X-ME-Sender: <xms:t4XVaLQLQLOTuSIt8T0l98KGsmwgKR6YsR-sHVTeEPg7a9LskEnVPg>
    <xme:t4XVaOJK0yAo8fWjHvMaFD9w3J67qHPE_0NlLLXiDrpV9L93Aur3b0PTP3nIou2zq
    n5zEYecLbdx5uxvJkgOdk4T0h20W5rPHHLyZyDR0RwmzVfXpyCg0zs>
X-ME-Received: <xmr:t4XVaKGtTG-eqaEbtXpT3B2zaUU_n9zPwLom7qJ0uCvRGYOGOg28tNB1kecNKnrZVjbCKWVwa8Kf2BaSAi4w2_SkEiBJvoRY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeijedujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepuehoqhhunhcuhfgv
    nhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrh
    hnpeeiffdviedtteehffduudfggfegvdejjeeiffehledtgefhheeuheetheelgeehffen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquh
    hnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudej
    jeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrd
    hnrghmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepug
    grkhhrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmvgesvghlihhjrghhshdrshhp
    rggtvgdprhgtphhtthhopehgihhtsegvlhhijhgrhhhsrdhsphgrtggvpdhrtghpthhtoh
    epohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghlvgigrdhgrgihnhho
    rhesghhmrghilhdrtghomhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvth
    dprhgtphhtthhopegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomhdprhgt
    phhtthhopehlohhsshhinheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:t4XVaDRKB_rJV7LRbNXEmMVJHx1ePhimymx69BNbC-HcCA4Cp1WeIA>
    <xmx:t4XVaLVZW5cawveE8GSq4O59KSo60xSBbBj6iBGeTMB692Gww_khmw>
    <xmx:t4XVaKgtPULtCuugXC9lcymHz2Cs2zld4jMfZhxeQi-Dsn1861atNA>
    <xmx:t4XVaMey4KPiqMAJQelWiRjjuc7kcYWMejJK4AUjsFSuX5ZmFWcv0w>
    <xmx:t4XVaNcgdS2Ah1x-yaAI0g2TSFQ3rVMGUR9QSgz9gV-9RIsI8zDQkTWX>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Sep 2025 14:11:02 -0400 (EDT)
Date: Thu, 25 Sep 2025 11:11:01 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Danilo Krummrich <dakr@kernel.org>, Elijah <me@elijahs.space>,
	Elijah Wright <git@elijahs.space>, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] rust: slab: add basic slab module
Message-ID: <aNWFtUGlPeIojFEp@tardis.local>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
 <bypo74mzotejpsjdqd55sxygq3wjffnnimpm3vhm2xr5bddmen@lt6sr77ys73g>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bypo74mzotejpsjdqd55sxygq3wjffnnimpm3vhm2xr5bddmen@lt6sr77ys73g>
X-Rspamd-Queue-Id: DA3DE20009
X-Rspamd-Server: rspam05
X-Stat-Signature: dtbsbzs6egg4rwpsqf5sk3mmrb73muhk
X-Rspam-User: 
X-HE-Tag: 1758823865-797468
X-HE-Meta: U2FsdGVkX18e3SGQfDoQIkgsHGwIEapjHfP31NkvIqb8Ni6GAkfnssTy7Kxn000NgXWa/BSB8iQjAkjC0NR7XJKqBrLu+/inYbavNs+pMV03fty5IaB61cY2uGm2EcvutCoGs3ip2Fv8FN0izLrK/RRqQJEBGRvs1M79UV0emlRQZk0tqAKMCDJ7ZbkBf457AQRVY0VU8xiAPqirc/PqkOjwrSz96WtIUqu2T6NtNoAXoLLQzWBNNa4JXPt5tFWbnhMPrXDqr4Afs+Ei4d9sg+enz0cxYi8wPG5FVdre4dPJOfR4qMEeiI4F5mZrI8nSA5m+VXkxH5N5OaWyngL7kGPwfv9n3puwFmsrwZxpVTyYYNNyQeVoo0sBDT9IQCT1ntEINeBNKKiW1jyokUW1tlIcPsxXCoQesSZAn/okimejh61rM2hFXERIeApQjGTXfOOwvT1q9ieZPJ4uGQFZQKxEpXZ0qE9T4HD1u9ti8ehhnRNYVfBia4F4bJlwR1uxFdascEsXWue4dLwbkcfc+/lLKrWF/mqbGuxaqnn6vSNLToimJIwzi/A7jEfaYo88PIAf04yxoA6Aynn398HlTzzQVBVrO2+yfsqNwKGJn9fWWztYSIHFhOZc0BkwCat3/f5WhRxELEMLIkbINcu0kaQU7jNcGFtpYH6/LglDJGc4nt0RoiAoEg7onnzbJ2kBebjF9We4ka5TDZwUgzSy99hI1fAylWybwo9IoEuL8bPmzx8Qw07BNy+kYpQJIC3ZLBEOeDaoR1PJc9NEpx/QihusqKXMsloF/lsjcYYJYkJDrQNvstxOzQ2N/mNfCQ1r0EFYDY5Cffic2CVeOgOw/0Pq9Ys8JbckkGS/U651yBweAVvrEOi8YRWGPlXFVYJDp/+r48W0NevYtZ34jZyNsoxBOh/GHwwqrgAoi6yo8mJb4aQLEIf/INWvIMRLXVEmIx30frizPEWKoQSR5rY
 tcXc1k9b
 uGPEtX1CfZC6J/xOmewNzGk9W2G1KQzJ/E/vcVu4aG2bc0pEkGHZkj86zDBYW6+ynA9rwhnVZXgTE3WRw8WNRyUUV7VHvhfvIcFYKgSQRqj7gevIsdLjohZirU+XISw2jgECnJHPzZRuGzfZ/NqNmmw8cIbIHphAwnuyaotzGTJWdkwrRiSzceqn5FBSfd5oxp58YBE1X/Qx5KEVLXVzPUrTGTOj2QzOMn63xHGmo0JXLY1U0+LWKB2C+fKIirBNQVFZ8hySaYAZocdod2ZBUs6pFbMzj6y1aTOVVmeQzR8jlMwy1QqagVzS9yZ80hL/nQAaeXlosvkZoVgGJBl8dUoTAgsfA8JnUbomOoZ3RyOj4jPwQmN+PwlDSow9a2HMbOVMq1iWUdKjn5Z8jen/a8Pw8nceuiXMSO0dDjPUrcMfMO0Ksnv+itRZD2SK/RupPANnSJ2xMxDLZ9k8iWsB3jmtXf8d5Fkr9wOL15qDSi9MMKSrehFsEXUqbY9QdgIJ9NI/Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 02:02:55PM -0400, Liam R. Howlett wrote:
> * Danilo Krummrich <dakr@kernel.org> [250925 13:43]:
> > On Thu Sep 25, 2025 at 7:20 PM CEST, Elijah wrote:
> > 
> 
> ...
> 
> > 
> > > I was thinking of maybe creating something like KBox for kmem_cache but 
> > > I didn't want to touch allocator code yet, I figured I would just create 
> > > the groundwork for that to exist. rbtree.rs uses KBox now but I'm not 
> > > sure it should, at least if it's going to scale to many nodes
> > 
> > Ok, so you want to support kmemcache for rbtree nodes. Ideally, you should also
> > have a use-case for that, but given that we'll also need kmemcache in other
> > drivers (such as Nova) anyways, I think that's fine.
> 
> This seems different than what exists on the C side, at least to me.
> The rbtree is implemented by embedding the links to the prev/next into
> the struct which is using the tree.
> 
> The above sounds like the nodes of the rbtree are allocated on its own
> and not part of another allocation on the rust side?
> 

For current in-tree API, yes, because we have to start with something
simple and the user (binder I believe?) doesn't require
external-allocated nodes.

Regards,
Boqun

> That is, the kmemcache would allocate the struct that contains the
> rbtree linkage (or nodes, I guess), but not the nodes alone.
> 
> Thanks,
> Liam

