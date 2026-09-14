Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF3AC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ECC6B0092; Mon, 14 Sep 2026 10:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6E46B0099; Mon, 14 Sep 2026 10:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5DA6B00A3; Mon, 14 Sep 2026 10:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A922D6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:01:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 572D5120187
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:01:15 +0000 (UTC)
X-FDA: 85212529710.18.D5EFE8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 501F9140024
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:01:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Inq1X2UO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394473;
	b=xG3RfFHY48SAJqEKNk6WDITjV+KO7oJJpsh15lYhDq560M3orpPHeWNeH+qUu4yhAkGu0n
	qoLIDl/fXkvsmFTwn58qKeFfvsfwSn7e8W9pKk4OQfHYiYVEP1H+jb5fh/njKZD76Prdhg
	Rzu0qeTBXVuewNn1W8A/J0epqbInWtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Inq1X2UO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/rpbFlDLr3/FaI9P7Zg1rDlT67APBG9Z4kueW2XMzo=;
	b=VBtuy841lUmoxekiMgBcMWbsc/qdp73tqmqori9YDODy1FEDXDvr69Yn0vjmT5gCLpLIIW
	Ou1SdYCNWglp25wnJujfiPH4CmWdLarsMuYs4ZTsWyOKxuOwjUe1CALvf8GehHw2Yg1MUG
	ghBbhPERT2Dkk47llQNnvyV4YDF4HTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FF1941AC2;
	Mon, 14 Sep 2026 14:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073C41F000FF;
	Mon, 14 Sep 2026 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394472;
	bh=P/rpbFlDLr3/FaI9P7Zg1rDlT67APBG9Z4kueW2XMzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Inq1X2UOe1dBhqTmIsSdhFCoEPP5h5w5NuyR1I1U6PjQPPOd2m6RFBkaNpDcjUbY2
	 pqXWwyHqJqaCGHDSGNe9aFIHx1PIJVlhpQze9fMhh79oIEeMbKRCBxtPy+lCeCP15u
	 AM19x+EJoBxioMpAH0c4frPKP8AFlyIVnzKkd74olaoF/m3+ki0PAgYpI/t85ulbX7
	 DFOnIwsL38o7geYbyrF4iu4VIvqLttzbbjlb/lEXYCp77jTEDw/kw9zc34P4m0SwY6
	 60BUGjq36GfUR3br292pkxd1YX4XGcbBY6xgGZeVkOJhXL08ayfMPFapMa6JuDPqBN
	 T+XwUhJeW/MXg==
Message-ID: <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
Date: Mon, 14 Sep 2026 16:01:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
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
 <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 501F9140024
X-Stat-Signature: o1w3j1ui39grajf1kodudc9at3qorwf4
X-Rspam-User: 
X-HE-Tag: 1789394473-385335
X-HE-Meta: U2FsdGVkX1+EJygVVWstcKa6I0lQy6Y2bkqUqedA90ZkAnR+OS8to2tx9KvUUQ9OsR0T7UX9vK4SgttFVaSHhTb7Vft87samUVU9Mlb/2SkIWEaOuIT+ZkJHosMsklVXbd47fhMd5flSIyFxNZG7hkSuCP0np0XHPuo8V/gq2pEKkg09g2fAx4Ky0J0ErKDGSy19/iiOA/AiHnhVYsSeoMpKSfkGgOgYQU4fBC+ecgTju/k7cipn4FzDWKfib3Ct3mGgNyedEEE4B01loZ+eHYlAaDUxFLGSQIv6QL2f/yELorvwKjnGgBxTiv3NHJGzilwyEANN5J4A62B4RNL87S7a3VAA+/a/2zSPv4NzYe27GvfthF+bvuSLnL1XmdR0EGtatC152KajlIaWYUljaTku4o8b5JQeGj6cTFLhBdAc0/Kx26/yLNgXD9Mx/Hxfs5PL8XdrBuz0lVIuUQiG4SJ4Qutc2hcLUh6fN+AIjcdMGLxVSQTeXXRayGQRVW/HrUAWETjgClgPxeRrSGfrbv/HbbcjsCesICKr4rPxNvR4Bvw8B7WnF/BUBBRewSumaUMFsMedGmdbi0NrEFnmUAONW3SlwGZVTOzltLlGsNhBcHOnI+OZ9gZyVo9z/9APYnSbiex+yQ532PfY4RrGYP9wMaOsCwwkNYwcMelABPYHmebwiWOo5gJTvWtjt2l4csm2euY2mtXkNgDrhaBJHWBoBkssB3XDh8p4RyDVAD6lYNOTJtSAyKrbwo01nYOvdUzgbLaQP3Zs2k86BxwRjsUpcEu+yHO0IM5Pi7tSe4/gG1u0c4daM9M355YZJ4cyj6k6W5qKd7iJWLgwZ4c+d+U2IU2EpkChwYGKWNoD458eIm43QcN6EB3wceQyzUrlTcWvQAzDNu+FzgaGkx765sOTRnjVwBprTRSjQyAOyLJjg+mAwfIb0/YG0rUUjd624eYPEofZFrvEGSTeQ28
 wt5QRkNV
 OMbILt4sVY5JdWLHoHkwPNQCgD2uPI851QKbK8ojP8QvLewT9VbpACpuqsPBfv1vt0qtM5YqHiNhBrkx6wGLsdwJRNhzm5L7IGVN7IfS8zixcqbXKOwj9B83EfRzj4fLsaDeC/dSwqZ0F8Hh+RoqTanclbvRlCnS9X50LSlWVfqBKVOzpR+//yfG/2yWPfGf5UwxeQYrWC9JvGOScx3aujgden7d1sdxddzz/Z14SvKttXr4R+bF+dS8qSFYZWHnidimKSM0JaV1jfpLzcGqxPSVdf7TbefX/sl/7BFhjQHIwLw98g22+WfnF8ZwyuvtNntuZ1/+AUsbPGwWWv8JzJYG5m80BCClSesbcrqmmYZqcxXJrXh8pqgH/8BKgUNw6HLUi9j6nxqfJjhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 09:30, Yeoreum Yun wrote:
> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
>  tools/testing/selftests/mm/vm_util.h |  1 +
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index fd1432dc6152..1fef1266429f 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
>  	return false;
>  }
>  
> +uint64_t size_to_shift(uint64_t size)
> +{
> +	if (__builtin_popcountll(size) != 1)
> +		return 0;
> +
> +	return ffsl(size) - 1;
> +}

Could likely just be an inline helper?

-- 
Cheers,

David

