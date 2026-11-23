Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E74606A332
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ljFKBqmi
Received: by kanga.kvack.org (Postfix)
	id C49446B05B8; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6886B05BB; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CAF6B05B9; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE816B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03972A84E9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:34 +0000 (UTC)
X-FDA: 85465782990.11.5A64765
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id C013920004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ljFKBqmi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424313;
	b=jFDDJOA49ZdFvn5uENNlv8fU4hPJnB8e1UoYKLmbCWRjsvNSABFjs9oMXnaVpSarepo4f5
	61dDamdl0OVJdhjfDm+heI2lvS5JoQQYkOnxzDqC1z7HSMM44kWTh0Qqstj24p1QYl5izc
	dw5mWs69i5N4+3Qns0HfPw9QHcu0Wlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3WMjSBwi5PFDvIaCpQd7Axi/XWPxIYqZlMheE6sk7Q=;
	b=ExNpomXgEA31uBJlS392S6EHMtTNzdrt/9k4g9RPXmTush2DHWp3tdxM7lfwNoko0Uzrej
	6mVGVHbe8movpBHVl8TMnrRnv7y8UcjNcvWP+eFIMC1HcTo62sGOJpdkbJzYLNPfGb0I1l
	flSxB+FZ/glS+WiOlBrFfTMT93CRZts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ljFKBqmi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAC6F1476;
	Mon, 23 Nov 2026 00:58:28 -0800 (PST)
