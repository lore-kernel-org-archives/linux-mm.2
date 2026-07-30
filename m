Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BDBCC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FE36B008C; Thu, 30 Jul 2026 04:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2A36B0092; Thu, 30 Jul 2026 04:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB6A6B0096; Thu, 30 Jul 2026 04:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 007486B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:19:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D9E040944
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:19:49 +0000 (UTC)
X-FDA: 85044744498.04.0325367
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98605140008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:19:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lhI0OFT+;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785399587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6WLUKJFUKQUW5N7f7h5hkTBhzM6TSLYf6QFGG/XuvA=;
	b=Az0aRma8smS1puigbfKFIfwg8u0one7KVU24bxh0p7qG68XNGMxTeEgHm5Qu4IHa0dMyn/
	7aV9StkdxkFncD5UC2rx/G12f6YvMW1puHQiv6A/PbSIX88aee/6MGT4DSH4dFaLBxkXED
	rqRHaEKKOAYXGHvkNP5CauYe+JfBnc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785399587;
	b=wf5tags6N22h6DZuPgqIuIEuqr81DwyYQ8lS73rSVg/GtQ209XbzDWR2xL/hDCEkBstygV
	PjHkGkmQNMPX7i8CujIpdkuiFdjzB5XylcMTYa3hw592YdghDt1Jgvilz3BZtn2oUUetNZ
	AN3BivnQU5CCsw6GrGxkNPLScRCC6EU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lhI0OFT+;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785399586; x=1816935586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wpfIrMcHN8QikkXCKITCLw0AA407+GAAoFiif3VfJc0=;
  b=lhI0OFT+knjAwV7Uw1Ev9wPsZd1PBkNotSczLBmQFCJCm+KFzerFVyTb
   PJIpvaRF0zCTnyJRg4jdLf/gJrpmmft7nVRvsEq2ekGDCM2ZI0LcW5BKt
   EmFNwvVqhc7wMCM5oetwG+6evOm245Yo9+Mu3Ks6ifjISKIQcT+GFfyzv
   AOf61BSbAgL+NVIDeYb1ZT2wsJ50wZ9iAw8L4qkQZJORb/ZXvQnyMv/Wd
   fhMgz0rYC6ZFd1+HhCNfnB2s9Kw3EinseWvgUVRL1qazG5wHf//EBJOKx
   LAHk+c580WMbix3KDO419RCWyRPHiZFRE1QRwEimMOhnvYeZe04nZUNkf
   A==;
X-CSE-ConnectionGUID: Lv6fDg+JRhmsR9OCSrM12g==
X-CSE-MsgGUID: U2+XGjtFRl2q4WcjyahRdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="86091149"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="86091149"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 01:19:45 -0700
X-CSE-ConnectionGUID: 0mKvQIstRByDOckKXDh64w==
X-CSE-MsgGUID: iicRvDLaTO+wZke7z8GHMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="259664017"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.238.208.132]) ([10.238.208.132])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 01:19:34 -0700
Message-ID: <df06e0ec-9462-4072-a0c7-054f1978bf89@intel.com>
Date: Thu, 30 Jul 2026 16:19:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/41] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
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
 <20260728-gmem-inplace-conversion-v9-4-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-4-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98605140008
X-Stat-Signature: rje7z6zxhu4a8c6xft3szc3fyqtrwwt9
X-Rspam-User: 
X-HE-Tag: 1785399586-655931
X-HE-Meta: U2FsdGVkX18Gfxcsaxo4nL5fR05+RqgHZjnnMialxrwWJowisoF/v6X4hpEDLJsaOoa9zPyjXwbkW0EefROzIEy8Md9bkf41nMhKO8vc94mTTsY/7+8AMEYo/YT/s6qSoBzg6FlJ729ad2VPMnTNL6hAcDSDiRNKG0fwvKILLt5OshRI846r/u6YHbWCNmRCz6Ez67zTGsUXQuaJsl7/9PfeXnEYpZLWpPBD8ecwDlaKVBrgrW9URQjQ5bJHZiEVH9fTVjnZGA4wi3vEcmjFahyKtbVTJauEPrulPlA8aF8zuv7bmVvDnMcds96Oo/pzTZJWKIZ/xovn4CTdmrNd0+ioyQVW4WTUC9weQJNQam/Z/05WGkigcfUrs2uennntUx6PiQuP6+PAckGaDaAAmYbwpzBgDcBgaOlap+EzpBD+jj0bIn1Z6r2TW1/V6vGZa4AajEvV5OkrE2tR3W+qUe1b50Me/Qc1bUwG+oMDoFCw+DOuYZlIV/lieHqruN0+BPeK334xVVp6LnpsbitPDkYAQbtxeK4XiDdXRepye7sKvPTrBwasLOZWAHDSWUFuOKNS4/BS3wl4Udp7QHT5iU6hgfI+VMKv2Z6g+uiOp9QxPW3ajU35z8WM3IwRM4s4pt1q07hvQD6cbJUOsCOmgdEIH1EAF+jyeJSa0GnJ9fFlCXQOlyk/A6QWBZnSM6LutCz2ebGhXNWcHLpatHOvYmRKiGYrkUXhazVb2pdNNIwGoj0mnes4FqCVRYzQzI1RsWuSzvBHa8d40bo2rYYvtCAifgV0rFLDeVkj/qhQf2qWtNwfjp50oAa9E2O06iG2KxI+Or72I9OMU9MV4q/rmqF616f+UXUl/5MtHjPrpCDDncwFtBqP7Y9lhDq98Z6RRGoSR4QyKyFZ77irlQouiAWadN5eW1Vre/9vElFt8X3zcfhS3wDYJdZjxd3LVK5i4EP2p014IZGQnSpxSb9
 jnszSRYx
 mpkfZeWGDu5zJ96VoD4XQc250ufp/zWfvy7OyVOFBfAt0oRRo0vtMqksl3daRf5GA5DvWc93r5IGv+j+3oYOqJwxcaqrpMTTjZ0eW/kaICBGnIrCRzhoWIE2yzU0xshEZOS4vn0hA1zUsJwcNEeB8d3tXPzs9hIKPOz9ArP1Zf3z+oF9S7i2ABbyd8ccb4izG++1YF4gJmQbym1RWpO5pBAycxgz+rVA4ZGHT0RpRioMzNOTuOUNgQ2Xk69/kEwP0DsRrmZFIylxQA6h4xeA2mmQ+fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson<seanjc@google.com>
> 
> Rename memory attribute APIs to add a "vm_" in the name in anticipation of
> moving PRIVATE tracking into guest_memfd, to allow in-place conversion
> between SHARED and PRIVATE.  At that point, there will effectively be two
> (potential) sources of memory attributes: the VM and guest_memfd.
> 
> kvm_vm_set_mem_attributes() already has "vm" in the name to indicate that
> it is a VM ioctl. Rename it to kvm_set_vm_mem_attributes() to show that it
> is setting the VM's memory attributes. (Drop the VM-ioctl scoping since it
> is a helper local to the file.) Update the accompanying trace function to
> match.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> Reviewed-by: Fuad Tabba<tabba@google.com>
> Tested-by: Shivank Garg<shivankg@amd.com>
> Signed-off-by: Ackerley Tng<ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

