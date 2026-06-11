Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94094CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 02:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE44C6B0005; Wed, 10 Jun 2026 22:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB596B0088; Wed, 10 Jun 2026 22:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7B16B008C; Wed, 10 Jun 2026 22:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB5B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:50:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B14040305
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:50:51 +0000 (UTC)
X-FDA: 84866104302.07.22C70A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F1AB380010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:50:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jm4teCxk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781146249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeTt+ma90++oB/pmg/novekOFyYf+u+Cy444ynH4ojc=;
	b=Zyry1ZwT/+OAoUi8ecpbnRHS5MsZe6BoXrjP7zydPbJtPbx1yfjAIcVqEOz0CvctiNiLqR
	uz6fMVBEr42YvAidVjEn6AiaueloZfMaKwb6Zogpj3K4MgxqiujbXA2ve7NzT+PHoPQ/JD
	LMODnAxHTsaim+O2bXE+3QV5TDpIEJU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jm4teCxk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781146249;
	b=gQ9pQ/QCChk4DUX2n98WrAfceqHz9/PYvo3h0Be904c+zWKc8erO63B85ho4NQxNc7dHPs
	JnvkvMN/Ccue4Puo/exWLxtngO6Uof0kIhX5OQqPNZJrHJKx9Kz6UCZHtM2JvvIWvKPV/t
	YIwp2WzvId/6kra5um9HsN3emlFHHd0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781146248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeTt+ma90++oB/pmg/novekOFyYf+u+Cy444ynH4ojc=;
	b=Jm4teCxklEo4pGP8HAZa6r5sGRQUL/Sf17bTatDAesMc4horHhdvOwuhtix+qVv7Ns3LH+
	bIejKktRKi1NxLRia1fo/9lI8jK7tlGwJZqhaIA4ls9gVCmOB8/4INckZRkD3lYa5y/LDx
	YLKz6eqFxu7ROCLP0Ebs7/X4GEBJjMk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-4GuzfYPJNDWLqOuDDRCa9Q-1; Wed,
 10 Jun 2026 22:50:45 -0400
X-MC-Unique: 4GuzfYPJNDWLqOuDDRCa9Q-1
X-Mimecast-MFC-AGG-ID: 4GuzfYPJNDWLqOuDDRCa9Q_1781146243
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41C861964CF2;
	Thu, 11 Jun 2026 02:50:42 +0000 (UTC)
Received: from [10.22.81.61] (unknown [10.22.81.61])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CE7E2ED4;
	Thu, 11 Jun 2026 02:50:39 +0000 (UTC)
Message-ID: <c1cb5025-d089-4e73-8bb4-d7b8cc0badf7@redhat.com>
Date: Wed, 10 Jun 2026 22:50:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems, not
 mems_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
 <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: PhIe_Fo4V-cf2u2JpoSVphzPD4ruVDJL5pYac8mwm6g_1781146243
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 74879ei1rqtaewooei4rmw1pz3fe5s4b
X-Rspamd-Queue-Id: F1AB380010
X-HE-Tag: 1781146248-542959
X-HE-Meta: U2FsdGVkX18whkoeHD3FrEPAwd+AtZfrpfcHc7OX8vmHzONh0uJm5QviQtMH4uHy6MPVkpoZInN8KYNkikvW5/AFMftNIQGQTHdtZPEWzuT62LXPfb4xGstFgX+wnDfMiCn0SDzlpGMuBn9uq/+j/ZI8Vn1HggnPeShMbQZSnu6Qggx0Spxj4XYA/s/XmfnSir5b/5mP4wdQZaEmeNOvT6J0wWwfCP+AmOaoKUsZecxpWyYqvoRhZlgpT9HnbI3F1j/6yo76VP9NBgvfVFeHpoyD1cqIsjjkVSTMQxzQg0QktF70c73tm54zLqoA9yxJuov4EZvpC7N7OHR/frhuA3d/iP0gdtwLW0pt6Lc7SDs9yf8loo7WvzG+WnAnjqxz0kUX0m/nR7a6n2nAHlDrhbvFvVb6oe3DAjLmlr/N6NW1qLXnLKbiiGRaQriZ2qidsi5HjET4sGEkLylZhoqPVx0SCAxfESVBWef9o3xVt9G46TAdZEmFZ/94OrSE3pRXZmbLVDB56agRpomL38WYObOddlm8JBiDRSPGSLb4w6h5ofM9TMcSTidsWOwpszDhH/thxg+wiQqfLFQsoVSaHuoe0EO9ePF+KB5A6dZl5VS0tomBMPE8qVfMbbt462VWrocovmYpQb1hh9zCGAvNekWWqhskE5VprLhguqJui/uHdPKOM5WXrDMuDf+FMxfe/MDWNk4289Ad4GnZGtbSygv6vd6EkzDE52v4UIRoKWuGWj8C4vIAyeg0d3IF0OfIbfkZeFRqsiNS6MRhyIxdAWEeSS76+kskkXlVIaYewI+XOJrynQVSJu5gkAi+5/o5RTUpLWnVBDPjc5QqtMB/jW/nmk0eeUOxsxv1zSww88GPPgTKeZrUuNcsmPpb1lVTlIs735WNeDtThWxf6QYJwhNct0AU6QNuqAp0y8yjF9MgyiXXsx7jlGYo9OjIQqtuhW/zl/4knX9HJWK/mpr
 I916fQ6w
 HWi1QB0RA41zo6EJrOihz8AAekIyokftSIWQTtofaTwH9BSBdb6YMYWWF7dUwu60Ry5poUy/aaQMd0Nu9jQ/DrgRmE5ZbHtg4g3ondPwO36r0wllYZ7ucvW4/URQJYgcVyXb9RGwpKWWiWMETBbfYqtaGezxwy4EooZeKZgGW4yFHRAGBt+DVcN+BuWqgaG+GpJUMvBQAk+/aBJ4hVIr5GGwMdeW9IWzBFT3owboYuz+8aGaEKH1gbrifRPcdwmzjAMLDngD/iLScoMnXpw7K0hs+Jarf4IPPvtlPWXaEUrUhd6AldMAfn2meB4WsHbNO+eT/EqWFy+5wGMC0enlzDCwNo4IgsBid9CNFWOQ3zV8Wz3tZR5MwmWsd5tD9YjvbeDXufBRytgxKyf7wyP9Lzva+PVJ0SSFv1dMN+KjGejbdQWGDNu6qbAbu+lqhhKDWXdfDzLp92iFd4R/6jtMm6gf/8gIPo9BFJxTrzc2HZ9are1I6UGAuuURFbS8icM2swcNIW8aP0jlYcdVLiY0JiNMm63GDhKivTiYsdh5ELd+GRmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 7:57 PM, Farhad Alemi wrote:
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
>    Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:bitmap_fold+0x5e/0xb0
>     mpol_rebind_nodemask
>     mpol_rebind_mm
>     cpuset_update_tasks_nodemask
>     cpuset_handle_hotplug
>     sched_cpu_deactivate
>     cpuhp_thread_fun
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
> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Cc: stable@vger.kernel.org
> ---
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>
>   		migrate = is_memory_migrate(cs);
>
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &newmems);
>   		if (migrate)
>   			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>   		else

Could you change it to &cs->effecitve_mems instead? For v2, 
effective_mems will never be empty.

In fact, this is part of the following patch

https://lore.kernel.org/lkml/20260604150229.414135-2-longman@redhat.com/

Given that this bug can crash the kernel, it should be separated out as 
a separate patch.

Cheers,
Longman



