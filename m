Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB10606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C1P+xjqX
Received: by kanga.kvack.org (Postfix)
	id 2F7FE6B05BE; Tue,  3 Nov 2026 03:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF216B05C4; Tue,  3 Nov 2026 03:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5406B05D5; Tue,  3 Nov 2026 03:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBB266B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:45:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 821DC14031E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:45:41 +0000 (UTC)
X-FDA: 85393174482.02.5D05511
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0C8A80005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:45:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1P+xjqX;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTgGh75AKF7JtZw7sCDB/mISauV2EyQCWjbc+0T+Gms=;
	b=bVo3f5wYzrpn1rLwhKQAeajyheXC22scfji2mamAcXmWU1o4zJv9uvbZd9cxfpAm2KzxBa
	nRPAMkSAEi9vWl7kzHTvcqP6QdR0/YeRgOA7k6a5eOWHZgzA8qeb+9KhHekgw4Ym5pZ7NA
	42f6Zql9WO/ZPF3WFJyeuo5yPf39hs4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1P+xjqX;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695540;
	b=g9H8W2neinLCHf7u9t1onbn3d4LLzjYv0lcC/6HmuTsmsRA0ab8PfPA+I5s2X1dBaKfr1w
	IoOklVS+Jn6PSWP8dkb/8kP05yLs8EccVZLN5s5Je0cdJsCi8cmctRp73ZcMe6Jobek+4J
	iEhyzBkuKqfM81jR9a+cc9zJq8Z990s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79F6A605CE;
	Tue,  3 Nov 2026 08:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569511F000C1;
	Tue,  3 Nov 2026 08:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695539;
	bh=HTgGh75AKF7JtZw7sCDB/mISauV2EyQCWjbc+0T+Gms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1P+xjqXf/TXroGZhiYgYA0PrR6zo+kHIQkXIH4MJ9CRJ9tQyDRQC1xHaxX8NFpub
	 vYu2U7a4xQFnToTkslUPRO2TaaA36eDdyfkYuwLOAMD3GtSxwIY3TpsG+j1NpzweDg
	 t+8dn+tEAT80zamJNPIQ6Wk0TVVxB+hDgkf3VYDyJIz897kEkMjZK1uhSTlZYnVAhb
	 6zqw2u6NYc8zdZ8xIJIHuhMf5OeWcwWPzngaemYDl+vS2F3WW9M/M0LubRBHngAELS
	 WJXeyi/y0DmHjCLe8SPg1HmUXXFTKDQgTd9vkMhFw2jHKfy/huwPappK5UtknXyypP
	 rzqNjMsl3FMLA==
Date: Tue, 3 Nov 2026 08:45:22 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Byungchul Park <byungchul@sk.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Manfred Spraul <manfred@colorfullife.com>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
Message-ID: <aume40GKpYIoqEkN@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
 <b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com>
X-Stat-Signature: 7otfh7b17yz8siafuzta3ye8sobuws4y
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E0C8A80005
X-HE-Tag: 1793695539-849761
X-HE-Meta: U2FsdGVkX1/VOtqw4Afq/fQ863dRhCbCLMCjuAYx7IiuYzcg8XuEiaDX+7xchB2LCHFQOMeI2lyEwSsaCdYlhB2WokaaMYKEGyfBO1FJuW2XYkxPlGKtc7tfJTTaAdaQP0kvOr2Hl1LxUMp+xdCkVistV4OTQ8ENIsEbEENB5NoqZsVizFQju9+d3ly79UGenQRu+BBFewXvzEnwIePqrKP67l7mHeUEEGebr3DzTrSU+6VLVUt62S9ypANeiX40omoJyxivEBZQfUTZKIrUO1vY3a101OMYlXRlq3W9hlQU8GfB+fLM7X4xmvz8+I8AKvEo+lm6Ik+xfnxIPU1KhgliNGOq4BWlgrtyeEnl2k/kpNVWi747Tmaxu1kLEp6Ahu1VM/wxiWVh5YCm+sx6bEquWhjogsk9qVJS7fvCvfnnV/xjg5C8FIHbOHPyUdiH0hOUiIFT6idEd53/8C9hq4b4sW7kBBPUS8tb6B0L+oOA0BtqHu7KsoQifkUYBn0lt9mxKSkr6m+as2jSeWjkd5ZRioxcRjDa0OByyI4ssYX7NM4psfSvqtYcsnF+RQdnyCdgyvlClXl5+C/SVMhx3dJYsjsyKV+EA1b2mIgeSE5Y2Ij5cDpIqGiJODWsU8nRxJCYNAvoKAnKrz2O6zLyw7yID/rkAbX8zIba8ua58jAlFye5s3/LI35uXbP2T1T1u6mNpObT3hYGBq2YAOCXlu40OBYVz5rJiiMz74+xU7vNwzU/ziPFlW7iSH2A65Kvzy5IG845BMsgQ+Qh5rwggZWmv7NSqMM/xnp8JuAz2wWAWNVKmdWrtUlQYWeJRGzbyMKkogdJla2qEpqnqkT8Z5VdaTrIepm5+5o9AJDNW27N74cAzbLJwjft3lG4QOR5lsMKtK0i87dg2vUKQEFypiPErUE6VUxbhAatt2y+qSbbFPsbLKYf7rg2b15SZ38p37iPJapanuz4oz1lOtx
 QUG/o4fY
 0BL4rrjgldafXyJreIcpCmh+BcTLhRgs3wyknJ3a5F/c2tDz2G7Jpsl4e2DCm+dI9FF58NVPvd9TBh9UsG3LORdzhm12OcpEKBAMA5xS/arFNs3wu6jkyjGMJOdImmL0ROIooHiem/G8sJMQbmvoMhqzT4CpMN8q3Gnld25WaGl/sR6t7W6+jMZdDlK9nZJrfqlgzLsaxqS6dFgBvMHW8R7bxwRR9WEqALKo3vN1AnwNv1vsrwuRWTXVbbbJIyV2dqVZYT8DQktIU3zhFl6W3Mn/0NbtkkOMQGgm6iSfCOJoUSSvp3UOBVSo2QGg2MHb7RT+LL2MeDIQCudU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:27:22AM -0800, Hugh Dickins wrote:
> Okay: but do keep in mind that tmpfs is a filesystem, and often the
> FS folks make small adjustments to it, which usually go unconflictingly
> through Christian Brauner's tree. That generally works well, so please
> let's keep on working in that way (just once I remember holding off
> intended MM changes to shmem.c for a release, while FS were busy there).

One thing that's useful is keeping certain files in multiple sections at
once - we do this already for some mm/fs boundary stuff and it works well.

That way you can make sure the right people are cc'd on it but not restrict
fs's ability to do what they need also.

--
Cheers, Lorenzo

