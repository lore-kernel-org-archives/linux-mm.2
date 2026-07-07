Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD97FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88DB6B008A; Tue,  7 Jul 2026 11:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39116B009E; Tue,  7 Jul 2026 11:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E5F6B00A0; Tue,  7 Jul 2026 11:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 776B06B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:58:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E68C98EAF1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:58:46 +0000 (UTC)
X-FDA: 84962438652.15.74936FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16625180011
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:58:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oW0AEo3u;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783439925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uY7JoMzi1A48geFlWQ28KwDtJVJxbeinDdtBSbMmcUY=;
	b=s2F8tOrhsYT+06Jy4TuKRul7LsyWQBs4B+T2szd9Kj2LAsBoYb4gyzrHZHwdO4xpd2+kZ3
	364KOYu2fgFFljIsSJ7vzjX9o6RLKd4oZqnvwCFJBRsGtajHWqvq3bm5FRBbihQcdbv4Et
	NV+jGhIuaiiKzZ0FoFEnjf5UbX/XZjI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oW0AEo3u;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783439925;
	b=IjAVBxHWRQw6Ba2XzZmN/Ph47yAuoCjN1rS/guOnvJhES5SHZos7QwwEc5eET8UdSjAKTI
	xYFEcGryjzgo8vS/WeZ68y6dOzUdWlG97zyUFsAqYI0rRS1r/+zVzmXvsJqYRqaCYhJncQ
	AyRWi9oHvZNNJCJEiAG5o8amYS/0Kzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94CEC60018;
	Tue,  7 Jul 2026 15:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4683C1F000E9;
	Tue,  7 Jul 2026 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783439924;
	bh=uY7JoMzi1A48geFlWQ28KwDtJVJxbeinDdtBSbMmcUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oW0AEo3uBpCypEtwnrncI+ZUFlC55dKRVFZKYH3tN8kAx8q4MB5UFu23kI0gBCd3D
	 x0XY7JPbCM6/N0bNONNlEY2s602hyAHc9daLeFMvefaaBMIS770EykA1Sh5fKXQfnC
	 WK6SmTQEUi1j5HB1hkVUfhceypYTDV/HNi1Hji7pSEcd4dEjpzk/ruNwbYjLJONFeD
	 HkyXvOn4ajaApTUrStG+HIhtjXICpv0+hvJfkMdY/FRojlfWUXHxy8ezFAj//68Suu
	 Ud9gS88Y+Q/rdNrQGRWdzE04JH3F8TIFLWBOOe/13klO5nhTYUxeIYQRLDQEWVPK0w
	 BrNWzIsgH8kUw==
Message-ID: <793fe8b9-f5f5-4458-9150-5edbabde44e7@kernel.org>
Date: Tue, 7 Jul 2026 17:58:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
To: Kairui Song <ryncsn@gmail.com>, Barry Song <baohua@kernel.org>
Cc: baoquan.he@linux.dev, shakeel.butt@linux.dev, akpm@linux-foundation.org,
 linux-mm@kvack.org, chrisl@kernel.org, jp.kobryn@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260701235955.36126-1-baohua@kernel.org>
 <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
 <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
 <CAMgjq7AT7ddzbTcg1QCOOP2-gDmtt=8nZbDb8pKSfFCG7Y2U+Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7AT7ddzbTcg1QCOOP2-gDmtt=8nZbDb8pKSfFCG7Y2U+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16625180011
X-Stat-Signature: us8gp7n7wc36e6sucz8rbyp17hr381ap
X-HE-Tag: 1783439924-876288
X-HE-Meta: U2FsdGVkX18VNjSSB1atJZEEY9skPcg7EBHYAaJNKZSJO0MOQwOt1xTFHeyO2/ObzdEszEN2nQvoZVv30VwGJ50Cv3b+t00MRTyBL/Ihvi7dFCfZsC7MmlNA1uVm0tych5MafUHyDo6KJxpK5UlrGVNRiFfNREjseU6xFjDn0xJ6FL+HuJyCrtGrM3fk1/20zW3vkED+ApAHVwTEOd69yJWXVFBM0jRgd6NEc5eJ/ZMdzI1MazZtA4Oh4lYMbtRN4p6BwcCsnenTGdPsV8JDvLg+GmFniB56yrfvRz82Rg2ml0OIW4R3AuySv8KK0FMwPFGftH07MZ6J8fkwRpxFB/21xppJUzm9TjIwfbeWuHuStJ8NcQmBXsjOjBHKjXrtTg5JyyrZrt1ETvidIPEqzEoskCdyUeXwujWirkvx8aKla8xSYehbCRyYIAIQgAWT5aHhefHwJzy8olCJllhLVAWsZ8HOO9ChaaSQwQLcsC2AqnXF6dYd1TIfxDEu7vbwCx5PZJQK96s9GnTrfEHngun90kdJ9YSrzH3Spg9/kzBNxCL7NsQMc4MkDHmQafyVbxxBXy/9tcf+IKro4EAukqRedxY+Btc+CYW1HhlECQ/pF01sVqSo/0HbyTZgoU4jbu8c9QeGqsQme+7JsdybJ5V9X+6p8MQpa0G7omHxapBOQc6Z6+0/ByCjCRO/74h/qjtpdV5WoGfGG0FvZOQcfSEwfx44ZwQJsrTQO98Qctw8Ke/Tq9Sn7wuIFKTZ264L5cZzqwZksGupHzJ/CfXBhg1TEOLelaoJv5s4QkZ4kqcIHVMLVdILhx1KZt4VgVD/9beMoGPJ5pDKp+6ZINILy+/TKAGUmcB3ps/PKwq29wgkclxt0x5zsLSUR49tw17N0kUD3fRMlx/mWIL2RXCzmWewCrpyhe0N+zWQvNmXTFF7AlIiRO489jyr4fMkzueWbEqU5hWDC5szQ0scoZ3
 ci7ThNk1
 4zBlnHgxfjL/Fafaowb2fw4+2+MJXRqnuJ5JzQJkfUbt1n9bvJyPqCX4eJ9HAo8JVl3+BIhk1G8CZbR006Rac90mvMCb8JZznmTZ1FNuCGjT8VDdetFow3a0YASOFMj57+OUkrxeRAUUBpqFB6oXfv4Op/0wOeD8akE8LQU4UOa8LT6B1yMkK8FiLsp1E0XcLCmNXM+DWr5ed6No9j1vye+XbsO1d7OzA9MOPNHvIIAGzhFHoEnfneA2MZmMRbyOjDapdr620qbKVba+JjI/XIV2i/qdl2oMNOBe69YaNL9ZDNCvuyLwyQk94zkOyy2MlJO864GGRv/mC2Fqcdu3sq9rb6+ttCQ4p6QlG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 17:26, Kairui Song wrote:
> On Mon, Jul 6, 2026 at 4:54 PM Barry Song <baohua@kernel.org> wrote:
>>
>> On Thu, Jul 2, 2026 at 4:05 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> The other folks should probably re-review this patch that changed quite a bit :)
>>>
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> Thanks!
>>
>> Hi Baoquan, Shakeel, and Kairui,
>>
>> Would you like to re-review the patches so I can re-collect your
>> tags? If not, are you okay with me removing your tags when I
>> send v4?
> 
> Sure, no problem.
> 
> The only complain from me, and a trivial one is that `in_lru_cache =
> !folio_test_lru(folio)` looks a bit odd. 

I was debating with myself a bit, how to keep it short yet expressive.

"maybe_in_lru_cache" could work.

-- 
Cheers,

David

