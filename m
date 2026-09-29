Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE533CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 17:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2606B008C; Tue, 29 Sep 2026 13:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9FD6B0092; Tue, 29 Sep 2026 13:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0AC6B0093; Tue, 29 Sep 2026 13:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D75E6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:26:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7137816059B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:26:04 +0000 (UTC)
X-FDA: 85267477848.18.796B2DA
Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98D74180007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:26:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MethFBd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790702762;
	b=DMlUINWYbwBPxp50VL2sbzKWtPdrIF0qCksyR0fPYQA/wbFYPvlmAabFCy/MnTbb8pj+u4
	UBDz9cH79X0QMDvYzX/AD+2gvxx1I6r4TGTOE5vc4JJjrC12p4ptcHDXhAM9/iFVEweJKf
	1k2NXZ9bFtEzFEyyg4yna86lLFlt5R8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MethFBd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790702762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6jepSVcmHm+oxwGNgqeKz9lXh7Z2Z4id6g1VGOo8Vc=;
	b=L8Ed1NZ316Gvu1ly22bU2at/m0fs2cn43JSkMrATMloS3FX7Scmv3eHGJO4A/msEMNZKwF
	pgXvwB40dl6kGp2+6RBuFNq4akJvtVFXAbayKa4JiHgYOlNOqS+67OAagCjrr6dfMQoPbr
	S7JcjRPturANfezjsozX0AWU05dSHQQ=
Received: by mail-pj2-f39.google.com with SMTP id d9443c01a7336-2e2d2bbcab2so2895945ad.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790702761; x=1791307561; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U6jepSVcmHm+oxwGNgqeKz9lXh7Z2Z4id6g1VGOo8Vc=;
        b=MethFBd6kJsBLw8rzypaPjAzEb5wRFMtzdb5L263yVbPZCOERYl7V1t7VrbXcjtTPw
         YDWWT9bIeJ7F3HbdOrWYqz89Q+8iZwbs34h46z495Cvkzev/kKx2KDDQ6GZ7Q2vHnwbu
         jfAMpM3C8NCtYIJLjfZmrjjJR3mP+8FB1IPLISqGz70zV5IqyYlwrb58UHnjPj7i0DIw
         S2fZa92ryhQxZL3d3c8Q6vgTSjbRSPfvtFsdUHrmAItx8oTIjqYrlQKVVfsLOTuBhUhI
         kpkx2ZNEqJ2OQ6PuPWAMmy0vgvjzc6Drhgvq2rETLD0b3FQy8Ei+GXB1w1DStYWOAmmp
         mNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790702761; x=1791307561;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U6jepSVcmHm+oxwGNgqeKz9lXh7Z2Z4id6g1VGOo8Vc=;
        b=USO6YJ3EBn8KV1c2pvgQw3OWsenvUg7cWIrpCGhupFckc8MnNzL9WwBBWibVhkyqev
         /otXy3HMFKA4pPLg9su/WQEbgtPhxi6JgK1UnO+wW3SDb6YxxUjZdFmNGVOdXioZrykP
         Qor2uHmxY6vu2ywYdKWlZZWW58vUs1sqNre9yibqbDrQCZ028df+YkiY9WUBXdJgOvis
         +KrqKrf86rXSKPg7dTM/pTt1mIwZW50EVyUw7CvgkMvt3KTtMX9vlqZokkoPdY+SkDTH
         hhAadaJagkuGNYi6LjugFrAzppgKT/XMC3SMQcpPMcoD+MkMTcI2Zcf8fTIGcjaChqv4
         INrw==
X-Forwarded-Encrypted: i=1; AKwUvBx59LSQkkFuOmBrWtVtzcPKZsNTnOn58iFbmpiQoXjXBOnqL4DjP7SpdNI1J4wxcD/vrlobNosjpg==@kvack.org
X-Gm-Message-State: AFq9FYJYf7EFQBDKwKQc15XjFCYBQC596Ecvl97Eb3CFMfa+vZVwhctG
	ddLzkDES+XjhEu/vFMf8q6mtPVy32Q0XqB8dmv020jDw5NdHtt2lE0XD
