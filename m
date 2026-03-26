Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9975F106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2A26B0093; Thu, 26 Mar 2026 05:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73206B0095; Thu, 26 Mar 2026 05:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB09F6B0096; Thu, 26 Mar 2026 05:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF6616B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:22:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70A67E1150
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:22:23 +0000 (UTC)
X-FDA: 84587673366.11.BBADA25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C7CA640007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:22:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="T60RG15/";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mXPK7lpjr2jkstKjDKVsbA3b8iFRa96ykdWt00pnME=;
	b=wYK9inDkRFUE8KwnS9o6QwQ32dwhKqu+pdz7BzWobWeUUuiq04GxAMmvu4EjulnGaxqwzd
	JLeDNE+L+Eoeev6+sfYBqgivKCS+wURh2qFx5mG8sfwXI1LucVGSeZkJWOdx4l5njRm1yi
	m+kuBkR/zWCZo9BKaXIlUVH0DfeM2jQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="T60RG15/";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516941; a=rsa-sha256;
	cv=none;
	b=eV+xnkavYJZyTBQs3lFJB8HTvi6YzwaqktMN5TMpEIQgETgAGEotf8lzueJuYzBp82CluS
	y4pUkHkCVBw9M8pX8MiUKDjDb6sq9GKvMIfb/sxG7vHX3wZMoW22ZnUYsclWAQWp7Rs7oa
	YDgIep+u1euwUi43moPzt2weNkTl6tA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E36E3434CB;
	Thu, 26 Mar 2026 09:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24FEC2BC87;
	Thu, 26 Mar 2026 09:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516940;
	bh=5mXPK7lpjr2jkstKjDKVsbA3b8iFRa96ykdWt00pnME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T60RG15/SASIiyvZRlWG6a1ooD9hJY9bS2tA6RbdMM5h8CYGZkJYFCcUgeRPFHH0+
	 k27LjiReB/pF73NfKfcjawlYQqknkyCUNx8rqDjzhCYLNMRz7LuXCK4/407+mFWn5M
	 9ShhERYll6g4vHzzvS7LGpKvnXxYL5MbQsu/Wj6vpe1WAA2YxgmGYlR6Dk65+7+y8M
	 BGDKlFpI/uz1ryZMFenvcXSv+W+ddfEy07em7pGDJGzERCvReXp60NAb8zczQFkSng
	 QHN6PAJBiqwdIvdt5wIYlKid76Iwol2p1A26K/rtqTea3wv+suOKaTA3zrKhUAXeYu
	 CmKRkkmSXaSBw==
Date: Thu, 26 Mar 2026 09:22:12 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-ID: <a80b8a13-f9e5-4941-94f9-36b4fe1d16dd@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <acTc3JugF71I9Eep@tiehlicka>
 <acTlkB9WOGzVJCEo@hyeyoo>
 <acTrwjrv9Eq8redq@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acTrwjrv9Eq8redq@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: C7CA640007
X-Stat-Signature: reattihf6bkwxohis8iw7y9suskpsia7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774516941-990803
X-HE-Meta: U2FsdGVkX19WF2THtZg5pHok5CFy9MNVTCaIiD1+OsQdUKkU+pdrv9X2oq0C/1nA/jXYG25ymfe+l1OM05L/S8TAkShdFL7iw0r8fRAIgnsd2t6j/oo3YX1amrNWiH2r7sPL8kq/fn/Aun03i/fmiHcm/AsMHWwZYzCzOuHKj8MoHbL/2spi8dzPRVFnZV0OmfdHEFMPArRTFcJHzbnWJzBdJc6gceoVRGmPFX0bvAbB5BgRVHpSIDc4Lj6hovnSnIfq3MFbWhMcS+lnV4+At+o6/OVZC97WDuLb0lIxstxoz6+0sR6n46jhmNBR0zDMCUSCWqh+26TM//Ixk4l1eb5jl5rdWdPB5SfqbNAOltYZwx4z4EQbCEaFekFk3k5PrlI0yWJtpb/AF1Wlfy4KGKIEg8qVfqQ+sfBju75cMGeMAKlL4hw4FK/Drh0Iy9ymi6gsrweIMOrLtloC+KC7B4oaoaZqpjR8CETXpb+ZAJyGOJTXCFo8ERpv0qu1dRplKD0NY2aWsqvt0kDoEF1ypufhrGbzd5SSKzUYc3WHAFVKSUOKH1Y2utlg7jcz4bMqennSPD1ikmx7H486LuoHqqtB4jtAUJ5pjOr7udnorvIaCiJNRtbfir7K6X9WoBCjNaS+MsXhT7x9c+Xk0A3pkg45L/K9YpXorb069+deeS9/h8uXIWyUgtOj7xmSckDp6irWVTOd/BW0JGzIHDrXEyjfU38x/t8xorpUQrlphZt95Flo1gMIZEPxV/OFt69EXG8Infls6LwKk6U0G04rbAA7D2y+fNAGoSvmIKK0z5pbJV23MWtgrgxKItJEfAEXvXha7SotionbB/7d++44rTvRl91Ob0feHuGq4mzfGv+PD8+k7x+0yI8GCW78eF8l/9dwQCPWVlUsaVZlx2iAXjWbdQNnZ6z2wYBgOphq3b6WCIT/FFmPHnSr7Kx0TxCzQl4hKCaddpez9DQYLXn
 Dudg5iL6
 6WrWi3GAmNbFr8zTc3G/IAKTc8TZfmBFUoHVeGac2zgJEfD5rlt+boNn4CRcnkmRjGZw1lOCxbV+MPixNjjfxZeKPvQutQXTm2zODB6qneZCK2RMfalH8vr96C74M7qhY1JxQEW4K+h5s4faRoNBAzUACKVW8w1Kg0Ifu1gnFKypnw6j6PZE5A5wuZ5NGi8cm/vKKAl+tjzUl1PTe6URnBojVZ+vWeZx2PYbiOwXTBZITxgBCPM6r81kmQyPObtUTqNHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:18:10AM +0100, Michal Hocko wrote:
> On Thu 26-03-26 16:51:44, Harry Yoo (Oracle) wrote:
> > On Thu, Mar 26, 2026 at 08:14:36AM +0100, Michal Hocko wrote:
> > > On Wed 25-03-26 22:13:21, Qi Zheng wrote:
> > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > >
> > > > Hi all,
> > > >
> > > > As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> > > > (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> > > > update functions can accumulate and exceed the upper limit of a 32-bit integer.
> > >
> > > Is this a real problem without reparenting? In other words is this a
> > > follow up for that work or something that we need on its own?
> >
> > This is not a problem (as discussed in [1]) without reparenting.
> > [1] https://lore.kernel.org/linux-mm/138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev
>
> Please make it explicit in the changelogs and/or make them part of the
> series.

Agreed!

>
> Thanks!
> --
> Michal Hocko
> SUSE Labs

Cheers, Lorenzo

