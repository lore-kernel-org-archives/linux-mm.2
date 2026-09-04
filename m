Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB8EC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C036B0088; Fri,  4 Sep 2026 12:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CC76B008A; Fri,  4 Sep 2026 12:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962456B008C; Fri,  4 Sep 2026 12:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABD76B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:25:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0849F140135
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:25:08 +0000 (UTC)
X-FDA: 85176604296.09.8001548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A2E5100002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:25:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyFHp9Ge;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788539106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzIjMFSH1tNjnbsKNHaVpESmlSYBZ1Zva20ytbg13fA=;
	b=RLxDsbS1LoNCwF+OD7beqX+1mOeK3eZ078CcoOWbeEjbFgK/sHijp57Stuuw2G9QUn2g0b
	CVj6/Msqx1j5l0bl4diteeUPpSRggal0922Zpu2UVZXDnXnRToVl5C3j2O8yNYLcwFhEJe
	tdADDQHlbd5VnBS0jU+P+jS1/PcrzoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788539106;
	b=Ij6GDRP9WJv6GQvFCrfUg26d6bir00lxoDx+d6JfxtWimFbmB1+9j5KDFwTnByNuDx1L5D
	nSpT6m6UbpdD9gOx+y9KcP0gegImKEtRP4QyDpbM8aZ7oWbuV/M4Hdhn7lQ3F+SUBe5pTI
	RBWpUCbegOiUwZvbiRI6vvnCXa28Vdg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyFHp9Ge;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC3F74092B;
	Fri,  4 Sep 2026 16:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A941F00A3D;
	Fri,  4 Sep 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539104;
	bh=KzIjMFSH1tNjnbsKNHaVpESmlSYBZ1Zva20ytbg13fA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WyFHp9GeXwJKlncsYct5wjADPuVdgkLd2uSHFbC1mG55lAXc1U8XZoWXmnfmn9Dr2
	 PXORo+2coJ7Mph4851ypNraMEIjoOMS5zCR3wcjtLWWfghetN0zc1n+EVb7FD2/U8l
	 naTgQWztpPtatKKLKpxcMtowm4CHYIHi8CIt2tCvFG4729T85JbHsgYl4hOcPBSKe5
	 9n2GlvulkZtYJ09c13UQtPuTLY4evPQHxn6dnQSXBKuq3QzLvYB9pvF/AuT24+2u/P
	 wkSpUmHB4p4J9mFmKtXOvNAZ9oavWEkWa3uVk5jDbifS4N5aSsiiyRilgZ5DgCNRE3
	 XDY810l320myw==
Date: Fri, 4 Sep 2026 17:24:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <aprp6GXv8poXXad9@gremlin>
References: <20260831234339.280376-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A2E5100002
X-Stat-Signature: 6x9y6amc1dyep84h1ckxhko8ww57ubp4
X-HE-Tag: 1788539106-437009
X-HE-Meta: U2FsdGVkX196f4ZjyZ406abnn1KD5L5039fPw0sx7T4fMT4KuREPGdCnjQcN0bUCkz57ykvJmHuCbUn16MZ+5nYi46b7VUwX6Kd0es0HE+tREq5SjutdjdOPiw0LMip7r2I2iu0bD8rHpkxOUxI9lN5g4SpyIQwvq+YuL8mVPE9zIarZcuwYuJPgso6+R6DhWzW12sirlY/ZbkHxJ4IryhlsK18YNgyXzoQmQr6vc5oOJbObhGZ+cDiNRnqdBpPxjoffCfB/4wPCtq4u2bGHHKTBplCiwwCUzluS8MX1euML2+9gQHa31IkheS26eB5dNt/7HhnlUtOHAzXWbFgIXnJSp3eFyYsdy+MsFsmJ9ddP6loCQT9gYHuYNp7q9+zzhYV+6kzTqE4WsP3vQe0k/2BJnaA+GKmGJPdQe/H9xg8hKkjAgg4268hVn0GSjovEu+k03Yv9P4nkCPXP2/ghnltK2qjjqvnbvwrzesApVaQu4fQfZ3gNfVHZHSTJbEwCiJwt5bb/l5wMpBK/NZv7Jkds/MhXQbOXycGSZLWyCZ9NMICccWZO3lZdRCoBrwkn44nKfm4DPWI0qHUIBeuWcHJnfs7giyPAljRtd7/kmWmtm4ztRjhoCTrasmQeQmSTAdJDnKEMTzSSvSI0SQEonKqejVU9MdiNphHsgIOSmkt0MtAWUzYJVsQdkLssgu/TegEwYymQ2WnNqxrDnMWuf03x4rCLO63MaemlSAdO4lfYsBREUmeCO7t3Rvj4pOguSyjYYSWRD8y6LPkRr9xWM3xCmZJa9XabOyTljMMWDG4uCuGGnf58+qfT7/Off3+od4iw4Ke/8vOUS7qRca8x9Va0lOfp3+6KK1Ry3GhgAjTTQVUKXPtzOlzmRAA1PoMKQU8pAKBx0vx2BQDCCx7CwdVXz3IbjFI7TSROnlaiFq/nl72NANZG1mpn+3lPm5Rzrj0U/hUl+mfuMUKvaIT
 LyFeabza
 nYc6XvZTV3DotwNQwYrduYCaXD5bIJ+9hZomtCxXeNkBEYmxTefTXGb0hXmACyp6UdJjajbNHGWyL9KlTFdxgBsZPt7v0EfkCTQ4i0zsj/x3gVjsXUXHhpfVjudq17DXOf2dHXWIhDN/CbGt1VVyH1A56zgQ9EuC4akbcqp3Rg5CgWGRmbzaHXpUEIhYY/uL63PcF+AOVxdtPO8wHQ7z47hjd+8ekSd8DNpUgxK5eA/P+XLCXnyqLdAFs0ESnixVf2VIRpaw8scfTdF+UepJG8KnhBMgwjlgu+JwOVYBS78F9leosaF3xb8YX3Lz+tUQqSLdE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
