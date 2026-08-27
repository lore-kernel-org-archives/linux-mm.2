Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D7EC61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B1E6B008A; Thu, 27 Aug 2026 03:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BC86B008C; Thu, 27 Aug 2026 03:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D2C6B0098; Thu, 27 Aug 2026 03:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7AEF6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:49:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66AF516032A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:49:46 +0000 (UTC)
X-FDA: 85146275172.20.5490506
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C0E2A180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:49:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XP5GUoKs;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXKPSGKEnYpUCi4b1Zk1PpaxxASDBVDKKvWhbUsQzzE=;
	b=8ENvzJ+fo+lEeGqP38sY99I4R5RrF0uS0kq8YTrK3cAJP9G9m8TykhJmqtS9fRaV/GGhJV
	zEtqVTOotAndOTMZf3hC/7ZFuqajseoUe56NTcYxHoKcw3W10nmIDGfCVzDIEQ1T3P7WgB
	HD6xNyviCFQosijAjsjFBwcaItIFXG0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XP5GUoKs;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816984;
	b=LjxFr+S/d2vc1fvE3zQTNKLDyvgdQSFV5u78hQmJ9sPafbKFbT0M8kuCL/hs99qQleSECu
	S9+EiTKH1PMA7Bzzp6Q39oKw7aYZX3U4td/d11l7bmiEBpKpRUOAqpve6JQL/4tfILPnvf
	8qNsfQlaOJCMZNFPwhiC3b4AoRsTjxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03E3442E08;
	Thu, 27 Aug 2026 07:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DFB1F000E9;
	Thu, 27 Aug 2026 07:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787816983;
	bh=pXKPSGKEnYpUCi4b1Zk1PpaxxASDBVDKKvWhbUsQzzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XP5GUoKscwLfu7Wd9nUZA5nENI+S/18k7abGqbbmVOSzWIZOZFrV9h7aPu5Asmf7U
	 OwJFJSoNI9m1vYcI4QoNpM5xvoy8mOk6jaM1Q97ewpFzcC1YTjN1uSUpnYNCOKnOwk
	 6j7TJRULs5vWsgaNPseFCq3o9vlEli8peP2xq6qfnlFJ60vivszWc0cYPoskntdmIv
	 +q4aMFrl0i+M+oKTIqkT1+z5EdtxBtdRNeTn9qouluLVwxVfm7s09i/032hvBQHd+D
	 d/tiFEHJfC3XWiDyJzXWpQM4SBVsoSAqHACxmgKU+e97L6OVESE17Qpvxy508ZLpxM
	 mF/83rFlBH63Q==
