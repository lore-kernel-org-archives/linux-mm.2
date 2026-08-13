Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89230C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EC86B0457; Thu, 13 Aug 2026 05:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847166B0459; Thu, 13 Aug 2026 05:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735BE6B045A; Thu, 13 Aug 2026 05:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33E1B6B0457
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:34:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8F121A0166
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:39 +0000 (UTC)
X-FDA: 85095736278.29.CBF0D84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1C43540007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUE5dJPA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GGJeMXZjenStr/KzvJ5bvXYBWbaVtnV9BN6Q25mvnc=;
	b=dApCoGhsRXeKmrvWnMvVviS5Wdc5U8x0h0mq1+b/gppw3haMn3idYMZNw2KLOZgsFi7eVW
	Y/uvfpiGfWY5Qzv0yBnjGujAFvfZ/h4caSZVIeCzdYJpJhT62gpDE0iN5sDuWgFTKWytJl
	u1DEvq9xIMKyecTOohQHc1BgTY4cAEo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUE5dJPA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613678;
	b=dYFgJiqjOAhEUibjO16yhNy28NIlXR6ntSjzsjW/26les0ptlNedg/U0gIUKNlqb7VZ5/o
	ZL954zHHb+FhkgswG+TfFO/lK52ILVK/lai1ySPNSjIJz7MJ3oC/7zW4AcuxL+lHLnQm7J
	dZeBuzUpD3b+Xw4r+XODhQoNtwfKpKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DEC76011F;
	Thu, 13 Aug 2026 09:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2C21F00A3A;
	Thu, 13 Aug 2026 09:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613677;
	bh=8GGJeMXZjenStr/KzvJ5bvXYBWbaVtnV9BN6Q25mvnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bUE5dJPAlkV0e3vT0h7pYlLJU5zXJxR2LXxBNspnyo1VD4QhHtGs98mt311XJsBdW
	 NwB8Nq4PllboYzEJBi81NS4Znt7rwrq4KgMryMSE0C43kPgg4JZBe4YaD73IDj3Qhc
	 hkISD3HoCeXW5N5BR+POiDBs1yZqmn+EUOSooN1tXl82a26xMjeWiPMpVvfYRQfG/x
	 ZMtuu9DxIOMyxMhsNgoWAd1PzcOu+EcD2NUsikKPG7Mr3cJCZt6UfUjHm2RYLp+0Px
	 1/SSm+fTyu/vmq45+SrPqFDYNWi/Yibqy+QbWRYX2IwQzUF1p8qhv0/ihpFi9UoHkc
	 0QX0gdddlS7+w==
Date: Thu, 13 Aug 2026 10:34:00 +0100
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
Subject: Re: [PATCH v4 18/20] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
Message-ID: <an2PQD_pT-ZpSCvP@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-18-ab318a350404@kernel.org>
 <517ea018-d6a9-4c78-b0a6-4f002b3b72ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517ea018-d6a9-4c78-b0a6-4f002b3b72ca@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C43540007
