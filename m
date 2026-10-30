Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF844606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNRLj4xK
Received: by kanga.kvack.org (Postfix)
	id AE1506B00EF; Fri, 30 Oct 2026 19:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A922A6B05B1; Fri, 30 Oct 2026 19:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984B16B05B2; Fri, 30 Oct 2026 19:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF8A6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:33:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C84C780789
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:33:36 +0000 (UTC)
X-FDA: 85380896832.01.2FBAADF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC61920003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:33:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNRLj4xK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793403215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPRSfo0QZ75Sz+slqG8MrN3zVsMn83dh2upfWeaLirk=;
	b=lJ/9pAr34P4ImAz/3idM4NgCkChB9XqAB9UiW81OZt1/pQBFIfzkKThh92Su5ogP811Kl8
	H3vca6DWPz/7sjbJvhde8Z2tHCxzVVSjYTpK5EYSbSfgwKiNpoSqdQiurfj7aTK0RRXigG
	pOI6Y5VkS0b5zH5y/O8A9Q/IlPvsPHI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNRLj4xK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793403215;
	b=CKwD1D1aNS6riltn5R4Mh6TDgSHfDyYFAo+/CwddfbLmYHvvVvfBQdjuuy81bjMx0tC0cl
	NsNHZW4fZViH5eF+oHbJHhkWxZ6XNt4ChwVS4BDkF8hKAbcNfnLYjWJwQ3VUfE+ib4xk2j
	86SMCwEd181hNDlXyzVm6W/VFvyCa3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA2854369E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A01F00A1F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793403213;
	bh=OPRSfo0QZ75Sz+slqG8MrN3zVsMn83dh2upfWeaLirk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QNRLj4xKQ+HaMG4zhZyywH7wyjerFa1yDX73ggPT/ytrytbA//bp87DyAR/59cy61
	 D88wY8L9NCkzAK0R6IhkT+og8BWvEaGiJ+CR5eeTtPI93LK/lmpXuPvU6jw/skuAqT
	 NnvVAFZ2rGxOHEw2dtybn3oh/f1li39x9kZrKMcuGEPLrS2XyuHn/NWs8GQ0BlPw8s
	 ilMte4aTnZU0bU52w8PSwJNNyKzClMP1XKF2CdlPTG+gMPIoRTRlzUh71yzZUA4K7H
	 GnsehYz4cc7Fy3DTADyMgaXdncaTEyR+LKXuNYGOn6mUA7IgSW5zgwNVI1Q4uMRlRV
	 axU6xN9FA2FAA==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e7ad9f78dso142286385a.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:33:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxfkf3Gm9U/NpqEvjaPx5KoOKRDmEKR+m7Bb3gi/fD+0EQb1B234mJyKDzfwnQjsNvvXKeM+teAGQ==@kvack.org
X-Gm-Message-State: AFq9FYL/hjnc0Aalplwvd4NF32fBdrdqo35oVX+R+nIuZJ7796ldQeoa
	NoIUJ++yuHlqMpUw9TuecJkpAj/+Ome1q+uCPhrc5nEp+FetOfQ4Gzx7NgDGg30g1QZqKG2FrJV
	IGmqXpYJfPZpTqwJReonWaLOBk37ABf0=
X-Received: by 2002:a05:620a:6a87:b0:93c:b420:c2b8 with SMTP id
 af79cd13be357-944217b4dcamr669650885a.61.1793403212815; Fri, 30 Oct 2026
 16:33:32 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org> <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 31 Oct 2026 07:33:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x5-01G5dim5OPm0iuw8V2naHwj3qZkOgogPcV6qp+xkg@mail.gmail.com>
X-Gm-Features: AclHuK_LU5noV4t1G-cnnOf_R0ik1wLzu3ZYmOCyMHU-nWfFHkqwyudGcBvvVho
Message-ID: <CAGsJ_4x5-01G5dim5OPm0iuw8V2naHwj3qZkOgogPcV6qp+xkg@mail.gmail.com>
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <baoquan.he@linux.dev>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
	David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Gregory Price <gourry@gourry.net>, Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DC61920003
