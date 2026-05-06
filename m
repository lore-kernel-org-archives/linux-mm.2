Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9457ACD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD8A6B0005; Wed,  6 May 2026 10:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E596B0088; Wed,  6 May 2026 10:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CC26B008C; Wed,  6 May 2026 10:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 657406B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:10:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27AC0140277
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:10:19 +0000 (UTC)
X-FDA: 84737179758.25.701219E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8626A1C001C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:10:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A4PcQv80;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778076616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF0B3PexmDAtg/xwB4TCMJRjL/G29AeOJJCuvLBN0CA=;
	b=Lomb8h3FZFawT2TjIwptL3WNdoV25LArWBriElDWEI+U5jzYbLEgsmlsQiraw/a1O/RycO
	zCcIVexlGPvAQGlDPcsmnT1S72dii9Twnb05nA0I3stnYww8Wup3xxuzAn9fcW39BFxAfU
	CsUW9DMLN1LO0ZTEf6YJlPcsilqt2lc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778076616; a=rsa-sha256;
	cv=none;
	b=Wgrvb3ALOuJyH3lqy74Y+yHya2EamXGfnahKmXn3dnfA3R8pPP8eUn7rua4RcH8nov1S9V
	5KXRj3D5bGTOvih9JQzoVQ8HDd9e7nj+hLMov17vBLDW+eOjmLIKQhT00H0cu5WlkJ3zoN
	qFAtlxGP4ITvNKPHF4IvL5YH4v3Goqs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A4PcQv80;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64603Hqv067384;
	Wed, 6 May 2026 14:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JF0B3P
	exmDAtg/xwB4TCMJRjL/G29AeOJJCuvLBN0CA=; b=A4PcQv80Y6uXsYnj/xcjKv
	lhPmppnvmjqg8UNaKnJiZAooW6REJg5TTT94G0vCbZlKc4xAh+l9H3u5WbDjM0WL
	H6H/Pa6zPcZexVH2AKwgsNzNntr5PsLvEfFmju16Y5BeGUVwTJYw4rTgvcmOvWvA
	z3B+zvl2B/UrUc0cCNDr2Em5mHkZdvzC0EVcozoADoyrm7P0FefaTHHZmf36eYEw
	thCXbUuf/nosZPcgg045QagkC25xNqShMXBbF50hcQa92S19k1epTrzVW9D87mW/
	yVmob9GOeXEh1dDf4w4KydfYZH91KqkychHBoem45zF7ZYAmHPXD2XXx+B5dLL2g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1h24p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 May 2026 14:09:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 646DsPQL022750;
	Wed, 6 May 2026 14:09:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtgebp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 May 2026 14:09:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 646E9HGe45416810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 May 2026 14:09:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C63B42004B;
	Wed,  6 May 2026 14:09:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1546820040;
	Wed,  6 May 2026 14:09:17 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 May 2026 14:09:17 +0000 (GMT)
Message-ID: <9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
Date: Wed, 6 May 2026 16:09:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/19] x86/uaccess: Add unsafe_copy_from_user()
 implementation
To: Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
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
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
 <20260505121718.3572346-5-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260505121718.3572346-5-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 2IiCT--Vp-RQVdUGSeMKj3NgFgjYnGxT
