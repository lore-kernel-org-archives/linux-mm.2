Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89966CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2256B008A; Sun,  4 Oct 2026 13:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773326B008C; Sun,  4 Oct 2026 13:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6620A6B0095; Sun,  4 Oct 2026 13:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF066B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:39:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A757EA0B7A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:39:11 +0000 (UTC)
X-FDA: 85285654902.11.3C760CC
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id D3BF41C0003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:39:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdH41uH1;
	spf=pass (imf20.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791135549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hJVS5+jE0uXV92n3fYslDINcPr4GX7oGIj8l2+wqvM=;
	b=NVGpGuhLN6MchWnuoThP+sZ1GGpdwgCQDrqn2HYTG+WCKO6z5Y1i8ZUIAshczC2xWpBZtp
	VdlnyqNIZ8fNAs4mQj9ExTlz3oIURuqtwwntyC6dPhaLGbmGXNdD+tL1GRQmOrSYM1cox3
	OrXMAHSLcwqnaexEfZKPL1n6wq/nIGU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdH41uH1;
	spf=pass (imf20.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791135549;
	b=FCpBDrnMjGp3M+lBxBRbiDfczCWHzulZlndI0d4g3cwpu4nrc6tsNDrT+snH7K1ZngN6F9
	aNps4Qk6GzL7npk+pTanEs0zAaNGgsKeDvcGSmQIrr0lRfE29uiePXjo3870D06i/4bigw
	s3y5wblvxqUvVuU/VHQ9EmTuYK3jrUA=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e576377715so1608805ad.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791135548; x=1791740348; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6hJVS5+jE0uXV92n3fYslDINcPr4GX7oGIj8l2+wqvM=;
        b=kdH41uH1LSiQnekLp5n7fHj3iDlYnSyIYfXi4B2hwHNIkN2el6G54jrcAYGL7iRgjB
         B+SbtuYgmvJp+P6f5y3JfzRin+8fc1RWsc+SgoC9tgTmV0Jd1mjlWh05eTqzABOV8Uu4
         BZqG5i62Zbdm5eCSJKUqsdCOK3E7VskBjg7o0FwhZBcooKB9w2T4vtWK80LIDZzNEvDY
         OWnZO24j4nDY/UoLmkVYlb6bsIOcU0JQtYj1YFXmsLrk6YcQf3xMvpARjd2s1DtTKDWZ
         bjtPLoN+HGwvvE1LNZQjTjMYOydIIDZxyaRhBdIWrTDWed0IdzY7vcMx9FUsbMABysEl
         0LOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135548; x=1791740348;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6hJVS5+jE0uXV92n3fYslDINcPr4GX7oGIj8l2+wqvM=;
        b=s1Eyme2mb37XtoR5sJWXokHaoXbwnWuYarRPtMV4YCn1lobP0nb5T3DrZ+prrC6mr1
         h2AxYNNSyJI+q05aKXHKNYj3yflpEpFKmJ69kdrZVUaWEebV2uEF2/nwx2u7HNSlejAC
         FnQZKNNMa8JwQXdaw6kFFVmrgEw4gCKC4k3UqXNFv6Dq7+9N500X8BrAb5iIurAwv4OM
         geO1Rrqc6e6gs9cJRJ5WMp9E+DQ3Ph2q5CKSAjG5zx+SNvbq5f98V2r73H8DxNLUbtpZ
         v/OaNnEF6cNfubk0pYItADMKw3uhEvHliufDCzQBgDmf+LTJA0sZY7V94BY56Fh9eebY
         6hbw==
X-Forwarded-Encrypted: i=1; AKwUvByfmzGhknEbedIml+AFHB1FxNGl45u/OM5a+x59Mtab+oqXd7pw3C4X2/7fL0sdrl1ZjZp8cf+raA==@kvack.org
X-Gm-Message-State: AFq9FYJJ3wOOUxyuXT1hxU+Evw2D3DLKselmjCiGZhlW4nqs3NMCEEvQ
	g+iO19OdeflJb3nsT2dL46FJqdTATMPp9+Sl+qJxPmUKZIkciywhmIu7
X-Gm-Gg: AYBFou2awJj/nrBkiSAw1Zewj8WHbPqZcJM4SLDT4+8Rr/Xs1aC4D3d5Qgixlj2OBbp
	VFEUFafT4Euy6uxzRKEmqEKs4pOLzH3s4nzaxoOgazc9kDXGvamckNo+9JBh4cRp+HcyboJCj3+
	KvC9+z0NEUK2C1U24yLHmBPQBBVzWpWkxOMK8qzyUo/quH+OH0yYcj/7rXFAX2PORJkk0yAMVYV
	VzPpViV17Fqa07oaWXLK7T6sdJs8PZ9k4FoLYtg13K6ExNi5KYU7SLqQI2JHPiCEudUUGNt/1Wm
	wCe6jOcLhPGy2NkgxlSJ4m6zSfkoyMQkj6sKXaOy4uof/2DnsoA56KrzT12Bwo/fTu8g3ePROUI
	LoGaIzSHkah/20wHkFV1LVr3TA5CeM4mmIFfO1HpBV8V3sakumVe3m5uVIsaiuntzvDfUP90fir
	6rZktnqCLD6kW0ZUvOFxz6hJWYfVy/ERPvrsTKzmc9UcCm3RU+Ne+96F4HCYwrJg+b6dUFbvLZA
	7FpC4gvWozyfGSxDjtcRSf6eh748ptaWkCTmP0cpg==
X-Received: by 2002:a17:902:cf03:b0:2e5:33a5:36ec with SMTP id d9443c01a7336-2e533a538b5mr43880885ad.4.1791135548480;
        Sun, 04 Oct 2026 10:39:08 -0700 (PDT)
Received: from gmail.com ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6fe249sm24473095ad.61.2026.10.04.10.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:39:07 -0700 (PDT)
Date: Mon, 5 Oct 2026 02:39:03 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, taejoon.song@lge.com
Subject: Re: [RFC PATCH 00/10] mm/swap, PM: hibernate: improve image slot
 allocation and I/O
Message-ID: <asKPN6X_Rs5h8n3N@gmail.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
 <aruGQpdsq7_O-AC8@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aruGQpdsq7_O-AC8@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D3BF41C0003
X-Stat-Signature: hiz9dpixosgctj9ft91s6ka5foqeea1o
X-HE-Tag: 1791135549-242892
X-HE-Meta: U2FsdGVkX1/0sKpwMzKl+PNW5quxfIvxTVN5vR9Nxld6nUB5B2CTXfgzeaFdq5SsSrV+MeNdasgvWpeeatDgqC67LcEfbS/HkMKqZykx+DPEEFWIK6gGM4mMjzS2fePnFJ15yzu024dOA6wdE/eVUqc71pGU3TvkPXoA1ZIkhLKeNsZSr8ZcAfVUc/2tj7oPiamers0seqDub91aVE+gNeeLmhXzYGGM1We3EhHTmOResLm6aSCLpUETF+d/HwlMDredSGV06zsFcxU9WBzhiuEv8/4gBwgwXnzEpk2p1DZHBStRENP6gq/ZbZAYm2GoAwVexjmVS3FgHJGC9Vo9AhcUjwh+f6JdpBG0TPy6k7m/6cjP7bFfbvVJsURGtu07/OF0iMoLNUsk27LFaLG525uwTvD6gTbfc4L1ca8ZrTFRtaOtekEjfd/mZ33uynrPITdBMZ7/0ro/F2DsMWbZCrTVIl4gpYdM0Gz/AgmRpMyt5OhMkAgqSA2zOou0ULlH/8/91cZoGrjKyjV54hcqpnyDPsPw2VRfWxA1AqukeP2dYkQRReGOw6C1nIFi3qxe/t+W2Sp/Qo0keKGro1oGKGNwmDHciNfEqXsTpVjgiQYzgcDpp3/R2Juuy0yrm7/AN0NsgGWrAeJz3wMUnRPw1HUIi2kB1tcx7rybugjoouon/7fmgY5dNCMKY1srFsjD6owhOOl/xfS1ChF9HWfWJV0va+NGjN4rup7kNDuJjNp17CSEUmu3/gseSRMdrO6FVFwiDobAeVaYJR5mu9yUzIhDnw+39cD4toJvEMmr3ptWQeNEP118vEWdKLMQaCwXmP1qXfmgcXzyyfXJo16SAxalHznEG1Jn9SHgxAwlAuVgYKcpBkOdwS1r7i8tx5WgvSxlKV076fEtZi4wqpkR8naDQ2d8ejNWRJRNjiZs6mQKkWbGdwcf8BOCEjsrAtXVHDKFswErzLOMHVRAIhn
 I89dAeEy
 1tqVVN81iZsalZCqT2hPnTWzxlzPGS/VVkdEqc17315is5O1ZRDqgEupl445Uz1qL61c0GBLOC5ndzq9qJlIx7vDdgqnwLtK4w2SMntW8lsqfCTYwP359z3lINa0Cp/sMW3DZSrQyCHr9TCr37FW0Y0vHrZgMF792eOwPlTE73e3+X2Oo1az2b4lbhA0hBIIAMkxFfguBZrY6ghGKubEIyxXT28io2UTWJJ8oT+ihAH4J8kmgWu3YvlC5Nd6bgEiKohpEu+Sa6XnCP6wN9an94pkdxzqc4SRsOhmmLqwLmWrpIYqX1mlOSQPE97Ch92KxHZzT0HOyRMdTmPOm8nMHD579BoxHayCsy1OqIXkRpa+tJD3MvIocuTlMlLpRtVAZCPRT9zTDxGpXVfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Youngjun
>
> Thanks for the patch!

Hi Kairui,

Sorry for the late reply. I was away on a family trip.

Some of your questions and points need more thought, so I'll follow up
on those once I've reached a conclusion.

> Splitting out the hibernation specific part out of swapfile.c
> looks a good idea to me. We can then compile that file conditionally
> rather than having a huge ifdef block in swapfile.c.  Would be nice
> to get more feedback from hibnernation side.

Ack, I will keep going that way. :)

> That's pretty nice indeed. But I'm a bit concerned about having a
> specific cluster isolation path for hibernation.
>
> Will it be cleaner to provide a more generic cluster sized
> allocation (PMD sized) so common swap can benefit too?

I am still thinking about it. For now I am not sure what common swap
would gain. The gain would be mostly cleanup, e.g. the allocator would
no longer treat an allocation without a folio as hibernation.

> And I'm not sure is IO batching working properly before?

It depended on the case! Before this series the image is written with
a bio per page, and the block layer merges them back only while the
slots are contiguous. They are not always contiguous. Two cases come
to mind.

  1. The image shares the per-CPU cluster with other swap-outs on that
     CPU, so their slots can fall in between.
  2. When nonfull clusters have holes, the image fills the holes first.

When these happen often, batching does not work well.

And plus, on this RFC I manually collect bio before submit.
batch will work well from this patch as I think.

> How much performance gain is due to the cluster sized IO?

By cluster sized IO, do you mean the batched I/O of patches 7 and 8?
Sometimes it is cluster same sized, small sized and bigger sized(little situation maybe).

If so, allocator + bio cut the write time by 18 to 25% and the read
time by 11 to 20% in the cover's tests. The large contiguous I/O is
also friendlier to flash as I think

> But if other appraoches won't work or hibernation is really
> special, and we can keep all the hibernation tricky clean and
> simple in just one place, maybe it's not too bad.

Since you prefer the common swap code, I will try it in the existing
allocation path and compare it with the current swap_hibernate.c
approach. I will come back on this with the next series.

> > Note.  [3] gives hibernation slots their own swap table entry, keeps
> > readahead off them, and frees them by offset alone.  The single slot
> > path of patch 5 builds on that.
>
> Nice, maybe that series need a refresh to get merged first.

Yes, I will refresh and resend it soon. :)

