Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EA6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ipJHz1y6
Received: by kanga.kvack.org (Postfix)
	id F27436B0725; Tue, 24 Nov 2026 09:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0706B0727; Tue, 24 Nov 2026 09:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77196B0728; Tue, 24 Nov 2026 09:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3C646B0725
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:13:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 592FF140BDC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:13:54 +0000 (UTC)
X-FDA: 85470206388.27.5047530
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B31E18000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:13:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ipJHz1y6;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529632;
	b=1uBzCElIDR038WU7LjyhZIBoxP+J0nCqUCoX4dI8ZMH/8QptDDsissOJvCgkMB4uEUjfMu
	JBJ7/1Mk5U4ijm/DfbvZI4RFGV54jQU6C74DcDIFU3dnA/RQcCr4CMVLPg/h4CPa5UebVR
	CzY3RFLZn2JtYNNhfYdCJfOvVMGSLTA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjY3RPs1T45ei4uQmlm6jIypKs8I/ViOOkAu35+Wui8=;
	b=nNGYbeVPrEVTggsdYRPdvHU1FpWhlzhgj2BzWO7O6+lTc2QyFqpA/0AK4cGXYsKqrpvXUn
	Tj25l2thWGKKVDGEwUqIB7ySP1T3CZBCNGAR5NSIcngwLO9NVZPXIfpjDBGaVt9mrRd/Df
	LY14g4sZ/EKMoSpAdItlK+VWcwlD0zk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ipJHz1y6;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RjY3RPs1T45ei4uQmlm6jIypKs8I/ViOOkAu35+Wui8=; b=ipJHz1y6J2sT6cXKuCBtRxBC1D
	p0QB4U1sClw6CblPuSePEDLLs5JUW3yz0Gb9zi5aTl03FSXLHCkehY/m7vLXfMOC5S6sXVp75sPwj
	2Vj+sR3ReiBRCmlO2EnC/lSSGcR8IOlQbeouNcWiTtGk59mqOVZVxzWlkdd99pm1ryPeNUTxk26O/
	or6wpAl+LCGbXKFDzHQY9vBKaGsCEEpkkN8MBFV1cZ9Vtk3smU89o46zmrJH0WTUVen7W+VgHVCbW
	NLrSp7aTsE0i1pxzrLQnPItn5Eh+E14/5F4iOSA0GN0ThM/6ODGm/VMz7XUd1UjxWw+NFJosx4lNa
	+rV9DZsw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVrHE-00000006iv4-1DAG;
	Tue, 24 Nov 2026 14:13:46 +0000
Date: Tue, 24 Nov 2026 09:13:40 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: kaleshsingh@google.com
Cc: akpm@linux-foundation.org, kernel-team@android.com, 
	android-mm@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/mm: uffd-wp-mremap: skip unsupported shmem
 and hugetlb cases
Message-ID: <2h2aukjt7udstg5ywc2sqlyaamwkh4ip3erac34bcdly4qiacx@gnga6rnvsd56>
References: <20261122082020.1255434-1-kaleshsingh@google.com>
 <20261122082020.1255434-2-kaleshsingh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122082020.1255434-2-kaleshsingh@google.com>
