Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D13CDB46B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 03:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168F36B0088; Mon, 22 Jun 2026 23:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A306B008A; Mon, 22 Jun 2026 23:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FD76B008C; Mon, 22 Jun 2026 23:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF0E06B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:10:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44FE5140359
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:10:27 +0000 (UTC)
X-FDA: 84909699294.17.EA75B23
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57DB220007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:10:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="BLl2Ug/e";
	spf=pass (imf03.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782184225;
	b=AK71Y67ph1+8JIPU8iXn1Ke9128jyYqC8lUcrsIcwROKueElaNYavrrEw2F+LWBLS16Eqq
	JVl5A2ylhrSp+RhbrHn2mXM9Ta6/yL/aJB0YaprtZYNtbNPg7TB5yWRkb30xQUWUdzt7kE
	GIgDpRWbBe7PmBZjwm+etbs3FgEKEfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782184225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGyfP2VRYKfSDyHfYs3S33fJgpK5MhBcS7yYBG6G/vs=;
	b=bVCeb4cW8yy0tJ5XESO62Hd81jbI+9Zq1fjwSSv+eTb/Z3BSnKhgHpxjeYk0W4DWR+m+WO
	HiA+3m7VpgZ3QBlfJ1B3khEgqjiJcqNvT+exowUOqQKp1lCFmMwXwMPHtFxsxnW5kmyPZd
	zDUKvDdUFJ9kv6DJ9h2qfiW3Zqaq0is=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="BLl2Ug/e";
	spf=pass (imf03.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782184224; x=1813720224;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FzB8Fb4p4Mjwmnh7oxOdArQm2a4Bl6t8IOGs1WP0LH8=;
  b=BLl2Ug/eLj8p1uLirtLSh0KPVKuPz79n9xv/OeDHRYsBU3dRGdmatr3c
   tj/8RMSbSniF3stF0N267pPq1jw9uhz5HtGN98F3xziJDaDNOxAg3oDxs
   +dkY7LcQQVMnyDxN9TRKKhRdVyLl2JLPoUbu61nX2dfRAuvcM4Kw+Dix0
   gLBRYKma7fEnEjgA1GAkBYNPVtUP2R6JfGqNCfMguzDImuXit6BIuT1Wn
   WICJx03pjJ4Y2JMqj/IbbUnyv5JbPkBbctVOr7/0JhzVzHpuEsTqwl6Cp
   S0n7v8ant6cu8gMFBAhwNvWtNWabRp/Xz4HpPlGgRmEOac1H84k11MO2b
   w==;
X-CSE-ConnectionGUID: 6Ab1vMPYSXm57EgYatenFA==
X-CSE-MsgGUID: Q25DAH85Rc6OHcDs7d7DUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="100470634"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="100470634"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 20:10:22 -0700
X-CSE-ConnectionGUID: l6e4mZ83QTiXSvs+mWEwsQ==
X-CSE-MsgGUID: FX/cqQqIQeCB/GDWGdGDPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="254376571"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 20:10:09 -0700
Message-ID: <1c3d817b-e5d4-47fc-a716-3a8bd941375d@linux.intel.com>
Date: Tue, 23 Jun 2026 11:10:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/46] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: magcqyys8hpuifcm4y3sk89ze3b8gtic
X-Rspamd-Queue-Id: 57DB220007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782184224-789086
X-HE-Meta: U2FsdGVkX18N5XYBfY6kJc5d3377NyhNXPqMTrbfUdfVjjkyK/idmY3tbagsInABD7/ra+A5Lj9/51UIBj9hA1opb87GhCZGnOjM121eOIogwBnIwp77pPytfCop2YvATpkkDxLzVnEMjA7jP7Icch7JXcIZ375CkYukNH4H4YhVpWDZbSNt4p3K6j4/CTFmQHSgQx9zE6liI+5x1ATublrwFU9Fdkzz0pzlHgXqgxcCbPM7/VuwuCSV204uEFTrkEysuAspK4c9vCLZxoMUjilI+CRBqtDaf84CuXqnhvZOtIKnkLyGDD1fCmTwDkqHAGbvDYAHLldiOzmbh+2gVYRPGV1Pf/fSzzWG0Xlu0Hjz0ikilN2L/w0rG1ywCsR1ErCAxvTZVRaYcdonnUn9M5n2z8aFdIGkCGDcj4t8hC7Qkcf6FEA1wnDIX4/ibJm87PDLOhAR4OgCz/VEHMIPwB6Qfan6ET8fDI7BzQ7xtYLuPzhpsw4mqXZRhwQr76gDXZL7eL2Q6V2gW/JavE4hkiJtb7BN+Ohv6I+MoxsuR1AdaWFnYwRI2eLIFmTU5+x+o1tpvcp8vFGW5rs0ZdCaXAjXkjbEsCuB9t8UUWRq+3fFG5nGsaSapWIjshhQjwDi8LL8aTxH2lkpXC2Uhap+cxSER5aMKqEu5yk+me/nj1OniCUM6QlAbLeUsmuq9eVDcs1ZLb62w61RP7eUXJWGgYCC87L2imIzz1n3fkeMClgJQOZf1qofzOA9DFiGjFqm4iRkN1LQ119Ge4yI0AXJIj/Xga8XVcv8pXGkkhBsKOwyPXrf+8stvWTN1xm0OStIM8Hs6wlmVbJOvYA7hajdgbpZwraNJHhsmOT0wwLJeXM1JSwj5abwQu+l08fLQo49Hv7A/uMFM+TM9LZVc5nAESMH48CdxvBhRIis3EmNoaZRpaXhOTDUB+7r+L95iv05239tBVYRgpcXj2xIAzo
 0h8fA15D
 TzErtTU5BqkZkrKNo7NWCSnezTpNSD4ohQjZtz5UNgNV0CqPie2vkb7tgzJqzVJgAak9n6r2gsCLZKcII7kxD5POOEZoc3sJD5zFp6Tz/PyVCa9R87XJadVi3hxYVh5zQfS36tFe8wswhhYgN6PJXYbETWKMlaGEdE0iqcg75cFFB9A/mDIv/r4tx7hYcnn01zvoKe4FA6yB5QAKhukibxRsS+/FuJEuIeokUSRL1CEhqx0z/VDMH7B/rR64ZXBrO4Yw6l794gZTPbkdgD/XGQO8YDGvHCZSFAxyHxdBFJc+nVvUVQcSVFlePqncABLvxb9u8onpTzpwesak8DKKGXYyTHIRanpCVJv4w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expected to
> use per-gmem attributes at some point), at which point enumerating support
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>  virt/kvm/kvm_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1ccc4895a4c26..7b989b659cf82 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
> +#ifdef kvm_arch_has_private_mem
>  	if (!kvm || kvm_arch_has_private_mem(kvm))
>  		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +#endif
>  
>  	return 0;
>  }
> 


