Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB402C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89A36B008A; Fri,  4 Sep 2026 12:36:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14596B008C; Fri,  4 Sep 2026 12:36:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB4B6B0092; Fri,  4 Sep 2026 12:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 507016B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:36:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91CC9140154
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:36:11 +0000 (UTC)
X-FDA: 85176632142.19.F738F6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B708C0009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:36:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoMOTByP;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788539769;
	b=tEcmPSCzBjqDSmHmiM+UKipEx4k7gtq5UWoqbgjCzrTs2lQJqd60RBDCg0P7gTLMJ1SPoa
	ROCQ/Z4g3HnbFyOU8+H217u/No/1O8kYf0MY8HCOokW6q5dqmHyjrD2y9l0LVgkYtZdS0N
	VYnwaKnb7VfjfPX9ap9PMYLTvzsrkhs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoMOTByP;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788539769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqyHe4ig7vedzj2gzyGv7QJ5dMXsIqSih2e4fKgIahI=;
	b=3hZNIsKEiHzDFLjqPfn7rREJ60HQZFo1mBBqMr6tB/Kv3zjaXCKUXZstfALZAiksqP3ovS
	bbNdY0L+TEsmeNfCRr2fVy3dA5WvDoQFkojrCyyYTMX2nTmylKEVHpHXt9gj/tL+X8Odr5
	fc4hqmyYrAuk6v79/ssR7KMyeOkbfc8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13B8141098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0FF1F00A3E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539768;
	bh=EqyHe4ig7vedzj2gzyGv7QJ5dMXsIqSih2e4fKgIahI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MoMOTByPAVtmgg10B02BQAVMBbjSbMFqN3cuBPf3CfXHcQTr/Iu2mvqgwAxX+MDcX
	 /+iZyRQMGQCBkzlDh0fhsouXEwEht9AoT92jWvHI5ILdvlw+m6tmP8hVixUvbg4Wr8
	 mJ7gbA2ujyoSBrus+ISmG82m6XJ9i1PFMUDzZhaRITEP+6zEXry4yWv4DEZ90+LZKo
	 /55jAeLvuVGZqhF/qWoO4nP1fYOliNYWF92M7SFNqrttr5FXgK0fDvtB3gTUqNJwjd
	 rH11eMH73g348P77hoy6VhoKIxDHwZYqELHv6GyGLESWf6D6ECZeJPmuU6OKUd4hie
	 FoX2ZLedcobFQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1c52d920b8so159840166b.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:36:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxN4MBFDV6V3dmP6/LZk2brqyfCr75iQ9LnXdAODQvXcxNsnZeS/0XjEcgplApyMF4t+0OStdSYPQ==@kvack.org
X-Gm-Message-State: AFuF++n3MQ1p5jACdcjcthsIRh1QYdKlercUuk3KDC8eWGRpaJAt4vfG
	gesQ3KRlTVAsGH6e8sjOtfq9OKBUtwwqGsOPLq2tCvZbGNw/kp82p+zo7PEFfnLpV7XiX+gJ0Fb
	zC4sQbfBb8DKa0jyrTa2CBAPAIoPlyq0=
X-Received: by 2002:a17:907:3c8d:b0:c25:608d:7934 with SMTP id
 a640c23a62f3a-c260c9cb984mr349898266b.12.1788539766806; Fri, 04 Sep 2026
 09:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com> <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka> <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
 <aprxXHSh-LyqaFCW@tiehlicka>
In-Reply-To: <aprxXHSh-LyqaFCW@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 4 Sep 2026 09:35:55 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
X-Gm-Features: AcwNN1WCfeo409btAP4JUxUY_0DYyfbooHU3anTgx9GPmkXmnGquyayK6GUdEWc
Message-ID: <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
To: Michal Hocko <mhocko@suse.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org, 
	mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz, 
	hannes@cmpxchg.org, quic_pkondeti@quicinc.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B708C0009
