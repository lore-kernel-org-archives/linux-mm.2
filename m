Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D770CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4DF8E000C; Thu, 23 Oct 2025 12:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C768E0002; Thu, 23 Oct 2025 12:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B158E000C; Thu, 23 Oct 2025 12:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4468B8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:05:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA257160BE8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:05:17 +0000 (UTC)
X-FDA: 84029853474.18.46F251D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id CCDEBC000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:05:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k6CK3FaL;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761235515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcW2s3Fa+q4vWajBFsclXMOAOSDRCnv8z8Qb6vE7ohA=;
	b=PXSTD+3XWSC0i0F4vEmY2Coej+HhJEzYUyto2rDkHz0P3Oi3I/eamPCQvZ/lc1NBsdeQjl
	iTEafEPEAbW2vRc6nLskXTfZKDiVIqyF5K+knY3wgwGGZ7OvhJZ2RO+vaVPcS4Ze03AJKm
	GMzlfVaKOKdEHWs0Iii+PXhPsixrhME=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k6CK3FaL;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761235515; a=rsa-sha256;
	cv=none;
	b=OIMab4sOrn6gFq6/F6wCgVzVxbZLOC/GY1b2xZRfLR+3a+yLnqT1NlwWJnUf8tOpHWgpph
	1yZ+UvIZYPnl+UsXvLanD9GdKaj77AoC/SPJt12kW4f0uLpHLk5PyRh8cfeQDucfoLGZSH
	Rn2RLVHd3TUJF+PXNj6JOxN4NgdgzmU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N8JWcv014261;
	Thu, 23 Oct 2025 16:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NcW2s3
	Fa+q4vWajBFsclXMOAOSDRCnv8z8Qb6vE7ohA=; b=k6CK3FaLLc7xFjQIr8BUd1
	EDRrtPNXywRn/lscS+tLIq1BPthOAxAoW3g8HMNoyziKANzoIHCaT6ZXTEncDcjb
	QdvmQWSl5GOasxtPPD0yY66FSHANlesCCRnnCRnLk7L3Pl7lrTP3naQQ2MerEra4
	nB75u5zNs95+wNs5HpYmuAWH8X4vx8wuIBz2eghcDAgGmQbWhz22l82ZnP4hLfIa
	uoAg+ejuSLDh9Ns2fbn9EyxSoKzAZuSeTtSuF/Lt5TxJGgujscG9OIEE96vu0GCq
	N6e7PW/hF7Ofwlm0X6PKkbD/OKP/+gTNluigA4aBkFAQ8Du4pqS86mIoo0+7LR6g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31chsy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:04:43 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59NFrvGr009892;
	Thu, 23 Oct 2025 16:04:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31chsy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:04:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59NDI0B5017052;
	Thu, 23 Oct 2025 16:04:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnky6rs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:04:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59NG4ck436569352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 16:04:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5F4B20040;
	Thu, 23 Oct 2025 16:04:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4C6820043;
	Thu, 23 Oct 2025 16:04:35 +0000 (GMT)
Received: from [9.111.177.23] (unknown [9.111.177.23])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Oct 2025 16:04:35 +0000 (GMT)
Message-ID: <f855f1d2-35dd-48bd-8de5-25d850d02d37@linux.ibm.com>
Date: Thu, 23 Oct 2025 18:04:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/15] unwind_user/sframe: Add support for reading
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
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
 <20251022144326.4082059-7-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20251022144326.4082059-7-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fgZdUdnGXaTGdSaxwNUvOB3JNAYR6LNi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXxYbS0I7ozNJu
 olD9B0XrJZvSbfWDUx+3Sqi8NpgFB0qU0t9tF3zQUoxXU6konKgOnhszhPE8oKGWiHUdHJDRcxd
 8ViieVm5wekdYLpFm+A73xS51SQcgkuIqX0ZHn44aDXIv9mKhhgTU+DAWt+oY3jEf9jyb+boa+4
 2xXTCGYi1ry0HDJGM/YBzRGIE6ezhP4kJnR18shXPDs6fjx3gE9FoSvvMsORWfBL99cPC2Uzglh
 yxkGESRMvyU6jsqz+4p8osiKrJ/pnJIambuKHpfbM4t7mWotdI+baOH96LqBsK+tqCHsKUE0Ynh
 69QOh0bOVtLgmzhG4Fdq55SCCx5oLsMJ1ERVjiS8s9cs0pOygX5YySe6VpgcegnZsG2yX7z2rDZ
 jEXEfZR1fIaRadv1ly56Js+HF/U+HA==
