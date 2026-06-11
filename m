Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23F5CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244ED6B0005; Thu, 11 Jun 2026 03:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C6C6B0088; Thu, 11 Jun 2026 03:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132966B008C; Thu, 11 Jun 2026 03:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 086B36B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:35:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 880ECC0976
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:35:28 +0000 (UTC)
X-FDA: 84866821536.17.BCFEF9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA2FBC0004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:35:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/Isisuv";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781163326;
	b=vqH1ydVmdCWeWaO/ilRrEHeS5fH0EV9K3d5r2syk/55BvfkZmuGQN2z7B6i+pHwZ7hp8/I
	b//yI6Y95dPke/J12owS1cAiXIdWtM/Yu85/OZ+czHdKgT4byx/JlbqMhCa/c9ilXEiTki
	yw3dTtS2XMzura7DLPrkyDxujSF53mc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/Isisuv";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781163326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNI7jhwAKxOqPW4v+VQ09wX2NQrlWfNTYApqe3DsInI=;
	b=IdnrlSeFgNeF2SVJtHMXgmLd+cOtaYqC417d5MvDZ5rqXOf9uZvDJTfzzWujQOyUIJreUK
	IUSj+vf+aKVq8w95hGxR05wA253HfUjoJBx4YU60LDRMpV76JBPoy8JHHV4ycamABGig4p
	En/RTLUd60UEmqGTjkKTLx4Rq5WjuWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76AA743E93;
	Thu, 11 Jun 2026 07:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DF81F00899;
	Thu, 11 Jun 2026 07:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781163325;
	bh=MNI7jhwAKxOqPW4v+VQ09wX2NQrlWfNTYApqe3DsInI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V/Isisuv7gfQAejbPTqxpbDSnvi0ig5q/qA+XLKyTfCSr8jcF7LSpMdo6/hvEwPPS
	 oq12h3CZSHAP0+4yCaDIIjBbB3MwWMOOBrPgjY7oIExoHErukUlsfShEFSOD6y2zWx
	 LWZQvue9b8Fuf1sfNfbTxLdrmJZYbAP7kB9bFDLGEJWEX6OfUj2bfsb6zkw5VOzvlb
	 xkwEMo120ESWz6G7ExnkrqeM2T3bhFVtDYsaqT7iTTzREI/RFGAzOfRPZgbK9NCnjH
	 xHoY/ph00863vQSpQQPC3vPE9chwyQ2Z3Lg2+uJ6IHQGUn9M5qk7X8Ey5gpgqCOpHH
	 9bbg1zpIwnRyg==
Message-ID: <07fa0325-25f9-4179-bcfa-fbef8938c40a@kernel.org>
Date: Thu, 11 Jun 2026 09:35:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Balbir Singh <balbirs@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
 <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
 <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
 <7A8AEDE1-C28F-4490-8A2E-72E4E8D0E78F@nvidia.com>
 <aioFswTdZCdPGjag@nvdebian.thelocal> <aioG_ko6HoOv8qlc@parvat>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aioG_ko6HoOv8qlc@parvat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA2FBC0004
X-Rspam-User: 
X-Stat-Signature: 7gmeunfr58hohh8jawcemospy41od157
X-HE-Tag: 1781163326-810130
X-HE-Meta: U2FsdGVkX18c8DsYjoC8pdhT3SyrKtQbFKYiWV49xBww8ki719/jxPzs+Ev0rDUoeP/8rTZjAUdy2rh2ERKGcscEj18eWE7PGzGxYjWR+s8AowBCDdrLP/KzqR4Vh2E3pqRlOnWbt+jW5VI7qW+wGovrszSlH22V+7b0YLfP+H4CSoIJzPE4Pc4PXVh7w8+jsV4X+aHPmnQOMGCDXBIdnDtOdF0MEZ/tJzlaKeP8W8S4D/At24bHv/QvibVxjgnHmBOL7WAf+rcpSQXQo5ETi0J2cEhc21BlCRwpIGrT1Wm8ps7xG1UywbR6iMvN9o7siHivzQGScJlEEk3+kDgkFBx9s19s1e3S/PHxGWj8QKHGFFwHMxqF9qcK8J5Jsb5YgZTbL5RuvUuknBOm99m5dxUKNImdvo54j2BImkaAQRxQMLdHfg9nzoPEHzAryQY6zgOEH0Gur9KN8OQYD4J12ZQalX72CFEeN3+Q3dwreBbjl4XYkM+DVD60/XLSM6TwWfGODTyea19wHWipiTltJGTnyazQYHec+cbI5csfXPVDuQSDagf+2a6l8whPqtxlx7V+NCgtR3wR6MSmNF5EBNHI3Xe4zYesMHKgi2QpsicSnrmpjk65+TL/p3OYJ0xg9ouQLdTkQzFXt5fOkhQNwoKHcTI4xBorl0LxThEIz2uYYLzjJrd+VBpZlnITGassdM7VQigBwQffvYWHxJLNPKLLdp0VNE53X0EpChbUi0U0sHRgt8dD5Kp0PzD1MilV8CBqUOKLPXiQkIsbCqKwr0M9XY2susE9xVELp5g6LWULD3fMXR9AdsOW+4CIZetvlDBY0qV8EU4I01Vy6OIDku2FazeIo3zVZ7Ig1/lgV0BTiIjMO67Wb+t9XnNgl0paqvgh/FttYMH/PRXvUKS2UjvwXT5fdIdeHYgsOFTQiiueHyDuKzGXjPfh06v0DI61yvaocUL+FqGZKdIv7j3
 QiuNPZuP
 m9Ay7JijCoDZ7ejrIf2E9zcDdXOGAYF9MvbBIn4Ve5ORjm6bdiYlrNadeLGTLe3d8BxMAv28KQMHqyKHHKWlaDdT4ef49JlGz1iWWVaD9zt8tMZDSarYzNcVTc9DKTmT/5SnO8bGadInEk09qOECvOYlhi5zm8UKDSiXLWn/i3AS3mNo1K4dL7r7nHL2AFhecI6hvXwR7HOdVznkS44m8iqIjoac1eyHofIIAaIT3irYPph45wYckir+Wh6p0mv3tBtU+lxzHkS+PacefPMuex0SVSWCQ3cZ/a3N5OlgTvMTEl7BDUkG6hiGpHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 03:12, Balbir Singh wrote:
> On Thu, Jun 11, 2026 at 10:49:59AM +1000, Alistair Popple wrote:
>> On 2026-06-06 at 02:20 +1000, Zi Yan <ziy@nvidia.com> wrote...
>>>
>>>
>>> Right, I will work on my solution soon. Meanwhile, this change
>>> is simpler and can be easily back ported.
>>
>> Thanks.
>>
>>> BTW, should it be back ported to older kernels?
>>
>> Yes to any with f002882ca369 ("mm: merge folio_is_secretmem() and
>> folio_fast_pin_allowed() into gup_fast_folio_allowed()") - we have got bug
>> reports as a result of the lowered perf that commit causes.
>>
>>  - Alistair
>>
> 
> Ping @akpm to pick this up, if there is no objection @david

Fine with me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

