Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A48DC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFC66B0095; Mon, 27 Jul 2026 12:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96706B0099; Mon, 27 Jul 2026 12:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60656B00A6; Mon, 27 Jul 2026 12:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976746B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 254A8140108
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:36:31 +0000 (UTC)
X-FDA: 85035109782.27.B8DDC26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7124E20009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:36:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHC5di3D;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwZp8vrcS5zNu4NMBMc7+FtncQiyjKLq2JUaAvCeOIM=;
	b=QWW1sVxP0yiKjpJhCCk7ckOIMcrG+c1CKRv8g1NgQsGWPmYMcV+CkmkITOWZP+FCcwmTqj
	h4fFokEZOwgz4toP/07vWfIzyGyeX2n/L6Z8504mu3fSkZl2NYmDNJJDItoywlyWROl42T
	jbclrK32l3ewTLCv9q/NDymN7m5tQZs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHC5di3D;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170189;
	b=uoksYjMHHnpyJmw8KMhCnh76YMJs0iR7jc6tMSRzvwHHpBpGRQ59+PrZU/2a9NE+php7Bx
	vqg0GUs1VSCw9UH9O5OkgpKrn5LJvRoH/4bqSitc7f4+iotpBAvnkqG3fK2HRIwKzB8ndx
	XQ92SHt03eTBwYkLPJGnBYfBXGFBC3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D52AC60008;
	Mon, 27 Jul 2026 16:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC261F00A3E;
	Mon, 27 Jul 2026 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785170188;
	bh=NwZp8vrcS5zNu4NMBMc7+FtncQiyjKLq2JUaAvCeOIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DHC5di3D1bGlMzcG7F1Nm23rfd1M/xEorCZ2zg2aJ4kfE3Ia7aVAOoCnNfdnUCb7u
	 xvwTiIyUUZMVxSba/az3+UtCgzeobMK2K7uUXfMy+Fe5hcQ2pWc7ZdVLkHoR2yG5dr
	 QmlOUpofMIT5FjH1AIflWD/OKts1pPW03Q58+kqfANSl6mi8WsYfNjhTk59EMDBkvD
	 +A7BkHY1tQUPXQOU5XBIHE34ro+EVSnjYsSebzp4lUxOkDyhdHMm3ZUzOIMDbfMHw5
	 Pox+sEHGUSM1J/dSayDMcF7wZTwhgGGS6E5ymM+SFqBfPru1/PKFg3nrka9Er++OoM
	 dcORIFdnznoYA==
Message-ID: <06ead85a-59ef-4c1b-8bb6-8eee5c6a00bd@kernel.org>
Date: Mon, 27 Jul 2026 18:36:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: Add unmap_mapping_file() helper
To: =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Baoquan He <baoquan.he@linux.dev>,
 Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
 <20260725210549.3716546-2-kwilczynski@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260725210549.3716546-2-kwilczynski@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7124E20009
X-Stat-Signature: mkrp83xhqpzj9z3w3a6qofmoq1t9bmnq
X-HE-Tag: 1785170189-273108
X-HE-Meta: U2FsdGVkX1//0DZzG/+UjANk0GjD8+I2TFQxgsDwT3VPpxQoap/4DUk5n+3P6gBvnCBzn5cI2iMzN26sg5wqFjo8yX4cCpb/AXUCX/vDelf7q/GZgsCBLwWiF7J0bLxwo07GDYhxPJTsG8j/z7Ql9mfjIiJO8lqnOeKsUW4Ha42QBu4BOJvYwH62PuZhDZ/FWExdBuCpGm7CA+6yaOBy8hfbUb1JNEj7vTPI/ekiftJFc19LwV4IhD1eti7efsMz7K1FQUqW0dgwpPqPS7CAi1YCvb6n4gks3QAXalxSUAPeDu+HKfUsx8/KN+qtz4F5hUeF9JKCZv8i5WYyhY8CeUDBi83TvVMDZy0remhGn65i9y4o7evJnb+ZwhfGeenH/dao4akXk735/Ag+2bAvah2nrSiZ5ZoCmmu+gETa/Wy49ay9ZXuuveBa+uofYVy5LSAGtFl18sJPh49wTqbADvLy4+W7UH+i1UlM3RRl5wDMPhbOVktc2epdAhfvy7bYxDvDMM+HOfv9WRBHLk0GODkoj95cks4z8TFbWe/CyJoqK2gWYvHkorlcSThkK7lc/ce2tfj2fa8F6b2whQbmXqHRH5Rmvb7dtL8iBYnYD0/vbCKm/IvhtHtvNHzAhU7ZC02roe4QtJiAFsiSevNTUH5LJj+xCL5OpS349ANNBpgx+tVefQvXhTWiAlabGYKXxIexSpIr0rvXYAQKAML2Xd4PUZaflU5LOsm5xqoacbnX2Cx/FFTdZ3ZDBw7hLemqsj7UErGwSj41EHr1xv7qUmNPfeBj1IAChz+/TdKUXoENTY9YAzWvOcuH+tV0sKVNwG7vqaOWmxgtNrPFiDK06NqmQFbGBt7eyCTS0O3CWyakmDK/fMb3p9DXbnPkRParS9xtQoftFPH1iMDMdc328cEXRGUVjbcQuDHb+Lrj0aLiNYfg+Tnth3QmH1noUpy74aOfJSjuOCSZbmm+Y9m
 MVC+ZI54
 sOzNtxLC1hzeE90kQVWoiYd7R5lTncgXgS3OLmsupYJjo6P1Lu87QvBn1RYSYwlzNfzkW2K3Sqtz/OM/SazqMqB0SkPSWIr4mfzLg4q+yz9YkfBoJzKW8iI6NLpNmNOG/XO1z/ijvd7Bi1hpZUVUTkOuD+lX9ymIc6a5V0LwvU2Ei0+tu6Aj5Sw7I+NTDfwShT3NB8+cQm+FS6VnGw3XNuDb7Z4c4V59js8dnZ5a6WEMLdbB+565YNFzroAFvwqg7qsbziXXa1kUgT2pIZrP79cI8tn3PUfQ7CIXC4OApFsJvnVCbDUNBvp40qxy4qV7GqN92Xn2Wbs8HwQNkyMbjCvNCpxK6LPRFur+OSM4EHbrQ4H7y+W4nf1yIXlNhp2UvtNueuEOF5q+lVAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 23:05, Krzysztof Wilczyński wrote:
