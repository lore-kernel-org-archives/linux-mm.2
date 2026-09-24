Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7326C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE52D6B0095; Thu, 24 Sep 2026 04:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96196B0099; Thu, 24 Sep 2026 04:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3166B009B; Thu, 24 Sep 2026 04:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8216B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:58:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECD38A5ABD
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:58:06 +0000 (UTC)
X-FDA: 85248053772.04.B798A1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 598D5C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:58:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0GBvYm+;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790240285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7SDwsWf5CWIVcYPIFwqJtjthSxCCaBZbCFYwnYVzTY=;
	b=2BG2WODs7ttC1HIXx4EThXUE0gg7ybqjNSkjJFxHybKBSCJJF9erUBvmHXwNQHuc2aiSCh
	1wUQ8T5YFCU+y94SPMQiVENTDNBt47UXLYKU7g5h36N88a1oKL3+QJ7VUJYCKbgxJhy1Qv
	JxykIwWX9XFtJwzzbbrNPCBMGmmvfNw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0GBvYm+;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790240285;
	b=OBk5qDVvMhqU/HjSIwkx7qZHEH44jA5KKQ145BKnuiRU1C1dPBIIkb2nmbvuyAidl8NGYr
	dtzlTtEHVouYsXs0Fuus27dd1Xdp+bmsiFAYN3ysmO6J8BHvSw0/wmJnczw69gFsZxEe07
	fPrxJ6CKotcNUMe3R6EA3//SK/tQ0Vc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0A18601EF;
	Thu, 24 Sep 2026 08:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620BA1F000FF;
	Thu, 24 Sep 2026 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790240284;
	bh=W7SDwsWf5CWIVcYPIFwqJtjthSxCCaBZbCFYwnYVzTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B0GBvYm+aSiuZ8w1vI3FHuWlJebwgQFrx8W+AI1XAdjLvlLa8uZ47QEGL49eH4KZl
	 2oMDPAVHkc1hwghlVCYZjt/lB3fYe7Aff7J46mdO+N8CnFJxv3R7IPmCV5Re9VR8+a
	 hkOPinqVOHapVhnHbOL/JvlGRKwMYUuZw5DmdhF36aDdnZdq8sFkZDW8Tg3iGJAzTr
	 0WVy7VvQUl5DTOrIySgS+OXB89YeHEn5M14MeaTvp+Ko4o1wYtTmUGwhOPtNuLNP19
	 lv6f7vaE/AkNJIHDrh+3Ekwvsm/IkUaKM6L1hyCJ71gA5hhQ9Nu+d7EACBxz0NZlpY
	 2fRa7pTx7XZAw==
Date: Thu, 24 Sep 2026 09:57:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
Message-ID: <arTl5Cc1B-2_BoHP@gremlin>
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
 <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
 <65b94694-d503-46c5-9f13-f0f7f8bba8d8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b94694-d503-46c5-9f13-f0f7f8bba8d8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 598D5C0003
X-Stat-Signature: aq4mfbic5ygsuciecj961ndoosnydwdx
X-HE-Tag: 1790240285-671732
X-HE-Meta: U2FsdGVkX1/ncDJUePdoyp1yh7HB5tT4uX8R/+mY6iBxbjRuH1U0qrpqLN9iaEczN3DnLZZBSOifNjCOXJ9wZN/ZOL/oUVvmIMFMMU8aa4dGGmsUtXAVi+A6j7/qDCt0tobOJihaljevHnAcnr1jZLnM+UXF3jrCoUms4ax+3dUjZN/gLo75AmooTXmeB1r+B323kNT83cAh3tyRdDguN20h/Vuq8EW6GDARKrceupfsLt3w9YP9IqC9G8Aveu0UCmzKtkjuJEE/MHDhDlD817i0dY1lgihleNhA/avvQeyY2OEz61JwiJ0xYp++B2U5vQdBqs8dKyfc5+iQz4wF4/rSxj7D7xh/g9FjuoXzw+54F0DAdLlF8K6mypo0Jsjb7dcEE8d7Zc/mXYoYyK9BIth7ImL9GzR3BcFXWlB/Fo8L5wnmaAHj3Ve4wMxUcQRqQMkMTrj2m0x2+XAv4cf760M8EVPrLB5qU6E5z5t9UmHZQm/SYCascgMlZi3R9ep9LvLRTmBEf3wPVT/g5jhWAmHh2c+evKZ1j/52Brf02/XKs8b+7Swz0tctnINMJuzy/EwGIILfkOE99QTJOQEVWA58m4A3rZu9iWFEskDA5t7DuHNvBJL5ZD6hybmUOz3UIjA2Jh6aephzqBFLcAAkxBwXxO1ye+K0CgXC4QPkDCBwF9RGzElSL2i8Q+jygLLZL2J9uGil55Y/UYykO2NKvwk7IcC+i/xkw6amETidDG5S0KL8IFeaPe4ECbjOU7a10oofhQhvFCb+hAWQ2sPCmKMmhLGuwZzYoXLMVIpUUkNy57O94bYaz6y5vuqlpvb49Jy2xsRzgcWAZA58RHfQOmAvLaD8508HBzjyHu0lGbinEnLYuXLM9QYBUlSweGO/eUVeGOtkd2+1LT/64r74T0nSep7cukXKfTizkOHcaRapSkXioYZ/b5YUQgjWTiQdUqUQf2FldV9sfIf2pol
 htDnq0Mj
 SSHNpV3OGGx5vsMqixN8bTyYEvkBYt5+O9qKqhyzc+cd9kRbd6dRtDu2PlCP1Ru8B88ZG+DsQPfBtjdzbERBRfhZURuspLUzfCQ8XAl6uIL1vM7iT/4qZg+kLLuy9bWIcDrCreRgod4tW9VVNLxz6uQXN8Se11Wx92WHm/melHvBJe0WTASa1BVGvuNVcS1taAOwxs3XtRZqmFMJKz0WyZxldloaInCkiGR8AVPUe/Tvmu6zE5MjLpjyLK6BymIQ2tD6gkLVdQNqXebaUfrwp/G1uxy3jSIj7TUuBjGJWoT07cgABZVHSibV87A2/JPSRAnMahVvsw639/dE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:31:40AM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 09:28, Mikhail Gavrilov wrote:
> > On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
> >> Should we instead simply skip the
> >>
> >> 	schedule_work(&kernel_pgtable_work.work);
> >>
> >> and rely on anybody freeing stuff later to just free that one alongside?
> >>
> >> That avoids throwing in more freeing handling.
> >
> > Yes, that is simpler, and the early table then goes through the same
> > IOMMU flush as every other one, so there is no need to reason about
> > what an IOMMU can see during boot.  The only cost is that it waits on
> > the list until the next kernel page table is freed after boot.
>
> If we're worried about that actually causing problems we could drain the list at
> a later part during the boot stage. I'd suspect we free something else later
> already and simply drain the list ...

Yup agreed this is the best fix.

Please go ahead with that Mikhail.

I hate that the Fixes: is a patch that actually makes the CPA code do the right
thing rather than the fact this whole code path is possible this early, but it
is the correct one from the point of view of what exposes the bug.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

