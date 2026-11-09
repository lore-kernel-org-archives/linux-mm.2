Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0111B606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U7k7USFh
Received: by kanga.kvack.org (Postfix)
	id 1FD016B05B2; Mon,  9 Nov 2026 12:24:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADF76B05B3; Mon,  9 Nov 2026 12:24:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2F26B05B7; Mon,  9 Nov 2026 12:24:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEDC76B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:24:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65B3712075B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:24:10 +0000 (UTC)
X-FDA: 85416253860.08.866064A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E20040003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:24:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U7k7USFh;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eun4fonrA8YxuiXzX4G4XMpkIlQF/XMM49UglMMMiXw=;
	b=vVP+5KeOXCsZkVc3iUhBQdgTg6mlH7aHwl70Md1qXhVnXPLQ75nE8eWVeIRrrLUPpZxQmh
	jaQv7QoqF8VoBFmuC97Z6QE7+Gbl1IeLGDqfwzCiytneLjSOuzt5yn0dOKvDMlkf2KTZao
	w3cKGdprSz0OrI8PNFUQ1QknIPxP9eI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794245048;
	b=kekYPR+pU1uL6iVa8AT8yEcrEDvbjl6nYC1T3pinz7fxiwqrqCqm4ebpz5+KEYvoi2xSEi
	wthUBzUguqXbPn7Zgj7amL0rX3AaA3eWYNYkkf+xfaXlBJS0XqpOYIP+1ZFj33w8IEySEs
	EqYXAbXc923DFdNMd7ovHJ2nXN+/K6M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U7k7USFh;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6707941607;
	Mon,  9 Nov 2026 17:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924481F008A1;
	Mon,  9 Nov 2026 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794245045;
	bh=eun4fonrA8YxuiXzX4G4XMpkIlQF/XMM49UglMMMiXw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=U7k7USFh8CiH8yapE7FTZPIc3n7a1VfVrrw/hRpz7ZfmAvrqap3KqDfRs+5dgXjUg
	 7b5GVFc0envv1FiTeaCTmMTZ66R7rrrr0X/aHT3OQaPAdaAd9AdSGv+gj/dkjcPbkm
	 IviqjTERNDo2xLRDzAyJciW777BbRh6rtjEPsZg0=
Date: Mon, 9 Nov 2026 09:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Leo Yan <leo.yan@arm.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, catalin.marinas@arm.com,
 will@kernel.org, urezki@gmail.com, linux-mm@kvack.org, baohua@kernel.org,
 dev.jain@arm.com, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 david@kernel.org, rppt@kernel.org, xueyuan.chen21@gmail.com,
 chleroy@kernel.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ajd@linux.ibm.com, jiangwen6@xiaomi.com,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and
 vmap with contiguous memory
