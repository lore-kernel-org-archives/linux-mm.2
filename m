Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6694C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 03:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0406B007B; Thu,  6 Aug 2026 23:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2696C6B0088; Thu,  6 Aug 2026 23:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135036B008A; Thu,  6 Aug 2026 23:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D27256B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:04:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D1E31601C9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:04:59 +0000 (UTC)
X-FDA: 85072981518.12.D697EA8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1772240008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:04:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KCGUWKlk;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786071897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1pPh0dzfin+Wivkqd/MJbzCLZEfhwCk4nv4x9GzEhI=;
	b=xSQyjYyUdn8NOVaaojq+qnreZwOg4euHOlQAfufGbpYS4i8nrHXOv4DkeHcISnmRTVpHyu
	T3w/4DLg/GY4JJA0a1we0PSCU9W/gGOZhUu8hAJWWASbC2CrczmYsHQApesbXcOS4gsLUJ
	WUGeSI/naN9ajnCoayQexg7lohGVHVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786071897;
	b=y1ASMsXOzyRFJM+i27ticGkCGoXEfQe21Sm75x/OAMIyTB1l/Z5oaarhHfSChJH0XoH3Ni
	QnuPOdVZmIv/FAq6nmOpeD9E3cZa142GyhWq1m3Vh0uJCHjOXhQk4NewSR1i3vaN9k0V/G
	Ze1AVsMx4rTMwsy+r7FPMb8wFEbv8ec=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KCGUWKlk;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC8ED1516;
	Thu,  6 Aug 2026 20:04:51 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AEE03F632;
	Thu,  6 Aug 2026 20:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786071895; bh=uKm+O7AZw6fz//BmbGOF2o9qC5lVxMHc1iVJyBQ2sxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KCGUWKlkBhQkid6298mbUGrvwOy3yjyaj7fJuZ78NAAp61RUU+pb23ZqfUmWzKJny
	 K6qzmEI+vufX6AL0zi4P8fF81RodsJZrgzIsoIXX1V9N3RKa/xNPoWKU+sNlafL7o0
	 SveQaWFANxHPpoyzxB+irLTu9ZkkgXsMGPJ2Ml3I=
Date: Fri, 7 Aug 2026 08:34:52 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Drop pxd_ERROR()
Message-ID: <cvv4iwa33bpfrqn5vbg7qjomvazrxm55i4u4gubgcllwm2so5n@2hdj5rbzmcd6>
References: <20260806080639.1916749-1-anshuman.khandual@arm.com>
 <70cb93fc-22d3-49fd-9103-29a4759bc39b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70cb93fc-22d3-49fd-9103-29a4759bc39b@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1772240008
