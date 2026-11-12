Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A64606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHTOA7me
Received: by kanga.kvack.org (Postfix)
	id E5EC96B05B1; Thu, 12 Nov 2026 13:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E361D6B05BC; Thu, 12 Nov 2026 13:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51AD6B05B1; Thu, 12 Nov 2026 13:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7F5D6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:45:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC0B7A8655
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:45:37 +0000 (UTC)
X-FDA: 85427345514.30.10C1D83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E46440006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:45:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHTOA7me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794509136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QMrnQVo4O5SnIGabJN3wrTnW6MusZ0h5giYV4GIf1o=;
	b=T+Q6zV0hpTUPMr0wWF7IbYjZATdT7jJIbz4rNTyp23xbGw3aqg2CXQGJbkv87grYxGxMdK
	vztZ09AKEWcFXeRm7iCXE9r/f/Xb7UsGnMgJ9efkrnnqMFeYkz2OOVZmxVGOTryYwGdGul
	SqbJuUeh4EOTmBQAOab0lG5kjzbdx7o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHTOA7me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794509136;
	b=0Lk0W7jgrdkYT6CISgOFr0izPDC7GPFSHu5oUhqXx+JmuChByi/s40++lrtS3xkbjTOfgt
	0139eOvMw+3VTNq71KsZbzQKEnURErjlvNtzznPKPvVo6SkgHwofIjfLYwZg5DxRQ9I0o1
	emPCgmKVuy3+Q8Y5MKh+73knjp9f4qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33A9543851;
	Thu, 12 Nov 2026 18:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E451F000C4;
	Thu, 12 Nov 2026 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794509135;
	bh=1QMrnQVo4O5SnIGabJN3wrTnW6MusZ0h5giYV4GIf1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IHTOA7mej2k1aqlGQe0o2vMpa5Gw7UtlZwRhFQLZhUTCPvjZO46VWVXtxm6J6aWPb
	 3DA2ss0NGpmaXuWwx3qDKIjM/7mIIpHQUFiHQ7rul2sbAYCgDUI/bRmUDwuzf6EvuP
	 9APyFHKZhwk3J4J7QsFpl5djiJQLpgor+vvJZ35Xmo8RtVotrYFuFGP8WmlO7kgFsU
	 8X4wJpKybcr5WqKLmdjUpPSVvmZv4My+ZLM1BpHQEc0/E/ehaBGmkKGVt/Vt1V711D
	 /4XVd6l+Os/5iSG4YtWxiiYY5FJ7ra3yGPlaTOAxvcFVzd0T1aJKMtBVEoGPFQqmlU
	 d2sk8BPTykwBQ==
Date: Thu, 12 Nov 2026 18:45:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 13/13] percpu: queue the balance work on an unbound
 workqueue
Message-ID: <avYJKR8fiETjd9sy@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-13-3d2454362e8d@kernel.org>
 <179450887590.482102.12180028123925629664.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179450887590.482102.12180028123925629664.b4-reply@b4>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E46440006
