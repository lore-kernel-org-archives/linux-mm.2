Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6C8CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618B78E0158; Thu, 30 Oct 2025 22:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A31D8E006A; Thu, 30 Oct 2025 22:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4913F8E0158; Thu, 30 Oct 2025 22:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A598E006A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:55:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C194988317
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:55:56 +0000 (UTC)
X-FDA: 84056894712.13.1A8D911
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3D55A000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:55:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sgo6yyeZ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761879355;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbb+HtAkz5E08qbbx7069G9TclCwWAydoNERXltG7Jo=;
	b=slslZxwILopc7PwK+yKHdHXFQkT87uOakWCfpWDLWdKBU0qAefNVHN9Nf4b0I3RPUwBlbt
	kbAI6+RV7FbKfo9xRSEUC7i04OZpwGh7RoePS3W2TnaCVcrY75/Ya7bYLIQ3+DVr2z7Hlq
	BTjlf3VcreeGJnKkEo/vlljU4EL+5l4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sgo6yyeZ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761879355; a=rsa-sha256;
	cv=none;
	b=aa9G3slpHZ0yTdXj/8Nm/IDhM4i8IuEPqawWaWQdPaZvYOOtzUJ6HR8vuOuX2vwRzkBtYF
	wP719xhmRbhNUoQCTsIoU4h1QY2T9szq707OQS5izjlHEpJroSNHXVeyGr7s3DnOj0BFVN
	kphVJ+qer9NS255KWinzo20ldLU6pH8=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3d196b7eeeso370729166b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761879353; x=1762484153; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbb+HtAkz5E08qbbx7069G9TclCwWAydoNERXltG7Jo=;
        b=Sgo6yyeZwUc5jdtAm6niePBjM8/BY+mLsmSGcKPVcumbmw/OMkiofnHtOySJ7AKQ1D
         r7LGrz9HVG+yaIcxOvwR8Dhh02Z8/4YjqfOiOynHfDRk05t9YIDgu4bYt/eSSDkhVqS7
         dRSGemmlggS+yubGvedJ048FtZHOO9LZ0/sNV8zD0DMiVNbLRGM/lKmAZurdijZysRrw
         5MaDCoU0xQ3xvofknKwlkXUlBf/uL3awBFO+56k0c8yl2xfbRTmE7fw0iQaN7OURaKwX
         kxQUa7puNoS4IaeyDcagp3tvHvgG92AQ1swYDoOyyp3p7RMXNZPzxkmbZ+gCwNcvyTK8
         fc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761879353; x=1762484153;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dbb+HtAkz5E08qbbx7069G9TclCwWAydoNERXltG7Jo=;
        b=dGdgBbYMCvskyjBLgpdPYqwnIfrI5YYxZ28/XdDq9WNmlvnj5HmLxyRjY8wCAt6nSm
         3Qek+ZNzZyP0pavrpRtkZUk3OXJugh/Y9Pp3RL/j+lIjFePtbrg/R6egzd3In2OgpkEx
         Pgvs1HsdanHM1LXCJxnTJb6iw+91m0TO+6Un1TsBdqczw8Y0/pR5LvSrG88TYdcLEhGB
         BwCWxPDYiirP3xL8gI6fwuLJ2fQZAng+v+eLs9d/wQR6d2GUNxQ/T9QvT1jlEZbpgsjB
         vP+Q9bIMIdX+GxHcGbi0g/18+k2Yl69yQE2jzJdSGt+qB2La5X6feoG3IzYVoS6b1Xt/
         vAXg==
X-Forwarded-Encrypted: i=1; AJvYcCVgy8HZRpAgtMmdubDR3XYdkKFymOF2UjsBU09hW6jZQjuQ5EgG4jcBI+2Gw96YLeuABntMH4omzw==@kvack.org
X-Gm-Message-State: AOJu0Yy1T1lAd+iMKLoolI4XzkuzbVPHxn2LTBCkd2SvuXmJFCzOmp4x
	S3L4rzSEW1Une1oCvty1hkWOB55+T9VRoRutvskWsj/gARoWWKkpibS9
