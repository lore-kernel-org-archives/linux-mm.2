Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80D4CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EAE6B008A; Mon, 11 May 2026 12:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F256B008C; Mon, 11 May 2026 12:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E8B6B0095; Mon, 11 May 2026 12:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D50EC6B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:17:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CFF6140208
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:17:41 +0000 (UTC)
X-FDA: 84755644722.01.81D54E8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 61B1F40007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:17:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dcrn+XQg;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PljQfXjEQJkTJMcKcqWTViVGwQCuUAG7K0M3qjxMCfQ=;
	b=8XlGVesXCwkRXuin4shuhCGLTtyJjotX7U1SJIDC50XRlRv80rzwebwMlCADoZEHfz8uZe
	pM/UtI0r6VQkq2MEqAX3HX5MOeV2uwc95vNHG9Lcsj8BOx1/eEK0qHfR/ksgQX7wTzvncf
	Gnxok58arykg4QImZOulH1mQvRAeId4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dcrn+XQg;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516259; a=rsa-sha256;
	cv=none;
	b=23DvP1bWnLRLhqk6w4OocMYc4KUyS2Dezgx7o4k9NgTLOaug07iatkBxK/h2TOajQ3T9Z5
	HNUSU+/uy+N9+XuLnWI01IMfCaxuyeCCYaz2AuTpHhLhtE7+x8ILBQInlxeBW7nXOQwmG4
	LqpckCOFewYJ2nnxHcTaftL+eb+tcXs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B9S2AT2762269;
	Mon, 11 May 2026 16:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PljQfX
	jEQJkTJMcKcqWTViVGwQCuUAG7K0M3qjxMCfQ=; b=dcrn+XQgB/bj2r8nDP4tBW
	wgZ591e5O17u/t+ejyYaLZ5GCZd5TbaFDGzeymY5H8nD5Ea16xNZaMTYLkpcO8wE
	shkDQsQllNiOxFCpoxoOHjAvbveQtUM8zyNE7MH38kox6zYgEYOfKjZiyoUU9MDl
	5u7IBIN2yjlaE2TwVxkVjkI0wJeMeZhxnyb0sYKa0F3gbsXZhnOuFQPBH7hxaYhE
	n30Ec0gxHuYNuEUZqVhTmfNUhgPbOcPjBfoo+cNY00ZFM2gber++p068emUFWIeU
	NzXW6Vi0iefdCffwAP5WKEu2nT9VeJgwIs3/a/2U9LBNyLCgy5yW8DV4jDEMdscw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1vkqs531-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 16:16:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64BG9ZNV023420;
	Mon, 11 May 2026 16:16:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e2f8q65d9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 16:16:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64BGG6gT35127710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 16:16:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EBC720040;
	Mon, 11 May 2026 16:16:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D19F520043;
	Mon, 11 May 2026 16:16:04 +0000 (GMT)
Received: from [9.111.205.47] (unknown [9.111.205.47])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 May 2026 16:16:04 +0000 (GMT)
Message-ID: <8d72a8da-945a-4f73-8549-db6d8f2f1a46@linux.ibm.com>
Date: Mon, 11 May 2026 18:16:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/19] unwind_user/sframe: Add support for reading
 .sframe contents
To: Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Dylan Hatch <dylanbhatch@google.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
 <20260505121718.3572346-6-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260505121718.3572346-6-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE3NCBTYWx0ZWRfXwzDif66fkrfh
 Q8WZ/54cGOIc1otkBfbOIq905Yg00jeO3y8YLB1SZQLgisaeGZwo86NdiRxetvynSM6V9ayWzq2
 HzF4dnSa6jiwyMxwg5lTGGdoihD9MfyJC8A2Fs7NX+U+JmLEE5zB0uC83xWGubQHX2OV+D4/M5V
 eHunX0JIijfO9PsypQ6Xqa0C6CqLLpvRtVkcEohotQ0dKnzCdzXZBNprAizcqWaHJU+sJhgPOJK
 lXhFDYZGrUAmU6xz3nREIDDdjDyI3swvjbQesTHYGQTbpiSzD49q9YLeuPOi7+dNWsg41XzfsK0
 BphNMoepS21cfzucK0MGwnGZ7efPF47amD+CghrCIFMgxjA8UyeioD1DsdQn4fkeywU3f3yn9r1
 7kIMy8HHb2tNyGYt7l8zrIYFZqTXS0bAOimuoUbo7UzZa5vXgPMUr2+ZUmV9qGJUx4xoDDfP7pe
 d30xEPRxdyRxEtWflaw==
