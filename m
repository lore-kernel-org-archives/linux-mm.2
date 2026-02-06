Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7105EE20AC
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090E76B0092; Fri,  6 Feb 2026 10:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069C86B0093; Fri,  6 Feb 2026 10:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADE96B0096; Fri,  6 Feb 2026 10:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6DC46B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:05:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94D9F139D46
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:05:24 +0000 (UTC)
X-FDA: 84414355368.03.6FD9B5D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD5EF2000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:05:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m0DmBTo1;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770390322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+NUvF/1T7B6GCJR8b+rLpDCIKJcl6xd780xFLtfmXI=;
	b=8faradnqyTEiyRJnOn8VKwpD1s8IN+3xCVgxwU4y4YvKsPfVNfsj8lh6y+emx3qc8JxkDh
	r9mp8fA6YvUdn1F2SZeQxP0KUSgJ/yjSiBUeXcVU7QMctClj2NNX/9273qYT6KjbyK7wcm
	kDCQrqkWvVTimhhzJZmrQaEfjRSN+sc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m0DmBTo1;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770390322; a=rsa-sha256;
	cv=none;
	b=00Tr/oQpirv9a+lQPqW90eVqaiBimarAbkdf1rzO5rKtIANBUXimmzhN5G2UciBgFGKLC+
	UpK42r+ihPeUg9OzebZNj7WtO+bLXCBF0vj1XAB0EFHnCW7xbP16Yo9VZ5uxLl1EWfYE5n
	ZhYLW3UrOdX6cN2jzbewwoLm/VT0nEI=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616CIWC3025645;
	Fri, 6 Feb 2026 15:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/+NUvF
	/1T7B6GCJR8b+rLpDCIKJcl6xd780xFLtfmXI=; b=m0DmBTo1W5nv4yaxXixnbz
	FGA5S3DXkdp1bBcl2hHC+7LYI5aZGbS/EaipLdif3b50+7C14Akx4I5lq8W+mjSi
	ImaF+BgmlSswRcEvr7bNE8p1fJTvwBZlZrRZpEVQquExDd+YYPpZx5wUGgo6FcrN
	Z6JI/jUUMA8N7Fvuqd7EYsXaW+W3h15/JeRIwclBY4lF26vJKfTuJ1qwJQnqHevx
	A5Lc0V6PnCw/j4a0XuQVSzEo5FSKMSrIvbXexf5Q74/D/g7Pemylo0AH/x3tbRU6
	ROsDMecWHyC/7oN9xqTm62K994BZcV0IbpioEwMDiRHHaNjmzyu4BOsp1qRj41Gw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtm1ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 15:04:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616F3411011832;
	Fri, 6 Feb 2026 15:04:51 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtm1eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 15:04:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616DpKje027348;
	Fri, 6 Feb 2026 15:04:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1pb67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 15:04:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616F4kgx50332134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 15:04:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFC0820043;
	Fri,  6 Feb 2026 15:04:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC09820040;
	Fri,  6 Feb 2026 15:04:44 +0000 (GMT)
Received: from [9.111.140.182] (unknown [9.111.140.182])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 15:04:44 +0000 (GMT)
Message-ID: <a8274e59-4e7d-47ce-83dc-cfea5c61a45f@linux.ibm.com>
Date: Fri, 6 Feb 2026 16:04:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] x86/vdso: Use CFI macros in
 __vdso_sgx_enter_enclave()
To: Josh Poimboeuf <jpoimboe@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
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
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
 <20260203171958.1522030-6-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260203171958.1522030-6-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwNyBTYWx0ZWRfX74+yGx2tRSMH
 WC5yeiqpYSi0SmiON4O+jYZFhZvj8KbYVCx9Zv5CyH/+pm413HJArNIA559F7TOig3PQWjyluKC
 uRxJsh5Qf4ScNPiJTBRqcS8reZbuwv0Pstpl8nNmbWZoPkY13IY3l96Lu6QfvhWHD6nxKhR0qb+
 kVSzQSEyp8GaHT8Sb6Lvt8Vl1UTOjfK+vsuDm4knZhdaOoHITf7VwJauq3yvEhl2va+JHKWCw6v
 eK4QqLOkqmkhfdCPwE2WzuQDLyXtVLPpHiCo2/WyWDq3yT71yE3KoeI8bFuGJr2JQYtd9geJr+U
 EIGQwEI2Eam+RtBWYE+V0ewE7VfdX/tF6NTrmDOq0s19f/F/Bq1bHVeWcvE1crhX0IBEVVM96+K
 XaPNyxxmPxnYdOgfjZTos7puGHKgjvuHJIrkOWaV3boQ/RENa17dkpaIZuuOX6BAUJgx1ONOlbX
 719YUAKJ27s+muWUTmg==
