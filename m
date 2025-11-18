Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8373CEE341
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E15F6B0022; Tue, 18 Nov 2025 12:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091E36B008C; Tue, 18 Nov 2025 12:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2CA6B0092; Tue, 18 Nov 2025 12:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D78CA6B0022
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:05:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 778FA1A0108
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:05:34 +0000 (UTC)
X-FDA: 84124354188.10.BD016C0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0318180004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:05:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jii8NTfp;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763485531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijA+HIYuNJYIZMsvTMim+FE9fA7c8Iz2SKyOURAWHGI=;
	b=L9YJ7UjEkEW8DyyMr2dmKcd3u8FygOHckQayVSnaVWYhgWwRYcABTqljnYGTrK8MSaTqU9
	PJXz/xmofY1nDpAGas3Y1ih9vJV5MSlzWh4ppZTgpTkPc+kkdIUBAjh4ylI1grVoxG0rNc
	v7JPGC1YBkZK0iv9IP4GpffZpsfEB9k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jii8NTfp;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763485531; a=rsa-sha256;
	cv=none;
	b=ZcxvbY10VSxF7TPwU/BvumWOQEmKay+qZIl8SKZZCTxQRFjyEvOOdVArh0/32eg2MwnS1w
	KSQ2k3gsKwn5KtwV2NHwxIgVrfAtTNx6QRtzsEq/0iPt+ASBCStgV00N6WRRsNtIKqiJV8
	dG2lveOj+YNBxAZYxRdiA8nrTUgrtAI=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIFb44q028393;
	Tue, 18 Nov 2025 17:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ijA+HI
	YuNJYIZMsvTMim+FE9fA7c8Iz2SKyOURAWHGI=; b=jii8NTfp+CrLguiMc82UnJ
	a2AIDpJMZDmZjuML9w4Ac49hUCgw3CvbueuulWJImn1RwJDNvZNFxcVgCoUGPF5Q
	8Cf+BcS++w9IKJuAFc0lO5TvFVsedfK7XKOUfVVj7uYxIVobnNCtySaxgxpnr4KY
	amz6U5pt6Zf0U4OSU2uh7XbKfkX83NRfwHFcWkkgcOGqh/Gx9a/TjQbHsYmiu7wL
	+m5X2Acn+pWDELYlEPzBUo+0ENzk2K7SExETZ0Ct8yGWCt7LyU6pMc6/8OhgW2HB
	NVL/WRkS/b2rhhK1xGJ1YK8/EI/F4sncANiDxK1R5EWjcHuH0V4KbB1QxY58ZVMg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmskr23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 17:04:34 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AIGq5M7018669;
	Tue, 18 Nov 2025 17:04:33 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmskr1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 17:04:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIFE2cV005137;
	Tue, 18 Nov 2025 17:04:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bk46qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 17:04:32 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIH4Sx657409922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 17:04:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 731132004D;
	Tue, 18 Nov 2025 17:04:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9933E2004B;
	Tue, 18 Nov 2025 17:04:27 +0000 (GMT)
Received: from [9.155.200.37] (unknown [9.155.200.37])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Nov 2025 17:04:27 +0000 (GMT)
Message-ID: <e5c5e17f-1efd-4f9e-be2d-c6f65003ba3d@linux.ibm.com>
Date: Tue, 18 Nov 2025 18:04:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 03/15] unwind_user/sframe: Add support for reading
 .sframe headers
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
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
 <20251022144326.4082059-4-jremus@linux.ibm.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20251022144326.4082059-4-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V9xFeZ-ISUTWS4Yz3HEfN4KzcAl4q8It
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691ca722 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=5IsC6wTpv4i_iJZREhUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: 4sK-gnDjYQrV3c78NwXR2VgwKDcxHk0C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX00p+GvsXwWsL
 99UQLrEJdv/87Bi9UJUR/dzFbyC5q33Ywzwyelr5euiJ6eOjsZPGpV3i863qQ3mvTXK1pTP9omD
 88h2NYITEfIluJh0shbkujutN+JXsCUPRAAWQ+ksTE9OM0KocFKUEMfUFDudi98m1GuuXUmgoxC
 hNruG3iuHIVzjV/Uj6BPjATiIQXU4JaqBU1wDuE7NtGrjTBi6fixDiiUPPdm3GcyJvG6o2SSI/z
 0L1X1ejxZNmQI1oT677RzJ1dten6eO5QVp9NwKpQod5wB/k78SQOFbiqOwU8hqb3JL683ezSfmI
 HIEfiQ/Avvxc3odgSASGXHuox7weRkZXGEdQ/rsZxrXXu02Yi60E23ujRvt2Bcmf9J+jEjTNlSf
 /jDQJJefA9+M5jmGSO3/yqTPa2ATwA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0318180004
