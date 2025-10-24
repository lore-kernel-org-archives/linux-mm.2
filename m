Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC79CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84148E00A0; Fri, 24 Oct 2025 10:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34378E0042; Fri, 24 Oct 2025 10:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FBFC8E00A0; Fri, 24 Oct 2025 10:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 897A58E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:29:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39076160EB1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:29:51 +0000 (UTC)
X-FDA: 84033241782.23.1AEBFFD
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id B376C100003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:29:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V04MSyAs;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4oMNta2EA5ONs6LrrVjbXVDCb8udFX3XWucqebTej8=;
	b=PJoe8JrFTVAyXRrqV4CjBrRDStETyC/bz3MoMlHt77e/fA+kyRygzegiUgL06cGKyZntre
	QQ9K5UQR4ZhOKhr4RN9gbNUjea3J+O5BCUZz3nv7H3MNNhgXPDd9n5ifX7ojyJ2GUGwz5m
	eCpQ+j/Y94BhLyO1GgbNZPNVNAlsoUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316188; a=rsa-sha256;
	cv=none;
	b=DqtutBM3SL4d7AWgaZCc/PHg/app90wxOYuhdzAvOXUtoPToBJhWRvWT1cBforfpox9gJQ
	g7JeaKW94M9zR18twpsmXxnqA/EaijRd+r6MhZZkwnRxWrVXdPUZ7ogMzwcZnbv8lZNAID
	JSfNfMowU+mJYL22XgXXVDzHgPuRK/o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V04MSyAs;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O8VK8h010609;
	Fri, 24 Oct 2025 14:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v4oMNt
	a2EA5ONs6LrrVjbXVDCb8udFX3XWucqebTej8=; b=V04MSyAstrmDLJINvm2cvh
	VH4O7MmBLQ3A+6sq6zY+4LDsmeUvK2duNA0isw6qpilo4yeVMbE3+37QAxnkVVpJ
	XfKdQkwZU3GHDE/jGuYXgNG3VM6Y8+guEtdgTgM4VkDzvUL82AEWk6fSmA+tmeLV
	mxeoIz0imRO3xrMbRLyjVUGNYV67h4JOlzzG9PLz+5A/+Y95lj/J8MuX7Yuv4bCz
	ZZA+L324/3yYOY7ZYODoWvAkpmtEHIxPpyvP5QPXKPFi2Omi7Ymcdih9YFKkShP/
	RT9LDFDayJBr5zurxg+pCuU6j3FzCirFbY5/3XI7l0zM1paxidN/0/58y8GVDhLA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30w65vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 14:29:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59OEPFuZ011350;
	Fri, 24 Oct 2025 14:29:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30w65vj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 14:29:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59OB8wi9002488;
	Fri, 24 Oct 2025 14:29:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqeju9tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 14:29:14 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59OETADX38994314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:29:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82A4720043;
	Fri, 24 Oct 2025 14:29:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8233F20040;
	Fri, 24 Oct 2025 14:29:08 +0000 (GMT)
Received: from [9.111.177.85] (unknown [9.111.177.85])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Oct 2025 14:29:08 +0000 (GMT)
Message-ID: <6b5c0c64-c4da-416d-a103-8d6ec2f06a9b@linux.ibm.com>
Date: Fri, 24 Oct 2025 16:29:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/15] unwind_user/sframe: Wire up unwind_user to
 sframe
