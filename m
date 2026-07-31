Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FC2C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7A16B00D2; Fri, 31 Jul 2026 04:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279536B00D3; Fri, 31 Jul 2026 04:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1676F6B00D4; Fri, 31 Jul 2026 04:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D622A6B00D2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:57:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AE60A0356
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:57:37 +0000 (UTC)
X-FDA: 85048468554.18.A8FCC1F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0584740005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:57:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aw5s8MJG;
	spf=pass (imf01.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22/5z8mCuacQu1riQ1ailHyTuMS8BLmTsfHTAmSBOUM=;
	b=syIzTPdYWYdNMpHp0BgiCPlIKJ1tR9udxKAXPsrWvHlzDraRmmN8aqewqr37JQdroFZDOE
	v/LJBqZGlOxlFYwZbT6/pn28G+/1MUTTEqc4NzKUzmhKytXUpKMHMwTZX5DWvV4UAErmBr
	ZxzMEREWkNn4q+Zj0FZN1SZqW31Wi8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488255;
	b=EoY43r5tMa+0AaTxaUjGboP615LA6xQH6rnV6pZyfma7+m2zSKrdK7KOfHJpjWd4nsId4r
	YWSuyyUigHKKHuHNCdSbXY5wao6s8/W2gEShVYXwDj7xzkG95r0LX1sbw+uuaHBrIF83qt
	eDXd7ibGg2FcszmA+OjC1x8rtuU2a/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aw5s8MJG;
	spf=pass (imf01.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785488255; x=1817024255;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1b87pWmuiWigK1wPtNTyW7rMpkhrK9XpARbjh2u7/PY=;
  b=aw5s8MJGfXsoP382n7VNNcFxiZvjRJWrs3xRExx00XFzPhbf7BCJwu79
   M6rEukLPssyoel8BxlsZnyk+FKYAnmxddLw1cppDuFBz+OgZwiFu53fWY
   i5IWE+D280Xr1pYcu0/JFqgpZjFAySWWZnwNuLsoZAT893UBbE1vozNLi
   g0FKGKnnriK0MF1+1nkI2tsGFQFvMnFgXtp40onuArblKYgaomnClE2fl
   xEGAwZtHWbI7lni7ac+3sLS8f1gqCFzo2j5Moh/yW3inY70Qzhh8pFjOH
   9p3NuhkmBPLi9n6zyvpH3A6KXt1ek36mgmBpIOpmyWj+ytg2jlWDqzTVH
   A==;
X-CSE-ConnectionGUID: yaPh146lSR+NsB6C3DFN1g==
X-CSE-MsgGUID: 2HGMvpXTQYm3pi8loCBWkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86063912"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86063912"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:57:34 -0700
X-CSE-ConnectionGUID: w/eqajcFTA22UWQ2rzow+g==
X-CSE-MsgGUID: HP5ylDh8QcWlI7vAtQHsxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="283856796"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:57:18 -0700
Message-ID: <b78bfee9-29f3-4044-8ac7-f294b3cd0ad8@intel.com>
Date: Fri, 31 Jul 2026 16:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/41] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0584740005
X-Stat-Signature: xyxwwrdff4159fw8btnioamdqixmfgwe
X-Rspam-User: 
X-HE-Tag: 1785488254-246292
X-HE-Meta: U2FsdGVkX1/ce7buvGuDqtD0XF2x1/0ppi5Kyw3fnVCYJgsRIwlSaCAdm4Zu7n2m3u1MJM2LUtfjrZpI6CD9UGG7rJ2NXuPNfI3Jl3IYsNIip84cPdqfuG7WWqVMDdV/9nw9ZqQzW3KRRVJEQJ4Y1lyUDqIyGj1zqw1Ktaiyxi6ZyAmQYPGVL7oBFuz3ZjVv3tNz1M8y5jwYPC7kkC9K6KEbpmbTIZu6JeE1K++TeOXzLsXKW5C3wgy7Qu9jkZUlcb0km8WMKgSYpgcHChzKI98nBwUJaMU/RjaKggYJs9Wjt7xEt0ZTUpE0qwx2Sb97lRhWf0XzA/yNJg9nFeTUbJs3mtG5uFRV5SfIVmGggbGnYSTmgSqlmxBd5J43o9my1L0LFV7FSdkiYrrEWJgxnoKHvSa0xWRv3Bmp3YtQ1qa5m0LoOakGiMMn5gNKxVc8p3sO7XXg+cyVpJ/qLfxCJ+N33IkIomvvjOTm5hqHmWJI3txip6u1pHKIVYZZk3gL3+8huRxruIQPH28cf8CqFOo2EA2BJCxEgAHfOVJArZTITwpWgBo5lor8GSDX3pPjeRkE5vtFQTk849Ozu9RvfCEeYoy/1c9YHuafrHsn/uu0eFp8uSFUl2wJJJCzFNE6CUbRf5zXpAaf903Ru8TK45fMVTjhayENR155iynyR8eUvQezEqLcVvWLHEx3IxvTXVYbZeYR7H6doF4mpNWOxdtkG2NZqYFErK9z6geh+fDVIraSb/HgqPP0Gq1T9gw21ncX3vh/LoxF6SxKThoRVnmi9tjT/Qzo9q9Zzn4iSzou8Q3ivMnSi8i7um2+w4vdDc/cb/4Dtc3Uqu3tX9Oiu6JOeIrJ0C1BbOxl27CSrXsBrg0ReuUMajdV31Do1wF0li34N9MQlcV9YW/OylRJemwjP4jL0dQOWdBziCBUSfrV8kIcS5VKBQ/1+2VbxTeZqDpMrzw6FJ3edwW19Oy
 YZYP5+0+
 q+4SulwecUEX8x/dn8HLNcVak4C2c2CMy8dQ1gDzQlmAgOaKYYcRrUmxa0vtCJ1GBC1IVM3tfJaEkyWDQoexfEF7MiLAGeG5fcQ4fPDSSJjJeuBMVMaslHtuJ/uocSYV2pRQIDowXTkk0zC/aJTN8tKTFCQxvOLhVSUFpoxDG/MZqO7FzS8zlUUxbGBwhFSrME/rhC2DLqnqlaZsGRXM1O1SakYNe7C9sO4552K3qWZFwr8biY9UGQMkay5y7QgZX9bHMUUb/YE1eOgxYHBGKrl4y59YAaAIQvjlJ1luVZENPXxv/QONwtYBF2vnyNg7OhWOh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson<seanjc@google.com>
> 
> Start plumbing in guest_memfd support for in-place private<=>shared
> conversions by tracking attributes via a maple tree.  KVM currently tracks
> private vs. shared attributes on a per-VM basis, which made sense when a
> guest_memfd_only_ supported private memory, but tracking per-VM simply
> can't work for in-place conversions as the shared/private status of a given
> page needs to be per-gmem_inode, not per-VM.
> 
> Use the filemap invalidation lock to protect the maple tree, as taking the
> lock for read when faulting in memory (for userspace or the guest) isn't
> expected to result in meaningful contention, and using a separate lock
> would add significant complexity (avoiding deadlock is quite difficult).
> 
> Co-developed-by: Vishal Annapurve<vannapurve@google.com>
> Signed-off-by: Vishal Annapurve<vannapurve@google.com>
> Co-developed-by: Fuad Tabba<tabba@google.com>
> Signed-off-by: Fuad Tabba<tabba@google.com>
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> Tested-by: Shivank Garg<shivankg@amd.com>
> Co-developed-by: Ackerley Tng<ackerleytng@google.com>
> Signed-off-by: Ackerley Tng<ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

<...>

>   static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> @@ -60,9 +68,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static u64 kvm_gmem_interpret_entry(struct inode *inode, void *entry)

Ummm, I'm not sure on the name. It doesn't look like KVM's style?

Maybe, just kvm_gmem_get_attributes()?

> +{
> +	if (WARN_ON_ONCE(!entry)) {
> +		bool initially_shared = GMEM_I(inode)->flags &
> +					GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +		return initially_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	}
> +
> +	return xa_to_value(entry);
> +}


