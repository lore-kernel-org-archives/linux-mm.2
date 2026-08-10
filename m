Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E578C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 07:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026D06B007B; Mon, 10 Aug 2026 03:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19C16B008A; Mon, 10 Aug 2026 03:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08966B008C; Mon, 10 Aug 2026 03:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B32446B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:51:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24E07160341
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:51:12 +0000 (UTC)
X-FDA: 85084589184.06.D8623E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67CE9C0006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:51:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gnfQ9ms/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786348270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFgRE53dFjQ80+ECIKjoyM+QU0baooTcvpeBj0dahws=;
	b=TvpHDkZ0JnT174TIG1pQnYkJ0QICthLOVmzBt6wLRYtnis6BiIrdv71OJs1+hxLwLOYJxB
	mme9/lje9nvZ7ZqVF9tqDxzkVgn5r9XUDvWgtCuoPGXXEThnYjqAvQrG6k08uk+nH3fr08
	Hc4Vxz8jfsXj6ECDsZFg5QWUDJqZ+zE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gnfQ9ms/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786348270;
	b=P7G8yv/yFeWF5i6aPlhgSCjqM56iaIUvn5QIEfBEOYhTOMk4BaEilIFko82MkQwmcAARDd
	frRHTVgCy20vPku/xQFI0O0bQLiBK3MJkRq4IQcBVlffA4UFskulRmxTyIFDjP23r5ZrfU
	DSbjLw39uMOcGaNTzygs60mGMTS7MA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF6FD60052;
	Mon, 10 Aug 2026 07:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A255D1F000E9;
	Mon, 10 Aug 2026 07:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786348268;
	bh=vFgRE53dFjQ80+ECIKjoyM+QU0baooTcvpeBj0dahws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gnfQ9ms/oThb5Ch9veMgNhrTO6RV+Xy8+ko76jeYeDO+7MNWt7ILUr4VOZYJYH7Fu
	 wmVCF3vqoPq0IqhPjG6f7APbnsF6MnV/j4bQ6a3M03YAOg5IZl5nuPItDjbmWadvOo
	 QvmASc3lZ+x3DL7GHoC+2d2iJ5CyjDwrc80XZ+1fmlDV6W4rWJZODKBNZL5PcEPCoZ
	 Syh4S9RULj74wrAJ3Cbuymlm32GvB8hwxv6sGMHUk5eGQyl6R8veZWNKMHl1PNE5bG
	 aksDlkqqBybU0sP8CFGkGWinj/KCckNtR222zEw9cDtLUaYruayTRszZ35YsJGMBqF
	 H7J6eu2OWuPJA==
Message-ID: <0a85b27a-121e-40a3-92b6-3927fc298e4e@kernel.org>
Date: Mon, 10 Aug 2026 09:50:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/41] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67CE9C0006
X-Stat-Signature: gxpb61s1ps93u45bxyucs3uwieoe3p74
X-Rspam-User: 
X-HE-Tag: 1786348270-785179
X-HE-Meta: U2FsdGVkX1+Hp0wP5EN875GPfrFmqqI8cC99UWTk7VOC4bWr+UsG2raGwTtDXAxY0HZliZjA/UmV9KemTRBmuuBJd7VVpg2DmGro5iz/Pyes4JNLfwgwNotTGQKezgYsgM25lRaCPT4pw6UHl9XqvfomjFT93UYvIS29xY2n0RmfkDPd/Bc7yWze2g9G/eUgqJk07fiNATRzP1gRow6zXwa94WAhIksbYnrIIfupIyA36FSg5cM/odAobx37VUnIjlig4yjuIdIKbFq7UBpJ1S4QScFcxiwYh8tBTEPJH1fLGdRu/8VRaB7NTaW49aEa51AygUhTWwlfcp/Lz7BHYYP+ML29f2QqCrg+11wGoLeo2SWIwyaZI1LflPBS081D44p5ySSUMNBL8o3ERO8hSHefRlfZLiuuhzpp4akHhf68acoIfb5r+BFgCdcxrm2ORVPWVe2zh9Y9rxbY/mG1aU4+34K5LGSEfHQ1YgdWO+9q3qPnVdq+MeqxHegRKsK88jMeQSsx1wJLWvU32r6JV2+UlU0nCUqVT1tlY+zs3i+waMuyl6+0yJLFMhC8w+7rBxt1qPlyLfJaOieXdxePos/5dEMJcO3zNuFOt2Q4OhXtZ/DOz8o4ezcBPH1flFV01gqtDMn23Kied8PbW/RzyrD716MupRUCIkUUhH7Z7WCYEgg0I7HnJWlIqutSO1dg4KrY5+61ZWq7g0GNmAEo784WE2Uya7WjL8XPiAZZ5jjsZSwdzSb9AEqMvRETKtyNaF/V+qYAIJ2Ulhe2T8T7b0oog024OzcZ1ib2LN4MtYucJvXSm5/U5Zf3EmG4kjvVP6UGlM1qOUHR0H+O2X624QytqYB2XdIJ+1ADRV7Aw0dGgX4Mgu/jyAB5H+pIfQPqxPKyatrCHv36ByfNH7KbicawIUKCfiHYJjzpISpQXunjI5a1tgq3pNad78Gla1u5el9zcfN+xxu4YiCG0Mx
 LL+8t+pX
 8DOKBDBvk86GiDOCmdMJDFjc0jewlpefztuQDkNYBLYxk7/0PfClfeMhiqDRiuygC2eJ/X9klUCk8H4axzA7zPPW7u+l+af5WZIbbgY80jgAXL+h9GV/LO52+WWdbXq4r4fbowSNoxh/EpquvquMftMZPids+tEHhHaany6ghEjb1IWGs9yMXic189N7TONB8LXkbpE0JIwAGfQxKhPxnRnEwAjuhtF4dIeKgDdUrwjpLNKhOmvje/XLVgRNvWKKTUHFaKWcBpJkEhFb9elUo532209YNMlaXrffHmNLxvcUEDgx9pyCMBpo2gQpDqRgZSv7lJL6DrL4mt84BNKxwzuRJBWSwGqKFOxXd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Start plumbing in guest_memfd support for in-place private<=>shared
