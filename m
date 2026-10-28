Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93129606A339
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gU0j6S5l
Received: by kanga.kvack.org (Postfix)
	id 8E8816B05B0; Wed, 28 Oct 2026 14:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899A06B05B4; Wed, 28 Oct 2026 14:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788556B05B5; Wed, 28 Oct 2026 14:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 549E16B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:18:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC4CBA01D2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:18:17 +0000 (UTC)
X-FDA: 85372844634.06.719BBBA
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB180120004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:18:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gU0j6S5l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793211496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oiry0ZaDpBozgKs3Yn0AN+r5C81GF5EHZ1wjFVYL/k=;
	b=iTrP0cJUyV7negQvW6ujEMyHMXaz+AhptPuQVxX+4de6by4AaqeRiyuXOKTh4dAVyLTRgm
	qsAHAWNibl74JqTODDvZYGdSgmPDwQIxvb2ICx/zRjgw+81ultmpM6jm8Sh9xRqJ2W5Opg
	rW8b1OHivVZ/o7WjuHhQhOxCM/uoRuY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gU0j6S5l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793211496;
	b=ClTy6n7oHrpi3SHK1lT5nYe/Z2RrGs6z8s/NodUHH70d5Njdu05vwV2LIyUojWLUIjHY7A
	8xcLoD6HWc7xkZqAFmm3V0/73ZguvnfAhFMpsEJFWxXrGq1Ed4krB1nXVGyeqDN1M2Hi5o
	qYIH9OlX67VIDQOgIOByYTA/52TImKY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FzSLDoLL3l9c7gMzSXMHTUPkCis4CHxPNrJyJmMFlpk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793211490; v=1; x=1793816290;
 b=gU0j6S5lCSGrqFK3BVUBPVUpoJjMru/bTOQUq6k4s8hYE7pyHyjgIVQVNpixe8IGEYsHiSTo
 Sa9tQgmS5tlXViRJaa2x65+OMlfI5V623xi1qnOcoJVUKz1oQgC6LPcveWygQ0GXNgY6TXjxYXu
 B7nX71X6/VXlzdJeHTaUT5fQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ad5a2eaaa496885;
	Wed, 28 Oct 2026 18:18:10 +0000
X-Mizu-Trace-ID: 5ad5a2eaaa496885
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 11:18:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] ipc/sem: account enlarged sops arrays to memcg
Message-ID: <auI8CyIxjbLEMeEZ@linux.dev>
References: <cover.1793207025.git.x-professor@outlook.com>
 <565d855cbd81e0f49018da21df00ff0308f646b1.1793207025.git.x-professor@outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565d855cbd81e0f49018da21df00ff0308f646b1.1793207025.git.x-professor@outlook.com>
