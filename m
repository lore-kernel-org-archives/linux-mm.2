Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C49AD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 13:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B176B008A; Mon, 29 Dec 2025 08:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB94D6B008C; Mon, 29 Dec 2025 08:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8066B0092; Mon, 29 Dec 2025 08:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9C726B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:55:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38CA4161518
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:55:30 +0000 (UTC)
X-FDA: 84272656020.10.E202623
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F1304000A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:55:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGxdnq2k;
	spf=pass (imf04.hostedemail.com: domain of dinguyen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dinguyen@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767016528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCHdJ+AwPpTnlXU8IFZJLxjB9Jt18qke/EXtZw74Gu0=;
	b=NQqv4d/ZQTnOE6DS8IkpHksDtH4+dNxOElLm+Nb5ewdlFlPXVxSu7B0kB5l/GRrgzuz6/I
	NciAN2nsnUN83ztNoSlZ0oMsQe943BMGNZFvr6b17yKjHOGF/6CjFX0dOu4i87GccLYj//
	zkxYdXA3/hV+4W3H17V0rPAUPjAWYTQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGxdnq2k;
	spf=pass (imf04.hostedemail.com: domain of dinguyen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dinguyen@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767016528; a=rsa-sha256;
	cv=none;
	b=6zqF/X5aJWf5Ge37U565XLmoxEEjOXbaPyGuyaAsr/8km80QrqBBPpd0OjCkefSnL4/Ssy
	JoiwzjsPNiv7oCE1cux44NIUBT9Vw00LBYPNgBCJKQdghCRyDUlPbjz0ccHyecWXds5nb6
	kIqzCPsM8+qIwkpr+vCNFzRad6lWNcg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9742B6000A;
	Mon, 29 Dec 2025 13:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B958C4CEF7;
	Mon, 29 Dec 2025 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767016527;
	bh=KUzcCQmQKdCc6BXDXkIzmgljIGG78Dm71TrJEBQ0UVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YGxdnq2k/1YHQkO+jdKT72GRWIqp9MvmMpClq2GsOdPjlPP0FWxM04kupp5c2Q36H
	 WhlDnqIsMmUc8EKUXxMVpxOS42QmCYKRBBIDWLcXcg4PUPqipaWdrKH1gKS1FwASa/
	 hKp6pXPaUfKZpSt6S9+PDmd4sDLYk+k7PB2/GgxYMbTYOOhWXttLamMY9XPRpV3eOG
	 +7yYHchowcnAlit4edYM+tpviihqUXpxV86rHDGshmddrsiLgHbLG6n6z8+q8V0Y39
	 wHGA0q9QyXUGWHVXz4L51blEjBjtP/4YARdm22YWyWh7Tr/vFqZHJq9k7MphA7j8SR
	 mM6Yjtx2b2iDw==
Message-ID: <d17b3b7e-2d3e-4b0c-aa55-ce82fecc1710@kernel.org>
Date: Mon, 29 Dec 2025 07:55:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/28] nios2: introduce arch_zone_limits_init()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Stafford Horne <shorne@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20251228124001.3624742-1-rppt@kernel.org>
 <20251228124001.3624742-12-rppt@kernel.org>
Content-Language: en-US
From: Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <20251228124001.3624742-12-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6nkp6bjgtq7exx5tw9q5yeiu1i9s6b3x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F1304000A
X-HE-Tag: 1767016528-110808
X-HE-Meta: U2FsdGVkX1+JoVRrdHXlrZLG9mDVf8WtXg8RGGSbrL5hR36Gt9nc2jFjjCemzwLY3Pg05eEFbAAtj+kbKHLnw6J4Ifv9hz1zYYHJAD1cqV+WavWRe8u+09k4S5miqJMDcHco5sp6M4BNVqslu7p2VcLsUMDOPDHzBryqujOhWMUKNK7VpHm9A8TEFXYgKnfP+iwbdZHvWTit7htCh7XgY7u0uoWXmyKc1iRAZEJYrlYvq5Z/OOkx4Wg1NDYWS5yLK70IP5kF/nS+7m+AQzd+fIz6ln+mXef76tzCn5zhBTumYndixdq2wCJsElFnqUkr+RLggHx4M1DLOTJYpVxVanJx0qc2Pz8u7nBU4q5+/RKibPGHVd2c1rxtLXZLQ3MBGvtquQXUdbi7mtkMvU/z3CcuJu+LO107a/eBNHzaPDavxwfvyZtXjO0gTfhaOz8pJUNqPpT6uNNPOxHlYl3GgigrhhlQzFFIc3gu9LZ8d7GUtjR/tiMQMBohojUrCxLT7YFZFvHNWMcLzPjiP+spOyqJKHUTN65qykpysbkdegYYRqSw+frZejy2IEvFjg9EFKOKYqiVsX2iNXps2fsnnzZ8lCT1Tnlq5yY1ogvS/kTCg2+gpVKmMrXklw+lBQYEGuQb+xURvIsXa0LQ7jrwNJsr7VmMwQ9jePWeFLt4CvUh0MVYE5NZCZa+cSO2n5MY36+75fYm2TTlcZ78HTsSQXl/GZin7Lswm6Ks/fkLMQts3G7W/JZAW/n5CWc4A2vCSOBes6PDI1MFjnFjxLn0mvcpQJ/qQphTNoN6aqsQ5MKgKv8XbMRHsSdN0+8quhYB+tNajWgNJUZB0lKnRavWb1hN5CgZpukle4hLSXk26is0M2tOwKoxhCHlFwIitZVsgS2+TWXROV54HPYjN6jPMxKIrtc6TXfvxwETBkTIdqTF0+nLeM6yl6cyhwGCka1BNe0T9Utdc9et81IEO8K
 KnIiKgvc
 DlCRrA7NJf1HGPr7BVohijKoxMKSsrljR+bgKSaoM6+/Dufbfe/zimV0YV4JOU4j9PliuQNuIadpRfTOwFeEqFPmlWXo5u4/NJ8pzcf6/Er7A4cSuloxRafFQpjtqkIPZ86VAz0LWWWSQoZK99SPNEHF+87bxF4kchPNt4NuY8JKPluF2pdh/AZqDeEya6xXtcmOGw48tUEMSR98GU+DI/3LmPkk5ZgBo1LqR4kNmmZIMs6n0AJJQST79LZ0RjrXu47YQD+077u10DKGZIwrao2SCovP37GbAIvixy2/AXAnDyxHwUffIgoRYgC9wVVeQg/PTexyNafMimnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/28/25 06:39, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
> 
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/nios2/mm/init.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 

Acked-by: Dinh Nguyen <dinguyen@kernel.org>

