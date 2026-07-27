Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E721EC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63316B0096; Mon, 27 Jul 2026 12:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39786B0098; Mon, 27 Jul 2026 12:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04A16B0099; Mon, 27 Jul 2026 12:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 822746B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:47:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0ECAA16013B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:56 +0000 (UTC)
X-FDA: 85035138552.23.1A7858B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 503F34000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d9t9pVk3;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170874;
	b=8eGweDBxCzE122GwetiCjX1M1+9kwg8irr3o1voSSqxRDyQ+SYnD4HAngIwCPjfm7tladd
	bRyYezw2bFYjlJqzMYOjS7RRvUTDANa19RrufIMTdp6dj/MNP8gHtMFyiJikXvz5fG3jwW
	WZ5qFl8NLvGYHaA3CyNcpYBrE5OqEnU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d9t9pVk3;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVhgDXV9mHoB+/Ql6tKT+Tsfk9Whul6wOLlCMFVKUHk=;
	b=KLUtfZ50eYwM6K7kRvbj26oxPqAI/XjQBXOTDkYLKjnV8MUZj3cV3219TZJRp+R7O/UpU0
	9htZX8e55+9dErD0gaSyFCJ+UMPxhoRMD8Ga525I5xyqqjbnUUHQlo+XBh8loNwazdw3+s
	j4WFIh0eosp+woG0SYCRCgoT77sWM+s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6328C1756;
	Mon, 27 Jul 2026 09:47:49 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CAAF73F86F;
	Mon, 27 Jul 2026 09:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170873; bh=OeHCtGC0uAROhEyzqyRGicgDGQ57E/f+pQoW3sVwCjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9t9pVk3z+LotvxypYLqFho7KP5XEkp7l8lfha+xgcBRash4qGjZ0Vd/mV34z3ngj
	 YCiqC4R9lIHqddTtejnz0iRZ+amGDO4RrpcG6DeJWoifcWXWkFCXl4PCx8iVJw3r/E
	 fHskF6P1T34bdcplSjvRlLirD1a3/E+yp9d0XlLw=
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
Subject: [PATCH RFC 02/11] mm: make hw_pte_t visible to generic PTE interfaces
Date: Mon, 27 Jul 2026 17:46:53 +0100
Message-ID: <20260727164715.2866609-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zec358zb3n4cngqjgahwk53a5ofgq71d
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 503F34000E
X-Rspam-User: 
X-HE-Tag: 1785170874-646970
X-HE-Meta: U2FsdGVkX19acfrACA3+FW8O51sYy/jt7VJT6oV2tYKC9yuHk1WAvj4k0kQLmOnHX9pN06Nxrgqi0xhPf09cOgZxx3bXk2CIu36Y+7SrvgbjVTbAf27ndIfADDb2yI6OxEIY3mAfhwZ5CCFK8WT2u3/7fEurxglQgXO4s8Fb4sVk6KZnTUxSnnpxwEO3U3JNWmPxOPpQEXWY9O/TU14+/2tsvhBlXjRjh5QxImzNBr2UNVdQ7y4gvCs2Bdhk925EIzV4/GaDJmVub2qfNFpAkhX61+14usHgckFx9GIr393Ib3mre1uwqkXDJF3NxFMLzrngcWwYQjBBzi4Hx5G+gGrxduMapINyKP7eYQl9cUStXXstQy7T3YI5NzcxukL8emjeD1RecJv4+wiknvCYSbRXaQJZN4KQht2qGkK7KVS5IRS5TsEPvvpPnELfZ3DN2I+551+KFuieLVVfHsM++Km+0gF2t47nDK4RbPuNZqRE3LVdoNUhUF7FEz2TvmuwwkLpqUSo5MYNjhbC2F7pcEW1tXdP4pTMmn52s1s4cIMWrTReEcyAUGmU+eLMPWdWiw2CacInUqjgrjMUcC2tZaahyYwtU2N+cC5H9VuoG6S2pOlTOONmUW0cysjGE9Oc36LZSeLDYnWnujABgFwWMfDnWhGHWqVzxAytlhEYTadhDa8GFQpONjsn3qpMBcB077jjHmdT6BTqNw6ALlxz7ryzBOHO4PxwcFXbvT4hkD2fkb6RipAN2SfjNdQ6g62GbRn9iyE+OQKcPednWiyFzntxj/kaMLyVgGJtfHc2ryJAlnsnfqiUpB/o85Y6JlT1CNAZwx3O5jA5cKs304zDNiNhavzFQz+dfZIzGJerhpfFx9MF7jSN8simXb051jXk9Yz2mRbVi8FyjnknH85tmRAvAB8jmCFSI+NMo7kZl6KiOZQ74l3wbiGbt1QRtdozbVLPMf2SvUB1ypJjRr/
 hAZvXPAX
 VNaPj4571vpp0g3dn2VeDN+kLFLUPRfi5qa9viCmYwHbT3YyM0bREguno+OziCVSRZObjjN6KpjEqOu7NPYzhoh7eTUwJGBuE1TrPYmKticPyrN8ZgzPyWOiUh4/w01DqXaohBNdAQvMhw5BE7+3kogWUP6D9gKhWEzUCngswuGRqAyrGZs6Jpkm5e7GVjs0HD3uECPSjVpT0Sz2bsxVbM1o2q3Im2SHT3xqQCcxYX+Maj//eaSFd+UdXeJ3gWNdTKrejRwnTypQgep13cdDmH2HyZpQzzWxIP5GSgGI4K+4IyCXMMNB94/3MDslPwtcWKCDkVQ/ofacdlMG5CoRz/nmIYRiMdp9N/1rt9H676kajj5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later conversions use hw_pte_t in page-table checking, generic page-table
helpers, and vmalloc interfaces. Include linux/pgtable_types.h from the
headers that declare those interfaces before changing their types.

For vmalloc.h, replace the direct asm/page.h include with
linux/pgtable_types.h. The latter includes asm/page.h, so pgprot_t remains
available.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/page_table_check.h | 2 ++
 include/linux/pgtable.h          | 1 +
 include/linux/vmalloc.h          | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 12268a32e8be1..12ee6d16ad339 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -7,6 +7,8 @@
 #ifndef __LINUX_PAGE_TABLE_CHECK_H
 #define __LINUX_PAGE_TABLE_CHECK_H
 
+#include <linux/pgtable_types.h>
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 #include <linux/jump_label.h>
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..cf595608cc4c4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -4,6 +4,7 @@
 
 #include <linux/pfn.h>
 #include <asm/pgtable.h>
+#include <linux/pgtable_types.h>
 
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e4d8d0a9f30f9..c59a68c183110 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -8,7 +8,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/llist.h>
-#include <asm/page.h>		/* pgprot_t */
+#include <linux/pgtable_types.h>	/* pgprot_t, hw_pte_t */
 #include <linux/rbtree.h>
 #include <linux/overflow.h>
 
-- 
2.47.3