X-Proofpoint-GUID: XPd4wWwQGmuRjZnZjoB4arIOKbc4d9iw
X-Proofpoint-ORIG-GUID: GmdViZUO-3EVxYkMXdbQPRaVORisp6Lg
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69860314 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=ynVLL-t7yow9N31yAb4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602060107
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD5EF2000D
X-Stat-Signature: spgn3k1bo76zka9ykyz5hm4upqx1mgsp
X-Rspam-User: 
X-HE-Tag: 1770390321-586263
X-HE-Meta: U2FsdGVkX19DoTZ5Mv2ey//LgozZHWOkRCfB6Y6jNID9I/HrefJ6GgOZ4p8LBDvm29mq9P42t5SyeU/y8TcbvpJozBM/xe4rC/LCWxXSIUtmSKwtZlMhl06L2TC69n/MNgtE/7z5sd79L/osPxbrX0KRd6ZlbbADmnwADn+7X0Ce6EL+6ufLKxsueGJZVrx4NdlE+ifVU7hnea3dHebY82W/Ea4jZvlifYEzdaq4Py6k+umPYvdURYJJweD/DFGklpW8R4HK8nMwauWUDl8lilaV5OJGIjZxwcVVJ1co/BpDVmPoVjyejXwzvbTU8TqYZ0+xjTqO3fVnZoc2GynvuMLjnAiuX5x+scvNqRDI9h4QYrsPJltlkQtezf9E+4t6LWU90FcUsIXUWRJxt5s8y5bsSHefgRCtGL1sLh0QbGmu4Vemy69HVq7BkCv/gDR3bnDmWMo1R3ltTqvDGls+lj9Wv5rVt+pFX13jZQL6InvEwNW8d4rXlAC/tLgarMlMwmeti0Dczf+DzkFIIqUbAPCZLqUWolO6eVnUM3+18L8L4yZqdp6goizDTSgnaF9eIWDNFVTOcrFfW92oJMVPgRGSnadiUSoz7mzgd0bvokiZuU7t+Mptjh8uu3sUMVIEPm414P6fJTqrvohKcmiufpD0lhvlG065uBVYFxOFtmAnhn8/hZgFg8t44DntoDlCqUlVC/RbbifWCsP/DYnHZ1xHzxwF7ns9+iHCMu/qPBpTQdNEOAjz6GTjDh5HmcSUgXg6IwQ6QR9AOKinjHCsBBwpnaS+nT+UTjDkRXsrPOhLUxwlqL1QFuwYwCZFjc48dtAlmcWtVA6AoBroXkn8tGOIhdEqSTZJvm1wn27FezMnRzxRo7f9aBYbxn2SN8l/9MUKeeK57FjCP9NVMRKo9llcpUOj+zajgCmcYf/6YA1NxfiTw0m65+yOpNzMJk6AKrTxJ6GIHanbnD8PvBX
 Q9yfBQqF
 26J8LTwZf7Td0KERzZBNSepcJFa6889PYBivuV99fDzfZ/C8n8T9ZfTs/rVOVOPHhamVsrmIGGW1a3EnzpIRuvLU1K8reWp8crBlFgTg41XONgEB11E2OsOnk8oj1MExPihrgZJ90OXbCiMNFRXi2uKJfa4MHeSPBo65M39sqI88uQ3482+KM5iYkrbIjwOf+qChknYc9Vw3BnbpSZgfntZlBxf8la8LJ8TvrkgVWseG2yH9UPGmZCL/9AH/xzq0m5os62ruORLFKoiCiD39Fr4wYQwOSnCE82rkMFcSI7Mu3bKJridgfBt/MSHI9sANBKC1GRWZLZ1tR+nu2guAhjBaTgp/JkEc/cwOM5LUSrJUsUPMandIzPWekg+2r5YPgXOMisFtnDRw1dCr1/6AZ3h3319HzTtd7JbpGfdsIbFkhnR4X/QgLlECowVGKYe+xneCOTS0Qv00ncELd2V0gM1NaOZ8u4k13UWCGx1PhCC9SlxVwCUQjS3tUkzLPsvyc6W3ys3o97dh6OoE8tp36oFIX+ha5d+OAkayr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/2026 6:19 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Use the CFI macros instead of the raw .cfi_* directives to be consistent
> with the rest of the VDSO asm.  It's also easier on the eyes.
> 
> No functional changes.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> ---
>  arch/x86/entry/vdso/vdso64/vsgx.S | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
> index c0342238c976..8d7b8eb45c50 100644
> --- a/arch/x86/entry/vdso/vdso64/vsgx.S
> +++ b/arch/x86/entry/vdso/vdso64/vsgx.S
> @@ -24,13 +24,14 @@
>  .section .text, "ax"
>  
>  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> +	SYM_F_ALIGN

Somehow I missed Steven's v6 and any of it's review feedback, where Josh
noticed that this added SYM_F_ALIGN somehow creeped in and should be
dropped:
https://lore.kernel.org/all/amh7fzsjx4p5nowy3b3j6blkty5ojqf7jawtlslexwzdbxrhc3@zersgacmcnai/

>  	push	%rbp
> -	.cfi_adjust_cfa_offset	8
> -	.cfi_rel_offset		%rbp, 0
> +	CFI_ADJUST_CFA_OFFSET	8
> +	CFI_REL_OFFSET		%rbp, 0
>  	mov	%rsp, %rbp
> -	.cfi_def_cfa_register	%rbp
> +	CFI_DEF_CFA_REGISTER	%rbp
>  	push	%rbx
> -	.cfi_rel_offset		%rbx, -8
> +	CFI_REL_OFFSET		%rbx, -8
>  
>  	mov	%ecx, %eax
>  .Lenter_enclave:
> @@ -77,13 +78,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  .Lout:
>  	pop	%rbx
>  	leave
> -	.cfi_def_cfa		%rsp, 8
> +	CFI_DEF_CFA		%rsp, 8
>  	RET
>  
> -	/* The out-of-line code runs with the pre-leave stack frame. */
> -	.cfi_def_cfa		%rbp, 16
> -
>  .Linvalid_input:
> +	CFI_DEF_CFA		%rbp, 16
>  	mov	$(-EINVAL), %eax
>  	jmp	.Lout
>  

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


