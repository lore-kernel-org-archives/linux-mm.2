Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40C0606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l07Usqya
Received: by kanga.kvack.org (Postfix)
	id 06A1F6B00EF; Tue,  3 Nov 2026 13:18:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B786B05B1; Tue,  3 Nov 2026 13:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C1F6B05B2; Tue,  3 Nov 2026 13:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFAD26B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:18:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F334A80F3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:18:10 +0000 (UTC)
X-FDA: 85394617140.06.03BCF8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2D3618000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:18:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l07Usqya;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSR0F9dYIX2PVgUgo+faFrW6sPidANVelznumvDC+iU=;
	b=EAgBIApgOw0umHSDuFRTDnYplhFdZ/ZiJwyKMOJaycXc+J50usgdUKZ1px37WqlKqyK1Pm
	aNZRppDIoCXUODSWA5r9IP8htUA1mOnBeyIleHWpmM/d6HELK1qv/cA6JjJ1btG3d+110D
	Eo/J2Xu5WUgCbdjb1OnC3sabs8qgHA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729888;
	b=E/5JZsDWMh+ShJwq48YYFvM6Ku7KTjgNAgOJQVtjpozHVKHh3VVADbKOPFmmJodjI+7fyh
	HZNXEYS8RgBcnu6U9TkTAETl01G6wkon/gZAUdTsx118Qn1+Ec0KWtqJYgVkLuwHbuFCsW
	uNuhBKhthleNzS85TuENRu4Ef5ztdJg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l07Usqya;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BDD601FF;
	Tue,  3 Nov 2026 18:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9791F00919;
	Tue,  3 Nov 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729887;
	bh=DSR0F9dYIX2PVgUgo+faFrW6sPidANVelznumvDC+iU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l07UsqyaJzFG7ahJtea0kkm7vIGcocBIXoapK09NCgQVLOetoXvpcBgb3I2gf4aAJ
	 Zz+/mrV8BT7jEJuET0svSSpZUAHTOXx8GCKqSx9MfTfhkQVuVOWsX/XvLE0J3csxpg
	 sjX17buevItZO6odX3QytPXCFhPfBsVdygyApnYJ/ORsrQn6RVOI7GoFi9N0/7RTj/
	 GMBa0Gqt/MiiA7O+EQNc65lhvT3i7fv7o8YIt9JSwRSNhaLsinK0HLiQbSUYCdw3zj
	 B5gBnNjLf4+2h0Hhn7cbzg3/k4o678sGKD6KmOhYYCnExsL2jd5JAyKvx46Edht78H
	 P9a/IFOnTLxag==
Date: Tue, 3 Nov 2026 20:17:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: uffd-wp-mremap: keep the THP sizes in
 unsigned long
Message-ID: <auolVwDqg2rXAGmv@kernel.org>
References: <20261103150232.291827-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103150232.291827-1-sashal@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o14fxkujxcijr46mmfbwa8kq6947m7in
X-Rspamd-Queue-Id: B2D3618000C
X-Rspam-User: 
X-HE-Tag: 1793729888-988802
X-HE-Meta: U2FsdGVkX1+asGK4DaNwjmUerlnXi4VUKfCLtA13ZnfeXve7D6MD9jGECxhWHeikfxmXGguJr9y+z5PrgNAAI9KZ3ayi31OA5N4GrfhcR1IBf73Bx+u4genfKYCrNzkRgLUSp1Dxv9JsL9LgnS/43SCnE9uaTMVQjtJlTDqLahpBELCsL8i4u5ACJ9M5DSPMlw219AFAiHhkRTI4IW0soK42oQSYN0kqup0ybLIjuCl5EwstgFh009RU7TxPjVxvmCJ+PBQWso7OXCq9Jvgnd5iZF46sAWcK+OpfXeDA4dOKr8z18lBPTNfWKKcoABVOJ4WR0yP2mJi8xNzS4/Ykr1/cnnPqQ1+0KZMkmPOhvoToXZcC4Z5p2zaMC4dc7MufEdlPVXlFrdnwbb8EsEHpFer45zQaHpQPVPVT0EuEKilxm/aq5l99BKWKlTfLveKzYyQj4F7kWhnnNfRarDngZdWG7vzuPQONouIYT0dR86UDafAP/K2D2No7rQ//qFyRE8AIQZydSXqmbm1BlxBy+g5KR3DQdzR9Tq5Hulls4EOq3deVSXIC94tJi5leYmS/Q1uCy6TUoLKKjq1Y6W+tV+B1cTF+dYMyXun0I/X0Yk1n1rDSznvjW/Ya4iXXYVd+yFOyM8he8IsP6xeUBO7sF9cq8n1OL8KH+jT0Y3UmpQAeTFXBWFrS1tU5PpOXTNrVq1sHuWbeBaWel3sB6PpNjIBuOCpK2KwbuoGLKVI++qvpso2eoyzLjHRLUTFavGxj29ilKEePGAZNZauflcDX3hDgL0UHVZ9kgbyygZjmp8e+5hGoJJiOIzEhB03E+Q/5ByzRpl7jYihf3UadsNC24eq6aa9ilZGaen1K8728dZdgyS//hTBROpizXnh99FEs2cGXVR0X7G57R5h3wgZTX958gHphogsyIhoyWPppIjrIbEPa89O5mV5UW5IYjrl5bBC9gdq9DqLdDcwQCi9
 UyR57ELc
 923VSukztW+K0kRVRzTh5aImxOlivkblbcQQ+WADojKoPrZCdltsH8bwkirfSWGglLWH+uxRB9n+U+sLbZantgJvWCZa984zo3OBUFKOc7OjrnRIBDwXBXg/dluw2O4SHJjxuSjMYe/5dft0U2Sy4PlAfB7/0y6MCGf5ajGfmfpySG3vKQfPQfIGlCJzpHv6geGXvrvg7657v0mA2cPv1JxNQ1uD5zgC8o/1RgZO1Bp0JlF11kp2IBPRp1unYJKyIU115/cXZ2uFx360U0snL15cvVQ==
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

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
Sincerely yours,
Mike.

