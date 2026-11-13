Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB88606B1AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nkcpuIX/
Received: by kanga.kvack.org (Postfix)
	id 8F8826B05B4; Fri, 13 Nov 2026 09:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A92A6B05B5; Fri, 13 Nov 2026 09:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE4E6B05B6; Fri, 13 Nov 2026 09:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 524706B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:00:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E227FA79CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:00:02 +0000 (UTC)
X-FDA: 85430254644.14.7B672BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37C174000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:00:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nkcpuIX/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794578401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etnvj+JpgQdzFYHD+qJZ07knY/Y3hXQM/Aj2QDnzPPA=;
	b=X/8qIJ1pbGlbWITeLATpxhum5DO6kQBwr73D14060ZvY6IQoUBjjyPPmVQKWM17Z9InSue
	zY8i7NXzgZ9pAuwK/veMEhac5ydG5W1gzIYn3Fg1Es3o0UOiSaNrWeum4Y+Y3YZdhwo3dW
	chXnFJQXS0wOeskaJ68sQ7Ny3P8nXqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794578401;
	b=M9Lo+16v/MMTfHqv1XVRQwBYyXuMKJbaISAwLRBPJPwgd2yM7QiMBfaZ21Hey94tsMpmD4
	2S1VzmvytIrhSgVoaHGkMaHNE+U25WFpuFdtWGrGbqv/rn8dkJRj9ubx4DTzBHXHjlyM+J
	9g0pMdAnxVC3KewJnjO0ZvLA6clNiRY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nkcpuIX/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EF3A446B3;
	Fri, 13 Nov 2026 14:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B711F000C4;
	Fri, 13 Nov 2026 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578400;
	bh=etnvj+JpgQdzFYHD+qJZ07knY/Y3hXQM/Aj2QDnzPPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nkcpuIX/hkjOJiARgEwaRBrnD0nUe+XNzRzHsWN2UnVLWwMWj+pw+6ethAkRONvx9
	 axQgvhJKZMaDkI4WgZjMjC7qbTWAZ/0PbWTT+AIJuRsaA5+S2t1gSpgukGd1mjtBKu
	 pPuwar1JLlxyUmfxwaDJCN171SuztT1SAURIbeZNEXds7GTJUpGrYqJUDgt7Vo4rTs
	 mQjmE9zbcYr4jvL3+89weq9Kx0R/AVUoXVtTa/kb+S5IBu53cAAUx6/kCdqzsi4ZOw
	 2POlwbzlsB8tGQg8xYz6MDFovOoQPmuenp6of0f+M27wjXYcpIBR71Qf7j5lU1AMdA
	 ADOc8KC+feT0g==
Date: Fri, 13 Nov 2026 13:59:53 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
Message-ID: <avcNcL6svEOTg_3r@gremlin>
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org>
X-Stat-Signature: chubz8pfotfrroju944zhmbdnta55yq7
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37C174000A
X-HE-Tag: 1794578401-703644
X-HE-Meta: U2FsdGVkX18a3J4eRjOc5tXwsEpdDZk8PyRfASe9HDwa7Mxg8ab6qCMV68SZvoxw7HJaihIotFCAlfFlbfgTCF+5YVnTc9YjwTwVjlN2671jukqEdfAnkLoaY22l51FmgG4x9HCFsvwdZJ6t0CCGc2Jut7PqcwcqIQRoY2HsM+7LJcMkdCGWiNCPY2UX37x1piUscN1qRXF7EQNhUhaQEXASnEmewXDAurEPX39BtHkPyYyS2977EgaF+fp+h6nlHrEUkfgVTBWZzbo5kT7HrRJ7FP4hPIPIXzxK65M07+VD0VZt3KaAgw2bifh+cQ0pKT6wz8uG12eVuLN6RAw7IUIelYt4b26HiE9uyRDPFFeT0ojYTBxwMb7F1WquHmo+RXBdx+pFz+4Rbx2qEDvo1+Kv/bRjxKQtNAVpdY423eL7gd/GH+IpiblCHXVBhO9mUsRmOx6Lq+UA2yfIuwck8wqWmmErM0RYduBdlaRzfXRpjXY6NLoT0Piopy/nySr31iS0WdfjOYtK2TIpoxlLz3rS6lU9qsGNygvRmxWjzalMq/3nNDzuPBpLqrUbQ9E/lik2dq/lWEkA1nMeda1lPWqM3CWsXbpjBZZugQa0POvJXUv+lP9IfQtuJxuKZokAioOi2lPZGllYp7Q4SXKD1FfPO4xqybcunDloXVhIv2+guyOU8qWWHLVw79prV3zSjDjnYW1+XsGxNi3FvKsb5d+PD84lOXhAMhqqWydv7UAxkkiFp8uTYRhZeN9/SrdOtb6WuXEv0INMJTsDU2TBWcwIq6uvfC8BY+dRD2iLCRSJPo85jmsE6gEXOk+HlL6HaqR9w/jGZNP9jLlxmfbWF9/WIt+jKw71AaNU9ci5IVj7W8MUWlTbPetkmBoQAdodFuXf1xsmuoxBNkRLThIwliG6mzP3NE4JdQdjgIVE32BgJaCkA9S9yyj7MEYP+nQfLZlwYFtVCct+nOjRWrQ
 6axTUhX1
 jlgQ973gTloD65hkvb+mFgjS1OpO37XzjF2OYVvYIPuHr46WOdEbNSBiY2pmHeEQKXOwDT0rF+GK6fsqka748U8jBR6eB56/LCxzIM2NDtdXk9hzuXez9cIS7cT2+BpNXWk0Le4cqqRJHI6+b9BB4pI63D2CkcEOj2o4NzjnjYZraR6YZObnQUgRyUQDn5ovwORKJXG2zMCqRSQAZetMprlYMIVvYwjg2vePmzaMon5hrOQFndVcQkWNY5bOJQj5D9qrd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