X-Proofpoint-GUID: KIizt9F92xnbY-nhRloRCta2VU3AXvFV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA2MDEzOSBTYWx0ZWRfX9/D4gt9JjNe3
 1dGTBSo20Nns4lWNkY2R57YNEBhiw6CjJFOYeKzOR9Auu8huq6ARaFbnF47vfs0iqzUPW0gQX3g
 Gk41rjmpwgzcz249VYsMTvez/E8WZQYBZY1oH3thtWHPZ97uWr18xWwOD8FHwgsCOPM6ysBPTlX
 cpL1ZL3m6lxsNe3O1IZ5qRcKdZwj7plK/csqi8Re91a4zGvn10HTOd8S71AZu/ipZjT4xPjqkWu
 f2AxY/01ggJqg/drUjJZxHCVfM1csDHt9KekdvSqv+xhOh/mtOzkF4P0S5XjhnXyQ9XbjHSUZcv
 7+ZHoSzHJED1lCNCurZ2wA2Yt4ZNRuqVCSxa1uWf/PhP3uLF2I9/QuRIUYLkTNgp9ddF4o9rNcp
 cpkEn9w4R6MMVSZWxLaMfCySy3maOK7BsokLWqbFVmrxKkBmW+om+0qSPpiN+JA1ilkuA2lomMF
 1KA7rirk8Kz+7jNbuJA==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fb4b93 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=LFt20mCCc4CE-LtB3JUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_03,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605060139
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8626A1C001C
X-Stat-Signature: 8m1penx5y6sdo9zkfoi47ro9qnbd39hu
X-Rspam-User: 
X-HE-Tag: 1778076616-503234
X-HE-Meta: U2FsdGVkX18oYbbvjDAEmJ9391dPeuHLun/EZVzVNifxsDnYbYPINX2wAjoo7PKbmYciQxQ0auRsUbMqwwVfqZeyO9dZMpHFOTbCJhQdnJGp+PN5AN7yoSXB5bJSSBroOnk+Mwi4tvARwNDa1FkWnx3HVI9FUwpSe9E1YQUmqhZC7665LH9FdD9y0eNt8wNi+bIf5rN2A9bmgfuLxdRp5Ub0YpLHpepU95PSWFmFXNhcG0L8sCnrGot7VSTLmlrVb5xGSUWX1ztkAV128dcr7FfA/OMZw7GcDEOptID+FigwLfs2M3W7o6wDjYBc64mXRMFjxU02SH+dY87+KM6jLSxUrQIY78E4yo4RjxvZ/szDcQTj3jasy1V9VbY+furPGBc7OQ1mRO7T2o8LicvmbjBbptwYAkkC3kcBCGI4EiHowb/PGVzKOEvpCGG8Fy3gFoyeMeDnPVA+BHSfU2GR0MfrCTLPrhQpVhDbs3+mgOjI11temChNsslPrlW1Wl8Abq+ujZOOd7XNSxkwdWiFCQJjXWp77pGBN2fqA4BlceMfuk4Ydc+5kJypUavc/GzB0uDsNFo/bid1A9mGqai39cHWhCUC32GF3b5NQ/QfpQVPYt6KTCNj1Xf/QcoXDafxwGbmlxJRQn9MjXoiwTlk2u4E0Mtkm6bQsiQG2rb/IY3wiZB3pUixr4iqKQ+qjwatrci6H7O9ZJKiIf8YLZh3xcBCD8ydauqFEI/mPeBNvKt3YfMhhtrqwZP08zWwgHuUPq2fXIP0ZUj5OTpuvH0qL5IQM1ea6n+iUf3Ocjpfq4E/Q6YVNOdfSTw55hE0NRDXeLJYVqjrtWACnzMOsJjrf0jnyjB5VIR/FPBPifC3qrGxLNsjJALcsk+40QMOEXZ6eMUChJadySLANSkMiAN3Z7rflYIwyy2mDb04BCo9t74zgaIi8lvCb29yBTdpMz0Sj3oIl2XbwnVLyuwNsC6
 ZM3DuP3l
 QGMXSRjsxz65HGOTRhT2NHaBnh2f5liuCFQlVDRteFSlmBS1thmZl/ydAg1RDEM+9yY+5ZW8nykCWRTFsxa2vquaEARXmklvwrMsNjRxk2TEEOYyIySnVIFX6gnye6uXAFe254Uli5VSUsTmMnQv7dmhHk/KOFxhmc+IQyZ8XWuZJ/Le1jZheYZHCYHcDF3EvfdVFW21/In8Tvd50qdUEs8mCk1OHJBfNCKr3FSXqs5LI+plfMmcbJ86mTIBWrY9WZyJghIqOp21eMtLY429ngF0+sBR9baSsU9WRSVnT8A+Joc/TIocELnIBrOQTFmBxp1/2fd5vO4ejci1Ul0sPLklxX+GNImz1ZA0WAg3OQHdlfUWNeyLs5TPSwO1pEln61RmBf/LZfW9H0CyQBLt4FmVfqP7/ebobuVhrZe+T7vVYwo5bZ4lnQBKIDVEMPpNXA5pkES3U+MNnWvUudYs/KkXylcw2HmvmJtJT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/2026 2:17 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Add an x86 implementation of unsafe_copy_from_user() similar to the
> existing unsafe_copy_to_user().

> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h

> -#define unsafe_copy_to_user(_dst,_src,_len,label)			\
> -do {									\
> -	char __user *__ucu_dst = (_dst);				\
> -	const char *__ucu_src = (_src);					\
> -	size_t __ucu_len = (_len);					\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> +#define unsafe_copy_to_user(_dst, _src, _len, label)				\
> +do {										\
> +	void __user *__dst = (_dst);						\
> +	const void *__src = (_src);						\
> +	size_t __len = (_len);							\
> +	unsafe_copy_to_user_loop(__dst, __src, __len, u64, label);		\
> +	unsafe_copy_to_user_loop(__dst, __src, __len, u32, label);		\
> +	unsafe_copy_to_user_loop(__dst, __src, __len, u16, label);		\
> +	unsafe_copy_to_user_loop(__dst, __src, __len, u8,  label);		\
> +} while (0)
> +
> +#define unsafe_copy_from_user_loop(dst, src, len, type, label)			\
> +	while (len >= sizeof(type)) {						\
> +		unsafe_get_user(*(type *)(dst), (type __user *)(src), label);	\
> +		dst += sizeof(type);						\
> +		src += sizeof(type);						\
> +		len -= sizeof(type);						\
> +	}
> +
> +#define unsafe_copy_from_user(_dst, _src, _len, label)				\
> +do {										\
> +	void *__dst = (_dst);							\
> +	void __user *__src = (_src);						\

	const void __user *__src = (_src);					\

This was suggested by Sashiko AI review.  Any objections?

> +	size_t __len = (_len);							\
> +	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
> +	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
> +	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
> +	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
>  } while (0)
>  
>  #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT

Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


