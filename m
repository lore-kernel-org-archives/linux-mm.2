Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C3DC5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350976B0092; Mon, 10 Aug 2026 04:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327DF6B0093; Mon, 10 Aug 2026 04:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217386B0095; Mon, 10 Aug 2026 04:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB9DE6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:50:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81559A06E6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:50:38 +0000 (UTC)
X-FDA: 85084738956.07.208B855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2B45A0005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:50:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SM/P1WV3";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786351836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32eQ8RiOgQgeidQGipeTq06XdRmfmVmvwXXxzjSlN3U=;
	b=pwJuiqJJpuCmIJuElVyAXAXuVCnSrI9u5pQYXi4mpnWfYXRbqMz4Kt4H82iidz/kpyvtlJ
	Skz283N3M6573Uf0/+PTTWtWUvhI0dP49ZBJsTyS0lI3aQMOem6RRt+8oLREyodryWDrLB
	7TiI7zQD2W9qLMVv7yxdCV2ZuGL4qZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786351836;
	b=c/uI8Je8ZqHt4Pmw65vyIEBUYyb1oMimhw5aYAo88pu2izgbHliGrS21w0YBOiL/6o8Za2
	YGrVIzNy6/6Z7G1MSXLlFtYFH+pLMNiDnVIx+7NqwMMvwe7TGzUobc41koeSEF9EQlcCT3
	r2Vpgjo8aLxEgAkBbGidRXf5wpc8jZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SM/P1WV3";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68D74600B1;
	Mon, 10 Aug 2026 08:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0A61F000E9;
	Mon, 10 Aug 2026 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786351836;
	bh=32eQ8RiOgQgeidQGipeTq06XdRmfmVmvwXXxzjSlN3U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SM/P1WV3C8zFESyVbhdVq5tad57H8sCNhjQuEBVfNmdL/9KekwKyq+sy2MoeTRTxi
	 9gpyYY/u6fxNSmlnmF8Rya5V6q+sZLUqKRPSSFo+VlQsjpY7LPRgD0Z5uX8uZ+AXkn
	 PM1I7vhmhQF1dIp38+N3NBbQYh5+e3YRGbQhpwBZDmO9ocZbaRM9pSR9VW11aawym0
	 OJ4wRui0/fC3MBwTXbiS8O8O6upweVhhHwFpOz6/J65qL0+TSbE6L6+sm+A/19QBzU
	 Oa3z4YInY9KHU97DeC3zmT2SxcsSNTZ7WQYDCIwyrQWzqPdl8VOydPzwsdy2LQJcYl
	 rqpqifrHLwQ0w==
Message-ID: <c42c8146-4616-46ba-b46f-85746149e99a@kernel.org>
Date: Mon, 10 Aug 2026 10:50:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/41] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-8-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-8-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: x5fnhxwehajqsg1t955pznqd7tipd4it
X-Rspamd-Queue-Id: D2B45A0005
X-HE-Tag: 1786351836-287748
X-HE-Meta: U2FsdGVkX1/ZPXkHHehUBHims8SeJqhA/V+2SyAfUDgd+BNyADJsXddbC6XNlkzJnLwyqAKBZRWu0A/YL4/R6GRU8xgGo9JEkjNe96K47S2KzudO6HEczgpmK6BcxgtXdj0A3VVfMXj0oDZFtVKu3SHXJfoqC51ORwt2zu/byx5Zdgx+cpMs6G+XOmHkoxV7rXxIKRIw78yQgakXyEaoAgRG2bJjzXVa8zF8Ee0nJR8z8jXtSvej46sH+D3r11ABZESUSB+Gkw1vOJRZUIX2ikugPICeKRnyMZQJLItQKUqiWeM0YSE8OZ++Y6WzJXpXajDQg3AW1xfJgdD3jIf/X6pcyxm3BbfVAal7CNCrsrIkBgSIsAhNZ2NxE1zbcEcp8PJptvvTJFneaG/X7Y6UOjnMpq5mofrq+Ql2FUUoBb0Ys/1iB3v6fFKoontuFOD2znEhhFvLP81VowVN5sRtnlupvDKD7Ex2xjJxv3hR/kHt/E8/7VxDNwp0mFkOrjlFm4YJ1powkAY5Ze2M74T+i//aP/v0wgG9/AeEYuAxoOtE2tlp29tyvfppAdl/0HnPNgvu/t8mEiKo5Y/kba5OOO/cWTTmd9g6Udg/GnTW+o1/IavBn0W1iIpr6Hd8aTedJmDLj22lpKZUwoKbBLqOJVag8qedilFku+QS+2G7A1TkepNN5r+Jwi54xNMQIOvat478RKC1vIeh+y+oy6WyEEJIK63yZCzKv7qiLK4idKi1uYt3jSlvsTaUmAQKdRnH8NzkaqUs6dq56wdUGV88T+GhR0q1gZhml0ovtRoxvPPY7uQcHt1sHmx/C9n/ztkwK2fMTAlZC5H+gqCXFvQWrXpc635dODDzbfPg+usHpV/tb+1llYA0h1KEL+NcE6lqxWwLi1ylSOn64M7BVtpvRZape3UpPobpBozgyQuYiBpugima7rwPo5SoGYQlRScKXHLtRJSw90xv+9IpxdX
 d/KCze0t
 uiL3aIURiJnwDt4lcrpFh4xW/vwntrYJb6hzpgxkFBL58YTZyxSwNEs7re4D958Hs/6+7SIv2ptWEiwPrvGEZ5SOx4suQYjHto632o3q1mth7ulvcZtFjTJ/0lmA0SrdBxoT7XwtYC7u5qjyYBNHDHbrCnUD8mPisXkq99MZlj0ipnUQHXterY88UWh/4EPPV4NoWCeGX+XGm1lu+7GXMP5NYleH8ifo0jL9ay5YMF+cPF0y92OkQR5nytxFCdux42NEiSiSV8PSPtPfrkLkPyKGWv0BUJBCky9BFr/+YkeAah/ex+SutKRUbJqptCh1Jb95tPLWw1fCeGDv8oGByZxtLT9tzmy8+wPkybbhqHoIXnYwqNEH0rccerB0HkbGj2jMzHodgyaidNkfzr/fW4uRq1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
> definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
> and so that related code is clustered together.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

