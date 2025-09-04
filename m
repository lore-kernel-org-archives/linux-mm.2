Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FEBBCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3E66B0011; Thu,  4 Sep 2025 13:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3B76B0012; Thu,  4 Sep 2025 13:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0506B0022; Thu,  4 Sep 2025 13:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF3826B0011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:25:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4486D119E70
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:25:56 +0000 (UTC)
X-FDA: 83852245512.15.8E4E0D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D44714000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:25:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWEYquBJ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757006754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRFi2fOS+pPLeEd6RVoOJ3KBwU8rGmFJra41++SZb8I=;
	b=mx1XIBQh3T3fwidyBHeFaJoVDOkOZy05PhSNf2PoUz0dLmJkxrDoZ1vDO22yQV1PwAdJ80
	WwoEtDhSM/YAmOB+Q905ryyiQx+CrNcBpiOgXsbew+G7R7O/QrhXAbETcPbYXQSmbkTd2q
	HmMjWtmNkUzYW5a/hrcj5z5YarVj3Bc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757006754; a=rsa-sha256;
	cv=none;
	b=B5LguKIlcFC1ww/t8TlDUhQBhdk1oQCOaGVFGhaqnjvSss7P4Gu23ZDU2FhZhItvDO2EoE
	nySmJcRyWTOncUWQ2nElGe3BjcYriZHQGhvoiX5xKOKnTvBd3i7yn0H4woC0QBS8N1BePC
	v9uP4WXJ4IZc5SsoHsFwd8cJXB347DY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWEYquBJ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33F3C43610;
	Thu,  4 Sep 2025 17:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD20C4CEF0;
	Thu,  4 Sep 2025 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757006753;
	bh=uWbBIU4w3aLjzzZXHzzipzpYkmsV2qF93OFDrZU6U1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWEYquBJUUyxun9aoT8Xkk8GrFE84DTB7ULwGOwIkaN8Gd8yLTnmdMH2GnwXVvkLj
	 f5wEGhspBaXR++6faQCybvpWSNhJT5fDiNjYJMefAeJ/ouUHFfFTU9jBsRm6R/p/Nt
	 iryuEKioWEuS8rBewYZfxSNYooci3kZraESh1bWSmhRNfnsvaQ9YANTMpyiigPAyC7
	 JrlxXM9vsN4uKsIbWrzEX619YL1fZlvYJr3FGNH0nubG4xdGOWEGvi4rjw8bJeB9r2
	 faaGdNRVjbs8MMa7/jNPZJLLNPWOdFiFqJO0Z6xBX9OnVxrzFazfm267zWOQKLhVqv
	 JxjFbt9al15Zw==
Date: Thu, 4 Sep 2025 20:25:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com,
	"Anderson, Russ" <russ.anderson@hpe.com>, osalvador@suse.de,
	nao.horiguchi@gmail.com, mhocko@suse.com,
	lorenzo.stoakes@oracle.com, linmiaohe@huawei.com,
	liam.howlett@oracle.com, jiaqiyan@google.com, jane.chu@oracle.com,
	david@redhat.com, bp@alien8.de, "Meyer, Kyle" <kyle.meyer@hpe.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
	linux-acpi@vger.kernel.org, Shawn Fan <shawn.fan@intel.com>
