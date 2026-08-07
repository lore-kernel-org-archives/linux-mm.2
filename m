Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE868C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06C96B0088; Fri,  7 Aug 2026 03:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE6C6B009D; Fri,  7 Aug 2026 03:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7ED46B009E; Fri,  7 Aug 2026 03:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 805786B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:09:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA34440296
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:09:44 +0000 (UTC)
X-FDA: 85073598288.05.77546F4
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id A07B940007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:09:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Qh6BCzQc;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786086582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpeOcxycXBTAlw8xEd8qyVhgpwcjWFNB4soWtck85Pw=;
	b=AfGi8+WSgUl5jNPtMBjyoIXyYP7ssG8Qw4+xtZVMlu2hKbZ9hCk1PTIKU1eb4fyGYMgII2
	8mva63jwM3yTSCHyEYZuoJyEPMJh8XVMcgTGs3wpEGr27t4UgZinz7hFNb13r/ZbJhG9C8
	82xKWJGWXbDjCj+IN4/q05HfvshFFLg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Qh6BCzQc;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786086582;
	b=IY6W0m+IyxJAUkko2bVLXBkNVra94cUsgQDbte2aEzZHs9mnhLSIFcX/lkhfeI5UOt7uD2
	y1Pv4fg+E4NGDRJHjIGYtUwFeKNzTmzxVwmBUjfTRVg1q/R6dSy4j6K8v4EcSzRU2d+zuR
	EQuOZFtgPSUoKFrHnJeq1PcunCSoVeQ=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770JZQv4064146;
	Fri, 7 Aug 2026 07:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=jpeOcxycXBTAlw8xEd8qyVhgpwcjWF
	NB4soWtck85Pw=; b=Qh6BCzQcqD/AGOqi1hTQHgQVz6HuWuBJB87Gbu8R2QRIrL
	ftEfzBmybSkNntrd41XE524cbuEjupU7byCqaB7YxW9kBgydkUCxBhrhTSiwT6H+
	U4OKIllzATyLLGfNArjEOqj0akgLZ0asqOkSM0XKJyYYoIst8JvDseeB2sH706u4
	hhs9ueI6JSC+Ld/f6qPFOuLXDpab+v18Jf4LeEQIr4j5+MFCFi1kjnwg8/MvRqx/
	KhT+u3vzeF7qrRG7dH6ram2Pu9RQGcAByOzaawNWn2aii58OGSRM1hM7xmzHRjNe
	Si5vdvDt7lOVvC8K31hkxayAWljo7JjlQf3ZTeQg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy02anmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 07:09:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6776uIAD024920;
	Fri, 7 Aug 2026 07:09:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhpmkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 07:09:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67779F7T51315084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 07:09:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 668A020040;
	Fri,  7 Aug 2026 07:09:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA50320043;
	Fri,  7 Aug 2026 07:09:12 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.55.180])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Aug 2026 07:09:12 +0000 (GMT)
Date: Fri, 7 Aug 2026 09:09:11 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        David Hildenbrand <david@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
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
        Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>, Mike Rapoport <rppt@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, pfalcato@suse.de,
        ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 1/9] mm: introduce hw_pte_t for PTE table storage
Message-ID: <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-2-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806083926.1807279-2-usama.anjum@arm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G6ws1dk5 c=1 sm=1 tr=0 ts=6a75849e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=7CQSdrXTAAAA:8
 a=knT6YJskkHJV9nTHl7IA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA0OSBTYWx0ZWRfX0nP+lx57+9VF
 1gmEHMdPT9FDdcpiQyi8SmdcwszvdSJS7mABzCaLeNrHd5Sn8+sTGSPk7wgKar3hoAN1E4B/pVx
 bnXvboS9h3/hfmNoqiGrVCRZoMjtdCQHGGcTi/BUQBFwhU3T8reyBMtbDszvLlwmh+wtmaSZLqp
 yvHKwixzlq6G3K0WuaMTKb0rV/vx4p/+UD+c1HQ1XyaQGUDlAtP+qGdAxuohRKj+obB6JSz4pJf
 zR2/7yIz+BcCrmWWxRtyEAkQu5yJbla8dkOuZTNT+Te2QfvIou3iP7qEQNN4GRIU2Q5uHMR6b+I
 Dj47k0jZ1vEd4+qsmknTL/rQ5DO0GSFvsjQsVYtZ2xV19zVeKyvXq+fRINOYMQUEmIHFL/MkEMn
 a61cmrTNbkwX+us4u3c+MP3DMEixACEHjWeKrnFUAYotTcrys6EiCMj8gXkAJjhYM+ZfvANLuAs
 LDq51urlTaBYjwemYPw==
X-Proofpoint-ORIG-GUID: 24rCQEgxgE9QBP75I4HmK7CgK28n9dSJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA0OSBTYWx0ZWRfX1i5aYO825ZYa
 TwQN6H3jwP2QZ+OLP/IGdT3C7Slc5GOjV5747KQtgAdatwi/16p60JYaM2efb4DysHgyipihWtH
 8fPlfABrpBSxaw7p4kLOdK2+bYjkzog=
