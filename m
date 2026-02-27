Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08667FD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A7B6B0005; Fri, 27 Feb 2026 14:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D83D6B0088; Fri, 27 Feb 2026 14:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6E16B008A; Fri, 27 Feb 2026 14:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1500D6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:42:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C9C9BBB35
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:42:13 +0000 (UTC)
X-FDA: 84491257746.08.9C0BDC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C2FD180004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:42:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NRJvXF3f;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLjmZvowIH85J0FwSVwOMBfeWcFPuRaToy5uLaDzfa4=;
	b=S2h8W5YdvTNwmMSkVwOCZVVTEf1CsOfBn+dSvqpmfUNWclyMEku73Jj07yGEIS0pt2I8Bc
	57dwAyP1XyNr5F8pF9n9TWJMfLki9RcNj6Y3n5WvOIRWfkwagIUSHVoCA/P4ciSMO7iS2Q
	Mq4ScXqkai4Vk8B781GPAWhse6SlTA8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NRJvXF3f;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221331; a=rsa-sha256;
	cv=none;
	b=xQ3+Br73Ky2Oivp1xTlMeTEM+vkZtJrWfZaMBA4bMAtaSWfcXOpAvsjKxrfEWWgaQCgCPQ
	lRSwv90ugIg7Y/llPgVYtlnpvZI20al5Np46myds4uNOgcN4pAjJ+dUOAceB4YOeq2dFaK
	sC9tuTzUwVoHFSin96hN9kcHT6ta8c4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D0F441FE;
	Fri, 27 Feb 2026 19:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A62C19421;
	Fri, 27 Feb 2026 19:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221329;
	bh=qix5xWTZDms/A62vFZUqjLyjGKPSA6VqMVFDJq6TWjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NRJvXF3fbr382lsZe850hbuq9j2JDOKV2XZPmh+z/rg6YPJmsZJ0SVFAT9XEUXPkc
	 pOXr0I9yUmoutFoqqNA2ucqYDU/wdEGiKNP2owFrRl8s2rNtFR40MafvGtb60kyBA+
	 840cibMCM3XKWjfw+XGo2sdfV9rNrTjo3Q1QzLLXyDx7upGDirSvn5LqSiAnCLffDe
	 3pw/54OCYfvwLR38FAIfiqkwgSprW+Z10tr4sP60IbptX8QkIH0GxoX3hkZxmsUo3i
	 X41ngQO5Z2WYS8My+sW8C1KEtjCaVh8m3TYYPNZbdEyC/2p1ohHKmvE2mxoI0piXiu
	 pGLCAQqEJNz7A==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0F16FF40068;
	Fri, 27 Feb 2026 14:42:08 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 27 Feb 2026 14:42:08 -0500
X-ME-Sender: <xms:j_OhaZ7T8xofTbSV_wxzruxN-nXeWOHmR9ZUD1N8fdum7Ka9GtazMQ>
    <xme:j_OhaanINzpVNXlZDJYg638MRgHKQ46XBK26arkcwRiDKPsDRV2RWCU4v7MgZ3jwX
    _VssFV-r2qgouJQB_7JssLJfMR2vG6D0MleT2NV1wp59l5i4lkiVAk>
X-ME-Received: <xmr:j_OhabhTJmjGZzRPAgdx-N67m3ARSYHeGQPgi0a6vxPrAPS9vrUeatHTMZkmKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:kPOhafnUoUDPlFCZDk2Q6YSXDMzCj3KxenrCgMhAaoYIYmX6Qrgxvw>
    <xmx:kPOhaSqBA9KT8bWFyqwoAM-s_hzFRN_uj898EqG-swi9NYuIvCnGjg>
    <xmx:kPOhaYNCdJ1cD37tHA4NIBWRC7GtH4Iy1Sg8pe6g-XyC34N49zVwYg>
    <xmx:kPOhaUJcDtBW1voctED0w0hVn5SxnOGPTX87wunEpNeAe432yBjBzQ>
    <xmx:kPOhaf1qJWEWG-0cmHQxVXVAKA_1czZ0-hfziyUmT2Cem0dtfjvqENGh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:42:05 -0500 (EST)
Date: Fri, 27 Feb 2026 19:42:01 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv7 00/17] mm: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <aaHzKykadJwN7tF1@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C2FD180004
X-Rspamd-Server: rspam08
X-Stat-Signature: ggg8xhherymq6tzf3gohsn8gduardinc
X-HE-Tag: 1772221331-519667
X-HE-Meta: U2FsdGVkX18X5TVh0wPrvMRgGpTqOzkX55Ekl02dztuQM7GLBYm/H6tJXCovY+7TS/HIHGF7NodAhQj2xAoOMjQ/F3tOB/LxYT9fQlzHF8E0Se2K+dUHUJUrX6MA/WeFxlIoTHLOzkqLF4wIFsJM1jG6xcuRejxbgDqrfhG0OWYyuplhh5KW/CbtBUkRc2jx0oUZnLcakXXp3+dvGwmivvvRrJ6BFKRx8Jmeo2JnXOYu1VDap1/56EriV/62gl9lxUeSTGrlvdmO+YmPxcO0l1VFNGuAJoGJQf4oyyUmEH4Ldm9A0nEdy3FNlTEDaSFwKh3BrhVqgPbL6x4LnkIYVH1/r+A3NwXc++Y2kf4u4TbtnF0NX1RcZ2X52wmSDYMagozPm09WWRBXH+52nrpq0p0shSe3no55yJb3E2ne/prGkBcqlSThf/Tu2ncpKUQw46ibM+EkPxbiibuaidU2xplhh/BYCGDT4N7FrDIghImYFVQMpMo2g4EcuNWatGhWUN39Khs3/H3FSVa7rnzjlaZXCOJ5ho5dJmAKDki+nZDdB2FZQNuMUyqYHDPZx0KosEii0EZWN61Xdwkp2cfP5Qan3w57VmMBjQbYwmNp09QNIb8V+VPKVy3eTr+eQ6wYKsjpVp90CO/5W9DIezvSor+I3MXsbbLxqZQOtv4vfCyVh3TbqGhBAnhMZ3TUe/MEZu8lbJOB8f1jUCEQUFvhJ2h0LvQZU+PDJyF/Ak9kSsxzX638LTvNb50lsAi5n/TEobIUs1SCHZRQWKirL+HzFYHzjxEsX6nWeJOwjIX170AgJR+XZsp9iqPcqtr+LVfREFGdjK5U37AIMMTE3VjZwu5sosJA+WjgR00NvI31aVMZ+NMFuMxzafW/lS/P5D3BZyyw/6xHJv/XgO+gH6KYdF/9J3jhZD7jW/82KcWFxUrGubCEEzWSPxnUK4rm47D77bndgK22AktmOjVn4Ok
 rWhK1nUc
 4Dmi1t5Y8CEFJQY/Tmu4831SE8WdDCbOC2ZaaUE6UGjRNTkWSV3eP1ErZwuRQnKN6Nm0E09sm6iXgYV7xr27wvTGfX76X3MfVtfXQUhuvLNjDX4+3ucpuKj3i7kM22sR1veLniFj6R74kTAGOMB17kZNCZTni+vHieGJwAuizUD9ybKlrc0s3u+W49Icq86IHDiuSmFEgOsyYKbZdcr9WIajM2fVmTbG/bGiJ7Zp4r6yU9JCrbsLnH0ydPEhtJcnyidCakWca+ibPAuBr2g0O726DZRNILRdGgR1OTM4i8MnYCaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've screwed up threading in the submission, please ignore.
I will resend properly.

Sorry for this mess. I should have figured out mail by now :/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