To: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu
 <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
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
 <20251022144326.4082059-9-jremus@linux.ibm.com>
 <20251024134415.GD3245006@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20251024134415.GD3245006@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ykpf61_8y0gZ-cwvoWdHTyYd4VO3jyTg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX+6YJFqcIrYau
 FfAiginkKWCbTRDMMfI4es5x0Gv2LrIgpMT7B1DW1SUwfXR+r8YvBgLHibQikeToBe9tDf9Su8i
 SNe406UM1ZQHVDOOe7bQLmK3YmgyoFsKs3snpKHi1zjEdyPg/untiqR0sx8USLZ7DslJvwuVXtX
 7uov274LjKqmA7OxgZlmpdrURUk0CEr7LGSOd39WYdiUPx6BHVrf74M9u86J8W6h2C5teh/wZnT
 LzpVbaclqQLW2t3ExBtkH2EeFZY8j3Kcro2vvFU8HWwqbKP+gaXumYanr19g8i8GnuKTvD5En7N
 CxKPz3S4KFbu+pLcYBRBXfeJa+wunvpVdCfE3NPMCJ4iUwiLX6zytmxsVam68rJax8xxt/LSz2L
 xwE2cVaqDY9a72MNQPfsV8L3ZSYvmg==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68fb8d3c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Z3Xqy3CnV3LH82Reu_wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: T5WOf74hicSV-YNKqrY5feRRWuekCWRm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Queue-Id: B376C100003
X-Rspamd-Server: rspam02
X-Stat-Signature: i9scz961j4q9xapp6dce97jnzobhr456
X-HE-Tag: 1761316188-266342
X-HE-Meta: U2FsdGVkX19aP3UbvjMVvLny5LietvRs+9UH7WigZ3ZS9C4Q5lgpBEWfEzy0RlU0St9YW/1U7w1UwFp2Y0KhomNUzoVHkI41MXu/Yf9S0w6wAfSgRfRg/k5taFOAAOMIl8m5aoF08Yupul+OMZNzuz2mygvKaS/vSV7MdqDV18D/+gI+aX7ky4SZiNCX3cgnwl/E/RhqydVDN+x+fF+cqGz+1jvWiVln54jtaDWt5l6ON2VXYE72UviS4AqRHBOao5HDH+eNtCE0l9VNG8KdTjEgPbirm1kJoioy1v6Wdg4FTgzb+REqlSpyIjFTpexVM4CPXnpLa6eiwPE+cFW6FfBK1QBxyqEjC/Hkew4psnX04jS3PbtmGz1bRKCb5q62RDaz9xBwUKniK0bsrnPKH+ZQi+VytzFPHDi/kEggrJo6aufzGgWhIV6VRxE6a1cBnHiOH5pDPR2bFvvMs7g8NGFCco6ruGXsazDJZMOBJU8EOzzr3WSKcwChWITAYTDK5YSLYrE5CfK/UQQBYd3llAcu3SPyvQ6c5UNPgoAFrrpU0ko9Qncx0/lApi2dj4LhPHJ0UqaLS3r6a0uDbDSUIEGwZRjcBvdoFnZYrBxuIBgNCcZ3XVcnuojiVb5FefJVaLUVGZejm7DsWAAXqumVreDMWtv/lpdWlqjMO0IupcMyu1Z9zcHbxtv5+ux356+G8VsMMJk9rzBvrDNCvX4psn1Hzm7TjJ1/HNkB7Q1scIocgAmKLWsq60eXV4LrPR+WOa3AXoJY0+kQ7KXS4qGMR0d+udbJ4t9zgcU2JkSuYD2gZbLmogVufLUpaCnUEaMUqIlcXdQRYqCU1VHDWrmlLTwcrS9BhcoxTSGD4i+mX7vXX+daeFAcijfxplsGKYXm/JILdG5W5sdUf0cr9Zh1QdrAjF6NZI10X+Fky0xZtGoqePTJdbEso4i1VgX2tKrrwOaJbLBDT/2WCDgryR2
 zak4vv0u
 YTaDUKpoAUApSiOcQt3F18wE9kDPJbhgSB6x8Ay9pLTVyw2tDv+7Mr653BmszI/54WVaI04Sv+zXukmLLK7rbr1NG80MAG1bdVbdXqE9Sqwh/cBEFTn9jm/3Z9PXz/7kGuUAaAB3LTp13z1M+fRGTUTQBzf95DBkrbK4TSqC7NW/g3s8GjfD6LNxX9BIEZw/sOLerGjntmfsJHG2NoqrFQ3rFo2dxMh6jCxxyay9lDtTILDIKmAxPYq3j0p4G6OhZOozbkJ9ed8kWo7uA4chO5YgXcrUBDJIqB4sDIdr/QKI15mWfHUSLBdxFuOZ/IAwCyEhbz2tQOOO1Bts8ZkBBsEy33DczQiovpFZr/aM6QOzA5mJ9fv7RX/dgm94J4FSgKgqDvIh0D9Z6G3Z3Tp77HB7ftoW3GjSOd7E2K7Op72lWb78x9CfXWW3zWft8L0Ip4zVGV+NgUbL0sOhRmm2bt/u61ghg0Jx30t90WXs+KO52UeMbOLzEcWpNdbeJQPJtAlVe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/2025 3:44 PM, Peter Zijlstra wrote:
> On Wed, Oct 22, 2025 at 04:43:19PM +0200, Jens Remus wrote:
> 
>> @@ -26,12 +27,10 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
>>  	return get_user(*word, addr);
>>  }
>>  
>> -static int unwind_user_next_fp(struct unwind_user_state *state)
>> +static int unwind_user_next_common(struct unwind_user_state *state,
>> +				   const struct unwind_user_frame *frame,
>> +				   struct pt_regs *regs)
>>  {
> 
> What is pt_regs for? AFAICT it isn't actually used in any of the
> following patches.

Good catch!  No idea.  It started to appear in v9 of the series:

[PATCH v8 06/12] unwind_user/sframe: Wire up unwind_user to sframe
https://lore.kernel.org/all/20250708021159.386608979@kernel.org/

[PATCH v9 06/11] unwind_user/sframe: Wire up unwind_user to sframe
https://lore.kernel.org/all/20250717012936.619600891@kernel.org/

My s390 support for unwind user sframe will make use of it, but it
should better be introduced there then.

@Steven: Any idea why you added pt_regs?  Your v9 even had this other
instance of unused pt_regs:

+static struct unwind_user_frame *get_fp_frame(struct pt_regs *regs)
+{
+	return &fp_frame;
+}

>> @@ -67,6 +66,26 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
>>  	return 0;
>>  }
>>  
>> +static int unwind_user_next_sframe(struct unwind_user_state *state)
>> +{
>> +	struct unwind_user_frame _frame, *frame;
>> +
>> +	/* sframe expects the frame to be local storage */
>> +	frame = &_frame;
>> +	if (sframe_find(state->ip, frame))
>> +		return -ENOENT;
>> +	return unwind_user_next_common(state, frame, task_pt_regs(current));
>> +}
> 
> Would it not be simpler to write:
> 
> static int unwind_user_next_sframe(struct unwind_user_state *state)
> {
> 	struct unwind_user_frame frame;
> 
> 	/* sframe expects the frame to be local storage */
> 	if (sframe_find(state->ip, &frame))
> 		return -ENOENT;
> 	return unwind_user_next_common(state, &frame, task_pt_regs(current));
> }
> 
> hmm?

I agree.  Must have been a leftover from changes from v8 to v9.

>> @@ -80,6 +99,16 @@ static int unwind_user_next(struct unwind_user_state *state)
>>  
>>  		state->current_type = type;
>>  		switch (type) {
>> +		case UNWIND_USER_TYPE_SFRAME:
>> +			switch (unwind_user_next_sframe(state)) {
>> +			case 0:
>> +				return 0;
>> +			case -ENOENT:
>> +				continue;	/* Try next method. */
>> +			default:
>> +				state->done = true;
>> +			}
>> +			break;
> 
> Should it remove SFRAME from state->available_types at this point?

In the -ENOENT case?  If the reason is that there was either no SFrame
section or no SFrame information (SFrame FRE) for the IP, then SFRAME
could potentially be successful with the next IP in the call chain.
Provided the other unwind methods do correctly unwind both SP and FP.

@Steven: What is your opinion on this?

Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
+49-7031-16-1128 Office
jremus@de.ibm.com

IBM

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Böblingen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


