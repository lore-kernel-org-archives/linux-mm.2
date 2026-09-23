Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AA9C98311
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80666B0093; Wed, 23 Sep 2026 16:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31AB6B0095; Wed, 23 Sep 2026 16:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FBE6B0096; Wed, 23 Sep 2026 16:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 857746B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:01:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EED4DA094A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:01:13 +0000 (UTC)
X-FDA: 85246096026.14.84E0B8E
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf25.hostedemail.com (Postfix) with ESMTP id D01ECA0017
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:01:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790193671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvDDKbJOCHVNMBf6MfRG+XPEG43cFbYIZQUAS2hlVUA=;
	b=Y4dYhvV7FNwsxIEwsk6SQV2nZPYigQ65f+f4cmT2TejhaWPCJECY36+EfT7u4UEp0R9auK
	r9k3dn7XO29oIoxkbzQ/+Ky7DB+mBDnwqtg7EapFCFfrLR5P37fYNxj3F3pQMZBvMgme3z
	orzgjSV1dq0W8ValyrrpxwYPbvCfQ3s=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790193671;
	b=Y7FjxGi7bpQK2zBXB9W6Z9NLfVzj4JkIHwVoc+uURkGkiH2qvExsSr4WyamGOUSaFguW7A
	hM1MasD0rM9rE74pM5MkDZQMQa6IGlfpAU40J26K8uv+YG36QCzP20pe3KQx9ZQDR/SaRF
	9bFRriKux+dUVfxpwivQH/T9cNk9acU=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65E144088E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:01:11 +0000 (UTC)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29A451408EC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:01:11 +0000 (UTC)
X-FDA: 85246095942.27.3CC01D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A63240019
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:01:09 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790193669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvDDKbJOCHVNMBf6MfRG+XPEG43cFbYIZQUAS2hlVUA=;
	b=OCNZAEuOE7TPZqpr8Rdj4mHuDQ6aBAcV3jY/NOiXJjEL6nJvB0H9n4DEMmleJ8GLN3yzSC
	WRCgtHdBM427aw+2+uheZEhV5JJ1ZtiKCuRHyKgY63oknacV5DBYs+17w2JPBlaTATqluU
	WJxmt0GMMPVJVtc/cMB4wKvE60tF7KY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yukRbG0q;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790193669;
	b=0roLP4GFLhjE46Ksvobsj0+Xf5fr5LZFvLfQBLXhqGmD+QFfZnRrHawietpC/y2UMqxxCF
	+2kK/EvmqK88nXi4g21af/gNEdyG+bLVD8ROf6YzWbIe8gJlLQ1b+LMWDFFA7iGI28QR9i
	hsnF3UmVsuQH6D+KtjlYSxs7KKVy5ys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 961F5600AA;
	Wed, 23 Sep 2026 20:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976111F000FF;
	Wed, 23 Sep 2026 20:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790193668;
	bh=pvDDKbJOCHVNMBf6MfRG+XPEG43cFbYIZQUAS2hlVUA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yukRbG0qkn30dWVsqij/SU5fM7nkPcs9gLdvOBDFKy6hSl5ItrFuR2BYdapipYrFp
	 /ULALkETS2Hzxxifit/ssnY1WioE70raLvLXq6WSexLRbbzTwV3qRYdtF+xb4eB5wp
	 1Lu+3tjEqSY8F42OSvK9noPy1qtRRMWcgWlWM4o4=
Date: Wed, 23 Sep 2026 13:01:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren
 <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne
 <shorne@gmail.com>, Rich Felker <dalias@libc.org>, John Paul Adrian
 Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>,
 Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris
 Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge
 Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel
 Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Randy
 Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins
 <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-Id: <20260923130105.522942080238d133a36afc91@linux-foundation.org>
In-Reply-To: <arN3iaw7VDIA-bWf@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
	<20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
	<arN3iaw7VDIA-bWf@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX18cxf3L+aMcGgiTR+Ln1wzqyM3tjP+gy+31hzFvNvj1tpqsGN2St/J53Uh+IGpJMC7/XQZ5vHxLRLpGlWZH2ni3WDZRVpD7uMeNOoNlzC7psZJir939xa6ScwRTzxDPh8VGFaNy72A9NrtHhGB2coFfzMJOBGI0jdSUXmLBGCSV/E37wxzo+9n1WhiDY+4f43DRxwRP+kj6PKSfAjHtxW9w8bOX1m+4iTq0CjB5zjbMhNO9zN1SdesWw4rW/9bV80ZRwRLv1aFid33OD3QRQ9hWrQCiUv7WGg3ZE691eOmx9jSDWm2k23pn1+WYGw0obYR+h8nHRR4gzWgIUz6bUdTRkt2LnPpU2uhGV8cGfun7WuWX/8G8mSNAR8+QQLGP2E2WJMxDXfQ76DQUHkpaF5B2c8KVVBSipGF0MVU/PFRprv6uujKskm6WHY7xrK/LTzvrYrt5xTymXOuQ0nexMfiIjrFCCB8Xl495EMjMHo6BGOIRmYRShICx2n9vpMr+kJkeAL263n7gF4AvkKfSlP+szV3oDqmci5hc711JCTFuUTqa4nrs10CWDvSYZPyaXxG6eWY2DLdiWk3HeHjid7ckYhyeWcKOVQGxTG0VDe561gm71n1sqochNgI1VF/slzlMeQVekGYwaDorX0BhUTa3nYm855gfKl2mYIkPuouqgDz0Lf9ZXtYqeRZt3Ag2OK+prFaLM4cKVM9tbXcO89oyWO4RzVol8AWHXAyiDxFi4B3++l4ZpItAwP848GTrFTKdD+ty13kX00+dgvNlNjZ+OV/vrwR9sVE0Ley179XBuj5EtEfQZfufmvpjQXi3Ctp8SES5vqTv7XqrMbpy3Z5zm03vdS/5xkRYpvtrwm6QsptsDqSKWIjoSRGnSYTD9kScVec8mjsDX/i5AgvBHFokfLmy9zKoZmUcV7z2vHpsjkwRWjgK2HCit/CIxQXtbVmBPL03Uoe
 O3QBvJ8x
 XjczcMXcVKTBYsKe40kh++CmFAKeJSUi65OI2GfigJKXklADWbo1ponJrz6srG30C/Ngs/2UpzQAa479IATV1A4Aj4Nh7aa12ldOVNEU53mewP51KHJmYTeZCd1RARdMT8VqNJgLi9vGcSzWU6RdCPcRMYf0zsXsxYfLZdcD/fp0Go7QNblG970XH3FQMjBDdTraRoCC+U3jbDjE7sxC3AQN+YgMS4gsx/01IKSLatn3gZN5X3W+SEzAEi54U0Z2tdhyr1xXjnOVB2e73JSiSKRXhPn9Law0MdwvDuSu02KL1rtUDiZySx6HJOn/4IBLcCvz59kY0l5DY2RNQS98E5LDvkuPtBFoD+IqMfVYNAFobXQXMiQmqvasX6g==
