Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EF4F327B0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1512F6B0088; Tue, 21 Apr 2026 04:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1017F6B0089; Tue, 21 Apr 2026 04:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32976B008A; Tue, 21 Apr 2026 04:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3E726B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:28:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1B1CBD970
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:28:25 +0000 (UTC)
X-FDA: 84681886170.28.FAD6DA4
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3588B40004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:28:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="b/enU9GW";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776760103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S37y6HE7oOJ4CNhNQJ8fCZpfyA4jum10NN4frBS0PCM=;
	b=oONzstVmxB5LxydFvk7Quu3y+P8YfwWEc7PTxjaNGF/BnTIT8B9u8N9P5/WIT/aZFlq5XW
	ljvIjJafOS/txf4rMk4K6ftQy1gNJCgasqyRHe8wWDGaroti/QWMODGj9L5Z5KHdiPgkTq
	LFSEuajdt+7/VzYK2L1srZC04aJo3SE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="b/enU9GW";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776760103; a=rsa-sha256;
	cv=none;
	b=IuPVac5OHK6eGIVK2fxB+G7QvzS85JCJ/6MmsrbUOcZ7z5iP/4r4BgG6e4n+jDynwP1SoV
	cUWfyxPBpbg6PxtfvwECku92lVrrqVuYTQdEgxVT/SuxrOXcrmfutT/NnGOaa9vKjcBDI3
	XRJEzjvxhRv43pczFXn1GUiWafn9+7k=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KJgnN12037786;
	Tue, 21 Apr 2026 08:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=S37y6H
	E7oOJ4CNhNQJ8fCZpfyA4jum10NN4frBS0PCM=; b=b/enU9GW2mN3NHfq5I40+J
	yH8Jqw9uJBlV4dTdBU7tcEgO6iup7Q3QE5YY5sfaI+A0j/ASnR45eDJoFDHyoiVJ
	CjZajRXWfCd4u5PBKOn1zW/Sl+MbEG1ilAOecqGYpk08gK4DoTblfrFWCitxmyUL
	Bs9sP1rN6/dFGzbTuXiN3A1W42+bWiH6qlwEt9ranzl6TdIDloWUM+kds60UTEli
	jAim5bX5ak2cxyJpvGJKEkz/yBQQUVSxf0cQuvcHOLD1zk5sXpFbISeBlNRSuAeC
	wOuUTrIqZqYGhtEenYDt4nMdQRBvs9T3yqcnIbcG4rXcPAnVHZGLgxzASX8QYhvQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2h9jnv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 08:27:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63L8KFKo008086;
	Tue, 21 Apr 2026 08:27:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9jyxwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 08:27:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63L8Rl2p12255652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:27:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A135C20043;
	Tue, 21 Apr 2026 08:27:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F358F20040;
	Tue, 21 Apr 2026 08:27:45 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Apr 2026 08:27:45 +0000 (GMT)
Message-ID: <9115d2bc-781b-4e5f-9772-c0ebeecac91b@linux.ibm.com>
Date: Tue, 21 Apr 2026 10:27:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/18] unwind_user/sframe: Add support for reading
 .sframe contents
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
 <20260127150554.2760964-5-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260127150554.2760964-5-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 1goWuCKfC-7KiyC8K84-VTn1qdBVnTzk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA4MCBTYWx0ZWRfXx0veQ28IaQW6
 fPpGKE4AGs52FLXRq6Os3Xi7WV4PA62uhAW5W5FYHNjTyGzvxoBYcO+upsEji4XkUq45iwHMnPa
 5uXe82pmmIHwh8j+XiOtB3QJgqbgEAJ3/nZGi3mxK1KJ8xn//G3zAIbnMl7vegYyhLS6kqtnFKl
 UU2LTeYDnNT9Ug9l0P9gDNLYsSWZdKb/n/eZpr/dZGX/UWb9W7Iw7+6d+M3hOlEbUTgFoPPTf/2
 FrAHbNm5p95qGcAThxOl52GrNE+iDowxuLDF6IRTKCHY2sv+z/Zumc5muCysXEGiyY2cVHjB199
 jr78obbMbd8xZJFoIlqxqqucb3hiNVm6TM/4K4Nc3rhgwrnMGBZ8FwBTnptCyruvZ4upXzRvruZ
 kztMNtG3p4Wrl882vpsH1sm+AsvYQMTYbE4Y8O0wTJn8ajhxRFAYSvMhcqqUW+7D4yplyA5jpbq
 mezHHgL1OpRdsRhZwTA==
