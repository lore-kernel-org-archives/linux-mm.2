Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AFD606D804
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z26plYoU
Received: by kanga.kvack.org (Postfix)
	id C98806B05BE; Sat,  7 Nov 2026 08:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FF96B05BF; Sat,  7 Nov 2026 08:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F726B05C0; Sat,  7 Nov 2026 08:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8647C6B05BE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:51:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1321080363
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:51:03 +0000 (UTC)
X-FDA: 85408459206.25.F53C297
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F00A40008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:51:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z26plYoU;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHl/pcUk1PujjHCFvfmAUSYKKFrTIfDLlcd8di49U6U=;
	b=7+v7d+XabaW0hEa5UyS0ldqWJ98LfaTvCanbYsZ4NvrsUZdDnmQUTLIZ4XnncRC9BEioP/
	UUFt2rCmRDQb8WszmEKbwsBgEEcf5yoOfsx4SgficgocwFjBiN8O1+zuH2D4zxiLPyJ0s2
	ysRVUV6xDl5eWk7iv86OgAZ9qAgfdjU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059461;
	b=u6Ad4E2hcKgEP034jUyQWzxVvTuja+WxtWlYYGDbzT+mmTo049yMo1voVzNQgdRtDaEHXR
	k8nQDcvmD0DMK+4QVI910NS+0hh/g/5iX58H9xv3XQySyhomwGhMS5K3AaFh1tGcGgLVKP
	xdqdm22+JNocjSEJwtFotCYyFGsZHTg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z26plYoU;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso2544338eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059460; x=1794664260; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vHl/pcUk1PujjHCFvfmAUSYKKFrTIfDLlcd8di49U6U=;
        b=Z26plYoU4x6qYGY+eUZ5lq7mQ57BS+OynA1eGKw+MA1RAh4ZQ07PrICOhPMnyMEzjr
         szVMsUpAFWWX0MxttI6hRKNLKqdYKOWGzhPsgikhQjfsv8xr5cZme5/zP/mmWvJISjGV
         AQKhtd84g4T9zLzJcYBsTfy5WExPVM/sSudLNsTXSInUaq1HoB+F4xyUkd3u4zuC/A1z
         0AEBoHdFobWMsi4pv5MyrMd2nme7ur6gBg+dhd4VETZnNVOf4Wk8QDG0eidJq+mwFiMl
         d6IVXAK8iU9/cu9AX7KCe4lEEsauJbvpjAHZ3V0qgeXtCJ3UkgaaEypPROIsStj+BrIV
         PHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059460; x=1794664260;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vHl/pcUk1PujjHCFvfmAUSYKKFrTIfDLlcd8di49U6U=;
        b=Wm1VYh0xn5OFBhEJvMAS/Z5qQYcrjsDpg/FFKg3ceeTV4Iqx1JAy3i9A6WYni7Bcqp
         Zs7k2G+r29N6ScMZS4HMehVl/6YUHXgVzn2ZDvb6rOcrQ+8XDnbmwBYwZi2pY6HtbuNf
         g0CxXRhaeaCKcnsWPj75LnGJlipizNt6lCOT89pRbqvwbiMcmMqsZnvRy60NWrXq6wi+
         AR5YeiFYXagZm9cf0ujtFKwASv0a+gwEajbiQZGxpIoFxxb2+o9RwOyEJfl5GLZQ5S/J
         GNAcGaeXt2fUPF32IdsgXviVr4C4m6lckerv7pxtejeoSmwN6AfaBn8etmCt8nFZNI4+
         3KeQ==
X-Forwarded-Encrypted: i=1; AL+hErHU+qrZiFjVjPCYE8tSzBh06OrNjMaBn+lImlatOVeYKUyLu1GSzWI8IsparRWMZd8/87AWa2wWGg==@kvack.org
X-Gm-Message-State: APuU4Z+dL0qJUKn+dozjgCE/ssb9PyDw8MIOf8/Gvil/W+I9J+L4lRlU
	cbYpZDpJglnf86odWjnJTohrX3CdWGqEYAiPPkMCV4QfMoaiexQmnUI7
X-Gm-Gg: AYBFou0HbLOiW9oxtV2G/7+okU/lZKZ9EPj/owyxWrS2ohToDYgkakw2/WYccEjK6Hk
	XPzEcaRQvs2FRcP/yGObVfxkem8YP/kHH37y6llmr6/SXT8SMfNUocTU+tXWJimScOJBWVcqDHU
	jV14UC7LXV77a6wxDQe71quLTOU0Q8KPTxUAUQStI/YskOAE11xphXN5gb4icxvOQNMJBdj9Cwn
	7/RXWB2FtxW/ONszuhvK6jgvyW4tRLTQPsy8gCpr6nih8DSPiGZ2IRjEdH3EUTrjhd/mGm4fnRc
	4CMijt8kShQ0wxUYUVHRhai3YUgKxRtn5XgzNYeOszIl31j4zBwTxU6RpAgNLfIEsU9uQDY7tsE
	2cnaiRnNC/Bg97O/ypHImtsh0roOfZtzXdaj4lohXa03KdCtnnE/wV+Pz7FSgqB9j2tRA8c7Jhn
	RdbzQ0zOEBwDMTDMcNTQRScXgC3UFmSM8esuNHfXnctfJG8G7+vuRCiADNnWizjQVq9mW4IS7DQ
	u5ESRWE73WVe0hcu6m/qIQNXuVqjogWOcOksyPM+SFD/5ejU3XaB98oSaRHf5xwM8v6tAdTbJvG
	ognG98Uc35wYjrNRSiKx9KWMLzTBY3iOpvhlcDk0x47rzZUe4Vqth2yMEw==
