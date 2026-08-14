Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D506C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858976B02E2; Thu, 13 Aug 2026 22:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809AB6B02E3; Thu, 13 Aug 2026 22:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8B56B02E4; Thu, 13 Aug 2026 22:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0D06B02E2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:30:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFE4A1C10B9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:30:40 +0000 (UTC)
X-FDA: 85098296640.21.211B376
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA36C20004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:30:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IzmhRSxC;
	spf=pass (imf31.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674638;
	b=n5LjcSlhILcq8Hrauyd4sn6QuT2E5s7Mzi1ZOF3D619U0K4APVbEBqicHzXTErqo0yYxJ8
	647rNzYss3c6n9PzhDJp+4iOB94DwAt5zUYcH+Xr87powG4zDzjps2NLMiWayPRPZoRFjH
	JwljZZInBUK3KOgCkXKgoypBykEmN60=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IzmhRSxC;
	spf=pass (imf31.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXz4/9GbKlHmtZw2HyECZY/KxZcYNRtyiGUv0Q21gLw=;
	b=Dy8gaNIy3NXxyl1RwyCiC/qKhBHY8MezFctn3Fu0TOLrMuv8k1TH1X+cSuh+gMPzt5iLmC
	zAJ3RWX3F1cvhn3FyQPxt5/bJRWtd+1754h+NbUv65E4n3WWi3wd1z6TIOieGUyPNvaLnt
	xvQJqJeR7oA8U48chL4d/bQpZ13HEUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786674637; x=1818210637;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e6EdqofycO1KcQ0vu4NOsmDsKE9B5d3of8XgzYF9JMw=;
  b=IzmhRSxChW6QHiKpcjNiT3D69yyuNn6FQ0NklhlUxDE9e1H8eiOz0X8U
   gIU/vHaXbwLxQk9jvyTePu3m2UyveBEV/qv+dfqJHxfjnl8NYskUbGQ+q
   Vhof2AfTFJIgsodV+txteGYXwQnpSc/2X+x1lS5SOMS0DPkzimyYEFWuI
   oJ4ervAx0KrAs8akArf8gDLvyHh3dznXYHv5ude/FX3E6FanTAjVeiWjZ
   MuHqQOMYT8zQxRBeh3rztH1xj4f9Uq0s3D1m/G0aef3LQDlkn3AkPWUKY
   WaQ0mlzKrveSfLj6MWqUSHuc3MkKfUhXLvtw61tJTE5IRhMnfoYI01cC2
   Q==;
X-CSE-ConnectionGUID: hA6K4aCMRMiPJy1jEJTmVg==
X-CSE-MsgGUID: rjXMM0c+T6GxoX7OvZ86Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="104788816"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="104788816"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 19:30:36 -0700
X-CSE-ConnectionGUID: nQfL49GxQ+C30MTsQCAqig==
X-CSE-MsgGUID: niK+s9aWSOSxaolKC/QZPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="264700152"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 19:30:24 -0700
Message-ID: <4862dd36-2f9a-4a7e-b9c8-e08e51e80b0a@linux.intel.com>
Date: Fri, 14 Aug 2026 10:30:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/41] KVM: guest_memfd: Return early if range already
 has requested attributes
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
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-13-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-13-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA36C20004
X-Stat-Signature: fogjejscadszsijqmmuahybhbdt1ipix
X-HE-Tag: 1786674637-864761
X-HE-Meta: U2FsdGVkX18zppWKyWcdFGdyoldiYR7toR68NdM04efRqhXQN3/wIEy7U54yUd1oP4b5O1tGVH7rPrfM7jEBrzuY7BeCN9S4I/89ylzDvNiI4SpUO2MG65qrm1WoBNR4MhxxEoPTiDwjqiHITO2za5FuUzeg2d0qQL0opq4G6LoGrv5HVfEd99C/0OtHo5RpGnRgQl+3Rnv/d6M+lDFco67JlH3aW3d7GH4n8WbXukAXmgxqUH0QuPPgrwLvs6jDgZVtPqB0BufR6P9umY1G5Qc2rO1Ko2E6CWa7DDcuryMQokIhQkqVTZ6m+miPzqv1pnpBQV/ih4tZ4DRUpkzZdfaeOjzwa1YSEUwygCZ9iq7tjGPk0qiEU/e1/h+ewv7o7M12PBzZHVnfDKYiLeX8ViJ9EwP7sRQB25FVzQy0cfkZCNkDlrPKOr2Mo5eysLET5s5An4v0uAKn3cAkyZ5tO4BI6cI91ynOFWmpr4RnpVrH5gvbN2CTcU8/638HOhX2ToWhNIGe+7O+2y5m8aUGkHLy79h8PqsAOo02zX+8eSSjOX3jzjejR8IaxFPh2yCKgOmp/ghv+aLtLDbqmdKuChyxfmdqhKTFhfcD3ZUyvojRNDiedN/IovaScUtKwfxtO2d1uOujaNQjBDEvulf6wWF1aPul4w9fw/NIMd0PYjKxTVYdsy8LcUurbBXDh2UI7DlGe8IsUvfPe/hh13dSwXqlKBF2SO6nIX6paHk5qZfBWTxBY3DGYQ1Kb3Zb0/EjAw/6KMu4rZABcTzn0Fe2ckfm3VDionK43SO9yH3cKSadbn+uAKx7AVrUmTiWPzteN3nhEmb5eBQkUV21WCjlgzbS7lnV453OU1khe+uKIu7W0v2ERJFIKkcGo4zI12vQ0ADsNImvpHJkjdlRXVzapwjXhWc/MxD3kajn4gCJopLMpiDig9zMlu31E2VyHzES8maV7YKq6opRa6eeJBF
 H53wKv+I
 UPjU27kjxzbZVfTKF8QYIDz0rgsRLrfRc2Jb/uUTUpZDJ/oxJnEU94U5t4PXmt0vYf3Dd9nnDhZ5q94YVm6+VxPrCcYUgdG7chfMbvkVAPY8QL+EnmKWslzvAAbKNwQbee7KTKA62tp2tqVkF1Vd/1wcNkPUF8KYYRFHT6cTmgkj1f1f9MCRyC6CCwrJ7acRrEoeN2CVg6wmg3DBny/mx/5pN913QHKfjk9eEKuVTYGIfOfYM1Y7Aq9HH9AtF6f/R0djWwu7omFBafS1IngNu69nWY1XwYu9zQwmY3Gf0buErTi4mQY26ol/Xxg+W2jjaZ75bsO8FQs8qyss/7nz7BO+uxIAOeFtRnChP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Provide function to check that a range has given attributes.
> 
> Optimize setting memory attributes by returning early if all pages in the
> requested range already has the requested attributes.

Nit:  has -> have

> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


