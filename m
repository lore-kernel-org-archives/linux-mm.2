Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2966C606A332
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=j9YW9C3L
Received: by kanga.kvack.org (Postfix)
	id 0F61B6B0728; Tue, 24 Nov 2026 09:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FC56B0729; Tue, 24 Nov 2026 09:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A186B072A; Tue, 24 Nov 2026 09:14:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDB0D6B0728
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:14:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF60AC0AA6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:14:19 +0000 (UTC)
X-FDA: 85470207438.14.C22A17D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A1554000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:14:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j9YW9C3L;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529658;
	b=p6GzbbZQyQOy5cFuvQuVyE+eJrIzeH2aH0Alqsh2josHHCLUorlnV0UwqgV9rkOcplJFFc
	Q52bhlg9U1iZ3bXskMJ+zVDVTEgFnZG6TYOdMLva9JTTghK46q4o/lwEC82iRjIcy7uoJf
	BOnoKdfDWzgjP3/tdw07EuvshSG3YIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tGwmEPNnZKcIeVBveDBfvH+PJuYnDW44W3GOjoj51g=;
	b=rU/WnEbmH/8c/v/+FMHc+LdotPDPLPbRCGd4QsPrhHtWMTheIeyl7RIn5BCK+g1EiDTMYS
	wVrztgR4NUg6No1iIkxwshnCKcNKL+88eIkbUZcN9KMYjrIeP5dDUaQy45rJklBTtAJYyY
	5WhD6ZYH8PdaFNZXDa52jfQE7aecLO0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j9YW9C3L;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3tGwmEPNnZKcIeVBveDBfvH+PJuYnDW44W3GOjoj51g=; b=j9YW9C3L10YmUzDHGReZ4Lm/jq
	l+zDfsrMdSjW3IX+v8yQ/XIfUiSFpS40DN9RKKEToUv0i4XgIMCB2k01JckxokiGfrf1yOAcOZKPd
	xWA6VPbVatx79oSFjXiDrxfvp1rO8yS7SFzt2g3PWhoBPvM7WDvmsDvuAYKO+zwqmApP2JNj8x9Vp
	aRSER4Ar552YvHDItXA0cpHb24zsr1QpoUrlDkQbBbMOSQwOVexUncwTrDBQ/s7dz11dYxQr8lYEN
	sUMp2nV/6oBCaN0PyiNSmDgfBXr1MWtw3vd7K4CsmraXLhsKVVXRxZNGtDbOtmHmhkByojTwqV6Ic
	k9vBzGoA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVrHj-00000006izt-2WBF;
	Tue, 24 Nov 2026 14:14:15 +0000
Date: Tue, 24 Nov 2026 09:14:13 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: kaleshsingh@google.com
Cc: akpm@linux-foundation.org, kernel-team@android.com, 
	android-mm@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: uffd-unit-tests: filter required
 features per memory type
Message-ID: <7kat6qajo4td4zelsmc4s2wdmkhvmlshbe3odar2bjmaucxydf@4tdhsa2gntp7>
References: <20261122082020.1255434-1-kaleshsingh@google.com>
 <20261122082020.1255434-3-kaleshsingh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122082020.1255434-3-kaleshsingh@google.com>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A1554000F
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: giidmctyy81mpg1efrmhb1b8axxxzify
X-HE-Tag: 1795529657-932448
X-HE-Meta: U2FsdGVkX1/NqixYVUT8Xf2Gw/wTzGA9xLxbq6ocAwohMv6WTItdei/Q+u95WGuWEeBFy1aj2xeFnKkptcXzaOfEzSNEF/Wy98LF2RLdUCE8Qv/Lf+LK5qyMmYoYQGfAfLbFVQDmNzjzzNTCNKyt1igZZAkrvQZEFNpHxyBOTwMrmTnV9nRFe3nG2trYVlyDWp6GRyXPznPr76bq0GbDzLqfe4DHmtrNBSSbLqGipBcNuryLy1J6hJOVpeotdVq+1S2BaDAXXwIIu1I13ko7oVe1xBOfXup8zOQY+PA1QjEJocxdrEWAFRS60d6GrgNsjxcU+krAV6FIsqI2asuMj1oWtVRQk0FN0piHdGyce7iu1dGZKn7yZMSw4uZhsylpsxKQYWVopp6vaTc6NnQoH1iE0DA5iHF/aySHDZsbmRHn9uzihO0+E4tJhpCgfObNC+2CJb+OfynqGny97bIIktPwXmyNqcE7yWpAwNJFJ0hevIhj+JG5xFcnfa7p/UtelR4pqnWX0gTSqUS5Gaebz7vX5NCWgBB1gwADfzDn777PesVLkvhSEWkGoaLEK0i62MO1zkg4J/mZsLEIWKBmMTUkVJpyBHco8V8VFcr0XWvo/bgtVHuXYd6Z9kLoEH9K7PFHC7BmeNf/B4oBSeSlBrUxokBX6OaEU7MhXVt+7CYMDTLCLy32kt1Xb7Wif76G4HIHbW37r/zoaFGM3DKgVR+Y9IIFw1R0ZIZywt4xcLOB87quQA9sJ/iiww42qHoEJ6GgNFavGpUQ+Xd50Q4T0AT/eHloDzM1GUuOoV4eHbzU1d/NM0l40gcCt1dj9VTo8+tRTY/Z22lybQ8Pj4OzF8wTwfeki6sUnhALktr/eDu3PDoEPliri374H7MJOCEeBg6+9NsOCkhZG4VUFs+HT9TzCX9SpCONWsabBkyoRUicN/ClwwtLZ7i2w6d+Z94grcqKR5p4DGoCeNKoTHh
 rX97Hk4X
 QlfIWY23GpqBCgmehXjlXYskTFo+ohdHYhKO00e5+ezk6AoW+jXSIxwkCJ6lhzIaaGEc4oEPbQhuHGVQQTV6440vXf2jFkeH7JHFgBy0OYCEwXZsu7H1Bqec0N7NaYqpTFC5SUo6n6LrRaAsLmhL2iB8qMFEQ53VSkqueHu8HfNh+BG4Tta/2xf8IOe0ySAdPW4mW+jS+ko/WWHN6Ahet7bjybmOlg+sf6qtDaWeSRcCd1lh1+c8BF0IzuMLlGxnDNxKaY7JYPN6PLf7F1OhU5vwl6HvwSICVJcWEww7E//6iMYlxuEUwChvb0TgxZbBQ4CheQDJskNiljcsz3Ebt3z/pMBhgEK6rp0ZN9W5MkIl4LgwZbwgE80E67CKqICJCdMSFOgk5ErgMtYqkjhkS7mlCAjDlONrK67ea3WI9pC5wGkbZXKTpWW1INfBqYrM7MtvIjK6d8dsK+Q6eVCe626dZNxaUe5dx0Nc6ZkxsvRmcuFJvpRwDDXJGmhDjY6sa0silNGByRzEzgF3kgjUpdY7A1sqGRWp34HD80JNbulxmfjV7DX1DxoHgPIrIQunynf+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/22 08:20AM, kaleshsingh@google.com wrote:
> From: Kalesh Singh <kaleshsingh@google.com>
> 
> CONFIG_PTE_MARKER_UFFD_WP defaults to y but can be turned off, and
> userfaultfd write protection then works only on anonymous memory. The
> kernel still reports UFFD_FEATURE_PAGEFAULT_FLAG_WP but no longer
> UFFD_FEATURE_WP_HUGETLBFS_SHMEM.
> 
> uffd-unit-tests checks a test's whole feature mask for every memory
> type, so the tests that run on all memory types and require
> UFFD_FEATURE_WP_HUGETLBFS_SHMEM (register-ioctls, the wp-fork tests,
> rwp-wp-exclusive, sigbus-wp and events-wp) skip their anonymous runs
> too. Check and request only the features that apply to the memory type
> under test, and make minor-wp require UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
> as it write-protects shmem and hugetlbfs.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 42 +++++++++++++++++---
>  1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 2a97ba1d6feb..d0dda2ec48fb 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -176,15 +176,44 @@ static void test_uffd_api(bool use_dev)
>  }
>  
>  
> -static bool uffd_feature_supported(uffd_test_case_t *test)
> +/*
> + * Filter test->uffd_feature_required down to the features needed for @mem_type.
> + * For example, UFFD_FEATURE_WP_HUGETLBFS_SHMEM (gated on
> + * CONFIG_PTE_MARKER_UFFD_WP) only applies to shmem and hugetlbfs, so anonymous
> + * subtests should still run when it is absent.
> + */
> +static uint64_t uffd_test_features(const uffd_test_case_t *test,
> +				   const mem_type_t *mem_type)
> +{
> +	const uint64_t shmem = UFFD_FEATURE_MISSING_SHMEM |
> +			       UFFD_FEATURE_MINOR_SHMEM;
> +	const uint64_t hugetlb = UFFD_FEATURE_MISSING_HUGETLBFS |
> +				 UFFD_FEATURE_MINOR_HUGETLBFS;
> +	uint64_t features = test->uffd_feature_required;
> +
> +	switch (mem_type->mem_flag) {
> +	case MEM_ANON:
> +		return features & ~(shmem | hugetlb |
> +				    UFFD_FEATURE_WP_HUGETLBFS_SHMEM);
> +	case MEM_SHMEM:
> +	case MEM_SHMEM_PRIVATE:
> +		return features & ~hugetlb;
> +	case MEM_HUGETLB:
> +	case MEM_HUGETLB_PRIVATE:
> +		return features & ~shmem;
> +	default:
> +		return features;
> +	}
> +}
> +
> +static bool uffd_feature_supported(uint64_t required)
>  {
>  	uint64_t features;
>  
>  	if (uffd_get_features(&features))
>  		return false;
>  
> -	return (features & test->uffd_feature_required) ==
> -	    test->uffd_feature_required;
> +	return (features & required) == required;
>  }
>  
>  static int pagemap_open(void)
> @@ -2417,6 +2446,7 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required =
>  		UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
>  		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
> +		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
>  		/*
>  		 * HACK: here we leveraged WP_UNPOPULATED to detect whether
>  		 * minor mode supports wr-protect.  There's no feature flag
> @@ -2636,6 +2666,7 @@ int main(int argc, char *argv[])
>  	mem_type_t *mem_type;
>  	uffd_test_args_t args;
>  	const char *errmsg;
> +	uint64_t features;
>  	int i, j, opt;
>  
>  	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
> @@ -2711,11 +2742,12 @@ int main(int argc, char *argv[])
>  			/* Initialize test arguments */
>  			args.mem_type = mem_type;
>  
> -			if (!uffd_feature_supported(test)) {
> +			features = uffd_test_features(test, mem_type);
> +			if (!uffd_feature_supported(features)) {
>  				uffd_test_skip("feature missing");
>  				continue;
>  			}
> -			if (uffd_test_ctx_init(&gopts, test->uffd_feature_required, &errmsg)) {
> +			if (uffd_test_ctx_init(&gopts, features, &errmsg)) {
>  				uffd_test_skip(errmsg);
>  				continue;
>  			}
> -- 
> 2.56.1.750.gf70dc682cf-goog
> 

