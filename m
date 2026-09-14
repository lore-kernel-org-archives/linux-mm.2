Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97937C88E6A
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682D66B0088; Mon, 14 Sep 2026 05:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634586B008C; Mon, 14 Sep 2026 05:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522156B0092; Mon, 14 Sep 2026 05:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290746B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:26:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 663131C0C66
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:26:26 +0000 (UTC)
X-FDA: 85211837172.26.F37A99D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7990B180009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:26:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j29ORYVN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789377984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nr8zTPRJR4XCNAzMSPXRD1SAJbdWdrTlMg9PBTC1Fg=;
	b=3KvqDu2B3xZ7eTN7mNGE47fpoGrdsrUOut/Y3o8pAQR4n1cMQxWhH63HrvslHqwaGE3KUf
	cGsSNpBiohn4eva3EkvuIJCrcnXdsRZN4kBR+RZQmJIS44kBebUJa55wnIueKOisLaY8G6
	/68Rj2QMNkSlXqiWimdKNyR3zZAxz10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789377984;
	b=JUvAKzPBJSTtEMmr+xL2BaTfFc/6xpCl/ylHvoqE3fwUwMNsNzC9mpGQp2V9ky1549R0Y/
	6gxNMP2NKmnH+QfJMC3+y0gJWxZuZNK6nx6cZLnG+9qjEO+j3ExsdiIm1765Ev9Rw6kXkU
	iCUTYukPKahs4VTspCQOSW0d2cnvuQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j29ORYVN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73FCD42B61
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A831F0089A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377983;
	bh=7nr8zTPRJR4XCNAzMSPXRD1SAJbdWdrTlMg9PBTC1Fg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j29ORYVNgYfPyoi1mUmgmGMXRptKlY2PArjQNYQKeL9SIIYLNoHlrhq3OlOTn2I1y
	 rHGz+U3aCycNndYevETtnc9I1aR0YqmXhqgUSCRNzVB3Ey18ksVreDiajzRLr96vbb
	 6akXDHwObu5CBEP/Yp0dOSp1q6taxQ4S9zWtC/PxTNdwyEdXb5hTURVeoAH3VyCS/y
	 FcDIoY9rpBNa/bjjIjISj23IyEpFWEjw+9CrTcgvxAZ991X/zXaVhYMH05vQeaLN5r
	 zP7zXeUU4VlA75UqBvXemetxOldkiQnJ/By/Vh3i0jesmX/olKXyGlLax2DnKAoBav
	 lo7b7/Nb7njVA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93a10f9a2easo134224085a.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:26:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwN90KF+Sgd2wlyuwJmxo9eYPvSF5ZshJ4P5GdkvDYTJ4V927NUDAzgQPCIYXj9SOuVqB7qRdHsxw==@kvack.org
X-Gm-Message-State: AFuF++kd1yzKNuem+f5X0B3C4bMTTkfAJMKw6aOVd9GAnaq+KLZdCm6X
	oVAxUCevtEpbLQaHdEssznBR9X9Q3ti2Rfi0FvvMZhPzpvp9AtTdzpwQW6TlWuXbrVlID+pQPL8
	zEX+ue6urL9dHaKGdGKSOd52sbnGjMfI=
X-Received: by 2002:a05:620a:2708:b0:93a:133a:310b with SMTP id
 af79cd13be357-93a1870eb4amr541774985a.26.1789377982735; Mon, 14 Sep 2026
 02:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7DdF_fi_MserE_P_AbKR23mrqPLZ-VD71eXH6iv1ncdzQ@mail.gmail.com>
 <b5263014-23b7-4e8c-9bd9-18198409d0f1@linux.alibaba.com> <CAMgjq7CcPfOnAjh1EVRu8-YtCaWjCfx=07Q4RLxF1yV-bj2NPg@mail.gmail.com>
In-Reply-To: <CAMgjq7CcPfOnAjh1EVRu8-YtCaWjCfx=07Q4RLxF1yV-bj2NPg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 17:26:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLdOmwsOum8waP8MGSZX=MbuJfjXmR-NRoUOmND5+Zhg@mail.gmail.com>
X-Gm-Features: AcwNN1VghK2xzQNbqn1Q95Fi6KZsPMwLyabikwvKm465uZ60Jog_NueleFhaFLk
Message-ID: <CAGsJ_4zLdOmwsOum8waP8MGSZX=MbuJfjXmR-NRoUOmND5+Zhg@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: mglru: clear the reference counter for
 rejected folios
