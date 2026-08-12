Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26676C5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 17:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E1D6B02D2; Wed, 12 Aug 2026 13:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45B16B02D3; Wed, 12 Aug 2026 13:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B476B02D4; Wed, 12 Aug 2026 13:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B90D6B02D2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:18:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 209991603FE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:18:03 +0000 (UTC)
X-FDA: 85093275246.13.D4F74FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 504A2C000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:18:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PqOPKr1U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786555081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORVjW2+uzGEZ3P9C+o+jbVG9nyuLf1KgGswOIiDbPpU=;
	b=LxCy05bMQYz4wfDCY4LBKLefH5et+R/HRoN1jvHdAqjFace8I9m/Qt+XrNf+fO62LfJ9/p
	YwFZvNJ0iKz8leM63YM5soCwbv8HonD8KpZuF5BKrnqFD1ngZgEvAysFiFHp97nkn9fg8E
	wgb2rrISvaJL36jfdLp9MmsoOwSCd5E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PqOPKr1U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786555081;
	b=x3lmTwj7UQ896hEexJfx7JQWkrH3uBBe+mD1exvlvYyK1kGUcW/a+2coNkhcSNFT8ZZRrP
	QWYN/8vYPmitUl0AaSaYWrWAam5CDKz7e08RDlLDKaxSRJ84b6oel76f0ZiqLgoJJ1Yl3d
	ZPGS015rHcTEXAR5vGqJC7ijqnCNHp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FC9540317;
	Wed, 12 Aug 2026 17:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AFE1F000E9;
	Wed, 12 Aug 2026 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786555080;
	bh=ORVjW2+uzGEZ3P9C+o+jbVG9nyuLf1KgGswOIiDbPpU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PqOPKr1U5/Zq/Agb3zTnII31kLHupSik1RfSnUbFYYJxc/LOWQA5OndnLSlUrwPNe
	 TYSzKj9S+0Qdc2Q1gyaM4kyDT9CQBarGPj+5FLHb/JsSWspuQ8Pfc5iIUUiZ7+MXA1
	 16JtkYXjjCOcDhxarJebImOL+ify/0dGzPawerSv91sViOfv2uYxFsF3632WBw9LMW
	 is9aol95hYPNTHbXpseyT308oBoiSv1xSoEYR4GY5olBVeew0/AFjSHvgeC616xXK3
	 zyED/ApTUhikIHDO1E9ansj2GKB5DZX6f0KX38OwbwEGfQusq4zozJXxxC6phj9ODs
	 l1WxGP9jFFnlw==
Message-ID: <5d1a35d2-8541-44d5-8958-1efa9773d7bb@kernel.org>
Date: Wed, 12 Aug 2026 19:17:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/20] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
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
 <20260806-b4-scalable-cow-virt-pgoff-v4-19-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-19-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pn4534xhekm6q9o5fkbo5fshqf41ijm8
