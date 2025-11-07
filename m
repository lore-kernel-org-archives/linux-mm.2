Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BFFCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58B38E000E; Fri,  7 Nov 2025 05:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30988E0002; Fri,  7 Nov 2025 05:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DBE8E000E; Fri,  7 Nov 2025 05:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 851AF8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:16:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26D7B1A0432
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:16:24 +0000 (UTC)
X-FDA: 84083406288.21.300FB3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C5521C000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:16:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awbR0Oez;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762510582; a=rsa-sha256;
	cv=none;
	b=l3Ekzta5xp4cRefP3LQCihN3MaboL3f+KJgMGIvGTqRGWEMD8Awv5HGYnFC8xaI0TYGNIr
	B/kxBxthX5pP/d2B3whrU2ONh2E1M1PlEkLdOhbDUklgiHb0oT+VSib4B7TCiWv2cnEz4J
	I2DPiAG6dYFFSthONZe+DTjg5i4Jwlg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awbR0Oez;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762510582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbyGOOp/aOkwmVqaiVboc5hvBKX6aWPHOeCGUl6BpQ4=;
	b=VLcNfv7acqZGOmg8YKr3MpM4X3sa1AEdY8OLSmpheRi3X4Yw2JOXsDeheuIwFzmtReKBmf
	u0wTNhMy6nQW+mmauAe7SfKmMEDf9p5cnoo1aqvcR2ildBZDzj2ipWw3AbhIBChXyo1gBj
	QdtVb0YQLlFhQD2hht7dZe50zXV9jA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71C1A618FB;
	Fri,  7 Nov 2025 10:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C642AC4AF09;
	Fri,  7 Nov 2025 10:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762510581;
	bh=tGg0Ew6wJCOFUYAwLzpnT5v9JKs4CE3fRgVoMFp1YAU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=awbR0Oez26r8jCfmHn4FdEWH6w5alT6ZcidVw9+wKGgkjS/oXmq9H8WFVMcl5uWLq
	 fpUgnbeYUkmsLMLnNQWkY24KLAGYy7VTJZiEUP5aZ8w6CTLtTlQvUsy0lrw9ZVKX25
	 R+YU/kv7US9T8NZFJWKKqMctJFHaBngBtn/2q4OsSGlO82/TmGHS8Vxzlt6LLDOAsW
	 95dKR4t7tSq3DAyzziGGMUbyVzinAqrIuOQ0mYWKJAd9y8ARhO6M1JAx6kNJkPDr1B
	 rzeVSQ+fEmfatInpC5p6r9FJ4Iz+b/3GRT71TAz7Pa5qbMHIbt0UoOQCtjw/fC4e6E
	 SjK1Lnju3RV5w==
Message-ID: <29da6069-1d41-4b15-be95-5c1889a37aa0@kernel.org>
Date: Fri, 7 Nov 2025 11:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Peter Xu
 <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com> <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <78de3d64-ecbf-4a3d-9610-791c6241497b@redhat.com>
 <boylgf5thjyblsvjlumxrwg5qfl43e4revh5i7yyh2yiddhgah@gtht57bgkuzn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <boylgf5thjyblsvjlumxrwg5qfl43e4revh5i7yyh2yiddhgah@gtht57bgkuzn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C5521C000A
X-Stat-Signature: 74hjcy9nfqz81hs6of9gb4gurgxqc5ao
X-HE-Tag: 1762510582-838275
X-HE-Meta: U2FsdGVkX18TSGO6zHiBmVgVzRnrwoBmA2ZQ7tyZGkBVQU1ndvRBHbERZDb1KTm5XneNlarCIyozB9NduHcpgaB1ldpjNx3qRx1kt3Pkq9gQb2h91OWpb/rV59pQdoJ7iJ+QQYTRgU+qXqNs3HNW0qhSGxRarZPjy3Cv1IoDsXF+s940BEd6bADllJkTUURreF1i7pj9djwuzYbGTtk5iAI8WFt0ubP+osKzoxbZZsItCJhQEazfFaS/FBCUxuvHKdjpZlSLTnpa6mq6mQRPspS/DT6QefVgqy5YEgeqtI/epyQ4/C0/RfIuqraDtrXmEkStNaPdVykOw0GZZ6pS3ScRa9b6pSHecqRMVIKYgyMkVYRyFzt3Inb1QEjRtD/lXxK7tVwaM4qsGSoBaVNgCFrsTJpDo7ZCfIvsAlNT+UMIdo9LF45AfcKthrJAZpF5iohNXgdw84haTEilwPjSV8GNIgpxzJEq0YMtb+5/TzYxltuLNBHO2fMtUI74Pr8nbtOxC2DCGnaQyxmrCNzMTPZZXNlV2ScHHwD9bhCVlP/OnV2bWq3DhqCmm/ViJQTNAjJ0BcXb6dayK/yBSZ9INPdHfuKfdjkB1TmhgKl+S/8z9jh7VLXwew/owchVgRRKUWWOuWvkba93690XmVfDtuc8iZVWLmJOt2pYkMFOVfuxhitrQ/l4G+/cIIbleoH0bdUD5pKV8FdWWPUoWfEd4NrEbfZ1ScPRlj4fTBia0p2H3box8lQwhSFCXvRk+RsLa69uYNkM9lIux/TWhl+l7xg15fBEdg3MRXePUA6qjzNtNXOsHgaLgj5A87EHBezF0OmWR7GBLNOXwEmNdYAlREhxvUl0UMeXbM4NysLB9jsW97V4qIYs1AedZmXzl+gf6Nkvl7dUFoD1636EMNx8WchZdJCs+K6+79owS6CjiwrtgHXbNoYnTFueNJzqGRaHIsERnrKq8YRv1RUJJ+y
 ctNLB0zr
 cGuLCtmerCNu5ULOkyzzm2+c+QedTQ6btbx422orNWi13PE0lUY/thNSYxJ70pou+x1Hr+nnA6CH+uyVYbToRnwDgcCYvDH1EBfVN3z3JSOfU5XfjjZYQkdNxjafaYa5Bu483d8uSMik/pItBybWo6jrTQxQuaC4CvA8dPnwHEpP91WTHpKmIhCyK91yHVd6bMKzeYlN5LQSjuO6fs7TCw6MRKyXAjaHXRH75hy6bQmBL5X4UFKu7ctgh29ahAdw4nWUDXrA5U8gO2aeFEuW8614I+gp9UwMDlBwArhMExCz4lf5qopiRBOAJX/SM+8SmXAVj18BrsSn9U1Dvj/OWkIV4A7BUyT+J8KJ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[wondering how my mail client decides to use random mail aliases at this 
point. The kernel.org change seems to confuse something :) ]

