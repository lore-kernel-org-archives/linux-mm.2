Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 810D8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67078E0008; Wed, 10 Sep 2025 08:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F06D8E0003; Wed, 10 Sep 2025 08:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DB78E0008; Wed, 10 Sep 2025 08:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82D7E8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:57:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D02F5BA19
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:57:01 +0000 (UTC)
X-FDA: 83873340642.30.B08AB90
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2CD921A0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:56:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI6y+Y1a;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMKyDunwSGtBRbm9G/rqnpc3sRFNucd0BdvyVxUFvLg=;
	b=FutYJJp9tpXzqKSTz4WfoB8ZmaE+xx7u38N8bahgfw+rGUmB4wal1ixvhfsOhojLpn7YVg
	wEbmFeFvgQSTxuEU6m41PvBL7VpTJYS52OI8qqWf0hj9ko0jVLg21Wc4DXzqf/+wyd8V5r
	ygiavdI7T/OJHqJWSEMVSW2zGygWYHI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI6y+Y1a;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509019; a=rsa-sha256;
	cv=none;
	b=lL2JWQniQTLm5fjNNOmBeCDHAgWHKtSxS61hD9Z/TiGPq9a9B7DpHDx2B3rPMVYVGxrBXe
	mfss+aZImpdHKxbmZCotijMSC6C5v1PQpFjOrlKvRqYcqFSyYcY+Bg6OTjf0LJyqdIMlYt
	ZZ5Nx4CSeatP0hTF0gDtU/P+J0aWpd4=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so7607453a12.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757509017; x=1758113817; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMKyDunwSGtBRbm9G/rqnpc3sRFNucd0BdvyVxUFvLg=;
        b=WI6y+Y1aNwp7bMIAVMayK+byo5peOgbux6dGajINmEzNDI5ZLkI+ZiIpQk38KbJTeF
         RGLjoa9G9bg41KHGcT5L14MFJhBusitFiWwtWXcX3K7T/Tqy7bOcHBCfvo3vl9Z/3A29
         dwkbIs2htgLwL9fMMUpQDzEKB4GPZM4ndRlmFYjYYmLrc8rexTd75ZDw5uP1JbGnPTDE
         ItiskDVWewChwce2rt8YiVZ9DZORyuQ1nGhnvW3FcMZHS/VqRoP9U9LmvFVhO6h0ZoLx
         yzxmCgBZUD+ExM3JrMbb6SDLnh2I9zB+O3t+ShkM63JotVHb6H2fVN4FNAxJ8p+uTU1N
         30QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757509017; x=1758113817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MMKyDunwSGtBRbm9G/rqnpc3sRFNucd0BdvyVxUFvLg=;
        b=qzhB9gfNW7m7MQGE7Mr2CnpgPPFCZau94z/Die22xjkZujsNRyzTO6wetn+ZrHHPFD
         cy6Pp9hnADU/z6xbXxkhxE1/2BgJ1rBNRpfQpLzfyFMWz8Kvy3dBOeFfnQxD7AgLRJzv
         kFXnU827e7kaimimD9M+DTPaTQ7aUgYal5J6mFyxiVENRNS7TbEYSKL3eLf0DySYu0uI
         E9zv0j5tY939Vgwv5ptSCe2N29ADMeL2eP5SnXNICz3a87ES+Rk6JqC2i6SW5mnZRYDK
         VOuMJ1noomGZ9rw53yezGt1D0mROQ7xJHXsK1tM7jcaXft8mD+eJ2/SIhiaLTOuJ6pOO
         Ezqg==
X-Gm-Message-State: AOJu0YwQQj0I/ZHgWWIMQ7I8ZqCT4bfjQF2j9PbGezL7cAw0P4L5PulN
	uBGE0IPNMAnejW5xb9l+/myKdCP/x4n9iamRMDGOdzpo0RQr9WVH3Rpe+aVJCXDdTP4bKYcDUOY
	4u8A4tPiKYXaSbIcogU1FrspECeb54fM=
X-Gm-Gg: ASbGncuNVEhNqeEC1X0VTuQwZmN90K0FiYIS4num9NkQQ5avBaJfx7g0WspPLuLSWZt
	CcYBz0Hm9r/aorSQANMLx0aRvKH0nrZenl/zGyb6NYCSnY2/o41SOZcvE38HeiLttR+WWwpAWVI
	LN9MjlaTKEMqYGvnX5hd9LOzfrZV5hG0J4ZSHowmi9QeqUOJotD/eZrBjQyRLGQlaL6x8gK6CPr
	L5GdBCz8GUgycyaLMCilA==
X-Google-Smtp-Source: AGHT+IEv9eLVpjjBvqrFpdRX6L3iK/v3rJwHC4f9FyOGjkK+DZCBoaCqi9xQ3rFk6LzHDIS4tktgKLhkDhbSow62Vc8=
X-Received: by 2002:a05:6402:4305:b0:629:7973:e8b1 with SMTP id
 4fb4d7f45d1cf-6297973ec5fmr7558603a12.7.1757509017250; Wed, 10 Sep 2025
 05:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-6-ryncsn@gmail.com>
 <0bbda135-068a-45bd-afd6-3f5cdf4e570d@redhat.com> <CAMgjq7CsKYWzAD0Ev7q0cocQO8kOYLmhgLD0wk6AX-HUzWFJZQ@mail.gmail.com>
 <283fc6d5-caca-4a67-916e-55246a5a4cbb@redhat.com>
