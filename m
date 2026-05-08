Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8F6CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB5D6B013C; Fri,  8 May 2026 06:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982C76B013E; Fri,  8 May 2026 06:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871776B013F; Fri,  8 May 2026 06:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74CDC6B013C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:52:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 154E91207F0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:52:35 +0000 (UTC)
X-FDA: 84743939070.06.805A838
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F0232000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:52:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="V/Lb1iUf";
	spf=pass (imf03.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778237552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMFcUg6YI0uRs0oFeC5tG4Rvu7Ar3pTJNfqJiF659xo=;
	b=znwBqQK3liurJB22DhA4djIk9AcwvB6yGY0+f4YYS6Ub+Pwq8JnoNJAfdvCGAS0EmbP+P4
	VH0yxKe2UieUzl5RjqsCsXjrQZVECwBc5zgXhQY+2CWy4FYJZWN2KPCbG/Nl0gdlUtGvFY
	BRnMi97bY7pWZYb/voqnMrdt/Fg20J0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="V/Lb1iUf";
	spf=pass (imf03.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778237552; a=rsa-sha256;
	cv=none;
	b=Vzw/Npzwmlw3SC8/TZdx3Z1nmn3kI0w5kPdZA7iZWUqBq6EMQO9KQLYTBg9xXXjygm77K5
	pJg+Pjx7qvnztJCu9NKMxVGT1V3Ci5o8Vw2ot65ngBimnZRde9qEElUFnddg6KkL/tYKod
	U5GY5kfg/2et1gsMYjwLtCbw5bc8F+0=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647Jf9S82830434;
	Fri, 8 May 2026 10:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tMFcUg
	6YI0uRs0oFeC5tG4Rvu7Ar3pTJNfqJiF659xo=; b=V/Lb1iUfWIu0JXHYBXssnr
	/iIE/nvjj2aOJUE93RS3rXzL7gDsr/ZzBO/zrmoaf5pDd0ZngHZVYicUpNpiNp/Z
	gPRP8EyUNZXFXS8TQI6mmRnfzR7feW07plzHgrPtMQ5XFfLdP+H9Zu9C3m1hNw0J
	NnjsY1l8+PdXL6wfA54zBYJQsr7RwL2OFSUg4BKTGy/2QsnAtzIsLiKzfEc63x2m
	tMI2QhPpPehjY+o0qYTtHNQd8bwls1SeQoFwt6+9QALNbaTT2aVk8y+QTKuy7cep
	C3D8H/exX5uEia9T+kuwjnXGLs5K95WQw5/Cgq/X2N99gFacWkcG4K68BrYhEKvQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7ubd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 10:52:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648AdaCW026903;
	Fri, 8 May 2026 10:52:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuywfxya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 10:52:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648ApxPQ61800952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 10:51:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B6572004D;
	Fri,  8 May 2026 10:51:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86F6820040;
	Fri,  8 May 2026 10:51:56 +0000 (GMT)
Received: from [9.111.207.158] (unknown [9.111.207.158])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 May 2026 10:51:56 +0000 (GMT)
Message-ID: <606aebad-d83f-4dd0-9316-9d6dad0cdcc0@linux.ibm.com>
Date: Fri, 8 May 2026 12:51:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/19] unwind_user/sframe: Add .sframe validation
 option
To: Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Dylan Hatch <dylanbhatch@google.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
 <20260505121718.3572346-13-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260505121718.3572346-13-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDExMCBTYWx0ZWRfX2auMkqKWq9zH
 Kavt7w6o+5VsedWe6iM0PPPzgQRh4KusiXlnezRf3zsYGS/AO1+pdCbi00e+jrqb4oj3eBWBvWV
 uFfuZ3QmH6iquylpROzws0b7SgAsixvbXKJl/2XoCsQMiOcBzDZ4Sfxopeqpyf3FK5r1zbVIaFc
 V2Jt/34vzxbCvyRZ9+2jxCD98J3PrUFo7OFtFzWy+CYPa8CMyJPgXylbL9E+lBhVIIta6svQ0LC
 zZ9yPoSYIXlPir2H6EWqLJEZ4w5y3FgP/k9xswkHo6EFD+A6jap6eGBvGKpzN8WkHGk5sRLVrgj
 40MLKp7jdLJYQmD02rkYvUkAQOGfdq6sQ2AjAIggoA6O0/PCv9QccQEhZ2HdxYkMB7X6jb236Lo
 sI8TWIY/ZYOgDVFiWfn+1gk8reKmStmBnQFIiIPrVAs7sV8BeDV3MS5LYxM/hAKi9+BloqOHFOw
 MOtkDQlPIadYUtb9lFg==
X-Proofpoint-GUID: MwWipGJ7KURaSVIuB_RtelIYOy5mE4YQ
X-Proofpoint-ORIG-GUID: Ocagi59Tk5URWX8c5UV7KnL-pAuRJkoL
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69fdc055 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=LFt20mCCc4CE-LtB3JUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080110
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F0232000E
X-Stat-Signature: 5qn5kqk51hi89g6o14zxaeojq7xdptc1
X-HE-Tag: 1778237552-312437
X-HE-Meta: U2FsdGVkX18JJTuQS12SF5kSkQGFZAFa70uX4eUOUE7rKze2oM/y9nAe8og3ehyUIYI2LHto6aN3Ty6N29Ek/dc12w5k9Rxab9jCjpSBfjFlBEtBNTfcL8TvMK6PNAiMUaKaBtuwAsZDkX021UOYwK587D2Hvie8WoCTT04OVTtXix/7QwESmcP4HD1QoH1U8WH7LZ3Hy6Sk75x4JefR+ca2Kkh5Ma3TLXTmRaIXQg5ESN3LA5zGjFUYOJUvGpANGRQ/oEKXT/9ym4K0X8x84DBU2KYqwAtzLYE/xPQbElseQ7R1GVnmteR/JQOVQYe71crMVG5gokwsjkLBZHCSXBTFyHoj7bVNfMztonqOYfxMvRAty4wkg2y1D4AjflYwS6q5iTpAlOluawQHt6mcX4Fn4u81yhNT5PPfK9Ar/+vphOU1vlpT6Fv8bE0o/4soEE9j+q2dMz9hIvGP8LPpVMztCJeFZpRO9/42jP70d3tA2l8Nu574ANLDFY35dieScEC7wqlPXI7RO6ecolAoOrVvegCTLiOMXOAfYBaZCzp5I3bb4Idruc4eytKfmrtu9eGG8sr8YLQj2Lu4yHieLpnga+MHtmcxGbxcvuDLHPEfZ06cHbnEYJCvR8eIXaozQ75wys7Zi+LjNMWQBZi/fNL4cy61Twsl+wZ9PaRbs7vBqOF6+fy406Ibh33he1JFVdjv49JxUl+XCOWCANcv0BLeWjVfKgJ+Lk+taqrkzVC9k8nYz97pv2Lnyv2cLJodMe7zeT1nJihOHwcFDGgffTACIS+UsbdvlAWVJkIdnXcAHlKlO+2vWXU2KA5EqCEMrDseaiyELd5AdpvbSU4q7LFgkDfbTNkWRbHUiaiWMYxdYNtI+MFlzgigj3mrL2bsNfuDttNUfwEZvBAExR4n80IjlYEP08dwpVzZAQtdfqTUHsBLGHpuRuLwqsjHvakxH3BQvWG0gEiNKJuce9o
 KkAT7Te2
 DkOFynTw9SzssHpccwWGNSQzV7U7bWn7y9N4OKlrHldPrkKtfH7cNjnjLuejRatfFzyZUPMQGP2Wic6H18XXadxgMn54msUITYE1yUJE0aI3WTbZrTOZpWp/LkOomrUn+/Kf0BgEX8K6Ckl/DvIJBkGnMYUUIQzK5HT7q2WGFloJB9r/7hRgK6dPodZGRJ3cJbwYJSoPgDxwNkLF0XRSpxPvWVFDmlpf8IGT4jZ/3rsBBijWtGmtwWveQ2r4aQCD74Ahxlf2ZeyEyY6gzXyisMg+2GnOgLrOYMbu2lk7aOS5GXUeGt5ExUtWO2sagc6/LS6/GEfxC8B91sqTh5/Hjt8i7aE0QVdbQfdenupwsEAEedhDy9DjOdPSBqIA8bKn8z/dL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/2026 2:17 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Add a debug feature to validate all .sframe sections when first loading
> the file rather than on demand.
> 
> [ Jens Remus: Add support for SFrame V3.  Add support for PC-relative
> FDE function start offset.  Adjust to rename of struct sframe_fre to
> sframe_fre_internal.  Use %#x/%#lx format specifiers. ]

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> +static int safe_read_fde(struct sframe_section *sec,
> +			 unsigned int fde_num, struct sframe_fde_internal *fde)
> +{
> +	int ret;
> +
> +	if (!user_read_access_begin((void __user *)sec->sframe_start,
> +				    sec->sframe_end - sec->sframe_start))
> +		return -EFAULT;
> +	ret = __read_fde(sec, fde_num, fde);
> +	user_read_access_end();
> +	return ret;
> +}

> +static int sframe_validate_section(struct sframe_section *sec)
> +{
> +	unsigned long prev_ip = 0;
> +	unsigned int i;
> +
> +	for (i = 0; i < sec->num_fdes; i++) {
> +		struct sframe_fre_internal *fre, *prev_fre = NULL;
> +		unsigned long ip, fre_addr;
> +		struct sframe_fde_internal fde;
> +		struct sframe_fre_internal fres[2];
> +		bool which = false;
> +		unsigned int j;
> +		int ret;
> +
> +		ret = safe_read_fde(sec, i, &fde);

Iterating over all FDEs may cause __read_fde() and thus safe_read_fde()
to fail if one sframe section covers multiple text sections (regardless
of whether it is also registered for multiple text sections), as
__read_fde() checks whether the read FDE function start address is
within [sec->text_start, sec->text_end[.

See my related comments in my reply to [PATCH v14 05/19] unwind_user/
sframe: Add support for reading .sframe contents.

> +		if (ret) {
> +			dbg_sec("safe_read_fde(%u) failed\n", i);
> +			return ret;
> +		}
> +
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


