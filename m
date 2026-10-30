Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745D5606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H92dZjxo
Received: by kanga.kvack.org (Postfix)
	id 590826B05B1; Fri, 30 Oct 2026 19:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518D26B05B2; Fri, 30 Oct 2026 19:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0B16B05B3; Fri, 30 Oct 2026 19:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117FF6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:57:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BA5114042C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:57:53 +0000 (UTC)
X-FDA: 85380958026.29.5391289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA057C0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:57:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H92dZjxo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793404672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYH3ZHoy3wMBa62rdRKFlOT5iUEACgCaryz4Ge7v3YA=;
	b=NO/OPLvcaGAxGPPUQBPoBRuoI353ija+iq02VZqSA0kRkcpk096ZWqzRZT8flyos2eNmx6
	qIj/JHxkZFdHTe9NgHYJ+Sm9DjFZTiRrkB5kvE5cAvZaAJKktW4/a8uSPaSxs/jxHRWytV
	323YACUwgaObxVKUspGQNMM6Gyc4/i8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H92dZjxo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793404672;
	b=gFBa4w1Q+aKUQ/uPPN0PqFZXFUH9ziKV+2j0Een7X5+teap7fr1fa5NA35GsLRkG79Ljgy
	+UT+xkamWRXCfP4GfkRPtmNUv17kCAMvUnBOYluoPyRBn+hkomv/xMlib1l6/naS0AqhSZ
	dCc9u8Zgn4CJWUn4KcXuUOkKy8hBlaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F46E43CF9;
	Fri, 30 Oct 2026 23:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0D51F000C1;
	Fri, 30 Oct 2026 23:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793404671;
	bh=yYH3ZHoy3wMBa62rdRKFlOT5iUEACgCaryz4Ge7v3YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H92dZjxoEBjeg93MdfYqW/6IAuzONdaBmZ/OVUIsM/rdieejBoUuPSaLoOlo/X9o1
	 LlUIR8KOWVCHXQJ0RXY6QJvgcTFZDjQ/SKuYB5lMYKKlKkip+akHrFT7sXCC+QTS8t
	 cXMzHeO+7K/QXNLgWd24gdJG0IuXHSKRDFzXJJyx+460C2uW4fEZiprWvkS9p5Z/xm
	 XcsKKOfRK6ab+J2juDoX2gfEAAT5ljzSTYck93sZyWI7z36GkDg4BEq9Fni2WcB9aI
	 mjhqPrj/7BdZ6vAmuIqFRM5iI7AFLcUsJ30+CpY1jeLBqohnWPf9I1ONGO9xBX9uKC
	 DGSaHM1C+gE2w==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or larger
