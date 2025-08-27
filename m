Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D63CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117448E0113; Tue, 26 Aug 2025 22:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C96F8E0105; Tue, 26 Aug 2025 22:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E157C8E0113; Tue, 26 Aug 2025 22:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94418E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:12:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E823C03F5
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:12:26 +0000 (UTC)
X-FDA: 83820913092.03.E754A2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E31A100005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:12:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9NsJStQ;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92ufSU3QMirtn/fHDO/1rgNKvLi3yd0ndFnVmv977Dk=;
	b=Z+rqgXgwy5ILbwQoYVZAd6aHhSAJahXgnumLjIFLpjOKf26uZ6NN3/KDZe6DbRJdr5Cc0u
	j0Z83x7lx1R65QA6V40JiX7UnlrBxJZa7kC7t4JNzp5j2pY5q+RDbPzyU8+XL9G7PaJADH
	OF5CNk3w5oA6LXorthgQhNwaq6g9Yfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260744; a=rsa-sha256;
	cv=none;
	b=UwMll1T8GFFeQJY3SBl0h/CzKot2CIqE3LK8psMVja2kA1Sg63oJY1DWI0G4UvASFZly5q
	Ww0AuSsGDX5TvkGDLV97O7gf4rthzWGSCk+WPED0piljVusseARK2QPG94B056XMkRelm9
	YPWQdZHjc+c5auQ4kCNpYmsqr9e8YiU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9NsJStQ;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68FFD4518F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FE1C4AF09
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756260743;
	bh=q3BHnTyprndOuKphk/986OLRZxR8Lf0Nb5L1CnkrEIQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O9NsJStQ4Q1w1TG2G5Ijni7Gm7CF8SUUTRJf0rDWlpomG0JQ5O6P5Cad9ZkqtQ2nD
	 C3PkIOCJfEDGFAbNSIj4FoRQPzR7xeyhZshY1D43Fu1q7EaT1R4IWp4cTg3AxP21C4
	 fKI1dfmDzGxjUXtEtS576GlgOItwJoR8ZwnEiM1+s+RYG1wuMWBU5MzirRKqiI7eUX
	 +jwW4ZYNibE+1wMTUF5DH47wakIeyv93bGMu6qxbngdV2jNzGBa3CgSRI33Tntawuh
	 GJzGf3VY/OG3q3QpONjsMO6N8JPhFy9S4sMOAgJlAS2NF1Q/dy62p1g8iOu3HPR5Ur
	 Ps7O4+2GbhWCA==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d603a9cfaso45177857b3.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:12:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWBO9WjnmzHJBvipbobqvUAjMRP9Vsb2OwTgUEg8lyFKjYoNUJ87fnoisGwyb5fgo3rTmMRRQvAhQ==@kvack.org
X-Gm-Message-State: AOJu0Yxn3Qdv0uhD5uHCRIYI/qsD/yDQ6wUz2gTRw51mXCY44eLHvo3d
	faZKUq+pfQq6Pyua/pkB4JnvqGZbEKQr9SCAKMSUXjPoiVZ/kiYx2ZDGziII3FMyHIqMRvKPaQi
	M7W942hqS4TuGPJ5zvzr0vUX5ieumxwB4vrlYyknUDw==
X-Google-Smtp-Source: AGHT+IEDyAmgqIwD4iHxr016hc/sN+CLBgPqqTEe+4xgcqDUeB/dlcmPyaawZhUoORiYlJxetixb6mEsNqqbhawFvw8=
X-Received: by 2002:a05:690c:d82:b0:71c:4091:3c61 with SMTP id
 00721157ae682-71fdc30b412mr220214347b3.22.1756260742402; Tue, 26 Aug 2025
 19:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826231626.218675-2-max.kellermann@ionos.com> <BA16C3BF-C843-4976-8FCC-159324B2E477@nvidia.com>
