Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84795C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 21:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BCD6B00D9; Sun, 20 Sep 2026 17:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC866B00DB; Sun, 20 Sep 2026 17:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB2C6B00DD; Sun, 20 Sep 2026 17:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3AD6B00D9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:31:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 675DAA04E5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:31:57 +0000 (UTC)
X-FDA: 85235438274.17.5627015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 73AF61C0009
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:31:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7AfkNrl;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789939915;
	b=MjvF9F+7rDazVwNHk5RGH3R44VZ9kV5g8BV9b525zdvTaLXUJrOqST8bxP6wRkA+sO8uk6
	PgHxUPYqoABJlO3ubwxaXqSpy2bHCRRnI/mas1Xiunn+BOKgO4I0DsgjCjuIBZjKci34pe
	J2ZkxCMCvtzYpvdX5M7BNhQTBeXS78g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7AfkNrl;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789939915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG+nFrp4upx7MCXw9OUfu9nQHcHxme4Gwg03BFoGo54=;
	b=VoFSqnhVz3CgGA0sA5zPEQ236FL7FvhWQNlQpE5pvEwyQVw0Vjbzco+4euhnnp2fJ0XniY
	viEmye+UEh0sDAECyjc7F6KeHPZuUs3/XlnY4wFHajmLIDQ+hzlQNP7dlFOcC2W/1v8a55
	/pI0LMEzFFqpRFVxC8ZVoBgwENkFGWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4ED442E4F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866EB1F0089E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789939913;
	bh=bG+nFrp4upx7MCXw9OUfu9nQHcHxme4Gwg03BFoGo54=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c7AfkNrlXZ6qmN08qHKoCJ3kpb2ZNHolItZA0w3/vupQRThu1anBLBrqM5EF0w9j0
	 EzEZihVRTFAJmvedJDp9U2WYM41/5YUZiiWeGCRJgIiu35AcW2aMOXXP4v4ghEVocn
	 repLUfFmOjkBsW7sgNUDFcYQXiyhAZYP5DCix4cNM/rJIQGQA6ECEVmslDkYqLTVJA
	 xdvSu2swHUrP/tGpi+E+4F0xJbsn/GOw890LcdaaGtwCrSdKbpdYfTBmGMJt3ylfO1
	 WkTaPhEsV1lsWtEpBfFDdgQFVnX1hFoOPAdnWp7gYIJVqJVZALWf99ffwTraLASEiI
	 0Hi48UQc3IUJQ==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910cc46c4so229438785a.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:31:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw2AOtR9JdX9PQukRLo1SuLFmaSlmwYNZ8t61Fb7riVf2MI0x9BT9jiOHakXwPvCod0Zg2zI/czEQ==@kvack.org
X-Gm-Message-State: AFuF++lTSIj85txtkiQNyGX6JpM15f3tAwU6iUccbrbbRgGq+Pi2Aj8s
	K510skWXqqIY6PrAnZJYbeixqZOosCetJY0cUEZbjDhPmi5iAU9sIWj6WrCWDtSe8n2ZaT5Aryu
	IX3kBWA349fVBAnpXlEVrL29Gn3WWCvA=
X-Received: by 2002:a05:620a:2623:b0:939:6dfa:48fc with SMTP id
 af79cd13be357-93bf576d80dmr705850085a.50.1789939912852; Sun, 20 Sep 2026
 14:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260920132519.3369946-1-ridong.chen@linux.dev>
