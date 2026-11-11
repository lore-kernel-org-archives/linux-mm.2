Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55859606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cii2UW+7
Received: by kanga.kvack.org (Postfix)
	id 6B9D46B05F9; Wed, 11 Nov 2026 18:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A9D6B05FB; Wed, 11 Nov 2026 18:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5589F6B05FC; Wed, 11 Nov 2026 18:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D13B6B05F9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:38:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98E6F1203A9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:38:48 +0000 (UTC)
X-FDA: 85424455536.06.7D3CA2B
Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1970120006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:38:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cii2UW+7;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794440326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBtMya5JHiIoe+mvC9LpyA8nsmCcAGgftQwnt4hAqeI=;
	b=H0ref9jiNi1kibmVK5qiY7thMWBCBtPahojxtiWxdtGlpBHMnEU20fF+nVow5iLqtoO/m9
	RZbtaBk1KebfBsCjfXM4praxJryEmnUfo85baLS3DtRECAhNB7u0QAQ+sL3Tuo/SSDKkqL
	vIG0atFEY2y8cXsTrh1aMXZKSSp5Mx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cii2UW+7;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794440326;
	b=LmCbuFmrvvBtQowapPLX1/jdZoleFwcPHDCPSOUhhXASVzYPFuDZbURTbfw53DtLAxzvYH
	vpaiXcl2A5h7bZL7CafkdbLCZEjGEbAg3zehc7Eam2VtKUM2HC5O3JKtkQPsFBa835rx2I
	aRdh3kDX0Popgq3/4ZRBVyAjkH9XySw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n4XGoevqqrbLPiJf0WVzjodKBgKSfEnOAs+PZZo3dNg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794440321; v=1; x=1795045121;
 b=cii2UW+7VcxrIVAWlCPVxc2A7k2LTA3p/TddiEUWVZc4+BUMo6mGN2irt4FP7mJoecm0BhLU
 yTLvkBYJJl7IaDDKdMTfb8bnEE4craruu464TSTbjJiZTaWR8fiCHC2lC4dM1J2JKz+ahIVeFrz
 zfvhBY1EHDqzCn2idFHrM/VI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7a6aef2bc15d97d;
	Wed, 11 Nov 2026 23:38:41 +0000
