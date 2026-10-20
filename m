Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CB5606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuyZcDLB
Received: by kanga.kvack.org (Postfix)
	id C4AEA6B042B; Tue, 20 Oct 2026 04:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA2D6B042C; Tue, 20 Oct 2026 04:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2766B042D; Tue, 20 Oct 2026 04:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83DF76B042B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:18:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F20C8090D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:18:30 +0000 (UTC)
X-FDA: 85342302780.04.7316636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5377740009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:18:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuyZcDLB;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhd9i6MZ/tSeH3TKysGHa5PRQgjZlpMeCGZ/ilQN7u4=;
	b=x9pi7Xx90NmKi+36Uor7j1oMy9OeS6xpbsNSgcesB+O5T/u4t4D/PJchVUS52cnfcUSbjH
	jxAlbShu6vqSd7wN3FxAA892tM+qTBpRWmnz8Ydw/SpJ+ji96aJAiIkvf0Ra/POVdYNqpI
	IIoKRm6lqTHsUT5U9DGrNO5cn8Rf12E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792484308;
	b=6wj7WrWH8swKfZzqOG+H07S2DOTGoNqEmvaFgIazp0Ad1p4/n7Ar2l3GEutIgqo0UuK6G9
	TTkmDglucm6t7Vf0GEoufqzBChr6UEd/3HhlKLSc2wrg1eBHKCQVW8dcgiBS3jm43qw12J
	xrvPrD48NdeNBGNHeGZTZM+HRTnkRfs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuyZcDLB;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FA29600AA;
	Tue, 20 Oct 2026 08:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878311F000C4;
	Tue, 20 Oct 2026 08:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484307;
	bh=rhd9i6MZ/tSeH3TKysGHa5PRQgjZlpMeCGZ/ilQN7u4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DuyZcDLBfXNWGZLzrjjSwNI0RzkczO2f3zpg9vZGZFaS9pACw8aG3t0ARdAuQvUpJ
	 Y0yKh/MRIGouMTXjxlKTSRaT6iXqHy71ZAbQXpZ9MkolrGsHxKh/dr/OX1/4OMSeQd
	 8Igv/fmXqVZP1lAGUC08nLriQ983EoBLSu9HIRMP3ZScQWfvC0afHppbX81k0ZFnEr
	 TI1vDWFtseK9Dfpk7vRuXTWYPHawurc49SNlwPBVNrosNDt+prbwGFkSHmFlmVRYgQ
	 tux4Gr+NELTlqmf4DbsgcToRnH0obdgf52u7zp6K/OETHTxV3DpRhRN2JvX9TbaFM/
	 /XwIgnp+F4UPg==
Message-ID: <b6d4de88-cf2c-444d-8050-da2a9b22c7b9@kernel.org>
Date: Tue, 20 Oct 2026 10:18:23 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/3] mm/hugetlb: fix mremap move length truncation
To: Li Zhe <lizhe.67@bytedance.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, rppt@kernel.org,
 peterx@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
 <20261019113034.97690-2-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261019113034.97690-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5377740009
X-Stat-Signature: pxcaebeb1qt7ax64pmnc78fjbxjbifmp
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792484308-57956
X-HE-Meta: U2FsdGVkX1+Dr0eCEWPLCk4zxQsqLCcusfLAAIOYOBBfzE1iV6JYjBSKgb7wDvk7PaIgwcHIcLThNUyeOuhBMJn3FRmMjWUzhXDlhG50IWrGeEFwsza7XpWqKeI+g/N5sdbPWWtGmVDYYNT8VnDPZizlI7M9HgYuoukVWk48aih4EJg5u6l6xU9QbqCy8V+CETVJfAZXD4vr6SJCIU35CsGOTcIGp7H38vKxHeHclwOp4abj2kJ+sIm8hUJAUA3I3QVfeR91gwFnGi7FTP7A/NA76MLVcngIjczmFxLvHlZES3tXA6EjkUNL0eWldHRIgqGk1cIZ7KqOLBZK9TZ06b6/VhmNjWPZQEQw1UXXfdgyK6dKWL+9xKde3/jy7bvU44LK1wkScCAxK1SjnlNnGHUy1o2XtsjdjE+1Um3TnZiL/q22LCIxJeHbW2QxIdXmaodamvjO07G1z/+vKXs5OrDE7c7sl4lx7Hkiw5YVxvABx7I0yRnAZOlm3d7+xXOXiVKR/ak7Jb0jpy6msMG/BkQOSwZclkOhJ8hRxgVQ6uZBrWzzNq0IB4Y3I0GBdFdeCXD8osVPbd6tLiwvagwun8eGTkbID4U6ljFGTNJr3aD8fv15G60caoLtvS8CgeSoT/BvXshYlZt2cd1fGsRh9TT8CXM7HtpK/+3k0ZJAvpSySxHARNtbxFbb8fXp/5NBWCbZeLcKZkG3wi0AU8Pki4v7pjuOxw85a8g8b8EjAldT0qO3ySpLhEg4mTo9za5k/bPCRUuR5SJ4BrDntBZMIbsIa+vZT7HV10PKggbXz8xqiV211b5qjPCGzE9guNmU8WUjAYtgGPV25xsyxEWjwEccQsVzZfW4EeR2OZ+c5rYdONANYMbAX8p2KOcgIF008Esd4NTxjb8TzVT1Jk4NPcTXyd02KMyFL1Z1WyXiH2sPBgTY8svEJuUHMFQYTXvkvMTSgzE+0usS1Ws7c0o
 iPIgxZQe
 T5FHdVEb2x3izf/7Zultrk3tfrtjRZ++3OjE5WLRf/dh1vnaX2ze4reJ4Nm9PQdvi/owzfs78eLchC4YhL8dkU37izgklcQQqJ7yelZUhiPrZKYZWtFy6jI9bfgOtM6iUQK05pWgGEPS0nVcpCamTNppZ1bEt1Ngg70OXeLATRY1bne7y+dhdMX91PcA61Booh/2ly2S4I0JUbze+5l1cuLq2zROrII5fji+ww+dvDKJhahJ+uD9TpI/jgiFHkNbCRs1nNgvxGqx1yBB99uwHAJeaKfzEVnMQKJDbWh/Gv/ntwnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 13:30, Li Zhe wrote:
> move_hugetlb_page_tables() returns the number of bytes moved, but
> its return type is int while the generic move_page_tables() path uses
> unsigned long lengths.
> 
> A hugetlb mremap() move length above INT_MAX can therefore be
> misreported to copy_vma_and_data(). The out-of-range conversion to int
> is implementation-defined; on common 64-bit builds, for example, a
> 4 GiB move can be reported as zero, making the caller treat the move as
> a failure and use the wrong length for rollback.

Sounds like we want to CC stable here, right?

> 
> Return unsigned long from move_hugetlb_page_tables(), matching
> move_page_tables() and preserving the full byte count.
> 
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  include/linux/hugetlb.h | 18 +++++++++---------
>  mm/hugetlb.c            |  8 ++++----
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16c4c4caa126..cc12040e4032 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -121,10 +121,10 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
>  
>  void hugetlb_dup_vma_private(struct vm_area_struct *vma);
>  void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
> -int move_hugetlb_page_tables(struct vm_area_struct *vma,
> -			     struct vm_area_struct *new_vma,
> -			     unsigned long old_addr, unsigned long new_addr,
> -			     unsigned long len);
> +unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
> +				       struct vm_area_struct *new_vma,
> +				       unsigned long old_addr, unsigned long new_addr,
> +				       unsigned long len);

While at it, can you convert all these to use double tab indent instead?

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

