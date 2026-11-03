Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D65606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VxaGgJX+
Received: by kanga.kvack.org (Postfix)
	id 407106B05B1; Tue,  3 Nov 2026 12:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7FE6B05B3; Tue,  3 Nov 2026 12:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDEE6B05B4; Tue,  3 Nov 2026 12:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 113DF6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:10:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A866F404D4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:10:23 +0000 (UTC)
X-FDA: 85394446326.01.39FA7AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 078478000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:10:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxaGgJX+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793725822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TD4KfNsj3/UrFRijVzp0aBQ2ycYA4MK0lvSZb8XyWU=;
	b=BR6LBKCljdc6UGqA3wntr8X1sUMrExiHJ2LDunkxWDBkGyJ9zocxRldiZCnZpe7h0VlOgX
	hy8JSjdbOBNyohfoulZ6wyYbK76d5jUiGL57woS3Br4wakRfvxxTM+zdFa5JYY6TXDRmeQ
	w45wBIL8+4FGeOjZ87GQgso/WNhqTSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793725822;
	b=bD8Cs6khYH/T1gMQVHWiH+HgHFIpJ4r5kI3v0h5xurJCDGisiAX/dKOTOUCFWhRt0RFPzk
	V2P+Y70nb6OSGQ01GidMCWG7Ycul6SO07GFXfghqNUfLnN/AcieH+Smzi74CWmSrPiHaQn
	QqVihXu8tZRW0yojdsqMP6C93ImMf0Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxaGgJX+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04B2043B8A;
	Tue,  3 Nov 2026 17:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F51F000C1;
	Tue,  3 Nov 2026 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793725820;
	bh=+TD4KfNsj3/UrFRijVzp0aBQ2ycYA4MK0lvSZb8XyWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VxaGgJX+NhI3el1gfofJnmiTMXPVVPFAD/Zbbn2GN8+WYkhKJNmd4FtAzHHVV4bjX
	 Se4xnfAVE52NXtS/7ybU/dgIMm29RQXtpnLk7xb4Wfh4YNy15K3ele0RnTXudceNv+
	 rJxnEsfQRfoVJ7V42VfVH0oJrZAFvLM+x69erRZcn5skFeJFkPu3MzdUWslSQ0bT5w
	 xy3K/kqUZBQqWMRpwPNxVZcF/ZNnQccLeVjG4Q5PTomGqFACK0aMAQBeEAEqiWcSkk
	 pKexwSv6lzbL9OMdMnBETRwZKg5jI87wm6H67UUUxyUonhawZmkJxxnlFhpu6Dv66B
	 v+hUzBuGNVc6A==
Date: Tue, 3 Nov 2026 17:10:15 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: uffd-wp-mremap: keep the THP sizes in
 unsigned long
