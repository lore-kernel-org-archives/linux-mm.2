Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2BAC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BB66B00A6; Sat, 27 Jun 2026 03:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5D26B00A7; Sat, 27 Jun 2026 03:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CD26B00A8; Sat, 27 Jun 2026 03:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5230C6B00A6
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:21:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACC73406CA
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:21:06 +0000 (UTC)
X-FDA: 84924846132.08.2A95E18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B714016000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:21:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQEKHFhP;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782544864;
	b=frC0SGU/2ofO8To8MDUcpZA8gdh0AZP9DaqEA/LcOQuaqhWPIVyd1ne3W4hmOEDOiVLYRx
	K6wzV77PzNrPgRncUlkQmVXhCE4ls5kOp2TLbdgARfA0eIkIoDgRdDGK6VaF3hQOGUDEZ4
	Qx9im+9B6EKADP3D47+MuG+l7w1e77Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782544864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdGno2AbrekCG0b53bLETJhCdWbqhJa2B0RZ3rUtZhY=;
	b=n4Ycl7he48OgfuQkaYKbrCgxFQRl52CTCDzcAgVH6ja+5jwicN/3ccPsXVZgs0Amdp+A+Q
	7ZE/hAbtb+PFPvKx/6LpP/pk9Wjq9oaLL/Vtm9sZNs3Rz8gBdmVOcFsAuDtS1FYKS3JvVB
	UsrUjDO9sTkKA8a1cRtqgBuMp4SrDBE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQEKHFhP;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D941643927
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09CE1F000E9
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782544863;
	bh=CdGno2AbrekCG0b53bLETJhCdWbqhJa2B0RZ3rUtZhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mQEKHFhPVVQycgnikJcQagUI/ln6fOtLx22IK301bueLhzlS09RNYUw65TorMUcIe
	 N6EkzVX5BoWZyqBwmTwUBJK2ipjhiiaS8V7jI7DK8bik7hMUTM0v5KYaX+J3MNzVJT
	 Fn5otSZX7tMFgQwG/fPordWWIOptIqX28NTN1O82mFDJ9UANnXQU0+/iZVX8bt0Aj9
	 2/TVQbyM3pd40uquoJNB5pBmg4K8v+kJS+ypRbgwMZ6IFFiL+M8uUHcWB/BM6mthvp
	 pLO9C4y0fHk2jRxrk290iMY62IaFV/oS0M0GYlCZ4aFhgykiVp0sWZ+kpGxq0ycZ2A
	 1kVM79YhKF9Ag==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8eccf61d0a0so1931716d6.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:21:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrWydzpMlZiSW3ku6IFAodZiDPUrcJ2N7sOg4Or2TTKjF9CdogQHV60qspV81N5EOSERmdx6F0jUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/Budp7FCGzy/yWP5uy2xxpGCtmJF9r1KeTiWb8nBlhNcxOe9/
	5k8YklPSocICmKTBuuMf9uLUA4RbPgOYsV+tbzoRwP6zzjdT43y8tTYAnA4kpi/N8W+YQB2asKu
	VfOL/jNAaeMv7tQF8FFuJteq/Kg82Rj0=
X-Received: by 2002:ad4:5de5:0:b0:8e6:7adf:e0e1 with SMTP id
 6a1803df08f44-8e6d687a59cmr148353856d6.12.1782544863012; Sat, 27 Jun 2026
 00:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org> <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
 <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org> <aj83c5ix_YCFMU-M@linux.dev>