X-Stat-Signature: kxu396eem9ky6hybaybm36bzmoqfxjgy
X-HE-Tag: 1788539769-800042
X-HE-Meta: U2FsdGVkX191eqEnE+FDAhofpZUtV5RSLQYMmqKsBwvnQRkhvQwjHYN2PJDXvCp0OK/4+HFJU2FFq3L0uoPaTebGhWDH8134PijT6YEUxb2JOagowTjhOHnQ1UIjNBpjcXbfpyZ83+kVbGA1ZgCvE/nVE1kaZ2dG7QN+2pND6GN+I51OxhGAGQK9jAB3APX9m+6GVzuKlsEqhwKT2iQFSIpyVVAchCfOisTuxLWsEniE6DT6cffeS1/0QtYY+otZ31M0En5O9NDOTd7DakxB4qWrDLfZjHjUwai0XqpKcDucoXF1+qlq/F9zfDLqD4JsXYWA1r0fZpOpJOnjtfu4EzlTYxBBorihJfDwCR8NT72Ct140PRmkxbIRAFybWCIPz3KNzT16iIQfQythQbNaj7sHrt+4JE3bS3OpAU7qHyq9zT8OW7ou6npHjWjlK4AsAvzeNi2kbpEgsv04FwE51BfcxsTe1MjoEvFt9EqVsn7pnpi3I0VWeHh4lkA7v20t4tJG44aLP/hgdm4R/FWfnWaNxnVN+w/KZMVi8RJK/AaKUYlOocU/AVITLteW+8dQ5rt+F1/Xsm4DaVxV7OoTFRIdywhUvplwGBfKZG4JKMiG2ELS2p0K28sBxZi6Gu58LzJS9Z/eSBDSiPcRntk5eEECAU54N6pubxDW6K5QK/o9ZgAH9vmkaQPTZt6b95HvMj+3WABi7LwIPJbcy3LLbMYsdyHmhUw43vMQu/5M5b3GG1pQXhIQApDYo9uGGHAH/2JjU5hae3SwXqFNLHaEa4XQyOcrzASwXOyjKSZ/65jhbDnO5crgrwBUycvJHxy0XYHuwyOXN/Pka4dnLUkIKLE2jnocxrHTbqs9lYUXrcbrWE0P3clPfzzQ0eeAr1kZr1Nu9ddQUN6xWVud5IOcf3xA+GMVtDTmuZvIau4xhES+wGWWFRh2abo4uWX7DmBkiZqaSXaWNsimLvBGy3t
 lXLqKXXa
 o22MHCvMol7g6CCE38pLD1tzBpT6uP/S5ilvnEdHQAmoj8fDQy9OYawU4ymndV6QZKOODX2ceXECpZL19v7G4wcaW2o4WjKk4t3wYwrSx8DR3SLJjgN/pWvAwXqKBlNtC9eUZshL9eOuXsqsrO7vnBwCzNploCkCzcBAEpQmJlCa0oXs0/k+IX6Q/9Lg2u/3YiZiIQqLv/qoD7SPCz+DnBZUVrKVrV4TrqC+VDnOcW9vNdz8RBrELC672wInD+pY7Xago1BCniWIPsw5mNegNX3O5er92MOG4dLn3x73LXYFNYICNzmRPlwx2G14s0yUzcvpywv9uYRf73g9i3QcsZLtZFz6hDQPNdi94u2ErmtKmr05JjX/MIl0HMqIULkinHyLjawiDgFDdujcdrONqCJYrDIwoUgs9Y6i7Lhk0KnY3DlsFm7objG8sFqsjxkVjaKcX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 9:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Fri 04-09-26 09:09:35, Yosry Ahmed wrote:
> > On Fri, Sep 4, 2026 at 4:21=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> > >
> > > On Thu 03-09-26 07:03:33, Yosry Ahmed wrote:
> > > > On Thu, Sep 3, 2026 at 12:27=E2=80=AFAM Michal Hocko <mhocko@suse.c=
om> wrote:
> > > > >
> > > > > On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> > > > > > On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wro=
te:
> > > > > > > pcp lists are drained from __alloc_pages_direct_reclaim(), on=
ly if some
> > > > > > > progress is made in the attempt.
> > > > > > >
> > > > > > > struct page *__alloc_pages_direct_reclaim() {
> > > > > > >     .....
> > > > > > >    *did_some_progress =3D __perform_reclaim(gfp_mask, order, =
ac);
> > > > > > >    if (unlikely(!(*did_some_progress)))
> > > > > > >       goto out;
> > > > > > > retry:
> > > > > > >     page =3D get_page_from_freelist();
> > > > > > >     if (!page && !drained) {
> > > > > > >         drain_all_pages(NULL);
> > > > > > >         drained =3D true;
> > > > > > >         goto retry;
> > > > > > >     }
> > > > > > > out:
> > > > > > > }
> > > > > > >
> > > > > > > After the above, allocation attempt can fallback to
> > > > > > > should_reclaim_retry() to decide reclaim retries. If it too r=
eturn
> > > > > > > false, allocation request will simply fallback to oom kill pa=
th without
> > > > > > > even attempting the draining of the pcp pages that might help=
 the
> > > > > > > allocation attempt to succeed.
> > > > > > >
> > > > > > > VM system running with ~50MB of memory shown the below stats =
during OOM
> > > > > > > kill:
> > > > > > > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > > > > > > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > > > > > >
> > > > > > > Though in such system state OOM kill is imminent, but the cur=
rent kill
> > > > > > > could have been delayed if the pcp is drained as pcp + free i=
s even
> > > > > > > above the high watermark.
> > > > > > >
> > > > > > > Fix this missing drain of pcp list in should_reclaim_retry() =
along with
> > > > > > > unreserving the high atomic page blocks, like it is done in
> > > > > > > __alloc_pages_direct_reclaim().
> > > > > > >
> > > > > > > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> > > > > >
> > > > > > [Sorry for thread necromancy]
> > > > > >
> > > > > > Hi Charan,
> > > > > >
> > > > > > Are you planning to respin this patch?
> > > > > >
> > > > > > I know that Michal was questioning the need for it. While doing=
 some
