Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC91BC5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 03:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F9A6B0088; Tue, 11 Aug 2026 23:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611056B008A; Tue, 11 Aug 2026 23:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5003E6B0092; Tue, 11 Aug 2026 23:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F20B6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:27:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B221D1402C5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:27:55 +0000 (UTC)
X-FDA: 85091183310.17.8BCC969
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0644F20002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:27:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lSWSVr6I;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786505273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7nCXQyuej60Dy6VlywCutcjX4IZTkZG+J+wPF6RNSA=;
	b=2isaymSr8/pg58Z+ALYmSK7R4/t8vbgae4gBU405WIW/FSp7C3OsINiROf/2k3QByTBGWG
	1ZO7qwo5tIUlkedHRrWniVvhg3F3AaspWllEN0ckKk6bcFZfMfEoxo32dhg5i36IJyfHKI
	nBSopgVuG7vN1ykF7Uk6h3+cve42zbI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lSWSVr6I;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786505273;
	b=INHzQgvW3n3wZOn/UAVL6bFBYFAuaE/alv69H2BdVgqew4wEN3OKw/+/wlmxHLy8x/fywD
	5ht63bkG2QmCmuLOwkNQekDyHjOSRutOHboAQPv1oN52BIBatnDwyHtDPUjzgwCwK0K9Um
	UR3WVIEepse7G/PdFUEscPlqX3hRMuw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786505273; x=1818041273;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DHngFFMTzobiHwpPz3SjP9y266L3Dd5I1hQOUiek3dg=;
  b=lSWSVr6IIOBA+nE7CS6HNVGsc9J50fb6vBLrJdIFK1d/Ev+djFY2Uc/+
   GHAkiKAFc/D2Qo911CnmwaTqBA4yI3NDQ4V7XKO99xMA/EkcANsSR5yGa
   ZjCeA0Odl/zYPSalIw40aZTv1WdeliIzMqNlbPW5RwPFp/83Rg+Q3KkfK
   yo6mZTXzZmUPXClwUksKZQJ483XRuAI6mBHIgO2H7d+prcykvciF320+h
   i85afMebF1kAiOE7TWLq3CXf9axQLj+l9kU6bYJKhD+r/lGAMsf72AjKb
   WDfsj16UZWFpJxhpdhcY9d3iWbFcqe3CR7zgN08qWBPVRfo43HpLZdRCz
   g==;
X-CSE-ConnectionGUID: 65Q09dbxRaqcCU700DrH2g==
X-CSE-MsgGUID: nhMp/esPQpeChoptcNHKYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="89575906"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="89575906"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 20:27:52 -0700
X-CSE-ConnectionGUID: jXyrUnQUTjijHpNVquEIwg==
X-CSE-MsgGUID: bUYlg8z2QcKiPLUcckGC1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="261763974"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 20:27:38 -0700
Message-ID: <5d7151af-79a4-4e3b-8d06-949b1dd670ee@linux.intel.com>
Date: Wed, 12 Aug 2026 11:27:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/41] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-2-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-2-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0644F20002
X-Stat-Signature: gajo4won4mzuz34snguyjn9yb1wcoyte
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786505272-413142
X-HE-Meta: U2FsdGVkX1/2T5Rqtp9+5kAexdzKScgBUkAWK7KckSoCS+Y8yL0/s8CNOVoPapXfX+lUQuPKIWb3X3XpWV9x0dbOpXYhcC/t97up2AbpgLryQYfWzZZhXZYvW1QrReWRTH55fvhchoYZtbrnj6dBq4M2RS80TKD2F06d31R/2Uz1tpoHZJymQL+DgcSev11hu2+kf9JZPxZDiRssbCCP65/Km8stD2jKq+OClOn4NJdwCh3YNYO0dtFYM9Ay/S00uoHbLPE8EV+sJafsQOdHzfht9zznAgdT6N0fG9OFsVABSpcMsjHUXZFTVWxIXiGTLvMEFp+LCaFdlH6hxr5e92yw4yBZNUF44FOV944HnFj7k63KkcUaGwm1rylVM8LpGGujSurwCVvRkRu2bPCQNL0Z4eWu919SZeGFd5Q37qlNVancgOzNmjMdnpWZWdR7YChFFgWjtszUiWLeQkwaiKfBY40SLF17obKsEXfUzGHb+8mksdG79zpSxeGXXRR8g0HFgf5aTaNz+Pdz70Zy9Py1zSvdqfb+6IAVQUzRHn8hqhU4s/w4IWWng6znRTulPjA1oiWOrK8dG2zf7Dd9vjkZTfVThsSmdrc3b+eOmC10R6gIN8tfhMM1A9jWJIzYNxmqhPitNB/OVy56M1gEx0l4VjMQVNLFHd+QfpCsg7BaSXBeZMstubSaepTuQkD4SwHxQtjYozdskuYxKvSRqIiS/NayNWyIOvlV1Hut0WQ43wX2+JYcVMOP+xsfMomMDgpJ5nYzmW63fZ0dj5iScbM4DVN8MbyX3loihSErs9pkTVFPq9Vxx+/1FKG6JTzs07o+uc7tSUCAMDWsSStGoW3SELGj2jcylTCXaLYDxihHt/DFoUvri/7AX/ad53TuvuFjPIF8UYpwo2wZwCuS+pRFhixZmG8iVCzAsw2KPxSh4b4Fad1ajqIb+kthL1wv79bVMVPcmtIH84hso3M
 WkeWHiKm
 HU8hUY7VJbSrK3LCpAK3gLfBmqme2WVUVYIBTvQ5CniwzA67Ud4G2BNi9kAGwa8t1k0KNd9tx5aPpZPkMWydBNhImW4OjCIchJsfApPRjzKzuUS55rMD7FIv1FzClNKY0yDwSW48X9g9hKKkooGUETAVGHQo4URnIFCtCRHhsufCsaRjodleN3KXYS9/MdtM+axhz6bRCu9OLvHKTEiIkXXgKNqRz88le5OT/F6NLVqtQ64EmoxdjON+dSyPPtpJ1yKao439EKMwRZ8NHwJ9SbxwztNJSF1CyH6i1PTGfpBcj0p+0gMRvaHNntxmGfFTop8ktbPGnBs2OGQL0RcGkdzDIHDJ+/WmFq5dovLR2wd1VnjTtVPKZi7Abb6hmXp+8KvRiMHUO5Uetlic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Start plumbing in guest_memfd support for in-place private<=>shared
> conversions by tracking attributes via a maple tree.  KVM currently tracks
> private vs. shared attributes on a per-VM basis, which made sense when a
> guest_memfd _only_ supported private memory, but tracking per-VM simply
> can't work for in-place conversions as the shared/private status of a given
> page needs to be per-gmem_inode, not per-VM.
> 
> Use the filemap invalidation lock to protect the maple tree, as taking the
> lock for read when faulting in memory (for userspace or the guest) isn't
> expected to result in meaningful contention, and using a separate lock
> would add significant complexity (avoiding deadlock is quite difficult).
> 
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

With Sean's fixup in https://lore.kernel.org/kvm/annqex-kBOc0UJvp@google.com/ 

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

