Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB962C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C056B0088; Thu, 27 Aug 2026 13:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BF56B008C; Thu, 27 Aug 2026 13:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5856B0095; Thu, 27 Aug 2026 13:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD816B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:19:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD3DE4014F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:19:52 +0000 (UTC)
X-FDA: 85147711824.28.D518059
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF70A20007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:19:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dRW6naVH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787851190;
	b=dLP+UUMPAJJRRGgv22B3hnMt1+v5aRfkFWpErEoh2PeLxagS0JWx/x6IzCUH5H6k3Of53t
	T4MwaHhSBjidRYcsYyjFXeh9NGB5LY+OjeAF+MXTt671Hx5HNvjeiCfuYTeaphvu4nQ6Gp
	KHERAjTnAV+Z4UmXg3ZJMMJNzB0c8Lw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dRW6naVH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4O9IcA+RxZYf7jVM0MLLyxrl/FRrYRl3dstOxuMvo4w=;
	b=7GSdsj3nxceGXS8+RGL3bO+2NbhZLoMsT3VYY8XWoxIpxK3kTwvohIFYqsTO+DQAPAc35x
	Zgk99q692H6CEiN5lv8UL2Ud297o7prttHuBRGGEmaprAUhWUvZdR+rFZRugmIu6xb6Hni
	1pieKfEXzUWSbPj5//54eKofGqM/Zhk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c25344a8c6cso13141066b.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787851189; cv=none;
        d=google.com; s=arc-20260327;
        b=H0s3H8KG36vQQ6C67F8kUQcF8wjaD8QQ6R94t7sOz0w0Hk1YoK9x0AlGoQteapXEZr
         r/bUKrKWc9Pq4oSelIwhKUSvwtW6F37TtNRcJHDsSvagzrpCmx+IUnoyWBuS3ZFmGl50
         Kj5+VDdtsRnK+EoF6dl8A6SVL3JhSw1HF/cJ6rpDXRuuxFPiji9NFbA9T+6sRdwwN+6O
         XuuTGE9ShVlwRWp8i2+vtkySWbYOMjZb3rbgSfQW9Czd7mq5V6dghxGv+stuP2mgdHsU
         u5uLp41frlmdsUaBuDkE0vEIk49mCBAiWkc+JPAEExrNyTeNC+YABzkljtAmO2HLxO51
         LSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4O9IcA+RxZYf7jVM0MLLyxrl/FRrYRl3dstOxuMvo4w=;
        fh=Lnl4ENVPVkw/LTFHtLbJmnwSQsu/ahPLRNxCZ2hSTo0=;
        b=l4yLmIaXStDSpKAg4abS8KDN6O6+KWy2KYsz9RJDiHZ46kjZq4dAWoq9splDniNwQG
         4eeilfBYIrbzch+HzlduuKlB0sx1+STSYl3R4+e9miCbV2lnvTWi7/PkDO0c8o7UcgKu
         h8PduJBm8ikb83kpPRyGz4rAmOXW+E4AzPyYcNy76E6ESa7ka/D9Z6ZBVyPbT3Y5tslp
         oBafBOsg24827ldff6tOIU7u0RZLPMQWFn/nOrszEf6NqKzLB5qmdefTrFl+qyyxRlK6
         mHF5n+vFJdGvBqv/dtxvrkqV7uHnm16tZ4/Xpsznd90v4Tsbd0l+8k5lVGYVTOGzKdxt
         5F+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851189; x=1788455989; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4O9IcA+RxZYf7jVM0MLLyxrl/FRrYRl3dstOxuMvo4w=;
        b=dRW6naVH8EINmLbg3MjZTVuG9WRCAUcLM11sjeT40AlOnpKxOWQ06Ga13N+6D+Pc1s
         5/HySCkFBUP1jupOSPop314NSoWXxKIVrXvW43aUlBlAX2rnYhijCRe17jiAS0EiwSQP
         yb45O94ywrt6rD5rvMOnfNjtetenWdENytrhOt9LZt/BOlL70y3SF35ranbgeQoAfhEn
         NHTFQY8XBjHNAWxNkgICUNhsoV+CYIddUSfMS2a0YCUGEFvqvG7w6k/OrvK+niGj/gyW
         CrTfesDAi3l1QZqFfBFRoxxbvJwVgsi6MA6k173Kl7IbBaCTi+ZJjd99P3xmUKXU8O37
         8asA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851189; x=1788455989;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4O9IcA+RxZYf7jVM0MLLyxrl/FRrYRl3dstOxuMvo4w=;
        b=guusg9ZqFsH6v3v+Gg0E0LJubWEuNCcI19j45pASznU6iBmTMEbx7DT0+PGGYpM3uv
         mqvqEyp0QkFx6ziKPjtO7Fe+6v/+SbPljciXo19qGvtxNQUOF9qH7iWeAKJbNQYWpzSK
         sk+1bqVEg7uiZqaXc8A/dA+uHZ1smVrBec0obk0zF4CMd5bmtkuQdPwB/Lufq22apLSi
         5/FXjDYZmuClmqe43DNFQh0gZZzdEMmdPFlVC+TBx/oTkqJbBgQAbNYWkyD1xNQxJOYl
         wDwfXW0bYeFm1s5bG3v0XM/dMbhYB6pP5hiP85sxrO8TiGWWRkZ9i+THQiOGh4VzfgLY
         +Qwg==
