Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C19CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9F28E000A; Fri,  3 Oct 2025 06:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AD18E0009; Fri,  3 Oct 2025 06:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23178E000A; Fri,  3 Oct 2025 06:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C16C8E0009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:28:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FF885AF70
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:28:58 +0000 (UTC)
X-FDA: 83956429956.19.2FEFA0A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67E12A0008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:28:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759487336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qS2h4dNMRC4olTp0F2+ihnLBmEEJQ7AutH6JnjUHI/U=;
	b=pMeAK7bKnkBJrc3FuZcYVHpOp/41rERSR7mKkF3R87hbJhFe3HQG68QgSEYkFSxu84cDoD
	5aVftmOS37CAzaPjaF0tjBrowxtlnjudCHroftbxQOyt1tIFJObQMbyC598m3os/Gmd15H
	m2ovmaoiWkG4DGPTUBIScA373BmK784=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759487336; a=rsa-sha256;
	cv=none;
	b=ZEOR1q67KmSmH3DW+SqTLweN0vABZf2pTrOgz1ftt7MAGJzRUawLdeyiW7UktCxepOcoTJ
	Qyl+uvKrJuJL/76Op/E0M2fTfLXJtl5b+ivQzgi07C+3gynzvGj84PED3ufgeuSu7gLA9V
	uir9AoNV9qiNJe5V8+9k/nEp7+X/HYE=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdPwB1qVsz6L4w4;
	Fri,  3 Oct 2025 18:26:34 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id BD87514010C;
	Fri,  3 Oct 2025 18:28:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 11:28:50 +0100
Date: Fri, 3 Oct 2025 11:28:48 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <yuanchu@google.com>,
	<kinseyho@google.com>, <hdanton@sina.com>, <harry.yoo@oracle.com>
Subject: Re: [RFC PATCH V3 14/17] trace/kscand: Add tracing of scanning and
 migration
Message-ID: <20251003112848.00000cbb@huawei.com>
In-Reply-To: <20250814153307.1553061-15-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-15-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: s1em1yhb65j7ssm5nioxffpzgjng56xg
X-Rspam-User: 
X-Rspamd-Queue-Id: 67E12A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759487336-151259
X-HE-Meta: U2FsdGVkX18Py9Oyf1l1dwvDavt38dm8FOU6uesZo+say3YpCw/aaANyl4aizYNCKM9ohJsTFpt7aHAxkx+neJu7FhZvsdONv665XQlU/6TjVCq3LsIDY85HV52TyxIL3FApzIY2ExyCZqY5JX0nZEUr8QDLVt1BlxP+iiTbEHtvg/16lX1+dcW61P+OcRESvM50KPByhBkaCEuZXf6yklN4CHHB2RC/0TvSyluSGDn2Bqw3NE7wF9nmDYcJo14j1fufzwRVC1vIfly+7M+n7A2CJia+iUMTWWCJoFjSeuP/rUtorpc6A8T5LGk+ERUHB98ZsxchOPvaj46CPZds/MyFKlhp4HQWNF1ncehg936hG4AGX6sSYxHT69/f0cqDUMrAY8BndgE7iIHxzPL4bCHtbjWSZ7MmzdKWewke/WKHiXH+fLVlUoGDkveFQcpsdX/pFG2EhZUBEk7cHHPj0W68AjjnZ3ptQYDm2v5oVX1wi3ATsCQz2KzsLlYxaTcVW0AFQwHcKcpkdtd4fvUMZq5jn5w8AQbyAN3OD8NnbISnp4zkaNbnomntRWbUYgdWfVSI7AYHIHJ+y+OlcaiwCBTQ31vFOPdHICpouXEX3ite65usqkw3Bf3i8XWzMn+mnIj2OvhXD86q9K4FwiYLW1Bn60Q7U2wZXBr6Fa1eQT1ihXonffiF32RjzqIy5zGMKR/+Sccs5n52qqNvWNZIDTt/DrkSba2OywxvBP3HCAW+VD+rn3o0MdmgGFl+S4bULPKqc+TQFiS9rBOBQPi550sOkajmpOf+xmgu5erCbGCbR4f4+MQHWZfCaE+HeAL/NpzN/Zoz//z7eSXtppSciw8nkXJ21VaBEcu3RkJgzuZJSBd66ePrH+xh/47y7u1Wn8bLchjWEUx0DW/13Ui9aix4btHUKiDsVcW0PpgUzKCV/t1jJUiVUNfjMWwlIUkj0H5hDJlY6NZ2eYy6pWc
 oinrPKnd
 998GiouL8hsIeDK7Q9UDTArNLtV3hL0aBmwdB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:33:04 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Add tracing support to track
>  - start and end of scanning.
>  - migration.
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Masami Hiramatsu <mhiramat@kernel.org>
> CC: linux-trace-kernel@vger.kernel.org
> 
CC s are part of tags block so no blank line.

Probably move them under the --- as I doubt we need to keep these
in the git log long term.

> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>  include/trace/events/kmem.h | 99 +++++++++++++++++++++++++++++++++++++
>  mm/kscand.c                 |  9 ++++
>  2 files changed, 108 insertions(+)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index f74925a6cf69..d6e544b067b9 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -9,6 +9,105 @@
>  #include <linux/tracepoint.h>
>  #include <trace/events/mmflags.h>
>  
> +#ifdef CONFIG_KSCAND
> +DECLARE_EVENT_CLASS(kmem_mm_class,
> +
> +	TP_PROTO(struct mm_struct *mm),
> +
> +	TP_ARGS(mm),
> +
> +	TP_STRUCT__entry(
> +		__field(	struct mm_struct *, mm		)

Trace header formatting is sometimes interesting. But I have no
idea why you have this padded like that.

> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +	),
> +
> +	TP_printk("mm = %p", __entry->mm)
> +);
> +
> +DEFINE_EVENT(kmem_mm_class, kmem_mm_enter,
> +	TP_PROTO(struct mm_struct *mm),
> +	TP_ARGS(mm)
> +);
> +
> +DEFINE_EVENT(kmem_mm_class, kmem_mm_exit,
> +	TP_PROTO(struct mm_struct *mm),
> +	TP_ARGS(mm)
> +);
> +
> +DEFINE_EVENT(kmem_mm_class, kmem_scan_mm_start,
> +	TP_PROTO(struct mm_struct *mm),
> +	TP_ARGS(mm)
> +);
> +
> +TRACE_EVENT(kmem_scan_mm_end,
> +
> +	TP_PROTO( struct mm_struct *mm,
> +		 unsigned long start,
> +		 unsigned long total,
> +		 unsigned long scan_period,
> +		 unsigned long scan_size,
> +		 int target_node),
> +
> +	TP_ARGS(mm, start, total, scan_period, scan_size, target_node),
> +
> +	TP_STRUCT__entry(
> +		__field(	struct mm_struct *, mm		)
> +		__field(	unsigned long,   start		)
> +		__field(	unsigned long,   total		)
> +		__field(	unsigned long,   scan_period	)
> +		__field(	unsigned long,   scan_size	)
> +		__field(	int,		 target_node	)

Similar. Aligning stuff might make sense but why the spacing before the type?



