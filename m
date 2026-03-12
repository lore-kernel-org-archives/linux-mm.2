Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACE6105A595
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DD16B0096; Thu, 12 Mar 2026 08:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924D46B0099; Thu, 12 Mar 2026 08:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8270B6B009F; Thu, 12 Mar 2026 08:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 725306B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:50:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02E83140226
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:50:25 +0000 (UTC)
X-FDA: 84537394452.08.16C9D01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E2241C0011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:50:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3VxknOD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773319824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYhjd6jcLP1hr1/xaeJSYUqysSjFfTJ2y3WjTHu8X+w=;
	b=H2GtjWJlAmg37Eq5XtTqnqI52LqQPur8LJVI+dLng6Y5F0fG8NMyk3U0jXAEtKCtII8EkS
	ZQnY4C9R3cEIOMJYpbkYtkITna0eVqG8dORCqdSqk9ToktXDxMihdvmmmyKHHqYTd08jh0
	+e4frWcmnF882atMxIxYl+ooeJvQHK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773319824; a=rsa-sha256;
	cv=none;
	b=ftolap6JOEaPkSCdb53XtURSxgxqLZr27ZZ3NyUND0nF5oDmDp72wx6Kz4Oek4SgAmJ2iN
	LxELMNNhG0D91qdUWOujoLQGnDUwaOjQ6XxHWOwHH+NmGsR04td+2z6gHBbAs2p5M1vaL5
	mYoVIUvbyfgZauD8HJug16GTQFx9eo4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3VxknOD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E46AE42D68;
	Thu, 12 Mar 2026 12:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3CCC4CEF7;
	Thu, 12 Mar 2026 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773319822;
	bh=adjljW+VNbO+pN1pMra4pZwRC1mZke1wNpJ+7Qa+hJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R3VxknODXNCIPm7LSy8wUZk8DApPOKFgkwpKvijaRHBrYIEUoEwRgOLK7boYLNW1O
	 b1Picp4lm4PXJWe1N9ubhs0Qg4gsdrTZgFn5Rtsgx2uMZkdce17nMRfmoOPtGDda51
	 L85Kv79rMkwquASxcKxRCTRcJ3EMqOVJKIqOFZUGK+VLE4MRwBgqNf0VFW0PbehFd8
	 FyBVTJp6tW61g89/dUb97UcWJTyj+pzroFsrt55cPMGj6CowugbTL/bR+dnO0Uz30B
	 eUcpGwOpiB3HeKsgDMK3Lk7EQ5iMpDDKnxk7YbqHjy1BM/D1sJxOGx46a/qXnAjbYE
	 UNd/jtMKxTJ2w==
