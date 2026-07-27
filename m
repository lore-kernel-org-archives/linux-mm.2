Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356C5C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3356B00AA; Mon, 27 Jul 2026 12:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A57F6B00AC; Mon, 27 Jul 2026 12:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8546B00AA; Mon, 27 Jul 2026 12:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBBCB6B00AA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:49:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53C8340144
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:59 +0000 (UTC)
X-FDA: 85035141198.19.FE53C81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2D4F4000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cDo3Do/r";
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170937;
	b=YT9or6BXO//It7aTztOsz5wtixNayIvEoMb7b8AvrpqpTtjQOMg/w+/gghlYxq3ASfI2Pj
	wT2xnP9IzrsUI3j9d+/pL8uyTJ1SXwIPBKmElNpGLn7D/XKzadTDO0iUjZxHXZUqc5+0YP
	Xdc9HZtz/ETOPMwZw7M+IIBH6C7ua/Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cDo3Do/r";
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By2DrjTKhau0GEW4lIDe9qC6xkB7ql5CLuXux5cCT9g=;
	b=FfH2CsaSunRA4dpkI77Ebd/YAkfB4VSYBxXuMYPHEqp4nZE/0akMLCycAkDN1mtFWAuyk3
	BtyMDAzyA2AbGX6IxFXg5ZSyGAv4Uh+/PVZ1P4OUfLJBv3j88J9Qe5igEyvUMTn5Z7ecJp
	fgRjzIkdPco2n4WPRaVnNWj2BSOiCuk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A614F1764;
	Mon, 27 Jul 2026 09:48:52 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1AEFB3F86F;
	Mon, 27 Jul 2026 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170936; bh=qEy/4+Wk/vbSZVdyK/qjuUUSc2n2G8gdddSYiTCTNvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDo3Do/rskCw4TMjsksYR/tTcB5Uv/vDrx6ixPR1mOTM9Q1q7fU9kGjz12p9Id7LU
	 nUuEt+vwKjZkAjRnRdC1eDlKTRvfsr1Lh1WkbMYT2XqOqXc7LIJh1KJzggyS6NyLvN
	 HLK4yn08JVV6tDRzci16mxLBAw0vZjMCqreNmXG8=
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
Subject: [PATCH RFC 09/11] misc/sgi-gru: use ptep_get() for page-table reads
Date: Mon, 27 Jul 2026 17:47:00 +0100
Message-ID: <20260727164715.2866609-10-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2D4F4000D
X-Stat-Signature: jr6wr8nin3whfjrc39fuimm1nb3bn49s
X-Rspam-User: 
X-HE-Tag: 1785170937-949516
X-HE-Meta: U2FsdGVkX18aU69HweGklou25HAhUeJw3D1idqsDGI3hDmZQutAgdJwrV584I1My3EPKvHa7ciBcSc/shTanFKpaWDyxTjuarpg0qnrR7LERmNNLl0H5fV/7+zQmfUXmj8a4uqLsC2zIB4i9E/Y1pPkFXIs65P5fCBcguywsFmSlZ2hAPcMoWterh0d5/hdTX86E49sWPXAGVAnWmteJCTkgutLGw/8X98pXaiZmPqdmi24J62gGrhA8nvFOaRQksQ3Jsf3YBCqCvgrxETwzWXixMZur/g+Xg5gDlD1ruD7sq8IoBg3nODmhVNuFUvosUJ3ZcAXZN5G1cu/+KjZTxKdUYHmOAJGbZoHbIS3d0r2C0ST7qlrY8YCxerkeyj3cnEFZuz4zGNh1Qv4tItGPr2M6WglAEYRq0x4jwfXNBg4nEiBH6KI1/EUPfDDjeCqDbGTHfTdhSR7KfSU7MF7sZoCkwOojQZ4Xu/TQvdHHMZsFnMhz70BsCKkoAPzPgoNZpLzrCQUXxMB6HiEsWRNZl+8r2RFjEhLdvGH8ZvHBfiJaYKHSljgvRgCuKiuKto9TkFqPmMowe+xp8DsPzBgQnM51V4uKpzkopf73WRY4HZagkD2GfcDHOf2tL6wjpYKRLugRXyUB/FL34B4Kc8OMYMjHRZOQR/erTg+LAOCShJ2gIaTDX3EvHETEY6mIx9toO/boz/5DZ71kbxMigfv87BhHjDKJuHxq4SkNe5gP/WIX9VZ328NC2mc58MmcJfl2TsBlh0G3ipNWvzhaYyeeLLu9fErKxCaGi/bRCgraF5+vgwKNWi+jKjKAwM/8/SMgFKx/0jGQ80VHH/7KjRh7k9k4UxNj80Kj5gpmS9TYXBUiXZhgqGtMKiNXFZBukCzOfIrg0t+ahPZvy/r127dx9cdRNd+pphaqPNIQalI+dm1Y7v+jTpP2Ve5AKhO4bKL3CgS5ypl/Jj/38l7BRP8
 8wVeZRdN
 nQHwrYX6YrrihvWybqwVI9SiBtA49oA0RIYm4cctI0z8E1+Z4ptaXcyOZZ4YCx5Douk4eNLGsU7vvKb2FQsPvV/RqXAINzVU3DMEfRFqCFK+ijT6QkJEegcMa+0UBfSHGNqVwzwruvN39Kg5LePIlH+nPjLoo9NhgbPXn7Rq8IQPMLRwDu8lPBU3Evan48uNx7tDhxwcwT/m0gC27cET7vc9Le+zpEvMVJ+NUtToUfNRtsv53mWB7ImEfNU7icF6hm48PamOYw3cN8oye3D4CxRLppQDvK3G9itnlvxXGoGsEqW6KKaf4Ix7JpsXpagj6dXhTU9nzzLBmN/0iNw0phZINoqExDHpDSdXeDK6YHHtP/NM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A leaf PMD is being read through ptep_get() by treating the PMD address
as PTE-sized table storage. ptep_get() now accepts hw_pte_t *, so update
the cast accordingly.

pte_offset_kernel() also returns hw_pte_t *. Get pte_t value by calling
ptep_get().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 drivers/misc/sgi-gru/grufault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 3557d78ee47a2..ff89d34ad2aa4 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -228,10 +228,10 @@ static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
 		goto err;
 #ifdef CONFIG_X86_64
 	if (unlikely(pmd_leaf(*pmdp)))
-		pte = ptep_get((pte_t *)pmdp);
+		pte = ptep_get((hw_pte_t *)pmdp);
 	else
 #endif
-		pte = *pte_offset_kernel(pmdp, vaddr);
+		pte = ptep_get(pte_offset_kernel(pmdp, vaddr));
 
 	if (unlikely(!pte_present(pte) ||
 		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
-- 
2.47.3


