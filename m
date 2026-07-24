Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1B9C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82B46B008C; Fri, 24 Jul 2026 14:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B339B6B0092; Fri, 24 Jul 2026 14:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A276B0095; Fri, 24 Jul 2026 14:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79E576B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:39:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02E90C0121
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:39:56 +0000 (UTC)
X-FDA: 85024534434.22.5A107FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06E5A40006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:39:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNbUimD5;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784918395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMy0RkLNIpKgOxH4+WCkTX8ET4G9jEK2AAhw88X/HIQ=;
	b=XeuTZYPDAdVh0Z+o1v44r0HJ2bMscUN8KA6uz12eMS/yZRk/Na3NVpfXJVbH8pUkF+Or5h
	rIP+U5SXXhYZuFPcsN3CztRllUHNLyiwqdNNgONy5dauKCcVPn4eflQhLsR7eb3+g57cSz
	B2s1qRRnCvVJSwElTjlxEPyemTte35c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNbUimD5;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784918395;
	b=47pkTYZehdNKY5Gg3BaQLJpVdXtl7JQdu8d72At/nIP0p298yMtICgg27ij/3wgDhBRp9L
	oiN9kTry780G8wKyxy5JXdwD5T6P7xbDCoQ6vZbKS9kc+hw7YLdgiGBfH1BBD/gXJx9wbT
	45wLtAtiuydI/nu6DoVVozeeyjQy7w8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3290442A2A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DDE1F00A3F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784918394;
	bh=yMy0RkLNIpKgOxH4+WCkTX8ET4G9jEK2AAhw88X/HIQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bNbUimD5rb1oWmYlt59f1ayMnQaUUjp8jvJQBgXnHfHjg11tTOQQ+9U0NPB7R2BOE
	 ovRdp3KRww8l4r7yJ5Vqwpx20OifzkU7lAhMTZ8IB8zoE7U/himlZoIaL39i8g3kXB
	 Ah8xmynRQwZTnXVHALrGM5UmbI3MtqnQzd8lz3I3z39DJXBf4uTE1OvO8Dm6h0a2AW
	 ux99rVYZuKrhpZXUlKONXq28uFQa6IIrlKn4MnK2aARjzW1Y8KbO7lUdom+LnfjsvT
	 Ge2bWVZqcXVTbGzcjUpur2vRAJ5SGPJHVo3Pl4pqXg3Z/1RGmhgxuK8/4Cz49HCr0l
	 mLv1NYrOgVAiw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1c52d920b8so108533566b.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:39:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro9YjvuXyrOt3n/p6o9WmlqL4XIKzT2hO9KNvwdwZMOUfn2jsb9zJpqQ3Y8e3G7V3ekG603+aMcLg==@kvack.org
X-Gm-Message-State: AOJu0Yw5Q6dBQymCCd00mAsSLK7agmfAclhPX+s9kQtZXVGipGlokQi9
	Rf6FX8ETYNmrGoDjYM5Tmk7qRCHzTvD1dr/NGQFRxjpl6jw/4aBsl26btjB9SEnzXKLj7y3um5g
	BkWeMT6RaHcwG27BX32N2avYfB/b3WJg=
X-Received: by 2002:a17:907:7b97:b0:c19:8408:5b54 with SMTP id
 a640c23a62f3a-c1c509e2830mr386703166b.60.1784918392986; Fri, 24 Jul 2026
 11:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
