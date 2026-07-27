Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF2FC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030506B00AC; Mon, 27 Jul 2026 12:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006BF6B00AD; Mon, 27 Jul 2026 12:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E386A6B00AE; Mon, 27 Jul 2026 12:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8C6A6B00AC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:49:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4995D1A012D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:08 +0000 (UTC)
X-FDA: 85035141576.21.8F84D49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 95DE720004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ecDWkEbb;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TSPhW4EoKUV5joivEvfj7hKpdd/qjzphwyDuYoRqZw=;
	b=TsWqAQP2SnGLd4kHfptkRYkMQStBIJNZopvJBYZPtegZLoiDsrHI5iy8AclyU2Q5JMMhEJ
	YAeItsVq/AL6/86M87nrjmdXzVRXUxzO5ANGSHSlckN+zhiYPnsrnEgVWXYsOoUb3Gwswk
	Vwb0dZmff7jaCgSmDZ2w938ShD1ERM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170946;
	b=lU6eYpPVYOgC64L8JLuSJnTsPwdkk6hb8yVcO/MnJC+m9J1BzeOMZxfUhvOtgJY8J3Mpe3
	k0BVTqKRdpX2MNWzBqHhHlvUDCG9HzwIeHjEsF6NpGfZ4alYu/q0EcATlfichdoHE2sQP1
	DLTCdQtu6cRZshxYesck4ag5LgkrPw8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ecDWkEbb;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF6CA175A;
	Mon, 27 Jul 2026 09:49:01 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1B7693F86F;
	Mon, 27 Jul 2026 09:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170945; bh=0q+7yLXlDlEamYyqT8+gJuMmLMdePag4Q+fMTD4K878=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecDWkEbb2qtk+8ohd6Kewpw4n8VlI4E4Zyq+L1811WJFybbUDBiT4Z8cWhNiPrkBi
	 yWBZRoq7dWSZtF4v40NFDEpiduacWSK35tbmzo9qGFoi4xbTCiexyO5JyvZMXpFccf
	 raReWNwEs40DmEFZyWJK+vCB10Q+0nVfqhCKOuXI=
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
Subject: [PATCH RFC 10/11] parisc: use hw_pte_t for the data-break callback
Date: Mon, 27 Jul 2026 17:47:01 +0100
Message-ID: <20260727164715.2866609-11-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95DE720004
X-Stat-Signature: yzjmdt35k61qr6o9wp1wiooxptupezzu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785170946-777616
X-HE-Meta: U2FsdGVkX19xtMM2Ia3HbnkYSWX95srjJzW0e8KH3GGLqviNxAqzfDm5o2PHBfGRODWxF4I57qfXvf1m/NGFus3/xxAT6iIa0HmdTpr4/vMYBiWmFe6glHPVoNfVf5DtdxxenLsNCEpj4sssWOrq1tHZ0ytFGUnkd8JGTW+WKu4X4qpyXc/JDyWghFWDkWJZ6SdVCN2QLqD8A9GJTPkf47Uc6qYgy5lL3U+Z3BEP7emhLIyMn3TuxQBdlzRWe+gh1gQtMIHDEc317/UbcHP0Fcyf4ItRNMPaT8LjjomjUNqZ5BIJFpq4rCNRhfYgumB82Yu6BTfFngP0mr1Cpfo355sKoXQ6jFskU3DPUAt9BxJ3Tdr7ssNEM5n60Et2RPvuNfKnI/DKqe7+NFQsxMyXmCW5OScE2/csviYAW6Y2DiLePo4T9/VFmnWNk17VXouhsuoy1t0hIsJUBYpLT0fTRgiDpERsfEw33g2PkhSdHHFwXJpTAq/wSzNk9eKaxbl3n/9XxCyY3emHhdSVSwtRiOkw+RNjKHEE35U6L+eo/KvRjHNNNp5Qgk/JKiKfQ4lOGuukZwhKZSD0o+rGqTGkEgR5dSJu61GXj2ZuycibIlxeicmoMhfKhQ7Z7e6pJKM0fzB59a23K682QX3Aenik7OA9/Y5UYoaixQs4aWZP6ysHjd2PyBKgT1BvuvjKyggv1a8TMYHsLfAj+aXA9qSIJo73uNI0AHRSIRjUeIF/0hHMVnaplmrmK8GcyvdSvNhyAXVuAqLJju8UlNCNoAd4YvJCHFPuLR03GHWuSXDSjYi4qbWrIP/Ze5sW7cSJExheesqa179RtGkJxoksuToeIKRA319xSTRvPegZJijeV/7kPfsY/qHb2hmBCIIMP4oCYcQzWA9uY7z2Mxj1dGROtasXJGulH5D4H5m0mKjZramSHJenzuabZStlJgHhHVO2yNVL+R44xQk8RMe96CY
 C5YBlMVu
 8H/6XLP/I4Ku+zA8SfDzwkydSRiaDUTq15owf6f1Itvp36E99wBUrZgk/ELOz5K5J1AqxrqPoMPRYyIMbVIS2zhYKBOxMLvOA+FpwOS5odNym/TCbmk4DMU8UyLq7kJ+V4g3TGuzE7VsVT92peAhlHxGeG6xajNBMq2DYIE7WmkOiYzcmCQwkMIj4kW5QhM74zXba0UGFkTpTLMqusT+E8NrCY9Q8f6VN8KI1w0xP7KitvIB6X7gN/Dmi0jw5zHp27a9YCEyW5pKmeaoA1F92bicnaJEBmc79a/Wawu/71qOE/c1eKGWz3UgsqvyZZbS96JbFfmKVV1PvoSm9OMf+iBzjMDQTmd+T+cm49+kVfTrOJng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEBUG_DMB_TRAP path passes set_data_memory_break() to iterate_pages()
for PTE table storage. Update the local set_data_memory_break() declaration
to take hw_pte_t * so its argument is identified as table storage.

The generic hw_pte_t alias makes this a type-only change.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 drivers/parisc/sba_iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index d9339dd508262..27a7efe3e0a70 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1697,9 +1697,9 @@ sba_common_init(struct sba_device *sba_dev)
 		int res_size;
 #ifdef DEBUG_DMB_TRAP
 		extern void iterate_pages(unsigned long , unsigned long ,
-					  void (*)(pte_t * , unsigned long),
+					  void (*)(hw_pte_t *, unsigned long),
 					  unsigned long );
-		void set_data_memory_break(pte_t * , unsigned long);
+		void set_data_memory_break(hw_pte_t *, unsigned long);
 #endif
 		/* resource map size dictated by pdir_size */
 		res_size = sba_dev->ioc[i].pdir_size/sizeof(u64); /* entries */
-- 
2.47.3


