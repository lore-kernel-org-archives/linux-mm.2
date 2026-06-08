Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05FFCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1397B6B00D6; Mon,  8 Jun 2026 04:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3B16B00D9; Mon,  8 Jun 2026 04:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5B76B00DB; Mon,  8 Jun 2026 04:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4F166B00D6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:55:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A45A1C2468
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:55:44 +0000 (UTC)
X-FDA: 84856137408.07.510A244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A20A92000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:55:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCkFO8Pv;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908942;
	b=Bv+RLK7h72s6FooJ3WbLLd7UpLJzP/UVO7qsRjz2gr+xxnTZZHRryGbA2AHTTaWQLAJUAO
	ItaaqyNwSuMNU+5y8N4HrIaH3rMuR0XFPraUz9bLwGTG8Y8bVeLPpE9qArspb3Nl98rFVQ
	wBxVipjIW0fKDTPTwjDCfGeUWA+L26A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCkFO8Pv;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=andKjaputZdj2JK89k0CuUeF5jJoG1iFA1/oxm6MK6g=;
	b=dfHw5dpreOVM98e60tTWM9RQ4lxI5jKPrcOmc0eCeTEdGGeK17HPBaBj/CIH8HVfZNLe93
	2xBj6pilbfQfPbZeh3rL9LqSMNDVsvO83r+7Kif2kF7+KJhGtiCxAasdKaSBb4szmWllKd
	SVTXuF/XLa5jDQkLVVcIGdVo7O+sXWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B862140C46;
	Mon,  8 Jun 2026 08:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117A91F00898;
	Mon,  8 Jun 2026 08:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780908941;
	bh=andKjaputZdj2JK89k0CuUeF5jJoG1iFA1/oxm6MK6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LCkFO8PvYSl8Urpj1ZwGCTb0JbUIruFNU8NPeRbexBg3c7UY2kvFToy1FTWXfh5Lj
	 WeDCzn3IDSlJPtiUORlmJ+cRn71gfM9RDXfTKT0KY/Z6zBLid4w3b357zEY71o3wDc
	 C/blPBYKpCuwB9inhb9qEruw4GomE0sl/zPk5RsV+LbFcW+NyCrB2x/2txoYQPfQQA
	 j7UjPugNjlHbDFNHM5TYMxf7j+ciL6RP5yeGqf/+G2ZghhBe0onF//HgmJTwlVg6Xv
	 dZIpWCdsF70Rxp33LFaWIbaanFGRwE+OwHrvy0GjAEl2sNVKtGcVy/oP1Vjskyn78i
	 O5zIEEP3sY8Cw==
Message-ID: <509f9a66-5ae9-4c05-bef1-ced89fd29bf0@kernel.org>
Date: Mon, 8 Jun 2026 10:55:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/42] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Content-Language: en-US
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-10-2f0fae496530@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260522-gmem-inplace-conversion-v7-10-2f0fae496530@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A20A92000A
X-Stat-Signature: 4q549k9air6nj8nt8ir1r87gjpsdqfrt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780908942-750163
X-HE-Meta: U2FsdGVkX19U5RYhjcYXvCyuEXnrCTJ9IC7+bkauSEOQq7q3Tsp69Vhmt549U6NUQoTdMouP45oz7nkbWZCxM2tvp/Y8DcgB6h6wYQDxUnZ3wUs6QJ7p1YVQR34ptyr3AjeBhOEFNKTJpla91y8WhItBcbooiOFJQ6EM/tC8tawsEGShTlneXYtT78DvB6iXNSFLWRTIFlmFKCNY+702ILV8PiD0B48vpzOk8yF/lpKxOfuofnKgB9xDiNrVGQbJzPmnrF38HDu03TOKCY35xHVRSqj6YRUXptZrsH2fBl4ymsO+mD6338bv0XnJgH/JQ3yL48K+AV1vnRWd2wuT+XQSFnJIkdZb1vRBLq9YGLOMOHzmRlC5z4LAYgyRXZXJv8wmb+Xuk0mP6k170dUBfBG/jDi56eblPR7qOTm/hYKRyG7P0xhk2wfZF6esgtyLVRwn3hz2apOd7qwuKuUP/ZXFVNaWbruvM4rcAjxVSTZwS7SfeAHPKWq99YYzHV4oybBHoE/NqKq27bzkyHBxFExMxFQ2JMyEXT6T/qkrKvm00pBvf0pUUnN/E+fYf8G4Np4Bc6zRndYHOL5/ASuSSTX/brJC8r5PH73aNDfc10v1suaUHwARwFlKvEnxPbF3K19ZxcgyBGyJRjvL3cask34Qe7u7aPqiznaWbigvAIP3DXDwKDyYomZV0QK11Ucnd0QPJWw78Fb70iDRxLnb7J267FkQy+1dZGZxQYVBNIfWV6JKEgoKD7Qt0CpvNYVD5zf9DJb/3Exc3n+A04JAQn4El90TILr+1H5UR4mNa2ngVYUGcF8VjgfLwHpJUxcM1/uJFabgn3oxg0AVUIskuSHQ7vGAOr51pZZLW3GFfpYMMiWXUOC2kmMNT0vJik2vQayQc05yykosj2HIw9mVKR6IqginBwiU0S6w1ogNtk66Hzp++XRo/tCVhtWFV6P8bkro+tTuQt0h9u/v/S6
 8savloOW
 zsnoYwjCVB7kALlB0fU3cfyW+ndxRmjweDphSxFpSISiJW+4TFItVihv923aCAKLoGB6jNpbwBjXHQsWAjjO3+XfdYrc+yokkyL0APZcTJWGo0Stt4X/V4G14gUirJBKQlaquw/79p6Npf0H/TcQxtVfSK1UNFvnLga24WyT0Y4MfeJjLfvMGNeovTzCPlfx77F4WiwL+G84B5Tb59ndDF7RjLCjIW7gw3GLoqNXCW/8G47md+VeeVwaPjEIVSrINEsmzMH9Ip+nMwqCQwmZ46/89/hSs80rAtKhRDbsLexWE1vdkFGBHCjbsi096YcvQvbYMDWT5YbfSAxXt5oIQ/PQbEVYT/HldUpZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/23/26 02:17, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When converting memory to private in guest_memfd, it is necessary to ensure