Date: Thu, 27 Aug 2026 10:49:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <ao_sCh5zP0IC9H2S@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <5bb86e34-6196-4b50-b553-be2ff7c1fa32@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bb86e34-6196-4b50-b553-be2ff7c1fa32@kernel.org>
X-Stat-Signature: ajphe9zchjyqfubwyq7wk9rtjkcfd9z3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0E2A180009
X-Rspam-User: 
X-HE-Tag: 1787816984-975064
X-HE-Meta: U2FsdGVkX19QnzZP2d4n9NlQ3KzJ7zz+uOK53b4WmvHG4JNq46bwfT7cAEJZEIBKPEaZYUdkq63E6pjkf5DpWfiG/FJ1ZO4FWSC/V3rPXBRHNChnAI+1+DZvrIMHJ0dY6i3CexK0LWbDhiOGYvSkKL/S0IwJcEwuLPFRz69FlkmmkVX2In706kehOR33pqoW+wmxDjqPGoUw3HW37Fv8EX7XcXR4GF0PxaiNN0bMcdU+cXirpNm3JDjSYFFT18C2KDHtU9r5OmEdzvQvvYiX+tl/iWviX2lUwtOvOgccCS2dbbXzlP4SoGRv3jCxeLtQULz87M6pZMXvmWnlelazI8OaCkRSgd7bRUMFEJ5AVOfKVZ8HvR265NfzPQIrI9gb52aWPNR99E64NTj5hNWbM1uuT3nLkfYBPxkoEO/uv+looGandBrWay8FDvCczjpbUd+Hm9gD4NK3qD9vTdxEtVqfYovEvp3zQyMh5qpkpmN2fhbfakuhKratDVMMHyj3h25sCf8fxFo2mt7STtJcsFThqtNCM2ouvlgWGTsklXrxk3EdCyPZoRw2WiN37khs7RUjMBoPwPcIKtYetl0gJwej6sXEG+t4yb0cpyey/SlLB317SmPf13FCLjNc85SsRmCsoz3pU0qJUy9DJ5jaUy63dE+hAajwOVLgTseAJMz/RjJUKsAwos/Bm59dXP2xA7wvGpqlqChgLAgSXP0xuQ3WWMsGaAUbiMw5x9YAOTBK+MD6WlFJJ2kcJ9456p4igFpLYfTVTk6KnedL2gEuI9UxjbDnHIfvtbeRh3d0unhSmEgFjr9iT7JWQuDV0md4kfnMXoTCAlgPXq3ygI3cXQVAvy0BHedgO4qjWdEcanWu9XjUvNb8qeL23SaYr0x9VRgMd0GJLGb9QUapsTp5OiU84+Kx79QQndrDssrcXaEg+qOD6HcV463L3atT7e7EaQep85J/n//lkT1dIKY
 jR1pt3so
 ixb36WJ3pW5VOl7ET34D8QG7/H912xeGzVxMczl9v5XIWtmrMKURcPSKN7q9Bg06essbpTOY6XMWZ7tSt2Z1tkRhyTTiIAH2VNUFDPLZKg1Ull74MjyYdyN5FbpObDIO0qlEzKdKu6kvCHGXPrQ4QGVC2SSuJekjWLO3Qoz9dIzaFdIFI4pIdbHahs2YmU4kAEEeQNTxr0BuoxIcVNCgfmo3l8jOnqna5CFRnP8RXq4uRqVRW3GS4pEnyfmNDKL5jnaa0jXA4RN/9Lpb7h6w5nC2IGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:46:14PM +0200, David Hildenbrand (Arm) wrote:
> On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> > Introduce enum uffd_reason to define reasons for user faults rather than
> > overload VM_UFFD_* VMA flags for that.
> > 
> > Using a dedicated enum makes the code clearer and decoupling the fault
> > reason from VMA flags clears the way for moving the uffd mode bits out
> > of VMA namespace.
> > 
> > No functional change.
> > 
> > Assisted-by: copilot:claude-opus-4.6
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
> >  include/uapi/linux/userfaultfd.h |  6 +++---
> >  mm/huge_memory.c                 |  6 +++---
> >  mm/hugetlb.c                     | 10 +++++-----
> >  mm/memory.c                      | 10 +++++-----
> >  mm/shmem.c                       |  4 ++--
> >  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
> >  7 files changed, 47 insertions(+), 35 deletions(-)
> > 
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index 45355bdb4ec7..f401623f315d 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -9,6 +9,18 @@
> >  #ifndef _LINUX_USERFAULTFD_K_H
> >  #define _LINUX_USERFAULTFD_K_H
> >  
> > +#include <linux/bits.h>
> > +
> > +/* Fault reason #PF handler passes to handle_userfault() */
> > +enum uf_reason {
> 
> Can we just call this "userfault_reason" or "uffd_reason" ? Maybe the latter is
> actually what we want?

userfault_reason sounds better to me.

It describes what kind of user fault we are handling and the 'fd' part has
nothing to do with it. 
We do use uffd as a short name for the subsystem, but still most if not all
userfaultfd "external" APIs use userfault_ prefix.

uf_ was an attempt to make it wee shorter :)
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

