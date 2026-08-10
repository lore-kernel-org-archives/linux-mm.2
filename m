Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F46C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224756B007B; Mon, 10 Aug 2026 05:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4A16B008A; Mon, 10 Aug 2026 05:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C186B008C; Mon, 10 Aug 2026 05:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C52D26B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:20:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BA1B1C1696
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:20:12 +0000 (UTC)
X-FDA: 85084813464.15.0289908
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 94F7F2000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:20:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Srx5NcHv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786353610;
	b=5bl6bRDKP3I234yjHF4bZVEGYvClzvQg4WMNIuxkZlQaAMHGtw7f8ZooCwhOef/2hsiwPm
	TKIDw+oQ0le9OYnwvEV1IT4/srYkd1mMqgN2ExE3Rghp2WLjh23eyzfKd9ryRaqr0BRNBP
	ZcpLMmDMzQDySvg2yQx24okba4+x73o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Srx5NcHv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786353610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOaEX7G7WbL3WRc3qOqS40hHvnBJZDj9XRocVTD2BrE=;
	b=QtzAqzCu3w9l1D0pPNIt6osdOQOzzHeli8le10rfcuUaRhTxz3ZQdX2GPnSjBaAitpVZWA
	xgr4ktOtoJ/ag+XyKxuVFPjBG9tdPngayLpXSiGkemrM0tVHhcSRIurKezO4EVeWE7xOLC
	Swsomn45P6KljM3u+vzN//TjsAk2r2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEDC6600AB;
	Mon, 10 Aug 2026 09:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EA81F000E9;
	Mon, 10 Aug 2026 09:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786353609;
	bh=NOaEX7G7WbL3WRc3qOqS40hHvnBJZDj9XRocVTD2BrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Srx5NcHvuYWHX7NKDmEKead6xMO2DdHxbktyD9Wsiv3rNza+l3o4CtjVjAv1VubgE
	 3w3ZeQ7jZ+1VmfNPGmp/BFpMnSDsI9RIQtrg0a2v8irfeFG6aMZadFAobQ1+sDZ6ly
	 4UW4Zj7DfHuZjUIWGda7tQp5AhJ981xhEgzC4cz5rW1S4qzCs7DdoWdLOR7X0Cbtt9
	 IU3a8mFD5qgLgfiOk59J7AgohHhlXa52xlis0TM8yJMkYifzxw49Fad1jB5MwWHHPm
	 Xi1xUcLa9D3aOkNAvOT+o2xZ4xRddHQ+h1ExEA7gUCBQQ4G1fXw8ms9QYrrHIJYr3m
	 BjXmxfFWKGSEw==
Message-ID: <eb1b5763-37bc-4cb3-890c-1e619e5a8ae4@kernel.org>
Date: Mon, 10 Aug 2026 11:19:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94F7F2000D
X-Stat-Signature: r1fmpn1phnxwrh9nhfwn8jj8j585hx4x
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786353610-245709
X-HE-Meta: U2FsdGVkX18FXRiZ2Iuumfv5z2ccV3P8tIBHlNYSYDjPsZg0ZqsiDyqmBU7oDsmRpeNMlnkcrQG6TUG+HLCIUsWjIgIa6azxdEfKF3J67GscehIAKo1U+yJRQUD52RMH8tKAo3GhWDi3ewnubsKwqHVtKnfGWTkEWMXNu7b0uk4L1p6lnQsZKtn8xPpY334Pno9cMy+eNgq10H+kRPJFDwqj8wkiYUIO/5tEODSmll5BLx80rk+hBOqpWfc0nIl/ljcF5Jr8DbCC6mbwveAfrMGAW5qL9yjUem466FXLxLGVtPTIymKjRRvi1z2b0Ou4P7FyUiGn/Wv2L6I8PMHDZLubJC+hXFfmIJ5Ffnb6Q41V7uAACV9KtP+CTBVyme5ESla7NQrCm9dOQi2Sr86l+9jYOttT8uPn8+sG6Jv4UY94FYuAAhmSVNBx8acE2W3Rr6f5y8mp1JuQL6h05sNOLBK77Kv1BsQDq+Z1XcKvi7nq+DdqTybG4zAxad7LVRqyEe3mtQaYGGsfxKiSMpgJTOy2cnd4QmFJ8k5ASGyJb4MISH2VP2A0uoH5yBzZkeyx2qwbqk9nlidbM6EU1gr0H2NF7UK5HLawXNE27nUA4m2ys0z/kmA9+GD5C1vQxbvuTHJ3rw8Ct2yYaxgLWyDsV7q7W3CEr9HBlGl+hz8vOCOgXXu0DMVS1qC81jXfljdM/pWWyWkXYa/pk1yxBO4enpjnbJ1XR2aukcUhdto+zl3+UBNBmYwLkqrSEmngwsAgBpkW4mWXUUiHBdv8uTCuvJlz98dOvON34jDnQqfY33knJVTVEbnOV476hrtZSGoM0zhS62c4yBlf6CZ3lW3GQYT/mME8CrcvVUFA169VSQf1GHOfWPTupki5CqLiUAESwYWZiYPkryDXFMH3c3m8k37RRWEYCe7OXkoQprGza9j93rG2IP4wV7deHpqVWqS2LBO0hhpUs/8xjKQcdBB
 y/YTS7N/
 GjO4XwoFUfVL9QHjGNybjnqMtWubYYZWSPhBuvlrrmAzzQvNDBpTSwEdSn3kqOmzUafhU4OPQoZb3NasYB3veq9joU0TJJhRcvusSZ0UZMFHQmEaYePFreqMQvLPnzgoVEgypm+EkVx48CKUDDgZzqVVNf1i6aO8HAezWtR4hw/uR+E+73HJs9xKFp49N1QRT7KpKnBRmQB2sXTbzwJYU2uHQUsBhC0Z1nSk8b9yBs/T5fr30r6txB/4jat5BTlA4ewe+uHYoYysawbKkJwFtcNG9neMDuTBwBmjoDdbidKrt+W0hNiuYopzbrCWDRK+L4K17D6DieBQMhTdHzK+6SModS17UuaslkqauF6pCahnOVCrJ5SLdPAXGatRCdK+DE+Dk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
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
> 
> Update the kvm_memory_attributes2 structure to include an error_offset
> field. This allows KVM to report the exact offset where a conversion
> failed to userspace. If the safety check fails, return -EAGAIN and copy
> the error_offset back to userspace so that it can potentially retry the
> operation or handle the failure gracefully.
> 
> Update documentation to document the error_offset field and the possible
> -EAGAIN error.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

[...]

>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3783e63476569..13c3989136f67 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -524,8 +524,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>  	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>  
> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> +					    size_t nr_pages, pgoff_t *err_index)

I would focus on the "to_private" aspect or abstract it to
"kvm_gmem_mem_has_unexpected_refs" or sth like that.

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
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +
> +			if (folio_ref_count(folio) !=
> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {

I'd rather add a comment than have this filemap_get_folios_refcount.

/*
 * We expect one reference per folio-page in the pagecache and one
 * reference from filemap_get_folios().
 */
if (folio_ref_count(folio) != folio_nr_pages(folio) + 1)

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
>  	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  	struct address_space *mapping = inode->i_mapping;
> @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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

I'd add a comment here for the "why are we unmapping".

-- 
Cheers,

David

