Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6B6CF9C7A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF596B0008; Thu, 20 Nov 2025 13:35:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496C36B0011; Thu, 20 Nov 2025 13:35:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D39D6B0023; Thu, 20 Nov 2025 13:35:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC866B0008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:35:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB4471A0232
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:35:11 +0000 (UTC)
X-FDA: 84131837622.28.743E2D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9A9EC0013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:35:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBu+wMtg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763663710; a=rsa-sha256;
	cv=none;
	b=6ZcBr6I5fYcF4heDRJuCNPoTb47g8oEUWwUZAOCfQ79A6Fm7DHz2tAkMeA1AnYitAo8HlI
	g8Q+cHIyRQCuCrsJmnBYF5K5KZsn5/RCm4WzVLzJI1+hyT3xjHKQfXURe7GfKr5aErUs2Z
	E0t5cSb9tIUQWjIs3TUNG//4YdCh3IM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBu+wMtg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763663710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUJ2hBeYatugS6Smbbj6N2n3QO68UfcJa1y36dZJ/Z4=;
	b=WSGkiiWKU6pvOeMmOTtt2VwdLQkKA5FWPQdScEN1EjtC2gmn8wPB9IvQqBLUZ/yOuXUMsP
	V91MOB2887Xznd3lD0j7her+3PpDgOOzxG0YiT5CbLQkgfwl354I2dB4Bb5DBvh7S4M9kT
	InEt4kcDpmCifYxvDW5+siOIsu7TpqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A15C60017
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C01C4AF09
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763663708;
	bh=HUJ2hBeYatugS6Smbbj6N2n3QO68UfcJa1y36dZJ/Z4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IBu+wMtgbbfUI7iApR0iRaQ/gREPrFfKYsQaERvj2D7/RjvhtP9YCcEzRoJ9hsUdY
	 R18jR2uSFGzWqknIanhDHl9ffc+lQkMcyrZ9BnQ0I3WOZs4rj1KEIKrudmGLsukrHL
	 JR2A7SIqSCR9AtYOBR5HYwFiD9cUPMC7ypy42JyivQwhi8N5Wy7cEqvOGTcLIpCQ9X
	 IFZR6Iu8w065hx4hJ8Of9CUJh4F6+Bd3KgH1qPVTVNCbIsDfCxtpCnUNcJdsOCqMoq
	 kNE+tn2IIquv0k2MnKZZkwb7la5Keloo/dBHig+GzQYu1c4OUghAxvnX0Iltr0llpD
	 D+akIu1/EjdYQ==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-642fcb9c16aso573435d50.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWmkr6ZwoRkp2hL/a9m+qjbk0jK7PHVstaGFBL4EdBpc/3/+y6cJWaE0vA1fOGvfiae/vAB7F/eWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+d3hmRydARYCKdz0+/WHyGdfnf/A70xGV8LBOESJFlsqgMM3t
	CBhx3rtZDQWZ8syFpliuf3RnPz4o21WpGARdY318L+Ld3bnN2oEMwJDdzljbSYsdEvbTD8ee8DC
	FOKLfc/tAepbTRHNYMku1rAwaShB95/E5U9zkRTMdXg==
X-Google-Smtp-Source: AGHT+IEv8dNE+cRLKAyOyuUIWtplNGioYh0/alC2h+kjIm+zp3dhbbnjHFPrrRNSlPs7SmdmHih/pD7FPA5/3F6n4GY=
X-Received: by 2002:a05:690c:4e02:b0:788:181b:869e with SMTP id
 00721157ae682-78a795fefc0mr53581297b3.40.1763663708107; Thu, 20 Nov 2025
 10:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-4-youngjun.park@lge.com>
 <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
 <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
 <20251105162953.74b38e11ad1a28093e751822@linux-foundation.org>
 <CACePvbVLG2BbC7CQLrC5sP1fUXxuV+MqBh=LyJgLr9REQz252g@mail.gmail.com> <20251120085419.4476309a1af1679106b61ebb@linux-foundation.org>
