Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555A9C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF326B0092; Tue, 25 Aug 2026 04:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568A76B0095; Tue, 25 Aug 2026 04:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4301D6B0096; Tue, 25 Aug 2026 04:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9106B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:25:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6271E1A0368
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:25:49 +0000 (UTC)
X-FDA: 85139108418.11.06448E5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66B79140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:25:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GND00vCh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787646347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKMrUCQDNqWk8ocF8KL5USQHhwQXnnAyM+MD1VuXNEo=;
	b=4g60BnNKWYKdWjFLSpn8qUmOwd98DkWydzUps1qWjoD6mUcNEfwxwE8L98eM5AZUpDQy7x
	hD7hNCnaiiCYLXq70Ffe6lcFWR1YGHmtbuGX4aQZTJ+IZ+VplDSK+Sgv712ZnHhoN3xnqC
	20FLEVFpsFDJx9OSt2I1tg2RsGD0+dk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GND00vCh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787646347;
	b=csEvGv51x1RT/p8Wxrd75On3rzXONIxcmWTg2nrttRSOyesd34Z7/86uhI0SNNRVQQ4L/0
	EvW86uT18gR4n7ehwmENX6Ixi9sOZOd3JpDYYeJdwqssIOsN2VYslwaF/uI40tLfbBNR/l
	Rfin15HrMnfqlqJNeUqyFl3xNvdvhrY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787646346; x=1819182346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gedJs0vtoiKBYvIXCEhQKxHm0BSByi7gwLqVFH+/z/Q=;
  b=GND00vCh4KEHhXaPHUT/B/pIfMUDFgGJcGJt1TULu/iMQcUks9l6MXPx
   eSeV2IHrQ79ny8uTVJ2qt2gtuI2+4edAb6Bre7E8ljcLxV5fbSTKjB3Dr
   xw/Qxb1A0EaT4t+FS4hyflFy2fDulmUnrIOEvK101O3An3z2SmDa5BkyQ
   jukF0H5ynMAexYSs/I3SKJ+b8ru3IIu7hIJRQG/r4y70kD65iK46eMSLW
   afo2SwtGC3Tl+sgS1B3pDk3UO9deTMRa7wNMCNPHF78XjddpIONli/RUN
   jOhyNwYiHH5LOQCoKgW6b1QHHiInljSubHTOlQf/YGb3FSXyF9UhLE/8P
   A==;
X-CSE-ConnectionGUID: iISGzk+RR0aMJ77vzTsBfA==
X-CSE-MsgGUID: CN1U3pTiSYOKUecpTi/ptQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="99454712"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="99454712"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:25:45 -0700
X-CSE-ConnectionGUID: dbEuODyNSE2d0o/gDaizJg==
X-CSE-MsgGUID: 4cGhqpINTNCvR1Dnz+3ULw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="270695629"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:25:29 -0700
Message-ID: <f7c2e245-ab9d-4ac7-b3f8-815fe111881d@intel.com>
Date: Tue, 25 Aug 2026 16:25:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/41] KVM: guest_memfd: Return early if range already
 has requested attributes
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 <20260807-gmem-inplace-conversion-v10-13-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-13-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a3triqwps5zhauhtsqw5gsabmkhko1oh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66B79140005
X-HE-Tag: 1787646346-444020
X-HE-Meta: U2FsdGVkX1+50re8IeWb8Sa8GMKRrfyPG0Hnj52VMmf3us09TNUcTfGQgDe5662prE5aI18Fg2I+r7O9Nh5wY7YW0Y6JfK/Oeo/J7XLNeh7L1Ux/jMvogVwDVux1I/BboVRkWoukPkwYgkpiQ5JMoFffOhPONGc+Z4CoZcDD1qm/O9nqRiygrVjQKaiREFdbuXLzX8l2vyJRacX72aS3mFGm6XCQT3ff0RhLtZxX9UZBcTQmCpbuFN0zWCpVTLZ4z7OGDlVYgPBK4QTgMChC05w1XF25kg7hJzn16SP972/XeHLsKkYFPBnKSBHLcGbAZkSGhq6pxtFI+MDE046KxjTx1GawlCCMmFrbrfxU3Z30FaiV5msKJ2ZkqTUqDpUck79HG0NCre+3f+uFEsTQdHGmhvoWZV+bsLdhGIMAnC3V2stiaXmouExAFaxhwSCHL9VrXPZfu5OMH2Y7jg0zNcWWVY0piPSRR2iavoZBkq3ffLFqf4kAr6P7716rmDkrajxwv6dGi2BVOQWLATGDu8hSrp1OpflslwF5Chy/YmKzGJCYDsgdZVCme8YG5tz655+5UusZh8Wt8pcDBnYiDxj42+jNRdKhwMglkwQ/AYg/LBpy6eQJUGMax6LW/20jxkvaOKalV890MxFxkPoOIAurnudc8ehOTFnD4RLJRKTZImJLaT+XlEeomBL8WnbBB0R/AJ1N5ZzEKAbxe8ApTg5hc3aFzIvrBiQldMARSgI80x69WrTp8EzCjrHBOkmPoWBc6iZXyycWlIdMJ+PHLu4aCoy1fC9yaTzyzrg2MLDpNLV9GN1NtHW1UQUnYM01iXj8UkxiiYUd9zfbyBWBFv9qD2udoCMmy/hmr73G5mXNCpO0AkJGNysv49qBiWcpNUNIsYye23o1E+7CGsx8l1iQCTG4mJmyUSptA2/10VgvNrwdIfg+GiwcYNv/zkFVIzJGtgc9I1RsxICCSz4
 O8UUpmVG
 OoDyUA191P7+zoh2j63TQxGOsR0+EXQ5Eyn46JZEgyzQUUiMZBO8DyMOmxDkxAqy0ZfIxF2H1RoC1sZdxGCJmRRVmBFj0U3fCQxZKUNH+DZ3qB8ogTHqb4NmS+/WSWrCUf12eiGAOhn93dYy7tAxj3BZF9A+i1TGD6424zfAtfjhnyn9B6WjJCKx2AB9vTU63P5AqqBayjoZ2jizAwgXpk/6fDRf560WK+UyK/GG9m0+fTz6f5k59vOMVYEq8eJ+0hYvYGJrd+nD4MzUVnc+h59HehE1ha37z6Cc7/O9KQ0A5MCLGB465yKdXS0tUx8Qzw7i2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Provide function to check that a range has given attributes.
> 
> Optimize setting memory attributes by returning early if all pages in the
> requested range already has the requested attributes.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index c9874bd85c5d8..896699afcad9d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -95,6 +95,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
>   	return !kvm_gmem_is_private_mem(inode, index);
>   }
>   
> +static bool kvm_gmem_range_has_attributes(struct inode *inode,
> +					  pgoff_t index, size_t nr_pages,
> +					  u64 attributes)
> +{
> +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
> +	pgoff_t end = index + nr_pages - 1;
> +	void *entry;
> +
> +	lockdep_assert(mt_lock_is_held(mt));
> +
> +	mt_for_each(mt, entry, index, end) {
> +		if (kvm_gmem_get_attributes(inode, entry) != attributes)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>   /*
>    * Returns a locked folio on success.  The caller is responsible for
>    * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -605,12 +623,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>   	pgoff_t end = start + nr_pages;
>   	struct maple_tree *mt;
>   	struct ma_state mas;
> -	int r;
> +	int r = 0;
>   
>   	mt = &gi->attributes;
>   
>   	filemap_invalidate_lock(mapping);
>   
> +	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
> +		goto out;
> +
>   	mas_init(&mas, mt, start);
>   	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>   	if (r) {
> 