X-Stat-Signature: uediy34qhzexnjk7z6ha46rkth53wh4x
X-Rspam-User: 
X-HE-Tag: 1763485531-833698
X-HE-Meta: U2FsdGVkX1+9zM3uzxJUfg6soBiYEHR5IUpXJKjhYaF8tdwAODNqaRtO40fg4XxvHOaEoF11zVrD91D5iBl1lG8JBwIj54f33dqt8SUIJyJnaaR41bjU0j6arwcnToZIJ8XW+25DjSkIsb+zaP5D0/3W4MeYIWkoOFudupxrJHb9872B3E0akkhBsYLLVIHjlqpEbOdiYkpRFmHJK0Ub2TEUy8uuOBlFbDVpuqG0yQsZEi5GQ6P+cfzvHtqS2PDx7FI/Sb/D0Xc5Q8FnkvbHiaexudEV0ySLVIBIgS3UdCZunEWm7hoNESKTlFUqUQPdvOb+LkuLukyZ5crC1/qTrIe55F2o2aTQ9+gY1z2M7RG+Zf2hJ414uJgcHBt2eNYcQ2yWaWhAA0XgpCW5nP0zoxAOAYHyGLEvgw7eQvlVlhA7G9QJP3aVJCNwHpcgfu2v5vJTPvPe2GnzZKh+AOwNhYH5HkoFZIWFDNR+gRUj5zBZmBNTSog4f/u3kYStpTGzEbx7Ocjct0zer4l7vL88s63HoGFEuMsrglZRyd8OVUp/y77IR/aHdamYBJkXXbjSUNtY6+GpbhsiIPCjbUE2lZyK6Ks7xSazttOcqU3rl3/8XD36WSjNQulg5ucjRdE8wNbwRw9KrW8+QG8iR3maUbomz5zLm7AR2BUxn61js0r3RIn+gt+I7XHXv7YqAyhi/oGakFWfSoURxaCi7CekxLvZEH1W3s/D/zbPWMqyV4sQ2x5jxDiHEOrKwsjUO8WXJxI8wvnVWTEjGnNybLvpVcZeN0mWNOsTd2m8SaYFWnjVS1mR1m13VH81+xeIA/uN6VM7G5sO060EPHHLoqMhV9nqERJTB0WxKj6eHkwE2+MPReOCN7zPA2zU/fyexC7C+wVJyGxR0kk15ySc+0JecYyWA8g2/jHGhH6MHERZfvNvbB1sEp5gr37NPpgAiepSx8+OlCcoDECktyq4YOm
 QSrt3+3p
 8S30FK6KUjNj7sOEMLbIKNyAeJfi2l7jSV0cmZ2TTvbzK+Gj5AzQsHhUnM8AJfW9RFETZfPKK5+agPLme566xNlPlnXYI7CXfTAWwFBGZX0sMjgtWFj/r00ohSSq/vlKJZ3XP/OXI15xxc8p9L1AddX8Cm2D87xFk9vqUdm5Xpmq5p9Qn4Of158Aro0IqTkFnrj4tKcQXvv4Xl3Caxu95I7GTcJ9qAaS2OlvvRxem6BP61fYEaf31FVB7sEO4ISEE3DT+m3z53DvjLqG1Nc0xlXPSMMsMQOhFzv1F7Cv/+eb82q4VNxiFXJvBi2uTCoBFaWfp9LcUBFJjYfRQEQQkJ5zRyyA3+6lBu2S8Rfq9MS6nMF1NSmuC9e3YOY4fBVzgQ32eecFaXmWkxYqCZnFFW59avuX34iACh8Gj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Josh and Steven!