Subject: Re: [PATCH] ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Message-ID: <aLnLlyrfNjY-hMuU@kernel.org>
References: <20250904155720.22149-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155720.22149-1-tony.luck@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D44714000E
X-Stat-Signature: 7cb7xpzn5u3foij6g81e31xhannwonyt
X-HE-Tag: 1757006754-718135
X-HE-Meta: U2FsdGVkX190TUsY3Naak55UuPS4joEwGJEtXL2hkf1wfLvW59cwttE828lqFLdiqAUiOWrAZFAidNySpwkA0YdwZbAdzgNIjicontpL+FnXxXI9J8xw1juwZy3ukszsA+KlOTzz2LKxugn87B6az0aG18lwj1oQDkpRNGy4kpQpmUxZEgSW7/cSbTUfeH0SCZ9uvYmRUlgH2KNArK/qMjwgCPR3Yk4K17cOv/YQkaP9L6C+dDkGsDwk7ZDXftHE2tMw/KcZ+iDIGsgbHN9ZTDrGLfzQQonRMelugNY2QUi01lq1hogpIBn2AuGM4dIzjrJ+A6JYqD1ol2rjisTgBJlTfUKt7/O7v2loSVblH0HTek9f90eu9slKhByRxAT8E8ApphY2wR1QvjswtDWKZH30Mapp+TwEUOE/8wsBH80Q/8tKPs3Enrq5RY4GpYYivQNpK6onOXDhG1L7v5B128byhfSvROXc4qsJcCf3zYQc0PQKx5H0Z3jTdMZTvcOs6p3fk7aQJqEi0hlWxWtXH9ZzjX7WofOLZey5achKZd0ohoVvRh9mlmUmOjBKqVOlKUPzhc/C0ZnwON2ZmJ9qMwyzvBwJq9/FCIyftn7WqO0WWZGhGy163le3vfbkpSJG8iX/Mq3uid31wpCFkpuZle5vILBzfatAB3r16U6sh42FysNDwhs+Gedpe8CKpyLubS2hVc7Rxr2vSFzMz82NdnSDBBOorAsh/Zszfqs3LzCsOrHSIYhdECJgwD8nUahpKatO3dk6r/qmgKP9TDuNgc3pKqvlpVxg09sDjrQXa5VPjnorgPU9ejxczIzf0FsKr9+YRWLvihZtsdnuiAn7oy2/f/Od2JoOTKaVLcyLjrlJvnIfvEYHSx2754nHY5T/J4SZqc6U1xk7wQT8o6OFropUqgZYCCj/EYNuFrXyWVAHbIZRYGGnlXAVV5azKFoeksTxjSo8N16g4B90mqY
 7+d4+ilo
 0hITlU5CmkcHr5UDAeWP3y+c1HtaTKZlUz/svBAdqbwDr3LDJ8Bn2+w8CwLJNh8MGSw+NafBaxl15ewevOplD4fLUK8mOeSgyq6VUoBnk1qLByLFDoLMEmLJ7flY95DzbRVSnobNm5/HJvrBYKIABlQBzgj0CLbo8PPxYBJrLmEe52oPpn0fxzZIPvk33maOLVhCtWDdq9aKWcbBkWm+crarXKyT1W3nJPC0B6S4mO2Fw+nQSDro5hXvFF7q4SSVIE+WCcOO2gbVSRypSA1kzokqZRqi+10l5/0aT6wWJzh8TbXtWt91JSIYtNoRjpi+eGL7+zPZfQ3BP1WyruYtvIl3N+tsaWUfzxrce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:57:20AM -0700, Tony Luck wrote:
> BIOS can supply a GHES error record that reports that the corrected
> error threshold has been exceeded. Linux will attempt to soft offline
> the page in response.
> 
> But "exceeded threshold" has many interpretations. Some BIOS versions
> accumulate error counts per-rank, and then report threshold exceeded
> when the number of errors crosses a threshold for the rank. Taking
> a page offline in this case is unlikely to solve any problems. But
> losing a 4KB page will have little impact on the overall system.
> 
> On the other hand, taking a huge page offline will have significant
> impact (and still not solve any problems).
> 
> Check if the GHES record refers to a huge page. Skip the offline
> process if the page is huge.
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/apei/ghes.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index a0d54993edb3..bacfebdd4969 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -540,8 +540,16 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>  
>  	/* iff following two events can be handled properly by now */
>  	if (sec_sev == GHES_SEV_CORRECTED &&
> -	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
> +	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
> +		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
> +		struct page *page = pfn_to_page(pfn);
> +		struct folio *folio = page_folio(page);

There's pfn_folio(), saves a line :)

> +
> +		if (folio_test_hugetlb(folio))
> +			return false;
> +
>  		flags = MF_SOFT_OFFLINE;
> +	}
>  	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
>  		flags = sync ? MF_ACTION_REQUIRED : 0;
>  
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

