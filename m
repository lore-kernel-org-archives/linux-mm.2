Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890BBE81BD7
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A766B008A; Mon,  9 Feb 2026 10:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48346B008C; Mon,  9 Feb 2026 10:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29A76B0092; Mon,  9 Feb 2026 10:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A16206B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:47:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AD751C0C9
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:47:05 +0000 (UTC)
X-FDA: 84425346810.13.6D9B3D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A5BBC0007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:47:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cSvFRN/m";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770652023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LxajV7omcGeunj6GBsaCyyVxjfYfSaMTELmHusuTZo=;
	b=2MQlO54rh2uh85wh7daRN+St0mBHmOwiPEjEU7zaZnB6b9m8Zce3i3H/on5uvWSpsK+Nsh
	FklD4iR6SxpToReWgsJkFo4ralafr7lvldAmwT10jKN1JdiV1DaUwhMlKKWcuyHcKMN1F8
	7ip9FCpNDf84XXNPBQs0lkkS5N8w5/U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cSvFRN/m";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770652023; a=rsa-sha256;
	cv=none;
	b=h9HlRd/EJRYQmPzq7TJkSvnnwwTNygjC9W6kogTUYy3Z2M3JrRoGxvzhnsiPXlHWrq8xhU
	ivneErXYKbFuexJZOqlkW78z0GoKSSuQS6iGGWULJ1h5THjYWhUrVKlctJ6rI3BzHBnpt9
	mUpkQq4KM9ui8ce/XSlBVAxMyZk5oz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A84443619;
	Mon,  9 Feb 2026 15:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3552DC116C6;
	Mon,  9 Feb 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770652022;
	bh=i1KhIFKAzZ88HWXeCTWKj2Bx3h/vnsanclghYBtvs5U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cSvFRN/mhHSAQXCQEMuBxWu+v0Tq1/2HT/clHFDF4YgQHodKBT3OqePuzaOO2/Sst
	 2i8N4QjsHT0BgxxEdFh2MOYQHf5Zshlgxdep53NV+H3sVhpjyv4asGgBLtAwmIQnPB
	 uFDh98MhonM8FQeRS8h82RS7R35Etn9fHT29gX7suGrBEj+KYRHZBTnnKo+nuesbt1
	 nyEEFxOxVrWjpW0l6bAnyN3aNWZ8PcdDYcEfTgqUm1M5SYx7+Qr4GAsAztVu99iTgV
	 ZMWMDBAZ9+tRdKVYuVgQVNUhTLkloPXYv6vqQpPDQrOj+ZuVY+UmJrFidNIO5NMZ25
	 TPQHWkLY7hhxQ==
Message-ID: <c0b93b3f-bc4f-42f6-8287-72d015a0a79b@kernel.org>
Date: Mon, 9 Feb 2026 16:46:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Vlastimil Babka <vbabka@suse.cz>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
 <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A5BBC0007
X-Stat-Signature: k1m4mpsmybn9z7kicnz57wzh16ddm6od
X-Rspam-User: 
X-HE-Tag: 1770652023-104892
X-HE-Meta: U2FsdGVkX18dmkG5lNxV8au4LDYOBd6Hocc9Kk8Sn7HnRMntVhTB5Ps+FpxsHNcw42Z/JXqT+7LEj8WeieYCPJXbFvKPIpYrb3ZGcjfTmqtcJd7UdveNRAH2Xn4MDmkw2cTFLt5uxJhIVyg7h6Sj44k2uNjaFzvTRBk0u2PjDy11nzHhuxtHJuOr0Ne3bYSRYrbmadJInlGlc1uP/KVVEZKzLCuFoZyjZXJsqbLN92toiAPsUzS9wMtwWpxcAujb4odpKaYXXyNs6SIudotAeopD1gAOFIJFVpIouj3m3FjhXD9Elxt9OHIka0FoZgVmf6ppea6MsUgwGntnoGUSdY1wFb5tHcHuEq3170R9hTL5cS8Kk7HH1AsnkVSx4ZetGGIwKVzplM0HgsKan4j0Uyt42SROxleQNK9lbQ5ZrP0mbecuVyc1t5WLpHOBKSvkUf4JkTFUK8azu5XDqTUplqYYdCfPN162VKBd8cUdsdG7qKHbnCC2oTRzcNuyiQ36Ficfi4BfbXm1snqqVOh+Wk3X7g+g8FDCPtkyiozZv+DCIq3+VWooDbWIiQ/QO5JG7he59+2s9219zsTQUTdfeLim+Xr5lbvWXi1voWguGCuw8E6rLmTcz41h9K+Nyt+dKLLzeVwmXI0bYqUZOvQ3ZGMToOItMY/Eu++W8gkModjwMkCK/71f8LqKY/fuQsmsYEBpJk+evqC8mDE2Dq7xSER/jRZ6Ub8ml01/f7C8Pb0ySkZgKVubj65bBTdm/cJVejm2edv36IiPQm82ojgdNDDildwuuole1H9empGfEKq6isAYCMe1Ym52E7T+OCfF9gx/fP4km3aQovY92hgtAsrmCpZr8rl6doGDlnw44Ce6cBEff9iBvCU/IFAs5gEc5nNIgJT4HjAMuVE/IYPkEu2ePIwgugXDK3mJreEnwPVeDKSCJaZrT0c2Y+ZZ3Sa+h/kaB1hIDgia2JVZ+Ox
 EUCOT2/l
 aJTLy2UD/P5TwuwjPy+CAaw5U7pCMpY5eeN45Xpy0NaGw6596ApsWYcYmGp8dMHSYinV9Fjgccx3zSSqkR79NvUK/0h2i1cPZ8/kWvFc4iHDXiTjBd14Vf4tIdrbhAnRIlExKb2rpeM6FhTkofCS2ck3ew6qBllVvqJyZaQZb5G/S/JDP8Z72mZx3XZmfJNUGMAFpc43zLIHbin0VdG7a4fSr7OvM2JD1qSNQrLhJowz4nlqAb26kFhF6mxx81dR7W5rF45UydOhonjxgRTIfQ7Ldwl8mjeYw0itiCDRosEcjVuhQlAoxqJkj1VzpY0dv9Xw5yA2kM9xGdS6lmiXKod0cr+yCr/nlQCUAwkMIXjJIab4poMPtSRpymj+Ttn0Q7ia5fU3IelhbtloDt8MpflbpfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 12:17, Vlastimil Babka wrote:
> On 2/7/26 23:08, David Hildenbrand (Arm) wrote:
>>>
>>> -               /*
>>> -                * page->private should not be set in tail pages. Fix up
>>> and warn once
>>> -                * if private is unexpectedly set.
>>> -                */
>>> -               if (unlikely(new_folio->private)) {
>>> -                       VM_WARN_ON_ONCE_PAGE(true, new_head);
>>> -                       new_folio->private = NULL;
>>> -               }
>>
>> BTW, I wonder whether we should bring that check back for non-device folios.
> 
> If the rule is now that when upon freeing in free_pages_prepare() we clear
> private in the head page and not tail pages (where we expect the owner of
> the page to do it), maybe that check for tail pages should be done in the
> is_check_pages_enabled() part of free_pages_prepare().
> 
> Or should the check be also in the split path because somebody can set a
> tail private between allocation and split? (and not just inherit it from a
> previous allocation that didn't clear it?).

We ran into that check in the past, when folio->X overlayed 
page->private in a tail, and would actually have to be zeroed out.

So it should be part of this splitting code I think.

-- 
Cheers,

David