>>
>>>
>>> uffd_flag_t has been removed.  This was turning into a middleware and
>>> it is not necessary.  Neither is supported_ioctls.
>>
>> I assume you mean the entries that were proposed in Peters series, not
>> something that is upstream.
> 
> No.  This is upstream today. 

Ah, you mean *uffd_flags_t*. I was confused there for a second when 
grepping the codebase.

Yeah, not sad to see that go ;)

> uffd_flags_t is used for two purposes
> today: 1. deciding which operation to call and 2. pass through if the
> request includes wp.  In fact, some of the callers just create and send
> the flag only within the mm/userfaultfd.c code because wp doesn't make
> sense.  Once dispatched to the operation code, the flag is only ever
> used to check for wp.
> 
> If the code was structured to use the call path to know what underlying
> operation, then the flag can be reduced to a boolean - which is what I
> ended up doing.
> 

[...]

>>
>> After calling err = info->op(info);
>>
>> Couldn't that callback just deal with the -ENOENT case?
>>
>> So in case of increment/failed_do_unlock, maybe we could find a way to just
>> let the ->copy etc communicate/perform that directly.
> 
> The failure case is only detected after getting a folio, but will need
> to 'retry' (copy is the only one that does a retry).  Retry gets the
> destination vma, where the vm_ops comes from.  This is why you need to
> return to the loop.  So it's not that simple to moving it into the
> function.


In mfill_copy_loop() we have

		err = info->op(info);
		cond_resched();
		if (unlikely(err == -ENOENT)) {
			err = info->uffd_ops->failed_do_unlock(info);
			if (unlikely(err))
				return err; /* Unlocked already */

			return -ENOENT;
		} else {
			VM_WARN_ON_ONCE(info->foliop);
		}

		if (!err) {
			uffd_info_inc(info);
			if (fatal_signal_pending(current))
				err = -EINTR;
		}


Just to be clear, I was thinking about moving the failed_do_unlock() 
handling on -ENOENT into the info->op(). And the inc as well. 
(different) Return values could indicate what we have or don't have to do.

> 
> In upstream today, the return -ENOENT can only happen for copy (in fact
> others mask it out..), but every operation checks for -ENOENT since they
> are all using the same code block.
> 
> All of this code is more complicated because we have to find the vma
> before we know what variation of the operation we need.  Annoyingly,
> this is decided per-mfill_size even though the vma doesn't change,
> currently in  mfill_atomic_pte().
> 
> I think we could find a way to do what you are suggesting, and I think
> it's easier and less risky if the logical operations are not being
> dispatched based on uffd_flag_t.

Yeah :)

> 
>>
>>>           .page_shift             =       uffd_page_shift,
>>
>> Fortunately, this is not required. The only user in move_present_ptes()
>> moves *real* PTEs, and nothing else (no hugetlb PTEs that are PMDs etc. in
>> disguise).
> 
> The hugetlb code had a different value, so I did extract it when I
> Iunited mfill_atomic() and mfill_atomic_hugetlb().  I am sure there are
> other changes that could be removed as well, but to logically follow the
> changes through each step it seemed easier to extract everything that
> was different into its own function pointer.


Let me elaborate to see if I am missing something.

page_shift() is only invoked from move_present_ptes().

move_present_ptes() works on individual PAGE_SIZE PTEs.

