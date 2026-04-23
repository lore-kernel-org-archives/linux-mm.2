Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C522DF9937E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6FC6B008A; Thu, 23 Apr 2026 07:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38ECA6B008C; Thu, 23 Apr 2026 07:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4C56B0092; Thu, 23 Apr 2026 07:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2266B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:57:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B618160119
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:57:17 +0000 (UTC)
X-FDA: 84689670114.19.0E46C2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15E9E10000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:57:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=idkCZOup;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776945435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMZWtfjIWNO/JysIhn7eMR9XhBiqbQQjvoPhb55A6AY=;
	b=oWmM17YbHTELNJQvjxfwmaWv/B1mat841rwmNzhTt+99C3/aQx0ViTpy8oMkYTt8BbUv9v
	JGp7I1ZrlK4RZemZwOaevYBnxDC3C1Wi0Wcov6R8hVVkzlf6qCGC69kkfh8eWvWKdnaXFY
	N2+HoniZEp1GdmbhkUpC82CgxeRmqLc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=idkCZOup;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776945435; a=rsa-sha256;
	cv=none;
	b=n6we7q7cFS9cvXTPgAn5OAmqHTiqVU63j2V3nW23Mm/mL9xSU8ynxpSKIGb2KdGaffmty5
	ql4wBaHb4erElNHRJe/BaQkfsiYJApdVFOoNM4nvMAHrp1jCwytbIwjBVKyfTgfI5oEPIa
	NpVgXxrVLI4Fy30pcYTV4eFR3q8/pq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776945434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jMZWtfjIWNO/JysIhn7eMR9XhBiqbQQjvoPhb55A6AY=;
	b=idkCZOupGtbKqjmqoVCIoASSbzm3/wKR59tOKjC06iHVMRUe4EjFmBm3ED+8jYe+8M4NHE
	8syu1xEMbZHyeOILZUJbYnpqdRjPJolLBZ/073/Xrvgh8XY/rzEK5+wyfNej2UtKUx0AdM
	V6bfPyetYn+HSyXGNFc3wsbF5en4uOw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-uv4UVzWLNYC9QEyIDOnujw-1; Thu, 23 Apr 2026 07:57:11 -0400
X-MC-Unique: uv4UVzWLNYC9QEyIDOnujw-1
X-Mimecast-MFC-AGG-ID: uv4UVzWLNYC9QEyIDOnujw_1776945430
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso47426985e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776945430; x=1777550230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMZWtfjIWNO/JysIhn7eMR9XhBiqbQQjvoPhb55A6AY=;
        b=NvipzlO+6QcCfc165S1VHYaZQc7RP11/seCvsQt2xZO3uOJ3s61FzpOBHRftZG6GC3
         5NIWQOYs3OQZjYvyuynRQDyP1zW9klJnpBucQ6S8UTukr8FJ0DR6E8zIA8viLe2eQN/x
         etHqDLzMBTkTDt3YUVXoqKBLtEBnR/s1MftKjlmv9NgexQuL9VSZF3UOPr+7zy8+Elkv
         edutgRk0pmtyaKqZS00akypFp1hgG7+D2AUiLkhuzA2Zq/SPzY5xetthRzHF3379azBa
         6MaXpXAaO/p7SQ1Yq3fu+Uu7It8KMLzRhcr+6LT6wGOcRJ8wsOLJaC5Fh3wpeB/fHQWN
         jFGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9BLI/aRByDxJjFXiLK0I+eAh6F74XvEg4ISelQt83SJGi745rpXSPztZb2mpT1aiqlvBhphPQhvw==@kvack.org
X-Gm-Message-State: AOJu0YyFJdBlrGii8ykE5G1+07NKxJ3TrXu/2hYBXv13vhKz6PtZg9Y/
	eYLCo6qWGilwvglsYdXUCHuYi4Qu8UeJoDygKqMLEigIs/GC4g75tFC3XZz2sdx/JeO+bz1W/Pw
	8iPApn6fXvLycIgH2hBq8OEzxlgVqF1DwNhJI73zB2vsHTIdaEv8s
