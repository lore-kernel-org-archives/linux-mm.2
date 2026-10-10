Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECBECA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 01:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF18C6B008A; Fri,  9 Oct 2026 21:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1F66B008C; Fri,  9 Oct 2026 21:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8386B0095; Fri,  9 Oct 2026 21:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97DEA6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:13:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE1E2406A4
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:13:05 +0000 (UTC)
X-FDA: 85304942730.01.21BF592
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CFAA140005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:13:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hg2oA4vQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791594783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LG//Jli/TinVrF7/pw6I/zGy348UH4ol7I1gnarYG8U=;
	b=bTsacqmHRIctJ9rm3O66aMUvkPlnj8NZ2Qk4TGslWwGfegzPqlBQ64KI0E5id/mATOUS3M
	CXSY6wbwD/GvIRFCTEMdWb+Jnwfvu1KL2S8iQYnScwiARLMNYkJaaksiVzgP6Wf1Y4tYCl
	DkTNqgORTrROrNteZjWs9f6+de3T2bo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hg2oA4vQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791594783;
	b=f4c3fjly8bfGOKBA4GEzv4UGPEHmTGjNLQUnlQi9wcGhlgulYI5bL0cTYXvD9f8rEZLHlk
	eWgtDf0VvnlGbbzxwSImcRNjO5s0H275MkQ5pvGPzGwZ2KGYC/NmB8psNLBzk0gzhwAnz7
	MqZEV4uZWGawm9BPF5nhW6hD7xhy2do=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vgSSjwqoJ3UL9SpCaxLIlO+CXMUgBIurc/MPR7NqdSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791594779; v=1; x=1792199579;
 b=hg2oA4vQ4SiQPWoa8gt3sTBnuZs5ox+3Syuyla4g6zq7cwfE7gZ7i2ogDBFoZ6CPz1E3rvwb
 fi/y0+u+GpiJhDbLHzmTZXahtcfAEj0395D9giLkuVTrZdDXiyNl3IBzP6abI/zZ1ABYftNIBhX
 mQQ22QPZE/KkYgeLlBN55gJw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9e75b8b92041ffeb;
	Sat, 10 Oct 2026 01:12:59 +0000
X-Mizu-Trace-ID: 9e75b8b92041ffeb
X-Migadu-Flow: FLOW_OUT
Message-ID: <0ec81c65-fbf5-405f-948b-0fb1b2e083e8@linux.dev>
Date: Sat, 10 Oct 2026 09:12:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: avoid transient none PMDs during lazyfree
 reclaim
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 stable@vger.kernel.org
References: <20261009165214.40212-2-kylebot@openai.com>
 <DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com>
 <8db35dc0-eb06-42e4-90f9-534522e810e1@kernel.org>
 <55765FF3-18D7-424C-984D-81C316F323E1@nvidia.com>
 <d68cb3de-e471-4ce8-8c6d-c7260d79ec1e@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d68cb3de-e471-4ce8-8c6d-c7260d79ec1e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7CFAA140005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: xihgk4nnc8shqinkmbuj48fcznrgmrmh
