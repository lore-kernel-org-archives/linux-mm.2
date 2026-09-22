Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3757BC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3949D6B009B; Tue, 22 Sep 2026 06:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345DF6B009D; Tue, 22 Sep 2026 06:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2346F6B00A1; Tue, 22 Sep 2026 06:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA0356B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:47:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82AC5A0445
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:47:16 +0000 (UTC)
X-FDA: 85241071272.28.80192B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC6BBA000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:47:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs/PHQPu";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790074034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IawLj7aqwzQGc78V1Oo5gGQ67uJJH0blchz2xUDXHGc=;
	b=6J9pfT3fnMWeOfNek32igP6/Yx0Dagmatq0+8aru7AOw5fC1qwMRaxGR5aq+Jy6SXBFpgf
	AiIqQAnIzvkAuCGoxsQI5Tw7zmn24WXcQdnBa9CWvIlwkCebuFQrs/owezXCsSvVl+qazt
	ynDBJ0HulP6BgnfM6ZaxiQuHvCO1rOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790074034;
	b=JRj7iX/7bm6Gltro6neQht/jKCowz9da37oHf+uSkaKELKzw2Cfgi3u4ZQ2ZOoBNjJbEYa
	HDLCUi6haSb55ctoA826tPIn5ytM5ci4oXN3MT+9fk9gCoufyPv0gnJ3lBhoXriqX1h4LB
	6YHMD+FeTq3RIDgUiYWkYLQz8J7PEP4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs/PHQPu";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A55F6021C;
	Tue, 22 Sep 2026 10:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E61F000FF;
	Tue, 22 Sep 2026 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790074034;
	bh=IawLj7aqwzQGc78V1Oo5gGQ67uJJH0blchz2xUDXHGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vs/PHQPuN9SJlA/5opT2vG+BItdARiKWnhmDyAZoecXIcm5CJua1eS0xuvsUwHFTF
	 x9hHYldMcpXJ0QSU0Me0VRQqkyXjGEqqxU63D5/kKy7Jacd+mRaJRY3paMOxc/3Vi9
	 HVl4mpfFzOAAjaQX8sbjC6mkRBWIm/b1X2iSPNbNLhVNQ2E8VPAE8Dq4Hz4zXE2VXI
	 buRSl9jM0z39Rle0zZ0v771qFBajKvVuD/6ROjIhu+seL6iGJLoEjWO+ULiB3+K7xL
	 rACxLPzvK7iKVoGxfFS2KiZXzupDNAOJaVnuJ9mmNkryS+tPzh9DWcnO0gTGRHDsl1
	 p4+8QZt+EZYdg==
Date: Tue, 22 Sep 2026 11:47:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	kunwu.chan@gmail.com, tz2294@columbia.edu, hch@lst.de, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
Message-ID: <arJcPIaqJOzLpkel@gremlin>
References: <20260921152449.629486-1-alex@ghiti.fr>
 <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
 <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
