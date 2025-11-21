Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81698CFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91836B002B; Fri, 21 Nov 2025 13:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D413F6B0092; Fri, 21 Nov 2025 13:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30336B0096; Fri, 21 Nov 2025 13:51:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD3896B002B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:51:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20BDDC06D1
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:51:37 +0000 (UTC)
X-FDA: 84135507834.24.87C4823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 41D364000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:51:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mqq83c+A;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSC4Tuzk/QvFtyvNAKy1hIk+wj35F/yk9kT4/VXch6U=;
	b=hnj84pqgCrjrA8G6YNHDyOuMS0cMfRlB/Vc8aPaH5r2adj0l1Qe1f871rXRlVbhh6aByhS
	quhRk5i5z4y9x9HHIW2RO1VqhYZzM0jlsjoO8LnTLyhJJWgQbk1RvxeX+Aq+LirYwakmJq
	2GNZVa7NRPg/EQTeaN2xKwgAbZh6IRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751095; a=rsa-sha256;
	cv=none;
	b=l7S/s+udooD3XXOAwKyeblBBwjAv0EuJmZU+m7IXfmgHz+ildda6BlBeHBzUfMD75lKuBQ
	t+oN8o3E/Dqt3MzwgCuh83YbjmY3S1qBtXaIF4uRyytu2Pcw23PAQQ6dDkHhXMJsz/zOI1
	E+1QAHACFjfs6nbWl4i3Jpuf2u/Z8GY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mqq83c+A;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE4B644304;
	Fri, 21 Nov 2025 18:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8378DC4CEF1;
	Fri, 21 Nov 2025 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763751093;
	bh=d2GokLH9Jn7Ay35MXv4HSVUXdJS/fnCjmcIwOcL9BgA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Mqq83c+AcV3bkcoekyHmiQP/DqqYSLvxbz5l/EP7TMtFKSF7Y1Dfuq6nLL5ZCwD7I
	 Z4Y7RhDpT3IL2ZJF3wsSy+RVz56gobTC3n8MTAfklAdDkzaGyJupYGWQUMDvbJM1Wr
	 m3urCQ1obcfSRU4B9FjtR5fbCIr1Z4wBKfqeREiQ=
Date: Fri, 21 Nov 2025 10:51:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Peter Xu
 <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Kees
 Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn
 <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Pedro
 Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: introduce VMA flags bitmap type
Message-Id: <20251121105131.1dea1fbd744587b433390116@linux-foundation.org>
In-Reply-To: <c82d75d1-5795-4401-92f8-58df6ac8dbd3@lucifer.local>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
	<195625e7d1a8ff9156cb9bb294eb128b6a4e9294.1763126447.git.lorenzo.stoakes@oracle.com>
	<c82d75d1-5795-4401-92f8-58df6ac8dbd3@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41D364000F
X-Stat-Signature: a1kmrnr33a94tfxd1rkhaf84ti5rjr6u
X-Rspam-User: 
X-HE-Tag: 1763751095-10024
X-HE-Meta: U2FsdGVkX18v0wGdeojNb2e68d+EKMInYXHmv8u1Q511qWIeQ12753fl4k5FFhMd9jew/GcDmm9lQeM0nKbNCTZ+8gYzax4G4qEv8vwJ2TKAwcrCiuG1fyBV3tnIjFDck1SvCed5dMUX34eZ8redi/6vKfpnX4lbUXrSAQIhBQ4lIOEs+k6UMD+dUgLGBK0KRMYfIVLB9MNraS0NqYQn19jWtzV0d/39dJLQRu2H+6UcSGu0vfBCw2amnTYN8Q3mqJ79sOskymfcpD1MuruSFW2JT8wEYykfMREGTzF+tqTeaqwO42vlT2sGEz5WjBmLKF/ZIrMeEW98dA7MKOcuPdc/T3GsMnHYsAPwTLod/aCteI/mWMLPZBFbdOyFa59WQfbxdjSzX5aXeNQ9BGIu47yJ6CcENKobZN5rizDAFhRvXbqmTgCBfZu1atyraLCtzHepi/1eRhBJUYhy3T0YpiEqQpZsG6BTQrIHEn7YKUunhFVhXZK+H8YSWaf0Jmt1CHD9A0evy2a8rYx4s+RfjDXTzuBySHTstte7NocmwAgTTmb8aYyu6q927fapY8214jmzhNKl0khfyPZaDjtTYdj7RzUhIJBhNlJxU/gswO1lg7p0A6xSUH4Y3ok+NkBHL8cANyhUbG78Q/ojNbD3H9BJWCibaJX+FI2dfEydxGuz2HAOGsHdg3Cv7Wj8lC1NT4+f32yujQk7sCzon1D+ggUc0CuP5YWjOtHq3Euy7RWt5fo0ByZKz17MSwQh8/9ufl0dtLmNk9pR+RM5OuYO95vymyw7S4JxXI2T4xsAyHBWNSqI83OeNircDCBCxCFL+CXkp7wPDtvpRunKAWJ3/nqQcSg0VEOUFLnMcCAkyMl02WCRWrZsxC66LTWencriZLWVlm7XtuXk5y+hpp6/A+NsVkffrIxc+I3OHkKcm6NEaOz7ZM2W6ZHbmtAOO6lcPGM5d2faCvrL/2EGzrR
 uvH9ja/x
 hfPFANxF+f50N3AOVHSz0bQuPq7cZRcozYwAdRmpCp4yl1QChkri9I51YqZs+99yM+UTLPMbYpeBzDDGXjzX+XourUaxemVfCp/q4+O+khVmKvGG7DLt2YA+Wi/sludZGNKwioAvQdh0y2oXLyQVb0DiJEUGWFYjRjrQKjG7+JTs1KGVH34j8Xj4XszclcPegS6WIs+96PJOSbsG0hGKB+y/9YknKh/7slOcSnw8KS5KoSRvXASZqzEe0fjpL77SNaKdFLA19iPHwaKkuJYXNAks7XwY33cL5aZC1ejciSpFpTQ9VBWToidGIQb23RnjAIzcG83LsdiXywDiXxAqeLNGRAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 17:44:43 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> As Vlastimil noticed, something has gone fairly horribly wrong here in the
> actual commit [0] vs. the patch here for tools/testing/vma/vma_internal.h.
> 
> We should only have the delta shown here, let me know if I need to help with a
> conflict resolution! :)

OK, thanks, easy fix.