>
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Signed-off-by: David Stevens <stevensd@google.com>

This is in mm-unstable and breaks the build for me :)

In general - please don't rely on implicit header includes, if you're using
functions from a header that's not included, add the include because your local
config might happen to import it but another one might be broken.

$ make -j $(nproc) LLVM=1 mm/memcontrol.o
  DESCEND objtool
  CC      arch/x86/kernel/asm-offsets.s
  UPD     include/generated/asm-offsets.h
  CC      kernel/sched/rq-offsets.s
  UPD     include/generated/rq-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      mm/memcontrol.o
mm/memcontrol.c:2859:6: error: call to undeclared function 'irq_work_queue'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 2859 |                                         irq_work_queue(&memcg->high_irq_work);
      |                                         ^
mm/memcontrol.c:4234:2: error: call to undeclared function 'init_irq_work'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 4234 |         init_irq_work(&memcg->high_irq_work, high_irq_work_func);
      |         ^
mm/memcontrol.c:4443:2: error: call to undeclared function 'irq_work_sync'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 4443 |         irq_work_sync(&memcg->high_irq_work);
      |         ^
3 errors generated.
make[3]: *** [scripts/Makefile.build:290: mm/memcontrol.o] Error 1
make[2]: *** [scripts/Makefile.build:551: mm] Error 2
make[1]: *** [/home/lorenzo/kerndev/kernels/mm/Makefile:2229: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a2..036d973ceca6 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -219,6 +219,7 @@ struct mem_cgroup {
>  	spinlock_t	 peaks_lock;
>
>  	/* Range enforcement for interrupt charges */
> +	struct irq_work high_irq_work;
>  	struct work_struct high_work;
>
>  #ifdef CONFIG_ZSWAP
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..5e2f749067cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

You need to add:

#include <linux/irq_work.h> in this file.

> @@ -2360,6 +2360,11 @@ static void high_work_func(struct work_struct *work)
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
>  }
>
> +static void high_irq_work_func(struct irq_work *work)
> +{
> +	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
> +}
> +
>  /*
>   * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
>   * enough to still cause a significant slowdown in most cases, while still
> @@ -2752,7 +2757,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		/* Don't bother a random interrupted task */
>  		if (!in_task()) {
>  			if (mem_high) {
> -				schedule_work(&memcg->high_work);
> +				if (allow_spinning)
> +					schedule_work(&memcg->high_work);
> +				else
> +					irq_work_queue(&memcg->high_irq_work);
>  				break;
>  			}
>  			continue;
> @@ -4129,6 +4137,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  		goto fail;
>
>  	INIT_WORK(&memcg->high_work, high_work_func);
> +	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
>  	vmpressure_init(&memcg->vmpressure);
>  	INIT_LIST_HEAD(&memcg->memory_peaks);
>  	INIT_LIST_HEAD(&memcg->swap_peaks);
> @@ -4337,6 +4346,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  		static_branch_dec(&memcg_bpf_enabled_key);
>
>  	vmpressure_cleanup(&memcg->vmpressure);
> +	irq_work_sync(&memcg->high_irq_work);
>  	cancel_work_sync(&memcg->high_work);
>  	memcg1_remove_from_trees(memcg);
>  	free_shrinker_info(memcg);
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

--
Cheers, Lorenzo

