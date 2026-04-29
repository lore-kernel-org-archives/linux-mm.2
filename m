Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83485FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AC26B0088; Wed, 29 Apr 2026 08:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41EC6B008A; Wed, 29 Apr 2026 08:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F046B00A9; Wed, 29 Apr 2026 08:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A898B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:04:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71B7E12018F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:04:34 +0000 (UTC)
X-FDA: 84711461268.02.1FAB3E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BBA4C180010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:04:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p91l+b9K;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1O59nCjQWYNOD4VN9H5Hjh7VT83TFar7877eszYWAKE=;
	b=oubTY8CKNr9ruZbCjm5MSU6q8dBAkOwE8Xnsfqd2KeLTD/yEtr+q8+4cQBOoLiV1LyhqvU
	J23EBj44mSDPzZiOHTrKEMmTJggXc0gM5aNR9HRmRhraMl06GKn9cYFEbrlOXxdlb+1Z++
	0JILgMipBOm4+ASwGQq8lYQVQwUpAW8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p91l+b9K;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464272; a=rsa-sha256;
	cv=none;
	b=KedmxcZ130dEpUfAMtVemO7cclrSX9LEhwR8PjHFJwUtnrclwGakgz2lxFvHI+nM3Ih6jb
	nAvbE286m6z7guFo48NyKXH8wDSvDMFCiTylww5lEBWuoiDhNmjzwl+ESnhlGsvgBaoOs8
	Wq6ND7mLrKd1AY6rybLp/JLUvQZOTLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E91D60018;
	Wed, 29 Apr 2026 12:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF49C19425;
	Wed, 29 Apr 2026 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777464271;
	bh=IFAJiEknzlPW2ICs1yOFKVmjs8x4lk0T6++/h57So3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p91l+b9KXgYp+Fpi6U9aqoSTXGyLkwjQj5O0IWHaunxWDbsyPe4UIGd3MhQITqXve
	 mMVkpv5deeKDCdo1AcrYwtt4HN8fwUttVKMprhzGq97Xl2sH4gsaAQtDh/h4u7dzyn
	 Uu6KEeZltN5dUHPSEfLPCV/FoI+Ley1LWMlkJa3E=
Date: Wed, 29 Apr 2026 05:04:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan
 <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>, Nick Terrell
 <terrelln@fb.com>, David Sterba <dsterba@suse.com>, Vishal Moola
 <vishal.moola@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Message-Id: <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
In-Reply-To: <20260429103326.GA1743@cmpxchg.org>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
	<20260429103326.GA1743@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 37nu516xtt3x4ou7yykyr6uwgecto4gg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBA4C180010
X-Rspam-User: 
X-HE-Tag: 1777464272-187894
X-HE-Meta: U2FsdGVkX1+18Dfx/18pR322DWF1zH6V7HAtMT2ss+KCqDrVdzseZj/mBuHyi05N44Q4wIq1h1lRgxUmmLW8EWAK5fVXLzSQQlC3oanw80EXEeYvPViHc3FX001BpesGTejI9P57DxinHXKKiZU6k25Uejd63PBgFUA4Ql9IkGhfCaSGhZOCwW0EwjRA0A7DlYC5WPk3WMjJOkL/+Ao2S0GanWyjWA1WYZpgGeDmh+RiWodsAYyK9T0yLDSpfbZEQlllqPuAlSGB9hstAExCmv8IM5nIb/O6eFKVHcgTy/i03nTb2gt4oLQAhgIzl42Fr5TdBsC5Bkuzg0MnZ5lmL/hWeUFVeqrA5zMRT3mNTP1Db0TkSNTll56mjkg9jJ/+46lNeYOAffQUVR5Aswg8g+YL4IsEAH5MH6+qgfs6bI+jpOSTMmA02uOEhyVIeSnGkW4KniEqOCby2TcyGBr3k8WoU/0YGk30doh8SOC/QyuHa5qO3yXV0ZuYuMewXSwGTeGXUy63ZE8QPRNX8PPDZU5tcrabdbdW4wVVKeTkXJ+l8x9vht9Y1LphzX/1CzA4oBhlUDWMSTH+5i8//oCnhH5l8FDgkB/rn2ErBrcwdoG/ZJf/UX7nrP8GM5dzrPNssKMRZviloSGRyHggodTpC4N1GUqdBUzNQ2HWutIaqM/BFnlZj+nwxYS73E+kTOoHLxZWJ16AiWOYxK+0D74FHqjmWg8xMXJGRIxhFQccNceGpIZxfqxC/WwJK6lqtV1go26jZqD2kolcMHkjQB55vp1MnP4T4tnP2a6xk0XSQklQ//muKKe+AA9nYTpDm73O2CaSO7ANrFgmU1pyxWTvVgfMAnyLQYbCyUOTid+iXWPWpAgLWo+HEURwT1Ab4G8wkUp4XQW8Oyh+oyBnwIYIkkS7UPpx60flwuO58Cqhf9drxZzshsMlQEfNjFfVESqOf3ad4wjn4MHtBXO2kxJ
 0CXLvEpx
 1bwUz8sODJLj3wIo8LakkAHjSoO6ev/RFCp3339GIqoG5+i3N7K+tZQN+4bThP87pdEb7MaI/X+jGm+y0PrWKuLzO5T0BWF3efx2vU5RQk6+Xpbu2WSADGUT5eZbjg7RLfph/AmeYXAYeaiSrZWXazUBtHr8ph6qhpjvoVNOCJF5wxGleHZLNnP+/rv83tCB4r8P16NxjesR1zV7MQ7nAAY76nZz53MfilEgiVzrF6GPNeAGDXct596hQ0M8Dw6blvxDjt7NCCAY5aPHVgN6sf7P7vMEhrs8sBxGRRbkbYTwoKLhd1t1fZoBVmm6KPnGwNueSFPKgPS6jr0l04gqcQQpihdFddD1ny8n+V31s1znjkR/pc/Qa9J8IvV3HMwVOSNVX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Apr 01, 2026 at 11:16:18AM +0100, Muhammad Usama Anjum wrote:
> > Hi All,
> > 
> > A recent change to vmalloc caused some performance benchmark regressions (see
> > [1]). I'm attempting to fix that (and at the same time significantly improve
> > beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
> 
> I think we should revert the original patch.
> 
> The premise is that we can save some allocator calls by requesting
> higher orders and splitting them up into singles. This is a frivolous
> and short-sighted use of a very coveted and expensive resource.
> 
> The buddy allocator tries hard to retain contiguity *if it isn't
> needed by the caller*. This patch actively works around that.
> 
> The cost of recreating those higher orders elsewhere is shouldered by
> whoever actually needs the contiguity down the line. And that process
> is orders of magnitudes more expensive than we save here:
> 
> We're saving cycles per page in the vmalloc path, and later spend tens
> of thousands of cycles per page to recreate the contiguity. Scanning
> PFN ranges, folio locks, rmap walks, TLB flushes, page copies.
> 
> That's a terrible trade-off.

That's persuasive.

afaict much/all of this series remains useful after a06157804399
("mm/vmalloc: request large order pages from buddy allocator") is
reverted?

What I'm not understanding is how significant all of this is.  Sure,
making many-page vmallocs faster is both beneficial and harmful.  And we
have super-focused microbenchmarks which demonstrate both effects.  But
how often does the kernel actually *do* this stuff in real-world (or
even real-world corner-case) situations?

