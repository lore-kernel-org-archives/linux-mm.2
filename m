Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE47606A332
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKagZpBn
Received: by kanga.kvack.org (Postfix)
	id BE2AF6B05B7; Thu, 26 Nov 2026 04:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9B66B05B8; Thu, 26 Nov 2026 04:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF6A6B05BF; Thu, 26 Nov 2026 04:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 891A66B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:58:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 722701A039F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:58:25 +0000 (UTC)
X-FDA: 85476820170.19.CF64A96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C8E2B40009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:58:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKagZpBn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795687103;
	b=xr7bsDOJ8xrd534s5Nu6aAI2vXC81ixI74mUOObkPkC4Ptj5HQK2XCP85+SgVgg7wFJho3
	d31jJMo1rquo8n+xT1dvBMWkHfNkU2aoOvapPayFMPNJxXU0Q5jjuBYBTlORSLcaRimN+b
	Zh2sf88UsF8Z3HYpPvaec1ffwmmL3pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795687103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMPzilywSB0BY9L2Teq2vIgsxnr+wRA47wTymsp256M=;
	b=o+KCGHekQ1BkrXYvXBH1OGlvBvaFHJmWpwOFYUMcL2t3CSb146eigzdbXPff3JEemIwSRv
	crQEjesgn+Ym9GjWJOa1iZ/j7RCiKMxmb/76GZvLU+zOfo0fDGdT4Hb2LVfZ8FAD1DAnIp
	Iy9Tuub/7Y7OM5XRb9EortLNDhjBRLY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKagZpBn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5151D61B63;
	Thu, 26 Nov 2026 09:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DFF1F000C6;
	Thu, 26 Nov 2026 09:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795687102;
	bh=CMPzilywSB0BY9L2Teq2vIgsxnr+wRA47wTymsp256M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AKagZpBn09AMbaWKLVVyKAJAUx9rdzxn5/4X2BaEMhVscDXISnhAXMP+67fB0+NLE
	 +L1iyYQ+PzRxiOnq7Z7lckWKWYA0MJ4zn0Ndo31NuPvyNz/U9QzPl/RtMc9nRy2IVu
	 /u8KqcUDY2UH3cJqKTjjnxzun6NlSMQetsy0RPceCAw0QLpfvat8hr4q/jK6YG/Fu2
	 Vt6L+bsyDNM4fGCvaYAckuNqXVjtavc5m9alq5R79ljduTjslbQGsxMWtVAxfEqOis
	 GlH5d/P2EV4eiLuLnTHtvUXPD9PQWhUsmk1VVUDOfZaSvct0VtCmL7/0NqlT7s84Sn
	 n2ZwN/mGR+2Mg==
Date: Thu, 26 Nov 2026 10:58:06 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jinmeng Zhou <jinmengzhou22@gmail.com>,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dave Airlie <airlied@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Dave McCracken <dave.mccracken@oracle.com>,
	Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kenneth W Chen <kenneth.w.chen@intel.com>,
	Hugh Dickins <hugh@veritas.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>, Joern Engel <joern@logfs.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Sasha Levin <sasha.levin@oracle.com>,
	Guillaume Morin <guillaume@morinfr.org>,
	Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/21] mm/hugetlb: always mark new page cache folios
 migratable
