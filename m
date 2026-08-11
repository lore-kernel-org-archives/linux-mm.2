Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF666C5CFEB
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9946B008A; Tue, 11 Aug 2026 13:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69AE6B0092; Tue, 11 Aug 2026 13:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BFC6B0098; Tue, 11 Aug 2026 13:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73EF86B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:07:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0C91C016B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:54 +0000 (UTC)
X-FDA: 85089620868.29.996E94F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55678C0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muZHQpJO;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468073;
	b=qfr7jwKF22A6X2vqi3Am7fq1lJ+w4YfJXd1rA7rJ5MmHhVmvOh8UXyw+Pk5uLWt1/6zBUf
	i6uyu30iaDzC/2DA16qbl+k7jG8udQxZ6r1olzCTkuNUKEEB9QLN9BAOzFc2PQ/w4q/DdH
	PlTVh0M/zuSg3IVYhZk3HPTitsA4YZY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muZHQpJO;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUKLaNVgnm6yVlIUuq3S+v3XbNNRA5IFdKQLUZEf4Po=;
	b=azuDi9AFCMQ2W79iKEXIoKYxcJqLfbMrDw38B6XaXCqGZch5SUY9XDPVwrlgotUyUzGikC
	JB0YnYjiq1zzDccyPpNWJlYbJv86QP5m3yCUiwa1fzmRfnNv0R5YoTvhlrWXSe00hSwsbS
	hYDzIi+E3Vz7wBFWw0FPQNFcofNiW58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32CA4600AE;
	Tue, 11 Aug 2026 17:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4A1F00A3A;
	Tue, 11 Aug 2026 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468071;
	bh=iUKLaNVgnm6yVlIUuq3S+v3XbNNRA5IFdKQLUZEf4Po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=muZHQpJO9uzZAk0kMRcdaEMI9jcfs4Uu8oC32MtScjPY0WQhPC9xcG9YtLeaqYkRQ
	 BghULgIcL5/Ouo5WcMWjVgCzG81bXQD6IdhgzJ6RLsQSkBK03Zm7Q/fe1OeV3TUm0h
	 46THJIkIrI54+SDkzKF9E0cwdr8sdNPbtzdgd4zMW4gmlKrbgcMHPDNsbQ5FIgOYzV
	 5i4BQIab45nRpWJ+5/jy2TB8m8BQIVBiwTgWhiKCPfXFIL663Lp+qsXIZ1AuT7UVS6
	 vdbOBvZg6oEOgAzKgxsuG5rlZ/X3CLkTg0FKOgfOxRCP92SoTKocLw6YIaqodz+n1H
	 r9H212Mfzjw/w==
Date: Tue, 11 Aug 2026 18:07:36 +0100
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
Subject: Re: [PATCH v4 16/20] tools/testing/selftests/mm: test anonymous page
 offset merge behaviour
Message-ID: <antWw3a0iEv4l1Yd@gremlin>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-16-ab318a350404@kernel.org>
 <cf70ce8f-cdde-43ec-a50e-796d4e390f3f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf70ce8f-cdde-43ec-a50e-796d4e390f3f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55678C0003
