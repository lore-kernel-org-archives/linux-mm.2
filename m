Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD10B606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZASBbMWP
Received: by kanga.kvack.org (Postfix)
	id B960E6B05B0; Fri,  6 Nov 2026 06:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47906B05B1; Fri,  6 Nov 2026 06:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A388C6B05B2; Fri,  6 Nov 2026 06:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5E16B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:53:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08B70140D01
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:53:21 +0000 (UTC)
X-FDA: 85404533802.23.5C36739
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3EEAEA000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:53:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZASBbMWP;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793965999;
	b=C+cH18o9e03MTNUWON1L+nVMCqHooaQ2ZbRIgWWk1ous2SQVz8Lgf/jhSy19JX5UbIiT9X
	wGaENZVUhkG4NIqDO5Es1a4UlL3b9e6vKk//7I7gixwr2hZlVjPx/NstLBu9V2kjuDIrd5
	sE41Yw5F3fbmCnJ7LxcJeGSlSrcSkn8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZASBbMWP;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793965999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqpiqZcrPC9wx5aNBvYP4zckV3Yjf+8M1ASIDcJQ21k=;
	b=6kYiZKnfKMSB6QHMBov5Enx5tPkW2Po22QZ+2Pns1Ne8+E4ZTQn3Ibg+kq5rbVYo/C4QAM
	vo4kef7gkPgyUE26reUYckZIIKX9qY2ZIlvoGhdsHa0epo6gqDyGqReSqOOoCj0n6UXIcz
	Z48TjP3Bj/eY6KZhcr0yemPoNqCUWY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75F194356A;
	Fri,  6 Nov 2026 11:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67501F008A2;
	Fri,  6 Nov 2026 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793965998;
	bh=hqpiqZcrPC9wx5aNBvYP4zckV3Yjf+8M1ASIDcJQ21k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZASBbMWPNza7o7x9E3ufbm4LKePl9d45ui5EyEQj0c6nFYmEnKRqRSm6yN2TUJnIG
	 x84xkieBm9T900liY371Whv+vlEgtVoIoe8ljwbZ4lwWbM8KpyGnDW53gpM4hXJBWS
	 OVFW5f4RKVdmXU/CRk9MtOYLRTOVEPMg4cMbwOjQw3CDtAgUhShid4U2o80KoWCvXJ
	 7iOsi5mT/kqUbrGf15Pj29AgOI3H4VhdUJhDFAAQhNzZE0VHvIyVtlFvkhJjAua2XU
	 YUPMnsJ4zBwKcR/8IaIsESK7/SOqxLxJHo/P8jZeFAnAF9NyOrBY6sci09ixJJiZ++
	 qRejsB3E6wJmQ==
Date: Fri, 6 Nov 2026 11:53:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 02/13] mm/filemap: convert fault and readahead logic to
 use vma_flags_t
Message-ID: <au2_PPpdAMgRJZtX@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
 <sashiko-outbox-200257@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-200257@kernel.org>
