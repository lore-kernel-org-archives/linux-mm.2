Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C3DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553886B00E5; Fri, 26 Jun 2026 11:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDB56B00E6; Fri, 26 Jun 2026 11:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FFF6B00E7; Fri, 26 Jun 2026 11:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02F9E6B00E5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:55:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78D0BA04E8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:55:14 +0000 (UTC)
X-FDA: 84922512948.03.C111409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A45E31C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:55:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOOon28K;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489312;
	b=s3P4lk+bmENtShUI6zB1TpO0iC5I2t+Uh+OTyBh0KrOojcrxNJ0v58W+KuiA+8LwyQ9tNr
	ag/tzVf7Ww7/nWmzTChLllEGww/IkOq2WAxYjEqGdcnsUAModUvk7r/dpKhB2eYTihcPK0
	1M8n1GoJ7U56+7KfW0nrfLcrKRCfOVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ce1ivL2u+pzFIhU3inz2XhQZgcVJMPkBIHLb8U0NEU=;
	b=XIxlq8ZX1Z3JkrKktiOHaBntJ5/M1d263rHN37ci6t36Pi61yfnHUOO+wu2gyKXnHy5Ozr
	7FjvU62+N1LvItzc9SCxhefz/8tnekF0dZ1ED7VXVLAyQxV67yqa/4+t0eAkxFkqg4Jykn
	3dDCCSp0X0/KYBk3gUzh3WVJZWFrsGo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOOon28K;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDB52404C3;
	Fri, 26 Jun 2026 15:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA851F000E9;
	Fri, 26 Jun 2026 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782489311;
	bh=3Ce1ivL2u+pzFIhU3inz2XhQZgcVJMPkBIHLb8U0NEU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aOOon28KnbYeL6fq04CX46DrOdtRGnEJBkiX8PyMiZjoOsbGH9ZqaCuHqTkwVEPRP
	 lCUe2dVwynO/Esz6q27hA8xSWwPzuBV8c6lkY2LZ0ReU35zH9rA7M9XhBAmOcwk2/1
	 COtOx5Zvo9YaBeO3usPWhONHEzJ5BXoNnYoGa0FG1d6bSeY91upGpdo1J57UVv01yi
	 HZUwILylvMhxrMC1D/v/lhbDYsjzckHsQ8Y8QP1bNcwm9E3htpmrrR1DEhyq7gY8rX
	 w9TrocZ1Yxyw0M/R118qcw5c61fjn7FLhl7XozKS78Z5ozhH9InEhM5chFMsEkbTT1
	 WoGJvl4ZRCbSQ==
Message-ID: <8663e05b-0e54-4c1a-a7d1-94e49f2ca178@kernel.org>
Date: Fri, 26 Jun 2026 17:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: fix ksm NUMA merge test for systems
 with memoryless NUMA nodes
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1782365671.git.sayalip@linux.ibm.com>
 <8540b58ef1fdbc2e5cb2f9fe28a2d2a54a5bc6a8.1782365671.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <8540b58ef1fdbc2e5cb2f9fe28a2d2a54a5bc6a8.1782365671.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ma9qdgs6a65wgo8ef7c8zebcfcc431ob
