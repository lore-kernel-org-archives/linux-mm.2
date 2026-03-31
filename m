Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5ED1061B37
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E056B008C; Tue, 31 Mar 2026 07:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F586B0095; Tue, 31 Mar 2026 07:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD706B0096; Tue, 31 Mar 2026 07:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2CD6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:42:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1861F559C0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:42:16 +0000 (UTC)
X-FDA: 84606169872.11.2936323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A4ADA0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:42:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eklxj6nk;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774957334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sV4bKEX3SHqLd+MsbDz9nAG/v9xodOWpOT03SIGw3yk=;
	b=ZV49+DUgkpWsZLuFFs2syDrWDnpg0BwODCds5NOIKF0prIRAyrb2alwfcPR7D8PxyQWoqn
	BG0IlQ74/F+LCqYGb7mdYSO3nr8+uKo7LyrjecqAFSHigr/1ZqNscKfNUdnkMApPaEmVon
	rrC30Z77tPEgS4cPdkYH7tpvTGmBrWQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eklxj6nk;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774957334; a=rsa-sha256;
	cv=none;
	b=CNRiQU1kOUEAkaenJ6LFCUDIEUNbjBjT938oGcVvFgT5BaQ5L7N9/hbDCMAfNVfw+tYJLw
	g1Tc4tzpE1K69D3veu+BiguZTjE2FzopriBy0Jzy/NkTvX4fV/U5rKRoBpWMBuw7xO+0K2
	VItk/kBEzEVopdG32upJr03plWbDFiY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD43D43E9C;
	Tue, 31 Mar 2026 11:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A17AC19423;
	Tue, 31 Mar 2026 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774957332;
	bh=v9/AUUMGVf9+nhrOWCMNuXE2J/EJf4Yx/A5I91wqayM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eklxj6nkgag9phGSwi3AtluNOuSXDrudDeC/1PoarzkDyR4p3o0WsR5+F14ZRDl5g
	 K2Nl5yCy0RGOJ0DRUiYL4OX7lS9rHaVpZcs/Y14YToXTDAfwhtXM5q/OBBwVM6+9rC
	 a5PY+jeY6+oE9/UgIx8ASEbSIyVGTC4HR0AcfqfaLCYhekdoktZLfYZ2+11xgMDX/l
	 Wejb1KLzSWw22xCDrro+pnvMhSvIuDD7yHMaAR6HJWWaIHeb/lR56OmzTWLRk1p3mj
	 zt/MN2oV2Jzvs8jCoFDoR2DNo66mXetay7g3pMu7BgyOJjl9SFicy9OxWrV0FhxgiZ
	 d+DZbWhjK1q1A==
Date: Tue, 31 Mar 2026 14:42:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 07/15] userfaultfd: introduce vm_uffd_ops
Message-ID: <acuzCX1GHZRLSu_x@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-8-rppt@kernel.org>
 <acqrtd7E6UxrX6Ji@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acqrtd7E6UxrX6Ji@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A4ADA0002
X-Stat-Signature: gwc7aqp7xn3bm7opcefrorgd358sz5nr
X-Rspam-User: 
X-HE-Tag: 1774957334-128722
X-HE-Meta: U2FsdGVkX1/KqRWwmKe3q4vv0kRH6MaVLfkw4QSRAMTF+MHoB4yDmq27fV/BhyobpdlUBEAUVycgc2va+pYyTb9PF3V4yCgm2TdQEd3nIPnRlk81rSLWeROyne4WBl4uPZzNvYdUdf0uEVzfuN0Ha1WY8TjiQbWcfvANxUZsq8Yppz480bLdcE9nb8Ur4Nvou64CpiJTzx/+2//953I1kDltDHbUf6gzpF8/bns3CuguUXXGNwyDqyhOAi8tplHJvI5T8DUYbH5rh6SFqCeUDHW/kPGUPJQukNMOwpXv2OmumnHJ8/oyMtFz/FlCQjRgS8ufRvviZRz4O+WR17BEu0ifimsTGhnwX1lkv/Uu4vbBuNhV5rRJ5azid8Vn9UzBEaeA5OJbYLVa19Z16PAyxuZHd7rWl2dUX4RLKe02bdQdC8g8GIBJZf4jOPdK1YFBBFJzX5CjRyGq3EVWGMoFyZ6yX9K+nfVjdI/FbxPENVGgqVa6Vf61SysrGR2RhjzQlTPhJh/e10SNJ79FsELcYsb/pHau8FwQ8inMwkXeVc8FbAIFMTywViwAf3jsZZpzaIfNSyjc1TAB+qRJMlW634Z1bB/sUz6j/bYymRI7vA6i1czWP4RaAcaKYxBegvHiM+YXFOCuaVV8IHwXs8G5MYPNkc9/DuxKppyhSRJ0WE2Et7O56b3hJP6l6I78yD3IkQK/D+NpMPTNH86s91HGgLhyWVo4p4ZYPj3TIPlXl7C3Y7rB9qHfeTgP+wkcvIRON4HL6VGPNKTCQBDf+9fGcnuy2Fylr7l7UyBE3X74e8JMpAf4ITb9bLujxi6UKtGhKD8wtYwovzykoUprC1Q8KTm/LBecWRb/m+AWCCQQ31TPQKWZXMcHWhIWp4KSsZ8Uzg91nk5LuIZdsYU8V+77R0QLy4F60XcvPQrpsGDUHu0E2YQXOhfyQ8uCZI2mJNpA1z96j6OS2qyb+lO2waM
 XYZRB/Gy
 YaSf4JXyvcjCYVABGurdCeO8UG93kxMDzZEzFraDKQasinsHSJI2ftH5y3K8SbFax4dpejrGWe3jheWVsSkVi9+wVG3c86bw4CgT/nsLtQgUN3LQJEWALm6b4Le8hoxfeUSYjvf780Z6AuBOskHqZaa8/QOKIDG+kj1x1TkRttk+N+sB+mHYQW2LaNvKSsNJgeJDuuxsh97cg4Xdev6MJkm4TykyThH+2QXhYzPmF3EAw1q8CdS3erqXN438II5mre7/xJb8pQH9zAPEQ+gU9mrYxm3uqxtziF6rRuCVfpbNDf0sfZ/1dQpyrHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 05:58:29PM +0100, Matthew Wilcox wrote:
> On Mon, Mar 30, 2026 at 01:11:08PM +0300, Mike Rapoport wrote:
> > First, there is no fundamental reason to limit userfaultfd support only to
> > the core memory types and userfaults can be handled similarly to regular
> > page faults provided a VMA owner implements appropriate callbacks.
> > 
> > Second, historically various code paths were conditioned on
> > vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> > these conditions can be expressed as operations implemented by a
> > particular memory type.
> > 
> > Introduce vm_uffd_ops extension to vm_operations_struct that will delegate
> > memory type specific operations to a VMA owner.
> 
> But the VMA owner already gets control of the page fault.  We don't need
> the vm_uffd_ops to be accessible from the vm_operations_struct.  The
> page faullt handler can pass a vm_uffd_ops into the uffd functions that
> it calls.

Not sure I follow you here. The ops are not required by the page fault
handler, they are needed for uffd ioctl handling, e.g

	userfaultfd_ioctl(UFFDIO_COPY) ->
		mfill_atomic_copy() ->
			vma = find_vma();
			/* do VMA specific stuff */

-- 
Sincerely yours,
Mike.

