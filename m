Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B183F589DA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12666B008A; Thu, 23 Apr 2026 10:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC35B6B008C; Thu, 23 Apr 2026 10:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D95A6B0092; Thu, 23 Apr 2026 10:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED316B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:14:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4478DA0187
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:14:04 +0000 (UTC)
X-FDA: 84690014808.19.742FDBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DF41C0013
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:14:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdA87yds;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776953642; a=rsa-sha256;
	cv=none;
	b=P7/gg0UXmvQ+D6cLu+eL77CUxrQbWp1+b7hp25N0x81rszPdptoNjETO3p2wdp8Iw601RD
	1BOR6bWoDXv1MZmzqH/UDbXi1pQyjzKvxnG2SuwGKgFq4ulcpo8nfLjdhKmGIsFnKq+QXC
	AgUXLt8K7WvusbYVit2vFezTYH0WO6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdA87yds;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776953642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1E/CuvYj6LlhN9kiDNJPcKqI/bueNkItOVsJUQHbbAU=;
	b=N23FrGtjPBBJgtAxvyY4X2yP1J4GraseZ5aqcLD013ukzCp4zLZBzgcBI85oNe2J4zb0LZ
	Ql6vo3/z0xegmsU/cu9z61gc137Ke7pfbsJrfPiBuLTCMyfL2x5TKUayC5YrzgOFdQGd8e
	glqRSoZg9OKCmWUHNAqc9XK1WJbi160=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 826126024D;
	Thu, 23 Apr 2026 14:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952A2C2BCAF;
	Thu, 23 Apr 2026 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776953641;
	bh=EpBTTRg1rLtTK6bSRcJ/pm4319w6ghGNpdcZ0k4OSCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hdA87ydsV5pc4MAndtcsCuNsC05FxkEo71aDamvg0Sn3MK6iJn6aTihkZinrUFWvK
	 jRXGDUYUDqeUHkVfeHN/wZYfAomPbPiCBWnmiBA49CG5Xv7M3kXXJ4NlSbOzpmVIPY
	 zuA74h3mUbHaz0eEefZgl4F2mYsLsp4d5Krn+/V9776lf0MRQ1/XhFCqNQthKhgJRN
	 v8SXfPzMb9VIvJ2CVpVyUJdt55IEFvNtXdhCtcRZZ503MTinIPvo3ZIHPkwbxWCjv6
	 fQmIxQ409UeodQVwxzGq2xy8vijJBwS1MYJ7Z3xLGvGuE47iAsndANwd7rzVEqIkSh
	 LStO62t5OdNbA==
