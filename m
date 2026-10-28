Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EB2606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNbe3+OK
Received: by kanga.kvack.org (Postfix)
	id 1B26C6B05B5; Wed, 28 Oct 2026 11:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189766B05B6; Wed, 28 Oct 2026 11:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7A36B05B7; Wed, 28 Oct 2026 11:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7F26B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D2C1A5B29
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:16 +0000 (UTC)
X-FDA: 85372355712.09.605E3BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8FF0C0011
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNbe3+OK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTJQq7oa2v1xKFQCN16xq62LsnI/dsCpyqBRJDWbjP8=;
	b=UF2MyLtPntOtFuAgOvFLgI1c95t125POAqUeOvOsa2ZQlhLBKuyJvIg/mfKE+IItog+dh+
	rTBrvSE/DtauVv0jNV2vH3jR2m7m0UaQvcSTQxohnMxrJGJsCsKHuS4ytYW8FP+CYxizLS
	fN/e2zXFV0wLVaiAARVb7UNBiQzkCDE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNbe3+OK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199854;
	b=oxc+FpcBCIiYjLNYI50qOhAMI5Tn4pIEzyqT/kP4ETxG/M/GZUGbh9nYzuN7qyP+pWGwU9
	eiuYG8DVYRiAN1rikd1Qu+NmH8C9OUJX4KNBLZfC7+jVmpJ/1Z6+BtFV7YZysCpUodc7aS
	s8pDK9nElldyVvcUI+9V3rXoMafMn5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46BE4600DA;
	Wed, 28 Oct 2026 15:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E51F031E4;
	Wed, 28 Oct 2026 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199854;
	bh=RTJQq7oa2v1xKFQCN16xq62LsnI/dsCpyqBRJDWbjP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iNbe3+OKl9aWdEyvuidT6IAvgrw0IGCiAktVRNlleig20UDtv2JjexS1/AEaEBEyQ
	 lclo7aHZbevKOmI1Nlnss5FdHeEYZ0OSbQD4649rd8dzntfPO7Z4SpnFmRgXJM5kpI
	 honXw6BgUOAFypippELMlxN5q0H/LLbMn5USre0PBq2ckbuIeyf7lMf5d8xi+qqS5L
	 W1lKIPsi1jsYi58SWK+TnUjslc8mW6bVMWm9eCHDqHmVeco3Ay1dzbIzul42dvhGZx
	 PZ0hprxU0zPS9KQ6o3kjLsOI603Qj8vC4vfRjb6xaZlNALEkSrH2TZDMifT41Y8Dgn
	 ABcRkjm6+a8Kg==
Date: Wed, 28 Oct 2026 15:04:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <auIIxSorX0bhZNZc@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
 <atYJA7nIu_RwpoCC@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYJA7nIu_RwpoCC@gremlin>