X-Authority-Analysis: v=2.4 cv=OaWoyBTY c=1 sm=1 tr=0 ts=6a0200cd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=YuDcBBqGAAAA:8 a=DW19hxsEfaWoqxOqFrcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=V9_jqlfyBUA7Gw2gN5zN:22
X-Proofpoint-ORIG-GUID: v7oyYq_1EeTb2SEXuDNJ0wNJCl2cjr3V
X-Proofpoint-GUID: H50GDy6yegsuV98nwCBWYnMMVcIUVI2L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_04,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605110174
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61B1F40007
X-Rspam-User: 
X-Stat-Signature: iiz3qp35t48ytkztrwtq6un9ci4kjc41
X-HE-Tag: 1778516239-134560
X-HE-Meta: U2FsdGVkX1/fpCLtXZ8Dix7sfrhfK4Aw4EJKUJ1xTXTHNPA0OeI+hEabnoEdsO1jPDYtbPpKplbxOzsfzbq0IM91/kCNG0bc0Xf8cHm0U1ez5S/aXUl/zPiB1HfUEh4VOkM5GpWiBlf84WPuvVJK2VmlXB4MvP408UeCZR4b25MUARNuf8s/3G3IlwUwRSQmP/FtejkZtzcXBv0hSWOGndCRy81jkryGuuw7HsREkr1aw+zHASJmnSge2AJBVRkXIDlMrgXqRGXsQQfus6SrsTLMCHup3Wodf8ZuoVx+jbXgld+x254jFO3xlUI030+Tj3vp+BuSJPxVNsqZv78zRlFWzcy7cclD2C9QgbVglUtVF98SRk8lEIuDqNxusESz0poIrmUfC7JLnJVHzA2tY3iz5YChuBi/TPw/oL6SACjP1Xa4vlzeGN8+xZ6xQ1HotC2clyQFRNmP1p+QFOFs933wUHwfGTAkT42sck/GFMCdJJnMDRxisJCx4TvE9GprI4R3K/pSaeeUDiZDSJdWIU+1TnAaNnuKzThFXCGYsUidQ7HDVN4hpG+q/ysP+9snOGZq0zrBbNUmlPyjOXeAE8Lx6xmzhMvL3pGPIjpiBa2f0fMreMpugg0gOoKTQNS5fCV/yeohG1+QRZDGwNbKW110ZeaQsOtLx0UczwCjngrLh00trIO45WabpEL/m1EsVyCsb9XYN5jgXPKksRmXkqwGoS2eM/J0PeWpiDXBIm50zruhTphR5VVEwYDwFZJnb1NVQ0kd7n0OFz4/TEA6oBnbEQHnWTk1vJuH+8LxaGBi43ErtqZcmAJsr72pZrtPzrj5WXSB5g453QqS1Nwa7jn5wzBViZ1mIs1icrQZmanUq7c1wcSV9+778nBdYEixYY5iFCMJ7rzsNvhyoMuLojuBOZ5xCQN+bzO4KNQOorTDZKwqbB0Mp6K4vFtDOeuuwJ1N4lV8AInAz99UZfL
 RQ/Vi5c9
 77zBKBF5K3zLw0tW3HXYfhPzCgrDs179U60GE1BoOd/fsnzRFej0BjOewdUdAEO7NEOSwt7zR9dUoGGAC8gwURwyFHHoxZbqpcQlD6u4u4j/d/xe9NtRe8sdcr2up/AV12bYVDuI+Tim8MZ/pOdM9v4lqcLzhtqMpX1yCKfUY5kBJejQZFekp39sdzZvN4gXiZb/t5zgmuY8eEtAYggcz45CBBPFV6xsldPYW0RPh6p0+ko3/ekISlcklFCmniBGyefBCyiT0s39tb5jlhzG5u7nu90cbseMF0Tqt6FN435HDNp3BYMKZp6BFijg8BCxKDmITeLMoeH184u5qqkTiWbMasp2sjLLSkMlqU3gh67FGIUuQdLkmhDJMeYE2STVc6WdU9LGuL+DoISUfuj5AUNoGsxv8GC9dXyvygyiYeCrHqQ8Oq3nwMz5Y/bY0ngkhy6TLeHKL3rGGMji6PDqL8HFeS6iTfO3MMFA5fIZRoAFmYL/tMx3fQoc69zpxa119gU12oyJUvvCNYyQcWQBjXfrZ5wbSfjg+UPkW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/2026 2:17 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> In preparation for using sframe to unwind user space stacks, add an
