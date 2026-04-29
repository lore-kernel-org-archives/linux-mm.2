Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE9EFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4466B0005; Wed, 29 Apr 2026 01:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884F76B008A; Wed, 29 Apr 2026 01:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773C36B008C; Wed, 29 Apr 2026 01:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D616B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:21:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1ECC8BDE9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:21:12 +0000 (UTC)
X-FDA: 84710444784.16.CEC08F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EBEDC20002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:21:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXyJ1Lbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777440071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvpnFcu1Midr6AKA6e+oxJvN2UlLqFYVDvZIL/qOvr8=;
	b=g2IWiOUUGbegg+SN1gfEkbe34/LDgxTr0fwddX6ZdFjj6mvEZ3Fb+nhiLwdLGCFMyjoKaK
	IVvnUMlDsYB40YVOgQqfh4YHs4MrAVIlKe8gEWfbBwnTH/324IVApwI/u10C9ubqWYSpWO
	EvZV03l9iqISSbAw5soNBmo2j2cyxmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777440071; a=rsa-sha256;
	cv=none;
	b=7Ye3j565DkLVyKkwCsO+pjC1JerowCrcXVol67iofNcyWck42OfzSflTbfvQn3CGtKHDQH
	98xIw8xOPVNRnPLSUMZPIzqminKIg59/ADx52nnVRNZ81RIu3ENDOoYDLgKgsDjtxz5rvC
	9QeEFfJk4PHObZIC2ShByyzQ08PSEDU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXyJ1Lbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF6A440183;
	Wed, 29 Apr 2026 05:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADF4C19425;
	Wed, 29 Apr 2026 05:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777440069;
	bh=JbSRCPswSV+fr3ncCbhnpMP5t/4xPQUWyw0UcG4ccnI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LXyJ1Lbx7eea6IE0Le8OInjBwSgYxAglA2n5i5lPYTDEiyv5/of+aBsboS8DfmG8y
	 RjYDyuDFWs11TKOZxsTYft/EPowNU3hcg3gGXLIHLAu3qlgCL1XAWkrnM2FTe7uJ7I
	 IW0OKMHHGD4fLTtAtvWd9ypPtmb6qZTJKQ22pRxQUS8W0a4O0FU8VPaeneh5gRLzgU
	 8kafCwhiN7RLiwwRx4nFl7+kukWq8tuRLEwDIBHqsCeeghj0A35cILjK2GOB6oeof0
	 6wPTFDiutj3nOsTDg03zLg6ZEMMPbKOR4czUi6ZuhPS6vYnUwksrpj0K1cILnr2ENl
	 CUEhu1NolO4tQ==
Message-ID: <64125a84-848d-46f0-9aec-d0917294fb45@kernel.org>
Date: Wed, 29 Apr 2026 07:21:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: cleanup pgtable entry accessors
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>
References: <20260421051754.1691221-1-agordeev@linux.ibm.com>
 <5f45cc59-d71f-409c-8cfb-6eba23b0a447@kernel.org>
 <3faf45f0-30f5-4a11-850e-3e5ed7668c72-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3faf45f0-30f5-4a11-850e-3e5ed7668c72-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBEDC20002
X-Stat-Signature: sbzaqh7jx4ck9fbqnhjiebsd7mhn8or7
X-Rspam-User: 
X-HE-Tag: 1777440070-188395
X-HE-Meta: U2FsdGVkX1+uMlSiyTUqjZ6eFXpcwLsooHz8X1N3CR00uweIRitt5uEtdTAz1qINpx7wwoMogBGakpa3C/YbSwBtDLQwrNTYX6UbmzUeEu+j6MMQ6uTeSUbWfExraOtDtbwgKMmguqF0PS0kr61YiXEl4eAeABf4MfkSbLssrPbTs+ZAGtZYyfQY6xW6OkZ1FHuJtFw84DAIMXJ+Wjln8llHyBL8ZKp+UADTpboHw0AydHQDbTcdO/KdAAljzrB4/SM679VwhdxxnHZK31m4vE6ukSbszqmMpoJuzQZcSlRGaX8kjJ1Amv2g4a5UtEjWKNCdI7f41CMjV2LKT+nJwBY1vuIelRPB2fRNJfViNS685OV6WIgH65BHSreM+UgKWuzUH75TrhsFstY5JhK8UAaDepdz0Uf1rY8B4GZHsOdts/523MUYFPCAyywWW+50VZJIDpO06I4jvD+QJh7BSE6xnbMuPgmnsGMcLUheQAUhjajErrwTMvf1MERjlM3ysRQmja9gF/65nXxgWfu17591LTiAxcvUTHXOzZuA004mxTTtrSwgHR9FXGM48oeGVBkTqBFs7ZcFNyGD5slZt8y/v1P3wDMsEp0S9U4vAIinQ54Y9dBaVYhTV3vFvKqWo0whu91WeqStlXniRYAABDQgj6grYyJL10zZf2YmkYCSKUqOCkYTBKVp8eXqXX7U3un5bmq5Tqmd0vALpqN+48hy7K/CBrjMZfqohtCc/bVFGkIknt4WXd78mwyNBRg4wsY/asvAZJn4yYcWM3q2whrRDGZt0j9+qmfccGsDQFQs4ezWNRLfJYNP9WpySgqdvMnWkFWFheOVQIbH2R2Rr4uFBAH/gxJxeK6I0RZv0KxwfB6zTTDW0i1vup0Rq0YHv+ycCV1dp5PVBdC0u7H89yPOWDT2M0Uc83JTjMIONn4xhC0lQIUIlxV+QkJzSAAtac0O1BJuwmDca2Pa8zw
 gAwzcsHD
 A6QHXYXan9lqCwPY93ZqZrc5G66A7cwaWorAhpiNXrD54koBaxAb0sB2avG1TknAKaf/i0kpEpRra1dOASxtikRv9nnqHirfvN8K5j70YQxdpAiVXOD0jrLeZ+V/0fk21/nViUtE7VqUaB0sZF+sQVfiUX0j7TweiNFO0px0pJCPQJswMJKzwNo4zhG5PxnKdcXl92tyfelWXaGAxtg8XPuoEYIk1ba2EmMQbnbNkAEYs76aTu/HnYNq1DNnKYhnmaOF/djv8s9z71Us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 07:17, Alexander Gordeev wrote:
> On Tue, Apr 28, 2026 at 09:45:59PM +0200, David Hildenbrand (Arm) wrote:
>> In general, LGTM.
>>
>> I do wonder, though, if we want to switch to pte_same/pmd_same/pud_same while at it?
> 
> I thought about that too, but decided to keep it focused on direct
> dereferences (as it fixes a real issue with the pte kasan sanitizer).
> 
> I can send updated patch or a follow-up patch - as you prefer. But
> if you like the follow-up I would suggest to un-squash the original
> series to get it in three logical steps: 1 - pXdp_get() fix, 2 -
> lockless access fix, 3 - pXd_same() cleanup.

I'd prefer to keep 1 and 2 squashed. I don't see a good reason to temporarily do
the wrong thing :)

A follow-up patch works for me, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

