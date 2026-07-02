Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBBBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A816B00C9; Thu,  2 Jul 2026 20:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61966B00CA; Thu,  2 Jul 2026 20:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C0A6B00CB; Thu,  2 Jul 2026 20:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70E666B00C9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:28:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F436401ED
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:21:42 +0000 (UTC)
X-FDA: 84944503644.05.96A69A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F116820007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:21:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPwAbT8H;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012901;
	b=aJ159EjTSZ+8YfxYzwgd37WtUTiCn41mGTTeZgbHMXlklwyUwCtlbKQca9Kv/YU8/nTM92
	4vr8+N/3IefWLdFtP0R+UQtvl5ChhtyzVVtXSlQV1D99jxmmywEM8KUDeQKwij8b9ByrKv
	E+l+vCWrQ9S797rVBHjuyOGbD6P91qw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlRXSRPV++bjN7bWwif730RnQ8rU04i0r0nfsWb3/TA=;
	b=nxJ3KuHmpLYqZaBw/BoemjUabbYktEvKf1nZ5RLl1GtcYNrDGMnfdNHu0uyd4ku1ke049d
	UYEy7io36SVDE4DhAp9lCzWOoLTGHikEPZo9GruBxnVUhJqgX+l7+QMgdk+83w5LfBupYT
	HHu7POCmIYZK+JPXsYq30lk693fzsRg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPwAbT8H;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ED08601CB;
	Thu,  2 Jul 2026 17:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD651F00A3A;
	Thu,  2 Jul 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012900;
	bh=PlRXSRPV++bjN7bWwif730RnQ8rU04i0r0nfsWb3/TA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NPwAbT8HDhhJwYXY33Dl0zR0tlK6KPp3Qf5+uvgeCZ/8QR857KCccgKaOsw4GhBAL
	 3SLy6MqIVdEj6QwkhLc6CobBgBjDkDXwm1ocfYUNx3foMA28fo7obk4hHYkbm03azV
	 7m+B4liqJnSwEOUa48JE2dMlyc/LUC9ifQQzjC++vpWqKHSEVp8fgk76rxsRm9Ys5D
	 joaXOwXRy6K9wEUkejAbPvE2OacUKWvntj0AZLfoIuG1v28S2QnKRB+MxxYyREqWZ+
	 9tMWhOCChJ647d0PZEu1HT8AIwx/dYnWAp6DfvCbB8qFhmEs75UCglJwyrhslIeA6L
	 UGR0QPvOYCFoQ==
Date: Thu, 2 Jul 2026 18:21:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>, chrisl@kernel.org, 
	kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <akacmGGmzSODzPEY@lucifer>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
 <akTJsCTKZ5hMBf5V@lucifer>
 <20260701164613.008aa13cb6187ec9597bf652@linux-foundation.org>
 <akY_L-yuaCXBOXb3@lucifer>
 <akZis7j6xSjl8K_D@kernel.org>
 <akaXQyFlZi82SePE@lucifer>
 <b110c415-c9bd-4e70-ba49-107e355477f6@sirena.org.uk>
 <akaawVcQ4D4XSOKs@lucifer>
 <756f3fb7-5129-435f-a84e-a2af48e323ab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756f3fb7-5129-435f-a84e-a2af48e323ab@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F116820007
X-Rspam-User: 
X-Stat-Signature: bse5fsta9154d9as897jbxtkp1gjeijw
X-HE-Tag: 1783012900-92484
X-HE-Meta: U2FsdGVkX18ELGO7w0orqdxWLzYJhUYVQGW2kWRJx493KAxbuTYuNuw33TSiEZp2BxsoWEZHk0sQG7mbxPoXTV0IU6ssuk7ELAVErbC+5KiyNf7PxXh6Uot4eZecvdeZSsWv8N6taHSSbxt+utSlaIYNZthBILX5eP8JRSa+1qZhOv49KdxQx3JYpf+Yc/SJCkImDrIEVXtvO+H6MAQRdkiwCX3baTm+7qI2a5OUrrOwy0wKKdTgteD+442UXyeQosG7xuSQAZT5uirrvtt49IipooHUA4yxV62sF7mLU0MKKWtOkNj3QJvS2YtJpI0PewR6xaeWy9I5sdnnkYywSIpiT4Z8KZZSjxPxrC/fEQhT5Q2Xu2QEYXyros276LndoZuLnbwE/zbf0Xtk9FzKsNecb5+urzLCbRfR40SRB1AQMOY7J2mvPJeCWS8ntnHpmTV+N81JXizpWDTKqJiCocOQnBcxtsmrxNPGlJQKbfKJK1gbj+Z7mQJPqPu+gHm/sMhQDQRoinHZui9evQL9tsB7rGJQ4rP3t8sMfy9xZOc/AyN5t0Fa/aPDtr4YXdid0fji6tatBpIIFpCzDMdc5zdgnfSNQ0z9rwWM44U8Rm6OE5sa8Hf3eOWxeFJOFxMCak1hhiIGlopkWK5P0O/QyyGPECIEO8/kVlMae5zEdzJhC9SUg0w6nyOYyQvrAZbCy9FxnFt1EL7J3tFss9SJvVipOjZ6sVlEfZZCrNYjVJZQgpD1OyPmThhvtMQRwbpG7XIrULa+W1EiCEvznYX111sCZqwfVaiWkZ2OrlBSqrUC+H5IEghyiwSUrdm/2tYwI9r43SSpw+THNcmkVA/HYdCWUR7gl7h7TEIkPJrmhjEZx/cRC1z1ufxkrTkhIUoLZcMFlCsi5vRrKFm/ZYNpB8+4YfuVp6hiwTPEIPFn6k7D1kL9lJc1kUL2p6VLEllTv4mB97q3GgXjoSEf/xW
 EAmU8Cdl
 ffxhlarlZs3fsPZ2NQCAhf+ogo7EonPp6MSDZ8hBHVH9IPcV1te9p6o7SARQwamxFu+qOg0mt9N13uo634rYlwnv2SpHzOEUePbG76e/0tkrB3Ovju4Rd0KH8XDh9Fgh3lVau4JI9W560f9oqBvSMpmjeGphO0EH5Y66HmaQNZ2NkaZqvDLOQLQUPcmR1bn28ksoEjX59CWMaIz52hE7vAzQWQIEIyNSagXz3YWwfqOv4FBssxQvnsUrLPHpdwaqEVDs/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 07:10:34PM +0200, David Hildenbrand (Arm) wrote:
> On 7/2/26 19:08, Lorenzo Stoakes wrote:
> > On Thu, Jul 02, 2026 at 05:57:34PM +0100, Mark Brown wrote:
> >> On Thu, Jul 02, 2026 at 05:53:48PM +0100, Lorenzo Stoakes wrote:
> >>
> >>
> >>> Well we're very grateful for what coverage it has :) and that's nice to have it
> >>> work with email like that also, makes life simpler.
> >>
> >>> Mark - are you running tests based on mm-new? I'm not sure where things stand on
> >>> that?
> >>
> >> I currently test -next, mainline and stable plus my own stuff.
> >
> > Ack thanks!
> >
> > I guess in the long run then we can figure out a way to not necessarily even
> > require mm-new at all, and instead let our CI try to handle as much as it can
> > before -> linux-next :)
> >
> > As that'd be the nicest way and help reduce confusion about branches for
> > mm-next.
>
> If we go the for-test route, we'd still have a branch where people/bots/tools
> can do more elaborate tests when throwing stuff together. I still consider that
> reasonable, but we'll have to see if we really need that.

Ah fair point :) I mean we can have both of course!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

