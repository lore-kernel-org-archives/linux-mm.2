Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1379BCD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5DB8E0008; Wed, 12 Nov 2025 20:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D558E0002; Wed, 12 Nov 2025 20:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA868E0008; Wed, 12 Nov 2025 20:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC558E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:33:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6E795A8F9
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:33:36 +0000 (UTC)
X-FDA: 84103861632.05.9E28875
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id 845781C000C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:33:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762997615; a=rsa-sha256;
	cv=none;
	b=4QvqMsSuf+VB5GNLmmw1PJxkP2a0y5VhGre6oZVIMAdYEBm8GyVlvJ/99NxS+tsn1svbuX
	lElT2up4WrHqu46RVjoCbx1Z6owWci8r8BUXwOxbHAhK+LxTKLnT/gLsQcegP/Mmnd1K4G
	sme1S+/21Y92XHOA4z21vSILUmsZSQQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762997615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Fi3qOQUMh4P2pt8VGNkEYIim9KYTs0ww4k+osQ2CWg=;
	b=CfdGe3vPCzo3e2glXywgGho68Os5ToSbC7hwNjfbW+l2sbbRPGexQwwCBaaCZmMrqj3Ypz
	SiOARjRXNisVZB1NK3LTWYmAGpTVuengjTX0Y8fiEqGG/35Q36/jT5UnFspqYyhT9aMz2I
	9O4eZIeaXIeNBLUpcqKp28nv3P+eofI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Nov 2025 10:33:29 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 13 Nov 2025 10:33:29 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap
 control
Message-ID: <aRU1abZaS+c1rK4R@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <CACePvbV80ZtC2FL6Z-Y4Rg=5bzdi1O8zqQSMEGuxqhj5P0txsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbV80ZtC2FL6Z-Y4Rg=5bzdi1O8zqQSMEGuxqhj5P0txsA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 845781C000C
X-Stat-Signature: xa75b9g54aekpaqofrfm1s6jpjix9cs9
X-HE-Tag: 1762997613-483799
X-HE-Meta: U2FsdGVkX1+I607pwgLKEpmi5yMlshqLTMAD8+2EGUKHqiF6S/tShDnrqyxCnvIHva9sO6mJ51584yvZ8XGFpw+gnN8WaZxggJ542URbw04v0N2aATdz2gTKcDLsuZiM8uAuwUkLtuA8kJdnNEMSGzZ5xqCHCeKn9aUjMvxYCCvhkpNH/kFJTlKyag9O8i/+hi91Uev4KMGjx1ZIa17b60kJ+z3F5i2BQqri7oRsEgH4LfcoCX23OLNYARzjeTpuxU4ENAU7rsv6r2akF0XGW96AqWZWZFaNGlxjWxCUuN14dzKoDhtN51IwakagWrTermITCiWTjTi7peETvMl6UNZRomMindwBLzveNWSAVprH69T2g3NTa7+/7SsprksAgKScoeR2ek5J2H483RQ7w1VX8TgzzGYUmRO7N2unRfvWLOXJ6IEdqNXR41dmEWFw7LsSRV4LTXsQrnG5ZS+72E3HU6D4rV+riW2y+OP6RW4lUkiTy/zwBMyFmbGlfOR8AV4FF1hKeiNctqDYtc/zUN4k7cE1hRlR5Ce7fjPM2bKIh7icKJnKf0q7YR/g4kSdcNPCaJNEgBEEmsifWeS+VOkjC3UTVCJu4in4aYE3yW9HBhrJhJ5GsNAZ+/Q6NWd0wlv1FZbNKDrYSVLujadhAvBstPkNSG/BvU52cDk780xS9of/Xn3wNfzSLuZJqHax+uocBr6w8p4bsT0b96SP9dvkFCRPkhNAXhk/1x/QJ46FM6Z0RUJKxiLoR4uQpBt61OLYOXzRfcksAfGDWBY6GzJChnMAvR5VubM4b7kb+LV0svjaW/Z5H4SZw8ofCQH25dRtYnSQBFP2oMvW6+ehLorK8xOXwYI5RI4YzaukC5K7vL3PqRYZXXADJjpuc6su2qBY6sCqsguAMcuWHh6slhT22bLs8pNmvcNsDKgjS6wIeiTX8mzsbU2AZGKswHWjz0aeXt7rrUFcHt30sQO
 Npc4yyVH
 9pnQ8nAx5Z/0Difrnxt/IxlA1aNAhoR9rvCDiPqpbf6F87MxhT3JxqzypbbiGxwDhYDxFX0+GSkOpKtkzZ1hqLNhOlPaoA7M8bVW2OZOde8pe3vHDC+A1pD5ZCigCgpn4hBKYwlmoChM8657w0lGgBmcY1CnnjLNjykM74MI4fWrLHnPprJJDF11oIho0l1e7zVOM7VShvXIbfoIEOn088kIbxqdLg8PetgiJLh1V9vEVB/rNQDz3DhoZlNUjd/Fz22xe9fZ+yVc/1zs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 05:34:05AM -0800, Chris Li wrote:

Hello Chris :)

> Thanks for the patches. I notice that your cover letter does not have
> [0/3] on it. One tool I found useful is using the b4 to send out
> patches in series. Just for your consideration, it is not an ask. I
> can review patches not sent out from b4 just fine.

I manually edited the cover letter title, but made a human error.
Thanks for the tip.
 
> On Sun, Nov 9, 2025 at 4:50 AM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > Hi all,
> >
> > In constrained environments, there is a need to improve workload
> > performance by controlling swap device usage on a per-process or
> > per-cgroup basis. For example, one might want to direct critical
> > processes to faster swap devices (like SSDs) while relegating
> > less critical ones to slower devices (like HDDs or Network Swap).
> >
> > Initial approach was to introduce a per-cgroup swap priority
> > mechanism [1]. However, through review and discussion, several
> > drawbacks were identified:
> >
> > a. There is a lack of concrete use cases for assigning a fine-grained,
> >    unique swap priority to each cgroup.
> > b. The implementation complexity was high relative to the desired
> >    level of control.
> > c. Differing swap priorities between cgroups could lead to LRU
> >    inversion problems.
> >
> > To address these concerns, I propose the "swap tiers" concept,
> > originally suggested by Chris Li [2] and further developed through
> > collaborative discussions. I would like to thank Chris Li and
> > He Baoquan for their invaluable contributions in refining this
> > approach, and Kairui Song, Nhat Pham, and Michal Koutný for their
> > insightful reviews of earlier RFC versions.
> >
> > Concept
> > -------
> > A swap tier is a grouping mechanism that assigns a "named id" to a
> > range of swap priorities. For example, all swap devices with a
> > priority of 100 or higher could be grouped into a tier named "SSD",
> > and all others into a tier named "HDD".
> >
> > Cgroups can then select which named tiers they are permitted to use for
> > swapping via a new cgroup interface. This effectively restricts a
> > cgroup's swap activity to a specific subset of the available swap
> > devices.
> >
> > Proposed Interface
> > ------------------
> > 1. Global Tier Definition: /sys/kernel/mm/swap/tiers
> >
> > This file is used to define the global swap tiers and their associated
> > minimum priority levels.
> >
> > - To add tiers:
> >   Format: + 'tier_name':'prio'[,|' ']'tier_name 2':'prio']...
> >   Example:
> >   # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers
> 
> I think a lot of this documentation nature of the cover letter should
> move into a kernel document commit. Maybe
> Documentation/mm/swap_tiers.rst

I will create a Documentation file based on what is mentioned here.

> Another suggestion is use "+SSD:100,+HDD:2,-SD" that kind of flavor
> similar to "cgroup.subtree_control" interface, which allows adding or
> removing cgroups. That way you can add and remove in one line action.