X-Stat-Signature: i841ne1gmz7nyid7tyki6u8ozs966exa
X-HE-Tag: 1786468073-182087
X-HE-Meta: U2FsdGVkX1/MI3xZcQDiWgS8SJsBBWUxMt2EaSUtxKEPiIA/Cj1rn3pt/VDJVW4hyQp78nIF8m+o8y8T0ookDiEeZ53WlL80fJtsf3RY60Qpn8ZQxNrgyXdttxAQwGmzRcvNFRce0w/NF+7TV8tzcPxwC1NMlERCg9MBIDwcRaVeXc8f8AJW/BJ25I64LntOdSaFkRqEDVKBS3eQbYW6H4EJ8S3SX+WFvXKkQDdfh1yYtDz6s1KnSJpn/kX6AuPqRHXxNczuv3kC0t7MIxXCeuStSH/aMYfzkJedvUKPV3Z9RSBfGT9jLBFEPTZkbVy7xqdKWhjvoVfP45wF09tNNSBw5er+I1yJXrhiHrognVdGj+7c6LF7bghqoI0aMlPQHVzoNep564Hl5c9OiOdLrNtkwEqDYHPtSvOOdBUGeWFXOptDJpZ0+PaZGoWS74Tx1Iwb4BT1OVBVPkwCeSk4PWMHmk7asbqZOjidA2djdklnrLnlik49x0AWqPJaTF1bDNgbm6qMm9ofpET6aBheEUJcQaIVcj03gOyj5jhgO4pRwX88NwWu5nUkWU00SwMP6uovlWAfy0FmlkaK4MVl1A45PeMiC3TBa+8AGTpoOKa2yDa7U9bUwTJ251frG5/afz+2zDiVhtuuYdkZSuRvLO00ms+94FxkRepedsvoU6r43u8G6YQDieAwdKxpErYHFnJFnu/c6V7EMz2PodF/ZeeIrCCyjJI8E0AE7NaFd22VBmYR6LWOpDWOrCu+FY8qInb4Zw0IJeNXvM+eSDFFzbJ+aUfQwFpPZDiDQVSqf8fm1d30o+Lh3C2Dds6nrc/WyeJBVLItfo4nSreR+kAWHcpJiYi2+iuVIG7pl0oY4pqsFYl9s+4wG4+86820qiOhsc7iBDRguz/Zo6nV6JDUZhkzEjRWYDBuYE3Sqh24mxWkBQqE8JZR3OKzXImO0PXneOFg04wWKOxDRCcKMWS
 rAbt1qW8
 igRCuDUpui15h73ymNNJ1+RVlx86VyJ6MnMwKr3X/edsdHXlOsjihpsvkibFs/fMRihVzpBsLkxpc1zjI9MNxHMhOOySCklckakS6Z4cnPwIsvmeEvi77+100vODfktVauhyzv79CyvX0NlSV8U0ggt6sjHys4IvCRaHnH5DXzBdPEk+4nabGKfdRUU+H2nCA6zVfuYqI21GRif3r6r++eYvC72DzleVvG4h86dAGTAjJa1IdeRV+shqJGaERjbqBAB79fxo9ujJWmo+gc36+M3HQqcZNPPKcyBfZyfSyLnRFo7R5xkqMYYmrusLGOM0GPGXuGEqbnwEDHOJAenVvN01gktuaFVgec8yz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:56:18PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> > While maintaining anonymous page offsets for VMAs has no impact for most
> > merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
> > happen to have matching page offset but not matching anonymous page offset.
> >
> > Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
> > region with a faulted one with compatible file page offsets but
> > incompatible anonymous page offsets.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 57 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> > index 519e5ac02db7..cb7cdb6b7ada 100644
> > --- a/tools/testing/selftests/mm/merge.c
> > +++ b/tools/testing/selftests/mm/merge.c
> > @@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
> >  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
> >  }
> >
> > +TEST_F(merge, anon_and_page_offset_mismatch_memfd)
> > +{
> > +	struct procmap_fd *procmap = &self->procmap;
> > +	unsigned int page_size = self->page_size;
> > +	char *carveout = self->carveout;
> > +	char *ptr, *ptr2;
> > +	int fd;
> > +
> > +	/* Create a 10 page memfd descriptor. */
> > +	fd = memfd_create("anon_page_offset_test", MFD_CLOEXEC);
> > +	ASSERT_NE(fd, -1);
> > +	ASSERT_EQ(ftruncate(fd, 10 * page_size), 0);
> > +
> > +	/* Map a region using the memfd at page offset 0. */
> > +	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
> > +		   MAP_FIXED | MAP_PRIVATE, fd, 0);
> > +	ASSERT_NE(ptr, MAP_FAILED);
> > +
> > +	/*
> > +	 * Map another separately, and fault in, at page offset 5:
> > +	 *
>
> "Fault in" is imprecise, as a read-fault won't do. "Trigger a CoW fault." might
> be better.

Andrew - could you fix up? Thanks :)

>
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

