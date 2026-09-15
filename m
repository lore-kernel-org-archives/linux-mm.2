Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDD2C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BFA6B0098; Tue, 15 Sep 2026 09:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925186B009B; Tue, 15 Sep 2026 09:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8494F6B009F; Tue, 15 Sep 2026 09:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67F9A6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:05:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2F9BC010F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:05:44 +0000 (UTC)
X-FDA: 85216018608.08.C72148A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1CF02100010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:05:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaWwXhlq;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789477543;
	b=qByWOlPMOkDzF4DHn9KX5T4YU1VWmR34wYVH2gOwE/059brpE6/nAapN5cVHDn9r3U1r7B
	KnpiTSmE9sPwS+1GuUoJO61ZWgrN+NzrJe+B3waAAg+lLQ0y7EbMdZybo2I0tgyTJCPgoT
	aNpk6gWHpBu5WxK8/unIXWFoptx4kA8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaWwXhlq;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789477543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ordUloR4tkzjSO9c8EIpA4VajsXZhXheq1XH0wJbAg8=;
	b=1CLiaARgjymgYIN4kvyFEZ8h+Liy3BHrcr5XR2l7QWeH/MNEJPR0NyfVJgcoWjxUjugP4u
	wQh2wqW1eEJwiBkLNKFME4pQLZ9ksOBzR6GMBIAKgp2bh3R/T0MVAy2WfdF7nWH4T4MPwX
	nUPaw9klX/LG8Fwmjr+iCY6PabzcQak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4955A42D96;
	Tue, 15 Sep 2026 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C919E1F000FF;
	Tue, 15 Sep 2026 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477542;
	bh=ordUloR4tkzjSO9c8EIpA4VajsXZhXheq1XH0wJbAg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AaWwXhlqxLtAa5qlsWLkRg/bwK7yuKnIL0MYjZ90S+6rgQdy2v7lDv6HG6lkhZtYY
	 23zmI+aO1DaJfwR21QNJYZjFaow5wDJ2UDYtmR+AB7oWsO+95ZAfx5htQPznuHY1Br
	 +8gWOaVLSq3ydNSGBSGAM4yCUoQynNoap33dmuxf97RTtGGFTRGMHtsBgX9xLyDC+n
	 1w02AyhfbIKLqA5b3fN0dTiDi6z7pCjNmRiX8xTSK86Al8POq9LjCHnnF98mSL0jLr
	 8q8VIkJ0yl7nt3TuB7KsNJMkaLxaV94rNmYWVvFE+QcKKO5ZDiZ7hvmzNgS2eBKrGi
	 RvLz2STvXrYeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/9] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danilo Krummrich" <dakr@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Borislav Petkov" <bp@alien8.de>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Breno
 Leitao" <leitao@debian.org>, kas@kernel.org, "Liam R. Howlett" <liam@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, x86@kernel.org, "Zi Yan" <ziy@nvidia.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "H. Peter Anvin" <hpa@zytor.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Andrew Morton" <akpm@linux-foundation.org>, hannes@cmpxchg.or, shakeel.butt@linux.dev, "Miaohe
 Lin" <linmiaohe@huawei.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, riel@surriel.com, linux-cxl@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, harry@kernel.org, kexec@lists.infradead.org, linux-efi@vger.kernel.org
