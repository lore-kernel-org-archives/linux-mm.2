Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DD7C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105E56B0098; Wed, 23 Sep 2026 07:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF26B0099; Wed, 23 Sep 2026 07:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7DD6B009B; Wed, 23 Sep 2026 07:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4846B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:53:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 552C41C33B2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:53:52 +0000 (UTC)
X-FDA: 85244867904.02.31CAF51
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 09AF840003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:53:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Ip/9PsmL";
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZPR253R3+bl6LyBiXW5gQAtjY6DOY80tr7PJYJoSn0=;
	b=6nciwDwgHwfEy2kHawDXfY8ewr7d4gRprgsABlqSSKw308hB39x24qeRA7MYwjvB2dnAYa
	Td1GipLFD9KJ4T76BE+ubcWVpuLzZdfPOc8EwwfmZqEXTrM0L1aKBG0cbBHmzAmCTkz6GQ
	6TY4tHCB3SKQt3J8itlNglOuqcCqzII=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Ip/9PsmL";
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164430;
	b=fjWKeo/gMY02yWYswkiowMm3KsnEPT5NuWI4G3x/jJ/koMFNnyghCsMJV52c9887iTGG1M
	KH0/9t276fdQlyyHGGhULoHZJe99znngxuNLyEcuCLF/GE5nrlh6oXvREdWdvbFZ3ySMAc
	6HKlsDH33tAbFYoNVqoih9AdgYNr6Ns=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8ZaCq2742039;
	Wed, 23 Sep 2026 11:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DZPR253R3+bl6LyBiXW5gQAtjY6DOY
	80tr7PJYJoSn0=; b=Ip/9PsmLLpYTUEIiqqN7PEUCjt/tbos3gbllDcLV+dKinE
	DxM4vzFM1FgDLuHauy7zkOFHkE+8QgTu4v3UOwe3wRUssGJANSTjHJOqGP138G+T
	Nhqd4UMt93hU/7hAzMP4DnDStV7v3lAJgOZvyhZ0P+hcH1+UYg4pIU0KHQpm5t+5
	XYQiGLs519bydF3F3Ly2mUsQkpmeIheUS2Amsu7SuvxdJgo6dsqyP4V/N6M8uPwo
	Yuml8Vro5Oj2/R/nPk2G/xRZFMnqki/FTHYZUvTsblhV4A+Kj49Gi5gWyBTzSy/p
	hvCA8ghvjVyo99no8eYyGLGNv+3L5xoksFaAmS9Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1jk3y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 11:52:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8ILmd2892101;
	Wed, 23 Sep 2026 11:52:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gu5bkgqma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 11:52:48 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68NBqkcL49086914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Sep 2026 11:52:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C3D920043;
	Wed, 23 Sep 2026 11:52:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F30620040;
	Wed, 23 Sep 2026 11:52:45 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Sep 2026 11:52:45 +0000 (GMT)
Date: Wed, 23 Sep 2026 13:52:44 +0200
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
Subject: Re: [PATCH v2 1/8] mm: introduce hw_pte_t for PTE table storage
Message-ID: <4fb9f42e-73c3-46db-ac10-351a90901b7c-agordeev@linux.ibm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <20260903103002.1091859-2-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903103002.1091859-2-usama.anjum@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zkg8Yjm8buhyt1eRNhnorvj4h8bfMg31
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA0NiBTYWx0ZWRfX6bMVOEi2qN4e
 SEAEWElqPuFcMqb6XxMSAKgTBU7nj/dCzT7pboAwFXABTdsicPgdnhSpodFJ6O+u2hg509qHfDk
 z9HbX8YO6UJxXAtAPBr1SXV/yRHUshBZqtP38jfDABopi2Q8TlICK2s09kBGBV4exDZexYbukEp
 Oxg7zWWj4bwJEOGzokpvAGkgwx6mOV9Hci2samlSyJVgEXMEqtoph/gVCurHxiAAqf0TauaVInd
 IvHSuwss6TAgfLNFvMkfvgEfm/lWIxq4QqGWZb1wZGJTR0i8Aqwb5xGBOLcMv/lOTIYdxzI8o3R
 oPxWzTJkmoTyuCze3ranpvgoRtO0j9Fwo13juJtO4WWD8YTP1C0PjcAbhZUntKNvoYTNnIcU/mO
 iX0G+Pezy0wbnkBvSeLA9ii/P51EkQzABCycAD2yGmiU5zm9dKM8qjIMLGZaPS8vA+24yUC1vPk
 rGMSqvFG6FK+7tXalcw==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab3bd91 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=7CQSdrXTAAAA:8
 a=WBsaCDucxrlOMaPtzzAA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA0NiBTYWx0ZWRfX/Y5nhDG4vyXY
 k03GeTaIqKwMRq4AUpoHFMiSiGlDWAE+orQ24P6M5Bz7btA5rwd/KAwZVyCP0QeAkoFRkdQm8Rw
 gOzyts+JEL8Z8Grz2VhIOfiIo2KdxD0=
