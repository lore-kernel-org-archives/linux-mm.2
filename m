Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 797C0CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 04:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47C88E000B; Tue, 30 Sep 2025 00:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F728E0005; Tue, 30 Sep 2025 00:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B359D8E000B; Tue, 30 Sep 2025 00:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A12598E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:37:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44D40C057C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:37:35 +0000 (UTC)
X-FDA: 83944658070.14.E0717BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 305A840004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:37:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759207053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68SAHMrP3cyjiZZS9QDhn5k41wOUinZiJQpPd+ixALM=;
	b=LborGV+56yDQuGHvARzEvMwlDqfWVGiGczYkPpFvxwutvGChyVK1fQtYd+H9z5igndn6me
	R40IBT9NjkDqJDUFxvbo3z53hQ/vkD9MLvThPNHyllg/OAom4zym8pYpDzSkOCb4hB525O
	ly0XQcWs9zlf8pH3cGwVe9aUrinYCOU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759207053; a=rsa-sha256;
	cv=none;
	b=zC9HU2fTkcEY9RpKfrN8siDqf3aRfK3fYK+kWZGveTLE5+n11BUg+2rlGFqrhGE3uCpqW2
	msv99aaRdLAuy1QRR9AVyDsfHSqoZeOmzpeHS6Vr4w08RbysZngWOtx95P/O2LPQDt4mIY
	JoXhkVlpvO5oSogkvJkcK0OJkLd1ods=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1D331424;
	Mon, 29 Sep 2025 21:37:23 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 433023F66E;
	Mon, 29 Sep 2025 21:37:29 -0700 (PDT)
Message-ID: <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
Date: Tue, 30 Sep 2025 10:07:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250930025246.1143340-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 305A840004
X-Rspamd-Server: rspam05
X-Stat-Signature: jdnniriz9bpb4hxjp3go3w33gq6djo9q
X-Rspam-User: 
X-HE-Tag: 1759207052-27408
X-HE-Meta: U2FsdGVkX1+fya0XAJaB7ACzjsmjZifEcGiyfPDfG/Q9N2c5jn4blsOPpNL/OcDvIPCgXc2C4thvMvYgCQ/QZjc/rP/mf1h/jJQ0/2cC3ZWGBay0EgBtZThPru6ILZ9gpNdRo9xYBP3ZP23/BKJ8vEQt/DPNtWzzwAXReln+UzRjjVproiBn+0411skNvSw9MAbx1s1a/J2TC3bUSAntTBbkXYgdsHZOfTTxCLtyzV17j0pdUzyP2KQ/0+yrFj4AqRxc3DVRaBpji/W4FVaeoawoWcKPNBmf+NIhhqxU64RGVx8TkN2h3bwi31MC2OimL4B5Zc0jSp/NvROdOGJyJimk+mB6kZ+UzIgWAmkVe95kZUPxRqLCzMYJ+w4detGyeE+RAYd/f/zzj3LVhzFYjKiGqcf74ZofbVgswVdK+H/tta65/D04Wn4AENlioMuNRJuKxO3ELZkL9uwY7oEcBm/U2dxD/u0t9Cm+dMEZiaFGj7idKeJebLJMlcciCPtBlhsKFxm6Ok7p2I3DSqiFSc9hgU3piD82N7Wm+gA/Y693fxG267gKCTTrV2+1S6HIFRM8OHT2LZfCPQ4UV1/1ehQ40qGh12XtGOW469aOvxI0f0NY3WGOJqv0NmoriK7LI3cEiZL6sW7BKwMv0KrOJ4QgkE7yIFqfyk+ClJbfqjF5K/7RQTf932q5J+FuxySSAwebl0TOH7Wt38l77lyy6lF3UW7UiIH81KjBjkmlqv63W/3uOc7uHfyQgqYWXHS/7+H5cTEco9yjnLndt4z1h8EwpFe8kr6mAAYsFGz23qUaV9dYqmTThXZteLvSMRtqShdurW09vkBNhGrToCtEFZN1jqff6U2zalqE26IUJUgh+H9koWfmxgGc0YjYvZPPGjgQWRUA6kFJ2rIOQUvVOxAy5/7Ynw7KnWIeVPRUFneaWvF4PUEzxdR2cIzt5MJ3Rv97WbCKL6ukVjoM1fu
 T57JSZxf
 8mXUZ5A2LXxSTHkAbrLfj4eqFuT3RRfjyKBDUzIFAB8Fsx9HbBESNrU322NltRFYn+pewDBw7icnzH1XudWEDmlUPMasNBtOLyHWR7q59PxBECp7a9+h2DQVDDOs9kKJwouGok9cFo4YEbuXrpodyxo93I9R5MTTfjslBctxLnTL3u7bFwE9grPghORbXAcnjPJckDfhxyVKFQfb5rU2yipp0B4CxxZ22VS/AIoY9pgkxZxPMmxmtMUStHUxttx3OBQlmov0fHElHZPaEWE3LH95h/HkV1S/6i52FuXa8ckNRPU4sfQQ2KQvp7mY6It+egTfhocYteae1bZJDXakFOxACE7l3OP5N0UiQc1K8xbic8Ki75JTdcjxTpnE3mfWd3KeOfbgOt/wab3aAoMOfbtn84sKxvV8QwCS/WIaj1CY1dBI5CEM4X4c1+dvHqLAQdwMF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 8:22 am, Anshuman Khandual wrote:
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform does not override.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   mm/ptdump.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/ptdump.c b/mm/ptdump.c
> index b600c7f864b8..18861501b533 100644
> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>   			    unsigned long next, struct mm_walk *walk)
>   {
>   	struct ptdump_state *st = walk->private;
> -	pgd_t val = READ_ONCE(*pgd);
> +	pgd_t val = pgdp_get(pgd);
>   
>   #if CONFIG_PGTABLE_LEVELS > 4 && \
>   		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
>   			    unsigned long next, struct mm_walk *walk)
>   {
>   	struct ptdump_state *st = walk->private;
> -	p4d_t val = READ_ONCE(*p4d);
> +	p4d_t val = p4dp_get(p4d);
>   
>   #if CONFIG_PGTABLE_LEVELS > 3 && \
>   		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
>   			    unsigned long next, struct mm_walk *walk)
>   {
>   	struct ptdump_state *st = walk->private;
> -	pud_t val = READ_ONCE(*pud);
> +	pud_t val = pudp_get(pud);
>   
>   #if CONFIG_PGTABLE_LEVELS > 2 && \
>   		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
>   			    unsigned long next, struct mm_walk *walk)
>   {
>   	struct ptdump_state *st = walk->private;
> -	pmd_t val = READ_ONCE(*pmd);
> +	pmd_t val = pmdp_get(pmd);

I believe this should go through pmdp_get_lockless(). I can see in pgtable.h that
some magic is required on some arches to decode the pmd correctly in case walking
without locks.

Reviewed-by: Dev Jain <dev.jain@arm.com>



