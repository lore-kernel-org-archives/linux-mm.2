Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE5DC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0EB6B009B; Wed, 23 Sep 2026 09:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381D36B009D; Wed, 23 Sep 2026 09:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F716B009E; Wed, 23 Sep 2026 09:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3D066B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:43:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECA0F120788
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:43:43 +0000 (UTC)
X-FDA: 85245144726.13.5EEAEB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 502DF140005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:43:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odmxHHcp;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xDgTcRD17pMZUKjE+n6zU9uG96i5536rlsM5iR5TPE=;
	b=OIGkbFbx4ZSEFPFn7nqnfKqXrPLv9MgnYtUkUlForRWTWhfNpqZJy0QyEwQOUGiNZxpCTw
	UMlmxTJxeVleRvYxtcIx91I6NNagZVdyWO25YuY3kKSJbPvuew3b7bYQWzWh6uLPONp8NG
	AduMUI3Dz4fbp+FsBEzuispsnskHRzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171022;
	b=BYDPh0Z0aKHp2dZEtu3raYTm40cbdMnvnpyG1Cx5mU6lriozucNoNhtUlRfp+AbuZZr2hF
	20z0CV0xmXEZ9FUjwnvqLkHKFU13ndeBXSKkdvVVTgT0Gw+tysSWVkCrTb9yZojqoD84uI
	JSLsfpT+X8BxNjs5xkXaRyyvTPudFwI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odmxHHcp;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC4B2600AA;
	Wed, 23 Sep 2026 13:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A5C1F000FF;
	Wed, 23 Sep 2026 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171021;
	bh=6xDgTcRD17pMZUKjE+n6zU9uG96i5536rlsM5iR5TPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=odmxHHcphfJU/2dNQHFnLCZHx7qUsOTN2unPx/tuy1nXDSyLZmeYwR7/Rjr7jfT77
	 QnuCynM47lsKoqJC1y97i+U1JvZkZUSXp9zkXwbycdpb9XJ+pApXutz7lCcNFAJ3vm
	 vBWH4cHO+xn5wlHRsn6xzSZJ9/9k5KZaXvlcM22x8ZHXT/+6kz62RqW65s76Lppcuz
	 F5EUgyH8Kf2PVj50ygyL2QutGkc1XBv8xpCS/e6hY65wLgFvWhIpVu4lKscZxay6Tm
	 z5HHhYChWlwV8Hq1DsRMOKqUEfxwlsCQ4YbcBWu/p5tcGD9PmvWztotX9Xy/LdT1Kq
	 9Ab6m9tid+4dA==
Date: Wed, 23 Sep 2026 14:43:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <arPXb084Xbty9O4_@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
 <72d1548a-a4ee-4832-b2ab-4bc82f1933f8@kernel.org>
 <arOWZCeV8FrkAvhK@gremlin>
 <802d3999-95fe-4a09-89b4-d01b60f8e963@kernel.org>
 <arO7lSy71meks_sW@gremlin>
 <c62bbd96-d949-4c57-a3c9-ebec14744f35@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62bbd96-d949-4c57-a3c9-ebec14744f35@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 502DF140005
X-Stat-Signature: r5e9qpsxzxu4c6bhr3ich9hmnpsxrwbh
X-Rspam-User: 
X-HE-Tag: 1790171022-710032
X-HE-Meta: U2FsdGVkX1/VD4s0CbVwegR503A5XJhF97gXAhel1CO4kG0+Zgy9M9O4rWONy6xkWu6yKad4IXLw8B4OlfmuSeoCfiwgVSMOVvnjsKYy3Ru5/MHl5StF8lf7/y+4qNEVVrCyc8pUZtZppJ4brzdmeLQ73nFlh/tEZTL+twFC//3LsYpXHmwjXh3TzqtoAI/qvLV1kvnvvjQFwkAXgxf2driuy3MjXLoyiZwCJdJ1Rz0gAaGkhRj1rllbtZuHArOyIycBXUugsCfM5fKoDUgIt+PiZC8KjGHHhZV7lYpI5wFMVHcou/7JFuyiPD3rTdK/O9xhMJyMwUSFmqO0q1Tdzqoit4jkDsDUAB0s0p7ja0yeqwkmQ5ahKkrPoV3iMOArEIf+uoH/fvyqHdWBaMROw1H4Te3nWB9d7Q4DPsze4eha+eGhUHcRVEtZpIsyMeUenqj2fJzCck7XIrHUeHTdrsT/Gdyo/WoZRHaxtvP/IxwOLnxmRR8C1Y8zGFbHdyHqOZz0vbzOeGO30GkOK5Df9nkF8BG0+IyP2B8HN6mNwIg83qoQdGoKSXY3JxtQu3MXXxAhJu7ihRW/hVNTTSKVSSpCLYlqRgFzk4zRHIdj2BwHc8tpAdBnAasSOyiYF/Od8JQ0qxiepRmfN57bBylVU7CX3p7I7txNXl3A/zODrBBJXl9DtnO3dPXBfwoDfUvL4FoI5kyh6I2noLfCopL9h9iZMMm7+O5XHfBaDZWkHN3xnElyGHCyJ8l+MQ2RE5PZeEAU6fECJPAJXdP6WpE/z726r2uj6K4AiGULFerzXKNlDKJzA/e/vbTFAJV3mufG2Mq6S+4ZLy4FoFRWA5+gQi3lF5pXibHmDPRjqRVPqNV/soAnccH7Wwx5elW/FN8Nvs8nqz+rQc+Z4W8Jl0/TlsNjqbjdh5N1lvsjcD8J8loMl2UoffCxWHdqFhdVGYZl24qrG8kRas5g+T6VwtA
 AjZgKkVB
 g4hvbxm2sYPoLR1Pt2MXxuvJEH4AKz7Okj1G9OjWNgtuJbxTDPkF675rTXIU5HZN7BzAO/6W8aQfBJlCjVybch9jsyKenX7IM5wqSpH0RvNzmKum0IsfUozf1AsEo8W6ePCR2pjpjg3H/8E77cqYOpTtylP/vena2N8QFZW1u3DIjBpUghkp9ryx583xR68TUOsUpxD0enI9UBzItATaFHQS4ejgF0NojRXCNPxDIRuNq+O7OFWuSLh6IIIyTclKVzP3cPvU1UOYTYGGib7+BdYcuRToQdyaUBwcwAg9zQKmiUNJM0Xr/JOhmU1aZWgYQEf7GAyJO4TcjUzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:38:53PM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 13:48, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 23, 2026 at 11:13:36AM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/23/26 11:06, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> It is the final piece that makes that the case, so I think it's OK to allow
> >>> oneself a nice subject line? No? :)
> >>
> >> Just took me longer to figure out if I am missing something important.
> >>
> >> E.g.,
> >>
> >> 	"mm: remove unused RCU-unsafe user page table freeing"
> >>
> >> would have been clearer to me. Anyhow, just stumbled over it, I don't care too much.
> >
> > Compromise on:
> >
> > mm: now userland pgtable freeing is safe, remove unused bits
> >
> > ?
>
> Maybe something along those lines, yes
>
> 	mm: userland pgtable freeing is RCU-safe now, remove leftover bits

Ack OK.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

