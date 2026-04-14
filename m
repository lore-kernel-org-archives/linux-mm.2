Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CA3F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69DD6B0088; Mon, 13 Apr 2026 20:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A756B008A; Mon, 13 Apr 2026 20:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30106B0092; Mon, 13 Apr 2026 20:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0CF76B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:39:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57314B82C5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:39:11 +0000 (UTC)
X-FDA: 84655302102.11.168D1B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B44D3180002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:39:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l79wa0HR;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l79wa0HR;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776127149; a=rsa-sha256;
	cv=none;
	b=o3+9HLWCG3u/GPJAcxezfEc5SqUmeUbFlw250C3x/zpQleIev5kNij8aPI9KiCwDztpWO+
	ZAkDy892/aED6kU50qtWFMNnR7DL8XS9uvdROkdCYe7h76IOfq22WeaFEIcgLioFr1xv5O
	QT3M8RwbhNFXvEbnZQ5lYo03yZhAZ/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776127149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n43kFBeoC06JZ1MpcvpOZ6EWMxQkuczpCZfnmpEAFA=;
	b=gkufkp3HHPqGcNR9oTb0FyKsKGDWa/4AJrQTXh+z8aeKRA7zUI3rqIz5XNpOkeQBmUpbcu
	M+8KRolYV0ysLbAWSuirU9UA/O9qEQdF8zpajeQowhE2Y/Nx7REJi+sfs5FC+zGym+5awl
	n2DBa0BqYNpSPOJ9If6BGpjjCp7IszM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8349943FD7;
	Tue, 14 Apr 2026 00:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343F1C2BCAF;
	Tue, 14 Apr 2026 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127148;
	bh=0T9EJqjoj0FC1DEZoyXGcf1oSecBxT00S22yS7p28XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l79wa0HRrVqmEmDQc9OjOwwXJN8MYyDuMQOz8/K+e+FE3w5+FbiPNd2LXktWrmq6h
	 W+t5y8WT79vZkAAjWG9PbvXFjezsinJDAhD1MEKIkW2DPU0XFskKdFSIqAbNDjJzf0
	 RNDu7r+lUrsyGXUfrLg47YWmw4l7HxmRtjD0JSlh/nRwizmmxqX+k6J/jZdSsN5pD+
	 mzW1mRDpHmuZaFLfemQBvoT5bmGXvApe+dtiPzymj9seDWUjDTEQpFk4PkJ3TQ1ejR
	 E/2unyzgkq6eiN8qqfxjZl5oIch1srWnKUAfQMel0vIKbKvfcTO8arE2vao7Xjrl9n
	 wX85iKr0xGTxw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Mon, 13 Apr 2026 17:39:03 -0700
