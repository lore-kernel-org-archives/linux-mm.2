Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A505FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 14:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940536B0005; Tue,  5 May 2026 10:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1456B0088; Tue,  5 May 2026 10:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8B36B008A; Tue,  5 May 2026 10:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68D3F6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:25:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0A911A0523
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:25:55 +0000 (UTC)
X-FDA: 84733590270.02.ED6DD7D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D17D180002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:25:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kCK8AOLU;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777991153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcbaiPrXeZHYc5M9HkIsXuvWd1b75GWDcR6c1FbMbYw=;
	b=P5Rf0HM8zDv7tPhziiPAmpRpfsmJ2Ik190j8GH7H0Rq7ZGupw09NPJrOAM1zbA4n43mqVJ
	weD8Mzdo+GE1tmLU2uKqcODughDi5V35JKh5WvseqEfSeF67ljDcWvP3hPCkMPQWNQU3x4
	PIgK0mh7wgYsP58Lqdk0ofMh1mTa3UY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kCK8AOLU;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777991153; a=rsa-sha256;
	cv=none;
	b=Ydl4hXZT9DQ6IT125AtzyFPBhqXfptie8M4fRRy1TyBhNNDqTzC1tz/yPeNgxmPnGEVt76
	T29tYBtunFRbFbQIQrfJP7yfeXLgP2m/9/qF6jzWne3yKRS7/xl6QCaPwzLBPC9oUZdzoG
	5o4xudguMNESsMPfPCy7xjSZK2ne1wo=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6458GFvT3351555;
	Tue, 5 May 2026 14:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OcbaiP
	rXeZHYc5M9HkIsXuvWd1b75GWDcR6c1FbMbYw=; b=kCK8AOLUroh6Op3oeyQ3tA
	kzVZqVy8brV9VXXxeWMe1xe0uegxlWAP7GlX8ovDne5GCGOJ6mN9A3M0+tQFZE20
	UTAuXEd/hKZHIZs8OG43OgomII2KZKukRUZem/GJs0sfy9YuMQpVUokP8VRGp6vL
	JYE+nxrBRCmpjDntN+grlI7ctrouR/3JLVJDZB5W5tbJlHV+UI8bCPaHaeHLc8UF
	TydQHg1610Pfo5WZB90/4C/nUKCa8SmXcog7SJZ71loAJvqR88Kk6S/w+8lgjgWF
	u2G30tRfEWu8a/MYl7AjhmB16dpF+9ri5gKb0s98DPHx1vLFSdz/DlD+IgM1lFng
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6bs5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 14:25:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645EOgrs014230;
	Tue, 5 May 2026 14:25:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukqa509-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 14:25:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645EP1Rl29229442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 14:25:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2A3F20043;
	Tue,  5 May 2026 14:25:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C4A020040;
	Tue,  5 May 2026 14:25:01 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 14:25:00 +0000 (GMT)
