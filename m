Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD154C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDB86B0106; Tue,  1 Sep 2026 05:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97AB6B0108; Tue,  1 Sep 2026 05:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87216B0109; Tue,  1 Sep 2026 05:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88ACC6B0106
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:19:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 020AF1C1E2A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:19 +0000 (UTC)
X-FDA: 85164644880.16.B87B500
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21B7F140007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ax9/nMk0";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788254358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7Brk22IX8ivgVeznwARkHfXlRRqoPxVQ4XrLKm2tU0=;
	b=E6ZhwBTikyhzcfsuwEIO0y4cGuN7hsVz5eo8pCwtjwcYCl1IN+NdEkXmPN+KgzMnhrOT4v
	R08q37/LiE2SwC+ckjbm7HogvPNDFTkBlgHP7FMPpn4kQHIi9rx8rxq4jFU1ynZ9i0SF9c
	rsf3LzwvpUSuKR2zFJRS5bH5axsLrIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788254358;
	b=f326F6y2E+JZhI1G5SSH0zmUykbtWR2ZGDNHh19OeAKKiLgIzih4U8UT0E87rybLu+UQba
	pAyeX7qP+gL7kddB3C9nRdLZOwiXIeX9tpcBMij0QSynL2baQV5pt5JBoC7/feHPpbRdPS
	SqY4R4q4Zk/DuuIJLocVenr5PcMzfdA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ax9/nMk0";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788254357; x=1819790357;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ybzLPBq1Kqmn0Fx88mmu2PUfpGn2KPU3cTB0rl4kSD8=;
  b=Ax9/nMk06l/n5r+H4V72BLuKqdgI1QxK/y75W8rSy0+UKzYirXZTKhEC
   ea67dnXukhUbq2ToN7kcyDFMwzDqkJlzRpyxOxovq8QzX7vCDOrON4iGi
   QX+5JwF8WLTLU7x7CgjABUOCExTvlxwbfDh8CmBnfK8ZXFmk1barrLdWJ
   2i+CCMU8mK8Rr79UlOOhN9/OqrDYHrJTV1VzmdtS5sivwYMt4Lh72reM2
   2LdZ5zqswl1iKz0MX5vny2CEFvejRBAlDl7b5xP26BZeFRpcQbUzX9qV2
   IcE/LCkA7MO7ENue9FZKH8wxIVY6A1g338i37XVOVf5s439IMqIGSki3A
   A==;
X-CSE-ConnectionGUID: uA7UPBvaQOiRulExhoqIsg==
X-CSE-MsgGUID: MLl7RCdFQV+5JCNgPcNpfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92493111"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="92493111"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:19:15 -0700
X-CSE-ConnectionGUID: dk4Yv7r8QdSTMtXqf1bkOA==
X-CSE-MsgGUID: phpUd5YHQ8+X4qWG9ERdUQ==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:18:59 -0700
Message-ID: <ad5ff907-d468-4556-bfb3-d930b97b2c2c@linux.intel.com>
Date: Tue, 1 Sep 2026 17:18:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 07/45] KVM: Rename kvm_mem_is_private() to
 kvm_is_private_gfn()
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-7-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-7-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21B7F140007
X-Stat-Signature: gnqf131fjeqfmkibqsykjpcu99cupahj
X-Rspam-User: 
X-HE-Tag: 1788254356-465415
X-HE-Meta: U2FsdGVkX1/0izeTX7N7+oJaliIgItOew8I9sNz9MnC++V+PkMwCZeLnokz0dpgQH9VkCgXjnN5sAVygzKkDBOH7e6+vrgwRwxQH8emd22b52XPBz6+145jjlFYjtKStOk1/36/aGFkw9gBtVCEQKIS5uPtACAMF4+AAsEDlVZCxUZQ2kYCwwoESRdTPjlTIqAFu5sIKLD6x4Sx6zjWIIjoBl3HPHQ9etG27JAdRgGRyXtrfwVI26lJ9oBuytTXMDnxk+GJBMJ5HkblMfTT5B6xby56tKBwmxCR9s65VcnRpcAYHEOi+7fXTR4fx6OfQuBMQ2TUTtyVeFJjPtMVEqwknaaoi3uYC0mWt6fhTVErwM0DyUcak7RxmZQFSMPcb+x7rHoeYehxkSmU46nbGEm/6/vDUi2FNOD5El0OYag42Tw9CdSws8qcCNKAFW46dDJHhvghnawIVjAOslDLtaoqgAlxMx2JlncR+0kgWbr4Xfr3jQK7Kj5B/2ASf6oZUyoJ6qArTH7Ujgxo5JhtUqbMkov4cNa50LIjnf/uDV2M1jOUCgwTVq5j1WiK3qW5gLiNIyToW34i8fLoz9C80YNeKq7TvhHqwJjcxfnWN+g9NwCS+nBXeLQl7oVIXpU6oekbdGjisqB/VkHgtSS0n9VndiBN4+DiyOs/wrvYup1i1VbDPlw/Be7l+mSDqs0A7AwIAhAEhcSuR18BtL2bG9xC0COQjgvCI+FRxXNy3X6GNvSQ7izyM1GC/le4HeKBX1LmXPRlE+ZEVxcZ3VSjD9fy0S5op+a+nrsOJJac0KjrsbG9N8zoV6D+h28RELGOCXsl5Xpj7zPNVPfPBCau/I/2wxeo9aQJ0AVHtZtQ2FXpHQsbQa2KvHZdR1j9g4u587ygF9MAHBCYWWGZPtC1AMrYpKpsF9M+EWC8PWPBbHIblp68B9Fq2kTfLGCs4OioDdXdOhSOczckLrTZBP94
 eDLCvwMw
 VGCXp1rxShsZ9+Zzw8PEop9l4Z1a3ITFr5zteUqizVTpu95FGGZMqnfd/5dz5ju5eI7nwNqb2kySqXOVaWYrRxJqmITlUgpjn8IGvXyUXQp1GzH/x1R2avsNrojHYZDqdU31U/blRj3PZSWS2XXF5WmuvTAmtEIpqfQUwEi2C5GDioFHp1qas3xYSfsKtHqMeafP+QhbSIoLAmHya5fX3DkbRJvofbZbTeUMH0no4yDljbZcT2A8ICN2B+GMW+kpPleA8fRnCay2HkxRWeoAB/yg7bBEkC7zrjaz2XQxLRKTdhIgNgmCq2Y8HZ9xZ1KFGROkxBION1merFNdFWhS7R73cog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Rename kvm_mem_is_private() to kvm_is_private_gfn() to prepare for in-place
> conversion, where there will be two lookup functions,
> kvm_vm_is_private_gfn() and kvm_gmem_is_private_gfn().
> 
> This renaming allows consistent prefixing of "vm" vs "gmem" for
> kvm_*_is_private_gfn(), as opposed to kvm_gmem_mem_is_private(), which
> looks like a typo.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

