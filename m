Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C26606EE96
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QzuU3YVM
Received: by kanga.kvack.org (Postfix)
	id 71F386B05C3; Tue,  3 Nov 2026 09:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1BF6B05C4; Tue,  3 Nov 2026 09:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5964F6B05C5; Tue,  3 Nov 2026 09:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8BA6B05C3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:49:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4A4D120340
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:49:25 +0000 (UTC)
X-FDA: 85394091090.13.1C6DFD4
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id 146BB20003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzuU3YVM;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jU0FKXBVK1IwPB+pnplBif7xzGvyqeYd/rvs2r/ax0=;
	b=B9Qz275AfmVWV+AUEx/2ICf+Z6L6O/gLQiHGF8IWgYpvoEf2wAadrS4eM2swKC1mC/tZE6
	SOssa5zJukI9TsHOEoANZfjNYAc45AaxW9tsVwNmTLLqr6KzKHGBs5J2XzA5l7nJ6ja0c5
	dL7KipJTaBbZw9Hg3gN7gSLeF/TjhKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717363;
	b=5TKcawcGXle5A8XFDPSfgn8KrM8rxLHWNfUt+GocGrhDPcCRbqbHcUxjt3iIuy41tRFTHV
	oIV2dIlr3x/VgQY1nQMzQvdPKS/S64bMI5AlZOt43XlnuaaDCekbjfWlLYd5GB+Oanq2q8
	rBvNc/BHsNFJWHiEIFVsL2P/CGQU0Bw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzuU3YVM;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dOHWqJbFAMJYJY9pYQ0G9QdWl3ff5fr4nC5HvUAG8+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793717360; v=1; x=1794322160;
 b=QzuU3YVMkybToy3jCx589JuXk6v7arOjZKVMIuzVTtcNW67BI2N1Sv/tO1vpXZew6+OWlgh+
 BtzfOsvNi5KxLjRGGqGPhJtBN3VmFTvpgdWNR8NKH7Gp6SbMkzFQdncMIrRdzS1uk7Hz+9X+9N+
 g3oq2Ln4/BioZxzKZymYhmOg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 632a76e6b0da1a08;
	Tue, 03 Nov 2026 14:49:18 +0000
