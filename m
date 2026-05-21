Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED50ACD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524186B008A; Wed, 20 May 2026 23:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADCF6B008C; Wed, 20 May 2026 23:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375466B0092; Wed, 20 May 2026 23:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236466B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:46:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2C441A04C1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:46:09 +0000 (UTC)
X-FDA: 84790038858.03.90D3A20
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id EAF4B80003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:46:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WVr0Lr8R;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335168; a=rsa-sha256;
	cv=none;
	b=vrvJiXvrYSyjssAi3Mo3x+XYH8Dni+pMvp0i7pd3i+S9AhdXlb2VKFEt3qmrdGEhBXGv1k
	ENGUVoW6l3yYxEEgFTwCX1kdw/3K9gcQW9BMZS94geLXB9seD27Tf1GK11N4J0Xt/j8XKt
	t+YF0OWF+kBZnumEnoF8Mug1Nzq2GTA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WVr0Lr8R;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEBQggBlYt3BpKFY9Kg3q0PYXokZZ4ieOXENn/+MaCo=;
	b=wHbx9zo0KtKhDH8FZ9aZ9E65754F+P+2za19c15yYuZ45IB0LkbTJMRwIf5zhxeQ8jUP18
	8XhyzS8A+rv4C4HrW3K/7NbpIoFhKLE1z7ksusNXEjJMmf9F4Cz2C634keOECPlXfrrgoL
	4ri61rebmxhrKC/yYBVVc+xrL/zYB4Y=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dcdd1b492eso5709840a34.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779335167; x=1779939967; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEBQggBlYt3BpKFY9Kg3q0PYXokZZ4ieOXENn/+MaCo=;
        b=WVr0Lr8RCXiGtmemRFNvZwkY93u9SlDDXGFZoGI9B+OKN1++AP/S54td7ZBp9ogYFw
         /6TTlJAXhVVJJhDQ8GjIJodNBiHEgl/QRtRzKpg4t41Sr5iax0l+g5wb6tIpjxzH8plr
         aYbVak+lp+tFnlVq6eYQyrSZ1KTZeiqxC66SabVcqV6cG64CL3y14zOht6r5jq353EUu
         RQ38Ki3S3mnfkBUM9VDvRvctItsiN5Ro0HAs0LPRN7JPRePIdZtXEOSqX95SxeJRscvj
         E34M3JRd8zgBQnp/wTrPVJUtgRDONmXrASvr1NOHUw1XyKwpQqdr11i20jqoBE7F+aFn
         +n5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779335167; x=1779939967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zEBQggBlYt3BpKFY9Kg3q0PYXokZZ4ieOXENn/+MaCo=;
        b=D3cXaGucOEXBvHTCq6kVdoala+isyx/2fpnefPmIfRB0Z9DtvO1Y83zxbG6IbjmIy6
         TPp1q2RJJzVMhD0QS0MnCgwJhuZlKG7NuO74JjRvpTkvqmGbh5mK1YIf3p1IEphtyQU6
         rqCneWVQX2PH5g0NiWjJHenF2fdZVZVO9eikEUEQTT284gVevZkfU0OQ6zZQ1aoOA2vD
         /8IRNZZD6PmLnl2+iDkRhXwvba/mDZlmgTXJ8Je/Z9XPdtrOEHO/oX9U1/DwtrAcv8nE
         nSQl6YLhtRidWz07Ehsx4PErZTAvNfGpIEEbx8UW7hTvGhN/epxoRrEJNA5QJpdPcxXq
         Uchg==
X-Forwarded-Encrypted: i=1; AFNElJ9JTzu3vN1y3pMjcMRXXbJvaNAYI8Bf3SerqE8pa5gXWaQ8YvYNvsa9vJ2I+Vk2Mkpqc35bo8ilnA==@kvack.org
X-Gm-Message-State: AOJu0YxTXJIWrplLD353IjURFfRDaVYG9CrFb3VHqnXmCP7WmgE5VeSs
	hAKa3AT8rlZJWROGyvpb+otDT7dy1Ft8t213XmhCQJHQW/KoLEyQSiat
