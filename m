Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C331CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629466B007B; Fri, 25 Jul 2025 18:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9F46B0089; Fri, 25 Jul 2025 18:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516A96B008A; Fri, 25 Jul 2025 18:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42CE46B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:42:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF223140838
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:42:16 +0000 (UTC)
X-FDA: 83704261872.23.F29A0B3
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F2818000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:42:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZ6pCdAv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753483335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0Ko/T008kKzATvgo21S/8DgIEmpbQO5L/7e7R+RnuA=;
	b=bn1J4IYz9AnNpSu1wdq+KP2Urar1lF+c3WTqtyEnnwPBtKGqw7YdL9LH+pSxlqcSHYNhDj
	urAA1d2YMR7Guuxy8/S8+6WxtD9+6bqx0Wi6a8+5OEeR9ardvUZRtPfzjZlsTGNV9jZ9iB
	S+GRWz6HzqFQAsPodzo0FsipAX/985A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753483335; a=rsa-sha256;
	cv=none;
	b=val23wwzoctFprkNMwRZoFfch/ZtIhJJMZBi7u+SpKZhfLI0W2/AWpjXIBsc9j4W6IB0Az
	KMzCSbNS9PDHBFx3wqqmONqQAKOFZq0sBgwhMROnNXPqU0txSF6DuhBWxqAnB01mEJ7WEP
	jTwG/p6OZLkaMJAt6k7P/SXrQifCidM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZ6pCdAv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753483332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A0Ko/T008kKzATvgo21S/8DgIEmpbQO5L/7e7R+RnuA=;
	b=nZ6pCdAvBYhWZg4stmEXGZH5XqIb8tSQDnvH847rHfYlDIMqVqE+C+HBAtAuhl/pQtur2N
	CNgAVpr+Hv1R6Rh1tfJkcGv1PPIsoJ0daGeq/bGM3KlgCCf9CnVBmQGGWh/f1tKWxgZy6c
	uBfKo+1+LocCIHfJ9czveJ9oEIpY/00=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Matthew Wilcox
 <willy@infradead.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH] mm: consider disabling readahead if there are signs of
 thrashing
