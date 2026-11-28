Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716A6606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 03:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=na6IyvOs
Received: by kanga.kvack.org (Postfix)
	id 645486B05B0; Fri, 27 Nov 2026 22:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F61E6B05B1; Fri, 27 Nov 2026 22:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BF26B05B2; Fri, 27 Nov 2026 22:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34A0D6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:14:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D25F1C3DBA
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:14:28 +0000 (UTC)
X-FDA: 85483059816.21.2B20352
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf03.hostedemail.com (Postfix) with ESMTP id CDAE220011
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:14:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=na6IyvOs;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795835666;
	b=tKWRblMVWuILGYznNx+XUP+ledPtwV/aSd/XFSjMYCcl8aYH0+nSGXlXL8J2J3PIxh+ZVd
	RvtaArvQtpu+t+SV0a96gLvl5tpjgg3qOmSxX9ACSig7XlmmM3fP5OzloGCHMGdfZC3hqr
	wSprlIcODZUA4gzKGd2rFqbgsdVn1kg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795835666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTKPmpu7cQqp9OdU/3u1dQB38lywShDeIEXeWARcue8=;
	b=jFDQ2biit6+JuOijTyK0tDT7ag4i3fwjLI5f/nN72LdbFov30Rt+73DcnkclU4d0aF+3uN
	fwPgt/MeU9lGXZj5Gqo/8/3FBnL5l/f4kx3PCYZt/JyYF7wgJW1NawAGupTX/QAgFdIzg5
	SlA33z0iJL4VkYxE7xY/K9CCSbOyB0g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=na6IyvOs;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KTKPmpu7cQqp9OdU/3u1dQB38lywShDeIEXeWARcue8=;
	b=na6IyvOsUpAhRUvw5wJnlVmOZKwpv4u7S6ZFdiwUVU7aJuyZBUXKW+lpp5xZRI3qEPLqWRbgG
	kz0oEqWY6ghGjwbDxUbm/zLdpiPSbDMcSuFJ1tiNx4TAbHIzwwT82F2xecmJZ4POLREdUtv0zpK
	0mx4Pxf0e4m+Ze/0a3pN7XU=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jbwNB54phz12LCv;
	Sat, 28 Nov 2026 11:13:30 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 46203202E6;
	Sat, 28 Nov 2026 11:14:17 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sat, 28 Nov 2026 11:14:14 +0800
Subject: Re: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <william.roche@oracle.com>, <ljs@kernel.org>,
	<vbabka@kernel.org>, <tony.luck@intel.com>, <wangkefeng.wang@huawei.com>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <osalvador@suse.de>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<jgg@nvidia.com>, <ankita@nvidia.com>, <peterx@redhat.com>,
	<sidhartha.kumar@oracle.com>, <ziy@nvidia.com>, <skhan@linuxfoundation.org>,
	<corbet@lwn.net>, <david@kernel.org>, <dave.hansen@linux.intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-api@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
 <20261115160105.2507650-2-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3dbb102a-9860-f5db-28ae-801bdb3ae8c5@huawei.com>
