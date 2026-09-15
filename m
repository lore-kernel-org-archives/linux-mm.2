Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E813FC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D9E6B0092; Tue, 15 Sep 2026 10:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126F86B0096; Tue, 15 Sep 2026 10:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30E26B0098; Tue, 15 Sep 2026 10:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D311D6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:11:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7121D1A03E6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:11:25 +0000 (UTC)
X-FDA: 85216184130.13.65C8CC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C817B4000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:11:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=baDlUtFw;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0YAPSCzjIvx9j5UuO3la71ldkiY663ti2cQ1z7Zo34=;
	b=dNHdCHhxdeRzr/p8KUwBbKKtB6BW2zTUB6f2qlpSN3dbgvzbY+Dq8k9KtStzCn521BOOOc
	GGIBJxbx8etchrd1RR2Mxvf00kQt56zTcj9KS9mg/8xO0Waxt7js2z1v9mRWyZ5LDQYg4T
	RFzpowkcM9i4YyjHNHbDZ5E39jUSVSg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481483;
	b=6/sQfhGgHMbWi3YNg2EtsAoyoXMwNJv4Mykz/UVD1uEDnWZ7uxTQkd72PNq/HwXG/bfr/9
	e1EoKKgjbgCaPvFv1pqV6hePZJ3Z1atak9hOzygpj8OisX/clielWvWCCory8o2XJ6+B6y
	ed0wJLwTCRAE1GBZ/bB1D8jyxkN1LPY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=baDlUtFw;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99FE14385F;
	Tue, 15 Sep 2026 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A209A1F000FF;
	Tue, 15 Sep 2026 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481482;
	bh=U0YAPSCzjIvx9j5UuO3la71ldkiY663ti2cQ1z7Zo34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=baDlUtFwZ7KCV4ufgTF//oU9YijykM7UmGP8RPQrD+I8pBO+jchLE29xCD1JteFFG
	 uJ0SOqHSmDC+KQ4IZxr7tzq7M6U2SU8TAl5BBntbdoZ5zj1na3pmN7vXwcO9Wpx5SC
	 rY25b6BGE0yPe+0Mswb8tlBkv5+sXjFsGykikSy1u4unUQZWAkHACiourVm8X4+O/E
	 HDneJHgr8sfHh5bwIaTnsDcvU/1uJxa2dZ/oPSwy0lhieD/NUrLxIJRS5tFAt/jW1D
	 l3m84KwUcryVRdWgYhgaA0nOxBWmOhcjT4OkTN+OlDGJuUQa+LciWoQcxHs7mQDkuq
	 cZRjH/f/KpnBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oscar Salvador" <osalvador@suse.de>, "Suren Baghdasaryan" <surenb@google.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Zi Yan" <ziy@nvidia.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Borislav Petkov" <bp@alien8.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Mike Rapoport" <rppt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, x86@kernel.org, "David
 Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, shakeel.butt@linux.dev, "Brendan
 Jackman" <brendan.jackman@linux.dev>, hannes@cmpxchg.or, "Ard Biesheuvel" <ardb@kernel.org>, kas@kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Breno
 Leitao" <leitao@debian.org>
