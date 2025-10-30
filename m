Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C839CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A278E01A6; Wed, 29 Oct 2025 20:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7629E8E0106; Wed, 29 Oct 2025 20:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EAB8E01A6; Wed, 29 Oct 2025 20:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59F898E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:43:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04BB91A09CC
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:43:16 +0000 (UTC)
X-FDA: 84052931634.27.2DE3AD6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3FFBCC0005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:43:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULiUj4m2;
	spf=pass (imf28.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761784995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prXThHTV0GDAwL3oDEaWG8s/Dj6lCyEPeFRl/UXwls4=;
	b=UzSlOfx5d1rWuJt67EJQMlHMfa9i9a+7JLc1OGKPcyN2iGPC0cwpLMcTPZQHcD8AXnA96p
	OpmJ30vnQKcD4WHFAH05AJBzY7bXho3y3djtDzAGazey74s5DU1KeSNjwDiAtvawRih0Sc
	nSKfMVjE4vSiqopenIQdKwYGeVOWx0w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULiUj4m2;
	spf=pass (imf28.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761784995; a=rsa-sha256;
	cv=none;
	b=UKmMUPUJg/HDR8EnBzx4y+eqw09cOWwHlLkQkKQ19XPNcbJnc2Dcbn6cPd5TloQIEOrP01
	3nCuDlGxI0qb8v1naz9lbCcB5XMIAZ3ldytcZ3JyZCOgr8ZBxrpyfmQz1PcqN6FwVy4M0E
	XlnwmFpbNglWmYBInwf6+75M7w00wwE=
Message-ID: <dc66b416-6d35-4e7f-af9c-6a0831dc1fb7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761784989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=prXThHTV0GDAwL3oDEaWG8s/Dj6lCyEPeFRl/UXwls4=;
	b=ULiUj4m2ZADrpZISUHsciB+yZ7PKa6iclQpmxGVtWMVHGj6KYXWwkoKCZXXY9Uits03dv4
	vupgCZLkEk8MYN4sAipt4OJzgrznJx+C4i2+XdgM1k/plomzacRE4NBqO+zq8iMFDoad9k
	yH8o9Eo8jbJOdnnYDOj5Jw2VA3b/1RY=
Date: Wed, 29 Oct 2025 17:43:02 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to
 cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
 Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20251027231727.472628-3-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FFBCC0005
X-Stat-Signature: uutrathi8f77sx83eojwiquq4du9a6nf
X-Rspam-User: 
X-HE-Tag: 1761784995-979478
X-HE-Meta: U2FsdGVkX19lfk1F7wIYcFJI0lj8mS5a9nzsSM40XvYRreEVdH8Q8ogM5atpQEDsBKL63sqNBCnKAjRV3mOde0r8C5HSessseFmET320rB9Bgo6PFZ6UtAXLXEXhpLP4BzYTpHbIPK53MeJx1b2TsHBjcGuXdYiBQGOym4iJN8bPKpCA3d4eh5Y+98wJwqhmA2OdA/v1Tn+qllhY26ga5jAqj8HbTvsnctoHtXti62SXHEvkXaNydZ1tLDcSSXXGt2sRMnlYqHFCSaRUA4IrwQ4Ou+PA7v/tCZa8rKIayNCepHeLdTHxyPZBs07vJ5hmVAh7kTvYkxjqbpwmCbabFpSDAQj9zvaO5V1NdHk+wEZ+qwGq+5YQLNUHZbUwV3qwQc72NBAj3Fqc/tQjHfxE30K2SlASDsUj4Ddpc7zLNZuEC5lT7tbnuXyER3wxiDropr4Oqo03T48po3xuVbrtnWF+wVqrEbxgbfO/tBzZ6eYs3kMGxtmp787Bg5712J8cZFHXmsg1uS27sltOnMEFPvff8NH0gDYaX8V4/AF0FQyw+QtelV0Y9Xv7RuVW/lF854mHepq33XZjZ1O0RvVMSN9n7/iaPq9DP5esYRXv9v+8qtiz302erUOFCel6Me+zW0jCkwpQ199zbjMThV2M1XJNi9YFFY9r2hTxAZJsQIODLRn97l3FLGEzqjbfXBQFl2TB/THWt7I70wVvIekPqnzjKT89pL6L/SUs3cUxziSFhRQePMDHxfdHG+Hd1kd23nMVH8Ze/MFhTJU2C/+fQsDRTS737Dw9qvFccJ3J8PqM8UFyMR2REk9t6fHmQ5vtCHi1DN/krj5uiizNx8ROcT2uQUBs+Kc5/W6UA4s0EJxtgkofR2lCsgNxlT+nSp5OEIcVa3fN3YoZffIu/+k7mBwxnldBn7Ygw7Af/lf3NnpX74LQxAv/0lct1hfL/pGNcG0k89Pxe6CkWmI3BjS
 RiKvrMXj
 2rDvnx5Hq+A2XdXylQpqdrV7iQ6VZoEs+PtvqS9/Ukd0tUIIX7z3ZO/2VgltN603ewF3IYitJWckK/FgX78bsLfZKz2lcC1nnOxflaeCYNj3DsBnB+XuqPhlAA6FkVJ6nzPV1hZ5TZclPPCZfdulnsdt8bDfLJ82w6Y9CLdAx8VNU/CduamLiJuo58Sh3EiQ/uthqlcInbL7H+lbpLk5RZ91MOui6XhqDx0IyS3RvLwKMjEmKfF4xcx9PLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 4:17 PM, Roman Gushchin wrote:
> When a struct ops is being attached and a bpf link is created,
> allow to pass a cgroup fd using bpf attr, so that struct ops
> can be attached to a cgroup instead of globally.
> 
> Attached struct ops doesn't hold a reference to the cgroup,
> only preserves cgroup id.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>   include/linux/bpf.h         |  1 +
>   kernel/bpf/bpf_struct_ops.c | 13 +++++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index eae907218188..7205b813e25f 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
>   	struct bpf_link link;
>   	struct bpf_map __rcu *map;
>   	wait_queue_head_t wait_hup;
> +	u64 cgroup_id;
>   };
>   
>   struct bpf_link_primer {
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 45cc5ee19dc2..58664779a2b6 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -13,6 +13,7 @@
>   #include <linux/btf_ids.h>
>   #include <linux/rcupdate_wait.h>
>   #include <linux/poll.h>
> +#include <linux/cgroup.h>
>   
>   struct bpf_struct_ops_value {
>   	struct bpf_struct_ops_common_value common;
> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>   	}
>   	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>   		      attr->link_create.attach_type);
> +#ifdef CONFIG_CGROUPS
> +	if (attr->link_create.cgroup.relative_fd) {
> +		struct cgroup *cgrp;
> +
> +		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
> +		if (IS_ERR(cgrp))
> +			return PTR_ERR(cgrp);
> +
> +		link->cgroup_id = cgroup_id(cgrp);

Not sure storing the cgroup_id or storing the memcg/cgroup pointer is 
better here. Regardless, link->cgroup_id should be cleared in 
bpf_struct_ops_map_link_detach(). The cgroup_id probably is useful to 
bpf_struct_ops_map_link_show_fdinfo().

> +		cgroup_put(cgrp);
> +	}
> +#endif /* CONFIG_CGROUPS */
>   
>   	err = bpf_link_prime(&link->link, &link_primer);
>   	if (err)


