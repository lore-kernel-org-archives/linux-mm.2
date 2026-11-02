Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4314A606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z6X9Wt1f
Received: by kanga.kvack.org (Postfix)
	id 4081D6B05B7; Mon,  2 Nov 2026 07:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF416B05B8; Mon,  2 Nov 2026 07:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5FE6B05B9; Mon,  2 Nov 2026 07:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0BC6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:19:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 865E11204F9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:19:25 +0000 (UTC)
X-FDA: 85390084290.26.1CA2127
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6868C20002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:19:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z6X9Wt1f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aamrL1eeNrbIdMSN+jaXpW6b7pg64KUgg9/NR7r4M8=;
	b=UHdH8CZARFGLNgdK3tNKptOR+SJlP4aEgeQBo5KDNtVL0v/+R6oIH8gW4grO2RxiGfCZSJ
	SS26rGpMhMJp7r94gz6r821FaissFPZzS+cxF7gxLvcYmyL4Com6k5KiDoNDLsxWjycxFC
	/eRQQDrSntapMS3YW+0Xk0ao1UNwK20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z6X9Wt1f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621963;
	b=q3f/Sz4EGWomh+n5JEM9fC1m7Nw3Va0WQzUSX+7Hv1IszJrOR9kJtT8AGZHTqwOBnJOws+
	hSo6FGcJwtRrHN/qiuks0wcR38THcUt3WUYICPWmujn3B/ynTfZ1Es2gg/TEned0EuaF96
	dZY12DpKEU9tRa7b9cdrEF+32rqk91M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=r/y28Pr8KNBr61CZIB3z7msn3ARAQOG25oOo8bDyEqs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793621962; v=1; x=1794226762;
 b=Z6X9Wt1f2OM0mk9Cvw5ZsBYTsSsI5PkwaBYJjVaRrHKRsTE9x/ymuRWOcLnrF28+pJweuNV7
 6EzFPwGVjc92CRJwXYeA37ONO25xqpbqAElMy37M/9RJ7oZUyP837HGQFBUQd7QRrP3u8yb4+GD
 5HLS9jSoxykzaPBgfV1a8xbo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c966688054ce713b;
	Mon, 02 Nov 2026 12:19:21 +0000
X-Mizu-Trace-ID: c966688054ce713b
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
Subject: Re: [PATCH v3 31/47] mm/mremap: recheck PUDs under the page table lock
Date: Mon,  2 Nov 2026 20:19:14 +0800
Message-ID: <20261102121914.69229-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-31-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-31-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6868C20002
X-Rspam-User: 
X-Stat-Signature: c47bm11ctpcubrphzig14r7opgc4t3ye
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793621963-118230
X-HE-Meta: U2FsdGVkX1/01PMhKiufUpvw7QWOLALOWcGCxdB4WA2SCOsr8uJVYZxn/WgVvpcscMJgpgIgbRm+0tAI8RIdBNDEQGbAnwO0YpAqCGsdh9i4Z9WeH77sSB8dIGyjnvaNa0MB0iAPizJDT1YVRFRFd1i4m1VSodSwVA8d8mZQoDWJtY9w3bb/C0ibeCuRDYuhWrNqkjDujk5Y5U//BeIQJ9Xi0Yivz0Z5BPe6IEQ2KRQgoQ6DZZ99Qp3xjko2wdyDf2KSL2c9A6piIBD+vhkPGoGIQwEjgojSTOO900IcYC+QzXHhIkIjcwIpf9rWta1bFAPDvSoLDT96sWm1Rw+l7DKoCYujIiEVZqe+jkGJlWAy7LLwyupiKpgcUvr7PihhU9Hrlp88Ey9qwp9KCcTCmZ7vJ0//OIuFh/xilGEZtBLfZ2sR5Pml/eKQMMU3B+bO6ioblXMULODnGlLjAZ0VN01bBNCHn7VTQTxMubmnSWWHb+xkYHpZNUNieznmJ1qMaJxOs+HFUfOFt4Pu3HrmsfdUSzW3MARUsyLX+GUeaao0B1MRxMu57fm7j83v+qmCXgc6SnMQCkGbliAC8PtD6TLXmyD+0qaj9mDgGip4itzajdnDwrP7nawLRTh1FVInT7X+BuK1WS0yTtejrCc6mBMpGWyAOus/jpnWob8ZuH9IvjpC95rK5c/dohtWAqwlBBt/zWtp8jZMGNruIoYYF5NxiRnVUZVr9GPfUBIGa4RSzU95tKPzA2rIbulNKfJm/SZ3rTe+yhh/zZazEg1/vUt5JBjCRWE9BTvZ+WFpyEHeB+8ZwrF/0fZinu2qt6dWX3A5AQ8uQ2/sbvIQWZiJiXVtxfGUsUCp9aHqktHzJlK+JYEp5XRFKGkvuOK5nbFPYZCCwLAXubZTDzWPzlZMB9j0nR0UDEbbslJxcQyEkm4C5Qu8YrdI3E4UtAODY7OxyD3fYa/MHPVlZvG0HUi
 Ztch3wDv
 Vo4fLNqdswsiq5Yr8zYHMixB/fS6ZK3ayD+EzpFMpdsVyoT3PyZXpJH3rh+vhWuySsYZlkxp+/YIL2THuxCNW0F7ove+L3W9cMOXPIOuYLBaIeokhKm8+7whu2BVWp59YoIYbSMrwwn/Ihw+wqXaVWLixIR2n75XZiBW86mjA2Yy855hdQU8o2fI0H5O8gutqiKy48bXR6pIGW3MmpOPRTgTfNvMT1rSzw/KV7ni3cBIjRAKi2w7CvwAzmSYqnjKwCyl+L0bEawbKKZFtqBP/+x0ZSqZaEKEc6EcAGl8pGPp8sRFVsZyPmU9RbmKyZmguEUyCWPBzHHrRGcV+TwYeBcLE2wuEmcanRiXXCmFUfVJ9IVmHl/hW6C9KVuSUNfV2bZuz15waaF2pcYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:00AM +0100, David Hildenbrand (Arm) wrote:
>Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
>clear a leaf between the lookup and the move. Holding mmap_lock in write
>mode does not prevent this.
>
>If the zap happens before move_page_tables() tests the entry, an empty
>PUD can reach move_normal_pud(), where pud_populate() turns it into a
>present page table entry. If it happens after the test, move_huge_pud()
>can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
>warnings on powerpc.
>
>Recheck the source under the page table lock in both helpers. Treat an
>empty source in move_normal_pud() as a completed move, and use
>__pud_trans_huge_lock() in move_huge_pud().
>
>In the future we should likely have the code lookup a PUD/PMD lockless
>once, instead of multiple times, because one of the problematic bits
>here is the:
>
>	pud_trans_huge(*old_pud)
>
>Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
>Cc: stable@vger.kernel.org
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

