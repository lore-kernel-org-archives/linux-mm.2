Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43981C5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9CC6B00B7; Thu,  6 Aug 2026 04:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B07D6B00B8; Thu,  6 Aug 2026 04:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6A16B00B9; Thu,  6 Aug 2026 04:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17BA66B00B7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C22BA1C92
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:44 +0000 (UTC)
X-FDA: 85070198808.19.89D0546
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id F280F20005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LH0Y7EZ8;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW5xyVGX61DijIZrtH6YEi/wR5ZThgYM+r9aoKVKPv0=;
	b=He5ys1R2G7ZvXySQprCdht+Ln4Mi4vlJEEg8RdYrHfVvGN7Mvobw9gw8PRxQPNttjbyKok
	0tJpEBZhPk+ATHBokVdlbDPh4mmO2+JXXCvtSBb/tnF9RRNX2CRcuZWWbiL9ScxLWEpZ+k
	0y8iQ8Rqz+1NoBzsg0BaEUvCwXHwWOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005643;
	b=YslXQWGU4yRoL34+5mXg/uUX9hFChKdwfz2p18TmQlQUC9eMZw14ZvjgJ33U8MJ3qcYfuX
	1/pPEXKh0XqBwomW4sSVYQkJE2Djfgjwl1Ff/99mTJg92UsWU00TT74lnTEC17pc94L4Zt
	m1wY/EqSrp4tfGbCuMobIafIbm16feI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LH0Y7EZ8;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 125021A00;
	Thu,  6 Aug 2026 01:40:38 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 58AF73F632;
	Thu,  6 Aug 2026 01:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005642; bh=QpJOEY7MAUNTQ3U6qtfA/cSosGpAOafJ7uPgYOeWuHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH0Y7EZ8u+Hxz4ct2u7B3pbaW7kO2q9mCmBpSc3Gc5aIuRyHyNcQBmJ6i/FKIN1mG
	 dO0EeHj+xqiekdjfLTdjC448G/b6+B4ErFjOTWEV9jERZSZ8hTZnDekIxcwtofLf58
	 Qhbc4ZPDILqETQxHx0gtUFWmYjKyy7XySo97FBTY=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH 6/9] mm: convert PTE table entry to pte
Date: Thu,  6 Aug 2026 09:38:44 +0100
Message-ID: <20260806083926.1807279-7-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F280F20005
X-Rspam-User: 
X-Stat-Signature: 5ip7guypeofnx6gp3bcsjjuhz6ngdf4r
X-HE-Tag: 1786005642-274910
X-HE-Meta: U2FsdGVkX19hk5djBwSHx3bzPPGyxuQCCpjpyob6QHzKNcwqcokxAenKcivq2/fC5Sg1TQMWBILZiAo+Qm93j1dy488fY+wbfC0IvFuuXlOennsgCKXgN5Bbjz326i8uMVgqyoB6UNJGofsWfmLTi9qNoqEr1/oXC9NWD1ytqCMwN6GbxNsdKmWIKPbiig0vdEf93NbcsS21gL27e50riKrLrTEv8FH3chsGoowIm4/3aEZ0ZfkND4Y4mrfo0wKsjC0HdOJEdzRpwJGmPa5QPnA24MgcQM5lMlP/5rIFcP7JXO29Cjvj/+OXlqrf45ixHEU/FYh4PVFcK9Xc2jBQ8SMFqa1hk65fVfJ+6zHAfSgWs6nLhT8yx4R1ivGR9k9vm3kJk2DnNhz9UMl7sgV/Z9NrOi/AHlmdDqk3l/9NBK3++abRCKHcF0WRQMEYExKlrF/K1EklHsglpJ+c/MbZSVjxcKJ5+0Mnco75EVrLh834VWbVVrym8fzBto+6ScTOPcb4hSRJbpkidaXG4FVm9pjXRRyj3MuYrJXMFYuB9jaP5iX67VpHGU5LKlMoJXV1vkNutxawTznkEtQH1SyhomRVOQU/F/jB3cvsDjQTvUNbKwET6yUKDFvT+0F/KDlxQnD4HvAjQ7FieZtOGFumVLq7PlEmra84b0ZosCZuns3ogE32cy4CYMTtBx85c7oZNNsLJuEcZ3Bs/QcCfNv1hRkn8YP6zpys8SQC/OaixLrM2HuaGzp/qNReKJGHqPbP9vDUKIKkFe+9o8GOwwZ33Of/V/+RTmqgTaaK42FKMR0PxBf1xShUQIpvkADdXOqe6h1RbfG0AgTWO37tidtvUM2nskRWGDp1B207evdIq+WY0By5c/c4xkwqggqUP+ttn9igB/Q6/I2fBzwNQxH/8fwG1aCugSfvXcCQE0Xx4zTNUSzZ0xKods70zNtNiHKgDilYOnjBsqMSBUOQmq4
 BoMQooQK
 F4xBun/pHslV3E2f8jXBwv3cVDC+1tQk4qqFd5TQiZjGCb/bI6ATw00L6hic8Lic4GdCz9N1fcePByr4RXuqnaXySHBtEkDrlf1rvnLF7wm9yeBtbOzNtcy7e8WQbgBH70t4NJ8xwKSllyC5+C46z7OT1/uc9Yw2hRs0A9uTLmW03qNayw54thq4PQrGWzbFcEu9a9fTiqgD/bvJzhGk9u9w2KY0UCnfeOsJqtJUphXVAy0TS19W31dWb+OhY8YSIlFEpCf3hEBexJx5gIDN/sbcyAJj3hqGA0r9iMhgO8chdxwEskVr5VJbFG4Lrt23OwbOa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The non-MMU stub receives hw_pte_t but returns a logical pte_t
value. Convert the stored entry through __pte_from_hw() before
returning.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index bc0b9c65aa1d0..9e8b391aa4bc9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
 #else
-	return *ptep;
+	return __pte_from_hw(*ptep);
 #endif
 }
 
-- 
2.47.3


