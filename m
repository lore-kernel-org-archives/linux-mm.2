Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B9EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBF36B009D; Wed, 19 Aug 2026 02:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD736B009E; Wed, 19 Aug 2026 02:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B756B009F; Wed, 19 Aug 2026 02:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33D76B009D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:52:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38FAA40450
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:52:40 +0000 (UTC)
X-FDA: 85117100880.29.EF2FA0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B0611C0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:52:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkLTMf+q;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122358;
	b=CpnH+82efWagWSaMJqLmyFSgDku1rI6F5n5PhfG+/b1ZmrXKBlR4SdWeuj8TjrCKupaiiM
	ANWSxGolOQKHr2Ih0hpiF0d4b5DY+8XrRt5cgeGvNThEIHzMdSWGIL9xFLhzldkVrreImW
	YJgisSLIRFlcVqX99lHDfQfR/PnpUzQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkLTMf+q;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7d351kwETeBhwKUAevfFIdhiS/3pPYk4RDmKm2u9Xu0=;
	b=oHuuhvH9ryZLHxsBeuwGCyvYRtt4DK7BCenXhbxZ1FWZc9QfZIjpJpHR2BHVXX2TWkhbOS
	vuIKUG9pr+6ACu6QBhDtpCy/21Z2mXvbQpzcmcouP+ab9Qjji6ZG86BiAiqIbdkxrSOzv7
	BssDVNJfaKsLW8EMV4pLC2IL8bzgsSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACAF0436FF;
	Wed, 19 Aug 2026 06:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7811F000E9;
	Wed, 19 Aug 2026 06:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787122357;
	bh=7d351kwETeBhwKUAevfFIdhiS/3pPYk4RDmKm2u9Xu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WkLTMf+qpN/io805Y+2gkeOkMbkpIKzf/6QzY2J/6Bl2FWOx3hYwxZqHUNh5M4dgw
	 NmuyAHXcBRvh2GxscHJW61nXGUBR8lNKbUmLxqWPpQcQgLHWUAVlSWz6LVoosdqCUL
	 ZEmosEMGQfwSgXLsUlMUGHaMqKfk3Jvw8lbWY34WrNbJ3DRB7qmc/YZZa7OShj2kZU
	 9F9gzCeo4nBVxNMDWaMYPftvg52ti3BnqeVARRjJq5cVbN2pVAHAoYGhFw0l1dFtDu
	 nWSAaMBzSD2S1DqUVmDAMWvEN7eDywpx8rVr2/eMxUkxs3qh6vnl3GoJDWDRt0ReB8
	 kGYH6E45e0M5Q==
Date: Wed, 19 Aug 2026 09:52:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
Message-ID: <aoVSpnf-b-btyHR9@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-1-90944a3ad43f@kernel.org>
 <DKR7IK0VAERF.3ALVHRNQMSXZU@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKR7IK0VAERF.3ALVHRNQMSXZU@linux.dev>
