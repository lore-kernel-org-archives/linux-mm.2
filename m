Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B94C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666176B0095; Fri, 24 Jul 2026 11:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6190D6B0096; Fri, 24 Jul 2026 11:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DEB6B0098; Fri, 24 Jul 2026 11:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2BC6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:04:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90F581603E9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:04:07 +0000 (UTC)
X-FDA: 85023990534.03.8562367
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13C44C0014
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:04:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n5/Rd4ev";
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784905445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdO7KCyyIro+bfenb1xkDQljGGt5dLLkhErcCFsE/Qg=;
	b=8BMk/rKwjzp87NoG5XUrfZDgTTQtKDUZg5Nx8bwDuwQTCH+IWlet9xAA4oBgKaygivf8cr
	hK1/MysSaUJ3pdmWnDpB7JYrSjmvH9+dKIn0IzjZumIakYAIhkVk15vBQAhqYCog1VmJ6i
	2GtYivCau/wS9gFHm68kajurebv6tPo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n5/Rd4ev";
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784905445;
	b=Yd4L7Ly4YJ2bIZJRemd2I1IobykUCHKFTkPiquYy7Nnr1G7zCj29rH+WEtrLKzukkuuCz6
	4nSlGOFwAShUd02Cd/kZu/YdhkAL7Y9ddOm1mdrn9JSTIQNIBVRtpNxAa6G7sS0/w2Vf5l
	uaMDqsLky5aMui0ZjovqCPyjHP/XGO8=
Message-ID: <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784905439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CdO7KCyyIro+bfenb1xkDQljGGt5dLLkhErcCFsE/Qg=;
	b=n5/Rd4evPANGbx1Hmm1azC85wU0nheG46FNmmGZJPiYVUUuGaxBTO3RHHaSsxBQmXrEiYH
	w9WBY2Cs+toTZTVSry5TJuqptsIkQ9usv7g3oI2qlLAi3yC1kjAzyk0KK+DRltA6b8/OHH
	0wfJYfPBAYVBhVVxrB7ixiXxNmqIs70=
Date: Fri, 24 Jul 2026 16:03:44 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amNzLXuwflIZFKtI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13C44C0014
X-Stat-Signature: dfotgfa9rwspx855a9hws5ua7rcgwmub
X-HE-Tag: 1784905443-632896
X-HE-Meta: U2FsdGVkX19cChd7+2RwDKW4r7ceVU4CSmMRwz3TZZ9WKz1QWZh00EwIUz9pqcwSGouKizNFKHqS1wWqX7YVINzEhIlTKX2Y5Zcmau5fPF681clb0fM1gtEuRxHH6dgAtS3Wi00mnBgNtw7SVKFst+5IUg1ZI4NZsGfTQrI0TrKVad3lqfAfHS3owmNK/82W1AWAgeLoE4qHPNSvIvxHZZIQ2OYK5YBodzZQKBQJqg79p+iTtbwudzcS+7c/grVqDQxrXmY2gLskDTpomZjQOxHYzk3xZwtZu0ccOtSBbd4M+KYg5RVaykx0LgZ0I2K9x+AEwRWE0wwsqmfQBU4lXFGd6cxIqyTfjiz8mkHNftaxkGU/aAxtWQmWfS5t4WVA70r2/9eQcnl0AWMg/ra8Ho0AXYqS+4KjXqpT1j3K97KoUN+huwRsvqqJWHil419x3vzOwnPkemKYdWziyddcIk5+imi8u0Y6xwn8KWSQcNMggGi9zqFXfJfEU/wdwYVLpdipdmanjVeQFyBF3KfzkbO+/KRr9v3f+WEKrWcyIjB7hYOsqJTcgv75Mjvag67+GXU5u67rT6uRyNzbfgmverBAe6iqmbXh2qRyLj4r9tuOhPvveIjcD6Se1mOL9rbjAhc6sTqmwbSwjZ9Az6hpb2kGG+h8FXMER9fUdpEfz+TEpusd93IvTNCaoXHFTz0/hfyTsz5SjlSArd2VL9Y0/1Hg2t5oBMZxbiqtaGNraVLkmxiFXagE/HE2JgeRzN2OJNdteZSzYYPjptGYuEKnB9RV1VQaBl2dPr5k2B2CAe54yoHJQMkKEASgEj4IeJOwMA1BiaLNOGKfx3OB2g46emK8xnwNoZzR5aJ03o0DCaqcokfoisqLKNfItFdLjnDm3cdLmcIXaMkFgBc0rqoF7tXdDCrxsVJ/yis+4m83TpSP8lGwEbRw/NgA/ZLDAIER05r9jD5ne1aYlv/XpY4
 dGJ5RXw0
 XabkP+KGqTKW490FbTUk8sAW+Xr5f2rxsCFC5IIpXAMA4dPrvEhHIFNyVAvFl0MYN/RTMLHFjlW0UCB/LWVDRH6vIpHX4Jy8gtaRH2qDZ+ZZa5A8iA7545z4HkuwyFmk4/F+seduNyuSwyQGsTb9QxH1UAD4hozXNTWMN/8Ehi1EApCLQwadKQt39lkY/vazYnrC9M9KSKcO9QstByp4N5hYYGzQxkV6hrm92YTYsYM3Jzhd3f9XJs/mo/ambix8i1uJr34WnQWqeWqwJKmV2HNgLv6D6VpMR8IEHJznwEv28yiwHlqJw1Y7G0psEeFNVHTlB0BhtmnyOJ0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 15:14, Matthew Wilcox wrote:
> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
>>
>>
>> On 24/07/2026 11:20, Pedro Falcato wrote:
>>> ptep_get() does not need write access to the PTE.
>>>
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>  arch/parisc/include/asm/pgtable.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>> hmm I think you might break build bisectibility if
>> you separate out the patches, you should squash patch 3 and 4,
>> with patch 1.
> 
> I don't see how this breaks bisectability.  Can you elaborate on what
> you think would break?

Patch 1 does:

-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(const pte_t *ptep)
 {
 	return ptep_get(ptep);
 }


ptep_get() takes a non-const arg till patch 3 for example for parsic.
I don't think you can pass a const variable to non const function arg?

So parsic won't compile in patch 1 and 2, powerprc wont compile
for patches 1, 2 and 3..





