Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD1ECC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E8F6B00D1; Tue, 30 Jun 2026 06:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E926B00D3; Tue, 30 Jun 2026 06:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818CA6B00D4; Tue, 30 Jun 2026 06:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52A6B6B00D1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:46:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA18F4043F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:46:21 +0000 (UTC)
X-FDA: 84936249762.07.CBFF0FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AFAB120003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:46:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jrNKMY1F;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816379;
	b=Lxu0iwbhzPP9gw8KlrQRiycvobcxgOBve0CLAMIlzZPdjcdkMIgOUQosFManAp84HSAl6/
	1WHHShf+VHUZl8OFIH4idxa/oZ8sZPoV+Gh9LudFmLjkiswcm1HqJMNYqcAud6NMk/S1yD
	C9gFU9phtEMuCQXOCrF8iBfRHEV/Dqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG44B22eDfkj3NXxuoUkmFfFDQEh4PhEztP7cpXs2N4=;
	b=XihpKNvmxPQAF2cOJm/whYmkg3lpl9KzrLYZDXUmD15o/US/VITB/S1kT5CmZx2b1RkOd0
	31/vc8pIBcUA1b0Dm65RXRJfy3YgLInepqhe9D1vIlIGb+V8EVnyLAPcojiYbX2NaiIJDQ
	dVu32JEYd4QCAAFGnkXs8IYvwUH8XZc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jrNKMY1F;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782816380; x=1814352380;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ydIclReBsYd1/Q40BSDyaWtNirB1lFLBEoV1UQ/28ZM=;
  b=jrNKMY1Fnfw1CWjC7z+c/DXZJ5hP8Ou6XZ5Y/fXw8RwzNLvMwtEjfXkD
   pWe/PFFoHiZKDxufBCa4b2PCUn56tXgc+w/NQK7f6p5kDWybJKytWxWqQ
   fp/VFX8fiiCd254dBi42c5P3jHVoH1kwwtHQFX0lV5oLyotfl1Lq7Tlwp
   4nP07TTT7wLqmkecxFVAPYMRIAJ+S2ttxxxUR5BLvYWhjOlW3bmpIHXC4
   7A1TMEOIxMlRjaJTxLKy/gEzhuGTM/y50iWpfHNZlw9Q2UJ0ANvFQtr/y
   qYaM88kCEWBaXvX0B6DlkRDbeoqoQN8CaN70ZDTYX4LUbAtCCaPizrjwb
   g==;
X-CSE-ConnectionGUID: 4/1oeTyTTXqLw4m1L7ZMFQ==
X-CSE-MsgGUID: YRwWCsuGTf+Sh86ZBrQcZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94676855"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="94676855"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:46:13 -0700
X-CSE-ConnectionGUID: kIS6WMq4Rfum65TODXoe7A==
X-CSE-MsgGUID: q2IEDfAAQJKrOxUnJNZT+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="251179296"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.239.158.70]) ([10.239.158.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:45:57 -0700
Message-ID: <a22b7696-9923-470a-9696-4db40f80861c@intel.com>
Date: Tue, 30 Jun 2026 18:45:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/46] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-3-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-3-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AFAB120003
X-Rspam-User: 
X-Stat-Signature: ehh1pq56yd79tpaosu4arf8pcwzhoag3
X-HE-Tag: 1782816378-780307
X-HE-Meta: U2FsdGVkX1+9bkWjJQu0hzuZlf+zJzGTCccvkcSgzINW9DM5VvPFcm+vrKL8MxZPpIO2jAly2MXq5njz3ILZwSYPTtfPdU/rpEjwl41AUSOPa7oKmksmOu8swW4ULaRvK7mUBp4mqw11APOdXHYg/6zT+xVNEdJr+1MGFkFtPbUPPGhWCPvwkrmHzwRQRWxI3VJomieFaSwadZDfYfSQgeQY9Oh4zqIRXQiODdlFNHN51bl94jfe9px8VRxZtZI2JgfA33zJAjRqtNpW73vCkm3nb7LUVhbPjBxpCM4a8QZntrO48uUmH/5vzB81Ub8/6hyO5IxEPpwiCG/ZUbEkk9WxLy+asMKktJKUZ4Ew3sZdLfjjBlIO0QrydeJEFjIBZGO7xx43vvbbox+y6o9l6m00Z9CbswRHSZ42xzUqfFgAC9XmFcPyeUMSjK8JT2DARKlkrlbIdCufYEw/Ww4K8PYqH+ONn2SXf22NnzAEeOubgTR3BwIS/wKgD9YULrEvJkwgjJPU9fu98VHc8lB4bi+VY+gP5K1D/dT7+IAbRZPscyljC2M+186V1tokqtXLE2cEdZyhMJ8zCTTfGpzpS5uLeDPQF/4XQmNe8iqmRezS1tf5naAO4aI2dMQUC9VaHxr5Y8AjcZKsUX21r4eK/nx+d/T/lmqFg7x7oO096tb022viHtiAQHV/3TEpz+scEZyv8a7TGhpf0SBBm60ef0MsL/Jdgv/IUCHNBFx9QtQIXpycrJQ4WkYxMMmD2lF+mIGDeJl1Re0HPJAlihJ4Zb0VfBXwknjsaQMJITdT1XvNXhN/TI0CJvtDPcinEbAQXeU+FnxspQAEb8qDUOgP2iLvvlHBhWdRNc0Ok6OHEOq3CVuV5YwNeN4tsNnyKVqocKpfCHJelGeChm/D7nj8PhweG3vclTdcpEIAU4lUW+ZCX6PkflHRtlRqBf0m2/aznSHUgNVZFyXzFSUn6qY
 KsqSLXJL
 iEbuN/TVAo8oJuJ3pgLAcajLuu2TUyxVGUBzqvuniXjN0yAN/hFGcHXjo3ayMHWcF23+E3jEVekvkEX5GuU6eYHGZrmHLdmPula0tQA4pH4PypZ2u07I5s49hImdtwCfUYvT6dZiB9ZkomWNfJDKNh6jMsrgN32HOWDJkyffZbSpyIskDl61cBUgGZfLL0xcBRUz7y9uajWl6xdYJCOqCDjOxZ4j++Armbgoe0VKxa9e5z+KgQxEBR3/oX9/eDYuN7r5dZjybL1NLD5HFh/AbGWnsZZMUOv4/REokmonGF5CDRMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson<seanjc@google.com>
> 
> Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
> from adding support for per-VM memory attributes, because tracking private
> vs. shared memory on a per-VM basis is now deprecated in favor of tracking
> on a per-guest_memfd basis, and while RWX memory attributes are on the
> horizon, they too are expected to be x86-only.
> 
> This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
> user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
> Now that guest_memfd supports in-place conversions, it's entirely possible
> to run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.
> 
> Leave the code itself in common KVM so that it's trivial to undo this
> change if new per-VM attributes do come along.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> Reviewed-by: Fuad Tabba<tabba@google.com>
> Signed-off-by: Ackerley Tng<ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