X-Gm-Gg: ASbGncu+CDUYvykfFjKb8zuAtYMpLQj5V6ViMhCTH05AV3w98cH40bNDyU2litAsBFP
	R0S4RoONycZclxSf84Ld30kLZQqfH0E5vNEEcdCVN5VqFxG1+hE1x6gzLw7piGzH9Iin28pnbrw
	qRSgozkW5sXtkEG1fHeKdFw5QahbJ0Xx36VHlYQLiJfTVxV0K8U6H0DX/GUx3vwOGOuaYnNqw7b
	A4jpk2MrWgPn3VnBL5RAZ7Clbpb/17hZpoKd9n0bp4A5AMETFcrzgKtsEUHJW1hfpeX+zoiYjFI
	y71jTFRxvdQpItoA1tQFULfIvAQ0UB/CKC63RHzLtQe1/bC6LZEVtcyQsc0lVcjmqWpGQ6+3BgR
	34gCApplaZidK0BBIEtEpfcyISS76SIr0p3zHoxQz8kaVo1pek728h8bkd58sAI5lUbOiOJI2NX
	o=
X-Google-Smtp-Source: AGHT+IFaVEZlf1vH3SzuCruGg4BO7/3SvDRPUOGQR9RtSR34EJQMmXJ0JlLsI6L2lpx3vT3NXuIEKA==
X-Received: by 2002:a17:907:3f13:b0:b0e:d477:4972 with SMTP id a640c23a62f3a-b707019d264mr198901366b.25.1761879353147;
        Thu, 30 Oct 2025 19:55:53 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077cd2d48sm48761266b.60.2025.10.30.19.55.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 19:55:52 -0700 (PDT)
Date: Fri, 31 Oct 2025 02:55:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Message-ID: <20251031025551.bmt4wh6e6tmhcr4i@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030014020.475659-4-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3D55A000C
X-Stat-Signature: fnaadu9b59suhjxc1qxuhh6ob56p3dn1
X-Rspam-User: 
X-HE-Tag: 1761879354-817866
X-HE-Meta: U2FsdGVkX1+2/cvPdNlsDMJasBQsokQeSFkAyVB1D61YJUzwtxdIPENwHvyaMD6CdqVIvZPkOPtvnxUhZkB2QMW4saf3hOm/UM0QwnBs/UBDHRE/Kya7Xx8wqVocZ6A9o+35eX509WKO3AZ8NDy6IxcQTsurGiqXa9Z5iiEzRF8kJ6dIqJ3OFC4luHnQIDa+nnVO0oTeit24pb6frIGicsz6Xsq1YNJPn97Rt3vIdk+9aU3ReCEiBfrWgBsW2Vp1KAEmdhVOryUEzdgvHMWp1GvEi+B6W3eQXTF+WKMQg/ES95fB2+q55nHU7QK0KZyILXJKhd1vLTZ+pXr6yvdC1RwdHE2NZ4EaTBl/pNc4dStkGdEIXPDWglM0eFqhq7E6fcB+KNoOFGm5+kUHqcgco7buXxxWx/wA4SPSk0vv8aw9qdtatFVsU1O+BuKw2N5z75BdH22zuUeZbgeZ1TfsDByvtyi+7kybi/PqGpesPRKt/qyONmINhek6uCJ8NotPyyZmn5cCU8GmSbSmtuBWQOO1Mf0H45NuYky1LXQdNeh+c81ECuntwEOdx/5iRkEqcYP9gN3NmQSuIjCskxrWm7+8q82BXTDSQCoP1k0ifEhgmwZ1UppgGYO4zpH50PzEw5ulc3/U/aTodYfKM8VLRkoHKVJs33zpDtwVqtGUVNqQg/ZqCBZ7OEQqr+bFfN2wGvr9lV053+U3wVBpGr5y44Ph+D9nviC4DpnjAhe+NxZRkCVUxnJte1wwJr2+8wExroqXYWEqWNUIVFEBoS/DgDM1ZEC6EEm5j4feexhClHGkh2yFSj89JgEi+XBBvLSBwWdVzcNpuTdArkhrjPJQW9py+t47Ox/5xdbMRdoufBx0GVRhWp/MXDGIp3KOAQsvR4jbo0SJuX5AhUOYxLon2CVQI7zKkDfLAlAxv3BsmMPv+JqzrZ81VHLGTIb4iKYIbJoL56UjiNCAfAHEI/u
 P3J8O632
 7qkVWmMB0ROz/cl01fNiD82Zm2JoM0kFLEn5g/NmuLMSovQ1GPKif7J536FSJjuDDvnU9BcEtE07p+COfcXHA4nvOXaZycwzNhV8AiVK1DMLRFkNMzsioPtJtV+QlrTd9Q9yAO1LqXVfQE+XRWg6/oO1hhYHbHDqGlotgJ8IkeXuLYpmGlqH9eusr/aMTA+yl5pO6Qktts9+4XUnWblFZyqS4z1dUK3J51euN7+ilI6unMNVLQPWDofv+OYOPijGAjvh5V/+v861JNV5HYrxNtPn8fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:40:20PM -0400, Zi Yan wrote:
>try_folio_split_to_order(), folio_split, __folio_split(), and
>__split_unmapped_folio() do not have correct kernel-doc comment format.
>Fix them.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Acked-by: David Hildenbrand <david@redhat.com>

Generally looks good, while some nit below.

>---
> include/linux/huge_mm.h | 10 ++++++----
> mm/huge_memory.c        | 27 +++++++++++++++------------
> 2 files changed, 21 insertions(+), 16 deletions(-)
>
>diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>index 34f8d8453bf3..cbb2243f8e56 100644
>--- a/include/linux/huge_mm.h
>+++ b/include/linux/huge_mm.h
>@@ -386,9 +386,9 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
> 	return split_huge_page_to_list_to_order(page, NULL, new_order);
> }
> 
>-/*
>- * try_folio_split_to_order - try to split a @folio at @page to @new_order using
>- * non uniform split.
>+/**
>+ * try_folio_split_to_order() - try to split a @folio at @page to @new_order
>+ * using non uniform split.

This looks try_folio_split_to_order() only perform non uniform split, while the
following comment mentions it will try uniform split if non uniform split is
not supported. 

Do you think this is a little confusing?

>  * @folio: folio to be split
>  * @page: split to @new_order at the given page
>  * @new_order: the target split order
>@@ -398,7 +398,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>  * folios are put back to LRU list. Use min_order_for_split() to get the lower
>  * bound of @new_order.
>  *
>- * Return: 0: split is successful, otherwise split failed.
>+ * Return: 0 - split is successful, otherwise split failed.
>  */
> static inline int try_folio_split_to_order(struct folio *folio,
> 		struct page *page, unsigned int new_order)
>@@ -486,6 +486,8 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
> /**
>  * folio_test_pmd_mappable - Can we map this folio with a PMD?
>  * @folio: The folio to test
>+ *
>+ * Return: true - @folio can be mapped, false - @folio cannot be mapped.
>  */
> static inline bool folio_test_pmd_mappable(struct folio *folio)
> {
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 0e24bb7e90d0..381a49c5ac3f 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
> 		ClearPageCompound(&folio->page);
> }
> 
>-/*
>- * It splits an unmapped @folio to lower order smaller folios in two ways.
>+/**
>+ * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
>+ * two ways: uniform split or non-uniform split.
>  * @folio: the to-be-split folio
>  * @new_order: the smallest order of the after split folios (since buddy
>  *             allocator like split generates folios with orders from @folio's

In the comment of __split_unmapped_folio(), we have some description about the
split behavior, e.g. update stat, unfreeze.

Is this out-dated?

-- 
Wei Yang
Help you, Help me

