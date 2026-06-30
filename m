Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EBAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B556B00B3; Mon, 29 Jun 2026 20:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242DF6B00B6; Mon, 29 Jun 2026 20:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1838D6B00B7; Mon, 29 Jun 2026 20:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E887E6B00B3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:19:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DBD61C67F4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:19:13 +0000 (UTC)
X-FDA: 84934669386.19.F8727E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 39450100006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:19:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nv9rkHwL;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778751;
	b=FSCDZKeLH2DMUAqz0BL0cO94lkkLZcaZKRAsy0kLOm00Xuriflv7ASY5Tou6Pxc9S9QWtA
	L4BtGYiIiSg5KHEjmsL73/6Mj8dbE4FFGo5c6PXTrDnjgMI3ts58kaYa7qpLD9yQug4NML
	fTQ+CEArm0Us7Bs2Zkw6dpScnFnH1iU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8J7zyOljJxIqZB5f7uwdIkFI5+z/zXnpkVRuCp1TkU=;
	b=q8mEIV5ljMme/s4hQ/lYQuNKX5v7MzqBifeM0dLX+fkPrivN+te2zMFslYtNOiLsP9QMBv
	aciVJeM64LTFH2bJVrgfjvD+gjX5b9GKndHOXZNxI+VVL2wQfsTfWNkTLhXciBBOH5XDNJ
	G2IL1Gagqmji0jT1Mu9NDrqTLnTyc+I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nv9rkHwL;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1926B40967;
	Tue, 30 Jun 2026 00:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A15A1F000E9;
	Tue, 30 Jun 2026 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778750;
	bh=D8J7zyOljJxIqZB5f7uwdIkFI5+z/zXnpkVRuCp1TkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nv9rkHwLKumPriu4HCUOBpBwWTkj8j7Oi0Qpx09LjAX42ImcenX3nSswjKvLS9ewS
	 Rr48m2UzsJKtSW0rKOoiW5ZPJFNxG+cUZgxFtrpIpG6tve4XaoJXIEmck9twg191WB
	 z7b68thqB94mCvK4qCcrTf33doOMfHBBD42c7rCI=
Date: Mon, 29 Jun 2026 17:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, Guo Ren
 <guoren@kernel.org>, linux-csky@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
Message-Id: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <202606291606.9h8aGniQ-lkp@intel.com>
References: <202606291606.9h8aGniQ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5kersdf7mp3boqsof4znq16du19wtguu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39450100006
X-HE-Tag: 1782778751-531698
X-HE-Meta: U2FsdGVkX18EqGmKLlpO2SD1E4aaqbu5Lac+CiOIdPdNAqOH8d8f4KNyTXDjPJhDK5U4LseibLE3ddYLGMi9BZCabQGmcNczhnDXYK889B/lbPKdfuPX/JNilkXjr6fhPJPE5O/x3dZ1OBiQ2B7zwXZFZn89TMcs71USqG4sgFpXHLUNbTCXrBvh0VjD07Jkz3fls2vo8Ak4DqeYI8UjWIxzz1yoP+l4It926I+6k37BFf5zHmW0EQa5Hmsc41sEcFSP7BWgrbQZWq4wJPc2bH850JsDadsi0Eal1FY51feKav8AWjZp9qOqCeDZvlEQ3rFw6QKGX4aaOKg1W0dPxxDknismAYrlB6fPU3t0Vm0Ezpu1bt96qAsfUHMvDClVmJOiQk15HQ/1apb0KR36pV3XvH84cbr8FiYd2BRP5PMlawHECtvLzaF2YZZjUAKlRwdMH9hHO6f+u0S4ib4eFRzkVgr0WBFgD+CA4WSCm6ooGDJ7hSiDR/I7wma/exsNdNmiP8+SEY7mmSSx8XnmPBTzJZcG2AynaKpyGWlRAKHp8p8jaAbUUa2ArryWpSjQMowLctcFLr/+86wF9mk3gglN8y4jc82XFWLfHFjakOImGmzoQLjIafJWLumIdVObiVX8AdttkCOBwkGseaFejNuKyHrjEVH9UVscK14rWFgN2DLkifJouvRK9nYJUTOCBK2f0P5PkmdtFTvBcX6lo5QdJXxMaab9ss62UA6ljJYknHzwo2cCN07GPXO95fXaYcAcPQD04LEqzOf7ehTwDEaQZdOTTR3NLXLAEmUeQDSAe0KHpLQ27jhc/uQy7ywvYq8FY4umGhvQRtQPS8Dn9srYvU3Isoy6EaBuAs/lwfsp3QYdoyLtIhrrNFrFa8XitNIVhOv5Ro80CGEnWxjy+zsolJapy6MUVW34iqqfJLtLfpwG+hzh51L9UKDzrf6/1VimcA5nLBmxickeAyL
 njllTfAu
 LasbAvF/TpAChH/841nB26yc2nTFGe17bkDUqbR/4GDLY0DOF3K9ZY4evWabDar3TMYCa0CdnLE4gOXoW0xisBLN9uqEPtMoAVArqdwVWt8WzzgP/3uK04xss+TQbg1pNBjvhYSubhbojv2GR1rKkCFQv/4xSMzV6N4m3CFdtxBBs6py1UAL8wKH9WH6bLrFKLl7DH4Oh6Ut4SyHVUZkeW6w+j+HgsimD6id4RYMu0XYkugMxr0kwAlm9EeKwPfVH4onOr5uMznA0y1bDxYvaNFAQZ8pQx+4SHXqGhkTXCeGT/eRsnCq7ithEansWa1xDOg1GARuRzjDukJs0OtxjVTVUIV1iBbg9PHDpmKuCaslA2c58wmsf1OHEbAiMLL4dC/F+kosXbHErULHlJDt/8WAi4KFRqZap9sI4pGsBrCDJK1znbu6Fr0xfxppragFRnLXo3cr9viy+vz/b7Q5ShV0HCy6OE9yxDU30KUYbe7du1fwf2TD7Cu/nz4T1P6dKyTj7yihcVUAS2h7Fnxe/wKOOxND1vfZpasNonjC5+JLp1QM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 16:58:34 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   88cefc306c43b58d9bb65c9e96e284306710d961
> commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: map contiguous pages in batches for vmap() if possible
> config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/vmalloc.c: In function 'vmap_batched':
> >> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
>     3590 |         unsigned long start = addr, map_addr = addr;
>          |                       ^~~~~

Sigh.

	unsigned long start = addr, map_addr = addr;
	...
	flush_cache_vmap(start, end);

See, this is our punishment for writing kernel code in CPP rather than
in C.

I'll queue (and test) the below.  It should be OK -
arch/csky/abiv1/inc/abi/cacheflush.h directly includes asm/cache.h
which declares cache_wbinv_all().


From: Andrew Morton <akpm@linux-foundation.org>
Subject: csky: implement flush_cache_vmap() in C
Date: Mon Jun 29 05:07:51 PM PDT 2026

To avoid getting an unused-var warning from

	unsigned long start = something;
	...
	flush_cache_vmap(start, ...);

Cc: Guo Ren <guoren@kernel.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv1/inc/abi/cacheflush.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-flush_cache_vmap-in-c
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -42,7 +42,12 @@ static inline void flush_anon_page(struc
  * Use cache_wbinv_all() here and need to be improved in future.
  */
 extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
-#define flush_cache_vmap(start, end)		cache_wbinv_all()
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	cache_wbinv_all();
+}
+
 #define flush_cache_vmap_early(start, end)	do { } while (0)
 #define flush_cache_vunmap(start, end)		cache_wbinv_all()
 
_


