Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E36FD2D79
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FC96B00E0; Tue, 10 Mar 2026 09:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF37D6B00E1; Tue, 10 Mar 2026 09:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D56F6B00E2; Tue, 10 Mar 2026 09:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87D5E6B00E0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:09:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0575F1401AC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:09:24 +0000 (UTC)
X-FDA: 84530184648.28.CE3C2CF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F59040013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:09:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eKXAjIAQ;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773148161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=De3BmUR/fVp2HRwkz1vDBQc/3iM/oIA0Ob2vAv3cVR0=;
	b=jPHo95V8gNA/Fa5yBNlyZSCiB8lFp15lw6aAq3yamhcm5xiZPDJMLK9qo9fmOzvKouzJpy
	0yXJ6omX3QckxCccsTol0jlgoLnNnSQnItR41g8QSumf4EhQ/saeRkwvgxkLdR8IzGmlz0
	rgFSizEylAXpXW2KPmbSlvgTa7b5glo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eKXAjIAQ;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773148161; a=rsa-sha256;
	cv=none;
	b=pD1vqhz/d4ElCGIpeZW/4pAL2382ZVPJ9c2FcriCPe/rDxgcB4jLN/9ZcXFr1vfS0QEI47
	A0bF1Yu8jqI50JSrnrYlYSGGcv/S2gZqBeiWW7UVkihxeaS/m7wKukPMzHNyn3Gj/mYZ0V
	tXc7Ph4bGBekfcs162JUyYl9vf/xXts=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629NSQWl641632;
	Tue, 10 Mar 2026 13:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=De3BmU
	R/fVp2HRwkz1vDBQc/3iM/oIA0Ob2vAv3cVR0=; b=eKXAjIAQPEFYC71ThcLitu
	kecSm078+NgPMP6u1bUMmq2hLmumEUiEIJRn5PNG039Lxu0fOKz2s213mNU+WJFq
	RM4p/dFgnlLKBo18oAp+zjFx6JYFZNmT82Wb53bfiIvKSpL3OHqbbG3lSnpTSOz+
	azLwrpy5EtgHun7C4RzJDcYO1wVwI/nlwCA6bVHCqRqkV7Lm2SSavHZTMrqQfadT
	pZYVWTywEqkXvC9VcE1ARFzRzMSTCBpIdzYWoX0TGIubr4JbSdvXOy/0emunY4zq
	Y+JixBoNWNjehSPLMHvrLM1UXd/HU9KEX6KAvahfhzFoo5DBut/G3O0PC+kwRbAg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvmb024-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 13:08:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62AAEpV1021172;
	Tue, 10 Mar 2026 13:08:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbssa89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 13:08:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62AD8jCY36307420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 13:08:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50C1D2004D;
	Tue, 10 Mar 2026 13:08:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F3392004B;
	Tue, 10 Mar 2026 13:08:44 +0000 (GMT)