On 10/22/2025 4:43 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> In preparation for unwinding user space stacks with sframe, add basic
> sframe compile infrastructure and support for reading the .sframe
> section header.
> 
> sframe_add_section() reads the header and unconditionally returns an
> error, so it's not very useful yet.  A subsequent patch will improve
> that.
> 
> Link: https://lore.kernel.org/all/f27e8463783febfa0dabb0432a3dd6be8ad98412.1737511963.git.jpoimboe@kernel.org/
> 
> [ Jens Remus: Add support for PC-relative FDE function start address. ]

I took a closer look and wondered whether some parts should better be
moved to subsequent patches.

> diff --git a/include/linux/sframe.h b/include/linux/sframe.h

> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_SFRAME_H
> +#define _LINUX_SFRAME_H
> +
> +#include <linux/mm_types.h>

Move to "[PATCH v11 04/15] unwind_user/sframe: Store sframe section data
in per-mm maple tree".

> +#include <linux/unwind_user_types.h>

Move to "[PATCH v11 06/15] unwind_user/sframe: Add support for reading
.sframe contents".  find_sframe() needs the types.

> +
> +#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
> +
> +struct sframe_section {
> +	unsigned long	sframe_start;
> +	unsigned long	sframe_end;
> +	unsigned long	text_start;
> +	unsigned long	text_end;
> +
> +	unsigned long	fdes_start;
> +	unsigned long	fres_start;
> +	unsigned long	fres_end;
> +	unsigned int	num_fdes;
> +
> +	signed char	ra_off;
> +	signed char	fp_off;
> +};
> +
> +extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
> +			      unsigned long text_start, unsigned long text_end);
> +extern int sframe_remove_section(unsigned long sframe_addr);
> +
> +#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
> +
> +static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
> +				     unsigned long text_start, unsigned long text_end)
> +{
> +	return -ENOSYS;
> +}
> +static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
> +
> +#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
> +
> +#endif /* _LINUX_SFRAME_H */

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> @@ -0,0 +1,137 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Userspace sframe access functions
> + */
> +
> +#define pr_fmt(fmt)	"sframe: " fmt
> +
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/srcu.h>
> +#include <linux/uaccess.h>
> +#include <linux/mm.h>

Move to "[PATCH v11 04/15] unwind_user/sframe: Store sframe section data
in per-mm maple tree".

