Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E497DC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989C36B00A1; Tue,  7 Jul 2026 09:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBC06B00A2; Tue,  7 Jul 2026 09:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4556B00A3; Tue,  7 Jul 2026 09:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC796B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:17:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C04F6168D24
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:44 +0000 (UTC)
X-FDA: 84962032848.29.90B314A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E135140002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ekBlEtaX;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783430263;
	b=RvbEoXJTrD27mNagqmpsebCS1LcckIkNNOGkiNZ5S4NsE0dOUvzK5Plv/PJjYI9UQYulnU
	ObNuH/cKeXLuisuKhB66qso96mCgbvREnv8kypJDdASbD7JwbtDaxA+kHRMSkzjEHGC01K
	nhOTpdk4NVw07wzTx+uVGgCOXj+gUYU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ekBlEtaX;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5p98PRn2cxjDk+JJlvD1wzmliW0l2W8nSc95PJxuTqs=;
	b=Bkkv8zeX/anP4dPR/FAbUWvqV4heiB1WZpVS/g3GqpY9+apYGGDOaHdMu2uEBoEEiyO6oD
	nLezjJ/VMNgdiYr/Mgz6n/6AQvIlec5f/QhbRf4P34jLIT4SlTmzy38QKmJfKwfRQ4j41a
	MvUheD88nAMRNaX+Rw7yUfZE8x8QeSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D68443D6C;
	Tue,  7 Jul 2026 13:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1D01F0155E;
	Tue,  7 Jul 2026 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783430262;
	bh=5p98PRn2cxjDk+JJlvD1wzmliW0l2W8nSc95PJxuTqs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ekBlEtaXKEYUfjDrvSvzpx89vlzX8XAx0GfpW4nUJOaQ3SRolAmuk/Y7CfTfPGgJ7
	 JP8faT51OLBKI00vsvtQZWw9WIZOFJ3rVlmmw4hHsISJu7I7SgSszbErKQ1L870E8d
	 KIls4KWjd6p/bXVbraoj9gw0JDhauAiy1T2Ba16ZZW274Vbl+qZ+0JC+Qgt9C12Fxs
	 vwHJ02whL36oG1D1TQm/f57N0ubo2JltZ/dSnWg49uXAigoG4zbLnXj1TDipXQh/i6
	 ou8ugFM8ohRJLocIx6s+ZM7/hodfALjZxDkmwUMVIbVeNlu0X6hQMWJfwQ5uzJLzfr
	 vrbb7unCQNidw==
Message-ID: <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
Date: Tue, 7 Jul 2026 15:17:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: opaque hardware page-table entry handles
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E135140002
X-Stat-Signature: rkq99194e8rq734b3m4ezoytpf9edrxf
X-HE-Tag: 1783430262-954560
X-HE-Meta: U2FsdGVkX1+ce/ADufujqRCOVuDaA+w+JsqHAbaGvpBDJnIjf4NqD//88k1GkGg6ePE0FtMwFPkH+v+togmCbgxI5G0TyiusoQ5ufrqtMtAT9enudfqRMCHY2DJlnd6ISUIZAv5TipAN4/eq2sb0XofawegGrZiCy+N9xqA2JpKHtC2PcVXIciJ1fJTJVGjg2tIxUS5jnzpV5UA7WoTOpK8SkMcJaIq68ey1t66Vr4YqUpGYAxPsTfIAhmy3OWVPsaJWv3VGvVKwdBQNkanrGGD0t1hwiK8BKimMs6WjokQ/ykW9gjgx0Lr0BxB+oWNHt74qeWqPBprHYaBHl9uw3OSUf+Grr4lcYRphkV4XlxsVpyXg6MKMVQAfLWTIwykeoVc+L4ch/uFEUIa8Slf/ndeuMSEUONuSwdIdPENNWuUzXtCoBYKT+0bDuEBVg90xII/U/StiPKn6htSmUe5CKUtDnpaBfKnnqkspzJKUK5oNNynStUbHA5soRHbBxq5tHgYekghBZofVT0utQbDyiPG9dYNZhX7OwaM9axEftgEnCKbLMmIXjj8h0+hpJCvldlAmG16ZgAjSJqBISKEHdNEz24Nxp26hLbUeR2NeiuzSTKugo7Mo+fsLykeKubXixT7Ozy+n+vyiuYmxqK/tvYwpuzifiNR4SlfqnwzPybgp/vg0XEX6E+7DCEsFAYknkfR1lGFUUoJgRejMRlyaFEuflxHEYn2SCuTWLVCTWX0IeBuVuJR70NOx/WQac3436CMXUS4UHVBPra9R3GKKRQdL+phXQeF6fSzzTrmqj5Vvv5FyZasMBMV3jkVRuHI5MgpNzeuR0Pl/97M/o3eVEzGwrYtZY6/HN7Z6E5bFiBV8SRh+vW+EugXZ+/+xgWLuGkSkSr0DDMWeBITOfm9MA8rHk3TlvRxOqUz9DV1wU66UlqAALJXegNz1ZqWa61ma9f/hhe9k92aKH7skJwi
 LD1zGfKa
 0y2vPzQRcw8PTpHOsegwDhZLwR+4j3PhRS9q3lR2p90bTjAFj59nfIUEy4b9qZe/SYwZC5huarEvc9niShGnNUra2XTJYvpg4AlHRokeWEZwB5Zto2Ata6g58uSXE1s/TSv7iHPWyDsJrLBglnj3jToCWv2cDamPePAZnQoOyFqRgaFhbM9Ist7Qj2Qbmx0QfhR7ziQ3DbK9BJ0dzqvlkbvltPktq0MiYDDFLDTaewUfDvJ9mv0nnH5t6MgjqeSrk+A0hMV3Dnh5zeFxQy+4kn5ngpW1x4TzlQ9nW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

>>
>> typedef struct {
>> 	pte_t __pte;
>> } hw_pte_t;
>>
>> And then simply use
>>
>> hw_pte_t *hptep;
> Make sense. So you have suggested to just hide put pte_t inside a structure
> instead of complex structure of pointer. I've tried to implement and it reduces
> churn enormously.

Right. And for most architectures we can probable leave both types be the same
under the hood.

So we'd only have to convert common code first, and can then e.g., look into
making architectures that care about the difference (e.g., arm64) actually have
it be two separate types.

Just an idea to further reduce the churn and limit it only to core code (because
I saw some very ugly stuff in some arch code that would make such a conversion
harder).

[...]

>> Why do we need this and what would we use it for?
> The idea was that there should be two different functions to read value. Let's
> leave this out of the first initial series. It is complicating the original
> proposal.

Right, let's leave that out for now. I'm currently working with Levi on an
approach that tries to avoid the overhead due to READ_ONCE with folded page
tables. [1]

We're still struggling with some bits, but looks like we can make it fly and
have it be fairly robust.

With that, maybe there is no reason left to have separate pXXp_get() vs.
pXXp_get_once(). TBD :)

[1] https://lore.kernel.org/all/08ecabe9-0664-4aea-82fb-f9cb1739f762@kernel.org/

[...]

>>
>> I'm still not sure about the _once() really, and if we need that right now. We
>> survived without is so far, why do we need it now?
> The idea is to convert all current pXXp_get() to pXXp_get_once() and convert raw
> dereference to pXXp_get(). Let's keep this idea separate for the other work. Let's
> discuss it later sometime again later.

Sounds good.

-- 
Cheers,

David

