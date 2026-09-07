Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2419AC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BA66B0098; Mon,  7 Sep 2026 10:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3306B00A4; Mon,  7 Sep 2026 10:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9E36B00A7; Mon,  7 Sep 2026 10:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07F966B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:09:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1F43A01AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:09:47 +0000 (UTC)
X-FDA: 85187149614.19.AA47E08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BFAEE20010
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:09:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzNgA4dk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAPqbLuFWuncpfCHNeDVN/DPeOZ1rIcAQsi7S3J/KLk=;
	b=pJBAfmZrAO2l46vE0UcnXzOIvTrtyhhxYVCXq6dB5v1nB/fCzpXl8JYT5ikyMZgjxExN1Q
	vZ7yahHWU63gmEmQzqklqx3oa3D4TifnXufgddPrH+T/1k0FQnjFt4HS0Av/AZ9IlJPNCh
	+7BdHNXcigln14dwziZajkLBQrb611o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790185;
	b=1LpNlBzh9I9a9cwcLa/jffjd1H2QMnd89yHVTg2AP6b+J8rBG0DoicJ/mUPSu/69eoo80e
	6oSQASR33DqZPsJ3HcD3REdiSIOM0HDEMWS4Ru+UDUqw6lFry1T0taTsJYwYF8B2vSpCmR
	iRkQLaMDlLk1CwImBkrVY7o0dbrx97E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzNgA4dk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFC6340247;
	Mon,  7 Sep 2026 14:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B47F1F00A3A;
	Mon,  7 Sep 2026 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788790184;
	bh=mAPqbLuFWuncpfCHNeDVN/DPeOZ1rIcAQsi7S3J/KLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mzNgA4dk5MDoIQMR4mG95VGzCkXjcuxufKDW86PLFRn1GlfZY+y28XlxJAko9nGgB
	 9w5/MPHbjvi0kPHuQauMQMjqUH01jA9CC37OlmxiVSbUCn04LghqaEgD7iX5C1B/NS
	 +4XOO8W2ZdVFtfeoTu09pHGRohSD6b9IggFFL6SkpQM9MoIFnyHrG/hg1y206BgCAp
	 wzCUP6tMtvWnHGnbYsuRPyln1cRnPl+5DX/70RgFuUvAgsirpLq5+KpNzud2EpG1lM
	 7ltil5AgtWizfYFknlU+LI+J4zLVL8HANDx66IcYpHgruh8p9SfWVFmHJKIA6qJS5+
	 vAb2SdmgsgjxQ==
Message-ID: <f21ab49e-b61e-43fa-8846-e5ff6a7b25b3@kernel.org>
Date: Mon, 7 Sep 2026 16:09:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
 <20260901-mm-remove-unused-helpers-v2-2-f6474e169c23@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260901-mm-remove-unused-helpers-v2-2-f6474e169c23@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFAEE20010
