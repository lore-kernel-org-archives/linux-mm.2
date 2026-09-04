Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B669C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C066B008A; Fri,  4 Sep 2026 12:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC766B008C; Fri,  4 Sep 2026 12:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBF36B0092; Fri,  4 Sep 2026 12:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C164C6B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:27:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4ADDA16014E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:27:13 +0000 (UTC)
X-FDA: 85176609546.21.9DDA599
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33F74C0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:27:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bTOp//JN";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788539231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r44+M//4DhylFOBUCmAtsCMDMPsNkoNaCuU6IAuNSxs=;
	b=f0o7j8fN4iWDwt/kRhyGHwVdRo4fewo6Tgn0lUt/t2DVs0Ebe13WOA2sRelVYk8SfpZltS
	eZXB3yM5EkEpajrE3P06SiR7e5GM1KssBRPzGvzBjbYFgSR9sFrJeZMohQPy/DkxxOITjT
	t/I7SCbnSBnom0kDmCzNwFfL91Zm9a4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bTOp//JN";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788539231;
	b=o8eblz0c4y+XruPm04dj+x9OgCn2COsPMvcphFxcz5k36eErY1inql+dE3muzQCuw7IcSE
	wamx45T2qb/Ow3w9jMCj67NTk4w5WaQk9fZciohMi26wupLUBxI/VBJbKYPNwHZ0myiMTm
	ykTPWaWCIB2Zdj3CUdqlPFuWyzhOy+c=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so14373035e9.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788539230; x=1789144030; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r44+M//4DhylFOBUCmAtsCMDMPsNkoNaCuU6IAuNSxs=;
        b=bTOp//JNjZ5Fd7Zvv7WpcMR9Ls3h3CRySL+pZ/YTROjZbX5XzWBUckvxI39kXTzmZI
         aLtyHinDAoT0eZfAgLhfq6xFubGMP8zKbXhjCueFUBLq7ETBLrLya+lo1R94MqKLISyJ
         RF7t5SBvJmKXSMb4dlQcicmAsJSbPCPsiAaq/FIqAicGf2WQI1AeVb01pjpUBuhiW1gV
         woiOdIMQYIse691T0C1rzFekd6rKaz2zjyPoQWQzs5AK3CCTDKfF6WlLmeYUeqbby+b3
         ZibZd+LdYKyXhVD5WRBUbU15nIRkKXa8Do/V2ccsGMm7BXKkStIx+FdOwXmmyxsFWS21
         MY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788539230; x=1789144030;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r44+M//4DhylFOBUCmAtsCMDMPsNkoNaCuU6IAuNSxs=;
        b=pA2gn5XSvPxBe+Bia8XSzroPBiug+pDdCuJ0lwwtTIuwgB/AjT64bOH8IBZffK+g+7
         awGOi/aumQeikFbz8afq6pODYJZwlgIOtoeBmG9R8OhMR0j4C45PSLmyr8jbTyXiapYW
         VTQG8qpCS+plBhnHZ6VR1cQTXnKVP5Lf3ftSl4Bqjy+bbBE0exolsTzUZUryQzk3Z7qP
         uYaj8W4K0msrVVdYItyZ++93VUSM//pel3O8nGafShMKFwkqZErw9FhGbiM0RtdtfBfd
         W4OlNa9NPdBdBHsLel8IZmPV83WyveByr2iYV7sBFysBDIf2J2KODEE3qsuk+vOd3clU
         iLtg==
X-Forwarded-Encrypted: i=1; AKwUvBwtz3aryBAe+6EkzOw6lZXFcf/Z++UaSSAu8rqQWAtwnS1rbDMyahN5g9KifXmRhs6jrjtB3ASc2w==@kvack.org
X-Gm-Message-State: AFuF++mvG2YdO+TIKWSpVBZKmYqJzvhFpiI/A+pNTTHNowdQFy8fRLZD
	ztsiYaJcwXo3yL+hbzSTDR4Ss0AYzJJsfF6K5UcfhwOpdIT9BcfCTHUrpchnphuJpVM=
