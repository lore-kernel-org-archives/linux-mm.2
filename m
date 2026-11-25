Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3992606A680
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=Th9WkmJA
Received: by kanga.kvack.org (Postfix)
	id 1CD116B0A67; Wed, 25 Nov 2026 11:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4F66B0A69; Wed, 25 Nov 2026 11:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBA36B0A6A; Wed, 25 Nov 2026 11:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2FDA6B0A67
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:04:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C530580AC4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:04:18 +0000 (UTC)
X-FDA: 85474113396.16.FB8FA4B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75DE520010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:04:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Th9WkmJA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795622657;
	b=0DOyLbOOFViT8C7IsOk1AQhUZ/uGi6x0S0NADZ06qW0LpZCVW0lDCcFJneZ8TMEYVFtr1a
	bDd1kLQ8qBIojAzawzWYwy/26mmqpyjoLSkeveXLHJOEhIPifyd62sbsnauCoRV5EuAoAk
	cGXwgHVuDmVcGH7bf8UNdrQvYc8zb2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795622657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LozVc94GvRrMpc05Z6BHALOclMWxHaFig1ixRTKkdyU=;
	b=Ia5n9ahunba8uSF/gRGy+XKRyHwOZ75ONsD9c6k0ymLb7w1v7Un9N89EIk+3UfVqLjAyUk
	/KKn9eJD8uX6kJkztaCoE9ZS+EIL1UpjUQdC6gmIxBRRF5qxQVXcx6LxSTEcJWcR0JovDA
	1SMCzYDiCB2+ZYRjbdNs9rtsjJp4d7A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Th9WkmJA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LozVc94GvRrMpc05Z6BHALOclMWxHaFig1ixRTKkdyU=; b=Th9WkmJAm20Jktbi/zYzyZaOgX
	BjVyyFdGD3TGMyljTvD+yJTzFUq9AEoZyUNauy2qrAauT95N4P/TL9iNr3hSkSm/kF7ArBq5415/S
	CoaywChZFxQy/1UnTQCVJkeW9nohTRLMNH37hcZeUvMZyFEm5aZ3S/JuPoFl69s+9dDqfNYW9nFW4
	Pb70nVw3U2LuiNZbmCrWu4ivq60e9kkzN52b1HfBUSU4QFwvUfLZLff/Zugc+yvZZfDCBd0P+vEFS
	2DWgv/zrsUEkgGngu8xYoRY6INTtaI8oa1ikYVUfb5vQ6TLpMJsaQWv2qBfVXalT9hUc2/GwzdwAb
	3l6H4OxQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWFTf-00000005Vfy-0GiP;
	Wed, 25 Nov 2026 16:04:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 18D053008BF; Wed, 25 Nov 2026 17:04:09 +0100 (CET)
Date: Wed, 25 Nov 2026 17:04:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Harry Yoo <harry@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>, bpf@vger.kernel.org,
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
	daniel@iogearbox.net,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
Message-ID: <20261125160409.GF2668804@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
 <awWRZ9xCzWLnj_R6@thinkstation>
 <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
 <awbvek-HS3OJYJGF@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awbvek-HS3OJYJGF@thinkstation>
X-Stat-Signature: zm54k4btyf1fb841cffae9yupgkheexy
X-Rspamd-Queue-Id: 75DE520010
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795622656-653740
X-HE-Meta: U2FsdGVkX18piRMvOf3tQvmnk+zhacKD6E/G3j7Ij17sl0x0g3IiIOIN27e6/Dm5QjUhMEfvz4iN669Yw+epQcdeN0ZpSZu/tCss0DtFQxnoq2m7oTNbSexTngGZH3xxgxjXfXze34AnoBnXZwr4wYhEiNDudKrSDArRplXBBR22Az132YpczCG9MbmGJMaYj1X7iR5sTEN/mqlImWpyYfVPpgrVlLuR2aax11Psd0UYYTw2eTW0mZLQavi5PIdeqmjBX3kjVEzcOOCtC4pqzZTAm7bUSyigqPiN7KENEUJGXoHxFlkxihP/idgDhU//aBoozr+9ye6KdJXTdQXOHINLfTDOcOMoIILnMRNQc3UFUwRHbPES+ZznvyFjVj86Oj/N46lsJhh+lZAmNsDW2QdRzgfswnU+q5PAa8bTZ9NV2ft+l/aoSCm0RGDmVY7ICBwXD6EPK15bDImaEBoFuIsLglSLzYDR/0h7yOdPLLwS0icfvUlCafmsNxvBQs0EYojIQce+m3KsHttFqVMwUibmGVek3KSYmmHsIVzi5L7lHZoWzK13BL4Hqlr3VmkBQuAph1b24hkWgtlQAXqEiA7ZagXwfrXMbmAyHYj5oqBt85cQ4vuIfRddYgf6KgLgglmbwEo1+KJAEoC03BQUMC/hB7reKk5VlrxNwyOeQ0gH0TQkYf9NidLZMAbJkz8HKxWlNQQa1DuCnLyHJ6HbkQGNK5EcZ2u8PB4fKb0GJiO0+1iKDaWdSVdXz6YInwhV9S9IYjoSlwPOXLmbxtPGiLaEIFDeADDh3DorBffKJHjnjT42boHhk2T6jPH0VnyhX5+A2RfCguq32fi0ruLe3VF3+/dB0baFZil4f3llABH3BfkxK0DZxGOnJVRY7hfjvO6Y3HUIbc6Va8kOQNhGhoHb3h5jGg6/+LPtamzsU2KKDBCKN6Pp6y3INoSAMqDVL90Sigz7zRsHq+g+W7H
 CwxgqHWA
 4FdM+ihlNC4hzX5uL2bSIXbrtCzhXw0vxiK13WkPU1jXORBSl/rjsobbIV1l6RLe1Do92DA5trPYmcxYxWzAE/9JY8Ba+zGlYnK4omOSpHl4HSImQgGVv1stNNJO1qOvtHyxxqbhLVxF7bFzclJOCR/ajg9p2rTXEXusJ8Dlt3tbgFjqf+cMia9Yj+1Ksb5CVzXrpENVmz2IV1o2oxCdRCTiaVXXgAt3LlyPFz/xGuUbEVR9TJYmUB9ebQKArtcTBkECFCStijGMaGW7wOZAWjsbYJVfgoJJIxrHmMGLbR2pqa6kZZ7OYR3BRKRNyLVoHUYvy2ehpSCOtYZJXhbSmBmPpSxVeikld3sUMihqB/f59dPOimaNmf8ab86gnQQQ6WoBwhFOTXzSLYSkhMF52JHbgYjuqISRJTy3/9D0VxBxXwLl2hhotMgKIi+d9iomBEobG5jG/1j4pN60JKjiR6qz+P5agIysh6CB5sZHAtYeqfVeNhyr9NHAk5qk4eDdF4zJz+UXbdyY60lH+Mbpu0NE+L8Na89H9tZG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 02:30:52PM +0000, Harry Yoo wrote:

> > This is absolute atrocious shite. You cannot attempt a spin_trylock from
> > NMI context. That thing might be a mutex.
> 
> Uh, right. We went through this when kmalloc_nolock() was introduced.
> 
> > This should not work; if it does, that is an accident we need to fix.
> 
> Current implementation handles this by can_spin_trylock() in
> mm/internal.h.
> 
> One remaining accident we're aware is that we cannot attempt a
> spin_trylock or local_trylock under pi_lock (even on !RT).
> 
> Currently I don't have a good idea to fix this :/

Yeah, me neither, other than creating specific classes of
tracepoints/whatnot where things are explicitly allowed.



