Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAF6108E1E5
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354286B046E; Thu, 19 Mar 2026 06:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B0A6B0470; Thu, 19 Mar 2026 06:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267AA6B0471; Thu, 19 Mar 2026 06:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16C0C6B046E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:58:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B06891A048A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:58:51 +0000 (UTC)
X-FDA: 84562514862.27.D632FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F35DF140009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:58:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F7Del1p6;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773917930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0BEyykFePmHDznb7ux39CO7rxoVrMqqUlVSh2H4MEo=;
	b=JFJ7IpAy/La5uaDd6ZkKZ//3vf6hDSgw/qJPt+E5etgbCurqCkqzpjfoPdI63SBlmCvlkP
	EKyO0pMWSUpNgKBPfB3KNjqyFKBjOhnr4A1YlOFDydoNzdcrEVJHYe3752O2sGnCvdZiPJ
	nSdQH/ZF+/lpgrAl4Tmzm0TT5w0zMEg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F7Del1p6;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773917930; a=rsa-sha256;
	cv=none;
	b=nCU0R1FA8S1cafHpjMP/20CnASd19XQdfnNnnHFss1cIQi/gTJMRF9fYMeDE/zeqT9tizp
	eE3dktVn0BQkCulhB/MVsBShh1bAIZyIqS8FN/y8du0CRuJteI+Z9qcKnjyB1mXtV2Oy5u
	VuFj/AfRKnipu4x+zjXBMWAkvvUPQ1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0D8D406A9;
	Thu, 19 Mar 2026 10:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744B3C2BC87;
	Thu, 19 Mar 2026 10:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773917928;
	bh=G4IGN215QkvAF0BgeVUwJVOFGBt23hN0qlN9K0glx6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F7Del1p6fgL9fUUqhXIf8URe5vpBMbMGeLFuK5fZU90T8Z0BXqCdaDrf8+W8Cpf3+
	 QywkuBqQb2kgaBrPix70vYwM1A4SP0AtjqQjcahw0dphnL9gsKq2kRjaKIOyzvOPC7
	 cMefUiNo9085lQW0nwVGa5WdUzRXa8S9pU/3GBqL0NOsgEflAWxxNYr7ppEg3Hf+mv
	 F2O/lIMOcwp5ssF9+Dn1SQIq6GNO72/+kvqYouUJ+xyBhH3TgEbgONQgF6+j6Fc4R4
	 CrUZUR7WUA0MBd2w0/UPKcY06Br6ZCuupjP5wG7lc4yXfEyLBkwrgDjHzUOi0XeoPl
	 kkz04/QFvVL3A==
Date: Thu, 19 Mar 2026 10:58:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/huge_memory: handle buggy PMD entry in
 zap_huge_pmd()
Message-ID: <e875959d-231d-402d-bf5c-e7e6cbfd2b36@lucifer.local>
References: <cover.1773865827.git.ljs@kernel.org>
 <8ffa393ad86b9b0ecd9b001ca88706ce2f9fe003.1773865827.git.ljs@kernel.org>
 <b4ad83ac-abc5-4389-bc74-70468bb77572@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4ad83ac-abc5-4389-bc74-70468bb77572@linux.alibaba.com>
