Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D0A5CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 04:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8CD6B0088; Sun,  3 May 2026 23:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7598C6B008A; Sun,  3 May 2026 23:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648686B008C; Sun,  3 May 2026 23:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 544686B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:59:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED7EF8CB9F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:59:58 +0000 (UTC)
X-FDA: 84728384076.18.596159E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BB2420005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:59:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xgf2isDA;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777867196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH3LgVMXf6Uuymix/+Ipek/Oiudb0lrDKNRk954dQLM=;
	b=sj/HjWEMEh726NYmglGoJmj1a3k4UMtFgfpttnGRv/mj/Y25PkuTLljl6B7J5Bi8djMNXz
	UemadmcYOPd3SVooK7oM+H7dAiguk4NcW+55yYPTQcOXUih5Egc6WXrPNUe3Wg6DnWBHao
	xCJC7rxLhZoTgo88Edjgm7mdfqkZqwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xgf2isDA;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777867196; a=rsa-sha256;
	cv=none;
	b=gqjMrbuIVNUJxZdNmqqN9OLBiPHSFFo8eUksDi5zYcPNz8zwawLJu1uEF6nFpKKSfh1N8m
	zfs39P+8dl/+cHjPlzqKLxCCIQwOnzaHb935eNEKuwOy29UFvhTCDvTJguJ23O1ANTTIK5
	6QWaYBSJGnk4WmkX5oLRDkm0wX5xHBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH3LgVMXf6Uuymix/+Ipek/Oiudb0lrDKNRk954dQLM=;
	b=Xgf2isDAUSZGjkAmvpOVoPXBO3jl72ja4XmM2RGEZUViZ41F8A0pnfBuYEvipyJI5FgChR
	9VHg72oxaR1hehMi4GQAeHx+NyzPPlF9wxQ/uc9E7/BEUuzx3ulA79VC0zHdxnyzuwfmp7
	7GhNsrYiCxxUwr+qAdiMKt56cf68TZo=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-L0-SIZbqOWqHU175TFNrog-1; Sun, 03 May 2026 23:59:54 -0400
X-MC-Unique: L0-SIZbqOWqHU175TFNrog-1
X-Mimecast-MFC-AGG-ID: L0-SIZbqOWqHU175TFNrog_1777867194
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7bd5c9e2e4aso61252907b3.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 20:59:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867194; x=1778471994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aH3LgVMXf6Uuymix/+Ipek/Oiudb0lrDKNRk954dQLM=;
        b=k/UAMsn0/IZ5q8EyvK193aEmMj3htIHj7s82t6E6OyeScRlPvBoFPd6cnT5gjwyf5l
         zkKssyQ7bGmFhSbmy25fJ+b8BK0qJ/EzwKtosuXgDIctyXLGnB4ZrT2Av2sN8jF1xL97
         ZWAdkCkLZB1iwviQeSM9rfKuRj6eA3JT1T6KS7MIh2bjLnnSXisqM/3sV104FrPXNPBZ
         04D6Q3Ue0sOTr27n4IfIqjPSLDnvVUOke2ZZR8kJIvn/IIbwNp8m9ONXUyd4xtAUFlUS
         hMsFpXa2/yR3/X0HXubRXBogj319ymsk8hQ2r89sIFwgbBbg3x1B4xPeXbVyBqO+fkFM
         PXow==
X-Forwarded-Encrypted: i=1; AFNElJ8+PewhNMwRvWTWqoJLn0N+aY4ehVHkHHt8USmDsX5vMZhjOhFqkTRf/7e7sZtMSvqLCyiq9U94Gg==@kvack.org
X-Gm-Message-State: AOJu0YxcNg78SrHMvpca4hpMyyp3dnZtNj4aoE0MhZaQdwtI3xGhu36v
	v/7OiwiV2UW3ekiRUvUWRVuZIJCqygukMWwSvT4bIcvgMsktGnCRHuKG1PeYfGUyyq+81LOpYKF
	CKa0rd04/5iUv48ee7Ov6wZp5zR3Doa7hg0Ysu/O6uHFp/LkUEFRe
