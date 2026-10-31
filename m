Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218F3606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMlx+PVU
Received: by kanga.kvack.org (Postfix)
	id 4308B6B05BF; Sat, 31 Oct 2026 05:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0A96B05C0; Sat, 31 Oct 2026 05:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7956B05C1; Sat, 31 Oct 2026 05:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 118946B05BF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:35:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1203A0903
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:35:12 +0000 (UTC)
X-FDA: 85382412864.03.E10BED6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2618A1A0006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:35:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMlx+PVU;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439311;
	b=Cy7awgKWz3kAnCp/Mn2pHFlNh5mgG8akKvZpQrtH6d5cQWUuj/lxn/ae1pLTq5rgAfs7Je
	4q+K666T9hm/0GSQJ6n7pH+mY+7QNyRnTF3Nx3MFgxJfcwOJao7aw30o0pBEqCCQlmQiay
	f2fg4ufPbNDLLV1+CDZkZySooNjMacc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMlx+PVU;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXiIcJEvHHW2WbJurL7MDrlUJa6yPyxGwD0eqcXi2dQ=;
	b=3ClWFluOkRnVHclz39SyhpZ+QC96SljWSE4ae0aifbaKXGyoXAGMO2KhUzALVtunNMniDh
	EveJzvVWtJ2lp1rG+2PIn0/nVwZ+MTZrkdcicReCDC2hJnZIyhnNPwbSco0Rl8fenbBJ/s
	uDGSi4wHPCkLTG43RlfHKHExASIDSO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B609F6022F;
	Sat, 31 Oct 2026 09:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC98B1F000C1;
	Sat, 31 Oct 2026 09:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439310;
	bh=oXiIcJEvHHW2WbJurL7MDrlUJa6yPyxGwD0eqcXi2dQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iMlx+PVU+3s2S4Nhekc1XnebcbMUhBTXzSaTRFIXiv18Q1Rd+Kw0avo0s3mkmoOU9
	 LhAc8Ule/FkKquWC8kZrlzFmx1zxugwwMrActpUlv6TODjH4ePNPP2EUqpszUq5sva
	 mxklnCJ4ZWiftJjEqjrjC9L7pnyridW3SKXk4emaPQbdRZsZrl10E+iHGquEQf24xZ
	 8P2GVjncSLR8m2po/4dFaDrEMfvVwEpkNPpusfkbyW+OtgaUgnzuRJoegxSbFCPGoA
	 //NpUu0ULR6N7TW0gZ8H9dPBlLiyhMaycyDda4jy56U7Yb3dhwvhkcsppSD3b8E9/S
	 Hmf50SLmp+5KQ==
Date: Sat, 31 Oct 2026 11:35:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 2/2] selftests/mm: add a uffd test for re-registering
 during UFFDIO_COPY
Message-ID: <auW2RZNy4jgR-ZNU@kernel.org>
References: <20261029221129.89068-1-azpijr@gmail.com>
 <20261029221129.89068-3-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029221129.89068-3-azpijr@gmail.com>
X-Stat-Signature: 9qb8xaz6d6f97yig8jg9d6w1rqccqc8s
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2618A1A0006
X-Rspam-User: 
X-HE-Tag: 1793439310-74420
X-HE-Meta: U2FsdGVkX1/w4DBSr4xohUDCefO6CGNJfcbbRNkrQbEoOLi6JrjyFjsFhXMPH33kFWZn3XFgOpjgxDmxvKBs6yxKZ/962NtUwEL9AnUsTpWV4eiY+0GTD1qL/Fdpin9gg98pp3xDb849wIMxL5oGnU27xwuJAeoCtn1/n/Za5fTCVTTVLbCcg0C8ESa+6+hgDdHxml4T7yJAkX1ZC1PIijp1uDI0rdeDGAntkvij11uXLqQ7v8/jcqiIwSVfDL4FOBaMyUmFIjAJX1lBAW5EaWspfX5UDflQXli6/kowFhLXI+mhFDtq3OaYxo4qwY+f4BAyUyVBTtw+3aVn77D51sV8YZLONyL5LjaPSz8o97oDHZl3Xp+EQXntu9nLlS+c+pzOn63YRCmmNLp5K8MNkompUSkkoi9lbm/R4MVMn6L08FDZGGBjhNo+9NaTF6MuwGfZ4q4sDZj6iN5jGjUtbGoRh6lckvWI2Gt/AFrrTrEo7ztW5PhzuzyDcWoQpn6GBnmztfq4qfEASUBekucP42hxhv3+ybfptyjhgNyG7exuYc9DbAXbgwytMZRcpcrjNMWFiSEh2ad3jHpJgQS0vRMUas6MECOtFHzbc5OR2P/JjWrG7RmDObYrlEppS8exGNqwhvx0p4SQvDYUISdjBUQSdlheRMLlweasExXnS18v4/LCeyJozM3tYw5dAHRDPrUCvreAayLyNJPDgcBTSKusVpPd10qsXjTCn0Py5OCa5TCLvVMcswwQmVjifFZdSYFEVN+y8nJRE2Sc7Z3xx1aXLb83iqOONudcpFn8+wmxAWCPJPGbkihq56oVuXZM9b8eNa5gl0M1mKuNj2J9+e+hFyab4J1kCltTZxUBuIDvmp1WvA2m3TQVViWDVgsUYKkCBqelGEv/7p/ajJQY90h+4RjIh0GWX13vMU5hav/pq+Gr6CeC3pm8kKCIFlq/Fh3rND/qcbePoiB8i1i
 ibdDMQ/3
 Jufv8Zpge5IVjvv69ystQZBgFRrnN35HhNQsvY2+zgJ14LwUn402j2CeWkr4QiiCgiipjZMvXHPxsXvQkihTAhD32ip9i+lphlJs/zf/iinjHG09nShTcgi81NC42X2ZtA7pl34jb/QorK1JSAYA/L6CetcfOTwrVg5omJHS+pWVpet7XCYYO+1tkuPTs/kwioyUPOInJXtB4CKOzqpTVjmBrb1XFxRqCruydmtMmPzvmVjdbWUVTv9SYATG1YMWySPoCqZ7E2ES15Fa4+6BUjotYQ1sHwhu5zLefsNiBNYNtpyCxS1qzz1MEzRSmpnTs163gxTmY/ksnj60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:11:02PM +0100, Jose A. Perez de Azpillaga wrote:
> Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
> waits for its source page, then check that the copy fails with -EINVAL
> and leaves no uffd-wp bit behind. This covers both the hugetlb and the
> non-hugetlb UFFDIO_COPY retry.

maybe "all memory types"?

> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
>  1 file changed, 105 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 2a97ba1d6feb..8a7efaa7b3ac 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
>  	uffd_test_pass();
>  }
>  
> +struct wp_copy_args {
> +	uffd_global_test_opts_t *gopts;
> +	char *src;
> +	__s64 copy;

maybe result?

The rest looks Ok.

-- 
Sincerely yours,
Mike.

