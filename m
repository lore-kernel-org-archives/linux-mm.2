Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2747CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FBE6B0088; Mon, 22 Jun 2026 22:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420486B008A; Mon, 22 Jun 2026 22:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EA06B008C; Mon, 22 Jun 2026 22:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E641A6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:48:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42D761A03A0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:48:24 +0000 (UTC)
X-FDA: 84909643728.25.A7C8A86
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A0E6A0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:48:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RmY5ltJt;
	spf=pass (imf15.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782182902;
	b=HZHOYKuccTGgdYVOd2QPmavwnFHNTVx8nSj6k5gbbqIP+rXnTDgMnM7vy+qnPTIikuZyF2
	rNA2rFzb4MVA54+KclxCOAyI8nMWHl0LvWibmZHmniZFLsKVNMowE51mNWqbyc93veYbTk
	5SeYSN1FUeYrq3XOYFkayPXPercYMVo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782182902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqHmD7JR9t+Z/0KEel6mY6qfmZPWJdHpdBu80i1TItU=;
	b=5pAs1abkvStZLwpIoi5AdSFuLs8gYDjmbXlEKweGCFyltPggchBDk5zAPpLci+lZoJqhm0
	hQ+N1QSGaGjrULr7KHMrx3gEaJhXods/4OtJXYNix+4n9daLw+YobvTPItYZwWLx1bJAYM
	7L9IwVtUu7P4dwAMAEN/Z5YNk72EgfI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RmY5ltJt;
	spf=pass (imf15.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782182901; x=1813718901;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xcTCbDjQUR7rxGmM347P8QLVcSjWKie3dpW6fuAityA=;
  b=RmY5ltJta2UToa6PgTZ8wscpAArYHHyNek6hXfOT9qxfGP7fu2OstX1g
   UAAAMWc/d5zcS0GAaoWWKDTdX/R+J8sFXzoSg6yfx3ugEBm1psrlNKZx9
   e5TWm42yq38yCQ8o9mLxFwYO5EWr1R5RKoS9PxV4o4m7LcYBD1KZmpffP
   zyMW4kWBDOIEKsOq02dvAwCqomB6QcOokAtkxZdSWwXTEK9RNhU0aFusC
   0uOh6I/MxiGIxErsU+ECenbBxP1ukpmORhwuhVLabSOk6EHJ3SScIHubs
   GSo9dXsRSuR+rMBsT+jODdv+1WWzAQfcOgWGHP56tv8/pDU0ImxvYg2UO
   w==;
X-CSE-ConnectionGUID: YTboh/qyTQWIZKLYTs+Jrg==
X-CSE-MsgGUID: HViJ17RHQbaREryafkPHkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="108462625"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="108462625"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:48:19 -0700
X-CSE-ConnectionGUID: ge4zSK9JQp2sW0bCR1G14w==
X-CSE-MsgGUID: GAIO5dR+SgyTg9YNRJbOpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="249520909"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:48:06 -0700
Message-ID: <7391833b-f754-4cdf-a46a-9a27d357750b@linux.intel.com>
Date: Tue, 23 Jun 2026 10:48:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/46] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to
 KVM_VM_MEMORY_ATTRIBUTES
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
 <20260618-gmem-inplace-conversion-v8-2-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-2-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: e447pu79p3fq6q68isjhsnbuw86z3371
X-Rspamd-Queue-Id: 6A0E6A0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782182901-260106
X-HE-Meta: U2FsdGVkX1+rCdVS4D3j0TcCva+zv6VhAaOBTbumwy0UgdKJddY2YBWv29INbS9fitmIO3D3FfJ34a80Wk7k7QqWbwCTJ4y7vWmHOHlG7JSTMNyHqNe5UJfjv1712wL0OIW7+3eolkhvG0hI/Lf9lgesUsMPRJRwT9yBqM6aVq3IhRjoMYZWBG40M8e00CK5cXF4PxYIfXxJ8i+FvIVRktzTJehQWDW/pIU/nH817UL5OH7JSIuIzD0y+vLGZH7Px2n0spwBQJzgfA7XfqsklV+2IvKjMCxaNmGCkor7mZDHwsaGg1DBddTY3GyRwF74LWnxqG7ONOhBkMejl+bdAmeQrNUhxiGGBnvLhh7IBESo7Hj6XWlgt4u8t2lPZSKvQXQ5T50IjNN9HBn8SBBzmd6B0JgGHq8d7NjfvK4CcuyUwGGeXLF0gLMTZ1mi54v2cG3rlFokmZDXGrduhZgpubsza0N3b3xpq+Ciss48pavm7YneVXTyMFxlBx4P9qVVW4uzK5B+mVvXXmwpBghsx/87onDNws+K/bDsXhxelb+zKAIR85DPVPmLkbFfzMtZkS6+3D323YazV24jnqTiLUKuqla1kLC12CLUEIYbChM1n3dHuemHGVPqbZV+j2KiJzCurO/e34nffZ5fvXICRRVZsFdbnePUwOuhY9dG8a0LT229h+3BTr+Z7fqkPccqkt/RbgmYqrlIs5lHACBRgF/BXVFOwJSOIxjvgCsL7MewBYLxAYcN8n8pORkfCxc0LO/DZ4OJ2yEjCCOvVddJifsqICp5OYlM9UT4hUhIQCWQpagfCtC7JCKID8FLuBk6613RidcFwCfGPD/HUGYb5L106RxRVGO61BRA2Jj39L7fIRqT00gU2eiuYWsDPl7wjZwE9WXhae/Ha/0nzNKviumafTEbJ+IiP0Vi2z/zVjJ4KYcdfKDPbqfNb8Q9lj9mEMPMDVmNS5WOdCW97go
 HaFMjr+5
 4Lle7ThpH1u9uvmtM6dTnsFPb5OGAOBQc/Ma4ue4asfYl40xVYNSBFAwKOsuri8jIkMcop1wl2D6+N+P63PKieb8FLW0UGLP6YP5Nio9vVbR3l3ALlfwC4+9DSR0JKgGvNi9QqB1zBC2MBkgGTZLuYCAWKGrZdNu7igbBOT7vqeHeHmluVh87fFsIET8DUtK1WYJ8oq+JbkOgVB1SAZTuX1y5DGkX8MwZNGQKZQ8TQFqF0dlEgLFVYrnQWSofHAruxcP6wM7YciiASZwPUTHyzcCPfVkI80A28kd/AB6ZVDDrcmYM40OO5z/+4voJ960LoK5Hcpq6AIb9pXs7cV8ZYXiwGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Rename the per-VM memory attributes Kconfig to make it explicitly about
> per-VM attributes in anticipation of adding memory attributes support to
> guest_memfd, at which point it will be possible (and desirable) to have
> memory attributes without the per-VM support, even in x86.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


