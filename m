Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65D4C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 20:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C593B6B009D; Thu, 20 Aug 2026 16:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FA96B009F; Thu, 20 Aug 2026 16:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C776B00A0; Thu, 20 Aug 2026 16:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929CE6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:18:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D0671A02AE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:18:52 +0000 (UTC)
X-FDA: 85122761304.24.36FAF00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 318531C000F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:18:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZgTjWP4;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787257130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EA6OB8efB4CjX+7G6ehKwJX38JDkTNDwLUFqLLQu5KU=;
	b=d7JG/jypeNZei+n2oo0honGhH+JW8YsLEsW0uElZYH1ljzZVuueCGHVbW4tLLNQUfFy0CU
	amu44ijQ0NmyPvDKxwegPA3eOr5BN/aGhdV11kATeNpCqx8HARtdonx5ckuTXYGSRjdMSP
	CCTrcOxM9jrEsVKh3pVx/IzhGq3PdNA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZgTjWP4;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787257130;
	b=EzZu3EOt5Mj4DWvU+Mix+B/4HmfP+D7Mpkf+4mcLoxYPo+vbHlnj40a4aAHADP1Eu0LtgG
	ESPBXTyTjQktzsjzvAZr9rDByDxu21cLw5SqF82GMLfI6/nx8Vdeit+uc4Ln4bFdKSGvjX
	sUGqZ6D/UMlKaWN+0ACs6mvNqh/ZnBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F16784380B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CC71F00A3A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787257128;
	bh=EA6OB8efB4CjX+7G6ehKwJX38JDkTNDwLUFqLLQu5KU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cZgTjWP4kUwedUY4+tjuChuBR2OgOb2WF2djzZFULirEcCI3xCFZnXv4rbbLcLR5c
	 z00eqZyrEhKYWL7VUfU4zAx+7GErtIFPGIDeRmpHlECpoAoxm7Dt2W80ShQ86imwQ6
	 bJ8bxPFDSkQCcuQcaTgkGvGVsLVWxsx84ytA7oC7DafGoSRNJ8MS0NL8cjEc5YIOaT
	 UGgQg73+4uYYr2fZf3v921mJYQgP1HbHzxMryYuFVnwioSwKd7cFXqR/o4eFqKH1kv
	 q/r1mvkP0C5+WOU3VSpQ/bpNovtrhxAa+nTAoR+SkW/yHWht/UmOHHscmczk+4lL6/
	 VvNpNNgyDO9xQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ff20870ac7so2776476d6.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqfhUExk172m/dlJp9mINeUVeitufOKwX5yMxjpnrrweT8NgGUz0aY5uc5gemcrPfGITV0M+UhioQ==@kvack.org
X-Gm-Message-State: AFuF++lvbUmKG6wkN6o0hDfLnPp2UU3KPNVhIyqEKwWJsPUCo7RNqkAq
	iLsX0bM9G/lZJb6AVGSlAlnzLOKW7Rk9JP5lnN+eEOmPl1OT1N1gbHHhBNzJfyvVZjfNh75HmYR
	XibUYYUwY+LNZsD4IlIR6pJteZ5ZjMlo=
X-Received: by 2002:a05:6214:5006:b0:8f0:6a92:b90e with SMTP id
 6a1803df08f44-90c80db17a5mr9077766d6.25.1787257128121; Thu, 20 Aug 2026
 13:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <c8287b5a-8f8b-4110-ad47-996842f01bfe@kernel.org>
In-Reply-To: <c8287b5a-8f8b-4110-ad47-996842f01bfe@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 21 Aug 2026 04:18:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
X-Gm-Features: AcwNN1WBnDfKERJ1DWbe774PNc22vEu6BysyJ-hXtK6D44bKVjz_b2sPxe4tyuY
Message-ID: <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, hughd@google.com, 
	ackerleytng@google.com, usama.arif@linux.dev, joannelkoong@gmail.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3pb71gipzc5pfxao8ay1bzf3m44wmx3n
