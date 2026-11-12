Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8DD60707B0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKfCprWW
Received: by kanga.kvack.org (Postfix)
	id 194C26B05C9; Thu, 12 Nov 2026 03:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146C66B05CD; Thu, 12 Nov 2026 03:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034E76B05CE; Thu, 12 Nov 2026 03:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D27156B05CD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:42:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CB741C0A21
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:11 +0000 (UTC)
X-FDA: 85425824862.09.75A08E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8647140003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKfCprWW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yX/snQhfs/qWZHLfhiGp0UkDR56azxtXVdV6DTHRemA=;
	b=n0wgv6rtZ1vhSrd6ZitXn7LOgUJ5lkNao0a3zvCYGCjFsWd2gOsCgZr3POQQx0vngzxrWf
	3wIlds+6C+bXkPYCbODRD+YdcZmt58u3xkRONg3qRw5fzLsgbfCP5HKqDQyenc+9fr1xat
	r/33MknTxS44S84vo+/hnuZ5bbLNfuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472929;
	b=yfbciuNY0W0SG1u9zcfRWzlfSZuc3Qf19/I5hqbdlPJX1f9qAauxXEnvkOCBh4in6mC2W1
	ArO/7mGKMs0+DjiEY8DcFk7v+uA2KA6AFLhUjUZUF2i1hNAirAbmoiDwkTDcgs0UAnL9zx
	r5NubcQiwA//La1qg54Mz+9pb7UhDTQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKfCprWW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C620A4135A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD38D1F00A09
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472928;
	bh=yX/snQhfs/qWZHLfhiGp0UkDR56azxtXVdV6DTHRemA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iKfCprWWielEa8qWCAy8ZrFTAc9sYEdp2d95dZ0fP3WMdBuinjhFwKaMeL1kcGwq5
	 kjBb7O2pDIFZI8HBnKfmJiy1UncxHnZgbqg+GnjCutPiaLw0x3h+s4d7JU/+PatuzJ
	 uzcxXSvU7PVH7J9Im2Q8BbhNVkiBXcPnPPodD5HKlQLMh7U9zlTdgIKzqTK7n28ADM
	 M3K9XuTWJeD2m1Jzd2hwY7DuJgUmidG4HGB9S2KRhkbLL6M3rCAG8i4EZyjnf2l8am
	 R7w+Yl3OQheaghiuYRRtcLfQ3f4dPIt5wky/FHmlA3wkSQcxZs8+FJTZkUof8SmWd8
	 MXqvpDS0XYsjA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f20b304c0so371876785a.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:42:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHii9wrsc3LPkiezFUSTObwfqu9bNRHCkQISrzaIbi2rJ0VTCtvtzajvHce5v1nVx1m7GH71l9K8A==@kvack.org
X-Gm-Message-State: APuU4Z9ONqcEq3av8XpOojoyRLHdjxAGC11UkHJpv3yNnZGw8ngu6u6r
	DZzTSgl9uCgk4CC0/yk1BS7SgitrqVIiVVfQeHE6SsYern0rCc0CQRSURd55mFpKgZH5/uIszby
	BppblMFGtHm0CSZ7b7RVo9NLMAPodgeM=
X-Received: by 2002:a05:620a:4629:b0:93e:c12c:9dd2 with SMTP id
 af79cd13be357-947b000dc62mr804392285a.82.1794472927557; Thu, 12 Nov 2026
 00:42:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112081928.3014946-1-ridong.chen@linux.dev> <avV52J2rD19cjM2J@KASONG-MC4>
