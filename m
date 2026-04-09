Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B128CE9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2744C6B0005; Thu,  9 Apr 2026 04:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BB46B008A; Thu,  9 Apr 2026 04:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1896A6B008C; Thu,  9 Apr 2026 04:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08E036B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:22:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9647A1605AD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:22:45 +0000 (UTC)
X-FDA: 84638326290.26.14E93A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E3E1940008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:22:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1AdIWKg;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775722963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEQLa/8haXS+/Iqw/lhgd64KpO8nYmKlsOtiLdY6YwM=;
	b=Yj0NZ99o18TXSx+M8TDpIxEH2w+AUgM1Wn85jOjpyOwNgHTxSxX/ytbn6AdGorj97p+5IK
	yUw6gxdlJLqku30B91yNRPti6kFvUyL818wVyIwxPoXOQ5OXMNlJa39Oa4vl2vb9MGDXbz
	XPZfF1BMPqTgj8bYgOeA269L+7Wmc4M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1AdIWKg;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775722963; a=rsa-sha256;
	cv=none;
	b=qeLfqp+wlsJUR9/Ly8Q7Irv/yZST0VhZsCb8JhaVPfbWEmUGry9MkOZu2i76ILa7dEjMAV
	z4m2c3JiSCCSkR2gXm6HsxeFAuh6IGpc4mW6+Dwk6SnOXWrqpRlv2FTbyE/yLZjJNJuTrl
	brOEH2ninqQ/2001i6A555IjhyNlv4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48A15600AD;
	Thu,  9 Apr 2026 08:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40484C4CEF7;
	Thu,  9 Apr 2026 08:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775722963;
	bh=tEQLa/8haXS+/Iqw/lhgd64KpO8nYmKlsOtiLdY6YwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V1AdIWKgfOuDJnPp0z+X5VbbR6VGXVevTY5CMaVxbW7CBwU+xh+KqYAgOjAwy7ayy
	 xzHnhxAd/NDD9PPh7UKVMBhQ9fr/XYFFQ+/GYlRiGfC+DdNPbr/HkzLVA5ThAO75nM
	 pn2hP70NYF2GNI8LRJhk/BLYgkmfk/TVZY807NSO77hk5Qt8r02RB+q8ZXCAslahwb
	 G6y0N27JcSLXE4vix5q//WRmXo0IyrN5OjHcBiDQJGfTZ+bY9izWYBaW5K/GMWypOU
	 kgK+kiHTUk7BM/QtTyJ1TXXRAJHMAdStC6LeKNMoTV6yXB4AlVpke4SVoacUGT/wLS
	 iexf5GxvRAAhQ==
Date: Thu, 9 Apr 2026 09:22:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adddpxFfWIO9a2Ih@lucifer>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
 <acX8_XMQYA0-NGUW@casper.infradead.org>
 <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
 <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com>
X-Rspamd-Queue-Id: E3E1940008
X-Stat-Signature: 1j4rw9gyct3pph58zgo7ydppajcosmdw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775722963-801412
X-HE-Meta: U2FsdGVkX1/h4v4YoB7rd33yPP9vMPwbkrpCzDyyENo/NLZuqxl3qGcR2iyGgsTTnGvBObl1NWa62k2f6vxb5QNUkrCQkhb52QavJ7vF3UTGp3HDRbgzE+quREcPWcOa28LWnoxlP0pec3xd59zbrfG61mrHT3MvjUmDRfY5mN5E7W0LmxZv4/48fSdH67WNpY61IH91hx9COeS2B3lE84Vlj2x0uQ1Rp9dZuv7gl7n9FAczrtuDnqymGBcCJIz1XfjFBHy41JpYOi5GKvr10Axf/pURuNKbsGl1BLRODGYYETKUpnz42HOxjBzUbM98fxKO8EjdjICjDFo6wjAGOcdug9oj+vbswnx7QX1LZrRXfQlWbX13iJSSMkEs2NE0DB29/pdR0DSk9PPlm6VXL36sy/egRxNykOM8cNK6NIaZEEmu9L6Ikn0fADSS29EAbgWTc+Dt0oIdDPdkWJfOUhbuoqht8r/UzpBHy6gQP04UCpO/SKKohWRhV+CbkDHSNPBQ00WPslwxwcmHLyYnXZRr70AO+vvwHGZeLvsQBMgGHG32uqH8FkLH9seoQT7y52/I82o7Gu5N3cjwLNRKI1guOM55vJIGt0ofgujL3mo3rjVuy4mVbssemRb4xpWd1kdXy5SsRW9AVvTqobfZyYREgE8O8C4vBrO/USmd7CiF7ruWuaJ+dBQzyRlxh8ppS2QOj6u4F7l/lDFcpIpM8qb5oJTpih9Mze6/YmoF4od2Xv6Kn8smM8IoN95w1HmOjgkNQFHVUNR1c+1dZ56o5YcyzJ16YEN/W768KqRniC5paAdTekH85pG9veS9wI2SMuDXfZQtjoGOCyHgPWTH1y/pdIzrOc7KcBbx2p1MUmTo+sAh/HMNb1NIMmmgLWSfX/XqY4RxaJCaV+SUxNLK2jDmaghIdds80Y0qPgfRaqrTU+VzQ8wZUrqjxaL1j1PnVy2rVQdtvgqAqc8p8HI
 8XzWJtOv
 JmwKC7j6EG4jlXpUm0XF20EeqIo0pvqlOnDmc0/456iOXQq4Z8utCIJT4+WSwjfF82CF4kOVul4w/72ZhlfcnGy9r+jBu+1EuIta1BixP1A0QGzJsPUTD7O019U+J49hG6YtdxvCDDWGNv62Vxn6ZQ0nzWY3+nXnNf8ZOOTZg2pMQqlEu5a0b/lE46ViwfLf/GmkaUFVWXmuZBHWNjGXY9ZNiHpG6TwbuKjhIhkCePaRWnXRgOUG4SN73OYzNlhVB0kCiTWRTsvnwdkpGlEbjBBZTlF9vaXlAd88FW/lAIj/LhajIg2ho0N7cOBZzhVdciYPAx2jqbHnD+cZ8AgkUtrwQprHU2CvIp5s88T/sXg++dcghVzCtnd5ntA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 05:21:17PM -0700, John Hubbard wrote:
> On 3/27/26 12:12 PM, Tal Zussman wrote:
> > On 3/26/26 11:43 PM, Matthew Wilcox wrote:
> >> On Thu, Mar 26, 2026 at 01:47:43PM -0700, Axel Rasmussen wrote:
> >>> On Thu, Mar 26, 2026 at 1:30 PM Gregory Price <gourry@gourry.net> wrote:
> ...
> > Yeah, unfortunately it's not so straightforward. As a simple illustrative
> > example, consider a file-search workload, where you search through a large
> > number of files over and over again (e.g., a poor kernel developer trying to
> > understand how the page cache works). This follows an MRU, rather than LRU,
> > pattern, and readahead doesn't help much, leading the active/inactive and
> > MGLRU policies to have similar performance (~40s runtime in a specific
> > benchmark we ran). In comparison, using cache_ext (our eBPF-based caching
> > framework), we can run an MRU policy and it goes down to 20s.
>
> That's dramatic!
>
> ...
> > It's been well-known in the academic realm for a while that there isn't
> > really a "one-size-fits-all" policy that works *best* for all workloads.
>
> I think that that point has been less clear, outside of academia. In fact,
> MGRLU (to the extent that we believed we would eventually get rid of LRU,
> in favor of MGLRU) doubled down on the idea of one size fits all. So this
> is interesting.
>
> > Yes, you can make a general policy that works *well*, but if you really care
> > about a workload's performance and want to squeeze out the last 10-20% (or
> > more) of performance, you need to be able to (1) experiment and (2) take
> > advantage of application-level insights. Being able to extend reclaim (in
> > our case with eBPF) enables that.
> >
> > We wrote a paper about this that was published a few months ago [1]. Happy
> > to answer any questions and continue the discussion!
> >
> > [1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
> >
>
> Excellent work, I was delighted to find a well-balanced description of
> both older and more recent history of the Linux page cache there.
>
> It's helpful to read this, even if we go with a non-eBPF approach.

Yes, thanks for that, it's interesting!

But I would say for now we need to defer any consideration of bpf being a
thing until we actually get things into shape in terms of improving and
modularising the existing reclaim mechanisms.

mm has been far too keen to take features without paying down technical
debt first and it's been very costly, so before anything else, we must
ensure that reclaim is both long-term maintainable and maintained.

In terms of reclaim bpf as a concept in general - reclaim is so very
sensitive to even minor changes, and I fear that people might find
something that appears to dramatically improve matters in one scenario, but
end up with an unusable system in another.

A bad sched_ext implementation might result in poor responsiveness, but a
bad reclaim_ext implementation might result in a soft-locked system, and I
fear that it might be quite easy to do that.

In any case, we can look at all that once we are in a better place with
reclaim, which Shakeel's proposal focuses on and I'm very much in favour
of! :)

>
>
> thanks,
> --
> John Hubbard
>

Cheers, Lorenzo

