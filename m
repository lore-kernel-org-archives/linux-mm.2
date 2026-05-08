Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBCBCD37A7
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D093A6B0185; Fri,  8 May 2026 11:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA576B0187; Fri,  8 May 2026 11:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6E76B0188; Fri,  8 May 2026 11:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE4BD6B0185
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:40:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D5DA1C00B5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:16 +0000 (UTC)
X-FDA: 84744664032.17.2390A39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8507418000C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g3/gBa0c";
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778254814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhMfRfoOfBbVALGBjX/IdO3YKsZdRA4ohpg5QHM4gVs=;
	b=78+JK8ZTvYAlRkBciHrIRZ/TFVC/FEajksABO7o2mQXg/ieYIt6p+Iyqt9izINyn6bkVOG
	HGFUkEXPh8i2M2AX/aVHqrWe+uzUb3OLRn6tgkCdIgZJXxibvK9SKQ668blTwhO0SPgfc9
	YEh+0/RsxIMtvviCleQPRCzDt5XBqh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778254814; a=rsa-sha256;
	cv=none;
	b=K1/8LmknB8d+LRWiT/3s7D6UbV7xrih93alwkRhHeMz9f6E0LrIfv7pcmKxaeWUth60Gvq
	IMGM/i1aj4FH158qGUngDilFsgeTl59v8hiBrrTRrpfDwfNc7t68cYCk0wb2IcZUOGUAps
	iFLWNWP/8TgmsenwmqYd4HJSzbfkPkA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g3/gBa0c";
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BF0D43B46;
	Fri,  8 May 2026 15:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A15C2BCB0;
	Fri,  8 May 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778254813;
	bh=5eIp3bwp4cQp8tg23m4rYRdOZqX+WIiuLyvtwPi+PH0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=g3/gBa0cf9OwjQWFJ9vGe/TZWi/Xv4i+zd0jitU/4ginCWmWARUgMgccQRP1SCzCA
	 Vr32iTk0ixcL0tI+mygVv9hZuSJq/WYAQLW0s8zS4JUwzqPD5EdR/2F6YgbPmHzieq
	 Ac/gO3rLy7NXECVdQ8EMLY88VVLS2dLs6YZdSu7mfQu7wlL+uvZaglBLvLgNsB16rt
	 LqaIX8UuafPjEj1qKQ95twBOPWaKycexMADMh3v0f0eSANMxfdoSQkvcuhT/aAktZa
	 Gp4K4g+JQ5ac7//GdSQP+WjW4467vADUIupjUHGod2gdNG0lGdcXAzQyH91Y5TTnCz
	 wTGcG3mtwW4WQ==
