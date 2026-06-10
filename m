Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7EFCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 06:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BA26B0005; Wed, 10 Jun 2026 02:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924FA6B0088; Wed, 10 Jun 2026 02:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED066B008A; Wed, 10 Jun 2026 02:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 698A16B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:29:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F23291A088A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:51 +0000 (UTC)
X-FDA: 84863027382.18.6305947
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41DD314000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjycE5Aa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781072990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nXhoKBKFsBSVgBh+Kydkjm+k3Aw/b2vmM+J6r2LJmuo=;
	b=sTelgEvw1tvDivmbKKU1qk8zHHwoAAZfOfblCtTiy+GF+9HtiXeqnf1ic1ld5pi2yegPhS
	QkkQiddJpY1w0zOyJa31YyTM3Cs8DVmRjZVLBLK25zIHBCf+3kLrVQaSCzeaZ7Wu7K8MJE
	VC4bg/rJpm6vt0PSPqnq3uSXMNUABlI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjycE5Aa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781072990;
	b=sGVOhtsoA4PE7o3y8hnwQ95A00NGvtEuhwWdc6mNjbI0k6B6TE/Vg0alMTbCIsP6U/zBuN
	pEcFOBP+09hAwfk062NuM6wdk3/QeXB1ntPyf2rKPWDVBDaFJar1431q+dVmmK0o/+Yy7v
	xSBOFUaRdwHRvTqKqKx63nY86GyRfag=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c859a374903so2238171a12.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 23:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781072989; x=1781677789; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nXhoKBKFsBSVgBh+Kydkjm+k3Aw/b2vmM+J6r2LJmuo=;
        b=SjycE5Aa4TKH+YMoYITFeyM3ecpySyf8rMlxMFDlgcblNB1z4zMMSNqpHJiC3+sP1k
         XWFrnhn16LceOdftXFPt4Mwf6ImPouSsv2hnrfTtcM4G/jpBWl6Xu4DFHNXpC61eVILl
         4OVFfd1U85AZKHljrqIcd9KNAT8xKTVEqbBPMmveJL8pAzYYjUCbBE/cV3tcIgHpOC/E
         kF35Ap6oUM8XdAxNtP1zw+2ocAUG8q9Nur++h2GLQyOFLWtvxe3YaZh86lWo2Sd88c4I
         7vxmbCcNeCzzHOwJzHCItulrnM3Nr3+vvltTj8zlEArspB++To/4AxYurqrtaM83Z2os
         Lgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781072989; x=1781677789;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXhoKBKFsBSVgBh+Kydkjm+k3Aw/b2vmM+J6r2LJmuo=;
        b=dJxG/hdgCBhuUJ4XGVCKX9wGzbSm5IEQ/DgrRqYBkQC8lYKZcGrI6oG3yvBpMgjq8u
         EGUGnPH0DJ9RhwQSGKHoq70x4nziRbht4CXwtwJJEZqbiKreHeYCaUedlThXLbUSHTKl
         uNhe+gu2ATg/uvjAr/widw5+drpMBZq2XJDSYAP2qycPfoIQhwr6xrYsY/PIG9Hid6TT
         4MBXdsG3ISlpM3lqgR1/v9a4GlQ+LGQoZCldeiSefx5Yi81C6AkQVe8brec1J1sNMmfr
         GzaYJsGbW2IwL9wBDBZP9Vdr/5jpRAnn24+84XzqELuH9qY/fSck20vTtstrcBm72Sc5
         rbsA==
X-Gm-Message-State: AOJu0YzQQM9i4uYqYYsZOJNf0OImTjRF4/i3qigRzeFQM2sCvfejNvDT
	4fGyKHo9d7q1QsaIYXZFPKntfOzZrvGg+iZf6fFl5WPF0Njxgg2lqwKz
X-Gm-Gg: Acq92OFSQR2UjVW64iOCRKIs8M6tPRMaCf0sd4z8pVj9cgHJmG1Ag4oNCdrbExidU3F
	won1H3UtewuL+RFOVFAmDIJAiTShmxmKoSoAajrGQjVwZs1Uzf8KpoJZ4brg1Pm9BvwXDZf3pX7
	YfRUNgYfp1urCBQSwWS0DAT1ehz9Xk9GhwDhwe04CaeoAgJ2hY74T3WZplkytXx6e0igD3zwEh5
	/Pvjv6o7muNV/ESiffprX/B/Z4EJYOXkDnVN1BOWW85ET5fae6wDq3G2SlwEaxtsYsmjKWFTFIa
	rTwN7xaArMTIE/EQeAHDquDMS6y6wZxmfIAjeKtcdzCqDEhFr7ctufBjSNZ4mgUs2G58+7OYQdq
	5MS4xZvJwCsfVttRlTydTiCimcoYMUgjbVt14HZMnXhLlV29F6HZ6QTHIrrz0SXF1kf1VMTOiqW
	eav1vVpA5SkBf6GtU/X/+goLWS+1l2XaLx
