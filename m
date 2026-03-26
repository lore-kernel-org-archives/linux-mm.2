Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D2410A88DF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FFF6B0088; Thu, 26 Mar 2026 11:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0726B0089; Thu, 26 Mar 2026 11:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEE96B008A; Thu, 26 Mar 2026 11:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855C96B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:35:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 335AD5D53D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:35:39 +0000 (UTC)
X-FDA: 84588613998.25.6EC2EA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7EDE740013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NEQ3/8kr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774539337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3pEWRJpcEgsTaX3SeZ8hOEGgyd9eN0geBehDiCFH9s=;
	b=4l3PWRSt3sqduc6MCbQ/wKvM2M+1roeOsmrOT0fz7+8Wdf7EsW8i2PzHCF/ef8qTCALjya
	f69+bIVimMuYA1is6K1CWxM/ggskSpy4sRDQSZkibQl9SCwlLw5xYppJVjeFrSqLutRYHC
	yTrsQLDhleHjt0CTd5/ClUm5nYIPf30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774539337; a=rsa-sha256;
	cv=none;
	b=XyWmTXsl3H0/NeBTU4sMUwLRLfNVx/c8L/Mv2WK0cxT3RxiTWSF1Eg2PWEA+wSXjrCYT19
	4aT3+OA5TYoCVTzHlgnkwrZfnb58ijH0F+J+YdqWhwp2UHsYPqWzGW0xdLiDMAep7kymn1
	SetfxXA5EOxk9u/NKLInTECuRnrTLlw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NEQ3/8kr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80A3044555;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D2AC19424;
	Thu, 26 Mar 2026 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539336;
	bh=J+BrV9gtq0qIc5uH8RmrzCSQsDGfxVkuOgtcGS9wqRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NEQ3/8kr7AXvTNifmkqXHgsSJYVLQy4oJZmUz6qvpVtujrx8Hkaz7jbuW5FqksPtB
	 iVmeZVRnO03XSgMjf1z4oK17lKBtHlzFzEA2DLI6mBjx6QyDOXvv78NDgFHSfYiYxs
	 +ebXSf1w32TibjJsohEsZoBGSUotwT/kSQWLeKkr8bFEpsQLBIi39j29JBKRDa2XM2
	 gOYVaQo7cTYKr/tg+wmfv8WOqDQwgwtLQc04/ejN7tvwTO3PJpdgNmHtX0rg85s/Qt
	 dtbyymDStrYDeMITbR+lHuxkhM8MBxFDxtrm9w9OS1lNaSRyNboAeF877khbazBSqC
	 hRh7Im2JCKRYQ==
Date: Thu, 26 Mar 2026 15:35:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 7EDE740013
X-Stat-Signature: p4y3qeebjbkw8tftd45f13d1mj3kden6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774539337-782366
X-HE-Meta: U2FsdGVkX1/YMlPDiZogikCGKpwtyuhsMjPwHXcTcNx289wkVxtOwQcUsPSg1k6W5hbQxs1QyCMPpvRa6VNWpn/2vVz+QSmGnbDCWcuIaGuHJ5pXPKQehfWxBF83niqov6IRRknMQoazARBAKon4L3tPO3TGW8nZIJSQv0vw1U4FX3WFrTfMD7FNIWGRlNYhATnYL95kWl+R6E9TtrHVedP0QFUzAMnFQYmAn2p07SPTFtvxFqFVZob9LprTeqSy+NST/O6xCZuwQS+av9KVGaPF/WEofsGyn/XHgsfuv2SExvuKn+yLNpfMCnrQ5wLjXwuP5gZkl8Oyo9SalA06Wyw9bXWzOvs/CP0yTw4ymsI/Z+2FREhREMvgi0qghUOffoKmsFqsZ1Pbg/H3Ar5/kDR5TQduUVNXVuGVeNlLHh+mI77hcYDzfMY9reLCIiVQ7QAvWkjKQD/puI5ttEfpjrtmGImrl44UGdJrkKVH4Xeo1fJ8tBYYCoYJ6W44KwTDhl5j5mah+Fdb/eKcuMaXGxBat+DMigzMvKYD6RsYkB2puw2ZG5+D7v0wWFW/1nHzUbrfus6HwTvKpSgaJmLRm9G4bugUvOylBbcRhW0g8nBaAvlpnQ3afm/RR4NA6fktd2LYgFnZN3rYqbDorjZSAH8N702/+CVOxL9C1Bj98Q/Ppu/2mbMhVSMR72NHo+YtX24EVSkZpCvA54ht1V7BVVHnDXCXl/WXMnyUj16VzcKFWFQUpc1JoLZN+9ynC2MDusmOV+n/NSUuZKGHdbejBjHozvXbc0YOo+hXUzHGI+T4hgOL4koaPO4zYsCecUIepz2A3a5m8nmxX32m2inDE0/YSa01xWDn7zeUxFdEG3B7XswfJvSmuJfB4DS7oDM9+ROgNBxkvjrS4CWMeQ0BdVkQ6MJozrkI2zPYNGSH5iVYcnHkZl9mrS0qu7VIubmlTtiOoLtQ4AI9Hm2QWsh
 U+xvLmVr
 exa/465gaSY0+A4sAwfUZCG3GabNLtSgByrWO935cYbSt9jiydcDeOT8BQTyfKD1FD5ur0i9blFBZjPo5kMhbDKaGyJPT6avNW0PWWPTRa7DNh0+m1uI/+B8ed2Tyot+2N6KXaW0doYZ78HVhJ5B0gxGDN0tohe2WUxBm7RAtkR9vzcsNtixHrYqJFdvTc41zmOpI3kqGGxj7or8niwabGcZJrEOhD9oED7GnfDixXEYEz+0d/nGlwWXYi5dJl6YhSOcR9oK6eTdu99A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:24:28AM -0500, Gregory Price wrote:
> ... snip snip snip ...
>
> > >
> > > How Do We Get There
> > > -------------------
> > >
> > > Do we merge the two mechanisms feature by feature, or do we prioritize
> > > moving MGLRU to the pluggable model then follow with LRU once we are
> > > happy with the result?
> >
> > Absolutely by a distance the first is preferable. The pluggability is
> > controversial here and needs careful consideration.
> >
>
> Pluggability asside - I do not think merging these two things "feature
> by feature" is actually feasible (I would be delighted to be wrong).
>
> Many MGLRU "features" solve problems that MGLRU invents for itself.
>
> Take MGLRU's PID controller - its entire purpose is to try to smooth out
> refault rates and "learn" from prior mistakes - but it's fundamentally
> tied to MGLRU's aging system, and the aging systems differ greatly.
>
>   - LRU:   actual lists - active/inactive - that maintain ordering
>   - MGLRU: "generations", "inter-generation tiers", aging-in-place
>
> "Merging" this is essentially inventing something completely new - or
> more reasonably just migrating everyone to MGLRU.
>
> In terms of managing risk, it seems far more reasonable to either split
> MGLRU off into its own file and formalize the interface (ops), or simply
> rip it out and let each individual feature fight its way back in.

But _surely_ (and Shakeel can come back on this I guess) there are things that
are commonalities.

In any case we can all agree that MGLRU cohabiting with classical reclaim is not
a happy household one way or another.

Maybe a stage 1 can be to separate stuff into another file, because that'd
actually be pretty easy to do for a fair bit of it, surely?

Can use mm/internal.h to handle stuff that has to link one with other?

>
> ~Gregory

Cheers, Lorenzo