Content-Type: multipart/mixed; boundary="===============2613262717962070956=="
MIME-Version: 1.0
Message-Id: <669cdfc48ce0e37c6985d33d7f649e93eb599611a0cbe51b79defa52949580a5@mail.kernel.org>
In-Reply-To: <20260508150055.680136-4-vernon2gm@gmail.com>
References: <20260508150055.680136-4-vernon2gm@gmail.com>
Subject: Re: [PATCH v2 3/4] mm: introduce bpf_mthp_ops struct ops
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: tz2294@columbia.edu,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,laoar.shao@gmail.com,gutierrez.asier@huawei-partners.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri,  8 May 2026 15:40:12 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8507418000C
X-Stat-Signature: cb38bzjis4fnw88pjrpbhmd3br1ypuhg
X-Rspam-User: 
X-HE-Tag: 1778254814-55270
X-HE-Meta: U2FsdGVkX1/EJtj0xaWfLn4kfZbKbDUB+EL+x5m8pcV8QY21ODEQNrxjvTSjQbkTYwEn6MliZm2Jo583+E6NtREcTrofW/xoDWumfkYGKZgGBzU3MRdi7tjyHCkIaKkVqbj7QesvUpEGnzaHHylql1+2tS/BjmwdUk3oUT2bHuL+cgjLhzzueDrYq2xXWoENYB904wtrZcXPId+BQxLytNty/EuIoEzS7NHZG+Sldzed/XlRm7Bm2E/b6bEanTKuXpHlr+CsCkoipfWDkbyV4/aWkshrCNiq/AMl2ZwHE9Y9djHgYkFxyjt9hb1X+3Rc0WOmWJP1DdfCw3Wgf566Em8y5XmNW9Q14nDtG46whvBqahV0Q8UZYpFWX8cAxo/G5L84QlejM2VbjMwrxTCYIs3DzPd0BcI4/tdmJGV2LiqR/jR35qnnu/E/BlDdsgSbJtHuTkD7ZyK/1yayDUF6q4hZfkBO5riYVm+PBO+6HbNePQI7l7jiilVKvaKR0WCj3z1bX7bILkabp2qtiy8vVjFCQbQ0nLGf5h3NojuVCw9Es1mmbo3Yf2eX1rlrxcWAAvh4OeXwvZUIRXeD1Iz3FEi5+Kq+XxrSWAjCXxPdGYgUllHqqOFAFx7RraS8g2UfTHG078htyl2A7R5dP/xptKt4M2PQ87agvn+u90Dzfv63JNlMC798S2BcW7oQSCaDGYKBnS7B8+UNbYessxmP1/LAqwfbZJM1GLBzRvJKR7koGRbZLfe+GLgdDSj81mWzSJdgQCaLoh7bF/0LIop4ZOhKGWHc8o/RFgm9UvX0O9HElVWI+ltG0uOLb64zG1O9QZjxJy1RXGUwKtAQ4Yijg6ddrSFUH5jrIAIjKidsHIQj7601B5aE7pRFyqtlcFXNhnJ7QjmwA/8OezSp0MNsW/J3ltQjcuzgOFD328w6yBuoydiAwjnYWPejfqSch2H54JLTuyxrScZ54mMfEmO
 iojHjkme
 PzhakCPp6BIZL9NW1rw7AqR480palgUqa91kk34J7PyU3rPfXBJkWC6G0PqUJtSzzAFxAOLmxsVVuk79uzLNcuYsbOBBlLJR25ZqYuMbDNEGvz7pxunnfKpufxKN5gzW5RNEZld1JruRrIe9MhyYx/5pTEEv5Nt5vV1uQCLTw/lWYirnSPDdrEE90DhHB51mSeuRz1cAF1ziQ3QpOld31GGP5LUGLgLNWbuHpGSKX7bRByi46SgBGOYcVEVLvCxsladVhf3Gcei8EBc7j1Wmi9QBG+MR39EVVBarQwbXTsGQvkyaha/Oa6o2xy5jyS168Uk5ZbeVtlRjbdDNrAqHCwUIMlbe7L6BBlIZYi5QXnLP9XeSPSxzbil5lLRs4YSwgQ8Vz6h0Bn2srqKrBA5NsuUUAeWkWJOn2gZSbY7fIRgpbjqNTciypaQr246K6kpmxr9gjQEOc7JdutWAoGWZT5oE+JVhR+UzUry6PgjZq9yWFVFR1RP8hkdX4ETvaR68pIwwmWyQL+q7QeY8hzmdKQ+XesQAscMmL0SOjedrYDDcDx06Ia48Jsy0BX3WJgHagrC8N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2613262717962070956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 13f49378b157..cad3a87d9873 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS

[ ... ]

> diff --git a/include/linux/bpf_huge_memory.h b/include/linux/bpf_huge_memory.h
> new file mode 100644
> index 000000000000..ffda445c9572
> --- /dev/null
> +++ b/include/linux/bpf_huge_memory.h

[ ... ]

> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index f42563739d2e..78854d0e06ab 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h

[ ... ]

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2949e5acff35..80ec622213df 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h

[ ... ]

> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1f084ee71443..7db83ca81e6e 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c