X-Rspamd-Queue-Id: F35DF140009
X-Stat-Signature: 9r3xs4zqk5wmw1dfe9u4rb3xsp3h9bs6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773917929-628794
X-HE-Meta: U2FsdGVkX1+WVL0EE74KMcX7TfwWdYiCwnFfUqbFmwtMtz3tSBwC+EifW33MgZBVWQF++yO4hp8/LjR0BTLDPLxyJFRnmLOPZKYHvjIXEjCliT52rYABKv8Jj3HTDf5dBpFjmrgwMnCJCAPDuYLot6NgSYduDY/+iC1HY1I1IMbb90SeDpv3Lb4zyFtg72OaFLW+0JNyXtW7svIJpv1Czs1IArWk+ego3MTVGrVlw+9OG2gdR7s0QQe2msHiqPzLCLMKVGyyS8yU/HDk7HpXs0tf+vr6ztt2u4sMQcWOB5iIzp1zUqjfWecqJkCk98IFuyvntycZtYXElP+3SKRqkb3vpnxAlrMNDYif0lCGAYx2tlTPldKJIhHK1c9Inu+TU2CmTKlUuiQMqPE3daK3UNV3+OZ2DpI7MvmkDl17z7Lqj73+h3zEY1vMOFLWLmz1qhSzmYWpuvYtY/+ps7mpZRMOoifHrggUmkau2AgfdnEsC4YOBZxzrYHcmL0sXhRnXHzf46W5xSGhaSv+8tJuwYEQhY6sqtpObSOUMO9dFU5p2hl33h2/j5ai/SFBBvsXf0cu82SN1bqQiSnCuR04wk5P/QJZotD7l4K2Jfyr3qyWImZN9aH9mgqxSezR4pppehqcssF/HkOwzhim6StXgS09PlMJkinTxgkhf5XuMsP+8r4nqc+FaRE3wtwS4S8kb+Uu6tMXh/V3t9ZMtxZDI69NXfl97b2c4+adwm2Qwfiphy3WP01+V61Z8vb1fuhMhVvQRdaB0qeauSsoCDj3AYjgWyb7bQV9R9lsooHoLWYzxGUvifZW5lYKXBlxuUxGWzDa4bNaFV8qjO6k5jf6aV2zCXqXIUOTp++LYp6bHbU/k7AlQJZr25HLRp0MMr1Jydj1OzLi09CjNg026hEOtNCDpISg5wTAKbcF+pzC1KM5eY0YnZFeCx3OQOxRlG33nPWzZz+Jn9ksQPdaf2d
 0juiV8dX
 FWfTitXgFPLkzy8/SwnldJBAlmfzBQtFpVfbn5RtKliCJMXzF7S7XDdMi87pPsS4AjKsCiNR54H28xq37QMAeJ0M0l0/NH1H6gLRnD9E4EOE6ORo3u7tWjUhcTi2xnzj7dJTW3vKBJ7G13sW0Jh+aM0e4HuSYk9ewHsXZm9BM+dK2cl9JtdKpyVCUi3Cl6D2ctMdmfTKHgpwDr48OcKlSkajGz2XziNa+FQ9y2XD8Bne6F9EhS4lzb4Qc6p4q0fGwG2XiOvKur7qoLM2b8q0TLUKHVTvdoUR4WmV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 03:00:17PM +0800, Baolin Wang wrote:
>
>
> On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> > A recent bug I analysed [0] managed to, through a bug in the userfaultfd
> > implementation, reach an invalid point in the zap_huge_pmd() code where the
> > PMD was none of:
> >
> > - A non-DAX, PFN or mixed map.
> > - The huge zero folio
> > - A present PMD entry
> > - A softleaf entry
> >
> > The code at this point calls folio_test_anon() on a known-NULL
> > folio. Having logic like this explicitly NULL dereference in the code is
> > hard to understand, and makes debugging potentially more difficult.
> >
> > Add an else branch to handle this case and WARN() and exit indicating
> > failure.
> >
> > [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >   mm/huge_memory.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index bba1ba1f6b67..8e6b7ba11448 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2478,6 +2478,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   		if (!thp_migration_supported())
> >   			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> > +	} else {
> > +		WARN_ON_ONCE(true);
> > +		spin_unlock(ptl);
>
> The warning looks reasonable to me, but ...
>
> > +		return false;
>
> IIUC, if we return false here, the caller zap_pmd_range() will fall back to
> call zap_pte_range(). Since pmd_trans_huge(pmd) returns true,
> zap_pte_range() will simply return 'addr', causing an infinite loop in
> zap_pmd_range(), right?

You mean because:

	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
	if (!pte)
		return addr;

In any case it looks like it degrades a false to potentially carrying on forever:

		addr = zap_pte_range(tlb, vma, pmd, addr, next, details);
		if (addr != next)
			pmd--;

So yeah, this should be a true, annoyingly.

Will fix thanks!

Cheers, Lorenzo