X-Gm-Message-State: AFuF++liBj1pE0dRKdL2XH8JSl8VRfvxqwOIarhl/lXClpbf5KUSVnfQ
	kbPXUkjkg3Ka/0iO9+Rd3SfcTP/TrmAN9AoA9Bk15lRDT9vgV91KUoox6QIUcVxXXt4R5mgT2nC
	fsOT/a3MvXh4HoNh1CVbYjwb5AOwgDWE=
X-Gm-Gg: AR+sD13FK6kXoLEfH615e95ikobg1foT4MNypj4AhLa+f6xtpUzvtnlUlPkEHdIPeeS
	AKUtcR7cxY0ToVjGKCG2EoKHnuP99+cX4PR4M0N7KDTrN8Inoc7/HSWEnC+xigaGMezcwjHPtZZ
	K27S31i7yIKgW9MSoVKGOT0ITdu1RXKYg6EnM9l9P5ijeGs3nScE51O0eOJ7MbAfKDhBn96fGtN
	B88aPZM7CgVbwzmljJvdMU/w+95aVpLP1b1vsi529nY0N9F9EHjttS0SS/bHpjlzMXC9ojkTInw
	5K3loOLAvO1+UhFTneIqiOF0OAiArAvfjF1xYUSQlHiNrwmW0HMzQZbXYCywVDAR5OQvALlizuS
	R
X-Received: by 2002:a17:907:7ba6:b0:c24:6445:d19 with SMTP id
 a640c23a62f3a-c25571647aemr14714566b.17.1787851189141; Thu, 27 Aug 2026
 10:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com> <apBPFRdRdJqODHzQ@thinkstation>