> sframe_find() interface for finding the sframe information associated
> with a given text address.
> 
> For performance, use user_read_access_begin() and the corresponding
> unsafe_*() accessors.  Note that use of pr_debug() in uaccess-enabled
> regions would break noinstr validation, so there aren't any debug
> messages yet.  That will be added in a subsequent commit.
> 
> Link: https://lore.kernel.org/all/77c0d1ec143bf2a53d66c4ecb190e7e0a576fbfd.1737511963.git.jpoimboe@kernel.org/
> Link: https://lore.kernel.org/all/b35ca3a3-8de5-4d32-8d30-d4e562f6b0de@linux.ibm.com/
> 
> [ Jens Remus: Add initial support for SFrame V3 (limited to regular
> FDEs).  Add support for PC-relative FDE function start offset.  Simplify
> logic by using an internal FDE representation.  Rename struct sframe_fre
> to sframe_fre_internal to align with struct sframe_fde_internal.
> Cleanup includes.  Fix checkpatch errors "spaces required around that
> ':'". ]

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

It just occurred to me that that the use of the return values -EINVAL
and -EFAULT is inconsistent across __read_fde() and __read_fre():
-EINVAL is to be used when a lookup for an IP fails (i.e. cannot be
        satisfied) and
-EFAULT is to be used when the .sframe is corrupted/inconsistent and
        should be unregistered.

> +static __always_inline int __read_fde(struct sframe_section *sec,
> +				      unsigned int fde_num,
> +				      struct sframe_fde_internal *fde)
> +{
> +	unsigned long fde_addr, fda_addr, func_addr;
> +	struct sframe_fde_v3 _fde;
> +	struct sframe_fda_v3 _fda;
> +
> +	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde_v3));
> +	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
> +			      sizeof(struct sframe_fde_v3), Efault);
> +
> +	func_addr = fde_addr + _fde.func_start_off;
> +	if (func_addr < sec->text_start || func_addr >= sec->text_end)
> +		return -EINVAL;

		return -EFAULT;

> +
> +	fda_addr = sec->fres_start + _fde.fres_off;
> +	if (fda_addr + sizeof(struct sframe_fda_v3) > sec->fres_end)
> +		return -EINVAL;

		return -EFAULT;

> +	unsafe_copy_from_user(&_fda, (void __user *)fda_addr,
> +			      sizeof(struct sframe_fda_v3), Efault);
> +
> +	fde->func_addr	= func_addr;
> +	fde->func_size	= _fde.func_size;
> +	fde->fda_off	= _fde.fres_off;
> +	fde->fres_off	= _fde.fres_off + sizeof(struct sframe_fda_v3);
> +	fde->fres_num	= _fda.fres_num;
> +	fde->info	= _fda.info;
> +	fde->info2	= _fda.info2;
> +	fde->rep_size	= _fda.rep_size;
> +
> +	return 0;
> +
> +Efault:
> +	return -EFAULT;
> +}



> +static __always_inline int __read_fre(struct sframe_section *sec,
> +				      struct sframe_fde_internal *fde,
> +				      unsigned long fre_addr,
> +				      struct sframe_fre_internal *fre)
> +{
> +	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
> +	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
> +	unsigned char fre_type = SFRAME_V3_FDE_FRE_TYPE(fde->info);
> +	unsigned char dataword_count, dataword_size;
> +	s32 cfa_off, ra_off, fp_off;
> +	unsigned long cur = fre_addr;
> +	unsigned char addr_size;
> +	u32 ip_off;
> +	u8 info;
> +
> +	addr_size = fre_type_to_size(fre_type);
> +	if (!addr_size)
> +		return -EFAULT;
> +
> +	if (fre_addr + addr_size + 1 > sec->fres_end)
> +		return -EFAULT;
> +
> +	UNSAFE_GET_USER_INC(ip_off, cur, addr_size, Efault);
> +	if (fde_pctype == SFRAME_FDE_PCTYPE_INC && ip_off > fde->func_size)
> +		return -EFAULT;
> +
> +	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
> +	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
> +	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
> +	if (!dataword_count || !dataword_size)
> +		return -EFAULT;
> +
> +	if (cur + (dataword_count * dataword_size) > sec->fres_end)
> +		return -EFAULT;
> +
> +	/* TODO: Support for flexible FDEs not implemented yet. */
> +	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
> +		return -EFAULT;
> +
> +	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
> +	dataword_count--;
> +
> +	ra_off = sec->ra_off;
> +	if (!ra_off) {
> +		if (!dataword_count--)
> +			return -EFAULT;
> +
> +		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
> +	}
> +
> +	fp_off = sec->fp_off;
> +	if (!fp_off && dataword_count) {
> +		dataword_count--;
> +		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
> +	}
> +
> +	if (dataword_count)
> +		return -EFAULT;
> +
> +	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
> +	fre->ip_off	= ip_off;
> +	fre->cfa_off	= cfa_off;
> +	fre->ra_off	= ra_off;
> +	fre->fp_off	= fp_off;
> +	fre->info	= info;
> +
> +	return 0;
> +
> +Efault:
> +	return -EFAULT;
> +}

Similar for sframe_init_cfa_rule_data() (and sframe_init_rule_data())
that get introduced with subsequent commits.

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


