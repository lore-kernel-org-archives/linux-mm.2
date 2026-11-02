Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D62606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C2E6B05B5; Mon,  2 Nov 2026 08:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3B96B05B6; Mon,  2 Nov 2026 08:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820F56B05B7; Mon,  2 Nov 2026 08:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5226B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:39:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA940A8AA8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:39:58 +0000 (UTC)
X-FDA: 85390287276.16.151F293
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 385F140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:39:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSHYl2ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drC7ui1vqpoznwNQPJ/mkzkctCxYdxCsGvREcxstvos=;
	b=PHHuY9hdikejUe9w+5waoIlLRP0DQCCkeqFevWuP8ww0l/lio3W272uVet4G0UYAJ17/nL
	d/3IzemNB4cAOTPsjdpO7WANFCgM6LRttDRDtFOLQPqZwrhZiErd8h7W2XxeUr3d4Ly8jK
	+eWLuUnWvQi9+ge0AqH02I/HK5U8XoE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSHYl2ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626797;
	b=GhXl6vlxaeF3wh+v5RMjFCjaZ3ntU8NZfEoCdScHendCwf2o1y98Ef7Rjh4rIXVzj7yNHF
	kF2qwxrDPtM3eakV68rfo10WfpMU+W3jalhMS9xXnWkqWUuAzDR+z08/CTF6GRMIri9584
	Ap1JneYhSPUnDbNzxmLzSxKuBneoN94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DD8A42DA4;
	Mon,  2 Nov 2026 13:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0555F1F00A16;
	Mon,  2 Nov 2026 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626796;
	bh=drC7ui1vqpoznwNQPJ/mkzkctCxYdxCsGvREcxstvos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dSHYl2aiukyQNvZK74IPf2FV5u8vwz8MQJpvzauaB5v1gswWIvlbOX0eiIdMEAFhL
	 uDoQ/c8ZRQJWDpYyHBVnQjn5c++6pTetADUp2z5LHb9Ez9k1ZPKumTi+f5QOLPzEXe
	 QwDtrxkijtBFdVDg6gxukZ8QTH5q1LDpmQSYS5ri6vXYrvVMdmnUxlQ1Esgh9ORU0e
	 okUNkHp2ihZ5BOKRPdVksHnowZLx681qhv20MdF5fVs9M1uKqsUVbiwbAqZU9gU1Pn
	 QMQuO+qar0NWEae3qZhr2FyohR/1kl6+Jhlw/GLX8At/7y3EdeBjrGdFKyhp4tY+qD
	 TRnsxZg4fLpIg==
Date: Mon, 2 Nov 2026 13:39:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] selftests/mm: test mremap() with an old size of 0
Message-ID: <auiSj5MUeyY907tJ@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-5-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-5-c1829811aed0@toxicpanda.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 385F140003
X-Stat-Signature: 11fsnw9h94uzrj8xf1yhxswkmugn5tah
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793626797-556561
X-HE-Meta: U2FsdGVkX1+LvxMd/hB21A7WDqw1x+3gr5OmMWxDIHUIpb/t3kOfSunkFOscoITIXrhrDmdilm7xKJQLD6oNQwCtcBII+WL9d/dynrEw/XBAW0GqgL9AYYXYzr4KJBwREYpxMZKrKzAjOTqmcZzhXasgYVo6BmaFQupJYRsGN+IipYx0KqB/ojuwdse69KBg7XWYMUIbCCcGPbgLH2FqlFVqUxnE6TLIdIRFjLasN7I3NwE9dEq0zJUa3z7z4NdSqvtWN1sm7NjNIgae59L+80BwUI4fj8ch87H2IGy1ywvz3PYy2ENtzuRAC851T6Hm+hkEQRUkpfgdroUrKUOa7ZFDuoy8E1XA6/tI+8RUQjTJunkEZlUycdyE7SNeWCvihmkOJnxP78iZzcr0nair3Gj/YhTEXqOBKvd+N9t70th6pOWmg7kkYb8anaCt7XMsfvaSfMa4yKIoDRUc+W5NJEg4hzAjHkvM9bSAjEvABkvJzfkc25yw2wnuPeNOmUwb59EzyYE0y0uwP4Vk/5HxuDlTjByz75As3zk5IRAyIUAzhuh/AvgH5lCjh5NKuHIeNYXGUdWrZCc0rpSpjAXghImToFOCkyhsJ+fjkc2Ti/CghTDGrVriZv2zEUt8hw33jvPGWrlna6WnrbLYVpC+xqUtLW4savotBLRfNpFyOdJ2EnbNs3nBNt298lXx2UOTsd1LkUxmZJZFAA59P7VNLzvizV6TTDq4Y5ulXeRhEu6cpODzVSPh7WbnvyjRFqGZoIolgKB3IIEwhiVQ+QkzIjPiyIz6vuh71/QbZzWR6nVHlQ87WT1WktQVkB6nuhiawmVr//vfHHoW8t8pW2M1eWnu+cS4ne9lGsVR5m4xAwVyQtuBDYCaIf6We8nU3WA69AH5HhjVOclzWeoWsT4w9N3Xebk+6ch+ahirfAkLTRcD2ROsweYJRYpEKGE3nJRbdXte9dSeOoBN9leFXBp
 YthAXnlA
 dHb/mwoIRkacEJ6EvVDgp6FstIZ/y3pGiQnN6EaUyO7I0Cfwo6J+dwe75QCivd2kH396QCbckA1Y+MUIc3dXpLHZMvIMX+5ZNXYci1OZxZlIV9j4DfpJyYgDg2aUnIAk0aS2VBH6lfBIPVXsYgxG0fa+ZhtfVOOoIKlB6K9gWqyVOHohUFhItKySwUitx1KhOvWw06vUWWE7XapKarzJKla2Ylmx8S2kBpWxHXyv3kqNrTJXgcYbfUNVkwu9d8KD8XcnAPnR7qRGzq40GZlKdLuDkqTMHHI6l+x4uT3Jj1kALDkwQ0IrfO0EeawZAZr1yLJGMZJiAlkO/ovEbgOlosz0q8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:50PM +0000, Josef Bacik wrote:
> mremap() with an old size of 0 duplicates a shared mapping, and mremap_test
> has no case for it.
>
> Duplicate a shared anonymous mapping, once from its start and once from the
> middle. Check that the source and the duplicate are mapped by one VMA each
> and that they show the same pages.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Looks sensible so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/mremap_test.c | 52 +++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 31b484517bda..92960fff9537 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -603,6 +603,54 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
>  				      inplace ? " [inplace]" : "");
>  }
>
> +/*
> + * An old size of 0 duplicates a shared mapping: the pages show up at a second
> + * address, and the mapping they were taken from stays as it is.
> + */
> +static void mremap_duplicate_shared(FILE *maps_fp, unsigned long page_size,
> +				    unsigned long offset)
> +{
> +	char *test_name = "mremap duplicate shared mapping";
> +	const size_t size = 3 * page_size;
> +	const size_t dup_size = size - offset;
> +	char *dup = MAP_FAILED;
> +	bool success = false;
> +	char *ptr;
> +
> +	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
> +		   MAP_SHARED | MAP_ANON, -1, 0);
> +	if (ptr == MAP_FAILED) {
> +		perror("mmap");
> +		goto out;
> +	}
> +	memset(ptr, 'a', size);
> +
> +	dup = mremap(ptr + offset, 0, dup_size, MREMAP_MAYMOVE);
> +	if (dup == MAP_FAILED) {
> +		perror("mremap");
> +		goto out_unmap;
> +	}
> +
> +	/* Both are mapped, each by a single VMA. */
> +	if (!is_ptr_mapped(maps_fp, ptr, size) ||
> +	    !is_ptr_mapped(maps_fp, dup, dup_size))
> +		goto out_unmap;
> +
> +	/* They show the same pages. */
> +	ptr[offset] = 'b';
> +	dup[dup_size - 1] = 'c';
> +	success = dup[0] == 'b' && ptr[size - 1] == 'c' && ptr[0] != 'c';
> +
> +out_unmap:
> +	if (dup != MAP_FAILED && munmap(dup, dup_size))
> +		perror("munmap dup");
> +	if (munmap(ptr, size))
> +		perror("munmap src");
> +out:
> +	ksft_test_result(success, "%s%s\n", test_name,
> +			 offset ? " [from the middle]" : "");
> +}
> +
>  static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
>  					    unsigned long page_size,
>  					    bool dont_unmap)
> @@ -1248,7 +1296,7 @@ int main(int argc, char **argv)
>  	char *rand_addr;
>  	size_t rand_size;
>  	int num_expand_tests = 2;
> -	int num_misc_tests = 9;
> +	int num_misc_tests = 11;
>  	struct test test_cases[MAX_TEST] = {};
>  	struct test perf_test_cases[MAX_PERF_TEST];
>  	int page_size;
> @@ -1385,6 +1433,8 @@ int main(int argc, char **argv)
>  	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
>  	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
>  	mremap_move_multi_invalid_vmas(maps_fp, page_size);
> +	mremap_duplicate_shared(maps_fp, page_size, 0);
> +	mremap_duplicate_shared(maps_fp, page_size, page_size);
>
>  	fclose(maps_fp);
>
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