In-Reply-To: <BA16C3BF-C843-4976-8FCC-159324B2E477@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 19:12:10 -0700
X-Gmail-Original-Message-ID: <CACePvbW4AG5nyohmEMS1BrmJNm+Xtaz8_rCCGdSu9Y1iOG-nqQ@mail.gmail.com>
X-Gm-Features: Ac12FXyA8McbAPcgcSwRJ4XPhqPTQ1ZXjfdNh9v53BJi2bHEYOaY-70OWXZymKE
Message-ID: <CACePvbW4AG5nyohmEMS1BrmJNm+Xtaz8_rCCGdSu9Y1iOG-nqQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: add BUG_ON(folio==NULL) to folios_put_refs()
To: Zi Yan <ziy@nvidia.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E31A100005
X-Stat-Signature: aqaw7t7pffdd7t7gow9owj6txodmadsr
X-Rspam-User: 
X-HE-Tag: 1756260744-678710
X-HE-Meta: U2FsdGVkX1+B3/2a+/iNOTJ0jERDyz0YEKWiq3dNf0GPvxeVNVvjENZ+Q+IR3eWN6fTWDy/u1xfhtDIaORxgFpU/JkNckrAnb/XdDv4NUWFBWR8oh5Eq4lGikEBUkIyn/h2fE6AhlbvotviTPHvWY5d4cpsRzq7qTHLVuPViJIuqgdIOOe3yo1uAIRO9Ey554QlLIa+QZo0MVQyRTISXIaw5CjQWk0eb353MTu175YKCsvRLyWuDQQypjJLG9Ljm13NXt6b79staXlWHZRp6ENJYtWVvcdnHIOEbL1uLQocab3XxgIxouhoS4czZLsnqjbWnMfDoRZYhw8rfMkqmtEFgPR8hVSdCZyRvSEf6WTQMcxQ6xOjezE9P2sMGCyynuOJEkgph7Vh22PBb0VjnzwA9X5/z8EJ3BKd7fN7VlS3+1cP1s/huhu3TVQ7S2ATsZp4RN+Bvh+ELvKNgCXS/miGV70bCoDStCjNuLW2Ie+T2P3wUCCVcM1rAejUw4znfqx+2CvLIXBw2tiy5nhYMWYGjdeq3yooLPJWB3nDmBmwaD3VNnXHxMsStSrTxOQ0WGxpixpZQzDfxBcQ44yLqt0Gjx9vdkG2NEgtLENCIHtukAni1Ubwc9HUdRlFAS53o7OyE0umT9cs+LGo2dsR116hJXyqrfyYqPI+TOzqG/hk1M8XYStBGrmvNjNmOKC3CqpqFPHgr4jRspkH8tvU1bmSGlUOUD1Rlxkx7nsvtuLl6wBckqUd2Mrl6231u6VJ7U7SEEHx3RiMiNiKOdexN6Wdu5CdVom9+Ta24cwKTuh37s7ZslQ80dnmGW8MlZI6UkJv5uWf1hfLFb/NXj+YtT6Ec1NYKRGiADmF3FOeuHN8Rl+S2/x038qb3Yp2YtND952k+DEIHNC5KW/CdVqn9NTzv31k2EWZHeAhhskwCYFexg15H16mAf8I9ZoUcnd95UIyo7ikzzR9P7U30ZeX
 lNtxqQu7
 nRkPDRkE8JJw3oKKbID+5FJMJ2TVvwPLvWJUO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 6:43=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -952,6 +952,7 @@ void folios_put_refs(struct folio_batch *folios, un=
signed int *refs)
> >       for (i =3D 0, j =3D 0; i < folios->nr; i++) {
> >               struct folio *folio =3D folios->folios[i];
> >               unsigned int nr_refs =3D refs ? refs[i] : 1;
> > +             BUG_ON(folio =3D=3D NULL);
> >
> >               if (is_huge_zero_folio(folio))
> >                       continue;
>
> We are moving away from BUG_ON. It is better to use WARN_ON_ONCE and skip
> NULL values:
>
> if (WARN_ON_ONCE(!folio))
>         continue;

+1

Chris

