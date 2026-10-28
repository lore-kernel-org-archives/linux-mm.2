Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFBD606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bIPJgOc3
Received: by kanga.kvack.org (Postfix)
	id 014076B05B0; Wed, 28 Oct 2026 11:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06506B05B1; Wed, 28 Oct 2026 11:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE986B05B2; Wed, 28 Oct 2026 11:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB3C6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:54:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 373F1C0151
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:54:23 +0000 (UTC)
X-FDA: 85372482006.08.DF781DD
Received: from mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	by imf15.hostedemail.com (Postfix) with ESMTP id F092CA0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:54:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bIPJgOc3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTZpPE9gJn7s96098K7j6uvB27YaMf32yiUhWF9ATX4=;
	b=VZunTNCvkH20QtpXnO8HovITH3tdIBJfMmRqsyqBRRa+KQU/WSk4L02tLnRuU+JPQbTxAh
	Z+jL2LZyriW/foG5Ojgob0Nalig9lJIUK64z7JUY924EK4Va99v4yLhXZjOps4b9qmV8QX
	MgUN10onKPY/+Lr3UewkSOYuIxtQCdw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bIPJgOc3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202861;
	b=Wf/J8JeqQUzX7a2qc4NbSHcuWPIRRe48XQ8tUTmT3okkBBK2ovl1gKU2vfRZ+2xmVGUrPO
	tg3MO+O9181vEMmSxxZ+LVLErF0u+J22lE/h12QhmjsfRKAIehR7H/AnbTh7ZALn5rQ6EK
	hxDB4vIAFY6fa2QUq55ftlPbrP4MVqw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tTZpPE9gJn7s96098K7j6uvB27YaMf32yiUhWF9ATX4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793202859; v=1; x=1793807659;
 b=bIPJgOc3iPcKTa1DXojN+YH2KEJcCalwAlquT1K3q2vP78rezERhjcEiyPnYf3XJJi+zm40e
 VZ8Y7h0Sg0LHwZ3RIB6hSZlxVJqtHyTLtmTMwa/Q5NiV5ZlDRHprLtwNr+zvun7UOnbjrZLyZOI
 1EXHQla+Wo0nAnoYaUtKJ62U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f81f3d53b1ebb019;
	Wed, 28 Oct 2026 15:54:18 +0000
X-Mizu-Trace-ID: f81f3d53b1ebb019
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 13/46] mm/huge_memory: fix truncate racing with PMD zapping
Date: Wed, 28 Oct 2026 23:54:11 +0800
Message-ID: <20261028155411.50458-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F092CA0003
X-Stat-Signature: 9jyt3nc37cqpcgty8mmd948hta673mad
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202860-257190
X-HE-Meta: U2FsdGVkX19e7+Feuk9dANYfZmQUIPRobThI3YykyKXSieRFC/Ta30HD0WGBLIYHKNqY48Kwm4wgWxCxyJymBseNbqgSO4EMD6GLeMYVhlQhPMsINIyQLgWGT4aj+ooaxyY/IHAUgV2R2IUNJE1E3TZAQvZ0VLW9qH4pPTl6/wK+WYM+pzGn0CABlQI/isbq2xC0eb4VZq3Z/MjhH2r2HG4dZJKrBDBJ2kGQ4tLWuRi22JpSdijaNZvC1O5Yq3uYBoKedp0SpiKNeWciznCydPLFm9cyy+yd0Vg349cRxx6hFPrJ7lgNwoSKopZw1aHXOSGMu4WBm3mCcd8unXMEJoGL+pNE/yCLuSfcHdLTAonX4pIcitsQMayfvB5NanOmL/Pd+YAgviabslf2VOGiTzGd7L4y2WzahcmBEdLu2zbVCsJldyOXtWdH7t2Uz+Qxz6l7Nqkzbgdb+GwDR07FCiUfxgfHqhW52exvPTFfMbs2kBwQuzBt3/EBDIg/TtjjvYSpIFTCeyHUY3f1RaSyuIVlrsYqMAI9Ormlv4aBUFv6w0HqTLW//X6q0kNiPXYNZcU5uamNURC+HJDkB2KbLYkkEzpqSgDLrvbGFqyVnKkskxEo6+S8irSmSXsc8Vdvn1Dtq5FJDJF9M1QMviZhCIBQNTxiZk4EWTDFboMRLD5f6bJFY5A5aF064/VBFD2MEB4p1Z6/TAEGnGfow2vs/vdRhHDSCI/16els5M7ArR+eB/I3MCWc5jRfenNzVS9pJvptQSkKvGu+c8xl1OZodyW8/TcHq6aRtYaDLaZsqV1pfFn/v9XVDrwjb1SdpkPWzTq+Np+qBUTWJ03CqldTuAY85wOm1T3ZchGRIkXxABTuB8Ph6s8wPrHCAQdNFeCnkfOU/JsZW/TTFoM0Y/u7G0yry0EIY6dIaFzcmLGKUh35M4B6Ww2nSW1AmdF6hXvsrznLB8JhSpWjgi8eWXw
 vekwg3r+
 HB4tLaU26TcGCr5mETVyYywm66hLWpLCySswHHyNSZ1xwGPxDtLMZAyT6thmPltqB2ibsjG3YhZEcZOwdShNwOHSnodEYByHlT83aprUtJuD0pEFNf+fR802UPGDbcYGK3eWh6nc83y/OS3NFB37NoC3mJkvyXeGxiRH0Mun6m6QICi95CpMZVBWtjphxSfcj9MSMmgSL5hzjlvO6mXpERD2i+Pz6JZX0bTbsjFtLvaZvErwNMOTchp3Zla4Uymt9VmzUSLF2bKogF8+JRy+2yokV/Li0u5zH8TeG+eWaHcYYUrur6DTDczl+wo78I1YNJBJPjxTFwBeZIozPp/pQeRVfbOM1vjt6Ji5M2/ajvXnpAnoL9ktnIZyJCGkzIuejMjO9btvzpTJgaigWmw46ARrjBtdnAnWHT8Nw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 27, 2026 at 12:17:33AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
>If this was the last mapping, truncation can skip unmapping the folio
>and proceed without waiting for the PMD lock, racing with dirtying.
>
>ifs_set_range_dirty() can oops if MADV_DONTNEED races with
>ftruncate() on XFS, when we get the folio set dirty after it was found
>to not be mapped anymore.
>
>Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
>matching the PTE zap path. This keeps the folio mapped while updating
>its state, so truncation must wait for the page table lock.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: simplify comment and description ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Good catch!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

