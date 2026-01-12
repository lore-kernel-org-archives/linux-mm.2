Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DB2CF45D5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157AE6B00A6; Mon, 12 Jan 2026 17:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1050E6B00A7; Mon, 12 Jan 2026 17:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003586B00A8; Mon, 12 Jan 2026 17:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E32386B00A6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:43:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 873A81A10ED
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:43:18 +0000 (UTC)
X-FDA: 84324789276.08.EC318C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B1C8D20008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:43:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XHbI+u/N";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768257796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ua8nWVmIqUSy6BTqKEwlGL+5NZiSuNBvgN8Kq9dJLs=;
	b=PBi+8l6uA3WIEGUQqURxwkzpKEl4nW+SXPSETbdKWqHhFavhSx7AiWqBowt1i/KWEBm0D3
	B+OCD5rKpvleeDlPrM6LsKcCKTfRovOlWwd8v9Xl9/68Y6IUvyshQdJ/EJCKQU1TXOaJHh
	8dipXIXosheAfmOX0j7GpVOVkAPOayA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XHbI+u/N";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768257796; a=rsa-sha256;
	cv=none;
	b=CNrkQQNAuGXbjUXIAiGVM9IPeK5J/Hslnfd7QRVuTWRGmcBI1ImdOGoBMtHgpVAcrLZkGz
	xvVfRzLDnHRHoNLX6h8DMk0az1859GEkYXdB0AWgJ4u9ARCNdanVB4tdqNzCxC0OCXj/8x
	RHKjdVTGoEqtNBxjMi+oZk7VdOF4DgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C8EB4087D;
	Mon, 12 Jan 2026 22:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC138C116D0;
	Mon, 12 Jan 2026 22:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768257795;
	bh=c8OfXMqmfWAA3Xd0n9k7BRlzt5YJOP+TMrdLjbKQz9w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XHbI+u/N8z+DTwJcPhNCM4+qG/aYuLLlIhzskPpVct7Tc3RDaA/MIfkN+LEBeGQ9a
	 u7o4OgXc7JM6Gl3fFSKUyXiOBLrsvJA7/55JcfZVY+eI4U31MivvleiDR+w3JZ2Uby
	 V/EuHDE9Q/+3pkXdGRE+/OInHfxbpKW0yms0awY8=
Date: Mon, 12 Jan 2026 14:43:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-Id: <20260112144314.69b850afad9ee67143f30a85@linux-foundation.org>
In-Reply-To: <2f9b180b-c221-4631-93d0-c131332ef178@amd.com>
References: <20260112202300.43546-1-prsampat@amd.com>
	<20260112202300.43546-2-prsampat@amd.com>
	<20260112130401.a857fac6abcf104ea9bb5c68@linux-foundation.org>
	<2f9b180b-c221-4631-93d0-c131332ef178@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fjr5huoyxsb6318bxemjym9ijo4cypc4