X-Proofpoint-GUID: 24rCQEgxgE9QBP75I4HmK7CgK28n9dSJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070049
X-Stat-Signature: qe5h4xgijcng7xgyk1ncw3qmtnstm6bd
X-Rspamd-Queue-Id: A07B940007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786086582-163509
X-HE-Meta: U2FsdGVkX1+7vWEnRgIKh+gmA9UJgGd7Eg4twVIQiGJtFButepN3RX7W19szi3awxzdIje3UT+RYb0GROAgw1f0TUfjueAiBTQxuOaKikMqT2E27B9Z5uEISg6Q4+P83Rebnf8ZVDNB0+leCXzGGFwA01NzabhQ9FJ8Ra+Y4bRFhnZyU7d51Xrv49Yez4404pim1VzuSBDpsm4sO+IgfVVssJbJtPRXCqjUCrMNZCa/l42j3M9QKkgUCVsGwlDBn3v/5rjPkfZTr4eETTBssRNXifYDjBaO+EETjUd3VlATVvpArD3g988mWQYI94ja+h9F016XL9s1sbJS4d0Vgy2xQ1NJ7CGn810Ewqz8d27S+IPCLfi7otzDxtrqBuTM1T08F9yM8JRHfVkdvxVJ7Hrn4jmsKRX2DrR7khZMk2qfUzw7Ccca823zXgvalZ35BS+qWhDc4+WNtxI053Pk6+2wdlNGDAi+APhnbIWEsZl7ea8IScsH5q8w4y4OY62gIgANQvpa/xzJRfGWel6LfYuBS4C2NGrr0aKKHxj5Rog56ud+9Od/Z4rmeKl32dZ2THZAWQjCDTNksn6TjEoOegdKDsFV3+F69oA7vFM7atoF+jEMtn894feFhcp5HPXEK7/tjYgMnJYBiwsyA1OzfZn9sUPT5i4s8ITYU+TfFI4v3dXBjKMWFurvVkiAmGWPiNwotQ2Kcq5cTTcufFA24v/9Kkj8OOQKkVqG10xDYOlXnBtUZ4i62k7k9kWZ8gUrsWMmc2zErTxYcA/hSe5Jij9jE39oJ6cCI5wXRzAOXYwEQcaoDV8Hb9RwaaueHCYGkvwd4bqCy/5lzEdlrH00mu34efSYhQ6+LIeEvbxfJi7nuen8XUrvBuzJ742jFv1FrVkwBUR7DJTsFLxKzbhiGXWAcyUOPEMHnIMa4GfibMD4dMOWqCsxOPEEfOuTytO9Q4yU7WpOekCa5qtr5Atl
 qKpK8dKx
 8Rii1nxg8grydzQ+nAs9FzKoFdYTx9SwiKOo766dxfeLOdt64YnVjjYf06vgm9ejnypgPg5Sv/AYK03h/+S/nTnghGCD7r/M5x8/LoEs7985LG0BqL3ezdd5Z21MfBvHfv2ivpt1u4geSXGoTks34yaUBZ+R7lU+4NbSUC0JkQ0jIp65ewm1xQGqc62+DyskMEfE2vPCKK1Et4bOvew+vB9v2qMOnsxpNvM14Wmm2Jy7H2tPURuEmqjl01Zb6LGkfZV6NjjCFbJZQG0kidyqxciBG6yndboVyrDcixSmIF3ehul8Z1hEwz2GAH0k7ZalmNMpjFzjPyOaNSMlEHjI29IgXY6rlDAR5XtDrJ4Ecuu21a7Wg33GMxhsNGbnxWTmVqkdLJCSQctVCeyjtu1bHv6TTeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:38:39AM +0100, Muhammad Usama Anjum wrote:
> pte_t is used both for logical PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a copied value from a
> pointer to table storage.
> 
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as a macro alias of pte_t by default. When an architecture selects
> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> This preserves the representation while allowing converted architectures
> to enforce the distinction at compile time.
> 
> Keep the C type definitions behind an __ASSEMBLY__ check because
> architecture assembly sources can include this header indirectly. Include
> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> they previously obtained from that header.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since RFC v1:
> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
> - Exclude the C type definitions from assembly sources.
> - Update the description for the new opt-in model.
> ---
>  MAINTAINERS                   |  1 +
>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>  mm/Kconfig                    |  3 +++
>  3 files changed, 21 insertions(+)
>  create mode 100644 include/linux/pgtable_types.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e9c8567308a75..7169bea968cf5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16982,6 +16982,7 @@ F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgtable_types.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> new file mode 100644
> index 0000000000000..70c3edd00a01b
> --- /dev/null
> +++ b/include/linux/pgtable_types.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PGTABLE_TYPES_H
> +#define _LINUX_PGTABLE_TYPES_H
> +
> +#include <asm/page.h>
> +
> +#ifndef __ASSEMBLY__
> +
> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
> +typedef struct { pte_t __pte; } hw_pte_t;

On s390 it fails to compile once we do typedef hw_pte_t *pgtable_t
in asm/page.h. m68k, powerpc and sparc may also have such problem.

The below declaration helps to resolve it using forward declaration
and without meddling with headers, though I do not like it much:

typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;

> +#else
> +#define hw_pte_t pte_t
> +#endif
> +
> +#endif /* !__ASSEMBLY__ */
> +
> +#endif /* _LINUX_PGTABLE_TYPES_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 331daf7fcfab5..31ba9ebf4aafd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1316,6 +1316,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
>  config GUP_GET_PXX_LOW_HIGH
>  	bool
>  
> +config ARCH_HAS_HW_PTE_T
> +	bool
> +
>  config DMAPOOL_TEST
>  	tristate "Enable a module to run time tests on dma_pool"
>  	depends on HAS_DMA
> -- 
> 2.47.3
> 

