Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23568CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670E08E0006; Fri,  7 Nov 2025 12:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621CA8E0002; Fri,  7 Nov 2025 12:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EF08E0006; Fri,  7 Nov 2025 12:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4510D8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:48:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3D43C058B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:48:13 +0000 (UTC)
X-FDA: 84084544866.04.1AB3714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 12BDC4000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:48:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p3CJ35JE;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762537692; a=rsa-sha256;
	cv=none;
	b=OatyUu1F31hqbIaWVlBfDr7PWg2O++YTGqTqp8+dsSWFrNxludOEyAjBAVz+rNnzcBcgTJ
	qOCAVdZuCV/Z4liCeaTZcBQAeEspFq8zF2JOmlugByko7vh0pvP80FutfPRlqPKrtWoJQy
	P6bUtHPz826d291IHeBc+X4yx923LoQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p3CJ35JE;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762537692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjz/Q1cZYNmD6e2RyRuEqDtDrAKvbXkLN31BRy1SyhY=;
	b=JSE/tWkoRNFAQ68t96CUcP+n+c6yzeLDj6M+RvkiOYUw1nwuueqmOrLoBp/miV6ytjoxL0
	NDsIZ8qCP4T5k1Q5bKa9sqafnLVA1CSsJINRdhFPQeE0vne0l3Gpx/s3MG3gyzY+bjICRS
	GGbAvanjtAqlIBCzU4lOq0dSvDvkiOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B806C40AF3;
	Fri,  7 Nov 2025 17:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC6DC4CEF8;
	Fri,  7 Nov 2025 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762537690;
	bh=dYP9bc3sKgdv9puyG2o7f5re4b2/aaF1Sb6wYlRgjOs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p3CJ35JEAkXsBD3qBOe826Lnn/azzuCotlVC5xmJO5N9yE2B5tI5psuND06evDlSe
	 wC4IXHDDCFMxiRMqtkJ5/szTGGYVmYUenCR/kDRwakzr17s1gjYT9srgSLnpi4yaaY
	 7pg+f9sBEFRBWOeMf9ANsjH+IdcZqm+J4FYx1vBU=
Date: Fri, 7 Nov 2025 09:48:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tytanick@gmail.com
Cc: bugzilla-daemon@kernel.org, Liam Howlett <liam.howlett@oracle.com>,
 maple-tree@lists.infradead.org, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org
Subject: Re: [Bug 220765] New: Memory leak in maple_node (Maple Tree) on
 Linux 6.18-rc4