X-Rspamd-Queue-Id: 318531C000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787257130-173790
X-HE-Meta: U2FsdGVkX183B3b68GtpM34ohKKe9iYdnW0vE1kHZiAWgW9vkMxVRS90kcVLDvhQSHFZ/61PX5mVrSXptY4ajO8M22kZesdQVZ3DCaCD+G2OlAewVfBlTXp2P98A19u6+y9gaAtVO7PjByn03SoHtNOAxUoGNd/G6xeFcU4Kk011bM1n6suTtgocBTQvSRVIww7/Clpb8z2Rvw7qqxt9dzytBDSdi5323UOVEW89BnvVNlk+T7Qh6AjyEcNGbaRGS09n7YAH3iR8HrJ83kWUWQAWlND6ZtbKq4ntyKao4APvmBvuF+U29sIy/f4DTNXWTXiZ1PfT7wHUUfX7DEa9hDoAcpjs0dekTPF3Fh+e4lqMjdmdLkR2x7MtJdnHL1F52NALZMH1iSk0e6odhBRCvh6EoWjm1X0suhXr5aP4Y6utp9zAz1lCtB9ltUC6/t6JRcqNSrv80jrkw8uUSKwz7adjfAjwheRUH4wOmo7WJn6T+RoWCRK4Dpqv4G6vrsc/fK/Jhir97gtymfue3zOskySpoYk1/6T8Lc7sicnNVylYeaupsaDPysSlTkR+awQrxoYZALRBkCqZBgaH+ql4G9BVD+YuxHn7YOBSsQAfhHB4H6B8+ptsGKgQ7h9t8IzKFPnxJS/UCPZjw+wK+lpSKDO01YPko5KsAWPu0WsTfRdpsnuVLPv84sslbUaFF17Lm+LfYhOJHMpEcVbmmp6utuW2nqcN09r40TcGRlcxtw3XuZ8ZIvCOQfBzw73GfoCfNHH+wt0Y5l1dydjvkUt+cFSmz8/jMEGkOfLlYiZvouzmZmai0gP/XaQPIjwoNfZkLlY1aOmSG4WxUoqIYR+CZiwY8eUt6q4HhH3+LyKAARu2NxSACkP2ZcXDFTm5utFdj+npsgdGkhXtQeg30Ll/pzsYNVuQsBy/N4l1u566sc6HPFvpgFhyDpubLJRmIL2x7pL3ALZ5J7VC3giWxQU
 1bP3a+z6
 FVrX2K9YqremTucOHTvevkwBVTXmpA404XKiBOhRt45+bK3LDiYChyVsC86ul8Z2n9APtSjmH7lS31WjemPRBrthWZDPiiiUK29GkQCrZHnKWEcrGeI0glKZcFC++vmolYRyyhvaNmtcY+CzA6wWxJF37xfaPhxMMrJ5Z+PxMD97XAN2wwa+Zx7wbnAgAEMG4IgeFKvVnRleYRh41Qvai1LG2s8avaQVo/GToVWftLmaYx8Va40b2VtN+Ez4NaaC0poH4/Mt9wWRj5kG9+rHQLFppfAq/NUmjHLtdii1DIs5nwV24EtExDn4Pow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:23=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/19/26 00:59, Barry Song (Xiaomi) wrote:
> > This patchset enables the per-CPU LRU cache for large folios with fewer
> > than `FOLIO_BATCH_SIZE` (31) pages. It also limits each per-CPU LRU cac=
he
> > to at most `FOLIO_BATCH_SIZE` pages to avoid negatively affecting
> > accounting and memory reclamation pressure.
> >
> > This is particularly beneficial on systems that use relatively small
> > large folios. For larger folios, the benefit is likely to be smaller
> > because far fewer folios are expected to contend for the LRU cache.
>
> As raised, there is this problem with collect_longterm_unpinnable_folios(=
)
>
> (see
> https://lore.kernel.org/r/20260806-lru_cache_drain_for_folio-v1-1-c6287d2=
95e99@kernel.org
> )
>
> whereby we don't know how many refs we actually hold. Certainly not 1.
>
> We might have to wait for Hugh's cleanup to handle that cleanly (and avoi=
d all
> the other LRU cache draining).

Hi David,
Thanks for raising this.
Yes, I saw your comment and took a closer look at it. I think the
best approach for now is to leave that part untouched until Hugh's
patch lands? We might end up doing some extra draining in that case,
but that's safe=E2=80=94any value greater than 1 might not be. We may just
drain more than necessary?

Best Regards
Barry

