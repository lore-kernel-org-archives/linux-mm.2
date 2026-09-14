Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B51C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8DB6B009E; Mon, 14 Sep 2026 10:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ACA6B009F; Mon, 14 Sep 2026 10:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2EB6B00A0; Mon, 14 Sep 2026 10:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51AB6B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:08:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 497DDA0166
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:44 +0000 (UTC)
X-FDA: 85212548568.09.7156916
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 870BD140017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzEF7Zb3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaKFw710LgRLsyJ/sC56wEF2fzSq0uylE86NbWhDQFk=;
	b=cBCznt1MR6a1ypXPfLsWn2UB7/6Ia2M2M/Vu8wWANipk/vrDoy0VD2eR45ie+8919EGWox
	qvTNueSXsVCx9qr9C3Q/sX9G8EedAKbEFnwH+P3mQujTNhj/+nthPudxEkn8dxhG/5tMzW
	XTDhcrQ6a7m+MFg0xJ4CggytXKW/vKA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzEF7Zb3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394922;
	b=ly0O0Iqjqn/LLXcMi4hrRcZyAl3xgkLr/RxU5YUFkn49UNC5mssxF/n1nzOVvij+v+oVdI
	xiEVUbAn32LNfqiak6fH6t6x0XB1xEzF4IxCm82vDJ7ilGr9aRYsuxV36RsKDOCbMMFroC
	FROUYy7zWJCOJu/IceCHCk/7CLsVkws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 116D6601DE;
	Mon, 14 Sep 2026 14:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7751F00893;
	Mon, 14 Sep 2026 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394921;
	bh=AaKFw710LgRLsyJ/sC56wEF2fzSq0uylE86NbWhDQFk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UzEF7Zb3UJGxecxEcgSsAz99wwyiMM5BiGcoPMbkAEDPDmqMuQ9UFozqJYWHlZdBC
	 OtsX63NB76meK0n19FgNlFs8oxWKYI39jRpq6yoATZg8qBlLhYWS2YNURkSYoQ5xm0
	 w550wwCy4R+AOte8TAFL5aCiNtQUOBFzaGeeMsYtCNey2DPwJS8qa5suW1YjHwMa8j
	 ZVAJhp3SV69xE5m+FWqpS796HgzjC0SiF0GMEclJfrwGOL+gcyuE6m98mwBoPHfNbX
	 Sgk094fdDxzGYU9Y1iusw2d7abhC1Ah681lUPNzc6QT2SBdnwLG0yQy+iN9+PDNzxR
	 dBhfuHWyc+ZyQ==
Message-ID: <c60fa1c7-ac83-4e41-9911-a426c6b42191@kernel.org>
Date: Mon, 14 Sep 2026 16:08:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
 <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
 <aqf_XGKDq6jH6pJW@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqf_XGKDq6jH6pJW@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 870BD140017
X-Stat-Signature: yb36nzf7w5uk64onxndkxepcwywknafi
X-Rspam-User: 
X-HE-Tag: 1789394922-414296
X-HE-Meta: U2FsdGVkX1/JYeQunIGAYpifVolXYfuhy/4vChd3EDf09xzVOkUCG+HKm/Auv+niToYDMVVHdPXX3OnoeGirHefKCku7MGgQ6FXzOGlcPzx9xPn4ZZg/B9g4BQKR5R+qLSMkLLoQmBL6Kd4EYXtV0nnqF7+Yv9NeIYqrSfGsE2YIEhuTqeBrGSvBY9z1COIfGh2aBcPpLICFEpAkNoMbMKpJDQj57p3a94JleVVQ8vjh9SppbeIPTQDf6ujel6QxDwMivNuspCHr3LC3VJM0yfGdKSXp1QsFDar4vUEo8L5WxY0hlvEJ8XdDEDpmh2el9wc7elx3Asy/TrdQwk5zKaLA2IcJerlhEvEI5Hb20OQJUTBAtnVmh/d+lqS4Y+3IsTGW9nc11tmuB1ipatYCPTiSmXJGdXCMZS+HWxmmlxH99xXuwKh7Yq+sS6RWbykaaFSYABnSN/PycQrKZna26c2H/UaE3CWqL5nASuEr235tABmn/nnkc5ZE8a4AxcDtGlsm5bT6BsJTN2hA9pg5BCPuT+Xje+f7PjbIK40JjCfMc6L8cVSDgFDFtAs1sf1l5pp9MpytXsXzivv7s0Cyb8794Iu5r0QIOJUBAzeC7GU00ZR8BuMlUR3om60/HdwbYhQ+36RIqcfLdMJiY6a+9egmk6XqyFLUVaa+Z4/ehs8gR9qF91jeDQWFGZZwvN7TvJOSfq/VC3Z5uWo/cZuGxXT9BToY/FcbJvA7TVN8vmkH9fIyXLLmVheihRkQ0bEsR64FZRbegLE1oDxXeS+9VOTWXNNrX9gg/USSKdJoL/W0SMKNPjilQmA8T+gVC2CKrWJwR2g3At8jY4vYy/t3OvknyCPvMz71mDmfRZLcHAZFKlGmFnTv3Cd5XA4bB6RK5/Pt4wdlaqbuDy6ED5JcNDaRl2wp85DJAhQpWKGcSTu8Trv2LlFWCH17zO75a1Xsfe8Sg/17jvaPud1BQjq
 4KOSWYM3
 S9QlJKgsQXYCVYXcKNYlTSVGfWWhUomKAmXN4d2tQOtp6rTuXc+tnU/4nI+gEmaNFmOwVFdq9zL67JTDN8E/JEuLMMKaRioanUOS1LBlqoFWdiyj3UqDUDDW3EUuQPrbZxEj58qsN67EgLswNaZf+sTd0gEOjCrxdVVuG9buRb4GRvcuexo647oLGMK4Upi4fFq97kUxznKNScWFluT49GUW8QVDnitzuK4VUuueA96HeGJuZyM9FF4m2CTuHYSpFFE0VOH8+vGwL9VaPurkHBfFP4onMJ2OpFB775Xijd33QPHC2ZwB/p/cyXkkuCXN/hVdGFwAwy59zWNspS2OM0JoRViDcMJqL/MzbwBEpo8WUiOYW2ODM3K153kqnwpUkCO+XqK9ZNhvOePc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 16:06, Yeoreum Yun wrote:
> On Mon, Sep 14, 2026 at 04:01:02PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/14/26 09:30, Yeoreum Yun wrote:
>>> Introduce size_to_shift() for future users that need to
>>> obtain shift of a huge-page which is other than pmd_psize().
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>  tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
>>>  tools/testing/selftests/mm/vm_util.h |  1 +
>>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>>> index fd1432dc6152..1fef1266429f 100644
>>> --- a/tools/testing/selftests/mm/vm_util.c
>>> +++ b/tools/testing/selftests/mm/vm_util.c
>>> @@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
>>>  	return false;
>>>  }
>>>  
>>> +uint64_t size_to_shift(uint64_t size)
>>> +{
>>> +	if (__builtin_popcountll(size) != 1)
>>> +		return 0;
>>> +
>>> +	return ffsl(size) - 1;
>>> +}
>>
>> Could likely just be an inline helper?
> 
> Okay. If there is no comments on today, I'll post tomorrow with this.
> 

No need to rush, leave some more days for people to catch up.

-- 
Cheers,

David

