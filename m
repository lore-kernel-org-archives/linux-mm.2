Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E69C5CFC0
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036666B009E; Tue, 11 Aug 2026 03:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29AF6B009F; Tue, 11 Aug 2026 03:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FF06B00A0; Tue, 11 Aug 2026 03:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C71466B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:36:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6769840380
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:36:38 +0000 (UTC)
X-FDA: 85088181276.25.ADFB344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C1AEC20009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:36:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzXBApLP;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kg9Mq7ZSC/CxtoGzamIKrqzJQJBmsfv1Nka3L2fwL2o=;
	b=azUmhiVIL0ZGEhBAYJOgBQBAW5A2mIoJ7weL30+1u9NoNCBji76ya2mqvZz30V6EdjZH6O
	4wak48k1+JgfFcr5LTFY1vr3x0geOhU37HOHhYRxjDyo9hVuBhBkoOhSETAPHK9NB/ETeQ
	zJ4MK4nXBOqvgsEJccoSoLlt5q7MjLU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzXBApLP;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433796;
	b=de4qWtychGs6RRSzc8X0kBql/dDKqkfK67OYg4PcJ6L+yDjrWET7LHzYo/hXi8a1kiQRjy
	H6LScnGhMm16g45sKx0CaKKGXVsm854+Xp1hOmEDCXhML6LkfHoaVfgOx8FKIegBInMyzS
	jG/ExsJl7EO5Rp6LPL4t39DGRtQdh20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF58141B5D;
	Tue, 11 Aug 2026 07:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DFD1F00A3E;
	Tue, 11 Aug 2026 07:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786433795;
	bh=kg9Mq7ZSC/CxtoGzamIKrqzJQJBmsfv1Nka3L2fwL2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KzXBApLPJH+/KdJv3g6MmEPGoRaBYa6IbDt6TrqYHS13QaKsUf1rp5xLiNmlpi26R
	 UUe/xYqxaPvB96GPxz+flfos8GUYRchEsY7XOmik0MYPk07SgWV8Lg0KdYQO77hhk0
	 DKgMhYawYoCilfx+uLwXZ7oDvXJybXWJeNKznVQcW00Uw87lULRN1LqikxidiBJPWV
	 4dzTLug+Kvrt2PMp6TWrYyE07SeOZdnelTcu02BUE1Soex7f09vNL2aQJ68GS+z5Tf
	 TghWYkfXod2/Gd4CQJXh48FsGzlJoujuEoAMY4bJHu8e/h1nHcgYzyZ0n8AO3HSQIV
	 sY0Jqm5vkufhA==
Date: Tue, 11 Aug 2026 08:36:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>, axelrasmussen@google.com, baohua@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com. r: 
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-ID: <anrQyYgBO95hnv_p@lucifer>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
 <20260810174852.aca0f73ab7ad71c70dcdefda@linux-foundation.org>
 <anqnAoFUUESi5Qe7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anqnAoFUUESi5Qe7@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1AEC20009
X-Stat-Signature: ygjzs19xfczatnjy3qwk7ndcp1r57bei
X-HE-Tag: 1786433796-776639
X-HE-Meta: U2FsdGVkX19LVUOSO95NPzsUV6FAgRRZMRhh6sLAZSUZ26k5H76jU0PrkDkR8o466R5t0OFaHIpThKKbCm7/amTflHLYC6vm+/7GauUs27mZXAdOvxZKgZQKYAwCEuylAoVB9SJMUCgsSXQWCQdLVhTGrpDeCw0atVC71mShChg4YZTt7Ho6OxvAll3pKKmpOImHrDxSK1aVXqTI5W6LAQIKIylY9xzPkWDDJPSwVceP6xEy7uuIU9dKugZC3XqdfqJxxEsZMVDkUVsUyuLZg1wbtzfNi99uYm12ebb7lqGOAJo+th0IIDnJwDD0xjroOk6lVztjf3OpzBRc1ak08hQI5isFqc1/siJjJUU6bRKQJVtz+h+x/n7RNvz+rRzOIrT+BOvzawB+tJTNOA6hebx3psnONJEmVpgIA2ABlUUrZIMz3Z0J79MLbP/cU9dcbrLyKTD4Ix4yuGszxGezOR8rt1XOZ09Iul6uhzWRA9Y21PiccRcKQHPVQCqxgfF5OHVxFis3YZ1cZd39llDj4DZIJhfb7ZCAQKle7hALSaksLfPwaVm5zNTwJg1bKZP6vL5VrPX2LAdZ12D0BvP2leJ0PC+iTE3HOHaSGs0jw88fdr6C8VirRAQEy4eYw/Wy1oA0omNPq7kCLW+4vvURY/Ot47we8L3TCJGLXsloL1yt3PWGlGOS2Ga/q18PeaNHUcIOgtuBZsPXIG3OzAlYd6y5CeSlHukBlOggRKx/D7DuCWQCtRz5KYczNLwQG/SpmHbSPltt8YRasXE/FjZdYeqgcUVU15dxbUYO7dwrlpcW4L9plMwpvKTOwexSG57N38+Kat4dbgQscblNScxI0z0B7t3q+wAgw9KQv14UtEyHR06CSjsFYGXytbZn85Nm/3TrfHhFmPmlEHJJFVAoFnckCcU7Nk7rthoqJCUIIMLUZDJnkovN53sDOQJLwNazlp8ZP1QzRXT2E9yPRE1
 +rigrK4c
 hgPLscZ3Orc6/oJ3UJgANenVBKv4+z14hgveCxOX2k5Ooj7/IZPN89DRFmPPM4EDFNBi6TgdZ1VDtCNG8jyNV8YSjx6A21z2ZT23RMECkA/jMXx5JUvTcHkjmJtfd3kDmWjafcp31gmQ1xggtDbME3SvRKGwXHzUu4lHlV2ip5u/IpT5REbd2k/n9eiAkQ9dPXLN9Vb6dN1q4nXzc4ab++QU5yoBfLyVISFXSVEbjGUmpEuSwl+vyUdSDdl2XM4rhwd7ON3kQ8u80uG+127Eddmy3n1iGL0Ppp7/56C3SOkq0JCyedpVspmjwbUKemBhZOvqhmsq2EahnvIGqvkhkAY9i+wNEXEI5T2Ekj1093LgTA92xjAdaN1ujUgl99hXTyfxpUihOMyhlQILntUMbl2DNeDy2FHfipEOchLUETSz6BR343y3/5kFfs/whhoIVkHhW7ZXy7MgyedTRnGsuNfRymQUhJpRd3ewd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:39:08PM -0700, Shakeel Butt wrote:
> This is memcg-v1's soft limit which is deprecated. I am more inclined to simply
> remove this code instead of fixing it.

Love it :)

The best code is no code (sadly we have to have _some_ code :)

