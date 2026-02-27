Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72AD8FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9398D6B0271; Thu, 26 Feb 2026 19:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E77E6B0276; Thu, 26 Feb 2026 19:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5B26B0283; Thu, 26 Feb 2026 19:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67DD26B0271
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:31:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1743113A259
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:31:45 +0000 (UTC)
X-FDA: 84488358570.13.6609392
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F992180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:31:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6wDT8Oz;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772152303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qyy+ESG4KhSxhtTwVvtYSTPvTzaBu2N4NhQlAkP102s=;
	b=eca9lgGG6JzfDejsvhT2sVqmGQ/3lMf4i++VgWgB2gbSHWDeWxDJVK8l4cQWGqbSHBlmIm
	6YPT/t2jj+JboIrACsxpnz/kOMM5N1k5Gdt8DLQQO7SJjl6Zd5vIzheJoDVqwbUTKJN/kq
	r0g/1FCCYXpoRRFWAdjF0VZzBY9h/Xs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6wDT8Oz;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772152303; a=rsa-sha256;
	cv=none;
	b=KIWsZUtLMvcGEonAKeUrnfOAvK/7shhhLH5hQRL6nmsa/v6nAIJZc9VMH3Dd1fxmjsGZTW
	HoveWRKHB80YUoM+ghO2rOEBeG6JDf5xP4Vo1QuETZCzdg5pICv8rboLKWyRoJ2F9qw5c6
	vHiMcTZa9J6zi4IySTMEwSSLNhJ5u1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C89C5600AD;
	Fri, 27 Feb 2026 00:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BA8C116C6;
	Fri, 27 Feb 2026 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772152302;
	bh=wLUycsWy3gvgVrAlquArUpLMruKe7fYZQVQj/k79Xis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6wDT8Oz/lWsnUbLFCuR+IuSXz5zQ2VJkvYKpUXXoPZ/z8OhpxaWeRaa5c4TLRAhK
	 O7HwYD8uJA3dEJRoQwpbdlwcpzKNFy6c6Y2rlnAx1i3MUOhZ/z/wkWiGmwlyEDFNXC
	 vaDUebAFwFQlcm0XAcavOJXyB7KVONW6Amv1x/VM/BEqfAsScqIXsUOZWvgdkQsNfh
	 RP9Vd2dE1ZBsotkGgdnOGvBNXFnxclpXgsKE2CpzjdRlrl1S7BjAGJs/sEPG20lVUt
	 tynzhNe8Wu+Luo8aZjvsWO+8Ja3a+mPaM4kWOeJEWsw64nvk2eyHOUYV+et7xVXzvM
	 4oAdfOn8IoOBw==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 1/5] mm: introduce zone lock wrappers
Date: Thu, 26 Feb 2026 16:31:39 -0800
Message-ID: <20260227003140.82789-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F992180002
X-Stat-Signature: 8gt13ai6txepzz1ufwkbhun5tiy6qwje
X-Rspam-User: 
X-HE-Tag: 1772152303-597915
X-HE-Meta: U2FsdGVkX1+Da3kLOjdKfE6hH0hbiyjwFhByqQYeoK5ZKobhzeIuWUccpeAUb5Z6B6cxFle6o/lra8KewD1hRW8C/KcTyWufCtTgQfdCauAAf1KDCMJAEPq6RA9TeyTKsffDbPN5UT2wfLZnvaeHOd7/1081lhktiJqNxIpAz49hZwxoKGNMswFV0JPxHapnYuYyyg+Jp6cH4+yUS9t0HMygIDxOdfOJo1ZAXtjNadIvUDCToscaOEpQ2V4QuQqtQZnVPS0LbswpHpyJaA4XUiwslJnphKktSE+norz6F7GAkgmp9jgTFV4sG7ifXu0MnDg+crsCNDQqlP9Uce8iuVmgUQCu75gny82rYN4C3vV92F2cpsVn1NgnKy8Vm4WH8f+Xy2iAD5eGc8vAkuykx6BFQklhDeIPQr0Dcn3jx4eJHrLk4U027/WPwbq9Vr3vZLPlY6BxRpdmmQcKKeTKHDWpl3DgPBM3O6JO1LDAfBMZiGrMjfXU310zXcyOkvYWTqGYrXwSAVVF0yRq8qb10qGWYZf+sZ7KOasgJssl3yYvNfbIFQE3vg44rgnznEhXuZRf0eXbuo8quxaVBsg2vvb80UDlWasKU5BGsuoMKLWUq/ZjB1KS1giNeEwWt9J9S6Nlep0SUGW6gL0NyT7+DJ889OMQMCsxyzVmTIUiUv4X7g7M6kvYQij43JgWy5gf2bI7ZnqPOTdGQYAqlOaS3IyZlaGbo8jNGTaf5ON6Xo2wbk7ag+vhA1cwLj92gt5TFtSdRZYUyBSXAQv4H4WkVAZb4671uIUDEtIat35qBv7AqzRHEI0ImGdBGXKA1BYGqmyfp8yonkJjRXmDkGnq3I20JBq5ePpPvZJbXxEZOXhtUHFFr0KfyEuDxKzIBSnay58wMEmp+sWYhzPL2jmPLDo988Zubcq01OEgz+zxXxe3y2gAppOGTN2XHpWts+8jNtEUX+5uWlJCZF7Ltel
 JgHfq29R
 26EAaDfIdyEBUTA+iQ5tA/a4l32fpYpSbZmluMZB5ywXsoC6WXuYuJ8fB+4IiIVArQgeXj7Pcx1auOZSyEv7jhVyHFRThqJYpSRAw6xCG7DIZGQW91DePBTiYb9FqVbkJlOjAjdzSN9VXMir6zOR+e2SaMbPQqtG4Q546fz/neU6jmT7nUnN+MRgbKFHohTMhwP2FY+Z5DgRHG4iKFrb5LcnuyFNTZlZm7H1ZL86aCW83QONutH+CypmiKZjiucV2yHjCTiCx25xuqFPQFyzbWOWQkWIWYnzf2wKGV+k0uKU6WJnnNmKXLyeC/Yal+/Y1wBRQrj96d7TQdkvuiZUOvgLp0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 18:26:18 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  MAINTAINERS               |  1 +
>  include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 include/linux/zone_lock.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 55af015174a5..61e3d1f5bf43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16680,6 +16680,7 @@ F:	include/linux/pgtable.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> +F:	include/linux/zone_lock.h
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
> new file mode 100644
> index 000000000000..c531e26280e6
> --- /dev/null
> +++ b/include/linux/zone_lock.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ZONE_LOCK_H
> +#define _LINUX_ZONE_LOCK_H
> +
> +#include <linux/mmzone.h>
> +#include <linux/spinlock.h>

I'm bit worried if I will think this as a file for another general locking, not
the mm specific one.  I hence think renaming it to more clearly saying the
fact, say, mmzone_lock.h, might be less confusing.  Or, putting things in
mmzone.h might also be an option?  What do you think?


Thanks,
SJ

[...]

