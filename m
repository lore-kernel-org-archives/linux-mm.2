Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE20CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A38F6B00A5; Wed, 13 May 2026 13:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154C66B00A6; Wed, 13 May 2026 13:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091846B00A7; Wed, 13 May 2026 13:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED1746B00A5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:46:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9FBBA042F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:46:44 +0000 (UTC)
X-FDA: 84763126728.13.040D012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D935110001A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:46:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BsfZzrgC;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778694403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIr1xcqYq5Tl3HDmm7kwPWSRvEZ/6U01PUBrtWGLIxA=;
	b=8gUiDGsIve+MHdC21s227qtrU/KdrLu0Ooj8FGYhnWAf9Ogpl3qRTs9pq9VqhpB+oRntQ1
	I1uUG3m+hP5iFgKi/jImZkAHXglYSPfQj1WgMbDCH5LO3ZSQ0CV8Gi4OdQFV4HKIL3fHAZ
	IvVC5K2PDEYzMcP2ZSYPjIWAOkyTj94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778694403; a=rsa-sha256;
	cv=none;
	b=IDNK9e0WsQlZmlJRJSyQe4A00rQoAQ5sEn9PktEjKgE8lPm0htvVoAzy2ZQ04jsmFNqLdX
	8y0OJL7n+MijZpOOYcZGCX4S2Clccpa4KVAJ2dHXGs8ZXCyJfl/E874lrlfqVqjy5iu+34
	g4aU0/L9qYFRmOjhY+Wl8FIa+IUiIbk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BsfZzrgC;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32ABF60121;
	Wed, 13 May 2026 17:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37904C19425;
	Wed, 13 May 2026 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778694401;
	bh=EvrM3uz6EOhLIcr/NdISliy5/4+6NtJJVBVMpjRPn7o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BsfZzrgCAKpVLGW+zLYqSFHcPyq87YZ8baXJG3nnULrm3Z+RuAAKdtgbdqYF/xcPp
	 LaIyzOwnzGxY2wcl2jy6+8nQwTZZV7ipeDmZATx+i3waJHlqutAHx5FH+Y8h+ipAOP
	 Cwxqkkec6wE+E4hm4PRn631DaNoGQYC3o/VkP+gc=
Date: Wed, 13 May 2026 10:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, Ackerley Tng <ackerleytng@google.com>, Frank
 van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/69] mm: Generalize HVO for HugeTLB and device DAX
Message-Id: <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D935110001A
X-Stat-Signature: eqqs8xh99sg4yduhjfysd1ej3zz9orse
X-Rspam-User: 
X-HE-Tag: 1778694402-240425
X-HE-Meta: U2FsdGVkX18SD6+/Vfstf+GN8Mz9xSgPuqFt4c/7GWEhjo8kGss8W0hFZO5zKAuPbL0/NKS2LQcZEK4hGcXzk/i78Hdr+MY8+YtRhe4XQ/NhP0ThiX+kbID+Lg4aRzF2+Jpd4fWB477ZXM8lP8xNb+x6m+0bzSy06FgaZ1OJyB5OXTmhcXjy47OfGwixVd2InAv45G16yLfiN0ehxCe90yt083BtLEADa3okga7IiYVFgvs43LRK1CCQEfmgXPaMXGSQi88Ln13locVc3gAdrT4bsFnKLjNqLKKKKqxWoDKzdCkWqhf3FKVX+pg00xbZTGypZNrD2ke09LQsSdNbx2UtKYVqSl5g3nqtgBiE+Hg3/8DujLqgeynkwrpT8PXmeOAUdLxtnHvBtwF20D2f3EdQWOPKgSZyNCSiF+CKFSP8EIo6ggxf1jhTLKTrJAvcKsrFWkAePEJh3yxLVMwPeAcAwy2MJ1wM6wnD+K2oJN7fOAL+BhoQvZ/9fLkE4mUSyeHD8w24MBcplPb0nKq/hw3T8S2ZVEl7BctZMrxAEw6Y0Qj2MbQtZOlvHVSsvngYHwe1Bh5dAPdE6MJkOf+E/Yp2XfTPiUO54Yj6Ct2uHw5sX/BxwMUC7n9mLy5DmQX3kfmdCF5l7XnrgepGqFrsjqGEzz9CNWzJKr9/Tho0Dpxe6QI7omeBD6CXdi0UoqElVkyTKze37P41ED3p7NTMS4luSTMfzUYuNtV2h4Dm8TPxd+EnsmfvnOYzUd40NpO7Oqt/pUnKxI5NVze2bf+NvIYd+WZ1Wl5qm8I2YQgWFY8bWCP1iH99BSdLEXgz5t8uuAFO9Igf65BcpbNt/kkHTgWgPpEUp1TD/QF/1y66cAp/Y+9NzcaiNOfcPILtCkMcpNi9XgHG88cZ6DlZjhlJ3bkJQq5RibDPfOH8eDs6cKPVSs6sQUhnApzyFzL8SB2qzJDava4LxoAY1V0d1ps
 xNieXFu8
 qLneLZUQxOtsLmFJUcmk8eqN5fqJM7V2kbG1joMmwnhDHBy6lKfUMrU6aZnEArze8ijGENQ2luB2+P03wAf0MpDPffWZyq/JNYSFdYRZbGs87tWst8jwv9zla0Kx08PKFVbyNBL5dXUOZTUaa8HcipNgtuZQqjvtUWrZQJnHmSRgBnYrSH/r2ArDjF2xkeOcxDT7U9/OFXn41w5Y3iwITG4ICJPRJplwzGfMytA9lKmXEn78Tqm06RI7TEMwSM0ncBry08xb8hkNhygj4XLputoY29w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 21:04:28 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> In this series, HVO is redefined as Hugepage Vmemmap Optimization: a
> general vmemmap optimization model for large hugepage-backed mappings,
> rather than a HugeTLB-only implementation detail.
> 
> The existing code grew around the original HugeTLB-specific HVO path,
> while device DAX developed similar but separate vmemmap optimization
> handling. As a result, the current implementation carries duplicated
> logic, boot-time special cases, and subsystem-specific interfaces around
> what is fundamentally the same sparse-vmemmap optimization.
> 
> This series generalizes that optimization into a common framework used
> by both HugeTLB and device DAX.
> 
> The first few patches include some minor bug fixes found during AI-aided
> review of the current code. These fixes are not the main goal of the
> series, but the later refactoring and unification work depends on them,
> so they are included here as preparatory changes.
> 
> The series then reworks the relevant early boot and sparse
> initialization paths, introduces a generic section-based sparse-vmemmap
> optimization infrastructure, switches HugeTLB and device DAX over to the
> shared implementation, and removes the old special-case code.
>
> ...
>
>  46 files changed, 743 insertions(+), 1812 deletions(-)

Gulp.

I think the first 15ish patches (little fixes and cleanups and
refactorings) are ready to go in immediately?

Perhaps you could prepare such things as a separate series.  Or tell me
which ones are suitable and I'll fudge up a [0/N]?


