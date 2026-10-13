Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA86CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8B96B0092; Tue, 13 Oct 2026 07:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B296B0095; Tue, 13 Oct 2026 07:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B786B0096; Tue, 13 Oct 2026 07:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 650BE6B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:43:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1288C0B3A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:43:54 +0000 (UTC)
X-FDA: 85317418788.20.869CE8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 38E0C20007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:43:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JvOEi1vy;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791891833;
	b=Rv++XVjQ0wSQfplyo7cIemn9ygbZQX35P0yZqDCooBHtgjpfBuH4BgXr+a9fhm6dwDgQ2m
	AqISXYP8rC5BQk1RdZ1PR23eKByigIOYH0VRlUZ+nRNtA6xWMXga5gChPH5GdCKQzAWl9X
	fNVE82SrJZsnpvtplZPhkYfTmQFJa+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JvOEi1vy;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791891833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3kwk859qFodmpxj3OxHRi9StcyZ/IRrGX/kgBYEpD4=;
	b=CLE5LxbRjT4RROt6I+Sv+bqz21PBIfpPSiUXzypCU9wZhCkv02s6eBPFSdzJxKTNwyT6h1
	xlVQA4QVddZw5v9iF5Ek/4YFLfbjaA5h6zUme59OoYGjRgv7al/7OC1YnkVVGBqI0l7rVu
	VMleiLYZe+cKiH61xHtsWrqdQOjV4UI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9616141A75;
	Tue, 13 Oct 2026 11:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ACB1F000FF;
	Tue, 13 Oct 2026 11:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891831;
	bh=S3kwk859qFodmpxj3OxHRi9StcyZ/IRrGX/kgBYEpD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JvOEi1vyoPSPHIK+3e1cFSGk5Nq5aIKf+aPMRBqWK+jdkr+GJ34ZVhlK6KFh95ok4
	 LFLkrLVzES/VjnqmInEE0Ue+CxRK2fSBE6/QrhXBRNAYjd1RCgj1C7FcX3LsnkXKK/
	 FcPKD5CYRd5utm0PX1a/JlzYfAu81YBwmUTmdu2jSQfZJQIWOLsgxo2IqY17WGdyK/
	 VwX9jgqE+oS/qTJ+U+MBVqNS1wFKQ3L5PC8a3V+m0KpECoP3Lv5uQdi+xwTGUWhyVU
	 JXNNX9WvbPCWhJAa1Kpla3Kp/XCy1sGiLGPzH2fxY+k3JRj8YHefM/4npCF3FyIv1o
	 RUlJ/KsSCGPhA==
Date: Tue, 13 Oct 2026 12:43:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Message-ID: <as4ZGTa7tHwVwv-1@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
 <e65264f1-52dd-4ed4-a647-87e7a1778b6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65264f1-52dd-4ed4-a647-87e7a1778b6b@kernel.org>