X-Gm-Gg: AeBDies+LGS9I5Zig7b8dUP5HsP95CC4SljSz2fS589tidL8RDphOMjlsI8mQNbhvh4
	naeBvPQnjfyCHLMFGf8W2Na4+Pbfv1eJw0DjV7JtH9enomaSjaaqSgeyFz608EAFyWzxV6SnJT6
	bR546IUH7LxZSc29kzaHfTRpriWFp5PNBN1fmTSQ36UzG0tRYCprivbEDuJrc+ku/WviUpXP5ER
	JSouAmgs1X0+8Oo8tao4gZQiK3Kw/U5txc5O9cHvWsTk3xZEaBZlEAkG85mdegFQfMit4yGGrsi
	KpBanalA/WmRR26RKmT0NzTs3hnUoBxvFNmW3t5d0gZvoPJyRYciV1WgSM2VwZ4A2cHc5yBChN4
	1ZmIXg20I34rL9DI/YNjVFO/+N8Ax8URLEhnTzznZuEDObIAA3dkVHw==
X-Received: by 2002:a05:600c:8b4b:b0:489:1ff1:74f4 with SMTP id 5b1f17b1804b1-4891ff17707mr203280345e9.4.1776945429778;
        Thu, 23 Apr 2026 04:57:09 -0700 (PDT)
X-Received: by 2002:a05:600c:8b4b:b0:489:1ff1:74f4 with SMTP id 5b1f17b1804b1-4891ff17707mr203279475e9.4.1776945429042;
        Thu, 23 Apr 2026 04:57:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7bf7besm184344495e9.34.2026.04.23.04.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 04:57:08 -0700 (PDT)
Date: Thu, 23 Apr 2026 07:57:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260423074433-mutt-send-email-mst@kernel.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yxd_u7lHLFEE_dslbkJmuuG7CkK5kH6e3ZX3fQXVbaE_1776945430
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xpc81rtcxhgirxxecz5om9cn838a3sxf
X-Rspamd-Queue-Id: 15E9E10000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776945434-898313
X-HE-Meta: U2FsdGVkX1/szHChn4leejexTWPj1bi7TA3I8FT6HEh+JGpJlNlMNf++CBYoaQ29jSLkqUspgyCgwEa4XI6mxYaP5K6pWJuvEurLERONQVD4UTMOBb6euNfoVxA6LBsMSJ1f3Ic/9fAHsbC8L8xSiGr4iofIwUXgwGms+DEVMvo3Zcm8qP2oSQIQUDAj0qQOA6l82HxdcHXfmkq6lh/VIRZw5oDsFenGulAjoEQ2kzJrLdYGuiARO4TnMfZK4AfRefPjqOXX5XWGbC1Zj9aqzGtMGyHn+Pvcv6vAP8BfZkHNoN5kHdWSgaHsFDReDpBbjkbgFDpYU5zVxCJh8x3jHUBdtGUdeUKlUNIEq3+ClwA26Nww6KfziBuJ051Zyv/5goK/sA/MQh7+xbxVKUwkKSAsY0uiCOEQjQWGjHEj3YvKKpu7Z/wx+RnGFe00KPdH76jTppcdN7mRtcmQMnaOcjLC93wX7M9RL7HMzWgzyHhYzE5oq1MaRSJrM97dG1or0GMwalfH5XKEx9L+7nv9htIM4FnW7JVl+B20aruXrZnGsLJibNPzapQ2Q3EXvca70buOqt5y2K1y9eoNa+T902F28RfO9PLHJl7us/MgtjLnR7qRcZM7poi8H44BouG+nCG71lvJHk7UfESkpxrCjldam9iTVCWrDqTKcXF6bpOQkQlRkMZzao8UXMKLXfXEH3AfpeOkgSnysZiILQ+5lY3FPLQeTK5r3vMaOHwvnABABdmQE+6eb0h7GezEgnyL5ZcMSqRlgFBSxG19ORiuBoFvrZ4cKbIGjv2Aqvy9tZYWyemSLNtModBZILdxe2xVabmtOqI5aUMQVf28U0hWA2WjqF4ylzsPb2kXNNcsuOLG2f2g3K1EGjV8CHFUPWh2rDPMhixbmEXyHauheKW7vqzsI5yePEGC7R0Dc28kW4b00S0404T2OyTD0+9E7djgNQ0k7nlpwd9fpJBOD7f
 vs7gN2qe
 JlmdKTDDjxh62nzlSavylkC6oLFukRjrr7MhUZICClIo42g0PZhFHGDgRqqWi2LlN0jH/fbQtKwc1hfh0K+tb053Jcoc05yKJ5Lw1wppy4HpKbQYulHvRtGSLCBDFpagqe5i3RnC5Vw0jwqdXqmDP5db/NDhltZ3no/I2WQ2qG9HT4wJNMdNwJkClDQKHsozDfZjtFQvJP/WYX/2xnre6wEvulmdA6qUm9vYuduPJX9Nz9jpQTLZ+LCwDiqat8GwjrCuxpPu3wHBkrigD08BQSN6dEphF//sbKcjc7MhSsIueSB4cUOha6dTnkNdgZsmQcyOo8b/XGJwzQBDL0DKI9MA57nlB+mjYy+Nkh0iBVWri9CzcykRhQrj33tWvtBhGP+qlX/DX2hskBZO9OnPigSkNvKSpZP77QUlZzZpwS3fyGNAYa8RnVHZXa41nNZ/Ixko1YtX6x2y4GPRkbqfmjWaSKthCynKu7TnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 11:46:56AM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 06:31, Gregory Price wrote:
> > On Wed, Apr 22, 2026 at 05:20:27PM -0400, Michael S. Tsirkin wrote:
> >> On Wed, Apr 22, 2026 at 03:47:07PM -0400, Gregory Price wrote:
> >>>
> >>> __alloc_user_pages(..., gfp_t gfp, user_addr)
> >>
> >> With a wrapper approach, looks like we'd need something like
> >> __GFP_SKIP_ZERO so post_alloc_hook doesn't zero sequentially, then the
> >> wrapper re-zeros with folio_zero_user().  But then the wrapper needs to
> >> know whether the page was pre-zeroed (PG_zeroed), which is cleared by
> >> post_alloc_hook before return.  So the information doesn't survive to
> >> the wrapper.
> >>
> > 
> > I was thinking more that internally you already have that information
> > you need to know to skip the zeroing - and so the wrapper can just pass
> > __GFP_ZERO and post_alloc_hook() would do the right thing regardless
> > 
> > Then on the way out, the new wrapper would take care of cacheline piece.
> > 
> > However, i explored this a bit - and while it saves some churn on the
> > interface, it adds two paths into the buddy - and that increase in
> > surface might not be worth it.
> > 
> > So I see the tradeoff here.  The churn is probably worth it.
> 
> In v2 I commented [1]
> 
> "
> For example, instead of changing all callers of post_alloc_hook() to
> pass USER_ADDR_NONE, can we make post_alloc_hook() a simple wrapper
> around a variant that consumes an address.
> 
> So isn't there a way we can just keep the changes mostly to mm/page_alloc.c?
> "
> 
> That should avoid most of the churn outside of page_alloc, no?
> 
> [1] https://lore.kernel.org/r/4bdc66f2-1469-4b91-9935-74c3d3ca0ed9@kernel.org
> 
> -- 
> Cheers,
> 
> David

Yes I'm sorry I missed that one and didn't answer it. My bad.

To answer the question, no, definitely not *most*. Here are some numbers:

What we save: 11 one-line changes adding , USER_ADDR_NONE in callers
that don't care about user_addr (compaction, filemap, khugepaged,
migrate, page_frag_cache, shmem, slub, swap_state).

Changes we have to add: 8 changes
Rename 4 existing APIs adding _user: __alloc_pages,
__folio_alloc, folio_alloc_mpol, __alloc_frozen_pages + add
4 wrapper macros/inlines in gfp.h that forward to the _user variants with
USER_ADDR_NONE. Roughly 6-8 lines of boilerplate per API.

 
What stays the same, but now has to call the new APIs:

all internal plumbing (page_alloc.c, mempolicy.c, internal.h, hugetlb.c,
the actual user-page callers in memory.c/huge_memory.c/highmem.h):
38 calls, of these 21 in page_alloc.c, 17 outside it.


The changes would be less trivial to review, too. And I would not call
the resulting very long names "elegant".

More importantly, it makes it harder to review: instead of
compiler checking we did not forget a parameter, it compiles fine,
but we get a subtle slowdown or corruption on non x86.

And I thought you agreed with this sentiment when you said
"yea something that is harder to mess up would be nice":
https://lore.kernel.org/all/20260414062524-mutt-send-email-mst@kernel.org/




From where I stand, we would adding technical debt by piling up new
wrapper APIs, for no benefit.

But then, I'm not the maintainer here. And adding extra wrappers
is easy for me. So, let me know. Thanks!


-- 
MST


