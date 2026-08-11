Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B4AC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947B36B0092; Tue, 11 Aug 2026 13:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA656B0098; Tue, 11 Aug 2026 13:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF356B009F; Tue, 11 Aug 2026 13:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBD46B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:07:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99FEC160151
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:55 +0000 (UTC)
X-FDA: 85089620910.23.5A10702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D4FDE40015
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:07:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1xgmaox;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcUYlebditRzXC8Tsb5C2O6sXfnUZTaYua9dPwxuhXY=;
	b=OQZaasT5RNz3t4zCBF8YYqg0dbySatfG9/Z+2OuvgZsfaxm5q4/V5FSkazOMqzErdguQ1H
	r6J0ibiYWQrQIbYLaTBPC/c+cmjt3SGNZQcIkr9HCt6Co13QXb3U3JkBaehsXOY9VsC9C5
	rgJLtgNYTr4A7ZojgNRh6dKNV75SGUs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1xgmaox;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468073;
	b=taNzbb2JEsBqC0Asapp8QHyKsgS42I9HhorqKTBgMkwCMQuf9AeGPyT0iDR6DvN30PqHfi
	bUoF7gkFqcFAZsBPCAgcJEcITDoN6TM5/VDcUOV22fh/XoTViKzDnyQRoWsXWoWtLIapnS
	q/9gPdaFB7RG6DNZ3rgWcFLH7T7Ljz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16F5160A5D;
	Tue, 11 Aug 2026 17:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1016A1F000E9;
	Tue, 11 Aug 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468072;
	bh=NcUYlebditRzXC8Tsb5C2O6sXfnUZTaYua9dPwxuhXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C1xgmaox6jM06CGbziwMMosyDYBUOxTpEKVdUxqsjMb14qQpEqq0l8Z7LDdXDoI+k
	 EYS6GIgSdIliHA5P9w3vpAQ75xrU1chQdg6B0MrUXcQ5lEI7JDDw+Twpk3rO//8lL2
	 umKh5RWQVoNpFm+HDDcXCJQxu/3B4TFo3Z5wao4bzIjH+LM6xL/QMBi7BnHS2+M41u
	 H/IhAZksx8DpVJun5rI8l95b86r2Gtbdq2O0KbwOd8I9AeXYDfWohPCj659l3Qq+cJ
	 9OqNbIptAelwblof6H2ZzsnyzFAkBFWY/i8bHlEhc1VtgTpPZ1hap7lJ5PxM1DefOs
	 P6gBwv8T2OsPQ==