Message-ID: <awgCro3ymVNkIykq@localhost.localdomain>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-3-db27fd2f71a8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-hugetlb_fixes_2-v1-3-db27fd2f71a8@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8E2B40009
X-Stat-Signature: 9pddwpbm33owt4su61ikidbmwd5rhjrd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795687103-391548
X-HE-Meta: U2FsdGVkX19M5uatwnH/wNpChuA9Ez3zWAGSDHtD4DeP8eHQCSb41hUKyPfCgWNcxfefwbqQuu1Vj1r9Hw0YtEUeI3jn4MW6swGe0HV5wdQpilLK9yciejVdEDCiIukXylCHk7zB+F/M8tVEBEcl1rqdXqu3Y9puPjCkrAhUL61ijMeNv+8gsgLP8UMDeSoudOwIO93HgAUczEiWgu3l2fgTNFmHylIOFu6qLeZAMayrnn+FdAAqfHkRrEZ0iHFlQARPZf/jA0aFGlNA+M9iBDTSjRQGjyZ90AgvnUEXzOiAxMpoUyr4CzWdQ80OnnLUgIKalrlc93wnT/l6Uqu1WiCQB7YL1PlD1Brw1DR4YImYWAdNu9R1TrfaESsMdzzAX7jqyApxVsivRMv5F6Egv/J4peTdn0nYb5lq1zak8rvEO/wyw1Q8l+/LA9YzISA9o7UqfPUtePpgaShlznC7f5R4Pw/2pYt/uIAFw4ZPt4eLooMDEKBWPSd5e8Ax86YYrT909dFQxpRkM68FszDm2ABRZQ88oT3v86/JUelMi+QIQEDWD6bABIvylCuHHF9LXhdCu2M2XVH51mgYLvMkYrXbCe0v3HUq9gl21ZJtAN14SLon5VnV/maor35pU1+ynGubF7Ael+Jld15xLC3kGdHjSUUtGSCej5TNAHpUTsssxpS8DeNL5BojcX0lFYRCtCTPPiOoG6SUnez27BN2vvyzaGJEPvHlXXhkjuisicpTT+k+kEjlqTCxvEjPtKO9GOKIx1+xvj5w2cgWaDQgO9m4eQBppkYgUEkhsJJ/zb5bn8z2qLTHX9b+uCP9g/PTQRs4BW0GTZ1Yu6Cw+AvMyOGN2VA7VuPdhLidGOp8sz0sR8oBmopXvtP1G7Fv2Ms3sfAMzy1/ZP1CbFxIYceZ4PQs/i9ItT4f/YAyPUlfT8DFg2ltzekPbhMoUG9OMtrV+Zy38M4hhMJtJKETNjt
 krBsI1XP
 kFeBFYMHFT4iCUH0Il4P6JCyrhXwclvLoLTH8jlrt8qPjOwL0Su8zIDeQGdwzyQ1zb4sMY+bApqMLQA9cjlYAtC/1vj80iZLE4rpYmNXns/csXABpm/1MZdQxtvTPV3UeXvKFAM+HdWCdzIm0ckzL/B/GwzgNtFn6tmWNU9LcBJRgmYScnq7rru/5Ptor9pHjU3gPxD36KkHh64JIPpdK9hr/JP4iLUVhchyfjRzC12HY9PgVKycnIj8SN3nNWevze6Zp7cYgjtFIjBnJXRdh2MWLKiTkYOeXdr6WD+KSErhohuOgQrNjYuCfn1eDu0DCTzZVgwpNAL3JH/66BxYThxBkDid7I9F/4bKHneII2wYXHFpUrKWo30pJ4WQBVMG6YnliAbcNLBzOL3d2FrRqe6LgDq5UlhwSc811rBJBedNE6feK4vlwydmAjDpFVAG8bjXK530AYtCy97q0Ywzh+itxxSxnUH/9Kv64xOniRi1/94b0bNUgyRerLT6gt16+xWBkTTBOimHkNzqXDC3+ziC3jeQMo4p7DhDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:33:01PM +0100, David Hildenbrand (Arm) wrote:
> hugetlb_no_page() and hugetlb_mfill_atomic_pte() only set
> hugetlb_migratable for a new folio once they installed the PTE.
> 
> If they back out after adding the new folio to the page cache, for
> example because the PTE changed or is no longer empty, the folio will
> stay in the page cache without the migratable flag set.
> 
> Later faults will find it as an existing folio and never reset the flag.
> Such a folio can never be isolated for migration, which breaks memory
> offlining, alloc_contig_range(), longterm pinning and memory failure
> handling.
> 
> Worse, if the folio is not longterm pinnable, because it resides in
> ZONE_MOVABLE or CMA, memfd_pin_folios() and the longterm GUP path retry
> forever on -EAGAIN. memfd_pin_folios() cannot even be killed, which will
> be fixed independently.
> 
> Let's fix it by setting hugetlb folios migratable whenever (1) a new
> anon folio gets mapped; or (2) a new folio was added to the page cache,
> like hugetlbfs_fallocate() already does.
> 
> This has low urgency.
> 
> Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