X-Rspam-User: 
X-Rspamd-Queue-Id: D01ECA0017
X-Stat-Signature: 5ahc118g6jt3wyso6u48wuoanmyodj3e
X-Rspamd-Server: rspam11
X-HE-Tag-Orig: 1790193669-368852
X-HE-Tag: 1790193671-349162
X-HE-Meta: U2FsdGVkX1/L5Sxkm2jIKY4SYF6A0Hu52QxUpTV9m4jyjCDLuqiGa5mQcjeFnETxrQYMDls8lCkWB3ZFmDOBxoBXaGP4dVQ69TEID3yDLAp386lcpIZXsopmvSnlwhpqJXr2PPVLmIAcbh+jq34AqOdXLiI1CXKxpI3a8JJGOMTzMHUPELLhAtKCNp9Guj3cXTVoXgwgYmOvQIjup9QXGVx3ochnVLapZDgkDDYHR7ojHlnHd1+krZd5VlqFQVhFpDU+/tyaqE8GwR4RjrX429IFFcDsBlGb0PpUgA9856W41CLfUL7XrSQQ8yPXhlTF2Kf20o4vJZiE7Y7YRYeC8hoUmanbAXSNf5PLKjQEmS18hE+FMUXEOvIB8SAut+XASxH+XtkCxWVEEr854b5emQg+xZG9ti6TlSMKo+YqNNYm28AzXUeRVs6LstfW+gjd85C5BLRsienlPPZ2jFXpBWbfguNa5G11HFJLful2PDUSgOkjtM5F8bJ+ShT8ARx0dRxdLef/dlwCU1IVtSsgsKkbIiA09ITm+utgTH3rzMc4dNVd25+mSKgoJOMtlt8B842SkFA6H0sxQAUtoYdlLJIGZIiu46KkHFhqutdu+q51GG9Vs9bDsYe/LKEMmlo2G3m25hrWi8usUtD8MLgpUGTnwRx9KOXY7bf9tqpxWoeL9pNa4w33ml+bX0WTYIstWUVZQjy2PdJdPx1iq8ST+kC/h3yTJg3fr+GohErR/lYxG+El2eapUZYxZwt72N76AHlkEz1v4Ninz7DtVBFqCjM45KMWhJy2UkxGG0VmSZ4N/+q6y9MbRJjJox+YHsUOa3JuO7999lYPZiXbgG6Ne6DtwE5dvMBwNG1xEJwR3ukvHxoDTqpq8cLSKi+xFHVYoWfEIjCImJUCtnuzQdKO81mDmd0ENnPr4pHhzBJpqaXE62gfu7ydTcIaIuDthXgx9IbrIk2Y/uwexrDSeYh
 8uf3SUN0
 oYfPd66kzgibQcBOstkQKVG9cvKHNbKA6DqM+Gx38pW5qVFPoIkg/CN8FbNMw0uqxF3urJc7D4ijdq3+aoyt7s6XewWV265hUeG7SBhgHmmo9KCNbcMimMC6KixWBe/Imb9OGX1sq0A2S0m44784b8WpOfHobRsdAZNok11osXv3bX0uoGrjb8NwnI/6ZYj1NkiAdijB++Yn+Pmk/kKD93ssx2WASjKXJm0u/N/Jip+/J1RdkS6BYZctghrAFJLHCbQmI6PlCG3XQpCSmmXmrCo6YueOCWKlqozl+i+ZB1/nkWtp1qEUTAwwNyFDnLAr2F8HuWUCklPmfccwEeeQhVNYvJsIaMqs60AdNzNNVD0HrpBeMUAG/svVFiSBqoSvThZnqcSazZm1XAh4A4DZxxCjPHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 08:04:25 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Err, Kiryl reviewed the entire series, I sent it in -rc1 of this cycle, and
> it's been in -next forever?

I'd failed to notice that v3 of this series was in mm.git, oops. 
Thanks for cluebatting.



