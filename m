Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A59CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72236B03B0; Tue,  2 Jun 2026 08:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A498D6B03B2; Tue,  2 Jun 2026 08:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F426B03B3; Tue,  2 Jun 2026 08:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 840A36B03B0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:55:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39D0E1A0391
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:55:37 +0000 (UTC)
X-FDA: 84834969114.03.F999E6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 839AD40014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:55:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mAAA8WsU;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404935;
	b=0L/md+2vZKFz7aHlcmkuE2bN1+p8rS1PsCBbIAF1X9oWTdxgib7NslrZToeyEGSbrYK7uV
	NL/SYdTxs4PPakYYnaVMk//rVmOGEOYNtScbdn5N1qKXSdNV+gBPaBHa08Gkd7rXz3uUHk
	tq59xqbjSeKg2PEFyNv6BTUHKXx5JdM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mAAA8WsU;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wa30tycO2hAwCFswd1NJn0DJ/nVTLOszbw0lY+/028A=;
	b=4fpqj35eU9lmWlh2TPLhjY/Wib7xfyTs54i5o51b0UpGXCNJ+Ut3cRTaA7fR0DpF3Koh9M
	IcfjcMG3SlAg+FcJgytCLAEpkBt1uBU7XPQmvsA6JkU5UYS/oQ7mfEQQ53WRJRPkxziODG
	g1Y3pvJDNhcmKFkMdAD5yyM8fkURy34=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07D3A60154;
	Tue,  2 Jun 2026 12:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A209C1F00893;
	Tue,  2 Jun 2026 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404934;
	bh=wa30tycO2hAwCFswd1NJn0DJ/nVTLOszbw0lY+/028A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mAAA8WsUS7WsUflPwTPwae77f5Ej8+KTXpjHH1MmFljpWmiLB2X1yvKvnda2jeBux
	 7CCIzCBRfE+M+JokVZ2CK4X5K1QA3/sZAWUAySESZEgkQZd+e2u6j69d4oCzXummve
	 AHX8Glap44IIcEGCtuG4b11E563RKThu31L3gMCV+xkeyyPpLK/9ezpOsRG5ePc+E0
	 aNCuXXCI8OAFmbU4jmaPthQgCqu4RAI0aoDBZdDW52CXD08n4C+lRzLtceG7Pl9l8n
	 jMH3mNCPz658yXUGFNBG9mqpYmdb8sH67JlzCsclaYjx+3ZccD3sLJAIw0tJnYkzUl
	 2r1m24J1FXdlQ==
Message-ID: <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
Date: Tue, 2 Jun 2026 14:55:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 839AD40014
X-Rspam-User: 
X-Stat-Signature: cs5j7ew9crfidahzjemsx8f354yhfstp
X-HE-Tag: 1780404935-899185
X-HE-Meta: U2FsdGVkX19MvMbDGMekGIhLPqTiZZUvGgnFVmcTLUpNolR+zR2z/QOF9NoKlU40LZyQjZ2vnSlG4mmrut8i7SzXyrMvcDjrju0tOa1U5OsmMe7Qr5hc+GIM+g0Zr2kLl387JRiN3P+hgTr4JtKaIW4dSKxs1w59NHnItTNwPadTX/MEI0kWBZeWZ2D6cj+qCyptz5XLeeQP8f/cBxVlIgtpCoPZnLyd0ctODbby2G8UCo0Hvu2uMqyTZJb+r+nxEVf+XxeWXm993Gv5sujVHij8HZYlHu4ywPGt9O81d6WtflZcOlXkMWLmDQ08GA4pS6fL+YXF5GUe6wywuAPY363b9WdjrJ49zl/U/sQxu4zEItBf2oXP4ROeiZT01ATdFxpW8RUr1v+eohjgqTxPXkqR70pXpq0pn1ZR2ZB2TuRqKRVvsN7uCzWJjXzN7s4pOIwd5aAnqzxmbZnNFJyeTFO0Ea8M6oaEcxduO8sJ24dqQk5R2AYRlxKXgoMG1RlV7OktJwqquJuEvhr5czNdBtK2ooUVjLMh63cz71QjcgZddrEAovicSiR0fOyf2GIAvEpg95JjwVWDHnA3pSMCek6lsOCglud30arpM1o7zbxL/LTrbZjx9jT5EwjifvdVCuZwDZfB7nAka2F0w0ik7rlJdsWnaG1pcOrHxLnD1lcshUNkoGBEEWS4gX92TOJ/0sSrKUKMEXqoJ2Q+iXsNN+lpp0dKNquCdnmnJ0JZz/g6nPnpn+2z8MBSbmN5CZqw4+Y3EH4DFSw3r6UfAbgjl6oK0udUcL4ZyjqjOoSVIx5nhmMCQ89kFG7u97mfCq4zsDAnJ0gIIpfnW5ERqcNA4i2xudFgT8t9y39ts6dtTNeTWAemN077hElZSu1zg8m1p7ntDEkEt5+H884Iti79GMdd0/xbiqGwXPKzCyyUTojKPCYt5++M9/GAtH6Q59cxekZgWfzhFLE3FqW/8Fd
 gZtJyw42
 M6VqrBj+Jm3jsXM0OPxdsB9E1AHOPfOt7O46FGk6E8FmFokAJM4IJoibXuJBJBMyBSoJiGenASpO/AWA53/1YDrR5R1zkcAmppkzRCiP00FJzor5DwhkbmUJR+i+hJOU3YX/WDNDw864aNf37HuyzxOwKIWTe40TfKRFiw4ArJtKeTzQXsT0OQIzjRVDMKkTSqcWcSACJumhv1nNLhMrP1zU87MygcNiDlelgZPijaCzLN8owk/OJBoMhP1GktbnJtAHdBwU1X0iEQmvfESmJ0rU5ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 13:31, David Hildenbrand (Arm) wrote:
>>> learn from obviously) against how mm works in practice.
>>>
>>> High review load with many overlapping changes might favour a different approach
>>> to a subsystem that looks different from that.
>> Yeah, but as we said, we discussed, it's all rather complicated and we should
>> move incrementally.
>> 
> 
> Starting to read Documentation/process/maintainer-tip.rst, it's very interesting:
> 
> “The tip tree is both a direct development tree and and an aggregation tree for
> several sub-maintainer trees.”
> 
> “In general, development against the head of the tip tree master branch is fine,

I don't think we'll be able to use this part as mm-next will be only an
aggreggation tree and not also a direct development tree.

> but for the subsystems which are maintained separately, have their own git tree
> and are only aggregated into the tip tree, development should take place against
> the relevant subsystem tree or branch.”

So it would have to be this.
As it might be hard for contributors to pick the right one (as Lorenzo
pointed out), we might in general suggest they try developing against rc1
first (which is the common base of all subsystem trees), then either it
applies to one of the subsystem trees as-is, or it applies as a topic branch
(which starts also on the rc1 base) with reasonable conflict resolution
during merge, or we tell them which exising subtree/branch to rebase on.

> “Bug fixes which target mainline should always be applicable against the
> mainline kernel tree. Potential conflicts against changes which are already
> queued in the tip tree are handled by the maintainers.”

Ack.

> So, yeah, let me reach out to understand what works, what doesn't work, and how
> it works :)
> 