Cc: linux-cxl@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-efi@vger.kernel.org, harry@kernel.org, driver-core@lists.linux.dev, kexec@lists.infradead.org, riel@surriel.com
In-Reply-To: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:11:20 +0000
Message-Id: <20260915141120.A209A1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: derb9owji4ykjj4rba8tne97z5fyrd9e
X-Rspamd-Queue-Id: C817B4000D
X-HE-Tag: 1789481483-716701
X-HE-Meta: U2FsdGVkX1+nFuxgSRiiMg07z6YSYXBDp50y4/5bjTmgBSHP42S4933v9qfZsGozZBsDtyvdhWejiqvdR+FI/vnpre+iPk4+oG7mDckXhYNZ5Mw/rIhhvaPkWpaxsIDTjAHF/yNAMrd2tShNUzTijfafeFo5+inF4BsAu+QPdn4AjP/Bnov/ZcbX1N0foHnrcx2c67btAcHiFQfbd0XAb5EfbTQz/9XxuIZtaIQ540ekGvlFq2PBGm6fga21rtnCDr/wI+sDB0vYbkHe3CrWPDv5vV1lU+/pJDDqPukk3UzsL8n7S9/BGST34UroyTMQSH4DguYJvmxQzcSz3iIoK6bAMnIsDq08lTxcYqsGMiIVX8KkRR9zuST5o5cQvEb0WURN/FUXUGmRvV/o4j8AAjOK2MbP01nV2fOrzVWq5qERrpyunpEmWhyc9gMhB9+hYu3kHKi0Y1vi8ZJZ07iszuBlhYOYNZHpziTs7vqrIgxCi/iKObUQQ2WWZOTrts/m0rDkHzPDqTZtsbZwD49mgTTmJrIurLbBmrnLxO48spLJK1bm7LvP85Qh+yrv5RJcdorxUgQjBaivEz16u1fhmZE6f/BISE3WvMMWTRhbGXk0mEr50EA872lU8/d59lCLVQYDevSsggWkZc7yUGKbzc3+Q9pvYir8YMD31cFnSS+XJPOiYoMmleVmEWDhHfS1IgvDiki2/tySI1cK5VoBsdY65SAL5QuI5pbD5ktb2W7ZmsYuneIwvdfjrwASuu/DbvEyn8liICgcfuKukR/Cu+mYAZR7xWjJUcM3jugzAHVMy9i4AprhpJhKHt754YOddDG86dn/1Jr5RlwSu0zjtlxIUC0ZtKtNISIkzWa4G0f6hYzOyiTPso99EeNzp0TNmJbmqK63a+gMoFcYk55KgeLmDiZBxwkMm8ybLElrnW0DaAFRzCC/PSPBvfdnChkmcC6baA5IlY/BQv0ng+v
 NjzCy6ms
 1A/PzlipfERS5ZqssTEBq8b1HUxtm156FqL1wxk4Q/PNqCwrkieoXjeWThqpqy8yQ8o7C3XYwNbZeRc1evLViZnaCijXDdHsttcB/gKAsPOuu5/sjptkh25/9U9WCcl3BKxIjq2QnxCx4YT8RI3N7iebG5z3DqUq3fSoYNjnYT4M/+dfR6vKhk+hEhVuSB3hZ7Nha2fTwvi6nlGM4gPKQtjingS6UmQL09rcKua9JXHh4C/TM7ztBxOr4QAExZNM9Dlt5mLzLmok0kx1DTE51bUnawN/tDKdV2gsbcPaUi0QF4QrAwuffHOT2tC/SIKmDMJ3OM33FmM61XlXSem/pK39bcmCDtK3jYRRedE7rMRkWuLaPmqw2TVwFpz6WBb0jgPquy4adWcUl48+QHKY4i7pcAl7YXz1kD2VR/Lkgv9ZeSxi6Hw2DHCz1g5mvPUFTwx2KQq73PR+WVt2HQAJGaikd6eMoxPkWtRD2hBB/S4KZ3Lq7MqjZ3Nvgpe6H0KqiMxlcw2D/JPmwMAaLV26Zp7QGEs13L2Xx4KDW3MEaAicdheX3fP0ZuxGP9e5DFanGXCgWtP+KP/LHYIa+erMMqZP+KJGUCSv2rHZ/UIXmqBVd0it6kYdQrBLsEIWtgKkih48c7JwawcGoiTGF3i0+zw3S7GKrdLfyPfMk5B082jrW4Vdo6rE5I5nmmZyzEqIjZt+CY8lfuwgi4UnjI5zXmIUpyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: memory_failure_stats data race in hwpoison_boot_page()
--

commit 95ab593413859ad843df67ede9095a08529eb0cd
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: add hwpoison_boot_page() to flag an inherited frame

This commit adds a helper, hwpoison_boot_page(), to flag inherited frames
recorded as poisoned by the previous kernel before they reach the allocator.
It leaves the frame in the state expected for poisoned frames, allowing
existing PG_hwpoison logic to cover it appropriately.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9b8be696aac3..60e9682434700 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
[ ... ]
> @@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, u=
nsigned long size)
>  	return range_hwpoison(start, size, false);
>  }
> =20
> +static void update_per_node_mf_stats(unsigned long pfn, enum mf_result r=
esult);
> +
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context)
> +{
> +	unsigned long pfn =3D page_to_pfn(page);
> +
> +	if (PageHWPoison(page))
> +		return;
> +
> +	SetPageHWPoison(page);
> +	set_page_count(page, 1);
> +	/* The page has been completely isolated =3D=3D MF_RECOVERED */
> +	update_per_node_mf_stats(pfn, MF_RECOVERED);

[Severity: Medium]
Is it safe to call update_per_node_mf_stats() here without acquiring mf_mut=
ex?

During memory hotplug (when context =3D=3D MEMINIT_HOTPLUG), if
hwpoison_boot_page() is called for inherited poisoned frames, it appears th=
is
could race with runtime hardware error processing on other CPUs.

Other paths like memory_failure() update these same per-node statistics whi=
le
holding mf_mutex. Because update_per_node_mf_stats() performs non-atomic
increments:

mm/memory-failure.c:update_per_node_mf_stats() {
        ...
        case MF_RECOVERED:
                ++mf_stats->recovered;
                break;
        ...
        ++mf_stats->total;
}

Could calling it here circumvent the mutex and corrupt the memory failure
sysfs statistics by losing counter updates?

> +
> +	/*
> +	 * The per memory block half of num_poisoned_pages_inc() has no block to
> +	 * find at boot, and divides by zero looking for one. A hotplugged block
> +	 * is already there.
> +	 */
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D8

