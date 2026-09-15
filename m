Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEF0C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1E56B0088; Tue, 15 Sep 2026 09:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3626B008C; Tue, 15 Sep 2026 09:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7B16B0092; Tue, 15 Sep 2026 09:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D90B6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:15:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25B9C80408
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:15:34 +0000 (UTC)
X-FDA: 85216043388.02.E88EC2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F9D710000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:15:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4EdpEhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789478132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzikfrdXoe4OKdqIVI5MhWMg7/FGoAHvmjSaSoohyws=;
	b=lQNvhOMiXK85phGOcY86r0kqMn2KzK1dv8c1U/iN/eL6SdzFtbR9lFEYEjzSG2LLgdsR6C
	uAyptf/8PCTYaKfL7dRay158oodyyJ24FhDbgx479EJtKa8cgmaTUbVw0I1rRc8kjuk+Qi
	9HZ4CYy72GcD1wR2JIIcCxm7l1Godyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789478132;
	b=tdxCCjNEk+viJMX6JNtd1EPMj6HC5lE7C8H6QEwuEi9i376r+W9Sf9xdwdhCeg7grpKSn4
	VpY8wiggwGKKhtOpqpgTpmehNgEqhRfn2iN58vzngI+b10QJIvuiJqmZxZnNh39ucZd5uO
	OqdpAVcfT8fUhe2IvfnzrnTBGgXvdzQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4EdpEhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18138600D1;
	Tue, 15 Sep 2026 13:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB261F0089A;
	Tue, 15 Sep 2026 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789478130;
	bh=VzikfrdXoe4OKdqIVI5MhWMg7/FGoAHvmjSaSoohyws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4EdpEhkDelvZkC/X/3bK3vl9pG/mNCj4Y9fnQXsUyUjfO/C0WIiHtAE7wUFnpIJl
	 hf0m/zLPCJxaZOLx5gA1XcJJcyM0/Uwj48vUqKR2OOSz37Capy4w5XMFn4On3XQ+Qf
	 KJpsPuIDKAOrTGf4xYES5OyMcVKeiupxsGAG72zhWHFQTMAf7voR40D27dtYgU3ApH
	 8lKtecKBw1KA6sqz/3HTKKHhPKKiHHj46fRvgiZoudqwdy24NRL7Gtou8rddlFICmZ
	 SZ2KeUkDOqE1SfCUntS3mJ5Sx3OL7g5dd9LgQ4Mx2s5CqVa8s6KdFslIYwtccHAxlo
	 ocVNOhI1yr1Xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suren Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Zi Yan" <ziy@nvidia.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "H. Peter Anvin" <hpa@zytor.com>, shakeel.butt@linux.dev, kas@kernel.org, "Ard
 Biesheuvel" <ardb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, x86@kernel.org, hannes@cmpxchg.or, "Thomas
 Gleixner" <tglx@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Borislav Petkov" <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Breno Leitao" <leitao@debian.org>
