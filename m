Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A734ACCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA788E0043; Mon,  3 Nov 2025 03:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB358E002A; Mon,  3 Nov 2025 03:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66A88E0043; Mon,  3 Nov 2025 03:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF9F98E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:33:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84F521A0AE5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:33:37 +0000 (UTC)
X-FDA: 84068632074.29.FD1B1CA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9B981C0002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:33:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SIJzn+1B;
	spf=pass (imf20.hostedemail.com: domain of sshegde@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sshegde@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158815; a=rsa-sha256;
	cv=none;
	b=w+tqGl43/YM9N4raaaKbazWv69Yz0AzE4DbC7lk2b0Ygksmea1nu6IRJAsWylxe5oXJU+V
	XtvL3p8e9krwcaLBC2TeF/m20abkut7/AKBX337ABwe+B9c6wf5Q/G8SRypiv3Jy05Ifjg
	4zzvPO2eQPCmz0uMXIeIwjQV/tLxNt8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SIJzn+1B;
	spf=pass (imf20.hostedemail.com: domain of sshegde@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sshegde@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kvXegtnHGH2dvhngivPl8vSn9VVnbxianx2ml6At6Q=;
	b=uSyPmIjMvojmAU11Trx/EKbNBPPICxbS5P5LmWvtXSjbK4KkuMdaszjze2HVHHddKN1wZ4
	XGlXn9a3ACNyy7bL83YhBFwivg000rMEW0NOsf36p38cVVjTyWnlcjdpDq/2AP2uLSV5as
	yJwYErvVX8fLGBWFD80e/FyUZRCWOic=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2KFI8K004420;
	Mon, 3 Nov 2025 08:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6kvXeg
	tnHGH2dvhngivPl8vSn9VVnbxianx2ml6At6Q=; b=SIJzn+1B6W9oM2eaoy/YHg
	eBBigTFYyvOI9FqFVbAxNQBJk7OsJkIcL71Bfna6VZUkqh40c7GapUFYZ5iF8sRv
	Gr8dTXMymRtZJ8s++yexWv1ij7wo6VYhShrZhVDq41yj75ph0JeGVCKADK/YHtTq
	GX3MIMDZ/N5qqAEIbGF00Q5htF6MOC+XL4hF518BX18l+iJjxcQbmu4bDG1zmjC4
	JaRrWPwAdwUgpIOYFdxBzdZMRCWUzsW/HgM451x3+JWx1KfcwQmlDNOkYt4NhTIW
	gRD9YIaV0/uJm8zB4i1DBFMoHs18pKBmB/HXGu5E8lZ+lxXr3R2rXIwqr6iKj5Pg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xbnkvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 08:32:27 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A38WQmQ029518;
	Mon, 3 Nov 2025 08:32:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xbnkvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 08:32:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A34SfIE012891;
	Mon, 3 Nov 2025 08:32:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y81mbvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 08:32:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A38WNYw44106174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Nov 2025 08:32:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C27F220040;
	Mon,  3 Nov 2025 08:32:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16F2220043;
	Mon,  3 Nov 2025 08:32:13 +0000 (GMT)
Received: from [9.109.215.252] (unknown [9.109.215.252])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Nov 2025 08:32:12 +0000 (GMT)
Message-ID: <dee4dc13-b187-42df-93ce-f738cfab32ea@linux.ibm.com>
Date: Mon, 3 Nov 2025 14:02:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/29] context-tracking: Introduce work deferral
 infrastructure
To: Valentin Schneider <vschneid@redhat.com>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett
 <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>,
        Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>,
        Petr Tesarik <ptesarik@suse.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-24-vschneid@redhat.com>
Content-Language: en-US
From: Shrikanth Hegde <sshegde@linux.ibm.com>
In-Reply-To: <20251010153839.151763-24-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXyZF7uxWMbR9h
 eLK/nkDGQm3o/vMS6b4dMArF21TNJ6CaqoI+fi7VPIcu7OWjh13TfAaGOyTxh1gnwQIWiBKHjJa
 4uMwIrzLslo+qUygbHd9488ZCjL6vK5iXuiWUNX6ThTOzJBP1PKCUz5zZmvloNgyToR45jE2irN
 a4EYP7E5d99vyLe0EnPUaY+AWXCKsxBO2ENMsQJ0K7+9kC0+hwsMybY4fCkeMcwmUxF0SvKxntf
 G1Y18toiIF/maL5RFi7povbdJ4FJNPvHT8auC2LdGyFW5VpJAL0soYtskChjteGM2wfpc+kcC7y
 KDSiIb0W+R7wCTgyXcXkjXUndM3ScPyUHlasPD5janXDgGwLZxidSrdWYD0Sch6Yd3oNTOJv1+T
 flE5Wy2KQc8LqVOKJgn3Dc1iG4Hf4Q==
X-Proofpoint-GUID: U84lOeDC5Q0AhrPIqcAHknHeCkhsE8rA
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=6908689b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=e3ynTO8eh5RAdg4_BR0A:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=UhEZJTgQB8St2RibIkdl:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: Yw4-ly9gm_lGmLrDsIj0uqTuFktFQQKI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021
X-Rspam-User: 
X-Stat-Signature: duyh5389x68aj3w7aiyyywmeup5tbbef
X-Rspamd-Queue-Id: E9B981C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1762158814-214985
X-HE-Meta: U2FsdGVkX18QZZt3OWz23e2URBi+ldCbyYIbtTv9WuCfg/8zFRQmfRJOi35CRBsI+o/poO4nj+FugbQpa0EWH8LmBPOQIa1FI4GnrdCr7q/5m1HcH7lLwi9W2fugldVG+V2moM0erZzoxRL1lH0R55eBR5HyGruJAQCxmOi+HBnmenjz6LkEpVgPTq9FIBfGasMBodBNJ22+6hhjSvzAq+YWYfW4fI0GSFZz3x7smLW0J/v6RsCPag+ggbngBAhs0J7jhzo9mwjFcrCY0jXIQpUwRMvvISj7NYb4zupVuC99rDPsS6WavcvZ719LsY3Lx4dT4OKpTiCfOncV+CYgtflJkv2Apd/r7qghUmorcokwNFwe0NmrZDYKhMZMBl66JgjAi4NuRP+UF3R7ZVQqP337DqOwb4fCDlGcAtOhI+uuuc+2CVERO+2MQUKzuVOFVvjjqznZVPizgw/pD0UFtYuDUs4F7ZFrGXakiwcdXjRxEVTIfsbEV3DV/lD41b8/5Pl8+KelH4dPjpSs/gpDg1mrvzHOp9Snudt2Z/2ZhlhRiURmuToKejOGqDpzgt6/qPF2rVEJ+qrrVAEkeVObGjbgOs9oI6InEY2gfR3MpX/CXcASyxA5r5S2eySjaQEp1IARaSqlZa0ZVHq4JhzRAFFCe8U3TZAah7/pmFDHg/10yEC0H6JAIN7vbvjyqcK//CA/jd7QayqiunjXd5acpeGKjHY6V3jGdnyKGxjTo7tzenrgGKJxUuiCmXTC3icHm8td0B4zI9jVCv+BiLuDC27X+eLx9U/+YrdXi5ZbNMTmD7SXGPPLdtfKgZOR6AcMPQK8MvyJH+2z+6PnrDnHiD+ZuNiLZrrYaLFQvPevRKL1Cagzc5H966/RR+0BQhLLMUe+B/6a3m74yHjz4tRnKosl96/wlqZtI4uUF3Guay7SvOzIWNB8PZtppKTEyX4e90N3dJZECH5jvmlC1/8
 Kn9l8vzf
 3eVq8aynzmZoxkzj3ApmcxKq/+v0HeutVerGxZIPFzchE8V9P3/xtsztm9tKUegBBEXKBbG+k2IF4iBOq9kq0w7YdK59/6gizs3z99bElzoSIrViPbJlAt1KxbttZ3GU2nNCnmeq8mWqcRXAJ2ShSPZmFjVRY3htFbQFxdU5N4NNUGgnb41UYXkRwRgb4+GY8PUqGMULwg2KOSKZi2rZ9+kfYSgj6iTcnJlbC8n+KwipH6373ZseCxrW/Kzv3EBp55pRuWegIAluZPDZNDEvZchspZ1J78lmX3r0MjcxbSt/pGBzCLCBm+WBXG7efABSDLYj7Ltm/37CqmE7TuF4XhEPOd8Wt+jqgoimj2NQ3pKoeYk8Fhi+eGb4ktUE99mnaHVYeIOQzxOem2tz+eyxDrbiK9YSP6uukxisuc8G0GxpniwNQeeUmabHvsGsh5fId8HL1TbaDArEzp7mi7mgsi1CimJ7xTFwYJXVdUUR5ExgEy7aKqwxaEabI4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Valentin.

On 10/10/25 9:08 PM, Valentin Schneider wrote:
> smp_call_function() & friends have the unfortunate habit of sending IPIs to
> isolated, NOHZ_FULL, in-userspace CPUs, as they blindly target all online
> CPUs.
> 
> Some callsites can be bent into doing the right, such as done by commit:
> 
>    cc9e303c91f5 ("x86/cpu: Disable frequency requests via aperfmperf IPI for nohz_full CPUs")
> 
> Unfortunately, not all SMP callbacks can be omitted in this
> fashion. However, some of them only affect execution in kernelspace, which
> means they don't have to be executed *immediately* if the target CPU is in
> userspace: stashing the callback and executing it upon the next kernel entry
> would suffice. x86 kernel instruction patching or kernel TLB invalidation
> are prime examples of it.
> 
> Reduce the RCU dynticks counter width to free up some bits to be used as a
> deferred callback bitmask. Add some build-time checks to validate that
> setup.
> 
> Presence of CT_RCU_WATCHING in the ct_state prevents queuing deferred work.
> 
> Later commits introduce the bit:callback mappings.
> 
> Link: https://lore.kernel.org/all/20210929151723.162004989@infradead.org/
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   arch/Kconfig                                 |  9 +++
>   arch/x86/Kconfig                             |  1 +
>   arch/x86/include/asm/context_tracking_work.h | 16 +++++
>   include/linux/context_tracking.h             | 21 ++++++
>   include/linux/context_tracking_state.h       | 30 ++++++---
>   include/linux/context_tracking_work.h        | 26 ++++++++
>   kernel/context_tracking.c                    | 69 +++++++++++++++++++-
>   kernel/time/Kconfig                          |  5 ++
>   8 files changed, 165 insertions(+), 12 deletions(-)
>   create mode 100644 arch/x86/include/asm/context_tracking_work.h
>   create mode 100644 include/linux/context_tracking_work.h
> 
> diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
> new file mode 100644
> index 0000000000000..c68245f8d77c5
> --- /dev/null
> +++ b/include/linux/context_tracking_work.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_CONTEXT_TRACKING_WORK_H
> +#define _LINUX_CONTEXT_TRACKING_WORK_H
> +
> +#include <linux/bitops.h>
> +
> +enum {
> +	CT_WORK_n_OFFSET,
> +	CT_WORK_MAX_OFFSET
> +};
> +
> +enum ct_work {
> +	CT_WORK_n        = BIT(CT_WORK_n_OFFSET),
> +	CT_WORK_MAX      = BIT(CT_WORK_MAX_OFFSET)
> +};
> +
> +#include <asm/context_tracking_work.h>
> +

It fails to compile on powerpc (likey any arch other than x86)

In file included from ./include/linux/context_tracking_state.h:8,
                  from ./include/linux/hardirq.h:5,
                  from ./include/linux/interrupt.h:11,
                  from ./include/linux/kernel_stat.h:8,
                  from ./include/linux/cgroup.h:27,
                  from ./include/linux/memcontrol.h:13,
                  from ./include/linux/swap.h:9,
                  from ./include/linux/suspend.h:5,
                  from arch/powerpc/kernel/asm-offsets.c:21:
./include/linux/context_tracking_work.h:17:10: fatal error: 
asm/context_tracking_work.h: No such file or directory
    17 | #include <asm/context_tracking_work.h>
       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Gating works for compile, but no benefit of the series.

+#ifdef HAVE_CONTEXT_TRACKING_WORK
  #include <asm/context_tracking_work.h>
+#endif


I have been trying to debug/understand the issue seen with isolcpus= and
nohz_full=. system is idle, even then it occasionally woken up to do 
some work. So I was interesting if this series can help.