> that the pages are not currently being accessed by any other part of the
> kernel or userspace to avoid any current user writing to guest private
> memory.
> 
> guest_memfd checks for unexpected refcounts to determine whether a page is
> still in use. The only expected refcounts after unmapping the range
> requested for conversion are those that are held by guest_memfd itself.

Is it sufficient to only check, and not also freeze the refcount? (i.e.
using folio_ref_freeze()), because without freezing, anything (e.g.
compaction's pfn-based scanner) could do a speculative folio_try_get() and
the checked refcount becomes stale.

Might be ok if we know that no such speculative increment can result in
actually touching the page contents, and the extra refcount and something
inspecting the struct folio won't interfere with anything else. Then it
could be just a comment mentioning why it's safe.

IIRC the compaction's scanning can result in a migration here so it's
probably ok?

> Update the kvm_memory_attributes2 structure to include an error_offset
> field. This allows KVM to report the exact offset where a conversion
> failed to userspace. If the safety check fails, return -EAGAIN and copy
> the error_offset back to userspace so that it can potentially retry the
> operation or handle the failure gracefully.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/uapi/linux/kvm.h |  3 ++-
>  virt/kvm/guest_memfd.c   | 68 ++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 65 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e6bbf68a83813..0b55258573d3d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1658,7 +1658,8 @@ struct kvm_memory_attributes2 {
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	__u64 error_offset;
> +	__u64 reserved[11];
>  };
>  
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 426917d22a2b6..2767992955752 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -572,9 +572,45 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>  	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>  
> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> +					    size_t nr_pages, pgoff_t *err_index)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	const int filemap_get_folios_refcount = 1;
> +	pgoff_t last = start + nr_pages - 1;
> +	struct folio_batch fbatch;
> +	bool safe = true;
> +	pgoff_t next;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +
> +	next = start;
> +	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
> +
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +
> +			if (folio_ref_count(folio) !=
> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> +				safe = false;
> +				*err_index = max(start, folio->index);
> +				break;
> +			}
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return safe;
> +}
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> -				     size_t nr_pages, uint64_t attrs)
> +				     size_t nr_pages, uint64_t attrs,
> +				     pgoff_t *err_index)
>  {
> +	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  	struct address_space *mapping = inode->i_mapping;
>  	struct gmem_inode *gi = GMEM_I(inode);
>  	pgoff_t end = start + nr_pages;
> @@ -588,8 +624,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  
>  	mas_init(&mas, mt, start);
>  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> -	if (r)
> +	if (r) {
> +		*err_index = start;
>  		goto out;
> +	}
> +
> +	if (to_private) {
> +		unmap_mapping_pages(mapping, start, nr_pages, false);
> +
> +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
> +						     err_index)) {
> +			mas_destroy(&mas);
> +			r = -EAGAIN;
> +			goto out;
> +		}
> +	}
>  
>  	/*
>  	 * From this point on guest_memfd has performed necessary
> @@ -609,9 +658,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>  	struct gmem_file *f = file->private_data;
>  	struct inode *inode = file_inode(file);
>  	struct kvm_memory_attributes2 attrs;
> +	pgoff_t err_index;
>  	size_t nr_pages;
>  	pgoff_t index;
> -	int i;
> +	int i, r;
>  
>  	if (copy_from_user(&attrs, argp, sizeof(attrs)))
>  		return -EFAULT;
> @@ -635,8 +685,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>  
>  	nr_pages = attrs.size >> PAGE_SHIFT;
>  	index = attrs.offset >> PAGE_SHIFT;
> -	return __kvm_gmem_set_attributes(inode, index, nr_pages,
> -					 attrs.attributes);
> +	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +				      &err_index);
> +	if (r) {
> +		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
> +
> +		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +			return -EFAULT;
> +	}
> +
> +	return r;
>  }
>  
>  static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> 