Date: Fri, 30 Oct 2026 16:57:41 -0700
Message-ID: <20261030235742.87036-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6ac05dd8-321a-4c2e-bce8-bd7ffcac9eac@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA057C0006
X-Stat-Signature: hsa6hd153tgkq17f4ny636r98i8teigm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793404671-670749
X-HE-Meta: U2FsdGVkX18oy+FB268dW/fIZpfTlE4tgZ1RzRMgeN350claHyKBjueDSOJwMmZW2PbeBINVjlRRpyuLP4pOMGjpMRorfkPaWTGe0IKz65RLkILh7u1EMCDpKQcVciBOSnPYewsxAh800H7dnAvXbum+2/AzNTTbHV1EcK1S8irXmmsTk5tP4D08/Bis3ZIF0AOAmJCGeI8ors7GPLGW3AxM8m6Pk+YXhUYVfhcoil2Z2WQmBG0IY+jcJ1i14GxLmlCHEzuEwlKpu2OTAVv//GpACdDMjQzYIGywj5ZjJZyLFrUUWvgU6Yn4hv78ekWxdtxf2kP5GJ2v65kLiKiTfhLZH4oZ+FfmpyDPyFX9NRXsEGUFyL89qf5YiTmIQ8JUD8Lad8nD3kmZj8mmC/K4otASEaZIskiqjdNWNRPMoBNFoafl5Fc2ddWfV0qQn+sLh2idARVCXxMzj16jYCzPty+R2wOlWyoWMdaGGQ4Vnj3DciTYzIRzitXXvGngOY/irIsdr3mD49WvBljkxU9dtaFoQv/vdwdf9eAe60GvFNeejr/hr6DIqHbbCo5XHvIBIVE/DNsPp7YBGUJ0JrHB6GW99wL1uwTvM7jhEhpMme6nQD3OrMms7icFF0YkqFvzYqlY7gspVP2Tg6U3vLPiPoxp8ZTEIn5eNg1JL6gSyMeuWugheab6WUqSszG6P/rAMKlvfzPPEuRMUj2JVCwKpfuUNFdUQl3MPoQWIBhqCgQnVRdo1YTZdEOqDtJoc+2cqpie6M8IxthonBsZCZUY/eLh69PuXutKCB8oeIwU/Z43D2nHDXtVWrzVsvj6sVipXV2Gau8KtkPAa8yqb1e3ODvRRWl3Rim3B8HWowHg7JzMU51FgY1k0kEhac0lxY8klYKuz/QpZamczgjEIMCaNZgesw1t7Z70riWLop7eBw/UCCtTHOyMsj3g/WucUABGb7zXF69f6Z8dGjh6bwg
 xJkfggYq
 oRQ1PGoPPpr3yhoGygLhdSi2tOloviZQtFYDCt/TlkKfApwReTU3lRLUGMe0LpVq5PEtVKz7tBYrmMQnGwciCgOSzlf25v8XRnQAL9pjgIBL5RmvBMf0+IIX4h8Vx+95mdVckgGyem23BrQTdmFJ/wbe5NfPQzzA8AqHftEmEtoaR+lvQviHVbnAAqU7rfbXXOIqbdGZ3rWHarprqrN/x1FMxwxZhVL7W6Q0hpbOTXgHiW11Ol1KPnykU8CIF2c4vpZXenGOix7yL4DZ2xnlxhnriCnBV3VjBsBKyMqGYE+owUKw914Hx0dxWPKCq8GvgRCjdVbhOHDGxigXozr/XbZcpq5u75EmI4YvdEkdVrUTa3d/pExFtdjDT9HI3GYDTV7fHwmPFAqlsMbxWl4LMMMrOND0v3zPDjStV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 12:19:46 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 10/30/26 12:15, David Hildenbrand (Arm) wrote:
> > On 10/30/26 01:57, SJ Park wrote:
> >> On Thu, 29 Oct 2026 21:33:22 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> >>
> >>> From: Josef Bacik <josef@toxicpanda.com>
> >>>
> >>> __tlb_adjust_range() takes the size of the range which has to be flushed
> >>> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> >>> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> >>> gets truncated, possibly to 0.
> >>>
> >>> On arm64 with hugetlb, a 64k kernel can have 16 GiB hugetlb folios
> >>> mapped contiguously at the PMD level and flush them when unmapping, and a
> >>> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> >>> at least these two scenarios are affected.
> >>>
> >>> Fix it by flushing the proper range instead of the truncated one by
> >>> properly using "unsigned long" for range_size.
> >>
> >> Makes sense to me.
> >>
> >>>
> >>> Fix generated by an LLM and sent by Josef Bacik in private.
> >>>
> >>> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
> >>> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> [ david: use two-tab indent, simplify description ]
> >>
> >> It seems the convention [1] is to put the above modification note right before
> >> the last S-o-b: of David.  Maybe you forgot moving it after adding R-b: and
> >> T-b: from great reviewers?
> > 
> > It's "b4 trailers" that apparently messes this up. I don't think it really
> > matters (some move it above all trailers), but I'll fix this up when applying.
> 
> Thinking again, I *think* this order is correct.
> 
> People reviewed and tested with these changes.
> 
> it would be something different if I modify a patch while applying it. Because
> then, what people reviewed and tested would be different to the original version.

Makes sense to me.  Thank you for the kind clarification!


Thanks,
SJ

[...]

