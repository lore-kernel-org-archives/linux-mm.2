Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D65C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B966B0088; Tue, 15 Sep 2026 22:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55186B0093; Tue, 15 Sep 2026 22:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49116B0095; Tue, 15 Sep 2026 22:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 910346B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:56:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A9E51C2993
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:56:48 +0000 (UTC)
X-FDA: 85218112896.20.A6522E8
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id E7F871C0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:56:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WL01MGvS;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789527406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltwHG9lHNDsQHaMaee1Lnu6kVGSGJpl1ybgHT6WGVmg=;
	b=mqH6dstDkQz3JDLenEgy0sZ8cCL7VXUkj7IctGuCWy1da9lvZOtPg/KsZMBDtJwosZHV5c
	9b/0DcBU8q+ebeLCHEi3Br1PFMM+K9D9zZq6GQJpgKgx7FEXbKNh7OrY48lr4yVUVij78N
	Oz7gAYnq2O3hO4AOKE0/SWwCLxlcT4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789527406;
	b=Y9Mp4mTYAt2x0/bM81mICDSYppTJHYtE4+L8VW4XRGlxJer54caGz1QuToiuvO4j6v5mPT
	Xfroffxg2IWSy2tnfdmVCaq4gWq8AK/hgJlsichBoEpg2oD891VfG7MGzVm85wJpNk7/Bw
	xYMF22g8BZrAJKi6TDtI976xSOFLpx4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WL01MGvS;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789527401; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ltwHG9lHNDsQHaMaee1Lnu6kVGSGJpl1ybgHT6WGVmg=;
	b=WL01MGvSeI7oaUh7Vt5BEq3MOTAUOantCIhBvcTmuLIpI6xDcsp7mQwXRMu5u1xhHa6sJn9D/VZmW6ClOB2HumwXG1QgfipnnikKNcgb9HpN9Xt56oi36YfoONx0IHRkgD/HzpKindXTZ3tQs5Mnn92MR/oWVkyUn23Vvt1QrOA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XB3ZciG_1789527399;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB3ZciG_1789527399 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 10:56:39 +0800
Message-ID: <24690e82-3aab-4f2d-95a7-3bba332ca5bc@linux.alibaba.com>
Date: Wed, 16 Sep 2026 10:56:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
 <20260915-fix_khugepagd_fail-v1-2-bb6f04c8759f@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260915-fix_khugepagd_fail-v1-2-bb6f04c8759f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gxckn3sweudag77aoy1yws16iruypsno
X-Rspam-User: 
X-Rspamd-Queue-Id: E7F871C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789527404-208107
X-HE-Meta: U2FsdGVkX1/4WbSU2qDv1StI+DKPK3r9Fmn7DLg/66cfkOoBFTenKGukVEn6gEpUrAPkOHEkg3WZYvYCcfrJqvzXj3nrAhFjxsqnr0RixO8z4eq8IGtaEPKtMl8w5ljgdN90Q0WERT1HrrDhEHKB1lFh7amGLbMR23SAHCvPjCt0j2ny7oTYiWUnkV4ARqrB040O5c86SmgBH3VzgSE/jpUVjEHGDnoz787RBYlafDP+t6FvIFJm8IIPIGzcy331RTYydZ9QcRiNiR4+KrXyvCWBd3X4GZ0127Uk+NpJHJ6vhhF5ikvR0+/ZfqWLjrHb6TB6kFc7nzYwFzSbFlAnULcOpI2KWjtmUYyKiRu3DhCeEKQUScZZJf7eB04LsS1Luw1JBje4PTjL7G1b/E2x4EYcb9rkWbIeH0/+E2Bu+2FZ/9mYKR8tbSg7dw0F3QoAKZutIXkJ5kz03oSHxxyKP5HX6V3kVCo6P1L/j6+JDxxfbm9619/C1vv4zHgMBP+LQa6Q0sEQBnICXwzm7NY0eL4vBHhDKDslnEtOCjm8f99Ndg3n8ySGSQ90KwrJDKpekXUiDK6qsD/EyPtSd2B8Vx03RVFFug+83bHhFMkE7vu80W3hnut+bV0QtYtZroYvXxrF9KBCQoFzv2fQP44WGzewtDHeSAv+XHuPfDBvp8GqPZcAutKy3fANJLqTgnDX3fEUlv4qa1LqRKI6ifqvcBPowz1Oqiqyj6MUWGFVU1Da3fa0UkghQTy2tcC9x87i5dfY02KVUPzFe56FcitTc5lM4MZ2t8AO9G97ucdQKrQ1axDjxekdOicw0bmKzBwxMek07aKTc+EOmgzqXjQkaVGnvMv0p9uwr9QMCl+RBZgZ6xfcKuBhcRvaL1gN/us9ReQumUqmPX2OrrQ6Js9ut6jjsyj94O1v7UborTxE44o1XI32vYJDdQmljIlI/yaj2uHoLaDSQfpZVMjJzJB
 qsE6Vkrj
 BS64cUqp+ueZwbFudydecRmVtRiNN41PZ+TXa3uXcVR8KJgsJ5WmysBhNKZwzAmI17Z2eo47JNXraGdDbtG85S3OoIooJnuckXKRYYdSqf7BoSzDGuKZiSMBIqX5vr7LDOQI1NjMKbMv8PDxqRZAG0eUdcTH/H/jkMuz6BY3LWq2t/tNdYQQ1cp3aXygnfq9okL8dLoOTOmToJtOeblGW5UgHLlxdE/SF/iZztwP8qd3ga45NQoYDeDI1WyVWfJYh9VHTbmOxfnus9tHy73bMMoX/rFiC1YWHJqTtlpdple6wAd/FhUwqcFJja2xUCk/EZPJOQCP1YwbJ3Yxa9xAkgUaVRk3lBUB3/866biwuqgH+UufNEgONyHVjmGqKq/lkORi0z86eg+Diz9M+oVkudwNCoabZeJNGNl6D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/26 5:21 PM, Yeoreum Yun wrote:
> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
> 
>    // while running ./khugepaged -s 2
> 
>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
>    # Allocate huge page... OK
>    # Share huge page over fork()... OK
>    # Trigger CoW on page 1023 of 2048... OK
>    # Maybe collapse with max_ptes_shared exceeded.... OK
>    # Trigger CoW on page 1024 of 2048... Fail
>    Bail out! Unexpected huge page
>    # Planned tests != run tests (26 != 23)
>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
>    # Swapout 257 of 2048 pages... OK
>    # Maybe collapse with max_ptes_swap exceeded.... OK
>    # Swapout 256 of 2048 pages... OK
>    Bail out! Unexpected huge page
>    # Planned tests != run tests (26 != 17)
>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.
> 
> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> before c->collapse() is called.
> 
> To prevent this, change the khugepaged setting from ALWAYS to MADVICE for
> the affected tests, and mark the VMA with MADV_NOHUGEPAGE after it has been
> collapsed by wait_for_scan(). This prevents khugepaged from collapsing it
> again before c->collapse() is called.
> 
> This failure was observed on NVIDIA Spark with 16KB page.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index c32244b565658..83e9386bbc842 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -578,6 +578,8 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>   		usleep(TICK);
>   	}
>   
> +	madvise(p, len, MADV_NOHUGEPAGE);

This looks incorrect to me and would reintroduce the previous problem. 
Please see commit 7962e05a835f ("selftests: khugepaged: fix the shmem 
collapse failure").

> +
>   	return timeout == -1;
>   }
>   
> @@ -839,6 +841,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>   
>   static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
>   {
> +	struct thp_settings settings = *thp_current_settings();
>   	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>   	void *p;
>   
> @@ -860,6 +863,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>   	validate_memory(p, 0, hpage_pmd_size);
>   
>   	if (c->enforce_pte_scan_limits) {
> +		settings.hugepages[collapse_order].enabled = THP_MADVISE;
> +		thp_push_settings(&settings);

I'm not sure why the collapse_order setting needs to be changed here. In 
your test case, you did not use the '-c' parameter to specify the 
collapse order.

> +
>   		ops->fault(p, 0, hpage_pmd_size);
>   		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
>   		       hpage_pmd_nr);
> @@ -869,12 +875,15 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>   			success("OK");
>   		} else {
>   			fail("Fail");
> +			thp_pop_settings();
>   			goto out;
>   		}
>   
>   		c->collapse("Collapse with max_ptes_swap pages swapped out", p,
>   			    1, ops, true);
>   		validate_memory(p, 0, hpage_pmd_size);
> +
> +		thp_pop_settings();
>   	}
>   out:
>   	ops->cleanup_area(p, hpage_pmd_size);
> @@ -1075,6 +1084,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>   
>   static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
>   {
> +	struct thp_settings settings = *thp_current_settings();
>   	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
>   	int wstatus;
>   	void *p;
> @@ -1100,6 +1110,9 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>   			    1, ops, !c->enforce_pte_scan_limits);
>   
>   		if (c->enforce_pte_scan_limits) {
> +			settings.hugepages[collapse_order].enabled = THP_MADVISE;
> +			thp_push_settings(&settings);

Ditto.

> +
>   			ksft_print_msg("Trigger CoW on page %d of %d...",
>   			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
>   			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
> @@ -1111,6 +1124,8 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>   
>   			c->collapse("Collapse with max_ptes_shared PTEs shared",
>   				    p, 1, ops, true);
> +
> +			thp_pop_settings();
>   		}
>   
>   		validate_memory(p, 0, hpage_pmd_size);
> 


