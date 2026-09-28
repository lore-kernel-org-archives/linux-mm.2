Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71756CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD426B0096; Mon, 28 Sep 2026 11:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5931A6B0098; Mon, 28 Sep 2026 11:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4549D6B0099; Mon, 28 Sep 2026 11:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B48F6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:09:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9211AA022E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:09:24 +0000 (UTC)
X-FDA: 85263504648.03.79313A2
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADBF480010
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:09:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeUDrwUX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ePUtRIIdzKxmcepIuM7i9rcIIVMHWU1yVMYxV/ojck=;
	b=mRZ8SYdLxh7bY/I+FNWhBb9Ujh2fjbIKXYFYg7i1Qg+Oki3zMqQku4+fzC9geENIMzLE/C
	kEcr1Zv63eTwkiiMBRW9Kn3m9JvGAvYarybdtgiRQxmJD5nAQa6P6Dc/hODN/5sJdWKcZh
	WA/NT7qhIyGfC8GvoNU8k7mtvlxYLoE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeUDrwUX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608162;
	b=5YAfJk/mf+Ntc7zPAFkH+Rl3LNHu+56+xx2G1a/Iu5I/qsaL/oAkeE9n22Eh3gG/kB2Vyn
	qXIVSblDKZag/ED0EoNTHShUxtf0V/KDvGjjKIo04O7tydULn5zmSNrrLG8Pc/Vr/sGjqT
	2yl4T7oo+8SmetiQ8/manpVw+/xSpvo=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af876539fso324561366b.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608161; x=1791212961; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7ePUtRIIdzKxmcepIuM7i9rcIIVMHWU1yVMYxV/ojck=;
        b=ZeUDrwUXBJMNYnxNN5rUU4UPJ04lKaxEGvt1D2NI0cgA9d+QJQD2/ZGApvVYuub4hw
         +dButjdkTAhsXg2YK+mDyyn7neELnJSzTCHradkyOINN6Daakp3HOQE4RaFERexfAYX0
         17wNWT124jMG4xIpigJ4RQVB3b+QuTC+7pxGJPnLXCEdxw+DlfH86r/gyL0nfQ3YF50R
         4/vl2Y80b1Lce2SLkVyhJQ18doAg87NJ9uibHYtuJIbKmeLQxKKPR3Fhmuz03bwC2xMH
         6KStj4+2993OQER3y/1cqMbLIMvVB9IZo4VJWxz1xIDZCyh+6x2T6O3Xlso/6yzVA+nv
         DRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608161; x=1791212961;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7ePUtRIIdzKxmcepIuM7i9rcIIVMHWU1yVMYxV/ojck=;
        b=MQTOLL1jVf5faB2CA9eOajSVz7lEoGNTiEheBjMXD1GLhDYNs4oxZFrUlj6O1saRRO
         l4Lk896EMavnhh20M1EwCsVxqauZ2UYvM9w7E2gfDsCdx5otBKWif1reLCEYRJznRlZa
         z7/A16ulp7AYV+f+FUI0KG5D1ELdJ+YCFD9EOZ90tSD4F9ZK70eB/uRuGTQcQ6DhmF1m
         UipZUjMUnDWR1ccYtWWKlQTfmeWhKd5i83Q0IE/R6RRyHI6Shlk3/2vOtDJMZuU8ElkD
         1ccY8q6RVV8gTM6qyPmRMLAiPJ5UmfSGbJ2KfYz3jwrAiApJR+wfrursG0yL6FSTIpx2
         qWCQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDqASRDUQfM21ubOiDNu6xbpIYj7Ggz7FsJT9yMawfkYdSVdQEkQvqD1b7d428w+cU/3Mxv6oe/w==@kvack.org
X-Gm-Message-State: AFuF++nJbKidYQ7jpbiWLyGMPElVwJFqFfa2p6YmjnevxxsF939wQK9k
	b4sjiR+bAF91wBQ7JZTB9RzXU9P+c9KmxB1WfykllfeZNEVgDRFCIT/Y
