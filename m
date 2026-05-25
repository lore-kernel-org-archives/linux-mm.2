Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F60CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C687A6B008C; Mon, 25 May 2026 13:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40876B0093; Mon, 25 May 2026 13:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DD86B0095; Mon, 25 May 2026 13:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93BB6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:21:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50BD514017C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:21:55 +0000 (UTC)
X-FDA: 84806609790.15.59602C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BBF1BC0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:21:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G23nJ4o+;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ns+vixeNuP37BFGrljacUY/E2Axl/BTJ39BV75ZKyzI=;
	b=XuIAeReH1Dg5b9tROnW5pVxEtBZQAO4gzAMTout4qYuDXikcdAX7/Jv57GzD9dyKGkojIY
	YBlRnTPeBAAFdPt7aKivQL1dp3GUselljzkJRLU5AMGoU65USDbJLVDBBaHUfFav1IaWrV
	3uN9AcgsCZ2TCSMJ0dxLi63P/aY5qVQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G23nJ4o+;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729713; a=rsa-sha256;
	cv=none;
	b=a7eLIxGIfDF12gonarTI0v/x/M/t8j/iy2tKunKgaXGqh06liMEFV3puF2cXHkrqxNXXac
	AiRTTVm4GLlfHMLnHGzRyT4QDU7mhHDdOIFaCm7skE8PhwgddoUruoXxI24/hUbwQ4PqHu
	OETjHIE35tpfHd4I3D7f+ymGapvbzwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE896008A;
	Mon, 25 May 2026 17:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178DA1F000E9;
	Mon, 25 May 2026 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779729713;
	bh=Ns+vixeNuP37BFGrljacUY/E2Axl/BTJ39BV75ZKyzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G23nJ4o+2EDnvWDsMORaOOW4c+DbVz4GQFo63SKudkw36GZc409Y/KHX9j9sdpy1X
	 dtYIfPGIXKXzYsbdLoVyS1FSy6fc5MtMqEsmtKaYm7ES6N0MlgA1/b/T9FczvPqXgK
	 po0e00lCrGIDwP9ffxrC5auvv+hWIJ7e43jdfSwoZWBTRX6UYDG6HHL+v8ZHl0CnEg
	 A5AlUJZ2rmuV1hlKn50tXvZD/te5/GqwEJxM9LvUTGbFanLfC18GUYMXdpsAhDZOKC
	 9JMXC4yCAkbly3wYc+PWjltnBdtSzNJGDvDObXep3a2gg+KR4gfgFmGKlpYYqs964n
	 jxzaijAYQGGRw==
Date: Mon, 25 May 2026 19:21:45 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/69] mm/hugetlb: Refactor early boot gigantic
 hugepage allocation
Message-ID: <ahSFKSTBEMs3bO8T@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-14-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-14-songmuchun@bytedance.com>
X-Stat-Signature: gq69ahk793yoboiyycaz1stoe3xxxjfg
X-Rspamd-Queue-Id: BBF1BC0003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779729713-238534
X-HE-Meta: U2FsdGVkX19h9EtO4/npGaFdCzEHH6DIQTHyxRVQpRIkhtbZQGhDQNSXxaYOOmvzhOcI+quqdkM6kqw9foeQE6WSFanJlausZyfjCWRSrM7dQxludcRZCu7kmNWpJA6crnoTkhbCASpqZlM1n7HVChXxpL3ELO9sTZ0qevoS66zhgCBJWHSzAy5Q6xBTt/fITaeh/i3G0C14GwQOOrffJDmDKWADPX8gqgF/YSLTveZn34qLWKvPxbFkrmKQUNx8n5u42uDhywJfrY/9M8Deu2gWYU38220zteGKMAy2/jZ7y76mwc62zX3WScCT6CgRFTX+4PavdUmjUoHVWKCPtYmIaqyZHyFEd4A5heTwXNWlic5wSBRVjbUdSSQQnOQreUjJG4vzEfCx/bSZgb/KEwJacQU1CPeNfV30QeUI2VQBmCQBwbqfG8fipaCyPYPWI9CP031TsaMG+2LEsY9HgfhidnTP9BlKMYUYDqLLiYtOyWk+/nvdRZoB+SUqHxa67Xq7AVZVidKE5LQVmzCittgSSkBtK56Wc8PJFEybx7YSb/RxESEb504Yuc6x6OxUx9KJkGDSiHZylt2znSw3Ofah181Hidg7mVo7eE0g5SKVbzL3bRn529WiXzCs5mPPKWMLK+N1kzeVWdYs+veOjP1JBz/t7KhesGc5qfCXyTkWMSpD7iFcHDd2QPjqxjqAJk7Z7QN3SGMsqJ3dqkLuwWsBSh5DDdPpltQrHU1b8W9MHtg16bVdiNTY5KvYPGuew6Sl1dW3f38DubcnbyACQeV1qJQ7HSOYy3/KrBOVr35SZ53qiITx63M256SqKrskkY5N2bXTS6rMNzTPu6KT26dAZahJr9uAE6GVSValP6auJZS60G6UHb/b6jRIrfgB8k1Cnpwb4LVcgV513lmUtG+LndHbPYZtMa+qDC1zOMs/xezhdkTS+R1MJY67WxwlCh+sR1oRqjcJ+UTqRiN
 bga+42e8
 yt/wt5X4nYSI96vs8B2rPS2cpZcj3x0rBM8ZLq5ddxSG7j6kEuTJXVBI8fCtB+Vj+NRZPKW8dSP3EUpayp397kKGnIqt4hDCLmmYCErQylLOi2QGvOoszIWeOfM96RVto6oKMgGMjd2GZn0m1XDmx0R1WKW2SIJ2mr5s3IvA+vCzm7bfF+ofkyuQtIyvk+qDqaBcOqSEqNM4Af9jKnrdQjiVYa2rpHfR4DSTQDGQtsE8QeR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:41PM +0800, Muchun Song wrote:
> The early boot gigantic hugepage allocation helpers currently mix
> allocation with huge_bootmem_page setup, and leave part of the
> initialization flow in architecture code.
> 
> Refactor the interface to return the allocated huge page pointer and
> move the huge_bootmem_page setup into the generic hugetlb code. This
> makes the architecture-specific paths focus only on finding memory,
> while the common code handles node placement and early page metadata
> setup in one place.
> 
> This also lets powerpc benefit from memblock_reserved_mark_noinit(),
> which it did not enable before.
> 
> In addition, upcoming cross-zone validation for boot-time gigantic
> hugetlb reservation is common logic. With this refactoring, that logic
> can stay in the generic code instead of being duplicated in
> architecture-specific paths.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Same comment as Mike:

Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

