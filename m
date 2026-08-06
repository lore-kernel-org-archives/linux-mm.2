Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A04AC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80ADA6B009D; Thu,  6 Aug 2026 12:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E25E6B009E; Thu,  6 Aug 2026 12:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9616B00A1; Thu,  6 Aug 2026 12:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41E7A6B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:45:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30F27140155
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:45:41 +0000 (UTC)
X-FDA: 85071420882.23.80E664F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 684711C000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:45:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KXiUMrsM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786034739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrdYoYmL+T5FlaJX6gRMCUi3wWSvcdyxUT0pa5jmJHw=;
	b=n5SALbW90hQaBMv950hw60f6WL+3duI5GVPWT6a6FO+pZi4ciZsVg8JZl77H22BYA561ej
	ljri0r7+ncYezVV99bVA55QAdRdC6RTgEi1rHAtRPVQ+SHVIdIU/JY2VuZ6rQTT9+5ce9A
	SR+RARkk04kQD4dpZ2dgCUilfIiRzLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786034739;
	b=srnDFNif4zge90YewHtIWl3G4dVG1DqtrW1SIpjx/3jTYTPTGEMKu/iaNnkgwO2Z6Z3ZAR
	b+fsQyIP7PP7zFkVStOMW61cycxdDw7ZWzIwcjD2JcAYPgfu4obAdTvpD4PkLreeXe0BUq
	1oJFLu2hBiXhhOPmKSv87vmUD0+jY4o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KXiUMrsM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FE824326D;
	Thu,  6 Aug 2026 16:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80651F00A3A;
	Thu,  6 Aug 2026 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786034738;
	bh=VrdYoYmL+T5FlaJX6gRMCUi3wWSvcdyxUT0pa5jmJHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KXiUMrsM5jdndCIntJReZr0x2HnPjsWH60xKSgXTjnftr76RGmt+1g7fcXDDLukjK
	 bPCbcxzZ0jtr2cnnns6XD/kH1hWiM3agXfL6gkzrLYK7edFKbHKn8OrWZGgLwUdj8R
	 l+OA/n2RUUhf2TbUWue/FxpqOejOL0q9srpQXixktHk1yXx8SMYZCa/CFmzOx7qovu
	 RnabFQ8CofvqZ+0Ru1X+sA+iTaadt5Vo50/XAkzI3Z8GoEtid05wqQs7dM8WKwWZKQ
	 7HqDX1M+9u8v97tat8XcM3cdX4VC40nizoaJoahol3Uuj+LsJy5GSfx0uDXz66GMrh
	 qpb25E6/i+gaQ==
Message-ID: <857ed4fb-7f99-410f-be1a-59ada04d06a8@kernel.org>
Date: Thu, 6 Aug 2026 18:45:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer> <0bd6d355-e6d9-4f5a-b101-9a041c2a2436@kernel.org>
 <2a7686ee-56ab-439a-90fd-ad3c10e4c336@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2a7686ee-56ab-439a-90fd-ad3c10e4c336@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: toyptzwsr7gm4hhpo11u6hia5mw9yp48
