Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC37606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcmYv+u1
Received: by kanga.kvack.org (Postfix)
	id B16F56B05B9; Mon, 23 Nov 2026 04:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADBA6B05BA; Mon, 23 Nov 2026 04:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4136B05BB; Mon, 23 Nov 2026 04:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D44B6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:34:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 123ED4085F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:34:07 +0000 (UTC)
X-FDA: 85465872534.21.2730FAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73F1D160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:34:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcmYv+u1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426445;
	b=AJ2xp2yAkG07zO1w5OYSTasiTjcpJt1G6nz8fUzKof5yRyABWfmS1HaoZEOO0TaPvK6WN2
	wEMH/3XUqYh1T4X/92qRl65jjK9FIUrnbdfUGpUqWPEtAFIM0yzaGe7RSsCjdh+3M0KyC4
	REkJ5MPBQpCqsuHGe9MaC7f06euNyFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FN3KYiDiUd/Aok6rWfJQ/sT48Fgv4cxk4kzvyIKO+ms=;
	b=TgElOzYBdugfbI1LaHOm3lJDDBwOyifg4gqWGjRbDgiaB+hTf2aUP3kgk7dZk/shx24hd9
	Li4yppKlYsKd5DgWItWE+P+mI9Ldt/kUi4e6JrUeAvlS8A/FY33XDIb61EMKyUdj4S/nVz
	EQwZGUt4L54zryhWTGI01D2dGZHAtkg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcmYv+u1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B04DB61358;
	Mon, 23 Nov 2026 09:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE351F000CA;
	Mon, 23 Nov 2026 09:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426444;
	bh=FN3KYiDiUd/Aok6rWfJQ/sT48Fgv4cxk4kzvyIKO+ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RcmYv+u1AiLj7FRFnV7wL1httPiUg2brQjo6BWTq2t6Eai7fk7aM+MYZyLArmNWVH
	 E1xUQz0d04Q8oHD/c2B5qT5Q1LePOjhpEZWuq5hGtOqf3jpN4xwIEZotyIL0zGxmRr
	 OBBPkv2ElYbk/AY4FhoXCpQKOyQ0EdI4kddQVbrRYBFyrhl/NJafx7lqz8/CWBwgbC
	 PLgq0BeV++AEKbFddn/wz8atTqsxfGFQKqGepzkb84Mwp7W1uoPlaNa7O2Kkjl2zuS
	 5okVlDmP0vPCMRKBCgbNF/QJNHO3hobijm9yaGU9KkDFwDOIDkIgEd7DSg0POow8xj
	 Ayf9Xg6ETIy5A==
Date: Mon, 23 Nov 2026 10:33:57 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] mm/hugetlb: initialize all struct pages for
 bootmem hugepages
Message-ID: <awQIhS9P8JQ_48mz@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-7-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-7-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73F1D160005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 1r5iz69su5kzubu7w6s7wctt4q84gnsm
X-HE-Tag: 1795426445-103284
X-HE-Meta: U2FsdGVkX19rHWBya7jxs1ktE4CW0Tq5JOYJlFwzsMubQ2Jr8tP7CBfpl7KTJVf84FKInRC8Y4zubCY3fr/k5ax/WzD8G9cZHKM4pbYBfP2aYQ21kZ0Zs6/3rFeosngruSQ7EEapqsfJFNIxdn8eHLvUuOdpXeSox+E0/nrSQOvCuBq2z1vDHqmEN0A9xc1tbmXn7oiaTioRctvoTXsWjyPy4fLuKh5fFBMnvgwDp7iBbqwLd9IXIFzsbKSK0mD2Ui2AXe/fVec2oOvny9IVnHgAAmJC4Cnsr8pvX2W3gUzsaBIRopUWuHAfbHTDkHyP42H+rYK4B0tg1fvSVWT7ZZF5UFwH9kPbEF9KgYQ0nw8po+cU+1yqyRmmUvzArxQRi9k6VDF++Ik6of77lNJz5ZvpPEf0tlZO40Ku32WqeBRfqf/xii+2/QYb5WnuaTDDIZ3epoXeeam7+4N+gKwGfkAbDwimZ7PQ98S0yP1f5M818o6gE0QFtBq3JNQkzeFKiYlCEwnqJmnOGDHLTBteE7So0o6FwEf9UxhL5xns3e7XtoZ9Pd9VjhfsoFaM16o8mZfl1x2tCta0wX2OTR2AB6wxpoC24wVqjmD/vIc/X7E6+J5wCg0IhfsAJiqRYgdKbrW0y2iMMMPVSeCDFA98TvsrHo+mSwQvyZkoNOgUUXolU5xvpANY1waVE9ITt2/GSkMdtW6G5YarZbbHe7OwdJLbNkNVXei8wRWTzsCTrLtr17Ax2MIYR9/KOCI3dW8l4SXHrAyZNREcE615oed6XT0cs86HkQWUIFPXgH3wanoLt+QR3CUDn6t6TZpQLzfQJVDTNDDpmV7VjXLF293KL819oURlnJt0n8BUvW1i9qpGV5BnKE6yF9FrASO0rRnUOtjXy2Q/FPdSuEbb81eF99emII931AOqmGm/lA3oYebbgdQRTtrLOmP/FkEL/MWzLlB6HkN6IHWrEXUcjX3
 QLfMkGEd
 kMS1m5L5MukF0SwxmUtnoXwHl3JdgnEnoClXoJITo1S+MSDYRRHQs6Mr5Bmeu0CcvEtUiKCATgYxuMF99VENuXb1zvW9t02Ulhxp30+6pIhIfSwjp8favIVpjbx9ygXdPCKkDLtLfK7QW9SfRiJOq+Cq13mRcL9V3+HCUZLdq7yvD4LlrU//eJNyqJ5ZeXfiQR1iLia+wRq7aKEsru0+XsZJewVbOZ4wY3DkuWRekVGKby8OiFvZXPD/r008A1su/8H5UPsei8Eulqr7ohQezfJhbVxJ0aaVxdvrJf3yFFgaB6ATsAr8NXTH/O4Wy9Xo8nn/iwPlEOv8c2dpeA9QfjDUt1I/QeoqbU7fYdIQt/aiRKRTzPyYO89KwhEE1mcxSO5Imxe7YCwZ23UIOfY5CwbGUk47iVCwPkwWJbhzZ3lgg0BTaKSA0lIZTI3eYnG5I0uI2lVmKwQ4FQO7o81AGbYliXj2ZWm63pEfdoHy5G45EGtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:51PM +0800, Muchun Song wrote:
> Boot-time gigantic hugepages currently leave the head struct page to
> the generic memmap initialization path while the HugeTLB code
> initializes the remaining struct pages itself.
> 
> Mark the full hugepage noinit and initialize the head struct page in
> hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
> is handled in one place.
> 
> This can also reduce memblock metadata overhead when many boot-time
> HugeTLB pages are reserved, because physically contiguous hugepages
> can be covered by fewer noinit regions.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

