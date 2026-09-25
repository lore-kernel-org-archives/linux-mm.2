Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398B0C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD316B0099; Fri, 25 Sep 2026 15:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E5A6B009B; Fri, 25 Sep 2026 15:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274C36B009D; Fri, 25 Sep 2026 15:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 000B76B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:36:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67BE7406D5
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:36:56 +0000 (UTC)
X-FDA: 85253292432.23.6C381C9
Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	by imf01.hostedemail.com (Postfix) with ESMTP id 469CC40006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:36:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXFF22su;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790365014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4/lST7zD2Erdwe6/sNV3cFEsUbk898lwUHJrduDZXw=;
	b=TYQL69WYGBhWgL8+TUNo95x5E74lk++8krsqstLOb/6p35sKM2fEeuYFTADv7jV0wMptO/
	4B2pr1fkdByO8IHzHpFcWMk2SfKp3ipKFToFsiYVMqH7Ek4JpFi+1keA0zolnU3awC7C9x
	QhKzrBDefTYMAZ9YRAMgR4cZbQIShdk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXFF22su;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790365014;
	b=yyvVF+npj276QMV1RBcd9jRuIAQRNAfv+nv95pJvE1TWSghN3+ikJQ1WC4GWNqSqqz/cxB
	cv66fDY7aYrsEOCekX406VatGA9koErFL9gUvax9TSFHMUlbQMftEz4MxUPx5j9RWaTIhV
	wzHNa3vmdb1AKyfhxiHv6/pFOEIkhIY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M4/lST7zD2Erdwe6/sNV3cFEsUbk898lwUHJrduDZXw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790365012; v=1; x=1790969812;
 b=VXFF22sukklykt3cUSRvuT4kz/LqkM+UbDC67HTjRio2lWyy6fgve2LzsrwPa3zRWUwkUxNc
 51cJkWVz77angGhv+3RvLJUqlq8f+ZabcwGp3y7BCkoRi7o1OL4QvVCtu35K0O5WcCbeEybTHcS
 osoWF2lWk6lPH3EBvClLbhqU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9b23b1b9c141f10f;
	Fri, 25 Sep 2026 19:36:52 +0000
X-Mizu-Trace-ID: 9b23b1b9c141f10f
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 12:36:46 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbGo3QTYlUD5cVW@linux.dev>
References: <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 469CC40006
X-Stat-Signature: ysr18ziqzpcnxwqb11dpg4ha8cczkn8f
X-Rspam-User: 
X-HE-Tag: 1790365014-882620
X-HE-Meta: U2FsdGVkX18jpv1HjT3fXvXLLc2kj96+cm2XH8mrgXFI+93qnsgdTgdL/+3quBz06QXIDNru0P+oXk5hVEmUY0Wu22lm/yZhpz/bufWVvHcwcHfH87JNex3XVxTZUitIZoOQ+wVkmJAAvb7QYGtRSEZdVrM4G4INmMv8CMi/0YqkscgnsIMLZmcIexogRyQUx+VG/jql1LYoM+oFZ20Lzh8DZTp7dCdGI/j9uutctJsnCns+BFNpc/ivPmL3TUmgGF+U48zK140kWPrGqsUjHxbjGvv3jldTtDDVh/65pFiTXR1lqlEi4YjawQTJ4EEYN1kdBqY7bXMtMQxeB7zu9ErsVxDtQJDgJhzLLn6HVOvkYTWZiSD7jeu5wMmEeqFa0jekj8kqpACf2gPj2JnHMLOtIhvvG6vDwxtJLztQMX9v79KuJfQPAfCYn9S+9gPIs6PKJa2XUYQiPQoGK2/num4C6ellpFwaPHBYnT9VI+Zl92BZ9IRZLzNf8f2H3FuY9glCbGj3NxIczRmQQK5KJdaNaGrZfMqcZvi92HhFbbC87O9cCvYiq8y2DjY07GE98da4Fci/QPwQHK8v9M2jvSuM2EShlMrJns1naheP7peHBqs+0+ld/EiiuhTf92pK9BuyjvcFHpNmQ5hfICqSLVD+kT/zUa9bQUcP927O6aHWYT5bXMZpc4XATYy9v5HlQxnFQZorGlbd61DFH+ifPbaVfmRMJ91EyPqmKxSo7P+M9jWuZJShgOfk9Kc1prCo1x4AU3AQABkOdclox9eLGz9L7Vj8umL2wzvHC5kLSn9eIgbRO/BsUYt42k198zpIgDzzx2pNakWsy8K3ryM9e6s/j1WbfL8q5IStRe3ZTHS4Ng/ARAsJY2EfkLrCebonxzuOu1zu+52WjWhprUxyuIPcASUDY6Jfm17AeOI0hz7WlJSDVdkdo5JwwUpiXa1y+cM1FX0nfs2sBM71Ufx
 Ndfn0Qd/
 TV8vKJTyIg+giaduI1uACv90YSBLQajNtXua/ffmx8+6eEf/eaY63uv/JH5nFE6xQ7tIGL0KK0VtFRFgOG+KAtqLBXvuCA5DWvCG5HyAj+wHFEFnqkwxDqbOVE5qPO+GRE7D+2iFeL72Oxbsyafa3FeQMc1BGq3it6Bg3J5rQJdfl0UGot8nDICYagyaRErpHg0J2+Bpz+nI0vRi7UDcFn992BLMmdefHO1yqABjvyZU/JCOUM1/hFaewxd1XdIq2ZdNKzl34plWP+M7bop5qBfJwPNKZ6kjqjefZypzoL201fYyJC9oxDCf9rF/TGUif1rvZF3/3dgNdxQH2CtqtZlApSX8b/mH4mZ24SDJIfQ2aCvq+wqvqXQwPihHF5dFYhxyer7pbrvMgxATi+KN1V1Auzv75e4y0xvIxsBsdXVQ+xK8P2zFSpi7Dag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
[...]

Thanks Kairui for very clear description of what you want and looking for.
After reading your email, I think you want memsw support in v2. Currently you
somehow are implementing memsw using memory.current and memory.swap.current.
(I am assuming you need to subtract swapcache to avoid double counting.)
To conclude, you want to use vswap (the aim is it to default) but you still want
your way to implementing memsw keep working.

Please correct me if I missed something.

I am wondering if you really want memsw, why not propose memsw. Someone from
tencent proposed memsw [1] previously, so why not continue that effort? I am
pretty sure folks from Google (people who actually work on prodkernel there)
will be happy to collaborate with you on that.

[1] https://lore.kernel.org/20250319064148.774406-1-jingxiangzeng.cas@gmail.com/

Setting aside the memsw conversation, I think we should go back to the actual
vswap conversation and list down what we agree on and where we still need
discussion and decision. (I will take a stab at it and start a separate thread
but still on this email and will use AI for the summary.)


