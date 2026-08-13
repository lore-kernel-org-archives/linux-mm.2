Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53458C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258B76B018A; Wed, 12 Aug 2026 21:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F2A6B018B; Wed, 12 Aug 2026 21:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149246B018D; Wed, 12 Aug 2026 21:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF8CF6B018A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:20:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C1EFC04EF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:40 +0000 (UTC)
X-FDA: 85094491440.09.C3756EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8BFBF160005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfm3BuzY;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786584038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5v95wtq1BLZEEyEFG0/i1jcAuSYZVvTrSaBmqKanVw=;
	b=h6hQwm7G7anngGQ+IG0U8BlHQuov3bkGNwbjvmn35luQ32rY6OG+s5IPcpzRdAYsdw9prp
	dAKZdksOMDPIpSn7drM9FP559oHG6hghc/GLkyceHX55pvB7TmyQWSAa3ECIjuNzV5VQNP
	IHJasX1xkvbaxyziATi4t34sIKEIZV8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfm3BuzY;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786584038;
	b=6yMmsp2viiivcDA226ihNdEatrrg8L36TUtkfrpxGXo4PH4RK1f0iBzOSUBxUhxUwGQo34
	N58TYIE5EfgT23x+CFMuI+qeo+iRLVUKRGkQ45T/GekR70607l6hEr1ww43IZdtYlSxnak
	Q8iTCelHmooTgKwKhQnfsjLor+HPjCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 203126011F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46871F00ADB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786584036;
	bh=r5v95wtq1BLZEEyEFG0/i1jcAuSYZVvTrSaBmqKanVw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hfm3BuzY7+sWZt7Z9zy/p7BmM7fa0dRTqBKhLi1sO5v/GquZ1vFEKKTCYqeUKFpkf
	 Y/uLtzy0e3d8evPLNsRRfgC5I6rQUngbgaCgHFPBB9wBxW/uFfksiWmfYhD4BadGts
	 YaZ7gReuAmB5odMh1W+XRrU8QDuWsMV7JND8lhxEj3NLrCpsvJxMivHkukZXFcwZYw
	 +tIfuffmfu5UAlEYAMoFd4D4dpS0/osC9Y0eld0dZw0wbGyJhBZhljK4FRQxcJG9oV
	 VbZGAEK21TzIwDCzt8E2+fNqudgLuDEhUerTthDqioSCmYY0wBRRUxlP8QrHoJNpPh
	 Scj6RMbyml9YQ==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8eeb4508f29so1587546d6.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:20:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpOzVCYWWVc7HHm5IK6B/qVbBnwygG0Js4aFoU8KmkdDOhi6qFwgGavBQtqUfXU8GmSew8/MIBKUA==@kvack.org
X-Gm-Message-State: AOJu0Yx2zPM+OBkVTqoD1dfCJcMXqTJouyeT4ZKoaYrD53ASoK/ssChe
	ZWoJCreEaV8ST7dMArBm50CSlLaiVngp1ME/9AoM3Q0VLLXXSfRb9bslJxWBV3/v6OKMireqn1f
	tXLVXo6Bwk+g1165d9M8puciE5/QD024=
X-Received: by 2002:a05:6214:194f:b0:908:965f:55c3 with SMTP id
 6a1803df08f44-90a80b276bemr20907746d6.10.1786584036123; Wed, 12 Aug 2026
 18:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260812065933.103627-1-hui.zhu@linux.dev> <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
 <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com> <37015686-6776-4e67-95ef-a26ac61a3b44@linux.alibaba.com>
