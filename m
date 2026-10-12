Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27A4CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE0B6B008C; Mon, 12 Oct 2026 09:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DFF6B0092; Mon, 12 Oct 2026 09:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CAF6B0095; Mon, 12 Oct 2026 09:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0486B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:22:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E3FB160E16
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:22:12 +0000 (UTC)
X-FDA: 85314037704.03.EBC7DF7
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 780E318000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:22:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nYM0wBZl;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HlPO4+kzCqKp8f0EIk+HoKpe7ab+E0eciRhKqESWyI=;
	b=4cXjEvngL10WcJIvhssZh8+rAHn8L3ChVj6YCtT81K3rsR4xFrBSeYnkGVWXDFi7+6KV5N
	XdnrMAICyd/IJwI65B5uYl+jYuz4+4/18rBjsBVmpJJM+IySF3ygOMxVhJpYrrMc1AcEL0
	6QwFitIKEVf4ggSpe+JEfSi7iKxzkzA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791811330;
	b=Q5oT7oyGdKca7LbmcLR30wjJ3F1xMb5ZTnmgVr3RA052DqVoDcWWX9jITkswAFGtx+gDXF
	8ver/qSGmOQwUdZ48PHU1ujPjUM3KejU6O6bfLCo+GF4VCAY/nVDsXRet656mvEC9eE0zj
	d3n8emb0sQvt6/uybuhtUod2G6srEb0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nYM0wBZl;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6793ff3d53dso1260823d50.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:22:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791811329; cv=none;
        d=google.com; s=arc-20260327;
        b=ij3ahAhDZvJk+YbhRhgNmNXqlPXi7qF/YVKoxjaVS601BadrRBjzqUovm9DGHhhD2s
         fyzp5fDmcTsn6/Z02tYBx5qEFirdiWl0pNzyFHpRxoootuKN4JG5CsLOS+gXDqrG05SF
         y6usCctBpq9mR5uAmCylws3GhfJjX0y/vIQ4jrq3c5SUwp5dS1DHYvHKUGfKWTq5b7Bf
         /jCeAMrKf2FGUDoeXEuu2S+WbJpQW1nY6ujf3QUGCw2/gGWS6gwZvWyhxTRs2p/iU7np
         Irm7DjFF3YMTXwe+18vY/W+IW21OXAnZXIYRLUVdOvlQPotBldGZWaZuoHXv21fsPG2k
         XaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/HlPO4+kzCqKp8f0EIk+HoKpe7ab+E0eciRhKqESWyI=;
        fh=GIr2hC2i+tEXUEPN8z2z+12rMxUazRFpHlB+VeWQ+HI=;
        b=RiBogb+vZPEAZJxC8kbgNCpLjbDnSQ9gMaHX9awEm3uWN/9FrycigwlplTkY6pFjpC
         gdbpzfTG6zWbGYgqf55YF90D9kJ/KFE+Vm6l6lH+uw+no+IyC4QEQG0H1pjeuraVyxNe
         ZZZJNdAnMIA7o666V2MR8O1DW6xVxvQhR6P7qOTbXh5K/+cVH0Bci2ccUT/DxqtshIJd
         Ug9kwr+xmAdAiwVisC4xxnea4hf0ZKMy78CCVYIiBKqB05+JSUoFXwUGdprmTq37APAa
         +8g3cyl+Tb8Y7gDNOQ46w+qxdVmmJqTkyC6l/OesFBeLCWv1tqdx2FHen7TUjBJ8YhAz
         /LSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791811329; x=1792416129; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/HlPO4+kzCqKp8f0EIk+HoKpe7ab+E0eciRhKqESWyI=;
        b=nYM0wBZl1d+4qAQ2VJ+Rx0hc8x3gFfVKV2trWY4gLh5tNb8pGMb14m7SPKk/kVGHF9
         qFJZX2TACR5Ur4X6yYDDlm0G7wHIc7BeVYeh1GkCADjs6toN9EHlGIXBu6GiDhwv5/+s
         KyzhnxhnZ4EGGNCTVzdfPSXPjEgPVP6mghRJNaQTu+obw+lOUCJxIBf7vGJYEh27JcPi
         0ajSrvli+4BsY6gVxrM/tjJ8ZA/ew8LD4I3qTIjJcmoYK/cqLX33AS819fzsKXSpF5DU
         fKjxK/nZX/s2nTI4yJ3WxNz1D2nIlUoX9SAZxT2VDGLd5sYiLgvYuVkemY+hn5vQlXGu
         0u2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791811329; x=1792416129;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/HlPO4+kzCqKp8f0EIk+HoKpe7ab+E0eciRhKqESWyI=;
        b=TeH+T1qUoaiCnH6x41lZAYf+EXhPXNE8WGMuB3tp07hbgHzANMRq8DzlJBpkPvxM+C
         Uh2jPfWMdNLHak9H6P2SK1nzYubx2layPsPi3T37JAzaOzn/eOcjeqCiGgVJfqSEtL5E
         duAL40CI+ikyYmIr/r80J6dvQoJNa4Lq6wiJv1M8t3GjV+xO17LFrDubVYnujuoP+AeK
         sOonkSZl3rc9F1IlgyPWOT4BXz5UPAWBr+aMhavwD4n8xC4IalltGFHy2gMV0/U9f9Co
         FKK7HAV/cc8BqgdWLUlVJaFFOTOfSKYrz75cSBW47IvNzErhvU5o/PAmXJZCmMG1lZPG
         SHgw==
