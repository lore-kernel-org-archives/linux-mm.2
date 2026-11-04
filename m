Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD274606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MC8VPNm7
Received: by kanga.kvack.org (Postfix)
	id 7FED06B05B1; Tue,  3 Nov 2026 22:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0A06B05B2; Tue,  3 Nov 2026 22:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B626B05B3; Tue,  3 Nov 2026 22:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2DC6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:13:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 762491C3ED0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:12:58 +0000 (UTC)
X-FDA: 85395964836.22.15A141B
Received: from mta1.migadu.com (out-93.mta1.migadu.com [95.215.58.93])
	by imf06.hostedemail.com (Postfix) with ESMTP id AE566180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:12:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MC8VPNm7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.93 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793761976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFKdbCnvgEnPUCR+piUdwFlucy5SNy4ZmkD3FremwV0=;
	b=JRyJkdNw2RwiqSotAiTyHW4wHhgLyVoDwoMzFCJjIM3uI48H/036HqznNh2NJEupynla4r
	wlKmKsAloDWiSXdIjgMIKTgRQCiAblLgse/04QlTSXpwQDeBv6XYN/rteLj4Jlpq6AVUqz
	ra61TD7XHPKQAdI5j19ZVNqO/RUym3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793761976;
	b=abm4Hl6xG/8hb4qJayw9NaRbQ8UOB9HlNkjzpErnuq3D5Slts8DTFacfurmgfpy+thJdbg
	TpdpXOck7NN+TqrQ+N4RHzUCre3nT+dHkC9dZ7QI/9JMwYwFw7MRVnwcsQVR5lAsfQcEL0
	5AGZVOW17tkP24BvoJRjIWPpPOfjqbY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MC8VPNm7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.93 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BFKdbCnvgEnPUCR+piUdwFlucy5SNy4ZmkD3FremwV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793761972; v=1; x=1794366772;
 b=MC8VPNm74Ok18sfdmxnpsI6xRh7R0Zk5W//KSoh4oQqgT/S/C7qdI564Yzn9q9U82YW5fQUa
 bHEVLCzq9Vqzf9FcDE7exA0+xlnDu1bTQ6V7pBzRG57qh+3OeK8awrDIx3MWDyYkXpPcFBKY+AD
 RqEEVje7E40Z3XH7oOIjjkYY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 888f0105953f8a83;
	Wed, 04 Nov 2026 03:12:52 +0000
X-Mizu-Trace-ID: 888f0105953f8a83
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
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 43/47] mm/huge_memory: split huge PUDs when adjusting VMA boundaries
Date: Wed,  4 Nov 2026 11:12:45 +0800
Message-ID: <20261104031245.9524-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-43-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-43-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9stbys1gndnhag1w3wt63eog5u9m755t
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE566180002
X-HE-Tag: 1793761974-140659
X-HE-Meta: U2FsdGVkX19lV735yx4HxXPltB7dHKgbilv4d3psMf3eRDQAho9el/UtZpYnCeKfB4FVYOYc6KjZmEGZKSwC9tMg+PZ65Gp4ZgJv+H7qxFeN04070OBfT9bbVya7Yv3jk6WBhL/hAhHzN5fbeovZpiw4A9Zze5fiep6arW3SNyOvTZcEOpbevootDL+/tofQQCj0w67r/2KmwVZgFK3pmhKTpu+ffnYeVwtGTBLq4EgFGuM3UsNXc05sp2Prf2Ee0YDDHlwprc2VBKwxRq+EugJq8z/wfCcXN5YSKAFLglaiqM94DrcnN95dBqvIZ8UEjosyUnqBlhb4dBMv85973qM2eRI+NfJBedo8f6WjIvxrklo7buWpbTeuEff07GpZeu8vBlx93BN1Pl/JN8kksM5lr3rUZa29EYHLzShgJWA82j6CUzTXcDt/Xufw8+L9NUbBxhY9Ikgfm5b9NvGjLjQgmCqHHC2Oj1pWuFvLayvewN3T9LJHlLeNccVbdSK7Q6R3dEtf9RQzNKHf3MMRF/g8hKio9OqlmfnNu+fq6P6udG7tkHQ4FKxyT396lptrbKmF4CsNyxrTo/SNXSk5Uj7IiEp4+MWzNTAS8I8GzIlFctT/+7Du4XoaJzvkOaIyNXsdh28t8/Oa1hlrGj1AEjjR3JTtefyEbjuoDaIJrgfQjJVRi4sPO+Gd6w2zxHtyIV/Dkzo0LmkFUrUnKkx5+AisygNfgqdbb6hGm1aY7bH/82sIrsepiJaVPBNvur+W2QyyGrT4B1v/WioW4k1uN5Au2tq43+hOLj0R5VQYiFtQLmRx82N0CTyy0g4o8lD2kRmHkW9DGiQzVy+DMh1LJQ6qXdK407r/xTtUzHPz7+UUEkqQMH9DP2IBE8uJHmpf+TFqY/5JfiFd0PZJ149GrX9GW1PS8Xecisk7SBhNxqC6nBVbqxyIz/CGLIswnmDs2f3jjgu2FntDrGsEuo0
 DFYjVCFd
 E3J4xrRrGVKjHt2JZhDjIm4lsKCP8slN/FckVvITEVK0Agxa/4CMDUh5FdiTEW8hETskXO8U5xcG5vlwYuaXsvS8ExiSUdw3CVRpoc0v2Pi5s/3CN9KTL/7kgNysHgIOuakOfuaYK27y/AsHKLf2sUv4sALWnm7mSLjvlc6k3Ge20MppLVpfl6PRbAqM3JvGppA7ytT5vmUZ2DGmqtve8i30I+FOoYVdbh0wyZ5XKHWYjn8Ljqzl6lDUUXvkPhgRMuMTK9vRGNLIqYQ8OAJmcyFBuYHHzduo2T+iq6c3sQlJd62ZS7bttGn5wGD1+9pDD5whJcVfFByzjSw8IEJXr6sL7q28Tx+Vp/e6BTsxUCignu1bW/jW9nOw0bW5kGLLS+8MLPTUxc7cHEV16Zqug2miOVHbd5IAmJIGnigDGsz1YYQ/UylTF3989pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:12AM +0100, David Hildenbrand (Arm) wrote:
>PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
>allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
>only handles PMDs.
>
>After faulting a writable PUD-sized VFIO BAR mapping, changing its first
>page to read-only with mprotect() makes the PMD walk treat the PUD leaf
>as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
>the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.
>
>Walk the page tables once at each adjusted boundary and split a huge
>PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
>PMD-aligned.
>
>Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>Cc: stable@vger.kernel.org
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