X-Rspamd-Queue-Id: 504A2C000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786555081-42763
X-HE-Meta: U2FsdGVkX1+sbeEFU/uycn1p2zGfIst0e8FIzs8725ioG8dqa1Q09vuI8qShFoWUKp4sVVye7GScKWUetVSQCHriJdvqXPonTg8zBU+V0euKvH/J/JH9ajsxAoP2wikRpKCmYMDHVyRr7RWL/Da4qoWvAg4xL6FHNVLA1cysGLqBx4wYwRjrC5jiJGv1Z4Wo9RTWUywEkQ5ZLh5ulVP3/xDtDvgtoVY5kSEyR00PHaCtvczzDdthfWV3ma+SMOBEHbCYbWm3HpALOXrLaGpLvM4uhp6FlEJJlO6akCsWCYdvff3IQqE3+NZB/9zenJy4loPHDvGPIwiOcH/ABip6+XZJEZkwSCGiM/P8ajgI3FEqW+XkNClL8+OenXBbfo0gdwT8affzglfHvRzLvKKRw0Y1YMc2FV/5e18CNL+RLV/km7zxsVFlHp4xK2WNZeOaORUJmKcxW+W8Hm3+TXPaJbtamS7zoKF6KLJ3YC1/4J/zHjFkrtCtihUFaPp8d5r539iArXzWdPcLO4bKoRhds7S+1ofDAHQ3xSrDUv9SNCpg+IhEpDJGo14l91SXH4eSP27C4tWaME5egL6tDmZSJWeT+E0jA5h1Jqep3Hcp3pVUPuQeuYOGdDggIvmdvK0mOJDGTU2WBiMN3jdLpigpGuvWz2pDK6tAvo2bvPELQvVw7yO3evrOamSXemAAMaAXSAq1111PQe4CnXTfbTfXGt/0gfoyr+HWv9sT3ZtmN+YH5+GDZMP3Jrdes/k2Z0sBTP4KMDxgwqyEudV8L/763N0E4LnzNynp+t7+EHZHpPRphPol760G3lwfXmgVip8kjeiW4YwFJNLCXLkKZEA8oa9uCRLfPlrv6Pd36ATNitvIf4Mt1x6HVCKh4v4xnbVIBD8M8jJ31tixq/B24g+JeKD//LzVHfR+OzA9eZIYf8z0UeP8Wh7JxAb7HHrqTmJyeIRiGlAeFjtho5UYRVQ
 u7WZKgq7
 N+vAfpG2uniFJE3BBmABH7m3ClSN0zhG+L9HbNupgCjAZEW4OkpbmqnMvgoDhqsN/oPLf88HjiJvNhEUaw7SvftH7GebgCU2DsU4kFdJKJPl5Ic3njbLE5PhklLTE7MMKBbnP2nx3R2IIOZXtD6mxiiuJAi0mQOzsSMQkbU0sJuyMOyV25SPtTzkDcrmzz+o9hbmW+jJJ9GDvDaXDP0BsXE9arFpe2cniMBSS1sc8K9UgGwK9YuKMRZMLcj5WezU2ZMRTo94oqtCYBHerhICuifa7AcocnjXLV+/g5agVZk1W4TztZClGIu/tSkMq3SPHr27x3Zq6gjNH0rSvXY31mx9ysi54kz+AgDMyj2Wy76DqskrbqoEccJrMSzK+zM0faGF+c07CxAnftuaTha3UmuRodA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +static bool test_pure_anon_dev_zero(void)
> +{
> +	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> +			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
> +	const struct file_operations f_op = {
> +		.mmap_prepare = dummy_mmap_prepare,
> +	};
> +	struct inode inode = {
> +		.i_mode = S_IFCHR,
> +		.i_rdev = MKDEV(MEM_MAJOR, DEVZERO_MINOR),
> +	};
> +	struct file file = {
> +		.f_inode = &inode,
> +		.f_op = &f_op,
> +	};
> +	struct mm_struct mm = {};
> +	struct vm_area_struct *vma;
> +	unsigned long addr;
> +	VMA_ITERATOR(vmi, &mm, 0);
> +

When we go with a zero_vm_ops this gets a bit simpler (see schloppedi-schlop).

> +	current->mm = &mm;
> +
> +	/*
> +	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
> +	 * offset of 0x10, which we expect to be reset to the anonymous page
> +	 * offset.
> +	 */
> +	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
> +	ASSERT_EQ(addr, 0x300000);
> +
> +	/* Assert that it truly is an anonymous mapping. */
> +	vma = vma_lookup(&mm, addr);
> +	ASSERT_NE(vma, NULL);
> +	ASSERT_TRUE(vma_is_anonymous(vma));
> +	ASSERT_EQ(vma->vm_file, NULL);
> +	ASSERT_EQ(vma->vm_private_data, NULL);
> +	/* Expect anonymous page offsets. */
> +	ASSERT_EQ(vma->vm_pgoff, 0x300);
> +	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);

Yes, that looks good to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