X-Mizu-Trace-ID: b7a6aef2bc15d97d
X-Migadu-Flow: FLOW_OUT
Message-ID: <9b795d3a-1818-4265-a364-58fba139c651@linux.dev>
Date: Wed, 11 Nov 2026 23:38:39 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4k36sjgaazfcnbpaym6s8exn9zb6bztf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: F1970120006
X-HE-Tag: 1794440324-152418
X-HE-Meta: U2FsdGVkX18KhcaxWtQTZ1BxjScfTDcMXLP6GtaWbvYTp1je5GfW26JqNmPbll0Rw3n1SbGJPtqG1y/64VYz5ktjZAm6qUfn3ZPGwmyAPpP9bI/CyHWfd4Y/mZ3g7VrFyuqfTpvIceMf/d0UH65ANOQgwcRDo6FYMlNXZBozh2wKJNwh6VYsC4gwceuEEKFaxl1SSrfsBs0NHNN+lzJoKMOyLv3peEJeOu1K/3uIEv0OHXO6IzxQez9Lk3GAWeKllRW85Qxd6G03e6nA/rzpD8K3EB3wtOH1y9IGUinz9H2YR5+7YlgQ7X/bkl8umWKJj7aj5GkXe6XXl5HSDA6lbRQbv0ivxyKV61CR6u/ZdPo+FGIy6FKL7dnEqEheZ1/c/63T5JKZDEl15AIKf1gJ1cy02jCIfJ1clVzh31EIIRNBkbJzZnVe3UnZnZoA05g4LqmWXZmrTV2qBAA69r7HEpIYsTaYtOaMIUNfZp74tSCrTY5TOu4+BROhZXvEEJoq18eA9Ppf+I56DU/aq28YD4naGImj/iBTlCYuodykhcqhHi2Oe29uJLNTn2iVspdLiXfay+WOqU9SxJxjISjQKgG2EJpBOLdlwkAEK/pzvwpga5dSMcjlJNjQ8KgT2mg6Xc/lFcPz88Li6XUUMv7uxXh/F/pvuziLqubB64zl09KAvzmILvSgU10cY83p+xh0ZhTACv7AqDcfc+8qlmBducGlZyOq1eV0pVjtFvJFdoWk2tvsZF0rVQP5X2qbqbgc45J4j1Ub3conlttfm5OshHKlt+5Mqbn34tUCHri9x6U0+xloq0qijtqLPY6Wr4KYfpYD1ru0ZvNdgUWUqCHN0HJ3fhh8XzLOZJBYMvqPyoNMP9zS+610J1HFTxjCHQTc2FpxcLEaVaXCUah6U59tM9ZVCtFJusdgs9Y0gfxc80N+KePBCgexxMhf7pX3NdhkhTHkVT0ToX5dNe6v829
 Y/0fc8fY
 CGsY9pTMgl8Y4jKOyK6G4SGrqmRdEKb8enRJwqBDOXpSe0dGCZR3o6WjtnQNKyCqqfGYf4wlzov1+5UNw56aT25w7gqB7VI5SpMFvR0WqdKQHbYgwfwygHwmD/TXbo+VYnGJWsMpiNvdAO2S5h1g266FZVBjqg9ZwZ+2/PYFQjhS4y93kxEuPsVFiW4HIGsoEcN1Ewno/PxAn2hB3L7cNps18M92NO32vnm0q1HwZBTIXeeGqsatrorbiwUOc6YiHmk1jcA7RiGQI3hQlO5tsPGRxAB/vpWA5i4zWToRkSIRaof/YGrwi3Ei2dvqQNeOW8LMpiCa7TdrRANxCDNH5KYiIFnaVtIT3Yg8q4tq821gpmx9PU6rsHMDT7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/2026 18:13, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> cachestat() can leave cached pages out of its counts. This happens if
> the entry that the call has just counted is replaced by a larger folio
> that starts in the same XArray slot.
> 
> The issue is that filemap_cachestat() walks the page cache under the RCU
> read lock, so racing concurrent collapse/split is possible.
> 
> Thus, an entry can be replaced immediately after the walk has returned
> it. When that happens, the next xas_find() skips the sibling entries that
> point to the slot of that entry, since ordinarily they belong to that
> entry.
> 
> However a concurrent collapse_file() or __filemap_add_folio() (when
> replacing a shadow entry) can store a larger folio in the slot, in which
> case the sibling entries belong to the new folio and the walk still skips
> them.
> 
> Consider:
> 
>     cachestat                         collapse
>     =========                         ========
>     count a 64-page folio in slot 8
>                                       store a 512-page folio in slot 8,
>                                       with sibling entries in slots 9-15
>     xas_find() starts at slot 8
>     and skips slots 9-15
>       /* 448 pages are never counted */
> 
> Also consider:
> 
>     filemap_cachestat()                  __filemap_add_folio()
>     ===================                  =====================
>     counts the shadow entry in slot 0
>                                          slot 0: a folio of 32 pages
>                                          slots 1-31: siblings of slot 0
>     xas_find() skips slots 1-31
>       /* 31 pages are never counted */
> 
> Essentially the fact that large folios might be present means we cannot
> safely continue the XArray walk, and must reset the iterator each time.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/filemap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 7c05e4fad081..c4e82891767b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4731,10 +4731,11 @@ static void filemap_cachestat(struct address_space *mapping,
>  		if (folio_last_index >= last_index)
>  			break;
>  
> -		if (need_resched()) {
> -			xas_set(&xas, curr_index);
> +		/* Collapse or new folio spanning shadow entries needs reset. */
> +		xas_set(&xas, curr_index);
> +

I imagine this will be a performance hit for the call, as each entry now
needs a traversal from the xarray root. Might be good to callout in commit
message. But is the right thing to do.

Acked-by: Usama Arif <usama.arif@linux.dev>


> +		if (need_resched())
>  			cond_resched_rcu();
> -		}
>  	}
>  	rcu_read_unlock();
>  }
> 


