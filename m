Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EFECAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B140D8E0009; Tue,  9 Sep 2025 03:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4E78E0001; Tue,  9 Sep 2025 03:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4028E0009; Tue,  9 Sep 2025 03:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8899F8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:11:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12C6AC03DC
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:11:31 +0000 (UTC)
X-FDA: 83868841182.07.1EFD71B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 342C0180009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:11:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757401889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6HnATaFlMZkWcAgUi9w8ZPO3zGuvEjZorSsRUWMnac=;
	b=wzkszQt1fscZ0BmA3HX4c990/hExb0CDIltUecq8Cp/s1NMocXIKwxrF9KHml5NkrfHhds
	Vj9oGCkXiw+laVBnUhxX8DsxV+rDhyhCs5f5zIFDiA1olGZQfB1bvdVdfe/1/AT5G60A+1
	jZ/gUMUIj+gIRlOT4GeCevsejqe+NmM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757401889; a=rsa-sha256;
	cv=none;
	b=h4niPZdf8Sa5lw1TVqPYL4Z0i5rf4SmphHoOUVpWpJTUAVJZaUsPVp/mDVXZvconPidIet
	wN5jZ5wZSL4tNG4okRIbCJ0CS6A6G36n6813G3SsuueiWs52hNl/pBS3n3Y9YGHzLshnyb
	mKIPat90vee9z37lOeKzYn/qRBupJrw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC68815A1;
	Tue,  9 Sep 2025 00:11:19 -0700 (PDT)
Received: from [10.163.72.34] (unknown [10.163.72.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AF733F63F;
	Tue,  9 Sep 2025 00:11:20 -0700 (PDT)
Message-ID: <949a4c77-06d8-4975-b81b-ea7df2babcb9@arm.com>
Date: Tue, 9 Sep 2025 12:41:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav
 <p.raghav@samsung.com>, Kiryl Shutsemau <kas@kernel.org>,
 kernel test robot <lkp@intel.com>
References: <20250905150012.93714-1-kernel@pankajraghav.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250905150012.93714-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 342C0180009
X-Rspamd-Server: rspam05
X-Stat-Signature: 9ppi8819wetb47rmiujkd8jd73o3fm69
X-Rspam-User: 
X-HE-Tag: 1757401889-782516
X-HE-Meta: U2FsdGVkX1/xXu4NwagZAKl1eEB/F1sptCA2P8FClGgP5UR/s2oWqSURzv+smK8gISsp+VZ+E5/zP9ZSAy9Fu2XrxAfSrLmhuJzI0BokVJNXo8iOhHJWZ8XZODFbi305UM18zvChBiadDcRFyHQg+gDi4iS+3X93uiZsKw87K8y30RjP9y8DUY5kLs3odURV7NyC6qRhuxL+VRa/gfvZfkg/mh0Hf5YnyX8HrrNULwzqD4JcX6kZ6E4dO52teOpac5z5uqelPtVN1diPvAqbtt0+Gr/XPs5WGt/6xiLMy8F17OkYKX45dtmQysGpLus5KgFzFejA9yPkY/SB9qDWeWTDddj2ejaA0EaEiwaex1a5PqAajdM7U0Thnzwj3Uin2p2+PyiAG1eiYrsfqAzQjSLWnT2m/Lnekk98Ims8msPqTOaSyazAZhxEyHbmi/WxM3eQ7JlzCoumZaHkZHPH6XEaGLupKdfDDoQkH1h3fH/41muJQVTA/Wnjnoe/6kcyhKQr3Hq1LIb8CZuKYWf6qvsfKK9VowMe3kow0ce0DBbkf1YX17Oa/W2N4En6zFAZiC5CW5yXp3vx7NIdaymr/9z+xA1smfXZuWaHPkzyC9+9hALPguKZWOzTDp9iqRvSnrtpT0qsYtHdVtp6ErOMsFhj/c7C/6gvq3W3ETvx2QvjxbHFsIICcdWPGqvenyzTrrME1J4uIOAJFDhLTOI/kebOvXw3EJ/bVcl6iQX2sxfUyL2LpYHQz60YK78ald8c0LR8jX8aS9dWo+qX6dYwlcqfQy2alhmSLSphJtJwdHa6ohVHvrF6+D1otdmqSCFsV0GUMJJd2e8UtFuZzJW6zuDFv+eSJbysPyCxPPjs4A5di7MpX3NzRy36jgxn4MmOW05t4kLQVnVOz8WXdUHjcNfw22496+kffkPlr1e7izyjHdVdTs3o6ZEr2bgR6iZRt6PU/7TFZooa1x2KnfJ
 ZuT/tctA
 pK2a3l1CoGPLLR8XGQY8fsDBYguskmVsLadig8jkPAHUJlpJ2EtQl6DUGvRre90Shp/WydLH5uRYaA7+ER+G0l4GbvcFjyNQtwirIcT9/2a7lpZNL1td/PhyzR+7jWShnX6phrsbtj1XvRLl3RCjKBr+NxYwzwBUSejFa3j4vasFzZgbpGX3aQWlrFyjK0vccwtRWufXCrjXoE0Cyg1vMux2d/Sk7OY9vLj6Y0sykygK3MwD9Xi7LmxP23ts6lLH75n16EopLqlL01r9PD8XOv37XF4973zf6pr+px0V/Q0225T8IelxqJbJwJ4kNcX+z2Hrnepm1ow6bwqttNAEVqxwcORFa8loDQAMAy1YB3pNQLwWnsL/QtxcXH9JbEtqB18NIfWYVFIWY1pTxIMGV8IhxERbn+pyQ9xNnw88BGSxKISw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/09/25 8:30 PM, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
> 
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.
> 
> Make all these functions return -EINVAL to indicate failure instead of
> 0. As large folios depend on CONFIG_THP, issue warning as this function
> should not be called without a large folio.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202509051753.riCeG7LC-lkp@intel.com/
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> Changes since v3:
>   - use VM_WARN_ON_ONCE_PAGE instead of the folio version in functions
>     that take a page.
> 
> Changes since v2:
>   - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO
> 
>  include/linux/huge_mm.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..cd61d2b789ec 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -553,22 +553,26 @@ static inline int
>  split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order)
>  {
> -	return 0;
> +	VM_WARN_ON_ONCE_PAGE(1, page);
> +	return -EINVAL;
>  }
>  static inline int split_huge_page(struct page *page)
>  {
> -	return 0;
> +	VM_WARN_ON_ONCE_PAGE(1, page);
> +	return -EINVAL;
>  }
>  
>  static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
>  {
> -	return 0;
> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
> +	return -EINVAL;
>  }
>  
>  static inline int try_folio_split(struct folio *folio, struct page *page,
>  		struct list_head *list)
>  {
> -	return 0;
> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
> +	return -EINVAL;
>  }
>  
>  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> 
> base-commit: e6b9dce0aeeb91dfc0974ab87f02454e24566182

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