X-Rspamd-Queue-Id: B1C8D20008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768257796-195818
X-HE-Meta: U2FsdGVkX1+HaEuPZcUCVErSvris0Z2YqL1RG1Zmrcq96fdVezZqNJEtNQknPPAj7SPbqnqg1Bh79vl5t9HH/ugKnPmGOhYD5TOJu2wXJtB17uFvuiWtkInRdYYQzTdpMYnfVav62oKmo1I2+YwRV1vvEPrG7FWEWS7NMAHvpwY5IAukAC1/DZYA6CRwZyB6ZnZhUDIFof8zUNrR+LdOzts/on6ZelBW50QbBHVsa8z9xgvpomcIeqz/rqnfbZuRvRILNDHEI8Bb31maWdIZ7eLuohsJa4FLMoIRtYy4zGN+Dpu/V4Vy/T4kizV0NuJ8ktTHXCMpsXnwKZCx5qn0sHOUom6vMXfOIXmLbKNgbdE3OxsnQV/1AAZQx0Y02H0gBjdJirEgMVi7z9Knge8R0t7mAmHrp7QU08BqKxvAm4Sd85CWflIZmWOdrk2nKBQZpmzwHY82Fceik3aUsFaMlx7lKQ75/Exf2Punp6mlq3JivomcCVVw+O9rrs9dRj1co+aJ7Ug6NZ7Jy+gZgIudnpBpxNijaorIvACz9kWWhK0sBsUt2ndJawFybUpZN2acJO41B9xOg9UuDii41xpf4cu0tqTZ5qlDh2F8FTLHFP7LCwdgctC8q1mgQ8idMJ31BIg1M2jR8lCZs78MCS80/t7CfjPEiSkTUSBQSYsljsLcAM5zEh5hrF/I+Id5iG+ykwS86hytMZ8ypb6PjyIXg6HH4rcVvm9NpY1+PhdeEhlmZww3ADg0eUb/wS8C1skdSouFGl8q63Asa5D4ncIPTJeje3ZnuY0Phr9TKAIeJXCgEzk16yE0b0ieTVa68rfEM7znhuTnidg8sTzi25wkC+Td8btABKEHW7FN7UD5SUPQpETtbpnxS0oZ+QjLAOpAetYAHv/T4aktUeOi+vQqCKDmwDR/swidZjeRm/i9rY4ochVJqBgARokbkTd5n2PV/TG+JgOFvMJuT+3vXQk
 3lUbFEqk
 kuaE7EGgegk8zquQnHmogBG75sKfMF6Rehj+qTmrBMgKelugOioX69WScmqtog6xUjdBsXN+RXURMCmOT4oK2oT6z5LeJNp6rWirWIfWkwVXj7VDtS05V7q8P11vwVPuRWYbMZFvy6ddj17g18/V0kScCYWJGEujhHbyuaF6d5JauG1hNkRZ1tJF//UYsvAaoTd/QmqNx6wveSIBs3LYMW9LRie38nc+/0gt0RI229IFy7MnCvtuxpX3AifzRhmbCkGRO3PhKkpNHJcBHzBT9R2GvdzUsxOSxsw3OSliydrOAZku4lS/HbjLuAgHBWvfcWZofUo4IxAYrBYO5Y3FT1rZXueOUnyQ2971S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 16:23:37 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:

> 
> 
> On 1/12/26 3:04 PM, Andrew Morton wrote:
> > On Mon, 12 Jan 2026 14:22:59 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:
> > 
> >> Confidential computing guests require memory to be accepted before use.
> >> The unaccepted memory bitmap maintained by firmware does not track
> >> hotplugged memory ranges.
> >>
> >> Call arch_accept_memory() during the hot-add path to explicitly validate
> >> and transition the newly added memory to a private state, making it
> >> usable by the guest.
> >>
> >> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> >> ---
> >>  mm/memory_hotplug.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index a63ec679d861..8cfbf0541430 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -38,6 +38,7 @@
> >>  #include <linux/node.h>
> >>  
> >>  #include <asm/tlbflush.h>
> >> +#include <asm/unaccepted_memory.h>
> > 
> > This only exists for x86!
> 
> Ah, I missed that entirely. Thanks for catching that.
> 
> Probably not the best option to have a generic unaccepted_memory.h as well.
> Maybe, I should have arch_[un]accept_memory() definitions within mm.h wrapped
> within CONFIG_UNACCEPTED_MEMORY instead so that its cleaner.

Something like that.

The idiomatic Linus way is to use

#ifndef arch_accept_memory
#define arch_accept_memory ...
#endif

Lots of prior art here:

	grep -r include/linux "ifndef arch_"


Oh, arch_get_idle_state_flags() got it all wrong.

	#ifdef CONFIG_ACPI_PROCESSOR_IDLE
	#ifndef arch_get_idle_state_flags
	static inline unsigned int arch_get_idle_state_flags(u32 arch_flags)
	{
		return 0;
	}
	#endif
	#endif /* CONFIG_ACPI_PROCESSOR_IDLE */

- shouldn't have needed "ifdef CONFIG_ACPI_PROCESSOR_IDLE"

- should have appended

	#define arch_get_idle_state_flags arch_get_idle_state_flags

  in case cpp hit the same lines a second time.


