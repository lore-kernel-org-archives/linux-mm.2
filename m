Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D30DC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2E36B00A8; Wed,  1 Jul 2026 07:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA7C6B00AB; Wed,  1 Jul 2026 07:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B1E6B00AC; Wed,  1 Jul 2026 07:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A68F6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:07:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 898981C6EF5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:07:52 +0000 (UTC)
X-FDA: 84939932784.24.2D868F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 788AD1A0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:07:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UhBEjII3;
	spf=pass (imf19.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782904070;
	b=U9U/xbfUVUEdl1c0aPvFdQIhnxastOpNm4uWz1z/pcd36l90kE95aZHjbA2xHSXbWj30hJ
	eu0rwYZLBVNVCRaje32QG/isixeqJmwih+SvkleCzT2JwmtV751fPUzeJASFrSm3X3XSaB
	z3XEg9dfnVckCQ/X1lyYTNodY52KyB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782904070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIuavgt6WfS4XzKwlIQ7LHYyqYr0ijg3W3SaEaqQyDQ=;
	b=zfDDptlom+TLJLB0tz+pVKG6KD/5PbVZ8g1YpqJOgNesVK7c9zNiQXNh+lyqelzua0l801
	Jh2xYAFbkUP69Nj2kM/h+YVq7nRPAxkPGMxdHqEl/x5LKcD8ljNq2SlFgMfd82NacS6oTC
	08P9Lk/GzcLaLAsRVYaV/rD3iDZxsJ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UhBEjII3;
	spf=pass (imf19.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782904070; x=1814440070;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hCvnNk/pEx9Q3BuA3GT3urPlvNsb9ZGbJEO+TxrHDhk=;
  b=UhBEjII3MOGjkqeInxy+u+oKXfcOis9wYd6qt6wXBipNegHtx8SCJ1ul
   q7iiaXF+EK6p2FxuezElSHnjS1oCHawiBxBLvp42HhMIhEYe0GFT8Lbu1
   6Pm4QQ3rbbDTCbv4g1R+EhG5sP+iCjFOKmXZ5xBdJjmPK7Jpgq5846tzK
   NmHcXAXvh/py0n4sWv8oAcfFhTMVR0Jqzpr9XGI7REtnNMmjCwAbBz9CL
   XmjU594/EdeW2o5mkxf1A1Lqm9EEyvB8+7jkkduVQ/NrcwmrqPzvgBewD
   CoMk+nBrjfFWdK/9II+5D6DG7EdeeXJPzl71xiyYddsmAj2pF0PLvUCgu
   w==;
X-CSE-ConnectionGUID: mynS1WgUSwyLmX1Lh6rPNw==
X-CSE-MsgGUID: T8gCzhwATraS2mm/g5c2vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87546070"
X-IronPort-AV: E=Sophos;i="6.25,141,1779174000"; 
   d="scan'208";a="87546070"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 04:07:48 -0700
X-CSE-ConnectionGUID: qj8BVJ/XRI6zgtwRVeHuag==
X-CSE-MsgGUID: hj6+vDsNStmOM/iX4E14dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,141,1779174000"; 
   d="scan'208";a="248074941"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 04:07:34 -0700
Message-ID: <25fdb77d-20f6-4b3a-8b3a-dbba0dc47046@intel.com>
Date: Wed, 1 Jul 2026 19:07:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default\
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
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
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com> <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
 <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com> <aj087H1UWSFxbShR@google.com>
 <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com> <aj7NwCRwWEfLK-gQ@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aj7NwCRwWEfLK-gQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 788AD1A0002
X-Rspam-User: 
X-Stat-Signature: pw4pbh7cohfr9h9a658xf6u9egfbb6wf
X-HE-Tag: 1782904069-166158
X-HE-Meta: U2FsdGVkX18HmUu83HF6XDws3E3E4p0dZWL6uKOGcgjyVDVBA4ehMs9dY8xuvGSP/FayztgXEH7uGTDBVXzWhlAEOGAiv1dHQCIpSHg8qz7AM6w+TmhTRU9wPnMRyIU+SP9ZvZiJ4eOmbG8WGAc4lXx4nVy9vSPoITJNF8okBIm2+smFTrPmnnWg7jBS/2xoyIOXs0yGrlZsWqRiVQRaxcgN+CMZnq59i5wfPup4KH0oZ6tB/ZGFfC6f5eZunHzGNB3c5PO+9lYMl/NqCu4mqnW9hlqiKJ6UeeCzM2i79vHl0iKui3w+nu+OxOb65XYG8j2DXHo6KCQH7WSOvvcaVm3DuV5tclSDlq2aKnuZLTrUPsz1MOuq5TXgljjNhfHh80YDLlryQEHkaJYlN8gG0gFI/It9aH9HOzPFVozgvj76NAQ1c9pCFiWubzsOAYQzZW1TZ0UUVb8kMVkjbDRN/wwftvAfKvd4ZqMlnjwd3SjN/74fudzGLwapq8CtfmkCIqMZxYawo8OrPWlw7odVrI222muE1Ixjx/Z3W5246v2A+CURvW/kF3ANYv/WrPLsA+BA+zpTg1p+gEiHFftXhPdXivZrhb0+XuWZNlqyyaCawesUdAFl9ASCpRcL8WouJTshwR01m80OPgOulViFWcoTv5BCS1YcleIWaabDwwp9K0MOEg6DGArhxwQhTTyBM29AAz/JKihXmPk6PXIWZPJ+gIHPheVbWJYXpT9EY6BMBMKj12szMuMpwma2bQRtr1Ht81URxVIZRpYw9vURoeQU6y10drDprJoKZjZ0vG5TiwF3zRc3R6SUs8h++PeKDMEw4rKHO+8it7TwAZLGVC6KNT0/LpClXgIp/YQwpOa3nBayIbhUHkF03gbFm3a5qvJZtjpNj2gdj2NEONFftIUfY5fufxnmwlb8TlghHtB5FseDxJoTp5oPaG2NNCvPQvQCJ+3groZm1SN0xg3
 a4EKQ/1h
 Rdzp7ZBoSzQnwJVT3K7D27PnznN/P2kVDahue+jwpM9h6rGf7Gm0YHDSnJdG4fJVw+q52Vi7Rf8GUuSDnQe2cdlXx7gX1lVuRhsoMEI7uh6Ayp0sFLwn8n+gVXFZ8L8LPNqL8lAnf5zsoUkVfvGtJU7GDx+mU6ponLv70T/ac7m9r9WNQTDO1senQHPOlNC1IgARWE9B+wXXlE5VA4mDppeCBi9J2ZTtAJiYtKtgzvpBlrsdYMPul+WIQJKGtCj4LQg/ZxYGqGwGhCnYwb1jYNeRVvTH4NC07D+0Vezk5jcDR2Iw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/2026 3:06 AM, Sean Christopherson wrote:
> On Fri, Jun 26, 2026, Yan Zhao wrote:
>> My first impression of gmem_in_place_conversion=true was that it enforces gmem
>> in-place conversion. However, it actually only enforces per-gmem private/shared
>> attribute.
>> My worry was that people might think it's a kernel bug if userspace can still
>> have shared memory from other sources after they configured
>> gmem_in_place_conversion=true.
> Ah, I see where you're coming from.  FWIW, truly enforcing in-place conversion
> is flat out impossible.  E.g. userspace can simply replace the memslot, at which
> point the memory effectively reverts to shared.

would something like below enforce the in-place conversion?

Userspace can create a memslot without gmem fd, but that memslot can 
only serve as shared memory and cannot be converted. So it doesn't 
violate the in-place conversion.

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2122,6 +2122,8 @@ static int kvm_set_memory_region(struct kvm *kvm,
         new->flags = mem->flags;
         new->userspace_addr = mem->userspace_addr;
         if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+               if (gmem_in_place_conversion)
+                       new->flags |= KVM_MEMSLOT_GMEM_ONLY;
                 r = kvm_gmem_bind(kvm, new, mem->guest_memfd, 
mem->guest_memfd_offset);
                 if (r)
                         goto out;

