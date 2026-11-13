Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B9C606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LjmXZN4T
Received: by kanga.kvack.org (Postfix)
	id CFC756B05C3; Fri, 13 Nov 2026 14:15:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCFE6B05C6; Fri, 13 Nov 2026 14:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2F56B05CA; Fri, 13 Nov 2026 14:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 958AB6B05C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:15:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E7BB1A01A6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:15:43 +0000 (UTC)
X-FDA: 85431050166.21.4F66727
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 682E7A0011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:15:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjmXZN4T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwPuVq7T8FdelkrZoqjLG70zrzZ/KbjEwFQO6WatOkU=;
	b=xyBhux29+Pp/wjG4Zx6Pc5fRLb0E18B7S6AovxuZ+y1Xf+d60Wt+aZhd+3YJuSI0ze8zVK
	GlSk3I7QLRmD9X72d/JZ85Sdzpvq+SyvHZVrx2w6sXVpJSo59Z8MxbFXvoYWpDXS+A5rRu
	6w+MWk+OqPzCcn04bWl2O7vPNUcKtWw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjmXZN4T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597341;
	b=hrrgAGI1GOJC84ZIgVyXZOHHX+l+IsYorGpQeGdevzgzWkeDGYu2RFTA5qfsY9DoeVuTXj
	bVK1pD/JQ3WJFZanci1HyOBFUjz00oaa0n9PmAagvJtwWLSyfhCAxgb8jejfY+igEmhz/W
	UUp+lPLOsSBJHivIP/FwSXeT0ubP90U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E21D6633BF;
	Fri, 13 Nov 2026 19:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34681F000C4;
	Fri, 13 Nov 2026 19:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597340;
	bh=hwPuVq7T8FdelkrZoqjLG70zrzZ/KbjEwFQO6WatOkU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LjmXZN4TxOHWUMeds0ZDPxwPCBanIIeDnosnRa9n71ZxOThzbLrZgo8dJNYMXfqwj
	 mW/DpaVwx5UkWp/+j4UaZ3V6+W7fDsNZb3CDJbdrpQeHrBwsnOB4an6C2KWXWHxcdN
	 A0LR0HWkvBY/UKYBWCJ6b8qEzT4YCefgJxwv1S4ewW1U0mhkaFtqSVfjrtdEWnHKmO
	 OgVRoeK4MHUrpXzMBIJ+45gKib4aXMDx4tCerHrLm51CAvJAbb8qI246UZLsLACGPH
	 9lB2uXB3KBe87fpe69pC69v1a+e3nhCYIAd3V7GUSRQFSnNQ/R5WoGEFdjNXxQKUB4
	 vQ7k5qcNPlGcA==
Message-ID: <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org>
Date: Fri, 13 Nov 2026 20:15:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org> <avcNcL6svEOTg_3r@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avcNcL6svEOTg_3r@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 682E7A0011
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: j1keqstd5s31agmhbfwhdneb1kok4qww
X-HE-Tag: 1794597341-745446
X-HE-Meta: U2FsdGVkX190wn+1PTRHj7Pb9/fR3wWikkXXOIwWkAkY+MMxCuwKSljhCWY/RajLSCZadEqj8sdgPvZy1v6AqFAQHal9OsVN6sSEqdQlzyZ5TutM4yf5/1A7ptgcTo1BOFyz01j+EJv9CngjMw+30DMgslCTLQ1I9jwW9v4THGQQzdSHaT+OtjRavaS5fV/8sZzlc/pm7rX0wjODZbOd43Fbkq4N4zEe7J+NBTAfmEWndC8PAFhPNraSKnJHOlMXtBy1VuY7sJUErdQS+BXJG9hc1umgqLmfZO3vBAH3hrA0WLktitO/chUA0vsWN8X1TcPDOmCiiiUNt6XGeFgmDga5NPTJoJpaY9csQy7xp2vdzJ6MG6zJyGU4dcuqSV/wbf28hs3q4C8shoDZBF5XV0RVodt3U/4dti5RcaUmx3qYr3z+2MSJGJ+kG3VMyonCEi5S8JnOZ6f9m1UhU+JYOfrZ2pRPMF21U0iNaJHdS9pYAIdgobzipWf/e5ULovgNFWimeCY2OJ8k+D3BFFgIKmKNXBoRKLc+UlzqJ5/zp3sOU8Qf+koHTDEi16RBBhNeoPl5Iz1Q5sLlZ2v92j41VYkuhdRlIee9t1TFtGv5SadHcXpLhw0NZhgQ38MF+gouT5DwRIo3FbgWuw5zhNBFPHROAdHB/Pi5wGFsZ3axFnESVF65I/PCrxDuQmm+r1KBZffIpvyQPM46j69RfCMHGtlgejl4k9Wy73Fb6lLhcPArkHKhXabhUouCUxt78Go9dw1z8f+WxyjlAN1n5qzIjYzXjjjAVm8y7BNfQO2G2XVtMRI6Wi/TTv0y0cdQ54+Lh3BCJNb1DTbnlrTs2hvJFbeO1ezLO5RL51uQjHyRM2RvF9umlZ0vvcJ4y73KkHcm0VkS9ApVd8is5LVTTiVAAq818+DKRwGSHsQLE1DhmlroL5Nnqczdc2pS3LzWdkC8oQLkOal/AkDO3EyMIsH
 488YQhXN
 qgzOZ6PloovcwXUH9Y6h6WniogoZayv0FsQ1HQBq5it4G8Ldz1VwBCrrHUoJYSIaSSgcsfUclIna+Hxdw5SUB3QWjXhESy3nwu8sk6ciTbKO9yqIJXHmfYaQKaaAhiwAZPI+K34TO0uOicP1ynvTRXAQmdY/dAAs8T70MP6qocg2MLqwQEpteoJb4JPb0UiAZMwEx9sfD9pW6lVSXoBKtXCmRtq8dUFIdnTIFBQaa1yeBY0+daN9fCyjqodjgFjQ4fYMJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 14:59, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