In-Reply-To: <20251120085419.4476309a1af1679106b61ebb@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 20 Nov 2025 10:34:57 -0800
X-Gmail-Original-Message-ID: <CACePvbW3XscOiyGQ+ubyyFQVdPHZvuG9GkvbyKsuOV1U332aeA@mail.gmail.com>
X-Gm-Features: AWmQ_bklbQ71-TpvyHY5TkfsHG6VF-l_tPzH9G3ul2lRp9Qvyrgd0SGCfYeZYWk
Message-ID: <CACePvbW3XscOiyGQ+ubyyFQVdPHZvuG9GkvbyKsuOV1U332aeA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9A9EC0013
X-Stat-Signature: x14nqmqsrnncyc6hcareshwupauwk9cq
X-HE-Tag: 1763663709-999202
X-HE-Meta: U2FsdGVkX1/FDTVn4eMohUV+YSK5l2HV1ZOsbcXUgT8OavbD6I+bUr8lNN928Vsb2wpgZu6KFg9sgyPOsWLAGUKLzSy5l898E8P0OsHJhWYPU+TDAsbSxhg12Q3HkXKcBeC3jZNYK8L0Ol7J6ZPY8gmzkVoBoJPc0haR7z89/SNdF+zqCsDGGHZEzE1iXXJMVOoAqRHbg3FDmBT7/HWjl1bhLd56k9NUK4IYVeSJDr4iC1KmbjqDHIEe1HKNA7//Ob4z4hiSIGhziXt5/2/XeNU/b9uI5X2Zvc7Rcil8C+Ti4kgopTzZxpNR+lBpaHuxA9CFiMdVTLHfYB2/B+zV7lBj+akr0EF3fsrKS0yVI+P31z2LhE23eOhhvF/EMHuZc7QhUi4cygAsr9M2hic0S21eXVYR7B37W6aygOAuJqOKTp+5YjiydC4lXL65MpNUEbIvBNenHth1AsfQ665HRTWl07nWqsXLV/dbp4Y745SJx99takmT5EqPGQ1STPgQeSExgobODNkPoOv3NKpg5KuryThCJJefpsyma5d6gmdg2TFmM2IJiiujDQTjJXkycH4vWzJWdlWHUs+MnVxyQcb6DefqRN0FXj6pzruYAtZz4ZMiJTwSBx/3yKrsdiGZrJ2n0ZlwzYORjlDsbag6a26sJDZqiApri1BPNBZAJhxBDnsiNdzUDXx36s6v/3GIYsMF/2trn61TZwgxH36N2HlkM5bbo/KOLjC8U/j6KXM//37OEYKv5IMpDyugAFb6Zh7PzHKUURmucErHUyTR1VQT9r1zY9UTc7AeyGDpqgDsEXtPIL3gKiRRSdyuOeW4EbfvJLilxkZcW15ThFE5OTPfW0V2n5juXd467K773xvyiRRIphTtKbv6zjWvQdkKrDaXpwjOF0w9BMbJqO2CHY/AAVZZKQEQFE4wpDqw68FMwsPRVRtBGPXeXSJppokuuLhOs7FWhl/5V9HuQsy
 /nl7IOe2
 HR7Ob1xaUK32tqckEJbtXdOnP6rHVsN2qmrmY2ghIsCWUwPU6uE5zYOlS7RcmXN0VBf5RdMEs0K5ei/BosmE86eUt5cx3+VC4hUehl0SrpDpWhAx8rFlS+5asab2UuID9+Vhd75Cflk4eZUVP2bu3Icx2UxLLsmYveF/4QRvCro3Pd8nqJQ3Ukt9JE5jyn/k7JxYVSUXRROiiFJ3cf6gRJZMuQru37Q7zbxXg2Rvkg9Rw3CDN3ND/Q0rD/+z3+QNTmdXMGG/cKQvgBCFGTLhZHv7Am3dJ1KO8NfcezONFOc6+13VKtbCTMIWNgMP4vO/WBZkg29Ld9E7MfpxVI3Ce2ACob4ULMxBWK4FFTju2xwUoG7wZuUA1pL9NA0RYN5dj21dguP67Z2iX/OmHEGOudvlMg2Ji3TQPT9Em
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 8:54=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> > Hi Andrew,
> >
> > I discuss with Kairui, his swap table phase II series will need to
> > refresh a V3 anyway.
> > Please re-apply this cleanup 5 patch series from YongJun, it is
> > already reviewed. Kairui's phase II V3 will use it as base so we don't
> > hold up this cleanup series for too long.
>
> OK...

Thank you so much and sorry for the back and forth, the phase II
review takes longer than expected.

Chris