X-Mizu-Trace-ID: 632a76e6b0da1a08
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
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 42/47] mm/vma: call ->may_split() before a partial merge
Date: Tue,  3 Nov 2026 22:49:09 +0800
Message-ID: <20261103144909.6138-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-42-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-42-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7qg6fijg9b51asyen7ix7t81z9qizded
X-Rspamd-Queue-Id: 146BB20003
X-Rspam-User: 
X-HE-Tag: 1793717361-105515
X-HE-Meta: U2FsdGVkX19ODPJ1Xs8zvXhDRO64uA6MWhDccKG/azD30AmTZmQA+v/xd7Ax+moNWGR0Ep9pTMaWVGrsL0qN1IumBLmsWyoS6xplZg0U/gFG9EacFPsAU3jy//uYp2znT9aDdYLPMoRAd/o1zgN8fuVwJ+JfwhQZZFHgCuSj26/ONNNwtIsf96jtWM1oWlDh9oBYuP7oUrWL3cD/fevtyYtqD7s8hnjzR/jj1af6xuw3+i32SyhUtyP/3fg1tV/l8pzyOIGuheHRkwXkIAfERwq4YtHWtBLq8nETu9wYo1c3bi2k4a9MElWtntety7ctgWIa1RW1z1VTSiivC+qR0+ubcdkvYrW88mQOFREAg43/WrGtmQnVUE5hxupKPZPP49Ks5Nt8jZ5jDrK56WJg8MUo+DoQG+/4A0nO/7yTyvQyVAl+Sw6AcWLKOzrXsLrPI3pScMf8ccEJ5LmCoj/HErDVeEv6b4kIyOIRsHbafOxWHFv3ENsKh4nEyCuoKurYIaCNmbqZlaGvbVOl9Ci76bBhUTTODIFnJDlpoLePO1Bo5KRGsowMXaLpUV7NvLHX4H7PZoLt83oQJz0lVpoNIP7tbPtsUYrOrVCTdTuqggFO6DNOM0HcYHo9cOTJMkRiuIem5ANWubsV16N5x3sns4jJV4iXMlYFviKAOdV7Bxj6B87712oAoaYvTQLGMhnwxXi0K0nvx6TSrVn2p173D9zP474J6wwYpCHtu/aV9qbyy3ddSVNsjGVLFpZ/BFvFiMZ8U1Fpj7ZkRbi/2DDnl6D2o5QF8spHYMUBkeZ5weUG24FW2LDVeGha4C4Ed6fvP089gd2NGrmQJfJ1EHoLbgNID0K2fCgXbt4u8gbewgscON+dVO+HViyRsMbQzSOYuH/Vo5/XbeP0KITD49BmO9QRCGHAawI/WW6TaiNRbQK2V5or5j5PkJSf3vXDx613M7sXADCyiRffzBRDlIo
 yfDcJ/Yo
 kBazpwavLx6OjaXvjpBylJDFn+gHSjZ5Z2lLG8VAB1kobDY5E7CAHI2KcPPTjw+0VVOXdtjXo6KD1nWwsFRcDzBxDfF0teKoUjCr3OyxXTu53+9S0U2NT9a6Ac2Kcifm2MojGi7EcH6yuG01Q9xw8sNlG7jeJ+BpWs7olNDLWWprwhIYNmRHg60VavQzCrcHAF2dGmBVl0/cxsDlFJsY2SYhji68WWcSUfP4YjglKdRJXVIX/dX9OfoBy7+A5M3kSpmtsh9rzODQbSayZ7Pdg+6FuANKIgYx060KJJx5tg+r/T4GgzX3Yoy4P1iBszuMYseL/AoI1Mcup8vWlNoZk5dZlPHl5xIdgzE4uCqHIP2vZJoQsvFRzQ9rlcmid1bPWwSIS1PQjGEQiU2O1OeJ/bpcnamI+UmEDMtv5/YnZOu5n5a6R/b2keQ8yuMcFfQJBd4Lrg9IMWMAFmWW7haSxKDC6vJxE7xK2ezQdLSeMPyY3Hjgzd7vojong5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:11AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>A driver can use the ->may_split() hook to forbid a VMA boundary at
>certain addresses.
>
>A device-dax device is a character device that gives raw access to a
>range of memory through mmap(). device-dax refuses any address that is not
>a multiple of the device's alignment through vm_ops->may_split.
>
>vma_merge_existing_range() can move boundaries, but does not call
>vm_ops->may_split.
>
>If a range at the edge of a VMA gets the attributes of the adjacent VMA,
>the function moves only that range over to the neighbour: one VMA shrinks
>and the other grows. This is a partial merge, and vma_modify() tries it
>before any split.
>
>Take a device-dax VMA that lies next to another VMA of the same file.
>The user calls mprotect() on the one page of the first VMA that touches
>the second VMA, and asks for the protection that the second VMA already
>has. The result is a partial merge. It puts the boundary inside a 1 GiB
>mapping, which is a single leaf entry at the PUD level.
>
>As part of the merge, the kernel looks for a huge PMD to split at the
>new boundary. That code does not expect a PUD leaf:
>
>    vma_merge_existing_range()
>      commit_merge()
>        vma_adjust_trans_huge()
>          split_huge_pmd_address()
>            mm_find_pmd()
>              treats the PUD leaf as a pointer to a PMD table,
>              so the "table" is the device memory that the leaf maps
>            __split_huge_pmd()
>              reads a PMD that the user wrote to the device memory
>              folio_put() on the folio that this PMD names
>
>Bad. While the code must at some point be taught to split PUD entries as
>well, the issue here is that we move VMA boundaries such that they are
>incompatible with the driver.
>
>Fix this by calling ->may_split() on the address that a partial merge
>would move the boundary to, and by abandoning the merge if the driver
>refuses. vma_modify() then tries the split, which fails with -EINVAL.
>
>Factor out existing split handling into check_split() and reuse it.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ david: improve description; cleanup the code ]
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

