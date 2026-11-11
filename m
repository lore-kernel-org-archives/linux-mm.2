Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE72606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVnQURsS
Received: by kanga.kvack.org (Postfix)
	id AC5AD6B05BF; Wed, 11 Nov 2026 04:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F0F6B05C0; Wed, 11 Nov 2026 04:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DC96B05C1; Wed, 11 Nov 2026 04:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FED56B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:30:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0740580243
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:19 +0000 (UTC)
X-FDA: 85422317358.21.EABA472
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 49F4780007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVnQURsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUjiaW6Rhbau38Ly+jhTqaup61BIGoXxlnOZsbFZt+4=;
	b=gwqYhe2qzqySIEuIneLvAPCLFH1U9ykRStLoXBLh2VQ4/4nzapRgQL4lXO0mh9hrAeqKDE
	QNKHV1PRmx4zFoMisPQNhWzs+kbvoyTPCAEiG3rCn6cOHkWI65PPJcHxJlj+ng/N5T8IiW
	qC/JFaS9CA9ymUEJBnoNS79NxSR0iOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVnQURsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389417;
	b=BakxcUs2jJ97Fc+HA5XEPPViopN92P5RQz/bPbG25xuB4j7OJjwTcJpMd2/+diOddMMHty
	f/xwFSSTCr0fy9f9qZZMZuoj7DZyU9IYEbM4htoSCI5Z4jjet296tJEi0ZUdmqmQsZrEK6
	UrAonH0bj/Ev+c+tn3TlDO4V9KcKDWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C275450C6;
	Wed, 11 Nov 2026 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2374F1F00A0A;
	Wed, 11 Nov 2026 09:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389416;
	bh=PUjiaW6Rhbau38Ly+jhTqaup61BIGoXxlnOZsbFZt+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JVnQURsSS5rX4Y373GS7m0C1CIvewDuTBUAwGFXCTvgFYRWph9BsqPxCT3kqXl/iw
	 NJ9AbbUEaw8eC7iAUKu4WilF+zfyYCJArhC0nRWHb39ci9xYDhWHVAvwMEPclQEP41
	 VS9NQKs/zG8oTo72teAXzkT5ATNVtoYwk6dGk7IDHuDVBFeIGib/pZHgZ8qHfctvYI
	 3Gc2mZyaGo+vz977EV/tzrAjHPs/TF/FyuiTIMS5bjyRGKYzzvN1c7OuwbfPWG5eSz
	 kUP+s9w1PFexXOa06viDKFV0JuI50tBayqJoG9JVDSmgGGvP3Vu/UVQpz/vL2HpZqv
	 uq9If5dt+6zkQ==
Date: Wed, 11 Nov 2026 09:30:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <avQ1W2J7lXraRsYs@lucifer>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
 <1c57ff65-ac25-44d4-8416-c92623f65066@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c57ff65-ac25-44d4-8416-c92623f65066@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49F4780007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: smfbafmwy9rfhcbywkjpgtxduxuxxawq
X-HE-Tag: 1794389417-357838
X-HE-Meta: U2FsdGVkX1+1PSng2TW9ude56RQRzRf6sY+H5JoigGrKkLc0V8yYZzPIzyCc8t1vUcmAynNw9EedsbsB58oZTYMLO55iH+xe/IKiGVCYkKLy6gGcTrp0YaCj/jl4owXZkGIS9bx2b2JcnxzhAlFxe/iWC+tQmhgVkxIBCVf2zCxlHLz+qVzmqPtSOAZeZ8MJEIcHOK6l9liI+GNy/pOuSxC+jFJlooskOtIL2BhNsWEGA8TNjs8d34n+uXf0Ff7VKtaIKDbfwU/RAd5qBh1vZNYVpXtSPrprBTerIrYlvjM/Tkh8T8ohiLNdMQrpo+gGZVm7GZANKikIWkSLLMFMIjj7yKtoIEUbt6cCxsYiM1Pgjdfppzi1fGxVTrEld1QYbzPMk1nMixH2GE4vipTmHnZfBnYt2D4sE4vAI4eiY+t1GnrjhR9OUdOlyvMjMh+aZRkr0zyJtEoXW4MgoYZvBsXr5GqSUzoqRGHtJ82HxqO+Hjkgjlk7XzrA050I6Rl24hNK5GqKsXYjjDGhZ6OHODbaoUjc7zMTIWfE7ZBCY3be4+q0WUZ+eEhy1Fds5vIE856DP8tMi1hqny8Q75Rjk8uBGp2/o+pXxQkIHPKlsfG+HvIJdVqs8pEYi4Hj6pWl6XQOVUj8OXFgsAervhxK9SbNpQuYEIG12eIflnE2JH0m2YQ8wlvO5Qk9LLWnK53g3KmJxuxZkJ0ly/f+B3zYDkdQ13XFaiN6WqCeY/f7PIAWLAsJ/NTo4a1PFtRVmnYz6h94TwAZQz7Jj1O1VjK6+L47b5Lt2zGryQgjDOhuB/oV4DF0J/BjIzHXox3HpSl+vG4WKgHY8mH4oFRFEoiuYwuK/Cm/w0LqMYQJZjmEb8NMf+5jV6n8H+/7hsgoRyaiHBpWcCukWCaLBkotSetgCbLSrDGhtxyAfNQ9rRYO5FtqU2zXi0BWzhdACJRg0ee5ZecMzLDP0zeRdggU5wV
 KIbwXrIZ
 1u+po7xkIBfezEfEb9ifr5PEyX/ixhkm0dJPynxO4H5mOHuBlCvqLG6TiR/pzbxUGTf8zj28LkhHOYMcx98E4HkJkIJgrdxQ3oIox9E9RpA/Lb06qHIpQF2Tr2chfsz74mYOfcL2Rsgobt7C0chd6NSsIm17vSUs67HfKEokuWZ45G2QwgDYP1Tvy2caHAQ3NFgEZW0jUEVgVD3B6VMyy1CL+66wyvIwVK7qjcAZuJArJ1KmshSZFWHmzxh6bKaDqyZJc8L8Io5P5MEMmq59u1m8ddg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:27:50AM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 18:19, Lorenzo Stoakes (ARM) wrote:
> > khugepaged walks an mm's VMAs under the mmap read lock in
> > collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> > them if encountered.
> >
> > It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> > when these are encountered, however only checking this budget once an
> > eligible PMD-spanning VMA is encountered.
> >
> > It can therefore hold the mmap read lock for a long time if there are a
> > large number of ineligible VMAs present in an mm, over which time no mmap
> > write locks (and thus no VMA write locks) can be acquired.
> >
> > Address this by checking whether the mmap lock is contended after 1-10
> > ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
> > long time for a lock to be held, so is a reasonable compromise for
> > determining when best to do this.
> >
> > Skipping an ineligible VMA costs ~100 ns on tested hardware (x86 server),
> > so a batch of 1024 bounds the lock hold to ~100 us without expensive
> > high-grained timer checks.
> >
> > This scales for large numbers of VMAs, and tests with ~1M ineligible VMAs
> > reduced the maximum mmap read lock hold time from ~93ms to ~110us.
> >
> > This was also observed to reduce mmap_lock stalls in concurrent threads of
> > a similar duration. Note that a reader re-acquiring the lock can currently
> > steal it from a writer that is queued but not yet running, so the full
> > benefit to writers depends on the linked rwsem change.
> >
> > Local measurements indicated no change for ordinary use cases, so this is
> > all upside.
> >
> > This work came out of investigations into mmap stalls when getting latency
> > numbers for an unrelated patch series.
> >
> > Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/khugepaged.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 7d1414a9b2a5..59bbef61f104 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -66,6 +66,13 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +/*
> > + * The number of VMAs to walk before checking for, and relieving, mmap lock
> > + * contention. This bounds the maximum mmap read lock to an estimated ~100 -
> > + * 300us depending on hardware.
> > + */
> > +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH 1024
> > +
> >  /**
> >   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> >   * @slot: hash lookup from mm to mm_slot
> > @@ -2910,6 +2917,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >  	struct mm_struct *mm;
> >  	struct vm_area_struct *vma;
> >  	unsigned int progress_prev = cc->progress;
> > +	unsigned int nr_vmas_batch = 0;
> >
> >  	lockdep_assert_held(&khugepaged_mm_lock);
> >  	*result = SCAN_FAIL;
> > @@ -2942,6 +2950,18 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >  	for_each_vma(vmi, vma) {
> >  		unsigned long hstart, hend;
> >
> > +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> > +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH) {
> > +			nr_vmas_batch = 0;
>
>
> We could simplify by just doing
>
> 	if (++nr_vmas_processed % KHUGEPAGED_MAX_VMA_SCAN_BATCH == 0)
>
> I guess. saves one LOC ;)

Could do, but I kinda like the 'keep it simple' approach often :P

>
> > +			if (mmap_lock_is_contended(mm)) {
> > +				mmap_read_unlock(mm);
> > +				cond_resched();
> > +				mmap_read_lock(mm);
> > +				vma_iter_set(&vmi, mm_slot->address);
> > +				continue;
> > +			}
> > +		}
> > +
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks! :)

--
Cheers, Lorenzo