X-Proofpoint-GUID: j-aP8M5YiDrfT85xUy7fTFBSirXnKljV
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68fa521b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=s6ekHP1XpJ6eNOeT0-oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCDEBC000C
X-Stat-Signature: 7q169rgrshypbx7x8tfweykqedzigizr
X-Rspam-User: 
X-HE-Tag: 1761235514-429445
X-HE-Meta: U2FsdGVkX18TslNXt2j3NqwwYA3XrbstkWLuKXA2ObRJeUM0pcBcP06ew24rg6MNu0MWLHmNxVzWtyVSpeJAWuLhyMGAX5qfDkqD/N9BRkArEDgb2bsNTCOXH5TcUALTbDh6M+bU2UF/SHz2zYacDvQRyIu6JQK0oQ1Xpu6pv4NuRSvxxSB1N82zmVUVZlwoGQihpII+KPX4QXLQmf3HVaghZf64IS2YxloO9Z+lMfSgLpwF0XF4UfTvHNREHlEYUiBsi0ECHLNUWlsCkytwYe6Vrai8mdxjhY/ziYDqgkoPAnFDrnW0COzFszQBMvn2oVJdSU7vvj8wiMMUcwo2vXcJr3ei6m2lfS1XAn1Ai31Gi25glQNrIo+4zL37vMfBom5ThtAFXbT1eZ4JIAtcVUygnLGa1iCq1VA3gfnl1ud5ITSyFlMye0BF6NeHk7ohVSnQ0V8/mU3ORdkbDHbl8gq9iC5xhywl1P3aZlPzd/lY/m6J2B27SlfYt9C+gJxyXhEkFXpOkj7dbNwZPZc6uG1N7YjiVzgUZ0v8VD/NQPce4QvCUHMU+LKs8D0c4OOGPPnjl1qDYRFQekEKHcrvujXeVaxfdK1w47vQtCVjqJxyskV32hKeL13l/alN2CG30XpiqTwzOBoeVNPCs06nzhtjG1M06gIInGWDPtWma4aFAuDysFQYilGboCqKx72qTrrULmL8l+ZVDPo2fx0V19klegVaktdbrkm9KBZOqGv/zpuX/cdrmfsWvhWuZcNchGq/Gg84RJ4qvFO5Zd4mQEwP3oQs3U1TJ26fy0QSRSRbra1ptF1EAbhASS2D1FPth4ITRxzpQvELbuTFXbOUE3YUvF367DUR8GSNaanQu9A8V6Nwnt+ab+E4/t6Y/lZ/ybkU8pyLegGqYUKUJmDEhV5BE1bXzddOniQ/j3ZM53YDJOjUe3/JUa81xeW3w7BgbF9Nc7SqmMpsEOx1Mdv
 MY+e8usv
 kLbmuKEfrEk5bfSvkb6G6gRxIDLg35YW8+stJF7T4jBFuYzbk+87Q2jSRWfMYHZTmuwu0i1+KMXm1KjZv9xhvjJC39li1RVOAtqCm336ONFkA6gGUacNSb5Mk4b4tFpJ/AOPlzyTiNt/nEBAiwQSsXvHq6Sr/c+0KaSQRkgM3s+2X7jy/+jz9O9yRCE3s8RJ0Ezh8iVFt+eiNK2Jj398xO69023BTptCU6S/B4edxI1elBmGWwj7swtkGLoXKRdkhO7ZvTKw2WMGgI4id5kJrV5RLviENXbeCJumucYLxDrGFgOlvnuLbomLIX0QlNkyUyG389acbzQwNipju7ov1/MOdSjOorEGAfOiJiHNBvpAzJ74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steve, et al.,

as discussed during yesterdays SFrame call I will be sending two RFC
fixup patches shortly as POC to demonstrate how this patch and
"[PATCH v11 14/15] unwind_user/sframe: Add .sframe validation option"
could benefit from introducing an internal FDE representation (e.g.
struct sframe_fde_internal) similar to the used internal FRE
representation (struct sframe_fre).

On 10/22/2025 4:43 PM, Jens Remus wrote:

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> +static __always_inline int __read_fde(struct sframe_section *sec,
> +				      unsigned int fde_num,
> +				      struct sframe_fde *fde,
> +				      unsigned long *fde_start_base)

The goal would be to eliminate the passing through of fde_start_base as
well as the various computations of the effective function start address
(= *fde_start_base + fde->start_addr) throughout this module.  The
internal FDE representation could then simply convey the effective
function start address via an "unsigned long func_start_addr" field.

> +{
> +	unsigned long fde_addr, ip;
> +
> +	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde));
> +	unsafe_copy_from_user(fde, (void __user *)fde_addr,
> +			      sizeof(struct sframe_fde), Efault);
> +
> +	ip = fde_addr + fde->start_addr;
> +	if (ip < sec->text_start || ip > sec->text_end)
> +		return -EINVAL;
> +
> +	*fde_start_base = fde_addr;
> +	return 0;
> +
> +Efault:
> +	return -EFAULT;
> +}
> +
> +static __always_inline int __find_fde(struct sframe_section *sec,
> +				      unsigned long ip,
> +				      struct sframe_fde *fde,
> +				      unsigned long *fde_start_base)