X-Rspamd-Queue-Id: EB180120004
X-Stat-Signature: s3g5rdc1roq65tmx6ed6dba3ytzjh5ej
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793211493-940142
X-HE-Meta: U2FsdGVkX19r2dtiagukcuJG2rW+kdVDCX4Ysm90H01/u33HAH+t29CWSpHyXZM+RoNoqEzg1seJiI4M7fUJIT6HLOs081OtpiY7C0+mP63Hx9YBnXu14xU/BGUeObHuMDLe/gxaO7dXJnsGrpzWJh9xkqD/L173D6MM5/VbCQQd5I48/Vn9+jw4+jLiQ8Lf7QOs8zvIW+qXFIcXTufps23jxtAiVcjIdoc1rElDM4JtnI1lvvLgCiBiojFwY3uwwyxyXoxsjlJyF1Dwbkn2aGvv1wGjEsySpMo/QnxoepnlJS+g/dK+P/6wCri1HOYs77rSHXbrnzbS8X8N3duhHs/3yJHtH8QDlX3jT4rJ5qfEUCStSUOn2kJZ+TJyUqhUMHLOv63koImVgA5uIkNSEsdFRCJjigB4tjd1XPCuIO4yhXUvRZY+W6nxUNcA5audooEwcxFFDk3Yyd3R9lEA5YhweqCTS6wL2aH6oETf3EZuhRk+D2jqwr1oYuGituKEWgb5QFtJ5K9s57904V7ahkNE7s+rEdnBGEbbZwqQ+m2yFmLX034IFk/IUcJhWbEZ5vPqOLStx80GngJQ4ZY1Puqg22ZdgOCpZvLLCbKIj1MmXoDNoLGZHu6BSH8AhTiK91x5vkENYZpmrdwhVhknWnHtPd6cdqWaItHKPuATfGqk4HjFTqDDc4/tglBO72IqcPSPcx/qxkkjfL9vW14/02Jx6AantrEVmXuNuiyc2BUqk0SuoBZ5KXrIIaOR9ePbiiYzrN/eRmDQqDuNgEJMCYjj7J5dOSPFlCerD5lIznsMYg2yhG7P34dXAeY/oUUGezD3dZJ98WRXyJD/3XKIUBV2ySVxKPPQYRkyeJF8vreuU0E5xjQbHysilCwLZbojqH5Uj/2ZfcJB6BvH5otzqaB1q+wXjoezjY6+Ej2s65sisSNrV4uCt/vQXQZYTtmyufeW5jV+mFW7XZR0hi9
 /0b48A2z
 QDbdPALt61Gs4X53X6CyJ8AxTZAG0bobarzwmXHJQ17su8E0c0HUFeRFUFs4EPqQJrlQUk23sRn9oQLGtCmjKdDtRMkart1uta11hObEYqvVd2p5DobzHmPIhyEF7X+/+8Wy4EsLWQI7O/B2gduILJ5xORwMfZic59kZWNKlLJTklMVrMA4R6PPxE4fFKuWULeJthWysqz2Q5tEs7Qm8WIeOqBGeSwzzLxSqlA+Xg9LZ6PAsSi57EZUzAkJxeD+kJbVrmmJ2m/ReG9YuCMCj2+ZhOdnLdZJSNxJnHbnvik+u1fBZ65y4gMoyIU31VuiDRau1jyC4A8C/u0Nbwvae6mtxp1e+uCKkPTup8xfHkvXW0Aro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 05:03:57PM +0000, Yingjie Wang wrote:
> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
> do_semtimedop()") removed accounting based on the assumption that sops
> arrays would remain small, describing a maximum cost of two pages.
> 
> SEMOPM is a UAPI default that can be changed when rebuilding the kernel.
> It must not also define the accounting policy, since changing that default
> would enlarge the unaccounted range.
> 
> Keep the historical small-array range unaccounted with a fixed internal
> threshold of 1000 operations, and use GFP_KERNEL_ACCOUNT when the actual
> nsops exceeds it. Requests within that range retain the existing allocation
> behavior, while larger user-controlled arrays are charged to the caller's
> memory cgroup.
> 
> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc
> namespace") later made the per-namespace limit tunable by IPC namespace
> owners without capabilities in the initial user namespace.
> 
> Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outlook.com
> Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_semtimedop()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> ---
>  ipc/sem.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 5ec41de7e85b2..a8c9807175520 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -176,6 +176,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
>  
>  #define SEMMSL_FAST	256 /* 512 bytes on stack */
>  #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
> +#define SEMOPM_NOACCOUNT	1000 /* ~ 2 pages for struct sembuf */
>  
>  /*
>   * Switching from the mode suitable for simple ops
> @@ -2234,7 +2235,10 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
>  		return -EINVAL;
>  
>  	if (nsops > SEMOPM_FAST) {
> -		sops = kvmalloc_objs(*sops, nsops);
> +		gfp_t gfp = nsops > SEMOPM_NOACCOUNT ?

Instead of making this conditional, can you just GFP_KERNEL_ACCOUNT
unconditionally and benchmark it. The kmem accounting has changed a lot since
that patch. If the performance impact is fine then we should just use
GFP_KERNEL_ACCOUNT.