Message-ID: <20260414003904.83824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260413184845.5130-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B44D3180002
X-Stat-Signature: x8z1r47bx19jzkbrtq5nttj58xqu1skf
X-Rspam-User: 
X-HE-Tag: 1776127149-1924
X-HE-Meta: U2FsdGVkX19Xfbz3rwCbmokISkHMiW3JkxOspol752izhNc1C+QJfY4F9kjLSwitUI2owfmjOIZ2QCUGP5e4ZXMW+tIAQYuEA0uMcCt5FjSn8hOP4iaSK8kRnsTrAvnUUb2pUkTLYRLILi3tFxJX5BDADyn/cbvTO7pL1tAxabx9Ag4ZmshSayWtTRZd0NATHp2RjD1LHR3v205Sa9uwAzJ7zotx5j3vTi7XbI5d2J7913nU5AUm6p6Mw23Zt3os30Ofc9Zz32Y8MOCwtac5cYT5Q4CtSXWlUyozFfQ4TFKD554H/I6WapIsE0mPj5oZ5xN4ekDqq+DM0yfB+ihnZMwV27LVEtdJn4t4cKtchIdTCQCe8lVd/Q5+CdKWFr6IJ6FjUO846h5P2NSoLOSn8SX/NlBw37y/Xa71zJ+ZCQDhTYuu9izn/842C74b2ggiHeT1Z9npC7S7lhIaUUvBKgbZd49MY5/HcgYCJQ0bOQpn7MZni+7jAjRKJz7JFEQrBgJWtTZC609mUKAPLp/9pk91NwWy+tdHm6XySkEeuu2W/USTUUNGq0ZipcrEW4BRaElgxPu/v4NuumcHa/oodGE6/KHcwLyM5oouNFL0XKJtPeZNqRRxQrDANhbtgI/xo5FAIeuCgcIZHGGvY4EtCQXZuevXr1egIRkqQAfKSGh+14QoX39FcTYd3mglyaE8RVXJeaiTSsqEuy4RRjqzsRwijr0jz0pvIr8QGnZCJhlJn6+VSzCqJ4toSRLrosGxkNsfVxX9BCGbrN/MnpBznfINFz15rETlIXibu6QkcZgKyOxZgorLK7UN55Kvn8xm3C/IEQKhNfI3Ef8XmE7N3zu9adtn3eRBfYJttWwRLf2zmHzhs0fzE6VA3wSa5J9g3e7yq4rWe6H9xY958w5hDiBrt9HmKaKTOa08v3FetNAxUX/z1JmCjnfr1xlBi/1Tvjccu82zs5QDVR/6GZC
 uhuB//GF
 B1wF3q5ax/PfDFJ0raEcA7LTT+Aufji7duipD+7qEsQkY946qh+QqgbyCR58bxoNBgDFpzdYPT3yG2SxoXnIK+HnCJEWE7FxLSb6vpzdwQ/rBa9fjnOJzGuruVmRxa002XsDir6vsAxpKA4b446wBJgwnqf1VHUF3fCEFSeaNIW1PFPbjeYP68NcSxcfHUutYbCD53reZ/prCm0kCzCCx3Ptx5yTZG+G42dwmTvXzDZDc9MLjG1K7BzdV4GLbzaDXUPjTuHHknVAOfPsI9F7uhp9pkDByjIo8cpaEDrv9G+8snOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 02:48:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sun, 12 Apr 2026 14:37:19 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > On Mon, 13 Apr 2026 03:04:55 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > [...]
> > > > Next Steps
> > > > ----------
> > > > 
> > > > So, what to do?  Please prioritize series B, if you still willing to do.  It is
> > > > ok to keep doing series A, but only as the minor user experience improvement.
> > > > Clearly explain the whole context you are aware of.  Don't Cc stable@ for
> > > > series A, as it is only an incomplete fix of it.  The fix of the one trigger
> > > > point is just a side effect.
> > > 
> > > Yes, I absolutely want to continue contributing to DAMON.
> > > 
> > > I realize most of this confusion came from me misinterpreting your words
> > > or making assumptions without asking. So this time, I want to be
> > > explicit:
> > > 1. I will remove the Cc stable@
> > 
> > Please also make the description of the patch clear.
> 
> I've been thinking about what you meant by "make the desciption of the
> patch clear" for Series A.
> 
> Here's my current understanding:
> 
> "
> This patch only fixes the case where kdamond terminates because
> 'min_region_sz' is not power-of-2. Other causes of unexpected
> termination (e.g., memory allocation failures) are not fixed by this
> patch. [Seires B] will address the general problem.
> "
> 
> Is this what you had in mind? Or is there something else you think I
> should add or change?

To my understanding, you will make series B merged before this one, right?  If
that's the case, you may not need to add this description at all.  Rather, you
may better to clarify this is only a minor user experience improvement.

> 
> > I'd like to avoid delaying series B too long, though.  The bug is not very
> > critical, but better to be fixed sooner than later.  If you have no enough
> > capacity, please feel free to hand it over to me.
> 
> Yes, I have enough capacity. My exams are not until a couple of weeks
> later, so I can focus on Series B now.
> 
> If my schedule gets too busy later, I will let you know and hand it over
> as you suggested. Thank you for offering that.

Sounds good.


Thanks,
SJ

[...]