hugetlb does not support UFFDIO_MOVE, see how validate_move_areas() 
rejects VM_HUGETLB.

Also, move_present_ptes() wouldn't ever do anything on large folios, see 
move_present_ptes() where we have a

if (folio_test_large(src_folio) ||
     ...
	err = -EBUSY;
	goto out;
}

So I think the page_shift() callback can simply be dropped?

> 
>>
>>>           .complete_register      =       uffd_complete_register,
>>> };
>>>
>>
>> So, the design is to callback into the memory-type handler, which will then
>> use exported uffd functionality to get the job done.
>>
>> This nicely abstracts hugetlb handling, but could mean that any code
>> implementing this interface has to built up on exported uffd functionality
>> (not judging, just saying).
>>
>> As we're using the callbacks as an indication whether features are
>> supported, we cannot easily leave them unset to fallback to the default
>> handling.
>>
>> Of course, we could use some placeholder, magic UFFD_DEFAULT_HANDLER keyword
>> to just use the uffd_* stuff without exporting them.
>>
>> So NULL would mean "not supported" and "UFFD_DEFAULT_HANDLER" would mean "no
>> special handling needed".
>>
>> Not sure how often that would be the case, though. For shmem it would
>> probably only be the poison callback, for others, I am not sure.
> 
> There are certainly a lot of this we would not want to export.  My
> initial thought was to create two function pointers: one for operations
> that can be replaced, and one for basic functions that always have a
> default.  We could do this with two function pointers, either tiered or
> at the same level.
> 
> Most of this is to do with hugetlb having its own code branch into its
> own loop.  We could even create an op that is returned that only lives
> in mm/userfaultfd.c and has two variants: hugetlb and not_hugetlb.  This
> would indeed need the hugetlb.h again, but I'm pretty sure that removing
> the header is 'too big of a change' anyways.

Yes, I think leaving hugetlb be the only special thing around would be a 
sensible thing to do. But I would expect shmem+anon etc. to be 
completely modularizable (is that a word?).

Having a high-level API draft of that could be very valuable.

> 
> 
>>
>>> Where guest-memfd needs to write the one function:
>>> guest_memfd_pte_continue(), from what I understand.
>>
>> It would be interesting to see how that one would look like.
>>
>> I'd assume fairly similar to shmem_mfill_atomic_pte_continue()?
>>
>> Interesting question would be, how to avoid the code duplication there.
> 
> Yes, this is where I was going here.  I was going to try and finish this
> off by creating that one function.  That, and reducing the vm_ops to a
> more sensible size (as mentioned above).
> 
> shmem_mfill_atomic_pte_continue() could be cut up into function segments
> to avoid the duplication.  Or we could make a wrapper that accepts a
> function pointer.. there are certainly ways we can mitigate duplication.
> 

Seeing a prototype of that would be nice.

> Really, what is happening here is that the code was written to try and
> use common code.  Then hugetlb came in and duplicated everything
> anyways, so we lost what we were gaining by creating a
> dispatcher/middleware in the end.  Then handling errors complicated it
> further.
> 
> The code has also bee __alway_inline'ed, so the assembly duplicates the
> code anyways.  It's really an attempt to avoid updating multiple
> functions when issues arise.  But now we have error checks that don't
> need to happen and they are running in a loop... also hugetlb has its
> own loop.  And returning -ENOENT has a special meaning so we have to be
> careful of that too.
> 
> I don't think the compliers are smart enough to know that the retry
> loop can be removed for 3/4 cases, so the assembly is probably
> sub-optimal.
> 
>>
>> (as a side note, I wonder if we would want to call most of these uffd helper
>> uffd_*)
> 
> Yeah, sure.  Does it matter for static inlines?  Naming is hard and I
> think shmem_mfill_atomic_pte_continue() is a dumb name as well.. it's
> too short really :)

I think it just makes it clearer that this is some common uffd 
functionality we are using. Tells you immediately when reading the code 
what's common and what's hand-crafted.

Agreed that the names are ... suboptimal.

> 
>>
>>
>> I'll have to think about some of this some more. In particular, alternatives
>> to at least get all the shmem logic cleanly out of there and maybe only have
>> a handful callback into hugetlb.
>>
>> IOW, not completely make everything fit the "odd case" and rather focus on
>> the "normal cases" when designing this vm_ops interface here.
>>
>> Not sure if that makes sense, just wanted to raise it.
> 
> Thanks for looking.  I think there is some use to having this example
> and that's why I was asking what it might look like.  I certainly went
> overboard in the last few commits to remove hugetlb all together, but at
> that point it was so close..

Right.

> 
> I think there might be value uniting both hugetlb and the normal code
> path, even if the operations call signatures are aligned and we just use
> a pointer to a struct within the "while (src_addr < src_start + len)"
> loop that exists today.
> 

Right, what would be valuable is still leaving hugetlb be special, but 
minimizing the degree to which mm/userfaultfd.c would have to care / 
treat it specially.

> The removal of the uffd_flags_t is also something that might be worth
> exploring.

Agreed.

-- 
Cheers

David


