Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB27CEE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601D96B0088; Tue, 30 Dec 2025 17:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE466B0089; Tue, 30 Dec 2025 17:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBF46B008A; Tue, 30 Dec 2025 17:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9396B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:01:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C533CC1931
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:01:05 +0000 (UTC)
X-FDA: 84277508490.07.DA6139A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 273AB1C0004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:01:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWivimCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767132064; a=rsa-sha256;
	cv=none;
	b=DXXn7oWEDzt7Vq7K5vqSx2LLYPij7lCoy0AZYvsPn2GZyrJDFTQq3m6qiY9C5S2tXxuYhw
	3ThG9Hic4MC/XGVRdqWMAXQp8qP7xjwjMQkuQPVhODa3jd5vG78hcTWTsfsRSN5pczWWoX
	knxNmYVTX+aScGlGRJnYt+XtrCXufME=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWivimCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767132064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UE2sOnzrZtZiedI2R8EUFbjjSPTGfccCw/KKzXOM9xg=;
	b=CL1LC03zzx8oHGwtqdL7KEtd1qXceUIaYNHk/8K9b0lbUjdkyM8du+HQEOnWJX7WiuPTU0
	CCvzg/Q8rHMfuxYBwEAYjc8nU2ww0lpphBuz+QRxkYTxd4TMgbBRhVlUSNUaCTNP+UnPDK
	c8ynVQ8/GmmyK4u5mwzNZhUSSSOWKV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D58E60052;
	Tue, 30 Dec 2025 22:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA6DC113D0;
	Tue, 30 Dec 2025 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767132063;
	bh=AwKXS5qfRcE5WBRvoQ+OLxVnWHCnRm9YUX47a62+58o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IWivimCrtOyINskmmLAhy6/igkHIx1E/ClX0ZQYGyHxk1UXhd5uoPMfkybAiHcQ9y
	 K/0B4XygH/WDV5uqQrKOIbdCB+qtJaKC+PKg5OwkNQEJWshw3myH8z4r+qJ23PjKom
	 NylPw51jkM3TZAXsborhx6SREG/OpbSb9x40L79Vd7ol9ySCPpR0cK8C9dCl9XZwGx
	 J5g/1E2ZX+bH0HFt0l4J9liDp+C+BZEOYpb0aDekIIyI2gfVEYS82vS9ofhpi2zLUk
	 Rgm3PiotFK8xfZrun03mCZClS+AVywjl0SBkxAtc2RRjy13TIxd3lEjS4CbBEBzDLv
	 fcDNuIJwvxAxQ==
Message-ID: <bb3e8b8f-4af4-4e12-83b2-fed6e20edd64@kernel.org>
Date: Tue, 30 Dec 2025 23:00:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 4/4] mm/hugetlb: fix excessive IPI broadcasts
 when unsharing PMD tables using mmu_gather
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org
References: <20251223214037.580860-1-david@kernel.org>
 <20251223214037.580860-5-david@kernel.org> <aVHnxxOAGu26a5Cr@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aVHnxxOAGu26a5Cr@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 273AB1C0004
X-Stat-Signature: zxfi3n4cko69euzh3oc58rs7be9sdhqa
X-Rspam-User: 
X-HE-Tag: 1767132063-662211
X-HE-Meta: U2FsdGVkX1/x1eZ9Z5bl0LyRCUdOvr14oZCcKfj1SPczinudbILKUBokqPU+zjdKs7jsVP4QklFE4Lbd1XPu3P9Ekp8qVY2fyu1pisyGU05+neDHsG1vL/bDdA/MtUzjjKrwN2nnX6LAIQkwIFt8QNpFJ23bKhhz+VDEJtnB3XWaEv85+HFCOp00FcB0WQU1rJrscswMfvEWMJsbJW+VoJiVVmhUfy8gJqBXEGFWYgx3x21gyW/ZLhAMcRr7Ys7G8yNdU+6HSY+owK5D/IsnSw6WvQSUFupdFWaZwL5Iy9eAcIuz4Dps+EXOsgrskS/aPy5xZSuPsiANHvx24kZwaJhMTRUaRKlfAxbgJNR9DLC61iwlUel78CTdHP8CQp3t5IZjo4Vm4AlX1TAYtyDCZ5qqNWhVuzeD9t9DS0gFPlUhLpUGNa0JW/W8Ah7VlJks+f7ptz+/H1WhYv2B5O5ywjUvMBQF85d9k32G6Cyag2rf8b563w6UsjKFtcePkPvFxk/S4RFv2McNPRSdSWMhoAs0OOBOcuAuVOFqluVMfP/6CofqG6Zo1Zv9Fg8TaHAVde+f/QTbNAK7qnZgHZCwMZ8T8FelLpuzder3lS9xTsCIL0P9yOpmosgCoLYYO3OhV083Qylb0Fr3U20cXkiqJn7qJS2lcPba+Vp2eAX9Y5Iw3Py6usiOzVLXsTD+eJD0wrtBFI453HURRB6O9LdFgmWoKgsnXEBRQEh7IEc5NjqDf/P7ccKX11zmFbzEAKl+fL1gOmvEag9TtFcObyr1iiadKOVpWuT9YRn8Ogz00eUwHoF47nPn2+C92TbJM3RLym3huoN8UReLRER5Zcp3A7M4vKkO4Yb9vt65VRn/z8RDYKpL6VsXYiTps72Jh8RXgnIyJJXNivE1Lf4qSyWKV12Ha4BUL9A63CzB6NZ4UW27OduNy67VxQH1X5EMO2wO1TxqcaUBnP5yuRTuK5v
 U13LHhZB
 uMEoIWaOzXxu0PTMmY2foW+egCXUpdv9fYPthuNKk5iamtF2lHZC8AeMkpG7k50gW+JM6vROoZOu48+B4QnlfBamoPHlisH2b46PYXwbB6QocB/GOzDxHVne1GaInZ+1VoHAuJz3bxqx7QQaL801vAdRklEgNL6QHqslovZKhWRPMIa8vP8bPdNdGc27ikKX2h+AdvyhIBhwpbgag6fcIJFUhpLppgFzvcs8/DuVlWbHkJzPZmSFxglxYm9BPFWaZXmJaiPm4Y9XrryE2YKeZtImBTWj/AiPAeTMpIhVY2sXnQ32LcOUWqsu/3pcSpb/U95NIF5gH+IMed8ONqbDOCYY5BlGkaH+w6rJGdNpY2am9s9LJ9DsEZgLJ9UUXYDa89gb7S0xhCbv5O+1p5ychCcHM5fwuEwA9tJIIF3164zcguuck7yzXc1wKR9JMW20lrF8S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
>> Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
>> Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
>> Tested-by: Laurence Oberman <loberman@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
> 
> Looks correct and nothing jumped out at me during review, so:
> Acked-by: Harry Yoo <harry.yoo@oracle.com>
> 

Thanks Harry! And thanks again for making me look again at the hugetlb 
mmu_gather horrors :)

-- 
Cheers

David

