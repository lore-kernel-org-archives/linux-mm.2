Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EAE606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IeVLrVCS
Received: by kanga.kvack.org (Postfix)
	id 4D8216B066F; Thu, 19 Nov 2026 14:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489016B06B4; Thu, 19 Nov 2026 14:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377A36B06BC; Thu, 19 Nov 2026 14:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 165B66B066F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:44:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA969A03E3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:28 +0000 (UTC)
X-FDA: 85452895416.30.3F1A858
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A877180028
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:11 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABBD34740C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0A51F0092F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117449;
	bh=sB1Pq7vBNntqu94r/2oUTzxPCprX1DSImM5jhZ6L7Ys=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IeVLrVCSsRPiQX0drUz2UWM7wWQUoOv9UhM9eXUGEnnoMcl+sQW+qiCun3+CTmWkV
	 mi/z8zorQ0ZxXwChyn2aP6ccRSaXE9uwamxIHeos9YGbYyFT2rbjndXO694GPBly+2
	 6KuZK6TJIwcGzxnyatmp98KHy8TPz+7rfIzZRNZp0T5Li9IYVmSLsp8gOT9puZ22bv
	 xvd0gn6xaYu+9VYtSV98kfDQkkgDxi0n63CKvmRsbGvvKr9aiBgR8OVAiNJmkLOF0O
	 2WDCxDrm02ztgXhsgGUGkmjZPeUM+3m4wl+RxhVKX+MYCKfabM6JTsL9CTVKC4O29a
	 EBOJBLo2oZtzA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-94961bfe1a0so10606985a.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:44:09 -0800 (PST)
X-Gm-Message-State: APuU4Z/cBfstZPnpRCsxv6AdUismxzPRInNS/sEzBWq3vDBi1++jNPSC
	AbB6t6NVlL3I9BZlXlx4rUvCDAQtKelYuLrKSe2pBasj97vxt0Oodu6MmvGqiHSgP12ISEjRbQA
	oMQlsf2VuuS3wDa02RRq29z5/x7NM3TU=
X-Received: by 2002:a05:620a:130d:b0:943:f301:49b9 with SMTP id
 af79cd13be357-949bab32ac3mr114181385a.53.1795117448550; Thu, 19 Nov 2026
 11:44:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 03:43:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z93rWEzqAQ_sWWVKbmQ5M3qjxX4o_qYzeX3xs+=2V8yA@mail.gmail.com>
X-Gm-Features: AclHuK83S9SvqTl7DWMa7lyKfrDc7jrgO_opWySalBDGVE3ZIlzAIZT17fPF3ZA
Message-ID: <CAGsJ_4z93rWEzqAQ_sWWVKbmQ5M3qjxX4o_qYzeX3xs+=2V8yA@mail.gmail.com>
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1795117451-100693
X-HE-Meta: U2FsdGVkX19JB7wPQZBGJEYbmsmIBzJW9fPdbdWC4v1eQmXnjw/WUakrfg0U8Gcc74rBqorD+q/oRjI9iHYmrSRNlHgOtakpc13uMmPJhkwdUVOO8RLFimRDbBLBAPH8UCvF7c3z7hZQxTZegCRDd92c1Yxn9TOQS+RmA/si75gK8xiEhlJ4/eXumX2FoIsxI9XyKu5hGxhOeyKH29bqrjPZ1BSEkhEaZwaQWgST3uBRa4jQw8ks7kOU09sCn6s+Y76yu1Uoe5WiaeAsuNmuqaN4IIRZUKuOHRf1wWzknw7HUNAH/koMQr1G71xj+irKFRsapgYFU1Kg7WD/wGcrU1zfxvZ+boWzRROYWoSyBPLwV/w/iOmQQ+i5me+dems3ab5xU1Xu+jt0mk6Gni+yyILaC9mmVQSZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/mm_inline.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