> > In order to establish guard regions, guard markers are installed in the
> > page tables of a mapped VMA.
> >
> > However, problems arise when one tries to combine this with registering a
> > VMA for userfaultfd, as such operations may themselves need to install page
> > table markers such as uffd-wp.
>
> How does this interact with UFFDIO_POISON markers that can outlive even
> userfaultfd registration?

The zap clears poison markers, as is standard. It's really horrible this logic.

So the code path for zap used by the guard install (via zap_vma_range()) is:

zap_vma_range()
  -> zap_vma_range_batched() with NULL zap_details
    -> __zap_vma_range()
      -> zap_p4d_range()
        ...
        -> zap_pte_range()
          -> do_zap_pte_range()
            -> zap_nonpresent_ptes()

And zap_details is NULL.

In zap_non_present_ptes():

	...
	} else if (softleaf_is_uffd_wp_marker(entry)) {
		if (... !zap_drop_markers(details))
			return 1;
	} else if (softleaf_is_guard_marker(entry)) {
		...
		if (!zap_drop_markers(details))
			return 1;
	} else if (softleaf_is_hwpoison(entry) ||
		   softleaf_is_poison_marker(entry)) {
		if (!should_zap_cows(details))
			return 1;
	} ...

And zap_drop_markers() checks zap_details && zap_details->flags &
ZAP_FLAG_DROP_MARKER.

However the poison markers only guards against !should_zap_cows(), which
returns true if NULL details.

What a mess...!

But obviously this patch doesn't change any of that.

>
> I'd assume it's just the same thing, just like having proper hwpoison marker in
> anon mappings, so it just works (uffd-wp will skip, guard installation will zap).

For poison markers yes, as per above.

>
> >
> > When this installation is attempted the guard marker prevents these markers
> > being applied, which can lead to unexpected results (especially if the
> > guard regions are later removed.)
> >
> > This is especially problematic because guard region installation causes the
> > regions to be zapped first, meaning that the removal of userfaultfd-tracked
> > ranges will not be logged in this case.
>
> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
> ignored), and then zapping that.
>
> Isn't guard marker installation/removal just another form of zapping?

I mean users being weird could decide to use it for that rather than
MADV_DONTNEED, but zapping is a side effect really.

Really the idea is that you might have users who, for whatever reason,
faulted in some range, and now want to make that a guard range, so for
convenience we zap it for them :)

>
> So to me this all sounds like "if user space does something stupid, it's user
> space's fault".

Unfortunately, as per Tal's series, there's more to it than that (linked in
Closes: tags).

You can get an infinite syscall restart (ugh) if you do this on a shmem
range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.

The other bits are just about a user losing track of uffd stuff if they
guard/unguard, as you say.

But every other zap code path does the uffd remove event stuff, so this is
still an exception.

If you support uffd, you have to add a whole bunch of horrifying, awful,
terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
have to drop the bloody lock and reacquire it too and make sure all that
works correctly (...!)

Anyway there's basically 3 options here:

1. do something like what Tal's series does - add a TON of complexity for a
   use case that nobody uses to get behaviour on something nobody sane
   should care about (i.e. uffd/guard/unguard/expect uffd correctness).

2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
  'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.

3. Disallow uffd.

1 is totally unacceptable + will likely expose us to new bugs (dropping the
lock is just... yeah no thanks), 2 just seems broken, so 3 (which is what
this does) seems the right way to do things.

Basically, right now, anybody using uffd + guard regions in this way is
experiencing silent bugs.

So option 3 is by far the best course of action. And no action isn't an
option.

>
> >
> > Therefore, disallow this.
> >
> > This makes sense as conceptually, guard regions mark a part of a VMA as
> > effectively unmapped at the page table level, and removing the markers is
> > like mapping the VMA again, over which operation uffd markers would in any
> > case be lost.
>
> Right, but that to me just says "on the parts of the VMA where you mess with
> guard markers, your uffd-wp protection is similarly ignored".

As per above on unfortunate need to do something here.

>
> So disallowing it entirely for a VMA, I am not sure. I could see use cases for
> that, although you might argue that user space should then register uffd-wp on
> the separate pieces. But then you get multiple VMAs again.

I did a survey of open source software out there - glibc, android,
tcmalloc, CRIU - and none of them rely on this.

So in general there's no signs that anybody actually does this, and if they
do, it's literally currently broken. And we've had no bug reports for some
time now.

So I think it's fine (IOW this patch is fine :P)

If you're really concerned though, we could go with option 2, which will
just make UFFD behave differently for guard regions.

(I regret, obviously, ever allowing this for uffd ranges. And we _all_
 regret that uffd was _ever_ allowed to be merged in this state...)

--
Cheers, Lorenzo