In-Reply-To: <37015686-6776-4e67-95ef-a26ac61a3b44@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 09:20:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-nfbeL7VxZyiWgJ1Ut3D5P+AfMXfqqmndwqMxmmsRJg@mail.gmail.com>
X-Gm-Features: AUfX_mx7bgfxS6l0IFxFtM2MLFiIwSFNHjUFPvv2yGnyvUchjbj1-_2nkD4Clq8
Message-ID: <CAGsJ_4z-nfbeL7VxZyiWgJ1Ut3D5P+AfMXfqqmndwqMxmmsRJg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Fix young counter undercount for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BFBF160005
X-Stat-Signature: jwtd8yqua1onr37e8mnswb1xss1px775
X-Rspam-User: 
X-HE-Tag: 1786584038-495515
X-HE-Meta: U2FsdGVkX18GjhvPp68fkATKZFaBN7WkmauXTEmpU6dXLJqkog17QqOQbIeHUGxzSsmWQs3czGgSLoYp3lswS48PdSljkGjTeJOvBarni236+H+pxRH1FlO7HdRczrF5qQ2ih3ieRbBkuFLMx5RDJik+zoKj526QgrI8x4VsCUxR9v+YpBN1wwybOWEWRaJ4309Wmy3bcI1bAcnIAhMqZM6+3KXATbG9CMEiIvC6/XkW0Kc4tWlCf5wyp0fZg/3dYKiGoiiAKePc+uArQYI5lqlZXMviyKubC5qTWyTzPdlnYfdLotCHxluwLi70qPYjdvpVBvbJY/MQD0x2aLTS4kSJFZ47IQsNKSNmdM6RDK4W38EzYBRSDi/FCHO/m+1hVnnzaOCa9I+aB60EQsdz8lBUegg6CmoHcjAslQyInoUOr/qovqd3hU9Zzbg6FyGkKe6YTvJNKFfj3tKyH0luAl5FEwj5nUeyOJsj/9aMW6jjDlNwr5DEwpKf9Ku2TAZqSHpT1l6ilMhyvK9tykI0iLa2T98REVYwCzFWi+yuy8yzRIE6sUUdBWqDG0JT3MnT5ftX39GZkLP4hQ5wm6EgVHLfUM/aggnCcF5Gcb4x+/MYQmY29aw65E+DSx4PEDCSeR93zjpi7gwn6Hy+flaxqLpEND8jYmf09DCipOWOJZzNi2Mr+tVE5qcsLTmFiNfMyuVPD023hmxbkpFdKvItEn8hcIwG9EiSYI+cS1XnQaVuHqNUxg8LhinU4/2e9laOcwr7/cqBOVpC2OIN1djItlndZSWNkL0kxkXQ/fYbi32gW5YWBBXuqL5PIs0XG8pFOVXq4uAAV/YRwcupA6O8JGBq2KPd7vdOZFN+n3W7QXiR36GL0E5Q0e0idReTAOT2K5AQ6nq3Be17Jumh8umO5QW7mqW7IMP7bMuE4QOIbSEJ+wR8uhwE60GWIukadgn30YuBstmXFko9SeIyKPz
 vFGThNMg
 ftGO14b7U0jxp7p7USYaTM/m+fwS4Ov8iUAPpkR5N+8d5IA1wtt3HtNFNYWQM43GiVRuEKSe2oqzc+Te9Nid1Q5EadgvFDE9pA4yATummgUpzVv78Rzr+eoekdM/X++wAJf0dfsI0m25VmN467LH7XCC8u6NPwEZMIwL7lKqHfYVguXM9qmk/zmz+TUp92yaiCqlIroieyODx92WaXfDMo8HEFqo9uaJlCaXXPqJeWKgxRdktA/CG+0I0EXJqj0XJ3Ye6f8CJvMCgoX5fKIluKje6govw3BmsCK6DYXaGZ5udkD6Gi1rrzrkrDjWShyI0bpqNaba8msp8jRLg4hIwwAydCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 9:09=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 8/13/26 8:53 AM, Barry Song wrote:
> > On Wed, Aug 12, 2026 at 6:17=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >>
> >>
> >> On 8/12/26 2:59 PM, Hui Zhu wrote:
> >>> From: Hui Zhu <zhuhui@kylinos.cn>
> >>>
> >>> In lru_gen_look_around(), the young counter tracks the number of youn=
g
> >>> PTEs.  The original folio's contribution is represented by the initia=
l
> >>> value of young: test_and_clear_young_ptes_notify() is called on it at
> >>> function entry, and the function returns early if it is not young.  I=
n
> >>> the subsequent loop, the original folio is skipped (its accessed bits
> >>> were already cleared), so it is not double-counted.
> >>>
> >>> However, young is initialized to 1 regardless of the folio size.  Whe=
n
> >>> the original folio is a large folio with nr PTEs, its young count is
> >>> underestimated by nr - 1.  This inconsistency can cause
> >>> suitable_to_scan() to return false, preventing the PMD from being add=
ed
> >>> to the bloom filter and reducing aging accuracy for mTHP workloads.
> >>>
> >>> Initialize young to nr so the original folio is accounted the same wa=
y
> >>> as other young folios in the loop (young +=3D nr).
> >>>
> >>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >>> ---
> >>
> >> Good catch. Please also add the Fixes tag:
> >>
> >> Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag f=
or
> >> MGLRU")
> >>
> >> With that,
> >> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >
> > Hi Baolin, Hui,
> >
> > I am not convinced this is the correct patch. test_and_clear_young_ptes=
_notify()
> > only indicates that there is at least one young PTE among the nr PTEs;
> > it does not mean that all of the PTEs are young.
> >
> > Am I missing something?
>
> You are right. But I explained why this is done in my original commit
> 56e5b60b2114:
>
> "
> Note that we also update the 'young' counter and
> 'mm_stats[MM_LEAF_YOUNG]' counter with the batched count in the
> lru_gen_look_around() and walk_pte_range().  However, the batched
> operations may inflate these two counters, because in a large folio not
> all PTEs may have been accessed. (Additionally, tracking how many PTEs
> have been accessed within a large folio is not very meaningful, since
> the mm core actually tracks access/dirty on a per-folio basis, not per
> page).  The impact analysis is as follows:
>
> 1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is
> mainly for debugging.
>
> 2. The 'young' counter is used to decide whether to place the current
> PMD entry into the bloom filters by suitable_to_scan() (so that next
> time we can check whether it has been accessed again), which may set the
> hash bit in the bloom filters for a PMD entry that hasn't seen much
> access.  However, bloom filters inherently allow some error, so this
> effect appears negligible.
> "
>
> Based on this, I think changing it to 'nr' is reasonable. For an
> accessed large folio, it's better to have the bloom filter rescan the
> PMD and keep it in memory instead of reclaiming it incorrectly.
>

I am not sure if this is the best policy, but we don't seem to have
a practical way to get the exact number of accessed PTEs, so this may
be acceptable. However, could we at least update the changelog to
clarify that this is intentional?

" However, young is initialized to 1 regardless of the folio size.  When
 the original folio is a large folio with nr PTEs, its young count is
 underestimated by nr - 1.  This inconsistency can cause
 suitable_to_scan() to return false, preventing the PMD from being added"

Its young count is not underestimated; we are intentionally
overestimating it. Also, nr does not necessarily equal
folio_nr_pages(), does it?