Message-ID: <d272218d-214d-4a13-8f45-dacd3e94f5dd@linux.ibm.com>
Date: Tue, 5 May 2026 16:25:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/6] x86/vdso: VDSO updates and fixes for sframes
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
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>,
        Andy Lutomirski <luto@kernel.org>
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
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f9fdc2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=0MvmVg10__VCTnNSAJcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: OcluZmLD_x4gMqANWuezmnnGoe4w0tND
X-Proofpoint-GUID: li-2q0iBa1957f3jFzff7LHFnhy2TzmZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDEzNSBTYWx0ZWRfX6Qsc9D8QpNTK
 eVoHxsAXC1MYjkQwzPmUOAQB7ApXGRsFCVGUrUanv9+LtbWXKa8Xs78P+2QBoI1CTlDqq09Gjiz
 oZqcKyVJKtik+oZty+qxqmlj+kMooiyKvLBq+InO1eejVaKGNq7kmyFxN9lSCSsQFrc4dF6RmJM
 ZLddMM8FdmtlaVClPXWPZuFaMqChGvOV0aqCZrB3eWqdvV5q2SYrpm8lyfm+5j0TDhgpvk3sbNX
 W+Zddmf5VVe4Er1Znp8kaceVNpCH5C7lv68OsKF5h8pavFM3mfEi/7YBtcAQ5KrdgqDI5bKQGI/
 RdeauxQ6L2iNSOEYrMkYy6yNVNn4IJ0vz31CtwDVxm+EgcCNB/XWFsrg/UBVQjH9UYxM5/6ryUe
 7QymP34wcEkCc59eKn2qNka3xSO9ODNF2Ucp6Oi5iOXR0b5fDcoAFRink0RblFi82cdTiW7a9Ys
 no2tKJkXF/og3584JYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050135
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D17D180002
X-Rspam-User: 
X-Stat-Signature: y197dtnfn3u6mw15635qead7c7mdfq14
X-HE-Tag: 1777991153-238854
X-HE-Meta: U2FsdGVkX1/5cndohF7lU5llXysaLQFaXR4fvSVN+zL+Ir9T1ZOK5nVnaEx5rV0ThqFX7z7hhoi0AifgzYTeyxjCZN41559x0VVNp+biYj4JAbWE/Oo10ZvRdDaw+7e4aP8eacP3OP1szTOcjZZG9eYdVcBuJWDy+GB36FStFyu4l7A2J7ePLlMmd4cxxRKzEZbnnMU63Kx4iNCbOqhDlDedv6xotYgywfwl5UMeH14abmZHzQt2t2F7FudpcPsdgwVD52QMTYIMg4hkkCtVRdFebnTGedqthMfQZipO8uTONkhSqNRHpCxa4DSSqSw7ll0DqKNb2q+Z6u1hwCcR6CK24C8jUwMgXqxzE4oVYwcKlmEhfzdmfI/s64XRtH07ie7UhCGM5IIxModDrdYv/2exnB4WWTap4UMfb+ZgTN7TvE5W0zviIZBa83w/z0BDVRodhj4GwSNGvCpfstumZdMd2AVMH01qCX+8IRJWPFSyo4/k7z7CH+3XV2BxemK/SfIFxrHKtriYUEydE++0OznG/+x4IxWzHNv395h6Y98ZKJ6zZVt2u9Vh/CVXmVLGt2OTMl+xG8pVJwqg8OROhCTOn24d9MWQ/aWeN6e/HAsy0aKJIeFojQBuYfTJKyh/KouV8cjLE7pQkdc1SzWPvk1pid339+TJTTP0+CZygtai7BZgwiaROmQm4dtRWrjNIM86nkKfW/R3iNppxQ4uWTtxW7K5zUtc/Q6gJlSoDjszBidTbmq+PjvtfduCC7j1Jw8hb9hkW0J1qAInS1LMsi8U84mAPRqAu+9or03a7GiCidd0gPG/Va+aHzUL9Uj/+8lwS/DLJAZaTW/ej8WaYzch/j/S2nsfHWbQs8ku0w/wzvh9PD1vRStHJm0IfHRxtzoYZ0mfb39VQZ4yLOXmF/ABxPd1O2M0C10GF5CIZtBGcKM4ifgyYQmLj5VAvlmtlPy71PVG4HpIaU0+A5S
 SpJN/0ws
 sfc0t2+5ylucFSAsi6oy+pSAgroxHI7+IVpt3CKCNMSW7sd17jeaHbfCu2Mbgy4PSyGxYYfFZRkF2fy846MpiQ56hIL028OuJaO7GPJQvwyFM7gfvOhPvmZkETne1zM00d8emF76IbL3Jyqc6THzceyCvwVhcHqbC1/iFBtvbc1ozffy8L0jR6/i7dvdmxIPdLKkMSqxDp4gf+5n5Kyf9pPiLcI640bLh2A+ArkvPRIq0kS0TEvbl1XwXNF4z6+ukzoMuVCKY0ziEbAKgkljcJCJYAN85t/8X32OOl54G/W+gcsl95tOB7iP7SNAot249l61qMLPxf/HNg69z3UgXNMvtkSwSaS0T2G20w8xxy1slt+IcqctmBef8Ld1dcaH2D5lTVZPHEghseFb08NBqdp4E45l9T1qclx/0TfgBN2AAub5DczP31iK8ldbVHhrUCWG50HpaWHFgF+iyS1F5smqqvUoOxkuuH4XOAV8Rqi7EUR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/2026 2:33 PM, Jens Remus wrote:
> This enables generation of SFrame V3 stack trace information for VDSO on
> x86-64.  It's a continuation of Josh's and Steve's work:
> 
>    https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>    https://lore.kernel.org/all/20250425023750.669174660@goodmis.org/
> 
> This series focuses only on the VDSO code. They are helpful fixes
> and updates that doesn't rely on sframes (although the last patch
> is sframe related).
> 
> This series applies on top of tip:master (a375022d6383):
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  master
> 
> Like the unwind user sframe series [1] it depends on the binutils 2.46
> release to be used to build the VDSO with SFrame V3 stack trace
> information (using the assembler option --gsframe-3).
> 
> [1]: [PATCH v14 00/19] unwind_deferred: Implement sframe handling,
>     https://lore.kernel.org/all/20260505121718.3572346-1-jremus@linux.ibm.com/
> 
> Changes in v10:
> - Rebased on tip:master (a375022d6383).
Apologies for the incorrect series version in the cover letter.

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