X-Gm-Gg: AYBFou2fErJZshKAMOCmvnVWv/J8yMbtHcHPfa7MCSctOg1mPI0nI2sq5gces12q6JK
	lyYPViQ788dcbqrYIFqS1HJCSFbbOm8O7ZAVrl9z2pxyaGIcrUECuFkRkH9aPwM3F+RDKPPnlmc
	E2uTV3YUmRf7wdtkEO2yv3YQJ5iSwxWXO6CNnRWd2ucVRmaEX2gBl/vBRvhTW8ZhT+3NlvOVyXf
	A/iGHVMVpfBNMn39TRUlfuXpTyus40WOmN0dTSMavDjGBTPyn5cRsFuuW8B996r7HVW3C4ZdzOM
	WQf0Nf2zxRMZZPW+noVW0DURLovKWyQrpfL+YVWmGXwzNMJK9BUqBA5BxeMyydXbGjZyG/zrxGP
	Gc/cT4FKoEsGC8oFQShXPKak+blWAUG4RKDiX3jx6j5+FBd/QWJMebb5HW6GsO4g5z2tfkxO+W0
	yKNKZBtfBf3k0Q/e9NuF2J3GMhAddYjjhQc3b77zzEfu3/Nfal7bl8uRgCHVGkFRR6wgUaCp+SE
	Dkv9cIxoUIbazRTg2PYq6CtDHaj6u4sfyFZHkaJ
X-Received: by 2002:a17:903:38cc:b0:2e2:aa17:477f with SMTP id d9443c01a7336-2e2aa174e56mr51304225ad.58.1790702761038;
        Tue, 29 Sep 2026 10:26:01 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9143a3aasm60994385ad.53.2026.09.29.10.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:26:00 -0700 (PDT)
Date: Wed, 30 Sep 2026 01:25:54 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, her0gyugyu@gmail.com, 
	taejoon.song@lge.com
Subject: Re: [RFC PATCH 00/10] mm/swap, PM: hibernate: improve image slot
 allocation and I/O
Message-ID: <aruGQpdsq7_O-AC8@KASONG-MC4>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: ngnn89z8pyue8qzy4kbwyzk413e4gf7w
X-Rspam-User: 
X-Rspamd-Queue-Id: 98D74180007
X-HE-Tag: 1790702762-13554
X-HE-Meta: U2FsdGVkX18AqqcjFoVgs7kvKQgRi628e77RRj9yWnV6DqZVyGhUalXIqi9AwHYV1Meq8nK/MMSWczpItgTllr4Q+reuv0oCucu4i8j7uUQgEDSPe5kByBoC3XDVKk8eah4A64gkiaveCoZR0uf1Zz/bQPS77gJjpsMGt+aOnq1LdhBmxQOo267ocl5M2xeXc7CMK+l3mLkW4jo22q8eX6Kp0Bo7ROD9mnZ0HmJTqpkGGlvxVs7THQojaHiK9SpeB06y8qp82HVDMaZf7nU2sTXQHQLnEtqnZNa6MvYWuFBsK/lawdwbrpHgPkKcuGxly+HNswr0HzsG6SG32RCgSQW0Sy5Dmw7CjsS6Ooz7tb896ZwIYuqZtJuf1Jm8YEC9wm0Y4sZHH+uICbjzs5CNvMr1+wTkNJNafkHmwe7fAIjCH8soZcdlnPZ+f9NbZ+wCYinu4tvUZz/mekfpDuWW6slAksRJ626Dcg3aCuwqNjgFmepsw1puc2Ly7BKgmREwFgqjOlXGcg9uR4ZlNZ6KXgenjko2JWYNpnRQbiE27tEjcY/fVmGlBraS5psouClmLJtttrFKzuNQNqf7fq6SrBECO8LZw2VwtrmNRGs7v10nW7M4Z2A+rw2poUPfEaBy5mqbwb6lX9aTdklj79HOiU2HNeYtjyLEZuGuWHDVdnZjdfJsFjy6ePFAGfuCetsnKal6DgyNFqQGoDCUYt5v3Lm1zA8vriUVwv4bgFWYjzggkEhBQbxJJ1Ync9BlxTrQa2YUPFa621myD5LFe8K8QBOFlYGVyh09IgXe9V3peHj9Pw7koqPr9xUSUsAuPoL6dtCAlDQdWxONZT3WxHQeFwTmto1qgKIOr/2hJqy2js9rbVGXrRTbHaS3llvZQ0hTw0+DGOOP/nqEdkDBVujwQ36BYARZrlQ5jX3zq2GQNeB6B+j7+WRDxiF/cvOroWEtytbg70xyDsI++JyAka1
 j1K0cM56
 x40YHfUG6EvaLIUVXOY7iabWgopKMlh2JIixaQVbRc5vvt2BJFPDnlyOXyXtVREAAKh34BnRLSTAq5xYCe1eBqb7eXx1lq+wsYRkRChCJOBunGjjkNJKZdyu0xHgdzYeegqFmOcWipupy0wz611yhaW4frCZ80QSnQNHW7LeUe4C9PVtg/N+K+hBAEkpqDwSrF58YyGAxdkyNvl4dls/HNqrTh+icGv4QKsd5viyPpLPN8TXklgG0UCvE9es8zFQCOPdMDYBW3HdU0Rf9nAudXe4wbxd7h0905CLFZc1ufg5R5QVhqTNY9/fREBg4rQy5FianW5PQD/3xl2IwyV+BHtdJxqsdQTLwQqv2VIwyxUc5qZFSy9r9MNFaF0NmmAUJZt9UEeZnusn+OFCNa/91z8SWUB/rk6eXPgV/h0r1wH8k3X5ZRbWyjUCOsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 12:16:48PM +0800, Youngjun Park wrote:
> This series improves how hibernation allocates swap slots for its
> image.  It starts from a few observations about what happens while
> the image is written.  With them the allocator can hand the image
> contiguous runs, the image I/O can be batched per run, and
> hibernation gets faster. Contiguous I/O pattern is friendly to flash device also.
> 
> Slot allocation matters for hibernation speed.  After commit
> 0ff67f990bd4 ("mm, swap: remove swap slot cache") in v6.15, writing
> the image was about ten times slower on some SSDs [1], until
> commit 396f57b57200 ("mm, swap: speed up hibernation allocation and
> writeout") fixed it in v7.1.
> 
> Note
>  - I was responsible for the observation and design, 
>  while receiving substantial support from LLMs throughout the series.
> -  Submitting this patch to confirm whether this work is progressing or not.

Hi Youngjun

Thanks for the patch!

Splitting out the hibernation specific part out of swapfile.c
looks a good idea to me. We can then compile that file conditionally
rather than having a huge ifdef block in swapfile.c.  Would be nice
to get more feedback from hibnernation side.

> 
> Observations
> ============
> 
> 1. While the image is written, swap can only hand out slots that are
>    already free.  Swap cache cannot be reclaimed to make more.
> 
>    folio_swapcache_freeable() refuses every folio while storage is
>    suspended.  The image may already hold a folio as clean swap cache.
>    If its slot were freed and reused for the image, the resumed kernel
>    could later drop that folio and read it back from the slot, now
>    with the wrong data.
> 
>    Storage is suspended before the image is written, so every
>    allocation for the image falls in that window.
> 
>      hibernate()
>        freeze_processes()                user space is frozen
>        hibernation_snapshot()
>          freeze_kernel_threads()         kswapd is frozen
>          hibernate_preallocate_memory()  may swap out to shrink memory
>          pm_restrict_gfp_mask()          storage is suspended from here
>          create_image()                  the snapshot is taken
>        swsusp_write()                    image slots are allocated here
>        power_down()

...

> 2. Image slots are not freed and reused while the image is written.
>    And whatever the allocator changes during the write is gone at
>    resume, because the resumed kernel is the snapshot.
> 
>    With observation 1, once the image owns a free cluster it can use
>    all of it.  Nothing has to be recorded per slot, neither in the
>    swap table nor as a memcg id.

That's pretty nice indeed. But I'm a bit concerned about having a
specific cluster isolation path for hibernation.

Will it be cleaner to provide a more generic cluster sized
allocation (PMD sized) so common swap can benefit too?

And I'm not sure is IO batching working properly before?
How much performance gain is due to the cluster sized IO?

But if other appraoches won't work or hibernation is really
special, and we can keep all the hibernation tricky clean and
simple in just one place, maybe it's not too bad.

> 3. User space and kswapd do not swap out while the image is written,
>    and allocations from the page allocator cannot start swap I/O.
>    What is left is rare.  DAMON pageout and the memcg high work can
>    still reach swap(This is all I found. anything else?), 
>    and both were seen running in that window.
> 
>    So the allocator can favor the image then.  Other users take slots
>    from the nonfull and frag clusters and leave the free clusters to
>    the image.
> 
> With these the allocator gets simpler and faster, and batching the
> image read and write becomes easy.
> 
> What the series does
> ====================
> 
>   1-2    fixes, a slot leak after a failed test_resume and a NULL
>          dereference for a swapfile with no block device (some bug fix)
>   3      move the hibernation code to mm/swap_hibernate.c (refactor)
>   4      skip swap cache reclaim while storage is suspended (optimization)
>   5-6    hand the image whole free clusters, in disk order (exploit contiguous space)
>   7-8    write and read the image one bio per run (batch I/O)
>   9-10   optional reservation at swapon, hibernate=reserve (assure contiguous space)
> 
> Based on mm-new (383fc05d4650) with patches 2 to 4 of [3] under it.
> Patch 1 of [3] is in mm-new as 10d9012e83ef.
> 
> Note.  [3] gives hibernation slots their own swap table entry, keeps
> readahead off them, and frees them by offset alone.  The single slot
> path of patch 5 builds on that.

Nice, maybe that series need a refresh to get merged first.

> 
> Results
> =======
> 
> Setup
>   - qemu, 12G RAM, 4 CPUs, no KVM.  Times only compare against each
>     other.
>   - swap on virtio-blk as a non-rotational device
>   - image 5.0G, written with hibernate=nocompress
>   - 3 reps of two hibernations each.  Times are medians of the 4 to 6
>     samples per cell that no host load hit.
>   - base is patch 3 and allocates as mm-new does, allocator is
>     patch 6, allocator + bio is patch 8
> 
> Rows.  runs is how many contiguous stretches of the device the image
> ends up in.  bios is how many bios the kernel allocates and submits to
> write it.  In both cases the image fits in free clusters, so the
> fallback to nonfull and frag clusters is not measured.  Percentages
> are against base.
> 
> Shuffled free list.  A device that has been in use, emptied.
>   - 6G swap, 5.4G of 2M tmpfs files swapped out, then all removed in
>     random order
>   - every cluster is free, the free list is in free order, not in
>     disk order
> 
>                         base       allocator   allocator + bio
>   write, s             10.60     9.32 (-12%)       7.94 (-25%)
>   read, s               9.15     8.92  (-3%)       8.10 (-11%)
>   runs                  3560               1                 1
>   bios                 1.30M           1.30M             12.7K
> 
> Holes in nonfull clusters.  What taking free clusters first buys.
>   - 12G swap, one 4G file swapped out, every other 64K of it freed
>   - 2G of 64K holes in 2048 clusters, 8G of free clusters
>   - mm-new fills the holes first, the series takes the free clusters
> 
>                         base       allocator   allocator + bio
>   write, s             10.69    10.07  (-6%)       8.81 (-18%)
>   read, s              12.21    10.89 (-11%)       9.78 (-20%)
>   runs                 31899               1                 1
>   bios                 1.30M           1.30M             12.8K
> 
> Summary against base
>   - the allocator cuts write time by 6 to 12%
>   - allocator + bio cuts write time by 18 to 25% and read time by
>     11 to 20%
> 
> These are VM numbers without compression.  Compression, the default,
> and real hardware are still to be checked.
> 
> Next steps
> ==========
> 
> Things to keep working on after this RFC.  Comments are welcome.
> 
> 1. Dropping swap cache before hibernation starts, so more slots are
>    free.  This series does not do that.
> 
> 2. Whether the reservation in patches 9 and 10 is worth keeping.  It
>    makes sure the image gets contiguous slots when swap has room to
>    spare.
> 
> 3. A block device of its own for hibernation instead of swap.  Not
>    taken for now.  Sharing one device keeps the spare space useful, the
>    existing infrastructure stays, and the ideas above give much the same
>    effect.

So is the idea for 2 and 3 here to make sure hibernation always success by
avoid the allocator using too much for common swap?

We only want one of them I think, and we need to be careful here to not
make the maintainance messup by adding too many knobs...

> 
> 4. Whether the extent tree can go.  A normal hibernation never walks
>    it, the swap state comes back as it was at the snapshot.  It is only
>    walked to free the slots after an error or a wake from hybrid sleep.
>    With the slots marked in the swap table [3] and taken as whole
>    clusters, a free could find them without it.

The extent tree is not a hibernation issue right? At least for block based
swap the extent tree is useless (only one node). I think swap_ops can be
used to make this limited to certain swap_ops (e.g. file swap ops).

And maybe, the swap_ops can provide some interface for hibenation usage to
make things cleaner?

> 
> 5. Whether SNAPSHOT_ALLOC_SWAP_PAGE should refuse a request made before
>    storage is suspended.  Such a request gets single slots from the
>    normal allocator today, and s2disk only asks after
>    SNAPSHOT_CREATE_IMAGE anyway.

Is that a even a right thing to do during hibernation?

> 6. Two cases are not measured yet.  A device with both a shuffled free
>    list and partly used clusters.  An image bigger than the free
>    clusters, so part of it comes from nonfull and frag clusters.

I think that's fine, free cluster shuffle should not effect the
performance much as 2M is a pretty big IO unit. For the
fragmentation batching IO should be very helpful.