X-Stat-Signature: cq1xq7w1o8pum1e7s69qac7c78j96r8q
X-Rspam-User: 
X-Rspamd-Queue-Id: DC6BBA000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1790074034-563963
X-HE-Meta: U2FsdGVkX19KEDhmWxBmm1ZU+hwm8GUIq67fWouFXzMeYC9UR6p9kbbceq8KQnClVTuDVWUwIiY5/aZhQQM6sdG+KCmE4B9Pf1HQmF5YOyHa+YG6UAmOSv8xxvpMbrAgDAerI9+Cl0JH/3aDAFRgD9KQG9EJ/R9aRU4jbQdNqVFrSffqGZtyclrDtvkagTA0iAMYnv0n1bLShYpMnjBZqf8yAmoE3L86wksdjMWduKpMneokVtL3o++UQB/RVywg/peOvLrDcLIUVztDxR3rT3Zx9HTfhLBlmMttFm0nRj/KTRdm64+uMxRgJlFCFWOLVfrVC8StOmiThGXPEaXYT3zsvi7IZQY3FQi4mt39C2CpqNnhQlF4E4Q5ILxW++qk7jlwtxiMdFB+b0hk6Z/cfHcGnJdppzawoiZzLL0k+4Fh1Ujp4+Y4iRLjKEXKDA5uGDs48eZnpuB/Y/7TkqD3maI4ycPN9aQXmBXXUO8wbrM4iia+ZSPgkKST2zvw7DK3nxdi2X39NT9Mkuelz02NS+H5F38y95noOruhZFUCtWQm0X459i3mY+DPs44Kcet3CQJaUTSrveTP+OBZr+i8+R3Dbd8swUSU0eR8rxu6RKII3stAFBDk0QKyZg53/9Wa8g/zQAnKtYgD6ezpMH0s6g2tnXnMVAnYzj8LFzOwHX2gBmeLLwdoM7NVlSHNhoPs4aqDYE9RQ0p1ujcmPh/inByXrPp1yffdPF4j790+is3g2owGSU6auGskDMUQzAYsuZoeM2Bj188d+0qYlXgaQyt52Jh5Vl+2T3h0iauZ5gEhhF2txm6m9+GBSu0jJK2C+6IYDWurScdCIGs1u/OaXEfhrUQqVBItJ797wPyRSA+KN8ROhmr9naCpXff9BEJS4e4gL23rbqjAYnipV2YQWFvBnB1PrGdzSc5sV0h5ibWavC7WrOi2YMIKDjNvqY/Aw3EQX5Ptq0zNrHsrNIA
 wdGY4YDg
 QpHQE8ZUGb8PMgHWJnX4JRRb8wRk18DAoP2JvVZJHsKxYuyKRbBEUCXCV3b2YDerMsZoCI4UF+6GcaKPwiKw+tQSqQ5KwPsoLpGuNNeJE5chcY06k3AZGzJFbYxXGFcytlsI4bFj3rTp76hdHP/gYXGvysskQn1J8iSe96UutZXuOPGWTmLna7XoZEp9RBqRbQF6CAI+EUesyI4c2Hymw39kbDLoTrsOQCahNnC10GpitCmQ/falkoLcOytc2WY68Fjsnx8TTfoNXtRMJUulA6GOy4xd7zigzilUl5fz5ZmBj5MAlachysUDe1naOIfEcIyhwCiDW9lfUB5tBn+FC/d4TQ3bF5RIN4GkG4Y+WSs7wCrzEhQ9NcdLETWfnu4OBbtn7/O7SI8qBdhg8Z855j5JohYGV6kRyjP1NXWdtpHd/8pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:37:38PM +0800, Barry Song wrote:
> On Tue, Sep 22, 2026 at 6:20 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/21/26 23:56, Barry Song wrote:
> > > On Mon, Sep 21, 2026 at 11:37 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 9/21/26 17:24, Alexandre Ghiti wrote:
> > >>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
> > >>> PG_reclaim and rotates it to the tail of the inactive list once its
> > >>> writeback completes, so the memory is not actually freed until a later
> > >>> reclaim scan removes the by then clean swap cache folio.
> > >> But we have the same behavior when just reclaiming memory ordinarily? It's added
> > >> to the swapcache and only the next scan actually frees up the memory.
> > >>
> > >> Wouldn't we memory we reclaim ... just gone, like in the sync case?
> > >
> > > For synchronous I/O, such as zswap and zram, the memory is released
> > > immediately after sync I/O is done.
> > >
> > > For asynchronous I/O, such as NVMe, the swapcache is currently
> > > expected to be rotated back to the tail of the LRU and wait for
> > > another scan. Alexandre once mentioned that when he tried handling
> > > async I/O the same way as sync I/O—releasing the memory once the I/O
> > > completed—he saw some regression. So, delaying the release until a
> > > later scan may allow swapcache hits before the folios are eventually
> > > reclaimed.
> >
> > "may", do we have any evidence that this actually is relevant in practice?
> >
> > We asked to reclaim memory. We wrote the memory out to disk. We unmapped it from
> > the page tables. We made the workload the could, access the page immediately
> > again suffer already.
> >
> > We should just evict them as soon as possible to free up memory.
>
> I suggested this to Alexandre, and he found that it could regress some
> workloads [1]. That is why Alexandre is only making the folios
> immediately reclaimable for `MADV_PAGEOUT`.
>
> See Alexandre's description:
>
> "Future work
> -----------
> Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> prototyped dropbehind for all reclaimed swap folios and it regressed
> sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
> immediately turns cheap in-cache refaults into disk reads and collapses
> swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_workingset
> gate recovered it. MADV_PAGEOUT alone may still be worth it, since there
> userspace has explicitly declared the range cold, but I have not measured
> that case in isolation yet."
>
> [1] https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti.fr/
>
> Best Regards
> Barry

This patch as-is is just way way way WAY too complicated and fragile IMO.

Whatever cases you have found, they need to be fixed somewhere
fundamental. All of this feels like a hack.

If you're having to write a comment like:

/*
 * If X is Y, but not if B, and if Z is J but not if the moon's bright at
 * night, then maybe we will foo the bar, but only if the baz is blarghed,
 * ...
 */

That usually means you're doing something horribly wrong.

And this patch has multiple comments like that.

--
Cheers, Lorenzo