Message-ID: <auoVbT8O10HFC2ju@gremlin>
References: <20261103150232.291827-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103150232.291827-1-sashal@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 078478000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gzryzpkgnz9u3idfxibhgy4ywfekdhzk
X-Rspam-User: 
X-HE-Tag: 1793725821-36304
X-HE-Meta: U2FsdGVkX1+kfFHaYrmWbecem8ePzHKk5P+wefeRE+IXu3yQQsjszHk/Cvj0FXkN1PkcERcaNJtPC3uFXQaoBZb+DrjJZwpTWnkljF1ZR3Z9nRFKX/uaR40utD/RtgbzE4sOECoDeeMMG/NPByQJLEsfafXyp3i6PIjiF3jWqy/DUPcP6SoEhoLMc8xthvHAsOg2ugTUmrDr5Ov8p+9Ko0O3j5X6LcD9RsyrmRN/2aqf/vYM6K8gqWlwkG67lCGtPog+h6ufnv0/HbT4ycaAkaUEjp8R0I5MSYoa3he3J1GNTkwIyqlgSSgd0HewUq4HNcP4c4cI7FojRKAGt52tqM8J836ZpMh90TlFmoJzKriDuD2Wc/yu7sBP8isL6eFSsn2ToJma42BMx7SEM8EciE5XYzOAr3p3dZ/jr4UCYt87fgPaCFNQXlgKRq16uPbz6AFx5GxrxHnqmPHmsLn2yD4Ppk1/zDfHQVvArrQjjiaoOkuRo/Z1b75aqgX6UzDyMFhSuY7DxnleFBw+bVilBKNIwIsEERYOKqai5fFXgx6v+R+/LF8YWW+ASEhVdfs9xmEVm0I8Egtuq4C514DmN9rIG5wFj09vl4NCVh/dcc0SJfTyJpJ0i0SIh0oTZTapn2xrJkiv12N52Za8SXw3bGa5VnexhSOehoFcb7a7lXhCD7SMrarVguD73eWgWlvi4AdEjEjV06jL+z6UkzaqA61NjNtlK8KEMyCqXLpMrsw0cFUzazZSb5SyjyZM0LK1EJvsXPuXTscvtGSSDIlwZ1rgF4WSGdzdoa7C9KG9YoYFbSN73XVDMDa8JD0pYfD4k8gqLCEou3/wzlByKcexbfpnHNPKFIxRmUSmELRuwducH1/NqFms83Bq5canCANMZ9+lG/RbXUNAfK1B58xSA65DNaVfZ7DWsK5k+sXSGgNGrmry61/xLBfYrvIcF9BZ9apv6jdIxb4i++/f4rf
 osJj4Gos
 plVrgAHxGHHmmwns/+cDxQFLbXLzmSu1NIGjlSGdmoo4XeqR8VPouuSPKeYK91NInMwxFlt1FdMIkjHPYvyU3vr1ISld4+biZFm2ptc5jW8LY3DOka1kZ6JIqvQvnUL7Zq9GYM65HWmcWyfw+4hwlrM7PcoIFs1UiSVhexpl09Umwd+TracNe5kTmiit9hUKZJWkLvjnf8Gv/QWJViWW8KUDq6iLNwL45Taq/Iihsj01ibxlZ4zVzeVPBrKRkmb9Xp8liURDmS85+EAEvMSJf0AcGCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 10:02:32AM -0500, Sasha Levin wrote:
> Commit 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long
> in detect_hugetlb_page_size") changed the sizes of the test cases to
> unsigned long, but left thpsizes and detect_thp_sizes() with size_t. On
> 32-bit architectures size_t is unsigned int, and gcc 14 rejects the test
> cases that point at thpsizes:
>
>   uffd-wp-mremap.c:299:26: error: initialization of 'long unsigned int *' from incompatible pointer type 'size_t *' {aka 'unsigned int *'} [-Wincompatible-pointer-types]
>
> Use unsigned long for the THP sizes as well.
>
> Fixes: 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> KernelCI's 32-bit arm kselftest builds hit this. Built the mm selftests
> with gcc 14 and gcc 16 -m32 (four errors in this file before, none
> after) and natively with gcc and clang (no change). An i386 build with
> clang runs and detects the THP sizes as before, up to the point where
> the test needs root.
>
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index c48eaab8e75cf..fb5582ec5b201 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -15,7 +15,7 @@ static int pagemap_fd;
>  static int nr_pagesizes = 1;
>  static unsigned long pagesize;
>  static int nr_thpsizes;
> -static size_t thpsizes[20];
> +static unsigned long thpsizes[20];
>  static int nr_hugetlbsizes;
>  static unsigned long hugetlbsizes[10];
>
> @@ -30,7 +30,7 @@ static void check_uffd_wp_feature_supported(void)
>  		ksft_exit_skip("uffd-wp feature not supported\n");
>  }
>
> -static int detect_thp_sizes(size_t sizes[], int max)
> +static int detect_thp_sizes(unsigned long sizes[], int max)
>  {
>  	int count = 0;
>  	unsigned long orders;
> --
> 2.53.0
>

--
Cheers, Lorenzo