In-Reply-To: <20260915-hwpoison-kho-v5-2-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-2-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:05:40 +0000
Message-Id: <20260915130540.C919E1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CF02100010
X-Stat-Signature: 3k6ec34inydonb4a6u8zz1ken9wd5ctw
X-Rspam-User: 
X-HE-Tag: 1789477542-731499
X-HE-Meta: U2FsdGVkX18+35N0lbaIijGXYMv6VPKjMmvnrGSgoNQ0Qo+fnYiHnNRYd/UvBAxYxcPedlmCEALAzryzVlgLvaXLA6E/3/an09jzoENwCkKKkjPb0SIvKEiSbV6P5fn2bU+7UwmYDwiwegRtLTxLuDeqBa6ndicmO7zeWFtGZJykR3gOD8orivfb8fmw5ynq4Ga4G75t1XtXvvUKFXyu6cg+jEhk50jFS7Wy4s6WPMiAoSptojHLbrEMUUZ+ULtsnflLpCxkqeUO/Gmj9+7W40+HiT5OL/sk3ar2jLzwqRElu0bC0x8ascNCWhyKrPBfQEfGQooFOXnnVQlI3Le7U8wtGK5AHMtNab8kW6vUFdwVXpHgJtFxF14x107jGtpg3HiYOzDwQovBRXqLbEiNcUq3PddcbOEXWjpxiaIXOmFe8X80Ip7NhQ7sSqN0H3Xg7NMv+Zsy32oh6WVoAzU4kTEMQuksd+MLwRLgtFuSm/oJhcA6LrLQycu80mgisT2rV+zBDt17H6IT+Qj5eCiaPPPlGJ2Z5Rce/dKAxG9bWwUVO65t+ZQeRFPx+UWAdRlqHbzDL0JY1L2D3eTQpDK5qIGce5kxktREia2AXRqnYGPPuckGSy9aeJPG43DNFEA/mfatyykWyxevsCwl57yIUt9gp5URQGCD079GNCc2O4jwF7kVuIeGzX9P6rOKSPtFbKDNOL6byannEW7I6gVKAqzlN9LPpHp7xYmiSdxI3btm80C+0giwwCWbS+AEaqhlAMCe9KyHai3jUjNq7NjnwAgDdmu1O6+f7eXq6MQ2SEpPKa/YJzaEJpEO53Bj4sbJmGS3/jrGGT/gB3OWfd17dltmdnTTDVLg4dsosDep5iAVdqWB+bbboaDuo0Y3MTMMnlleN3bEtItyRRDRzOToyEHEB7HQU1GG/Oh39c2wwMjz2RcKU1ho9IjNhOJGEoRvIMNKedwBtPFdesVsWoS
 nm9Re7x0
 4kAjmRUbFU1U+BMXAUtwZqiTHOj8jwV+3bNazHt7OqDhjU7o/jEqXHePeW6IDP8c2vGoz5ZmKmCOUsenR0DhdHJTYd0kFCJvh2JaXTIJXWGmZaPBx5JtDjOtZ+MeQjIk/Un5q8LD5C+5ZZE5omtyYS8kB334c/9pVaeL5KMmPvnV7p+CzB0JWP/lFLZqdid5jRoXqfKjGE7ssbKowKh6hde1zYDkidtupn2ibuesCs4dnqUA3wsVSN1JgaIOSGO2LEMtnchJG8mtvSQR0CbrslYiXHSkShOi4GlgHKOeyDlcwjNH4HRBf4yFGr8snOhRV227/JvHdrFFLSVae6KohboO3xa9/h9UbZUoxiC5Mb6RjMXL3IHIB07JnzW12if9DhrGhDlfaswq99fUN1X77JB7SnvuCEUFcQKOHuQoif5Q0egP80WaTliG7ccpQ8wlBQ0Iwnf1t5yseSWjozrAIGzUZdnEvJIhzYlZLLi0ujEFt++dXaW1JKVf1BlrUh40knTYmoX8oeja+FXN+TC6nC2QVU4OlhKh7QQU49n2NoFTvsnXxivdK0o+0XTOGAjN7EMwZrsfYLpDy8unVxzDjaJHa3FC+6531bVA706hbpPookL2LXPexSlaxzPpEPNMfwEqOyO/cf17GUPPbN1kYJGhx2RTOFgauFg47jFcjxBMDxGw4dvqvfqWQ6gK3G1fn8MMf6bg0tRbrr0gHSyvs+sLaZ4AUw7c6We69TS7Cqc3PqH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hardware-poisoned page frames are tracked only in the running kernel's
> data structures, so a kexec loses them and the next kernel doesn't have
> this information, thus, tripping into them again.
>=20
> Add an EFI configuration table to carry that information across kexec.
>=20
> It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
> memory starting at phys_base, modeled on the LINUX_EFI_UNACCEPTED_MEMORY
> table, and it rides the EFI system table to every kernel in the chain.
> Basing the bitmap keeps a machine whose RAM starts high from paying for
> the hole below it.
>=20
> List the table in the x86 efi_tables[] too, so an SME host maps it
> unencrypted like every other EFI table.
>=20
> [ ... ]
>=20
> This is a similar approach as used as unaccepted memory.
>=20
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D2