X-Stat-Signature: wbqy4oqxkbaub78ja7879fmh4assyhg4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793403214-505175
X-HE-Meta: U2FsdGVkX192gu2hhvutxdmKsx/p6Wvs0qfVS9XZ79wIgz+CJj3wOim1zdwq+Q1oXXTU0T+xaiM/8tf4YiICqeDfQ60YIxeMSj45Q2ka5O11pPQFS1nR7hV/vv3efe4g3Nsk0Q3Ka3lVmOHa6D76yq4qkqv1aKLoFgZnyiqMKZP6PKuXSz8u8yBmx+DnS5VKoXiDOPdZcL7kIcKKbOVj24S4aCNfezYbzw4iQUMRZQgq+N0Z3Ad26b/0SvE1L0QKA39VOG2YbPyFGjy6BGcfwz4kwpYlMmFGc3ZqV0eJcNNXm053L6lYQrfu/atL5GSJLBug7u93E4J5HvINJprJDm1TqtX6AwuWAVCDSTH63Kb9vapBK8EcFkA2sYZLbn2lwXD0qBvsE2qNCb8IihfzZrfLRQ1NR0vpCSFn+EN7HQpg5DqIurEtP8v7vcPnxcBWhK5TxiCPkAV2PXYyMbv8Pk5hGzKAeGLk/JGTEqcbfQSnlgIW2u2y3B/eoRXnVO1cVzU3mV89SXzV8gGkByeG7gDva+v+Fmrxa1gAHFPbLXmNcYzzll2XUC6Stc5ZsNlsdcB14DAR9Evmb7hOCTeavGKh5zQIrFJv2jsIhfxk9kDN9X1MFGYWAGsLRvKnBvVYL1b1iLXoeguFnqP4wSFMxaUatVQc0uqootcA4Ct7xt2M/ufAEhQfIe6IKfWn3d7MqmpnbSD/GqW/kWzZbhLjf0kC816vqVFJVcAX6r2BHwI5t3KkYPNxq2qL0bUUvzLlLU8ztZ+FtswWR6OhDLD17qGK6xZOAc2SVTlz5H44Lg/jjlz41dbYbi8FPaeH1BWH2cPK2IRDazeDVA21XhsxHXA8RGH8s6GITWD1HtwZRxDIvj+EfTorOHahCXb/WSuOcDSDCJZGbT1zW6ElHJpoX/mpHZa5ofJ7mldQ5IWYFl8EuYT30k9a8Rvg5Np2AIiRq5wm0YHHwp0Gi9mGuLn
 bU1KR+bG
 Wk9pNF8g7uzGjMMy82lxLhtoVQPoOLy6PGUjgsMdbI8EnZF+0Pjrh27qjVJ64aVfIAV7Za+mn9v1bVeV84EJmHjUZ2FKzzBaf4NDpSF2diBRqcGqi/FGik5b97BAYKRWBnQ1AQ6tPJ92QqUKhqWUJZLu6Ms/WBczdB5tnpwn1Z83tlYpL08w3xgSsK3aOZOhL9P2EkgOxtTL7zu+yGyS1RX9d4vHLHD5CEOxteT8lOhuCn3/e0/Apm0xI50Ms8Xr9ahgiZqxjVs8WmhY61Qrx81G96WyJm2AtuoEdTWDWWQPZCgbrq2f0MovEIBwCnp87b5GWK7azhc3FdImvnu1KOVbLpSRkSTGCaBpuoGV2Yn8qBKfPU8aHGmnJjuj+TV/u3ZQW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 5:35=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP is

Yep, that's true. I've seen Zi putting a lot of effort
into contributing and reviewing patches.

> an especially active area lately, having a single dedicated THP maintaine=
r
> is not sustainable.
>
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.
>
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Barry Song <baohua@kernel.org>

