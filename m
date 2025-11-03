Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0852ECCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43ECA8E00A9; Mon,  3 Nov 2025 11:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF138E0057; Mon,  3 Nov 2025 11:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B79E8E00A9; Mon,  3 Nov 2025 11:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 175E08E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:29:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4297B7426
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:29:01 +0000 (UTC)
X-FDA: 84069830082.13.C956ECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 020E0180006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:28:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gIG//177";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aDJN6aJe/Npw7A7kRLz0InINdcOIdzlDKv6tVFHMp0=;
	b=iqqEk1DN+85TSM/ePD/p4zeqUX8wWxQnI4ziCsPsNQawQr0TGjiujdmmYgKSzEDE9SuNK3
	hRG3UPHQjr4JDpCE6hZfG/P+r3AZWzI7kkVb5VxwqAnIAerD5JtHwHA0TxZ2ewojqr869q
	31JtZYs/4Giu2K7CWxHEJc12tmR8HFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762187340; a=rsa-sha256;
	cv=none;
	b=kMQcOfzmsnNcDVPspptQxAxr2HcL5jYw+x7w3hM3O5QHUJVyqIAmEoq2qf7apvT8irKh8D
	HdP3EkPEJ42UhmBPxvxOJzhoCGkqsRvT8KfAVN6fDamVfh/cm7ZzQRGbaCm64cNAgQtVHL
	WoBIx3iT1bQVpR1d3z7OcEi47pjeVyk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gIG//177";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FA02601B4;
	Mon,  3 Nov 2025 16:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C845FC4CEFD;
	Mon,  3 Nov 2025 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762187339;
	bh=P9RttLRFNBDXEMSCvfrmjQGTk+zQ0uUQRP4pZWzITOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gIG//1776XlFbSJmn0IYGp8V19rOTHgGDsYR3POeI10oN+a9WlnZjrXrfVSt0zJoK
	 C21UdwoXw90gjW5cJfsr6NLU1O/+V6jYUZxLPF4l25JMtjmoIwT9VpcD/7bna57/pK
	 JrqXJHAUYw6a87M2SiqUCwgfUw9VQ0Hk97a1LeTg07gh7BlWeXhrC7AMMFRhnDcpNm
	 G+Ys+kf6FVUgHPSvPXgJxVuQUHZvfc/t5AptVpUcZUmZlPxOGtJRqW6GXIsB20fWxF
	 LcVuCze517OKaS9EP3/jXzBe/uUL5v7pjXj9PVARwFZpcqjsoEDhExutFQwb5aQeLs
	 7PEz8G9++1RfA==
Message-ID: <cbee126b-5a3b-4f03-a049-2d8b86b4e5f9@kernel.org>
Date: Mon, 3 Nov 2025 17:28:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/hugetlb: extract sysfs into hugetlb_sysfs.c
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Geliang Tang <geliang@kernel.org>, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1762156954.git.zhuhui@kylinos.cn>
 <fa0fee2b8c2e54cb2437db44579475492c19e94d.1762156954.git.zhuhui@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <fa0fee2b8c2e54cb2437db44579475492c19e94d.1762156954.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 15cwrfn9y88j1ctjy4wh9x5o7oropwia