Received: from [10.57.91.245] (unknown [10.57.91.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFF623F882;
	Mon, 23 Nov 2026 00:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795424311; bh=IyuQOHegOm7o8+idks5YbotHgA2kGInEw/MsLFSwZbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ljFKBqmieG86A9o17mg2OKClKeqYmywjsi88qro4DKa+Bzf6DMkYNr9cZvknPpkUp
	 MK+dIkOffcqanqO2jC1axlvaTs8nppW4q108uU909LcHYNdp1I6oK5movdwY5TJcih
	 uXIzdw84Y8RliXz46ZJI31Ytyxy9qn1kOEfkLx1Q=
Message-ID: <7a3ffc6a-866d-472b-91d6-886ca8095008@arm.com>
Date: Mon, 23 Nov 2026 08:58:20 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Ian Rickards <ian.rickards@arm.com>,
 Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>,
 Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20261123033111.2349160-1-jeffxu@chromium.org>
 <20261123033111.2349160-3-jeffxu@chromium.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261123033111.2349160-3-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C013920004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: zyyq1j8fnqkiqtrpm85edywm9q8ec9dx
X-HE-Tag: 1795424312-463764
X-HE-Meta: U2FsdGVkX1+rLMlk6XsK5ynA1ol0DqeccjNfTbp4hBXzuTPZnV/c8qN6R768BU5s7vyGvYsjTPesbkdgeaoQGt0nZ9zepAo8y899Uy+n8dWE1JsTZAfrJzibbRBk3Hcu+QvuT2Bkp6FMg59XlHioPSY9TnabIdXfUzhMa3EKlLgQR8eDglFhBXOna5JiY6nExLDWTlRlaa//4jVrbj9BFqv8aRwNp6K9hY6KDpccazSATK3OKnSpiBKjHQE0CIPn3ZinodO3ECHNcj0ZyHqmVZa5H0gxmFjr0yyIhFSDdgDefYhbxn5b3eoNc25rRP+hT9bhzSahf/plaJDt+8KnU/B+vYyUwJ29785HbeFcevYtE9hmEiVTW/h1OUCRCEXWzCtTj1yFUAcCOZwcvAk7dNA4JgMXlukQCdvxKyKLNcb3OmAXdzwiSJX1vJvqW93Ii+YdnmcQOaThOBY3RvcQdOoeQ7sAi+SBkpT+eE7dD4IJBpmkuAdtbqanB0bHBMu2+NUtrwCsTUehVtsVF16nMW334NKWsgPdLy8V4qLzjjrkDdOIgoS9hpwV1OzNJNr7pKgoS4rcSeSwalhA3KGb3VWoEM6vY+SjcWDtYao20+r/czVJbz1ufiZShQQlp0CYiyq1YZQdq7DUjJeCzG7KPACmUdY+51FgLw9tau89S01U6xfml6GSyf0WJkzvmmk0O1/PvnDyT7K/MmAzKz38iSEF9xIhabdf/Tuw4WLfOK5YpO4h9M+KyaRn9mrRROUCd39CcgZT9KnLbD/6N4zpLJU+Xx3rwyQdeJggOjO+73H1/qQbEa6eLwSS7wcoztgZFriPJuh9xP7Ng/TBfbYgCHLBw/41OTTzRy0NDA5XDIVntxkTpoO6ld6UuifTfCbqdKlqiLH2WwLq9c6SvDCI94zDlL2OCHv6UMrJAw0EPQQS6ktKCiwD32+5yxl5XNMBirO1oz9mGKXxUBRBwJJ
 S/N+PByq
 4r0vhMfliV1cdnDWzFTE4PP7oOzNzTRbJ2eegZfX8Csg9a5JCUo52Yc3tzfPzOC/T9FxOuwbyB0CFdbThk5Gn5AR4cntFLwdyY/tzrKBBpqtGZZ0spt6jND45H07Bpv/9djCrmxiad142tB7TgQf334DF9fpDi2yXSi7/rHg+KQbr2fX2h+HJXf4/6p/I2a+L63FtDQJv9g+HXumid/Qq2hukEh/VcUuK816hDAvpRdFR0YTBz/HMRsx1A/Rw36wuml7czV7s0NwXo5sROYj1N5YEt45fNwE0St7pGrMPY25On8qyWv1XrjBQ6e0JGFxPImYKePeLznTiY5UQzMAOdgTUDqazrcqZSXIc8QjSEV2xViEEapMzb6kvOA7UXOHKPRefwFjwQzlKk3PRuaV4GJYLz1Rm2Fkw2mPkMp2SoPT52LZT4/w07KO2McAO6ao97+qyv3vlADCLJMcbDjV2qBvG3wrtePxKkmJheZtzbd5phexU00gh58Ua6vPH9/IdtN1aRBdXdY70KAOX0LV5Y/RVZRGnGCGQcomr7/B/NQz0tp5TO2IqeLYjYL4i1Kj1P0L0KL3RBa97YJLz8AfhC0VSZ/cRuWJ1beHMbyrNbZZ63iSwRACuzg8RTKReZOPy0fKHjkj6QgyGtv19D+/FIhHoFB4fbYR/Hl5F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 23/11/2026 03:31, Jeff Xu wrote:
> Add a KUnit test (page_alloc_skip_kasan) to verify that page allocations
> using __GFP_SKIP_KASAN (GFP_KERNEL | __GFP_SKIP_KASAN, GFP_HIGHUSER, and
> GFP_HIGHUSER_MOVABLE) under CONFIG_KASAN_HW_TAGS:
> 
> 1. Reset page_kasan_tag() to KASAN_TAG_KERNEL (0xff) across all sub-pages
>    of a high-order allocation, and
> 2. Return a match-all (0xff) linear-map pointer from page_address() that
>    does not trigger a KASAN fault even when the underlying physical
>    granules carry a mismatched tag (such as KASAN_TAG_INVALID or
>    restored userspace PROT_MTE tags).
> 
> Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
> kasan.mode=sync, async and asymm.
> 
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  mm/kasan/kasan_test_c.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index f34163e19bd6..72342137bb18 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -380,6 +380,49 @@ static void page_alloc_uaf(struct kunit *test)
>  	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>  
> +static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
> +{
> +	struct page *pages;
> +	size_t order = 2;
> +	char *ptr;
> +	size_t i;
> +
> +	pages = alloc_pages(gfp, order);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
> +
> +	for (i = 0; i < (1UL << order); i++) {
> +		/*
> +		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
> +		 * in page->flags, and so in page_address(), not a random tag.
> +		 */
> +		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
> +				(u8)KASAN_TAG_KERNEL);
> +
> +		ptr = page_address(pages + i);
> +		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> +
> +		/*
> +		 * The memory tags of such pages are arbitrary: stale poison,
> +		 * or tags set by userspace through PROT_MTE. Accesses via
> +		 * page_address() must not fault regardless.
> +		 */
> +		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
> +		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
> +					  "WRITE_ONCE(*ptr, 0)", false);
> +	}
> +
> +	__free_pages(pages, order);
> +}
> +
> +static void page_alloc_skip_kasan(struct kunit *test)
> +{
> +	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
> +
> +	page_alloc_skip_kasan_helper(test, GFP_KERNEL | __GFP_SKIP_KASAN);
> +	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER);
> +	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
> +}
> +
>  static void krealloc_more_oob_helper(struct kunit *test,
>  					size_t size1, size_t size2)
>  {
> @@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
>  	KUNIT_CASE(kmalloc_large_invalid_free),
>  	KUNIT_CASE(page_alloc_oob_right),
>  	KUNIT_CASE(page_alloc_uaf),
> +	KUNIT_CASE(page_alloc_skip_kasan),
>  	KUNIT_CASE(krealloc_more_oob),
>  	KUNIT_CASE(krealloc_less_oob),
>  	KUNIT_CASE(krealloc_large_more_oob),