X-Authority-Analysis: v=2.4 cv=XLYAjwhE c=1 sm=1 tr=0 ts=69e7350a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=rIsWgEjAf_fsY0NmbdQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GDOmWqtYOiKgBotIL32-m-aTBWQC6JcH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210080
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3588B40004
X-Stat-Signature: xfma8syxmg8iw3ebuqrdeab3zumfetu5
X-Rspam-User: 
X-HE-Tag: 1776760103-129762
X-HE-Meta: U2FsdGVkX19rTIbL5RytR9pG/dxwN3lUfa1wvca4cmLOzU276sy8Ctth67YTkEmZ7rR8z+fmcOaaVCQl2AQLm2toP1MZ8MAga9CbbICDtDiadSFuYf1alp8TOiEGuLUHS+95MOsRGg1K4i7m6h7gF09GnORbH2m6MHUh5jMaCOYb50yRiW9wW9gvnbJph//KMITCKwwNb57zkL4g/uCUStLk+sf0d42R4+ak3VhvaZ6Tf8M+qymeaxJVwYBS7QX3sLtLEnVYtBlNIILOOox/ImIawf4Nen6zzIcXSyBLbx6q4xG8+EQyW3NOVbPpENMB2NCVuECbFs+1fbBEFLAG8q/4kS2HzVtqUj3pTUc+EihfVEDltedd5YSlfx3KxCPMKucdYftq2AqhjjQjI5T7xKWIdwZhQ6m/vNPWETt6I8Zn4JfSzTZ9Ej2gCFaHFCSIbTYhK7UwCz4ZWxmjoijmpkrF2PJqxT7HKBVbUmNhKecnD8r07Kr0DPPDxsL2juZPGhu+d/m62KT2btf541JIDKPzcIZi2qr+7fQPmIQSshPKUTc4PnLRR4+2GPb90qOV539n33ompupDmTvijNPTiV/7svjDdBYfoaC9JrVnLJX9utWbx04pCyfadUxDy/+ZUO0UR7RSJIesEC65XRgdhQjLOS544zRKHee70iR3jmP/eaR07OoUZhPJyR1fsgciFfd6wTlgMwaTxobQ/hpiVLT5d0hmCTrAqROUKsRySRKI5BRFF85yPJK2Vl08PNazJgcp1jtw0OzgZuCsaDIOsr08822NpCyUVtfFKdkWjbA5KoJb7b8avRd0icitWIDe0z9tvG/YJmwC4jdMZI8e7mAw51iHg7gODndvPtDX+nBu4agc8CDDuuqXoBjP/skp8GHopJFlmE54dtUUSB+ZW6KhAiGPT5Rn9MoS8t8xO0ordX3OaaEY7XjczDkLqi+BQkIVYKD3ch0fQPQ8zpD
 mfhcK5kB
 gfb9gfG8lN0qa3AHxa3soKijI8pF3gqUGqjjJEPUONxVlHOI4tDxJJ673Hhm6bbdBWVzsUqktiwUujqh90Gs28h5VttGBPypS8vn33IKVkNLL2EcPWueEGyc2sZNF46efiS+clSYZIr4l0vUEFY4txEuQSsyok0gdQFjAFJlRHH6O8jnEoCDY95MICshDB5YPgVYgMAxWoj9mnAPRbLy0VEWCOpdn7dXHSdnfu6KeA18DeQvuoy3zgPaj26GbmFQ8f8tjplqcK07QOWMHBTPQcTnAnFLmp9k1mCMSmHhukVIJYy8CMaDxJZBzot+gJBx83WjyLRo2rFqM6atrbJP06l69AYqgqZVX4e1aaSvrggwZsvWSa3G1k8f6O9YYbstcy3D+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/2026 4:05 PM, Jens Remus wrote:
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
> +	if (func_addr < sec->text_start || func_addr > sec->text_end)

sec->text_end points after the last byte of the .text section.
Therefore the check for whether FDE function start address is within the
section must be:

	if (func_addr < sec->text_start || func_addr >= sec->text_end)

> +		return -EINVAL;

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