> Currently, unmap_mapping_pages() and unmap_mapping_range() unmap a
> page offset window of an address_space, and code that removes a file,
> such as kernfs_drain_open_files(), relies on them to unmap the pages
> of a file that is going away.
> 
> Files with f_mapping swapped to a shared address space at open time,
> such as PCI resource files using iomem_get_mapping(), have their VMAs
> attached to the shared mapping instead of the file's own inode mapping,
> so unmapping the inode's address space cannot reach them, and they stay
> live after the file is removed.  These VMAs can only be selected by the
> struct file they were created through, which is recorded in
> vma->vm_file.
> 
> Thus, add unmap_mapping_file(), which walks the VMA interval tree of the
> file's f_mapping under i_mmap_lock_read() and unmaps the pages of the
> VMAs selected by should_zap_file_vma(), using the same per-VMA zap as
> unmap_mapping_pages().  When f_mapping is the file's own inode mapping,
> every VMA is zapped, as unmap_mapping_range() does today.  When f_mapping
> was swapped, only the VMAs with vm_file set to that file are zapped, so
> callers do not need to tell the two apart.
> 
> HugeTLB VMAs are skipped with a WARN_ON_ONCE(), as zapping those takes
> i_mmap_rwsem for write in hugetlb_zap_begin() and would deadlock against
> the read lock held over the walk.
> 
> Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..e882a03eaddd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3183,6 +3183,7 @@ extern int fixup_user_fault(struct mm_struct *mm,
>  			    bool *unlocked);
>  void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows);
> +void unmap_mapping_file(struct file *file);
>  void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows);
>  #else
> @@ -3203,6 +3204,7 @@ static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
>  }
>  static inline void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows) { }
> +static inline void unmap_mapping_file(struct file *file) { }
>  static inline void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows) { }
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..4a09d7b6aa6b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4423,6 +4423,54 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  }
>  EXPORT_SYMBOL_GPL(unmap_mapping_pages);
>  
> +static inline bool should_zap_file_vma(struct file *file,
> +				       struct vm_area_struct *vma)
> +{
> +	/* On the file's own inode mapping, zap every VMA */
> +	if (file->f_mapping == file_inode(file)->i_mapping)
> +		return true;
> +

I assume Sashiko complain applies only when this function would be reuse in
other context.

But I wonder if that check is even required, shouldn't below check cover this
already? I'd expect that "vma->vm_file == file" must always hold.

> +	/* A swapped mapping also holds VMAs of unrelated files, zap only ours */
> +	return vma->vm_file == file;
> +}
> +
> +/**
> + * unmap_mapping_file() - Unmap folios from all mmaps of a file.
> + * @file: The file to unmap.
> + *
> + * Unmap the folios of @file from every process that has them mapped.
> + *
> + * If f_mapping is the file's own inode mapping, they are unmapped
> + * from every VMA on that mapping, as unmap_mapping_range() would do.
> + *
> + * However, if f_mapping was swapped to a different address space at
> + * open time, only the VMAs with vm_file set to @file are considered,
> + * since that address space also holds mappings of unrelated files.
> + *
> + * Must not be used on HugeTLB files.  HugeTLB VMAs are skipped with
> + * a warning.
> + */
> +void unmap_mapping_file(struct file *file)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +	struct vm_area_struct *vma;
> +
> +	i_mmap_lock_read(mapping);
> +	if (unlikely(mapping_mapped(mapping))) {
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {

Can we just use mapping_rmap_tree_foreach() here, similar to
unmap_mapping_range_tree() ?

> +			cond_resched();

Why that? unmap_mapping_range() doesn't seem to require one so far.

-- 
Cheers,

David

