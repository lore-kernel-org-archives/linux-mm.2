Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD57CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD37B8E0018; Mon,  8 Sep 2025 11:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAFA8E0001; Mon,  8 Sep 2025 11:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E85A8E0018; Mon,  8 Sep 2025 11:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8985A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:52:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 342F01401D3
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:52:45 +0000 (UTC)
X-FDA: 83866525890.26.DB176DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 294D04000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:52:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sr9+jP0s;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757346763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4/wSEN5V/tEFcdnGz88vxrUfrYJZXuuPA7e+i0IFgQ=;
	b=VExa/QZSGJ2c03I45/+WMA4WHlAGRcpbRjfrhMEfC7S4tgTdkJwX6IXhUaSwg4cQXUuj5D
	kMB/r0e5mLMsVJFojoN5m2naFMljHMXIStZ2a7QvQ8OYqR+v+y/cdR6h22nPKjLoICVuuy
	UWHyH0xVdR7UahWyXtr7crqVWKEnCMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757346763; a=rsa-sha256;
	cv=none;
	b=Qd2AqGtHSJeHl34I059LYsVfHQuz2MwXnJuIheaHfvnGnrRGeMg6Sngpn9U9C+juJ4j4yb
	3tRVJzqTMInX4jazKU9Y8n6OY0WdfxF+4zYGYA7Jctw5mtYli6TNFCwhYUldomIetAq6OB
	iRvtduJ94H6IdMRmLSQNq1eME/ifudM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sr9+jP0s;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01D94449A9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62AFC4CEFA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757346761;
	bh=Z6ZSBWyQkeV+NS1WSjTzf1xD/8S+KA+46oz8uElHsjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sr9+jP0suanwPGMyItZl9FbFyTsr0mkni1Ik1aZ+ONwRqQFyhdHNwCMxCVdrS8hgs
	 WIsT8tFNIY8uGFRuSPDgUYyrX/FlhPTm4F4jC6kPGGeM8wMhEbxfn7oC9aFk1gA3Bb
	 01/smlvyJUec6fehwtroYKX7jJCyzTncPnE90XvfFNrGw21QgrMxBC11Ow+iOziq/o
	 vEWeUrTvYbFP4T+87NLMjr45V2EvU0kpAqPEJlA2YRUdnpQeewm0V0cFrUOatnDOHd
	 1xpRSUopGdBHamxbiFyfdKZ/YFsXhpPh3Y5vAgAYrWcYjx6Q+UBJf3uauyvLOR+JXH
	 rmuY8waLRzWlA==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60504bf8so44194297b3.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:52:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWIEHRyYWznwAcCXz/O/JOYtOk214oot0RxPbNF1u97npH7ZEIdvYBXydoDDzGul3ftd3PYkkUhog==@kvack.org
X-Gm-Message-State: AOJu0YztKxgIPH8t2sPsiXb4EaxD0m/XoNtr59mGlnxtP1ejpcVLq7KG
	f4da/VKVb2+YDS+QU8IjwA+ItgUWc0TtrCSlw49H8ELJeGlZZtTULc1GPD3p1UtilIIi8hosnKC
	0Y7eqSGX5Qurfg2sGhBTge7a/WOxYahgBcz+LHadW8w==
X-Google-Smtp-Source: AGHT+IE+czKcfRqn73StU49ccuZ+KPlPuaehd10MsiijFtK4zhn7X/Pa1jxXn1LmgfTA8Ey3TB9FcE4cxfU/Fscwku8=
X-Received: by 2002:a53:b115:0:b0:5f3:316d:1ced with SMTP id
 956f58d0204a3-610232fec87mr4767627d50.12.1757346761101; Mon, 08 Sep 2025
 08:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-2-ryncsn@gmail.com>
 <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv> <CACePvbXi3Avsic62fMdhLaDfiq4LS_t8-wbm9yQnEkScoxYO-g@mail.gmail.com>
 <aL7xoiTacg0vCLjz@MiWiFi-R3L-srv>