> > > > > > stress testing I came across a couple of OOM kills that had sig=
nificant
> > > > > > amount of memory in pcplists. Something that would have been pr=
evented
> > > > > > by this patch.
> > > > >
> > > > > Could you share some numbers to see the scale of the problem?
> > > >
> > > > Sure, here's a sample from an OOM log (ignore mapped/free_mapped, i=
t's
> > > > from the ALLOC_UNMAPPED series):
> > > >
> > > > [   40.336188] Mem-Info:
> > > > [   40.336195] active_anon:96 inactive_anon:1540181 isolated_anon:0
> > > >                 active_file:51 inactive_file:0 isolated_file:0
> > > >                 unevictable:382720 dirty:43 writeback:0
> > > >                 slab_reclaimable:20339 slab_unreclaimable:26597
> > > >                 mapped:382858 shmem:153 pagetables:8291
> > > >                 sec_pagetables:0 bounce:0
> > > >                 kernel_misc_reclaimable:0
> > > >                 free:17264 free_pcp:16890 free_cma:0
> > > > [   40.336199] Node 0 active_anon:384kB inactive_anon:6160724kB
> > > > active_file:204kB inactive_file:0kB unevictable:1530880kB
> > > > isolated(anon):0kB isolated(file):0kB mapped:1531432kB dirty:172kB
> > > > writeback:0kB shmem:612kB shmem_thp:0kB shmem_pmdmapped:0kB
> > > > anon_thp:10240kB kernel_stack:2576kB pagetables:33164kB
> > > > sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0k=
B
> > > > gpu_reclaim:0kB
> > > > [   40.336202] DMA32 free:34808kB boost:0kB min:11028kB low:13784kB
> > > > high:16540kB reserved_highatomic:0KB free_highatomic:0KB
> > > > free_mapped:11032KB active_anon:0kB inactive_anon:1487720kB
> > > > active_file:52kB inactive_file:20kB unevictable:393252kB
> > > > writepending:4kB zspages:0kB present:2096760kB managed:1991156kB
> > > > mlocked:393252kB bounce:0kB free_pcp:42404kB local_pcp:2460kB
> > > > free_cma:0kB
> > > > [   40.336205] lowmem_reserve[]: 0 5976 5976
> > > > [   40.336210] Normal free:34248kB boost:0kB min:34024kB low:42528k=
B
> > > > high:51032kB reserved_highatomic:0KB free_highatomic:0KB
> > > > free_mapped:34028KB active_anon:384kB inactive_anon:4672764kB
> > > > active_file:180kB inactive_file:0kB unevictable:1137628kB
> > > > writepending:168kB zspages:0kB present:6291456kB managed:6120144kB
> > > > mlocked:1137628kB bounce:0kB free_pcp:25156kB local_pcp:764kB
> > > > free_cma:0kB
> > > > [   40.336213] lowmem_reserve[]: 0 0 0
> > > >
> > > > As far as I can tell there's about ~65M of free memory stranded on
> > > > pcplists (in an 8G VM), which would have kept the amount of free
> > > > memory above the watermarks and prevented that specific OOM kill.
> > > > Although, as I mentioned before, this is a synthetic stress test.
> > > > Perhaps in practice it doesn't matter all that much in practice, bu=
t
> > > > it seems like the logical thing to do.
> > >
> > > yes, pcp lists are quite (unusually) high. Is it possible they simply
> > > got repopulated after the first direct reclaim run? Or is there
> > > something else(odd) going on?
> >
> > I think in this case there wasn't a lot of reclaimable memory (mostly
> > anon with no swap), so at some point direct reclaim didn't make any
> > progress. __alloc_pages_direct_reclaim() only drains the pcplists if
> > reclaim makes progress, I am not sure if that's intentional. An
> > alternative would be perhaps removing this condition, something like
> > this:
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 8d79f76cdd0e1..98e9079240ad5 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > unsigned int order,
> >         psi_memstall_enter(&pflags);
> >         *did_some_progress =3D __perform_reclaim(gfp_mask, order, ac);
> >         if (unlikely(!(*did_some_progress)))
> > -               goto out;
> > +               goto drain;
> >
> >  retry:
> >         page =3D get_page_from_freelist(gfp_mask, order, alloc_flags, a=
c);
> >
> > +drain:
> >         /*
> >          * If an allocation failed after direct reclaim, it could be be=
cause
> >          * pages are pinned on the per-cpu lists or in high alloc reser=
ves.
> > @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > unsigned int order,
> >                 drained =3D true;
> >                 goto retry;
> >         }
> > -out:
> >         psi_memstall_leave(&pflags);
>
> Ideally if we can make the function call less hairy. Maybe we want to
> make draining part of the reclaim as the last resort when normal reclaim
> fails.

Do you mean do the draining in __perform_reclaim(), or deeper into the
reclaim stack?

The thing is that __alloc_pages_direct_reclaim() currently drains when
__perform_reclaim() fails to make any progress and we still cannot
allocate. The change above makes it drain if it cannot allocate after
__perform_reclaim(), regardless of progress. So if you want to move it
into __perform_reclaim(), we'll have it in both places.

Or maybe I just don't understand what you meant :)