Message-Id: <20261109092404.5441d8bf9c4494ed008162fa@linux-foundation.org>
In-Reply-To: <20261109140206.GY9176@e132581.arm.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
	<20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
	<CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
	<20261109140206.GY9176@e132581.arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E20040003
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: pprbi74i7ak796qfemtna3qcrdyqs3sw
X-Rspam-User: 
X-HE-Tag: 1794245048-712853
X-HE-Meta: U2FsdGVkX19I96gnqDPGCR1dP+p1aBol9m4bxrz2GM/7GGBaAogqn9mt0TmUs+MMm8oc/w4tjx55jdDGp6nXdnw9n31dXhM97BHQGu6WlNdZ/m8ERYdetIw132dEn5zr8yllT3bAjmMrOb0k6A5GHhAoamvBvz16kor//Vu8I9wS8UpAsB5DskOY5kg0P2YjISoFy/LZEKhBfEMULRL4cxPzOYIlFWCZUIm3KUmhr/hqG1YqSb/ixP+gxWDmHOOQXFIgQ285hqez6Rpz9LMNLk2hCoHjnxYz9gI0TSNYrWsdrLWsgvTGhE/aMN7cCpdjYROwxPcaTBzagQJSUid6aA/yp/sLncuhoLSJNwwgLuR5aqO9SLHkdzMJgTp8/PihLLxpg6TglD8V6XTo+ODsu22lsPZZwuFPOKRYMO/GwfA44Tdtds2D5gadu3PJHHcBn2v1QAJ8Onx15RqWIAxiBFiWxeCpoj0zDHcpMZ3hThhHMorc1UQHP6vBmp6MaAsnaJ95qbeu+QzdMU5nXpQg6ko70NmE3Sxn/z35FmCd9DcFiuZaonPv61vnFXpnIKUVh9WZKDLEyf485sGzwwbSyTxlFrvLcK71iH8zedcR+dmNx0TwbARPsA5GQxotGxZ9w6yHVE4BrmmlV/3SEa1ki9XBfCA8xS8v/uGydx9FjxWP/alL6kLSgWIOCmTGzfT8r5gv78NsjcXgHVPdXixXfR/68D/8Ch6aKZNPHxcM+FHJWJA5ysNQL8b5n5P7bNDoQYzCjRJw0xkB61WWcCK2YLoLp+g3rX38g2YUBXCh7d4R5xGIY14HagprMEM5zDo9Xsau9B0G6pxlrg+LpM/lGPY8lEWUl3RtHT7QE2jQ3HB+iauigQ1mdXc5djFyoNlSyQJVVig4Uv6yD2+NhX1X+Ptde/zn1Ab7Uj2MPa+0lJPm2N4ToxkXwEAVocganTxOfwq7KtiFH3iWfr9vw/q
 Dl+aQb0I
 52RTFlmwG5+X+S94dX4z5rJTWbI+SQyhV3NywaRHruB8222bpxqgeVn118O4LZGJygHPYqqefisXJfnMXj2I8YHLsbmL9VsnAXe6Joy5QtZtci7QakGBLCSbqAIr2WQLrnSdMCeOf7R9+JsTnUkTT9uBU2R9uD3hWVImiOWT8QrbbXPhCdWnHgk9t/YSKn9VqJ/XpeggMZv3P/ClhKNOpQ1SbjZ1hxmynnWTp0cdQzC5WwQCQ7og4y2AZ0Baa6bOsyn4nMUKadSSMQq8655YfPvyrbFZdUDJuqiX+Zmctpb6I8RU9xOoi2x44tq5d57Eynpo+pvXLG86cJvWCuwEaBeccW/+HyMRkRg19tfGJY52TrpdG67EqsRVsYop7MDWBDr6D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 14:02:06 +0000 Leo Yan <leo.yan@arm.com> wrote:

> On Mon, Nov 09, 2026 at 07:07:23PM +0800, Wen Jiang wrote:
> 
> [...]
> 
> > > Do we have sufficient ARM review?
> > >
> > 
> > Thanks for picking this up.
> > 
> > On ARM review: Dev reviewed the earlier revision in detail and
> > his suggestions are folded in. Leo Yan tested the large vmap() path
> > on TRBE/SPE. We'd welcome more ARM review from Ryan, Catalin
> > and others.
> 
> I confirmed that my Tested-by tag remains valid on the latest version.
> The improvement is consistent with L2D TLB refill reduced from
> ~16000+ to ~500+ across multiple runs.

Thanks.  I added your t-b to every patch in the mm.git copy of this
series.


AI review found a couple of little things:

: In [07/10], vmap_pages_range_noflush_walk() uses an int nr
: index, now shared by the high-order mapping path. The previous
: high-order path used unsigned int i, nr. Beyond INT_MAX base
: pages the new index overflows and pages[*nr] can go out of
: bounds. On x86-64/4K that means an allocation above 8 TiB,
: within the vmalloc VA window but requiring a very large machine.
: Please carry unsigned long or size_t through the direct walker.

The vmap(8TB) limit is already well known, not sure that we plan to do
anything about it(?).  But the patchset seems to drop that limit to 4TB
for higher-order pages, which can't be a good thing.

: In [09/10], nr_contig < 2 can be dropped: the loop guarantees
: at least one page, and vm_shift(..., PAGE_SIZE) returns zero
: for a single page. I withdraw my earlier NULL-page objection;
: I could not establish a legitimate producer of that input.



