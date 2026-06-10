Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DBFCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 11:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092E76B0088; Wed, 10 Jun 2026 07:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043056B008A; Wed, 10 Jun 2026 07:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9ACA6B008C; Wed, 10 Jun 2026 07:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA2846B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:34:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A49D1A0963
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:16 +0000 (UTC)
X-FDA: 84863794512.17.8314B64
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3F1A1C000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JYHXWuFd;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781091254;
	b=2jc+24Rni1l4AaWUxcj+WfvHK+EU/NfL6bUCLk8/Kj0iDMkDRFZCHUVmo1BD1kEcH2P52w
	2KE7bfxaa7MdvZVQnrrNRZSX1A40gBTJp/dFDm0S0celLpwOu+L89oahad6JN0RlioI3oO
	GL1qNpnR+rM/vxgiCuokSbx8hHknxgc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JYHXWuFd;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781091254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojEE6G7x5Hyz18bffBqmv/qKtAjxoG29cTYIDqTjZjM=;
	b=rdgEdzVrKCuOPCiQYZs/rkkKzMcwyR6tmWClDATqC9QRqE/XCmRahLHLqvYp0oF0fBXVkH
	AZR3TjjhSsGGEdyHEshGv53CRNRTdDVqoORlnPHh2xSGo/C8Bc116kl6LgtfuNGd7EcGe+
	MmfCQxWQP1C/svEwpo4K29xv6fm9PHM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ce9ddeddefso71642266d6.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781091254; x=1781696054; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojEE6G7x5Hyz18bffBqmv/qKtAjxoG29cTYIDqTjZjM=;
        b=JYHXWuFdZKhPCnxI7ggiRGgMBuJkM5Dj7ry0fUWiMjT12qW1mfyUN6hIupzgS4F5cY
         TS4BAUtj+ZS+h7+8Y0WoevxcK/Z+pBXUQr91eTVd8adZGCgT1CJaJnKpuhw/Ixbkt8pS
         EOvGPLS3GeThcRQ1lEmhT4z5ENM86rTaPZoo6ETadR+b056oQGNGOcqfYl8tXGie3gWx
         PiOennyTQoDiwOay/69s95aoyvJr7eghUEtB8pmdOq3mUGxRu2Wj/GwK9RNJyo1McW2T
         3gkR+V0bYaWsKVTvlTfNknZ2B71g9DgjP98jXJKapmr4Q/radJ9wExq8xqeA7NB5A0ko
         LURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781091254; x=1781696054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojEE6G7x5Hyz18bffBqmv/qKtAjxoG29cTYIDqTjZjM=;
        b=INUPx6Wxh8GovaKU0vdhUR3SbMcYjWsUPbQ0NHZDlfrAPGwbKmEwsz4Iv3o32vvI4w
         fEzjkXSJRorlkK9A2urv5f8BeKRt3YV14As61NqKBl4NLjj7LjS5KskqzTjen5RL5/Q4
         sGefhEh1QpSAQVZoXYlysn9e+4RAph0SU+RYH7ex6yGJTGJMadP+gyihH+4/sH+Yor/d
         EIl066eqndIkl4jWlE5PIZ4TaIr7zmPutD+vHY3Xm8DhgCUw8nrnQBKWltNTc3BKHeDs
         IvLmrTJoib+soxXos6qOYlBwrk7SvMlyFzHXwfyI1KtI/qOh5jkfZjVyMQbPQnsGi4iY
         oP+g==
X-Forwarded-Encrypted: i=1; AFNElJ+rBVi9xpOAsIzSE7k7lLJsVIChXL69SMbj90y1ViZrh2ZNDc9/eOeyWTX8K9mLyhUlp5glVH9kAA==@kvack.org
X-Gm-Message-State: AOJu0Yws57RFRxAR6bQ+tHf2TxLoYS1nHcRZaysxdt980fNBANVluZga
	PUnUr0l9VxkaqpgbW0A56N8w5Nukqvmsx609cyqvegSLudDIoYC3ZchaTkkq1NIvS9g=