X-Rspam-User: 
X-Rspamd-Queue-Id: A45E31C0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782489312-675533
X-HE-Meta: U2FsdGVkX18FNPxTcn/SRZDfzGNlVOkqikTwcQthJw07kx09YsAYyU2YpL0gpYjffGqFGedm9SdxTfIca4fhJsTTBFJzATY6DeA/pGVzaiuiteR3yekK2KbqSDr7RlDX95IKvkmy/R5FammNzuIv56/ncCrA75ft2GCEDLpHylTWYL7ICDe6I0lFrYaBW+mwRDCyrcNckpmDsd+KcW5Zx+nNGWDZSHb+lybJu4MPGbTDiSzptD8RB1SS/tWjMmXXjmOSLoCY5e5gxyr/ttStYwQYPqjNiqf+NlQyaaUuSt2tbogtCniS54ruhzfOzxy8iNtBsFiYvGX2gdVk+/FV8pSKMztrw9PAIrQXE4trXnH2sx1fznqpiNeg9m6Pp4eToMPHdlnaxRtEuheNhQIyvfGqezWGBfdxWgpf4ylto8b8hi4CKOB8PWl29tNlIBZUgBy4VsoAk9dHt+jhav7EpAm+dSFmEZezMukJK9C4uTduvXClUeqD3lqfhTXb7hiAHrlG+vW2MNnib3Pm3KcTNdx9PgD4s2OnBFbe8OT+kNot6z44UKRBKkbwkZJq30SpnhXZl//fq5AOOVb2iKzDUeRW/FffIcBZKCZcuCgKwg63NOGGgPhbP/qhnIRFzIxqjNycVQXBoda3o+6V6kCBP/zOnAWjGDVFvWFfWl5KajZF6hs7Qv+GBkOviFYj3HGUs3prGZGzAAIqb0KGtYby4tMcJOxkAYUYCM/kKuehXbpzySepa2qGA3expGRfxoXDmFYdhq04E2aZOCagl6IUdV1a0ckxLYRNz+9hVnfp3iyrX+w5Wy81tb4TrIxKUeP9lpdsjdnD+OXkdTakJ1s2BV7cwxOA0Bla7eeS3OZZlS9E9Jpq7vpyobgLhzXp8+raAAZuGBQX3g9JhfpIIr5nB4H7ncPbObR6Phqwq2oLWGPuKzedayJb7yakn3tjcDFyqaFT26KrYAiM5DAhwsx
 8vx/20SU
 GMAu5OkFftWLz6XnCBClF+zfHTfYinPrE9pXa2Bw1zauJ316xqx7b52kGqH24xgHfBWDWFgckgprAWG2GieAtSWmjqWpaBSMd21qpfhjVLM8V3EHC94gfWLgEahMhw82RIM6NnQs/D0onWIdsJqZ/sST3AnBePZGSBz8lUdmnthY2JruX0foqMbmWufCes35zZaPmzWvkZxELWoJRcqRRwM8A5syH/fcgH76g+KyWgT9VWgCjlNeyi4ixt17PlIdTx/YV6ij2LXKZgf0XIt9hICFtAYlQ1PivSXk3nfX8b/fRfwXgk+VwYNJQSZbdvFtz2ET/VFnLcos84q3pyPwi+dV7Ldz6Y5u7SfJVh1yBO0oYKRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  
> +static int count_mem_nodes(void)
> +{
> +	int node, count = 0;
> +
> +	for (node = 0; node <= numa_max_node(); node++) {
> +		if (numa_node_size(node, NULL) > 0)
> +			count++;
> +	}
> +
> +	return count;
> +}
> +

Can we instead build upon our existing helpers get_first_mem_node() +
get_next_mem_node() ?

From 432774fb50237519c1c041e402fddfdf4b35aa2c Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 26 Jun 2026 17:52:21 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a050f4840cfa3..2ebbb544c6711 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -440,9 +440,9 @@ static int get_next_mem_node(int node)
 		mem_node = i % (max_node + 1);
 		node_size = numa_node_size(mem_node, NULL);
 		if (node_size > 0)
-			break;
+			return mem_node;
 	}
-	return mem_node;
+	return -ENODEV;
 }
 
 static int get_first_mem_node(void)
@@ -455,8 +455,8 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
 	struct timespec start_time;
+	int first_node, second_node;
 	int page_count = 2;
-	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		ksft_perror("clock_gettime");
@@ -467,17 +467,19 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
-	if (numa_num_configured_nodes() <= 1) {
-		ksft_print_msg("At least 2 NUMA nodes must be available\n");
+	first_node = get_first_mem_node();
+	second_node = get_next_mem_node(first_node);
+
+	if (second_node < 0) {
+		ksft_print_msg("At least 2 NUMA nodes with memory must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
 		return KSFT_FAIL;
 
 	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
-	first_node = get_first_mem_node();
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
-	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
+	numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
 	if (!numa1_map_ptr || !numa2_map_ptr) {
 		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
-- 
2.43.0


-- 
Cheers,

David

