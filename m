Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B69C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E396B00A2; Mon, 27 Jul 2026 13:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297976B00A3; Mon, 27 Jul 2026 13:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1891A6B00A5; Mon, 27 Jul 2026 13:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D88036B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:05:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63E641A015A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:05:48 +0000 (UTC)
X-FDA: 85035183576.25.B56A8D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C9BC1C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:05:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5J5z06d;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxnKWGgv3kgSGpcOLq+j0ydLE+o+ovzFIuBVVmOhisE=;
	b=VxkhUyiNrN9N6dHBszq4DBxk7oa3gTtr+AV/GBKWPE2wkFq/MASa0D2GfScnSp0zMp3J1D
	lYYGPSnzhAZ2cBTFOo/7vW+3uJA/Yvpisya3CvU1srADj477Kh1tqROJJqCfoN1Ln0bH3v
	xpZBBym8H4ZFI9nHQwdmAMcu9cNtlnI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5J5z06d;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785171946;
	b=Qxahoel/RQJASreLikY4WCXDn6Yjw2a9jK5CGsh8WvvLA5zrLi3I53ZrRuwhF+0w5/VkJ8
	SYeSVPqDqoKtsZt5oAqOQLd2sEJBbJmbUujZvMXssP8OYDHFiGi9bC97aMnRl4fVu30+PN
	XWzXgNekh5g8vYI0lT+eljgPpZMk2Yo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C1A439F0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCDC1F00AC4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785171945;
	bh=TxnKWGgv3kgSGpcOLq+j0ydLE+o+ovzFIuBVVmOhisE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A5J5z06d+ldD+/vVwpkfraF8fr6YN14SfDoyIifZV7wAu3Y0A5oHKfmQchRpNuz0R
	 XzWjy51xjTv0zra5jT0YR5XOEK/+qDyxFFk9RC2+fHRiiW+qF3Rjb+7YXUghN7KYZC
	 HdgVlCXqVfViTpplqUKG+KfkKgW+07NczS22VAmUSn2e5Hq+Ou8dO1GLyshGTmx7N0
	 liHc53+1rVh0XSTXaP0SWA2y80Rri4VIDb2th9M1/wO2oLwL4lx32kCBh6XMibYdkN
	 ggPewZmj5hPEQS/O8yA5PaPUz6NlG3rPWtl05h5nxY8Kf/m+RvemnyT6exWFFX8tph
	 9oUZtLcd1xT/Q==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so337192866b.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr35cFm4uia4BR7PZYRuQ0CznTErAxoI4XrEIik1rkOdm3VbEbwReF0rlS/NrFgqKgZw5pj0Uik7A==@kvack.org
X-Gm-Message-State: AOJu0YwkmkBZ/o/JVa7LRDII05/tWFnajAmCsM6+pu+lybIq8IlqBMap
	oE05y+a7SUNMWt/YPWMOcNPuNLhMKfJ/pLfWMLrI4vo4eFT6nl1qhdCeFlNah/d+HOGnDC+EeYs
	dtbLxCDyhb25/Y4jB31N3y08iMYJkNhs=
X-Received: by 2002:a17:907:983:b0:c15:f376:9642 with SMTP id
 a640c23a62f3a-c1f1f119245mr387752466b.65.1785171943901; Mon, 27 Jul 2026
 10:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