X-Gm-Gg: Acq92OEUK18QZNXxCv4ymhqGwnJCR4BMZ7WnhMj+EVzc2VOqTTtbV6wAHa/2DFKKFkM
	sdhO9MynDYw/uIb5+OgRa4yNa7/+eTEb3VBMADWoJQCAJuQCEZg9YmkJq11tdF38EIj9UCKDg7p
	dUzQGk6YDU+uo/o2hP6VwmyEQpQAz5yaHJJKeQEg7hQJ8Y4vBwv7Ma/3zYykhWzcySpu5tG5nS2
	/Gum8dSonLRrPiTewYCSFTWNonwJHBrzX/gyijL4iXALb5MSsu4/gL0Ez3BFBBpFeuHGXykGy2n
	ODe+bI5DgvcJ0WKDQQ1hAWLKuyTL9Cm7DKYcRCEzBqoBNSEynZcR2GRIVTEnfYJ6enm9gnQLuPK
	5plfvAhCbt9ZolLlIl4qrM8q1M6ylcFjoDi0BYlI90oDGnClJxIL8LJwmr6e/sbCAlxGdE83qC0
	0TjzPDTQXsfigLA7POeFqGWnmX/CI6wN4dlbVIIxPfiU6DsVTQZqYmaQ==
X-Received: by 2002:a05:6830:18fa:b0:7dc:e059:c25d with SMTP id 46e09a7af769-7e5ea0e7ddcmr512971a34.0.1779335166967;
        Wed, 20 May 2026 20:46:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4749esm14591959a34.23.2026.05.20.20.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 20:46:06 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 0/8] per-memcg-per-node kmem accounting
Date: Wed, 20 May 2026 20:46:03 -0700
Message-ID: <20260521034604.4126295-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <7e28d0c9-80f2-420b-87c4-55e571071059@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EAF4B80003
X-Rspamd-Server: rspam03
X-Stat-Signature: f436nuj6eebjghk1n4mjqonqspp87gow
X-HE-Tag: 1779335167-150497
X-HE-Meta: U2FsdGVkX18JhHOT6E95JBL8WOlJ5n5EQwtP761Dzq1LUxZp1NjaJ40ywfg+DgioQllIUOwoSe9ATyckG2u8pnjA8PR5icNOyXuFd1wOtqB29v01i8fiswW5MEriB84AWDfaKLm3c2GPvs/byWfUOfJxpFcfv3c4pVjHC4wxDm73aG7lmVYgboZufgP13DpzJzbjjzA0VqfIa6ulepifLmsDBtLxTHcjdAm3MMSVjI8/k75L7iO4R48KJdS8Akft0AbW20xsk73DyoOEKwNJh3/VYggoow5sIXhX4ybQjKRhmlp39HXwEU7/qr4YhabpIKpO/p1741p4oiQx4+hHWkuNEHfUvg8kuIYDGdTUVFOXFcaavG8OJjMjKy771spJN+8OK/kCYEpr2W3WIcJo2wc77JJtmf7t2Lp/gkEFLrzYL0POM1ConYIxRbUhAB9QpoZnBNCo3m3C7j5yc47pwbypAiIfwQ73qb1x1tF/srT9wRCSiXOlCTtxAfwykUtOOhRKCOUd4MJdW3Txf6qTXT1PtORPNIROo27wce4tuS3T7XtCNwYNRWCFv3J/01DqeyytocpM6RJlwM90poGZiunNAjcO8oDpzmF4NISuw7DzIDGwGUaB24/GJ1uHDsikF4kd89hP/fI2ivNEk/CQZr613XX7ie30NTXfj8gId4h3oVk/UBTXvMtyQfDIgfaeMQaEivf21BkCy8ELU3un/jKmIg/+0t0NDmyABrpvIg/nNYrW5+SwPlT8HRVx1lpSqoFyapvHgIFzFHNtfXzDrLvuDlWT1U0Ekrm1SbkTzh/IDtM2eGHqGmUP5S7B0+VspatT3JE6T6Rmwjk+tyV3MnnM8XTP6GEEso5z4g2qu1pwySIanfIn61iEsGrmxsX7RkeQzwCzV5MFNSoOQIvNdXzqk+IkEd3fDpF02hFED5a175CP4j9E8E+PXKiGCZu9yk0JAdd6mE7xnumiTvB
 nmw88863
 kzqyfIE3JV0v673maqTUi0YzYWS1aTA1Jjtoar8Vac6XUZWfEtZ6ERJl2l8ddyziuy+Cb0bz420NY3J3rVyjq859pnl1kI6to48Dx9kqitP+SIHlg0ygo6d5AAeMh6yO/6XlBz+0xEWgenTgAr9cy6Otp0tMLsV6d9uP2+FF7u4dBOnsm+TbXlJi90r99ZYhy5UvwWXW/hS5ITZwoFPssFpzpT3atvxvjUw+dqdhv3GasyWZE18gbm9v43QFyYn0ssh69hW2Cw/M4kk4gspUUlz9XqQMFVikN3cWSPwLqgbHB8FlLNQvg0KtSLuCVTIzYgvq7XsU+ZV2easUOPIF33vQHJVI3/v47w7ftb/P/PcxB4M5xbM2n7tHOt0flVy53D59Y5TsrxGcIwtBzmimEkyVI029J2ngusT/TolwjtT1m4AdUy1JXUPZfUyt630BO2DPNxsddAu/VRSq1ZNCvDIrjlunIoA6t9Cgaty6JH6FaqTbv6qcSPLR1bXnv+Etai5/zC+4NVuJpoTnB4LPD1iEowNU/yncmOx9c+UI73fgo8gM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 10:39:59 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Hi Joshua,