In-Reply-To: <aj83c5ix_YCFMU-M@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 27 Jun 2026 15:20:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com>
X-Gm-Features: AVVi8Cfjlms2NVFRTodzEFCm_jnM6HsOYvqAgkGAMgtgvIB3JVVYsjveW66P4UM
Message-ID: <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xj1teh3bqo3h5ai16o4onjc5dju3axow
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B714016000A
X-HE-Tag: 1782544864-750743
X-HE-Meta: U2FsdGVkX1/zrsIYOKxP23VoiNM4/TsKTL9bGRuf7quQqF/xx4IAAX7T3I0phfXBOonDHn8vBI0lDeqV1b7ZZzwzWgst3BIU9mBuOzrxOs7lsYiRwFEL0CAWKnui8eVeQGO/oQsEb1lZeQm+hrwRoEItrCNC+YoccMTLORKfbEG65YKzhe2RJ2hOM4ObsgWrxRGDMedtYpqFsFsXD9ZYh+2YMHYILTtuJF+TMCCorMPrHm7AZE/GJXMQhnAJHMzmLIjGn8Jq6bQjZdCJk+xc2exvjoRtZm3gHBBW2Vz38I+d+HtlWO8VwishbI16mJFvPltwclWXmkVWAL+XN69cebA5xdMNy+BFQTDbv7iFiA+woFllY2jBs3XoWD7y/H3Kbe8kb+GrzKWBsi36wt8lx0+n1qoY25uMXjPnLyFOkR+ss1YqmG5KRlz2YMdEUIs3HRIkatdxCnxdM8lKTIpudvguZv1rURzexkUWvWeRL3oUhUmIyr9KKfAMnoCrlIHMaeQ7G53GIbtMCfXW/2+OTu6MI82Ghho1kWlAoTzsVXq6yXdtsw3ZUATqkgIfdFXtmmftlk4ZKqAjl24+R0qRYHXLWYu7lpBgFHF4SZ/nJKSQ/TY+0FO2NsT6V4cY53R3OgS5ZKyDnHC4TI98JcBQgcEgiFae6TvYF2o3mMdt6ZNaAV258C48LtS5D6BBVB5L4NvHla8XG0evSBHnEdr6AaV2EVZiEakQvmhQTheBsLR4Y1z2bIjy683w87RG2IDRfiKBQwbg1An+E/V3LJeDIFjchUJOAaeZn4ZK1kEUrnSNSeVZzYq8wVbo8Gt1JduRNvp3TKiRJyrmy1d53vn4gzLWjF6sfGtlaHpmRl49FhEDuYLyYtFcz/Dsk/lyEaQLVd5eMPe4o8EuJ1Fo2bqtAozMMPzAK7Y1dfz3zDzTIOSNnJj+mqe92BnPGNJIFUe5oulBM+OXXEWRXTUKUcV
 RgznIZJP
 I+IhmGa+mAoNKmJfEWCshTu+mrNkmrhFdMnHDkS+l1MWK3foQLvO30eVf3CjdFQB7tfmQVlAIeqWcmwoZvViI6jGDqaR7iiXRAS7k/LfOFQgy1MQbTluJSDGWjKBJ/1QAbcrCE9+MBjDuDKx6DDcx0qXW/y/UJhTFZGk6jtzi4xXPI5lCwQDpGyJVql41tJMRuTxdPXvhrNiSb1UM3kAqHiEAfN1VIhNdcklX/mgvi+0zYPNhrwsNQ9VEA5S7zWTMWVWHqvqsNrRSOoThdj1oXmimppmp9NESr1/sBqf8/fKGtQ/dZYorQ6vD8xzec9kPMaSIbn1YPXbqaEQaWTe64OUfmKl6VdWelr1Df1qx/L2AlfIcQxsOJbWxlVLdkgOpgwtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 10:44=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Fri, Jun 26, 2026 at 06:25:48PM +0200, David Hildenbrand (Arm) wrote:
> > On 6/24/26 23:04, Barry Song wrote:
> > > On Wed, Jun 24, 2026 at 11:02=E2=80=AFPM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> > >>> We always unconditionally drain the LRU before retrying anon folio
> > >>> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folio=
s
> > >>> are in lru_cache, and use the refcount to avoid many unnecessary LR=
U
> > >>> drains.
> > >>>
> > >>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >>> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > >>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > >>> ---
> > >>>  mm/memory.c | 8 +++++++-
> > >>>  1 file changed, 7 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/mm/memory.c b/mm/memory.c
> > >>> index ff338c2abe92..f6848f4234a6 100644
> > >>> --- a/mm/memory.c
> > >>> +++ b/mm/memory.c
> > >>> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct =
folio *folio,
> > >>>        */
> > >>>       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > >>>               return false;
> > >>> -     if (!folio_test_lru(folio))
> > >>> +     if (!folio_test_lru(folio)) {
> > >>> +             /*
> > >>> +              * Assume folio is on lru_cache and holds a cache ref=
erence.
> > >>> +              */
> > >>> +             if (folio_ref_count(folio) > 2 + folio_test_swapcache=
(folio))
> > >>> +                     return false;
> > >>
> > >> I'm not keen on making this function even uglier, so no, not like th=
at.
> > >>
> > >> We have the earlier "folio_ref_count(folio) > 3" check.
> > >>
> > >> In which scenarios can you trigger this such that we would care?
> > >>
> > >> If the answer is "I don't know" there is no reason for a change.
> > >
> > > As I replied to Shakeel in the v1 discussion [1], this can avoid a
> > > large number of drains, both during Ubuntu boot and under normal
> > > workloads:
> > >
> > > "I booted the system into Ubuntu, and after
> >
> > is this with this patch only?

Right. wp_reuse_skipped_drain accounts for the behavior
introduced by this patch, while do_swap_skipped_drain comes
from patch 3/3.

> >
> > >
> > > boot completed I observed:
> > >
> > > wp_reuse_skipped_drain: 5542
> > > do_swap_skipped_drain: 0
> > >
> > > Then I built the kernel in a 1GB memcg using zRAM swap, and observed:
> > >
> > > wp_reuse_skipped_drain: 25017
> > > do_swap_skipped_drain: 43595
> >
> > This is all data that belongs into this patch description, not hidden
> > somewhere on the internet :)

Agreed. Sorry, I was being a bit lazy.

>
> I asked the same i.e. to include this information in the commit message [=
1].
>
> [1] https://lore.kernel.org/linux-mm/ajK4N2zK3sPZFQuf@linux.dev/

Sorry, I missed this one. I'll add it in v3.

>
> >
> >
> > And why do we care about local draining? This is not a drain-all.
>
> Let me take a stab at it. Local draining can potentially make the lru cac=
he's
> batching ineffective. The whole reason for lru caches is to batch the lru
> operations to keep the lru lock contention low but if we keep draining
> prematurely we will continue to make lru lock contention worse. This is
> particularly bad for workloads which chrun a lot of LRU pages through
> allocation, free and/or reclaim.

I actually asked the same question myself in the RFC here[1]:

"On the other hand, the folio may be sitting in the lru_cache of
another CPU, which the current drain cannot flush. As things stand
today, the drain only succeeds if the folio happens to be queued on
the current CPU's lru_cache, giving it roughly a 1/nr_cpus chance of
working. drain_all would clearly be too expensive to avoid.
So another possibility is to drop this drain as well. The folio can
be released later, at the cost of missing some opportunities for
reuse."

After thinking about it for a couple of days, my gut feeling is
that keeping it might increase the chances of reuse in at least
two cases:
1. It could be a newly allocated folio in do_swap_page(), and
do_swap_page() may subsequently call do_wp_page(). In
that case, task migration is less likely to have occurred.
2. On systems with fewer CPUs (and typically less memory), the
chance of having the folio in the same CPU's lru_cache,
which is roughly 1 / nr_cpus, may still be reasonably high.

I'm not entirely sure about this, so I chose a relatively
conservative approach: making an obviously correct improvement
without introducing dramatic changes. Another reason is that it's
also hard to evaluate the impact of removing the local drain
across all systems and workloads.

Shakeel, David, what are your thoughts on this? Should we go
with a code refinement in v3 as David suggested, or completely
remove this drain?

[1] https://lore.kernel.org/linux-mm/CAGsJ_4yFgcvpTAZ_YV73+U=3DBEnOiSxaFtGN=
Fpbf0DWBkVcOQ3Q@mail.gmail.com/

Best Regards
Barry

