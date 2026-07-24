Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF76C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DFE6B0088; Fri, 24 Jul 2026 12:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BED36B008A; Fri, 24 Jul 2026 12:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6396B0096; Fri, 24 Jul 2026 12:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB516B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:31:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D30C21A03F7
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:31:50 +0000 (UTC)
X-FDA: 85024211580.02.C40D6D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98DCDA000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:31:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rJ2DJJ7D;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784910709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEwnT35D7tuzT3xeTQQMHkJEWGepfSu0cwMv30sxXLk=;
	b=rxGHwZ8SAg8pmO73mfcPS0PNGYV0tFzgDUbpu8tY/S4WoHn/9EhgKzOv65R/GgAoZMezwo
	mtL7uCBI40BTYwLvxbxedAQtqHS3sEbJknBDyaH4fuYQ4rhwhiqWO9Ic+JZhgCTZgv2v6m
	PwkdmbODyITk5DJ0qrHFBGJwr0wEoG4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rJ2DJJ7D;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784910709;
	b=5rmpoPlLrlJyNFLKkLRlfTz2bnfh6PHfYhdH0+gvqoWMI/GL3cSIDpgSmy2vj9OzpmQ2QJ
	bnZJMtY76vSQOKf2iZCtaX19N3+PrDBu/eHy/DzbyFnKlvCXBOrKJ/SG3VhQNJl1I8/gah
	yDt2IkiM/chEi0UDdxA9JkMQD5oKT5A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AE7F1BB2;
	Fri, 24 Jul 2026 09:31:43 -0700 (PDT)
Received: from [10.57.0.90] (unknown [10.57.0.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACA703F66F;
	Fri, 24 Jul 2026 09:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784910707; bh=NEwnT35D7tuzT3xeTQQMHkJEWGepfSu0cwMv30sxXLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rJ2DJJ7D9c7D1FVu9FvWF7Hq7v5HoLI/CdhriAp1fJ4dLBnD8EJRRWBa3d3TSeSRj
	 y4giJ+zCCtRJVGca1Zy4119yCr4CT8kuPBEs9cPEAEswfrfTiiEZd9fOxFya5yiDAq
	 5lH15CX22toaprtjLQyFDxQHqVRAyMvOmxdmryBU=
Message-ID: <c17ccb0b-9f6b-4521-a992-bdc658b91597@arm.com>
Date: Fri, 24 Jul 2026 18:31:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/22] mm: set page table page type when allocated
To: Vishal Moola <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
 <alZSwAM4pwmMOeaD@fedora> <f3afa5df-73f3-49da-87a6-d75eb5f3610f@arm.com>
 <al5xZHiFwatn518I@fedora>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <al5xZHiFwatn518I@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98DCDA000D
X-Stat-Signature: 1ywo6jmhnxbdfw5n6qpbs9ckd1cohnqe
X-HE-Tag: 1784910708-491751
X-HE-Meta: U2FsdGVkX1/ea6fliWIMO4Ez2JbH39Mq15Jxxjnsvg+ToyUPYtAIaDvCYpJoPc73L5UACvMmtOVbfq1KCUBowkxTDwPkTLjvr5PGPv+qmcS5isXjYsc+UBoBITPcjt+F9K31egltPp7QjjxhBRMJRzpT2ykBtg6ggPAd1mxcifp8yul5C9fSnzEUwOIxSnCYFdKSU/ttLAZPjXz6dCyG9BRw+rbvy1erf2CYtnZowjJnK6nJ9ahRAH5h/ZV8/riexIo25TnBMMpWyBgowq54OFCjQBTDLjqbnFLSRFv6qY83xtxaQB3EXuh4msW0toPx1wDaUShlXtebeol4Qu8OCIiPuBFdWm7KEQP2ah0BKfc8FXzULIJQbRyPi5i/ifGR8x/WvwF/xJQszKWQStHWwSva0GHv+zrha8V4z7UGK4irVmpAxkRBe2fKkpsQP4AJzi1RseSNTe8ZRME9QOjJNMrg3BVsvaBzMUoChco/gkd0h83MXvD0ujtf6qOhfFdgp4JByIXznm217D68lWVIGops7/EJEHQdXQ4RN78Zm316ErxpY28FjbUUoGgXoQD7tvcZtP9NSO6OESabwmvh1yzvMZqSi/4dp1PpPiGcPkosxb9CqrjWfT5pvpSkRJUPGvzc4S99JFn516NEI/ChxGObqxyxbf01pyhRoyOL5siGp/ao01lvDGJ5V/Cie/PrHx1f++ajp9yI+VgtGXl258sJ4j9GZyic+QiX6No1SPA+3vXvEReDJw8R7p4kgeABJOu1T8OP6vwB7TTa4AgBM23aE9XNFu6wR5QfHbVFLB26+tEx7WECEfpkwCZ9SL81zvcjUaypo2AkdOu0rgTvSoAYEspo/fDqhT67KsvsnBdRH/aBC5YoVp1d/mCkLNmEwWvJTBHb7UHqXCXmdBqLXQ3Eg3bXwJ3YhsGGAbsdMOCh6fq9vE3gg1IAmkCfveUvp0N5Oa1AIXyXOXrBsgr
 JZAySnJ8
 wQrilnxGeFG2gykNrPNLPEuNAp9PTJnxAtpY2F5SioPcadzyRhwS/bfkAjWNrlMH7XTvt8hHyVe+aFrl/CeQU4hXwrOXJT13TmI7fPeMU7ia3PwkBuPK/yxJJtrHu9UE98qlzW20RQ+UcMJcY98mNm/yGMXVR3muCpzMZZnGZ5Rbr78bm5mxQC7pGu13jiI74DuqQCBV7RNoV4JaC6tS4068fOx0hSc+Fb3k6mWyJwr88/8aBPvdjgsaSbLed+OeZka77+NNWJ36yhbphJ6q+MKDuo5WCeo9TKxWcXhGnMUbJ33Q+E9QxZ7ohCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/07/2026 21:05, Vishal Moola wrote:
> On Thu, Jul 16, 2026 at 11:49:31AM +0200, Kevin Brodsky wrote:
>>> We should switch over from __folio_set_pgtable() to __SetPagePgtable()
>>> in this patch. Ptdescs and folios should be treated as distinctly
>>> independent of each other.
>> I sure remember the previous discussion, but my reading of your comments
>> [1] is that we cannot really change this as long as pagetable_alloc()
>> can be called with order > 0, right? Multiple archs still rely on that.
> Kinda...
>
> The concern was about callers accessing tail pages directly for that
> information. Using the folio API ensures that we always look into the
> head page.
>
> Since we're now doing it at allocation time, we know we always have the
> head page, so it's fine.

Ah got it, that makes sense.

>
> The dtor/free should be more questionable because the underlying api
> uses virt_to_page() which could look at a tail page... oopsie. I
> haven't seen any reports tied to it so its probably fine (the
> setting/clearing has been using the folio API since ptdescs).

Right, that should be fine - calling pagetable_free() on anything else
than a ptdesc allocated by pagetable_alloc() is a bug, so if we get any
crash because of this we should just go and fix the underlying issue.
I'd still switch to __SetPagePgtable() in a separate commit to improve
bisectability.

FWIW there are definitely cases where pagetable_free() and
pagetable_alloc() calls aren't properly matched (see my reply to the
cover letter), this needs to be addressed for this series anyway.

> We can say thats a happy accident that makes distinguishing ptdescs
> and folios easier :)

Indeed!

- Kevin