X-Gm-Gg: Acq92OEcS0957sebei7JNTl5kMgJk/Zh4+Awix6nHjfFHhja+x5OqqaDe/YATCA0bzl
	R4scJfcBgyRAXBAnnD3UUBaoOGD4G9VURJyBPS1cZOvjD/VLQ/5jJjwczZ+wp6aaOoUbFfc38Ib
	cXGImmr1MKeQCt0YmYN7zsPDywypNF358G1S8N7ga03vkIPROu/YeLZaqiBjUnCKDk0MoN8d0yU
	+qQZqC++iaIbmMywEbcAYJTA4AJjcKZ5sGjZ1Rwi06ehn2LFX4/weoHP2sXJMPgrFCM3V+W/fow
	uaImtxVjZEXHYEXkQHir7Wq2erRYftY19DlgpcFW4oVoKOsTgSVlYygIrLjYFf2C6OpxFAXI36Q
	buIkABb4XW6Ug44WKAJ5HLXQr/DmwdiIOeOVvJEKqt2whIdGfoIHzA+SAf1ACm0eeF4J837VPHF
	HJuHHWHB76giItGYm0gAdKP8jjEzvqXilbKm5xsIGgLF5kayeUpdqSqsUc+bUQ9hFAfGOrVO98b
	7vSlvwxcsH+Uwga/UukS/GnEkoT
X-Received: by 2002:a0c:fde3:0:b0:8ce:ca78:409c with SMTP id 6a1803df08f44-8cee5fe4e78mr277619976d6.10.1781091253735;
        Wed, 10 Jun 2026 04:34:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26e9e3sm225660056d6.46.2026.06.10.04.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 04:34:13 -0700 (PDT)
Date: Wed, 10 Jun 2026 07:34:11 -0400
From: Gregory Price <gourry@gourry.net>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Farhad Alemi <falemi@asu.edu>,
	Yury Norov <ynorov@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-ID: <ailLs4akasGP1KLZ@gourry-fedora-PF4VCD3F>
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
 <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
X-Rspamd-Queue-Id: B3F1A1C000B
X-Stat-Signature: i5s8gjb5h6w638eguh11x8bmy3b8akee
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781091254-688744
X-HE-Meta: U2FsdGVkX191luJe/WxyJyQvapIFghjcZOkd6nDtDS9bFEztldFGCU9osuWTjoPAamjUWBpQjodg6UJoG0GAo9mFHGqzW2ojIG7pyGKcLAaqPH+rrAi2rzar6m3o/bxYOl0nYZRkKe0SMKKz5SYbrDm4GNCn8usmsYvBmsDJ747lfM4eXxkfJZN9fCkonh/lyk6Tqww+jSLdIiGswojjlwZLri5Q5DidL7T93rEGkYg2eYc/l6VukwulNToRk4UO41//yPLgPHgq07nZfmV0rkmRRGMBap4PVPOCpQqXtfClmtCHr2oYqDUoL73y5O2uwLd8ZJpWbjNlTY1PLnrHBCKo1S2hOaQpJVOwrcK4V9wq137xF5yg14K/jlbeHPVjgHGshPEd9YezeVIHNyjUOzkDgQgNqKXZtwW0lW+i/AC/9w6PJfCWa4wq4SW4JHQt5pjEh07+dmtuEM1pROwvvYyw2JO4fiKGqT6Dp5omS1APJGS4EYmut4H811JKcA4vSbye5Umr2fHdNda84eKfuhK1Gul3rCqtyxQ83lQwrouNU0Hi1vRrTWNAJ1sccUXtpyzapfQ3MoHzHkPpbwb4d+T+MDXMfGmgjAxHwaSI7GsBcxfZO0eFJWH/+jT7x2nYR34WTdaJwfioTBi2fQANGvspX05ECNe/4sNWMjEFQ3IzPLhfffsDxg+KcJ4nEg0plzVIxXfKsBhqeofFbKxp7MXgSBsoFxfRKReMA1wDTnyzz8Vn6MwzJJbOwiuORjBPGAQKdgZeu8jSmzv2oNIy0Jc4dRu8XdqO+P1yzVvPZ0e0ThiRrZgiiesvQ72rpgyd7wzF8cr3w6OhC4yhnvr9r8Ip/1QBx0PZexYW6BhfIU8W9WZuuKHyiXVTXv3n0GkAr90Pl5iukO5BGpr9xrpWJFfz7yql1TPu/BvIsarDzzGW8FYQmkwE9eKJTA2BjUcXp2ZJgmVXnEiVArpErsC
 H3ofaZPV
 ZBmQwr4iUBZKMqUoIFq1uC+viANlctg2Wls06Tdbjgr8hciPkWRdL002di6MoJtNccz8DcNVIyw3hOM8cLOHiHNeEd/dbiLX8o/o3eShtXp4Hh7bsMeAY1jQeCIGtIAX9kXFayu0JLks8RN4xnCmcP+498S60EHplfi7jRI8jWJUJIwver0Z6oaVfqQWY+kyUk84oKN5XZgFUaeOaw81fHQRMG/1SsWMNHnjcHYf0H+60FpJ9W0s+/pbofL8NBLF58JKuLbw2ihxdSDXO6r8pO9exa4wQdjbc2zZk/gZQhV7jWS7yX1pZVOTcs6CoC52C13jpPIK/IB3/QbPQm6+P81JTYPZth4leIefVkLJ4XNnVrm8h7FBxlkq+Ryn+MSqZYjVxT0jfFr/2dGz38B2PK4kTzjTlqyX+EhhF7erBzwAiqsKQ4MYpMM+NyeHOeD3eaTz2Fx6VCtvtUYNHi+icnWeEvJRv/YX2KeU29rlC4EO1FAAjkBKwpNPZyAiSi5V00akTV8qJKMS50Srsh76bW970rM4u0TUeC+SFviBojAGdrpYjS+Jg59E7lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 07:57:41PM -0400, Farhad Alemi wrote:
> cpuset_update_tasks_nodemask() rebinds a task's own mempolicy to the
> cpuset's effective, online mems (newmems, from guarantee_online_mems()),
> but rebinds that task's VMA mempolicies to the *configured* mask instead:
> 
> 	cpuset_change_task_nodemask(task, &newmems);
> 	...
> 	mpol_rebind_mm(mm, &cs->mems_allowed);
> 
> On the default (v2) hierarchy a cpuset that has never had cpuset.mems
> written keeps mems_allowed empty while effective_mems is inherited
> non-empty from the parent, and tasks may be attached to it (the
> empty-mems attach check is v1-only).  A subsequent rebind -- e.g. from a
> CPU hotplug event walking the cpuset -- then calls mpol_rebind_mm() with
> an empty mask.  For a VMA policy created with MPOL_F_RELATIVE_NODES this
> reaches mpol_relative_nodemask() ->
> nodes_fold(..., nodes_weight(cs->mems_allowed) == 0) -> bitmap_fold(),
> whose set_bit(oldbit % sz, dst) divides by zero:
> 
>   Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:bitmap_fold+0x5e/0xb0
>    mpol_rebind_nodemask
>    mpol_rebind_mm
>    cpuset_update_tasks_nodemask
>    cpuset_handle_hotplug
>    sched_cpu_deactivate
>    cpuhp_thread_fun
> 
> cs->mems_allowed is the only nodemask in this function that is not the
> effective set: the task-policy rebind, the page-migration target and
> cs->old_mems_allowed all use newmems.  The sibling cpuset_attach() path
> already rebinds VMA policies against the effective mems
> (cpuset_attach_nodemask_to = cs->effective_mems) and explicitly notes
> that mems_allowed can be empty under hotplug.  Rebind the VMA policies to
> newmems too: it is guaranteed non-empty by guarantee_online_mems(), which
> fixes the divide-by-zero, and it makes the VMA policies consistent with
> the task policy and with the nodes the task is actually allowed to use.
>

I think you can make this a bit more concise:

  Creating a child cpuset where cpuset.mems is never set leads to
  a div/0 when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds
  in response to a CPU hotplug event.

  Reproduction steps:
     1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
     2) Move the task into the child cpuset
     3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
     4) unplug and hotplug a cpu
          echo 0 > /sys/devices/system/cpu/cpu1/oneline
          echo 1 > /sys/devices/system/cpu/cpu1/oneline
     5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
        call to __nodes_fold()

  The cpuset code passes (cs->mems_allowed) which is not guaranteed to
  have nodes to the rebind routine.  Use mems_effective - the value
  returned by guarantee_online_mems() - instead, which is guaranteed to
  have a non-empty nodemask..

Maybe add a link to your reproducer and the original [BUG]

Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/

Does this need a Closes tag?

> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Cc: stable@vger.kernel.org
> ---
>  kernel/cgroup/cpuset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
> 
>  		migrate = is_memory_migrate(cs);
> 
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &newmems);
>  		if (migrate)
>  			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>  		else
> -- 
> 2.43.0

