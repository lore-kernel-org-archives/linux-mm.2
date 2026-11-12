Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25937606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGVBP0Cq
Received: by kanga.kvack.org (Postfix)
	id 0D41B6B05DD; Thu, 12 Nov 2026 14:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACBE6B05DF; Thu, 12 Nov 2026 14:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04136B05E0; Thu, 12 Nov 2026 14:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4CA76B05DD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:52:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6451FA90E0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:52:52 +0000 (UTC)
X-FDA: 85427514984.12.C7AE974
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C185DC0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:52:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGVBP0Cq;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794513170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6g6Q2Oc4KxDyRr8E2Y5ffCl+6LA2NNHiXLm26F3enDk=;
	b=gT/yAOaUkDem7tinoFeq5sjBS6omrPXVt5U0GifTyDcNP2hgN6PvFLB2HpJGgR8LKQsZZ0
	wzr43GloZR0DI2urLd1RVymLW9rkZnQWNCrHo/rNkPjq2Shf+01iq4krbSAzaZJCNBXDui
	SCJyMQflAyj5gy2hali6pHWRGfHuyp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794513170;
	b=qBSHxr6wYoSgLGlERL1PjdAtkO8JB61zW2DPO8HAco7shjCjk0unrjz6XHab/4y7zVwabZ
	GKBzUNdpZ7vj7dBQAdMY2d/nsMo0dQwcZfc69SKeg13mwB5FaDYawguW6vgYeK6X8sc7Jv
	ECugxtDA4GCH8zoo2Q2vnrEDByv/nlU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGVBP0Cq;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3758A61868;
	Thu, 12 Nov 2026 19:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1991F000C4;
	Thu, 12 Nov 2026 19:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794513169;
	bh=6g6Q2Oc4KxDyRr8E2Y5ffCl+6LA2NNHiXLm26F3enDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PGVBP0Cq7hu3Aw59R/1O0fE7lSUgGcOn3+9OHQCe3HyuoSz6a92FnrAyvz8+EPbPa
	 yu7y63LGnBGu1f4FLWbTpUsdlT+e+MmGDiGfGguzDB9RjfGiByDYmwXctb60H1XVPG
	 n7DhppG2/LGiSGaLWbdmJJmRrqSImkajVb0R4o+3beSJB9cV9l1RB+JiAFg8M2Yz0L
	 cRoI8Wkp4eJiBvBD4QahPkfBYkzL+b1N5rwVevc+qmnKlWXpbFBPflPIlAO/djwqut
	 EGCpFo/7a8c29CELEkIsvGusYTeMFuBAZOzBkMsNP8d3VLHjM0l5iyvVdTVrdUbaH+
	 BPC3+JxTwU8uw==