fde_start_base would get eliminated.

> +{
> +	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
> +	struct sframe_fde __user *first, *low, *high, *found = NULL;
> +	int ret;
> +
> +	first = (void __user *)sec->fdes_start;
> +	low = first;
> +	high = first + sec->num_fdes - 1;
> +
> +	while (low <= high) {
> +		struct sframe_fde __user *mid;
> +		s32 func_off;
> +		unsigned long func_addr;
> +
> +		mid = low + ((high - low) / 2);
> +
> +		unsafe_get_user(func_off, (s32 __user *)mid, Efault);
> +		func_addr = (unsigned long)mid + func_off;
> +
> +		if (ip >= func_addr) {
> +			if (func_addr < func_addr_low)
> +				return -EFAULT;
> +
> +			func_addr_low = func_addr;
> +
> +			found = mid;
> +			low = mid + 1;
> +		} else {
> +			if (func_addr > func_addr_high)
> +				return -EFAULT;
> +
> +			func_addr_high = func_addr;
> +
> +			high = mid - 1;
> +		}
> +	}
> +
> +	if (!found)
> +		return -EINVAL;
> +
> +	ret = __read_fde(sec, found - first, fde, fde_start_base);

fde_start_base would get eliminated.

> +	if (ret)
> +		return ret;
> +
> +	/* make sure it's not in a gap */
> +	if (ip < *fde_start_base + fde->start_addr ||
> +	    ip >= *fde_start_base + fde->start_addr + fde->func_size)

Would simplify to:

	if (ip < fde->func_start_addr ||
	    ip >= fde->func_start_addr + fde->func_size)

> +		return -EINVAL;
> +
> +	return 0;
> +
> +Efault:
> +	return -EFAULT;
> +}

> +static __always_inline int __find_fre(struct sframe_section *sec,
> +				      struct sframe_fde *fde,
> +				      unsigned long fde_start_base,

fde_start_base would get eliminated.

> +				      unsigned long ip,
> +				      struct unwind_user_frame *frame)
> +{
> +	unsigned char fde_type = SFRAME_FUNC_FDE_TYPE(fde->info);
> +	struct sframe_fre *fre, *prev_fre = NULL;
> +	struct sframe_fre fres[2];
> +	unsigned long fre_addr;
> +	bool which = false;
> +	unsigned int i;
> +	u32 ip_off;
> +
> +	ip_off = ip - (fde_start_base + fde->start_addr);

Would simplify to:

	ip_off = ip - fde->func_start_addr;

> +
> +	if (fde_type == SFRAME_FDE_TYPE_PCMASK)
> +		ip_off %= fde->rep_size;
> +
> +	fre_addr = sec->fres_start + fde->fres_off;
> +
> +	for (i = 0; i < fde->fres_num; i++) {
> +		int ret;
> +
> +		/*
> +		 * Alternate between the two fre_addr[] entries for 'fre' and
> +		 * 'prev_fre'.
> +		 */
> +		fre = which ? fres : fres + 1;
> +		which = !which;
> +
> +		ret = __read_fre(sec, fde, fre_addr, fre);
> +		if (ret)
> +			return ret;
> +
> +		fre_addr += fre->size;
> +
> +		if (prev_fre && fre->ip_off <= prev_fre->ip_off)
> +			return -EFAULT;
> +
> +		if (fre->ip_off > ip_off)
> +			break;
> +
> +		prev_fre = fre;
> +	}
> +
> +	if (!prev_fre)
> +		return -EINVAL;
> +	fre = prev_fre;
> +
> +	frame->cfa_off = fre->cfa_off;
> +	frame->ra_off  = fre->ra_off;
> +	frame->fp_off  = fre->fp_off;
> +	frame->use_fp  = SFRAME_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
> +
> +	return 0;
> +}
> +
> +int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct sframe_section *sec;
> +	struct sframe_fde fde;
> +	unsigned long fde_start_base;

fde_start_base would get eliminated.

> +	int ret;
> +
> +	if (!mm)
> +		return -EINVAL;
> +
> +	guard(srcu)(&sframe_srcu);
> +
> +	sec = mtree_load(&mm->sframe_mt, ip);
> +	if (!sec)
> +		return -EINVAL;
> +
> +	if (!user_read_access_begin((void __user *)sec->sframe_start,
> +				    sec->sframe_end - sec->sframe_start))
> +		return -EFAULT;
> +
> +	ret = __find_fde(sec, ip, &fde, &fde_start_base);

fde_start_base would get eliminated.

> +	if (ret)
> +		goto end;
> +
> +	ret = __find_fre(sec, &fde, fde_start_base, ip, frame);

fde_start_base would get eliminated.

> +end:
> +	user_read_access_end();
> +	return ret;
> +}
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
+49-7031-16-1128 Office
jremus@de.ibm.com

IBM

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Böblingen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


