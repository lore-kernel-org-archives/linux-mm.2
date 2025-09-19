Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86C1CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A2B28000F; Fri, 19 Sep 2025 03:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331A28E0022; Fri, 19 Sep 2025 03:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2199328000F; Fri, 19 Sep 2025 03:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7EF8E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:44:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF8761A0543
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:44:26 +0000 (UTC)
X-FDA: 83905212132.30.10C83D4
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8623780006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:44:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YlGh/wpG";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758267865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbmPw6Y//j37z9R7nvlC9HN0iJDHXVA3Kzi4zXzQLyo=;
	b=bxf0Z6TnoeovrwNsN2bVhQSVHAIA5IVmDznuthEZa9FOtHhCnakjYVafEPm9c1kNoCpd7Q
	6MaZm29oHEq8GGO6YcuRFbe3tJC5yDlByX/UYuLyiWjDXMFoA65vBIjCNJmmXFy7yV/p2O
	T3otQFUiMpa8+wYP9aJRxxJhjDECveo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758267865; a=rsa-sha256;
	cv=none;
	b=if8w0cbkzEDeGnfvT4vgtUs0rxHigOQkENLkDj8UE34meYzuMc4tzybkomCevLh/YNoPhD
	m/Y4cs098NfrHUqMz8ySHyP+hs6tekCX5pHrm2P9trbA+UP47IPE+UXnh1nAMg8v41fx3p
	/+bDtOwR54RurTDvuTZA6jw+TqdItFk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YlGh/wpG";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f09fe249-552a-46e5-90a3-1a1cf7195af2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758267861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbmPw6Y//j37z9R7nvlC9HN0iJDHXVA3Kzi4zXzQLyo=;
	b=YlGh/wpGO68cBcf/ewHaDRs9z4+TC+A1BRAvtLns5FjFC7N1GS/fM1gSfElx6MmIuDC8J9
	6wsnHL2k34EH625Kb1P6NBGLXz4vykL5/flKZPL4D2rC4ibFyTVd3PaqKnPSFB5f5Zaw2m
	4Nl8nEyeef9KQ2kg5qiGiP0sF4hz46U=
Date: Fri, 19 Sep 2025 15:44:06 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 akpm@linux-foundation.org, david@redhat.com, dev.jain@arm.com,
 ziy@nvidia.com, xu.xin16@zte.com.cn, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 baohua@kernel.org, npache@redhat.com
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
 <20250919071244.17020-2-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250919071244.17020-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 18x5c6e5wz3boo4frgaz7cw6exnhcwi9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8623780006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758267864-753423