In-Reply-To: <at4ojyziprhhktjgtfmuyzrqwfmomnly6fubkvmbtxkdnx6hpb@5nldc3vipwny>
	(Jan Kara's message of "Mon, 14 Jul 2025 17:16:51 +0200")
References: <20250710195232.124790-1-roman.gushchin@linux.dev>
	<at4ojyziprhhktjgtfmuyzrqwfmomnly6fubkvmbtxkdnx6hpb@5nldc3vipwny>
Date: Fri, 25 Jul 2025 15:42:07 -0700
Message-ID: <875xffsxj4.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0F2818000C
X-Stat-Signature: iab7rz1bwe5ckbeddwsdj1j558gamtjg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753483334-381671
X-HE-Meta: U2FsdGVkX1/SIJUSUQf7NojWRTOeoGNQnmSiJ/lzxoKC0OxVvxrS0U6qYdfpyuyIliuZ4DoAOYXKzKhqw8OSH3nqrHVthsUEoF0AgUgfEwzvVSWHBkeAmLYCx+G2ewjT8wyefSBw1oJ8f0H9i3gDQkBC2OUXMK2dN/iQSTsVjx+hV6yZI792FcUI/zsbstvUcBJnj9aV6PwbNbYbPlaTwbKFIIJXlpemXBdKjsqpw6PekD6+psVEz8XMWKVbnkl46ia1+phnBBw6WHmbePC91+1HpDfzwiTdZcUGuF94KPpH5kgyid2+W4kT6Fz/I9LByenr6EcPSJCihDTstT4wF2d5od/DUFli49Up7CDhQ5wd/SGfECwePLhO6ROdjkUo5bjUrQ8PYlNhmFJqvaqS4414yvvvb4ZBe5/0QWpskSH5P9bAiVqcmUPIZnminDzab/9vTKdn9Q8f3n0iSQCeKd7kNb6smzZOwP+FfcW4P3q4Hiz7bkm86rdP5b/Of899hDpNpOfjDWnymwi5wHjyassLWq3+2QX5dzj1O5DOdcToNMiq4VdKPw2ewfl6LkljXJLoHYFE6F+vnE/rUkzulWXyM5lX5rDpw9MOX7ZKpYVCPvl1OWxALFxCiTg/jU/TwFIXYuTZdTPGpigLL9yzDCyidnMu1sDv2RWUYzmNw6rdEfOujQNT8pbRHU300tiVxat03bea+xrHKTwIF4xwZDwdvRO6VvvFYqH7xlA/HIsnJw6t1cbxGQ6UU1y1NvVXQ/8YmB1cLAkvdlBPaiflS6nJuCspmvpGHctIkIDRXBEvUnMp20WbP1RBNY72Hi5285fvrKnEIRWGzRuiwPj/9OuHRUOw2PVeGxRAUJrpDkjPvhY3G+XEWNqbuX8xNMR4E92f+Sk1vjaL1YbrD/sgcRPIGrFan7UCm44kSJZnGUMRZrkA2EdvyEZTYvLftl6iQLwAmTSxkd+7Pimv5Hf
 WlisIskS
 uBjZWwGX5RcF6RkbCdRrP31qtlIEw3tAyQPifXse6pVDAUodW1dJ0MmGmQgDqLOnLOBCOhKg8SLzLo9svoCN/esktbbIooFTLTLI+e5XfV68ZnY0Urn/+rDYViyVpo8/l504vIi8RtPp3OyojTA/d/L8vnvThyhzYlQOM/2GtsExQQff0+X4Zni/z6EYs+hDaRPe+1I6rJ4UNgpRFGg0GTjcMJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> On Thu 10-07-25 12:52:32, Roman Gushchin wrote:
>> We've noticed in production that under a very heavy memory pressure
>> the readahead behavior becomes unstable causing spikes in memory
>> pressure and CPU contention on zone locks.
>> 
>> The current mmap_miss heuristics considers minor pagefaults as a
>> good reason to decrease mmap_miss and conditionally start async
>> readahead. This creates a vicious cycle: asynchronous readahead
>> loads more pages, which in turn causes more minor pagefaults.
>> This problem is especially pronounced when multiple threads of
>> an application fault on consecutive pages of an evicted executable,
>> aggressively lowering the mmap_miss counter and preventing readahead
>> from being disabled.
>
> I think you're talking about filemap_map_pages() logic of handling
> mmap_miss. It would be nice to mention it in the changelog. There's one
> thing that doesn't quite make sense to me: When there's memory pressure,
> I'd expect the pages to be reclaimed from memory and not just unmapped. 
> Also given your solution uses !uptodate folios suggests the pages were
> actually fully reclaimed and the problem really is that filemap_map_pages()
> treats as minor page fault (i.e., cache hit) what is in fact a major page
> fault (i.e., cache miss)?
>
> Actually, now that I digged deeper I've remembered that based on Liu
> Shixin's report
> (https://lore.kernel.org/all/20240201100835.1626685-1-liushixin2@huawei.com/)
> which sounds a lot like what you're reporting, we have eventually merged his
> fixes (ended up as commits 0fd44ab213bc ("mm/readahead: break read-ahead
> loop if filemap_add_folio return -ENOMEM"), 5c46d5319bde ("mm/filemap:
> don't decrease mmap_miss when folio has workingset flag")). Did you test a
> kernel with these fixes (6.10 or later)? In particular after these fixes
> the !folio_test_workingset() check in filemap_map_folio_range() and
> filemap_map_order0_folio() should make sure we don't decrease mmap_miss
> when faulting fresh pages. Or was in your case page evicted so long ago
> that workingset bit is already clear?
>
> Once we better understand the situation, let me also mention that I have
> two patches which I originally proposed to fix Liu's problems. They didn't
> quite fix them so his patches got merged in the end but the problems
> described there are still somewhat valid:

Ok, I got a better understanding of the situation now. Basically we have
a multi-threaded application which is under very heavy memory pressure.
I multiple threads are faulting simultaneously into the same page,
do_sync_mmap_readahead() can be called multiple times for the same page.
This creates a negative pressure on the mmap_miss counter, which can't be
matched by do_sync_mmap_readahead(), which is be called only once
for every page. This basically keeps the readahead on, despite the heavy
memory pressure.

The following patch solves the problem, at least in my test scenario.
Wdyt?

Thanks!

--

@@ -3323,6 +3323,10 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 
+	/* We're likely racing against another fault, bail out */
+	if (folio_test_locked(folio) && !folio_test_uptodate(folio))
+		return fpin;
+
 	mmap_miss = READ_ONCE(ra->mmap_miss);
 	if (mmap_miss)
 		WRITE_ONCE(ra->mmap_miss, --mmap_miss);