X-Proofpoint-GUID: zkg8Yjm8buhyt1eRNhnorvj4h8bfMg31
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230046
X-Stat-Signature: ng6r1bg51uaqbmsp4318denfpxnncxbm
X-Rspamd-Queue-Id: 09AF840003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790164429-999612
X-HE-Meta: U2FsdGVkX1/QsC1oEMw5YSGY8mtpS3gbL+WlCV6TQhJze6XHdAt1pYhHc8V1hCLqY8yAxeIoVMYRi9oKWDMbKg5i0CgCkGOgjHtLNybUJpiTrdRWiSzu8RGDM8a5vmE90gUEsMTzyDpsiyjv4dP7VIPliG96nabgUum72s3DGNFehPHJV4/Qvb28IqhzleYI454dv9nF33hvO2akY+t2ed8UgtFpti0vuTmJ9DEMIi62Xix1SfDcNth4/VXn+jKK6OpFBRE0LZiO6Ux3JEqlR4jFz+BLWGrGgFY/lswAhcK/VWS34ZspJ/I3EFgVECZAVx/8FXkGtoUanXDFp8nEAlnTnrFOYKMl61p2pqfeJiD/sNB8AHn2hAhp4NwAx/2RV+/BiPU4mChSB+2GMH35ytKduiX4uALNUnP8aFhwX57bAmeoyY4IIKoHlXSBHGMjThyYLwEhZRHJ4Hjs741umxFOs4K8WZprj9zlwjC0/VrNQC+aOcUvyOuYuPk4XIOMoq/pmGe5MSgUlPEXoGEOMNjCYcSrn0rhy0ebrCuGEuI3suMs8SLBif+KM5C8nTrs35gSW5XU9vPbkJruTSWhc3oXFpn6g28TOBpcIq5FSwzZ9a2AxJ65Uj+ll2y7z5tH2Sw+S5/jS2qIb/zq1LWKh20jakKi0woaCPDxhCLQkuwJGnWJRlk11nUicuDe2Ve8OWn6Ivvl+/fcGU6ZhVZafH3HIi5gCGqevbqOdF9dY/ZIvz9XUQtznFc0wNhuP3XljipIWZptpEePGkm/mezzZUFW0P1VyJdIJQC+laV8lYfHn9itkbi2MN874MOYBcV9SwveHdp3K5Kj6RayyXw7vq/qDfkGqNvpmIhYySrXU0K0z//SEYwqtysX03jYobAWkO3OdiD2WYjZMykQm/ng7ftsnbn4c9DJjVfAtUJXvRcH7C7/oxaPY9qS46lZtlzvw8D9Kqozmayb1NwAVac
 mhKVTG5w
 wuHWyRtXDEJPq4p0d5FQcNZJVeEZwjJ9uXShCMwr91VBlx33Bn1LBtp79TiGythRlsM0Joj6psdK31//zAMZdDsFu35XrPGSwaxdKVozaGDcM4FYom5vl1i1KaYS/KNdpW7LDpbGzhAczWiaCG7XbyrI6lj27wFQHiU4jANWohnosOx7QQJ+mFZSRQR58s45w7RCkS6B+QyFQgSI6NQfc6freGiWzgoLvwf4k3qxJmtoGvNEw9q+4UPJRvbAAWBsY+NTUka17Wqd3tI9u38vIpqIG2r1rTvexrA3Mso+nvvcgFaJoMwlETy2uphx2zF/FjYw2rQWL4FeBZBiejtnqkJLbUqO2zg/GvCztP+qUhvCuHfS6cY3a9dRY3ILxBxfwrlyyqbvQour/q7fcSxKX0cIdSNNN0gM8oSiIMKJFmg9ggTYx5nK3vHTGvkikHLcJFHTHnyquFRo7qO1DttLOntYHbRSEiotrugADepmUo2KmpvcP7ycXC0l35g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:29:53AM +0100, Muhammad Usama Anjum wrote:
> pte_t is used both for software PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a software PTE
> value from a pointer to table storage.
> 
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as a macro alias of pte_t by default. When an architecture selects
> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> This preserves the representation while allowing converted architectures
> to enforce the distinction at compile time.
> 
> Name the generic wrapper structure __hw_pte_t so architectures can
> forward-declare it when pgtable_t must be defined before the generic
> hw_pte_t typedef is visible. This avoids header-order dependencies.
> 
> Keep the C type definitions behind an __ASSEMBLY__ check because
> architecture assembly sources can include this header indirectly. Include
> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> they previously obtained from that header.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Name the generic wrapper structure __hw_pte_t so architectures can
>   forward-declare it, and explain why this is required.
> - Use software PTE value terminology.
> 
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
> index 2133aec4a2004..da60a8bdcddb5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17140,6 +17140,7 @@ F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgtable_types.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> new file mode 100644
> index 0000000000000..07da05d375c2c
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
> +typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> +#else
> +#define hw_pte_t pte_t
> +#endif

I would suggest to provide __hw_pte() in this series - it is needed
by architectures along with __pte_from_hw() right away (as opposed
to when lands in arm64).

> +#endif /* !__ASSEMBLY__ */
> +
> +#endif /* _LINUX_PGTABLE_TYPES_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c1ddf59c0d71a..5f462ec6fa5e5 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1312,6 +1312,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
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