In-Reply-To: <aL7xoiTacg0vCLjz@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 8 Sep 2025 08:52:29 -0700
X-Gmail-Original-Message-ID: <CACePvbV1t_mUzKaOa+27hGiK4qn-ARS0jzx5UKWa6GQ9bPxanQ@mail.gmail.com>
X-Gm-Features: Ac12FXxMRmlzF-feQnc7O21Fg-EvAA3SACAP6T4MTNnAZbQbEyXrvO-mPI3sHqc
Message-ID: <CACePvbV1t_mUzKaOa+27hGiK4qn-ARS0jzx5UKWa6GQ9bPxanQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
To: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 294D04000E
X-Stat-Signature: q9whs99ee6pr5z1gcbeuohyrqw85x6co
X-Rspam-User: 
X-HE-Tag: 1757346762-496739
X-HE-Meta: U2FsdGVkX1/x2Fk0anFZg8krF/kP9Fhw6VCiWTb3K3Xyp+RlsyYaunQ7BSlypk0dNJRjnBilBT5ueONXOGvxKF3MqaZtTBE9VVBRbNrEgazZJl0ejV5d8X6fo1ZHORB3ImPks8Ka+7GilrfpCXSk7ZZFd3Pfh/4roa7gg1hCb07TR0iFiIw5MybTbsXAJg273rbeJuYxb84CNySi5sbolrAMhhw+YbWLpy+P0IDybye3/QcmPJamKA5j8lBhUEFRMyHoBnggh6qFNtmQyF1tqjWEfqhGAByjQPNWBnQqTCZYNk0o5L5crpKDL9R5Bl2WsoZtZ6rMhsAJaFHYUMrOMSUh3hTqpr0Z4xE7dzh3+klyAfPsu3ovSoPKG5q28v94z0+v+TWWIO2jpruvTwxBsVXLS0UqqFraXQGdbBEFIiNz/wnntlCQUVnCble6BRM+DkEg+0bh01dk41CcV8vMOuDNGP7YV2a0p9H4Pe/a3yWwOy1VHsRUzSJj9YSETvhiowDJgkNdLf8tF+fOg/DxZhWBWh/vgzDHJ2Pn97tCu8JjuWjvJrJfjTggLwhnup3wKOQH1IBlGW73IwNy0RrOJz4tQB4FG7UrVnmGPLYHf++uS8+ul7PM3uiCJUSG8RwVz+j+un8XFCiOOvkozh1EC0Y5cXjnIA36/B4i14+fULNcf165EqnT252v9gU4YoKbcnKcbiOLKzUR05tHDtl860L29SDKYXp/2iU6JrRrDe7Cpt89Gm0T++cWnThFttm2aVc+vfsQKl/luESFkGYp0whyrTLKwcd3up3ALYEJQ1H5D83znjd0DCTdUb1PHi71GFe6HRleVrpqY5pyk9FI0ovB1nFWKDIF+jwIPA0tJ4v6C1Lm679Q0vBf2/UUvLAhq9QZyyZi5I8OS09sHuoQPDDkqykjZFjlNQpuE/tzmY0RothIzlN6wZhyvLrsfNp9Y9IF/jZ0ZaO944pAh5r
 nl/nvHBE
 SCGZ1d1Ld2l21hp6HOUYE/TEGVZFqgGofdCwdIH5S7z/ToxHby9WOzADDKzEAcaglUaPJ+CP+mZuskrLxL0ldtrxwQrVdQneE7bEhaoAqL0VTDWmCwkx7XptChBINMY/9kEvziRcuqkBJylVsUER2cBlZZgnSMiQC5fEPbLJSdGcmk9J5RRypuTzhoPbU1OBueCcM7kYRan3w4Gh7oM+faNcnqzAB3prLDbv7FFENQ8bvo5xTWP8mLKXjCIIj3in84vncV4kyVDq43xaM+L0JDqvtdwKxdi10GzmkrDLL7dkoyOgymJxg8TmZ0133zkfADZkyeO7hbp8w9Am2hpn/zYtjdMAYnQmvPJUcErPed0+vuo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 8:09=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> > I think that is all normal and did not violate the kernel rules. When
> > I include Kairui's patch in my swap allocator series. The same thing
> > happened there on Kairui's patch. In the end the git will know enough
> > who is the real author, because those patches are  outputted by git
> > anyway.
>
> Hmm, maybe git doesn't work like that. I applied this patch via git am,
> I got this on my local branch. The 2nd 'From' become part of commit log.
>

In that case, Kairui needs to fix his sendmail config.

Maybe as you suggested, remove his own From: line  in this case. I
don't recall needing such a special git-send-mail config. Maybe
Kairui's smtp server is different.

BTW, I definitely know that Google's smtp server does not work well
with "b4 send --reflect".  Google SMTP is like: "Oh, I see you might
want to CC these people, because you include them in your inner
envelope CC list. let me do a CC for you on the outer envelope as
well". It defeats the purpose of "b4 send --reflect", which is a dry
run. I still recall the horror on my poor colleague's face when I
convinced him to try out "b4 send --reflect", which should be safe,
but the email actually sent out to the full list. I should file a bug
for that.

Chris

> commit 337b3cd6c0ffad355df8851414e8aa5be052f4cb (HEAD -> kasan-v3)
> Author: Kairui Song <kasong@tencent.com>
> Date:   Sat Sep 6 03:13:43 2025 +0800
>
>     docs/mm: add document for swap table
>
>     From: Chris Li <chrisl@kernel.org>
>
>     Swap table is the new swap cache.
>
>     Signed-off-by: Chris Li <chrisl@kernel.org>
>     Signed-off-by: Kairui Song <kasong@tencent.com>
>

