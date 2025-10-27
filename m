Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F1ECCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5AB0800C8; Mon, 27 Oct 2025 19:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32618009B; Mon, 27 Oct 2025 19:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F70800C8; Mon, 27 Oct 2025 19:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B55378009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D10814028E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:25 +0000 (UTC)
X-FDA: 84045535770.04.06771DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCD99C0006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfIQEUEQ;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4eMvISwjAV2iG/mOWrYVKuWSHP+jZRkdt7Dk7yKMvg=;
	b=RGJS3uHBm8zbVSGW/zusaMMxbE0/7s8LPMexOHP/taZss3NAyEEdFMkO9X1cMcf+yEU8WP
	h4hh8Qf9IBaqXcx/9UQdHGLqmi/Kh6qAhWmdBcgsZR5SD+6INu9pMndLWlnPmxboTYBZ44
	poqBsfISl6fi0708LiWkQRlpEqKbC20=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfIQEUEQ;
	spf=pass (imf22.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608903; a=rsa-sha256;
	cv=none;
	b=S8lcao0TsNhCVQlk6alAPylsJ3kk9+ZJ1/LSHTS0h6WEkrqL47xSjWN4tzVKSv7IHtDa2U
	GFpP6/596UEKVMsJXvqpnLEZYNHi4ujoTn89mAp2Z1rMc9DtRYnH/K/EyC79RFVsMvWjj9
	o3gMRuIXyAwWnCMJVAJI3SGxC0OSHq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E84764369A;
	Mon, 27 Oct 2025 23:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11819C4CEF1;
	Mon, 27 Oct 2025 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608902;
	bh=AnKh9TnjGx6cTQHLhdWTDeeCl/DZJcm2y5DLoUM1VdQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=gfIQEUEQEQi+CfwEFux9nzPvcCq3QrhwulrRz3IrdqsruHvUIgsPMK56xlLanv3zY
	 peCjFOLErcM8XS1tvtrG4GU+RtTgLDu19+0Y0EByMZ7MftGEW7mYNYkwnMLwp70Cs7
	 iLtvefYfCXDM1Edbuvmzg+SJteDVp//b3FDA6wM2dx1uowvn/OM6klNwml72HvDhIE
	 gfWNkzOPxRryVmkpj3rmhNKPTEq6FC+ksk5gMdm7EKO19FAipFoiy5qPnpYDJRrITb
	 A+JisPsY7cXjEB4fut3FGxq16Nb5pIj7O5+3Qtzn5nssYXobEmdl/FacvC3lNp9Kuk
	 +uS6QYXz1VU8Q==
Content-Type: multipart/mixed; boundary="===============4764234490748152666=="
MIME-Version: 1.0
Message-Id: <2c91977fcab04be6305bf4be57e825f7e84005d16667adcdfad0585be506537c@mail.kernel.org>
In-Reply-To: <20251027231727.472628-9-roman.gushchin@linux.dev>
References: <20251027231727.472628-9-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg pointers
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:21 +0000 (UTC)
X-Rspamd-Queue-Id: BCD99C0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 38krt3ocro85u7a8towshiui3jfx43e9
X-HE-Tag: 1761608903-16572
X-HE-Meta: U2FsdGVkX1/Y2gbVKQyu7q02+chwypRqWU/SVEVXlC4jwNT95xkOxP4GlEUcWOL7s89+OQ54mA8RGPPb8E/FzEmqO9jJN4jWzY0gKK9nQGY+mP6IJB7AxiduEh5Bqhimi8/XlCiLk+U/piLWyrK1cCFe4C0Y7aNCga2LpdQrwdU0eDLD67MVboIBzopg7HKEOI7gCnff45JT/KEJTA4RQ7Vy7tV1bWWsbWGslGbUT3XNtZS9N1FM7O8Mp3Iu30CeNRSClmLAKCjJIpYleBywC+InxT87k10zrE6wU18IVxNc2xt57Xt9S8JVZUK0cHh5QkJnYVSGA4vh1iiRxPjLqyaphed6bj5LEH0xEPynXtBUmg7F1ppBly9aUm2y6ijNULUdPzbODe6s7l+0n2F9cpvkSorMf2QsDy0/vFo+hVML4KUQiBZQdPI0tj9Vj+J7FSEaboRPWzno6K2b+H3V+DsQGPOIbEFtvJqQMAQexOa8TYkQ/XG56MSsVcTejECnEKph0sCUZSmOO+zl5lQvKOjLPPnuUE45ly5IRL18aQea+IY4lq/cgcmhCVwY2tpK2IWO0ZnHUkY6ywE0XhEqPiEZwDNUesOW/e3RTAp0TV8FoWs5csWrJb8HJOI9OSmyZ0rvOxV8ByNRu9fFzSr0nisCGV8jCrwm8sgDb2BdWL/ZeEC+digsei7btr+E/s5qjvXpLd2B/Dd79TxGIdgDYmsjhKJ8yV4R7q0njHqWMiWHaUU3brsO1CwaVhDuqgP4dX78CF2gdOQ4XlUpVN1e4+1tUAqmaLA1ZHCBNszA7Zwf9TTVhT+m/lqGRcJxfojG//H4t9JoEMrNbwzlbZSybY1VvfV8qHHX98rgVdhkMLsiG9W+jGRKU5qknc6HqJWUA2IbVONMco+WVxM7I+rsHEIYTLx29mmQul+UyTt91vlbxHDdABmJ1Ifn7RQd0e6fHivkfNian17U+55KoDo
 +882CDTU
 PjihFy2mNeHeCMK96wYVeXZ6CUnSmSyQ286U2nLyGGFoF/m/GxwTHBbVwjKUoDJatkZQulCGmXbeye6lp7UuLgdRiUTWXX2CdN06eVQp5b+//MmlgkhV2wC7+MymslM6tb3fE70xt4BYect8G6kMHdi3GJLhx+ibzQhqopiXlV5jlMMcSNqIQfMc01ycXFdLEvObqvU7OeuVtWdwngdD9K5TBa7Pw3Bs4ZdwjvwHUvzreoEmAwHRx5HZBwgyDwN5WsJyF3epphfFd7+jdbsh2ebPxmiwNeJsZaLD3v/1UTnA/jnqeaVZSTwJ6rsHhfwqSrnDvb3c9mJaOr2HQUV6UoDYAPiNvfkLsO9okdXIajnOTuhLak2QcMqg/TvqjLssR22WbHbXL27EkuB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4764234490748152666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit ec8e2e1769704b4f69261f36e6aaf035d47c5f0f
Author: Roman Gushchin <roman.gushchin@linux.dev>

mm: introduce BPF kfuncs to deal with memcg pointers

This commit introduces two new BPF kfuncs for converting css pointers
to memcg pointers with proper reference counting: bpf_get_mem_cgroup()
and bpf_put_mem_cgroup().

> diff --git a/mm/Makefile b/mm/Makefile
> index 051e88c69..2d8f9beb3 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
>  endif
>  ifdef CONFIG_BPF_SYSCALL
>  obj-y += bpf_oom.o
> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>  endif
>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>  obj-$(CONFIG_GUP_TEST) += gup_test.o
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> new file mode 100644
> index 000000000..1e4609774
> --- /dev/null
> +++ b/mm/bpf_memcontrol.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Memory Controller-related BPF kfuncs and auxiliary code
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/memcontrol.h>
> +#include <linux/bpf.h>
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> + * @css: pointer to the css structure
> + *
> + * Returns a pointer to a mem_cgroup structure after bumping
> + * the corresponding css's reference counter.
> + *
> + * It's fine to pass a css which belongs to any cgroup controller,
> + * e.g. unified hierarchy's main css.
> + *
> + * Implements KF_ACQUIRE semantics.
> + */
> +__bpf_kfunc struct mem_cgroup *
> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	bool rcu_unlock = false;
> +
> +	if (!root_mem_cgroup)
> +		return NULL;
> +
> +	if (root_mem_cgroup->css.ss != css->ss) {
                                            ^^^^^^^

Can this dereference a NULL css pointer?  The function checks css for
NULL at line 42 with "if (css && css_tryget(css))", which suggests css
can be NULL.  If a BPF program calls this function with a NULL css,
wouldn't it crash here before reaching that check?

> +		struct cgroup *cgroup = css->cgroup;
> +		int ssid = root_mem_cgroup->css.ss->id;
> +
> +		rcu_read_lock();
> +		rcu_unlock = true;
> +		css = rcu_dereference_raw(cgroup->subsys[ssid]);
> +	}
> +
> +	if (css && css_tryget(css))
> +		memcg = container_of(css, struct mem_cgroup, css);
> +
> +	if (rcu_unlock)
> +		rcu_read_unlock();
> +
> +	return memcg;
> +}

[ ... ]

> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
> +
> +BTF_KFUNCS_END(bpf_memcontrol_kfuncs)

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `mm: introduce BPF kfuncs to deal with memcg pointers`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============4764234490748152666==--

