Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E05C5AD7B
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 17:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1836B007B; Sun,  9 Aug 2026 13:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9786B0088; Sun,  9 Aug 2026 13:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81426B008A; Sun,  9 Aug 2026 13:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4416B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 13:46:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10F25C0593
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 17:46:22 +0000 (UTC)
X-FDA: 85082460204.13.D108689
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id A48E718000C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 17:46:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UabY2i2O;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786297579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V46XsJ2ASYOMqPQa9NRG149ty7O7KB1wPG7dfwq0b8=;
	b=OvXT8TgB2yIno3bPdao5mAWjkGW9O559/QvV8aemmIWZotqA75vO6I4+6/RVn/pdAzttHR
	1pd/rCtoAdzxmvjmy9W600spu1MQQD9LCB3U8oA+iRuKJi3dhHl0uyRV94ZadlM+lwp4PA
	JrLuNoJrjQoGEofp0C00lg6Me+iBC8A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UabY2i2O;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786297579;
	b=jqjv/V4Zuk5c3fvLBD4G3b5aL02xsy7dRZA7bgZEOr/KfL+YrOgcOYlRuOm8VyEA69uQzZ
	nNsZNJ4kB4Zy0OQzxYTkNvMRVVMfvAIeF0hfaOm9hj21c8MXQrf96RVWgd21jzNSGLeeLD
	90JH+XT1A+4rQ7QOCCx7UvtikFxHWVA=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679FW1sE3277678;
	Sun, 9 Aug 2026 17:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=1V46XsJ2ASYOMqPQa9NRG149ty7O7K
	B1wPG7dfwq0b8=; b=UabY2i2O0DFebgnB5Itk1pRi3/Htbxgsnj9zfMhYyXAq+k
	yF4QkmQIRPAjVGN5n1TRYRA93L73U7SajNdDfI3dDHHhuVPIhOocLrBCQRPGo6fO
	zRUesLej41tQv0v/OKC288JhXJxpOKbIav1Tz2cpvXyghY1uWfY3xJlpLdnQWSkO
	g9By3jcVfZdNthUqy8R7s35WFAUQpmZ+ICuM5XKofi9TBR9lWHWDncMDr7e2p4Pd
	ahAwkkpqBsFsqnU9UxNpc/YeN9/xorzOtztL+lqAorMkbJvqxaDn+ti/Ykb1NS4P
	GkIfLBl2FlcgU/0FYB7OxhPqwp9WpNOjoazF1Vnw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvq94twx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Aug 2026 17:45:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 679HfJG7012053;
	Sun, 9 Aug 2026 17:45:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxf5vt2bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Aug 2026 17:45:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 679HjjQR34275656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 9 Aug 2026 17:45:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0842520040;
	Sun,  9 Aug 2026 17:45:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C40720043;
	Sun,  9 Aug 2026 17:45:42 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.135.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun,  9 Aug 2026 17:45:42 +0000 (GMT)
Date: Sun, 9 Aug 2026 19:45:41 +0200
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
Message-ID: <4a42c498-58ca-46f4-819f-da14cfba154f-agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-2-usama.anjum@arm.com>
 <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
 <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ehRYw8QMBCJQ6XIfQUmc1xOZ8VBocr8y
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a78bccc cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=7CQSdrXTAAAA:8
 a=7ZejAh3qsUrew3BXsuMA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA5MDE1OCBTYWx0ZWRfX8PAJydAF9Sdz
 7Q3LQNawdCCW5p3S9Cbrhno/+8i0akWT9oxXen6S0nUhBQsH880/7RsGl95VX21rT54x9YhFqi1
 20KERD3HCbwvoqxx4T70j96cVKwA2YxlZ6l2xOFcmMWRehBEI40oNe5oKbokVHGzUV8t5ZkpMSK
 ns0C/90GTY6G7Afmg3i4iWKGKI/x2MSzhpkhUmia4LUS0tqD/uSG8uJudCOs75ncoAMtIyBtPts
 SBc2vAEfXkhI2UuaiCwcdAwFVnvK8EgubcrGc/SgeNggiVPjDgs5qWQ8+vOIPtcC9cEpr02poOB
 Lg7APmO3Rx8vA6tguusRIZ4Fs8vWJdm8vnK+m2H0UOB6WahoA26KXbJqrB0927hzkoKT62s0AOf
 RGde2c8tcj7xMXKNQULCZu1ZlHt1NIVwRcJ45XzbncbVNxXZWhcoK8gsn97hT6hSSx+Fo3N5VVF
 ELeKceQfHYIaUoeswKw==