>>> In order to establish guard regions, guard markers are installed in the
>>> page tables of a mapped VMA.
>>>
>>> However, problems arise when one tries to combine this with registering a
>>> VMA for userfaultfd, as such operations may themselves need to install page
>>> table markers such as uffd-wp.
>>
>> How does this interact with UFFDIO_POISON markers that can outlive even
>> userfaultfd registration?
> 
> The zap clears poison markers, as is standard. It's really horrible this logic.
> 
> So the code path for zap used by the guard install (via zap_vma_range()) is:
> 
> zap_vma_range()
>   -> zap_vma_range_batched() with NULL zap_details
>     -> __zap_vma_range()
>       -> zap_p4d_range()
>         ...
>         -> zap_pte_range()
>           -> do_zap_pte_range()
>             -> zap_nonpresent_ptes()
> 
> And zap_details is NULL.
> > In zap_non_present_ptes():
> 
> 	...
> 	} else if (softleaf_is_uffd_wp_marker(entry)) {
> 		if (... !zap_drop_markers(details))
> 			return 1;
> 	} else if (softleaf_is_guard_marker(entry)) {
> 		...
> 		if (!zap_drop_markers(details))
> 			return 1;
> 	} else if (softleaf_is_hwpoison(entry) ||
> 		   softleaf_is_poison_marker(entry)) {
> 		if (!should_zap_cows(details))
> 			return 1;
> 	} ...
> 
> And zap_drop_markers() checks zap_details && zap_details->flags &
> ZAP_FLAG_DROP_MARKER.

Right, my intuition tells me to just nuke that thing by setting
ZAP_FLAG_DROP_MARKER.

MADV_GUARD, is just like munmap() another form of "zap it all and protect it".
>>> This is especially problematic because guard region installation causes the
>>> regions to be zapped first, meaning that the removal of userfaultfd-tracked
>>> ranges will not be logged in this case.
>>
>> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
>> ignored), and then zapping that.
>>
>> Isn't guard marker installation/removal just another form of zapping?
> 
> I mean users being weird could decide to use it for that rather than
> MADV_DONTNEED, but zapping is a side effect really.
> 
> Really the idea is that you might have users who, for whatever reason,
> faulted in some range, and now want to make that a guard range, so for
> convenience we zap it for them :)

I think not just convenience. There was this problem with faultaround / THP
placement IIRC ...

I'd just zap everything that's there. That's literally what the user asked for.

> 
>>
>> So to me this all sounds like "if user space does something stupid, it's user
>> space's fault".
> 
> Unfortunately, as per Tal's series, there's more to it than that (linked in
> Closes: tags).
> 
> You can get an infinite syscall restart (ugh) if you do this on a shmem
> range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.
> 
> The other bits are just about a user losing track of uffd stuff if they
> guard/unguard, as you say.
> 
> But every other zap code path does the uffd remove event stuff, so this is
> still an exception.
> 
> If you support uffd, you have to add a whole bunch of horrifying, awful,
> terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
> have to drop the bloody lock and reacquire it too and make sure all that
> works correctly (...!)
> 
> Anyway there's basically 3 options here:
> 
> 1. do something like what Tal's series does - add a TON of complexity for a
>    use case that nobody uses to get behaviour on something nobody sane
>    should care about (i.e. uffd/guard/unguard/expect uffd correctness).
> 
> 2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
>   'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.

Right, that's what I would do.

MADV_GUARD_INSTALL zaps everything.

It already zaps swap entries, migration entries, hwpoison entries ... so just
zap everything.

[...]

> 
> If you're really concerned though, we could go with option 2, which will
> just make UFFD behave differently for guard regions.
> 

Not really concerned, it's just the most consistent one for me. Zap everything.
The user asks for it, like he would ask with munmap().

> (I regret, obviously, ever allowing this for uffd ranges. And we _all_
>  regret that uffd was _ever_ allowed to be merged in this state...)
Yeah ...

-- 
Cheers,

David