> conversions by tracking attributes via a maple tree.  KVM currently tracks
> private vs. shared attributes on a per-VM basis, which made sense when a
> guest_memfd _only_ supported private memory, but tracking per-VM simply
> can't work for in-place conversions as the shared/private status of a given
> page needs to be per-gmem_inode, not per-VM.
> 
> Use the filemap invalidation lock to protect the maple tree, as taking the
> lock for read when faulting in memory (for userspace or the guest) isn't
> expected to result in meaningful contention, and using a separate lock
> would add significant complexity (avoiding deadlock is quite difficult).
> 
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 133 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 116 insertions(+), 17 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0bca42a0b346b..3d6547c5ba9a6 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs.h>
>  #include <linux/kvm_host.h>
> +#include <linux/maple_tree.h>
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> @@ -33,6 +34,13 @@ struct gmem_inode {
>  	struct list_head gmem_file_list;
>  
>  	u64 flags;
> +	/*
> +	 * Every index in this inode, whether memory is populated or
> +	 * not, is tracked in attributes. The entire range of indices,
> +	 * corresponding to the size of this inode, is represented in
> +	 * this maple tree.
> +	 */
> +	struct maple_tree attributes;
>  };
>  
>  static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> @@ -60,9 +68,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +static u64 kvm_gmem_interpret_entry(struct inode *inode, void *entry)
> +{
> +	if (WARN_ON_ONCE(!entry)) {
> +		bool initially_shared = GMEM_I(inode)->flags &
> +					GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +		return initially_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;

We have the calculation of the default attribute here and ...

> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
> +{
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
> +	u64 attrs;
> +	int r;
> +
> +	inode->i_op = &kvm_gmem_iops;
> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
> +	inode->i_mode |= S_IFREG;
> +	inode->i_size = size;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +
> +	/*
> +	 * guest_memfd memory is neither migratable nor swappable: set
> +	 * inaccessible to gate off both.
> +	 */
> +	mapping_set_inaccessible(inode->i_mapping);
> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +
> +	gi->flags = flags;
> +
> +	mt_set_external_lock(&gi->attributes,
> +			     &inode->i_mapping->invalidate_lock);
> +
> +	/*
> +	 * Store default attributes for the entire gmem instance. Ensuring every
> +	 * index is represented in the maple tree at all times simplifies the
> +	 * conversion and merging logic.
> +	 */
> +	attrs = gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
... here.

Worth a helper?

kvm_gmem_default_attribute(struct inode *inode) ?

Nothing else jumped at me, and I agree with the kvm_gmem_get_attributes()
improvement :)

-- 
Cheers,

David