X-Forwarded-Encrypted: i=1; AKwUvBzCtJt4HviKGgYoOr65ksMj4zUTJi19Ml/LAmBhCtStKcoNNSPtwKDMHVX7jRjAO5rpk6lchyREfw==@kvack.org
X-Gm-Message-State: AFq9FYKL4iThReqYeLoQHhR0mRlg0cpq/6CD8uqaI7J6CDQKR3qX5WaL
	gbj1f+jmtVABkF5NXpxG0/VMPUfDrwEtR26R5vwH9pjpJsl5FzTIY7IFMGm2IaNDICQDO4L53Vo
	+SvkDEm8cYlG7fBdsU/6UP1yWEmUE6tk=
X-Gm-Gg: AYBFou3A+k6FDfAAU5ml0CCN0nMw1QMhMNAdvrzaJA1FyoaxIZbsnwmHEs8f0goh7rm
	XU2HFJVRhOo/ZP/2+VXipes03s3lyKpTQuSEDZdews+WN+COq2OvuSrrcuBqM14/77bqcIP7uqQ
	lEONnbEUu7i3znXha7W8NN2qfB8xSrFifS/HxhoSkZB2//2nim0Mc3JG4Yd/ecMgVqQmisXZWyQ
	DrpgQbXL+OZa3ZDBvNqnfkLlqpQ7HpJ3je6/pXe/YQ0I9tGR2MILQEENwPoavYXduu/jjsZFwRV
	g2em4RYdjBQl+gHZG3moR6+sVohHR18R7eS8fOhiZ4o61NFKxImMthCTZ3ZeZfFd4u4jq+P08kJ
	9MZ2KSyyf
X-Received: by 2002:a05:690e:144b:b0:679:4176:47e4 with SMTP id
 956f58d0204a3-67941764aa2mr2893977d50.99.1791811329461; Mon, 12 Oct 2026
 06:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20261011014841.405327-1-ekffu200098@gmail.com> <5895ceec-df6a-4604-a7b9-8138212d786f@kernel.org>
In-Reply-To: <5895ceec-df6a-4604-a7b9-8138212d786f@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 12 Oct 2026 22:21:58 +0900
X-Gm-Features: AclHuK8yhaoSQLFeVsXDYwnpJIxtJKUApBovJsFIS6aaOqTwgiZl1CWCxDOUgiA
Message-ID: <CABFDxMH_TdG=txq7ipdsfkz0CCoyhD68Mp2-vVNnuFJyBUDRyQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, 
	linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 780E318000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6q4dyiti5z8xx5dqzx959p74dh3ero6d
