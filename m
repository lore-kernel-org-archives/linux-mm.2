Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB04FCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBC76B0095; Fri,  6 Mar 2026 11:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B993B6B0096; Fri,  6 Mar 2026 11:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B106B0098; Fri,  6 Mar 2026 11:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 937FB6B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:03:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 351DB1B80F2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:03:03 +0000 (UTC)
X-FDA: 84516107046.30.0AF9B05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64ACA140010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:03:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FC22dvTm;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqEWLVTLGCemuDY2A4v9I3atmDnyeDlcblEgWkQMhyw=;
	b=qwxolHeVKte2zve0yE8hvdO71cHmRlRaTFOcWAy8X1RSjudHK23RErqgQEzP8vPkLKAEXO
	jsI+MiIziU0phx3vl8mzxVfuBo3meAz9qwWO+Cevd0S/sqve1dGizg3ALSQW5aJeeGUqko
	eeUBXy5bBUKbxn40P0CaQzKjGyex63Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812981; a=rsa-sha256;
	cv=none;
	b=UEx6+p3gpJErow8q8XV9I3M2Tq0As6pIt6Z/PnZdgdhFrl/3oPePh6LnnXMDeOJ1z8M5CK
	Ha0Fvs8m16dmd38QumQRGgrd+V7TzhjSXk6DSiSSy+ruRhcB9uDbmM8pZ79vC5gg2B6SSm
	qLOLRuq2uNQCCZIlgQ62LsiSwMn59KY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FC22dvTm;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6FDA6012A;
	Fri,  6 Mar 2026 16:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AACEC2BC86;
	Fri,  6 Mar 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812980;
	bh=/Ys4d0/mU9CmjC7P2UTEA2TWEWGsOTVSEX2kYD8lsO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FC22dvTmruFfxpWA6NszR02HUo2o/qCQ0KdUmuj7ED8Er/3uYpMui5k5QgE4IY6WQ
	 EGmUsIR4S72LF/kMcaxN9t669WYnACus4K3IOV+2wXDFFwMsbdnn9j6NhWdl8oeNoK
	 8oIq+df8Y7QHFsyOauk+pIwvlmjL4AhKZcMySpOJb7iiekjHby2I3ssMur6IDNk7wV
	 Rol8lxycOQ6UIUSMtt8Qv17v36qJhsfb8lCXSxUgvksbk4XjOzIIQQYP6qdwT8wYAW
	 ZnvRyA4BnwmIGdqnp0Zw9OPLq5fZgBsrlzuu/bRSrfi/5d/1Ne54tIyA3r715O/wvu
	 kNrwR26Zee/zg==