X-Gm-Gg: AYBFou0PicQ7eRvXCa9zeQyd8U8BH8cgawycg6Wbaf0Y+2nn/7Bfbu8eNqddFDCr00W
	ix/IMQZvXEvobOOB9XQb1ZP/mQMUP0GDyXFhTTwtgkLh3Y77dlFvwFaK15DbwMNAkG/tTr3xf4T
	8Uek30lg0K6DwkBVawRB6xprnOg4DmEFWdfMVTyVAATsxaQZfFps7Vq4Rj9QWRQnKHxRDl9DEhK
	sNKUPPCCVgRSOG7yTNl+nJLFRGP7/Jdu45/UJd12/xCIPtRzvBy0HGW+T8AJPisoNyKwHmItGVF
	SmkaCWurEEI0Q+3KF8iPfoWDDgHPFg5llHlPZjnEC/yUNhlpE+NoB9c+sLiqGAUGf0MdkriI/Fr
	Ta6I8/9opIv+UJCjq8uc2aJkyGWuf48xvG1f2xA0XAr5W4zMahI2tJJf4PnscqoQNnJEYiUL0lO
	9sI14jGFS8z5XV1hXEJLUFGqd1MheDCOZeUz84kIduQ7EBtSp8ZMzrlHVvWQkXfHk/DI2V5MJFO
	A==
X-Received: by 2002:a05:600c:190b:b0:49c:fa21:e743 with SMTP id 5b1f17b1804b1-49cfa21e92amr53496425e9.25.1788539229587;
        Fri, 04 Sep 2026 09:27:09 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cff8195ffsm20600285e9.14.2026.09.04.09.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:27:09 -0700 (PDT)
Date: Fri, 4 Sep 2026 18:27:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>,
	akpm@linux-foundation.org, mgorman@techsingularity.net,
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org,
	quic_pkondeti@quicinc.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <aprxXHSh-LyqaFCW@tiehlicka>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
 <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka>
 <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33F74C0006
X-Stat-Signature: s4fdukappe941gq4ge97x5ghkudtxy8o
X-Rspam-User: 
X-HE-Tag: 1788539231-424819
X-HE-Meta: U2FsdGVkX1+pKscREV2/Tc8z0N8DoXe2bPZiSS4TZnEhNbrXny+7aCLWPjp50d0jouylTErRNYFPzAEK2/hRso8jjyUmP3/nYxVLdql//jYhwkWx7Xq8Ruja1rLjWMSOUsSw/9ySvor8v4Lm+OFqRYCG4xlNLSf5qe8gi1Eh5pWI4T0+Ma2z2vdzQ88UKNWq8x0hB/hSJXHL/kYZK7ia5pMeOAQ8ykeJuA9h/lo1MC9dYEMEUEEsdZ+FWNxK1Ml12RFKG2F38aen+c4MTcITulvR6R/h15ONkU3zFcFKUcENL/SH38zbyeB3mCYu81v/xMAeecvI9oIb+dGEKebYLJyM5Fly74VtBItw0vncLS/j1ZAlIexrkXoVNMuXOmQZDldudHV20ISBFrTm3ZqmstqkKQXigjfhkCVf/sPRZf4sAkJaLbcN7Y4kbmDqu+ZqXqH+xghEHPy80eQce48E1/igekjhCntxJ5jEIFmSqlUu2Niko76PpwE65r/FZng0EI8Oqm3jPrXl0NJ7qrV5RKLaA4shjgnuf1nCbCmJuIr1hw6axzOI4506Z15c9GS6/5ugBVFct9VX5QHapZnChrdhH+BK2QKroQl7vyuznq7Uhtjv+vD5rjRnt0U8WvH/n67vtLD5sNzhj+/ZIKgNTJ1+ijn43GqarjHKy5o8cE1X/VCT2u+dL/Z2CDVWIereQbOXytbOmOssML9PrgdxWC08sQTUbwmqSE+X4OIoVMYMiIgqzisCQeJkM97VGv1txByy11tnkIuBXoGlx/c/EPOatxIYxpgCOmrodZLWvKQHC2TyuFDypxMkx3U2qs5gSDzunoZYzZEaDV4r4nK7Lm3QRL/Gx5FI71iwVUG/8GhLUXugX1J/zPmuOqL/3JelRCWxtzYU2WTc83npzzj4XIEn/0+SQdLMUkeaAbuDyH+ucM2xbFuW0THS3bxJD+/sxMsE83S70nkY+UF0XJZ
 1dNudlso
 3/l4MmzLNTsmljNZvfTDCkdHHPzDESQ3f2T1MPliBZj0Ldmh6WTTH/PaRJ0yNsg9L00+e/PcUiWNABj/D9APG3p2yiyb5kgkmZjZSDRh5zBwaMBfuriqkzT338r8CSVVbVy0HByUvInv0rk+Q2jhORiCboaXAkmkFLl82NbC6JbW3oTyPlc7lhL9/lB6olqsRwlDoqVYcmSOhOI6p4PZ2Ge3bweh+TqecEusrfBf3rXlRcWTHuTiQxUf3oWgL7FtgqejQCVw8nP47JTDI9qj76G3peTwPvqSpqyfoKt+ftOABi9jY7wqXUmOhbUhzqPM1KdSg3lihbCrk2m3Z1DttUf+N8Xw+zaMIF6VSjKQtcKf72QYEdrYQc97o/+K/PNqOjPfBw8EtexHWHLxXzn67GYwPy+2R2LZvCGF7IDj4ag7f8qiIrChhc4ReovHHD6EFU68PEUQrX1IfV7gfFrwXhz4jDlo2qgYIVr5HRKlbKHTFcV1zYPGwykZG0xcb2V1T+tohcCk/m1HYP4yef468MVEkjSTv08KoO2x6ZauK0o38iHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 09:09:35, Yosry Ahmed wrote:
> On Fri, Sep 4, 2026 at 4:21 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Thu 03-09-26 07:03:33, Yosry Ahmed wrote:
> > > On Thu, Sep 3, 2026 at 12:27 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> > > > > On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > > > > > pcp lists are drained from __alloc_pages_direct_reclaim(), only if some
> > > > > > progress is made in the attempt.
> > > > > >
> > > > > > struct page *__alloc_pages_direct_reclaim() {
> > > > > >     .....
> > > > > >    *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> > > > > >    if (unlikely(!(*did_some_progress)))
> > > > > >       goto out;
> > > > > > retry:
> > > > > >     page = get_page_from_freelist();
> > > > > >     if (!page && !drained) {
> > > > > >         drain_all_pages(NULL);
> > > > > >         drained = true;
> > > > > >         goto retry;
> > > > > >     }
> > > > > > out:
> > > > > > }
> > > > > >
> > > > > > After the above, allocation attempt can fallback to
> > > > > > should_reclaim_retry() to decide reclaim retries. If it too return
> > > > > > false, allocation request will simply fallback to oom kill path without
> > > > > > even attempting the draining of the pcp pages that might help the
> > > > > > allocation attempt to succeed.
> > > > > >
> > > > > > VM system running with ~50MB of memory shown the below stats during OOM
> > > > > > kill:
> > > > > > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > > > > > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > > > > >
> > > > > > Though in such system state OOM kill is imminent, but the current kill
> > > > > > could have been delayed if the pcp is drained as pcp + free is even
> > > > > > above the high watermark.
> > > > > >
> > > > > > Fix this missing drain of pcp list in should_reclaim_retry() along with
> > > > > > unreserving the high atomic page blocks, like it is done in
> > > > > > __alloc_pages_direct_reclaim().
> > > > > >
> > > > > > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> > > > >
> > > > > [Sorry for thread necromancy]
> > > > >
> > > > > Hi Charan,
> > > > >
> > > > > Are you planning to respin this patch?
> > > > >
> > > > > I know that Michal was questioning the need for it. While doing some
> > > > > stress testing I came across a couple of OOM kills that had significant
> > > > > amount of memory in pcplists. Something that would have been prevented
> > > > > by this patch.
> > > >
> > > > Could you share some numbers to see the scale of the problem?
> > >
> > > Sure, here's a sample from an OOM log (ignore mapped/free_mapped, it's
> > > from the ALLOC_UNMAPPED series):
> > >
> > > [   40.336188] Mem-Info:
> > > [   40.336195] active_anon:96 inactive_anon:1540181 isolated_anon:0
> > >                 active_file:51 inactive_file:0 isolated_file:0
> > >                 unevictable:382720 dirty:43 writeback:0
> > >                 slab_reclaimable:20339 slab_unreclaimable:26597
> > >                 mapped:382858 shmem:153 pagetables:8291
> > >                 sec_pagetables:0 bounce:0
> > >                 kernel_misc_reclaimable:0
> > >                 free:17264 free_pcp:16890 free_cma:0
> > > [   40.336199] Node 0 active_anon:384kB inactive_anon:6160724kB
> > > active_file:204kB inactive_file:0kB unevictable:1530880kB
> > > isolated(anon):0kB isolated(file):0kB mapped:1531432kB dirty:172kB
> > > writeback:0kB shmem:612kB shmem_thp:0kB shmem_pmdmapped:0kB
> > > anon_thp:10240kB kernel_stack:2576kB pagetables:33164kB
> > > sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0kB
> > > gpu_reclaim:0kB
> > > [   40.336202] DMA32 free:34808kB boost:0kB min:11028kB low:13784kB
> > > high:16540kB reserved_highatomic:0KB free_highatomic:0KB
> > > free_mapped:11032KB active_anon:0kB inactive_anon:1487720kB
> > > active_file:52kB inactive_file:20kB unevictable:393252kB
> > > writepending:4kB zspages:0kB present:2096760kB managed:1991156kB
> > > mlocked:393252kB bounce:0kB free_pcp:42404kB local_pcp:2460kB
> > > free_cma:0kB
> > > [   40.336205] lowmem_reserve[]: 0 5976 5976
> > > [   40.336210] Normal free:34248kB boost:0kB min:34024kB low:42528kB
> > > high:51032kB reserved_highatomic:0KB free_highatomic:0KB
> > > free_mapped:34028KB active_anon:384kB inactive_anon:4672764kB
> > > active_file:180kB inactive_file:0kB unevictable:1137628kB
> > > writepending:168kB zspages:0kB present:6291456kB managed:6120144kB
> > > mlocked:1137628kB bounce:0kB free_pcp:25156kB local_pcp:764kB
> > > free_cma:0kB
> > > [   40.336213] lowmem_reserve[]: 0 0 0
> > >
> > > As far as I can tell there's about ~65M of free memory stranded on
> > > pcplists (in an 8G VM), which would have kept the amount of free
> > > memory above the watermarks and prevented that specific OOM kill.
> > > Although, as I mentioned before, this is a synthetic stress test.
> > > Perhaps in practice it doesn't matter all that much in practice, but
> > > it seems like the logical thing to do.
> >
> > yes, pcp lists are quite (unusually) high. Is it possible they simply
> > got repopulated after the first direct reclaim run? Or is there
> > something else(odd) going on?
> 
> I think in this case there wasn't a lot of reclaimable memory (mostly
> anon with no swap), so at some point direct reclaim didn't make any
> progress. __alloc_pages_direct_reclaim() only drains the pcplists if
> reclaim makes progress, I am not sure if that's intentional. An
> alternative would be perhaps removing this condition, something like
> this:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8d79f76cdd0e1..98e9079240ad5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> unsigned int order,
>         psi_memstall_enter(&pflags);
>         *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
>         if (unlikely(!(*did_some_progress)))
> -               goto out;
> +               goto drain;
> 
>  retry:
>         page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
> 
> +drain:
>         /*
>          * If an allocation failed after direct reclaim, it could be because
>          * pages are pinned on the per-cpu lists or in high alloc reserves.
> @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> unsigned int order,
>                 drained = true;
>                 goto retry;
>         }
> -out:
>         psi_memstall_leave(&pflags);

Ideally if we can make the function call less hairy. Maybe we want to
make draining part of the reclaim as the last resort when normal reclaim
fails.
-- 
Michal Hocko
SUSE Labs

