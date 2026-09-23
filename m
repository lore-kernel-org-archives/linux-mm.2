Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B64C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514076B0096; Wed, 23 Sep 2026 04:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C46D6B0098; Wed, 23 Sep 2026 04:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B35D6B0099; Wed, 23 Sep 2026 04:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 135586B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:54:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96BB81C342E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:54:42 +0000 (UTC)
X-FDA: 85244416404.15.BFD8CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C7ACE1A0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:54:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6JGCywJ;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfm+dgT5lNMdwvcoEsUCo1RatnytaF+7FQ0IE0uMup8=;
	b=UReJgmcKn/txdpQ92+5SmaKqpRBtQFMmd1xGJyjvlXpuqDVSmGRFlYPjnDFa8UjwVX/foj
	4bJCgMPxe5p3WHxhR8zJxWkQIK218H/4LYWlQN1oyqer6HOAvJ95Z4mTKWmW7/G/KH5FTR
	F6z1CPv9hB8OzPzZWwma5qsJx+cJJLA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6JGCywJ;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153680;
	b=07Rk5J4XAi+dk6dm2soX47Fm8zIE74IYSb/Y+Yy59LExyXGcGiC6+EUrrgxOP7Taf57V4N
	8n4n/LTsbfeZA7E7DMUcqeRChclszEFOO9Agxituf8JLKCOPLsz2xNhD//ZNYRPXuFqvLM
	2vsW5/JIkyNAQ4qlqPGWToGMn5NkSyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4F8B43698;
	Wed, 23 Sep 2026 08:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4BE1F000FF;
	Wed, 23 Sep 2026 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153679;
	bh=mfm+dgT5lNMdwvcoEsUCo1RatnytaF+7FQ0IE0uMup8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e6JGCywJTcC9yMcSrzIixlrJgX8t5PhsTA6gwRUYjo2Rg9Npys6OSwJnM5LDnfDEy
	 u20Tu9Pa0QyHyAfTx2ghB9J6QP6gBr7EWbZSjEiIrJOl2CCCILU7j46EcI407+b3G4
	 JbplyhQQmC8k8Zcc7ceIRcIj+e47k7MI6571ZOr6OU5vJGqRgnheYl4mX81DH9D74x
	 K5+g7m/nU0Qqxmm6i11YWDVVuq8qJUznAnAl7zgN5WMG00TrgLu8BDRDA/ps23/+iE
	 rfbVBTyqQij0mFvDHjN9Z4Vy8VJvV/Rfswxrcl25y5XhPcf3HoVl/l6+cj4FDRLumn
	 kUpp72cLS9TEg==
Message-ID: <76b2f611-b74c-4d6d-b166-491e1cfcb9a5@kernel.org>
Date: Wed, 23 Sep 2026 10:54:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>,
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7ACE1A0002
X-Stat-Signature: gcwa3isss5qch7mfgdsxczs9upnw9c36
X-HE-Tag: 1790153680-843523
X-HE-Meta: U2FsdGVkX193ZNCVgSTNB9gKtIAeTopdmUp7hVKoT2CTZiEKpB6zYMikRHH4A774NbUQB4Dm5AyiGGte5zdd0idckOkwvD3RZZ8RJZ3XenvAuD3GF0JXmnZzuMpzv1yenHsguyFvIO+CCLsEKRgnRC3K3DqdEDx1zGVQMzmNq2FukydLZ+e5TypVU40t1DlgloetnRoaW7uMpouWaBsqrIAeM8A27yBC0vYnjy/FcXFqkA9L2NxRdkXCg/OgvDdFNBjLxnZGm57EiZzQasZanGQqbvqBuqWYkwT5Co1AZBGBg7+aqLJwbJLxoyih13dOcBWt5aw/QLJnvp2VUNRx8o67iz1pTdl4VipHNbK+V52g0IWsHeaUa00nnuwtu50HOCSfEhINk1Rd7WdN+jEFpJt0tLecLrKBv7kvD0+5oeyNITPILNfJJKN8s9/73ClXMEOS+bGv9sNQ3S72OahQdHx4icb+2fZ8q6Bczhes6nJlsvIiMEqg2t/Wd3gluWlo3JLGhobaKz8NlgVnn12LbrL1bv0Y9jMPOkEPVKD7j0aArX2sVdWZPsJ7u43IRRIkrjgtaTHrHVYGWALvY1G06wcWzsdTJWMNuiP13Yq7Lp7T5NGVk2Z9ZoySX1gGH6SjALLL/w0gB3T4pF0HYYashYW//ycXkNFg4DfxM7rwRT8pV8zMDp1sTBdTQ2m0TbQi0fpmZ73TJJZt33JuX0+mu3A1mpZyyK1V9Q30EWI9/EqhswloxPi9XBVeXfNcFrm9KB8/lzfVcHHnKMllzvn0Hdinny80X9cGN4d8TAlNq4SU0I0DoYQCcigIJNJkRMfW2eov3fvI46aLqRTf2pMSfiJ9eTDj8J2Fdpf/vuCmTKcgaWDMFQANoXUhlPLoYZWP7vQ7D2yJbG6JsFGopM3D72dtM8iQBj2pKXniWItRNl7esqRYgaX+/4LtnAi/xQrxA3AzAZuSrpGoYEj9dSC
 rwu7qrKj
 BhSg782AVxL0pIKRF2l77ZmqeRZ3WoX69blXvFXRET+Foea2sybbUo4r+BLRvdThvDpGihD+Wy31H/Org9SgYgyJaw4eQhTf04iah2sJtY3ogrWD7XD+tREb561jvCOFN0dByKual/waNKh2JlDR8NkFZVwJDTkcXrHVcs3FbyBjxCIq1+PDiFzQLNt+8cMnr6mnNRRmgDT1wU1i+oCPXaUL7BuTOqSpqms7O+zgIYE1sA1BIgwUmhd2O+Y1w5SbKUsEdZnuYaJ68/8ZCiY+bK+xaAtqY2jlHKxn6gq5lWKU0mBNg6zEnryE7kLohJMIoY5p5x7mW66BaNElUMF1O3ZRPcSUkflDIn+2t5CLYrzt9Hpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
