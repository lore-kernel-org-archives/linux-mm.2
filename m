Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F36C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31966B0099; Thu, 30 Jul 2026 06:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCC26B009D; Thu, 30 Jul 2026 06:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CDF6B009E; Thu, 30 Jul 2026 06:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 581BF6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:08:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E9E71A093D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:08:58 +0000 (UTC)
X-FDA: 85045019556.06.E03E542
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 54A3E80006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:08:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mpgStl8w;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785406131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyEKmgQDKWQNaqyjGD9/StXJGEDRDY1U+s/7IVPb15Q=;
	b=S6XqV0nBRfN1LlIUp2xTDZHhEiHktwb3BjiNgMhn9C3ioM4w3sVKJUODgZ8+S9GggNfa3M
	niRY+LCjiCYK4RSVvAc9GPuy2i8Rm+b7fbRbzJjW/qgO315V4JhldYrqsl2XDjC1I5fh1d
	BVN3gGjlvE/QRdNzCfAPdgVi9WSYk3g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mpgStl8w;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785406131;
	b=BAx6z2BbyIZuBJ46shzwGHJPxwEsHIj8qCwQFYTCeFUx5YnILL6ve7lfayw6Vd3vZGkoew
	Y3A1A+iOW5pRGI4lbvXs+jleba4KN8T05OohV/EK67OHpb4zSXW3S5YJm36m9FQNOjDa8t
	t1rsqGTGNYiT5epfAlU+tiCmszl9OIU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6m2hU2316588;
	Thu, 30 Jul 2026 10:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=SyEKmgQDKWQNaqyjGD9/StXJGEDRDY
	1U+s/7IVPb15Q=; b=mpgStl8w7nM9YhaejMlJKR3MpAZdEg3CMrKaAXvLKHr7vT
	6VVwUWTv94MCyV0t0LoEvX4NTx8I4oV6Z0RyamfkVYt+l2AOdDneecdkibOEY1+b
	fD9XwZ3K4X8hUfJXGoIotglUANfOJDNKrE0DS35mkwFOijc9A8vDRLcyW5rJpkQl
	ZSz6TwC2s319vuPGylh8x/WmuWHPvwVDTCys8JeV+xWvLk555y/ELhHSpwIRUICY
	YonccknjvF9P+MZBOhJqIBxdnhuPD4Gkn7+w9bgCc5mVY0U6J1Gm6Uc9d61V0Jez
	zbYakob6m6/arpoFMao3y0RyGCx0NamVLgwru4iQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwd6a7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 10:08:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U9fHHZ004184;
	Thu, 30 Jul 2026 10:08:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fkatpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 10:08:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UA8Mar34079042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 10:08:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C9E62004F;
	Thu, 30 Jul 2026 10:08:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8DEC20040;
	Thu, 30 Jul 2026 10:08:21 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Jul 2026 10:08:21 +0000 (GMT)
Date: Thu, 30 Jul 2026 12:08:20 +0200
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
Subject: Re: [PATCH RFC 05/11] mm: convert PTE table entries in ptep_get()
Message-ID: <34eed5fd-c569-49d8-bc4d-a3d4b1207fbd-agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-6-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727164715.2866609-6-usama.anjum@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o0rywYqMRb9-o-diVy_ik6hJzY7jXbKp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA3MiBTYWx0ZWRfX9YzlV5X9xylI
 niwszbMcVKFzbqv5lB4+x3UMXHiu2Na/LX64PyF/7hm6373GBwUh9Nzp3rKvPU5zk189VQCofLr
 rPG5w4Fu4iCy4m6kL6IwmlpOMbpH93Q=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6b2299 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=7CQSdrXTAAAA:8
 a=rd7UzSewfSqtCNqF-5IA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA3MiBTYWx0ZWRfX5SpBi0HAiQ/C
 9ni/l34t00qdV/3lkOyjkRQMHI/bzArsCFIkiciKZ8adXpzfTg+v45rnYJqhyhndiqeJpPiwNep
 VZubCJTxxNPdh7fUODcM7dZfoUnpFjzvPK4ZEbfqEnIme5xp5/3dh/jC+Bz0wOnfq0jzNGqzp01
 zPArarMM0ovv+hNUMHMW7KFO1ciq6TJyi7CqiLbDAikACDO4XCNopg90PkO7ZmmtnKQKZqCc3Iu
 vjfATt8qU+7UDSj5FM+YWzMlFLtZ7yd+VsugakgEKb3nBJHhgB/c4j80i+hmodLARApOX/lUvJi
 hIn4WaO+yfetcmUKLTaNKagXUiUaD1+XmWFrHFYPqNS0/OPuPyGwB/Il8okWMucK5lVYiKp9Avl
 wy0uPYNZ2zKQHtwferVMHYGgVjDdrnJfKZLKq+RVgKww7RVJrU9y33ZnAADV+Y5aXFTSzYQrdU5
 SYDEkUDGowOYGL7zbLg==