X-Rspam-User: 
X-Stat-Signature: jwmcz5okpbdf8ysw8rmswyjmcb8zpbka
X-HE-Tag: 1786071896-868360
X-HE-Meta: U2FsdGVkX1/Km+3S6kwjcSM92Za5IgZL0lTVfUB/4aehv8MYT6SfqDF+JnO05d6r8BvRkJ9etJHJxKwc7Xc5gOykRYgLtGraEPffoEuaVpMeRzyTFcwSQrqWe1UWIhopWwerx+Ln5yYMK9cw8MKtpN3VQR3e2SlS2Ioxb4bdiEhuBbfdTcODK5d8J0SGf5SgA5yHgcc7ptowEdiujPSv171qeCD7fhgrqSsXFVvRUERMax6MdjvfFy4OgGb8yUF4AuH2nPQbf3dfX6WHAUZ2bK033+AvhZ9zh2mMMGBrQW4V+1bHEyiScXE24+7XwtcurBKJHoT26iMGVUtKuzdG1kD+c5ck1tKhJYUgWOmZ1GtXilLm0KgjrObAwAcKzXoWAcQDa37pbtMOTo7bXr8aj4dKmX0O139pXdIo46AobD8w55VaX3opd2nYU0ohcOCjwQ9dF3OPhlhwBBjxPi/7MMrNn44g0NzN+dCw0Z6ye3sop7tB+oD0+YVt2Yq36v6o36E9tsjSUIAL2KE1SWcYZLP5xgMZw610juG80CHJ0qYGhwQJw5hKStI1ybhtYV9w6jdgwSCkQvr9y7isFPElRdcGKuMswB19dpkfijAFsup1gg+Hb4mp1wxqGfiOvga5XhCAsUovdRMom2j+92+hc8592anuWeMh0q/PhAmryhRRZzxq0iH2BbGsRw63tHmTpDuR3ZSnK498XmnQPVTPlyPxyBsQ4+vM8oqzi/SdnNzI1+7lpRzRkH/GFF3lsiON2cuOPsnrvHUItjt4Ckdm5a8UbxGlQK/EzeCsshlPV0AZBvonzEu90KcZlsCo7vfh1nz8z0ald5MWnsH2Nf04XMNSZ2FJK9FICo/CryQKMm/S34LvHyncqyikV0IFw8Bvsf4eLTiZe0upuM/0bctB7HLkqp9h4B4PMgGPo/xN7EEk+W8o35j6fWCu2fXIqllLhTDzfmXhKGbJYzcr05a
 lzP8Xurv
 B10OdiSPi2afl0B/jaJPvDlB8xOugAaFfKC1cUc2xe8T9Ave9C59nnPTZpcKTBEB5rb2LBsUelScoC18IucBJ7pEtAIXaQMBsDwdL+P9794bezMMDZwK+oPZrbF+EsKClCqKDZdSFygoVKgoJja7m+LE3S9l+peTO/n7rBpd8IpWSVXkxHatfO8wK8msvND8V2CzNctB9gTxr7GoGSHkYZ+HZiocFrIwFYTeCSchpbJF3VSlSN2+tMvFgEmdQ/NhLF2/5QUH+vyiFFlKbFgISChXeoTHehWvEq6pik+kI7kjRou6cSKStzk8OeNrFjz9DNYvkLbIiGjDEe7se+zVTBEKKOPiv6GNlZ/UL8I0aCDW8juuszvbCaLZ5sW2nvZ+whna3aXcTkKkaCj090jygWauRtRDbDovQom/G63tuomdnfsbSpPfPzMvSAQzlyGHgjKsQ0S4Qupt1OvVd0sQTKcvHtAPTTHt5U/uAsv6EsPS21zPHlmTW4qwA6NfjDBLmzJVaU8r7sjVkJiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:47:23PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 10:06, Anshuman Khandual wrote:
> > pxd_ERROR() has been used in generic mm just to print the page table entry
> > in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> > pxd_ERROR() macros have been provided by all platforms which basically did
> > the same thing.
> > 
> > Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> > page table entries thus completely dropping dependency on platform provided
> > pxd_ERROR() macros which can then be dropped off. First move all required
> > helpers in core MM into a header file which could then be used else where.
> > 
> > Although some platforms still use those macros internally as well. In which
> > case just move these macros inside the platform for now.
> 
> No, just get rid of them first.
> 
> The ones in arch/sh/mm/init.c are just supid:
> 
> if (pgd_none(*pgd)) {
> 	pgd_ERROR(*pgd);
> 
> printing a none PGD? Stupid. :)

Will drop them from arch/sh in a pre-requsite patch.

> 
> Then there is arch/parisc/kernel/pci-dma.c, which just open-codes
> pmd_clear_bad() ?
> 
> 	pmd_ERROR(*pmd);
> 	pmd_clear(pmd);

Will replace these instances in arch/parisc/ with corresponding generic
[pmd|pgd]_clear_bad() helpers as necessary in a pre-requsite patch.

> 
> 
> Anything else?

Just one more instance inside arch/loongarch/mm/init.c which could be
dropped as well.

        if (!pte_none(ptep_get(ptep))) {
                pte_ERROR(*ptep);
                return;
        }
> 
> > 
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org> 
> > Cc: linux-arch@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > This applies on v7.2-rc6 but after the following patch
> > 
> > https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/
> > 
> > Would it also make sense to just drop __FILE__ and __LINE__ from the output
> > in pxd_clear_bad() helpers as they always print the same details regardless
> > the error path and does not add much value.
> 
> Yes, drop that, it's nonsensical given that all relevant calls are from
> mm/pgtable-generic.c

Will drop them.

> 
> Thanks for looking into this!
> 
> -- 
> Cheers,
> 
> David