X-Stat-Signature: qxgods7zrx1cxhux78gar8ejjbo3zsej
X-Rspam-User:
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B31E18000B
X-HE-Tag: 1795529632-352697
X-HE-Meta: U2FsdGVkX19VK1ZKhaxwwEDQPa1EuN0UiRCBImPWbXM8nxdkcDbe1RoXdJviTy5G8gbGLQuT5yjM3FQ7GVeltcxlH24kNgetslGmlIONS9898kn5NnqWryJOpsLxmO2uP2/aYEKMyZj/CzMThLuAbGuBuzZMvxo9cRPDxyP5n610AS+X39qHdTZYB9VflDLuW+g6j0VlMVya37RDw3cyNXJDdsKghYx/yGvfu/Do6lZgP+DVKtT7mH1sRndG+kIqOinRIJpM9s7J86OizDa9Y0q9C64mbFVEwzSJvqY4sP9N+5QbNpR/jcRN52CfXHQjn/aGiLj39ZUArlqEQjgznPoQPAy1Zvu689lIN5H6EtlYvWbPPJdVF1ulXOqJOgKP9IDEbCda8ofLNMUy6VrNEVJ3yflEmJ5WQTbT1iBFuP0hIa5ocotFL5ZbVPX8YZdSv20x4p+1f/9JkPi7KMTbpDQ5zevMn3xlolsdzQCASHcjQlG6VSqVJNGaOtbvTXgOSduHrvi6tKFRTCnkku3uUNATBBif+3cVi3dv0mOEaniWFN/FRCMf1PFaIMNfQ5JmvXEEzQzfh9h0LRgM1pbbJeyxaFcONxkmQkREhcILlN174Q5w0eESBxhM31sYrCaKAVa6E/1EUboUhNd754g7fa9o5dBSFNAb0rYEGNyBERovF7VfxB2rj1nSnUmfrxwmwLJs7Jpp+7iHQW+9bnfcwJ+QWUZ89e2Map2bar/jVsTIXuEzs3PU2/Zbhkd40VspU0sy6fU3T+pJqeSfXQY8CgzawwFZvXS4+GqvX1Re0an7606qGE9Pu3mB8s2ND2IvO9W337eyTXp6aW/YodzIxnmFalVxB25CcWwjKVo6Bn5Uztn21ptOOj3z8s384sef4rrHI1ALXsOm/B2fkT6jnrs3+MTu8JoM0LlB0RljmHbWoQRQDgAuF3FvEfHTBOTGMvxXzW668KkFUnI7aQ8
 EnenZxCY
 rKHMuSPJIpGXCTLGarVgfc7G8jcuWDGzxJ8vAG8ggC81wqvQ/iDaILwvpbBTep/dhkWwJ1zzA7V4ONfWOF3iPRAHtPOyxnUNL8pCLhNQl2OVb6OHmzh21r5mRer5wFLWI6/VBfg3KWdSawxeR7fexQwVu2IB/b5ygd7sM1cl1Be5s+EIVXq0sr0AgGOSV6uKm23KE3tt98mIFtofjp3iH4s3O4JwXgLn/mUpILZOhRdExnmFprreRD65SUMqgmP2Jv985WAINl3JxqNo9BoGsyLs0XYntF/vlm7AxQj1uI03bS7FQgWKNBfoCS4GqEsS6JFxFMEPnbQBoHZkJMjWHQG0KIK3Yqerlfr3/ilMsplRab85l+FqSds7PkIsFS20xHuQbSKNzMEJ4Q0+rbIlEJoIIS71qwBrc+vIzWnlDWyaFoNxf/qOKjHD3NItRZOrfoIHZxCxnrb0r+gzvhKyzIqhgHk4GEgzK1TQ6cLXJmOqxxjwBx3Iy26e0oEWDxMNgM9X05o0KgXyVQUQga5rzDiFdKd9UMpUXGLsSeufqB17P7uJYfoy+LqnhD4m14TUfG6S8
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
> uffd-wp-mremap checks only for UFFD_FEATURE_PAGEFAULT_FLAG_WP before it
> runs. With CONFIG_PTE_MARKER_UFFD_WP=n the kernel keeps that feature
> but supports write protection on anonymous memory only, so the shmem
> and hugetlb cases fail with EINVAL from UFFDIO_REGISTER instead of
> skipping. Skip them when UFFD_FEATURE_WP_HUGETLBFS_SHMEM is missing.
> 
> Fixes: b2466bb3b495 ("selftests/mm: introduce uffd-wp-mremap regression test")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index c48eaab8e75c..f7b272baa6f5 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -18,15 +18,14 @@ static int nr_thpsizes;
>  static size_t thpsizes[20];
>  static int nr_hugetlbsizes;
>  static unsigned long hugetlbsizes[10];
> +static uint64_t uffd_features;
>  
>  static void check_uffd_wp_feature_supported(void)
>  {
> -	uint64_t features = 0;
> -
> -	if (uffd_get_features(&features))
> +	if (uffd_get_features(&uffd_features))
>  		ksft_exit_skip("failed to get available features (%d)\n", errno);
>  
> -	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
> +	if (!(uffd_features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
>  		ksft_exit_skip("uffd-wp feature not supported\n");
>  }
>  
> @@ -180,6 +179,12 @@ static void test_one_folio(uffd_global_test_opts_t *gopts, size_t size, bool pri
>  				swapout ? "true" : "false",
>  				hugetlb ? "true" : "false");
>  
> +	if ((!private || hugetlb) &&
> +	    !(uffd_features & UFFD_FEATURE_WP_HUGETLBFS_SHMEM)) {
> +		ksft_test_result_skip("uffd-wp on shmem and hugetlbfs is not supported\n");
> +		return;
> +	}
> +
>  	/* Allocate a folio of required size and type. */
>  	mem = alloc_one_folio(size, private, hugetlb);
>  	if (!mem) {
> -- 
> 2.56.1.750.gf70dc682cf-goog
> 

