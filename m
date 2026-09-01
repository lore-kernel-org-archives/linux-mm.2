Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B098C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220256B0104; Tue,  1 Sep 2026 05:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8C76B0106; Tue,  1 Sep 2026 05:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A9B6B0107; Tue,  1 Sep 2026 05:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC74F6B0104
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:13:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BED8120293
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:26 +0000 (UTC)
X-FDA: 85164630012.22.18E9C79
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79166120004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AFSK0xwO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788254004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7aX4rgBeA1eOu9xDDLkRzZv35ZNUEa/k90j/kqoYLs=;
	b=yR/EzKwgVxe7LF2wvopE2DGXnlUMZuPXbby1/GPJyN7/PXlokNqiOfxcDZ4e+fkfaZQL3S
	2uUXl/GLcnYh7VmzKkkzlVWmzrdQBgok8KHowwNWo/H/2Bcxo0o574hYFLmZZT9sFejhUC
	7f8lj/3ewzIuLZTdJsUk5CpdkTU38/w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AFSK0xwO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788254004;
	b=uM+dbrBThShDK6Qfy5gW73PkC+8hjeXZNLmJzJkgdT8FWF0EUoSJXZgMZrn8yfjHv43ngQ
	nsYWE9lM2q5pv/Odr8fgg2BsCl0Mc4zPP3Q8XNPaLZrYpASOlRbSNd8Dx2ay1DMj5rieAn
	eQoq5s9BHxI85c77hXIhMisjFvoFYSo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788254004; x=1819790004;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pd1acZ0l+zUOeZobkaoqxgpVJGbI2mEIMZ+5P/Tso5Q=;
  b=AFSK0xwOShJaRGFmZj0eX5IUmzoDmktPPfiOJXn3pxGvfB9x75oQU8Pm
   rESmtmi00vHkN5zzYwMLi3CMG9yMJrXeE26yjdM1Wo7EV9IFrv3RlX6fh
   6rTt0naxyvQzcH812kBF4pZxjrOngRpT+iGvF6qnnmO895dp5VuQ8JBK3
   kLykgi8wCRfdCaaahfmGOzrdgefJois/PQTzjK5eL7Bqwvt+cDYrqKto8
   Gpw9vZcSIRZblxH16GbywZPivoArkblDbSwqxEDmusEMBccf9IvxHnVBp
   zcr/TqhRjbiSYV44bJ9krxBlcaNBywlDG0s27vrZVLApnxgvNOiUX+4ym
   w==;
X-CSE-ConnectionGUID: H+g3EU67SOK0HNiViIrN1A==
X-CSE-MsgGUID: g9pOdlD9QymiYSG75xyd+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="88603761"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="88603761"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:13:22 -0700
X-CSE-ConnectionGUID: 2eKjT+udSB6mMZPX1dBpZA==
X-CSE-MsgGUID: y9fKTNKyTUOUmNAApqtZXQ==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:13:06 -0700
Message-ID: <a11190b1-908f-48a0-9f75-1d4472b2007e@linux.intel.com>
Date: Tue, 1 Sep 2026 17:13:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/45] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ncn6jemkairkzo3gf7qpu8nrptajsmts
X-Rspamd-Queue-Id: 79166120004
X-HE-Tag: 1788254003-12581
X-HE-Meta: U2FsdGVkX1+3NiwkYEZkUQfDUfsgGgRSnPIer9AqVrDk5pzxtk3N0g861bLYRudkV7CCBN+xvi64s7hug0zLxvhLkqbIZf0vqal8NuZmwzHJi3kYCFF31D8RHQUuqgUJMHquh2ZBcElJ772ubTGgb7NAVfOAqR3PouLKRLo/ZSMQ+S4l0MVriSDYxK/E2UNfnE5xu/5PvNMEMlqEwsCKWVvp/zPfeLKgddRLrDfY9wMsgq71az93BzLNN3lmhuNKRe38m/J++VN8JQ89RP0tLjvr4FZ10avSh3tUIjqwRRMMandA/iftsTFUeSVrafY605xuZAshIUHYKmfr+AswdI4Y0LhzPlq/lohgM80XYdiV0iI1RYAK/vvHam4ajIVd4ZMUrXlb7Ai08Sc4g3v6Ff20BZyMP9qXxg6SeM7QsELIGcSfjv+EeMVrJkoyQqAqBLHzE4Sv6e15t/fKwQ22X1JCRRXW2SxzafWCyRKuZrwPA5c6PmSqJD9Ic7XetTfCXHO3WJ2iL+JUYttgF2aWvJ7GPnKYWckmS/rbkhVvHo70ra6EVO7EDuY/llswFtLQ5ij9kc9dAcnn/rtB12veUWa0oBIED5HiGJ8O96TEGL4ZzIFOGhIEPwTkaAFLtX2qHMty7yzNy+LKqH8Hps0ntG7cLBCVLxMcD9C2Lpse7Y/eXxIEmIEi0vWTfdiivxSZd8I3jvgHkRuGt5nWcyDrhwVUrZKoenPLZmsONGwRVJo+nnlKkmB9+Q5ApX49zQnaQtJF4Y9NC5KwPKufcGDIdQVjw8z3sr+fCCi09hxViXy5OUyUWhqKcw68zqSm0+1V8YUC7ByvwPUFN3DooHja9++Rd+AIsZvuQjbE7SNJZXcmSd2NoJ9hRK0Fh7demsAwTEZbQ73DkHmoboq/XFfzygNRQ1kFJVi5dqrmEUI4DUXwIe4FdqZ5CUs3hCsmwHZJmvasYdUJdNTytHDp0BQ
 GLmeCrCc
 ni+4vTIODLDbqkSofofs/KTDJhB8QhTBG0uZRV+7ubnENb1FJKXPMx274dO7Mz84xsTM6oGhxQigTkeNLrx5YiGAFzMlNVOgqt3h2/c0NsXsGB7ynKZ2qYevaNlsT7ePS/7PvvCtmJ3veBLW4HAbzu9L9bsfPC/GoZZWyv1SNUUosXCpgq1f8UaSWNXwLJ3nQa+GWMGKhg8JQqLdxSjzUuWulikrR/NtZIoo66ojujQJGNbT4iTcRvruyHDHaCkqxX2Hl+rX5p2H7WeLQsqHuGBdFW2U+dSBjUyxnkJDTRv/4dUWTh976dGxnhkLmNgRV8deyCTFGg4oC4tLIjDFtbKMMoFrwj8mSIpkSzcAeuNTwiHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
> of arch hooks related to converting memory between private and shared, as
> only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
> pure overhead for TDX).  At this exact moment, the overhead is negligible,
> but that will change when in-place conversion comes along, at which point
> to-shared conversions will "need" to find all affected folios prior to
> calling into arch code.  In quotes because very technically that work could
> be pushed to arch code, but that would bleed guest_memfd details into arch
> code and would be far worse than adding yet another kvm_arch_has... hook.
> 
> Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
> rely on dead-code elimination to eliminate the call to non-existent code
> when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.
> 
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

