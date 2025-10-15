Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6406FCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83428E001A; Wed, 15 Oct 2025 04:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B340B8E0002; Wed, 15 Oct 2025 04:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70DE8E001A; Wed, 15 Oct 2025 04:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9412C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:55:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20D9185784
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:55:13 +0000 (UTC)
X-FDA: 83999739306.30.34D6FDD
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3D17F1C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:55:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hkYuhbqH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kundanthebest@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=kundanthebest@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518511; a=rsa-sha256;
	cv=none;
	b=cDM5Naga7PGRh2DWRLUm6siJj+F7sr9HIzqS0lXPsL6wbBr20/T6RoguBjK/lL08LDRTwz
	sbGNTJOa2/+rp0AxNaVtki2rtZ69wR2qHZuxLWHvFNeqfbAc5NwQVFimqN9xkA9FWuQ/xs
	bybvwyAsqwgHR8qM8TbqvVXpTpatnb4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hkYuhbqH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kundanthebest@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=kundanthebest@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgEqnrxX4R0u2xnG7ixfV3NvX2lvrI5nPU8w2RGCEiE=;
	b=FP1Ug1H0qC0qcrS4FKwXxAY+WavPFfRe96O/NkWmugh4SSnBJCEgVsF0AK3iAX9eaEOW0E
	0aWuzrVX05U3EIviN9LGq9zB5vUWAQFOssNfJz1i2YKf+f17FHaFWJzjiV72EoHtfJ+Sez
	VM3JKj2Z2nWT+lt+0VvENvU+DYNW/yI=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b3d5088259eso926553966b.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760518510; x=1761123310; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fgEqnrxX4R0u2xnG7ixfV3NvX2lvrI5nPU8w2RGCEiE=;
        b=hkYuhbqHHP3PuDM7x4aE3UcysaG2uHcAadhVy18Ms6H6I7oAR5oYnVuNTkQCj3JRf0
         jBvXUN5pSETldeHn4t/55kOW/zUWm6r7/kLa4mwMLlQsYIlavehbSUrjjtXSXW6eli/R
         MmD4WCszzUje/ULo2y0ZDumps5F9cM53734ThZ2Ft5GZMhJU8rldhPWAcEn1sGIwkqFJ
         Ozg+djWA46+dmEPZZop7Q7V9T3WdX9AA1BdQNROhD9RfM30fbZmI7r0yZeFN2WcVYm2B
         qIfmm3rVW5UjjeMITWoVddyO4BQA0clHWq5KEYIwtg9+FQWKi7fds/sv/NeskIdYiMs4
         E21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760518510; x=1761123310;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgEqnrxX4R0u2xnG7ixfV3NvX2lvrI5nPU8w2RGCEiE=;
        b=Rk4bRpPZTz4oeBrFExNPDjQkY5Vy/x1Sdaxj3Ws/IZNak0tBB+u4wLQLn2IXMGAXG3
         ApjTUlqeOcsp29mZeJuQrv9ASGrrZqusR0Zj6NUeRuRSFufyi6lW9BLqhqFDy+cgJ7x+
         Vogp4QR7Y8pxFepSXRAJ0U5UK3tPw//Q2CqcbjRCnrhjESHQUolkZB8MjTG45W2XuULc
         jFglmvBh03MeAwTCpPUGh5Ms7Q2c0mp/otvP7wp5qlsE+orwwKtmHyG0Hb1KFNT0hA1O
         0p+/Z4EbRq54wARpz6DbTPcoN3EYXpLVDDM7vBdKpFDpXtPBsZZi4tJlnkFoACw30eXI
         am0w==
X-Forwarded-Encrypted: i=1; AJvYcCXyMcF7HonjdenXZVCU4YsRPKZvi6Tvu8YEEI7mXjCaUPH21rwJ/AqrcgsWaQ4SjcOCCmciY8gZ9g==@kvack.org
X-Gm-Message-State: AOJu0YwfVA3H/v2h89PAdY1kA9HdtQrF0piYQ/TZCerDBOJ7BrrHpZka
	5xrYDQfk8Qf+UKTpmM0ctF1zk+t0u2SFaXZtsAgpOyR7ETjQ17c0ZMpylOMhqbeBYN3mC13HVR+
	PaSGtiMzc7jRQeT8PaNVOx88r/IzxPNI=
X-Gm-Gg: ASbGncvXPz4NySC25yVIjGKUelSOvvxwfbBoTHiev+GSLVH0tLB5Z437ledAj/nhlkL
	CZpTOXllBa2wtyOedYNKf9CQOKBaTcJhUIKioTZV80I29wy+A9T0uln7lgi3Tk0sVFqzpDYBZi6
	oNWG3VPtMeG6nSJg9InYm8iESnXnSaYGVj8cT/GzihcF9npzD5fPWff/fZw8Gyms83LEfXlXp9s
	gpUZL8P+McDvq9IrI8XCpnkai/i66xPLu4M6dbUJSm1Yvdv
