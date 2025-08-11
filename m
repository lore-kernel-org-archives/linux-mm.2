Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14BFC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 07:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2391E6B00F7; Mon, 11 Aug 2025 03:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9D36B00F8; Mon, 11 Aug 2025 03:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127306B00F9; Mon, 11 Aug 2025 03:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F31C06B00F7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:52:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A47D91DCCF1
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:52:33 +0000 (UTC)
X-FDA: 83763709386.16.4F2014A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF913C000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:52:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xHpaFjAN;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754898751; a=rsa-sha256;
	cv=none;
	b=Kasg1mWE7J19Wyv/JnZmpS1EqXoNDYkdZHQuK7o+IeYUOLjy43FMDstSdlr2/xRbRJG5sN
	uSD8E44jRKDPFyLz0U3XT9B3hG65GL41MMExRaWNPXb/PQUbjujq+sQ9M4KuxCNIe6robj
	KBpeAeOwVd4AkEbLjTPhHbjRI1vH9IU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xHpaFjAN;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754898751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2dG7lIQa9l5kZL/Iawtixi2ty+fhGYumGN8z5y2DYg=;
	b=sQVP1nJ4a1x97W02RFkeuuh0/O8WcEwZcfyaKgS/PgQj9zjvbvN+XGrDBJtGshotCpMhOm
	FdvKrSy8DH6bMH6gkKl4JNB6uvLtHILraOY54Cfl7Kg+0tVfAUadl7EExRe713Bv9OVU4W
	NA3xkSAouG4ZezpSDA9CLbZskCqyV28=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754898747; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=C2dG7lIQa9l5kZL/Iawtixi2ty+fhGYumGN8z5y2DYg=;
	b=xHpaFjANunt7FUGW2sCq+hYtPn4roGvE5pdewAPmZ7bhk1/2kGcwhP1wSpRKFEgymIc0j7wJIqz13TkOtuWa6UTemGusSh8bGEe+76N3T3Xmev7SS2VGMcNjwXz7Za30hs0wT3hQjvabJG4zNo5NkdpYoIbFgdW8qCs7wod2ue4=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlQRCgi_1754898745 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 15:52:26 +0800
