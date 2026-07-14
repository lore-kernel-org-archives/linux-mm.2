Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451A5C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEE46B00BA; Tue, 14 Jul 2026 10:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6866B00BF; Tue, 14 Jul 2026 10:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B216B00CC; Tue, 14 Jul 2026 10:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE7E66B00BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:44:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A4161A03F0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:44:49 +0000 (UTC)
X-FDA: 84987653898.16.53EAD4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80F38C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:44:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRtN+RJS;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784040287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCt5+yPes5D/HQfJ866gi6LK9blmHASLqF8Sd1Y4Upc=;
	b=p2DyC6phsTKlb+BCKz1fA/D0TxPPG63ZDpmd6PYZh9vdgJlA5Qx0yoz2L47FzUPNcZ15zS
	gBavTgnNgYR/Gac/onddMfcwtEyKaecpX8SuZeWaW4fboVOOkV+j9lz5yYpMIHn9R5IhLw
	hSUSl7omvrbJqg7/oEyniXsP5T131Mk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRtN+RJS;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784040287;
	b=joCRN+NXOJT4Tz8TxGzGS7ruBHfNl+id4EYxVU29b4WUQn6JY6bro4jx2ZstCJd9lZraAU
	xt11l4CppBM/rr9bRZvG2dWJ5vYUtyyjcbGhtQnd88i6QCm9CqVtWnarYXsSqLOblkPM9+
	inpsO5Mx/rhOHcKtaL7cVSf+aj3XlV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 739D44379D;
	Tue, 14 Jul 2026 14:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9294D1F000E9;
	Tue, 14 Jul 2026 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784040286;
	bh=OCt5+yPes5D/HQfJ866gi6LK9blmHASLqF8Sd1Y4Upc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dRtN+RJSwBX95wliFZSY19jAObVz/AjIHJHcSiZl3j/uNsHU3P+xzF/L5L3XUPWTi
	 i4C/mUdhrwtNC9zd9CyPiiNcNrreFvV8rT+jozO9NicbwCTl9/3PYHZtdY2kgEkF1F
	 MbVvKA6FggcR+IGhRIfmqvMTxS7zlAjVwZHIDA1JR2UCMycWRt0UO92uTn8PTP6TEE
	 XUtncfQVKJ4lypb9qG8vojAL+AQ8kfDZaf8Uj4u8xMqhjlWO08VLkk+2xemBaEpk8M
	 W55EWTvnv0qzNyO8rx20gYwsp161ArGyux5iPExAI845LkjSYWsOACBvQmZ2O7fGXn
	 J9KEu+rm0MNjA==
Message-ID: <86ce288c-f82f-4d73-ba51-4d4f4a6ef1e6@kernel.org>
Date: Tue, 14 Jul 2026 16:44:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
 <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
 <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
 <9e9345c8-30a4-4f78-ba55-d7fa073b82d5@kernel.org>
 <2911979b-193c-4cbc-85ed-f1d04a9977f0@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2911979b-193c-4cbc-85ed-f1d04a9977f0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80F38C0007
X-Stat-Signature: 5wqa799j49xkhywidf18p7fmg3y9u3wz
X-HE-Tag: 1784040287-994548
X-HE-Meta: U2FsdGVkX1/NSfE3yVj0fxXVLb5zzvCCjzckR+acHItfMy7aRADt41Phouwbt9rooVxVAI9950zjFmt/ygObj418lVJ0pzkCmHDy30pJy10re/gvD4pmemtdltbyE7Le5K9RBnmJ8kN5HEG0VGCtO0Ec5GMSTsLLLTgZVqyFZQ/Iu+eVD2kvEmrEJNbPgMgDy8EZYX8LGqee5RRgRaxqitYq/oJWIZCRBEFfvqVGyJfJS/K5/woLz9Xo3aEk6u7pp3f1k0/PdpWF02JDfYs7Uv6T3Qzf2tnKDRa3np8w1RLV3n09BtadMR+GvZ1zu+rh0oBf0c1AX1VS6Tzccedz1qSC053FHk8MjuK82f+dHpL5iGmzEKKHHBaseTXPzE3ldCdLPJOmv/DE1MPgt/nLmBraTxfsNtRvllwNhezdeUHzhUk6wJqf85T14obBlgVidhsCSEVLM4Qjg4Yi23YPOr90w5//DtVH3+BilheGqPrI5tRm2MSkIgPakXC0bmsh+5gZfyL+BxqkXazyv6anQnAu0uBjlYJDkEN5cwYY0pD2rxzjXhZrYZ1cQ+BCEvpPsFG1avWrRETL1wXkslIEsJPD1SyAw4/TCqCV4uWSnM2HIvveBwMf4FYjEV0kTxqOfSo4DzhKDFVa/+lk8j06JFo0Np0MusffRHw4UyyNVBr1ecMWWnJ8ESlSp0ufka1ir5Ib1WPrsZFzAUkqUAIllltieF3R+lO2ShZM6JsETBmqkxN3+AoQaNvx7SUe7rptnCT/7o03S1Ul50+8+yhW5/4LPaZ8OAmwonOMb+U2RRd8LfSEBdpqO44pjJoUC8MWKFs1Jelr7HSPDmlGXU6DoqLzGOYt0KSdXI9NcZg6YBQF7D1zy4rEzR6dojamDtZSCWMoEd1fRRyo6DDStDK42fZBG9EPhUkQRtcylncu92D1gAHbZUdhDFGWCsvYhpqFdDWcEMbDwCzQfr9qqaA
 Ooy26tPO
 X1zmFPl/5HthYtmQ6U3uA1UEpJRpXAQM+6VFO6C0pq+WM1Mit0C3gkWei4Sk9ZBJuIRroBCTwauzdujMvHxTdS7fDagIbgRfT9IygYxs/3Fg3bR05OKxJeztMiDHQ70D4sQnKAvM8KX5rM4RBuLmA6iDl1IA5CAR6PfxobWMXkMw6Q5tQP1wGdmJN1yU3QER44YY4Co/CB6mgDxFbDAHt6gWZ65SV2GqXtpTibpakgbbbF6G3+XIgog9GRQs73CTMYaKy3Zrd74PvsOUioifMHHrBkgrRxaxR83xrD67QkLQri3/pvwsFPQRDLCouMPqnYOO0mabzLhd9ITuL7tuVukSa+1gMKyda3aJdscq6eNJdjBfMHvw53j23VrLEM7lE49ey
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 15:49, Vlastimil Babka (SUSE) wrote:
> On 7/14/26 15:22, David Hildenbrand (Arm) wrote:
>> On 7/14/26 15:09, Vlastimil Babka (SUSE) wrote:
>>>
>>> It's not used ever as a reason that would be actually passed to migration.
>>
>> Right, it's a placeholder for "there is no migrate reason because it is unset"
>>
>>> So I think the name is more descriptive this way.
>>
>> Not sure I agree. The usual translation of -1 -> unset is NONE or UNSET.
> 
> (note it's no longer -1 after the patch.)
> 
>> At least I was confused by "NEVER".
> 
> I won't bikeshed this, so whatever.

Just to be clear: if everybody here agrees that MR_NEVER is the right thing to
use, fine with me.

I just stumbled over it and it caught my attention.

> 
> Just to avoid another extra respin, please also say how the following line
> should change, as if we only rename MR_NEVER to MR_NONE, it will be:
> 
> +	EMe(MR_NONE,		"never_migrated")

I would probably just have use "not set".

And if "last_migrate_reason == MR_NONE" that would imply "never".

Ye Liu, feel free to keep it as is if you agree that using NEVER is better here.


-- 
Cheers,

David