Message-Id: <20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org>
In-Reply-To: <bug-220765-27@https.bugzilla.kernel.org/>
References: <bug-220765-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 12BDC4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: tue5tqdgd6ykqfcz6dfixiw4djz8dnt1
X-Rspam-User: 
X-HE-Tag: 1762537691-876771
X-HE-Meta: U2FsdGVkX1+uYbPAXfHEMdeQs+VThp6u7/C5k6QMYh6KSeJ6ksP6A/8lzw6InGzEh9BEp8Zdi7z+gTUzCXmr7Q8sBdDowEpFEUfouzMAjsJf1dauX9EK6YtSF1UrlqK+LuYMRQna6K6ytBrj7uTk8zmDbKC+KcAggSJdUhmSUP8vCtl1+vvCDfEQjbKI9z4dPWQtkRxVsIudnf8l+HK12wh+407eqPYcJjoEF1zyPVJlHVdYwhBScuRckTdJjiIp9ZK3WbueZvKSYrEKrBVid8/RsFAMp9I5AfqpGrIg4tXZvGleQ/daX+gGXv1kilUvn6yO2AocDpFANvJsDnAL2vbtad6AvTKXkGBUjN0RWk9SpgQ/RL+MnuVi1aHfKt0dz20V2tVxSs6tNZGkXvwIspDJVfucwWj7CxNL1GymrynUseeF3Rh4xrdjKgAOOi/oa9PmNhm/zCk0JduXp0wMy8H+KTGNTEy0u3kfH0nNyxx17/yNzzGOZ8CrSS2Vo3xQIccSANpPrcFp8HXmPVSyXql6i0kt3W+dXT3hcysU3iw0SvIeVF/B5xjSIULnakzwaAZk+v7t9CjtfaTIFNcGfcRTtMi3rDIeoras6a5Fs0fMqiPS0MC9XYDdrRWDhE8qH9TsvvhUJDKnmSLu7mEzcFjQ0T9eQBg+PRZ/eHls61qtQ8MujtnodoSsEvKz5ubo2hqO1QT8f8BOBrUSTK7WufzCfj9Tzi0mvra8FWhHg2ZV8CRRDaZ1k4tdsGm/JHCuzNuzZAKSuKPnnK3zh2Femgc0yK0lFkSh4us/t1FcFr9EKpCAen8apQY1Sq6ZfmXr2jVSbRLCaaiKl6ZWgLtl/LkIbRk16xJEZY++z1P21YWBzpROXjl+21uoalnFxk0ktR17SG+iwbRvE4YPtrZm0E8QTn1SHXv0Z+i2g5liCiPOzy43wObbubz1g/XvkLJOmPgLnpwtcJ8cVshNX6q
 ALctRrbf
 oqjF1LRXcJpeNr4HJLaXEd3+vz7y7EYHgrQS2dMHNe+eUVUHHuvwhKJAnMvr/XgNvUo1RxeVN79zRMj4i/Bip9IPIU+MhFxpaYIWqh1+z8yyVvL3PFUzUYQRoXPtNM5kZcpuZoYMIPPS8oMrllOfgP3HUthCmOm5sT8H56z/kUvvi85gvX6UIdELGZe4rluPDPubEwViwbdvEVCztatmguqsRt1dsH5uSomldTQFEjp+yQMo1wojRM8yiGYUHxXy64WgdmlJJAlTW8giRGexvLfMfKIOa7VyAoIdhZexeki2D8HNZMat2Ebw+M+kKuP/1ZwN+zz8cq9nv9E65s8Of7jCDN9MyhAsnarZnTkScvsAoaH3nTKV7LW4gyXyb0oDa1/jLpiUvTsfR0Iric61IRqn4NNG3AGv174Lxz3u3eMEouSsmSK3Sf8ELCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Fri, 07 Nov 2025 15:41:52 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=220765
> 
>             Bug ID: 220765
>            Summary: Memory leak in maple_node (Maple Tree) on Linux
>                     6.18-rc4
>            Product: Memory Management
>            Version: 2.5
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: Slab Allocator
>           Assignee: akpm@linux-foundation.org
>           Reporter: tytanick@gmail.com
>         Regression: No
> 
> Created attachment 308920
>   --> https://bugzilla.kernel.org/attachment.cgi?id=308920&action=edit
> htop
> 
> Been using 6.18 kernel and i have noticed that there is some memory leak.
> Currently mapple_node takes 86GB when server does not do much.
> I do not see that issue on 6.17 kernel

Thanks.   Cc's added.

In the future, please report kernel issues via email - we don't use
bugzilla.

Running

	scripts/get_maintainer.pl lib/maple_tree.c

is the way to find out who to email.

> Total 1000 GB memory
> ASRockRack GENOA2D24G-2L
> 2x AMD EPYC 9654 96-Core Processor
> Running Proxmox 9
> 
> 
>  Active / Total Objects (% used)    : 472110239 / 472257124 (100.0%)
>  Active / Total Slabs (% used)      : 7385489 / 7385489 (100.0%)
>  Active / Total Caches (% used)     : 164 / 231 (71.0%)
>  Active / Total Size (% used)       : 95486861.00K / 95528053.72K (100.0%)
>  Minimum / Average / Maximum Object : 0.01K / 0.20K / 8.06K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 345907216 345897683  99%    0.25K 5404801       64  86476816K maple_node
> 120873408 120841337  99%    0.06K 1888647       64   7554588K dmaengine-unmap-2
> 224256 223324  99%    0.01K    438      512      1752K kmalloc-8
> 224040 224040 100%    0.13K   3734       60     29872K kernfs_node_cache
> 196608 196608 100%    0.01K    384      512      1536K kmalloc-cg-8
> 196160 166455  84%    0.50K   3065       64     98080K kmalloc-512
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are the assignee for the bug.

