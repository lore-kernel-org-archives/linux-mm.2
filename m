Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B460C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416EE6B007B; Tue, 11 Aug 2026 13:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6FF6B009F; Tue, 11 Aug 2026 13:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6A86B00A0; Tue, 11 Aug 2026 13:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB5516B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:07:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EBBC1A0126
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:08 +0000 (UTC)
X-FDA: 85089618936.09.0406EE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4B43180011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bf5TjJfO;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzHgNprRUHzM+nWJ/u98+1Hlh2UAUyJ3Kbr/TZIbCxA=;
	b=XyJscGq3Lyjp4i8pvr5R14pbtCHgffvo8hZX973mcSQtnKYOs2lupp0nT9+85hig0WjjPH
	slNFw8ujUwo4JhlsjlEWTtSFc7PmoVGG/8Kyj0CcdzSqt5Ecaapxa/PBrdr24eFdcB7fkZ
	zYEPFp1a15gAgctTKvI+mwnIhv3zv2c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bf5TjJfO;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468026;
	b=3Qjbj+IxKcVLPjMFYGZMaGCSoYfAHMUW1hbr/V2oBODwJpzPYPldl0rUjnOWRXmvZQIDAA
	QlbhIubGMU2c53TCktEkNowwlpBC1mrw3W2wgLuitNEyRgN0Diq4+G6ZwTIhT5MlX18lr3
	TZa3DY1iMQhfyl+8GVn61KAlepW8WOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D268D42E10;
	Tue, 11 Aug 2026 17:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DAB1F000E9;
	Tue, 11 Aug 2026 17:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468024;
	bh=tzHgNprRUHzM+nWJ/u98+1Hlh2UAUyJ3Kbr/TZIbCxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bf5TjJfOh3SVJsd4OtNdIG5B5d2xI11qP61qJcO2dcoDBDjurnJvmNPwolN5e/u0t
	 B+s35+Ba3k0Ns93TcFR/N9sUve5/+B3Goi9qQ4RIFY2/TfV1P1ngNQrwNDWdpXcp/r
	 4q69xnZYEQ2sxu0tJvaoTKAAFegaeOn7niN+JtEhikAMpqH+Kg8C+KtvXPzvej/CwY
	 f4+zv+hOyB74boEfRrhRV6IzRg4W734UjR7CsmOmmM/IuOBia8qp9ei8JtAxef+bGo
	 fuAaB+9VFjwnNgmP/8bxFEXx+LF/kKv9tXOqV2pglDl8d/GMZ6T8XshRpJkqe6TIUs
	 eq8QHs1RDNSBg==
Date: Tue, 11 Aug 2026 18:06:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/20] mm/vma: fix self-merge check in copy_vma()
Message-ID: <antWi82nEl-7GY7u@gremlin>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-7-ab318a350404@kernel.org>
 <3a0a9aaf-20f5-4f92-b848-00ab702e8fe2@kernel.org>
 <antTCpT9gXN7pSRn@gremlin>
 <20f5b9eb-c4ad-4241-9556-e9bfce9ac715@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20f5b9eb-c4ad-4241-9556-e9bfce9ac715@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4B43180011
