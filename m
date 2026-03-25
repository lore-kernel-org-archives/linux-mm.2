Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B069FEA830
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5D36B0089; Wed, 25 Mar 2026 04:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966AD6B008A; Wed, 25 Mar 2026 04:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854D16B008C; Wed, 25 Mar 2026 04:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73E6D6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:49:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16C7A1407C0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:49:20 +0000 (UTC)
X-FDA: 84583961280.19.9929FF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FBDB160003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:49:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOISyRJN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428558; a=rsa-sha256;
	cv=none;
	b=H9DBJhaanpQPT+rbBpx0uit70qZOfyjIE7zXQFYmSo4maRviKHCXKTd8QJ/UUk5w1haBXY
	1CrRuvnd3ctbxVn+6f6POhlqfAoHiMbUr6pgyaZraf2NB9CjPXInsOxLSeUzxtiv3eryXw
	h5Xw/1TGfF712+8IlKTlxlP41vdGmNU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOISyRJN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7JegP3eimdMQFRrs78/ra7/daoFwA/URplEdaVxVYA=;
	b=dtxOCtvx+0bvOjp7EsgKfEX/8dizhkvoH+wn/CdGppCwNDuyURZz5DGrlxiX5n8tZzSB8m
	xzIFWpI1oInC8UCnvCokgeZtbwM+1DzsC8l3Em+ucGCPJcAIB//tbdyBc/copnw6Eym5cD
	T1FGD863vsGHexLyENgDWYEPmdRboVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 252CE41872;
	Wed, 25 Mar 2026 08:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D511AC4CEF7;
	Wed, 25 Mar 2026 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428557;
	bh=TT8uCC50j5LON03XR+370wuR3/hgIDrv5RVCNkZprKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gOISyRJN7vnYb+a/9jSJvZ1Y0J7sMVdE8pgl6Qji+DvsCJqcC4BVCv68kwZfJJjy2
	 RDzK3p4kbjpCa55e4ny9V+kMgzJB9shsVDKfuICtT/xbN6IIg2KqLkWQulSMR835Qr
	 WFru7gPZ4qyk8gJ0Wax9oFoJK93Oc8aOL58m2h/DmGNOJlsCmGc8DBoCpwRumHT3yj
	 sSMNs7E124BWgw2c8A9k59eHr1PPPagfSc16f0GPLTvINVasePOp4P5HOnCP3nsHwy
	 VyEDkmBDFhHrptT9HVUR+wo6l17hvNTe6h6XVldBPR/MI6ODTymIAaEN52neaGN53K
	 OVTU0Fz+5sM3g==
Message-ID: <1075f7a0-232f-4268-94b3-573d11c4203f@kernel.org>
Date: Wed, 25 Mar 2026 09:49:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
To: Andrew Morton <akpm@linux-foundation.org>,
 Jianhui Zhou <jianhuizzzzz@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>
Cc: jane.chu@oracle.com, Peter Xu <peterx@redhat.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>,
 Hugh Dickins <hughd@google.com>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Jonas Zhou <jonaszhou@zhaoxin.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com>
 <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
 <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
 <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uqwx3eo7xq7zdj5odtbqummcfo7hskd4
