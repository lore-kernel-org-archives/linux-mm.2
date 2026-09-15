Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935E7C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB7F6B0092; Tue, 15 Sep 2026 10:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C4F6B0093; Tue, 15 Sep 2026 10:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6741A6B0095; Tue, 15 Sep 2026 10:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459406B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:25:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC080402F7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:25:46 +0000 (UTC)
X-FDA: 85216220292.02.8BA74D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FF301A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:25:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpOWlEX6;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482345;
	b=Ne3tD0IzB29I/HKqGlhMbDwb3FpFONy08prvtf85+wgsoWwzS6i5y9HykxYMmzkpjqVtce
	8c+aJJGRP8G93qFLnKSf+2KuFnGpJ36u5e3K9aon9ATJbUuz0O7Qq4hqp+XoZDFAxcODZw
	YQprKQCt9dYd1iQiRrLt1k3nOKr9ry4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpOWlEX6;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482345;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41P4RsZFtpH5NGFfQV+UZfxuwGC9lxZAIr1dw8RbTR4=;
	b=k8DI8uBXIcld3J4BxUNuQPxEM2z/5FTt3DzlZ6MddT8NwMWDzYo98q2YWd1gVLMiuNseST
	f4JwSn/QP/9kD3AKUh0bNCklHY+ap2h3Ui1VfbQ67KoAXYKXgW/PY0n1Q+FfuWxBA9B8hl
	hEZC4R5LFY8NHydJMoPer4ir5foE4II=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F101600C8;
	Tue, 15 Sep 2026 14:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5154C1F0089E;
	Tue, 15 Sep 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482344;
	bh=41P4RsZFtpH5NGFfQV+UZfxuwGC9lxZAIr1dw8RbTR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XpOWlEX6GlUhNRuKshbD4eV+VEWBxo/aZrSmcGDmlWldOIv2oE0bi2PvRXl6eBz4P
	 RDmTK0sJjLksTMFuzt/fanlQTp8CDwd2ASUZcxjD/mPd5LSu6/vz+2kf3z+RKdoR4Y
	 54d8u34R+rtJn7lOtpEg9sezQx4Fuw88RI/i+JGwTrYovq9jfevfBhs+nfQ+ARliu+
	 bnwHo5WZKnXl9omRdCilRPgX4vGWWWL8czheQi9hZ7UGe570w/e7MBIC5hu5h5OuDi
	 OBpOv3iOs3URkcWqtnKKa+I3OAdzpd7wzPITmwFaT5iKV/8N33zzqTPaKd6nio9Zit
	 SCuNzx4N2FHUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 9/9] mm/memory-failure: keep inherited poisoned
 frames out of the buddy allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zi Yan" <ziy@nvidia.com>, hannes@cmpxchg.or, "Danilo Krummrich" <dakr@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, shakeel.butt@linux.dev, "Ard Biesheuvel" <ardb@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Borislav
 Petkov" <bp@alien8.de>, "Ingo Molnar" <mingo@redhat.com>, x86@kernel.org, "Miaohe
 Lin" <linmiaohe@huawei.com>, kas@kernel.org, "Mike Rapoport" <rppt@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Breno Leitao" <leitao@debian.org>, "Suren
 Baghdasaryan" <surenb@google.com>
