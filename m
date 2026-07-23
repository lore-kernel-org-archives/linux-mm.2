Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B70C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D386B00A4; Thu, 23 Jul 2026 07:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335AA6B00A5; Thu, 23 Jul 2026 07:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24EA56B00A6; Thu, 23 Jul 2026 07:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DABF26B00A4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:39:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DFD31A0476
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:39:30 +0000 (UTC)
X-FDA: 85019846100.17.0D219DC
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE20E40007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:39:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=beah4yPiJA7BeEtfLv4r45Ojuj4UkjS5TshRQRqSqmM=;
	b=DV9dpRBJ4F7AybFHpsIs/SFBLkJuWLo6NFKzau5HT8GArfiMDjfaoNfGzFr9tnuM3KJw4l
	6zHUHyyLZqJLQZte5gg7CQ6ohwmxNSw3KXthCf09gg0wR+K8QHyUvwfuT6UhAU/KuUw7/1
	1h/yE71iReDk5UbZ+gS0asuubq8rM1A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806768;
	b=AbxK7O1JPmxii0NOkgwEvtus6hDYWF8OzXNJoHqEQzcZcsgjlINVrLWsCNyfKqcRgifDt4
	UEF4CjbURQLAqe8Frflgmh5HG8jWkKztyeSTZONdtoamOSF7cw/0Oh/ySSSlWSgBnFwFh9
	TMVuWOs9KNUqavk78CJRkm4kok6URv4=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.51 with ESMTP; 23 Jul 2026 20:39:22 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 23 Jul 2026 20:39:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Jul 2026 20:39:22 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	h@yjaykim-poweredge-t330.kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <amDCIl51NoNPL7Op@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDCIl51NoNPL7Op@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CE20E40007
X-Rspamd-Server: rspam01
X-Stat-Signature: 3ibrb5t4pi6wwm7n3tj8e7bftdhp5ioc
X-HE-Tag: 1784806766-456143
X-HE-Meta: U2FsdGVkX1+w5RVn57VCdmHQZn2cMq/N9jChr7R+yB7/2dz+3lP0WTVN1BjH/MwQ2QzMbpeS54zvrZUZXasBIIMUHWIRybZbpT1Jn3d/2oTVmzFn2y/LGz7Wu9EAFDzXhrm8MYnnkqj0dP4i42LxAgzkGaizP9JoixjaaDTUCsPYl8JKV8+M4z2pmiyx/mYoni3fvl9U9kaGqAikFyrXZoPV8emQO+ITByKM/jk4YPIU6d68lU7Wlgb9Wugy4geJv0rwaRLE3uxbqWSwkTzSDf+ol2wVcxlzlaEx+5KHbvxPj2A0WlwtObayLJ1ZoXcAFPW7NcbdRjIdsN8QJaRZJH65K1220IGUkG2A/5pieQSAnCIDEAL7gGP0b6cHJo46Su4IPPOXRNrRgkZL8KwPoJTPWjn+cQrxidzAsVbwhMBP53Nur8/iQHgTKZ4lVJc93ACUbL2FkKOcbT532gMwZfc8ww6gJTWy1o1o/0kYBsmIe0rNT0t/8YaLLXf12feHbolKCnjSKXJsvs9pt98TG7+TJsWFaqebWP7XWsdjnbBSBKJWI27N6MJtn15uiYrT4UIZDrIG4nH+52R+MJ0anwBjXuS6uonFBXIQhmHL3uzW9jWjzFb+HV4qHQadpbqae+xhb+l89SGHqH8ZtQ20b1xUgrcIQ8fbnk4l2bPLOiQxNHtOOGryp3zy6zZsN5JRlAxJnfjowu7I94QWBP9vWGDhJMV6gZ8HKQmz8K/sIZvfqGpwaRATc4Y1t4w5/Q47eqXJLPe0F/iWd3pj8I0XMH5UQ/jP4yAbOYMU9kcMKZ9U27GvNMTFrOUKsdQyT4gnHAUye4DOcLRfglIWal8oTGtyqc7EoXwVIaON7vNSmfp3F3Z6w3wFze6uoKW7gvZrfRRmc6BIJUQ5yxpEKonxrpE/nR9eKgLp1jHtZlB4URg2+EAC1+JuKZSkG/dshVB4eE/GtyVtX6ngwsXaSNL
 gekKjqNc
 5Ex+GjUiKYI6qRbl94Tl0eANkKsLFPX7UoXodWyyWnjthjgCk/9BIOd40y8kfH+PxipxB4iF0rmQtaBF2fn/z4jKoIZFvP5PiTkCnm4NNngCqNDNPeejE35d3WYNvw6Mzdd/53xsASeB0lstSqCwuTvL9kiUcwGAvTifIhI3mZojsrEoOVT4o8sF3d3TFhCZlUxKmv7QGioOBDdL13GqI4dnztLt0ezk2wO8CUpXdOkiakaenW/w0JLHngxxLXEMN0gg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:14:10AM -0400, Johannes Weiner wrote:

Hello Johannes!

> Zswap is a first-order swap destination with writeback semantics. The
> way the discussion around zswap has been going in this thread is
> disappointing, and I don't feel comfortable adding permanent user
> interfaces on this basis.

I have given this a lot of thought. First, could you clarify exactly which
part of the discussion or consensus makes you hesitate? Understanding this
will help me re-evaluate my proposal.

To make sure we are on the same page, I would like to share my thoughts and
vision for the present and future of the tier interface semantics for your
further consideration.

The interface should provide the swap amount allocated to a tier and allow
the use of the swap device defined by that tier via swap.tiers.max.
Currently, it would only support 0 and 'max' (essentially on/off for
explicit usage). Auto-demotion is planned for the future, and specifying
exact capacity limits is still to be determined. (I have also reviewed
potential interface collisions and duplications based on Yosry's guidance.)

From this perspective, zswap currently cannot exist as a standalone tier. It
resides in RAM when allocated and borrows slots from other swap devices.
(If all tiers except zswap are turned off, it is effectively the same as
zswap being off, meaning there is no zswap-only tier.) The zswap writeback
interface essentially leaves only the zswap first tier enabled by using
other swap slots. Virtualized swap should solve this in the near future.

On the other hand, in systems without zswap (like ours), this situation does
not occur. Allocation and deallocation depend strictly on swap priority,
avoiding this contradiction. (While it might be possible to implement the
tier interface only for !CONFIG_ZSWAP first, I abandoned this idea as it
seemed unpromising.)

In my initial review, I considered creating the swap tier interface while
excluding zswap configurations, even if zswap is present. From zswap's
perspective, it acts as a first-order swap, and other tiers operate well
according to their original tier semantics. Once virtualized swap arrives, we can
open up the interface without any contradictions.

However, virtualized swap might be toggled on or off (at runtime or
compile time), we must still account for zswap without virtualized swap anyway.
There is also a possibility that the initial overall picture might seem
misaligned until zswap tiering is officially introduced. It looks like we must
care this case on the first stage.

Therefore, I decided to follow Yosry's suggestion. Since a zswap-only setup
has contradictions, we initially considered removing user visibility
as possible as we can (returning an error for unsupported interfaces).

Because the implementation is a bit tricky, we agreed on an on/off toggle
for this first baby step, accompanied by detailed documentation so users are
fully aware of what a zswap-only tier means.

As a result, I reviewed this direction and found it does not conflict with a
future zswap tier. When virtualized swap arrives, the design will align
perfectly, and we can consider making zswap a proper tier.

One thing that remains undecided, however, is zswap tiering, which is not
yet fully agreed upon by everyone and should be discussed at the next stage.

> We will not be merging a memcg swap tier interface until the swap side
> has a story for indirection and backend migration.

Regarding this point, is your position that an indirect layer (I see
this is virtualized swap) must be implemented first?
Or do you mean we need community consensus on the overall design before proceeding?
I believe our direction is set toward virtualized swap, but there are still some discussions regarding
implementation details.

I would love to hear your thoughts. In the meantime, my preference is to
proceed as discussed if we can agree on the future direction. If more
discussion and design verification are needed, I am happy to follow up and
address any concerns you might have.

However, if you feel the tier concept is premature, I would like to hear
your thoughts and others' as well on a fallback option. We could add
per-cgroup swap control in debugfs for now. If we need to scale back, we
could either keep the swap tier design internally or drop it entirely,
implementing per-swap control strictly for our specific use case. We could
then revisit this as a primary use case when swap tier discussions resume.

What do you think? I would appreciate hearing everyone's thoughts on this.

Youngjun