To: Kairui Song <ryncsn@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	ridong.chen@linux.dev, baoquan.he@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7990B180009
X-Stat-Signature: 8u86q6eoyofjek5gyrc5iqe8f9e9hgpg
X-HE-Tag: 1789377984-812485
X-HE-Meta: U2FsdGVkX18mPTkpaY6vUCj4/L4WvUH4oLU0/hQFsspXEOxTOOyzg/yHONbYFZhPd7Xi2O5Y0LukOPpVYlfepMnq2hWiyCvgTtMlR+YLfsc0u4tWa7sM/FVA414vI0AJRbGADsgEgYZorAY5Rp8xj2HN1LXIT0D8wmvY1sNyxqKIkBmlP7yreJXm+2XB0t0G5oJiAzGKh11JOIyi3pV2d+VY8Cbe+KZmMWT0/iwapW1pz8xClyruDgrgIY4xzs/+QXIWspTbqXrrGw3gpN3e0dZKOxayfu8DeJkAorWvJwmKCg6NpdRCuGh3x8USPisY0oyAQiyI7y9TaSqHSnjDG3MTm73gVWBEfiVprwZgcq3d1cqUrUUUzM66h4nA8Fm0bCs6AIXwlewhgQXb9UKkGmtJX7IdWTrn29RSd6LXG8iii04Y2qAPAJ83+BxbVAJglvUlnT9vuon48s2QuHicC5evWt83fujxD13GgELB/aR0lBDxOYPXcd0BwlCaEpJOm4V7SnVJD2mVX/UX+Bbng/kiuTXP1Q4Hz7G+XJ9lDM35W4OfofXUkR92jgK7WZxz7MQzktkwZ/QNbaxYDq0+Dle2En1Uisug+Ki9kh/AhKGG1MOTVZmRKMIFpnO/jRW4UM5tFDfqNypRIYOJCbPUlGAFZ0bBaiiB1uldIaySX3p2be+VrwpMfBs2XAeVzEIIv8RySdQa3lL5y2jF58WOv6pD8PIyrKKTKQ5SPmVtNVxKvgUQ6FbbPxY9n14Bv6vqqhA4ZswBnM3Ga5jVTphOZaZdZBQkSSowcXTNcoUMdMKsuxG1iXGeDu+f3V0r2VoSW6bB0BHXoqVM6FnlgwXnBAojeZAt/HWsoRK5vzSMSX4dfEXaNx9NbYSlFQkiUFX/c5cqLj9+QSGUGyGTY6xonf1UGX0x4mOLwnS54S0wZzZMWOkEciWv8DHv81NfhIEr67vj9AJuQ6aS1CgzHny
 M4nTB1vm
 8rC2Ey7x0X0+FiujbY+4FL8vqtt0BzqbAe+OwlbpuXbLDnhxeqe6yp5GTXr8hk4f/eZmCGQAnbH8MXJKqc69V82PgM4APXYmvH77neteKblJBvHM5UU49A39ckZfmxKX+UGTxpA8dnP3RnWAnJRWC851e/m33XYBkdd8yjdm+RrdHL/AoM5B1hOtgzzaeHoZqQnN7DBmyG2ZhGOEDW8tlow6wv+EbuTzP8v7bsZVq0AIQ4igqePQ0DGfMpwag4LzFrtju5kjyLl5En3Won9SCZEegnIfXF/6S+Q8llPR/OVukvSPD0z+Pul52Lm04KRnOM3moFukV8+buYTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 4:51=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
[...]
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c2eb8fa9d5e5..a1ead7c61054 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5071,10 +5071,13 @@ static int evict_folios(unsigned long
> > nr_to_scan, struct lruvec *lruvec,
> >                          continue;
> >                  }
> >
> > -               /* See the comments on LRU_REFS_FLAGS */
> > +               /*
> > +                * See the comments on LRU_REFS_FLAGS.
> > +                *
> > +                * The rejected folios are never added to the oldest
> > generation,
> > +                * so this effectively promotes them by at least one
> > generation.
> > +                */
>
> It looks good to me, thanks!

+1, with the above change,

Reviewed-by: Barry Song <baohua@kernel.org>

