Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E1A606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 07:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n9p1g7x2
Received: by kanga.kvack.org (Postfix)
	id 1E4C36B00EF; Sun, 15 Nov 2026 02:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195C46B05B0; Sun, 15 Nov 2026 02:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0863A6B05B2; Sun, 15 Nov 2026 02:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D48F56B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D3E51205E2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:46:37 +0000 (UTC)
X-FDA: 85436571234.03.ABA9E7C
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1FB41180002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:46:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9p1g7x2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794728795;
	b=bnzor03/JJldpGBN0kUoB/1+bq2/XBjd/RSVpKkbEGXW7Tys/7SkiLm0Jix9ymMPr+V6Zq
	XBnA2/UzItOZ/T/8aTbSXzoaDyImmOEAYsJl1uub1musKPEv7V9fT/WJQCIFOTCoERsca4
	kRDndVOna8mwpBcXH8+glyEjOCiv/+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794728795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DK+L45fLM0eTFpXkrDmE+xve33EF/t7QiHzPin4KYzg=;
	b=L9zqtZJ3EmIhmCaYC4uaT9VzjZxU+RfeLfLjDtWlSMQ15WmYhhcwmMCNkBirNCp+/lRMKY
	Pg+GMUWfBU7L638XFW5Q/4daWWaIUpJQZh0OkcCDj2HdTMHUVnAfAa6Y/OY16wINESgZQ7
	NFGrMn8++1tNbNYA9nSroFSRRfn/oas=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9p1g7x2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yF7XHudIlIhypmUU5oxh4ylUNM+N6uQezOp9runcKhI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794728792; v=1; x=1795333592;
 b=n9p1g7x2kHBX7I8RnjxwfQyilnfieit86jtKgXYGOl3Ttm9zXtgtDfERuRj0wghj51/bcYWH
 mn/dsEd/sS8mBN8HTMIqbnAkeSeq2ONqn5CUP0g4G46XUg7Hbr/79CPN1fqF8vytTYF9dz6u//D
 NBGRRclkoAPP5ontmpu7aAYU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b9e7cdb8db06deaa;
	Sun, 15 Nov 2026 07:46:31 +0000
X-Mizu-Trace-ID: b9e7cdb8db06deaa
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 3/3] kmsan: fix metadata loss during HugeTLB struct page
 reinitialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261114222347.227199839f5ffa44@chrisdown.name>
Date: Sun, 15 Nov 2026 15:46:06 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Mostafa Saleh <smostafa@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Usama Arif <usama.arif@bytedance.com>,
 kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <B8C10EFD-DC12-4388-9228-DC460CAA5632@linux.dev>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
 <20261114104150.58424-4-songmuchun@bytedance.com>
 <20261114222347.227199839f5ffa44@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 1FB41180002
X-Rspamd-Server: rspam12
X-Stat-Signature: wwid7qbqb86r94nmakjhjgqffpm1gups
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794728794-524925
X-HE-Meta: U2FsdGVkX1/awbwHGNyumbTPPaHgNHN5OHp3iNCFQ4OjPlF+pvJhdH1T9Dsy7vEQ+6TXb7m7BPRCOlWKbcYEBOZt/AeR2Pe3JCDVZSNUly0TIoQEZDE5N2EAsh7lipIXLR3xWx50vBfTeKimHPplZmZDDc9+/zrCQm6QTaEL/62iqJ8HJXn0MHEamDm6bGq6qq24DZiWacqQP7OAYAVzGP96Ugad7LXS3i1Tlpga8O59Ps9tI9kStHb+6WYwlQdCPX63c9cOh7ADje88IcUQSfGAbhaQ0KuvILNjxTkyYQBT6GoFDfBlH24VSlfwAjw3m6lrtuwUhoLqc9eM2JyIuMjS41qGUE50e2t7lJ0vyIY+L+a7QAFTNH9MfdGvDi0kyHgtuD8HOMRMjBmaB1iENqWvi6mzWS9HzyL4MmWL1X0zObQGCI4jJT2BQN5MtFdg8Jvyt0w6XGyR8xDuVVaRnyIucWtMWDLiSeeMXrBbOBDeo4tzvHGlSno1DmrSyxjuC4SpTjexBeylhwR3F8xL4t2Jhi4zfgzLvUF26iQ7yun3NDNCeeezOwJooFccnlvXOD2siNyA0pm4gMfq3XtBQkwLihq9lKhQisj0FRjObP79/01vPalLskOVJTG8a3a8qyQ/dynEX32tfS0hQcBP1Vh7GCJQ9OdHtARt1X2qM3xQjFFbtGeDtnWx+LtMK2qpMt7yA9Gx2w79jI8rdj01oTR2hoIHvoAXRykH3orGQwMIVRs6GtpsBm8G2mmBXqwAAST4coXB2CeSz3vZmvL+zOPYLRgb8ifKWa8NGMotbhd6FfIOJvqA2lpVvDegjFBjPv2MyUnBRZTq2ya9oZs4izDTYAAKhhUL1f3A0LHHwj1Vgg1SAYiDu8zc0HtDZXUCL7DbmKapazUvDToLm6P9UNwchLAYY3PzhjkWiP3zcZ5KxX7ka79sSwuTnFC+8wyh6wW9PNw8mXx7MLt8xFI
 HJQPojXT
 t9IwXNmdwxSJkQy1KXgIfrfDMG9x+jIhNxZR+ZDBZt2ZyVAZH/SZJo7dauXnWR3R+E4zsmM+xChR4QkPTweNnKjqeI2YcWptZVUJF7k3rUi/PfZggrbFKJVAGqFNSHDbbwjlQ53rwIMCwLdU2wl0zyGAcTmVk51HSiBkguuwlsBLhQmctuGOrit1+bQPBPzxDeQ4u7e3V5lfR8C5cB/kioh74UvjTQ0nPz/tdvGYB354pLG0/Plq2HbziKzNAuLexmB7g03TjIfxf60QF4RKLvwTP+knbg8IIqmyx6TtFX5LbFF4ai38xChuTek/OKpR6CBFjemYLU6TEfKoUlIbsv4W+3OREpI3wP5KLPnGIqEemr6DjOhD5/L90fnt4VVuCTTIz/nCUdby7L7liK+q9q4107ha9htpiqbWYWQOdzJtKUtptIS3OJMDM0smOKISIIujyLGwW2aGlFe+WKOEBdqDlV0KuGKHT+bXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 15, 2026, at 14:23, Chris Down <chris@chrisdown.name> wrote:
> 
> Hi Muchun,

Hi,

> 
> I can reproduce the crash and the series fixes it, and I think page_ext is
> the right place for these pointers. I do have a few comments, though.
> 
> Muchun Song writes:
>> -	struct page *kmsan_shadow;
>> -	struct page *kmsan_origin;
> 
> This takes struct page from 80 bytes to 64 on a KMSAN kernel, which means
> that hugetlb_vmemmap_optimizable_size() no longer returns 0 and HVO can be
> used there for the first time. From a quick check with
> hugetlb_free_vmemmap=on it seems to work, but nobody would guess that from
> the subject, so I think the changelog should mention it.

Make sense. Going forward, KMSAN can now work with HVO.

> 
> Documentation/dev-tools/kmsan.rst also still describes the two pointers as
> members of struct page, under "Metadata allocation", so that needs
> updating as well.

Right.

> 
>> +ifdef CONFIG_KMSAN
>> +KMSAN_SANITIZE_page_ext.o	:= n
>> +KCOV_INSTRUMENT_page_ext.o	:= n
>> +UBSAN_SANITIZE_page_ext.o	:= n
>> +CFLAGS_page_ext.o		+= -DDISABLE_BRANCH_PROFILING
>> +CFLAGS_REMOVE_page_ext.o	= $(CC_FLAGS_FTRACE)
>> +endif
> 
> This takes the instrumentation away from all of page_ext.c, when the only
> thing that needs it is the lookup. page_ext_size is already visible in

Absolutely right!

> page_ext.h for page_ext_next(), so I think page_ext_lookup_raw() could be
> a static inline there instead. That way it gets compiled into
> mm/kmsan/shadow.c with the right flags already and needs none of the
> finagling above, and it saves a call on a very hot path as well.

I'll include this change in the next version.

> 
>> +	preempt_disable_notrace();
>> +	page_ext = page_ext_lookup_raw(page_to_pfn(page));
>> +	if (page_ext)
>> +		meta = *(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops);
>> +	preempt_enable_no_resched_notrace();
> 
> This is quite a lot more work than the two loads from struct page that it
> replaces, and kmsan_get_shadow_origin_ptr() has to go through it twice
> for every instrumented access to direct-mapped memory, because it calls
> kmsan_get_metadata() once for the shadow and then again for the origin.
> You might think that's a bit academic, but it does add up. For example, on
> a 2 CPU VM, perf bench sched pipe -l 30000 goes from about 1.37s to about
> 1.58s with the series applied, perf bench syscall basic -l 300000 from
> about 0.66s to about 0.75s, and a dd of 300000 blocks of 512 bytes from
> /dev/zero to /dev/null from about 1.63s to about 1.90s.

Good catch, and the numbers are hard to argue with.

> 
> 1/3 says that keeping the pair together lets callers avoid duplicate
> lookups, but the caller that matters most doesn't make use of that yet.

Sorry, that's my oversight.

> From a quick hack that has kmsan_get_shadow_origin_ptr() look the page up
> once and take both pointers from the result, the same three come out at
> about 1.38s, 0.62s and 1.54s, which is no worse than before the series.
> Could you do something like that here?

That's a fair point. I'll amend patch 1 so that kmsan_get_shadow_origin_ptr()
uses the shadow/origin pair introduced there and obtains both pointers from a
single page metadata lookup.

Thanks very much for your review.

Muchun

> 
> Thanks!
> 
> Chris


