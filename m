Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3DAC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044C36B00AD; Fri,  4 Sep 2026 12:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38666B00AE; Fri,  4 Sep 2026 12:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DE06B00AF; Fri,  4 Sep 2026 12:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B99BE6B00AD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:09:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52D7BC014D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:09:50 +0000 (UTC)
X-FDA: 85176565740.18.167D730
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 66BA4180008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:09:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VOYe2PR3;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538188;
	b=R6h8MZWzHtMe/VKK5F6yxmLGnLzxNbsGkiCCAtpQ7gYs2Ya/XAC6Dw9nMQtBoRd5bSvtPi
	JynA7l6/816UB6drkFNFYr1nem9eBdHhpOR25LqtUS7KepTF3hDztr5d23YUu6iTllqIQp
	HNcfcjZsguDjMxrE8jpGY6WrOClPRCw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VOYe2PR3;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eeq1cCGbIWkkHc8XN84l/PkE/s3OPAx4E/DdJKyKEcM=;
	b=PGQPlUxaZmeUpkZ5RtxqUaJoO+oRs3gFdO4qc9rruBngMHraPL5xrqNEyjV8BrIocofTIb
	JpTTRAMJ6O7Vs2DFz6UaepxV7Pt+kFOp+uEg6P+7+3925onMGYevZ4M+YbYBAjAPOOoJYf
	u046IMSwcBicb1Myv5TFbcnpH2j4ydY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F1A243822
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDFE1F00ADF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538187;
	bh=Eeq1cCGbIWkkHc8XN84l/PkE/s3OPAx4E/DdJKyKEcM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VOYe2PR3MDiMotRQLT7leWQ2WJJprtf6szl2QmGCnwpsMPNduyy5iI4sE4U86VJAL
	 VCUT7yTGxb6+dQmdmCxfM+9Fk4uWK25UBCH8MLtV3Pn1QyN5lmIG8sHYZuVSGQQikI
	 wLfO3JHOlKD8HFz4OluR+8zmcmQf0IzKEWnSlJEhM6NZG7CXJtIzlLtYD2buSAqLOk
	 Lu1JE3d7U+GmLygai1R9RQxvBA8KtF3fj1Jazu2M3xNiHZcfeA2e/4FDG4OXtT7++9
	 /AB35hSJlxt0IPLv34h1e3iyHEYSq3AYs2n6CvKSm7MIjPQzYJQL4HOu0qZ/0YzXJV
	 UvlHEbVrOS2nw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c197e7e4e94so203042666b.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:09:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzL/tAwBDHhVExcBftyRl6W5FJW7mq5fr8PybLi7SyzAhKTqXKMcC/6zgweBUssGX77IDcB/wJTGg==@kvack.org
X-Gm-Message-State: AFuF++mvES+BmMVc8f+baZ19Tr7+iJxLaU7M4jNuPJye3TB8tNoPOZP5
	ZoguEeoKsv2gLulVcGdkMpKNdQgq4EYdgX7Mr0RadJm5KKnqOx/blN5OX5b3kD9HeqsP2uxSeD5
	WuMxFYSIaFIZBCP3GgJj0X1GbDBkW/oE=
X-Received: by 2002:a17:907:6c0f:b0:c26:19de:9ac7 with SMTP id
 a640c23a62f3a-c2619dea67cmr159398866b.31.1788538186259; Fri, 04 Sep 2026
 09:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com> <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com> <apqppFukssaAQz3w@tiehlicka>
In-Reply-To: <apqppFukssaAQz3w@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 4 Sep 2026 09:09:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
X-Gm-Features: AcwNN1UI8vVflFBHpjQw18qMFlO-gIfm7g3j2hfRTedEMhop9xXtUozwNzZigZA
Message-ID: <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
To: Michal Hocko <mhocko@suse.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org, 
	mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz, 
	hannes@cmpxchg.org, quic_pkondeti@quicinc.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: apwi6u988wrbcqocqiz5jqdu6htfbpnu