In-Reply-To: <avV52J2rD19cjM2J@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 16:41:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
X-Gm-Features: AclHuK_9uCBjHclHvkB2UW2bzSTSpgTVr4bRNegOOsiNxjGaC7AtEWcvW_r0__E
Message-ID: <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
To: Kairui Song <ryncsn@gmail.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 9dh57tiksmzyxd77gk5q9g39m1m7o8jq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8647140003
X-Rspam-User: 
X-HE-Tag: 1794472929-933209
X-HE-Meta: U2FsdGVkX19/ZF50XWLIhwxk5IAjO2I9OKaxlbD+9YdyQIAPKiIlcT60E/taFk3XiZxlHaDk60K83U4chvb/zzo9KxIu8INxqV96MyOT8MOaMLrzT2TWk201KnaBII0eSLilJC9o+1AUhA6wAbiznnCaKDm+/IbR1s9Um/HFtf8kuHQ+9x3Fuonnyjm8MHrWfx3QaCfUQT9Uk7n0PorK0YDfRjjo6zJB190bkEbgeimxoVmdCdpokhNs35uAM7KsYpq1hiBggUndDxUeVEJH+cdX08TimYyLk/rayr6d3EJzN+IryoI/B9gqXF8swad25vh0AvtmZak1AnGWgLgWWokxki04D6/jtA1KdGnv97uQy01UrPXiI+g6NpGRmNx4tdDOHRimbVFJX7gmCf6RRCCO53ckETxIXmrtW6dclnJkzKHfvmeFubQY3cY8x5d68E8WQoGZljjl/EusN4TCCEOdk2NZnzV+KbroLsKrU/22eW83ua20S6VlsZr3S8Iixr0J7sbBladcv+4OVWLO5zPgBYnUbh6cRYEt1Ndjn4YhLMMMgmibQoBecIh88fahQiow3X2qKIuFCb8pO0VczMQz6r7HTAhUlX5EKHBay9c+otzL9xTFsgk3wjSLlA/pkVYFHnKHJ+fvp7CRvQsow6pX7B7++ifZW9E8QcHyIsJI2Luj6zjAFyoKrdBNbUBV4hieWquvZuhu4OQfQ/Q1h94fUaXsA3x85QtwSXM9SImpvO94AmBXcZaJTiYRZcDsjiAWvaB0R/oH6YR/dn3XbwMZyRCAxmeYhl5OJ2/09lxtR3ENQqZLEhArOKl60YffoJ0IY5Xj8LgsAdzKnXtGtYV9E5Y0E5EZTg/bpmzX/AVCyXFDtNJ8k4tUmae3iqPeTElT6NcwBPTmgk54OiHb8hL5UxdsOSgC5NJ+IDkQlrxKS2nbE2zQY9AN/o7bs7TeiW4yxdizmSt/MzJPFcR
 v/iJpUSm
 qZSIglOwoDw+pTdc95/VC1dos2IySEZBeBMu22OAu6VN0jGs+E9gKtMDwGrVLY2s3ptSXlXYB2AdiJqsDfmejvzO7PGz+GEiUglLOdq12xBV8HYJEK7p9oo/PZUj0Dpk81ekxlRXwPAHr8kAWBZKfKnAKbiXonzeXGZ08sNnNEPSWhMQ5UfVgg3wSRIePu/l3AfP2bl215RtInQ74ROQ6Z8iSPRgnDh7sHNxoYY14IBm+CvVzNC501lNXyau+uMt9bUo+f8rDMlqBrSQHmQAbxGVWdRJ3gR51QbcfGAEXsZ804zxaxnYZX5jMjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]
> >  mm/folio.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index ea3adb6a89d7..c412d9b398e4 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec, =
struct folio *folio)
> >       lruvec_del_folio(lruvec, folio);
> >       folio_clear_active(folio);
> >       folio_clear_referenced(folio);
> > -     lruvec_add_folio(lruvec, folio);
> > +     /*
> > +      * For MGLRU, lruvec_add_folio() places anon folios that are not =
in
> > +      * the swap cache into the second youngest generation, which is a=
n
> > +      * active one. Add the folio to the oldest generation instead, li=
ke
> > +      * lru_deactivate_file() does for clean folios.
> > +      */
> > +     if (lru_gen_enabled())
> > +             lruvec_add_folio_tail(lruvec, folio);
> > +     else
> > +             lruvec_add_folio(lruvec, folio);
>
> Hi Ridong,
>
> One question here, why MGLRU/CLRU have to use two different ways to
> add the folio back?  Will this cause over aggressive reclaim of the
> folio?

I guess that is because on mglru, that is lacing a way to add the folio to
the head of the oldest generation for anon folios while CLRU can do
that :-)

