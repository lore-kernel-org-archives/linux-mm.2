Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004E9FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669396B0099; Tue, 28 Apr 2026 09:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619A96B009B; Tue, 28 Apr 2026 09:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509326B009D; Tue, 28 Apr 2026 09:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF856B0099
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:20:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C42861B7218
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:20:49 +0000 (UTC)
X-FDA: 84708024618.04.F8CB221
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8E2EA000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:20:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SuCOgAS4;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777382448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQK83wzMxgtDx5zJs+rX80tqrYmQXtE7Gqa/54foH+M=;
	b=OhV8vxSNTBb15lGR4hwq6TI7HGyrzEYmP3fMldBmJDS52TyNoRZNybs3AHg0sIanEn90nM
	QGin36PAerDxb6nSE2b59dKT0E57eq2bvsJFyMzIBEOv1GSkPpjo1GmbuXwTYzU6uv2N+J
	1dOGy0wY3LOEmuOYKmMTwutBQ3Wtytg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SuCOgAS4;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777382448; a=rsa-sha256;
	cv=none;
	b=7owH4wGkzvsDpbn35ny7VmgJKPDidONrpmelFZ0FzADkpV6gdQoXKh1AsllF6XVtUkfFDl
	n/058kY0peWWHIiaqhcOU8bBrJQBxOMOypKpGlu4WeO3vLHBmpKwdTXDuZY8LxZNK/d553
	H8DmNImNmVlnKyssZCRTmgdwjQ1+c1g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777382445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQK83wzMxgtDx5zJs+rX80tqrYmQXtE7Gqa/54foH+M=;
	b=SuCOgAS4NzrmxBcKqLQ638tD3V02Ag8mN8/0M7capcdVTyJsCDDgenQZtxQTB4AUTX4YIF
	Zks1Lkqhz4DcxlukdWzarX/zlV6DV5yKyhodqiUSxXCOc2Noc/Xq71hZLkhOWE/kdIFcj4
	vmBJt3djqbaM9XoBwIeaPLeZ8lXKk/w=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	jgg@ziepe.ca,
	baolu.lu@linux.intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
Date: Tue, 28 Apr 2026 21:20:25 +0800
Message-Id: <20260428132025.86657-1-lance.yang@linux.dev>
In-Reply-To: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C8E2EA000A
X-Rspamd-Server: rspam06
X-Stat-Signature: hwd6b8hgkaudndpidfdrgw91n1yf7no3
X-HE-Tag: 1777382447-541538
X-HE-Meta: U2FsdGVkX1/Mme9pFobcggJTi8r3zdF/UYFx4aoWd+zyuTIgmj4z8dgld0mLZhmXS7qBi8Bn7ZNC47laK36tSJCssoX6yH4+wjS317F2UDr4rYiGb+x+S3Z1nBeyuajTRC+ZjA3k9/oyDPeT2DySRQmpyzsL97YSXgP65VfNSZ88oUYk5fQln+qNlKUsYIvb4TOYA8ToylriIKmhHVVrpobtnR1lhVP5Y6ObZgcoMIBCc1wz5Q7335/1aEhMMgBZl54SJ6cgnjzVJl9nR1HXE8aOnZuUkkAqpq0UpuT5blYU7BPgwgl9eLg0+S+CPTCcgtr33mNQm9FzZr+mUoJkaBd7G+KKc4VPO3AQ2Cq3N4MVLnmYrBM0ro5VsYRt6EHyDJIReBbOTJINYnzio0A5OJDWD3BP4QBSLu+kQOI1X0SQEC2O3vXLARvp9B4naMgpSmKby3PxMEE8bSbopGYEdgl6schcwMhMCT8pK1ivj214RW9xDut1/wpzF9Wjsl6dhYKqXmohQl5k6Ds10irknjBNsVT/C/lgEZXYfI/qVFAkWqxw9y8bAq/a1/8IAhhO13B64PSgBkkxGrkM1Pe/gRw2s/z19jZkvln0cr2PS0cti1eZkik90/+r6g3msZAX9xibJW/OUsXuay67iTSV0NBo3fLo3iaevE03gHqpnEizCwQU/6leVhaUHd5D5MJ93G/Cuuq49Dx3JfyLDWLYL1t/HvAh1C4htySU+IMpcYX1bBunHlGs/RRJqTq/3yvSG+1QflEEfobg3wFq+lkLZhxORUaU1E+syn8xrTnOCw6mD7/esftkpp45xzJ+wd1TfQgF1wIz0JCjTByakCpk6wAnNa14WhWgCQMsURRbprThyZMHfKqifsawqSLFjfDRXTqRr9esrFt0SCi876KatiS6Tq8dBejM37oR5C88TunuQbNixmK1wiooj8qCgmMbIomWU97mjrGm+tXQoyw
 hdOag19H
 2RRL1/Taym8leiBX2niyhc8s7sEwTelmK3cEVZrhPPVSMkaea7JgFzxiH9I4JpVjaO2j6ILV64XAlFBmZ+hzaVPPS56qGj+oJos5FJC8pyN4bMVfiJ0JdV6WLhi4k3rFz+Id9JsbV2KHZpSCC4LASW9VDZNfGBcqO3MorWaml7zAjrG144rvw3lqRE1b62EHn0BYWO0GMF+82fU2RAMfoBL+S6FoQPUbvfVsW4felTRsQ9gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
>In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>from freeing non-boot page tables through __free_pages() to
>pagetable_free().
>
>However, the function is also called to free vmemmap pages.
>
>Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>is wrong. But worse, pagetable_free() calls
>
>	__free_pages(page, compound_order(page));
>
>As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>except for HVO, which doesn't apply here -- we will only free the first
>page when freeing a PMD-sized vmemmap page, leaking the other ones.
>
>Fix it by properly decoupling pagetable and vmemmap freeing.
>free_pagetable() no longer has to mess with SECTION_INFO, as only the
>vmemmap is marked like that in register_page_bootmem_memmap().
>
>While at it, just wire up the altmap parameter for remove_pte_table().
>Also, the indentation in remove_pmd_table() is messed up, let's fix that
>while touching it.
>
>Note that we'll try to get rid of that bootmem info handling soon. For
>now, we'll handle it similar to free_pagetable(), just avoiding the
>ifdef.
>
>Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>Reproduced and tested with a simple VM with a virtio-mem device,
>repeatedly adding and removing memory.
>
>Found by code inspection while working on bootmem_info removal.
>---

Cool! I just reproduced the leak with QEMU pc-dimm memory hotplug as
well.

Without the fix, nr_free_pages kept dropping after the hotplugged memory
was removed again. With the fix applied, it stays stable over repeated
add/remove cycles :)

Tested-by: Lance Yang <lance.yang@linux.dev>

