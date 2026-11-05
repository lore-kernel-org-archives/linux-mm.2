Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F059606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=STk28X0f
Received: by kanga.kvack.org (Postfix)
	id 0D6E16B05B0; Thu,  5 Nov 2026 02:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087FE6B05B1; Thu,  5 Nov 2026 02:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8CB6B05B2; Thu,  5 Nov 2026 02:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4D576B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:38:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34F061C3ED7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:38:35 +0000 (UTC)
X-FDA: 85400262990.22.F19F94C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E78BC0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:38:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STk28X0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793864313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtxZIHT7OSRlVekSLEKMKnbDe94Yb+d+zJ7oVfsal88=;
	b=HKrMQNLockdvjLy6zu1acOYYaKFZgf6gJpJL2fX3bMvgV/SjBdWTIma3YQlcBHwPj9cmmO
	KEk4gif6cOe87F7EOr2DIcMMunb+dfHMOLVCbqglGLQj5MqKIEEgDz9bR+igKsNLiw4Mqm
	pUBJPon/kHipn3rx70VmC1W7H/5p2M4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STk28X0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793864313;
	b=C+O0WBAy0g9mZCQ4UU7AJtR2QDxAUcpWvw+imLlJyfEh6//FYZB0xwETKvA0/Y4Pt/VpzM
	VCTpyzGhKlfAWr/oh/o4DVGgBsG5NtEAStEldHACdkg9HFDbL06wwOQccHJiUbBxviM2f3
	dlyr8ULxeOm0H+gScuWdCRZiQ7ZaJbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1CF943D57;
	Thu,  5 Nov 2026 07:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9173B1F000C1;
	Thu,  5 Nov 2026 07:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793864312;
	bh=WtxZIHT7OSRlVekSLEKMKnbDe94Yb+d+zJ7oVfsal88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=STk28X0fF6Y909TJuiOHUWcubijSHv9nAkp7aeBbfatLxW3q3DdEJaPDaTpMInw4h
	 e1snbhiu48GpKc00lTPFIrmHdv8Bw6prdaZHWXbjYw2qUTAQ+Bf8rJCxuVyol7DAnU
	 pij1fHUfR5rzYK2AKZZiP79iXkCz8iNyjbC2rCrpPCy+PrrfiKdWlJJrHl99RBG5dc
	 uTFcrvw93TpcQEFs1pEg04FlYOSngrezMHDSlvY1c1vdM67z4BfSOA4Ir6DD1LGM0v
	 uZO5MWs11lVV6DMHl8g/0fOApbMcLt7wvE4Il7iKqSrOEih5hDnYiYvhXI1XrIwrOv
	 nPHmRmaMwxNpA==
Date: Thu, 5 Nov 2026 09:38:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
Message-ID: <auwya6Y_jAkTmt79@kernel.org>
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E78BC0003
X-Stat-Signature: d163b3hchzp8mygnn5kutmrcx9q5kdfm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793864313-190069
X-HE-Meta: U2FsdGVkX1/cr4RCloL03Iy7AZxk0CwL2xl0T3j7S3HljzGcGXPlYXMYebNyxHDZOeVBjx+JFXjR9PAGaAYnRdeSlLOrZESGXOy94UxjDOgCtDzHCGLKr1K96ja8pABweHcrR1AFl57TqCZfL+h0/IPLVv+aAlyM8e54xhuAF7PsOUkttFnkzFgLF/M9gRLL7flMhEevh4cqz74wOaeiWLtfoQ0Mu+extLgELzn/Ouevldxd6fZ2hLSDyPkS+oWy3CX789EiKd/1mHb17Xyx0jWp4PHqAs20VOdCV96r5pMpJzURJnw1Db5kk7gW0yroBhPHuuVs7svKD0qklBbHsn3rIz3Mwjg65K7/WHqq/lCeLjUlxFoa1SHzt38Nc5vV2FAdMkO3MFK161Gsq2xL/iJy/6Me//n9Ia80EzWes/xxfuyc12/FrVIZx2nQCL5Bp4QJ3d9G7UROb0+iUw98fbsDvBOC6mc/QH6uLQja7t2g9MPHwGVLPeLJNcaX5+WD1kgKFoRXqs/ycD3dyh2uFw9uYgX/hXCohfFk7FvoN96x4DxnBFOHKZkt3Yi13o+QbIYE63tM6jCl3WthbY72e9MbqTnX8+9xTFrg9llLQmNN+nUf43hx9wx+dhHwSlVdAsL9nfSOUH0gLoF12gAw06XW6rFB4mauzR2+ekkM+Lx/JfrMiRAulL+lX3orM5kYjE8/EWuhiv865PeCtByQZfaFvey40N62MbJ/ZsxSzALZQIKHoXO0YtTt81a53P7UH4QSKNtBfuaS98V/j3JGc60SpnRGMh63ZLkF+nYYS91OB5PvlLH1RL2fj0E3Ft0bo3x6Hb4JkvbAWVwg/d84vLy/ZNHd1jcEnv7rO8NTdQ2hvkTBqG56FDwdt9VtF1/aUG16C16NcQJwUiTIlxBrWrCqmXljpMTi/vNUvEmyOB251OpOE/wfCY3r/CDFolstQMyI7pvAn63hFhJyYkn
 jlsUlf1z
 WoCZjWy+bWzaI8j2vKP+az91qdaIotDGnSeI+FNGKXqzzt5AULhHXmg5EV3jncU/oMrCiK5oTOuOHSsFazx9wO62xwfv/21Q9a7tLh9XbfuV41O7bKM0iCQ/ESQywlD4ZxYshDTZeCI1KKxqLWan2cUfX3ZFe5rG6OaipK1XgdiNqrmOQ/7ULTcPx/rR2xvE/Rir9Pl9mVGyhVantmlo98Rr14PnL8WIC89hhsQ0XlPMxHzgNgG6u9R2QA2WwDmqzS3HsIVl79+ewIyhB2jz5qvtBegH8JOm2tuSQQEyNHX9b7ueg06TCqBBjD1adCdhzVAo1E76wMkWd0QoRaGg0DukO7Q4noKU+C5/ouQA9z78kJN4TLnaF65KulA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 08:45:34AM -0800, Breno Leitao wrote:
> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
> 
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
> 
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
> 
> Keep the declarations private to mm/.
> 
> No functional change.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS          |  1 +
>  mm/hwpoison-inject.c |  1 +
>  mm/internal.h        | 29 -----------------------------
>  mm/ksm.c             |  1 +
>  mm/memory-failure.c  |  1 +
>  mm/memory-failure.h  | 36 ++++++++++++++++++++++++++++++++++++
>  mm/memory_hotplug.c  |  1 +
>  mm/page_alloc.c      |  1 +
>  mm/page_vma_mapped.c |  1 +
>  mm/vmscan.c          |  1 +
>  10 files changed, 44 insertions(+), 29 deletions(-)

-- 
Sincerely yours,
Mike.