X-Rspamd-Queue-Id: 66BA4180008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788538188-142428
X-HE-Meta: U2FsdGVkX1/WGPZ865ySEzglfO96J+IwdjMueKRBGjewEQy8oCn64Kw7nSRLAf6ROOg0NQgFUwWSa3NOQTqZwuPUItIAkg8HU0jBT41ZlvrdhFZXWvu/J1BYm2HKXxUmASp7GnANabvm0z/m8uHoOdoJC9UvsCa/eDu8e7kbI1VMOlAKbD6r7FXdSBU5PIon3CDWV+zTO1fqfFWHhb0SrgMZwfSLnohWFDftEYde0Lu2lOzcYGglLBa9/zpvoJVUxxaP/iPzgY8QApqqJQ7YgTwHgmR1dzTr5e3SE5EEEx/u7EgGT9oLJ/CK5umnYiJkMymbDIwmX1csmj8LYEMHGlc6AcatBXXngo0HuAPV89BQPVKoSaeY0te6Q2vtb9jTCVkY3XSuvJGbTyNjdvPXiPgH8KKmai2yGkEjtMEW2wi7SRcqBWsgKMIeUCNvTZ07MiUSJvLkNvkD2ie0cUaxMd9lDB4g7cnKOQYWx00tOmxIJPhktir3t/capIJe0QMPOgc8H13aBAputB7AalC+ky2evKRpcvT5R0Ur/5iPI0O4hcsk8taDkeEmKmTPc7Cd7G7YcMGHz3K6r2a3PjAoIIls5qS7zyymgsGyNX0/WH/5NkK/B867wD9uswqtG4NhiSzbLOhzYoLOJqKRYRKqy2PgJPAvP8JEhkSNq8DQG4DPMefzyfh2R/xldB3R8zxaCwmEwKC5C+tqY60G6fwwd6QvAjEIuPwWTbC0HZduBgmT0UCL+Esn5pwiYpzGtDZcTmu3FcR5fD3XIgV0TakEJQ/X5gNksHvPs25kTJdYtp45fj0z/p9fp1pMAzpJvNJVlTT+e8+PeCOF6qdaCRbb6/lBlpfe5VtAzqRWPe9iNZX6MEmNBtlQUcTuJbnSVj18Pa71MNNrtLn40IyKVftB2JIcgTJt41FulfYOcZg9YTZInlG/ybHX7xAQGCxI7hLyZCNKDVBGdhUVzpDhgwq
 TSgh1C3h
 tfMpBYuqpD8rSazr4r+jJw4uymTOByc1B8SkuqcEgX5730oC0VwZayzdI/F4/bL/AXyOJgD26ZwR2hiEmYiLl4j635AlPbdSiLHH//qsYI39uK9L+e51LRJGSIFnQQOYLF53mOUIktPNUq3YZfG9mLlFxa3lP3918C+husWuWChrbwV4OAXkJtmmvHEPanjX0zV2JKAjgXf1x2yKNkdrrxenBccDM43Qfv5z6uDx99fSGPeQOFpwKsAAn9QIyhTbcwooGety6KLHrKcPt+H/ZvDikzm8fdXUGYYnc0X+T7ahb4O6hjvpQOvVNa7A4ydXIBfJPLaOXxVIUclvzuz2lpIoCcrGjkG1UALoNSmqPbOmtpSE6dQmCF86AHj+1xTGLICNablDMqkN6Rf+dMC4bHr1v+ejx4Fq78EKDwc14CgXb1wV6MZTQkq6gyeOL/ntF+1Pn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 4:21=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Thu 03-09-26 07:03:33, Yosry Ahmed wrote:
> > On Thu, Sep 3, 2026 at 12:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> > > > On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > > > > pcp lists are drained from __alloc_pages_direct_reclaim(), only i=
f some
> > > > > progress is made in the attempt.
> > > > >
> > > > > struct page *__alloc_pages_direct_reclaim() {
> > > > >     .....
> > > > >    *did_some_progress =3D __perform_reclaim(gfp_mask, order, ac);
> > > > >    if (unlikely(!(*did_some_progress)))
> > > > >       goto out;
> > > > > retry:
> > > > >     page =3D get_page_from_freelist();
> > > > >     if (!page && !drained) {
> > > > >         drain_all_pages(NULL);
> > > > >         drained =3D true;
> > > > >         goto retry;
> > > > >     }
> > > > > out:
> > > > > }
> > > > >
> > > > > After the above, allocation attempt can fallback to
> > > > > should_reclaim_retry() to decide reclaim retries. If it too retur=
n
> > > > > false, allocation request will simply fallback to oom kill path w=
ithout
> > > > > even attempting the draining of the pcp pages that might help the
> > > > > allocation attempt to succeed.
> > > > >
> > > > > VM system running with ~50MB of memory shown the below stats duri=
ng OOM
> > > > > kill:
> > > > > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > > > > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > > > >
> > > > > Though in such system state OOM kill is imminent, but the current=
 kill
