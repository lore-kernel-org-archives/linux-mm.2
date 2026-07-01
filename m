Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A1BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6FE6B00A8; Wed,  1 Jul 2026 05:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE796B00AD; Wed,  1 Jul 2026 05:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6926B00AE; Wed,  1 Jul 2026 05:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB9E46B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:04:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E9A4402C6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:04:27 +0000 (UTC)
X-FDA: 84939621774.03.44E52A5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id 002BE40011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:04:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bkktkk3L;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896665;
	b=zwdMumMPn6j8JqANCI1stXJU1sSuXjzVgfUSMAKA37V5vxRKXfXvR1hy6SYr7ESemu+btr
	iqhdQpKcL9/tVPmwHS/NMPFlFfMOSjwZdceBvxom+d1J1PMrERrDqPlp7DYTmhzliypdWT
	kZHtgcPctmpSniOJ1fALQE91MiPdGMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqzrpbrJO9posb5o/ozZlcdMQILmRWmnguyCL696fB0=;
	b=HdEIaj7X+5l4J3G5/A1cd7Z70zUTLcuqwvhq/lhMPoNSJ/PxBlZZIJHkJNQYaw7l28uLEZ
	sSpgux8XJxT+i3ee+JJAH2+KVVkbGV5M/rqx2KImRDRWw5HpNbvnSmKmlZREvB/lKQlSWk
	YkwOXECDBUEGMKyhG/Ecf//Rpyat1I8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bkktkk3L;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782896664; x=1814432664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o6HO5yighH0lbPMGOWuebg9WNrWtRExEVC5nSB71uk4=;
  b=Bkktkk3Lltr2ttw4gghBuNxutlTWIbHY6gy2R8pRdO9Lr7piUso5vbCh
   r10RPrPai4Nygl/oIVkmHkiq/r/ENtfy58rcC1AEma/Rehuycd7I189UJ
   8YdTrE+dty0QDKGYMk7rzUmoPmTbUt8d72zanjJWpC6KiMFCadmx1iA0x
   yqyJhsJvnYgAjGe2kQrHQtaRyy/05hNyG1bUDiu4iShc1uFAxz1fd3t6/
   qd8f7yUGUk0ZKBUYbVpzIvwCYOMy1MxJaoUuLGzGaUNAK23Wb7Kp8bNyv
   0yNW7nRCDyLGYYabOfpSVM6972pD7GS0264xKhvt76hfEI6eHFAO2KS2I
   g==;
X-CSE-ConnectionGUID: mCzOFKuzQnaEWAOCl8Q6jw==
X-CSE-MsgGUID: loVePjraSy+YdcXkf1RmiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="71146236"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="71146236"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:04:23 -0700
X-CSE-ConnectionGUID: RfVhV5zfSDWv+vMwhlsJyA==
X-CSE-MsgGUID: bSAPRm+uSA+mXv3+cFiw0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="252641956"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:04:02 -0700
Message-ID: <584a8f9a-1538-4f8b-b576-75ef0fa961c7@intel.com>
Date: Wed, 1 Jul 2026 17:03:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
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
 <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 002BE40011
X-Rspam-User: 
X-Stat-Signature: 39gcdy3cw9omzipu87cbbh67nczr4djt
X-HE-Tag: 1782896663-616083
X-HE-Meta: U2FsdGVkX19YCbWs9heGSANx6T3oR3e3L7ceUcD+wtvNe/R0aa2v9HS67L78kpyth/aVcQSpTP+jPhQhS3VJ+3fNYxasSurtX233L8WKQVqrPyArtl+sH6bd10JKjYWu4u+UCVZ2QZYLN7nV5JfVNI0+P6Bx9sUIBMEK3Zm2DjMM+kExY8LmQwCmCZsLY3g4aTRShhl5oEy2oABBEpHuzEDBRrNSlzVRXsZ6OFGp56pqHWEhefJk4AZcLZTZRhp5KGVrbgCPNOROGYHWWjpay6Gt762U3OwU6mrGzFU8MRGp3MChMmZc1PPj0Vw6kYK+BO8sBCDxj1kDhNvwnsuxvKhnf3Sr6xm8U83Eeu2yuM2RQRG6JCR2ze+xVU+Z4gqPVIiycbXLV6c7N2KTljC7iZUL+RA3b0641qWlJSpA18cSNSElvK9U7o8xLqopKdz+S9NI6X8Yo7NJbxrce5+ccHRJ/rYjKEliGzP1auxucCb/cvttl2BgIrethLM0p03UH836OsMzMCEPbuKwEv0T3MP0v4X85cMsLFGprtz7a1PaninU1i5fHBN79Ojv38LvG5torgMvJ1GTXr8REjLKqHmr0fyFvcQEFF1DpRIiRINPhcjD+iToO90EF5VDf9d3HtX4ROqzPBWESmh8u5FBpuK84rskF8cvDmwZ383TqdKPzG9eKoFBBmxBez9n9MWw3DF5HOl4Mmi4xZLLpVRqcKgbf4W2xZWJKIAdwbucJYNqwWKrZKvajUCrox+5YWTyqF0XHfEIUaVVSlpf9hYTwmdk+3crEG+C9c7ZevFu+MMd7TR+CE0C+fFZ5BlYhcu4bMOWTFIkqTKNmzkishyMwWLmTqLB9j5RQ+ii0xuLs79rIWOu1EZ1HNTTqvvzEBK/Iqbpp8yBSC1XyUk+2rUugRW1mkOKj7iWkKj2xQhJhxBBRNjA/mROc+e2PdrDcy7MQ92mjRNaDpCqr4wdl33
 XBf30kSt
 66bCHDqBoPBdom3jH32fx52I0F0JTfzH48xChO61uucY7rLoGdrpcPEB5BCwcztGuWC8Aq0qWZFeElMtbK3CGrWRA6hzVt8TZPX9Q3cLzq4xSnr8eVjCg/Ceg8DaEccD0xzAx0fohxyPAsi2PHmNSRs4RZFOqTdpfuoFmEj3wDZdm+VikCvRmnxSCXi+Qud6jI8audPeV4OUkdhUGNID7KeeOUKAw/0yYLeGgqO6LJe1Z/mJ963vGmFjM7DEsDfdtuIp6KOuZ3Sqonz/z53kKz5EbXB9kPP2rucwngIYw0/vckDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> @@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>   		return 1;
>   	case KVM_CAP_GUEST_MEMFD_FLAGS:
>   		return kvm_gmem_get_supported_flags(kvm);
> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> +		if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
> +			return 0;
> +
> +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   #endif
>   	default:
>   		break;

this looks inconsistent with the

	case KVM_SET_MEMORY_ATTRIBUTES2:
		if (!gmem_in_place_conversion)
			return -ENOTTY;

Well, the check of

	if (!kvm_arch_has_private_mem(f->kvm))
		return -EINVAL;

is buried in the following kvm_gmem_set_attributes(). How about moving 
of kvm_arch_has_private_mem() check to put it along with 
gmem_in_place_conversion check in kvm_gmem_ioctl() in Patch 13?