Your suggested format is more familiar. I have no objections and will
change it accordingly.

> >
> >   There are several rules for defining tiers:
> >   - Priority ranges for tiers must not overlap.
> 
> We can add that we suggest allocating a higher priority range for
> faster swap devices. That way more swap page faults will likely be
> served by faster swap devices.

It would be good to explicitly state this in the Documentation.

> >   - The combination of all defined tiers must cover the entire valid
> >     priority range (DEF_SWAP_PRIO to SHRT_MAX) to ensure every swap device
> >     can be assigned to a tier.
> >   - A tier's prio value is its inclusive lower bound,
> >     covering priorities up to the next tier's prio.
> >     The highest tier extends to SHRT_MAX, and the lowest tier extends to DEF_SWAP_PRIO.
> >   - If the specified tiers do not cover the entire priority range,
> >     the priority of the tier with the lowest specified priority value
> >     is set to SHRT_MIN
> >   - The total number of tiers is limited.
> >
> > - To remove tiers:
> >   Format: - 'tier_name'[,|' ']'tier_name2']...
> >   Example:
> >   # echo "- SSD,HDD" > /sys/kernel/mm/swap/tiers
> 
> See above, make the '-SSD, -HDD' similar to the "cgroup.subtree_control"

Ack as I said before commenct. Thanks for suggestion again.

> >   Note: A tier cannot be removed if it is currently in use by any
> >   cgroup or if any active swap device is assigned to it. This acts as
> >   a reference count to prevent disruption.
> >
> > - To show current tiers:
> >   Reading the file displays the currently configured tiers, their
> >   internal index, and the priority range they cover.
> >   Example:
> >   # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers
> >   # cat /sys/kernel/mm/swap/tiers
> >   Name      Idx   PrioStart   PrioEnd
> >             0
> >   SSD       1    100         32767
> >   HDD       2     -1         99
> >
> >   - `Name`: The name of the tier. The unnamed entry is a default tier.
> >   - `Idx`: The internal index assigned to the tier.
> >   - `PrioStart`: The starting priority of the range covered by this tier.
> >   - `PrioEnd`: The ending priority of the range covered by this tier.
> >
> > Two special tiers are predefined:
> > - "": Represents the default inheritance behavior in cgroups.
> This belongs to the memory.swap.tiers section.
> "" is not a real tier's name. It is just a wide cast to refer to all tiers.

I will manage it separately as a logical tier that is not exposed to
users, and also handle it at the code level.

> > - "zswap": Reserved for zswap integration.
>
> One thing I realize is that, we might need to have per swap tier have
> a matching zswap tier. Otherwise when we refer to zswap, there is no
> way for the cgroup to select which backing swapfile does this zswap
> use for allocating the swap entry.

From the perspective of per-cgroup swap control,
if a ZSWAP tier is assigned and a cgroup selects that tier,
it determines whether to use zswap or not.

However, since the zswap backend does not know which tier it is linked
to, there could be a mismatch between the zswap tier (1), the backend
storage (2), and possibly another layer (3).  
This could lead to a contradiction where the cgroup-selected tier may
or may not correspond to the actual backend tier.  
Is this the correct understanding?

> We can avoid this complexity by providing a dedicated ghost swapfile,
> which only zswap can use to allocate swap entries.

From what I understood when youpreviously mentioned this concept,
the “ghost swapfile” is not a real swap device.  
It exists conceptually so that zswap can operate as if there is a swap
device, but in reality, only compressed swap entries are managed by
zswap itself. (zswap needs actual swap for compress swap)

Considering both points above, could you please clarify the intended
direction?  

Are you suggesting removing the zswap tier entirely, or defining a
specific way to manage it?  

I would appreciate a bit more explanation on how you envision the zswap
tier being handled.

Best Regards,
Youngjun Park

