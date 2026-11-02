Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D493606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdQKeJ5B
Received: by kanga.kvack.org (Postfix)
	id 471216B05B5; Mon,  2 Nov 2026 07:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448616B05B6; Mon,  2 Nov 2026 07:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3870A6B05B7; Mon,  2 Nov 2026 07:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4C16B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:34:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB12E160AB7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:34:03 +0000 (UTC)
X-FDA: 85390121166.27.CDE82CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 276132000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:34:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdQKeJ5B;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERFb/4pZagHFCs7MRUpaYMoBff9MSs/0QNXJcVIpqaY=;
	b=5msl5x0DNHZ+P2dXsqtWJmHOc1E5ZoaApSISKqP7rMhVxoNmaAHuJEZuyyI/OXhHD2398s
	hdpysUcDFvid1HZzB8/8rX+BPRrA7+obBSvXR9pzlwiFEn37yPYUNpzNj1tiza527uT+kQ
	SnWPcHpMesNK91kLSpagq2bkXVH/Zik=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdQKeJ5B;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622842;
	b=cmL8oTHcNXozy2xTV5wr3lcw7kQOVR6g3IOsS3r0vGoUlPZftk/31rHICkA/ZRgdoZyyUu
	oz1xg+87FQ93tJLmLkLZgPZSKSEiNTv+jABlRv8fvqRSSJF2Tdz4hgxprenqo86PEVW80Y
	0+gHrRORW13Hty/zMqnKgV0y9MOcWnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98F7D60618;
	Mon,  2 Nov 2026 12:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB211F00A18;
	Mon,  2 Nov 2026 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793622841;
	bh=ERFb/4pZagHFCs7MRUpaYMoBff9MSs/0QNXJcVIpqaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QdQKeJ5BsIoDlme6gNWtDqK6f3GwZCgeYN4gIySuQv+cPn7TsIVM5wO7gl+c9Tqo/
	 fU6buhP8+018nyBI7CmJjMfFZXWX5wKctuoNCDMhxxirKAgJWySavZW73xnQBMvws8
	 +RDF4uEuX5kTlz8k+zWcxK1UJQ3jgIi6nZlBz+GbEZ/DhdgTzsm53pZL3+lw0E8J3l
	 HgODW4TTM/U0rQzrzD066C2DqOVsIqEdYQAV1+/WnY25jOsjEP4Cru2iEtYb7CWZE7
	 0VumMjVk7tcHNAOTch/ScORa7POyfsl35S4dFeRrETxAttBeOGDCuIDIGE4Feig0iN
	 2UWCeQKC4VL0w==
Date: Mon, 2 Nov 2026 12:33:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alistair Popple <apopple@nvidia.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-ID: <auiDADcPkGKMf2Sf@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
 <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
 <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
 <auhw4mBAqzKU_-DE@gremlin>
 <4adcc07a-2df9-4d5b-8b0f-6734e336182e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4adcc07a-2df9-4d5b-8b0f-6734e336182e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 276132000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5zed8bgfy4gk6wph9e1fiwaqhsir6wej
X-HE-Tag: 1793622841-259205
X-HE-Meta: U2FsdGVkX19PwHpKk6psC32QK/7XhB+JpsJ+FKgzREsKl9Ky4727nLDrJMd+vfzincJLdxhbvskm684vQVOqkVbZuFtNDN1DZLpDd9J4+UVrYikNjYibqm1uUb/BPRR/iQBEBXe7S9B+nL6r7x7HprOXLl7H05tRNxMH1um48ux/alZfcCLCT1KCfUwoBCeA0hKGujlMm1qymiMgs6zBOq2rA19O9ZnNxF3KkzxlaLVbPYHPAtN+WbiFadziSqflM62GnCoeWBISyjE7fkqPE9d8nluQxBQj/uJ5wRyLRG7WnVBLb02BJ268b2um0cwUjP/Z+vKC7Mt75tboyv7BSPlsknwTahtz6cvGjpx4vQQhLBsm83dhrQwHPLjdNQyEaFdmclEpLd6GCvBVnqEgTPGPChte5e8Zs9QQoZnqkhV69ODMuU9bmVuyNLauysQ3DAcUF4J7mQn0XXPeY56Nbesd0yy8jXw9qcDwfwBP0X3KCLyog8VvTKj8rt+ZBKTI47i0gbGPTVqdY0HBFc6LOBFOkc4ycMhXtXSrj8jMRSOpEvKFovPUgQOnGF93tEtp/xcLRxaTu+BIDyv9L56WHMNhdV3/XqZHTbd/wdgt7y9fbYj/0VAcBy0KN1KMp5KqyJIczNSpFTPFqSD81vpmLX8bhbUTX69QBvcFXNrnEOvygthKD/P+Ft5v96EQLc3ghx6Z+2DsZ1E5yStKs4RdPSxAJtixCwUji4aywYoO+yWPocSYNUYVWqiZjK11suv7wCm4LxaH0DMXiITM4VtjP1kGen45ytFMjC7hsvRkBbiGKyKOc9gbsb7vsOWmhmb0WXQmq+5JxJipfzqoxji8L9YTIonG55RH/n4+0UozfGNqfT6ZLDeythi4yJLsQDg9U2L60eRH1K7uwdumwk4jTzLOE05GYCGJ+qki78jZPTICf0EgC6SwJqk5GTyXBl0GeOwcuqLcQL54x5jNp7w
 0NAUkEKf
 KWRqb1rLr0cNVRbnT23czwSIafXhbsgHKOj568akBPXcZB1xK8Mymhn9oGIOp7Yz1B+2sxGBE0gAkdPH2JLwxLG0gtSFV4egB0BDPha0jHbxVjt2EXUf7DNErBe41zyzQVIKkHszmrZOWskPlJqqtOLmbA6Zn5u2r4BxjIoZ0PXBfzniByx4RbJ86kyCMI4qWu2pnUVrFh4b95otMbbPRN9LzduC07QeKpqnz7LoUvk+eUClH57koggbEkcHeNBko4QIyxacCPrOn/aOSDmTsjyD7wUYJbdt4HZt0BItowmIOCELn8+GMzdjkZB3zLczB/YSvVWLPQ4zQ3To=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 01:32:10PM +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 12:17, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Nov 02, 2026 at 07:47:46AM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/1/26 21:30, Andrew Morton wrote:
> >>> After that I need to have it whack away at selftests, shudder.
> >>
> >> I am not convinced yet that we want that for all tests, which is why I left it
> >> out. There is too much churn that's not really relevant for a component
> >> maintainer POV.
> >>
> >> I was rather thinking that maybe we'd want a MM selftest component (likely for
> >> the later MISC maintainer) that picks up the usual selftest churn. Component
> >> maintainers really only have to be CCed on functional things.
> >
> > Hmm, but some of these tests are establishing important invariants. I wouldn't
> > want somebody fundamentally changing what the guard region tests do for
> > instance.
> >
> > On the one hand the churn (especially now) is annoying, on the other hand I can
> > just ignore mail I don't care about.
>
> Well, as a listed maintainer you'd be expected to pick up these things.
>
> So I'd much rather have a dedicated selftest maintainer that takes care of these
> things.
>
> OFC we can still add these tests cases to the relevant sections; we just have to
> figure out who will pick up most simple changes.

Yup, files can live in >1 sections at once, which should solve it from both
sides.

--
Cheers, Lorenzo

