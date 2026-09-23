Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A30AC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C0D6B0088; Wed, 23 Sep 2026 04:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD136B0092; Wed, 23 Sep 2026 04:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC116B0095; Wed, 23 Sep 2026 04:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADD6C6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:46:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C17081C3436
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:46:08 +0000 (UTC)
X-FDA: 85244394816.09.C701B72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3D6A160004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:46:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iMlX/Y/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwZF3pqAeMznwbepH5UUc0GjovbxR4bX9vcY1/GYfgw=;
	b=kx/nJn1DepE4qhtNy4TuetflSBS9ID0gTQJurZ7Jrm9I7Tn1tUMbs2O6mO9JDsPLICdfoF
	+mZ8BElMoNqRqXpg8shYzIHc6iXkmQSsgQZlGR56jYIJC37QsGDPXSx/pJuOewdDqrnJ6s
	5V7om0+IwVGXKkfW6ERvFpu8cDqZ0Vk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iMlX/Y/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153167;
	b=3gsmds4RXelcp5S/zrTycRqgLsXzZjiF2AeiOTdE03D40fCwiso7T3oaHk52+z2ToCnOq9
	9CjOZuA80eilsvL5VRp43/xYb31ei7O8OAxp5zrsLfaQcYI16qPjukk+TR+pfK7KlQm4Ga
	4/WWUIImmxU5ycZ+0Im9CBr7QVlvOYs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F91541147;
	Wed, 23 Sep 2026 08:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68911F00893;
	Wed, 23 Sep 2026 08:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153166;
	bh=PwZF3pqAeMznwbepH5UUc0GjovbxR4bX9vcY1/GYfgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iMlX/Y/JtwSu4cblQ6iLw2qW0e3IKyVInfxKJfA7BRoK/pTyJ4S+EDCwf3WlO2yI6
	 ZMbKchOUQs6OzPlv6jnOnAFLMx2aX2yyJ4WIdCXkYXviXnt3S8QE2R7tMcyqyjh8rc
	 D4YgQrB3UhOYtmXzHvKNBpqHyocQXqJnPewl5zg0aGtqvU/ZGIQ9ZTXHbd8dp3LwaO
	 i/iIM+R+GD+O4G+3sJKba/ZRRZEkamytqnHX7jbxqcAlQeXOwGsRNUVKWYsrpYzEGc
	 xDRsh1rc5dJlzI+7Op1ib6nlgpPzfyKS4T3MLSAsHl0DQtb7fEC+vWuK50S+36E0Ph
	 m1Efg+L3WOhow==
Message-ID: <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org>
Date: Wed, 23 Sep 2026 10:45:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen
 <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gyy8w116ijk1rt1d5t5pnixkob3ak7by
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3D6A160004
X-HE-Tag: 1790153166-379100
X-HE-Meta: U2FsdGVkX1/d9WRLuzUJ0j+b/NFHOXd7Hvv2UeY3sMlgeTlTTYTBGfwJGrNnR4bVFE/0Niaj1YEDqCIFjnBzFmtQj+GKJN4apQqF4NuN/8yMsNwpdAOHvY1ZcpAhsjXvwUplpu7ZXpvQpvZK+bAqcexo8PwDIv8939Ot6rKNnKPjL9VzYs6jm6PP9WjUTtpM2dNsRfelV8Wd8fiueUAOFJDkz6VURgm5/ovANW62k/4kQSaRJB/ehX8j16X3ZU/0l5+A4QNAAO4zFqb7v3R29HWjx0BxouKPwoJiKCEksmWm9S/RjFfDZLlgN7zRPZClAZ8Ec+WoXgSMj2XoxkWn8HAAB1seRm+RPaYN40y0ZX+HRNfi0L/fZO5R/VT2DyzjWUpwF7M9FFVML77XqhNJegWrX4GYyshHjUndKkTrvTRYLbkqMas858NsoZmGclNK9kpEgLfbcIst2tTg86sTZupuhK9X4rxUryI9o24RTE4rjx3QtmPeDbif1rjMg9hTt2qWjqrjoQzI8K99p4E0FSIKlMiy5cmnWR4F8VeNraNlVOoG+NXYJfN+jRSgYXgxEeIh1/TZlQfcCenVQCR75HBd1UU0c48olx4l9N5AXIvPuw5g+yFsjzTLC1AfaTj3JVpDq4QluuU3ToD1/RiVwuBQQSLH9TqtYMS5uA20e1VEOwdczV55FeVgWV2jE1VlGyxExM4ggMPCyB4EcnFQqO16hYZpSMpB5T8B3MCPWiyS7lzGBMFzvkqp1d6/hUfbbGlF5ycizH/kemTsh/an8ur6Eur3wEJbU/65pvxBiRkDoHHk6veBoWOqaYGs66xxGvtNXNSIbFnHXzqX9taQJWSWlkDT+ep1jDub8THOm/8Wr7+bWX73pwC8oeVKbNnCmZEy0BSe++wmVsgZY1CdzY42CfIh5pq1xd11YKRzfkANk4wsBlEo6gbcSf4sPOP559al657UDNVJpVwnjWY
 E0FNIVUI
 lQ26+rkfy9GM/ssRebSe3mhH5Y+UkTHHL/LYnJEgZW7483VbB60GFEDXydydXl+yUzlOLOf3wpqyt+8m4qTMqp9xrYaEDbpodBCildBB8U0i59XLOE/GqLVyNSvMwiS51kfa2GxYofHOzcqZ5spAvmseE50CYroHetqQdLFq6/yz/hmqA72dSKsN+2aBKG8kDj4AtBXKmp9GRB/3+Qw1lvKg3xDYmhSx7chN7jCmsbxKX0fOFUujdnIlbY6HUIrFBCFRyFF0idh+8J14jKv7IYbMEK2MqUnBSEZdgt3GdjCgwuhG06DeDkVk/XraaPNQPfIzmVBUW4/MhBBWfV6lm1okwzbggQEOyQRVdSHz9m4FuLA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 01:00, Andrew Morton wrote:
> On Tue, 22 Sep 2026 16:35:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
>> The majority of architectures in the kernel defer page table freeing until
>> an RCU grace period has elapsed, this series converts all remaining
>> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
>> altogether.
>>
>> This is important because it enables safe lockless page table walking under
>> RCU alone.
> 
> Do we have reason to believe that anyone is seeing any effects from
> their arch's failure to rcu-free the page tables?
> 
> This sounds like a rather long-standing wart, yes?
> 
> The patchset is thinly reviewed and mm.git is bursting at the seams
> again.  I'll play wait-and-see on this series.
Do we want to nudge arch maintainers to review?

-- 
Cheers,

David

