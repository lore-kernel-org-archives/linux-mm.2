Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54841EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F3F6B00B8; Tue, 10 Mar 2026 10:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29956B00BB; Tue, 10 Mar 2026 10:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69B36B00BD; Tue, 10 Mar 2026 10:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 957636B00B8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DB5A1A01F2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:58 +0000 (UTC)
X-FDA: 84530450676.13.AC3BEC7
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5EE9FC000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gD0zzF1Z;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pwf6Nc7CaGHddB3FSw2OYM6VouGq/Ldl0n4v0DGTvQM=;
	b=7X37zGXuWM0cW3VSlxZNC1pmkoaO+q7AYsMjFMnOVMn+GYcQ56lmDZW8uiuDtGRNvyXXGo
	mK9rwZ9X5hapgR1xUHuriayIruQ+x5Kc1rsGBNwfHgoVSrzERnfP9o8BKhXtvVqULA/lS0
	ZPEOasbz7H5Ks/85M24hSfdqdiibBOo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gD0zzF1Z;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154496; a=rsa-sha256;
	cv=none;
	b=7DqfJHz6i16cN5wpLQKwiRi1vIovqprayaxoMe2TE0uonHl82T8p51OpYZmXS22UyXlfIv
	zOlsN3DkCzDpkeitJxWhm5snQPMUm3kYAZKcN1UGHOcvQcjHyOOvJe2cBY5PokpL3RJniV
	UG8Xfh6ElAHBJ6vm18PcXlsMV7L9Ogc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pwf6Nc7CaGHddB3FSw2OYM6VouGq/Ldl0n4v0DGTvQM=;
	b=gD0zzF1ZzkpibyiRY+w+AjVdGRw9wPyUFI+y5FS68pAmCO1c1M9m41DEaxy2QyJUSTMhzg
	P5XvbFOUZoVyZubGSqW0JOoPKegDPZYBJmxRz5fKJnH3JtcIuHIQQfgUEkfvTqhC9I4zI7
	8e/PuxvBlI2swPY3tUz0PqrlB4hUlJQ=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	ryan.roberts@arm.com,
	david@kernel.org
Cc: ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 3/4] elf: align ET_DYN base to exec folio order for contpte mapping
Date: Tue, 10 Mar 2026 07:51:16 -0700
Message-ID: <20260310145406.3073394-4-usama.arif@linux.dev>
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5EE9FC000F
X-Stat-Signature: tssucm5zozs33fp5deasffhdf594w5to
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773154496-967432
X-HE-Meta: U2FsdGVkX19+rsKIQs1K8AV6scs5PPuRDxwKCtBwDXuMXBSoloRDeY5PHvE05zR8hzfaNjpb/dku8PNqSBr5+Glkx7MFS3ogILphXMsUz0u7dYu/rq6K2yI22QcFnlh5KRK8n6otFPjxUobwUis+AFd0bejPk9VRjRxA/P/gGuqa1Y5UpBPgMhHEI6T8xum56K7P6THbbGaEQbuhZynZptAXHh9m8qNdW4Jbg2YA8ZD4NTLp8ttKCOmNEnNaFUW1LeMH+r+nR3UtC7xSWyxbYOlUnNyQ6DBI42eHftbozIxHg2FHqVC0OsJrr9UOPthiCJt5e9wFnxpv4IxiRTTeRrusTBpmKgz6IhRU3Qgk6w/lbQcT0KVyDjqZlGR8mH7K1yZTrrbHcS8L6pE14fUasUCD1kn3q6SAx+iU7QJbKNaF9CsHy2e8i9Myg5u5gUoNcZONE+5uxnmlntZpEGu6vClvGHjsCOupL+67i0L6emIZS6GT++20WRay8vCFL2FkPUIqty9888Trq9xRq1jwvxAhHId928rCwPJJ3y92gA9ouEBJaAKH39GUVRaxkluOLUmKadjBHv6zO3/hX9cKitfbYLFx60Fzg/I0KkIMASQH/uaUasinEwpI8JGOKHpc3mpROshgN7Rc3+3jL2xZ3N1cF35vs3fSnwDhELSj/6wfn4yQlDI7DCMMQQsM5BlpIP/YEViv8PYa+W4TycWRKSRmJNYIZDNoiBiWTsYxDung/qWmLFkddAOgwitGsG8CHjSrJCppvVt+yNUAKLelUqZKtuAh6sdW18JMWoPub3h4va+KZL7v0IR36C74laeMRBLBaLF/8t35pTviwxsSETGAZjClQJAH1LyMgdMJ0W1DgEeQly6AxFHt2/4YaLOGCOl799X5K1PKcMbYPFnc2bCwQm8d3Tn4l4wM+sh5We/4DLQxKyDjjh0c/AZ+k/rqJYA33sRevks81fCzMtL
 fZATIMmJ
 vi6Bq47M74ZScQdWYXdk4vYKQnLGgEghTP9nV2hd+NbihQFl5/vsZg+zyQhXA8EsYjHf57EgrMQaIn79oQ22s348z0W+/Y019izDyZRd+L/gygr9g4mrp3VY9gg3PO4e6pBWYGwDYC9YFUQZyrP/piTlrXyIq30zUVrs8+0aaf3Ze6/lwxHPlcTsfIFJF6mIA9BFymM2S5Vcsg5WMAiolWZTsH9aTZhZ7dUgraykObkhyA7ihmnZSbQGgjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For PIE binaries (ET_DYN), the load address is randomized at PAGE_SIZE
granularity via arch_mmap_rnd(). On arm64 with 64K base pages, this
means the binary is 64K-aligned, but contpte mapping requires 2M
(CONT_PTE_SIZE) alignment.

Without proper virtual address alignment, the readahead patches that
allocate 2M folios with 2M-aligned file offsets and physical addresses
cannot benefit from contpte mapping. The contpte fold check in
contpte_set_ptes() requires the virtual address to be CONT_PTE_SIZE-
aligned, and since the misalignment from vma->vm_start is constant
across all folios in the VMA, no folio gets the contiguous PTE bit
set, resulting in zero iTLB coalescing benefit.

Fix this by bumping the ELF alignment to PAGE_SIZE << exec_folio_order()
when the arch defines a non-zero exec_folio_order(). This ensures
load_bias is aligned to the folio size, so that file-offset-aligned
folios map to properly aligned virtual addresses.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/binfmt_elf.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8e89cc5b28200..2d2b3e9fd474f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -49,6 +49,7 @@
 #include <uapi/linux/rseq.h>
 #include <asm/param.h>
 #include <asm/page.h>
+#include <linux/pgtable.h>
 
 #ifndef ELF_COMPAT
 #define ELF_COMPAT 0
@@ -1106,6 +1107,20 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			/* Calculate any requested alignment. */
 			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
 
+			/*
+			 * If the arch requested large folios for exec
+			 * memory via exec_folio_order(), ensure the
+			 * binary is mapped with sufficient alignment so
+			 * that virtual addresses of exec pages are
+			 * aligned to the folio boundary. Without this,
+			 * the hardware cannot coalesce PTEs (e.g. arm64
+			 * contpte) even though the physical memory and
+			 * file offset are correctly aligned.
+			 */
+			if (exec_folio_order())
+				alignment = max(alignment,
+					(unsigned long)PAGE_SIZE << exec_folio_order());
+
 			/**
 			 * DOC: PIE handling
 			 *
-- 
2.47.3