X-Proofpoint-ORIG-GUID: ehRYw8QMBCJQ6XIfQUmc1xOZ8VBocr8y
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA5MDE1OCBTYWx0ZWRfX40Jd01nPAYq/
 0UVJDKsUAxNz/IYIJFjnAhSgQRETCQqeUcuCeVy3WJaqKm5o/wyOjpQIKh0TKZ3HawAxontKM5X
 Anm2JSFRi6CK3bLpHrJPHohn6MgFj5w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_05,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608090158
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: o4h8rsmmr9fqbupei49d9zuw61b9i7cn
X-Rspamd-Queue-Id: A48E718000C
X-HE-Tag: 1786297579-309627
X-HE-Meta: U2FsdGVkX1+617yp8FDstE7z6iQqvUavjCs5gsxIF7YvrmfFRziUtLpa+7sg8/KU/X48mwWdN/wNTbLfVVlJKjW/7ToACgT13beNvMhgzn+dA2Txg1dnGW4dmu9ryIGzengcSzf0JEUUreT6ZlohsXValIajf1j/7t8oJyrZBfH5f3nkBSp4Fjx0uhuaSmhAY49qfQCKPqkbJA+V6GOrzCLs6lZkJ6wmu1Zb7Pv28dK7LWIPNKNo3oufGMSQo7NHTXZYidwh5XU/VJDKrI0+HeAg9TpezX7/1tudqZPZxTaqxPgbfivu1Xwv3ERXtuuGMAhPdWEyPR2ZdlH7+vNeATNlwDf45SNjEx8NVbVtI0tZRKMCJQARO4DkCL+oW2FU68l8TDddkeO1dxAXYqSYInPY+m8W6d8HnH7VnafDq8FzyijIJuwfdUPA5BKftXZ36nBGlH1ooCxDbYuL2wG4hYDs0M78fzzc7AWoKi837SvKI/Ly+EzpXkCE09cj5s7gZIRTPryJvjX0wV25O5Lvh60sl//qDIYuVMLcAyt578Hoxd+JniCdT4qkisbfGv5Me0v0cCO/tL3OSY6adqTif2302QV2MAbueoE4jcNjwYMpRMv/HxeXB5aYTJRXwvRbFf2CoDScGXaAbfj3C7wjT4e420SpSJxWR8CQUAdhoQ6z6jFXNt3M6NrAHMXM/0dJuW+0Z+RVvlZtI6ueJNsWrJwRifCYtIhwNJYG8jrzToRX0E6fh7adkeTPuIac46SNtzYZAG0onAkmeKIconGR/Gs5qbNYbxWmSJxkgN8ewHif9SReyMWYuGJ+o78pQhNa18BBWhHVntIHwkDOuTuPGiCViUq1kQqLu2PdTn47DogmqfCqHsbI4t2W0mc2ouwpJrY96o+5bOnwPNaW/Ql7dRv9/NcRuStZO3cUde+5D0/Zy1n+z3E36+HC554G81Be3rA1e5wqwUDdZZjHYXz
 kDxcNPBY
 RbrQbG9S1c9SDlBTUulXDJptsAaCTnaLZCZoV/cuB97xc9nn4agMMv+i+pzOSoc9FIWkHtgeOZKTZvKEIDtlZHO5rekMxk74qaKs/784/k+HHvZr38D4QvIRnqRhxPVyT/0jjhyVTNzIqiaSErtmM3OG3nLkxb7AsD/mW+sMym6q+y8cEMr1fNmf9xLqJ04l8KfmySbcfNHMAd85Ayo9/3RQWNZKFhf4VKQ8DcsqrYN4A0IeqcW+UIJi639pxE4nWPjYElZXyoEEXh28uH1VrneddiBX/HDhvJYrq3BRNcsA150VVHA2IajIfU1dYq0POqdvLWg9MCuRVAsT/xJ22brzugV0PHOiRNLSLQ7DXEzD296T0UP9BmzG2rR48kbPBCh2kti2hRnQVld4/OZEZOZYAjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:24:00PM +0100, Muhammad Usama Anjum wrote:
> On 07/08/2026 8:09 am, Alexander Gordeev wrote:
> > On Thu, Aug 06, 2026 at 09:38:39AM +0100, Muhammad Usama Anjum wrote:
> >> pte_t is used both for logical PTE values and for entries stored in a PTE
> >> table, so pte_t * does not distinguish a pointer to a copied value from a
> >> pointer to table storage.
> >>
> >> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> >> as a macro alias of pte_t by default. When an architecture selects
> >> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> >> This preserves the representation while allowing converted architectures
> >> to enforce the distinction at compile time.
> >>
> >> Keep the C type definitions behind an __ASSEMBLY__ check because
> >> architecture assembly sources can include this header indirectly. Include
> >> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> >> they previously obtained from that header.
> >>
> >> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> >> ---
> >> Changes since RFC v1:
> >> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
> >> - Exclude the C type definitions from assembly sources.
> >> - Update the description for the new opt-in model.
> >> ---
> >>  MAINTAINERS                   |  1 +
> >>  include/linux/pgtable_types.h | 17 +++++++++++++++++
> >>  mm/Kconfig                    |  3 +++
> >>  3 files changed, 21 insertions(+)
> >>  create mode 100644 include/linux/pgtable_types.h
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index e9c8567308a75..7169bea968cf5 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -16982,6 +16982,7 @@ F:	include/linux/mmu_notifier.h
> >>  F:	include/linux/pagewalk.h
> >>  F:	include/linux/pgalloc.h
> >>  F:	include/linux/pgtable.h
> >> +F:	include/linux/pgtable_types.h
> >>  F:	include/linux/ptdump.h
> >>  F:	include/linux/vmpressure.h
> >>  F:	include/linux/vmstat.h
> >> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> >> new file mode 100644
> >> index 0000000000000..70c3edd00a01b
> >> --- /dev/null
> >> +++ b/include/linux/pgtable_types.h
> >> @@ -0,0 +1,17 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef _LINUX_PGTABLE_TYPES_H
> >> +#define _LINUX_PGTABLE_TYPES_H
> >> +
> >> +#include <asm/page.h>
> >> +
> >> +#ifndef __ASSEMBLY__
> >> +
> >> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
> >> +typedef struct { pte_t __pte; } hw_pte_t;
> > 
> > On s390 it fails to compile once we do typedef hw_pte_t *pgtable_t
> > in asm/page.h. m68k, powerpc and sparc may also have such problem.
> > 
> > The below declaration helps to resolve it using forward declaration
> > and without meddling with headers, though I do not like it much:
> > 
> > typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> Thank you for testing it out on s390.
> 
> As __hw_pte_t isn't being used yet in this series, would s390 enablement
> patches add __hw_pte_t to this definition?

I hope there is a better solution. As I noted m68k, powerpc and sparc
may also be affected, so I would suggest to look into those as well.
I would prefer s390 to use the generic one rather than circumvent a
compile error in a custom way.

> This could have been avoided if each architecture defined its own hw_pte_t.
> But for now we are keeping the generic definition of hw_pte_t.
> 
> > 
> >> +#else
> >> +#define hw_pte_t pte_t
> >> +#endif
> >> +
> >> +#endif /* !__ASSEMBLY__ */
> >> +
> >> +#endif /* _LINUX_PGTABLE_TYPES_H */
> >> diff --git a/mm/Kconfig b/mm/Kconfig
> >> index 331daf7fcfab5..31ba9ebf4aafd 100644
> >> --- a/mm/Kconfig
> >> +++ b/mm/Kconfig
> >> @@ -1316,6 +1316,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
> >>  config GUP_GET_PXX_LOW_HIGH
> >>  	bool
> >>  
> >> +config ARCH_HAS_HW_PTE_T
> >> +	bool
> >> +
> >>  config DMAPOOL_TEST
> >>  	tristate "Enable a module to run time tests on dma_pool"
> >>  	depends on HAS_DMA
> >> -- 
> >> 2.47.3
> >>
> 
> -- 
> Thanks,
> Usama
> 