X-HE-Tag: 1791594783-775770
X-HE-Meta: U2FsdGVkX1+0vJ4NUtVB88dY/jo3tdXQDYCVxawzWE/o3obq6z0shjFe0cHesiMFF/ydT90flmdvs9sFObgxv1Enm9CEvNmiQcteZFoue3XKxwaJV74lU6P0qQju+cWcCCqH9yyhxOiknjUgls5roZEbpBX/9hQtOlEyyPpM/d05NIabg+wPMwbEE/0u4uKk0qomCErKQ6laM6UjDMSzQMjGwqu4YGtKxmSDngwf/OnoLcbNyO6Gbvixqww5dvqLrFxuZUFnU7CPsNdc41WHpFAIKWCUNd3Y4u3APVofX9Y8riwbCfwH11YgMWNb6DlE1SbGISbGdwXE1wzSadw307R7D0B/wXHaffKF2zadoiUOsGHiFsol3eWDXXMCGjKqi8l0mSyl4w8oUdTyBGE83VOWpxb+Z/XTwYalw0WBLivtx14mN/oEw1HR1KvwbjpcN85lxfdahXab3b9taQmX+tCvLrbq8ChuMc8HR/VGBXmjU3bnjMh/JJk6qbzny2JaW/wuxk1OKOl1MCJziUIIwczOxidxuKPxq8XySTfoyDnHybyhsBE4KZmKX5VhqAJvQA1W+7VdSCjDdz/ptOHPjaRxtmzzS3JxbSpN8IhBI24sptUY1FnfMxH8CNQnai9V6YgmYy+yWg7WGugsp+n2pnqATE3N2nhTpPoQ/61BOvw5kRcrUpPNFDt9dMdX0fHn2P8f9/FA4oV5DhC6L/oH+iNlHjgHSDjMmsOOREDuAV+SGa3c0onZPk9zOMNx1WUoj9Q+QInKozWDjLX27jOaecbdabf0JIITJW7CylhHXtkP1cWmZQlQ5rx8Efu3GN4cwYSkVlL71FyZp0tvtmunIN9rWbC761U5uFa1sjwvo2jnI2NedJyno//s3pafoWJ5RssfperbU4eYNZcQ02IoKeirMgR0DXZvTHjLE6oAq2/TByGfox6cJrav4VuOh1p1z312gbXr7Am1siQ9JDC
 vV0STSOj
 7Q6wXZ2taWKprD7Vzm4ZyTQ++tPiZhCplTdD3/75eqn60dUOZwE9KBTjI5wQNLr5xJe1NVCcBn4qgzAPKNB3zH6R1BTL72XwxpSF07qNEqjxgIMIBhKuxV6J7MGI80z1PQXMjQiO1f0oMKFc6eZPe3rAC1hSjMsHQwCggPw6plnZQNFOgZDdI/uLA9swvHuB1W3RX3CFyt7BGCY38z7vzBrnPrsxrVzKzCvsGFv6FU425TEnU9a2LkIoGpgW/Z/eG8DwNXK/F9c5TgD59ZLp171CMatVeos4H46N4cTAL+xCFHeXrJYAypnmrJrZ5WTOmst2r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/10 04:44, David Hildenbrand (Arm) wrote:
> On 10/9/26 22:27, Zi Yan wrote:
>> On 9 Oct 2026, at 16:23, David Hildenbrand (Arm) wrote:
>>
>>> On 10/9/26 20:17, Zi Yan wrote:
>>>>
>>>> There are some gaps we need to close before getting this fix in:
>>>>
>>>> 1. GUP-fast cannot follow the invalidated PMD: riscv and LoongArch need
>>>> pmd_access_permitted() that requires _PAGE_PRESENT; s390's
>>>> pmdp_invalidate() needs a change.
>>>
>>> Ugh. We really need pmdp_invalidate() to have reasonable semantics. This whole
>>> PMD locking is a mess :(
>>>
>>>>
>>>> 2. sparc64's thp_pte_count can be imbalanced with this change (based on
>>>> Lance's offlist feedback).
>>>
>>> Ack.
>>>
>>>>
>>>> In addition, powerpc has a page table check issue similr to riscv, where riscv
>>>> fixed it with commit 9f4a88b8d01a6. This is not related to this issue
>>>> but discovered along with the investigation.
>>>
>>> Zi, do you have the capacity to take over this patch?
>>
>> Yes, I can take over it. My plan is to send a series including
>> patches for 1 and this patch as is. powerpc fix can be a separate one.
>>
>> Best Regards,
>> Yan, Zi
> 
> If we need a quick stable fix we could temporarily disable the whole thing until
> it is fixed, just a thought.

+1 we could do that for now. A quick fix with minimal churn (correctness 
comes first).