X-Rspamd-Server: rspam07
X-Stat-Signature: uwhuzn4npn94sji94i3j1ynjd3bdpow3
X-HE-Tag: 1786613677-35757
X-HE-Meta: U2FsdGVkX19FS//wLh9M4uQ+YVAKm5BgLId5VrR87toaY9AOG3UlDsCrtS++8vmC6r4PsynJmQL2tfR9hXEv5hVOwEfclkVLlj8IFABsoZUlShu8QkWbeo6fD+uly6b6XyO51KtWnBkPBprLJ6p3pgfvlMmDce+XlKSu5EC22J7SW1uRqL7u4y4hEww9xAdGFql1ltL2Rf01wyGIzQZ2cI1dKnDR+agPdyMNB0uYZy+yW5XdyMWUbT2LALGYt/e8uNTobM/33BkqsDur6mqCtUvRUQc8R/BdSA44nI4OYr8/brj76nHMn9hpVyaCGXnDUEBpjAe6Fgrn6sNcGz3rXyakH13+u2U6X6M9YXyRZQMP4Yq/UIwBlIPZ8YOtdXR4mCFmqYQL1VKG7dBz1hKQXSBSvu0chhwBH++Jc12EZ8Vha09MluiAnRduTZBuS3qEI1OqMXBh5y7vCAs08CmrO8BCgD/wFoawBn4leEnu8lcnYFWWuUOvJGilFuOeM3qLai4qXPSZoNkxdEqlOPCITfmdxb97eRLjUUEpS9WNa4yIPnUgbnCryKlotaJs7yzwi0Jnl5EQB82qKrP+ZleParWTFt0MRK+hnR+DzhuNAoCdzbN7O3BltTUHD0rH27N4NzJrhQ5hk3Nj07+ilPw9DNbMucnTtNNQcy81UsQH3tGuJ0XUHfmtAyjLS/RtTnkQev/HG/tNuQRu5LJIVRHbkCQKIGMsEtxhIP8YJne/Leb57cXX+sdUeBBr0GwP3sfQoPTuzrfPh3PkeyLliW/No3uZwUOVPPsKAH+bBViHZ7TxFH8FQbqFsM3WIczoa6SjR9L9jBLr6ggOAUyFS9ECVk7rA2mACRLrpEhNTJCkDtQswfkW65iqZ18T26iiQTHtfzGX/nsF7mJnlV36lhrXy3AtkhX0cI9qynHwCYT622vXwFw97qaa85Zl9Soc2ti4Ly/aATYSP+TkCnTCdZu
 ffXu02s1
 ae5sknWHN8ya+QL4YKTXj8uUsi8CfqwWbFsBe0FiW8UQ+ymUN3gHQA11PNGfZbQwaKRg2nRunWYQ0w9kwiM6ULsi8PmV8xroQtGZSPOutsxc/toZFSXCRVSR6hHIK+F70KhtAV0sc0oVolldCDL1ettHq+V37fKmtH3W4p4QXp742PxCtC3Xz27sZsUw9uYgTcqliKxkMyVNBsi0Rv2YqSX1uxtrI3Z+9mXxEbeOPOb5IOqC0pLOY32c4LVVR3/nEu7Ri8pkkbFSQXxxq7ovUGgVOtOJeoVyS57MwreYnrzEkYIB1goZIWWRw8LW5/aicpdBUq2G229jHh7vBYcj6iSvTr4T2n5hN8j7pujiaaov0VVESiQnQNSM1kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:29:43AM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> > When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
> > originating from Linux's distant past.
> >
> > These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
> > vma_is_anonymous() but otherwise resemble a file-backed VMA.
> >
> > The introduction of anonymous page offsets and their subsequent use as
> > indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
> > thing with these but we are left with inconsistencies.
> >
> > The vma_start_pgoff(vma) == vma_start_anon_pgoff(vma) invariant is true for
> > all other anonymous VMAs, but not these.
> >
> > These VMAs are also observable as files in /proc/<pid>/[maps, smaps,
> > map_files] but otherwise behave like anonymous mappings.
> >
> > Therefore let's make these VMAs actually anonymous at mapping time which
> > will activate the anonymous code path for mappings.
> >
> > This means we no longer have to account for this discrepancy anywhere and
> > no longer have to think about these at all.
> >
> > This is user-observable, as MAP_PRIVATE-/dev/zero will no longer appear in
> > procfs as a file-backed mapping, but the impact of this change should be
> > low as likely nobody is relying upon this.
>
> As discussed off-list, it's best to discuss the impact with the wider community.
> I'm afraid not many people made it to patch #18 in this series. :)
>
> I don't expect this to actually break something, but we should be clear that
> doing a mmap("/dev/zero") will no longer indicate that as a file mapping in /proc/.
>
> You could mention that e.g., criu checks for "/dev/zero" mappings explicitly,
> but will just keep doing the right thing once this is a proper anon mapping; we
> expect similar use cases to do exactly that, and rather check for "/dev/zero"
> only to conclude themselves "this is just an anon mapping".
>
> Doing some digging, AI raised that there is the potential of some workload
> explicitly using "/dev/zero" to get an entry in map_files. I think that's
> essentially what our selftests do that you have to modify. I cannot thing of a
> good reason why someone would do that in their workload, and at least AI wasn't
> able to easily identify any such users.

I already fixed the self tests and yeah it's not very likely.

But as discussed off-list, let's defer the /dev/zero stuff to the next cycle and
get the core of this series in first. It's clear there's more discussion to be
had there :)

Will respin with the /dev/zero stuff peeled off!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

