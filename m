Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A1DCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19916B0445; Mon,  1 Jun 2026 12:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0566B0447; Mon,  1 Jun 2026 12:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05E26B0448; Mon,  1 Jun 2026 12:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2C826B0445
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:00:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F7ED1A070B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:00:08 +0000 (UTC)
X-FDA: 84831805296.28.0E0C770
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1A9040006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:00:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2p0Z7im;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qat6JWdcNSPHllaQ3+tJkXA9J08r8Vi0aHl23QrxgQE=;
	b=yr6BpFN54/qYfPvAmQhYZbj4d9/V155y2eczibX/Y3mwGoeoXoNjNeCULVIv0wj3dqaSI9
	ZsfQwjbEbadxMbNgW0XuvqPVLGvX5XJQAb1e2gE4niBP2KwezVQ1wjwXQUEIE1klLUmfz/
	3bBBUNcm4fJbnkpo5/8OeKTJgq6+OVo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2p0Z7im;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329606;
	b=Tlll6HuFwJE+j6BZkxniJyO0a3Apy3TXsUZ2hPS5GNHnrRwxBPzeIiBEfWfrstIs10gAI0
	NdAuVj8DsrttNpTdnIQVMuqHgvSQl/L2AZfSPjEcdKQJoXrOB71dd/OuVYNfj1Gox7Tqwh
	rpXvewSNDzCWWJ7l2gj8ksvuvbZHCYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14136601E5;
	Mon,  1 Jun 2026 16:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB01F00893;
	Mon,  1 Jun 2026 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780329605;
	bh=qat6JWdcNSPHllaQ3+tJkXA9J08r8Vi0aHl23QrxgQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j2p0Z7imKkOx58SPCs+B0b+lPNx8j+8mItLEBK0ZZJVQMzsF6MpcAfjdtrUMCn+tl
	 IXUp+JiYAwJcxDjo0JxFUg3rHc9shz6F9AHFyJvjsx6rlMe3mkfQoCw6B9erOZX8vI
	 hlAPlQUaGmZcUPSWNQQorXbHanYHUcHyRsroaQiX8BhKmyCAR54+HjI+3UDk67WMoC
	 6CdxAolg4NqZv7u2tsA7esv4eAeiiZU/Pdc+b/oTKGW+t4H91tqiW11UnKAFdINvUq
	 bhZj3TPvSioqeBqp7ISxkOzloL25CTdqAiBAf4aHFuhdco7os8BVx1zNB6hcEo1sM6
	 al/EgJpQZdUuw==
Message-ID: <949cd60d-fed6-44f9-bdf2-59533ab61836@kernel.org>
Date: Mon, 1 Jun 2026 18:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org> <ah2fG9fSqbocqUlE@lucifer>
 <f7737b9c-42ba-46d1-b69e-53ac2bda59a6@kernel.org> <ah2pbAnz1pwNcW-U@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah2pbAnz1pwNcW-U@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1A9040006
X-Stat-Signature: mmdo9gw5887kyypjqskueb1wxm4e6ph1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780329606-429793
X-HE-Meta: U2FsdGVkX1/hLIK3vIJcniR8w0P7fvijqwVGnmiy+DDAzGGP8yK4qs3JcERetlbEEkgGC6/Z674R+EO/3aGcnc66s417WRbFRqCNvw1BM+R2Lhbe2JVkQM5b4szpC/d9iqM//ud7renGQMm7fvzLSWGYhlub8aQggN5WmYue6e/OefKDEOq6E6+pvfJ09vMT5+IB+TySWqm4FoRoeCxPz+GVnKdGY9b8d+zeJZFb71ChQq8xl84tkeWFQgtDDjBYIlMVVUbM3UCC4WkWbK2SnD/rqqGpdaNry1D/TwttY2YQ6twGjJPaDm+z86e7ENQGmOihLtwTSJsljjLu28HbqJ1VHYEL+G7jnkyj3cFX4JD7fItonBwyuldVggDjOrhbAV025a2x7pXwhb7QODsAMppQWghYMaCZmCtP91EIx8c9pt+GhrW5VQ+vYhewsYzqmKteL4BBhw3m15xVmXyj35bu3n3OmYNFA2C3qV7IS2tiARjr11H45fG4dJedkyGFh2b0pU8staUX+CRRzsSu6ZL1fsXW3jLop1VFjLijjViW3NxAjEJoVSUiEc4aqTIlsmtDMeHcQ0aL6BChLEA1mEWyk4D4qwWFoMV0R0UOPH738+0xQ+MJiuXl+RiF+z0duL617eRUo4VIlbA1YpdSbQRV5DGg2jcW42wTzvtp2B5VUoWdS8795dM9dk8wcl9rjTijHmIV1flHOIZFMBOlOaGQBOidEXKJn/mYzpxq9FCGD09AefTRSZA4YRJS9D7HUjlgaMzJkJKCP1BE2av677SuBrKUP5uCo+1aDzFXvP7gWNvDMZnkSBWGvgw2c7WG4dfrebWqCjQsPJ+BUT2Xmvu1ILuBFqFL2xPfGJDthy1TmHM3eX5gT8QOBhkD1SwIMngSgAhrt8plxL8/o8oAcI6fUKM0SxV2v9DcLAA4BpOz0J0atYGs4DYlhbdCa9hBgEVCWJeTPTY1VIeV8s/
 71gE1ADj
 EF3o60pNiPX5CgDNghcLwQGVZXI8N4dAGu0nArM41MOioPRS2dCCdvBI44+R54GmqbbPbgJ8TKX1OeRvdZ2dCbZMV3pKgUin635MW1aid8MBdcDwBIHR6Wg41FRhzIrv1hw/FxsHUpYhuabg4OcAaSteoHzjkh7Wn9PNm7qtsoBeUxsFfVRLMVNEUJkxVaWvx7ZbyLjKPF4h9WnQHwuuw+1QXM9BQJ9O/pxu9dm49eOyX6EhZzftr3ap9MftAuFhQB4du
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 17:47, Lorenzo Stoakes wrote:
> On Mon, Jun 01, 2026 at 05:43:11PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I feel like it could get hairy pretty quick, but I guess the key thing here is -
>>> maintainers resolve merge conflicts.
>>>
>>> As long as we have a specific _solid_ basis for work.
>>>
>>> I think actually this speaks to it being sensible for each submaintainer with a
>>> separate tree to maintain their own repos rather than branches.
>>>
>>> We need to determine what this baseline would be for each tree though.
>>>
>>> So perhaps each submaintainer tree has for-mm-next that's the stable branch from
>>> mm-next + any stabliised local changes.
>>>
>>> And each week this gets merged to mm-next, and everybody resets to mm-next
>>> stable branch?
>>
>> I think it gets way more complicated than that once we involve hotfix branches,
>> and dependencies between hotfixes, topic branches and all of that. And in
>> particular, if we have to drop a topic branch in some circumstances.
>>
>> My first step will be to understand "how would it look like without
>> submaintainers" when only having topic branches.
>>
>> Then, add a complexity level on top with subcomonent maintainers :)
>>
>> I'll probably schedule a session in 2 weeks.
>>
>> Whom to invite?
> 
> I guess can look at the list of current, active, involved submaintainers?
> 
> Can also send a general mail to linux-mm about it too?

Yes, let me do that.

-- 
Cheers,

David