X-Google-Smtp-Source: AGHT+IFTcVXJ2k4Io0gR55B+LOiUs0D6lc9nA2FkAagSET75wVrURhguyB7dmaTVjRb2yFF3HFNEaUx2J8d6K4IUlfA=
X-Received: by 2002:a17:907:9448:b0:b40:a71b:151f with SMTP id
 a640c23a62f3a-b50ac1c4e7cmr3185549666b.30.1760518509261; Wed, 15 Oct 2025
 01:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
 <20251014120845.2361-1-kundan.kumar@samsung.com> <20251014180312.6917d7bd5681d4c8ca356691@linux-foundation.org>
In-Reply-To: <20251014180312.6917d7bd5681d4c8ca356691@linux-foundation.org>
From: Kundan Kumar <kundanthebest@gmail.com>
Date: Wed, 15 Oct 2025 14:24:57 +0530
X-Gm-Features: AS18NWBrpUjyPc8mxzcKZ88p2FW9F32bwQuz9_BbcqcNCJwm-Zl4oTpr4byxBk0
Message-ID: <CALYkqXp9Wewk=P79r+Q8HjngUOSWq71ZA6NBm5fPSj9EZHh1Ng@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, jaegeuk@kernel.org, chao@kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, 
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org, willy@infradead.org, 
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com, amir73il@gmail.com, 
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org, 
	dave@stgolabs.net, wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com, 
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D17F1C000F
X-Stat-Signature: am1whfwqa7w68ibw96gynbf36kmpb6ju
X-HE-Tag: 1760518510-815030
X-HE-Meta: U2FsdGVkX181p1CUZNccygEEsdvQQSFSEoK8CQJPUltN2HgWDNKG9nnQzSRHp0H7Qry7wAalZDEZWfMLKgopvwA7SNR6ZxdrdBTcO6r9FH1WKxeXSbbMpJzXFip2SeQBJ1RsyParVF+aNedS5AKJ8KhJvVK6aEMDaZpWt40ul1ni1npxIQwh3rJAUYwSE6/Dk0BELllqDSsyfqqwqEbYpp4c9jGT5oaMTln4DRsnSmEtcKdRYvXkb6GK21bHXHKhTo13LWffw5fi41iXSvKiM+Ks6siFLBxjg9gKECh8GX9om0njCYKrxZy8YTWIi3uRzXcR4/VFgGXCzwxT71+T/85vbk1nY4WPhb3Mf3fx2TH1Q7L35DKwiECH+FZcRnzyQZzpA2Xd3mFjB7TgpZM6WCqJd0fHGtZnre5RvjSDm4fBNU6F//DX+ph7CaAUZGysSyx22SfbW4/TUbvyooWj8B2hI0EiXhyB92FMLu4s5ip7sueieg7xSURMeLjHZlHqtzbGporzrFcuG+R4/vSBzf3RFLaQtEE4kK4TvMSAlVsAarP7Lk/BwDqrfdpj4v0XbFgFSjGYuVOZ7bljw2L9LQF++de/TXzdewL5ua0Pdx1ST5wglz5EaAiMvSBXMn55Z3qRWL0zfFs/cWsZdChHbZ1+rfWGDETJswujumLENyQe05oH/8a0Z0bwk5KUcQXW+gAYMseqPE7zNftdIXhGJXfR28Alz8mLu7AhfKQ850gjAfqsSUWXnTgxKGYFAcdQv41/8PoDbhSvlPZRWqiTE/uBIB1CmXNW8XixoqJRPehanPSAEVHamFVUZZkkc6McA1vvY+blO9JKzR1LCSd3mu8grteU3bQEMTEz04osVUVef/xhOf+5pgNGR5poOgoi7K8+i5I3BCqTV19AogZuC3JFBtzZJm/d2hUIOwg0c5vpEl44e8cjDKe0w8gpTFgyOb5NVffX6Ml7mEsfEVo
 puRgoN+5
 n9xgIckPKlE80OOAG/nnk7WmM2NYXb3z9arP6zDOuZIKIPnMtwVlipeEY6zwdLBfaNPuryv8tmoDgEM1eFlPpk2im+Yc1EQsE7TRjCfI72H3OzH4RbADKDwH9ExF7im7/HUPbYSpYIVntGVnWi3SFom4C96k/rAHuId8PcOg+210KI7g0KtZNBbL8rHVZKbs7ul2kVwBrmk4fKtsHL39HQ2UHljcmsLe80jbV58zWA0D3f79BrkSRkmPK/7T/5ZCnNxcyfK8cu77z6uO9htpLqNBkcidoKVnIkmQvtByO0nHTG6CzPaXX7GUHNkLHO4zS0f3YE79yXv1UjhvavK+YDycFSE8dAsFbLKCvVRSw1rWGFoHNm8lE0wCj3Pd21AdEmiU7XAgpy1OOVbHkjAlYrcwE5VqxuFacoo1VsYqoPuHZyEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Nice results.  Is testing planned for other filesystems?
>

The changes currently improve the writeback performance for XFS only.
We have introduced a callback that other filesystems can implement to
decide which writeback context an inode should be affined to.

This is because the decision to affine an inode to a particular
writeback context depends on the FS geometry. For example, in XFS
inodes belonging to the same allocation group should be affined to the
same writeback context. Arbitrarily distributing inodes across
different writeback contexts can lead to contention of FS resources,
which can degrade performance.

I conducted a sanity check on the performance of EXT4, BTRFS, and F2FS
with the current changes, and the results show no performance impact.

