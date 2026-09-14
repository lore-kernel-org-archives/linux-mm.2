Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB98C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3DC6B0099; Mon, 14 Sep 2026 10:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494CA6B009B; Mon, 14 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386886B009E; Mon, 14 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F756B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:08:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CDC980174
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:18 +0000 (UTC)
X-FDA: 85212547476.30.8CDCFFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A331140017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yc6puxwy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1MgQ4YkjRCW7c7SjK50zV8Sm2h6ALPWZtu7yelOo0s=;
	b=ORTeJ+CfKKUZ8G3//h1gfqCKU5oMnTWq6fArJrSXycyfclhNnTFcttIo1JVkt4XirtBPcn
	uOVw5jpjZvV0lrbDJ1u4IZKQY8GDfpzuTUBSReLjXYq0lkHPj/iVZxgXNUGMrcam3STFmo
	AhUsj7bJn0htpburpeHCVDGGdF9XCZE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yc6puxwy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394896;
	b=7UMzk//DjyKS0j7SsXuvqFrBiuNrTrxs6NG/ujAeRbO1UuBxbSEYaQkDrplsxQq+EFf86E
	KaaD9v+DBs5kIuxQ7Pv/1SorSOY21i2I41bcqxku4e8uNc1SBBqTMFGmDr0MIbDMjSFwxH
	ytwTQ8hmqXwGwkcS2tI77sP+wpl/wrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76E5C41771;
	Mon, 14 Sep 2026 14:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0828A1F000FF;
	Mon, 14 Sep 2026 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394895;
	bh=k1MgQ4YkjRCW7c7SjK50zV8Sm2h6ALPWZtu7yelOo0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yc6puxwy6rANj0lip7bIhBodmX1qJbjM7I+eZjazdFIQgAemi/LuQ/7RNRagtnNYA
	 kL/jlNMvO0jZZrmkjZPX1AvXnzQrWtFRMkeMrp+JxEZ3hI0sd+/5uBronsBq3KPWNp
	 ccFHv2YRryjKhdQe2NNuGHsKZnZV4qc+g1yWE+sfNKT32zVC/pZqOI7UNqvqlCeJRH
	 Ch1W0FCUb21LyLByzEO2iQZwQPorZmXrlsdBknrOviWNrA+vaLvetPBWqP/rcVPTmm
	 Pc/JZzqv1Sws6ZkzQF9W/qkTOKyUeuh+cSMn3d0JraAGtN+iuO/RXRmrJEPzds6d1n
	 mKxTDI+qlHl/w==
Message-ID: <08d3313b-d891-4202-b460-c5cefa96bbce@kernel.org>
Date: Mon, 14 Sep 2026 16:08:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-2-c9a305a01d39@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914-fix_hpage_macro-v3-2-c9a305a01d39@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A331140017
X-Stat-Signature: sudyqz1zjnajuq6x48suqdr6foemn5d6
X-Rspam-User: 
X-HE-Tag: 1789394896-351612
X-HE-Meta: U2FsdGVkX191w9EH8DB70x1fjhj/3UssyNq+i8OgE3Pg0/wtOO5qVsLyqkj1d/i0wRgC7m1lPtDg2RqAo4KmORNx9iXUoLt7hYoOoxwWGWE3+fGaWgRmlseEp0nzwOEhVArshlZ9cBdxF9I12GkeSD7d2YkNm9Qf8l0rUs0rBg51J1qHaT2ngwJm7rZFJRGBXHzDmvrWai1VOxFSmozfpTLSHDrTjLEA1WQAKnPyoAE292+WgbL9PUFHKRvyh3FvcUob6V/n6Co1Gs7kPLA7kQAtiz49n1EIGSeREK3fbojSO9lXsZVRFnc41FF2ZOYR0FFV82tR1K3A564syGEyMRmVEm67adysarE53qwqBUuFvxniVS5Lau0DBEDJmQyakUCsQR6XUSTb+e1V60WVBvMw4m/iDd6ixGe4UONylS2/2s0Cu/EmntOuMCOYOYqDv8ZxwNYJz81tdl91POs5LMDsO9gxDkTCMFFt53C38eB4LKGXBYHA/8MqIY7EmwuaPZb/2UBQRXsXp4U+Fw+rfTWugyAV/56lNbN2UfBLNHj+rSoFtua2qiIjv0IHN1Zp8CcfofwpXgzEUIteboRqr69oAVIjO+qg1DeWZciDumWr8wIj7rv8nMDzyEwNWX01ZomD3lh9TrNddGxwJuVYegodndM26Zk7AKfcM2SWgE7pCb0KzaL54TytWHjOy/mWgvgUusvtd+U3kmR4kdyqJQpTd+rlmXWz0HIfRUwGpUe2fcm0g5S4LD+OJQELF/hB/JVBL5FGKTns6ibNi6LOht7diH59SX/olMdymUX//t/pXV6qWM7/BoMjCK4K7/JNH9ia2lKdMo5n/4oyaeUDH0mI51mdhs/obymQr7KIzxAxUELgXwMrHGhBusZy4qvIvZTKjR85n6h3FvG5hcYBJhFe4lw1WcdERHhLw69u3Rj8eyeYgFCM/gX/hp5C16sTVv5QeaVKBttpkSvyFJS
 l8+3iJO7
 zcqXBhK7N6TVnvPbddkIvzxOEWfzk56tTY5Mx9VoDI16n8PygbuVxP1rlYFz2WY3zSa/WJpzM4ml9jwZ9bB8udn7EE9VnpTXOFykigheWcRVmPYSlm2gJCcvA6tP56UFv+UCI/Z4raFIsaP61atQzLp5Fq2afnLCeKAY/SjY8MMv56sb9Hni22NWptQ0SK51SxuAA13Ikz8OjFso+bQk5rnoJKm1qm2acZpPOEB+muzocrHcowQHbbIoKb80FcIXoG2wal2WwYpk6qP5MECZuOB2s7oZWJchmvusjG6d3XrsjcMaP3eI16UNMO8gX1/OJJYSemJCerd9ohP5GdAPUfEuw28iNdQ+nGXcCo/brnOAkYpFUmge3JzN1xWx1AxK7BjehFV0gfuAyX7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 09:30, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
> 
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> 
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, pmd_psize().
> 
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
> 
> After this patch, output of transhuge-stress:
> 
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

[...]

> index e712a980851c..fd1432dc6152 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -21,6 +21,8 @@
>  
>  unsigned int __page_size;
>  unsigned int __page_shift;
> +uint64_t __pmd_psize;
> +uint64_t __pmd_pshift;
>  
>  uint64_t pagemap_get_entry(int fd, char *start)
>  {
> @@ -161,6 +163,9 @@ uint64_t pmd_psize(void)
>  	char buf[20];
>  	ssize_t num_read;
>  
> +	if (__pmd_psize)
> +		return __pmd_psize;

The only suboptmial thing about these functions is that we keep querying
repeatedly in case of failure.

If it failed once, it will fail always.

You could either add a new variable for "queried" or encode it in the variables like

uint64_t __pmd_psize = -1ull;
uint64_t __pmd_pshift = -1ull;

To then set them to 0 or the actual value after we queried.

-- 
Cheers,

David