X-HE-Tag: 1791811330-256507
X-HE-Meta: U2FsdGVkX19bk0k6LZgrodr1Ck7gBl8y+FcobKDQDIqeUpMbVuE0K7Ijm/LsXCWYA7KaDHBCmq/Lc5xPoz9pzFr7fQXmqVEnoOkNbBre0/u4dm5HBDLksS3bi0YXzikJ1wYY1OrLskcVLxS67xxfV+4zigT/C4ChDB4IBYAUK78iRp/9EltL+0pUoIrJfCcNwm32qkNKyro+h1X/KGWoUZqUTmrY8dRrb1xSqHcPAkuPz2VPGob0qTHZFf8p7fyhK7jqQ6GDG4WAwcmxn7kP7aBZyj+lw+wWqLPVGdqilfoZOutV14FVSjKddkZWXq6btxbhZLl24na/tducQc9EBCr8Y+It7ZKMYrhYyXHSjeLDRWl4BxCt2F83ilGcCpirG3JGZoxbY5x5Pi6Jd823FsZ4OH2wsYRmeL0CiHnM7xq6AAD6CofgkWtlJfInYLtoWWBwxGjUhyEMN7qRmcg/RdgDYcwtAT8AqAokwpb6r9keMAeCWYFDsl3Xs9yffXScwnyOEgoJah9HezBYWH/g7L/UF0ZOP292iK+5piXD+xcX78lVzPzSrKqA55ZsatxTGbkpa2OzOg8Lvl/BccknqcFDB2H7wpGNJHMljcl13OtArsoxrMCZSnDUxMDdI0Txzp2kVpsgmUMKZLGnZvUmw39KdZAueTqcoMY1w2omXldSpDL8qXDENVKC6pFDqURv1s9vWyE9ofbghRtqANIZsOEsJmG6c1Y4Pje7/FLgWFPDy3jQluSKvEHB2BQ22qcQZ4wMK2CJYFXRL9InN6hZXU7RINrxfP/yAlfr067yJeowW444e32J8bfVoSDB1WY1onjxuCcbl5mSJIXjoer6wZjUxbb8ZB+yRldHyGyMA3G4aTb1PKEQOo8/eGgyBXCMmNbW8W6A4Nm+aZqoMTc6DTE5oNb/NUs5CxTN1PcOvPRPYzPtxmCk06vDMLfH179UkbsfNE91iRXqX4dHniR
 VP3vEO3G
 B6vCI8Ug1qoNDjm27po1l8Qm0dg4z7KTzEO1ST+gS/k63QrMNANoPguH/Irl6I/wj6DUm14UKIj7K/HKxmB+vkdNllcxiHTrB1wIjJvv4b96ct8AHaGhUfSodesDMkrvNGB4/m4cN7m95sedgLTsPfJH4YGeITfEPiqUmYup79hZgXi5FXrYY8XEX+/N1JNGKA/VqEvKm1BWkcsoaLUwnhwpzy83tSzK3GjgK9z8y441YsuVi5j499apyyhMLrO4LMf2SWeXcsXhRx7u5Y3EHWBr6170+N7eNJ4dc+uz7DFqvb2Qh5c4MZaz/UTfBAN0HZCdTNrrsGUBtg/0RbLA30LJG7Iu4iqToMpWq9oB0vfXKPu2Z9YxdxpmQ0ljM18KkWcrAh6o/OCk6ft6noVT/WgDkSPF8wpI6EA0J5HMA4U5rCDJYYxD2KILbZdWztoKlR0uzDMc4XhRcKGaPeT8hgOe6vNAeSKhc1X/fa1mHMvUuDXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Vlastimil

2026=EB=85=84 10=EC=9B=94 12=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 5:23, =
Vlastimil Babka (SUSE) <vbabka@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On 10/11/26 03:48, Sang-Heon Jeon wrote:
> > setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
> > setup_slub_min_order() has no such clamp.
> >
> > The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
> > at once, so slab_min_order above it makes no sense.
> >
> > If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
> > boot or invoke undefined behavior in order_objects().
> >
> > So clamp slab_min_order to MAX_PAGE_ORDER as well.
> >
> > Fixes: 81819f0fc828 ("SLUB core")
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> Hi,
>
> this is effectively part of my bigger refactor here:
>
> https://lore.kernel.org/linux-mm/20260923-slub_tiny_rework-v1-1-a0e66d536=
eb5@kernel.org/

Thanks for sharing the patchset. Then I'll happily drop this patch and
look forward to it :)

> Thanks,
> Vlastimil
>
> > ---
> > Changes from v1 [1]
> > - Change fixes tag to 81819f0fc828 ("SLUB core")
> > - Remove stable tag
> >
> > [1] https://lore.kernel.org/all/20261007163403.1643768-1-ekffu200098@gm=
ail.com/#t
> > ---
> >  mm/slub.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 1559cbace469..8400df7c222e 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char=
 *str, const struct kernel_para
> >       if (ret)
> >               return ret;
> >
> > +     slub_min_order =3D min_t(unsigned int, slub_min_order, MAX_PAGE_O=
RDER);
> > +
> >       if (slub_min_order > slub_max_order)
> >               slub_max_order =3D slub_min_order;
> >
> >
> > base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0
>

Best regards,
Sang-Heon Jeon

