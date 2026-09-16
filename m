Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9555CC982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0096B0088; Wed, 16 Sep 2026 10:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B396B008C; Wed, 16 Sep 2026 10:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6229A6B0092; Wed, 16 Sep 2026 10:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEAD6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:30:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACF5180565
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:30:13 +0000 (UTC)
X-FDA: 85219860306.15.E175A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D1BA240009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:30:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZbOE9AMC;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRPwui//DdZeQJe3FFPtKCePfUSwnp41dl+UxM2JXEA=;
	b=TI4I17plaWGPRBbwi+OlVOIPsrtOtfZ5osxkNR5DeeuU62o9/myBA97ewHHydWyL0FsB2c
	GuoDz/djXfQYmEkw1ywvAmi2OoO1UV1EDjY3Dpex+v8w1VxEXKJEI0q3dHk/jxejffStLJ
	l/c9jdXdma7goakZHpOfhYpZmig7HL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789569011;
	b=d2ZNRVTjBpbQJNH2yRTZFQuNAlMVcwVHWSR1oiv5uoiGLC459mWbWwuICYj+vHdbsFpmZD
	WoRkBL85nBVK8gsp0TxMKmvL//nymhIAMe2siMnbTisUbcQQAvMPf/P2JPy5r+Dut4aW6a
	uVzMtcxIYGaYPJzdw4U5fMfPp7Sswxg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZbOE9AMC;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA31E415CE;
	Wed, 16 Sep 2026 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B581F00893;
	Wed, 16 Sep 2026 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569010;
	bh=nRPwui//DdZeQJe3FFPtKCePfUSwnp41dl+UxM2JXEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZbOE9AMCGmYoHwYcnarKJaXI6uAMxVQfXWxur+hh8bApx/N3MdVr5/9UMcQ1tM+lH
	 dJy3cTT6U5b5ws+hkUqJsIfENsyI2AryeulCzNceohcyJfzupz9grf85us2YvbYJ/K
	 MlGiGPzwHqcXqUSm7I+vH309ANU2K9p8XP/Yc+Qi/4plXhBPiZAKdg9+E2Uh7ENeGN
	 bX9r+ZMUodz3EJowHmZFAJJOdkM91PFDKp4pMubfLfeTPq7DXJSuba0y5bD6+MvLy0
	 RLb2ZHvhBO0F5hoFNWgKQX7x+PiH3sePCO+ifp48KfAnQMTo77S/eiZnO8rJSYNzff
	 ijUhgnLsqNusA==
Message-ID: <be1c0a62-4589-4fe4-a500-d3fe16a6e610@kernel.org>
Date: Wed, 16 Sep 2026 16:30:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 06/14] arm64/mm: Enable fixmap with 5 level page table
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-7-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907035030.2839978-7-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1BA240009
X-Stat-Signature: wz9bgtimkmc6a974fmmae4atp8u6qsq7
X-Rspam-User: 
X-HE-Tag: 1789569011-36691
X-HE-Meta: U2FsdGVkX1+n078i/KKhH6v1G67ZH64xezTVxDvHY//xeTQZGdpFXlbfJmKopfck27BAvWK1xip0SKgrorZd+sG85hKpUpWeSuzTHuI/86JLtC3C3eMzHIfGUFpokgzU1V3n4hp/4aRIOOg5RoUwMpLk0VmcgWGNd2qS1XN4Iitddlj0IWl2K2Cu15wPhK8fQA/xz4poe4URA3a4+z7RUAH327IbNlB+kSIkJSqNnAL5BYspcw10HpYkXn8CzX2z9LO2OPJUCsryR1mGNXY9sRiPPOb3g1XuggWioOjRGlcQKLeVKdtSavcON0VQt16bYLxh9HLPamxEFIO5e8iTu5u+mmueGnbZdmJiCibHKb0hvUq6jVU9hSAuzDZRZqTe7K0SItTvg35QYn5UeHDpLWCUYlDhP0w7CZAAVtIXUaYzEVhDrOeqEYBr+lT27bfFNGMwGLx7npZdV/rO2s8fP0UZRJZR+OD94IWf6CkWu0L7lMjjQ2xYSmKkZQGTXbRRKwSpqPRbZtSq0RCFCfzycVV1RvjzElAhSM30j6j01AchUcZKbFijW+/f63+G5qScx3k1lTi0vfhu7E2S9g7k8XWYwp+QcufCKMMhDxJyfeqqz6VOdSjKweZAEfq+tyzy+VNDrUNYPCQZvSOoeUwRfmZUVxyb5IPsmk2Bt+qJ9qRMyKdu5ZRpt2RduBmB8hl30oj9r8q24cCUV2XnprKqH8+UUktYboFgaX9CNH5vqE2b+xtrj37IqPxhyIjNx03W/axoe2MamVhQ5qUILaMVDQa09V+a5JLR2BuJHlUCj6riSbptKqaiPuu97IbtxHITNvyudVttBNZQdO4vfSuDcW/vVBkif6yLRof/TE3MPXw5gzurdD1r8i2xsguX6lJ/CWnPUkZb/ztkD/zjNgPdfLxHsA3+i8a6KNkcRjlMiTBMtJQri/zz3Bn47fGKaxyKvm1DAxw3O9pMCdG+aA/
 /RMmhzpo
 9sEmpqHvap51oic6Vd3ATg36YwkmrNxDSS6vc/KUNWdksJCzznBJNh5jUDzWMvkLd1tQJ2IAE0YuhrwS5nSLHQTjNthm/C/4Us2WczqpR+XxZYC8dneIEUFjVvungnefAvIh9gAtmkRwHCUogFpn7x31fZeZoqIxMe6jNCAMnr9WPLmUphnxcBRx5/ozNn+/ZrS+7Pc2yPCXWxK8bG019ecINsOq8AEUsNaGAXaEOBQnPLzWwYkAOIqVuoAflXu2JR5W5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage
> for each page table level. Hence in order to preserve all existing
> VA range configurations, some geometry now need to become 5-level.
> 

Hmm, wasn't this 5-levels before, but other code allocated+initialized the p4d
table for us?

I mean, I see how we are filling in another level, but I don't see how we would
reconfigure something to use 5 page table levels?

> Since fixmap is used to build and manipulate page tables early on
> during boot the mapping must also gain that additional level which
> was not required earlier.

I am no expert ... but I am confused :)

We do have a loop only in early_fixmap_init_pmd(). So we cannot possibly span
more than a single ... PTE table?

> 
> Enable fixmap with 5 level page table when required. This creates table
> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.


Again, I am very confused. Is it really just "As the page table layout changes,
we might no longer have a p4d table pre-populated for the range our fixmap falls
into. So if there is no p4d table yet, populate a static one just like we do for
the other levels."

-- 
Cheers,

David