X-HE-Meta: U2FsdGVkX1/Rkqdz4YrgK7YAVtVzYxjtOH8G6A9TemG3gGOOLh/lxyx/Ig/XDc5gj5uIxUEs0Dz9rZ+XcPt2L4RE9UlrN8/7AhVecvwTWOpRYVAfuA7uu0ev2kls25y3utCqb7WYKezKXAwwFfAHJ8vJRoiDQYLpGVdk6o+yhz1aM7ZsSGx2+tlY6PYJa7UKnmzHlxMmYNj32bmP2ho0+GKEFKeSNXTiQYVt0A1ED2pnXQnh+8aICBfcoNwzCe6NlTU0/l+gDO3If0264dq/Ka0XOB25Ww2RB9VfsOsx4plvX3ZSLBrJFftc7jFLDLIcHZo+9OijFuyLws9UknHVKbmFWg/gBuQ8oSRKRc0SxzouIoxQKeEXce6+7uj7QWByr69Dh63c0hEW3bCofAWmEqTd5ER/+sgBhexIESlmxXroEXVPEZCQ9vaEtIUBgLaH+2y7/aV4xEr7UhUtZ2+mHLwIM8xJK+1JCHOTpwByAC+QnmQWwZh2qfDKTv7bFBTH3Z9Wyxm3XuQ8Ze5NMGU+RUG6YgPgXodb7b/RWU5youZZHm9He2WCtf1uS2OGWanIi9K8+C5IoxGPmzmBYyGgouvHdkkbgH+JY6cxBEITxBdWQbUubm1lnZB3GHJ5Nm9BdAAdt55UcdH6DwuqWm4RVOQ9JN9CAWkdWhxDwcA2I6e20y9rHkDeaNQtSvjP9R3hbHHgeJITe4HpEJXWtjWjOSdDuCDCz1pwVaxxvLNnhL0F+dzeE+oxdfrBMsoceBHNXyNwSiYffNHVYXF1mCE8bfLKxfzDfCdDKMKdIOC9L99j6XwWkm8WHwMRVd/nergTCXSVlgpMvhZYQNOBARSs15rxJf3HMhZMHCU37BKlhr4fH6AK9UAC81IcElpK/s3sIsMxDkWJ0txCzPwy8hnRnkVMkYZaQ2ltFskVqZn5hPO4PCCGRXmI0u6cfFKLNVJV5Oh98dkDePm6ZALapa2
 xYpd44TL
 /Cy4OTRdoBGuEILPt37vkCHyLFI7NcCtrbwfZfFqNf9JPAJsHIMHKgmd+v8cNo/BkqKx8JzMJC82IlY3xSnzuwtdm9lwh7ez+paYbQka6s3XfpRJEzeh045jpMM1xWMRNPkPP1DCV5koavEVXN7IWO/YARpEjyhfz3mIvOxydLdBJcGXvELKEl08kVv+erSVJe+EH2pMDpoCBsj3FI5RMS26vGIerF+QayeN5nQx3eZ9bP189HD9EirnGpzBIvI5IouNVKYyoZrebMTCE2x+u3usGqVA0+Lop4QyML/9YRfJJMnOCOrDa8d3XDh1x7S/iW+4Wk0KUQRDTh19YKMNfBdxsVHsxq9wr4V5iBpmDZTNJRlixHRcMf08es/EMKbvLw1Duw3RQCFihT5/hh682DwxKD4IbAqkSfWiOg9hFCUZJle8urfjLULYDktr4NfPpyUvl1Vi5nkC1RJ8e6zCzC1tMN2lw1bpEbbnv0td9PimfsREyasDIhNu6jBg4UcNfDg5m7Jg4gjVzYJJjD84M6fHNjVqpl9lE8sHkE75pkyFi1DrMkLrfDXoMffNNTuWkCHKY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 15:12, Wei Yang wrote:
> When using mm_slot in ksm, there is code snip like:
> 
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL
> generally. But currently it works since slot is the first element of
> struct ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu.xin16@zte.com.cn
> 
> ---
> v2:
>    * check on slot before continue
> ---
>   mm/ksm.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2ef29802a49b..6ff7f840e50a 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2939,15 +2939,17 @@ void __ksm_exit(struct mm_struct *mm)
>   
>   	spin_lock(&ksm_mmlist_lock);
>   	slot = mm_slot_lookup(mm_slots_hash, mm);
> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> -		if (!mm_slot->rmap_list) {
> -			hash_del(&slot->hash);
> -			list_del(&slot->mm_node);
> -			easy_to_free = 1;
> -		} else {
> -			list_move(&slot->mm_node,
> -				  &ksm_scan.mm_slot->slot.mm_node);
> +	if (slot) {
> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +		if (ksm_scan.mm_slot != mm_slot) {
> +			if (!mm_slot->rmap_list) {
> +				hash_del(&slot->hash);
> +				list_del(&slot->mm_node);
> +				easy_to_free = 1;
> +			} else {
> +				list_move(&slot->mm_node,
> +					  &ksm_scan.mm_slot->slot.mm_node);
> +			}
>   		}
>   	}
>   	spin_unlock(&ksm_mmlist_lock);


