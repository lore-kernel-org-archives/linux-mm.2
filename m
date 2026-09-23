Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8909C98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896FE6B0088; Wed, 23 Sep 2026 05:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820D36B008A; Wed, 23 Sep 2026 05:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1E26B008C; Wed, 23 Sep 2026 05:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 428036B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:39:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC1BB1206DC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:39:52 +0000 (UTC)
X-FDA: 85244530224.22.0FC5AED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0159B40007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:39:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYr7TIgW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790156391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ky9c7fQZ/1RFu7l1ztUmuvVnX2EIpcy6aLCf8pDHQ2o=;
	b=asC6uoV2xvbwgDEcY0mwIuyKnfVS+/41mKnwVyMirNPCGCvRRCGoKQJRvWmOwCcxnJmf/K
	ZOOdFPgdMb9U9F0QBHlP5+Y8Fr1B8XOXKQYhjaQDldLI6Rqg/nSpOx++MlLu2e4eb4M1fE
	0EFZXUN/t315Tx0MqA3xwQNc4vXjSOo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYr7TIgW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790156391;
	b=wzvT1r5CYe3r+1JNPFkwpPvBeQAnL8q/kUY8AHSWGvLvyWqydUNIHKVwzEtaIvElBEumgE
	eud3nkhdzv+pRtb1yoLiTx902JvoaAQ7Bb6Wb6gkaYtydW+7QsRov9NmF6NcfFnSVz5yry
	o78T3U5EwbOhAChyeHY+hdfBYnJuvcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7167600AA;
	Wed, 23 Sep 2026 09:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0771F000FF;
	Wed, 23 Sep 2026 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790156389;
	bh=Ky9c7fQZ/1RFu7l1ztUmuvVnX2EIpcy6aLCf8pDHQ2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KYr7TIgWfrXtSFuYVtPX6VTaibKpRDQE0xLEscffhdhRMZQB3sVyojKDpb3pvYX9a
	 qfvIpI/SixGIFQ7jPSlfRpTXqHoSQw3e5NGtYoZ0sYH3oJ+xqsBI0jpKsys1S/JnYy
	 IvQ5WEYwt2sHjNSrspaH0UnfT4l3XktBqmTgdQkVCWl9XgouOK5HxvYe5u055yDxRe
	 RgCQcXcWZ6Lv0CUhhbVrDCdmnM1DAd3Ix6pJv/92RXmA/nzdCeEya6awHMsihGp3fa
	 8OzKYVp4CPN2ar8c2+eqMrSU+ghKOu7oofCmSqVM5mgyS2NoW6ndtBPvRSr07sUjNj
	 CvviJRLhMRoaQ==
Message-ID: <300f92ef-1526-44d9-a01f-e9b8f3fc0cd1@kernel.org>
Date: Wed, 23 Sep 2026 11:39:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
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
 Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>,
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
 <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org> <arOVbT5B1FOMe1wb@gremlin>
 <77db2f8f-dfc2-49c6-82f6-8e6c4f7c1fd0@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <77db2f8f-dfc2-49c6-82f6-8e6c4f7c1fd0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0159B40007