X-Received: by 2002:a05:6a20:1615:b0:3b3:1951:489b with SMTP id adf61e73a8af0-3b53bf75f2amr8504650637.45.1781072988909;
        Tue, 09 Jun 2026 23:29:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df04a0e9sm17535932a12.13.2026.06.09.23.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 23:29:48 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [RFC 0/4] mm, swap: Enable THP SWAP for PowerPC Book3S64
In-Reply-To: <aig3PFm9jst8cHxn@yjaykim-PowerEdge-T330>
Date: Wed, 10 Jun 2026 11:00:43 +0530
Message-ID: <pl1zdksc.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com> <aig3PFm9jst8cHxn@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41DD314000F
X-Stat-Signature: jrbkj37hfc4rpi78xswmsrdjtheepkoo
X-HE-Tag: 1781072990-26565
X-HE-Meta: U2FsdGVkX1+t15+4Gen7ICqx8tDJIeWg6zpOGmcFtVbwUCR/NSadSm5IrIQ+20tBOjwkk5UAJtOhv7YxDM8d2z+J0JMvyCR5VmNSdcBtLCB2NNb+6Sh3CKIx0RuGPXBGAePRb8UzwSgHeBHLaOD2wIFcKHlMcwfdwDbvEFMhc78x9FWDDdAAAjfK5Mz4L9ExmRoWzp7RUV/82zV4IVYo+1XsP3WLoZ5fPLWKcqNWiLu1t1iOfPVCwbBMbYRnWANXywA31iYgf3iG5jhMfjPwNAPaglqi4PDftxQ1USvo6MAqc/y3D6AY4Dng7KZHpkRVIz/51QSNbN0doRZWLPll5XvBeK2aZ3nZs+m0ZojSKlhQ2kAvZHI910DBBWVNA8QTNN28Dl8YB8Rj5donQvjzKKr7T2PbbxrZYPeeVUxUMBf2Y8zPR0bqPaKnzNi1PzyV/99sMxQPnIjb0MGgkrjcc8WPM13kXSvY7iPlXup79cCs3noSbwBoU89UJI/WwXcmsQgQaCCGBSNmJPB46e3ftJ3Bqci1ElkyokYfZAfamJXd8L+9jVWNvKGCmAHLWolzb8Ho1PkI8Wf+jpHxN/vnBl/UcsMrXDvradXcpUbNi7nUQpsAYW5vmop21kx27+vT3KR27ssbTu2phTEa1kgPRJvA82s33t2vi1T0x6osHtezJkMrrGfS49mIMzckkRZ073owDoEi0a/OA+dk2ep+bnJtyULm9ANqhHUacs6pZPK5zAcJOA7l6W50UOxSD+QSUiz84s6l0fEGNg7hkurBqeW9kNdEbLsv+JbPfyzqiY+HjBDw8WpbC11CE5Zi0G3jTmFC/yYp6MTYs7zQN+G+ff9nX/u8NvDgcdwEwQemsNbHBcieLZFImSFq+wyrY3INCzsKurB950OZStQX0aO8tceuZO6Mvprg76dKGooVu9k1sawmiDINSrMqGVRRk0lGgMGj0+ksfkVvf7W2nlo
 o8FhgC0M
 W6inwL5Z+4gexV03UKY0gVpYMui+OwtPuLSTY55ARi8d89ttSlIuQzxfJAM9FywA/vmwdZIeONbdRI98vl4Ahf6ItLUfBFdWEu9v8TdZHVW8Jz5Mzels4+TrsFatjc+EArguJyMLVjiZEPU70eVPcGojUL4xmpj2dmY160JHEdCouOG7MgFOfp64MgwOXQxZi2IDPuzyi8GDevjFoeTi6qKObOpwi4Z1Mqrao9/G1eJDWlc1GDYOhewxLpL2oOcsheJG3I/8vw1IlCW3AJ9ZNMUFnd+BBh+S0vdaLn4TuUIIPNd2RgORhbSPCPX/3kJY3GVUSs7/RT+sIYY9PmG5n0/Mj+xfuRlGnc47F5Yo7KwogzIhD/hF1XOJnUZ5pS3lRwQbLPRgpQzFxPQ32JcKT0SYk6sJn+uyBUq10FEOTmgmsCf1N9liobXGQ24DBTTAUthNPe5CPXWfsMIopij/uH/CX71a8H3YPS7lGq3BEPnPPLsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

