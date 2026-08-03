Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35979C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA9B6B008A; Mon,  3 Aug 2026 11:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492736B0092; Mon,  3 Aug 2026 11:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7F26B0093; Mon,  3 Aug 2026 11:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16EA46B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:53:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 947C74075F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:53:56 +0000 (UTC)
X-FDA: 85060404072.03.FAE2EEF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 641A11C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:53:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FV1tr54R;
	spf=pass (imf21.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785772434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m53tqHBz8o04tSz5qJQugv22LnUiHdGwEIEysOgbe4A=;
	b=O6SF25XRBOOkFn9YxDKp3i3ATG3NJOvRjVUMhyiTQA3KTM1/tNYI2AavTKItxyvanDXd1f
	RY0X1zxcbjHPuFqF4HvDGduF19SxtSZtxGJvODQoxuFOnye59vBJbDvs1QucUPE2cNaLi7
	ByW7s74/oTKDLZRJdeRQKQ9Ry1Y4cQE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FV1tr54R;
	spf=pass (imf21.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785772434;
	b=EYljQney/fOXiJ8KlkazDf/pCVkWZ5Y4WRakleQ0CrNLUcgIW8SHw41kMHMziPlslPhs/h
	7MlhkSeNMJzaFXTIdcYcwmh3wG6yYzIPgszQrEhu18nSMEb7IHj8CfgEo0mFlvqLW6kQ72
	yMFyXi12YXUtkBrLxe4pXIoqvkUmkFo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 071B5143D;
	Mon,  3 Aug 2026 08:53:48 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7CA3F66F;
	Mon,  3 Aug 2026 08:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785772432; bh=bipZvbkqUPc5n72uKORzyVnSydHD9nn566F6fsSOJZk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FV1tr54R+0e6tXlM27sqOKgR2cBmb4FKaia/3O3OP4s3hKmWPkEG7IS8+OLthX9KX
	 GrYX0Lf2cSfDp5MfswPlbM3sUOONHqIqdrKUH+g+vk3O9IYEduMfGaEbAWs9TEbxZI
	 EQn85U0teStXlYCFKD+VYERDRlEcXckmGvAmfDr0=
Message-ID: <e14e022d-3fec-4edb-9458-47b31b26e0f5@arm.com>
Date: Mon, 3 Aug 2026 16:53:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/41] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
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
 <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 641A11C0002
X-Stat-Signature: 7uwoho5q4t69o9t7jr1apjj6c3dsm5d8
X-HE-Tag: 1785772434-198052
X-HE-Meta: U2FsdGVkX18Jm/SauGNIdC8reQtpTMNYOWRx2wFp6gR7b1sCs2yJOxDwo5tMBOd/S+8BJivRhFkA9ZkdEG6GSZ4QyeIOlWU6RJ/2mDbDtpnR5NU+D6J5HVlqtNl9AbPosrYqlYts+Qnma9mA1wuv5YXt8JZ4M1aA7XCdJT3UEseTbPIXQMUlGEeEsjnv9LM+bVlP3j3OUs9DZvnQFcHbmpF4S3iNhnudHkIO1w9Z2U9zbkxXzowmcT4aRqqMWosJatLFvlEPkpTlTUIOEhaX8d4w8FEfa2VMhu/sGuMroFQnRs+suI84/ZrcMX+hQVfp4IMDCR/ZNgtnD+NuchiiZ3P9TE5zx0PSIEXZlXpy/hKsJCBD1dKAATHq+EF8WBEoUACa1yJxju9YjaO8r+8zrnorTV9SsUWPrur0cMjhioMZYd//Q+MXHOY0tn1GZ2LzzJOmWDqx4O5lwPzwEoJwyeL9Ek1T7tQeq/J6OXolGfoFpDGyXky2O9N1PV1JzBMMWJvvYytCA89iOsUaT4Psu8pjyBLzqjeCnxlAsncJ3tMaJNG+0iDFHAuCdJuEFqxHZm2AXfPb3n4SdF3YmkC1j5KOu36FAtusq+Q/V9oBehEnEnNrw1fhE+D4bhLuBt6M1pUghVB8DiGFutzGNrDwYqL3elSVfpNvOqst2uErSirVdZ0srf53SoPCjdJ48bvpgws4p4wokOPkVWUBmYJM3/deTksTlejErBLFuWNKRg0NwDJjuYX9B5gDoce8xW2lVgRIRUQMl1Vh0zLzoqk2FMkLHciZ+8YFaK7s62+bZ54f1IxUY//KMMoJF0CwG6xlkWkC/vTdu3jbUIhvBxqoZigJlnkOzRLFv2XmlMghWEWGGl6aPV5AJcWKFAobuWeQjqSreei1KE+X8MxiwGkCSSI+PoZGd5hm5G+0J3M9YNtOEUBhEvmyH0m7D14PxiVolslaFbIo7vXPGLSseGf
 mYyhmcQr
 zz+DITJ+fGm5IkiUy0WTbx5+ZoAiAp03HQevKhD5q8muK6OXhe+2TKXrekOzynP9rpNPzP7iqjrl+Zb/al8aWyfw6OVJZ0KIRI87zDabWst0D+RdOFqFIN3qJBloUVEP+coF8y1DHoIUDFmcp7r279nnCYSTQzJIplIYYTriSk0yCn+1rG/90VBa/lwz7ImlwvBHC9/QUeYH3GDNXGE89LFFzpgLWAn1acIatlIOmtdUEeZ3ZK/3zHPflJFNcZQmUB8LfZHAT4qiTPco5WB/eBCsPgsqlfZzjhdQDY+wPfrQjPLIg4R8czmYqWASALw9W5E6Hyside5EAHxku+eJmQX1zWIwyiutlDBjBsJ0+hAWZbkKS+BfPwnYFMZudmK137c8e8KPG2WRQ1k9K/GJFtTq2GnA9BU5w/EIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/07/2026 01:35, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Add a new ioctl (and matching struct), KVM_SET_MEMORY_ATTRIBUTES2, using
> the same base ioctl number (0xd2), but with R/W semantics for the kernel
> instead of just read semantics.  "Officially" documenting that KVM writes
> to the payload will allow KVM to support partial/incremental conversions,
> instead of all-or-nothing updates (which requires complex unwinding), by
> recording the failing offset if an error occurs.
> 
> Opportunistically add a new struct as well, even though KVM could squeeze
> the error offset into "struct kvm_memory_attributes", as there's no cost to
> doing so in practice.  Pad the struct with a pile of extra space to try and
> avoid ending up with "struct kvm_memory_attributes3" in the future.  Use
> the same layout for the fields that common to version 1 of the struct,
> e.g. to ease upgrading userspace, and to provide flexibility if KVM ever
> adds support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.
> 
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
> 
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
> 
> The process of setting memory attributes has a clear point of no return
> because, for CoCo VMs, zapping stage 2 page tables is a destructive
> operation. Unlike regular VMs, where re-faulting pages into the stage 2
> page tables merely incurs a performance penalty, CoCo guests must
> (re-):accept pages after every fault. To preserve CoCo security guarantees,
> guests will not accept pages they did not explicitly request faults
> for. Consequently, during memory conversions, any operation that could
> cause the process to abort must be completed before the stage 2 page tables
> are zapped.
> 
> Zap only the ranges that are not already in the requested state to avoid
> inadvertently destroying (CoCo) data. ARM CCA guests will try to mark the
> entire DRAM as private at boot. If there are no shared pages at all, the
> to-private conversion can be skipped, but the existence of a single shared
> page would require the conversion process to proceed, and if it proceeds,
> zapping both shared and private pages would destroy data and break the
> guest.
> 
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