X-Stat-Signature: krsrxtpckfwy1hdy7ym8qrhm3rft1sk7
X-Rspamd-Queue-Id: 38E0C20007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791891833-196224
X-HE-Meta: U2FsdGVkX1/MdE6P+qirNlAfXaskOLz2NjlDNcntaFkrVTLE2BBGdM44lfmHgaMwuQhmMzy/21VBhsJZXpcxv6sGtQk3n1cvcF2WjeSgUrsH/matAwfjXLoa/IcGl0Ehp99JmTtaguGcJwNmQ7/H7SkQ3leBeCAiHkb0C0pt2Hy7kBj3219HdQhu89nKaHi8lJz4vUAnuUaSBoQoV90j7VyBcJ/9NYkty2RaUkK67hWMgo3m5MQFNhwvP2Xx6sRdv3xQG3Ez7yTJdrFeYiqojse/EIunv/bVegoNY96GBxGDIQlnedHaAWob1FgInDjkxSLRs0IaVa9KRZOtZeJ/E/y0SBpnY4j63EgcIaspYmXkLWcQawhF3xoLCrJDoTCiGY+499Xghn4xzONBrvF9HjGU0KOJhcezyU0xLDl6WCAe0eJ3NyqUPDcafUffxTbRfkZxg6HEKQk7TYyNu4betdGrXxNPyEOyJSBl/7M7qUa+Ia8E/4fSf/tOPJe39AmwIbbQl0weFvgR60mgA4h3heLSOr4K17eYSWSJMeF4M0nJpF56E0T1H2Of+5XbjrF2Mt8bOHL8emiE++t3HO7UQ9zlrFY5goINU6tTGDS7zKXtFGvf6khSk0sHjvusNCxxhnJc8KckU2Ca5RBNOJ05AOVdlKYObnaejSCIo/PF/E8F4ZW19xrQaxctyqLppI3+RxqtbLHpr6Qf2gW4o8nLCY0sm4b4d+nPDaUYtJoX9GVwJ9hwDq7KasjryyJXejMvUhl9rGVxxFsFMuZhyekrXAJYYqJvmT2/2kTSAuyalXNWK/AhajCs5sf6T/e2JzAOUV6X6oMOoyocxx1cpTZ0uO3vBz1dXRcTmVihxfxnaaDibV58T6F6SvDt6jYFv9n6nHW9md9XU1chgrEA5KHOf0I1LSIpkB7wKYmgJLEMXurlQ249M8eOHvlc9dvXxD6hVG+z8wrHqWp12u9rAl1
 bVLNHDBx
 zpTqTg+EiEogoFIoiiNnjF7uQyHZZ5f3uADUzayBfLpbp2NoywcWz1Nl0oaQnBhaY4kwGJPZr2ifsjXUT9Uni38CcaDQKpsTJkMKcDkzDcw4mxLYF0tqYc1UTLOZay7Sz+MC/NGCsdDiQNpJ8VhZAN1nJC8PUKbs1ODOkoq61y9rfaYm8tDwQ68Sg0sJ0QX9925Ftx0/83F3LAEucpB1uU4gQeBAsSu5xC5599Y1u8E8pLFz6c0aJYQSdvQX/T6DieoDedCxwi34TpNkw9BHYx/GrQfN1Cs904cjzeTfUsQV71q1kHKkH7r9QmxW9ZHAzyA8qnl+9Kn+CvBYg7skKqPEtXfjebapZRJxpfZEnfQUS4cHjIJC0yz6ueSfw5NM1t7EDTotAKfwVNw29QxlXC5wpYEzEO8LxyTEtxgdGttOBM6wB8PYFl7OxnWHePML1Y4n9LFIJzzi/Q9ExuUBgMUQ8BGsCVVCHh1/KV676Ls4aKgt9MHlmwyKu7ycvf3rFigQUJYSUHi3emuIBmTilbusd6cAHA83RmT0Pec5ktM84g8CpK+ymXXW+hLF4eyMpJLOnquCKMaJbezajK1woWACVIahFbuqMlMgTw1ZdSTyC+a3k83fXhfcP///Q/BxpQja//LLMIHT62qgHVyzzxlbA+sUT988jnpcVC8eDPQdwQPQsc99k4u1311m3aXT4ElPSdb3ooEA4+RYYxqJQ6xwVJCj7i/yJuAWxlMc02S2ZMtUa3/zCr3qjWzNeR6G2BpbkaUk+TTSM/adsxEYN7nUhttUHz7qX++N3CbZLb5R6N6DyXNDI8lnP6xHkZn1HLxmKqTEV0iGRZskANvlJwR8vXhh2hEEOyqlbmFhymf7z+1JzLZNImq4kwpdtjssY8ZMqHOooNkNOMXhOsj+USGfYVZkKLLMli4pDoUGf7JrRSrhZL9bwWSJ3dj/Hzx2fP5NGIzJ+lh21T3FRyqcK1hnnvxiE
 nI/MpXGZ
 MTCvja1yvxJ3mHCTg6h0CX4zMi+rx9wHmLTgT0ZlfkoeU76Yv+Il5ywQFtuJ6NYgbBmWAL/psUIMZECxHta1cZHDwtwiYYvKdTQPNMkPiarbKAJFHU0dAWHZGGHJd4tXeuEmGWKr0BOrkTdyEv18cvq+3HYMJVVy6LiZDg18pY2FXX2jVB0qmY1R7c53j6yQHvII4GvNM+tnmF1SXzcy8ygQEy4LkimqdqXjyYRaQnJIetS35GhulOu8BiuXiTAnyyFKM+5ljaVZtlK/EVQ+oZ2+AoiEg30KD89N3J+pWrU9MtKg5AjwJOqIeIiwooLbpK7v8kWtAoO3wokYLYzfSelOSYPN9JYe82jqMzIsGzFAQSO1C9sABqPhwzVrA5nBZuaY8PS94gV/13qT8hQ3pmApjimT4ojvQQ9D72045/iDOonndXDNlPjMWIiAEAPGhdqC8OmRLDtLehWiCjGHwhfFgkuKsQelMZx5Tha6LuUtNjy4EmKfNnSCizixzO0xxZVCOc4+bDhx+jcb1KKPcQwNapyMx9Rh3pmt/n9/XpBLBiu0gveNVfSFVhoBrGQHcNpRHCsSFxSH78meo+zzfo1Z24g88Gs7hmhiLg+gKLNi7nDv/aBOquthLUMU9+STMwPa4SLnBEMwgBA5FQGY4upywR5g9sCAbx0hyPUGxVUeAYKlKRbu3gDbqSN/SsmFKmJubjzOCrvzOLOnW2LobC30qDUbpJNprObBnq5stQ4rhVeSRK8cIdozjoXRPCb9lD0WNRbjbypxQ0e1MyYD+otpejdyexyMVwTUZE6hro8jjAXS2Kf9TnwCyU/I97eKwxbmWSb9gdTzD9OZycpbHGckzHwHwWH8ttDyE7xK6uk4UV1FYCNVtQz3spjDscw/rHPm+bn0gekjlD1vwyH3Du18TdB2SWXrCLN3VQj7y++dwEvWHaWn9pg+8N7or3CiLLy/guj4Kzm1eRGvILks6USNrRZoU
 eaoR3/sn
 GpN4RJXB4NrnjdcFTrQ590EFwEzWvOvPW5dP+yeoPjB+NN/jFtbydjplb7Yv4v/JtpkErjNx2vPU9Sjz5Z993nPa+pznw/Wz6jZL99BtHtlooWryMHZE/HVQCP8NazM05NPHv+P1t2RLCzlBFB1jCt+HOBWgm+qg7M0uRmohly4s2jQmlY3k+YyH8vFFvzWJ7XbQDugZmxFPCLLlVTGpHde6KpJp4TCrHUX6jh8XZ5VCYRtj8eSPsUfivEZRq8TEoeE7bV4PL8FK8OTkH9jzM5OWmbxNYI7txsRdzYIuaMuH3JtR91cmjIRA+IAgAo0gkyOM21LAsv88WJtPnERfLUMtV8aBDOhZY49AFINUbagVlSuzBlicW5qPymiCHTn5Eqo/4E9RsyIleKAgJ0t9VRsHJedNlotDcphDjlo6gPCODiqWSIlHs6BqCJdwe2ReVQlUTG0rWKm51xVjcMw+NSiyKc2o8M1Dx6stPtxAsyFfpLJjARku+/+4ZXOlOuOy7S865qbtEQq9BgPfgpQjYT8o87OoxifzsfsuQK5wOniWiGj6ZlYh306dHNquYE60LfRS2vZl3sPJq29LVHk1xTTZ77tIvGMMNtjnYybXQB3GMYLgNK35xh1e/4fS1Fc7ZmCJ1nJbuzGNf0/feGgi2iDgStPYzSoxvvPDsVpshg238rWLxP6UdIS/ABWGl9ub9fI8U2ZPpuhp5WNL946RJyLk9xPsmfkHBSaLuUu0eg9gUDbBeWkb7BC6raFEr783bqqEK+xuGcwpS3EAJmj0OnfofEZSW7QA9PTRe6CmM4yG9C1/aTnwW23WbdIgKchEv45FKAGNsPqSVw7YcTAKI+Dfi3LuhWOgcyoe0LCl5oRgMj/i7L8rAhGTSFfe9GsOctcLzkBn7d7dx+A6TTZOpyX+HcPmZKoOMFlPmTyDRISJuSM8g0G5m/gkzE8WgyZXKsCMTzMSWIevWPISKoZC4B6p5hlAS
 2Rue6vSb
 O1T8jbzIuDKqlkFwr5QOrVdTTuXaJ+sT45xF1VZRSYA5NQqVUCp03+MtETFb7SlKDQQyg/Kg2c3C+dynIX+vj9E/2u9HytS+SWBq7xale4wGTbuTaAiwupQyexvzvJ0+62KGZUwKhLWpwkHdhuwN9D3Kx8ETcIxP2KMArpD1H/pNZPwjgwkaxs7Ja0hOBWf4a5VRMzG0jz09PENcYHkGofW+o2Zam471pt9zQWAajTd4egJVOWQGOwHg0Tvh5RnPC/r7Gc4aAxIdRzI+NX2KJQNeTmz1CdbUcIxThYqwa2hBkKoSQqi2FmPYZgHi2jqQK5E9hKl4wB59dArSLPM4GZbQUDyqnlZgNLKuNGcyP+GIJCrcL3MQS4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:49:11PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 624f37975e12..ed66a90e0031 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
> >  	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
> >  			       VMA_HUGETLB_BIT))
> >  		return false;
> > -	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
> > -		return false;
> > -	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
> > +	if (!vma_flags_is_mm_backed(&vma_flags))
> >  		return false;
>
> Same here, it's hard for me to tell my brain that "permanently lazyfree pages
> are not backed by core-mm".

Yeah :) 'mm backed' is definitely too broad for this.

Will reinstate the explicit droppable check in v6.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