YoungJun Park <youngjun.park@lge.com> writes:

> On Tue, Jun 09, 2026 at 06:49:30PM +0530, Ritesh Harjani (IBM) wrote:
>> On PowerPC Book3S64, MMU is selected at runtime, so macros like PMD_SHIFT are
>> effectively runtime variables in the Book3S64 code. THP swap code uses these
>> macros for e.g. to size some of its array data structures based on PMD_ORDER.
>> This patch series makes that usage dependent on the runtime variable.
>> 
>> Sayali did some performance runs of this on Book3S64 with Radix and it gives
>> 40-50% performance improvement. We also plan to run it with Hash, will soon
>> update the results.
>> 
>> Note that this patch series is based out of linux-next (next-20260608).
>> 
>> Ritesh Harjani (IBM) (4):
>>   include/linux/swap.h: Remove unused leftovers
>>   mm, swap: make SWAPFILE_CLUSTER runtime
>>   mm, swap: make SWAP_NR_ORDERS runtime
>>   powerpc: Kconfig: Enable THP_SWAP on Book3S64
>> 
>>  arch/powerpc/platforms/Kconfig.cputype |   1 +
>>  include/linux/swap.h                   |  17 +---
>>  mm/swap.h                              |   5 +-
>>  mm/swap_table.h                        |   6 +-
>>  mm/swapfile.c                          | 132 ++++++++++++++++++-------
>>  5 files changed, 106 insertions(+), 55 deletions(-)
>> 
>> --
>> 2.39.5
>>
> Hello!
>

Thanks for taking a look at this.

> Instead of making SWAP_NR_ORDERS fully runtime, could we set it to the max
> PMD_ORDER possible on PowerPC Book3S64 as a compile-time constant in the
> swap.h ifdef block? (My assumtion is PMD_ORDER max not too big.)
>
> I think the general runtime version adds cost. It impacts all other archs.
> percpu_swap_cluster needs a runtime alloc,
> the si/offset and nonfull/frag arrays become separate pointers, and some
> accesses get one more indirection. And for nr_orders=1, the allocation
> itself is just waste. 
>
> With a compile-time possible max constant, the only downside is some acceptable amount of
> wasted bytes per CPU / per device on Book3S64 (the unused entries in the swap
> offset cache and the nonfull/frag lists), with no perf impact. the perf
> improvement comes from THP swap itself, right? Other arches see no
> impact at all.
>

I looked into the memory waste comparison between static v/s runtime
alloc. And the wastage for per-cpu alloc data structures (with Radix
MMU) will be 0, because we use kcalloc_node() which will use kmalloc-64
slab. So slab padding would anyway add some memory waste. So it is as
good as using static arrays with some max PMD_ORDER for the
percpu_swap_cluster.

For the other lists you mentioned, it anyways adds a onetime negligible
cost which isn't worth for making SWAP_NR_ORDERS runtime. 

> patch 2 looks fine as is. SWAPFILE_CLUSTER backs much bigger per-cluster
> arrays, so runtime sizing makes sense there, and it looks like no impact to
> other arches or the current code.
>

yup. That make sense. 


So, unless someone else raises any objection - I will give this a try
instead of patch-3 in this series and will get back with v2.


diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..57abd8b2c9a1 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -204,6 +204,9 @@ extern unsigned long __pmd_frag_size_shift;
 #define MAX_PTRS_PER_PGD       (1 << (H_PGD_INDEX_SIZE > RADIX_PGD_INDEX_SIZE ? \
                                       H_PGD_INDEX_SIZE : RADIX_PGD_INDEX_SIZE))

+#define ARCH_MAX_PMD_ORDER ((H_PTE_INDEX_SIZE > RADIX_PTE_INDEX_SIZE) ? \
+                               H_PTE_INDEX_SIZE : RADIX_PTE_INDEX_SIZE)
+
 /* PMD_SHIFT determines what a second-level page table entry can map */
 #define PMD_SHIFT      (PAGE_SHIFT + PTE_INDEX_SIZE)
 #define PMD_SIZE       (1UL << PMD_SHIFT)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 46c25523d7b8..5f1451f8f266 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,10 +224,14 @@ enum {
 #define SWAP_ENTRY_INVALID     0

 #ifdef CONFIG_THP_SWAP
+#ifdef ARCH_MAX_PMD_ORDER
+#define SWAP_NR_ORDERS         (ARCH_MAX_PMD_ORDER + 1)
+#else
 #define SWAP_NR_ORDERS         (PMD_ORDER + 1)
+#endif /* ARCH_MAX_PMD_ORDER */
 #else
 #define SWAP_NR_ORDERS         1
-#endif
+#endif /* CONFIG_THP_SWAP */


-ritesh

