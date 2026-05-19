Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F80CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3596B0005; Tue, 19 May 2026 18:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB366B0088; Tue, 19 May 2026 18:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007A66B008A; Tue, 19 May 2026 18:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8FC86B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:26:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 942D2140336
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:26:24 +0000 (UTC)
X-FDA: 84785604288.13.0317BD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89FCD140003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:26:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZzvwMdv2;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779229582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk/txucGLQIwsHh8NH2anDLZuGTDy7f0hjWCFl8qpjQ=;
	b=XimsP3CKxIWGx+qwLIvmWsYgr+tZK3ZcRxsrxDtFQ1ThpBtV9Rux64Pd8CcaZ6gUq1urGb
	vVQ9tTI7pesl5oCakGKNX73NM8Qci20PkH+/sjVz0owqhHhjPlvJoisuHYrm+XgLNEV/at
	+pS+SjEWvCc2HTVqJhj/jXZlczl3LIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779229582; a=rsa-sha256;
	cv=none;
	b=qdf86zHhcX0CLYhQfCrdXcfML/e7tAE9Nh74FF7NTuMcjNarx7WxvrZg60ooXY2FUtMoBJ
	GrwHPdOS9FmL33QydQfsMqQMLVthOW3DS52Octv+6S34SbtRPtEMjubCH99PwZ6VB2JKIG
	3Vsj0lzx7m8tWx1L2DVm7GdfWE2RFGo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZzvwMdv2;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DE914084F;
	Tue, 19 May 2026 22:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F671F00893;
	Tue, 19 May 2026 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779229581;
	bh=Hk/txucGLQIwsHh8NH2anDLZuGTDy7f0hjWCFl8qpjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZzvwMdv2qcDdj7qN8WXbj7Vgu/V3Kn8NhOwDqn7uSLIFDOATwv0s0SzGIG0Fd1zFm
	 4AR56iEgcNaCFu/u8nc3Czeh+99JK/yAR8QIVP9FM9nx6vv9FEWq7n4LY4z9FCI4U+
	 bLGSuDn0wC7EwVNm11kE2RjuJKRweLIr/tBHPDJ8=
Date: Tue, 19 May 2026 15:26:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Kairui Song <kasong@tencent.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-Id: <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>
In-Reply-To: <202605200624.e9eMvkBW-lkp@intel.com>
References: <202605200624.e9eMvkBW-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 89FCD140003
X-Rspamd-Server: rspam04
X-Stat-Signature: mut46p3xcfkagd7om75qp36paoc5eiez
X-HE-Tag: 1779229582-43508
X-HE-Meta: U2FsdGVkX19ZFpPEi0/yQGRuIZYbl9sgDgUcBICyomHJwv2jy3cSN7Qoix4euwxwtPOeiQzndH40yhIJ9xFIbxXf/lfRyj7Zp4PmZ7SlqDfucuimVQYfOBWyaRjv/u7qyQlg8YPXk8AcApdG6VIqYGsyrjtzaDuqEGXrDbJZIUsXP5MNBDSoO5QUBi2syCKo+h3kTOwGqRF4q0PHWpbJ403/JhSei0OmqiHUnNhdC9g+5JzeLOhYaDaJ7gXC7+MPUaepbP0uPkhKWqcxBnQAEkjy4/f2VFiT+0ehEBNuDjk9BZgskMV06J0YrLDQEvXDzH2RT21d21Zo3OUfprnAP26+zQ0maf0lNqEpW57ugLjZl4vQ4P68OimmAiczhS7IFVkack9osIWVx2xIAdcqYmp8T0l5AVOziirKN0z2tKZrTB73KkVagWYuzJIU5LV7F9NAGJdPrGlPIpel5PAr1Fp7ZHKK8zGPUf5/2snJoE4BBVPZesT/SFRAtB3vaHjWXpWbOVnEYwjLwPjfMRtg2jM+tKB/e4/BIowvskM+23aNQeeTkqqfY/CdJ5dtk5uzd168RyRJTj410nCogd3RWlY9yaY0/BxGZdHpi+KmNYiM77i3Ecz8wWe3V8KSktCvBgvZuLMQ5MOwgy4HrTkgh0o6ZvRJSVhn6lc8IRiiRKjD+rNPlZxoM6foxcE3Rm1H5EereoQFnHwduNJLAx/W7sB7+8UC0fbOZ3ylEoIY83KjVaTPlBElglmxGcrtTwoL59DzCBRVcRpm5X6zXCJC1zUP/wDx+n2TZzPOpZOK+GZfCtvmr9npyMSPD2q2wTTkKfY7PlBVZiBBbCxIl87imdRE63iQCqY0mg4lWwfBuCUMF6vynqOnNvvwUR1W3I+3SuzEuBOXYWXQhRcZlP95lSq/I3WCqSJVdi8clEDf1Ui4kFD1EQhBl+4zAAMxg13gShe2KeFdIfJ+ALYBMMH
 T2ngrHfd
 czb1BZ+CYnAGhV8j844icCu6V/jZpcsmNGkL5Dz57acbP6IES6x6/PjflZnQwTULp/lbtJjOeTPrNko5ovDVmOmJoD/Qv/7R9jqnd+YYqC98Ho4zaOw8QeaSDwZ1+lhUjvYeZwXHGVVnVnBqK0AelIpaKsQkJvG8L5Qii0ooAO3KNPtdNeA0i93emWlN+HbrQnuyYSa0FCH2d83+oZySMnz6ACvFEBhNj0ydqbdCvRQkOQYX9SpiOyWL2w+4qZXPGLuKEimLb7Wb6nGWubqJ2j5EVCJ/KnderUYykvhxhtbheTaGyTWh2XaoHh+ZAFKnylpYeeYxRS2EpIqeWNnRwvww4oY55Mu/FKH5FO7BGMELX58UPyjdDFKjMZgoUWszQOXidvZkIx9j+Q6YiX8bqDm13ywImh/XjgaluVAWluoAuecFaPSHsL35u3SItVEABUXyZaRvWwO1H20caDm9ROlmthgBrWXCYUP2o5yWARAj4vp27xBTF7KYL5lkftwuVupSr9WRLEbHUnLUQYPDFJzKwnyFTjKvhA8iEZ/gzhMEs3owUfobXTQbRh5Dx03ZxQ/ZcMJgvjxFEENWjqTT3btYsa+NA3OzpeLhmmOCNcIE48dMU+bf54Ln7N/jp6hYcRQ2QoR3ZbH282R+52H3y6mDQ6dA1iziT56yUwjyRTmc0zA1IkA05lV7DWKJ6t8Zj2+QMBc/Zry91SMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 06:16:25 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
> commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mm/memcontrol-v1.c: In function '__memcg1_swapout':
> >> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
>      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
>          |                               ^~~~~~~~~~~~~~~~~~

Thanks.  I added the below to fix the build, but I've no reason to
believe that it's correct.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
Date: Tue May 19 03:23:38 PM PDT 2026

"fix" CONFIG_SWAP=n build

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swap.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/mm/swap.h
@@ -482,5 +482,11 @@ static inline int swap_zeromap_batch(swp
 {
 	return 0;
 }
+
+static inline unsigned int swp_cluster_offset(swp_entry_t entry)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
_