Date: Thu, 12 Nov 2026 19:52:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
Message-ID: <avYVPp7fHNg8WSUB@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-12-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-12-00713d368976@columbia.edu>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C185DC0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: toa4dquwzssy9jgosesid7rf357iogje
X-Rspam-User: 
X-HE-Tag: 1794513170-576271
X-HE-Meta: U2FsdGVkX1+/bkl9Tcv/IbppUy4dPwRacNsV3lc7xYiLpVYbgzIsNgar366CzedzISk2JOIAIX8na8ryONsMRHuxjKt5TI8yn8/gSaw0tGgHDMEPfbGKaI9jfihzbJF3PW6+i/+W5xP/t7MKb2K6rkji5VbpUGNSzXjB4tDkr+h21Sd3vEV1QWryQcB7N7HK7iULe+2Q4bjsw282pb1Hs1BXzWsk9TUfH0JQ3iWduPNpjaaqT/HByzJfpPTjmgtztGVnqogLbr1VIl/waVlVU4pUqAEcOdyrL98wuTekqksdeJ6gujmgaDv+9vqWE+bc26VHcZFq0t3h6m9OP3IU40jMRuhGfX2kA3Bp9K7+fHa/glsxU4wrPQpouvTByi7bNHdhCL4HkVZTqJg8Qz04A5oxxnkGb79aY62Jg0n72HJP3kGdrFd5N83bt3CFcYUJswWWDYMqwAbGQXgYgDXqQ2hWg12tquugfNrWuOTl4EMSNbPA3xhFFBNhIzHe3WL1ZQq2agGQvzowd5Cu8erGFgjV5Zh0eMpY5wgLBT5X09oq2wBguoQMB3z9S1sQKJdiLgevxHGOzvq6LNokYkZYn+U8xJ3WlihNCgGJTtEeW9/pC/se3YMnn0HyMCEY+nx9hH9xexgtr0wi8pa79MoeExowa3qB99OdxnNU3Eys+Btw+e21q5uXWjHtBbr7EJoy5SjEibUxq09MMdcmfZvslZpOb/VzLP8XLfIDGigb7tw7u/AYnehgTl13AGBGBxMeRUHPsWgr6izI9W/fQ4f7uYrYpIDwKYEY1KR6/+kOHwAmjwXcF7KD3uN169bkib1jNbBhir3Lt7NtT8LYf3wIlau6lyxoNc3A5qYJi3OWrBOhGsyGVYd7637l+gFrS6yhlnktfgNvDDhmAP0r/Z7K1UcKpF8XUT0m/hs7tIkRhEnBc6RSC7jSm0U8EK8sXcyJe82GaSOSdcFEXBnDxtE
 zJdVneRV
 KKN8ajKMwih35BSxnuhl/gCQk3pFAUGT34A8gu9kSsrAzE3D8dyZiF3zQIvrvGsPO/KmBiyU7OVztt04WprdGJ9W+hBLqC9amfhxX4hVn3lBNZdS0zoo3TSu8bqpppbmmJCtv5i1xBxPlmU+wVsva7TQVrxxBQxiZt7Q8xCxeJfDXviBoG0YX+fG/TQTI9A8WSyOzLGsbv4j3wH5YHsPq0ZmXCWwnERiFGxMywK40wZtsRBtGr4l6WK1VGX91OFWS+TilurQVa1rbHBOkKNo903GwDyNkuRrMN+z2iv3XHK2vAVmT2rIi1rwumOV8i+01N4WYYrN2Bd6yT2ib73lV+OdMeDf6jtX+hqLL0hzp+l+UkfafZl0uVbKFQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb vs userfaultfd is a bit like the alien vs. predator of worst mm features
of all time (TM)

On Wed, Nov 11, 2026 at 12:55:20PM -0500, Tal Zussman wrote:
> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
> before changing anything. For a hugetlb VMA, userfaultfd_register()
> rejects a range whose start or end is not huge page aligned there.
> However, userfaultfd_unregister() only checks the start.
>
> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
> split the VMA there. At that point, userfaultfd_clear_vma() already
> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
> stays registered, but accesses to its pages are no longer reported. This
> requires a caller passing a misaligned range.
>
> To fix it, check the end of a registered VMA in the pre-scan as well.
> The ioctl still returns -EINVAL, but no longer unregisters the VMAs
> before the misaligned one first.
>
> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/userfaultfd.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index bf42fabb5afd..c0076c8b4e9d 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3983,6 +3983,18 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
>  			goto out_unlock;
>
> +		/*
> +		 * A range ending inside a registered hugetlb vma must end
> +		 * huge page aligned, as in userfaultfd_register().
> +		 */

Hmm I think this is more or less saying what the code is doing :) so I think
unnecessary. Maybe worth using the words 'cursed' and 'eldrich' here to describe
what's going on? Or possibly just e.g.:

	/* See check in userfaultfd_register(). */

> +		if (cur->vm_userfaultfd_ctx.ctx && vma_is_hugetlb(cur) &&

This first check is pretty horrid to spell out loud, maybe do something like:

	do {
		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
		...
		if (vma_ctx && vma_is_hugetlb(cur) && end <= cur->vm_end &&
		    end > cur->vm_start) {
		    ...
		}

> +		    end <= cur->vm_end && end > cur->vm_start) {
> +			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);

Could be const?

Also is vma_kernel_pagesize() right? If the VMA is hugetlb, then that'll end up
as hugetlb_vm_op_pagesize() which is huge_page_size(hstate_vma()), but it seems
userfaultfd is full of this crap and yeah ok. Fine :)

> +
> +			if (end & (vma_hpagesize - 1))

Could do:
			if (!IS_ALIGNED(end, vma_hpagesize))

Instead?


> +				goto out_unlock;
> +		}
> +
>  		found = true;
>  	} for_each_vma_range(vmi, cur, end);
>  	VM_WARN_ON_ONCE(!found);
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