X-Received: by 2002:a05:7301:6285:b0:35c:85fa:5a61 with SMTP id 5a478bee46e88-36f76f0e752mr7696943eec.38.1794059459921;
        Sat, 07 Nov 2026 05:50:59 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:59 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 09/10] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Sat,  7 Nov 2026 21:49:52 +0800
Message-Id: <20261107134953.748622-10-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F00A40008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: a6srk61we3iyytfnacny3hpmyaamphe6
X-Rspam-User: 
X-HE-Tag: 1794059461-153249
X-HE-Meta: U2FsdGVkX1/VrLPRF0rc83lHX3EBccmvqHolp/nevBWeiUp2ym2WlSYgWB7UjF9vl6IJeUtmf7elUhbOs/ubgntm7KeejXI94GchYNppQKfYbfAyvPluEpv+D6hCob/P6L/VNBE5N6vf2paP95A9IrLVpDltHT+apESrlfGhDNBht14hKows1CejvesTTZtO55I/9NKrMpjefAwdonwOpXHpmhKghR0JsNTljNYKd89bMqTC3iIAOeftQXl188tJBNmcmTYNbvw/pzoyseVsOpiUNQeEi3qdeqLVrTpDaKZb39AmfmCP7cRB5hr6euiwEcrOWtWm9gqceA0eTIgry+r+mRMs8AA204OHrMcE1LBdjeKAZpieZSGlMbYDhMiC4R37Tz1YYEPqoMk86TD8uvhMlVYp6xB7l2g86Oi4x0nsal2sHh9sgKLxc0o0oq6uRC+geUjHEvKyH/umgsmjlCxE0ZtZurwHAZJeVsnznJePdDrQMCUxozmJ2GtNpB04H+acr17fgdiOQmmRbz6i9ywSVBXCmASxwIY1a9a16IFCwU81+2luAc0tzJ38mEYuOVQ7uxTgdUsVbmssCIWFEhN6lCo+LyaKcJuBcGDSFKJBOI9j+i9GDjNhpfoVASOR6nfGxjgzi2nDrquk1n67xfGs003m8KYr/SaFYeO2wr9F/iVTerx/Gsr77gO7QSadsKwA7PldCrH0IUWmWsdMEQxCZJ2FZ9UtzW4/oNif/9VN+MDX9Va7WfxAOLA7J0d/kcgudVZABKtUT1cOD3ynL4naxABNUNkjb2bW9iaNSDl8553umDB8733Au3gVfGvFeB/PCOtujY8eCINy4qqHHkDudZvVaLzCdqQbwbrwJn3vIiRUZp+guzR668KvTYtjtaFLSiw6m4N4Q88mFfa+PMCGCeSJPhOQXGYbAZpixvIOw2prfw2y7pbAToRE5jC7oHlKwnuDA6pPgxv46WW
 AmqU1Lyi
 S1uVidFNuXapBKkS/NS6apubulGIiykam+1DifjUjK7nNPbP8gg4LAZE6uGnfGfOXk+9LdH3ENKXOyBYQsdo33/UcDTx4oLmxKbqUPJc05F08w+TR0r8uJ+wy+mNAwugzPfcZgBBoHcJxz+1GJU+w7Pf6Fuzl1tzk2Z+2haHzA5oA0g9PCU/cC4KEzDGsZh0n+qw7ROHXdG4ZaxyE1VdNE8+A+8DCeHxXoEUOHLoaIk2U9UqoZIE/WikqnvDtf8MWzQRksoUKBEGsoSqjV/0suTFSwnc6mIANEHt6XNekWgtNpxNiU3Zo3Xsl0Du4iuV/JxXFDAnc5kwwhzGMnuAtPJyQVDCh/4fHIlOsT9Iv0szQuFpxo6p0CjnfOviaut9f6FRbNxMVnx1hyTbdezRFHAW+HOB7DcKfjkqcXl8OyYbvu165091UoY0zc5u9X0GRB41oCiU/zF5QDFHa9Cjbpnf7oNPOSBgGoZX3Tqmnz4GDUQCeZLaYmaPS5br7xDmcAlpX1vgCS4n4CPCtIMGbopYqMjxOJKlmMxOxq9CFJip8zOyaTJoQKwxDiejp6bBvUAh8/FYvVmvMe7yHdfVnzCsE+Hh5kaOalA5IqwUYXQIptPQcAGlFxsQqDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

With large mappings, vmap_try_huge_pmd() may free an empty PTE table
left behind by an earlier vunmap() and install a PMD while vread_iter()
walks the same range without the mmap lock. Set VM_UNINITIALIZED on the
area until the mapping is complete, as __vmalloc_node_range_noprof()
already does, so that vread_iter() skips it.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 884e178405171..5b898da0826ad 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3617,6 +3617,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_mapping_order(struct page **pages,
+		pgprot_t prot, unsigned int nr_pages)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned long batch_start = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_pages; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_mapping_order(pages + i, prot, nr_pages - i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
+					prot, pages + batch_idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			batch_start = batch_end;
+			batch_idx = i;
+		}
+
+		/*
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (batch_start < end)
+		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
+				pages + batch_idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3655,13 +3734,13 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = get_vm_area_caller(size, flags | VM_UNINITIALIZED,
+				  __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -3670,6 +3749,9 @@ void *vmap(struct page **pages, unsigned int count,
 		area->pages = pages;
 		area->nr_pages = count;
 	}
+
+	clear_vm_uninitialized_flag(area);
+
 	return area->addr;
 }
 EXPORT_SYMBOL(vmap);
-- 
2.34.1