In-Reply-To: <20260920132519.3369946-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 05:31:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zCADpQDqVj=BFipOztctBMBhw9Wcj+FLVcj-d8e=0bow@mail.gmail.com>
X-Gm-Features: AcwNN1WdPK0ioQD_l4qRGaReDWr4kKpyTe5y6jiJxFOoD9G2B2z4IDYPysX9xBg
Message-ID: <CAGsJ_4zCADpQDqVj=BFipOztctBMBhw9Wcj+FLVcj-d8e=0bow@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the
 LRU tail
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73AF61C0009
X-Stat-Signature: ujwygm9gfkwfy77uawndhnbhi8h33xxb
X-HE-Tag: 1789939915-432615
X-HE-Meta: U2FsdGVkX18mk0qx+16CZuDG00etBNLgpUZFYZ4DiwablYI8SSlqeNFdFsdKvfkuPe3MZadpdOy48PV1yYrxLsZvwzhNlNpsC0qmhtUloxw74y7hyc/S6G5wrHg+waD7XvxIHrQsBEnTLyjWjpWBDxL0aYcBG9fQtKD7+isEtdYFV+UPijUSyNOs/62qL1XLWboP2FHt1rh/fVRdtb0lHpGSxhq7mUBvIDidlEEuzp5Nw5uuYR2JqXRyhdpJuKusm7PnnyzdHqExGET59CHaNCkFhAw6qQ9PSR4Q4mXzTNgIqeDQXX1IfDfiCOxU8iDFvpA3ADYbKukE5RwV05ePRiVkSHYrXrdACl1o1osVhihtsz6EIe3rAyjJsOD5K9RsIOF62ryjrGza6cfKbeqHcpp77sGzVsRoDf4p+aTdsGtP6Cme4GUNXEzbm9lYV6kMxCgp3vsufBF0wPLWOn2+ELRUzZrgk9ym7wCBJGZzIij6cojzRs7dwkGAqD8x/RqwGcMU0UtZpxvdBHyUC4VEgYlA/5w0qnAOGeVBWaj0nuY+CsWzCtaCInDcOvnEg7rFOaDB4BJGIrRV/p6Wq2L99fKqCac14SjBsHHNmWRSSawPsGottv40mh0J5gkA5vcRsd98HK3vOgi9GKU1DeU0uAWQhPYZtNJUU3g4+FuBds571yukkCfupzE1lQzSABmbg/e+nCeIhg20cGa9XmMRVJ6IPr+VQDGUa9f4zabrl74DBqEaL8oR9fXNnT8tPg0UuFOnfmjpelsU6OoxO9yw4gul2AiExiavqvyjAJ6by05Rz047WO8bg1sEFnVEJMiMiJFSSRPsTulqMvNylANMZNgn9zDqUlya4/T+yMC7/oPRowct3MTYOxSGy5KxS+9FZ153dF2Ug7x+mXZ7YoFcfNOF9Qz6PYp3xJ5T+y5pXKCx30TRijI87BUUkglTpIMro0ye+Fqq+dEFeWDLn6S
 j3WsSHVU
 EhZfyu1Epg4Rwwokcq4jfWGwYNnY12niTYrbMPJNTBjkSAIMAmKDeLzvB4eA4DtyBeF90s57yusozVtUTKxTuM9VH9Jef6pUZHvmtWzzBdUhyhjsYjt8R7zEVEDQ1m68PV+wPQv3IuRsuwtB7p1CzBl6CnUPJdIjceAvYgjenD8VEuxFtp+9PXH1H932SoUt5wfRa8lr4mDXeaUl8CkBRR9DW2qeAqcqsqJzfkPIEI1GJfIVI5rXL8KyB6D3TCfk4idKH0bP1/XYNgUuQ9vyvQpV0ODEJdnjEr0TM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 9:25=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
[...]
>
>  mm/vmscan.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e200ce3eb056..91295070ca33 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *p=
gdat, int file,
>   *
>   * Note: The caller must not hold any lruvec lock.
>   */
> -static unsigned int move_folios_to_lru(struct list_head *list)
> +static unsigned int move_folios_to_lru(struct list_head *list, bool do_r=
otate)
>  {
>         int nr_pages, nr_moved =3D 0;
>         struct lruvec *lruvec =3D NULL;
> @@ -2018,7 +2018,19 @@ static unsigned int move_folios_to_lru(struct list=
_head *list)
>                         continue;
>                 }
>
> -               lruvec_add_folio(lruvec, folio);
> +               /*
> +                * Put clean, unreferenced and unpinned folios that may h=
ave
> +                * missed folio_rotate_reclaimable() at the tail to avoid
> +                * cold/hot inversion.
> +                */
> +               if (do_rotate && !folio_test_active(folio) && !folio_mapp=
ed(folio) &&
> +                   !folio_test_dirty(folio) && !folio_test_writeback(fol=
io) &&
> +                   !folio_test_referenced(folio) &&
> +                   folio_ref_count(folio) =3D=3D folio_expected_ref_coun=
t(folio))


I guess this is wrong. We hold an extra reference while isolating
the folio, so I think this should be:

`folio_ref_count(folio) =3D=3D folio_expected_ref_count(folio) + 1`

Am I missing something here?

Best Regards
Barry