Cc: kernel-team@meta.com, driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, kexec@lists.infradead.org, linux-efi@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:15:27 +0000
Message-Id: <20260915131527.AFB261F0089A@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F9D710000E
X-Stat-Signature: nh5meq93qpgj4rnyfiiqexcr5ea63t9j
X-HE-Tag: 1789478132-11720
X-HE-Meta: U2FsdGVkX18mMjvchwvVT7/KGEkg9YsGEUB86KUqMkTOAi3Y8KSditJESVDJZ5XFYIEV6sZaWkSMsMd11MVdkEreYO/W9ZAT+oWSkBq0Al0SHMC7jU+r6/XSjgxtrAi1ZZiODgrzcZ0kU0s8zOwiYZZNnnd1zw46hR/Jwb4JER8HmcDF4oARDyUi6vO6SBPE0LsPvpSq7lt3AsQvUJE10Q2//s/MX8B3PtID+GiUb8GMNrr/cgk+hmktYYBA/WxvK3RgTD7GN//AYwUu4OnP93Da81l0YqEiVJQgtXValNFQBHYhsmzupazxbrzAE1L+enMKd168nhyGzwnbhewba5p0jc5ScEVhxtNxjUwnD0afHKadaKo+/6FwSvwZ8OoQ3ste4Wiw8RjF+mXdL8DfJApL+y96gVGoL0/bOaBLhSB8MO4mecoA2VghTxuo6hlUNOK+6RBUW7ovnFn3cjXBPw38SRLR33dD/juITtrs5Zb3RQzx7JOHCkDgpSNomnAuJf7/VS40E+sti3JsEd767wRDS2jG+eL5Dy7nAfqAQMuVk5hflEZw1DvC8+VdERzCUnuW4oniOvWGFqr6CWFi8y16+Rtq4gG677hDXMEauulaLRPokhYm2ZKy32FjEB2ekP0aiFAKGjdXTRn73m4+2wquqyra1/FmbEnqNRkQIB61eKVac229VlcA++QiH+orvjh5sCYFSZSZA5Ytn6pThiLaXSDximf10VFmYdOkke1loANWOkiEzVDWOPjFh0LOE3upiBchlQwsq+1bEshFQpGXJkRnKE8PV/d+Nwp56rz/KUkwUuP9ukUkVqYbRekxo/CJ/p68tV7Ir0jJeC8S9uULIMBYUSu2CS8X1MkxU5oXOmlTDAkiSZCbXge1bSlwrvVY3Utw4ONsmpvkiE7pHweNZxLYhvuFh0c4cDI5y+7YiDlMMGy9QNvAKd7ydMb5IDesAoJKbt+x1szgvPn
 a0HovZEB
 MgooF8FZIrlQnvJ9YvwoS99ckXlOQI1uD7gIbqziO61+sBq3xbiHOs+EZsk+zXgv+mywOQ01j386fP0mEPCjLSqK96qMlpbIBxUh8WD6Lh1GLlLSqOFrIQnT7a4RQfP9gLOizud431PLhFGhY7GY7pgjJL4q23OCoR1oXDaWqX7GpqBVQvTH4maRmVzvB1G9uq4ujVQcH9OibZSAkGIP2M+kx06nm6CbTCcPrhZAL+KC6BGWNoRhHcIacyUxHnDDzNKPNBR2rERgpzIpgbLkpjKpmvR+6HhgqaLUAciBnwsHCG4OZBSgC4HWv33QBQ6zlvmV1NG9Uc7uVPjqfi5aI+oubaYR+otn6dIXxF/S67ZRg0e47hMzrCCFyH+r03OBcVh52mWYM+cGkDd2e7yWE+sob4z6Vi6M9UKrOQ6E2IzB5bKOuwerjiJP+KWDJSPnpHQJ1i/bWcBBw5piu+csJ/5HKfxydFqT0b/gu8XK3iLvpTW+5J4bg6xquzvASU+frCShSj5RHnOOP0zx8DbQKegUX9kHF5zMmMjf+8TX6oUMPv3ydG3XCUXpClYBERTyegW72eIXI+vua/Rs5N5vtRapkW8dUSxqrm8IghWCPFxygI6ziZui9l1ZQC5YuJ8ninRMLFfnzPMfD+vpsxs4lvh/rmBFEF3wYDtdi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: efi: integer overflow in poisoned memory bitmap allocation on =
32-bit
--

commit 591eef51f672049b14b50a75d67dac823925a19a
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: libstub: install the poisoned-memory EFI table

This commit introduces a new poisoned-memory EFI table installed by the stu=
b.
It sizes a bitmap based on the UEFI memory map to describe the RAM span and
allocates it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take it
as free RAM.

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
> index 48f93f7758e9e..9c66e06c972c5 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c

[ ... ]

> +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> +							  u64 bitmap_size)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	efi_status_t status;
> +
> +	status =3D efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +			     sizeof(*pm) + bitmap_size, (void **)&pm);

[Severity: High]
Could this allocation size wrap around on 32-bit EFI architectures if the
memory map is extremely sparse?

In efi_get_ram_range(), ram_top is determined from EFI memory map
descriptors. If a descriptor is placed at a very high physical address,
bitmap_size could be large enough to wrap around 32-bit arithmetic.

On 32-bit EFI, the allocation size passed to allocate_pool (which takes
a 32-bit UINTN) is implicitly truncated. For example, if bitmap_size modulo
2^32 is very large (e.g., 0xFFFFFFF0), sizeof(*pm) + bitmap_size could
truncate to a tiny allocation (e.g., 8 bytes).

> +	if (status !=3D EFI_SUCCESS)
> +		return NULL;
> +
> +	pm->version =3D 1;
> +	pm->unit_size =3D EFI_POISON_UNIT_SIZE;
> +	pm->phys_base =3D phys_base;
> +	pm->size =3D bitmap_size;
> +	memset(pm->bitmap, 0, bitmap_size);

[Severity: High]
If the allocation size wrapped around, could this memset cause a heap
buffer overflow?

The 64-bit bitmap_size is passed to memset, which takes a 32-bit size_t on
32-bit architectures. This independently truncates bitmap_size (e.g., to
0xFFFFFFF0). Since the prior allocation could have wrapped to a very small
size, this would write gigabytes of zeroes into a tiny allocation, causing
boot-time memory corruption.

Would it be safer to check if bitmap_size exceeds the maximum allocation
size for the architecture, or use a safe addition helper before allocating?

> +
> +	return pm;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D3

