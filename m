Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9797C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7DD6B0639; Fri, 14 Aug 2026 03:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E756B063B; Fri, 14 Aug 2026 03:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94C26B063C; Fri, 14 Aug 2026 03:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC7CF6B0639
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FF9CA03EA
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:30:18 +0000 (UTC)
X-FDA: 85099051716.15.F28B659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B1D8C2000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:30:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Va+k8oGv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786692616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQBSsh75OLcrl354x/64LYAkiDCqavFHyytqP9ZvYPc=;
	b=QScvIT4VmAAqOeOnLjRnVRXNrh/6JdBu0X1hM6XpnJTN2ik0UfKfd5pzv00qqg+2hpxKkv
	L4zEZ1ajMB2E1RE8foTfFdF5mYT57R0fxtOXOko7KIYpQvsS49iMj9H9ea+Fnv9LTuV9sQ
	sS+CSEMLhkmNpV0UKTJl03AsFOVxRYQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Va+k8oGv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786692616;
	b=VKIgXo+NSzgz27zXpH9noPEzM0mMFmaiqZhOUMsX4z6URrLcptTzVOiSz0ex2iXs3vkSMn
	iU8EIr70U+f24UUjRopH8egNzbnziScAmQb9GKX74OcL01lTc/WR/t1DtCPF3NGf74iT9v
	F7KEiZspl43B8Hd/s0tl31MfBsXut88=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2EC4407AE;
	Fri, 14 Aug 2026 07:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58521F00A3A;
	Fri, 14 Aug 2026 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786692615;
	bh=aQBSsh75OLcrl354x/64LYAkiDCqavFHyytqP9ZvYPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Va+k8oGvs2PQFjlESywwxNn/dL+w56yfXXWQaCX53AyulvIjzIT+kJgG9lhzBiK25
	 Ca/JSJRMz0Cbm+UuWl8MbawSdAzAyGoSbdH84wjkTVlD2opT9yOzJFwe2ARXb/4d8H
	 3/kumAUzshKDtjo+aqdFwkEIbeSU9yaaQvGv7ULtIdc+4LLY6ta5TL0pEgaurodr9P
	 IKRf/MVJgaVfUHxLPxgzS/rZ6mYAh4sMdGEKpgXq/4dEtRzcCOT08MAmgtxoLCmOih
	 v4BTIdW/GbED5JsL23jf4l/YFenCkPOzG+v17tjWZ39rHPoGV4K3auTmv9t7ZN4hWf
	 +lSQzJ0yE4tbg==