X-Stat-Signature: f8jkdfu85jdmfh7dunc69fatukyjupwf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3EEAEA000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793965999-632620
X-HE-Meta: U2FsdGVkX1+Rel51PYQlvK3RYpsD8W7aKI6xGs6Z+ZFmfnPRPyR6jAoRHBZVUaUY7yGyqj9H4N9dnvIbftW78lv+pW2HYGh4EZRsRk17Yfha74fWAE9jlKpZg22p4UZhJL0grBrYwEtC1hV2Q5QGXLuduJN7EqW5gMnmBLZaZp23thcZj9GBR7t91cwbEOgJ0cEfC4sdBvRxY1EZZNfl92lpvpLxAplqCnlzWdUpPE4clwYa9GRyZIUoLviy78e/m9uru1J/lMyW+7EwIHs3VDEPDM1OYnmGj4vGtvuGSa6g/yIZUpYWiJPvUmEV8jY5foLnbfDnx0YeWBPzIrFi9ifrt7PVtccKhrc57bkaguBVYqyLkQWqRceUZZFR8PZ9zrwyzlHFNU7B5alw6yW2VNsLRFrCpGJAjYwW1MefDqLDfvp4JKeTqKS7AAKvAa9aRnNVCpsiODhHfoh6IpxZhhZeFk9OQfXi1Jhx3D+mTH49tOD/fW9PppTcQahFCAX4iYyK9yRDC3n8GeL5aZUgJt9yFOZjg7ew5E1z1cev/A6ibbnF+13jdhHjhZe1Trkq3q8Qo1eyuwVdQMpCjbnMoRkOXqRMboW1MrrpCB//D8MgXCBKdU4bR7DoeJhf8kHJ3KEaz99PiOUX4ffed6IMe+hEG1caiRMVYyxlw5Cgq7FBDaKVjISWfHUDWgIa5xmn3wjtS11G01I95Vew6zZg2LwtnyrxLCpxZyaT1uxzjxvFjgXGLRHoNaf8Vgc9SEAeUTDr7Wxdc8dfyabPvCuDV/vvqOFkAVFvxq7NI4GCVNjEUkZuxsuXLSKUjJz+Oskj/SnOyC4ao/lurPTNVATzyXPsJfdkSOvZ1/e3jQcCHLNuw6EECYreDTpxf/Lh6z+LxuJcTqRm0xrH4deYF/QLeg+QxYIYi2YfYMJgSI+v4Ec4cUj0pZ8FB7NTi6fh7ZI7oK1L8LfQ8xGpnODMqXv
 dhrhaFpu
 iAJ6SQamawU2HDXMV4DDXjAGA1trNLuDjbOFv+uREbQxLTez9eKZOqJ3/5Y0H3m27/F6vW/utHYgdX/i3MxUTPdKBn+08aAKzT+oR9/MQwrOFULqsZGDRm4KfwSYSy4MB23h/wHzfpt5Rf7CrJr+5q/eYTVyix3OI5s2gkay3hAgJr4AQrvHCXGrIPEj8hy/u1IYWTV7Zr2XlapBqa74xnSQ+gfpnh92g3Jol2OX7S+e0e6LjpkylK6zuo6d0jaqyd7CKXD74CAqViItElxqiEmnVxLGG7Ht1SXfDz9dnU6KjunMQ573BgIwcfhJqPXBTIrOb31r6SqUiA1dWw4vOQ39ACbNWkNR/FH0oBO1OtVwavGumUikJ4q8+V0uBx7Q/+Vvv7O3T4F5o6kbrs5djGuSYcbGGzDWpbMcHwiWxlGYQQOYlGIty7cxHPt1uK2BmMEKQc+/18H02tm1RCJI97TWgmjhbRUc+KzisK5XAYWS7ozw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:41:34PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mm/filemap: use-after-free on vma in do_sync_mmap_readahead()