> collapse_huge_page() deposits a PTE page table on PMD collapse in order
> that it can be utilised for subsequent split operations, meaning that those
> operations do not need to perform an allocation (as they are in a context
> where it might be unwise).
> 
> However the PTE page table which is deposited is the one which is currently
> mapped by the PMD entry that is in the process of being collapsed.
> 
> Once deposited, the PTE page table may be used in a split of any other
> unrelated PMD entry.
> 
> This is currently not an issue as this operation is performed with VMA/mmap
> write lock + anon rmap locks held, so ordinary page table walkers will
> never accidentally end up walking the wrong thing, and GUP-fast is
> protected by an IPI via tlb_remove_table_sync_one().
> 
> However, the series to which this commit belongs implements RCU-safe page
> table traversal, at which point this becomes problematic.
> 
> This can be resolved by using pte_offset_map_lock() which gates on a PTE
> PTL and a pmd_same() check, but lockless walks are unsafe as things stand.
> 
> Resolve this by simply allocating a new, zeroed, PTE page table to deposit
> at the point of collapse.
> 
> This path is already costly and an allocation has already been performed
> for the huge folio, so this allocation is statistical noise in terms of
> performance and memory usage at this point.
> 
> With this PTE page table deposited, RCU-free the existing PTE page table
> so it is safe for page table walkers to traverse within a grace period.
> 
> This also brings this deposit case in line with all other page table
> deposit logic which deposit a fresh page table.
> 
> Additionally, this was the only place in the kernel that displaced a page
> table like this, so eliminating it also helps consistency.

ack

> 
> An edge case for deposit exists for powerpc and its hash-based MMU - it
> stores hash slot data in deposited page tables and zeroes them on withdraw,
> so a zeroed deposited page table works correctly for it.

I think we would have zeroed out all page table entries either way already right
now before depositing. See clear_ptes() in
__collapse_huge_page_copy_succeeded(). So this paragraph might just be dropped.

> 
> Since khugepaged runs as a kernel thread, do a little dance in
> alloc_deposit_pte() to correctly charge the allocation.
> 
> This is already done for the folio allocation via alloc_charge_folio() but
> no such wrapper exists for a page table allocation.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f49a6710933b..dab421f8233e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>  
> +static pgtable_t alloc_deposit_pte(struct mm_struct *mm)

alloc_deposit_pte_table or alloc_deposit_pgtable

should be clearer.

> +{
> +	/*
> +	 * khugepaged is run from a kernel thread, so need to manually set the
> +	 * correct memcg so the allocation gets charged correctly.
> +	 */
> +	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
> +	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
> +	pgtable_t pgtable;
> +
> +	pgtable = pte_alloc_one(mm);
> +> +	set_active_memcg(old_memcg);

I'm no memcg expert but that looks good to me.

> +	mem_cgroup_put(memcg);
> +	return pgtable;
> +}
> +

With the fixup

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