X-Stat-Signature: m4d7t1rriu58cgbmtfyzcfnwstw7xqnn
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794509135-632208
X-HE-Meta: U2FsdGVkX1+7G3meetUgwpW7Qv1axgXJ9838q53ZU2hLvLKCIae1zehaHWI6gyrrYKJi9BhKpvXiOTFRqKV7a5sPpBlJ+5SgudD3YnDtrk/g2biySHp/iEID1rM9lRslJvpsWUY0cSIHKZMiPqmkY8ZmoKoNmwwidLuzjsNFRUUccMKOqWtBcji2jyZFAk7yQ2tnzg/gUFLhlHTZWxQE8/zq3ZPdv8/+4eTjcIyxeuArveCRhlX+jXMXYZ7pSiA2u6oxs+B2B6BLY+lTQQsV09E0te9omxerIF4RTTRBmVLgcG7EfQTkcCURY3zNxV2NrkSICMW+ZkK48JjPr4OLqzM3TpdQ/HoqfavpV/5gCvfdxCsl9giWi3hGDITsn5Z+xzikWDzm7AmHgx4aD38Zmn7JtEPGNXn8oLbOpt+e4DtF2mThMyz2bhHdJRMURw7inAPNAeHdNcxx7XLJO11BNZ9fJMqx1K3dGF09WRLOzw0RDc/42sSnvDWAa8un9dTR3HRETALOPTkknTaxcYE/w8/3gViwHOFit8gF60uZEREXRFshMXaZuz94HuBh4EP+UtBLl3xUB4x3kENj+Fc5RMcdpBwby7fi7ah1gYyhJQwk5nOatHW8OOxVRtXYQk5fVoXbWQBbUB5AmRXWyyFWtGRZQbLsnY6PodKD1HHR9vekRvYnhqJqS2fepEuW6ZiuIxamcGSe81Lk6afDx/2s3j0bMaHZmvT+uUaVrOrXFXikqu/THorD3qNJC5AR/R+pc8m+IFVOGvAcAqlrVH9Afvt8uAXjbfdXbmSspyckreQNlFPmiYNRTE8gz+g4b+IMN7gbONZnO1piHZINna0l2BGOmjd1OAFuqcpQfIZwjPwxy3qkSI0A64IbYD8OHhc5n64gTdKpBAJ01NXDc5dxUuNCQsdIb5M3yCBRq60mUX5b6Qj8nOAL0cGe11ABK2yOwXCnnh6NFNQSqv8RJTA
 wgcl5yM+
 hHAMd/ujY5KNr4LgvjHm4vXMeVSVhzN2EtIc0bRQyldt8SRVlWZf9HO1EzoAEBqQVFc0C1DWoMhedyS3IJZw4l+Mbdp1gT5RDOpMu3op1nFZTlCqQZPg6PQGRNl2a+XZD4h0glCXe+hvs3CRT7ppQ7fH09J3Qq6K0VvEGpegIYNyweVz7rjiWUia0QlI4rry/rHc5p5qDiy4Ek7DkmUJwYZBd5Rt/05mVBlPaZ9cvU47lggiPOvQ8WNUO+hcLMMHOLaxKgMMw++tPBSFl1zS6t3khRNh59Yh5rZEnIKVDaH5oMT7WaCQHu9R0MkWC5YmAB7AZbuHtccazQJXe0T9uhVIkqw23kziQ/FG27UHmSBj2xo6JAPMwYU5tss0NX7SU6/w3GqEauW5b43U4ecdHTv2t9BMx6s6finMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:41:15PM -0500, Gregory Price (Meta) wrote:
> On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> > From: Chris Mason <mason@kernel.org>
> >
> > A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
> > machine has free memory and idle CPUs, as atomic per-CPU allocations are
> > only served from pages that are already populated, and those can be used up
> > before a worker gets to populate more.
> >
> > Consider:
> >
> >     caller on CPU 1                     kworker bound to CPU 1
> >     ===============                     ======================
> >     allocates 8 bytes, which leaves
> >     one empty page and 4088 bytes
> >       schedule_work()                   woken, waits for CPU 1
> >     allocates 8 bytes, 1023 times
> >     next allocation: "no space left"
> >     gives up CPU 1                      populates pages
> >
> > The allocator keeps a few empty populated pages in reserve, and the work
> > item pcpu_balance_work refills them.
> >
> > pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
> > worker bound to the CPU of the caller can run the work item.
> >
> > The issue is that the caller keeps that CPU - a task keeps it for the rest
> > of its time slice, and a softirq keeps it until the softirq ends.
> >
> > In that time the caller can use up the reserve, resulting in an atomic
> > per-CPU allocation failing.
> >
> > Fix the issue by queueing the work item on an unbound workqueue so that
> > another CPU can populate pages while the caller keeps allocating.
> >
> > Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
> > Signed-off-by: Chris Mason <mason@kernel.org>
> > [ ljs: tweaked commit message, comment ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Reproduced with a cpu hammering atomic percpu allocations with preempt
> disabled. Results are pretty cool.
>
> In about 1 second of hammering allocations with the full 13 patch series:
>
>                         Base       Patch
> Successful Allocs      1,188      131,072
> Failed allocs          4,097         0
> balance worker runs      0          169
> successful retries       0         4,096
>
> Micro-bench obviously, but pretty stark difference.
>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks, that's great!

I will include that in commit msg on respin.

>
> --
> ~Gregory
>

--
Cheers, Lorenzo