> > > > > could have been delayed if the pcp is drained as pcp + free is ev=
en
> > > > > above the high watermark.
> > > > >
> > > > > Fix this missing drain of pcp list in should_reclaim_retry() alon=
g with
> > > > > unreserving the high atomic page blocks, like it is done in
> > > > > __alloc_pages_direct_reclaim().
> > > > >
> > > > > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> > > >
> > > > [Sorry for thread necromancy]
> > > >
> > > > Hi Charan,
> > > >
> > > > Are you planning to respin this patch?
> > > >
> > > > I know that Michal was questioning the need for it. While doing som=
e
> > > > stress testing I came across a couple of OOM kills that had signifi=
cant
> > > > amount of memory in pcplists. Something that would have been preven=
ted
> > > > by this patch.
> > >
> > > Could you share some numbers to see the scale of the problem?
> >
> > Sure, here's a sample from an OOM log (ignore mapped/free_mapped, it's
> > from the ALLOC_UNMAPPED series):
> >
> > [   40.336188] Mem-Info:
> > [   40.336195] active_anon:96 inactive_anon:1540181 isolated_anon:0
> >                 active_file:51 inactive_file:0 isolated_file:0
> >                 unevictable:382720 dirty:43 writeback:0
> >                 slab_reclaimable:20339 slab_unreclaimable:26597
> >                 mapped:382858 shmem:153 pagetables:8291
> >                 sec_pagetables:0 bounce:0
> >                 kernel_misc_reclaimable:0
> >                 free:17264 free_pcp:16890 free_cma:0
> > [   40.336199] Node 0 active_anon:384kB inactive_anon:6160724kB
> > active_file:204kB inactive_file:0kB unevictable:1530880kB
> > isolated(anon):0kB isolated(file):0kB mapped:1531432kB dirty:172kB
> > writeback:0kB shmem:612kB shmem_thp:0kB shmem_pmdmapped:0kB
> > anon_thp:10240kB kernel_stack:2576kB pagetables:33164kB
> > sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0kB
> > gpu_reclaim:0kB
> > [   40.336202] DMA32 free:34808kB boost:0kB min:11028kB low:13784kB
> > high:16540kB reserved_highatomic:0KB free_highatomic:0KB
> > free_mapped:11032KB active_anon:0kB inactive_anon:1487720kB
> > active_file:52kB inactive_file:20kB unevictable:393252kB
> > writepending:4kB zspages:0kB present:2096760kB managed:1991156kB
> > mlocked:393252kB bounce:0kB free_pcp:42404kB local_pcp:2460kB
> > free_cma:0kB
> > [   40.336205] lowmem_reserve[]: 0 5976 5976
> > [   40.336210] Normal free:34248kB boost:0kB min:34024kB low:42528kB
> > high:51032kB reserved_highatomic:0KB free_highatomic:0KB
> > free_mapped:34028KB active_anon:384kB inactive_anon:4672764kB
> > active_file:180kB inactive_file:0kB unevictable:1137628kB
> > writepending:168kB zspages:0kB present:6291456kB managed:6120144kB
> > mlocked:1137628kB bounce:0kB free_pcp:25156kB local_pcp:764kB
> > free_cma:0kB
> > [   40.336213] lowmem_reserve[]: 0 0 0
> >
> > As far as I can tell there's about ~65M of free memory stranded on
> > pcplists (in an 8G VM), which would have kept the amount of free
> > memory above the watermarks and prevented that specific OOM kill.
> > Although, as I mentioned before, this is a synthetic stress test.
> > Perhaps in practice it doesn't matter all that much in practice, but
> > it seems like the logical thing to do.
>
> yes, pcp lists are quite (unusually) high. Is it possible they simply
> got repopulated after the first direct reclaim run? Or is there
> something else(odd) going on?

I think in this case there wasn't a lot of reclaimable memory (mostly
anon with no swap), so at some point direct reclaim didn't make any
progress. __alloc_pages_direct_reclaim() only drains the pcplists if
reclaim makes progress, I am not sure if that's intentional. An
alternative would be perhaps removing this condition, something like
this:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d79f76cdd0e1..98e9079240ad5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
unsigned int order,
        psi_memstall_enter(&pflags);
        *did_some_progress =3D __perform_reclaim(gfp_mask, order, ac);
        if (unlikely(!(*did_some_progress)))
-               goto out;
+               goto drain;

 retry:
        page =3D get_page_from_freelist(gfp_mask, order, alloc_flags, ac);

+drain:
        /*
         * If an allocation failed after direct reclaim, it could be becaus=
e
         * pages are pinned on the per-cpu lists or in high alloc reserves.
@@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
unsigned int order,
                drained =3D true;
                goto retry;
        }
-out:
        psi_memstall_leave(&pflags);

        return page;

