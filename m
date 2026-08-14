Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB355C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42A96B02EA; Fri, 14 Aug 2026 02:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E226B6B02EB; Fri, 14 Aug 2026 02:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30866B02EC; Fri, 14 Aug 2026 02:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B449A6B02EA
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:36:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3650840369
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:36:33 +0000 (UTC)
X-FDA: 85098916266.16.9AB4B88
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7683F40005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:36:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QlnVsyVr;
	spf=pass (imf11.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786689390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic1sZk/lxqNab3ejhnUvaE2nDlNbsvE4zChV7Vo5n9Q=;
	b=MIZge+VkqlfJRTRXkHtJPbLI8ACKkjrbq0X3eZA9AdJleBm5StJ9Dkjm3x3xeMqd6yIFNT
	di7IO3hJu7rSQDGZnhbOwBxu9D+AdvZkr3YB3zbNzzvbVFX/nsmht7MygPTmh+i8vFFbje
	oPhdao9xQlWPen/Y4eD+Snnepm2Eye4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786689390;
	b=ZSDwKC6k4HFaPv9OIF28DONT17sbypslinzj6gotOljD383GvKqjRy39FLSPO0ORNYz0R6
	hfzKYZdCgSnbBVg7Th20tCjd4HgYfcTfGRrtDUKPvaG8XdXw52FuShvkEW8bPLpezHNgqv
	MG18gpURH4hqkwRUFYpq0AjTu83398g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QlnVsyVr;
	spf=pass (imf11.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786689391; x=1818225391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QS50L3Ej/o3Eh9pAbeQ2YK77qR7pbIzS03/vLRtWg60=;
  b=QlnVsyVr9bmKksiopEmi6NsGZOgYzWLZsP2GCcERRlivxcWsUB0upBYf
   Ib/Hsr8yTiLtJTPBPQE5Vnu8N6lJqxjd0CStDl0VfeVJcYwaOQ3o+o87N
   wSAG3ZV45qP1EOPGd0xLbdJ9/0Q4c4M1kxhWk4D/0ybhMRKnY8jWfpZy0
   GZj05N3POW13c4FYFhNNY4oMyIQ9aqyP2fopPX9ufQSZsoWXE1oUkOc+/
   lUufUky4YPZOFJ+xqtmNImIC9bubzvLS0nGQQBQTLPCyr7IvFDCYwEqiV
   STNZPOII9ewKPDrRtyRCTapB+q56iqD0GUiwapM/dBsa9F3I2DgfiN2Wx
   w==;
X-CSE-ConnectionGUID: Ix8tiMPKQfmFqiHPnGi1/w==
X-CSE-MsgGUID: 8zCjWpfCTByPYdtGf25TTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97859377"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="97859377"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 23:36:29 -0700
X-CSE-ConnectionGUID: GUn57tdyTJmSCwMdue8GsA==
X-CSE-MsgGUID: wgv+28R0Spi44YdDQh7WUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="288935132"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 23:36:15 -0700
Message-ID: <658c8441-972a-4298-a4b2-8ec4f2ca338a@linux.intel.com>
Date: Fri, 14 Aug 2026 14:36:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 21/41] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
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
 <20260807-gmem-inplace-conversion-v10-21-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-21-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: prykt5b5epbdjpmcziczhbc5n7z16rw1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7683F40005
X-HE-Tag: 1786689390-669379
X-HE-Meta: U2FsdGVkX19c/AME8+cWX95A2lbsmlfTQvVBgEVxnA4qwCCxE0YPw2fR4A7MABL/vgwoG7/BzdHr60fcQW6GRJBxZlRWb4Q6xegx12hqk10Hggh3+0GhNgDo/NV5nsiNpUxF2GU6gy3+VNh7i+3wXNxQJyJzYJWcCl0FhNw13m4LwfiViYaUsD30ft4PjqLLlaQDcRJgkCMI/bSQ9SdtwHNkNuhrNz+ddD25c3sdOT+cm+I7eIM9jQcM7JysjElmx4iV8PJH13TzMABHY5/dNUa0YTiI2dPY5mNUAWqpRHCpe+ZM8vJuH+G1puaUIA7QKNwNyT0uHZN2G7HYv6jwSG+o2J/fOAjEcs3mt+myyWXNjuhiC12wNScLvAJbM4DXUhMrNMMChW3HfJpLYvD9vB7iI6YZB8SykY4X5itmOHpvjtSm6HR3avnKh/zYpxJmI07B/EgBw/IGyzNFVAou1+qXS7riO/3Yzj9yN5aGPj02eLrT74iPVKjTUQrPREnvUgo/NKC1FQgG2XYQP+TcEZ0WK/2ZG0k8Z8rpvTldqZpiRierQ//rvGTeQurBx3VGt7Ug7csO+JmboHpwKf/j65u3Y9OpLg7Pz01D3Id58rmsgpTaMlM9eQtzriCzQqC0a3mFI1rsEE7WgYMuYu/8d7AckL34+LM9BByfzKEe1xSQf6RVrVjMJtpEQq0hcCGFtesu4drG/hVA1LCmDE9hrgGc8ob+lREzUUsHLcv/qU/TtSpfrDh5Slvo/XFSYH/dQB2PMkYalxOOcdjSbtY/b3y7tSZJhhXvjExLItEJF86HEfcwDwpoR1U5xbKlG9IcqOz3b/pP7njeWRKhMav0CWkLwDLyCBkd1FBEzQFs2hB7D1C03P5otLp2QCmTCJ0jV6B4Gsjx2VGP9vZOMmioWY8NCB2veJMQdJ5XOLKvc+RGwcO17Hzf9QrkZeRgFPugQpKPvM10fq659K9Nlv9
 dQJ8Akyt
 sBQVPqlfGDDWisN+JgGqtfcLh7P5M1lqUIMw56lhU4Jx69FHZ9EoPSEl+95SF88t/GI/p9WgtEIzsac84kMg7BBGurbVw4gKu5nSo7NOivbwZU+I/qWONxmtfW5Qyb6XJTwalFbm4gMZXd/cU38v6xcoFjbhMPc0sURTTXkGjPzKMFSUpv7bQEeczYoefEPYLREc8DMKdeYaF3YFMtLPB4i+LCQX1q4HN1hFcqZTiWJiznD1GApOSvHGb4ZZL4oDckVFg0jsy3sZgLN/9azwbBZC3t0Aev0Y8+ynlEJVufgq8McQG9c+I2IUGxuDP2zsCEei8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Now that guest_memfd supports tracking private vs. shared within gmem
> itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
> for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
> is enabled, i.e. when it's actually possible for a guest_memfd instance to
> contain shared memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