X-Rspamd-Queue-Id: 684711C000C
X-HE-Tag: 1786034739-59813
X-HE-Meta: U2FsdGVkX18KQqwHqpsk+jKcY8jpGoePB9ev5U44BmHoURwQMhHdOHUBNMyIWU4VvNpQH67MGIvN+SKM8wledaWu5IurO31ab6FhcmK6FfKs19RWItFERznnFT8diI+zi/HluSxtvgPMAYAwkmrtiBVRmZaGz6jVC33Lq4HN87JM8Ly088FSxrXZSa0AnaiG/+n4N3Ti870zlSEngdR42JllsyloS7t3LFgzQ52ZAs7la+8lAm/sviN5VBAQtaSLsD2Y5C1FMWAO8S2mdkYYxY1nW7jF2LFbPZFUtNm+3PEWImE1QinN/XyFRsNPOz2ap8nOE3iTQPO6BqzaqScVdiCX0j8zbRSINEs1gqtd2S/b+3yNWr9upeNKTGsv1roAGQ+3f+hzWWx4BgU0hd5n1V/halK261RDRV2CM3q809h9bx4MXEfT9jAfo3oMM3LwUZis+mv9xeeMXQ3zyKSpjRlFM15ebdBIm4vt+jPIl6PTvIYb51Bf2OvdyIv1mXCQnpvml2awU/92aWqZXRCucE7C0OcQDbjCae8x5f9orcxzUjHHsfCIkuhSb+vAx1m4H4omy5rQcaxFWGWv/oa1zpV29mnH3u8eHPnjGcwOUhH7eYUtZC1HfPLUMfYmMIZ/muutEbiqDaU2rRCP+/4mDuHhZu8neTsB4OE8coJ4bJ4JV8qPCJ/YO/tCRNNQelC72DPjk8IShS9z5Bon6+wb4Vcgc0/34M/Z4X4DItURZfApcNhRPftlTsOII3VKdcCsaikq6IjpB+1cpuBeaQur6LpCvYaKYCTUiFvojyFseyyOFmTmXgHk80QSRDk7PNwPXEmv7hT3mR+wnR+4hZXyUHwX9qAEG8fipfmj+u+CJMhaH37pvh5iqv2WVadehi1mUMEGfzVR4qTKWFJBXxV9Kx1dxyiaze+IaPgCkkpULfCDDlBem1wAKEGQJrZngzwLfhlVAwvE4o54b8eD+Cc
 h6cYHxiE
 QKAXFZd3o+s7nJ9If1fYGnvupln633NrwMhK539jDwATHptiorn+PizQwaMejZbBMrmvTVyVc+xhtjM2pxnYErN6HGYyDJ+753uBi6q617T422+/VlsHhsf2nE6VAbCXuxsLIYeKz+PNcbpzpQNitNsuaCiP7ti5sTIcHc/VFM02Rn8JhegaPBSi5H5F725Y42izvOC+uyg8mo8tL+ju6ApCRWpgAWP/oFmSAatRDnbRCIORBSzYcFhNE9Dculx3hbAGBmWbwmuBHcAzH7nWc6ySk2hG7l/qEFiEiCj5Tj/AKVUpahtd6zm1A360rCjxj3R4tMT+7s93PhxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> +static bool file_vma_honors_thp_toggles(struct vm_area_struct *vma,> +       
>> enum tva_type type)
>> +{
>> +    const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
>> +
>> +    if (forced_collapse)
>> +        return false;
>> +    /* Huge PFN mappings allocate no folios so the policy doesn't apply. */
> 
> So, may be rename the routine to file_vma_thp_policy_applies() ?

Also a possibility. I'll let Lorenzo handle this.

> 
>> +    return !(vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault);
>> +}
>> +
>> +static bool vma_thp_toggles_enabled(struct vm_area_struct *vma,
> 
> This routine could use the same 'file_vma_' prefix.

It's true even for non-file vmas.

> 
>> +        vm_flags_t vm_flags)
>> +{
>> +    /* THP=always? */
>> +    if (hugepage_global_always())
>> +        return true;
>> +    /* THP=madvise and actually advised? */
>> +    return hugepage_global_enabled() && vm_flags & VM_HUGEPAGE;
> 
> I would add extra parentheses around 'vm_flags & VM_HUGEPAGE'

It's even required and the compiler might complain :)

> 
>> +}
>> +
>> +static bool file_vma_forces_order_0(struct vm_area_struct *vma,
>> +        vm_flags_t vm_flags, enum tva_type type)
>> +{
>> +    const bool in_pf = type == TVA_PAGEFAULT;
>> +    const bool smaps = type == TVA_SMAPS;
>> +
>> +    /*
>> +     * Enforce THP collapse requirements as necessary. Anonymous vmas
>> +     * were already handled in thp_vma_allowable_orders().
>> +     */
>> +
>> +    if (file_vma_honors_thp_toggles(vma, type) &&
>> +        !vma_thp_toggles_enabled(vma, vm_flags))
>> +        return true;
>> +
>> +    /*
>> +     * Trust that ->huge_fault() handlers know what they are doing
>> +     * in fault path.
>> +     */
>> +    if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> 
> and there remove the extra parentheses.

Agreed, that was already there in existing code.

Anyhow, it was mostly for inspiration for Lorenzo. I should start spelling out
more clearly in the future that this is just a quick prototype, because recently
people assumed that some quick stuff I post inline would be complete or even
tested :)

-- 
Cheers,

David

