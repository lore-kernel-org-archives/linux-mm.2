Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ECFC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679DB6B00AF; Wed, 12 Aug 2026 05:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A446B00B6; Wed, 12 Aug 2026 05:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A866B00C5; Wed, 12 Aug 2026 05:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286876B00AF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:42:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2910A2259
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:42:20 +0000 (UTC)
X-FDA: 85092126840.26.FF3E414
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5200DA0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:42:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MM2UZ7wr;
	spf=pass (imf25.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQZj+qxVQFBNAL329zsAzJF4lg9dkJcqv8+67/F8PZw=;
	b=FhoHwFtQVTZk4dcmt6chJJSpEtLUixYULCZoMWTWQhWhLdwohThZqWiVJG7c4vp3DwtING
	FZZY68pNVRqAQTao2wUx8BfLwvoEzSURDWNncpF4fnNYNK0CqYviS+ln0x6huoH/Mg+9Wo
	O92Ip3ZtynDzIzkabF8J1HtyRuzU5dM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527738;
	b=7ykRHmCTUJ7HWaIxcYPd1OmSR3ULtmys8UmPl8M+5Dz8frdbHHTfr2TaASsc3CFaA2VMcc
	est1DTw8lI5x2DmP3frq0cf6GqmCLHTnru/lW6LoxH3cvd6xIrieBXyPkfM8dpoG2HdStr
	H0Y17gXj/YqkSreevUAQFBV3gbL+iYY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MM2UZ7wr;
	spf=pass (imf25.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786527738; x=1818063738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hO+eSp3gkznoaX0diJR0FkAzNGsy+/Ay17EoQrYMdDM=;
  b=MM2UZ7wrlYBLtyMRQF/OV/UnThT0LH38pu9OrYIYkG8ucCagtMZfMkek
   EAb6A7uurxdZvyhDdWpm6hgp4NPJdNTsuWd9/HmOyi6ADMS8RItBwzHOc
   KzxgB/0b9XJ4Kz/tZtM9CPsGJN7SaOeQW0b/kI7un0tFONEP14Vk2uT8r
   LdG+FqH+x74Nd4W7Zo6T6o1oeeLeHG1yD/J+y0NQHgHQLMykD17LE5akm
   M1jEa9CMIlSr+L1YLDjZOFmltkk7r+z+OfwgdgCBpJgneFTvxamngXlug
   gfKlM5bwv2+Ja+T8M7/WBfXVIhcVeLWvmqFK6nCAvCxBaAW/BIh6nE6Ow
   w==;
X-CSE-ConnectionGUID: odC2oBCrRXGM5TLB7AhjrQ==
X-CSE-MsgGUID: d6cFbf1eRwyD5aFV1C+IZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="87096859"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="87096859"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:42:17 -0700
X-CSE-ConnectionGUID: Yq4/DjiFSmeanwk+IfKniQ==
X-CSE-MsgGUID: lOQDrXhuRlWrGLkNcCLUBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="267092961"
Received: from unknown (HELO [10.238.208.98]) ([10.238.208.98])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:42:04 -0700
Message-ID: <cc44c9d7-a6cd-40a5-9f68-4822fb9c9d0c@intel.com>
Date: Wed, 12 Aug 2026 17:42:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Sean Christopherson <seanjc@google.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org>
 <annnrGR1noVuBkCc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <annnrGR1noVuBkCc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s58tioecnwssza87wxrqwbdji88euqee
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5200DA0002
X-HE-Tag: 1786527738-851478
X-HE-Meta: U2FsdGVkX1/JOmbSu0DmydiQ7Wj+JeiN/XNCrWrC6sVdhRMXJlvBg9nMTaIDGcjZwrzAfkmi4X+mrpjUvpewvHlLlFBHQ02T4CwX7SUv7sqduY8mPw4BQnEDtOKLXiL719Sc6YZr6ZHOHCTTkwXdl+bk3YNKwlGhRtPcUsLlOIsZzE7DKHny0zY3wJXy/1X0wTw9DdxYvlxhotabnWStbCDUpFAO9GYRiZMJQyXkN/bBYtIy0BYtN+b3Xl7iWIDfBZKPetdhHcFTSaybHc5BeWGVBYQuKumTwFDhRVmr4kMXWI7bUIcLVT4wdnYYMTtsqIFXSnpZud6Lg+/pVEmm1jQqeQnCRz/E0xVMt4dd5shyns34z2tzwsXwlap4UTGRo+FS+ZQifiOLNHbdDHOfyfRtUZlP8EDxN+4gRIA2tdwrfwLiU0gkPDB/+eLDybrBo8JqZAp6PDi4aUjYaxIr/tVYiv4uWyLjnwcbVQliQlmK4ymyZxt1o5QxLD1Zo2n5tPSCBaEPj2jmZr6rTOLrM2b6E0W9/ILP9lHXIN3v2sRWNQnYTI6+TBIpUsJzd0GhisK9r0VpdpnlXlHVJGtgF/mYweyRufgSVNWLgONxNhHWt9Ay20Wb46fDeR0lEDAw9pwcx1vHIvNbg+vd29VXlJccUGtpMXyHO09w/KBdsDGnUw7Yf26JzDyTfvVQWvMsdRjumpyAMlsyX3FI9DXxirjSeqPYkZOs4eMSg2FIqlGQxv6ynA3KIEuL80hWL6wMorNdWNA5Cqg50LK1Am/7WTrDXzXiJEMIgCbWcXr5BzNNTWM2yM1M7GOL+yeDjmMG4QwMDeIZPAZYRSQM9H1Ho5FZAVn2VrhqhkLg4LNH87YXtydV4PadAsS3/jYQapi/UTVIbFN2RPobqbS8TPsvGTy+0BoVglu+2qNNrjcrAyRvFn1RwlUawcGbR/jTLG9JH/7e3YqU2elcR4PLiUg
 uF+C7Z2L
 I1aYeDhQJ+1OmnDCzpH+EyUIVJgSiDlRanekuYRUDjfPyro2hh9/ZQORxBTIWB5ol3vc9bkeXPu4us3BnpnXcFdXuyAPCGMMGcHOoi3YD1oMUX4UN+GcrMrkHBal6JtsH5BFxjp1YOuvb+/oygxKB87BpZzO9S0DlRVAJ0kaq/LltIEBUxqrQzRZq9eOrtXAlAgEJ+blSqMLfsI2QBJzzw14a604yENAZkU+hraLmRtc8r1DFBXCNuU+RgTlObihMZmuoXYs2d+32JpKTt6Vx/Dz+y2dACJdn0dRB1/uE6sUxT4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/2026 11:01 PM, Sean Christopherson wrote:
>> As mentioned in v9, the name is confusing.
>>
>> 	kvm_gmem_mem_is_private
>>
>> ?
> Ya, +1 to kvm_gmem_mem_is_private.

So kvm_gmem_mem_is_private() calls kvm_gmem_is_private_mem() 
internallly. Ummmm.