X-Gm-Gg: AeBDietzQOrEPsgl2KRas8V30VEq+D2x+LM9UH/d/PNeMl0HC39h56LaheaaspdpCHw
	W7FdoXZ37sJQ5qpXqkolrvFhrkoKbIokWJDcnINAhsVbhiMh4JuI6OIh7xl4chbZe+L8+1fxZjJ
	+6R2GKDHd9aBTnza+YdPhKXMTg+dqMaXQ4xn+XSzotHi7oeTrWQKXhNM81aYtUmHYnhaLKibWYe
	1o9HEFMsC7HMAKYv3whU4PYqDKWEsrBbe55GezW4/7+Rc+VWoLwsjkQvGm53sEUd03MODEuJfRD
	kOUhSwXzVdFY7hFFqhRQtgs83GUyWD2ysl5yL3pkpmfvwoJZ8VkVqho0mmzlMfAHP4K7mtzx6hr
	QTU7527ClM9K3AU/OnI4odSnda/cCNkibpBc8qzw8szIrT9BaqeRAFhqZUuV98n16LX4=
X-Received: by 2002:a05:690c:6989:b0:7bd:7d69:7658 with SMTP id 00721157ae682-7bd7d697b07mr63166837b3.47.1777867194351;
        Sun, 03 May 2026 20:59:54 -0700 (PDT)
X-Received: by 2002:a05:690c:6989:b0:7bd:7d69:7658 with SMTP id 00721157ae682-7bd7d697b07mr63166547b3.47.1777867193900;
        Sun, 03 May 2026 20:59:53 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66888cc7sm43753377b3.44.2026.05.03.20.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:59:53 -0700 (PDT)
Message-ID: <78324cb0-fe12-4f45-85d8-557e2a7649cf@redhat.com>
Date: Sun, 3 May 2026 22:00:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
 in hugepage_enabled()
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
 <20260429152924.727124-5-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-5-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tVizV-pH-z7aXzzrcoIT5lIT3C5sqfJzxdKANuie4S4_1777867194
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9BB2420005
X-Rspam-User: 
X-Stat-Signature: g44igmuwmfgstmcg3iy3rmsfknspmcgy
X-HE-Tag: 1777867196-640962
X-HE-Meta: U2FsdGVkX1/Xs0AlNTVetwpnFCDaCP76Cx0qTdXHg2YmLPiQrsHB5OiawknTrZFY+JIx+ZAoKUiCHc8jXoPSW5fTKz1aIK1lg90vcNu9emX08MT0Dn0/PjqzIZ5zMW1016gGyN4dME9tkAg6QQ5LTOR9WLhLgzp6L6M6s2PZc455l0fRUB2pOSFnRsrM3oSXPJWfIJOpKCYJ/Yau+WH7xt5ImzBfpQa03Xq6w8LZ0XH2hkIJIcAATmrBp4chQ4fpgwGJSo+J2DpPeDIUXGEnIGc+qkl+gsohMlry3SI03ZsAzRW8oxNLvQlSd5jVdPTQSS+aVlIhfiT+b5KKyn3ZY43C4R8syDMCOSKXpr2BZpeHnD4EvzjKk9Hhe18TvLU0ZSPHebGBzLSHJpeYTnswgqpeRsxKIpScYjGV2XupWkyxLaGGHPXKC1B07OcOine5GgZC1KHQpmrIhEoIH3ySbTmF9M7xmPYiG8iD3UIzJmYRhZcjjrWWF1BiC4PkvhSSXcWVcvhXkOB/d3PY1GmgvPW6rdr6imoyDl6kfLeTJ34/fUGleAw4NT1mQTaW/jhqyvEWL3eXDewA4WKQkOpH7TECuHshg9In0DHyg3nL6v9Hfdw4lLn1yq5csQXkBJz2yqMwOgmNvEWDYg7rXWruODgkh4hqyHJwHk/tysQwHpa6hEnYm9frtG+otvH8eZKAyVCK2oWfm4vZ/FioqEMNbRDbsYRfqDPZ7iFqw4D2dTo2KKMGUFMITTtpGEmAxY0C33DnYZ7gbp4d1IkHDsQRUvb1ZRHG8sp6tlYUkjdmtDze6sogFmlsLiUbFFoNhb7t4qCPAFMFomlqgcjauSeZyUCRKh/tpvc0gDjkIj+TaQ8owcx2eq7XCNStbti17RYNT0c20RsiwUXHkFp/ezbpkbxF/Gts7FGidCPiRu0S8w9ODoihkswl6ASqzZ7SjFFY4ZFMklzUNJnL36vUi/S
 kYfbeKuh
 sBKeIM1PqmcyaQhItbqg6RBgGvA8jI6SniGdHV6fqYHLzJL/307bI0Yxq12KgInKcGUAohlh3KcsGnw5zAdzAH/KLu7mgtav2K0Hm7HxUd00WoE/lT4+k+7vh2UEmS2mv2NNgfRH6RX3XEOuuHDX/u43T2VJ1pxtMrscInpfWcxawqKC4rsf/ATNe6x96IuTRSKQyvJ5RI6QjLULvtzpexLIdLkmPym0eg12FtLkL47JtQqTiyWRjEHTd8BDT7fBaCPb7gnx5A7K/GTl8RwwXkgwG6kQroC8k4qLF4MSUR5sdcVEjDhHr0m2NQK4+FN5Hd+d6nT1pYhLgd6ObnL2j6vxJQC+AXD7XGCDWOKWaNC1LlyJpp887kenCDfnsqgXhi7jt6EG9ulmss7/HZXmEkCItRykSP3o3EMjooVAlF3S907+v343zX0I/SpAZC1pZX3O0iULVWVqZRpULfFbrBIer2OdzNcD9Ze6XCuJAVx+SciSN+d4A5UKd7s9hQBd8B4GC1LAodf8vgyf7aQaXT9k0eebIX3Fdb500EQEYbKz4p+uH8UfFGmC93Y43OS/TydZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:29 AM, Zi Yan wrote:
> Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
> pmd-sized hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
> IS_ENABLED(SHMEM) in hugepage_enabled().
> 
> Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Thank you for cleaning that up!

Reviewed-by: Nico Pache <npache@redhat.com>

> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   include/linux/shmem_fs.h |  2 +-
>   mm/khugepaged.c          | 26 ++++++++++++++++----------
>   2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 93a0ba872ebe0..acb8dd961b45c 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>   int shmem_unuse(unsigned int type);
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>   unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   				struct vm_area_struct *vma, pgoff_t index,
>   				loff_t write_end, bool shmem_huge_force);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 71209a72195ab..d6971ada8f199 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
>   
> +static inline bool anon_hpage_enabled(void)
> +{
> +	if (READ_ONCE(huge_anon_orders_always))
> +		return true;
> +	if (READ_ONCE(huge_anon_orders_madvise))
> +		return true;
> +	if (READ_ONCE(huge_anon_orders_inherit) &&
> +	    hugepage_global_enabled())
> +		return true;
> +	return false;
> +}
> +
>   static bool hugepage_enabled(void)
>   {
>   	/*
>   	 * We cover the anon, shmem and the file-backed case here; file-backed
> -	 * hugepages, when configured in, are determined by the global control.
> +	 * hugepages are determined by the global control.
>   	 * Anon hugepages are determined by its per-size mTHP control.
>   	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>   	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>   	 */
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> -		return true;
> -	if (READ_ONCE(huge_anon_orders_always))
> +	if (hugepage_global_enabled())
>   		return true;
> -	if (READ_ONCE(huge_anon_orders_madvise))
> -		return true;
> -	if (READ_ONCE(huge_anon_orders_inherit) &&
> -	    hugepage_global_enabled())
> +	if (anon_hpage_enabled())
>   		return true;
> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> +	if (shmem_hpage_pmd_enabled())
>   		return true;
>   	return false;
>   }