Message-ID: <c7930f14-5978-4709-bac2-54950c988883@kernel.org>
Date: Tue, 11 Aug 2026 19:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/20] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4FDE40015
X-Stat-Signature: rei6a3kmzbfep4dtr4uhu9ie4rgy1jh6
X-Rspam-User: 
X-HE-Tag: 1786468073-465313
X-HE-Meta: U2FsdGVkX1+4TZAl1TSk7p97zyrnPWQ3JUMvT/6J3BLpw0s7k87AHKUrxP9lJZNh5OS8ZRJX22eY8m/hSUHATJIpQqXXErffbwI3dYHgcN79X1Zwo7c3YP6YV9IRR2/8uOVqkMMZdnp0T1P5xHBBTYfPH0KEyoXJU0k0G9U3o6pbMw8oRojooNsAWHvH7C06UQszll70fSrwoSx5A7agolSR02LTNgchFhwPK76pJl9JnbQMGVtFH+yTdGPqD0sTffgkbG3aanD5khzWArXAF3ku76J6hxD5BToHP6h462CJ0Dk0PianDnZGQ7xG5ehsakWwoW0h/N19Il3n8GeEYuyCqwA7X326UQ8sYxj6OcQyPpG5g+RlUm0t8E7nu5Htz8HR+T/ruoIBIr7YGQiUVIYQbZXQHCQYSirB3mQVIQ41MDxQeor0iSrBAF980NU32QHgCGkHk6bU4FZFEPdED85Yi7J0cUPS7vMVp/sKOou56pu6PVynq+5aG/h/7iwgcQA5DHKUP+f4t2pxWRRsaektaICu/Ux7mVHG606AVCeegwnzFxkEpXzRPr4LpChU8v8WR66RHmG5QmopirUHRnxfUfz4mqm9ARnlOwoniLYklHioGGfg5JXKmXlCw5KYEVv717PM8KKLDpvy3VTdu15QwwLmZbmIpu7iwYh81g1KaXnZz5bWZt/jafUoq87ut2ZbB8IAxCtT0APpAO0AwRwK+sq+abwm+KCrIm8xxJoN5V30DTkyHuGf8Ak0WPFDSlrKvt1eG8ecZHTUDIDgMPoVUAsSl3vlXTIN8AAmdYW+mMu0/qGjJ3gWIGvUEGV1xKYKrDLZvVSudAFgvF7e8mVTse2seigecLGI2v8vasdIiSEsfhSdD7cxPlrBPmAKW/Nnvw6BeuaXb2mk6ij/8sbZebEXYXw7TIMvuABdsmx3J8VZy5cPFb9gVD3cxs4w650N/9/UEXPB1kTvuu8
 Q66Ax2UW
 ejx+UEa1yt4W/orJ9DrQgbyK+JzK5hZEq8wrr1Qe2HASG12Xg0P05lO2h2DXm679ni0+dnzumJjNfR0gQGPCe8HcFCPHSIlaOQeBvBzXwnxnITSmHLdCm5Xr7B+bhPvQow51KU7gJHN18WTRyRBZ3j4c/xL161D4Ttop0Ql4+loPZH3oBU4YAM4Vn5EnCz8uilOMNTS/xzypJt2CD1IVrVOfKxyY3q/23f4+faQLQJb/6f3aMh8DPowG8XzddSKT1/isONd7uSQCjHTX6WsDHSOsB+mvBCssaKM6sECWb1jgotwDkbjYBEwIvJeKeaAwSst7on19gjXcwmI5LQhwYfHb8P4EACXC6iE7k32AcYwqV71bJpc8kSoL4aMG8e8X04NOYqMEwndyR1loun6qHUne8nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
> without the success_hook hack we explicitly permitted mmap_prepare handlers
> to set NULL vm_ops.

The sentence is a bit hard to get as you are mixing "with" with another "without".

> 
> However this is dangerous and we really only want to allow this for
> MAP_PRIVATE-mapped /dev/zero.
> 
> Make it possible to explicitly identify /dev/zero by setting a global
> DEVZERO_MINOR device minor number then explicitly check for this in mmap
> code for a MAP_PRIVATE mapping and only set the VMA anonymous if we have
> positively identified it.
> 
> Then remove all ability for mmap_prepare or mmap hooks to set a VMA
> anonymous and update mmap_zero_prepare() to leave it to the core mmap code
> to mark the VMA anonymous.
> 
> Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero
> regions. Doing this would be broken in any case.

What exactly do you mean by "nested MAP_PRIVATE mappings"? You mean, reusing
parts in other drives?

Do you mean things like ...

[...]

> 
> An example of this is drm_gem_shmem_mmap() which deliberately clears
> vma->vm_ops before handing the VMA to dma-buf. Cases such as this will be
> updated when they are converted to mmap_prepare.

... this?

> 
> Also, in order to avoid a single commit bisection hazard, add a temporary
> workaround to set the VMA anonymous only after vma->vm_file is assigned in
> __mmap_new_file_vma().
> 
> This is because vma_set_range() calls vma_set_pgoff() and
> assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned. If
> we set the VMA anonymous early then this assert will fail.
> 
> This is removed in the subsequent commit.
> 
> Also update the VMA userland tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

[...]

>  
> +static bool map_is_dev_zero(const struct mmap_state *map)
> +{
> +	const struct file *file = map->file;
> +	struct inode *inode;
> +
> +	if (!file)
> +		return false;
> +	inode = file_inode(file);
> +	if (!S_ISCHR(inode->i_mode))
> +		return false;
> +	return imajor(inode) == MEM_MAJOR && iminor(inode) == DEVZERO_MINOR;
> +}

My brain is a bit slow after digging through this series.

We identify shmem, for example, through shmem_vm_ops/shmem_anon_vm_ops.

So naturally I am wondering: couldn't we do something similar to identify that?
Like, checking for zero_fops?

> +
> +static bool map_is_private(const struct mmap_state *map)
> +{
> +	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);

Can't we use the is_cow_mapping() helper instead somehow?




-- 
Cheers,

David