X-Rspam-User: 
X-Rspamd-Queue-Id: 020E0180006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762187339-512025
X-HE-Meta: U2FsdGVkX1+3TQOd5dCLauO/MZ1B0fwg4LJ/+Z4txjupHvPzd4NImLcwVJXEFsbNr6r3QDloU2j0KS3MLBUzqgycsy5Y9YtbpxSJ708ZspRDmBv1bmTdVckx/SwN6Bao2dZ/Tdt2EN8/vs3r532x/yVrNGxefbDtVZRoeL+pFRRWqN/1J9KiySrnKdhKAynqD+gRGefEtgLaEfxwoIcxnRqztrHLXtu9WQQ7ECHWUZ4QnhKtdrbCUvZOScLSsXt6tkPcy2CNnWs0P686ubBMH+FLxK3eNRbPWFEMP/roBPWBoUcK681nCckpWnXRgjtHSifNHEmzO/mvTXHlupy6raTbLkS7KTi4vClerUWduD8rE21oHi+Kvdi/4++b59TbEZVYULFS+CZ0lopXzHBHFe5PmRrlWXsqp+yRmJdTCJFiJoP/neXBd0rZzzRFeZToRXy8c1gNnhP/QVvhmIBS3RBB5S0/XyJXoECNJOA/DxAcORag//VBFuUiP6dKQGkJ/Q5XyuE8JIK2MDdnMY103MEjY8yXY5m35nDXq0go8eeG6efVhotsky65dl4S7e92pQ69jXukxJZjGIlmQtULcGm2gWDSW1ZTOUGJNcrfnRBzsn5G/b2UI/yPQthKzvSO3guzbFFlvv9iorcMxbw7qdTRrjga/+XelUrgKSrmD5zMi5Xevvs3FzC9BcrvVCqQLgo9qZPuQFmKs1ka5q8m+f+HLbbrGPHh5a/bC6Gsu5dSfC4jaN1rF9CpYWftNSoOInvYXjJKEFRmSQYgedtONHJrfbnomD2z9ouUA7G2OdppzTAPtWlgLqQY5kDjBqwLT9f60VkzqYRyKj1fDryoy9ZM213IGwXA+ODSP4r96q9ut5lMHbi5VZIBJ3eiTKD2MdK+ej2jD2E4wYKUkLAByflz/TTPFRTkOzTwqloGjlx6rFEwGeLJaled19guD8yvqHyxu2C1Ss1xba0eGju
 JctFPfMe
 K8Zvwh8PaoOC4ob8ITWj9qev/UvUXCmkF+0XaGTXJhjk45BCi0Wsax5UKUYfkMosmQsP3+7jD0+cSjEoXV/Vi2C2KDfO7ibi5IksT1q0ItIg296oLMN0A0oT6Pxs9IBjF2iPmLMZtHlORhOzPZ/uhtG3qgzgn3eml/Nr/DaDEjEkMlpmFhqIRF00JNGujzOVvigO2ub/3AEaGMSdaI0Zw2MNJ3K5eBde2M/Sn2Fgz3na5K3iKNQbNGMK5EtCN7Ia2CeBC48IF+Xxb9e3iFpA9Wwl2uZXu/YW4gABlpoFBxAz8lxa+vWPjH8YneqStmxutnodhjRC27ET6KnjHbQgE+R5fj/YpphF5czQhrKYKvcEtabE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 09:22, Hui Zhu wrote:
> From: Geliang Tang <geliang@kernel.org>
> 
> Currently, hugetlb.c contains both core management logic and sysfs
> interface implementations, making it difficult to maintain. This patch
> extracts the sysfs-related code into a dedicated file to improve code
> organization.
> 
> The following components are moved to mm/hugetlb_sysfs.c:
> - hugetlb page demote functions (demote_free_hugetlb_folios,
>    demote_pool_huge_page)
> - sysfs attribute definitions and handlers
> - sysfs kobject management functions
> - NUMA per-node hstate attribute registration
> 
> Several inline helper functions and macros are moved to
> mm/hugetlb_internal.h:
> - hstate_is_gigantic_no_runtime()
> - next_node_allowed()
> - get_valid_node_allowed()
> - hstate_next_node_to_alloc()
> - hstate_next_node_to_free()
> - for_each_node_mask_to_alloc/to_free macros
> 
> To support code sharing, these functions are changed from static to
> exported symbols:
> - remove_hugetlb_folio()
> - add_hugetlb_folio()
> - init_new_hugetlb_folio()
> - prep_and_add_allocated_folios()
> - __nr_hugepages_store_common()
> 
> The Makefile is updated to compile hugetlb_sysfs.o when
> CONFIG_HUGETLBFS is enabled. This maintains all existing functionality
> while improving maintainability by separating concerns.
> 
> Signed-off-by: Geliang Tang <geliang@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---


[...]

> index 000000000000..63ab13cfb072
> --- /dev/null
> +++ b/mm/hugetlb_internal.h
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Internal HugeTLB definitions.
> + *
> + * Copyright (C) 2025 KylinSoft Corporation.
> + * Author: Geliang Tang <geliang@kernel.org>
> + */

So, you move some code and suddenly have copyright and authored that code.

Especially given the cove letter says "The code is moved
as-is, with only minor formatting adjustments for code style
consistency."

?

-- 
Cheers

David