Message-ID: <f0711fe8-88e9-4634-98ee-1e37453a7e53@linux.alibaba.com>
Date: Mon, 11 Aug 2025 15:52:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250808190144.797076-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF913C000B
X-Stat-Signature: 7jmuj7cjnua47dapaijwabj6nq6oy46f
X-HE-Tag: 1754898750-220041
X-HE-Meta: U2FsdGVkX1+9bwbi41LL3sEhNdb3fpI8LdSVMUydr+DLy60viKmYFeMndNXafm+86PhKY0oySs/ZCqmGpMkBTj30aSD/IZn5SUSe6GlJCbypsxMERdASWqw0CJ4Aq9iWCVtc2mWt+SZhfYHqaS9S1W4VZpplTOONA8QOrD90Q3HMHMJF58a5VV83P/cWOboLBGNVKvrk35Pus/NtjG7vIG79vbLeK6mbKYGjzF0Z5WwdWwvXolol8hNx1Cqn+HqCwykBHGTv2+kvmI0be9/84TVGFWF5ScpNPno0eBRAX9scL5qe0ZbOjN1Bbgkle0CrU7X5d0A3kpBNIqLnSN8TFWHP7c2r1l3PCqcJ1KTKTRGapMywsNUpuB3DlDMLUnl+z7wYI422MXlR8YAqCnlGnKOgpsbdb9GVxkm6Ln8dBX+10eIqWjuzf2obYPDU2bvp9DRt1P4uJ7exd+6YqWcLG17bEsC8Urx5R83j+9WHk2IikjqGDaW6RATm3wv70weNBU8caNTw/Fk1f0v0m0rgWhoipC/mTWtq2j6zGEOhkXzZQhYngf9Ez8oYXJlY3XjMSG0QHpGvKWKmHLCmcSdlCy6/vEfiLTvfusI+Llrm+SYbUArxncwG89YUSsOAbLtS5RFDsN7dDV8ffChFu6mZ+CBm7wy0f2bcH6u26mKLeJk+MBoW5v9DEbYrUdSFjSjfkdi7G5gktR0KcomQ3wbY5g07d7lZFSk7DJE6eK2tu6LhCtS5O7oEslCwO/IiSY1ZG+AJeUvOVkwAhaFLFlDs5S337fjkShaeUIbZbXIG750OHrvT03QdCy9Kj8HXyQy7a3sdRkA1GU3yw+38k2YJhQ2RSa2kg/TX1ngZqP+L00/ToqpX2AC7YI/nU838rtSgxON/8jukRjKwBdrmGj0aaMop0HDjv/CopSwA21ApXVFge7FwoOKPQTyjTrGxpTB1na5yQJUtNFVvWqVuOR8
 4AXdZHt0
 Yl/q7liYAZDZMg7dJ3SBxL6Yx7u9ObL4kBgva0OJb6sx9ZibPSRs/Ag2SZ6/6dkYwdG0XJshLrv67wv4MNdd1PR3xVg5JqkKEzGH1YMCPL57A0yLXdsKZxr3usCAh5CP1IpmR04z282PVUalXjt8oWNm50DQHpPuz8guw/gcG7ggqHTtOI1SOzRevONnmLBif+O5W1F9yR5HWKxlKe056TGXcHOdHx5iwYOiFdSFR8WdOTTVRcSpwpP/4kL4aFg0nQRE2DFwYUFtKs4dHON6DWVLjdvzWmRt3NbFWVQE2gwNrvoX5ue/SKBYFSHBHoe1EdR/kqdWq+uepp/SMckUH+zA9Q8L8KrdO8S9B8uc019jUOgKtXf9SSf2Lh5jVEqVSrQiHOA+OFj9jBG1OLcuXR7d9pHGfNMgCXeYBKMOFLuSM6WTWzZ66LdkXvKQDR+UhLm4Glx3cxvivmoc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/9 03:01, Zi Yan wrote:
> The helper gathers an folio order statistics of folios within a virtual
> address range and checks it against a given order list. It aims to provide
> a more precise folio order check instead of just checking the existence of
> PMD folios.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       |   4 +-
>   tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
>   tools/testing/selftests/mm/vm_util.h          |   7 +
>   3 files changed, 141 insertions(+), 3 deletions(-)
> 

[snip]

> +
> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders)
> +{
> +	int *vaddr_orders;
> +	int status;
> +	int i;
> +
> +	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
> +
> +	if (!vaddr_orders)
> +		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
> +
> +	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
> +	status = gather_folio_orders(vaddr_start, len, pagemap_file,
> +				     kpageflags_file, vaddr_orders, nr_orders);
> +	if (status)

Missed calling free(vaddr_orders) before returning.

> +		return status;
> +
> +	status = 0;
> +	for (i = 0; i < nr_orders; i++)
> +		if (vaddr_orders[i] != orders[i]) {
> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
> +				       orders[i], vaddr_orders[i]);
> +			status = -1;
> +		}
> +

Ditto.

> +	return status;
> +}
> +
>   /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>   int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>   			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 1843ad48d32b..02e3f1e7065b 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,11 @@
>   #define PM_SWAP                       BIT_ULL(62)
>   #define PM_PRESENT                    BIT_ULL(63)
>   
> +#define KPF_COMPOUND_HEAD             BIT_ULL(15)
> +#define KPF_COMPOUND_TAIL             BIT_ULL(16)
> +#define KPF_THP                       BIT_ULL(22)
> +
> +
>   /*
>    * Ignore the checkpatch warning, we must read from x but don't want to do
>    * anything with it in order to trigger a read page fault. We therefore must use
> @@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
>   int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>   unsigned long default_huge_page_size(void);
>   int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders);
>   
>   int uffd_register(int uffd, void *addr, uint64_t len,
>   		  bool miss, bool wp, bool minor);


