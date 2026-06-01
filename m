Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD19CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55726B042D; Mon,  1 Jun 2026 11:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05AC6B042F; Mon,  1 Jun 2026 11:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4C46B0430; Mon,  1 Jun 2026 11:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 807A86B042D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:43:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33C0E40697
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:43:18 +0000 (UTC)
X-FDA: 84831762876.28.0F01918
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73FA418000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:43:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FVPTfr/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO0s+zNx1teMaATs5R5qm+l3y0p7GjTXfHROaGLevhE=;
	b=XEgjDYxmXZC/e6Ehj0ZHHvWZjzdVY/mVQZyjdQnU3wy7kXWd1u6wMECET490vKS7PUqLcd
	h6GkTd7VuvqM0cCX43pcJVg98gjpPrnEl98bidNA5plf4eF+o/kLaGxmcU4ATzTLDoxlFW
	fLzFlZETMnTrAcphoV1gbsl4lZQtMsw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FVPTfr/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328596;
	b=4UQh9nngRVi6C1jUniOLIAaD2/Pp52PfoqO/UxppOw+FTqC/WpgrA2qkaI5/i9gU/Uk8on
	OJvpWidonxvdgGKYg3EDVPrp+EqH2cnUxDm2u2l4IZQILwsROTdT/ZtJv8RhMTFEg7JYpe
	WYDcNcKI72EqDZBZeWoySTJ48G1H3J4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9774600AA;
	Mon,  1 Jun 2026 15:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78B11F00893;
	Mon,  1 Jun 2026 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328595;
	bh=uO0s+zNx1teMaATs5R5qm+l3y0p7GjTXfHROaGLevhE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FVPTfr/R0QD61EFQyyj4rj+imGDBnQ9tACcPP6NB1RPh6nSF50yc7my9PXGY/alSY
	 WgFLfr4fEY8mhypvAus1SojlL+kqTFtAnfZs43OXc5pXtGrUaBehnEI5AzSHohVu63
	 bTaEuwQaGYxTt7U2JwxKAru1mrkmoRPjZx0naRH/MsZXC7iwhv9NhMPAu+k1BzYmJj
	 JZQgWoOIQypyDgOfzHg9MJrTfxRreSASZvt0FTg4HH4L3pzM4uiJlaLnKRPGO5P9ac
	 65bpvHzOba9uUQMyPod5l1GbXHr9nEf/PdvMR/jX68tWQRG+rvnQvlUlluIBexOrAg
	 NQ7297TiyJv9w==
Message-ID: <f7737b9c-42ba-46d1-b69e-53ac2bda59a6@kernel.org>
Date: Mon, 1 Jun 2026 17:43:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: Lorenzo Stoakes <ljs@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org> <ah2fG9fSqbocqUlE@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah2fG9fSqbocqUlE@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73FA418000B
X-Stat-Signature: yn8484n1nh9nc19fi1g1ryz56xxpewih
X-HE-Tag: 1780328596-567989
X-HE-Meta: U2FsdGVkX1/eXObqrCrA+CB4RpulWrIAN7hndYEen54qg80GaqI06FgArQPUS7BZGJmO7ah/7bDtvgG8rLv4xSQWfno5yiIZXGL/Lw4I9T7y4LZ6ozNeQE5WIjdJW0CcIaKha0Ei4VKY/uuUzJlw5PEVag91NHyo8WMAPpinR3HC9UK2doU+xP2HWUZHkONTJu26YFiRdddbYFTKYmOSbAhuokxf5cNfpLt9YOqg+Q/al11bXuaphSp37rz06bxJeamLZAdRtPQCpSak3sdQYaKxHr11f0H5xXuyUcZPvvonhJp2AHd1yf6aesSp9w+w6J9NEMRbHi9iTF+TFFnGcnWSotgoVGfCBAkNOZbehLjYpJ6aN16y/F1gIXm6FeABgiKIf6RjCZLqbm0wElUrt08X/xoJX4njOTn5B8drQ5U8dIjZp0XlVnPq2ESriPoxZxYDN86QG8Wk0fSJBsjSE+YbC8TB/yQh8sIyUKhq80nopIbsY1ovbR2Y3C+g4T6Crc1f8I9H/mm2tBfyIg/p7Lav5aGraHsjiY46+4rhsO/5Pe4YUe9X61fabp49ApIb6SSb1Dyen8ahjac3y9IhyX+3PfUSE7s7LWMqoQDcTkGvGZi1dh75uNNUy8GpfpviRvhI4AP/6rTo8CUrjj70t+leWc31Iwbk3USb+GaNoHKjzEWlXYP0pQBgez26Rj4BR3n1DOUo7belC3Ota7l+NYVsu0qr+QXcl2O6eC791RpE7aBs/sxlc8c6BOo5KrKXDfjXBKodZBrX76GaS/Zj4ibiGrUEUghDO4GdRJzrWVPYHBxUYVvlDK4m46OIaGfC/d4vtqE5s3pviZqk7/sMd0AvPja/sDpQ/E2Pwr65Ny+q777jgvonqGvcuonbUoqLLl1Z3gPlysarx+Pn9B5anPxJ7sh5vHaHnJzkaa2ftVOjBX0ucRJRF/Gtnahf+Ut+JqfzbZKeURXkE+X3gKn
 1hAmCuI4
 iqnL9HSUUJBZpF5QUcSE68bq3TA0fM3M9iD81Zk56bMj5MECl378fCGC0G9PvUusgcNhU7aiFFJhvXwa0xf/SWdEWUMJI7XBY4hrp8o0Eun/Qf6NAMnE4+50QV6mBUwDy3KmdYMedo+mP/gD6PP/ozVOQEBtJJlvFjBOksI/KSQvcAcrEcWPhKpcrCiRvabwcpmpmvKS1C9E1sLiSeMD8L9+zTpuyd9fvpc38v/AjsImFvs821ADb6vO5oxD/YpzbfSOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> and have people
>>> base work against that?
>>
>> This I'm not so sure how it would work. Assuming we have submaintainers with
>> their trees and branches, the final "stable branch" is merged from those.
> 
> I feel like it could get hairy pretty quick, but I guess the key thing here is -
> maintainers resolve merge conflicts.
> 
> As long as we have a specific _solid_ basis for work.
> 
> I think actually this speaks to it being sensible for each submaintainer with a
> separate tree to maintain their own repos rather than branches.
> 
> We need to determine what this baseline would be for each tree though.
> 
> So perhaps each submaintainer tree has for-mm-next that's the stable branch from
> mm-next + any stabliised local changes.
> 
> And each week this gets merged to mm-next, and everybody resets to mm-next
> stable branch?

I think it gets way more complicated than that once we involve hotfix branches,
and dependencies between hotfixes, topic branches and all of that. And in
particular, if we have to drop a topic branch in some circumstances.

My first step will be to understand "how would it look like without
submaintainers" when only having topic branches.

Then, add a complexity level on top with subcomonent maintainers :)

I'll probably schedule a session in 2 weeks.

Whom to invite?

-- 
Cheers,

David