> +#include <linux/string_helpers.h>
> +#include <linux/sframe.h>
> +#include <linux/unwind_user_types.h>
> +
> +#include "sframe.h"
> +
> +#define dbg(fmt, ...)							\
> +	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
> +
> +static void free_section(struct sframe_section *sec)
> +{
> +	kfree(sec);
> +}
> +
> +static int sframe_read_header(struct sframe_section *sec)
> +{
> +	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
> +	struct sframe_header shdr;
> +	unsigned int num_fdes;
> +
> +	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
> +		dbg("header usercopy failed\n");
> +		return -EFAULT;
> +	}
> +
> +	if (shdr.preamble.magic != SFRAME_MAGIC ||
> +	    shdr.preamble.version != SFRAME_VERSION_2 ||
> +	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
> +	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
> +	    shdr.auxhdr_len) {
> +		dbg("bad/unsupported sframe header\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!shdr.num_fdes || !shdr.num_fres) {
> +		dbg("no fde/fre entries\n");
> +		return -EINVAL;
> +	}
> +
> +	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
> +	if (header_end >= sec->sframe_end) {
> +		dbg("header doesn't fit in section\n");
> +		return -EINVAL;
> +	}
> +
> +	num_fdes   = shdr.num_fdes;
> +	fdes_start = header_end + shdr.fdes_off;
> +	fdes_end   = fdes_start + (num_fdes * sizeof(struct sframe_fde));
> +
> +	fres_start = header_end + shdr.fres_off;
> +	fres_end   = fres_start + shdr.fre_len;
> +
> +	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
> +		dbg("inconsistent fde/fre offsets\n");
> +		return -EINVAL;
> +	}
> +
> +	sec->num_fdes		= num_fdes;
> +	sec->fdes_start		= fdes_start;
> +	sec->fres_start		= fres_start;
> +	sec->fres_end		= fres_end;
> +
> +	sec->ra_off		= shdr.cfa_fixed_ra_offset;
> +	sec->fp_off		= shdr.cfa_fixed_fp_offset;
> +
> +	return 0;
> +}
> +
> +int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
> +		       unsigned long text_start, unsigned long text_end)
> +{
> +	struct maple_tree *sframe_mt = &current->mm->sframe_mt;

Move to "[PATCH v11 04/15] unwind_user/sframe: Store sframe section data
in per-mm maple tree".

> +	struct vm_area_struct *sframe_vma, *text_vma;
> +	struct mm_struct *mm = current->mm;
> +	struct sframe_section *sec;
> +	int ret;
> +
> +	if (!sframe_start || !sframe_end || !text_start || !text_end) {
> +		dbg("zero-length sframe/text address\n");
> +		return -EINVAL;
> +	}
> +
> +	scoped_guard(mmap_read_lock, mm) {
> +		sframe_vma = vma_lookup(mm, sframe_start);
> +		if (!sframe_vma || sframe_end > sframe_vma->vm_end) {
> +			dbg("bad sframe address (0x%lx - 0x%lx)\n",
> +			    sframe_start, sframe_end);
> +			return -EINVAL;
> +		}
> +
> +		text_vma = vma_lookup(mm, text_start);
> +		if (!text_vma ||
> +		    !(text_vma->vm_flags & VM_EXEC) ||
> +		    text_end > text_vma->vm_end) {
> +			dbg("bad text address (0x%lx - 0x%lx)\n",
> +			    text_start, text_end);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	sec = kzalloc(sizeof(*sec), GFP_KERNEL);
> +	if (!sec)
> +		return -ENOMEM;
> +
> +	sec->sframe_start	= sframe_start;
> +	sec->sframe_end		= sframe_end;
> +	sec->text_start		= text_start;
> +	sec->text_end		= text_end;
> +
> +	ret = sframe_read_header(sec);
> +	if (ret)
> +		goto err_free;
> +
> +	/* TODO nowhere to store it yet - just free it and return an error */

An alternative would be to move sframe_add_section() to
"[PATCH v11 04/15] unwind_user/sframe: Store sframe section data in
per-mm maple tree" and reorder the patches as outlined below.

> +	ret = -ENOSYS;
> +
> +err_free:
> +	free_section(sec);
> +	return ret;
> +}
> +
> +int sframe_remove_section(unsigned long sframe_start)
> +{
> +	return -ENOSYS;
> +}

I wonder whether the series should be restructured as follows:

unwind_user/sframe: Store .sframe section data in per-mm maple tree
unwind_user/sframe: Detect .sframe sections in executables
unwind_user/sframe: Add support for reading .sframe headers
unwind_user/sframe: Add support for reading .sframe contents
unwind_user/sframe: Wire up unwind_user to sframe
x86/uaccess: Add unsafe_copy_from_user() implementation
unwind_user/sframe/x86: Enable sframe unwinding on x86
unwind_user: Stop when reaching an outermost frame
unwind_user/sframe: Add support for outermost frame indication
unwind_user/sframe: Remove .sframe section on detected corruption
unwind_user/sframe: Show file name in debug output
unwind_user/sframe: Add .sframe validation option
unwind_user/sframe: Add prctl() interface for registering .sframe sections

While moving sframe_add_section() and sframe_remove_section() from
"unwind_user/sframe: Add support for reading .sframe headers" to
"unwind_user/sframe: Store .sframe section data in per-mm maple tree" or
into a new second patch, as they depend on the first and are required
by the third.

What are your thoughts?  The reordering might be wasted effort.

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