Received: from [9.52.200.149] (unknown [9.52.200.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 13:08:44 +0000 (GMT)
Message-ID: <3d9cdee6-bff8-406f-b2ed-40df6ca450f3@linux.ibm.com>
Date: Tue, 10 Mar 2026 14:08:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/6] x86/vdso: VDSO updates and fixes for sframes
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
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
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 7vjkImBkAuczBtQ8WEn7Wfoh2iaA3T5G
X-Proofpoint-ORIG-GUID: WarMn3BsPH2iU_rGZcaRWlmBrbOlI6pE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDExNCBTYWx0ZWRfXxPXTI3S/wt5V
 u2Q7FvO4P6OODjsFQfMczt5mSSXa6jXyiKIOXW9yKy0pd6pWFsCLS95tVPE2AWGaZJsvUdzjqAz
 hCi1mL/ONSs2DUzx4JETthFAQsdaWrcxt//dLyvuAWpsy15Ootg3YD2KbGjU6iKIegTmVaDZ+Ps
 PedLK878panxPJ2/L6+BrNv++Dn0SbtrCTtZiPp0T+Z93sumaL9E6+4NdHWHNa6aqQLhYrXu4XB
 yzMSzeUSZCt7o6MU+89jxA6ye0zT2XfbGhFBGKLPHVeBl5SsRmVUNVb9hSRmU86TEbc4LXsgSM+
 FoMEJOuHnQU6s3FVHrH5ylq7UNX1vs+H37PUB8+thUTfLsks+JuoK2UCXtJqOkcs9JdOLWZwiTf
 aQAWYApK7+nqrSmhvUwst72g/NVf8B60otD7CFg+Dlv1ON1xrRqxfkF8jq+Pd3JWMj6YXRXTTmN
 0dC80PPkZY7m4VId0cw==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69b017e2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=0MvmVg10__VCTnNSAJcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100114
X-Rspamd-Queue-Id: 8F59040013
X-Stat-Signature: g8wraieaaf9nm6yam9pxr597nzdf7fkj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773148161-825016
X-HE-Meta: U2FsdGVkX1+6kF/Zh6KMzl8644dB/DBPdJobFBoUcxIOVjZPf3kxE0tLHXiWN/sFYO2WPSOT2PM3vB3ehdIeL3w+BromL+rykTONEmKijQASjcOyaSsugvAF8pDkAsTsJbYcqLPkivWIdDtN+O3HWSRYn8VVG99XT0C+cAvpxg3FgNRS99c//KqLbrB5YcjuWikL4cxZSeO96sV6NaXav4w7PuIrOh02w2hFWm/+wen9N/wo9avLBrHEVPOzLyf+miy5qefOzktVjhfsBjesM7/NEzprgfn+n9Hsaryj3wYGYI9qc72Cf4Qd8b/icYs8UtHYEnw92RLOr9FgyoiTk12AftjTlnskVr67QWxFpZT/Ui4emxO9Nx+kEIE4fRpQZdvGrENyEXhPygkbkn2C7aDnpzqjJ6ug7ggJjtJu8P/xlSoQTzGvGwbnGWi7axOgb7c/a/jKNqH0d7iyTIZd1uu3AOm4cyD0n773NXYsFKHgDJcwvqgAGdUvGx390ZgjSMe2wKriUR2ALLeDKhXtswLzo116q1AwLWoDfGbcvG+V6q0Yfvwk96oUoHyq1xTngHV7KCfdlra8TqRjg+EAuGAYazoVcSY+zJR1tDfpjwPETJSsnHgQBB3PujzkxZ2ojOPg+FCIAAsgrHRcrk9OnpCbro6zaC82JwQQoEECGReelFZY+iLtvbpVGp6x64m90MKCIMv7kvcg9QZQIAsgPuHUTgLtV1/LWAyCwfExsgz+EfZtMQ01oeQ1BLDZ99RsDwxeYjWyB7yccBJnfvcmpvDfnrKP9HVZM50r8C8bW37N+0onDR42udqL3fxevJyzUAxr6Vdw2nRQnZI8OFzUC/yVTxCSDNY4l1FsAZey37GVk8D2EF217MO0d9blgvajAYx2MHDMZl1CvsXPdyY0g7WrUFjVucBvM+l5KHVh9eNIQ6uDgEAGheBM/wY91/8PmE+yHC6/4Meg8aSuen0
 ExYYzrIV
 ONaFL+3YvnN/QUgHVqf1YTgtWkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/2026 3:13 PM, Jens Remus wrote:
> 
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
> This series applies on top of tip:x86/entry:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  x86/entry
> 
> Like the unwind user sframe series [1] it depends on the binutils 2.46
> release to be used to build the VDSO with SFrame V3 stack trace
> information (using the assembler option --gsframe-3).
> 
> [1]: [PATCH v13 00/18] unwind_deferred: Implement sframe handling,
>     https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/
> 
> Changes in v9 (see indivicual patch notes):
> - Always define KEEP_SFRAME to either true/false in specific VDSO linker
>   scripts and use #if instead of #ifdef in common one. (Peter)
> - Reword patch 6 commit message to provide more details.
> - Note: Binutils 2.46 with SFrame V3 support has been released.
Hello H. Peter,

how do we proceed with this series?  I got your Acked-by for all but the
last patch, which has all of your review feedback integrated in v9.  Is
there a different tree I should rebase it on?

Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


