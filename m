Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFD9C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232966B0088; Wed,  2 Sep 2026 02:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4316B0095; Wed,  2 Sep 2026 02:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6516B0096; Wed,  2 Sep 2026 02:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD82A6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:02:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D337C075D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:02:55 +0000 (UTC)
X-FDA: 85167778710.27.00B8ACF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7AAC020008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:02:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OTgc45WK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+G6/ZOaxQqaNbOk+5yKUaLF+YU8QdZBaGMZaCoWZt30=;
	b=YFLqwfhvf9Y94xs+etdwrFRaJBPymAI9ougyhbznepuNpo6uT6K50ZL7HhoV0poRXs/OmS
	3yMHXsBrmotfXt0ao9V3YSL23VWm+1AatwKAJ1hBs5p1rLy0oCkndllnhKA2jDY0low5PW
	Bev31AQC/7R5IeK7nLjQC5kUzPoQGI0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OTgc45WK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328973;
	b=gF95RlEfuMi9i5kMy4L/afKYdGWVpBQnZXv5WL68dvEcW6FO6Scdjur0wIJ2E3F+HvlnwG
	17N1PrNdW/itDjR5rdBqkW/9Kmu7ODjAsmUVpJoL5+9VpuOas4c7ZFnLLFqT1+X7hy9PEX
	FYDPBW2q/wSbNstBZYDAeZRSxZr9pQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788328973; x=1819864973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZsQIcqiHQLyH2DKVUpBoYLA6XTARs4g/JsX3IormNF8=;
  b=OTgc45WKYYgU2gyAZlGaQEk1kcOvQ2Asd2vrlIlH+GPGsiTSY5DI7IkF
   POrr224MKsDxclDbCYMdMK3YUcyBauHNSU0pvM3tSe5xpvBH7fOwZJxww
   wjfOQIFlnJH+7JxNSzJqSKQ1xa65UuCU8/UT7oh9kdNaq5Yx7QOm8uSrt
   p74IRUZIUbtz9Mw/58G0iX4a8M05H1jkPnrctgst2fvTkJBTtsy0Mh+6g
   13B9BDyfJb+DF/RGtd83bHHBRnnU7ipxFSeS+iNK9B29Q7QRz2snpeeJs
   0YS6cmJpJ+JzhDHFC7f6HcPdp3vb217R0IIropmMSYOrJcPJD869IQN2R
   A==;
X-CSE-ConnectionGUID: h3O8RaYTQEOV3TQVGk7PtA==
X-CSE-MsgGUID: Up1ChkWZQ9+41YbaejfltQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="99373029"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="99373029"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 23:02:51 -0700
X-CSE-ConnectionGUID: ZHqX8Es0SsC3RVfgs1tTNg==
X-CSE-MsgGUID: waXhBzDUS2CbO17ipdXqoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="269881790"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 23:02:36 -0700
Message-ID: <64acdf25-de17-42fc-a51c-726485f2b9fb@linux.intel.com>
Date: Wed, 2 Sep 2026 14:02:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 13/45] KVM: guest_memfd: Pass mapping type filter to
 invalidation helper
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
 <20260830-gmem-inplace-conversion-v12-13-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-13-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AAC020008
X-Stat-Signature: rcb3kaiw3whqosqmxjprd56kbwsuc5gj
X-Rspam-User: 
X-HE-Tag: 1788328972-626352
X-HE-Meta: U2FsdGVkX19zoI82lek/3OzeaJANJIUb4/21smglyb9p2G3nZdoU9r6wWnoN+g7DeSSpU5p9YmFxdGHbC00VCQORuQgWynSOoFPTNxuHudtTCqdTdxwnL3mDEluWnDH3H+TTjNsRaxcYNqjBz2CeezD2Do6jKATviD1tFJgRV/Mvo0qyZSqCjIM/xBibfRmiizFEo6tQiajjh0z1e5KWI+d+oP6Xe0M01nIE1AHlbp6SPBHJGO7j+VmFOdrKwG6C5wIoSPZ7zSAUOjIv7X/y34po6vsYsktstBXth4KfJCd0TBGrM9fMJnGiXCeQ7nGWwpbrXsQQo4zgzDAgtvUgR/mwG3HSPngZv/3pWfvomHwzzmA+bvCT3k4QZLyOM5wvO7hWCbHmGMIKB6eKt1MCxiPrigxoyN+KBgFX7jtsUi6+Gf5J+a4CFKjB75kdyueghX8zA+o8pKi2R+9WQpbvOnPM4c8bqHeJePHuCUCzAiLORD3Xlz4IW6onmlbLglCi+ONSz7a2QjmBBMfPyJQxNSU9iKgEYAEil81YwWIqphzIfYjDZG0CRIF9MJnno4poHAIRSogS+XKrif3J8it3raau6Sjg42Hz3kkZw+ou0h3WOQWfi9skH7gvCm2Is53+slY56P9KS5dedx9kQFiC1RFugs1h14OPHcY6TX2z/WI9X0NrSKYhyDo9WWhrGfx6d1dentyKCJvfCH8stsULCWzaw2SCE3iHNj+BCkWOY/jFY7PmkTUsja/DXmRzJyoXdnGGCHNebnLDiJgRcGfu2Gv1Wgf6C2Jf+aD3A1PKI0Ed7haBb+wcQUTU0Q53iBxaoAt9R7aaeyoMOzCCz0TP/+1srBBW4rfq0TB/UuOo4hVOhF9VodwZWHa9eoCl5F2i09UOsamuZxEhBh4dNPwNXxaWsihpGQuDTa8Hu4MxNNHhkDmwt9ZJVeozKHC1psulxQYbpk02VbG4P7XUFfC
 /bM9566q
 bJa8GhSVyW91hQ3+bV2jy7cZYaQIcT/qGyUzaCpVY3fd8Hep8Wh/6zl2w3KqOqW5dPP7vmrlbXOx1Ob/9Sq7vQ0OrGeXlo+AWX1+nSikK9w835u4XOmC7/1Pm2IZpU9I/HCDIluyb9rxdrYpN5iFfdz4Vkq1rLSwaxQBGmZXH3bN/k+WEeqf0Y4Zk33jNr3v4xYoH5SdP8x+ncDUMSacY4FjDlGUzfHEXGYFcr/mL3JofULOSQMw4enaibJaFDpJpoGwOAQYhzQTqxbwG3+VBaicJEcfz89VYdBQ6B/ws4RwMKBGF3c1ydWUAl3XiSV6unAYEMh/vTajFXbu+2Hd58eKi7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Accept the mapping type filter as a parameter in the invalidation start
> helper instead of querying it internally. This allows callers to specify
> which mappings (shared, private, or both) should be invalidated.
> 
> In the next patch, the conversion process will use this new parameter to
> invalidate mappings only when they're different from the target state of
> the conversion, i.e. invalidate only shared mappings on a shared to private
> conversion and not both.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