Message-ID: <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
Date: Thu, 23 Apr 2026 16:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: Gregory Price <gourry@gourry.net>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DF41C0013
X-Stat-Signature: jzpk7xkpphppsjs3qphcnpkciguax377
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776953642-621571
X-HE-Meta: U2FsdGVkX18ibEzL/TjF/tjv3UpXyQOYwqMbVf+7NjHG2LAWQZUZdzlWnuEdV5ZooOzQuFlS87jRh8LtS2kHjWmyV5jyWDo9YSO7l5+4ClfOTnk0oiycx0WryZ+PB8+0ioTxML3nwDY/jgAUR8/sKnKHIlHlMSHya0p+MaSzCJ1+ZPiKghHf0qJAOCDa7ujWXOt+XDXImMe3w0EKt/Xq9HmbtUoViJwAf57AVYHhkcobw/3iC0xw5+4BMNXx5m294JTrAVCsEvUVKBgK5vg7vPL9DY+BQgwmS3MFebFI6YHegYzSOrzS9T6/dQ9u7PV3Y0ZwN4Mb1JGu9uGNZgrpYAmqX85d7GOXO4jNDqpMntop++C3uNH9SjkNPk9cd4l1XuVovowyIwwn+jHgqoo0jidDhRFPALV430TJ9IfUDaamgKsbWlgWPCgzU88WaKqhAu04ljKgesz4D2+ziVPe7t6mOxRFx+0jbgZHXvqSwJYaFfprlsPWFvybCO/dUqTnd5AsemXSrqrr+MUT/icmliBqvlkJ5aEf0gd0Rliho/bSazSwbgc9Qp2Sa73LvMM8/U7M5sNvZj8QeVQCTKhsC5hq7NWQYc/FgDPnAr+Fw0YClZeope/iLr3PETFTLygECnCpGglSTGTKLOavuSdiz4Rpinz4pQNb/bPsiM03h7EYgrDXmaOBmVNnOLJA7dn/dOWkvGxhlaDIG73E0GuTa5WCls8NSjgtOlUtEPWeJf6XWUgTYvjPJvhSzzSRZTPw90zuy+d/XUEBat2fQ7tmmlCLc6EzCC57fTejaTTWBFzqzqVHvY+b1YOz54u3+lmKSuZt/4J2KRYXwZH16PQBJTPikD1SiSHZzFRHyL+niM9kkrWA2ITny4uKehev6bK/oJ+vmEMkOplvdx20FBrvZfAP6y53zJUnIYej3mLvu469v+cU1EPygdDTFW9GCWlHU+JHmFSYWquGNF3tcu6
 IvPYh2xC
 F7JX8zx5LQ0sb5vHdLdlEG4aPxp1VMaRuWZMMf5utycKkWlAuXLjYXlpWvshjFvsKvDAzBnkEAooahCie2zUkaMEopGQQPt73XWeiDcn+W+oQU3HhEaf73qVGsgD/WjyBRdZ7NcbYfcLC6RGqGA7hEqJiVYdQLXGuq08vzEtW18fSWPsLWdOrG3C99BXrH3Mm5V6+ZXG6b8o1ugeUJzAcHsb/K3QJ6VL5sE3ChwL+8bRsQJ1+/9rc7m18qPgGLBIPv0MLXjWGlk9qdx1wHhNUxDpogjdjkSBE1Zd0k3whBn8lvq5Ncn7zOMKN4z+7UUrSbukM2s2UVJoCjKwMEvLWZ48RYit4GrwpdOH3cjiXQx5BULGl9p2Mw5QG53JI7hOFtbaS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 15:42, Gregory Price wrote:
> On Thu, Apr 23, 2026 at 07:57:01AM -0400, Michael S. Tsirkin wrote:
>> On Thu, Apr 23, 2026 at 11:46:56AM +0200, David Hildenbrand (Arm) wrote:
>>
>> Changes we have to add: 8 changes
>> Rename 4 existing APIs adding _user: __alloc_pages,
>> __folio_alloc, folio_alloc_mpol, __alloc_frozen_pages + add
>> 4 wrapper macros/inlines in gfp.h that forward to the _user variants with
>> USER_ADDR_NONE. Roughly 6-8 lines of boilerplate per API.
>>
> 
> This is essentially what i was proposing.
> 
> The result would be more external surface to the buddy (at least 2 maybe
> more functions, plus all the _noprof stuff and a bunch of other things).

We probably wouldn't need prof stuff if all we care about is vma_alloc_folio()
that will only be calling _noprof internally.

> 
> And then all the callers have to be updated anywhere, and not make it
> any harder to mess up.  You either have
> 
>     old_interface(..., user_addr);
>     /* Churn everything using the old interface */
> 
> or
> 
>     __internal(..., user_addr) { }
> 
>     old_interface(...) {
>        __internal(..., NO_USER_ADDR);
>     }
> 
>     new_interface(..., user_addr) {
>        __internal(..., user_addr);
>     }
> 
>     /* 
>      * Update some callsites to use new_interface()
>      * mostly a bunch of _mpol() functions but some others
>      */
> 
> but someone could still just as easily do
> 
>     old_interface();
>     /* don't fall folio_zero_user() - Bug! */
> 
> So it's not like this makes things any harder to mess up.

Right.

Looking at the patch, there would already be less churn if

folio_alloc_mpol()
__alloc_frozen_pages_noprof()
__alloc_pages()
post_alloc_hook()

Would have simple wrappers.

hugetlb calls  __alloc_frozen_pages(). That's rather nasty, given that
it wants to allocate a frozen folio.

alloc_hugetlb_folio() already consumes vma+addr.
alloc_buddy_hugetlb_folio_with_mpol() already consumes vma+addr.

Maybe we could forward the vma+addr here and call a vma_alloc_froze_folio() if
we have a VMA+addr to have a clean interface.

But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
alone on a v1, and focusing on non-hugetlb first.

-- 
Cheers,

David

