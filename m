Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A34606A328
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RO6dfT3Q
Received: by kanga.kvack.org (Postfix)
	id 217BA6B05BA; Mon, 26 Oct 2026 06:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8E96B05BB; Mon, 26 Oct 2026 06:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091A46B05BC; Mon, 26 Oct 2026 06:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAECA6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:32:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67450804C9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:59 +0000 (UTC)
X-FDA: 85364414478.25.9EFDD3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AB60D100004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RO6dfT3Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fGI+y4MpKjEewUYjAn8ox6qZ5C7dHcWOShQtBM7bNs=;
	b=d9pU+I1f1xUnzFEw81oMhXVDaM9nHlvjBwD4C2C9ahI+4//6zXRIEcX9CkPDaacXaDPIzw
	3NSdTYslIz/NC8JhaE4ZP4O9ED4NuLWhv5WOyRmqZuPxVxne7bEthCRk4IwuGOZAplycQ1
	6Ck7VuL4whPQaDdTFv4hBFWe/Iq4nNU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RO6dfT3Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793010777;
	b=kKNyOZ6tOepoih3gvD4uOXtRr7j/xpaJwsruVMvbCyRR4ET5zgyCFLlgN4mj6z3AIJnKhj
	yzxicfXGfCxq0+l9+WeRugOGoYlkeH+x/nn4YrhkaLd0Tt1Jwd9iDxJL0R/x7yfocg4Bqj
	hhNC90uJJsGArlR8P10sJDV9BKkHC9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 400B460A86;
	Mon, 26 Oct 2026 10:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD311F01828;
	Mon, 26 Oct 2026 10:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793010777;
	bh=5fGI+y4MpKjEewUYjAn8ox6qZ5C7dHcWOShQtBM7bNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RO6dfT3QYsUPq4P/l+LzkzWsJNIeE4tNHdZ+B1Mabg0HNxC/baN6fFufRG2KvUn7o
	 BX5QCIBZ5N8hEF6cNLuQlvNVEZ673nYKERFyr5nN1XR/ngPtDM5sBlxUf0xYx9yW34
	 HaVBERjbK3lHqcFAw3bgQZt2FvA3bZCr5p3BynhuGD9scfLpV5xQrhJXzl1iWPqe0e
	 iqp/S03RLxbvRJrevVEedl7sWT8x7j9FPrfoz6X3dEmZEAc5qcXT0K8rvNu9VXTyeD
	 f1yh7pVsA+wCM2I2F2zAlMsTlbpsIt1sprPvc3PJ9xhqSrReBqbyberrBKLfj+X5Cx
	 Uu6l6Djs0qgyw==
Message-ID: <8da0110d-e05a-4559-a581-44a1fe28a41f@kernel.org>
Date: Mon, 26 Oct 2026 11:32:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: remove unused functions
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 SJ Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Bharata B Rao <bharata@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
 damon@lists.linux.dev, kasan-dev@googlegroups.com
References: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB60D100004
X-Stat-Signature: sigp4r3qn35q5ciq5xf5goudxnp4j6ms
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793010777-833855
X-HE-Meta: U2FsdGVkX1+xDPZyQUJk/9HjmtLNiYgj37kokeD+/CSD0UfE1GILCOoZ3pAMr4z4J4Izs+nISsEu3WnIHgn7Ja7KrBc54HL5jxfqPpoPaCw5L4M5XyKx4ePkw8+xtDdOM3a2l/G3yhsoraK53IaKiaLwcUCYUibzyliPSpmYpcOGLuF3ySCgns1Si2sHZ0XW2dDKhttZRKc53z1h3iFNfgDRKo2o36O7tPW9b8iEamI8BIPdhAp5ZoT4SEMLOOl1ktgmgDESmvn0S5IYDTMiMS8bGh2AZcVd6kjXzjSx6RO8BNxdiNeNKlkhEAQ3q+lPzTYU8BZbLbyJkUeVVR22FB6Uc9ZLp8v9WQBZbDTj6lGqhdyF/ADKLwvKYMv0Aph1axWEIufq2DqkoNn+cubfnt98S8mREqRzQ4SyzbZr2tXQpaOWrX7basO2WpTda5oMSc4sIG9pZJn9Rb7zspbLNuk9DtR+DFwAbwld3A0R+fhz5jK/1CpSIkYAqVETYwQlHSrCLk3oxDurnX/0t/D4xXLezuw5jKwe37qW/yvEeLe6kQdu9rtnSqdF+G2Aq/T8tzOLhqQ673oZEeErMDe+Mmicx3a0I1vcjfEJ8pH2Wp98DTMNXP0a0l1AmuucHn1kj5NAJZhU4COoWihxelj+wDiluAksQEk0JEwE0rKgKbacAVQmqVocIa4PbNSONvoFY81U/LTPk+2LArP1ihnbYdvtyqI2ErZeqaK7sRd8jbQ8VX75FfL1gVnuASSPvxWn6+gaTekaDf05xjQHkUFOOBWTsbvwAOAzeQ0NnMNwPc1kdWRj3v5se8d+I8EEn9Sj38hmpvSkOs7J0GFCtn9AlLQTmmyJhF9d/ISKCS3P5vwINDgUUZqzZpcwLypHo0X+KEy39tSWzOVMjSOhIRa7dTyKMHOkTBjodRBD9x1Qc1MtB6TNZu1h0XYWDU2yATuT+TgBGpQYwLVCIMHzNrK
 1g7NP8nZ
 Qm0mbJQeTxV8qeUl20qhgguJV6sShmrNa8gbb4Pwq3hR+LHJjQY1YGQQEpueIoaQOJDP0QjtMXRP2jvgrP0nn7ZMGw83DC2pZ4HXc/NEhRFfG6TCD3SnIuhJgh9PwuRjC3CPDBp/Fjpd8rN7BUMbX/qoxL0/idKG2FawL6j8y5YSI1+ywIi5SXIyGiECLroheRw+GQcv5u2dI28XkGlSz4lqzPElswBVrhAtztWgCWHmjeFUJwu+YgjQf2QvAhHDXBVQx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 11:30, Shivank Garg wrote:
> This series removes 16 functions and one variable in mm that have no
> users left anywhere in the tree. The functions are all static inline
> helpers in headers, which no compiler warns about: GCC never reports
> unused static inline functions, and Clang only reports them in .c
> files, and only with W=2. The variable is heap_stack_gap in
> mm/nommu.c, unused since the start of git history. Each patch covers
> one file or subsystem, so they can be picked or dropped independently.
> 
> How they were found:
> 
> I wrote some Python scripts, with the help of an LLM, that scan the
> whole tree for every config and architecture at once. They look for
> static inline functions without callers, and for non-static functions
> named nowhere but in their own definition, declarations, stubs and
> EXPORT_SYMBOL(). Where a ## macro could paste together one of the
> names, they read every call of that macro to see whether one does.
> The candidates were then cross-checked with a real build: a scratch
> tree marks each one __deprecated, an x86_64 allmodconfig build is run,
> and any candidate that triggers even one deprecation warning is
> dropped. The final report labels a symbol "Sure" only when that build
> confirms it unused, and "Unsure" when the build doesn't compile it or
> the scripts can't rule out a use. 
> 
> Before posting, I searched lore with semcode MCP for removals that
> others had already posted, to avoid duplicates. Each patch was also
> build-tested on its own.
> 
> The scripts and a generated HTML report are here [1], if anyone wants
> to play with them:
> 

After the merge window please. Focus on reviewing fixes on the list.

-- 
Cheers,

David