Message-ID: <e5374250-6fa6-4d39-8a0f-4b1804c35dbe@kernel.org>
Date: Fri, 6 Mar 2026 17:02:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/13] mm/util: Add flag to track device private pages
 in page snapshots
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-12-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-12-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64ACA140010
X-Stat-Signature: ksuid6ggmbtjhfjrcwcftdokbzqy7pdz
X-Rspam-User: 
X-HE-Tag: 1772812981-586371
X-HE-Meta: U2FsdGVkX1+UQGpumVd2nygBImxko/7cgzDNiwOSPmvw3kBguBRTK4z9LVYvI5LF0+n/4Q7FY6IwZVTi+bFL1vvmh8I0x5l3he6onZfLdOXQ3GDart6jEK3hZs5/dfSoN1qi/sdyuZPNT193YddOZeWgvH/9uWTO7VukWVNZsgy31py6BmUOfkyRgpMWB5fdB8UwcX5t03jqg1IC91MFn3uUPsexV9z7S3mz5nivBRAgzi4K+3EOY2p174E8AFeKxCmhU8hcEkJLLzAR8f2oO34HXg7ZdSErtI0Mbb0nwot9keLbVcchh8ShnYPyaXyP50N4uxtBhbpZhms8ttUp347TXTrdwHY/XUdYAzdB0B4GOzXm9xkHjUWU2SGXBzER+AYUuu9Qko6NsUvqDPWd4rxGGj0crrvlbyUibettm551FHFqDPiZQLQbzDZtUhtz+H4F8Kip4aXjzu0aFTDDkr2Yuan7TKzWdDpW8dikyCLX4ukeklpGtOYWo5TsIcHeIQQwEbBFcGhmpeAgBFU8okC/Xj6gtyihq51wGEE9DkZzYlfpmv1s6oy+GHTLn9KLHcjZGUE8Ptp9oFFlHzbmuuziz3gvKOOWHNvyKp+wQ7PfJAmvC+kjxTLzSp/ojLHPgWbr1y1VnpfpwWTVo8O3cTeM8MQUZQqScNtQvwNzU1LObbBkg2MnImp5JpgIb/XV0QYy9blom4fUznWTusWitaapr5BvqR96bExRFjY0pdPbbCyu0jVBpar3BI5PRdoObPYPIhMc7X7o505PCaL2IciHUillaYVvsz1LtJE3snGImy9vi/UqyhN5wHAoE0UxA70y0o2uuw4ZLrVf1MEm9JE3EbAfAD/PW/OKRegaE4iaIKGH3u5MuOZu23dfMrkJFG1qOVagi6ZTPsTrF7rb1GtUD4BWM99Mh8tlebGMkyi1zCTG//U58RZPICzQ5MsGcwsVUSpjSjodknpi6CZ
 yZCllOd7
 BGC4wN+oOEd4My6rgMaEojmzmPo5kZHezB1PQuEJCS83SuEXyWXUelCXR6fMxvkU67+x7oRHLBXd4HqCPTOqNMD2YOy51ft1wQWrr9YKqlDPjj8s8ZZfpOgmOJMRHEXoR/fDEieBu4kE/bhIbrhOqcOjj4+8KsDFZzM/Oqme+lWRdq88P5K/OBFGmA+/By2kSTp5OvQ50QFSF7BNwlpEeiDernGPClZ/OYIFGgXzZujtxOtuvE/VNfwWIDo5TEqhCeXFSkoX8Gs26TvwsYSmHJGKMJnXWQr0MxuNN+nJuJ85N16S0RM1uwJQszsFYpNpWIxiV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal pfns and must be handled separately.
> 
> Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
> page snapshot is a device private page.
> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
> v1:
>   - No change
> v2:
>   - No change
> v3:
>   - No change
> v4:
>   - Move logical continuation to previous line
> ---
>  fs/proc/page.c     | 6 ++++--
>  include/linux/mm.h | 7 ++++---
>  mm/util.c          | 3 +++
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index f9b2c2c906cd..bc14f7ebc369 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
>  	         folio_test_large_rmappable(folio)) {
>  		/* Note: we indicate any THPs here, not just PMD-sized ones */
>  		u |= 1 << KPF_THP;
> -	} else if (is_huge_zero_pfn(ps.pfn)) {
> +	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
> +		   is_huge_zero_pfn(ps.pfn)) {
>  		u |= 1 << KPF_ZERO_PAGE;
>  		u |= 1 << KPF_THP;
> -	} else if (is_zero_pfn(ps.pfn)) {
> +	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
> +		   is_zero_pfn(ps.pfn)) {
>  		u |= 1 << KPF_ZERO_PAGE;
>  	}
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f0d5be9dc736..a52979536a5e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4627,9 +4627,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
>  }
>  #endif
>  
> -#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
> -#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
> -#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
> +#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
> +#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
> +#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
> +#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
>  
>  struct page_snapshot {
>  	struct folio folio_snapshot;
> diff --git a/mm/util.c b/mm/util.c
> index 97cae40c0209..65e3f1a97d76 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
>  
>  	if (folio_test_idle(folio))
>  		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
> +
> +	if (is_device_private_page(page))
> +		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;

stable_page_flags() has access to the page and can simply test that instead?

-- 
Cheers,

David