In-Reply-To: <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Jul 2026 11:39:41 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
X-Gm-Features: AUfX_myfbn2VHTOdNwc3INo5jsB-s4YaeeA8KkqfC_LpORcf2nZ2hwByHTxg6Xc
Message-ID: <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06E5A40006
X-Stat-Signature: yur1fzfn65xtd9t9ja8epnxgbbf1dmzt
X-HE-Tag: 1784918394-565372
X-HE-Meta: U2FsdGVkX19N9E/uuRTyfzZPxhjaxBOMtTXpjbZXWLR7PyJX44AfzT8f6eW9Hnx0fsYtFv8jTlJHRCnyC7EyLZ7pBwCtyup6YcGTGQFxZaXuBN4I0g9m3nwUS+zDHYICRj4VqK5eivXbkyYpHiEtEk8tVeZePOACdXpSPEBnszCRLO5stPhQZCDFAsSzE4gDaop8FXj3+d6rd1rrfJbob5CdyEhsv4K7TJSEU8pgw5bOge8iQwLKS3edg2o371UJoowbxSjrqLtcmIwS7CJagXmckrOxryXVCw81FUwgiEMa1WlttzxqsEzPdntAML1HAMRfyDS2iwIJBPo8CdvLFYE8cYZdDJTvETod5BzcHeUF2NblfjZ1g+Z0LGYCm0HFouk5xdCwem20PCrE+hOayBazNUjjE/Cw/GgAx3YByCwBWcNz9+41dPpRsGZtIxFze7i+Xk9wYJtokmc+JMkAJC3jsXewx7zB2/MoJWmasWdcZLS0EvMUY/sIjLJyzvNNMMK32/kHS2Y4GUuQWrQwSrS0wt3wd8bzVUmgfNN6kJFViSRM28LS5oCR9EhQD+ehyB77flCHOpEmkRLMgxSOiesh9vNvWYgPitCXbW9R63GBCBouB0p4Oe48JHDC0i39uWs+LiWydbmxSS6cZk0poTeWN/G2FKeeyBwUGyV3d35IyYjSTRMRBsc0SjplEkhQfusKLBpKs2HI4YSKhLCRhRNru1S85p75xmBKfhdgOTAtS+743Y8sT26iRBWDkJULT83Z9GCqN7oJlCMNCU2GPbPv2smfsb7e1SpL2jXTqlJX3vGjTwuiByhevTSHq4W412KMpOEeOGoCpytyteODFynbCuJegZzrjzpcXaxISKrPAFhmi+ecloXVB/dLhSUsrZyfIA6SO4H2jP9VbppNLq/5SS9U6pdt9ZoEVzIoaEapsUO7jEVJeknaUM2pfQXbPJPg0yT5v4xAwV1XtOL
 i2FAuLPV
 nJayU4qlLEa5UhBuzvadLwC9Bss3cBoFv6FAXZBUVW/vprhujUc8217u9hHO0Si8ZSA72yIoLufoySKfkZAaYbCzOGo9z0fbpfAyKfdn/J78kLa9DBWVvPanDsPGpP/1Bius5DkDBuUOqt2+QL5GRMHEHCfp4nk3cCiPbJs5cDkkxgexbRnkO1NYlQXH5GKmfxQxXvl5hxvHF1pnOebPrJx1M9f3xMu6eLsw3BD3ADVJrnPIzJ3uLGMzoYXMNo8uzVVtOyxrErkdLoomzMVyES9dby1MJuDrkZBCUynbqTcmUZNuYREVQ+Y3RaIyARlpcN5IVJPDirikcztbrHH87JkRQrx5++YCTKYVZ2/2LLhyccVfXSOSX89lwqw3vWBTIUT9EJrdn78W6+Dw1EvxSBji2+7Nh0E+I8YTfhwcVGnF0fUSTwDXSrKW1XhKCa8S2SghLUp/mgap6Ti4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Fri, Jul 24, 2026 at 10:57=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > The numbers generally look good, the store rejection rate is
> > decreasing and we are naturally doing more writeback which makes
> > sense. The store rejection rate actually increases when the batch size
> > increases to 64, maybe aggressive writeback is more likely to fail and
> > cause a store rejection, so that also makes sense.
> >
> > The only part I can't immediately reason about is pswpin. How are we
> > reading from physical swap more than we ever wrote to it?
>
> The same page can be swapped out once, and swap in multiple times :)
>
> Unlike zswap, physical swap in is not necessarily exclusive. You load
> the page in memory, but if the swapfile is not full, etc. etc. you
> don't invalidate the copy of the data on the swapfile. At reclaim
> time, we notice the page is not dirty, so we just skip (z)swapout.

Oh right, I forgot about that, thanks.

I still don't fully understand why pswpin is significantly increased
with batching here. I would hope that with less LRU inversion we end
up with less disk swapin. Probably the test access patterns are just
too random compared to real workloads?

