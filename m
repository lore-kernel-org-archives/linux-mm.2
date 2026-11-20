Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C04606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1yvVJtM
Received: by kanga.kvack.org (Postfix)
	id 841CB6B00EF; Fri, 20 Nov 2026 05:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818F86B05B0; Fri, 20 Nov 2026 05:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EE16B05B2; Fri, 20 Nov 2026 05:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0356B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:08:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E09E80EDA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:08:19 +0000 (UTC)
X-FDA: 85455072318.21.DF030EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AACDE1C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:08:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1yvVJtM;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169297;
	b=FbCOX/qYpAlexZNIqOiaHDJ92jCpoBY/G74nXG0edmH8AkBjOmr9oSFnE2P7wQN6ho0cwX
	61QCBVFwEoVA5LuckZWw2iYQpIZqgBubve00DPgdDEjijRJHD9Gg6duV8lXxJde0F7CI1p
	WSOtpagIOs/Erx0TpdK4RSwzIuLi73Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=904Id2mFYY8G9tfMtZ8uCIKo9vL7+Pz8s2yY+3bhtdI=;
	b=1Pi2R8xFLpm3XQsDi2dM91G4+3bWI6mRuDVUwUuetpyjm6mhhVrItvqNqAwf7N0M+pSO+X
	UJnoviwJhPZeu8fAyM/AzPcVvMHVTEn/ujY0a4bUlshnxWvZlH/5le++NUzYtLJ0ri4YY4
	v5kXnpNEjU3421JNZwVn0ngTyjzrBcU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1yvVJtM;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF2974189E;
	Fri, 20 Nov 2026 10:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A11F000C6;
	Fri, 20 Nov 2026 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795169296;
	bh=904Id2mFYY8G9tfMtZ8uCIKo9vL7+Pz8s2yY+3bhtdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T1yvVJtMPpbvYWV33sppvQMr94v8/qcuMN+AaUhBPBAQdoa7J+muPM0seCCXEmvoP
	 wSBCS13M3ATDQgkLCIHvsvLzz8A6eCkVahFyUw+8ALZL9E3BUfvpqwSIZx4QtiXmjK
	 TzT1w68BzZ+9zo+KmQDtt3Hc/fsqxNq/pHK7WLwqQLxeGgOo8HEDCAMBdGoT8kqu+J
	 IXGEKtSNgNaJ3vafSxbmuJqmjG4UbQKRj0G6TLyLA+pfXzx0se0u0QKWQ/6O7Z6uMj
	 PbHSahC6JIRW1NP7qYysFYw9xmd2qXqiEJtNToff05buVoYIOCmkTOVQAJCvMStwjA
	 hEirQ323kLz5w==
Message-ID: <a0a5c3e0-ef9f-49ab-9f2a-d1a2e1e1934f@kernel.org>
Date: Fri, 20 Nov 2026 11:08:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] alloc_tag: two fixes and one cleanup
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <1f12c78f-782d-4d03-ac3b-7321520f02ed@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1f12c78f-782d-4d03-ac3b-7321520f02ed@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: ujj986ojneu6n9wz15q1rkde1n57i8zx
X-Rspamd-Queue-Id: AACDE1C0002
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795169297-564152
X-HE-Meta: U2FsdGVkX1+LNWETaKymmOwWvv2/RmCUHM3ZDks83sSBGKjQGibnb4QTYLvdhDAlDrizU+lHVCXWp7f3YERsj9+rdyU/UYpDH03ddqlf8CRE9VWVzlghMvx2NQnPd82aiv8lhDgfJ+Ymefl3GzqbV6EN7HS3hpfLxIeSky/pIrpNyTK6yORyrwgrr9usXz89OKnjUkYvxArRag3z5c9UCYffv7hL2ySeQHcEPdj9RTR51sPFoIG3sIZ52xPImoYWcCe8I0o7QlPEfDpLvm0d1T/tzY20t8hfMETkypkerA4SYnsnSvVnoHgn1PCmRY077Md4tEyf42dovc9pFKTOI3pw2z7dIRi59QO1Qi2pVCnpTXNC6ijMFJQhfgEDJIfeHZtpsjQtAqi3uKt34wAqcbGmhrXfYXtqfbFHaq2hmInr3f01r1RUaaE91ip67bscw/CrwMlqqAiynv4PSmkf9qTyttEIc6v7dm8LVpq5d582avLBLaLDqrNOxivbsARbTq/uPk3kWnRodx9PfxTB60hjb7FCcnPw0njD0mJ4QIouUJgbJnptuQd4fBKNYTpMt8uDeEsgn87sJ9HG1UZ4rK84tDZcTS6O5fUnRPNVi4ybMQYAeo2PADRDjihVC56thGQ8SDUQSyBl5GMCCJMbZ1t2I+wPBjOCeVeFepmMiO4euKJ2u9kAAVxAo8rxXaRRStTJKDkMN9MKJQydGPItSjKRPqPQsGLw6cLrG8H5in2dW5l54ZnDri3Jvz+J1gStpATK9ZnAAK9d1c4sk3M0Ulf2/SUPSavvekIDhfH3AhQbpUgnlqqaLJ+td8bi3TKWf//uirCSiWQa3ZK3PowSCsUv9sLsC3WYlukqeBMpuaPqwZ+kDqxJlYrn+AUEPKDelenzHwbvTX7sAKkrzL9YXQTIP1Pq5Si6FONEZtUG5Ule83rcIv5WjCyLLILHG7zNckKHkBLJ334bO0ey5Mx
 UTzCBkWY
 xebn+lQqq0lnZmGJwNgXDX5PlLLC1aDRtdHKeMB9PDgH/NlSs9coE0Co2/qwHHWvSTa7g3LvDh4PE7TYAh03A5ZKwhNm+bUKsCseBZdZx/B6AJ3CtPl7iodZI3S95dWcnPwXvV0VY5zkbHre9Odf3SKaY8UzKxncqIJ/DokuRTODsJwk2eH5Q8Od1Dx2le9n6GRB9rAWAWFAYQ11u5mR2R9pTB34HmBdjbnBAcs4zPeDwZ8b4o27X76DRMhqMyNRphyeuh88wp2HvX5W+vj71n68UuROtNjCNk0rsNmhJb4jQkwLHrXYC4RWc8coiRwUdvMy6jAglmSw6pRaL2AlYBz89QQW1NfANlLjSgb4NYeO6FguzTAtpDXaYEP3yub/kRaneubAbTEGR6WHjIjmAmyCMAwvJSSsTXeAgEIsZ4Cv1NvZ3rsmhg0wCTYoV7e+375czpf7mSHsy4MGWv4qoZNEI78d4YOe8SfPYMvwbGwGHKyk6Z0FHnYsb6YbmoW8wGbeWQeUlItWoc3YzTNb0WBZ00wP6duG9+IFN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:02, Vlastimil Babka (SUSE) wrote:
> On 11/19/26 09:52, David Hildenbrand (Arm) wrote:
>> Hi,
>>
>> two fixes (one for alloc_tag as triggered by slab, one for mempool) and
>> one related cleanup to make things consistent.
>>
>> Quickly reproduced and tested the warnings in a x86-64 VM.
>>
>> This should go through Andrew's tree. No need to rush, it can wait until
>> the next merge window.
> 
> mempool is part of slab section and the first fix while in page_alloc.c is
> also for slab, so we'll take it :)

Thanks! :)

-- 
Cheers,

David