In-Reply-To: <283fc6d5-caca-4a67-916e-55246a5a4cbb@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 10 Sep 2025 20:56:20 +0800
X-Gm-Features: AS18NWCq6G6AFq-R6ytPum-lAXwcxsOSJmLax7Xy0V_qYAvPUPQFSkeoLQETCvU
Message-ID: <CAMgjq7Axhj-OGe6p1_KHAcR=j92=3MjMMz1YafsPxHWqsmemiA@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qx7md7hbk7f61pru1u4hduugri1eo1rb
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CD921A0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757509018-112469
X-HE-Meta: U2FsdGVkX1+UMofoC+BabPdr4KrIc6+b7I6UxlwamEmmUJhCpvkucXBqGEIER66Ec03KIT3h7f1LLyzo8+Xrdu1nfcIR85bT3kl3KnyHB9LcVip58gyeq6wFHIsYm6/DlQXn0MFpllvl43QrbDbULfPMDlYaO/mARxzymUCjcFcZXhDXe2hZdJ5KtManEdSv9uX5btQt4gAtURILzMSX3Cz2wI9AludMR2/JIcxWkQ0siW+7y13ThgKh3fSeaNGcANcSqXCh5brizxJ43hcSxAq+CCNlZSfDG6Rbt1/jIBy45gK1F4Z+bxs42VmO97BoRBZaJyXMfdsHksIDkedjJv59CkrBnooL/ojkbqQFX87Q2FlEmkEAC7Jj8Xcrtr7QO9m1d+nnSPiU9ANKxgqDx1a1RoFkQRyo6RRW+xhSvIff/2/ATOFe0qeDOEgSYrPnQnil4Ryv1FyIX0WBHXCaKBplGLInd6zKq5mz1Jiy/P9EOiux8Adfiw67b2h2h83wJk0YhLeQCadLy0npltT9aXr6pTciZOtckwpilno0pqb/PJy6+u8o2z0IvJnbgJh+moyZBp5jUlWTwF4gOWD39a5CtGfwkoR1mXMd2dfVepqCxRHXAr2FXgkiwpHInx58Z6O/u6+TCPh9vWJLtAoH/vsC7ZLK1Mqs1pADQyMJZLfo+1IpoOwM9jTzSUw1RMz8AOBBIRvuz1H64YhmdnqUla8OvYcEqL+Cutbb4Lm1o2g/QiBqcSxIgE/6MnY7s73eBHaLa2aW8dj2Y3gqJ8Ytw2qZTrYYtJ84/DoTcQI2QxT6LFB0UOfA241xQERRTNOiVQlFc0KCdRuwCB6zTONCVeVotaYG5T8xjBglkKrwBY9H0zSslnIHNosskIkhUxWpCV8rZIlzk9C1kUtr45yIziaTRF2DSElgCtWXwoNAC4OCQuIg0Bjiyf+7taP+TckqBltPZ9nR0fzwVUux471
 Wp/TULUV
 vvXTV8hJVUBEZydm7mf7MkKdOmrRwGR/nv/TUoSyFzkXziY+/pvEnj0lPvyKpfAjYg8GOFHAmA4xY0oJ/6bTmfbSW5vIaG5qlfJK3aI5MGZj1pvfAbX1v7wX52FuI6LRtuk3Ibn47epgB+oDnIk4uJAB/uIcIQd3QOcVaoBJBardBAdf9SIhKlwnawHnD5isFE3IjKCbKVkY0ql/aJfBQt0RYZJMq3OyRPQYMyhf6yeiEXBWqzOmAlawqdkg/G3vQIOXX5TH1in9S2+CgJKxJqtqqtGLHyEPwvsBpDicfTqClUmJVCov77CmfBor7n0FMCn6XpXSASzZmn48zCEHY2XkPuOPI2GOIiTNT5ei03ukZ4VYhegH3D5V+U99zI1At1pIQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 11:19=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 09.09.25 16:58, Kairui Song wrote:
> > On Mon, Sep 8, 2025 at 10:08=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >>
> >>>
> >>>                folio_lock(folio);
> >>> +             if (!folio_matches_swap_entry(folio, entry)) {
> >>> +                     folio_unlock(folio);
> >>> +                     folio_put(folio);
> >>> +                     continue;
> >>> +             }
> >>> +
> >>
> >> I wonder if we should put that into unuse_pte() instead. It checks for
> >> other types of races (like the page table entry getting modified) alre=
ady.
> >
> > Doing this earlier here might help to avoid the folio_wait_writeback
> > below?
>
> Why would we care about optimizing that out in that corner case?
>
> And checking the folio right after locking seems to follow the
> > convention more strictly.
>
> I'd just slap it into unuse_pte() where you can return immediately and
> we don't need another duplicated
>
>         folio_unlock(folio);
>         folio_put(folio);
>         continue;

Yeah, removing the duplication is a very good point.

>
> --
> Cheers
>
> David / dhildenb
>

