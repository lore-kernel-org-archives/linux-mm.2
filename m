Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CE6CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DEF48E0016; Mon, 20 Oct 2025 06:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B67C8E0002; Mon, 20 Oct 2025 06:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F35C8E0016; Mon, 20 Oct 2025 06:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFAB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:33:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C127F1A082D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:32:59 +0000 (UTC)
X-FDA: 84018129678.10.D50CF9B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7CFF120004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:32:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760956378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AQxwufvO07AT5kQ2hNXxkfTUD6GA7CPz6wHF7lHZRs=;
	b=0fw0a5TXwbOS67IRHrzO8IlOLl4/xPzWfur41RD1kMCWxXAPTHJcC94ilTK1nOnYAGl/zh
	sk/iAfJzWdO6cm142w+JdBQxh5g5nIL3T+DFkh2mRhOuDZIjdHhVooy6qwawmQ5+Om2kZE
	qO8ZBKGPf2jGRXyu5ScYRUCyhE3GHW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760956378; a=rsa-sha256;
	cv=none;
	b=On8S1KT9vltGHC3BhhO2522k1LFTSQ69O5w5/JEDd56qycTeyZVENo33MjlOXZV5CQfAzM
	gZgdGjomsibxbjo3E4rpMMyXVe+lEXJS6hue+xZ86VMC6PonVzpI1+u5JMVz/qq+S1udm1
	3nHBsKoh21lem9QEnrBf03BQbGFrcXc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C576E1063;
	Mon, 20 Oct 2025 03:32:48 -0700 (PDT)
Received: from [10.57.65.147] (unknown [10.57.65.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 924903F63F;
	Mon, 20 Oct 2025 03:32:48 -0700 (PDT)
Message-ID: <2338a99c-665c-4545-accb-c9ebffef45fa@arm.com>
Date: Mon, 20 Oct 2025 12:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm: introduce generic lazy_mmu helpers
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-7-kevin.brodsky@arm.com>
 <55f8b155-5468-43fc-b6fc-f509f4becd5b-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <55f8b155-5468-43fc-b6fc-f509f4becd5b-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7CFF120004
X-Rspamd-Server: rspam02
X-Stat-Signature: eg7mdqnbhntaxr9ed1bwqgmf6ehup9pf
X-HE-Tag: 1760956377-202459
X-HE-Meta: U2FsdGVkX1+PtMH2LRqFn9tlbQHwDaoe6XQIRqJ++psgrf/nCCHaVtYQ4NPhPo9w2iPUfPBOlWQ2fUPhR9hYua2ZjJH7lMcM0xvC//jPv731bMIrpjH1+vq9J3jQl9bO8rR64J3gCDbycpHoxf7j888EUDQq+00iRrVagoLmOyXn3kLPXHXODAKL9abqowG56Mvcsh3u+dCLNbok5mJ7HNxoyrD99CL2R6IKTzKYcuip/XLq1MGKr2O0ux0wmmuLfMpwhdqlks1bOOMWTIRii2IJZbwl/1WPtrfg5077Q6qPIbpYLKwvi+9bBRmc/380z7OEFq73utdIUdoaLY6o5Wy1Hg/4hTCLOoYRhuHMuueAfB8YKC481g1vkipUcXt2abKziFK8PU3vO8x7WovPqERIlRI3rn4ZkfOWAq/BDijcb0T7x0ekU1jxe/Rqy7XXG4wfM4eAi1nxBdyav+DXMFHCr8Azb5iVjAexVYRRZxt0TsObsdR+lbfrv9jqmddnpeiDPxOx1UVyIINW5VNzBPXIdow+SISFvoJSdinB/6RnA8yHj9GO1UOZQhbAwLD/iY2r9V017KlA73/d+e328qSEhAqrB7um0gc3Dgkb+iWBdfVfb6Z9bJ/qhCNl9lGgYNaVTOepMfQZFWUQDyrLxnl1QMSX2J+FB9vsaJlXxoQrLL35UHRav0m5DxtPxIdD90v1ukIYARyXsI//z+O9+2u1g7Bc3/gXC4O2tQG6/2SvCP+mnfVgjaMbTrg2cWL6oQpswW45GmFrR9F6cDjw0vQtAxtZ/Tdr/JnlbPBauUkDPeWymDlZ8koVssR4PihfepABLd/Z3v2zbA+/PNNs70E1dN35HBgoysClu/TAlPS/fRaXPK28jjQ2sc8gLrM4QdQ9KivSMESLF7Nfa+I7FNaJKbjGGn3z9aV9pkNVHvs00ED7R3LsDv3+82n+MgiPe8+dgcP9FcGMV+fdLK/
 7TEjU6ww
 YeyEeUNwpbGgmOT560aHw46svTZI3/TgY1BQfzfACWn1qFYFAeJ4dqEU5lB4YNPDfT0t2URNHj5vJfYD12jspbuauASvpL2rZHfLcaDyvUJgdL3ubJCQ6LYa49uF09mI7rck9XkycJc8TP4Pwq/srX05zLpnMO+d1jfuYPpaQvxPJ4lEcR0atUjxY8HiJm41m+IFc/c/6YqaCw2KoxjQmVtDmYRg+4C+pV52HGxRVh7O7caQCmDJfDHMkdr3CVFkO+BlZ0TuzDDpJQc3wQQlR8pqDZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/10/2025 17:54, Alexander Gordeev wrote:
> On Wed, Oct 15, 2025 at 09:27:20AM +0100, Kevin Brodsky wrote:
>
> Hi Kevin,
>
> ...
>> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>>     This is for situations where the mode is temporarily disabled
>>     by first calling pause() and then resume() (e.g. to prevent any
>>     batching from occurring in a critical section).
> ...
>> +static inline void lazy_mmu_mode_pause(void)
>> +{
>> +	arch_leave_lazy_mmu_mode();
> I think it should have been arch_pause_lazy_mmu_mode(), wich defaults
> to  arch_leave_lazy_mmu_mode(), as we discussed in v2:
>
> https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com/#t

See my comment on patch 7 - these new arch callbacks can easily be
introduced later, I don't see much point in introducing them now if they
default to leave/enter on every architecture.

- Kevin