> > 2. Whether the reservation in patches 9 and 10 is worth keeping.  It
> >    makes sure the image gets contiguous slots when swap has room to
> >    spare.
> >
> > 3. A block device of its own for hibernation instead of swap.  Not
> >    taken for now.  Sharing one device keeps the spare space useful, the
> >    existing infrastructure stays, and the ideas above give much the same
> >    effect.
>
> So is the idea for 2 and 3 here to make sure hibernation always success by
> avoid the allocator using too much for common swap?
>
> We only want one of them I think, and we need to be careful here to not
> make the maintainance messup by adding too many knobs...

Yes, that's right. Both keep space for the image that normal swap
cannot use, so hibernation has room and gets it contiguous. I agree we
only want one. 3 looks like too much to me, so I would like comments
on 2.

> > 4. Whether the extent tree can go.  A normal hibernation never walks
> >    it, the swap state comes back as it was at the snapshot.  It is only
> >    walked to free the slots after an error or a wake from hybrid sleep.
> >    With the slots marked in the swap table [3] and taken as whole
> >    clusters, a free could find them without it.
>
> The extent tree is not a hibernation issue right? At least for block based
> swap the extent tree is useless (only one node). I think swap_ops can be
> used to make this limited to certain swap_ops (e.g. file swap ops).