X-Rspamd-Queue-Id: 2FBDB160003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774428557-379823
X-HE-Meta: U2FsdGVkX19qx7etksLYMsy2Vhzw7X6Ssr2KAaGgRhf1mp3OnaPUiy3vPpc0gkK4wr3XKGA2ySyIBbYaVam2XanPGCMO9QM66ajPa+CxkRTTgIu+qZMr7mDNITXjCiAM5GYQq+DXmzjWYnYf820MJ6fKmGUxdyLh0k1VTk2P6vafAmjCKQa/k78mzOkgtjv6qsuXQs1r5m3r8FJtXS5/yLnn7Q0iUmOGqcDVSONzjRCUtoQVBwHE1G8AiMahScGvSM2Vz1LLn5HVisDbKI4ea2pcBLENREWh5nx+jF8hODCMHtmecnGNv760o9rYd+HKThG504o71R4KD2HaKOSeCyO0TmSY4lWTvSp0mA3QDeQamr3FAnia5uyjDVKMyy19k2cpVaH6iLbXuvIaFTbJnJnXM6IDll2zWHtYkSH0T7zXrzALYXW8JSlOV5tr5OTijhS5wvdO3+05bxZjigxD6XWoCCL7Q3f24xFsn+D1Va0ZEWY9jJbESxvAP8scYbQ2+IMOejDymWHdHwIBC9jCRozieH964Qra8L+VKKjqJpXI+9eFHtxnNereyIGE7TmQ4F1NdDAVa3cvHJ834o0Kc4176SdNeJjPGffJKx4JScIHHJQDi4+kaUopxWT521U+M5ykL0nI9muXLzkYMNuVKn8y7nbPH4qPPbQkcZIeBmVBexV+g5Omalu4lxpk2l8KXCNoWSgESwy+j98aVxTrKdu7/ZZ4thM+GZC/cQUK7fFf+OdGogFwKwkMgZweQ8rLC/q76twnvr6Fy/DHErVQ6PmXlBR0jH2zTORQ6c5wTfj6onjSf3eJ9NN8zBTqFtoVsjiVsMG2xVYtjYXRKTVVeOV72NVr7GimppoZEjWYV6R+SC5Wu5fZSHmpo0V10SDylGSZJOwB1fYGW3HoafPMFSRHt8g1GkkQoL0ln9NIW9PTKcDcD1fNJ4lQWbl5nb1v5MAxtc3riRQc09zWTy2
 /yObaTk2
 WXm5qoFPIebLT4rhEaQSlxG6QwzWPZ5gTnpooxF6Q5Ho1/FsPotZ/Wyil9BaPZ/vgvB9587CNS6OPWHsvJoc//tQMGEWJc5UtQC1B7hukWFBsNKUI3GXAzWJK4XfoJjc15ntE9TFMmEztv+sOL4Pp/VT6BU+L5tsFWBQUjP45ZWV11WJikdTGFGvkzhlmE4DQxo69lUUuniZ8rJp00k5QBn1v81AFVsqxCX84KB/XPYO+Va+gIAd6LD5oy0N/2wvmo8cEK+KPQfPEH0ZwJWEUlg8jsuG/4ChNw2CTe3rPV9qvYN9HechCxv8MSSpVqyCS0YXKwO1N43NaEVPX2A6v0xFR7dcF50Xo7EwRlzInU0ZX8GNVxaZlvU0nbhHaeahTprOECYhf27Rp+etg+WeRhUFqoIR1Ha8nN32pH/+UHaJXwrD8a02VwTlfNOwuzAvj2BZJtyA5ays01hIeSmXR/lWjC+A4WDIvR1SOhBFbUo2Uhqjkl8PXLnWqugAQZKQwETod3DRzIKUZ8tfBloISAzvf3wAyewxkogUnRb6c3/+A9pq0T5tfx69z8t5Ob0ExY9fd4JdrsQJWGotqX1NhA4A5w6PedRsDkrJXqdkS1sL8uhbpbUZrjkPfeP9ytjqiMyuE5Xrv7pwCt4DNDhb9UrlIJjJ8bvZKa+HHPrKFfY67V36LrjzKf/oOH+J+M+MlHNbOS0sbXSPzL9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 01:03, Andrew Morton wrote:
> On Wed, 11 Mar 2026 18:54:26 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:
> 
>> On Tue, Mar 10, 2026 at 12:47:07PM -0700, jane.chu@oracle.com wrote:
>>> Just wondering whether making the shift explicit here instead of
>>> introducing another hugetlb helper might be sufficient?
>>>
>>>      idx >>= huge_page_order(hstate_vma(vma));
>>
>> That would work for hugetlb VMAs since both (address - vm_start) and
>> vm_pgoff are guaranteed to be huge page aligned. However, David
>> suggested introducing hugetlb_linear_page_index() to provide a cleaner
>> API that mirrors linear_page_index(), so I kept this approach.
>>
> 
> Thanks.
> 
> Would anyone like to review this cc:stable patch for us?