X-Stat-Signature: mxng9ys97wdpdshw9xibtwhxuks54u8c
X-Rspam-User: 
X-HE-Tag: 1788790185-552902
X-HE-Meta: U2FsdGVkX196S8z6F2pyLDkrg1YYG5SJpCm2C5YJ5oVThMVB5QkjCsoKJvMMj0+AUxaF+kEaTabKWd3UPxqTVceDYSeyJfXjgA2vSisO1oSAtA+OvXAPMy73/3STjOjLDwF9kIWXsHhUFEcutiDJL8y8vtOpro8QPoDopiqNJOk7FqIjVY557zkGbc3CrPABR3J2llRxwTUNKHDgTBHjCb+SWACloQgZ+1vAXJzdA+sHjW8QJYXjIVBjJdIYJOdBE3QQ6JIgdUS6t5XJsErD9I9f+Fhl3/+WqDBf6LsLVPCvN+K5JGQDhC1xYyGfc5VBQHjJ3xseuCTOJebn7ZDoeuCLJax6p0xSFSuAlVbRgBJ8geo1+1j5N2aHbxoFDI9VI/wJX+Ft6kxmQauN+D71m1SiXLAnyGYeMnwwIgGkZ1sD1iKoLDby98+K2vNQOKulYabemI6ICGy+S/cAdAv8cmxpnKfZ1T/s4j9u4ZKEJvgMbJ4mbi5Zr8dqQjnFflU4ZN16sUxWtMDnoO47n719f052i10WPgYINC7eMI8Clbsv9uWzq4wFDC+NMeIXFByCP7PxpIxqtSbKsuNm523yQEU5nyWPr7tbRN16uV6LlnIzADF7W6ehQ6iXK/VI77DQBRG4NHItGPi+4IbCemz2iEQ97rq55qtidyzqNozdr6hk4cc6YNarApp9mzkUOPV7Rp/xy/QB9/GfgDCbEEuUfeViT1+20i20/NRw5L1ZU0NC5j/J/Fnv/CZJsFpx+gJOqsvkWZwLBp/jjHomhczFOlTl/EhWh+ijwqsK3A/83dtdKX9Opj99FkYnPCw7+LYc20XGrXAyPvIxDwwLP3Key5VIPg1H8klaD0lMpSxJwMKWluuiWAnJyecRRqarDM3dC5Lenk/YRT13FSLPuSqOSWyb7/hOutZCENZSsd60NAVsZAmzdcf11sZm3qFfKKqPr7hpH6J02iZkaFEJWvN
 dyXdnS7V
 aS2/8bdR7kfWU44ciYJEhMSaz5dI6dC6ZuMvhtXD2/Jiy/3NKXX3BF4Mbud/Noy1W6+kwOGmg6CQVsldu7o5boo0omxrszyHkyzW/nppSTkjICVReBcSu9WkQzfaO+E80PDPMhTcVGLlr8QO2jgYZ+pXnEaf9P9UAVwU4KxYOZ4QgYYQ2eIizEgNPahupVxkDFBoExxI9R0Y0Ql/NbhoMFMcA81/Nx78Nf6iUxVsV+ft56NjCT5ivtnPezNZEXNlSZsNb33O/K1u4mHTLs+fXPxArQ3wUJg1Zpc+4Vs/agUUuPKM8bUym/GxmRtrO1oVlK73nIE92PTBVc84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 21:38, Tal Zussman wrote:
> totalram_pages_inc() and totalram_pages_dec() have had no callers since
> commit 7fbc5e26123e ("memblock: extract page freeing from
> free_reserved_area() into a helper") and commit 287b89773d81
> ("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
> totalram_pages_*"), respectively. Remove them.
> 
> Drop the totalram_pages_inc() stub from tools mm.h too.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/mm.h       | 10 ----------
>  tools/include/linux/mm.h |  4 ----
>  2 files changed, 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e3736c42c4db..c105a3758915 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -57,16 +57,6 @@ static inline unsigned long totalram_pages(void)
>  	return (unsigned long)atomic_long_read(&_totalram_pages);
>  }
>  
> -static inline void totalram_pages_inc(void)
> -{
> -	atomic_long_inc(&_totalram_pages);
> -}
> -
> -static inline void totalram_pages_dec(void)
> -{
> -	atomic_long_dec(&_totalram_pages);
> -}
> -
>  static inline void totalram_pages_add(long count)
>  {
>  	atomic_long_add(count, &_totalram_pages);
> diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
> index 84b5954f66c3..d586a510e6e1 100644
> --- a/tools/include/linux/mm.h
> +++ b/tools/include/linux/mm.h
> @@ -33,10 +33,6 @@ static inline phys_addr_t virt_to_phys(volatile void *address)
>  	return (phys_addr_t)address;
>  }
>  
> -static inline void totalram_pages_inc(void)
> -{
> -}
> -
>  static inline void totalram_pages_add(long count)
>  {
>  }
> 

Also very nice!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

