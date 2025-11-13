Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875B8CD8C85
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7048E0007; Thu, 13 Nov 2025 10:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97BB8E0002; Thu, 13 Nov 2025 10:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4888E0007; Thu, 13 Nov 2025 10:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA7188E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:35:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68535140A5F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:35:09 +0000 (UTC)
X-FDA: 84105982338.19.0EC9649
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9AA7F1C0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:35:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnJecusn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763048107; a=rsa-sha256;
	cv=none;
	b=P1jeRezjkl1wk2g7GO7S4bgwwEDMTe9HyAIWszR9L/odYpUB1r6ihtt1m7+Q4WoXcR5Ytf
	trAH7j86UtNuCKRBa6o7LLHCoMXlB6HpG9pX35wH/IaqQ7jn48GUQhQhsNY4gbtKNJpr9n
	El27rs++rIxMOXXHLVtWDEL1r0YooCY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnJecusn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763048107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IK5hVKBuYup83/+4gA5HIMijDseuiCK7bbzyJEMS2FY=;
	b=W60grF2/nwjxG5dU757AbQUc0Jf3hkgsJKTzttpf2ZwXbRGnGlX06wspSUJumgjeiY2xTq
	TGyLIoyD54m2t672upHcWiyrap0dmUC3HNjBiPrK7aMd85dW0OWIW/KgB+s4br2xpIcV2V
	sdTg/MCnxUCGf6DWUF/XV5ULi0HVSx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98F57415EA;
	Thu, 13 Nov 2025 15:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD89C116D0;
	Thu, 13 Nov 2025 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763048106;
	bh=D8WvGXX9KYt11CApC01Q8d5gtw7/8hiqu4Qp5u8lf8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZnJecusnHwdqsuJ9fbtwY58AijXmd8yBp2s3PG7GblTLfdAVe0BzB+hDsCeDhQxYM
	 Q6yPcbFWMbPTp5DYk6rFubx4vveHj8UFpn/BNA+ukh7ZCo1CIY/fFN7O9la+spfyl7
	 P5HrVepyV7con/tRe03jqW0qXxGI2dREqYJZVBfefH4pyhT0hDvwRoE/m3n6nyiYQx
	 B8BKt9bU5Fr18+yKOcRD2bGDsxs6YLzGfL6WqheSjoIb4U4k5v9IbDLpZNMT+2vBGn
	 QDck2fOXy+RYPESEGKClI2QzpvAYAFueHEPUcR4CWisMdNnjFQE1B4eMbTaVGVb/a1
	 ma7sxp2ysUfbQ==
Message-ID: <73552a22-c7c8-4106-949e-471b9a7bbc87@kernel.org>
Date: Thu, 13 Nov 2025 16:35:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
To: Jean Delvare <jdelvare@suse.de>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20251113145636.731a24e4@endymion>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113145636.731a24e4@endymion>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9AA7F1C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: j49mksayaczyjzsauwk8bmcyotz6aej8
X-Rspam-User: 
X-HE-Tag: 1763048107-842102
X-HE-Meta: U2FsdGVkX1/+OYfLaBVHDNHwo/nZXQMCimA1S02Mc0m08NoW/vFpbk/12JUfo2no279rL4tWvPbgDfU3RdvtIbifUAtRak+5KWvqvaebZq99pqlkRyVOMwPfJqXy2gfi4AXI6CKmgBN2e5iIzFnz8qXvUuzXjSxsaWAXMecIrySHaDB3C/6lJDKcKKxy0EhXrxjxPzlDscPjjCCgEDU2EWSw2uV6K82LmYMxkvtm8lleHjq13vwG43FeCCCPGaupmtGSoEgxCZOX/UmlEK1gRqsKjCoABFBonD9VJ2r1v/hnwZkoAv9Js72yJRoN2WBkoTWKTjofBG3KYpgD9uaXkXoU6Bg4n9kYa0q7urNhnPUcWG+IYa8mMlnJLousfwktSdQCXV0WOdZ6FN61AE61GeCWeNeG09pPoviBFAGsUrQtyoc8hn6yWrpgn2R2Z6rlGxt9/O1w6ODSXqSM5nAADuWLNeUlSPkSBohAPEJ1k8TL8nIxrsUWpbVlg1mYZ6TBHUOf9JZvkkeySRSjzz1OqY/hqqYwjEWjJLJzhAi1PoN/FLLAg5SE8JpzH/qskn9qhBiJrTUtbIowYvlOAEaFymsu9+exSo5GOuSmcgg9dgD0iJza87LV+LC4ySzWixAhH285w4nQLgdofOfThqgb4Ykx64ql93+z80Z5TYtXc5wTyP8b2Ob1qT6vFWNVXyN2/exZtuSVAKzBZgYQV7SLw1RB7Y7gr2IquMeKulcsFL7hwzBBiYN2fjBUisGst2/IB1UjdZ3+UKQOsQbvWN9pYd0zduDWurLG5sNZFmd7X+ZVtxUhlD9hiiOcpbAXJWpIeY8ZNC6D/3BGCArR53Ypv+k1p1KM029jBZaYNxTf1zjALHfIp1SAZlUuBv3z8RCy7Hc4F4OizonwnOrGo43Vw7L+fG+AwChuPm5mqrd9DUuOJJzskThvAv39FRCcWDxnm/AK6RtXpy4/uw1j2E6
 gXU5hbnB
 SCO9hL72EroKlpQellaAzquW0eVDAcCLKTxlImFe+o6yV6anHWkThAYDmpcilLXkZWSfRod4gXLgbEzvHTcfZsDJpS5/prjHTvj84NZDEvK+Kdeuv0KylQWnII3WPSZsE2fwOOg7LReh+wEbpQgMSU/3JPa81AfVDUm71PAKcHDkAQOaEVPbSR2bjFIIJG3i1oyUW5VLyZTuJpOmmFFg5BpowwM2ceklTdWKcLaQd12I1ddUlr6HKeJCOMQ/NR8fbVJVaZA1/at8k7ggnhoaGzb2hktP2FH5RqgEme6OlWjGZCRIMXmGw9isOn/xNU6d3l7tuHpk3J421/psyucGbeQj4Ah6w6zGSwUZqj7y1JF3Af2IAKkpPMCn/DjrtSBIqIA61
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 14:56, Jean Delvare wrote:
> The sysfs interface to CMA has a marginal runtime cost and a small
> footprint, there's no reason not to include it in all kernels where
> the dependencies are satisfied.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---
> As discussed with David:
>    https://lkml.org/lkml/2025/8/6/371

Thanks for the reminder, it sounded familiar but I couldn't remember 
when this was discussed.

Hoping this was properly compile-tested :)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>


-- 
Cheers

David

