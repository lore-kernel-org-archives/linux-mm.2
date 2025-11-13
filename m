Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54ACBCD5BC1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C0D8E0003; Thu, 13 Nov 2025 06:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9256C8E0002; Thu, 13 Nov 2025 06:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECF18E0003; Thu, 13 Nov 2025 06:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68C608E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0F4416094C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:07 +0000 (UTC)
X-FDA: 84105289254.19.A4A0757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FDB08001E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEENvqv9;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763031606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdbjYGFKjRHr2ds2JSRKn1vlCKqDSoksRoiAzU+mzIQ=;
	b=w6i8dssAaCC+uAqD/M1DiNMyjaKUfdhftkliHcnIU60OoZbefKIM78vBMnCdCTxSZczkS2
	yrTiWE8NFiq2tqSTBpEpOkhcBslA3pLY3P53K2PwvYwI8RrMKmu6HqpDNdlzzqXZkq6Exa
	+CgoEdfirq9glfpYGeXpfU/x5tmX4eI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763031606; a=rsa-sha256;
	cv=none;
	b=EzlqXsdGtQ1kBYAzzcD4LVP1fKaEHIcVJIKMk0sgHw/ih1NMSlNHPirOEMZzf2PG8EASP6
	1e900oXsCMe5mlAA4jE7eRcDQI05vYguSbwQo0FdpWM8eFMUfDU4NzKS9O/4LZNpvRwLQv
	lYlFU26eKH0JteaHSz4QA0lo7KXxeOI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEENvqv9;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CED7B60210;
	Thu, 13 Nov 2025 11:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F2AC4CEF5;
	Thu, 13 Nov 2025 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763031605;
	bh=+oFomDfNiypPBJ4AIDYzOAA6/B/jV4Ws0uR6/ZMqwj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uEENvqv9HfAuHD1WXdsKCusGJtCe0M2Ji3b8nXPR13TYeZZA4mxGUOfOSfBqQhceY
	 47poSSR5CIsAcvbTJ6uQzDMDicEQvnD2oKnzxZ/CjpPrYr3MHV13B03P8qRBfdrFKz
	 tzqJzmOFh/BZIGLPHJMWlUATAyXI42mRv+4ufNiduC5OPYRa9ypmwXNV+/euspTNBq
	 G020TvDeAO6iJZMOAnDUJIJJjI8SWxbbg5ELBCIktBkC92xoOoyGufr/s98AnW7CXP
	 pnlFOMV1dXEPugSThOmfoXJdgssakONNpFSJ0q8IgRkBYpkBJMXd0VAjuxnQZbpX1I
	 wW2CKqZzeekIQ==
Date: Thu, 13 Nov 2025 10:59:57 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 4/4] drivers/iommu-debug-pagealloc: Check
 mapped/unmapped kernel memory
Message-ID: <aRW6LWh_1lTce7kU@willie-the-truck>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-5-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251106163953.1971067-5-smostafa@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FDB08001E
X-Stat-Signature: ypro5qwoqjrirx5dpq4mn34f4zdhi97x
X-HE-Tag: 1763031606-268338
X-HE-Meta: U2FsdGVkX1/tYwRMr0SsCZOQ69WgpQTyR4n0zqcNsMSUch1cQr8XDKRnsr1TPGQlLLSgC0JPKz4V8ZijLrA6BPJGQsTiHYrY4mFMlOnI4TJT1ZjkiLb+ZG9PXVm3J+F9oERXBh6R0WJzzXtLMJiF+uqaEBTOrpe+XFeGd0f9w+4MJAPmkUxNcscCOOEI9PU4GrVRAuM6r3JkdeF9LX+zaIedfhxlXwNniAVkXbIPr1Ob0HIgTI9CJR1IeatnBETQu0c6ry+/pgzIsmAvwKmje4jTk0Yll5c3A/AnMIe7CSMozDFh7g5jEHVkCjtqXBDabla+eHFrvRxL8W1PtXLMYRbCik65oY2dQk/62DDIcyAelgAPi7c8ktUVpYd7GwZvke3Zef/dCZmECITczM2/+Kn7wlo+EVLUbIpPHCbd0/Yg34JX2F9+JhQ3tf6ZUVKlzzwrM5KKK8gqPU2ktXF+G1ifpPO5PkZRrzSkaFczIko2IKPr2lPUqsiMg5rA4Q6l49EaLxRsp65HgpcqVs8ZzeMjW6tbLbV3tOBVXrPbh5rqS2CQSyYujsJgdCy1jmXyFCtgW3Mr9lAiimH8hFv7BNLq5okwCdKmPaTuZPQTGZe1QUUrfYYt+tHytwnHRi25twfDDHL/k4HT6GatOIlY67Cpc7/GyDNPqTKexIIVWGR+scq+pzQ2cm04WQNTjW1iEgWsHR/ZowBlkoEHvsaeANLUpWehmZRrH2dhFF23iNZyn3bB4m5l5tZIP1LWbCv2J8/4j3w43yJvtkCIrNRscMqTRZtCOAVO2vo6FEiRMYSi6KKQDVpTecV5cTY02srhHhOPCKIrx67e2vcJ0KspTIEFEGiNSJ5bmqmuBqglwIzKEgs49b4IXPB/f9uhRWLcE0602hSyCMpChMWSSM7DZQ8f+ctXD5jSho4NkfiwWXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 04:39:53PM +0000, Mostafa Saleh wrote:
> Now, as the page_ext holds count of IOMMU mappings, we can use it to
> assert that any page allocated/freed is indeed not in the IOMMU.
> 
> The sanitizer doesn’t protect against mapping/unmapping during this
> period. However, that’s less harmful as the page is not used by the
> kernel.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 19 +++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h | 12 ++++++++++++
>  include/linux/mm.h                    |  5 +++++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 0e14104b971c..5b26c84d3a0e 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -71,6 +71,25 @@ static size_t iommu_debug_page_size(struct iommu_domain *domain)
>  	return 1UL << __ffs(domain->pgsize_bitmap);
>  }
>  
> +static unsigned int iommu_debug_page_count(unsigned long phys)

'phys_addr_t phys' ?

But having said that, wouldn't you be better off taking the
'struct page *' here rather than converting it to a physical address
only for get_iommu_page_ext() to convert it straight back again?

> +{
> +	unsigned int ref;
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> +
> +	ref = atomic_read(&d->ref);
> +	page_ext_put(page_ext);
> +	return ref;
> +}
> +
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages)
> +{
> +	while (numpages--) {
> +		WARN_ON(iommu_debug_page_count(page_to_phys(page)));

Since you only care about the count being non-zero, perhaps tweak
iommu_debug_page_count() to be something like:

	bool iommu_debug_page_referenced(struct page *);

Will

