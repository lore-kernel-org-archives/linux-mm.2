Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D952C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8946B00B5; Wed, 29 Jul 2026 10:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482836B00BA; Wed, 29 Jul 2026 10:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398866B00BD; Wed, 29 Jul 2026 10:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12A516B00B5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:24:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08F15A1AC3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:38:43 +0000 (UTC)
X-FDA: 85041314526.04.1F9C028
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51A3E140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:38:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1aGByGa;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiNgAObNFAt6mBMIhHYbsPcfaTdqCcXt9eQhv43/YsY=;
	b=xtT9oAS4Ryx45EBsM/wdP1D4sPVqAWFHp37aQXSlwGWob634/ELzMHMQxMprwkMubv4k2Q
	OKSdkZFThrToVrBp9ZqafZ1SXabNeZ7fenwpqQc5+SFrBClaYVjGRlDEMCell0GRFFAhPk
	fxhp0BPJSRghmQ5nq8+JW3QF6MWwzo4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1aGByGa;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317921;
	b=lmrvQe1MZzd5o+IUmfPiaz6APBQ7ohf1rlGZKi3VqCWoseUrGBvo46Ou5O6qlqjsCpAOEr
	Q5MMm7qmrF/zkLWJwNPyMxqBFjTrpgYA6NvQ7ira2XzJqel7k42nyiB572MTHg8au9X6QB
	95PGdwEZmoRGUbPlzNrULUx30uYBBm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C702960A65;
	Wed, 29 Jul 2026 09:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B841F000E9;
	Wed, 29 Jul 2026 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785317920;
	bh=eiNgAObNFAt6mBMIhHYbsPcfaTdqCcXt9eQhv43/YsY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W1aGByGa4skso+mkb+Im3FRmRn7Jkee/RrD9U3nU/R4b7aIjyGBRijQg+bv+/LnuL
	 NDqgM0kRfXO9nnFrMbXoKUG+sNdHzI8c+TtJtzdTaQl2D3zqE/UK1LsuBo2YgPQ2NO
	 V+27uYKEdCvZwbb1bH8WIirL9OLoU4wHQvkmh4hI6ejKy2LaTJr4qCdGknbSWxurCx
	 Nqs7QT3IXuTUp+BHC/X1q2dH3b1rLGyIbM0+v3FMlsaGe1qxOu1aDwSuBoILS+I4Ye
	 hmvgjShX5bBKsZETgDJa6m0QVqEFK/0sxDTEGoJhOFjZUZvzhFo554G++/tFy2YA5n
	 zTmXR11uB3gcw==
Message-ID: <98c91508-4aa7-4390-b2f0-e39f16bdedef@kernel.org>
Date: Wed, 29 Jul 2026 11:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/ksm: use checksum to speed up page comparison
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260716122039.679173-1-pedrodemargomes@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260716122039.679173-1-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A3E140004
X-Rspamd-Server: rspam01
X-Stat-Signature: 9yqgdbn7tgenc47ui7km86eay18miikw
X-HE-Tag: 1785317921-934870
X-HE-Meta: U2FsdGVkX1/uqviKqcLgK0NEDS+PTDKO6Z0MtE0qwmsNxwdemdEzPDEO2YkZ5Cf+X9xQh4lE/lnyDgIcp8HOXc8Cmz3iE4nz4YmwJ9v7HnUqiHNfBhtMwvGPJP1usZq8iTNxnUt9CXnia1UR9K6NQB6FzpUiD+LlHTMKhvnxLce53NqO6g/u6vcOLz5VXujiwqgUohS/cpo091Wmnxm21SGlXiyOPe3TzwoqjF5nYkaZkbqS6xvFMZr4hLv9hnQGjyRmnU/XkNkrEZhleTdloLKrFhMaXxtdAqXrQ7EdSVcJNIiJiCvxuuz5qErig9TIi6VcyZeRmScvgJr6khOoEQilfJDNBW3ZVYCnx994wh4mE3Zbk1UwSv8Z0IGZrXvw52ICwluYiQTqgrgEpLu6ovpi+03AtpFscgDnveRIsjmKousvJRVHRlU9zrRmwnmR+7zzwqk5gQgU7s8z8f3E0QoROpA6qhv9cdsJSfr6fx+Y2oc/W2v9DvuSfOeivPc868juwKN38lJy0wX+0LZtX7O/Rmlc39RHUxuLhbRi00nF6jfxcC2hRpyZhQxeQIxFsEzw0QBZbcCIZkQABWlu99gxXeY2LboRWG4JXU3zGz6e5RXWyh1q0NvmDvw7x2amQmkxgyISCGgHXzsQpVkLJg5VZjzVlSxbENlypJ62EoiBy2BAhwTBcZKBnrfWEwa2smrQWY2KuWuL/kkdkyauv/slYfyH05A5PfizY/FPPc8P6zS6rCtYMSWJK1e+8cI8q75UUNd17M8H4R0aUQABH/8sFBEFJj0TmDg//rBlM6ZjZO03tFXrsmk8vxHoFgzOI139OB3OZuWlKUZZQAk3r7MojGRP4UM5/YmJApNzLKCCXgprnMf00tgIBuO3DGQcnvN5+ANz7rerE+9h7Dco4smQPgMuNfB/S9IGE2Nh7gkMauUboSvoXa0PHXNz/r+Xym1Z/WLwRY2UgrEX9ke
 LZLMsLi/
 BTliBg2rHJQrinTdO1qTSXOy6J3z1qWiWH2BxyYG/Uvy05R+t8T8w21YNLB8XqK1VKA9L6H09HGzG1M6Lm1j4iQYmlwnqvHqdjrHHJg/8VN4aChKTIHhFNPNjrQ+pLPBxzMupMyJy9jpHsE9Q4sJyw/5EySXVZ044ZdbgONqHXVBsjjb1vGDbCjKdh4HnMF9aSKnr43Azh4f7L8f7EZ7tvAjoZPV2CjBOG1e5IsoOAi1Mlq4+W8GSBnUaGv5k8j1t+idi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 14:20, Pedro Demarchi Gomes wrote:
> Use page checksums as the primary ordering key when traversing the stable
> and unstable trees and fall back to memcmp_pages() only when checksums
> match.
> Since struct ksm_stable_node does not have a checksum field, create one
> in a union with migration list fields, so when we encounter a migration
> page while scanning an address space we have to recalculate the page
> checksum. This avoids increasing the size of struct ksm_stable_node,
> which is maintained at 64 bytes, as show below.
> 
> pedro@fedora:~/tmp/linux$ pahole -C ksm_stable_node ./vmlinux
> struct ksm_stable_node {
> 	union {
> 		struct {
> 			struct rb_node node __attribute__((__aligned__(8))); /*     0    24 */
> 			unsigned int checksum;           /*    24     4 */
> 		} __attribute__((__aligned__(8))) __attribute__((__aligned__(8)));       /*     0    32 */
> 		struct {
> 			struct list_head * head;         /*     0     8 */
> 			struct {
> 				struct hlist_node hlist_dup; /*     8    16 */
> 				struct list_head list;   /*    24    16 */
> 			};                               /*     8    32 */
> 		};                                       /*     0    40 */
> 	} __attribute__((__aligned__(8)));               /*     0    40 */
> 	struct hlist_head          hlist;                /*    40     8 */
> 	union {
> 		long unsigned int  kpfn;                 /*    48     8 */
> 		long unsigned int  chain_prune_time;     /*    48     8 */
> 	};                                               /*    48     8 */
> 	int                        rmap_hlist_len;       /*    56     4 */
> 	int                        nid;                  /*    60     4 */
> 
> 	/* size: 64, cachelines: 1, members: 5 */
> 	/* forced alignments: 1 */
> } __attribute__((__aligned__(8)));
> 
> To evaluate this change it was used two benchmarks, bench1.c and
> bench2.c. The first one allocates 8G of pages with different content,
> and the second one allocates 8G of pages where the first 4G are the same
> as the last 4G. The two benchmarks and the system ksm configuration are
> presented below.
> 
> bench1.c:
> 
> int main() {
> 	size_t size = 8ULL * 1024*1024*1024;
> 	unsigned long long int numpages = size/PAGESZ;
> 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> 	// Generate #numpages pages with different contents
> 	for (unsigned long long i = 0; i < numpages; i++) {
> 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> 	}
> 
> 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
>         	perror("madvise MADV_MERGEABLE failed");
>         	return 1;
>     	}
> 	printf("Wait...\n");
> 	getchar();
> 	return 0;
> }
> 
> bench2.c:
> 
> int main() {
> 	size_t size = 8ULL * 1024*1024*1024;
> 	unsigned long long int numpages = size/PAGESZ;
> 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> 	// Generate #numpages pages with different contents
> 	for (unsigned long long i = 0; i < numpages/2; i++) {
> 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> 		*((unsigned long long *) &pages[(numpages-i-1)*PAGESZ]) = i;
> 	}
> 
> 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
>         	perror("madvise MADV_MERGEABLE failed");
>         	return 1;
>     	}
> 	printf("Wait...\n");
> 	getchar();
> 	return 0;
> }
> 

Hi!

> Configuration:
> 
> echo never >  /sys/kernel/mm/transparent_hugepage/enabled
> echo 1 >  /sys/kernel/mm/ksm/sleep_millisecs
> echo 100000 >  /sys/kernel/mm/ksm/pages_to_scan

Given that the default is 100, and sleep_millisecs is 200 ... and it is known
that frequent scanning is harmful for performance, what is the real world impact
in common setups?

IOW, do we even notice / care?

-- 
Cheers,

David

