Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2DFF30920
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445126B0088; Thu,  5 Mar 2026 04:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8F36B0089; Thu,  5 Mar 2026 04:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4D16B008A; Thu,  5 Mar 2026 04:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19FF96B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:27:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1A6D1608DF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:27:17 +0000 (UTC)
X-FDA: 84511480914.14.EAC2406
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D135340003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:27:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SY8eFLte;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772702836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcQL7fy5/7dagQG8x3mheAmmWSf9wgl5j6VJKNqAGL8=;
	b=NBK8K/ZYoRvaEDhdYmUi6gccH06LsIJsClp6AJKk/59/W6JCLMWTqsBjEofn+DN6jzjO3Z
	d9YvGFS0pdqUZ11/Oha3drmK7uTMBG73/pmxS0oNveQVuupR+SJMWP7vR0rEUskFNeyqIA
	S9vzBFOuHCSLJkYkPzpa9WJMZB29iBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772702836; a=rsa-sha256;
	cv=none;
	b=UeWQFBGQQ4u2BOwVByB0Y79WNIdR6PiqbldmNUHWEUxeIAdSNUVneMKLEGPfOWTGTyvQu9
	GhYH+fpu5pJjxODjVGfUn5PQmWm5mDOq07GL4v/f8zUunmFinxD2JzpNZB0t5MJ08RAh5+
	dBFU1y2DIpKCF6D8mhYmNpeiu0zuM+w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SY8eFLte;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1E9E406A1;
	Thu,  5 Mar 2026 09:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255C4C2BCAF;
	Thu,  5 Mar 2026 09:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772702834;
	bh=2PM4TCzaL7PIpbUAvBpvBfsaqfpwHgfynLyCMx106LY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SY8eFLtecDllvoK9zUMo9qn2jHOAd5sY4zp6ILJ66Tr4bib3tFLTEtqxACNUgf2y2
	 sCF0z+E/B7kUMZf4O3fGNtuQ/24k78Eut7nDBiyY/DUio7LYHlDa4fJCI8+vngGo4t
	 mcpN54APp4sE8UiwGy14kbUMLM9AYwa2N1MZY34ywwEZ2GTqrHnMyi+2TyTqr76X43
	 siVYvzHvBqHZK3sjeZJr1IT43mBMhO04EGXLkzT0d7BcsKWku/qd++43Awvfl2u0U+
	 +Q/jopx6C5PRPyDyZFEW27mfdvkbjRLyk1NnDVtAm295ARYETRb7NTRJhd893NOMHz
	 qeuaSyL+N5G5w==
Message-ID: <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
Date: Thu, 5 Mar 2026 10:27:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>, Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
References: <20260304151335.172572-1-sj@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260304151335.172572-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xx6fo41wuk64tqfkufke58zs8gtzwgse
X-Rspamd-Queue-Id: D135340003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772702835-128123
X-HE-Meta: U2FsdGVkX18DxvtDN8CfpPGeJPSlbgldfa3V32889lymtu5c7Nva4WiHRl+jOe+bO2GBO3K5+L9HGtTQpHUjC/cpxd9rzENyTY45+2+EgvaK7ZQnG/FPg4KQj/TfHMG9VqA6zW2S5yNiS0yOfZYRQpn5rh7RiB4W63qFGY2R9OUCbXBcaqnQGDoehGGx5FO1tSFqzdIqIOd96BSrH2L9L71nJkpYFY68YTnKOUJ2R+mmz5Ldj6eC2drkWrZeTpEyYXfXO03hcOqJBmHlyavZCP/QuQmYNP85pMuHZmCbH54Wt1RfzYyCPEzIYHgfPxkvQcTe0Q84EScc/jju6PKQM5NddWh+VuZTpKe35JdVVszWN2m6zTO7jYIH0SrpMir3Yayk8IYKP/OyHZ7Ym/o6ZfviWrZHbjaVXSshjspAONikZm/bKVztipKEbZm/knzGXhrIy8K7eCwA0D8yjkhYIgUsR0gSFibAN8/+zW2e3rzCzU0/unFT1ZeiaFTP/qkPNtMFRmblq5eAyN5SAiFQBJUfj1e9uFK4GC4b8OakG3fTzJVNJfASBrjEiZokjzV6ayvqSjV3Ryf+8NAY/rEVeL5VhXSgjQT6iyrrx/IADJYaUIULYWUrOEPJBOQUX2KrEbLfnIF0Lt9KfbiMBs12HE59tu3TEsLwbOcTKfacj8j9+ZZXaRWMcoSe5QDCQEitrQDV0Ku03tgF14hbLMbjo7EHJmfnSqZUnAvWrUM+LQxJXkNQaLneKsUqDxi6571C9IAdxche7cv8Gm2VV266n0YDIexbFg9/A7Y0S8UmK74JuHgI1QJVNep4D9fQWFsD+etpf3+GVU4cHWrZhr7M0beIcyvIqVtEvzujlD4lINSiHzK6+fwFt4BNH0cTmi4IglHQrlbEjvnCaEnX3jjZalnNpd2AkR4/zUCGeOTEfB3nbwG3QClYCc3D7aZXFbRNNlRH3u9JO0f9yZr+FHJ
 hPJuFlv7
 qdFy8q9F3kYWGy+Mp2HtwIltSXy4p1G0pxWkumfvY+rtBYmO9k2H3WCGnSQXRGIY6YtVULc+fHUufHL/y2g4tC38ksR1s00NQ7xk6ZdonEPfbXh9hktyI0aBE56FFMb2U+wRZbo3jYeT2oUQSVUqaRuAwIwlC5q6cN89Fyt6hMfRGVLWgKtedl0n9yuVojv4OY1jkO3eVx2OcRRGp0CvRn6n3lrRnO0omnGeA02agQcSGH7q7Y0oaljwjpEEaXYS4L7suK6F8PEXoPeopwJJK46foWn4gf7RlsZwaweKHU4SB/eUu1K5Ub2wRD4iU+9kftZrVH8rwPtLAkLPe7p8GG1jW3MOpA67owzo7KSkwb4XY4VXwtzBCGjxyLs21SA43Qnjci484N+we5zGzsMxw6P3Gp2NV/sXLHn5plyRIGz3JZA67SPBbAe6QRg3fAr1vxxwW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 16:13, SeongJae Park wrote:
> On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
>> On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
>> > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>> > 
>> > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
>> > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>> > > > 
>> > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
>> > > > > > This intentionally breaks direct users of zone->lock at compile time so
>> > > > > > all call sites are converted to the zone lock wrappers. Without the
>> > > > > > rename, present and future out-of-tree code could continue using
>> > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
>> > > > > > infrastructure.
>> > > > > > 
>> > > > > > No functional change intended.
>> > > > > > 
>> > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>> > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>> > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> > > > > > Acked-by: SeongJae Park <sj@kernel.org>
>> > > > > 
>> > > > > I see some more instances of 'zone->lock' in comments in
>> > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
>> > > > > 
>> > > > 
>> > > > I fixed (most of) that in the previous version but my fix was lost.
>> > > 
>> > > Thanks for the fixups, Andrew.
>> > > 
>> > > I still see a few 'zone->lock' references in Documentation remain on
>> > > mm-new. This patch cleans them up, as noted by Vlastimil.
>> > > 
>> > > I'm happy to adjust this patch if anything else needs attention.
>> > > 
>> > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
>> > > From: Dmitry Ilvokhin <d@ilvokhin.com>
>> > > Date: Tue, 3 Mar 2026 06:13:13 -0800
>> > > Subject: [PATCH] mm: fix remaining zone->lock references
>> > > 
>> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>> > > ---
>> > >  Documentation/mm/physical_memory.rst | 4 ++--
>> > >  Documentation/trace/events-kmem.rst  | 8 ++++----
>> > >  2 files changed, 6 insertions(+), 6 deletions(-)
>> > > 
>> > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
>> > > index b76183545e5b..e344f93515b6 100644
>> > > --- a/Documentation/mm/physical_memory.rst
>> > > +++ b/Documentation/mm/physical_memory.rst
>> > > @@ -500,11 +500,11 @@ General
>> > >  ``nr_isolate_pageblock``
>> > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
>> > >    problem due to racy retrieving migratetype of pageblock. Protected by
>> > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
>> > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
>> > 
>> > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
>> > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
>> > for the rest of this patch.
>> > 
>> > I was initially thinking this is just a mistake, but I also found Andrew is
>> > doing same change [2], so I'm bit confused.  Is this an intentional change?
>> > 
>> > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
>> > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
>> > 
>> 
>> Good catch, thanks for pointing this out, SJ.
>> 
>> Originally the mechanical rename was indeed zone->lock -> zone->_lock.
>> However, in Documentation I intentionally switched references to
>> zone_lock instead of zone->_lock. The reasoning is that _lock is now an
>> internal implementation detail, and direct access is discouraged. The
>> intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
>> so referencing zone_lock in documentation felt more appropriate than
>> mentioning the private struct field (zone->_lock).
> 
> Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
> zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
> better.
> 
> But, I'm concerned if people like me might not aware the intention under
> 'zone_lock'.  If there is a well-known convention that allows people to know it
> is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
> humble opinion.  If there is such a convention but I'm just missing it, please
> ignore.  If I'm not, for eaxmaple,
> 
> "protected by ``zone->lock``" could be re-wrote to
> "protected by ``zone_[un]lock_*()`` locking helpers" or,
> "protected by zone lock helper functions (``zone_[un]lock_*()``)" ?
> 
>> 
>> That said, I agree this creates inconsistency with the mechanical
>> rename, and I'm happy to adjust either way: either consistently refer
>> to the wrapper API, or keep documentation aligned with zone->_lock.
>> 
>> I slightly prefer referring to the wrapper API, but don't have a strong
>> preference as long as we're consistent.
> 
> I also think both approaches are good.  But for the wrapper approach, I think
> giving more contexts rather than just ``zone_lock`` to readers would be nice.

Grep tells me that we also have comments mentioning simply "zone lock", btw.
And it's also a term used often in informal conversations. Maybe we could
just standardize on that in comments/documentations as it's easier to read.
Discovering that the field is called _lock and that wrappers should be used,
is hopefully not that difficult.