I would hope the hugetlb+userfaultfd submaintainers could have a
detailed look! Moving them to "To:"

One of the issue why this doesn't get more attention might be posting a
new revision as reply to an old revision, which is an anti-pattern :)

> 
> 
> From: Jianhui Zhou <jianhuizzzzz@gmail.com>
> Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
> Date: Tue, 10 Mar 2026 19:05:26 +0800
> 
> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units.  This mismatch means that different
> addresses within the same huge page can produce different hash values,
> leading to the use of different mutexes for the same huge page.  This can
> cause races between faulting threads, which can corrupt the reservation
> map and trigger the BUG_ON in resv_map_release().
> 
> Fix this by introducing hugetlb_linear_page_index(), which returns the
> page index in huge page granularity, and using it in place of
> linear_page_index().
> 
> Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com
> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: JonasZhou <JonasZhou@zhaoxin.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/hugetlb.h |   17 +++++++++++++++++
>  mm/userfaultfd.c        |    2 +-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
> +++ a/include/linux/hugetlb.h
> @@ -796,6 +796,23 @@ static inline unsigned huge_page_shift(s
>  	return h->order + PAGE_SHIFT;
>  }
>  
> +/**
> + * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
> + *				 page size granularity.
> + * @vma: the hugetlb VMA
> + * @address: the virtual address within the VMA
> + *
> + * Return: the page offset within the mapping in huge page units.
> + */
> +static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
> +		unsigned long address)
> +{
> +	struct hstate *h = hstate_vma(vma);
> +
> +	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> +		(vma->vm_pgoff >> huge_page_order(h));
> +}
> +
>  static inline bool order_is_gigantic(unsigned int order)
>  {
>  	return order > MAX_PAGE_ORDER;
> --- a/mm/userfaultfd.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
> +++ a/mm/userfaultfd.c
> @@ -573,7 +573,7 @@ retry:
>  		 * in the case of shared pmds.  fault mutex prevents
>  		 * races with other faulting threads.
>  		 */
> -		idx = linear_page_index(dst_vma, dst_addr);
> +		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
>  		mapping = dst_vma->vm_file->f_mapping;
>  		hash = hugetlb_fault_mutex_hash(mapping, idx);
>  		mutex_lock(&hugetlb_fault_mutex_table[hash]);
> _
> 

Let's take a look at other hugetlb_fault_mutex_hash() users:

* remove_inode_hugepages: uses folio->index >> huge_page_order(h)
 -> hugetlb granularity
* hugetlbfs_fallocate(): start/index is in hugetlb granularity
 -> hugetlb granularity
* memfd_alloc_folio(): idx >>= huge_page_order(h);
 -> hugetlb granularity
* hugetlb_wp(): uses vma_hugecache_offset()
 -> hugetlb granularity
* hugetlb_handle_userfault(): uses vmf->pgoff, which hugetlb_fault()
  sets to vma_hugecache_offset()
 -> hugetlb granularity
* hugetlb_no_page(): similarly uses vmf->pgoff
 -> hugetlb granularity
* hugetlb_fault(): similarly uses vmf->pgoff
 -> hugetlb granularity

So this change here looks good to me

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>


But it raises the question:

(1) should be convert all that to just operate on the ordinary index,
such that we don't even need hugetlb_linear_page_index()? That would be
an addon patch.

(2) Alternatively, could we replace all users of vma_hugecache_offset()
by the much cleaner hugetlb_linear_page_index() ?

In general, I think we should look into having idx/vmf->pgoff being
consistent with the remainder of MM, converting all code in hugetlb to
do that.

Any takers?

-- 
Cheers,

David