X-Proofpoint-GUID: o0rywYqMRb9-o-diVy_ik6hJzY7jXbKp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300072
X-Rspam-User: 
X-Rspamd-Queue-Id: 54A3E80006
X-Rspamd-Server: rspam01
X-Stat-Signature: dx3tu9e6cqkq8ijsnuer4y8ywfe931b4
X-HE-Tag: 1785406131-536505
X-HE-Meta: U2FsdGVkX1+b3ejcV0VxpLpM/HJfILWcCBEtmsRHBD1XJ4hgO/FGjMhZwV0jqL/ZIsn1p7qC/0/O5ppU7oACjAuKTd1Aauqw+Qm+9DMhj5b8X6nH04Thm64Q4EbBrYRPg3BAKV8sVz2+saYheN400LVxYBsI6Kgc9qzgFIA+pv9NoOySRrOYqeUnNS58sMhmyPo6aWM7NvekdsW4lmVkbCl282WRDeM4SN9KuNWctM2BOZc1Vg5szpD2fmHa6JSlSvWaIeBKqcFKAJ5wvVAmCsuv1jZXCbzaeBvLnm7Caj/tDYOgQDZLe1Cjs0DK/LS5rMRxCupmA3Go9igQNKSQTgq3T5Aryzriliea2HkIxlW/bagjg4W0tLcOGdZvts9KCEEk3AqqjvkAZAQokxhEd+vM2BfG3Jt3m5Yb9am+Rjqbj2ODDo3N6o+0CZCU3QXOuWn2Y/6Kg7plE1pWXDaG8J7AQB65mOgXeku+af4iv2KP5YIV7CIDF10jZytYINVMTT+mPDokdlCwDBORC01tVhiORhVe3Gm0eOy74njplMm6PthuisVrT9t7DL2NW3zZUP8EZX74sbdIfSnmy9kHBUo/CGV/EjFYjO02/Ev4BAg455e/6psRrLSxaDH3YLZQ4Wz/kwmTgoeTIquGnvl7A9/Z+M1Ve8ZkNoospf09Oln8OK4HUYEqhtOgmi5TIOb8Sj0HwrgQX9o3qI09rqXsVRqx7WQfBhBM7DEPiBvofBFJLAoJfgpWS1Hhi0wYm1sY0ASmu0jvdYd6SJLqBvL3HnEZH/j0rhOwVbARHQcqt0/F2K4ulgl0LJV9jRp07TGpX9HHlFaNmpHm722/TjnRELDi/xrG3sTRBXuLxfNFbYqxljEF2GQEGOHUMv8iZdCA6ZMNXpjc9shaXoq/CqpJs22UDme77ZBeRz44VtbNKYxgoAYbksLlDEpL5u9SrvmvqO1Ar4ncdG1E2TqXJcc
 el/0P8c1
 Wiaml1uTp/Ya40BLD1/idNW4kN+I12fjyzxnO40J87prnxCLKjoX4pxmIRgd7OQNmf2nzm/hMtgVFbepJuvxLhEpw0AszgHN2Bs098BVpNmXSFBXP4yXc7l6YXNnhA8lHP9h110oixeMh7tOma4/7Q1K5pub1mNl+zll+zawxTMI5e4zZf442qeFiz1/TNpKKwPl0QgdDYknG47nGFIw+0/Jp+fLHUIV70uvc28NlfCuzEhaG+y3WgNMMX0Dxg/jU8ea0trjVJ6lSv8fg255+Ki4to6+gKmzQ5zeiP8J0+/S73bUjR+oNO3Q8qddJGwPjBX4eNEjkVwb7ZZuYjEvO7FyaRtkKCaDc0/o/0qm1u4NR7IUtWU45b2X8R7OrE8+Ds0z+RhAFg/z2j7/ZSRjcDgIX2bRMVi3StETu9PYfS7u9+Uj/cShgKPM3upV9cnu1Sth4+0eIfEXPQQAAHMQGS4UoxMZYhdIYrZyQIAHnYqwtkN0vQxqyBe10/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:46:56PM +0100, Muhammad Usama Anjum wrote:
> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
> return a logical pte_t value. Add __pte_from_hw() as the conversion hook
> and apply it in the generic ptep_get() implementation.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  include/linux/pgtable.h       | 2 +-
>  include/linux/pgtable_types.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index dad80d264aac2..3003ac9cd81fe 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #ifndef ptep_get
>  static inline pte_t ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return READ_ONCE(__pte_from_hw(*ptep));

Should it be something like?

	return __pte_from_hw(READ_ONCE(*ptep));

>  }
>  #endif
>  
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index ed5dba42a4f8c..61afe27307ec2 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -6,6 +6,7 @@
>  
>  #ifndef __HAVE_ARCH_HW_PTE_T
>  #define hw_pte_t pte_t
> +#define __pte_from_hw(pte)	(pte)
>  #endif
>  
>  #endif /* _LINUX_PGTABLE_TYPES_H */
> -- 
> 2.47.3
> 

