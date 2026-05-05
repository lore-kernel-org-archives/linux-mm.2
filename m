Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB10FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF57E6B008A; Tue,  5 May 2026 08:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD0A6B0092; Tue,  5 May 2026 08:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3596B0093; Tue,  5 May 2026 08:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF3EA6B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A62316049A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:26:07 +0000 (UTC)
X-FDA: 84733288374.17.41198CB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F439140006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:26:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GIM2vmV+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCOWk4XOOb4vtcraw1379WOq3zAGck0wfj3WDT9TNJQ=;
	b=LdLPEwBOhJgblyVuf5WSa2JxHDC+1/5G3TnVT0ImHyig5YB61PSxmAaJyPgCMaZksLz6uQ
	aENlSoolDOr1f2q3KGH45bplX85TW05GSzyPNLG0QqwaTiPRSRTWNQjPItrVUqcfaKwyiE
	vwDMTpP/VP9wKnKzVMiD78NW8ihP/hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983965; a=rsa-sha256;
	cv=none;
	b=tPaq/g9HcR8bOSn/LtR0By2nOJyfTlVYvinRhlb+VnMwGICN6ly5erHdXFUfRlj1NECcVt
	wBnKaYJ4fZHzy9LyxMeiWQ8cwHf+R/qc02eOxvozI4i/fZLwTOr0OAnaupvSiJW6TBQwWF
	zH4t02Ihol1HdLcwnsKMkRpqBqkXHl4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GIM2vmV+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6458GFjI3351555;
	Tue, 5 May 2026 12:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iCOWk4
	XOOb4vtcraw1379WOq3zAGck0wfj3WDT9TNJQ=; b=GIM2vmV+9wx6cP+IduZG3B
	TI0bMI/1ja4/d9+QjEs9nzDQtIqhrhiRMix7vC5oJEucMH1Z6RHEQi36+sgtLfiY
	iTTHnFwL8PrBQk9WWK/Rj6DELX36l2id3xcsK3XbmubmyCRKZQfztt/FhY6Ochhv
	jbRnckLaHYXJu3kv9JrMHWIkcm5wi4DRx3UnShZ643ThGZguxNZfFZEDFemb1/Ag
	/PoN9kgG5biOexWa5iQari9tI7faj58NCwCl9+KcvTXHC+WWJ1QmobcsrJ+y2Uol
	CgrDUyisrCeHvUZBHImiQRW4peWLd2zv1JX9/8xsNU2pB/LVvHLZd6WYJqhleMNA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6b8cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:25:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645COPCC016264;
	Tue, 5 May 2026 12:25:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjsgwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:25:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CPeWe49545694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:25:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A12B42004D;
	Tue,  5 May 2026 12:25:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 020592004E;
	Tue,  5 May 2026 12:25:40 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:25:39 +0000 (GMT)
Message-ID: <6eb9cbb6-c997-49ee-97a6-66a721073846@linux.ibm.com>
Date: Tue, 5 May 2026 14:25:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 00/19] unwind_deferred: Implement sframe handling
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org,
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
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f9e1c9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=lNt1pmmDVPWPLV_8P3QA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: PLhVfBiZn-aSt5WckmzZBbYhLO1gOr68
X-Proofpoint-GUID: ybGT5PYqAhNLFmbquT73cbhc8mA2NIVX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX4WxFhGafDnwu
 h4Uo06QecP4Z+vTG+IBqEHK5gaPO6wxJxl9Xj3y/JBtxdsWpyGnyFFBxbKKoXMRx0aBFnzT0fJ+
 qkv+m8GgjVrSCFRe1VR26p5tq3ifVWviMJmFQ70DVSLUr4OILE9VSOybjGa2u76pBb6+4wnLBHN
 9LMzeJ13JPvZmu6Bqieop9zrVlm7hAV4jNqEUTdM6Zbx1UkfjLo3m2ZR87T+L+kM7oHML4EnfCS
 DRH6KcksTuS8yfL3/sXkVP8UnNXurhrYUK1pVWKyahQQQrJPL5lnBIHMNq8cyum5XYYVFxpP3Vb
 hKX8V8cpgTm/cqtriKD4P/FZp/uWa9+7d1ZE7AO8b1JIkaqqXg/Cpm6Stnmyzr/YugH0hAk6l0f
 Vk8cUNNr24eRLvwuAHY+vf+Y/JeEUjYBxDvzXGcRmc7oQ8YdpP4hFApjPJEEv0tZP0kiKBfk1Pa
 R0bLN4WHhLyjB+DpeDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F439140006