To clarify, item 4 is about hibernation's own tree, swsusp_extents in
kernel/power/swap.c, not the swap device's extent tree. It records the
image's slots so they can be freed later.

> And maybe, the swap_ops can provide some interface for hibenation usage to
> make things cleaner?

I need to think more about swap_ops here. Nothing concrete comes to
mind yet.

> > 5. Whether SNAPSHOT_ALLOC_SWAP_PAGE should refuse a request made before
> >    storage is suspended.  Such a request gets single slots from the
> >    normal allocator today, and s2disk only asks after
> >    SNAPSHOT_CREATE_IMAGE anyway.
>
> Is that a even a right thing to do during hibernation?

Sorry, I don't quite get the question (intention). Could you clarify it?

> > 6. Two cases are not measured yet.  A device with both a shuffled free
> >    list and partly used clusters.  An image bigger than the free
> >    clusters, so part of it comes from nonfull and frag clusters.
>
> I think that's fine, free cluster shuffle should not effect the
> performance much as 2M is a pretty big IO unit. For the
> fragmentation batching IO should be very helpful.

You are right. I listed it only because it is the worst case for the
long runs this RFC builds. For the I/O, cluster sized runs are enough.
Longer runs mainly help the allocator, which can then hand out more
slots at once.

Thanks!
Youngjun Park


