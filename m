Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C798606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QiYgY6HB
Received: by kanga.kvack.org (Postfix)
	id 71D996B00EF; Mon,  2 Nov 2026 02:04:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CED16B05B1; Mon,  2 Nov 2026 02:04:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597A96B05B6; Mon,  2 Nov 2026 02:04:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37BC86B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:04:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0339160BC3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:04:40 +0000 (UTC)
X-FDA: 85389291120.05.D293251
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63F5D1A0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:04:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QiYgY6HB;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKrmzfM/lfs87w6cnTmZ3Teou0HRxUok6ugK+JqAXis=;
	b=8BlKlvGolmXy9EyVTKAYJPZOMFSHzzqqRW6ojTKNCJKZFPvGb2JY8eeeY6HVtZaqR7ZF+M
	y7pwsWW0KCKRXZa8/lSDM+j4OGAIp04GED3kD2VsvIN4SNbKZ9SRD5/20MrIsGWx18iVA6
	u/Y+68Lp8VXONayoYnCt9NW0U/5FTnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603078;
	b=oGPVjhFVJpixsWMPy0+PFO7QYAbdUFXtwcF9ttVKKIEXv1Dj5Y5DnNzarKlQ2P5BOEwC6D
	m+DZunK9jXW+aQvnlGLBuk8ZylP02S+x48pyOoxWRk6Xc0Qjb15gyaKg316qbGXlsWPirc
	lvMsF7lPVHGF2oE4ELl+nnf85ZVm41o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QiYgY6HB;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HKrmzfM/lfs87w6cnTmZ3Teou0HRxUok6ugK+JqAXis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793603076; v=1; x=1794207876;
 b=QiYgY6HB1mW5E+FEecHdTmLFOegmRB/0Kx7ma4l5h/2qjPvozuRb5Nl7U8kxuJgGo8EsEZWR
 S5bpb779UuW1wWS0WUl/cAtINpj6P6ikL5UuxKgEg2su2eVSGCz8y+cgiDg7di06ITDFb3kKKxx
 BUsNdjRhR6pc39oxlYQF3xEk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4b82456d18ca3934;
	Mon, 02 Nov 2026 07:04:35 +0000
X-Mizu-Trace-ID: 4b82456d18ca3934
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
	usama.anjum@arm.com
Subject: Re: [PATCH v3 18/47] mm/khugepaged: check if PTE table is empty in try_collapse_pte_mapped_thp()
Date: Mon,  2 Nov 2026 15:04:26 +0800
Message-ID: <20261102070426.45406-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63F5D1A0006
X-Stat-Signature: kk5xk1f1uhmkcbm5781aoqo4kikxppog
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793603078-512324
X-HE-Meta: U2FsdGVkX1/vQ1+XWhePdGy+r779z0P+7AXwP6qRacyjAY00U3u+ME62jbOfeQmCO16mX54pPUpXaq92oOsrdn7MQ2z2J5gTFHOYXeXSM0/YMtguOdvFVvtWYPWZKY9T1/zY5b5rbQ85dAsJ1EKUTdzbPlEPGD13FksPTnM4Wm6Owk/nR+n2Na0Zgi85jPtedl1mc5qstwibJtzqymJAFn+dN35QPSoB517+2rPuyJldMJL7RQzBjkiJK7D0m86MsM5vwHTt9Z0jpBXxRk4hbmDeNvlT94TKTM3cnItmmRPnuKwZaS9eMP2M3P4srx7SbgpV46jT0d/bFsGLx/Qs5VmKSqMbkHoElpaC6vljETNDNtgYD2M+hR6aDpAIRWo3DzzCdzM5Kb4EtXL/2vmBDSqbpE3UGq8PM55otaep/NqTRO6iqC1VyEyKCIHGBvHm0DXfe63cLZG8B674/rHhN0sitR+Eqp4eufEd/k+efJEAqht1jjHXZtR/ksJk+em5PqPwJx6GBlmB3J2g6LuAtYaskOi+ZRLIO4VCkq2nIlJnBk3xdV2nfQ60YJ1ZX3RlkszVuMfMaYX5XP5vgbSYI43HPoouTjYjfoQ2b/PGuzjeYPOS4aHDG5cnllwxFoDxnyJpDKAYmFnUNyG+EBIuAKpFKEvLJW9j5SWLmvNh1ty0hnnsWoJZhwz2q94TeYnoOvYUXAXHxw7JbL1JExIl38sQPN1IcnvcbWyyTAOsDhw0zYj82c16t4Yhbxe/Rz9ksor4CVxl4P38Mt7x0x69dcTo9Adf9qbPGgVd5cScC5uZd5eQoJ2iSNor8Jah6plVXuGv07z7ZfrF6dMWkwcO6UVzYO0BMBPTXDPGA53Xg4G8ZYD3yPiw11JL+A2phVEqMGkEvUlLtF+vp+rZzoBwRVw8cuzT2XUF44m/CtLM3TqUrTbcZPho6X307Q7BfjGoY6gvBVtiiPultt8TdXW
 r9iLLvSg
 ab+V6XtdRvGZPmMpqFhVkeNdslP3isnV5UfjBo1wqoW3s3IThz6CF8gTJmACPYpiSC9CuCUJ550DR9VStxDEkUxTD0/P1qDw90tjgSPLb+hMxnQS3G2M0hmGp4KFz0/QhLMfUn2XmhMISreXt7LD6rxQcv/2VkaYMzHp6BPc4OrcjNTDVV87TPtxGet1wLkOu89WJFi5lnGaJOHhPFsl/CZmW9yl9UOV9HzWSzXacfyEgMUGK/meSsl5XdfirOOi5kPXUsCb/F1QHiB9WvD1OCzncL8beeBmabzEZ5GV93ARDGJgVe3rMy7OkYrUbzsJ1so8/2dhji/CGoNq079SkVx7AFxBLFfPBgQW2QcgfhTalKSEAaLGEpW9pI6DHPTLNMK84GQdaNeh6DCQtZHDxYDb8kiO4gplqkz1Izme/dFtu6AHem0R1PEXn28+czFvrxIOGRskd2M9Jq2m+N6rT6VgFWrtDvusnWn8R/h7DKPY1p2Ukvm8R9p1fLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:47AM +0100, David Hildenbrand (Arm) wrote:
>The existing code is rather horrible and already resulted in bugs in the
>past: we special-case UFFD inserting anonymous folios by grabbing the PMD
>lock early, but ignore any other markers (guard, poison through uffd) that
>could have been inserted into the page table in the meantime, effectively
>dropping them.
>
>Let's just unify and simplify the locking: try to grab the PMD table
>lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
>the right order and check if the page table is still empty.

Yep ;)

Taking the PMD lock up front would make the locking easier to follow, though
we'd hold it across all the PTE zapping ;)

>We still perform the heavy lifting (zapping the folio ptes) under PTE table
>lock only.
>
>Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
>depends on hugetlb helpers. This dependency needs a separate cleanup.
>
>Both issues this fixes are rather corner cases. Let's not CC stable for
>now.
>
>Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
>Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
>Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