X-Rspamd-Queue-Id: 8B0611C0008
X-Rspam-User: 
X-Stat-Signature: kr5w6d4ubt6ytbjqjmnrhab7nckza34h
X-Rspamd-Server: rspam06
X-HE-Tag: 1787122358-47984
X-HE-Meta: U2FsdGVkX1/6bu6U8S9ZlHgnnrxlXvD7vbsefaoMK3tDk1/2z+qEcNupF3fhY7fUIpkrK1rgS6rlr4duwumCNpiw2MZp6GestTMOdTt6ua6U+vxUB3WvibPnCrG+RSnMnzZbiUCmd/MQ6rUO+j8BGAqcM2zq2IDDap9wIBdy3wO53386aSg33Gj2OR6WlW1nBo6v47o9YbwsQhc7KA/Wm1o/rDtiVEGUkZPVy/BItz6RyMqgS8NTAlzK4dk6h/nlV3RFcFT7cN1LG1IhyZrO/E/jT9nPs7aMh1Eq2JH0EiR22JcFM45FFOf6isKlHw82xY8v4zxJCsquEXTojrvFNcxGRZPNnzCJcxIR76/tWFl/NkcRrZBh2ll+Od07SWnRQw2L+kS/PHvVx+5ehHds4nk+rft0NGzLUCYhE6uOuLIFNpl5yLkGodk6pPC6Jg8KfxEhCEobPWy5oOne1Axuf0lSCfOnG6nWRsAv+ZC2SP5a6zqjlOcGD9EPxam1fd2gZrcl+H8qAhV1y5am8upQQdrl5wOeO7He4Aa2Z8ubrA4qTaDRwrD78qVGkqD2SK4W6Ks8QOf/y2FgLOnbf/ZSDSrqlP+uW62fAKyUYyLbf8n/jwKo1MTp9m8vKRdBZQnuSq1bvNAdor55C8VBvm6nN/SpNdk7eSyk2rJkuqa1i7ke1d8HxrVBoTnpmNG20IeQDWEtZ5GACjxS+WMi9uzxWiRti0L8v5we2GCY9CuVm5nItsyUtaScAUeg2UkL4iBF05vxsPC/Yem/i32y9SYSLy3KHVDg1ORbfPc1ZuLHbPpmuABvqANe+0YzUn4p/2RL/Sh1YJ311nF3N6OD4Tr0kL11uoMjhmn7GefmWfFJ69I9WcavsfhsvVUg695jzIR+WMA+KAb0LhY4M9h9IEJdFD0BU67xtTwO41hoBIF7C3Uiwew2v6ii0x0XgjfKk1le9XsTPKAym3GNqmMIc3X
 I+3fTXhX
 zfN7C0QORS7xEQgO7oRTIYi/B02BuwQxJqZoik/eaLusMQdbMIfWkDc9W2msxIRcDpXSAV2+UlvlHQ3PGh4bMPh9iA9HzMLwMtxp2KIlKwupmm63hhZDG7Vl8BsSehHCREr29w9cgkZExSYEoKZZ7cioSuM+d9ZDvx/Vf8WZaXnuDPdM1++1htRPHKtZaXVKWAzOzzdoX0mdEvUC/8lEU5diVP3uYvCRCxz1DjkyvovucGhksJKa+3sYXtozF5ySITXOD73ASpX94gio/m/vCappLoAFQuL+1h69tx+Zvcs6yYNP1UcAdqDX65+zYp/pfIRKM+dFQIlWWnsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:10:39PM +0200, Brendan Jackman wrote:
> On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> > When set_direct_map APIs were introduced by the commit d253ca0c3865
> > ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> > parameter made sense because the initial callers (vmalloc and
> > hibernation) had sets of unsorted struct pages that required changes of
> > their mappings in the direct map.
> >
> > Since there is an increasing demand for direct map manipulation and it
> > is also desirable to be able to update larger physically contiguous
> > mappings, for example an entire large folio, extend set_direct_map APIs
> > to receive number of pages parameter.
> >
> > As there is still only a handful of callers, change the existing
> > functions directly and update all the call sites rather than adding
> > wrappers for single page case.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> I think if we add this arg we also need to specify how the
> implementations are supposed to behave when they fail midway?

This is the same as set_memory, I don't think it deserves a special care
right now.

> IIUC the incumbent answer for stuff like this is:
> 
> - The implementation might leave partial modifications behind when it
>   fails. The caller needs to deal with that.
> 
> - ... But, that's gonna be due to allocation failure. So the caller can
>   just do the inverse operation in the failure path as a cleanup, and
>   assume that inverse operation succeeds since the pagetables are
>   already allocated up to the failure point.
> 
> I guess it's worth making that a sort of explicit contract since it
> makes certain implementation details load-bearing, e.g. I think...
> 
> - It forces the pagetable update algorithm to work in a fixed order.
> 
> - it forbids us to e.g. merge PTEs into a PMD if the region might be
>   pending such a cleanup, since it would force that cleanup to
>   reallocate a PTE table.

I'd leave the load-bearing parts for now ;-)

I'm going to resend the patches that generalise CPA and I'll add some docs
to that set.

[1] https://lore.kernel.org/linux-mm/20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org/

-- 
Sincerely yours,
Mike.

