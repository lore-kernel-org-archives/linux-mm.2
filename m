Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99EBC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 06:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D026E8E0002; Thu,  7 Aug 2025 02:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3BA8E0001; Thu,  7 Aug 2025 02:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8B58E0002; Thu,  7 Aug 2025 02:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB70A8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 02:49:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 645885AEE2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:49:33 +0000 (UTC)
X-FDA: 83749035426.23.D9E6E3A
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5BC41C0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:49:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J9asc+eW;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754549369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhRuHq1YazfF0XCQjIZWM8IeeeAiuRg4ltzrKTelAdA=;
	b=czvsTEHqc6BjWdozI5PKkS/5A+2mrn9IdJ0Cbx3iPKNbXQ4QjQJ5xbNBEr5eZ90dudVTzJ
	+S7KPc1RI2IX9G/ZUqRGbsXaV/j56lvF69GQgundaMRvMNB0msQQxJXuOxyWFRMiKNG4m0
	RSV692ZzfvJ+bnB5aFYPIisA/gHUTbs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J9asc+eW;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754549369; a=rsa-sha256;
	cv=none;
	b=zw7jpvvDg1ddy8MnkcDm8pGEcC5gdSckwaugzBi9ol88zzh1SKQXHuJrU4AZoGo9OSLBoo
	YMis7bq232ofNuHTybWehz9NxopSY8sXccV7i/ZfGivGUbSC2P3spTdag9bzlQPVuVYsDT
	7YZrrziL2tQRD3h9rwwdvadgLan0VuU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754549364; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zhRuHq1YazfF0XCQjIZWM8IeeeAiuRg4ltzrKTelAdA=;
	b=J9asc+eWyk8CToWn0/SEdsInsjnHM+1CRJEXMxaPbYCnUw1Vj59BPpcLyyfqMip8G6aWu5iT5WcYndSKPdSv283DjrNaa8UQDfVb41KhWVvD/zjdwIGheRZakCKh/T7Qr8cVhDBZWdP4sXMOMu3mpdBSnEHo2p1x2rbj35WcBSQ=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlDE4jg_1754549362 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Aug 2025 14:49:22 +0800
Message-ID: <dd2118cd-9209-43d5-9c73-8e3989931841@linux.alibaba.com>
Date: Thu, 7 Aug 2025 14:49:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: add check_folio_orders() helper.
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250806022045.342824-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BC41C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: efzj6jafjgstk7hd1jom4hffewsjdxjs
X-HE-Tag: 1754549367-27280
X-HE-Meta: U2FsdGVkX1+z6TY58pOJVtGAaaY/27pPaqtPIHHHyZQ9Q2nyqEpA1g7z/HsZeJEYGaFqddjg1LLTMkO87cDXaWxTpipJJoc2zLjVxYPmJD4ruaSjDOXKzBpAsUeK84lNqF38qUoe0urrNQXmnLhFO9W6eP5Mwg9Njlf+c1CspCPRE98U/UPUYNZu5lmAwik9qkyhdSepEbFVt4fcm0kKQmF9cCXVsIsfI5OxdfH1rUswpUtL+PgrIey5jWCPCFqd9r8pcsvMwmEEZ2vZk+UtcH3YMg1kOWDqKEs4vO5J3ckuczxHjgrchTNWSt2OFWY55rROJsUXrsheatHZlW2maZKI9qQocoZYkcf/8ZBz4MnrJXDZ5xBMxhKkhMhUVMwkUpU2Fok+uPvU/MQcI9cPS1KxvrOLozWqnpuB+UUYJlKT0NC9imOhrLUzb6EyOworIPMHfrNyDQjx/Ot+HDloYGd/5WYSE/3Q3eskvXPEyinnbMRcNDqgdrd3tfXr9x3BgncnuyygIccYnyJ/Kf7PC+LC7F4CM+Uvc0y5b7TO91Bq0wJnQNKWElMaNSuXJ0nY/GEw/txROhiaJPDr/wBPpMuyrB8viCAJwmCEZLClPmngWZLFErl4FqQP/1mI5RKJj0ISnDFLuHHDoJlGUdOGohHm0xNvKlcfWw8u7Aa3IP9P5Sd3ZettxK4oFEAOAazsAbT5ZpsDSp16jD46rztxmUDUn6N21IaV9MN/YG0MZidUMOs6Q/cmivrzEg8BG4tTq6JMqMYH3S7K3+MZmnw0hsIv7qLU2l4PAzQ4u9uiv7AoX/gNmhIrGTR2HhaMUQygetC3ns34PMdnkm1HRnZ7eSKGuqyzFLStj34cvSzYRtqGZSWHi5sGUGWXImTn2RM136ljZ/Ez7zfeIHrqW0KCgoLnvc7TzmwWC/CIb00sUlvpsTTPVybfIfejXqT3YOn6m6sREtlJE1C2V2iNhg1
 +KOrnFog
 QJu/vy2byKtutQujb9nldOrfYJADhGB8ugA26WCaBS8OpldeNqPxyOTaf+Qf0luw63Horh7tGuIqCqXDhZRht5aciXr6rVdOJ2rOpoJX9LODAA4MlhxIJu1ZvrRzbD2DmikOiSYl0sCq+ULdL1KhzdTITA26stt+VxKJYaL1lYUztJw1bSO83FH9ZC89l3mrZbyOCI8VSZU2UopMJi09sAQdmRJ27pAYdOVlc6twzP2p29QEw5lijo9xAin+zpoklbbrbyHrKoOsjGr6TThwGmCBNI/uP2tnKyrV2AhAF60BwCWBXVQdvP6UBtrWhVF8GLX+SW1Qj/+S/RaCpBkEQL1Hg23w0v6B/+xtu4tnYikMZsy7/M+V1eZ7RU76feuaM+a7o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/6 10:20, Zi Yan wrote:
> The helper gathers an folio order statistics of folios within a virtual
> address range and checks it against a given order list. It aims to provide
> a more precise folio order check instead of just checking the existence of
> PMD folios.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   tools/testing/selftests/mm/vm_util.c | 139 +++++++++++++++++++++++++++
>   tools/testing/selftests/mm/vm_util.h |   2 +
>   2 files changed, 141 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 9dafa7669ef9..373621145b2a 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -17,6 +17,12 @@
>   #define STATUS_FILE_PATH "/proc/self/status"
>   #define MAX_LINE_LENGTH 500
>   
> +#define PGMAP_PRESENT		(1UL << 63)
> +#define KPF_COMPOUND_HEAD	(1UL << 15)
> +#define KPF_COMPOUND_TAIL	(1UL << 16)
> +#define KPF_THP			(1UL << 22)
> +#define PFN_MASK     ((1UL<<55)-1)
> +
>   unsigned int __page_size;
>   unsigned int __page_shift;
>   
> @@ -338,6 +344,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], int max)
>   	return count;
>   }
>   
> +static int get_page_flags(uint64_t vpn, int pagemap_file, int kpageflags_file,
> +			  uint64_t *flags)
> +{
> +	uint64_t pfn;
> +	size_t count;
> +
> +	count = pread(pagemap_file, &pfn, sizeof(pfn),
> +		      vpn * sizeof(pfn));
> +
> +	if (count != sizeof(pfn))
> +		return -1;
> +
> +	/*
> +	 * Treat non-present page as a page without any flag, so that
> +	 * gather_folio_orders() just record the current folio order.
> +	 */
> +	if (!(pfn & PGMAP_PRESENT)) {
> +		*flags = 0;
> +		return 0;
> +	}

It looks like you can reuse the helper pagemap_get_pfn() in this file?

> +
> +	count = pread(kpageflags_file, flags, sizeof(*flags),
> +		      (pfn & PFN_MASK) * sizeof(*flags));
> +
> +	if (count != sizeof(*flags))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int gather_folio_orders(uint64_t vpn_start, size_t nr_pages,

In this file, other helper functions use userspace virtual address as 
parameters, so can we consistently use virtual address for calculations 
instead of the 'vpn_start'?

> +			       int pagemap_file, int kpageflags_file,
> +			       int orders[], int nr_orders)
> +{
> +	uint64_t page_flags = 0;
> +	int cur_order = -1;
> +	uint64_t vpn;
> +
> +	if (!pagemap_file || !kpageflags_file)
> +		return -1;
> +	if (nr_orders <= 0)
> +		return -1;
> +
> +	for (vpn = vpn_start; vpn < vpn_start + nr_pages; ) {
> +		uint64_t next_folio_vpn;
> +		int status;
> +
> +		if (get_page_flags(vpn, pagemap_file, kpageflags_file, &page_flags))
> +			return -1;
> +
> +		/* all order-0 pages with possible false postive (non folio) */
> +		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
> +			orders[0]++;
> +			vpn++;
> +			continue;
> +		}
> +
> +		/* skip non thp compound pages */
> +		if (!(page_flags & KPF_THP)) {
> +			vpn++;
> +			continue;
> +		}
> +
> +		/* vpn points to part of a THP at this point */
> +		if (page_flags & KPF_COMPOUND_HEAD)
> +			cur_order = 1;
> +		else {
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +			continue;
> +		}
> +
> +		next_folio_vpn = vpn + (1 << cur_order);
> +
> +		if (next_folio_vpn >= vpn_start + nr_pages)
> +			break;
> +
> +		while (!(status = get_page_flags(next_folio_vpn, pagemap_file,
> +						 kpageflags_file,
> +						 &page_flags))) {
> +			/* next compound head page or order-0 page */
> +			if ((page_flags & KPF_COMPOUND_HEAD) ||
> +			    !(page_flags & (KPF_COMPOUND_HEAD |
> +			      KPF_COMPOUND_TAIL))) {
> +				if (cur_order < nr_orders) {
> +					orders[cur_order]++;
> +					cur_order = -1;
> +					vpn = next_folio_vpn;
> +				}
> +				break;
> +			}
> +
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +
> +			cur_order++;
> +			next_folio_vpn = vpn + (1 << cur_order);
> +		}
> +
> +		if (status)
> +			return status;
> +	}
> +	if (cur_order > 0 && cur_order < nr_orders)
> +		orders[cur_order]++;
> +	return 0;
> +}
> +
> +int check_folio_orders(uint64_t vpn_start, size_t nr_pages, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders)
> +{
> +	int vpn_orders[nr_orders];

IIRC, we should avoid using VLA (variable length arrays)?

> +	int status;
> +	int i;
> +
> +	memset(vpn_orders, 0, sizeof(int) * nr_orders);
> +	status = gather_folio_orders(vpn_start, nr_pages, pagemap_file,
> +				     kpageflags_file, vpn_orders, nr_orders);
> +	if (status)
> +		return status;
> +
> +	status = 0;
> +	for (i = 0; i < nr_orders; i++)
> +		if (vpn_orders[i] != orders[i]) {
> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
> +				       orders[i], vpn_orders[i]);
> +			status = -1;
> +		}
> +
> +	return status;
> +}
> +
>   /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>   int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>   			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index b55d1809debc..dee9504a6129 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -85,6 +85,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
>   int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>   unsigned long default_huge_page_size(void);
>   int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int check_folio_orders(uint64_t vpn_start, size_t nr_pages, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders);
>   
>   int uffd_register(int uffd, void *addr, uint64_t len,
>   		  bool miss, bool wp, bool minor);


