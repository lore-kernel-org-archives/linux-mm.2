Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB67DC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53C56B0088; Fri, 28 Aug 2026 14:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05826B008A; Fri, 28 Aug 2026 14:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B096B008C; Fri, 28 Aug 2026 14:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F17D6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:10:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC14240549
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:10:37 +0000 (UTC)
X-FDA: 85151468514.05.4368D44
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B6ED14000E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:10:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Hfv9UXjP;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf26.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787940636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzizNchr6WnEaWsbe0WIg1KOHaAgm5LlG9gDnfa/fI4=;
	b=zXItDAY7KgpTlyVqqM8BjrGeYA18yUBKXurJDuc22GhcJpu++hNr1ZmrWWXu16QUGzxDrM
	PXyqaIsM/KobFqQWiSu/xeyuk2f/zZyi7YsOA/lnz1BuBty6hledYCWURJcefSfpMPjnDU
	eyIXAcQcjx0z1Wn6xp0nNS+qXFXbCoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787940636;
	b=PWkdW5wyasybxk4L+ZznE7i2dicIbMSZ/6c5dPFJl6+7UOkn0YRHT7i2IfYLARMBhjLrxg
	1Opn37LvsglEYtGtssmkG9NYGwZNPgL5d3/u2P0Tjyekvk/4cdFlpOuFFxcebq9vyJlRZj
	xl0E7UVN7Jl/ugheSE0Jx9J7mq0yWkI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Hfv9UXjP;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf26.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1787939888;
	bh=zzizNchr6WnEaWsbe0WIg1KOHaAgm5LlG9gDnfa/fI4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Hfv9UXjPmOUtgcQtvb1YSLWhrJEmRWTUDHoGn35sr22HLK99gkqUmrIQgnXIe74tf
	 c0ms1s+RL2mYKdzhKgzGn3fjvGc9NHIm3aGHQszNLp1xf8fTY9ZP3JGn6hiPTu9ui/
	 nNhN5IWcKtnHfyP3r9d88f8jc0Wnr1VqtKqIcHyA=
Received: by gentwo.org (Postfix, from userid 1003)
	id 4BCC14046D; Fri, 28 Aug 2026 10:58:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 4927B402A5;
	Fri, 28 Aug 2026 10:58:08 -0700 (PDT)
Date: Fri, 28 Aug 2026 10:58:08 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: artem.kuzin@huawei.com
cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@kernel.org, 
    ljs@kernel.org, vbabka@kernel.org, linux@armlinux.org.uk, will@kernel.org, 
    mark.rutland@arm.com, liam@infradead.org, rppt@kernel.org, 
    surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    wangkefeng.wang@huawei.com, panov.nikita@huawei.com, 
    yang.shi@os.amperecomputing.com
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
Message-ID: <f47c0ab3-6d78-fcdc-b7c0-cd3a7b5c8276@gentwo.org>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B6ED14000E
X-Stat-Signature: q7rioj5eptoh19c1gmmzphzacw8oefqq
X-Rspam-User: 
X-HE-Tag: 1787940635-573591
X-HE-Meta: U2FsdGVkX18CdP41zGLIVlvDZFv6rGy634Vw9KQQY/bK/V/NZUBQndEGhg6zoQU82CYBD9hnDAQcsVsFjxjwyHh8afM5X+30cbAqoLDvrpa+9kMNJvG9ns5SoOYpObu9dAMX0IMGD/BcnD2aCyRoHJKs2muSb4p89ihldKPbu13D2ova2IMbc81BT8+n6Z8WiEhGvV89Gacr640fDgT6bqRpPkVce5LMLyiGJbmTnUizj2HLugFjm5p9bURwpsLyF/BjK2z4Gqwtq8JZo8OzHCjeZmsdydcVrw2YPIpxGertamWaXtPj+EI8VytlL7kmbf7gUQ5/WND+9bem4j1+1xDOfhCbPEbefe1zlgf01YP6N9Th2WiOpPT4w/yaxZHtbp82s9dTV5fTeer2fO494OajXK1nkrm4/PPuv28dLCJUePp/50lV46keZqPgMzOl5qVnoAGBDwCmBYIo8Q+m7xwrBoi9mWHf/Aug6m3XChHj55xG/Teq1Re0qQVnWbg7S1ZDuLlFUKqI7kb1NSeDrYZ2UlvhFEUgucqI+U+hn59sNDcqcaWpuCe0mZhROuRP1WN+METTrC1xha40J1bNNWiqqAxYD/k2b4gt26AB+zjfJrerpi3AtwgRaeVGFxQ4GyPXU2bk/FX89q4SiUCn61Y8n/lFN77C1B+kXJw3Gmx3hpW3h0F1ZfyMS9KCDJQ8Jj8peQsnWhQyuuUiBM1INBDQN8wuR+XYhCAdTI4zXLZENuXpZk4rE+LgjaXIdybgN/d3e3b7/h4ncjSzh3hnj/DNL5KcSarGT3P4DbaENQ3GhZXkLjA2dyeVmgwcRIAM0ac9shuXX48+Vam+c30UWMlQBWKVJ8zHytcG6xPMkdA0VKE/6S8ZMd1LsgkVCCG7aD5hY9rK7YVljQqYmQoZuN02cI5qH0v/Uqi4+PFPaZrx40GCXFQ6TplYC03Cf2RbaPFfNZcaS6dknJtfqJY
 vKaAm/FR
 Bl8uvcD6ixdUF/A+FvS4vJYw5yj0ELPOCaT5++3Ta6l45x0/+yReABSUmouW1gIxqumtQy5tlbtinxKMjfYwM1eIni+KeT7yXX6T7tIZfUP5JVwbmRrpwKrYE6kJ1dmVYzePTfp8batWXSTIQJyBrXLW6OX2bFlkF2k2cyOd0Fu9cznIyhMq/xe//A5dHIwDRZWAJ0Mi3zzhQOw64TUFj08BtaCwaTW6fvk+xsmAzblYKGZfLjDAHEs7L3ChRQLBtgSDMJrAg4ksQb1eqxX5CwzVC4puVEeiaf3zhGrj49GqSauGThw+Zgnk6DjgRvHZYtmdc/E3PRLGeZ6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026, Nikita Panov wrote:

> There were several prior submissions with some sort of replication
> for NUMA systems, including one from our side for the x86_64 platform.
> In the last couple years, several research articles related to solving
> locality issues on NUMA machines through replication emerged as well.

Thank you for this work. This aligns with our efforts to increase data
locality and the performance of local data access. Yang Shi has a patchset
that introduces similar code to be able to map partial virtual ranges
differently. His code may be more mature and I think these mechanisms can
be used in a straightforward way in future iterations of your patchset.

If we combine our efforts then I think we could be rapidly come to a clean
implementation that can be merged.

This is an obvious signficant performance improvement that can be readily
seen and that is why we have the variety of patchsets being proposed over
the years. As ARM64 matures and is run on machines with larger core counts
the urge to have this increases.


Please see Yang Shi's patches. We can provide resources to push this
functionality forward and have seen significant performance improvements
with earlier approaches like this. There is significant customer demand as
well.

https://lore.kernel.org/all/0344c559-1959-4531-9265-d5a5180eb7cd@arm.com/