Date: Fri, 14 Aug 2026 17:30:07 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: xfs: properly account xfs_buf items as reclaimable
Message-ID: <an7D_9YRVDG-0Qjq@dread>
References: <20260813204929.2253988-1-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B1D8C2000A
X-Rspamd-Server: rspam07
X-Stat-Signature: fh3no51qpanch49ehw695ye71giwdrq4
X-HE-Tag: 1786692616-35412
X-HE-Meta: U2FsdGVkX18Ck3STfl4rXB5cUqs4u8RAoW/6mXva9wuOHNa2fQ9L7Bt0BjKu7yPtPUIsKj3nhAO+DyN33Ivw4wC/U+49PGK88Pw55tW6nCfN4A8yzO4Uc9fW9TvnQJBAZGkY43UxlPfJPHoLtAUvuTTbqM2sndOB0Mjg3eSZ9FMHwk0E1v0ithZwPvxSTdzUJspkx3q+dbvL2XTegPAdVJszTAa8tj+aoG7eEecjgXvTjdakpCX6JOp+o12AWoG/wxA0fM3+dCbDQPOmIo0N9n+IL0KPMEoM8ZCwiJWQ5YUsE39iNU1YcUTpYlB4wGDIQ/62x4T3AFdFX5WH9Ku7qmQnNypONCWwfvxefJV69VWn+MvbvKgAlpCGF1syXhUc4TfFaeaB0VP0JHNXTjtLPWii/CpXokuizboVAJWHLwtHctkBKlT6V65oYril8Xsh2BX6/q7frYPVIBfh5iElnrZgVjbd+sQ25B5KXOWxW+jB/10cGHup6Vxy9eUDzw4mQdUma0qXrDpo1ENiKZI3e+reoQYZeYs/guBRMwoW3Z90OwEeVgimm0feguvFJTM5qaJcStev2l4ETQ3jI7Mq+JdnJc6HqXpQizAdMShtXT5sGsuTk+WMX0KeyBemZiEexT7X2cAnu9hPiLTYrmPId+BAQDaW6SNYAnzOlIK1U7EOVc9vVjIEXY7S0W7WgEwK9LsfbyRTN8+ZNfJFLoOtiCVQ96RM64hGlWOZzb7ZFN6Zo2kBjGFTP/dFY+rduZdyHG0SJdc5IIGXYsDeETEgD1BLAUbDu5BN/RQwSpRZfLdUEGX4abjkLfQk7ymd7hMqxm5/E6A2v3VJB6q9doWRmW5ek2DZsavtO3Pm9Ot7xt7En0dbSD6TpdByLz1DM48viptp8h1LOW92XCzmNkFbOMyMXTG0aTRM6RWGn1ZeAsp/u7bQDg6brdPmTel8wWP/sfS00Hlrsb6XJYgwIBy
 0e+4g8W4
 iO6pOhJ5yXfUfcd1w2md20u/7WTjX9CWkpDQ2/iAWF06Y3jyRaQ4O0nadwl+dg+EKP4O76m1ULtMKh0LLssROhP8jlOr7FIdZsBaSjXmTFf208TrYRrtxvMYenTI/dDCkWiE2E21oe4hqPmteQMxKHHa40j6dts980OXwa06XrhoaCnmfc4u19aKrg7toSlFc1ECVMqzlinOqihw/2A9QVb4GFl3JG+D1uL2RhV7qeLpEff64maROTkGZVPD8dvyCoV+l2/MfcwvzrXizaQ+PrxpIFA5wmXT3xAkQ0vnaLpXLhMYCgrt4krQxsS13W0APQ0N3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
> It was reported that xfs_buf items are not accounted for as
> reclaimable,

Actually, they are:

        xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
                                         SLAB_HWCACHE_ALIGN |
>>>>>>                                   SLAB_RECLAIM_ACCOUNT,
                                         NULL);

So the xfs_buf items themselves are accounted as reclaimable slab
objects, and these are what the xfs_buf shrinker itself acts on.

> and therefore various statistics in /proc/meminfo
> and /proc/vmstat do not reflect their reclaimable nature as
> other slab-allocated items with shrinkers would do, which in
> turn affects the accuracy of stats such as MemAvailable.
> 
> 2 patches here to add accounting for xfs_bufs allocated via
> xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().

That's accounting for the memory attached to the xfs_buf, not the
xfs_buf itself. We don't use the size of that memory for reclaim
purposes, hence we haven't ever tracked it. It is, however, fed back
into shrinker based memory reclaim via mm_account_reclaimed_pages()
in xfs_buf_free() and hence memory reclaim correctly tracks how much
memory was released by the xfs_buf shrinker scan, even if the user
visible stats don't show it.

> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
> that's a relatively rare path, and the above two will capture
> the majority of xfs_buf allocations.

I think both folio and vmalloc should be accounted in the same
manner - as a number of pages based on the size of the buffer (i.e.
same as mm_account_reclaimed_pages() does already). It doesn't
matter if it is vmalloc or a high order folio, the amount of memory
is the same.  If it gets accounted to the node of the first folio,
then it will at least always be consistently accounted, if not
always 100% accurate for the vmalloc case.

> I've cc:d linux-mm just because i think this is the first
> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?

These are fs buffers - shouldn't they be accounted as something that
reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
going to do this to make meminfo/vmstat report the memory usage,
shouldn't we make the effort to classify the memory usage correctly
for the user?

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org