In-Reply-To: <20260727143618.1582318-4-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Jul 2026 10:05:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
X-Gm-Features: AUfX_mymjXAGe8WFZWwKwVyHcv1lhqsWQChGfs9bdQu1IS7341exKkVzBFQ0Cg0
Message-ID: <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C9BC1C000A
X-Stat-Signature: taha6w1fpb4bmsoqjrj6qw7ajnb5xpux
X-HE-Tag: 1785171946-813140
X-HE-Meta: U2FsdGVkX187Oez/XoWfiJqk5GKISbs9GWORPRCOEXEJp0wJLy1UfxIrTE+B/7oFvz3ppxYjiMSB2uDeUjG2NNjtrVxvL6v3NYvsp3i7jwUHJ9KVxFP5x+RdehaGspkGSFrD916pZt1uMfy12GtsEyt/ye1ZhgAKQkKZ5HPY46qajy+pXMgJ8XvqxokyNFbjw6+f2ZDJvzAzOmxGlPilsy8lQozKMvEH3GKqghV1As5AMc2SgnZLhM/fQAzhz41yLlqBqEY0gS6y1iBvS7k81f6RhxMsD0t+DNPTfqmiuggbjeZPu0/pOUCryPjnZdxhx3X3/B6uHOCiKR3qYCEpoqISPZQuoA+Ryf6aVOiQR47Ur+IFQZHmKGL8R9hCByaNtOm+Bs2qEo2IEw5jVoK8ZcZG6LeidcsXEpKbFTZQ5FOCiC9thJS6zKZURGLZXF2Ie5o+HF5k8S7rSuUhbcXS3m/nOd+oFSGTmHRhxAkPSbBApOKLmoPYbQNYkowkbHMiuvrt64BQJvWpxTu2RasoVi2UnPj7jjGQuN17bfAAd0jXirdoyfxs5rscmaedVB/tlgc0EPghgfPVQjr9txAidaDT5/DRS/5Mu7N76ZkkikirVMZQTOubBLxbtdGbzAlBUuPiekrH5aWstIIxIbJVX2Vwh/SToakvVH/dlSr3JT+JDqiy2su4hXbZlda3deMpHNiUC9v2j+32aEVf1wvUeA+hO0J5TrnnLWeycdiYaxRnbNMxawX+e8BmHuAvRnqOkUpH5raYdWoA4Hn2P+ZYlVo/3sKHlF+YAcBjRly2efx69Bfh7h5Apck+QUP0bc5+4KqN1ictfx+YXV1gMw18ho2f2CNnP+P5yrvQAowiQ0T7+B2SLe2TCI6w9FQLOOi/zsM2W7hcdVWGesvzzxxlDHQFJoTBq8NYOxWTmPr6QwFiMIoI1fWG71W8A5KQTc/Hnb7+hqIJEshLgymBprw
 cyfCzibp
 PbBlN9fTC1md5BUU96wKMIIdWbGbcCP9pOb/WvetsO30h9WLpSMxW8PZt/TyVw/ev37wsnXJQ2GzUtgi6h0oVL9kDPOZ5w1uG+aDjxuLDH4NtzMZpNuvMQEu2kx7PX1Tps2lKInigZZrN55aXggoCrGgioMdEr/kBlEuxOFwbL+QYNAEfkRvzi8sel0NfVrdAxd53czGU7Ozhnurm1itH+GVaMmaGlfZwoNYJzsffDdKPgxq9LQPAGfAFzndr8Iavb6XFldmvPmDtMlJsAhWuLXobgmD0om8XGPhLrLo2GimlpMFm4jIIKoMxEu5UE4ZNu0fzbKU3wotvmfWIHTQClwOp+BUHndyxIFLQYvu3tb+GBI/u3XqyXr7UUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 7:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> zswap writeback decompresses an entry into a fresh swap cache folio and
> writes it back. The folio is cold by construction, yet it is left on the
> LRU for reclaim to find and free later, wasting a reclaim scan and keepin=
g
> cold memory resident longer than necessary.
>
> Allocate the folio off the LRU and drop it as soon as writeback completes=
:
> mark it PG_dropbehind so the swap dropbehind path frees it once writeback
> ends. Synchronous-IO devices complete writeback in this context, so there
> the folio is dropped inline instead.

Why does this need to be handled in zswap? Doesn't writeback from sync
devices still call folio_end_writeaback() and do the dropbehind
handling?

>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/zswap.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8163e6c5f76c..e37828e02938 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry *=
entry,
>         struct folio *folio;
>         struct mempolicy *mpol;
>         struct swap_info_struct *si;
> +       bool sync;
>         int ret =3D 0;
>
>         /* try to allocate swap cache folio */
> @@ -999,6 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry =
*entry,
>         if (!si)
>                 return -EEXIST;
>
> +       sync =3D data_race(si->flags & SWP_SYNCHRONOUS_IO);
> +
>         mpol =3D get_task_policy(current);
>         folio =3D __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), =
NULL, mpol,
>                                          NO_INTERLEAVE_INDEX);
> @@ -1013,7 +1016,6 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>          */
>         if (IS_ERR(folio))
>                 return PTR_ERR(folio);
> -       folio_add_lru(folio);
>
>         /*
>          * folio is locked, and the swapcache is now secured against
> @@ -1046,12 +1048,17 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
>         /* folio is up to date */
>         folio_mark_uptodate(folio);
>
> -       /* move it to the tail of the inactive list after end_writeback *=
/
> -       folio_set_reclaim(folio);
> +       if (!sync)
> +               folio_set_dropbehind(folio);
>
>         /* start writeback */
>         __swap_writepage(folio, NULL);
>
> +       if (sync) {
> +               swap_dropbehind_free_one_folio(folio);
> +               return 0;
> +       }
> +
>  out:
>         if (ret) {
>                 swap_cache_del_folio(folio);
> --
> 2.53.0-Meta
>

