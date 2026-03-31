Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C73AFF60D8
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F646B008C; Tue, 31 Mar 2026 03:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF236B0095; Tue, 31 Mar 2026 03:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDFC6B0096; Tue, 31 Mar 2026 03:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67D8F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:50:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D55A13C0FB
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:50:57 +0000 (UTC)
X-FDA: 84605586954.30.D98362F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7CE15A000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:50:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=otLloVur;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774943455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/eAR0lsoXbDXd70Lr9orNLGdpQBp5tCLrYPE0/B3RI=;
	b=Cb18Y2BbfXb3+nkKum6O9EU8qtFe+/jN8faFzSlclZ/W0a176H26r6VJvpPTtYV4yr/S16
	jGV0BrapRg+To1lBTEBM4IUx0uLt6oX/Su5XRiL1r/PG+j3sd2wP0UvGInFNmM/HdKw2sh
	guJjX5YlziMqW2H2kkg8wpH5Pcy6BVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774943455; a=rsa-sha256;
	cv=none;
	b=GFop1cdXTrJrtHcH7mLooeMjigmlZ3fRFI8QauIBM7RrO9DaNDjnK6w2lD42G7m4ffjFM7
	j8/0W43ZYvuipc4b6U0O76Hh+Flf9J6vmn5KyWyaEfsczymqGSJrTXmuhdq9jVbXtO5KKc
	9wQ1jNVOUy54WPzvijElTEr6dRSL7+c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=otLloVur;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CECDA600CB;
	Tue, 31 Mar 2026 07:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26696C19423;
	Tue, 31 Mar 2026 07:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774943454;
	bh=QmBrY5BKVbXz9CXTgV6unLVzlvXFNRWXO9R3+/R7gS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=otLloVurIebAAh64mVkWyy1Yx4OPNvjHY6Wavo2/t4scZtIey5FAsclGVAReyXELv
	 acxPd9t/ZfkfPv+8RIRukk+mhkmlBvA+a2FBtpVBpcMXMdKf9jax1Ic5HrqbXCTaup
	 L75gDcEL/qZJCWDPtiE0uv2tcJ6ipRACww0DE+70ADtXMBfVxH1qiK2c2+ILM1nif2
	 c6tAhrmqudLZPc4H8kWeC1d15Fd6KPnMbP8ucuuzdJcntZ/ZyBTViRoOtw++xYFqIP
	 mZ8dgFOzD3fLbeFA3spBT4TBU6/1zqW4GUaEm90ycw/3i2nT+5rj39NOfszj0isSvg
	 0qPx21ePK4h+w==
Date: Tue, 31 Mar 2026 16:50:52 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
Subject: Re: [PATCH v3 03/15] userfaultfd: introduce mfill_establish_pmd()
 helper