X-Stat-Signature: 7a97q58fk8zxcgah7wbhewe17ufnb84j
X-Rspam-User: 
X-HE-Tag: 1777983964-973144
X-HE-Meta: U2FsdGVkX1/k72ntSlBYWhzxMHcN3i0ximJOEWMXbRfJZdHeHIdIZik7RXHXeV4YhnNVL65ai/aqCkWnzwFjHBPyxk0XkWKUCwLbV1MasXCdYR+8Yr4JD9Rix7iA5vw+AT3+OqOjH89vd6UbaMuPW7I6aKNW1Y2MQVp2BO+r4Bhlmr0EQjx6mv90IbIig4PmE46q80VQcrLDkuFXPYDtVWwx3ojwUjHjeNjAEcdrigszbGbhMES4Qd1XB7bvnTQEFhG4MyN6GC0k2nD50XQdfC6loQbTm9CvtZUr+78sqwj2P4freqxZAP/UX9ErLB6jTnbROn3Hqo3ODtJpKrvhCmP2AUh7ZPtjzgwAr5WF9URKQuGh324a1wO+yFfmsUwv/iZBQkEcWYYOGhjpQ0qv327JHNarbb9J2GIzTaalZIHd60bqjq3BbLIDv2X5uv3OEWVJCoStvpdn2VXK5ysmETA2iLEVDzmOzcTuhPi1xNWN8aChMadVZ/hbHcqJg3A0qCyOYVVzvRTYc81ypAi5FPtzbULXDB1p0Mpco4rL5bL9xisVTam5CZt8VnDjVtOcYdM6l71TI5kwxCjquwrMsWuihC6k6L5Ay6PoWgkRPbH9SIS6AEHGQk0oQ6P/RnAixM/1kIfUie0UvUa0/OgZ5+CctEjwruIhfWReHSP33ABnzc54Du/LGwz1NoKLEk/QAwz8KzFxDXMFuc2wPyMzaREUTlTvm30lw56h8/u07ETrzW/sGDTk69MBHmmcwIFpes3Xe4m1UBPfvlDr7y0LSpPgM4xETl9sRMHOf57Y4ZYiDN1PjzgnaKDV8rFathK1JO9tdCHO5vYQhvFBBQh8mkVbf1a7hd34bOyUsfrbE+VmcUr98eHMfCpuindCiv5t7hmDSA5lqpNADCJ9rqkZFsi96/4AKTmm5bfTTmZajXt8XrHBbffOVg0DuwL1qwuPLrVpuXs8s8+IwZnUZOo
 7anhwUwA
 KeqVZHgtfuHy4d0EGqQ7Uwlel8UxMKiMj8eVlLweT5DtMfPh/kox5yIijxBoUtal54OEVuThhZ0Dj+AG/kAvh1vrDIS5aQ7gKoh1ky0Jkpn+zjyovfE3ZMDHmTupJoBgeRXSfW1m5Q4Q6Wl5dtqEk2Pvu+8l19IuTJld7jQURqNr18h1HkTJzmn0jfcxr2NTjYVwTyt4O0fOfdk6PuobA1xTTgeKkiWEmN8rK+GvAGCZXA6YDtOPuZ62hHVutorX03urfh45C9F2/NaLoPScaBOjEr3lT0XFYM0Gc4clj/y32I4Hz0nic5nlPkfr5VFPxwxn3IsioqlhF1xYshbZVi4rs4H8g/8Ay/0rXV/BA0rUrIGYYAk/ubZ6fNT0lKfNZWq+I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/2026 2:16 PM, Jens Remus wrote:
> This is the implementation of parsing the SFrame V3 stack trace information
> from an .sframe section in an ELF file.  It's a continuation of Josh's and
> Steve's work that can be found here:
> 
>    https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>    https://lore.kernel.org/all/20250827201548.448472904@kernel.org/

I forgot to mention that Steven is working on a system call for dynamic
linkers to register .sframe for .text in dynamic libraries (DSOs), that
is supposed to replace the last test-patch of this series.  Feedback
on that is much appreciated as well:

[RFC][PATCH] unwind: Add stacktrace_setup system call
https://lore.kernel.org/all/20260429114355.6c712e6a@gandalf.local.home/

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


