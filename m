Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680C2CD37AC
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B8B6B0088; Tue, 12 May 2026 00:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D246B008A; Tue, 12 May 2026 00:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B0F6B008C; Tue, 12 May 2026 00:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F00C6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:45:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB99A40386
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:45:01 +0000 (UTC)
X-FDA: 84757528002.19.E3D368E
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2C82180007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:44:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rPymqSEB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778561100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLBqEVqOtA0L9B/FBEFQZHxIvKYLTaOc7iFirBA8GiM=;
	b=5ONx9kEiFPT640th70D9ciOA+Dad0BY8IF+FispNkRKBdqq7MCyvOcr0qLLrr5Ir2W43HX
	i7a7fBu+y6IJLaDp6owNGgUP7h4DNSgjtWIuoZKT7nwYF3j+Z/cDxEIoMdSnzUstRqmiNy
	Q4QXanaNpq43hEvnDeDJv+Y14p/2Z2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778561100; a=rsa-sha256;
	cv=none;
	b=yJM24Ttuvm4TJ82N90PM5PPT4z3fsQxUI//iC3KUbt2jYJagoIoLGDvxUMwIM1LmCwRpVS
	1y+4/uIghxajgF5s8AOsAstpTqvPA7zoRCZnhSpnYQ/aRyba0lCegaOGpsIga3dTn0unxr
	UxGrlodteZxqsGan2JdLAyloxoU/Eko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rPymqSEB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778561096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VLBqEVqOtA0L9B/FBEFQZHxIvKYLTaOc7iFirBA8GiM=;
	b=rPymqSEB7ksQeLp2kXClF6xGrRcrtPRC6k7yv726vYMSQEmkKfG8uwEcPDk5G6OqXp5d53
	0h73lztm/ioh6KuUgtZJh4V8ofHz9eJyrpXqZAKKLiX66KAeLK7i0ZIGOjp7gBm/Mh8c/r
	/29FxCR53BgaL0mjYeUHQiJntl+h1wo=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Tue, 12 May 2026 12:44:44 +0800
Message-Id: <20260512044444.71798-1-lance.yang@linux.dev>
In-Reply-To: <20260511185817.686831-4-npache@redhat.com>
References: <20260511185817.686831-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2C82180007
X-Stat-Signature: kyaepdy6zyodmukizqa9t38z5haci14h
X-Rspam-User: 
X-HE-Tag: 1778561099-47394
X-HE-Meta: U2FsdGVkX19hE9wDOPEUUfkAoarF5VW1hKxEXB4ZbzJ7FGokobUceU0Gfd9+Gb6SCi7hMcVYztun+pP4EwIBfYpj4+TEqGLTy7fqfXGlPh+Zwd/38Ut8vDynkR1Gd+Chy+xM4MhncuGT3ebzlDZSAGxN/ODdUxKOjYwaa67GuT7IlfrpdRci+WP3IrJ5DYLwtq5Vi0YgnTd06MXQttPcQhnBHja4vNQqUChX4MI0GWaxoXE69kT/WH17gP4ii+nC6p6cpkArfj/ilYsWK/3Jmw5t+bivcTvKxltN8hNIG4CcnOo25f5N1efEmjFUf0BasNiz4YwRS1Ou7uSuzFj3OEio91svZ8zSih3cnaWn/eXDc68QZwvtgC8NVDwhtTbo/GvtjX2tom/q//49oWlnXoNajPGFmVvtUTTt/NKprNxT+A61Jp7KVxcNNt4kEAQTEuihmZMrIAw//643t+sduWO4hwYieE/me0D4tVBo6VZdCrYcfKyNs1crm2SWVDRV5YgMrA34TG4PZc0vL/Eu4tvH9j0qsCiPWj2gDZ9ZBCqRa7UOj/a6glKC7UYC8XKLRV364WmpRPiUg8P169jnRSFQdGvohcky3CUXYqEBf9qZHblkZPOXbTL4eYav7clOspPwbQDMq/CMt+7IriPDUBiAOiZpvg+q93EP61fRyoIBNxzzR7y0H0+vwdItpc+Id4l3q809eqWq47RmjqJS2ZJfn9FYkFgXMlSQriGZkXD3JZoU3dvVm73GPnuCfie3x0NkTPvaCifnyNjjN3p7L0QEvLHtItvHWmQdoKqp6k9RvmzCLGFxIQ+wyv53LsHy7hSzk6AAWV/srVDpIxG5DhbpcjG8Awrpwn1XI630/D19roUkOEtgut7im9KF45ft72DUeXmvbhK2Xj/cfcpMv1rGoE0T87oZn7JN9cBvLycK1HWvW1zVUmwvsPYejFyM/baeW3/axx//S2eHcGz
 H38RifdS
 jAuAXkHkzBV/e1F+uOovpVqzfrOKOOUBVhXgQkQD7MVGLMSXH0VurHB5d79ipMEVG++0EWZYWicc7isFY+8m609P+Ox28pkjvhJR3bwKPPP0HhA2/q5M9UQAkmuz9yazJTVPVGGv2BbHcDHcIGCPa+TA8TkriNyTLxjF3zFp0CZKzpdxIEKVvGZkVdn5uKFSeSDeX08G830CUck9Xq6XOaMTWRPq1AwKidah1D4Yf8mcdAo7VdWSqalDQULo+2/wiozwxM95SP1xObiN9KwqWEKWrD01kCllXYmklmOQBIUC7hNhUC5ArG5TbEr91gp6OXrKSUE+v2LjgXrCiFnFOIoPezryMzRXYmQuPhnCfTHQ8bddfGS7TkQLkzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 12:58:03PM -0600, Nico Pache wrote:
>The following cleanup reworks all the max_ptes_* handling into helper
>functions. This increases the code readability and will later be used to
>implement the mTHP handling of these variables.
>
>With these changes we abstract all the madvise_collapse() special casing
>(dont respect the sysctls) away from the functions that utilize them. And

Nit: s/dont/do not/

>will be used later in this series to cleanly restrict the mTHP collapse
>behavior.
>
>No functional change is intended; however, we are now only reading the
>sysfs variables once per scan, whereas before these variables were being
>read on each loop iteration.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 118 +++++++++++++++++++++++++++++++++---------------
> 1 file changed, 82 insertions(+), 36 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index f0e29d5c7b1f..f68853b3caa7 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -348,6 +348,62 @@ static bool pte_none_or_zero(pte_t pte)
> 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> }
> 
>+/**
>+ * collapse_max_ptes_none - Calculate maximum allowed none-page or zero-page
>+ * PTEs for the given collapse operation.
>+ * @cc: The collapse control struct
>+ * @vma: The vma to check for userfaultfd
>+ *
>+ * Return: Maximum number of none-page or zero-page PTEs allowed for the
>+ * collapse operation.
>+ */
>+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
>+		struct vm_area_struct *vma)
>+{
>+	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.
>+	if (vma && userfaultfd_armed(vma))
>+		return 0;
>+	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
>+	if (!cc->is_khugepaged)
>+		return HPAGE_PMD_NR;
>+	// For all other cases repect the user defined maximum.
>+	return khugepaged_max_ptes_none;

Nit: kernel code usually uses C-style comments. This could be:

/* For all other cases, respect the user-defined maximum. */

Also, s/repect/respect/.

>+}
>+
>+/**
>+ * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
>+ * anonymous pages for the given collapse operation.
>+ * @cc: The collapse control struct
>+ *
>+ * Return: Maximum number of PTEs that map shared anonymous pages for the
>+ * collapse operation
>+ */
>+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>+{
>+	// for MADV_COLLAPSE, do not restrict the number of PTEs that map shared
>+	// anonymous pages.

Ditto.

>+	if (!cc->is_khugepaged)
>+		return HPAGE_PMD_NR;
>+	return khugepaged_max_ptes_shared;
>+}
>+
>+/**
>+ * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
>+ * maximum allowed non-present pagecache entries for the given collapse operation.
>+ * @cc: The collapse control struct
>+ *
>+ * Return: Maximum number of non-present PTEs or the maximum allowed non-present
>+ * pagecache entries for the collapse operation.
>+ */
>+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
>+{
>+	// for MADV_COLLAPSE, do not restrict the number PTEs entries or
>+	// pagecache entries that are non-present.

Same here.

>+	if (!cc->is_khugepaged)
>+		return HPAGE_PMD_NR;
>+	return khugepaged_max_ptes_swap;
>+}
>+
> int hugepage_madvise(struct vm_area_struct *vma,
> 		     vm_flags_t *vm_flags, int advice)
> {
>@@ -546,21 +602,19 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> 	pte_t *_pte;
> 	int none_or_zero = 0, shared = 0, referenced = 0;
> 	enum scan_result result = SCAN_FAIL;
>+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
>+	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);

Nit: could these be const, as David suggested earlier?

Nothing else jumped out at me. LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

