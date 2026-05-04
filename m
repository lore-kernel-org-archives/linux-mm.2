Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF25FFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 03:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C196B0088; Sun,  3 May 2026 23:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833196B008A; Sun,  3 May 2026 23:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7494A6B008C; Sun,  3 May 2026 23:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6650D6B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:48:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B97F81A09DC
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:48:14 +0000 (UTC)
X-FDA: 84728354508.10.E6FE1D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5ECFF40002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:48:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OZggEc9d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777866492; a=rsa-sha256;
	cv=none;
	b=ldLQJNdpIfgXO2qkj6szPUDW+l1BCTtWQXWSjI9pK0kiqFKVya0tD1e+L7UxcMQ/1Is5Ge
	lMTshF2U/H0Nq/cDj6Duwu2fzxFxSLeMTfgH3qYCvY/lYnVaP1b0DFOKRtLlHauT2LQIJ6
	kttyfH5X8F5YvOIJd1zJKndanTHgsks=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OZggEc9d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777866492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0d34gXFxHlvZ/8OcBwFmPS8KNdBuUnK/1QEoQcHntzY=;
	b=e+Z2/egzSoZniFqBbqaNPFe6gIfzx4sDcptOIufvw8ZDU5GpDSBq9PJATnpy2XbY6vuFEs
	fb3eiWqCl+RQdwr6pJWfpRo4REK2M3t1xI3kfGoqtBySxZEdeE9Rbd2xTImWbcxq/oIsKH
	zfSb4QjVo6ImcVQUIClGBDphs+4x4QY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777866491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0d34gXFxHlvZ/8OcBwFmPS8KNdBuUnK/1QEoQcHntzY=;
	b=OZggEc9doR79XCcBLnTnSnAFsvaprK4Unx28P+hE5wSjG41VjpoBUy00eWzk9DIM8DQ0nA
	gWCmQxKe9wENxtbhxbF2OBB/tNM1JzTMbHpjVpMXZhDhJo9UiKqgzKb8Sj3fr6CfsYa83E
	Pfq7G4If6EQemi7FV+5bSKxdXd11lMA=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-rrojGCpOMGa9SNP14_RRqQ-1; Sun, 03 May 2026 23:48:10 -0400
X-MC-Unique: rrojGCpOMGa9SNP14_RRqQ-1
X-Mimecast-MFC-AGG-ID: rrojGCpOMGa9SNP14_RRqQ_1777866489
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7bd5c9e1826so12993347b3.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 20:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777866489; x=1778471289;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0d34gXFxHlvZ/8OcBwFmPS8KNdBuUnK/1QEoQcHntzY=;
        b=koxKZP5cWexULrWxMc+u4GC8HF+6gzvbsQ+9u2nLst3/MxojYXxa2RxDE51cru+dC3
         apzhDGg1q7QOUTeafnIBFB8jFWxdrqQDu1VukQ+9Dmok9GeBPh3nkqBuIDfxPB/fy6BT
         NSOjNXrFNINMJ+Xj1Vtpby40VdpkaLVRS51dQ+DiX//wCDY691cU3VUpy4EUcn0k+Sjb
         eB8OtFa5qcY6Z44ntfdyQRsDAEvkjFyiheT6OYblM7tBcS2FcX5Lz8KMJAkSf2Zlq2hQ
         ctlfbs78iGic1r+TapLg8Xk83Yu6/rk/y01FnoD+zwYDMP5xAGtB3Qhfg1YmEeH+XHPI
         /bNg==
X-Forwarded-Encrypted: i=1; AFNElJ9kWDoc9vCRgJYclUY6DoN0+6LouwZ9JuJPwErC93JX6TBjPT6qP7z+WZzRowxAhHvRZm2rfEhygg==@kvack.org
X-Gm-Message-State: AOJu0Yx8TQQ8XhaclbBpmn1L/iNXiJoskTEpAvZAMXhsSFqNCmbl2dm1
	HNt7AMB7Nw8pmFjZ9GIYnQZtThPgLtrKtI5+C/N7OyzzXLT3rQubarVbFMSvkplaNuaJIJFmY+g
	vcmHPrT90H4VRjMMq4YgGSFVmbA3bcFkM10W0E7CPHc84E84EOQY3
X-Gm-Gg: AeBDies8r0uTTkijGBhjBMEu6quRqC54Qu3tJA09nw80VNqTLf/IJpOwDKtWHV2dImI
	tEUWBSSyxDxcQZ1TFFa5uTC8fmMQachJ4hjORy1CI7wqxpCbQLqfqtFi+dfWjJenOPWXDl8R07f
	rObVOhNX/hjwKDaKMF07FaLM7ohFOl9Jo1YbltoARLEFk/DCs1Z/G25TJ6J2AON60AwvOA11XIt
	wQZyxwr88yxwHSca+r3sxqQ4jYLmA7TST3W09bivrqRpnVB7Ggp3VaASy1KMKk6qG7lTkbOZnZR
	WcIyxRAVRM6mWDfOvW+4IgGr8iSbQiY1engd6zGKQpDZLDHme53e4NJQt+Fpgqnj3kJbsaZ1p14
	SC7Htis6/P5w6o1M+Ps3vzKS9Hu5KbOTvs1CtHaIg3vHleaDW5ZoHtqAgG2/5/ILmH9U=
X-Received: by 2002:a05:690c:d85:b0:7b6:783f:2122 with SMTP id 00721157ae682-7bd768ef380mr66369047b3.9.1777866489506;
        Sun, 03 May 2026 20:48:09 -0700 (PDT)