X-Stat-Signature: c857hnpxmgreeaa7w1gah35igbg5epw6
X-Rspam-User: 
X-HE-Tag: 1786468026-398593
X-HE-Meta: U2FsdGVkX19xD8RkG8X5rAu6xaLtuCtV5cOZ7a2tFBUSgbdrcCgXsHPMCJP3H0zYh8tzZw9NFfTCGncuA10mSw4gDFmmnCwvD+fGlf87+hofcsepVpCzxCTFeqM9A9/SMZFvJA+ZxIsDimktWCs5LtGn3Tryua8GJWK2jaGO5sOQfCvZ4Gcx/JT+O4R5MddRkXzI9NobSep7aNS0vRNXpWWWYOoj5ZybU8Vwx8O/lXNQaU7R9mZL2KGYpFeG72jqoPfpGSIAzzoQIN5Qwlm8Bh5go0Fsb5GvuHJxokDvcQQKrnD9RdcLNl0/F5LJhhoI3698V44SD0ujl29jKtEHXl69YyWGA0+wEKXdwlaIf73lYgCey9bpVGmzDRQknWu+iijCnfG3WAMZnIUi7iRjG/wEUJQnMs8Nampt85IRFrh3xPrBVtZK7osZQlBbKvSV4b2tIXEjAno7zBXYnF6ApeVZ6K6eAvpvfbHOON0OpqXCWP5F/wEL9eeNAONhr1D16XwJe08YpicffHHgHZfL7xaqS2iEWUHcHIay5sCA+/jmJthAaO/OcfUlMMENXVO8HKsD0cW797PP25BrP/wuuXnuo2yaZCmBOJjwtN2tiPaIgopg5tsfV/6pV4UAjrbo7uIVSiQyWyg/4GywXi9/wHxjOuSw2DYULJ2yO6frFWXxIfsOXadnKRohGPLgV309YMteiQaBeyqRN2/peIREFhebsinKltCMspa6xCcH9Cu+Zrjp0IgOTqrqOH+TvU55w/YQOjHyTE3g3l6EGzOQiMbhF5PE+u3kSr2eNTsCIMQiEgwF/8T7ak0r1BNBPcc9bsiMQ6Aq2Z6927LSKj5AYqmnvbsEio9lhh+/x98XBU2LDJCOH9FB8havmYGYFPktVqjs8XiROyfkvndA85w2bUZJzNxz/Q8YrJbb0/mC4ZJ8BOUXQKt0/uG3gkjr2GTCIqWUMv5q/2ZloB47iws
 0tZF5yPV
 ZWtm+3qa7bxTEYFefMZ5M9Curg3Z7Sh6U7cVLbelek2HAKLVxhykgc0i34vxWJZ1ffQj6X/pKtu+3pat30yOeiJPVlR+5U56oVu8E0VH4XucsWqwCc1lr+APGKLVs/teIi/ghS7/YEr4UBoSbZgGWKOVWlOQwiFWcoPjzpeF+OnnLZ0yFrQvw1cun3EoM3+iOKi3nJPfUOFh8tpdXdyplyjzqTbY0ki8nF/2+7tD7FewBD+lJc61iMI+NM42U4PeowU8Gk4E6URIvYZPLFA4BOfMoVtVGq5CW6HZDY6u4ayzpHDEfhXaE6Um3GvFQzlbiJypFrMjTq3UpINrVsXFa9vtziAmXAG2n+OvbtN+xX7w3SipeGu7XdlkxY/My2QGefEYFtW4ogLLef+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:53:05PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 18:51, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 11, 2026 at 06:44:01PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> Since copy_vma_and_data() which calls copy_vma() intends to reference the
> >>> old VMA after the merge, it must have this pointer updated.
> >>>
> >>> This kind of self-merge is not possible with a succeeding merge, as the
> >>> merge always prefers to expand the preceding VMA if possible.
> >>>
> >>> copy_vma() accounts for this by explicitly checking to see if a self-merge
> >>> occurred and updating the vmap pointer if so. However it incorrect did so
> >>> even for a subsequent merge (this is simply a noop so it had no impact).
> >>
> >> Took me longer than it should to find out that this is no real fix ;)
> >>
> >>>
> >>> So change this to only check for the case which matters - a backwards
> >>> merge - and rearrange the parameters to make it clearer we're doing that -
> >>> i.e. check new_vma->vm_start < old_vma_start (having already renamed
> >>> vma_start to old_vma_start to make it clear this is the previous VMA).
> >>>
> >>> Also update the existing wall-of-text comment to be a lot clearer.
> >>>
> >>> While we're here, replace the VM_BUG_ON_VMA() with a VM_WARN_ON_ONCE_VMA()
> >>> and update the VMA userland tests accordingly.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >> I skimmed over it, looks correct, but the merging stuff is way over my head to
> >> confidentially give a RB tag her :)
> >
> > Well that's what A-b is for ;)
>
> Assisted-by? Half-assed-by?
>
> ;)

A schloppy schplatch I like? ;)

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

