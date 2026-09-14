Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8117C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DCC6B0088; Mon, 14 Sep 2026 09:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675D36B008C; Mon, 14 Sep 2026 09:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562EB6B0092; Mon, 14 Sep 2026 09:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3526B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:11:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE0EE1C02DA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:11:27 +0000 (UTC)
X-FDA: 85212404214.05.F24649B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F11E3100007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:11:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJKJt+kI;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391486;
	b=WLCUYqF9WfuNgtsBrU+AqJWzq2UhjS2Qs2SwG+H5Ut7rzKIFjDrZwdgx34j7NhwpNfVGqi
	kk7vLAVKWk5yxauOd1Yqi9o6Mx82rZkiHeVc9iXKEZv8xWFVxTcrW5UgAT6MK3urLBojeq
	YZWxq9amtL+kPB2+aDVOv5fpais3+fs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJKJt+kI;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMEr8VxikyVfU6qvEUZWpmfPP3XV/5sFL4uxF81JxCA=;
	b=WU/lqLI9Ez4K/zn5/p5OlvLzfxe17uKyvwHmuLMPrR/GUo8AHPpz13pbLC89rwdwEETXV3
	/ND6yoP/JJAOpPDjaoj4rTeu+X/WfmzUxLjaQSvx6jE4H+F2XZ33A6EVCtUAQlec1FCZ0u
	BptDlo/JKSeXz2QBYrUGlKB22aX2p60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A94E40332;
	Mon, 14 Sep 2026 13:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F6B1F000FF;
	Mon, 14 Sep 2026 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391484;
	bh=HMEr8VxikyVfU6qvEUZWpmfPP3XV/5sFL4uxF81JxCA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CJKJt+kIe+hjf+CMIokL8p95jJbZP9ztsmmxzZVo1NFVjWTN+jeWfJ8gkpM0krJT8
	 Utjnt2XRl1o23z+XgGILQt1K7qKpVap9QKwfAQ3Pbw7Nb1qdciasZLG+bCxX6W8crk
	 mB6ySTVDkFOyHlizGE9wPiKXzd5ZoeQzUUHq4GK3Az9uzbVLKJs+jLvaWj//Z7s9yJ
	 26BLl4l4JsAZDlTiLo0F5mBC0VkJP+XRzFeBS+pwUeA7vgq+fA4Y2VALNJVCMnpA9v
	 1Oa2VfL25A9Rb97s1Afe8qFm5GadjQrDawLd5iUENfXkRUR76/6j5S6iZTu65TIRWr
	 3oGpW4Ax822zA==
Message-ID: <066c3b3b-e5a7-4cbb-b077-26c78cfc07ac@kernel.org>
Date: Mon, 14 Sep 2026 15:10:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/16] Remove PG_private by using page/folio->private
 checks instead
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fscrypt@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Tal Zussman <tz2294@columbia.edu>, Gao Xiang <xiang@kernel.org>,
 Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-trace-kernel@vger.kernel.org,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 linux-nfs@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 ceph-devel@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>,
 Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <aqd2N1J3ui1llWWG@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aqd2N1J3ui1llWWG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F11E3100007
X-Rspam-User: 
X-Stat-Signature: 9aygozeb3jqzbqimctc6tkz57xzw9mp8
X-HE-Tag: 1789391485-374260
X-HE-Meta: U2FsdGVkX1/6+3/jnraiA7ACz8QV53qTw0p9ZyoBY+RBMus9JxjZwnBwrNQyQi2yF9B5bixHt//xXZ57lhXi26Fbbad4HlfFcTywNfivWMY+eu+1Q7nqA5mDw1rmGi+5VDKa/r4yHZFnDh6dapj3WClLlQbb1NhnrkOjMZ71bkVGg/oWUVHF6trs9q374Ibk6SjZiYI6TaSceu8s6B6/iTlHZvukpvABfmQ+z8aw3f94HQQsa/lS1eChSfdFD3Xjy6TEUo0FKFYQRM2RlYEQZ02fGUBd+ANd1fB4mPqyi2CS4pgdx5fc77Bs4d9gzl1tqYXX0EDxuRPv0lpyqYKHPo+JC7TVlM8gz1hOVIakxIHfKkrpu8NSH/p1ZOePnJD1SbBGCfplXVKLBQXVVUQ7VKdtXnjLfKEpFC/SPdKPuVLyDP4JatwR/3ZkrmqLo6AHF+5xPrwFhjiOTkbk3D/pUWw2snNYYoHPNd1IntvK1yZ7NNg4d+2n2dDxC2Trl9U1Eo2uVHPRVzja8iVwZ58nc1Qrj23vp/7DyIY9dzBFhpoX4vGQ8jzKVyS7FiBjvWlttSa2ny0AlYZoMGaBEPXsEiz+xgEGXadYbe4z4epXRSZgntyZB1CrCV1whr2mHnNFgLOJp0Fvha3pK1rFgcuA2rbaJ/tRHjmfkMDU7/QnEc8zGt0aLJtz60O45eiZatuc+EX8Jmy4K+Y16ivJ2sV4DAfgKICJZayiVr+lnYcrzCY4lgyVFG/XStDAqvaTCFsnEqgxtG7uKca9KAkH3sB8mmnhd4DlLTRCePajE1qBV2EWQA5HcTXeQSfjNIxMUN0VJzXYQ3NH+oB6lgtpptx6ATvs3mFz7Q5xM//xw2zk051HIHFcInvCNqUBCFWYsE7XH/bJg9r2U32iUWKBCeOMlwUxiwuD1GdO7X5tNDe7IU8VQBfuSyS5YM1ZuyD0Idd+izon1BCl0KN1dJZE7Zf
 PhSHl2Hu
 ZATqSAciSFRN2zwLHwIAPoW+9trFZAnBei5qi+2zMUxA4gUfVDLZwLvEsjTECG7b++1ro47NHn5WcxcqcHlqN7q4OL8N+WnkNbYhSQmwyfHP2wW/4cSRmM0ekPX7FWQu+SybbmX0rIXHxqqdweHajgj5EyNL6/WZs6pevWOhzBFSR/EwsBzixt+7oxm7c9gbyg60eBoKGgLD2t2c6nH6Cg6X3ranRP+0fWcARMC+knE+RTPsGYRtGOpqasZnfBqkjzROLb7JPQ3z5PUY2igJXKoqoP+wN8nJxyej4ymlu0v1oxwZ/RS+190LSFDtlzsdgeJG7UP9CPuEVg5oRzReik8b2cVYKhDe349YSFEdh9NeOCtn53fpd2jWcunyFzfzx4K1AJjmNy+nCESlUqxjpxTYqw4IlRxWAlGvwjBNKMdIicBuHuugwitu+4jc8Bz0Deno8KgviUfsw7oob3zrzoMKYRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 06:21, Matthew Wilcox wrote:
> On Sun, Sep 13, 2026 at 10:23:58PM -0400, Zi Yan wrote:
>>       md/md-bitmap: replace PagePrivate() with page_private()
>>       buffer: replace page_buffer() with page_private() and delete it
> 
> Sorry, looks like I screwed up git send-email usage.  I'm proposing
> replacing these two patches wth the three I sent.

For everybody CCed wondering "which patches":

https://lore.kernel.org/r/20260914041830.2072626-1-willy@infradead.org
https://lore.kernel.org/r/20260914041830.2072626-2-willy@infradead.org
https://lore.kernel.org/r/20260914041830.2072626-3-willy@infradead.org

-- 
Cheers,

David