> 
> On 5/18/26 16:57, Joshua Hahn wrote:
> > On Mon, 11 May 2026 22:20:35 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
> >
> >> This series pursues the work initiated by Joshua [1]. We need kernel
> >> memory to be accounted on a per-node basis in order to be able to
> >> know the memcg and physical memory association.
> >>    
> >> This series takes advantage of the recent introduction of per-node
> >> obj_cgroup [2] and makes those obj_cgroup tied to their numa node.
> >>    
> >> The bulk of the series is percpu per-node accounting: percpu
> >> "precharges" the memcg before we know the actual location of the pages
> >> it uses, so charging and accounting had to be split. All other kmem
> >> users (slab, zswap, __memcg_kmem_charge_page) are straightforward
> >> conversions (zswap support is limited in this series because Joshua
> >> is working on it in parallel [3]).
> >>   
> >> Thanks Joshua for your early feedbacks!
> > Hello Alex,
> >
> > Thank you for your work!
> >
> > Overall I think the direction makes sense to me. Pre-overcharging makes sense to
> > me as an approach, we would much rather overaccount than underaccount and
> > later have to breach limits.
> >
> > I do have some concerns on performance, though. Namely, I think there are
> > some expensive operations that I think would benefit from some performane
> > benchmarking with this patch added (maybe some simple microbenchmarks that
> > demonstrates kernel allocation overhead could be useful).
> >
> >  From what I can tell, there is some additional performance overhead that has
> > to do with iterating over num_possible_cpus() x pages_per_alloc, which
> > doesn't seem trivial to me.
> 
> Indeed, let me microbenchmark the overhead on a large system.

Hi Alex,

That sounds great with me : -) Looking forward to the numbers!

> > Another concern that I see is the stock credit system. Maybe we could be
> > bypassing the stock check leading to more time spent doing the atomic
> > operations.
> 
> I'm not following on this one, which atomic operations do you see that 
> could be bypassed?

So in my initial scan of the patch 7 I had a concern that if we have a nested
stock system (obj_cgroup stock and local credit "stock"), then we could
incur more work if these are out of sync; do extra work in the stock refill
path in obj_cgroup_precharge, and then do extra work on top in the loop
within the pcpu_memcg_post_alloc_hook (obj_cgroup_account_kmem does the
charging atomically I think).

So what I mean is, I'm not sure what the "size" is typically for
pcpu_memcg_post_alloc_hook. But it might be a worthwhile optimization to
do precharge all the pages, then for each cpu iterate over the pages to
figure out how many pages are used per nid (doing just math, not actually
doing the atomic adds), and then outside both of these loops just iterate
over every nid_objcg once to perform the atomic operation.

Maybe this is needed or not (depending on how big "size" typically is
and whether we go from doing O(1000) atomic adds --> O(10) or some
big reduction, but I just wanted to toss it out there as something that
could potentially be expensive.

> > obj_stock caches a single obj_cgroup, which means that if we split the objcg
> > to be per-node (in patch 6), then the obj_stock basically gets invalidated
> > every operation since we iterate over more objcgs (even though we are in
> > the same logical objcg). Maybe I'm missing something?
> 
> 
> The objcg split comes from commit 01b9da291c49 ("mm: memcontrol: convert 
> objcg to be per-memcg per-node type") and the problem you describe is 
> exactly what Shakeel is trying to fix [1].

Whoops O_o I completely missed that one. Sorry for flagging it again!

> But I remember trying a microbenchmark and noticed a +5% regression (on 
> top of the 67% then...), I'll rebase this series on top of Shakeel's and 
> re-run.

Sounds like a great idea! Thanks again Alex, have a great day! : -)
Joshua