> - [Low] mm/filemap: inner vma declaration shadows outer vma in do_sync_mmap_readahead()
> --
>
> commit f5f0f8e634a6a2e2b76ad818de67e83f30cb7dea
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> mm/filemap: convert fault and readahead logic to use vma_flags_t
>
> This commit replaces direct checks of vm_flags_t values with vma_flags_t
> helpers in the filemap fault and mmap readahead paths.
>
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index b74bc1e5015c6..d8b538bd14043 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3351,13 +3351,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >  	struct address_space *mapping = file->f_mapping;
> >  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
> >  	struct file *fpin = NULL;
> > -	vm_flags_t vm_flags = vmf->vma->vm_flags;
> > +	struct vm_area_struct *vma = vmf->vma;
> >  	bool force_thp_readahead = false;
> >  	unsigned int thp_order = 0;
> >  	unsigned short mmap_miss;
>
> [ ... ]
>
> > @@ -3414,7 +3416,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >  		 * Fetch two folios so we get the chance to actually
> >  		 * readahead, unless we've been told not to.
> >  		 */
> > -		if (!(vm_flags & VM_RAND_READ))
> > +		if (!vma_test(vma, VMA_RAND_READ_BIT))
> >  			ra->size *= 2;
> >  		ra->async_size = folio_nr_pages;
> >  		ra->order = thp_order;
>
> [Severity: High]
> Can this trigger a use-after-free on vma?
>
> Previously, do_sync_mmap_readahead() cached vmf->vma->vm_flags by value in a
> local variable at entry while the fault lock was held, as introduced by
> commit dcfa24ba6899 ("filemap: Cache the value of vm_flags").
>
> In the force_thp_readahead block, maybe_unlock_mmap_for_io() is called before
> this check:
>
> 	if (force_thp_readahead) {
> 		unsigned long folio_nr_pages = 1UL << thp_order;
>
> 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> 		ractl._index &= ~(folio_nr_pages - 1);
> 		ra->size = folio_nr_pages;
> 		/*
> 		 * Fetch two folios so we get the chance to actually
> 		 * readahead, unless we've been told not to.
> 		 */
> 		if (!vma_test(vma, VMA_RAND_READ_BIT))
> 			ra->size *= 2;
>
> Since maybe_unlock_mmap_for_io() only pins vmf->vma->vm_file and calls
> release_fault_lock(vmf) to drop mmap_lock or the per-VMA lock, isn't vma
> unprotected against concurrent modification or freeing when vma_test(vma,
> VMA_RAND_READ_BIT) dereferences vma->flags?
>
> > @@ -3422,7 +3424,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >  		return fpin;
> >  	}
> >
> > -	if (vm_flags & VM_EXEC) {
> > +	if (vma_test(vma, VMA_EXEC_BIT)) {
> >  		/*
> >  		 * Allow arch to request a preferred minimum folio order for
> >  		 * executable memory. This can often be beneficial to
>
> [Severity: Low]
> Does the newly added outer vma declaration in do_sync_mmap_readahead() cause
> the existing inner declaration in this VMA_EXEC_BIT block to shadow it?
>
> 	if (vma_test(vma, VMA_EXEC_BIT)) {
> 		...
> 		struct vm_area_struct *vma = vmf->vma;
> 		const unsigned long start = vma_start_pgoff(vma);
> 		const unsigned long end = vma_end_pgoff(vma);
>
> Should the inner vma variable be removed now that vma is declared at function
> scope?
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org?part=2

It seems these are valid, oops!

Andrew suggested a fix off-list, and I agreed to this as an in-place fixup to
avoid respin.

I have also updated the series locally to reflect this change:

----8<----
 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix
+++ a/mm/filemap.c
@@ -3410,6 +3410,7 @@ static struct file *do_sync_mmap_readahe

	if (force_thp_readahead) {
		unsigned long folio_nr_pages = 1UL << thp_order;
+		const bool random_read = vma_test(vma, VMA_RAND_READ_BIT);

		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
		ractl._index &= ~(folio_nr_pages - 1);
@@ -3418,7 +3419,7 @@ static struct file *do_sync_mmap_readahe
		 * Fetch two folios so we get the chance to actually
		 * readahead, unless we've been told not to.
		 */
-		if (!vma_test(vma, VMA_RAND_READ_BIT))
+		if (!random_read)
			ra->size *= 2;
		ra->async_size = folio_nr_pages;
		ra->order = thp_order;
@@ -3438,7 +3439,6 @@ static struct file *do_sync_mmap_readahe
		 * pad that might exist between sections, which would be a waste
		 * of memory.
		 */
-		struct vm_area_struct *vma = vmf->vma;
		const unsigned long start = vma_start_pgoff(vma);
		const unsigned long end = vma_end_pgoff(vma);
		unsigned long ra_end;
_

--
Cheers, Lorenzo

