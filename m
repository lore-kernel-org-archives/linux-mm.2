Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DA1606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=dKoGpakC
Received: by kanga.kvack.org (Postfix)
	id D9C7D6B05B4; Thu,  5 Nov 2026 21:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D743A6B05B5; Thu,  5 Nov 2026 21:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1436B05B6; Thu,  5 Nov 2026 21:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABDAF6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:44:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE70540CFB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:44:14 +0000 (UTC)
X-FDA: 85403150028.13.ABF31E7
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf20.hostedemail.com (Postfix) with ESMTP id D76621C0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:44:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dKoGpakC;
	spf=pass (imf20.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgrWvNnafi0hz01idjBDDnVhQC6ycv925GHIdoMUXIU=;
	b=8S6k7BV+zjhfjUp7VfL0dPvcJps41Rc2pnweQKJ5bmemxa/5WV9IEpCgjoxwFuTKcjGnx2
	BM+WWSgG5BnpUsRuLtjeuBqWomSmmlMs02b0gX+XZZ/dgyNo0cr02QmiXGOQSJ2HvuePsE
	drL/SOUEleNp8CdrnsNrWJdLC88U4Tc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933053;
	b=GAQVkZm4zRqQLU4Jab5W5OQOxGN8952H+p3pyb3KvwHOiSfWhDGYnTy75W9oGES3rtF1D+
	pRfm9a17IAHbAmi5gzQGtBCGnhtrfqDTbupND/+H0gVsOD+FTcj6JTIM/u5vZwyAxa2Bux
	wyQu5impbcqUjkY4zS0AVXk/eDbPeL0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dKoGpakC;
	spf=pass (imf20.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793933045; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=tgrWvNnafi0hz01idjBDDnVhQC6ycv925GHIdoMUXIU=;
 b=dKoGpakCq+RU2UuXTJysOZT7YmHbb040g0fXp8Wmfj6zU/Z/qjxPR/SWw401MV7u0e3Gqa
 Ni1Pllf43TdKWrUQ4s7RlJO/+Edi3Hc5QWuW2WTVzoX2XFIn5qtIAJ8/b5fZtu2s1dIu7J
 KRm5KaKPjvItNiC6gwLlZjhYlEdQvoHJgC2YO0X7iiZ6LAOHOfaT89gSWOErsL1eGK55E8
 udPQqfbSeZfSTOTO5wW3we2PTS5tyArqlnunk8Knq6Hanhq0q4k9ydL0NYfhUtOKNAqMVL
 drApI/PdEL+L7lEK2lGdUJDB5/WucJwwOxhqROGNDAsRx0g9v+IpT1zlMLUuTw==
Content-Type: text/plain; charset=UTF-8
To: "David Hildenbrand" <david@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, 
	"Chengming Zhou" <chengming.zhou@linux.dev>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Rik van Riel" <riel@redhat.com>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org> <179387163181.11797.15205182972949028650.b4-ty@b4>
X-Lms-Return-Path: <lba+26aed3ef3+2342e1+kvack.org+zhaogongyi@bytedance.com>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Message-Id: <75926835-508f-48d3-a5d9-176cea61546d@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 6 Nov 2026 10:43:45 +0800
Content-Transfer-Encoding: 7bit
In-Reply-To: <179387163181.11797.15205182972949028650.b4-ty@b4>
X-Rspamd-Server: rspam06
X-Stat-Signature: ubimmmxaijad1cwbso5w8jpr7tk7chei
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D76621C0004
X-Rspam-User: 
X-HE-Tag: 1793933050-514252
X-HE-Meta: U2FsdGVkX18uk0C6PnQaDl9a/TmLKYIo7dksZY9zwoK7oLymEL/nM47mDT2hTxo4GhjSlcXJvlAJjPCthCJFYVFUfIAEdN2RXO3JaAuC68RUCWO+WDn9npiLWlJvMCQhAQc5a6ffMKAlMGQNC8BBehX0+309G2srcu4DX0Zwz1nIsLUcd8ztSdeeGpb1BwEGb14VlFmwa1DEUDstNrFNB8NQgdx+8PaHVxnA4JvMZJTX7R1WQTnVj7LtAD21ZixDCBn1YOMhBx/aBuUzYXtiivu5nVYlFK2j24K2/FFu93YfhFAZsxYWkMtWRj1HgFVolp66toKb8Dgwe3hmKTOx1dkZFShaxyP6CmzVW8BzNL0DT/9pK8lfB0BfazZb3nU63geXAG9vo3EIx3X4aJ+U1bWFSbV2n4suwLdNSB1byzoaXrU5ibIbu6sbOEeXH/xEik/Nqih10YFeTlx1p30Ara6pDsyJVV04dTfvGohXzndHzsnibYNUlZwt5xoN9mMHKliDq5q/JPbDQpb/h+2FzuO8gPBaj13Ktw4mGZ9jIpLUutVU6Fqs6+Wp+MybmB3vxnuPGZuxifOOTaOzVNjxyfMVjNcvIxbMYqs9azxk7RCneoxPg0DGfBa5ZoYoVxnBrXhnIZ/R9xE42PzJb4xbahPvDBEYSFk4/uGj9Z+QOmunt/MG65qhE5TPlvsQUwV74UZ954zkB5Yc7/cDxeziOSaobM3dp9Na0bedQzQGe5z5LRvx508eCAlK2iVQByIqSR+GbxYdRzo1xLUVFBO9txjN1FxvUtUCkZ4UpT6U8oFpQlSTRubKUjEkMEx4bNn8I4DjdOGpXixWNzyww2lXinZtu2jRO9wv+3tRVcGKwUQu7rD+AIcoZ8Eeq2wDz88JKoHvUdLBRM17DRaz1x3YipDVZcyBhBSeB462jZZfQeb+yZ4CVdIqGbeQHv9bHDjooSIjU3moLTNZ/za6oGJ
 TQh+ieNE
 bWF+p+qRanqSvbH1tP8OmxjdAbH26MMgAlJn+skrankoXs2CEBL+GQf+6el3jSam0PmKU5QOdMqa0oXp69GKIn0VmjGUTgfM3wEGOtb0y0dZ4GZwB0IgHA4M7CAmlslj8xiw69C0VSdzqIKe/HEpTumEjArx8oqfsuEEc5JI0Galjj6aK9Alby/WM6+WI3fDYwyEqYjB8cHQsBrBqrSNX1nRahhjp3FAZ16iWmxYufaqupkQ8vnZu3ti9tNff/zRBvsenNqGzHFpb3bNb7KFtAOFRYFTpM9sAhV9KlNlyw3Y79PXO/Y4kQSUAEge2WSydTVhD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David and Lorenzo,

On 11/5/26 5:40 PM, David Hildenbrand wrote:
> On Mon, 02 Nov 2026 12:32:25 +0000, Lorenzo Stoakes (ARM) wrote:
>> When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
>> accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
>> via get_next_rmap_item(), pinning folios via a page walk in
>> ksm_next_page_pmd_entry().
>>
>> Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
>> which it drops afterwards.
>>
>> [...]
> 
> Applied, thanks!
> 
> tree: mm/core.git
> branch: ksm-7.5.misc
> 
> Applied patches will appear soon in mm-next, followed by linux-next.
> 
> Please report any outstanding bugs that were missed during review, so we
> can either drop the patch series or decide how to fix it up.
> 
> It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
> though the patches have already been applied. If possible, patch trailers
> will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. Further, this is not a guarantee that the
> patches will go upstream. If in doubt, please check the listed branch.
> 
> [1/1] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
>        https://git.kernel.org/mm/core/c/d8d12d97
> 

I tested Lorenzo's posted patch on Linux 7.3.0-syz-13001714+
with CONFIG_KSM=y, CONFIG_KASAN=y and CONFIG_SLUB_RCU_DEBUG=y.

An earlier unpatched run of the fixed-pool KSM/mremap reproducer hit a
KASAN slab-use-after-free in page_address_in_vma() after about 342 seconds.
With the patch applied, the workload ran for 12 minutes (1027 KSM full
scans) without KASAN, BUG or panic. The fork/COW smoke test passed.

ksm_functional_tests reported 8 passes, 1 failure and 1 skip. The
"ptrace write failed" failure is a known test-environment issue; dmesg
showed no kernel error.

Tested-by: Zhao Gongyi <zhaogongyi@bytedance.com>