X-Rspam-User: 
X-Stat-Signature: cr6atxhp94gj15dwxztxmd4g1wpf6jqu
X-HE-Tag: 1790156390-519178
X-HE-Meta: U2FsdGVkX193bv61VpWHiSgMIxZjM0ucukWsYYR9uSJiJe1PVQO8K2TeEs/VVYvd59fhO5Gpa6MxNHjqLLPbL+2rm8FAgbjhEyGQ75D3+/0TP4TPnxUdnyeXbwOpqHcPqRbnVZAVysurEv4ygQpBeWa3uTLohM5NUGJDs1DKV4I+snHtzjtZloR5SHdfbrnRTQujBKsLiErVJJbIliNnSga7A2ihPPRNqfLfQWXvpPMeGVMymW5M95rwHsqYe0xBKcUJ+w16WuhFzBfpTgaGXgAN3R1guo5vb9c7mRHJ6Yyan8ZF2pipp6ADfFNj7osQoIFitPVotc5Rh35kEQADSehyr4o4QxvYTR4a+JcRaQ+yCzVdFx/qVCQWKnFjVx+t3jjEjtNVPsR7jY9SXwMsrxz2XbBPzUZpgXTLsrC23IRSuna1hmrz/ei0NcchGjQtggum8G0y6zDO/ywvgn9WazsJzwVDhObpKV+tm/E5W8PrxF42apLKZz1lVeE8Ezrce8T5uPA7W88uFImMwHod9kjnrdt0ZdOnp3/Ms6ue+BGcrmD4uwrfQSybTll70lbouv+yv8D7iV/oKv/KIRcDk6u7WBPrCs7fdDoCa21NfE0ps6tvXzasW5uqlIbg1Zg8n2894ouzHK9S7Sh1f5z7iVHJo5SK6A/WifwilLVa/NKkf6c+4D7Q2y+su39iqhHHjPNysW+W/GZvFRIua5Spqq/j7rPUICxmBamVi3HpIYWWHHxI08PLFYEGpFgbtMOmCIMJzYxbEg7Z+5azJbAm9sDVcoGkMutCQ44zCQmCm7y8wameAVOFqpPhjX9bM0ms5nIFizypY/Ye/zQZ47VwWzuVGFwc/Ao042H+YoG8ujnfhoaC/uK5odcjx4E3jzAD3BERZZ87NxIhi/C4hHR4+qZHJtr1V+PoBiFV3Pj3RPR0vUn+4ign6+sHymtHhXrNjOoKiUKWpZ6FTUwhtrS
 Gh82Q38r
 IWTqhNTm3g5T8glWI4MIfhiN7aZwnYp2Sf3C8nVDn8X7gLj5o1j9Q7EUa9s1V+SD/x4VRKTZ7NmSKxyGrRAouM/0mMq9XIrhXw5BSEEwzWksk0kpZdEHmzRvtm4+CO2L1TPzS8dDQ7L2VkJJ0B/xdb3DTzVzxSvLtWUJQj+yP96eqFPRpRJrg1Z2aAgDijKePqCVeeZvSjzybYhqqt9mFm918w4OQDr4vS4lNI7zAxU3NMGXjL5ye++LUQmexpe0FU6wAblquDc7ktiPknkj+0K5SIfRWxl9YMJkNe26lMvLX/r2eoPlSPhO/K6Nxb+8+BaHbNArvHAHBqrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 11:15, David Hildenbrand (Arm) wrote:
> On 9/23/26 11:04, Lorenzo Stoakes (ARM) wrote:
>> On Wed, Sep 23, 2026 at 10:45:33AM +0200, David Hildenbrand (Arm) wrote:
>>> On 9/23/26 01:00, Andrew Morton wrote:
>>>>
>>>>
>>>> Do we have reason to believe that anyone is seeing any effects from
>>>> their arch's failure to rcu-free the page tables?
>>>>
>>>> This sounds like a rather long-standing wart, yes?
>>>>
>>>> The patchset is thinly reviewed and mm.git is bursting at the seams
>>>> again.  I'll play wait-and-see on this series.
>>> Do we want to nudge arch maintainers to review?
>> 
>> (Just to note that I replied separately, 'thinly reviewed' is incorrect, it's
>> been in -next for weeks and the whole thing was reviewed by Kiryl.)
> 
> Ack.
> 
>> 
>> The only places where that would be useful is m68k motorola, sparc32.
>> 
>> But in any case it has been heavily tested including on every single arch
>> listed with stress testing performed (I think I cover that in the cover
>> letter).
>> 
>> The changes are not controversial so I don't think that's a blocker, but
>> it'd be nice?
> 
> I doubt we'll ever get sparc32 reviews :)
> 
> I'd definitely appreciate some review on the arch bits from arch maintainers,
> but if they don't reply within the next weeks I wouldn't wait on that.

Indeed, for minor arches like this the lack of review (it would be a whole
cycle by the merge window) shouldn't be a blocker for important tree-wide
progress.