Message-ID: <457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
Date: Thu, 12 Mar 2026 13:50:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: he1znpaa5pb8984ncyqio3dsufzp7ri3
X-Rspamd-Queue-Id: 1E2241C0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773319823-206943
X-HE-Meta: U2FsdGVkX1/hK3ad4uWHNan3VFTVvb5mwdYUMYh7rk+rMY72jcNbZoPDyUdUVJdnXrL37GGBynl/UzYvXAeu5gtXjv8as2S3vhGuEqeBB8NWVwq6iN/EK4LLcn3GxvJDZwnhz+7hMv3OKRPFJDyBdbMDFf2kCOp/zK8KMDjyLtqkqSP83mkm3t0xSGkHFTRddWGWKaWPgWe5LctBh+L83JgBZNwDl9P3tgo1+xj+4XudacwcafHncwjdmZhFdlmCY1W8zEa81qy5BvydBwQzvgSmVucn7fkILRWRNIAX0aHGs5gEM5Ibk8jY0pq0NU/M2ZpBOQPi8Qyu+4fpvMYNR7ExmPBh318WkMZYOjqEXl+EOYbbJFJVWaQnPJHLYy7+H/kHyDbDVm56Qv7eYpxTp0f+mH6H1zAwLpFv9HK14yRtwI0YtUhW4hIzay/+Xj7IrCm0ofB6hvO5ciEIljEKIghy6tzyAJb7sBA2MILWVlW8ToxRuiNu/iNMiqiqc5RMZYUYtJF9jXGdrQdTJN5jlLHb/0uT/3+oB63YecaVtyWZsxJ+2JC+vJ1TsoQEaXIaB7DbU21P/NcrmX5HL6Dv7hP7C848Q3NZFA3fiRnc+FA01j+UAGCdITzBXzcZgZblfWiTxUzPYQXAd9wC5y45pWMNLQZHVYIbVv0pwXrrDUvxXHpcsmiC0uY8O95kw2LIPiY30q0ctUEu/JgxrOL0MFtLPeMSY+V2QCmIsz16letaaN4ItGmb9qyD8V297xUiuKqMFVivMs81T5jQAsNgcjkagz0MkekiXw1cr+ekO2RIH0Gu0lFwyvQO4/ZNt4/6jso2mhzT6IHp02ETVg4YLE1exl46X8ZCFMuHMrwOo7XR8EoBnYfWhlYkIfS+LVUGe/35Qj0fIcXrRJEbb6/Omy3F2e0YuwsKK5Lo34b4iHBJtcBX8SfFBj1xfgL7WOMozmjgY58dQlFA042FmpO
 hQwW8Rtx
 +oYrAjLRtdbgE+cXvu+8/E3JkcSz+w81ybsblV/n9hF2KEMce3mzN0XmzWsymqllQWnbWemAB8KKOXsiVseFNdfpkI1K9+48ePOLxISXx6kMABSXggxWCDMkQG64PQEMVDh113MHxS+oEdGGBj2Sf7eObS8+j3Ou7OXi7uBnd0/CR5fBzAcYOTNQsJ7fLtMUgZAigB5y5cPwXa958zl55tNY2hFYWodBmL92LRlDd25/gG0mOM3noxyWKfKmWOYX97zZRaGXpHq8t8A8FzbnUHcC5IkWqQYTo+HwxHFI5jpU5jvm7CuzBG3xJhN2dGHTKWVzLojmzhabpxobesACF2mnFsHFzsEBz0SzI1OnjD49NgPE6aclsFwH+fOZd92LUSPE47axkU1LrhP1bqt1HMmkVoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 13:25, Sayali Patil wrote:
> The uffd-wp-mremap test requires the UFFD_FEATURE_PAGEFAULT_FLAG_WP
> capability. On systems where userfaultfd write-protect is
> not supported, uffd_register() fails and the test reports failures.
> 
> Check for the required feature at startup and skip the test when the
> UFFD_FEATURE_PAGEFAULT_FLAG_WP capability is not present,
> preventing false failures on unsupported configurations.
> 
> Before patch:
>  running ./uffd-wp-mremap
>  ------------------------
>   [INFO] detected THP size: 256 KiB
>   [INFO] detected THP size: 512 KiB
>   [INFO] detected THP size: 1024 KiB
>   [INFO] detected THP size: 2048 KiB
>   [INFO] detected hugetlb page size: 2048 KiB
>   [INFO] detected hugetlb page size: 1048576 KiB
>  1..24
>   [RUN] test_one_folio(size=65536, private=false, swapout=false,
>   hugetlb=false)
>  not ok 1 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=true, swapout=false,
>   hugetlb=false)
>  not ok 2 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=false, swapout=true,
>   hugetlb=false)
>  not ok 3 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=true, swapout=true,
>   hugetlb=false)
>  not ok 4 uffd_register() failed
>   [RUN] test_one_folio(size=262144, private=false, swapout=false,
>   hugetlb=false)
>  not ok 5 uffd_register() failed
>   [RUN] test_one_folio(size=524288, private=false, swapout=false,
>   hugetlb=false)
>  not ok 6 uffd_register() failed
>  .
>  .
>  .
>  Bail out! 24 out of 24 tests failed
>   Totals: pass:0 fail:24 xfail:0 xpass:0 skip:0 error:0
>  [FAIL]
> not ok 1 uffd-wp-mremap # exit=1
> 
> After patch:
>  running ./uffd-wp-mremap
>  ------------------------
>  1..0 # SKIP uffd-wp feature not supported
>  [SKIP]
> ok 1 uffd-wp-mremap # SKIP
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index 17186d4a4147..73d53a4da389 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -19,6 +19,17 @@ static size_t thpsizes[20];
>  static int nr_hugetlbsizes;
>  static size_t hugetlbsizes[10];
>  
> +static void uffd_wp_feature_supported(void)

Likely that function should be called

"check_uffd_wp_feature_supported()"

Because right now it reads as if it would be returning a bool.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

