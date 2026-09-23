Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CA0C98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781F26B0092; Wed, 23 Sep 2026 05:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7596C6B0093; Wed, 23 Sep 2026 05:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F4A6B0095; Wed, 23 Sep 2026 05:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375BD6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:15:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94C5D1C3413
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:15:54 +0000 (UTC)
X-FDA: 85244469828.20.CD1E78F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D820320003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:15:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMhlc0Vg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O74zCChabJPGX/5FXG7XmXwrySBRD///uZE1gOiATno=;
	b=y/DEqf3eU8MtDNMTEu/rGGVhlNrrkklibM7MiLoyiFdZZvLnQxrdIvBJq98gxeK4YXCggA
	U3EdlTea/1tqlSidavapgoTL7PuxILAu+rwtpiuPklPpc2HmdrkBMS1diBY5ojWq/bfHtp
	STL5Z300OxsA9kHwkHHTXmuhLVdchGU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMhlc0Vg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154952;
	b=vauIXOwZIMtf2yHEoudekG99KOPWFJUKzAQUBUu19VDYC0fvsn9RVCVA4dK2yxGJCHkVF1
	USTFClnFkoNpDcrbmJw1Ae0jLem0o6td1nEjaxWU6K/Hx8g989BeIdB8a05diuarIVuw7Y
	WXXBTbIegV5gK4hCnhpnvuKC4qvv4II=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23562601FB;
	Wed, 23 Sep 2026 09:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3B61F00899;
	Wed, 23 Sep 2026 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154951;
	bh=O74zCChabJPGX/5FXG7XmXwrySBRD///uZE1gOiATno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SMhlc0VgRdQKdx0qwl14ANA68wVrXDsrycIDNbwUOrPzQGed7psejweuHvn9y0Upj
	 oK9pF6NnduwDsnqfpjtJ/98OkmFP3+3GiOq1Gh9n/PtyI2qphy+ikJaaV9pWvwu/jb
	 lgkfeUAJH/6wrnbIuYjLND8YDK30CL0Xmk3ZEGU/0LCGarFAZx7fHYPYSxTuBD/9Po
	 M10D3egALYwoCwT9UTdFNWLlH9Bts/yO0DSd9ByK7feU9BZexVgvkgnX3iMjolsZ4N
	 yD6SaWbdPJpvZOUAW1bcswar5pOH0YXD/VsfYA6P7+enqEtASX+lnYGFo0DZ63X3o1
	 OTxrzvc6LwB5g==
Message-ID: <77db2f8f-dfc2-49c6-82f6-8e6c4f7c1fd0@kernel.org>
Date: Wed, 23 Sep 2026 11:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
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
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
 <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org> <arOVbT5B1FOMe1wb@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arOVbT5B1FOMe1wb@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D820320003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dfapmfcuzzsaw9e43hhyug5fsf8gu4ef
X-HE-Tag: 1790154952-337997
X-HE-Meta: U2FsdGVkX1+nJasGJQz5tSsV2SLVpnJvz362d6YtXKyV2N9+iu3/4lDUNJ6ywi3YCQ0Jd/tsPFZGMpplEPHeFPALatuHcizWvYmHq0YA3xu/MeRovs5TVwFEAiUuCby3+Pz16fmdTEDTN9lIA7yf0/r+WYfd6Nq2cF/3slh7wq0L0LmYifA4KhNV04jaZS8uxG1am3XY3SiQQopGIwsQwBNn0E2V550myWn+X+OUJ0okpi++GfR8/g2Cn9mn9/umGeoJucJZrvF/SSc1qoWO+0D1nOiXzR8mKtXXm1Hne0ly1k0tvoPJWtTL5Pr5driSCRWb8liPPQALBvk4vHBUJZGRi84XjCypyLZc8yEOmZfhgyGzRqaUhbf3xjR1WDTzMFc8PFtQWBKIHZd7llWYoqaooOu2tHlSGEyjeq8v53NXLgzzgR9mDfVl0NyVq3nPVU2C1AsPzc0cjWgr5Op/UvHig2Ee/KLhPE5ZogK8GVmB4i1oFx1Vh3hJFTmy5HF3gq6hLdEfIcAGTxVvkM4SSXZCRbL/7Q9Fy0vKg/WaliVDsfpzhsqmnmhgzGMsLi+85t8V+n7kjXMjQYP2SMDFnk/Hd6fBQDlzeqC0uzjz6tFWncEwj2LBoOSD31LSVmTcB5MELiVhpAqAbIGqwmisdRWHCzAIXA7yQxY2RaBrZ7RC1nWtnlg6ucgwA30V5Otq23LSE04AY6TldSTw09j4/jLBFhUxxJjf4vZnbSUeWVeb/CWe9hyTTMzlvZm5Fw9xSTxHlUf86cCeFVBkawT1KnVNJvLg1rSjM6Ju1LN1wWpq0NMo5QojIgIWE4enN5akYL9fSCjaE09gQYep/LB87RXYiionvQrzmp5F6NEho+zKZnr3oVABlHDDv20YipdqwVgiVQAhHtL0dWB3wUIfgY6Up/jAr6q6vw0OPPU9In34s2dVEsH5TiL8PDk3EFjl8SXOMynjdsBl0NLmq5r
 iHdCsNr+
 QKXR9LFcYSU/bNXWw6W9dQuodfryBdCyVIyI59YFrYRBwAsneVJP/Gz+9S6/og2mzBd1JvAWgQ0d5H1Gjg/XAf0TR4kYYg8o7tkfY7yPE/yaB4O0ZQAYl0N7iVAj1xZMpF8Y7y2u8da719L1X56zy8Ns06uAHEWPz/g+iON4rUyagQHfaOLIXzr7Wiu0SSsV9+IV95VJUyxywQnVzFRVJ3/FbyRHjjkFtHw2EZ/xCyZf9/sGgQ5ObEAgFf0UgChsD+BWidOGbx9z2G2eo2W7WdT0jR7AtllDI81RDskHrG11NZwrbVmhxBWLCOC4dz1Pz1ZKKVnshfph8h2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 11:04, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 23, 2026 at 10:45:33AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/23/26 01:00, Andrew Morton wrote:
>>>
>>>
>>> Do we have reason to believe that anyone is seeing any effects from
>>> their arch's failure to rcu-free the page tables?
>>>
>>> This sounds like a rather long-standing wart, yes?
>>>
>>> The patchset is thinly reviewed and mm.git is bursting at the seams
>>> again.  I'll play wait-and-see on this series.
>> Do we want to nudge arch maintainers to review?
> 
> (Just to note that I replied separately, 'thinly reviewed' is incorrect, it's
> been in -next for weeks and the whole thing was reviewed by Kiryl.)

Ack.

> 
> The only places where that would be useful is m68k motorola, sparc32.
> 
> But in any case it has been heavily tested including on every single arch
> listed with stress testing performed (I think I cover that in the cover
> letter).
> 
> The changes are not controversial so I don't think that's a blocker, but
> it'd be nice?

I doubt we'll ever get sparc32 reviews :)

I'd definitely appreciate some review on the arch bits from arch maintainers,
but if they don't reply within the next weeks I wouldn't wait on that.

-- 
Cheers,

David

