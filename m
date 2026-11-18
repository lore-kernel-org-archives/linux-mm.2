Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8352606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vamNkQ+K
Received: by kanga.kvack.org (Postfix)
	id 8AE886B05B1; Tue, 17 Nov 2026 22:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885B46B05B2; Tue, 17 Nov 2026 22:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C9F6B05B3; Tue, 17 Nov 2026 22:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 454A06B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:10:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F84C40647
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:10:50 +0000 (UTC)
X-FDA: 85446762660.21.A542306
Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6E22A1C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:10:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vamNkQ+K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794971448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfA5i4d2gCwIuNfl/V1REoqxWlwBpLBqgHxGC6bP5bg=;
	b=DwgwGgnPHRLcswtRmnzudjU9jwRcrn7TA2arqSwbMMQPdh8GYgi6EUeKjdh1CBXAN1KLlS
	u3wcCweKtZ7VQ4fQ2T4naGJVjGMEOcqBU0eBDsENlsfROCPMc5EyiXJBCuL9PDBiE+M1Jo
	gpAMOxhzqckGTAkeiZqunw4u1RS52Js=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vamNkQ+K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794971449;
	b=lyHyevVzonj+1Vmsbq9ZM5RN9WbtFtwmCJBM7qCDz+YiNMeAJ+d0+4746oigjHfdcqCwA+
	WsWpbjQBera0KmVnYsj7bi5rh0mryDjupvZECUnY3QMLWLdcvrS8xVaRd5tso5AGEZaGIi
	mg4ygE44LiGrzaCGMAUdfek9B0R6y5A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eEhQXNIJ/LtAn0ef1h8RiySWKjEFVX1iaNKIEFjrPfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794971445; v=1; x=1795576245;
 b=vamNkQ+KDQxz1fvgSr5uSrJNBhqZkNgjq0BHyNAyJFjJL6SgEcnAN/PeohSqcL/kh7m4DZtd
 O9aImLfuDPm5MS5bMdOS6A1nZWNIbHSiJtt+HLIAl0B6a1mlkltw+sy6YauXIPhC6L268b4MgHA
 dIS3fG44WPxGIL190MJglMu0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3059d6b605696205;
	Wed, 18 Nov 2026 03:10:45 +0000
X-Mizu-Trace-ID: 3059d6b605696205
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	xu.xin@linux.dev
Subject: Re: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Wed, 18 Nov 2026 11:10:38 +0800
Message-Id: <20261118031038.75525-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e971c3f2-e8cf-4eb0-ae25-e7e4d9ea02ee@kernel.org>
References: <e971c3f2-e8cf-4eb0-ae25-e7e4d9ea02ee@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 94sq9qfbo331hrhqgfprpkgwk38ahb87
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E22A1C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794971448-233645
X-HE-Meta: U2FsdGVkX1/K3OAfNoQg3xo+1kHz5mqGEsrgi+VonERfOIb3pSRzgXbSwiy9sdyn9Tj3xgzePYeHNb9bjwbNUGYNbeTzLkcMplOwgjvlm8Kz8M2Z/NT4mzrNt6wwy0TGmzLnZQtMpB7THHJSfA2Bd/kjL277tdhbV+79SJmI2zFc1AnRpY7QBqSrZG1tYbGzGRO27JLTyo1z2/9sM/yEClqa+fX8gVel3pb8yCfoTJ2C5d1QYWfNGKKxbYiOciW18cW6KI6GOR2nzdmYGZUqlhqlbU+GC8aM/1ZAcs2Ihd6+M/JVXW8YvY7tYfhdj7KGXxjvzTMG4LE3msGNs/1KfGQWcGaoHPV7ahuxe5WFHddTuiLgbbknn7Z3k/ZOWdEujpBjPYBmC4FHP8r/qFTePXteh7HUmVcqR2RseQMiCPD53AIDsiJNRAVOp/s1CSfQD3VcXE69+JHBxBqo12vhZmGCK9hZKYpJZKzH28CQM9QMc7WB34/7LfEKpdUq7GdiGoDR1rC4OtSRvFrvKbwkALKdDcjU1R97wps4haOeSjYTI9KiptPb2nmuCTLit3dIqzmN/ZztcmlMearmgDi/KY3OJ64bw8jKa5B3A0zxVeEFR8NCMWgewGN9P3RpDN9Fq8koZtxLe/ZuvnKDAzhgpxwAVWROJpWVSX0b2gxW9HZutqK8G8Uiq6gP0eKClGHuRF5NZ0I8QPXuBgHoNH3yGn+cQVWVqN2vDZlEihhZ1tW/jDDxyLmsJhrpEfqsrYptDTpBOY2tIvfLuXCcLZohMulBOEnyZ9TFASAXfOIWvPbh/wA8uuiDJpL9T8QygWH1A1e5aGoHL2mwLUMt93m8LB6y+mCWJmV8bgHwWemuUHImpO/XBq2UupX2UxWIdFdfMKNXbyAmdfLjBzi/2+k0MzfXU1Cz5oo0l44SQEA+uvuVnJP6AnzwgoG37kCq/rbTHo4/c34YjbWCAImdmYc
 edxdXXwS
 XsCKyfsgRb+7tbfPTZEhetC8Wa7fA8yMPohYcwsgpZLOe3qKqmqMb9TbbpVhefttbC8Zqc+e5vPUnT2UJB8NMGE7zX4AtO+pUxvsgmvhAF5cO1gM3hFwzPPFweMX+JVzqg9R6qswYfPOI0HFl7S845gGXLFOlQkravtJHKkE/UMEuAxEAoz7JR5KbMJHkgiwYImoDXQ+V5M6TAhGcsWdHTMh2yILkiPReXMDp2m4mvBuy+C5tBORZ/mt8m0OUWCommRPVrcyy0zMEIZNT/WW/eYokm52v4EztTFnuMcEJ+ikBGkUfFtHlg3KLZyJ5/eSwfCcy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On 11/17/26 09:18, xu.xin@linux.dev wrote:
> > From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> 
> Hi,
> 
> thanks for the report.

Hi David,

Thanks for the feedback!

> 
> > 
> > As documented in Documentation/admin-guide/mm/ksm.rst, ksm_zero_pages
> > accounts only for zero pages actually placed by KSM.  However, the
> > current implementation wrongly accounts for forked zero-page PTEs as
> > KSM's contribution, inflating both the child's per-mm counter and the
> > global ksm_zero_pages counter.
> 
> But ... they were placed by KSM?
> 
> Just like any other KSM folios deduplicated before fork and then shared with the
> child?

I see your point, but in practice, people evaluating use_zero_pages=1 often
look at ksm_zero_pages to gauge how much memory KSM actually saved. Since
forked pages already share the same physical frame via COW even without KSM,
counting them across many forked children can give a somewhat misleading
impression of KSM's actual savings.

Also, ksm_merging_pages right next to it is already reset to 0 on fork (even
when regular KSM folios are shared with the child), so resetting ksm_zero_pages
keeps the two counters consistent. 

> 
> So won't there be an inconsistency when MADV_UNMERGEABLE?
> 

As for MADV_UNMERGEABLE, leaving the child's mapping as a normal read-only shared
zero page is safe and avoids extra allocations. Plus it naturally avoids the
skipped-VMA (MADV_DONTFORK) accounting bug you spotted, and does so
without extra per-PTE overhead.

What do you think?

> > 
> > Originally, commit e2942062e01d ("ksm: count all zero pages placed by
> > KSM") marked KSM-placed zero-page PTEs with the dirty bit for unmap
> > accounting, but forgot to clear this marker during fork().  Later, to
> > prevent ksm_might_unmap_zero_page() from underflowing the counters on
> > child exit[1], commit 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter
> > handling in mm_struct during fork") kept the child's inherited per-mm
> > counter and added it to the global counter.
> > 
> > Instead of inflating the counters, fix the root cause by resetting the
> > child's mm->ksm_zero_pages to 0 in ksm_fork() and clearing the dirty
> > bit marker via pte_mkclean() when copying a KSM zero PTE in
> > __copy_present_ptes().  With the marker cleared,
> > ksm_might_unmap_zero_page() will not decrement the counters on child
> > exit, MADV_UNMERGEABLE in the child will not unnecessarily unshare
> > inherited zero pages, and the global counter remains untouched.
> > 
> > [1] https://lore.kernel.org/all/53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com/
> > 
> > Fixes: 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter handling in mm_struct during fork")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> > ---
> >  include/linux/ksm.h | 8 +++++---
> >  mm/memory.c         | 8 ++++++++
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> > index 93793ca6bcc4..3c6db19d825e 100644
> > --- a/include/linux/ksm.h
> > +++ b/include/linux/ksm.h
> > @@ -56,11 +56,13 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
> >  {
> >  	/* Adding mm to ksm is best effort on fork. */
> >  	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
> > -		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
> > -
> > +		/*
> > +		 * Child's inherited zero-page PTEs are unmarked on copy and
> > +		 * were not placed by KSM in the child, so reset its counter.
> > +		 */
> >  		mm->ksm_merging_pages = 0;
> >  		mm->ksm_rmap_items = 0;
> > -		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
> 
> So I think there is definitely a BUG int he existing code when we skip copying
> some VMAs during fork. We should have instead adjusted the counter as we
> duplicate them into the child process.

