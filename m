Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE74CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2860B6B0096; Thu, 18 Jun 2026 05:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CF26B0098; Thu, 18 Jun 2026 05:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172F36B009B; Thu, 18 Jun 2026 05:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D25D86B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:37:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 497951C0B5A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:37:18 +0000 (UTC)
X-FDA: 84892530156.26.4DF69E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7130A18000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:37:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqcFCLD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781775436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQ+VdzkNIT8tHhjzl6siQwOcdm316deLyyLan0NDdjk=;
	b=Pbp3IpRbLEdR2ylRyNiyCGAwYpBsnSV7Yo32EetxFNZrpol5NVi3Z7tYHkchimygBj7FFc
	0OQxxmmRvwKejwxG6VpHM9uNf90z5z8B/QInbMcToLgc+JnUUgMqXBYJf51VyIYvMln70G
	SvP0Kx3V10K4k+fjNntg51K/nHsk830=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqcFCLD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781775436;
	b=cKrPkJEDyNmZXSxfb12kO9OaKQ8d18xXzt1LTFDdygAB7+ru/2hYtFNk8t0R8wKnnJ2r4M
	tDjqK37CUVV/Ed33GLJCeI9uOPmCuXK1IoE2I7Eb5JL0xLYsm6AFrLtYSUrdeC3OizVexN
	LCMAr0L7YkSZU10n8lVpyFZ/3VUU5+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 960F44368E;
	Thu, 18 Jun 2026 09:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86A91F000E9;
	Thu, 18 Jun 2026 09:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781775435;
	bh=mQ+VdzkNIT8tHhjzl6siQwOcdm316deLyyLan0NDdjk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HqcFCLD2R7hOPyjhYBm4FaxGAnBpbYMYsFLx0Rjd25jHKkJQddurK3Np5tnW8tQnD
	 wtH+hrqqAk2HAIDBuyFeTeBMWB7wFiahcrOzeI/WDHGggbHSAgB0gJpcp8RIhAFzV8
	 T2LL+Sdv4oZNhqxs0NOyq52BjPpfnhH/DCgXFb1a9vLxXMVlCyHqWxKw1KnQyhHGuI
	 e0FpI30Wn9FRg4lHhC7CqxWBjI5Ud89E9brojrzTJ00EeCMstn8cZ51Wn9mnR6gU+i
	 DciK8JXWruf9KN8NLBYpfROTQvxApSrQf/uiz0E7zuCjThV3UgZSwRYnqrl4i3DM9g
	 QgTsA3/BrCoHQ==
Message-ID: <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
Date: Thu, 18 Jun 2026 11:37:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
 vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org> <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
 <ajO7yI541hphWRb8@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajO7yI541hphWRb8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sk7xbzrxhh7zhekp3wdy83cjtiep5dfi
X-Rspamd-Queue-Id: 7130A18000B
X-HE-Tag: 1781775436-549518
X-HE-Meta: U2FsdGVkX1+EgAtQsesv6YnYngPy0TfWBC22qefWqKm2yOflqfuxnXdzDEkRNK8s2yFmTYLzHaYj2fmeztty3dUyv2nyCW4wPUmrZg4FyIGN9duWEsCFjnp4/BKmMHXfbkkvrmepDUBcdFKayFk6IiiatYx0WYqy5qAE7/mARzWGsYKiKtQrSxr6E2uCfDDW1Ytt+yu1qCuQOAEGKx+2gT2N4bNvLoTd7WBBn2NC3+q1ZgLCq6Dm29cwfCLOfLO/P244+8MBrqUSNgAaKSJnexK1gtoJTv6IH1AdD59HckuNn77nbbKpesJEwypw54znzHKUhK+QuL8r3+q36jYmpXAW7R6jv7oskZpM2raP9+dVgNxXrkxh70knyVCTMoW7Z/h2h0WaeBspbJqs7QErs8Knozl9aa9QyIoUCmLjE43BYcucuB9piawsngl57ncXPUuY9VoREVwwX2r0/VNvEgxjtyPfjUtP30JuEWIvRJi1CxGQ4bm+Gwm0Hs2LoYDkyhKoFnjQd1e7HhvdF5K2ptgLDwFzYVh2lxR60ldEoHDZ7CoBnrw9315U4LlWEyEcPlyEDnSpT8qvAqpOUTNCT978zGeh1C17oL7FIgXIZk4AztCkshQyWnmyhp4TJTo5dXcp+/iTdNOuDRLZgczsvAvJhl8NRcoF8EswQ1l9Y70an8hw99JFfRpDGXTef8G8WOf27S0N3kOWTGKTxpXCpUUp1QETNnwey5knG9d5ALCvFhk4GlywGRNgjm7/xZ/+4S/SeYmxbRPLWyYr5qKUArofmhspbRuMKAQdO+/+1ScgaF0JbYBkfHrrw/qBWM/7vqL8qGyyUgWfrrwrQ1t6khAIyUq8o0F6YlYzviCzhymyF/RHGcPOAlqmKp3E+/ET8yc8g/g0Yu0KSu0fgk4cRyxt7wzQeLgl5f31bUQvBlaIIo7kGUU57Hwnm2tT8PqJROx/7LD2ePyjj2apn/D
 thK1lkcR
 mrsIu/QpM7FBz4GeXaW5VSY0DgZ78v/jOSue/3Ri+MeAZ13KoRepPc3wJZ0b0WRxmfoQNf1jr3CuwMWqKAxcn2BWuq//gddETuybHGj/yzrTTrNDGmo8kGBxcvHWROj2fFbn6utBFWOfei2hdNFyvHB2hfbvvoC0UYxqzhQSV3qkzLCaU0n5XS+udmvQ2rNQqzaUb9ViH+h0AF3vtn0vtBrtBrNwMafEJWqL1A/MAIWMnrJ6Ww0mZf7Rj9lD8+gKqS0pUhYjFbHaEs5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:35, Mike Rapoport wrote:
> On Thu, Jun 18, 2026 at 11:25:31AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/18/26 11:21, Mike Rapoport wrote:
>>>
>>> Cleaner in what sense?
>>> Will be uglier for sure, just take a look at vma_can_userfault().
>>
>> I was thinking of this:
>>
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index 180bad42fc79..8a6803618a91 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -2029,7 +2029,10 @@ bool vma_can_userfault(struct vm_area_struct *vma,
>> vm_flags_t vm_flags,
>>  {
>>         const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>>
>> -       if (vma->vm_flags & VM_DROPPABLE)
>> +       if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
>> +               return false;
>> +
>> +       if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
>>                 return false;
> 
> In a way that's an extra check for hugetlb, but it will work.

My point would be that we exclude all special VMAs, except hugetlb (which is
special but supported ... in its special way).

-- 
Cheers,

David