Cc: kexec@lists.infradead.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, riel@surriel.com, harry@kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, linux-mm@kvack.org, rmikey@meta.com
In-Reply-To: <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:25:41 +0000
Message-Id: <20260915142542.5154C1F0089E@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FF301A0002
X-Stat-Signature: ygksbswk3hzx5ew9yi9fzrjaz7bguki7
X-Rspam-User: 
X-HE-Tag: 1789482345-390512
X-HE-Meta: U2FsdGVkX1/qWWiGzFRJKDg5i/OEiIf/m9Fdp0QvjN3OsppLxppftPuLJ038ryfcs/xla22kee8GI0A+EbYP7b+2z7TNYUH6QHEPtEGACc3OB369QdYW1pr9AFXxZM84lN4OEw/tSnLtInNOADik/WN6XxejDjaYLqz3P30dXjNcIvA7TKWkzRX4fr6tf1JJ4oYwYbuUkkd8J06v4v8thWqQgh+UzWluPs+MPwZPJtJiu2C8jvKS8NfCMCX2JTKozIrMv7n1yK9S9+0fuW7B59v7xWqE5Okxyzy2WK/EROCXY7tm8yacrgFf6lV1xSCknfWqQLt0CipjdDIrQRNcAxDnuUxz08ZOnFx8I7Z1zO1F4pYf/UtsTNSJwex3F3lebkczCX2e3aZXx9QZjj8Nu4Jiu9WkEuAjvCEfR2DOQm2nKi7LQ2PGu8I2scQWOGw65E0OX3w4gn4TLCNSAkbCZGSRJLKsViFr6jdwAoCd6hNfpAPA2FoLdJh/WeZTH1+zyqxPq8a9r/cnNBZx9hLLUYzVXP4RpAZce3XCIj+J7tiGROQ7sf5bBOTkioL1t9sL5HacDPN2ILQl7qwJ/SvWMBBnyTTpiEwtDSWpZ1ufiMMO6CBTruq+EFNW8reC4GuvKuxCrx+15QhAz+jYMSwjNhwEVrTM7gtqBtXk8LwAneRTkjBk/udCKSK0jKS3wiYdJ7Z5epiNGg/lZhJjQu1ljUekndyklfSDB0cubhuOzGH4syEHBiceJqhn1zlxdb1P9ZFFeGuLjp/Xs2ml9HGNBlqANT1WpkOOJqWaZGv5sDwuzRR5kXZD3yxRhA0lcicFRA0pwIq/76gUE35NvRgeM1faGL1FmanOthxfQlETj3KHHhlYgDGq8BXpSfWMw9hwMk6ppbjAHU3nq4qdx+bX/ZHHWsf4DgTD7ilHYAwwGloV54wXrDVybed7wSlhCEuX3aL0HK4YdL9q2ukne8R
 THmAf8yI
 lHdbBiSa/dSkvfOpFBzT4mawcJ8nuqAHqmncQR8K4x2PmlTIrouWrO4go+rCD/GscrJ4WEfrILXMms2PSOP1p3AZTAveZ1L4kN2AUxv4RXYMDyM7oMffXZ7eqt/mQDnE2ajNYJofqG0L3tYwDKdBjD9rkSyXV32pktpMyrNKRSh6S/3z8p0yZp446JID/S1jKdxYvFUgKstm07mfqfA6OT3QXQFvgOWVEnXh1nC52kxHtvf28u2NfeVlpLfbH7rzG4SN5s6Yw/8pnp7YgyscsD72FW92dacEaUEXmIkQCliR5LDgcBGTaBLqUcVSQUFa4D0EQiukTvRUsEIMiXuIJi7MEBRdN2Z5wgPt+vj0OuSvEBQr658HaO/u4m8YoSOsvxd4MS1gYBns/nJ5NZDwFKhPE+0TdlsvrQ+pjdSiiK8BVCKJqw/215yJHJxBZF1//rzjdi+r+4m48fszeQPdVwvVvjLSOheK3ezmlmuN/FykzmkwXluCVCZUiUrOuW9+vNe8NR3uL7T8nd694qvtKaKs3TGG9So+2o4gtcfgFtVFLySLh+Gg4Ax+/YXnD9z4EXwaMQaMO5UVjaFkH0cUA/AH2Io+h1nQYI0g9c4i+HiBJ3v1ZSiifhNujfZxIVJvVPURC7t1c4GeKa51TWbQKr7YezvlR2qQCB5aU1C3cFwxA3Mg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: panic when accepting clean pages sharing an unaccepted unit wi=
th poisoned pages
- [Medium] mm: lost memory failure stats due to lockless update in hwpoison=
_boot_page()
--

commit 92cea9db628cbe8f9651b225628684a39c80ddd4
Author: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: keep inherited poisoned frames out of the buddy=
 allocator

This commit intercepts inherited poisoned pages before they enter the buddy
allocator. It processes memory blocks by checking for poisoned pages, flagg=
ing
them, and passing the remaining clean pages through the allocator. This
prevents unaccepted memory blocks with poisoned frames from being mistakenly
re-merged.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b07b5f4751cb9..cca67a2702a42 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
[ ... ]
> @@ -1597,6 +1597,25 @@ static void __meminit accept_and_free_block(struct=
 page *page,
>  	__free_pages_ok(page, order, FPI_TO_TAIL);
>  }
> =20
> +static void __meminit free_poisoned_block(struct page *page, unsigned in=
t order,
> +					  enum meminit_context context)
> +{
> +	unsigned long i, nr_pages =3D 1UL << order;
> +
> +	for (i =3D 0; i < nr_pages; i++) {
> +		struct page *p =3D page + i;
> +		phys_addr_t phys =3D page_to_phys(p);
> +
> +		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> +			hwpoison_boot_page(p, context);

[Severity: Medium]
Is this call to hwpoison_boot_page() safe from data races during memory
hotplug?

When called during hotplug (where context =3D=3D MEMINIT_HOTPLUG),
hwpoison_boot_page() calls update_per_node_mf_stats() which performs
non-atomic read-modify-write operations on the node stats:

mm/memory-failure.c:update_per_node_mf_stats() {
    ...
    ++mf_stats->recovered;
    ...
}

Since hwpoison_boot_page() does not acquire mf_mutex, could a concurrent
memory_failure() execution on the same NUMA node corrupt the recovered and
total counters?

> +			continue;
> +		}
> +
> +		/* this part of the block is not poisoned */
> +		accept_and_free_block(p, 0);

[Severity: High]
Can this sequence cause a kernel panic when accepting clean pages that share
an unaccepted memory unit with poisoned pages?

When a clean page belongs to an unaccepted memory region,
accept_and_free_block() invokes accept_memory(). However, accept_memory()
operates at the unit_size granularity (typically 2MB) and rounds down the
start address to this boundary before calling arch_accept_memory():

drivers/firmware/efi/unaccepted_memory.c:accept_memory() {
    ...
    arch_accept_memory(phys_start, phys_end);
    ...
}

Because the clean page and the poisoned page share the same unaccepted
unit_size block, won't arch_accept_memory() be inadvertently executed on the
poisoned page as well?

If arch_accept_memory() attempts to accept physically poisoned memory (such
as via TDX TDG.MEM.PAGE.ACCEPT), could this trigger an unrecoverable Machine
Check Exception?

> +	}
> +}
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D9