Date: Sat, 28 Nov 2026 11:14:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261115160105.2507650-2-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User:
X-Rspamd-Queue-Id: CDAE220011
X-Stat-Signature: rk3oxcrttxxmgf5gok6wizi7a5n5k44p
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795835664-382536
X-HE-Meta: U2FsdGVkX1/RhSsCO5NsOg2qSuiE4169FHMvHCf5rOPvwJZsqz3s4kpjH1wFIAV0kz1eHoZEHWXIFYYVPhvZRRzWD5ZAiWefqS6vGmDU5T8gb7OTWcPQZAKZ3YyaY/oImWqeTKnn37pIqln/R8NfvCgoGM5rvmw4I2sRtPd5JHT7gZlUbiwLHbx+J9g/Mtv5BcRx2AgoSsyUi/VaOiJuoeDPv2cfs4FWvp9lSPjFG2Fx74V2gxNRvj92hTLz0wuxQd3r7m1OaPABACf4BO809+wFY5MnXCve3GV4iHr/Sm0hNEMfg7JP/0zKSOwsYtQyc0Hd9Io5UfT1C9FQXVP4NeWp8cK3uyrsSINoP4IXjQvo40j1pbc9AEuPi/Bthvv9/N/hU5eBmWX6oOWd9U48eXjx/p7yPi0UpPJCGhnokA52Km3SCzNfZsEqk5edhW9Ql9o/wgqziKf+vzyopR/V8YrAVNBcD9zCkpu1pCGcEEwUCCCX9VVtOr9O/eassHRn8eL7VA7khpr37bVsjEzvWcQ4zXcovAELEOdAuFiAWBbYP5t/M5ZfWkfL7X3B7a8l1BiWlB4IrZqXKMH6uLW+6v0tqgtuUqpGhGqayvXs8mrocD4y2uUiq+jcfMJ2ZAMhsoxJ82KF8snyCLxsAC+AlYoQDMdCqJsYJdniw5BPhtiuYaqACxPFIU3oRv1eaeBS1YW+eV46mkaQJh4ff54Y3qFcAXZua94YRvbkCPLqwxzLvc+2dJqQVaVqhRjAMqBu+edEupj3J8g8usKWzjtA+K+6iOZV5Dcx/L9QNYhcLcrLhEzM8kfs6kBfCz2KQGuuzMvjb3aWqUGhioc/r5vZnUOHDjMhvQAIuyDmfqsAha1PQ12jn4etprXa4VJBPORWA3QxBzrZOrDucxjZZq9efp3ozVmZ4MOQpzJ4KTDjd1Kr4kLAZKNHMiUf93Cu2tEg6Y1uaO2/xFhro08gHur
 j5i5Y6Eb
 rLnn7Uk1tRuMoAURUpegMa+LzZcAMBHti5T+rmzePJi3vYqZvjnKnGcuYwsDK+Cg7zlmziRWBJEzRHyCfJS66hMyhSdEcFAZUuV5072d7kaUlrW3VuhuNydUvgy0GYANOleWyme2d7onymyiMWW0MRt66lUQma81ntPslYhPyV08CsjL1HTNyWqyq8GbWmCv6B8j9n88b8ZynR9/Ji07hm336GlphhKvyoTWTCg4mwUrRbnEavD16U9XdUtppA/Nd66F76H6UAtrUpL4rwWFtaS6hvKCGunjksTsf3PgkU1YZtLW0nuDEGmapA82atPcqwUFBxP3bcTZWEcadnIZCeWcHO/3mMBBRbUqecNWFbJjJ8T3Kk0WQBJoSkvfKDwvJhiwqk2Lp0dkENCIm9a2a6LhmfAezeJZfZmUOrz1TD7SYZBbz+g+DgCKmEDbwstvQvVxwPisF+glU5d7VXpzKMcOjlRYLgvNMsV2WjnGq9WePWR8YICF3RQdeOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/16 0:01, Jiaqi Yan wrote:

Thanks for your patch. Some comments below.

> +static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
> +{
> +	return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +
> +static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
> +{
> +	set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +

Is mapping_clear_mf_keep_ue_mapped not supported?

> @@ -1229,6 +1259,15 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>  		/* The page is kept in page cache. */
>  		extra_pins = true;
>  		folio_unlock(folio);
> +
> +		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping)) {
> +			/*
> +			 * Page cache keeps the folio until
> +			 * filemap_offline_hwpoison_folio() dissolves it.
> +			 */
> +			folio_put(folio);

There is a has_extra_refcount check below that may change the return value.
Is it problematic to return directly here?

> @@ -2070,7 +2122,15 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  		count_increased = true;
>  	} else if (folio_test_hugetlb_freed(folio)) {
>  		ret = MF_HUGETLB_FREED;
> -	} else if (folio_test_hugetlb_migratable(folio)) {
> +	} else if (folio_test_hugetlb_migratable(folio) ||
> +		   (folio_test_hwpoison(folio) &&
> +		    hugetlb_should_keep_hwpoison_mapped(folio, mapping))) {
> +		/*
> +		 * A kept-mapped HWPoison hugepage is
> +		 * no longer migratable (cleared by
> +		 * the 1st error), but it is still in use

hugetlb_migratable could also be cleared by folio_isolate_hugetlb. So when a kept-mapped
HWPoison hugepage is no longer migratable, it still might be the 1st error.

> +		 * and should/can go through same handling.

The folio has already been handled in the first pass when 1st error happened. Why does it
need to go through the whole process again?

Thanks.
.