[ ... ]

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0a43bb80df4f..f3309376bcc5 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -962,6 +962,20 @@ config NO_PAGE_MAPCOUNT
>
>  	  EXPERIMENTAL because the impact of some changes is still unclear.
>
> +config BPF_TRANSPARENT_HUGEPAGE
> +	bool "BPF-based transparent hugepage (EXPERIMENTAL)"
> +	depends on TRANSPARENT_HUGEPAGE && CGROUP_BPF
> +	help
> +	  Using cgroup-bpf to customize mTHP size for different scenarios,
> +	  automatically select different mTHP sizes for different cgroups,
> +	  let's focus on making them truly transparent.
> +
> +	  This is an experimental feature, that might go away at any time,
> +	  Please do not rely any production environment.
                                  ^^^

This isn't a bug, but there's a grammar issue in the Kconfig help text.
The sentence is missing a preposition and pronoun. It should probably be
"Please do not rely on this in any production environment."

> +
> +	  EXPERIMENTAL because the BPF interface is unstable and may be removed
> +	  at any time.
> +

[ ... ]

> diff --git a/mm/bpf_huge_memory.c b/mm/bpf_huge_memory.c
> new file mode 100644
> index 000000000000..851c6ebe2933
> --- /dev/null
> +++ b/mm/bpf_huge_memory.c
> @@ -0,0 +1,168 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Huge memory related BPF code
> + *
> + * Author: Vernon Yang <yanglincheng@kylinos.cn>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/srcu.h>

[ ... ]

> +static int bpf_mthp_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
> +	struct bpf_mthp_ops *ops = kdata;
> +	struct cgroup_subsys_state *child;
> +	struct cgroup *cgrp;
> +
> +	if (!link)
> +		return -EOPNOTSUPP;
> +
> +	cgrp = st_link->cgroup;
            ^^^^^^^^^^^^^^^^^^^^

Does struct bpf_struct_ops_link have a cgroup field? Looking at
kernel/bpf/bpf_struct_ops.c, the structure is defined as:

    struct bpf_struct_ops_link {
        struct bpf_link link;
        struct bpf_map __rcu *map;
        wait_queue_head_t wait_hup;
    };

There is no cgroup member. The same issue occurs in bpf_mthp_ops_unreg()
where st_link->cgroup is accessed. This would cause a compilation error
when CONFIG_BPF_TRANSPARENT_HUGEPAGE is enabled.

Were you intending to extend struct bpf_struct_ops_link to support
cgroup-scoped struct_ops, or is there a different mechanism planned for
associating the link with a specific cgroup?

> +	if (!cgrp)
> +		return -EINVAL;
> +
> +	cgroup_lock();
> +	css_for_each_descendant_pre(child, &cgrp->self) {
> +		if (READ_ONCE(child->cgroup->mthp_ops)) {
> +			pr_warn("sub-cgroup has already registered.\n");
> +			cgroup_unlock();
> +			return -EBUSY;
> +		}
> +	}
> +	css_for_each_descendant_pre(child, &cgrp->self)
> +		WRITE_ONCE(child->cgroup->mthp_ops, ops);
> +	cgroup_unlock();
> +
> +	return 0;
> +}
> +
> +static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
> +	struct cgroup_subsys_state *child;
> +	struct cgroup *cgrp;
> +
> +	if (!link)
> +		return;
> +
> +	cgrp = st_link->cgroup;
            ^^^^^^^^^^^^^^^^^^^^

Same issue here - the cgroup field doesn't exist in the struct.

> +	if (!cgrp)
> +		return;
> +
> +	cgroup_lock();
> +	css_for_each_descendant_pre(child, &cgrp->self)
> +		WRITE_ONCE(child->cgroup->mthp_ops, NULL);
> +	cgroup_unlock();
> +
> +	synchronize_srcu(&mthp_bpf_srcu);
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25563319416
--===============2613262717962070956==--