Message-ID: <act83N6QP8kgcrZn@hyeyoo>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-4-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330101116.1117699-4-rppt@kernel.org>
X-Rspamd-Queue-Id: 7CE15A000F
X-Stat-Signature: wqpdrpz3eysnq35r7ofbuheax8c1hy3p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774943455-452075
X-HE-Meta: U2FsdGVkX1/vfQ20tw1jeqkdT/Cu0s0Ig5aye7VoOTslrBmsP7AErPAV+MWJFlOWEAn5CI+l289CsJ5OIcV4fzQn3eEn90fFjQ+GBoDyNKrOrvq7VwtaTbJ8cKrCo+9YKqpSfZIVioqxqkMYk9+wP04P433T3sCQVRCQQd8jesoP/YbVuCOljsnBw8f9N+2OM3VjFU1KfqCtoVQdJZsnVcmS7FqIeLx76fUzpu5b4X7lCPhwD5EzQBbUi7O0OYwL9NhfazOMUBP9yZqfJXY3RKOaqGH/oCGKRu76LhL001bzpDBkM3iHtTArWOLUNsBcsxd/M6O28l9CKndrCmBc7znhDn1QZvIYC79VwyNp218YCFqNALF7xThhP4pAKpMk0rhmga11+Gdv5ZQe55fsxv8LaGjmGlINVwxJpxWnCPDSrFH21D+ILfHuS65riVq+FI8IEp1CYVEsOqGT+vK5FG0V+bnaasCCcY86qABnKjx9noatuSObtbUA0Gzj5lbOVXk3CiOU9AOBn6+FdxLWsLzLHuMfqYXweKAXU1oiaOZG3uALCPszoAgK/IAR+/T2ZwKXAWPTBn8LQPwoSvQ34BZ0z0g1vW9Ra/tsLZ87sd7taOTqH2MA47fM2Mc6aO3tFqy9fi9G3fdUDUtxUw58WtwU2R7SK+nvn3WJ/Jv7alsB7NQhZFLadkczhxyoLReJAqH535QzI4R7464dK8JRi32kwFwXk+91TRAzRJQi+BDjvFInvzxLYdiKlNKzoD6orjNkj+IfyURyHhKHmEfwc9ihQSarGBZBGlGFsg1VTRsa++y1hraMLPHNV10pvWBEOYgWbPmk6SehJdXxP1Ve+s/b/qbcPtmz4LUNcPoyG2lVJ9Xn/LZF3pX9Zagkz3/n5UmOsj3Jd/qT4vxt2HpJ10xd5ZzBaeeQ9o+iQPBjf4sogvcH+bg01TfGHatEFkRGSf+mmVYLHeZYQ1MLlQy
 FA5GAaDU
 5udIWj6bpV3uOMrTeUdaubKniHydhIxo2Uxn8+ereVQKrNAVW4ZuRYtTap7bb4DQNAs6GOSotNp6Ofs/pKV3SA2Ty97drbvSzLazj2lZR3HqOtFBTYm90tqD8dzkKCVc26AVoB5xVjHiKv6VKxHvKzzSt4Zapo75CI0YmHwIrG5L6Q3DSxGNJcfv7QizKEfKdU5Ug9v52rVrRMiPtBJcLajJi3v2QC6RUCiajPTSnrMN0LHnSdF0bvcbmEea8vekORhn9Tw98Z2kuvnwBOLOWxBwCYQ4CWkPZG0aM2u/frSVmy2ng5nWLc221DM9dXg9S2Tj9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 01:11:04PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> There is a lengthy code chunk in mfill_atomic() that establishes the PMD
> for UFFDIO operations.  This code may be called twice: first time when the
> copy is performed with VMA/mm locks held and the other time after the copy
> is retried with locks dropped.
> 
> Move the code that establishes a PMD into a helper function so it can be
> reused later during refactoring of mfill_atomic_pte_copy().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Looks good to me,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

>  mm/userfaultfd.c | 102 ++++++++++++++++++++++++-----------------------
>  1 file changed, 52 insertions(+), 50 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index fa9622ec7279..291e5cfed431 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> +static int mfill_establish_pmd(struct mfill_state *state)
> +{
> +	struct mm_struct *dst_mm = state->ctx->mm;
> +	pmd_t *dst_pmd, dst_pmdval;
> +
> +	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
> +	if (unlikely(!dst_pmd))
> +		return -ENOMEM;
> +
> +	dst_pmdval = pmdp_get_lockless(dst_pmd);
> +	if (unlikely(pmd_none(dst_pmdval)) &&
> +	    unlikely(__pte_alloc(dst_mm, dst_pmd)))
> +		return -ENOMEM;
> +
> +	dst_pmdval = pmdp_get_lockless(dst_pmd);
> +	/*
> +	 * If the dst_pmd is THP don't override it and just be strict.
> +	 * (This includes the case where the PMD used to be THP and
> +	 * changed back to none after __pte_alloc().)
> +	 */
> +	if (unlikely(!pmd_present(dst_pmdval) || pmd_leaf(dst_pmdval)))

Just noting:						 ^ this was
						 pmd_trans_huge() but
						 now it is pmd_leaf().

but since the present bit is separately checked and hugetlb vma is handled
in a different path I don't expect functional change.

> +		return -EEXIST;
> +	if (unlikely(pmd_bad(dst_pmdval)))
> +		return -EFAULT;
> +
> +	state->pmd = dst_pmd;
> +	return 0;
> +}

-- 
Cheers,
Harry / Hyeonggon