In-Reply-To: <apBPFRdRdJqODHzQ@thinkstation>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:19:12 +0800
X-Gm-Features: AcwNN1WoulzeIyaT3RTpl3G3_l_jAJkDnLWzSfKxi-G_ggWvUMoeiqZPfqQzfgU
Message-ID: <CAMgjq7DmO=L5ajYCKE4w_quM19jTiT4utM62EL-eDhCb0-vmag@mail.gmail.com>
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF70A20007
X-Stat-Signature: fe9uyfyigmuodasxgpitycg13h1k1k19
X-Rspam-User: 
X-HE-Tag: 1787851190-235864
X-HE-Meta: U2FsdGVkX1+H1owkVpb+xlSH3ssKmy74l5il02boDrAGu19Y3Hdq8UqPXiV0ur6mcN/6SNO0R34V6jJ/7xIzKgYBc9a1/sPtBLTEb42Fy5600w/cOyhGUvbHxHjDGHFUKpN7jYt7mfAhCyvccB8z1bLk9TevyzbwB1dCH1C3m6euRDI5B1R2Cql3pwExrV2UGEiaMhRX3yRiM5CytOZFEK46b3ix3S62PLuk6wufsuMFh9aFF+fo5RJpWCaVGDsLLpShC09/7f+zdw1hS2dcMIo7HmlFc3WZK8xo6sGpK0DsVwIC9pRmr3gqUSUypH//1yK0ponw8h7BZ6OtIdYb7jsaaav7vwnUF0QIm0DJudYnLvECT9wjG66GpZVSRjvgtD5tXbrCii30WKrgUeK1vYjvPHXKxP3rluXry5H8+RxAp64mC4VdZz7IA56CcwumwW2seBLeeVbPSnofHc77xHV+DDa1MEjYkx3a4HS/NKj91D7myAi4H4mBJNkduvxfvf8xciZW0zi3myC5zTWRIuyx3stGygtJuQ3cKu1KCCbKMpCb9eh221OaMH0Y3CtrIqxa2MAiJ9QYyFo2H19rCdF2nOiLdZ9jRqWUSy6qVFJFczsfxtG4OqDrKiGpsttRNQ2xNmwGdnwk1Sun7Hir4U9jq2ASnjywbokAztLmlE4wG4UqAMKNH8VFTa0UjNszLZg1mK6LlZ9ctVnpqfA8ERZU1QB3XnJefpBHXBEK+dScPCvOMGzoEyGtq41omiYBJHh3kUZn7rJFWIImx1Ts/vNQvT6+CdnrXtpnzqvlxBJdMpUsJMnTxoVnBRcs1tVCna9OVJJuOlhmuHj6B8PLg7yd+1i5Ga2/OkwRvS1YuHF6D7L1LHbj3ytg49nWjKW/0IOhmYDCEmqm31Genk4bumv3SSfSXa+03W3s8MgwZ6/4A5v3ZjlF531Mkut2HMQJS9YtAl40sIILkL//Xb5
 sccJp8bG
 BcUIvWe3Q7HgwCiYII0cZCGlJcOusB6U6AE9AcvYJ9oqQuvHbCkdxbPahjWZdE5diDlsT+5is1lBNQWYN+YvRd851yk52IyislZ+cDZF+wVdmYAcz5FZSkEWlqd716KLdiKQIAALI04Ie3u/98PbI02uqRY1N6p8ndDZ5+yScmN8ry9TNQE771phUbkrnuoAso4YM91ZSmikxumJYBAKAskzC35/ZTOXP1rlVVuqYrwhJwpWYkZc078bkNilQsLRt/Fn3uxaGoZW1LyzT8EfIQxq2eKLF1jlKztUExM09lmcPKWSEKxdEsIF34d/Uj3OWSFRxmhHydtNRSlRVkWiisV7ZNCGXBzsj6XcyUYsX//I3nZukIIf169DVBirxg3a4I1x0Zs3aBIgjX6TIBc2ysAccFGCbQccsrrNbL+Xn7BmC5a3YYwDjzt5URV4d8WVHaHaf5IRqXTJ25cfGSj/Zc2+WdOG4Vii6ftMx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:58=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.n=
ame> wrote:
>
> On Fri, Aug 21, 2026 at 02:55:17AM +0800, Kairui Song via B4 Relay wrote:
> > @@ -4064,7 +4095,6 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >               folio_put_refs(new_folio, nr_pages);
> >       }
> >
> > -     zone_device_private_split_cb(folio, NULL);
> >       /*
> >        * Unfreeze @folio only after all page cache entries, which
> >        * used to point to it, have been updated with new folios.
>
> This gave me a pause.
>
> I don't know much about the zone device private thing and I had to dig
> to check if such folios are always anon. They are. But it is not obvious
> to me why this limitation could not be lifted tomorrow. Nothing in "not
> directly addressable by the CPU" implies anon-only.
>
> I would appreciate some explanation in the commit message and maybe
> VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio) in the file
> path to flag surprises.

Right, good idea. A sanity check and some comments are better, will add the=
se.

Currently device private folios are always anon and never even in
swapcache, many comments and sanity checks in migrate_device.c implies
that.

