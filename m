Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5B6C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA756B008C; Wed, 23 Sep 2026 05:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2A06B0093; Wed, 23 Sep 2026 05:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0CC6B0095; Wed, 23 Sep 2026 05:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 662FB6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:14:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7DF5C06FA
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:14:04 +0000 (UTC)
X-FDA: 85244465208.17.8FC23B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4F4140008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:14:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWMCgiXL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+j1lHJE5F3iMb8nSY99OQtjlVOCv/aNXLt1f/fnIwI=;
	b=HVEmMpzMJ/lg34txrsG/KYcO0gg3znYsRoYo4XVoE9NARbxs4MfVGDy2nebZNxuiz9rbsz
	MfQiPMe2nBk9NJ1ZomB3krG5hDE/CG/jWYxa/3UQb/yI9zMCuy3hIrXFAzfBrPaEN9i1CT
	NGPX0UiedvPrk2iytVdOJTvSb2GjZ18=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWMCgiXL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154842;
	b=X4tEmfsBJQLRp93UY9yQk7O/cEkckxrT3GTmM+As9urkWnXvEqUymCiRFV2izqv95LHF7h
	/2EmtXq/8Pl9iMdcbw7sgFfMDbd91Kjs7FyZlhrI4RkloontrvE0Rw3BjseYQrFhkRbaEy
	rqJ5+ZPG7nPdtHMbnsZnQoG5jpyTyGQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51138601F0;
	Wed, 23 Sep 2026 09:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DD41F000FF;
	Wed, 23 Sep 2026 09:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154842;
	bh=Z+j1lHJE5F3iMb8nSY99OQtjlVOCv/aNXLt1f/fnIwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kWMCgiXLIQ6wuVlwnnRx3lJKHDLxKLCH12IowjOX7efeQzZGOJawCaHUfqRK5YQRX
	 eyw5xVCFRsKuaXNkT2f1HZDd8aaiBjUul7jvkwjO6j1afG61xfht5mCCPSKKp4Dhe9
	 rzhiHvxgoP5JCx5uMMA6TbPPpBXNI0TvsBqy8ptvMlhuhl3LjdN19l8FOcusuHqGd6
	 W/Lu00eio/hX6O8BOK5kdqlsJZJnYqJ8DQtyzzxsImYdJDJx13pZ4NSi9WHt1anikw
	 dlxfFEX5t8FcpmSHMomNE+o4ZWePsDJ5WRA6GO3q2+DvMeaV13VT0Jhtfi25HVJqjf
	 K7utRZ1UWwiog==
Message-ID: <802d3999-95fe-4a09-89b4-d01b60f8e963@kernel.org>
Date: Wed, 23 Sep 2026 11:13:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] mm: make userland page table freeing RCU-safe
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
 <72d1548a-a4ee-4832-b2ab-4bc82f1933f8@kernel.org> <arOWZCeV8FrkAvhK@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arOWZCeV8FrkAvhK@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e3rdmznaopocr4nsmg617gyf1hxb11fz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4F4140008
X-HE-Tag: 1790154842-439394
X-HE-Meta: U2FsdGVkX1/vS+BD55CabXXIkPP/b/CvVkJxYsN1Z5bYeCivUZ/9YvE2fwyiNcTa8xLnNJxQii2WAEguWUPTWEbZ2rx2t7Lz9Cn1I5zRoyj1p+8OBjRdRvxFb++shBxDE0BgnZfGPCb9CTgvik17TiYUaQx6Ko6wpUnD8lHSJylay2JGE1VN+RejfhVZOkAFEWIENZgJMWJ9J6nYuirfJGfAlAzAU//5yx8/4VCXuDk8F+V5zY4V3T5jfPPG24CUVyql2iuUF2CvCdsSAlvlg5oE9Ajny8owML55wDt1EJAb/mi7y5HAXXbcV8NCFWEIIlVxSXVUzQ+EsYsdG5akB1tyJQ5TZMGk1HHxg2ZzPos5i+tr9HogBqW+EsSPILFnNwU3PaZ4SNrXFPfNKQypj1IauMkKrUXMomovNRSGkuSIvssvpH/F4WMvrRlCK+suO1r3V+gVOthjkc4cQ1y9jGJpgn2WaVrVn/9Tc3SWM5bbmC7L2xRD4Fw2Yf/USnsKWVeJMBIncMuBmipfh2EwdhPk0YbXFGZUbL36oye9sgFR+mzcvyO2Wn0SeoPJKM44u/34r6qL9bftsKTs5SEgAhX7tpIICnThJ07d+0Y6gkS/i4YVf4yBXl1O+SVzKbsRuoRjE2JSWoiyefAJHmt7kiYAVzOdJ09FvvoWO8rdpuCUUF5eIEr7F4DdYPe6BaPhVwdvBL0dn3XsBngVfCer+i6eUVpYMfZeD9sku9Jo292p8nLIt4baDWmxhoP3CnKalosSK+N4w6SnfXMDivwOhtfQQwYmvRffhPJ3+IC0CTbkEDYQHpbibALoMZfrHVvpO5UPD6h06fWHO8rDRTqCchs34gAHg/WooWrv0D5ZeFepzVoEgx8bq4Cu2ZZ92+Il4gbtQt9vn9P3CipcYyKO5i5xktYX8CAY5szw10sTUAJ435OAP3t0ZVhBzlBXULvCwuHda8yUcT6qrHlEr/a
 Yj7F9KDz
 Lmvwybk0H/xMap6INhJRp7W07JnZOCoR6M3pI4VjkLjF4A/5uWU0fnEr7d6RVzlJ/A9VH7/1U3uzcdFRFEzcyN4t4h7IHpyMnF9+sti8nxnNcLOWOtIGrGWGQGNhdhI5gPZh2g18biaddyHhCGM/za1w0iwYE5HGA/u3srreoH4CDlH0gUVty17mn25D56rslLSEgaINfIHGrtcBLyV4uFddCLN412M9Y/7kK0ldXGprCaVLbnCd1GrHpMZEgBT2bFuLCYk9Hwt0FfC7afqrgZNqxNDPY3mkuHWEHo880Wq+ecR5ri72NC1cXxAzlgd8Z2meYA006KBmuJEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 11:06, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 23, 2026 at 11:04:17AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
>>
>> The patch subject confused me at first: that's not what the patch is doing, no?
>> Previous patches did that, and now you're just removing the leftovers?
>>
>> Maybe I'm missing something that this patch does along the lines of teaching the
>> code to be RCU-safe.
> 
> It is the final piece that makes that the case, so I think it's OK to allow
> oneself a nice subject line? No? :)

Just took me longer to figure out if I am missing something important.

E.g.,

	"mm: remove unused RCU-unsafe user page table freeing"

would have been clearer to me. Anyhow, just stumbled over it, I don't care too much.

-- 
Cheers,

David