X-Rspamd-Queue-Id: D8FF0C0011
X-Stat-Signature: wboxot78zxjhdfzwqi76xfo38gch6ozk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793199854-856544
X-HE-Meta: U2FsdGVkX19Amv3Wv3tS87L1R6pz5u+wEGEaz6UZSQedrHZj/X7iQkFxyG7pHE88m1GVNxX7Do/zbuMttke4Vp4af0XsojOByCZw05DxsjYAHLhALmSoTKiIawJDZa5VxUNuiagNgJIKLjuHq+0Bfj6zDPSOUUDFSDq0NGGU244BSfN+3I2iI5c+HvWV6HY4OUxNGyFEA5OjPJycaTGR1ESO9gI+4itQnDRsMyiRkyyThrsYtHUg1cWRVFeFxc/iXq99S89QgabpGsVRt2/fiBJDSEWCwtElbBYfuOEZ1+P1EznUjsoHAwkMN122b1Z9IEobzwa6kHNtPC03ihYHfWYNGifCbxwE6DzXoDtX3U9emAGbduTR7leevLp6m7wezzbhG8ptsk2lXGsVBa3ALY0k6ZNIc41EKURO12fqjZUtAqxI9w32n8H1u1G//5s1SoHP3hkUJm9fNu9mel0O89nsi1Ctv4Qy4ITxQ9dxIQmGXpaXFJrftyMFitk0fbRHjgVYN3KDGGY60Q7bHCVTF6dnlTC1oXDg6wnKwpkVL8F3WgXr82IaP/ZF7WumoeJigo/sOQSLxciYR5eM4028aAoPmRjbAlSAwMS3hJkw1XEZRJPxJ9xglNWlxmxMScJ3KS+CVfBTE/BSeDmOZvL1pDQlocdl9a2Qrpj2zSoHYchfFg+Bt+bgqyCBGz+oXzOJxiQWNXxbga6Vj9btGOK0Hexzy+dYB0pq+3/5JcLo/u9nEKCmV84WzgpYvqjhH7/5g8Q/9mxPjwgAKvKh1OGb5WDYlrZYfuyu0tYshb1GbBVD6lfFVKhorje9EoUXGU8Sw2nF3bVT3WS09BxxKkGgD9jbCHi/UYKFlts2aSBrmXumxLLwtcWfS0cn0QkSYpRzmDE1hbUH83xWHbQ9VsgtJzNVFdocrwPaqrcxPkLDNjWGxDR4H/2dhRDAkY0zWIl5lW1l/VIOivec9tmRHRm
 MucGO8o4
 4+V2OHK8Sdl1hvvQNVsXlt7RqAdsSt4iGfX13vjzH7zSfVCjt+Mwpd774slEqC9xTK/fiToROACMsgLgepIhbxhZIy+GCWtWfJCFYb4NcXmq+lGRTFl4wjCcGDJzJFCUhvjBpBvQ3AWTXGbr61elSQQhsqRQI+kYrJHGNAV219O2wtKx7sGiJzetITVguzVhW5ipbi2AIVzbTarW/W7JynCl7YtDTaXZHAlCrDAZtZZrSX1H6H/G3GkrGHr6nilDlbfXgV/6q/3kxK6w5qKkVFZnZXpyYOt4hN6ysP74IE+b2Pg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 01:19:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> > On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I'm concerned by the possible latency when doing this to many VMAs. Do you
> > have any numbers?
>
> No, somebody schloppened a patch for a real issue and I haven't the time to do
> even the things I need to do let alone 'here's a new task' stuff :)
>
> However, this is a simple write to every VMA, done at the point the mmap write
> lock is held with all VMA write locks dropped.
>
> It was implemented such that:
>
> * No VMA write lock is taken on the VMAs.
> * VMA read locks can proceed.
>
> I.e. it amounts to a loop over VMAs and a write to a field.
>
> I don't think you could possibly do more to reduce latency here, and you
> absolutely have to update this field across the board.
>
> Under any realistic workloads this will occur at worst ~days intervals, often
> far longer, and likely you will see quite some gaps between separate processes
> experiencing it.
>
> There's also an upper bound of vm.max_map_count per-process, so it can't explode
> into something truly insane.
>
> Most processes don't have that many VMAs, other than certain steam games :) so
> it's hard to imagine there really would be that much latency here.
>
> And the latency is occurring on one thread, which is performing an mmap unlock,
> so nobody sane will put that on a hot path.

Sorry, I forgot about this and didn't get numbers to back this.

I had an LLM go get numbers on this, all in ms on my threadripper (but numbers
should scale similarly) with fork() + munmap() all VMAs for comparison:

(all ms)

      VMAs      reset    reset     fork()     munmap()
                (warm)   (cold)    (cold)     all VMAs
  --------    -------  -------    -------    ---------
     1,000      0.006    0.041       0.33         0.43
    10,000      0.072    0.36        2.1          4.2
    65,500      0.61     2.4        14.1         33.5	(default)
   262,144      5.3      9.6        60          168
 1,048,000     34.7     39.2       237          691
 4,194,304    162      163         954         2810

It happens on a random VMA write lock release, so there could be tail
latency, but it'd be tail latency on the scale of ~weeks for normal
workloads, and (assuming max map count reached at default limit) a ~2ms
latency for an operation such as mprotect(), madvise(), mmap() or munmap()
which shouldn't be placed in any situation where the latency of that call
matters.

One call in 2^31 is the
99.99999995th percentile, far beyond any latency target anyone measures.

The amortised time per write-lock cycle is ~18 picoseconds (0.018 ns).

Interestingly, the runner observed khugepaged-induced mmap lock stalls of
~100ms, far far more regularly, which seriously exceeds any of these
numbers, about which I assume we haven't had too much complaint.

Overall the numbers back my thoughts on this being a non-issue. Obviously
if people report issues in the wild we can revisit.

Hopefully that addresses your concerns.

--
Cheers, Lorenzo

