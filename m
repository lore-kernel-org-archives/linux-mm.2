Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6147606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=etSTVBVJ
Received: by kanga.kvack.org (Postfix)
	id 304396B05B4; Tue,  3 Nov 2026 01:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC7D6B05C7; Tue,  3 Nov 2026 01:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB566B05C8; Tue,  3 Nov 2026 01:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F097D6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1275B4032F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:43 +0000 (UTC)
X-FDA: 85392824286.02.7EA2C61
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74F8A1C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etSTVBVJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793687201;
	b=Cx4nLegSgOL9RPM8rt346Ly7UrhO6RgzWTZIKuNU7gnUt20LyAhKSi84YKKuqxTuZ51lTk
	d4CIgfIFFlCrFhHkPqF5ZYx2aexvc4f5ckRFZcFgc5rr+hEb0fMM+Jq75mt7owvcGDNL5d
	5aNMy7OdFa8ELYf5u+W6Xmb/3fay9iA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etSTVBVJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793687201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89WHsBI4UooPN0e/fzWqgj/M9hLD/tFhYxvpr6aA8I0=;
	b=AYqmm8AptAbOa094eHNKOrr0bxu9InAXRCjbCkwKttJmCOrOn5NfF39ekyivgPp3a3Sawq
	qxxMHnaQCExHqW4eI2sDMr+1gorlhTdxRp/CWGHrktQ9Hz958ALhEfperSyQdlfQFWTYjF
	KSkTpW1Va15Bq/TRBKnv2apcDQuQ2nA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R4qncA5U596ba8pavgxH4k05FBMaxgAUsAOufRDPVI0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793687193; v=1; x=1794291993;
 b=etSTVBVJTwib+EydsXBTcN46t5ObiEFGSGi0mA2SqS5GCUmazzVB9aqdFy7gKFGoWbosuEPb
 VBj23CX9Jcmlvez2+aLq6OO4n88LYpCbG9YCmlAAHgEOzrK0kJhm7XxGnKaxjemEXepXWm8mrsE
 I2BVPzv7cR6WQbnrY0rGwpyE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 650e1e2cc95fd22e;
	Tue, 03 Nov 2026 06:26:33 +0000
X-Mizu-Trace-ID: 650e1e2cc95fd22e
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
Subject: Re: [PATCH v3 38/47] mm: fix deadlock of mremap() against UFFDIO_MOVE
Date: Tue,  3 Nov 2026 14:26:28 +0800
Message-ID: <20261103062628.92242-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-38-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-38-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 74F8A1C0002
X-Stat-Signature: 7krjs9xkznrfxt47xfqkapzuprpqysq6
X-Rspam-User: 
X-HE-Tag: 1793687198-689657
X-HE-Meta: U2FsdGVkX18MEgMoxPyzpJyq84ZwxHvcr/wbjLXMPOs9oqzJfGZPVzdUBkRLyX4rsZnCXhL4VzW02Vd4h26UY3tHMq9xEMM/tn8Qd9tRWl11oqRYM2DPFlYkx0aPOr/g1qJB0iGbcOqxPupo16BJ6b0+UbbW3o3uKhNBYA74FMHdHKwWnR5gX/9itnoWYQR0PENU4zKnbGD7Rcu88mYtkcfS+wNJFEwgE1g0r86VDicEJxxXOvDch/5bt5NO69dHpqgpY8lGsYWfeA2Mo3SpPiE3LVsHMjfa8WO6ZlK8xmGmdJdleitNCoHtKIdbnYjDga2s5V+AH7Zai7IA+qKSsWCFkns25J7+i9wupvw6hf7bYq1xsxWDbZ4AYXPRMlnHXpl+X3298dM+8sbKnwlsUVYNc6N5IOQTHlNQ1dQcj1Pzd6oiZTZ14XFbnPhbC3hldtubjD3bJeNHTXUODVIqMBJHPlNHGnNCMEIAPMpRnPHTULmNjBAd8qxPJHdGEhYE9BoAjmUn2MHdOMw17DejNDyzQTelkgOIKihtQFoi/KAmyu2qrQwYOpDLop+7+B6CNi0WMEdbKKplsug9qQBp1r9ghAtumi2IZaFVuxtOPEgabFdnayM4Y/wPxIsnx9ff6ESZcHRCI3YjEqD/EOnH2+2oTKBS04GhuVOxSne0Ss72vTNMrwvvoUTqJLTIj1UVBWZus45ZDdzgLbo4piny+n++LHm46gbkPlILgmiCpD5UWJtIKiPhmReANqfpVkgQhEbqZnWcnh6rNlQaH0GpuWbXb0fd0X1kfx+oOcpKTb2lf2VJASHkx2t4MLhKER/t6VoqTECStrYhBhqLquE4M9yb6vg6VrQP0m0mQyA5pYzmBDRbYKlvwQlTKPmJcBGSSq6PIXcnPcMqRsvcRQyf/kTDePXbzJ4dYizNs6aoNcNH/12UAcOEH1SRukVK6bH40JrTJse3p3aM0/Pi0/m
 awS1rUaQ
 bjsKRFJBFfWbU+jelssvdkYBj7HfxQc6vdlloJP0euEKPeullIPRBwVGA+IWp9utbdZDqCOKAbxnagy/aSFo45gMFtJdIq56Ru+lSYGD+PnllaQmAgHCuTc/msv8BpIdp+p5fU0vP+uYCK1nTyt9X+p9kq0rxfrnMhB2R/1z7zWV6aGceyIQ+QJ7iACMdhXTumu+P9uE9RT5cQeL9zVWdBl2Fo8E3AzQ76YAoLiSvaBanShMvsYXt1eyV/Q+wTUncJG96zh+6xUkeviAYofxsGJr7qisRnCGkqaBnVm5FC5XBUZ4NOBZQWc13b9rczNccFZKzYnu+QJlj0k06HgISQtATdq9NVAutU3CzeWRLzhDGYNJe69cFNLds96hZpJ9Zmfrob9LllzlYE/94ev4AaFIrawUdbE1WgubMNTK3uXF0fxIskwS1rOrI1O7IFwQ7OF7n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:07AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>With per-VMA locks, UFFDIO_MOVE can run concurrently with mremap()
>on different VMAs in the same mm. Those VMAs can share page tables, so
>both operations can acquire the same pair of page-table locks.
>
>UFFDIO_MOVE orders the locks by address, while mremap() takes the source
>lock first. These conflicting orders can deadlock; mremap() holding
>mmap_lock for writing no longer helps.
>
>Move double_pt_lock() and double_pt_unlock() to mm/internal.h and use
>them for all page-table moves in mremap(). Preserve the source entry
>checks after acquiring both locks. Remove the comments claiming that
>exclusive mmap_lock makes lock ordering irrelevant.
>
>In move_ptes(), make sure to just recheck source and destination PMD
>after taking the locks and drop the overly-long comment.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>[ david: use new helpers consistently; simplify description and comments;
>         move_ptes() fixup ]
>
>Fixes: 867a43a34ff8 ("userfaultfd: use per-vma locks in userfaultfd operations")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Acked-by: Muchun Song <muchun.song@linux.dev>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