X-Gm-Gg: AYBFou0hzoal+sJV/+ctJXpmra0T4duC6NaHBbMcEmkXpEQJ/5czsCm3gb72DPwFj3b
	WsV0gCkDiSTHp7ZfifapPKfAQjycNlVZUwWkivhEGYbf2WKA+n5mozzbOzIWqVgZx+dyzlTZsOJ
	47+PBQYvYUJlQv9w8rHiH79ZbxapWZuf98c2HrtzWkidC8LAligp5fy4FJ/OsK83shW0PJ1UpN4
	hW372jR9TdZtBj3Ruh3CBjfSh3EyyihGzkHOSxtiEdMU7lRr3lu3eDbQD2KkVVTaJroyDBw/lcd
	2AuLmqkk3vUdvm8V1wzY6Un0ZGu5TQpaosi5LyFGyd1Sm/Tbzt8vJoyiaR8saaISdFK3oIv56pz
	NaUj4rxmMejjHFEQ8T2YSlNk6VuB4YUiad7qRz4w0Igzu3bTpS3Pmk2hDj0SGEO8xQvViGBkWW/
	pb1iczOb944P72KV/wl3HaiFxEEnU2IYzmJmU=
X-Received: by 2002:a17:907:c602:10b0:c2b:4142:2db1 with SMTP id a640c23a62f3a-c2b41424722mr392606866b.40.1790608160979;
        Mon, 28 Sep 2026 08:09:20 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2dbfde3194sm297220266b.4.2026.09.28.08.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:09:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 17:09:18 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <arqDHnBFGKQZm7VU@milan>
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
 <arpK2bQrrUMvEvTP@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arpK2bQrrUMvEvTP@milan>
X-Stat-Signature: tdufwf9othqjrei5zss3uazqp3m6an6e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADBF480010
X-HE-Tag: 1790608162-497559
X-HE-Meta: U2FsdGVkX187e0w+eUldfUatNjcyROba7EoZUkXVItFtaWaSXBXFZppKk4g6wVBH9azjTyI9Y94FVeKFxKnBsizdbHPv6gMXjuQpAcCXx/4l8rkeBcK74iOBUp2RC8zlMZv9zhjPXHMyKMDmEsDyD8Qp3QuBcITDQwpIoIMLfYq5MctaqgyYUUZWD2L4ip8vGHw/hQevpMcGOQn9zoPsbAYHeqYch5F+CMHkfrCNnRVcn6lVBuXYNnVj5P71tmKYZIh7oyNCymZiETj4IhtKR3pnpaLnZgBBB7riw9eqc0nOl/hR6tdV3kfgBLgrZTktyrNnZ9E+l5HIdN24bbqvul+D+jrEgGONs33KRrKZhXnyz9WyZuXn6eN21tW9ULz0msVRnCBHcyrg1ooNdKzAylfH6BCp5eOphxZgQX6fOHt2DQgUCv4kv4lP0AdafJ9MgCq14euAnMSq4Wz1/vouebVk/dyAqW15QJO04Dz4OAvvJzBHt11auauJnqenPFhJiv/SdfRFompn5kQMRlmM7lyMJT8Igu73zrwihM0OI23Eb2bcsghmx7Gyii8GS9Z/QM8c/D3egzxV7ArmUsmcZW6pIm4+H1BP7HOzhezIMkbYQQicnawV9rbUvImYu2yz6ZbfYoSGXXfjBueDzPz4Sn1AmVkx//1ZpQTCIUrhQKwfOr5XYgF4s7QbtJG8F8KzGDBwLbcw4wqIKgPb4Fuf6hiarErjFwRzNLIY/2QGfU0mGSL7ud3R6iQCVlNMA/Yq2SX2EhBb5OPvu68D+ffeIx89QtXVMcHSwL3Z5Zk6stDmHli1gqNngM7gOPgBg5o1cxwSaPyFDivge8rO3Awl+DV7mXoyH0SgT8/hMNytsQa9iQ1SlBfpW9e0llWgY9iYQO2pgDXHXelkBHbkdYjWJyTXMFkiQ85Szr5PSPYQBZyRm3g6rNvIzEw6qbsTA9RQN2Pp12VMLCrOkYDluj+
 jq06ez3z
 5V2E91uADBrsu53dZ6bsHzKFEpkWYC0q+NGGrt+sk8r10fIkkNsnBjoalItShr8gdNYMFaCKcykkX0CBx0/HWFVC4r2mmFZJTpmvSeZvthC566W7hSGYU/SuqSCvMAj7Ku5+EKGxXQKyphqa7MNH2EWdZ9fbZY0z7+PDZxjF3s7/+EjHNsFObxiwK+3Mai/hJLDXyhjRSa5X891xd1b5d96y6B7PiwvqHi//CBqwto9pZOwzEqbtThhOJypODmEoN9EriT2B3rBxHd1CCen/fJVaxv3BOmgclx9GwZA5DnM0HsRvTr8YUKdgTVASBEVcdVL++JluTPDw0VEF0M5GylTsoDF9E6tjSxFNZMebnlyujFRsE+sEXnGuhxuxHxCQ+LtxMd99u2QZAjuCAmr4u5BEeNCM1krQwrYya9pPp0FHGCq4EFyJotsthJf5pHNtNJLZjLPrkJiZv1jR+IOpX1mikiwbGkVfWUhuQjLaE4tZa+REebrgMkTbW1pXWLmImIb849dx6NFpM139jdAG4BFWhp2+yqsvbOCHJMY1dEZ7Zzw040KcNSBB/kPJq5Uj3YpBK/Y0RWRfS89poOSnpUgPUWJQ+ciqZlfMthJQ3BimNd9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 01:09:13PM +0200, Uladzislau Rezki wrote:
> On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> > Hi Suren、David、Lorenzo
> > 
> > On 2026/9/17 09:12, Hao Ge wrote:
> > > Hi Suren
> > > 
> > > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> > >> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > >>>
> > >>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
> > >>>>
> > >>>> Hi Suren
> > >>>>
> > >>>> Thanks for you review.
> > >>>>
> > >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > >>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
> > >>>>>>
> > >>>>>> The reservation is already stored in the maple tree when
> > >>>>>> vm_module_tags_populate() fails. A failed load never unloads the
> > >>>>>> module, so nothing releases the entry. Release it and roll
> > >>>>>> module_tags.size back. Without the rollback a concurrent load that
> > >>>>>> already passed needs_section_mem() can reuse the freed gap, skip
> > >>>>>> vm_module_tags_populate() and write to unmapped memory.
> > >>>>>>
> > >>>>>> vmap_pages_range() may have installed some PTEs before failing. A
> > >>>>>> retry to populate the same range would BUG on them, so undo them,
> > >>>>>> but only if vmap actually ran.
> > >>>>>>
> > >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> > >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> > >>>>>
> > >>>>> If a patch fixes two other patches, it likely needs to be split so
> > >>>>> that each part fixes one patch only. But read on please. I'm not sure
> > >>>>> if one of the fixes is correct.
> > >>>>>
> > >>>>
> > >>>> Kept them in one patch because they only make sense together.
> > >>>>
> > >>>> After a failed populate the reservation is released and the
> > >>>> size rolled back, so the next load takes the same gap and calls
> > >>>> vm_module_tags_populate() again, and that retry would trip over
> > >>>> the PTEs the failed vmap left behind.
> > >>>>
> > >>>> Without the rollback a load that already passed needs_section_mem()
> > >>>> just reuses the gap, skips populate and writes to unmapped memory.
> > >>>> So splitting them leaves each half broken.
> > >>>
> > >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> > >>> completely separate patch with vmap_pages_range() doing cleanup
> > >>> itself.
> > >>>
> > > 
> > > I think I get where you're coming from now.
> > > Thanks for taking the time to explain.
> > > 
> > >>>>
> > >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > >>>>>> Cc: stable@vger.kernel.org
> > >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > >>>>>> ---
> > >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> > >>>>>>  1 file changed, 10 insertions(+)
> > >>>>>>
> > >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> > >>>>>> --- a/mm/alloc_tag.c
> > >>>>>> +++ b/mm/alloc_tag.c
> > >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> > >>>>>>                                      next_page, PAGE_SHIFT) < 0) {
> > >>>>>>                         release_pages_arg arg = { .pages = next_page };
> > >>>>>>
> > >>>>>> +                       /*
> > >>>>>> +                        * vmap_pages_range() only runs once all pages were
> > >>>>>> +                        * allocated, and it may have installed some mappings
> > >>>>>> +                        * before failing. Undo them.
> > >>>>>
> > >>>>> If vmap_pages_range() failed to map the range, why should we need to
> > >>>>> undo it? If it indeed leaves some partial mapping when failing then I
> > >>>>> would argue that vmap_pages_range() should be undoing these partial
> > >>>>> mappings itself before returning the error.
> > >>>>>
> > >>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
> > >>>
> > >>> Hmm. I wonder if this behavior is intentional or requires a fix. The
> > >>> only possible reason I can think of is performance but I can't imagine
> > >>> a failure to map is a performance-critical case.
> > >>>
> > >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> > >>
> > >> Huh, my gmail thinks you are still at your previous companies :)
> > >>
> > > 
> > > I manually fixed it on the mailing list for this thread.
> > > 
> > >>> guys think? Shouldn't vmap_pages_range() undo its possible partial
> > >>> mapping when it fails?
> > >>>
> > >>>
> > >>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
> > >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> > >>>> so I did the same here.
> > >>>>
> > >>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
> > >>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
> > >>>> the current behaviour for now.
> > >>>
> > >>> Yeah, I understand it would require a deeper cut but if that's the
> > >>> right way to handle this we might as well do that. Let's see what MM
> > >>> folks think.
> > >>>
> > > 
> > > Sounds good to me. Let's wait and hear what the MM folks say.
> > > 
> > 
> > I just looked into the call sites for __vmap_pages_range.
> > And I found there's a bug in one vmalloc caller [1].
> > When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> > __vmap_pages_range. If there are leftover PTE mappings,
> > this can trigger a BUG(); [2]
> > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [1]
> > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [2]
> > 
> Indeed the below code is incomplete:
> 
> <snip>
> 	/*
> 	 * page tables allocations ignore external gfp mask, enforce it
> 	 * by the scope API
> 	 */
> 	flags = memalloc_apply_gfp_scope(gfp_mask);
> 	do {
> 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> 				page_shift, nested_gfp);
> 		if (nofail && (ret < 0))
> 			schedule_timeout_uninterruptible(1);
> 	} while (nofail && (ret < 0));
> 	memalloc_restore_scope(flags);
> <snip>
> 
> and it should be fixed. As the __vmap_pages_range() can actually fail
> and leave some installed mappings, we have to perform some cleanups
> on failure or on repeat(if nofail is true).
> 
> Below code:
> 
> +			/*
> +			 * vmap_pages_range() only runs once all pages were
> +			 * allocated, and it may have installed some mappings
> +			 * before failing. Undo them.
> +			 */
> +			if (nr == more_pages)
> +				vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
> 
> we can use but we need to check if partially mapped space is not an
> issue for the vunmap_range(). And it looks like it is not.
> 
> <snip>
> @@ -3953,8 +3990,15 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>         do {
>                 ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
>                                 page_shift, nested_gfp);
> -               if (nofail && (ret < 0))
> -                       schedule_timeout_uninterruptible(1);
> +               if (ret < 0) {
> +                       /*
> +                        * __vmap_pages_range() may have installed some mappings
> +                        * before failing. Undo them before returning or retrying.
> +                        */
> +                       vunmap_range(addr, addr + size);
> +                       if (nofail)
> +                               schedule_timeout_uninterruptible(1);
> +               }
>         } while (nofail && (ret < 0));
>         memalloc_restore_scope(flags);
> <snip>
> 
And looking further. If the __vmap_pages_range()/__vmap_pages_range_noflush()
and friends fail, a proper cleanups should be done inside, IMO.

But i am checking callers and see that some do some not:

<snip hooks.c>
	__vunmap_range_noflush(
		vmalloc_shadow(start),
		vmalloc_shadow(start + clean * PAGE_SIZE));
	__vunmap_range_noflush(
		vmalloc_origin(start),
		vmalloc_origin(start + clean * PAGE_SIZE));
<snip hooks.c>

kmsan_ioremap_page_range() it does clean ups;
kmsan_vmap_pages_range_noflush() looks like does not care in shadow.c;
__vmalloc_area_node() as noted, it is broken as there is a BUG() on next try if nofail;
pcpu_map_pages() it does cleanups.
...

and so on.

--
Uladzislau Rezki