X-Received: by 2002:a05:690c:d85:b0:7b6:783f:2122 with SMTP id 00721157ae682-7bd768ef380mr66368697b3.9.1777866489040;
        Sun, 03 May 2026 20:48:09 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66839f63sm44701847b3.31.2026.05.03.20.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:48:08 -0700 (PDT)
Message-ID: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
Date: Sun, 3 May 2026 21:48:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-2-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-2-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J8Dp5lX2-pbINriTHc41xG5427-5fNQFUDVjhE0yeqg_1777866489
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r5tukypem5doow4yg9iqg63s9bnn3pmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ECFF40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777866492-448192
X-HE-Meta: U2FsdGVkX1+coEwLSPCtcd1lRreaP3wBwY8Q6o4wekET+DSi2u44A5cCArLGbPjiewu1h7xwKS2X8Dp6hYB4hpRJDawu1TodD1XJiKOMGXlYnHvwPsxZw7zT7Ho13a/WMiHM0VzqipnZ2sArpqiJqasZCsVPwVeyWzpIuAArE//eG4QOQH6I5SZrwkl5LvWCdWIi4b96aA99NxTulkMhCTetv4TV0xDrx12sQsF7/aPuVLpL9E4JxY4xTcUE1VkxLHNS8sDGv+oBJkoxVq3SLiECYEe75vPptxNhEGQZJOKVs3nzRWy7wI5zD96Bf/tfG4iujcO1ogltDUZx9STD+Bik6t4JanHwnAe9Z/rH6YeSmnAaipY8M9Q6VDkMEAs5edQxAh3tWmQLcH0RDZYw3YaSTotCJhPrl9Gv47ptRbBXUBGvvenaCypj8pqwe98RafNe9LUjflhE/AxouUW/ZMnYWkRtm5CsmJSFIeqVYElE+3kRHR1xbTPfYXASovmMaqVeKie9F8t6DdkEWxk3OOqeD/Qu3GKkz6pa0w2dT0yurgxU3wscP0+ZtDVuFnyh2qcP4AkVeAOP1S5bsgYymh4FHeV+RLME8GG3kcfx0YnrzuN22C59ZWyclCdASLgHMYdQ8h8cKpE9y8ZMfKTQ+zh4ZUgxfSR9UvTjnEt5jlq2uHbmaXJt3hFqOTkRbwBij4zVUl0lwgkuTzxrmJ2ahvCB6w8o/HcWy7MNPx5Rtdz+VHrb9QNYAOY/k4CWOVpjqGJdhX/ujoaoUU6LMs3mssypwIfoyTs06B/9LEC4knoF07UTnac36kS4Kt3c4lAi7RTLV6K7Se8AnC28Ddrmpr+SZ/MPFfjGLoz1xSjGLiZX4e9x/H3P8B3869PorV2msK+Rd6VnOBN1cwA2T7dxmMcTQ8/ic280W+HisxsU8AldnCfF+mu41SKzlpiBoPTZBfREfEblbKy4T+DPlAx
 OSahUPj8
 STJGdXQiW1OX81t+2C6k/AurKVggu802ALx2KXBiYS4xe8SWxGpt8PJ4EhoELNAhRLHHBmfKpH4ReAI93fODNAP7e6KWcD5aijnwbQCcRJjBubu4ZDZsbgpI6mWs0QT5eSh2gpOXZxNc3cYRdy7/uEWsSYR+B+5nJuDcLXUFibipnsPRec9YQsLuuGVKxz4UPRpBzTHriUPKPfnZlSszxBddqbbggjTQVYOOvW57DzACBFU6Mc4jueDnHZC4KnlOBLpuWI6qljIjHuKwz75iIFn6SS/EoZfD6boJIclQNUXtAz1oyN76HSCf1WQiTMCJ0dSh7xDLMAXR7GcVcXK853T1x/RBWHpXjA0n064h4Ij7ohaIdiNVQbmNG52Vdte89UaIa6H1f4j+qwuYARc+lYY0Z6B3xQBP2I7O70Vi/XzcHUZXJ5kecUM5bxdvHqoyBJog4vRuXbZBCYAtWkokdsb2FwABy9Xirmy/aguHWNOY/dMPKRkngMsJeY0wnH8SarMVGd+ZBKUf77MEjYm0EBv5AA/UT6ZkOKrUjCkpf1dqL3KM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:29 AM, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> Add a helper function mapping_pmd_folio_support() for FSes supporting large
> folio with at least PMD_ORDER.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>   mm/khugepaged.c         | 10 ++++++++--
>   2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 1f50991b43e3b..1fed3414fe9b8 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>   	return mapping_max_folio_order(mapping) > 0;
>   }
>   
> +/**
> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
> + * @mapping: The address_space
> + *
> + * Some file supports large folio but does not support as large as PMD order.
> + * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
> + * this check needs to be performed first.
> + *
> + * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
> + * supported.
> + */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
> +{
> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
> +
> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;

Probably a stupid question, but I dont know FS thats well.

Here we are checking that the max allowed folio order is greater than 
(or eq) to the PMD_ORDER. Yet the function asks if PMD specifically is 
supported. In the future could we have some FS that does not support PMD 
orders, but does support larger orders (eg. PUD)?

Other than that. LGTM

Reviewed-by: Nico Pache <npache@redhat.com>

> +}
> +#else
> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
> +{
> +	return false;
> +}
> +#endif
> +
>   /* Return the maximum folio size for this pagecache mapping, in bytes. */
>   static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>   {
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e112525c4aa9c..6808f2b48d864 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	int nr_none = 0;
>   	bool is_shmem = shmem_file(file);
>   
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/*
> +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> +	 *
> +	 * TODO: once shmem always calls mapping_set_large_folios() on its
> +	 * mapping, the shmem check can be removed.
> +	 */
> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>   
>   	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>   	if (result != SCAN_SUCCEED)


