Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B8FC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0256B008A; Wed,  2 Sep 2026 02:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897146B0095; Wed,  2 Sep 2026 02:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ACC66B0096; Wed,  2 Sep 2026 02:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F256B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:01:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9C63140762
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:01:13 +0000 (UTC)
X-FDA: 85167774426.13.DE9FA4A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BD0080003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:01:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i7py9ARB;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUfXSMIWaUhsq7JusODqm79F9FbvvceZj6jJEknVn70=;
	b=ucDc1xFeDsfqAixR5hkgIypRkjbUL3IiMIWBvkVe6snL8peUH6Devk2PgcjkJ3HUWZWt1a
	Y6O2/IBXZwgoWK6wKuABYN0NE2O47TN2vcLKqdlIIakF6pnOxK50U3DdecAVL572KJ6BRv
	yd+VXY0IdWhAJe5gm59plAbwxd1JzeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328871;
	b=vAEwbxZ2C7xC2Cq+7xp/r7hYhroySGcrpFZWnb2TlcGM/2tGtEXMbxxy0No+woZziliNic
	ySV271kfpgt2ESfvKlcvZgUpqCOlNpcyJzHsaL/20ui/KqD8kHqFbSPTbxN9F/1+F9ARO0
	AU9PXD0g0oA8a/jOtxTIbMxGsRxNAeo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i7py9ARB;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788328870; x=1819864870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wodlJBhhDq6XlgK0pYCVcn+VALi8hcSEbRDEccKfps4=;
  b=i7py9ARBXeYXd2z0ZiwcXhnEEuRAgjUnXN3sGUQzZ4StaMv0kDar3Q4k
   V54OQBVIhT75VZVnnthv9F/2A79y0mTrKNcFVqNW9FjYr8DG1RUW7K1Fz
   Mt7ok1DO2ZTcZPv0CijJBsGk1exEWeC3QPNs/Gm+BnGjC+BhznlFLhsCU
   OaFhA1aB9VNTGXzmbIhUC7Khm9a2bC5idGg96mQrJLJjP17TrsJFZWMwY
   fOfaePhQ0N9tqYKQ5B2mriGr4MWpRNqdcH5bOwt2S/KN3cO7IUH+okWZw
   zqUJqnO0OtXh61HdFOdiclOVavM3XbEcVWH9DuB3QjhcY4MbF0mpwZ/kN
   g==;
X-CSE-ConnectionGUID: wX2c+QP9QC6r/ububED+RQ==
X-CSE-MsgGUID: V1Eq1jl3ReSvLhgqgD3fUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="91287125"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="91287125"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 23:01:09 -0700
X-CSE-ConnectionGUID: 8BboPIKiQX60QPFL8h1p+Q==
X-CSE-MsgGUID: J34KwcEYSM6A4SahyVFplw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="294141256"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 23:00:55 -0700
Message-ID: <7f524b1e-8a3a-401e-9e33-f655b7fc0cc4@linux.intel.com>
Date: Wed, 2 Sep 2026 14:00:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 12/45] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
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
 <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9y7oezo9my5kwmpix3wraif3fmi675uy
X-Rspamd-Queue-Id: 6BD0080003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788328871-304747
X-HE-Meta: U2FsdGVkX1+QAvSTMYxfN1dYuOpxY3RXsb2v3/Ay9mOFkVawB0xAKAurDm/hwc6Xzt5T2VIFnzn5VJ5T8gToFi1AF3wFIuXAXKhSZYLP4eteEIj8qmu1Yd5ig69xqKRfm+/n16XuZVmql4nPUILxjdZemPS6nxXiPPhEwlL6jCU0wU5ybLgUrv9L05ZBc7zwyQ1Tx/nv55zi+V9hia24HttPYlF3zs5x0ZwpuGziinwDJqfNJpuq7jx+h6PQSY88GgsvhZhIHz4C/lGi0YsNycfnmg/wIisXbZg41bXIEHznFBq8ek6Dav+Mb/mCNpbXh1V/HZQ2DnbRu+g0to1x/idqSjVYzqgCk0wyXFmwVvBpqly0+oUSez4SvBhv64hyuwuTIXJIX4hbaUYM+Z2cRsfew9OnBb+6i/AhzfAh81ehtcrqyyoqgYovfDUWMaOwejx+DdKnD8qJQ7nfjSUeO+Fhldeu8vOTgAq2zh3IAoO6kXcuW3jGNDsQr0KQs2ayJLbhNTyWpS9DbdAYe3iMYdl2BFZCcAyVNnGC0K9vBrs4zrAFshYmPID7X89MOiS5ndlc/m9L4INVdaEUnVJhT84b3o7bGeTRuzYJGxdcNrG/Hy8cN9WpXgOEvk6wiEQ2OGSv78wA5e0QiESeB2vFzCVr3z/6J2E7POOL5oZtqWQAEsoGs+kr3efIUv6Y28agtdcPd7Ij9Z9JNf3Efo0TziWErPVdCxKYpDY5qcQKdXtdpVhO/bAGqQrR31XqJGKIMNkZK93FjtoXtmGe9YYL8+oNEdIF8NLUN21vWuc8EKohnm2mK/QUOQtaKNqzEppiEHQcN7tqTvX+Op8QOPEHhzMsx9UNjALNsI/CTvNdQ9r03eEmm/JdBnTdf3ZER9WwQ8zcgFW1CaqnKo5zR6LflZ7ReTbXOQN7ikGu2saKH5YCaoWvHUkZCPxbSuFZmdBGiP5ld9KkYkn1HvImw/L
 nPnfAjlR
 Vw11aTKWBzeUP/4oKq3n0n50lFn4AIiVkbHI35eAmybNm3y7kqJuB6j7bPaw2pPMLMh4dpPe5UMhTUwAgA7RG8mK3QQ8hDdQ0BzS03RhRFF8uicrjK7kiw5NOqHhSTQdqu/F8PQOuYA9/JkOqdQTQN2MEAZKxzxXdEKUd5pMQ/BRB3+Q3W1/1YxUaWlXlu0QZWjJl1758gPkpzLF1n6MTtGYid5JGYPyqV+4qeRcmPHMl1VfEnBJrKrn83+Sw14PRzqD5axdE5/miaZtqFa/1cl3pERAlYjNMjzte1kfRmdHiyVNeInd7EdSsaUcn5q/YZvlfRFkSDrZcFRyEpSZmy2rypQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> If a guest_memfd memslot is created but the guest_memfd does not have the
> GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
> memslot's userspace_addr.
> 
> Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
> guest_memfd's memory will be used for both shared and private memory. With
> in-place conversion, guest_memfd will be the only backing memory for the
> memslot.
> 
> No validation is performed to require userspace_addr to be a mapping from
> the associated guest_memfd because even after validation, userspace is free
> to remap something else at the provided userspace_addr.
> 
> userspace_addr will still be used by functions like kvm_read_guest(), and
> if userspace_addr does not match up with the corresponding memory in the
> memslot's guest_memfd (whether userspace_addr points to the wrong offset or
> some non-guest_memfd memory, etc), that is a user error.
> 
> Requiring both shared and private memory to come from the only associated
> guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
> operation on a guest_memfd, the invalidation is now guaranteed to be
> invalidating only memory mapped from the given guest_memfd.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

