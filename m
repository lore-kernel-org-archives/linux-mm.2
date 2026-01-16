Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6D2D47CDA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91F66B008C; Fri, 16 Jan 2026 05:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D463F6B0092; Fri, 16 Jan 2026 05:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C286B0093; Fri, 16 Jan 2026 05:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B57546B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:58:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DB771BF64
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:58:53 +0000 (UTC)
X-FDA: 84337529346.03.0CF37A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8C194000C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:58:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oc+g5iS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768561131; a=rsa-sha256;
	cv=none;
	b=ZC9a3YGakgHbN1cVeXGHZKdiJ56FGXAuax01Zhk88SkPnAGI8H5kqFxU9MISuGPRcqjJcN
	JKlzm6MP+9xSp5Rh6fDe6xk6qX31I16UBkwhFb0AGmfZ4VzJ2Kbn5PfAAaVUxGrmSfAPwT
	zqG1tjQ0fDYw5E2dmVyx2PKFlSJNOj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oc+g5iS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768561131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24jVIuQKZJMKSu5ggCFBPpzP2obf+0gblKxiwrgQID0=;
	b=jfB8s/k0OPDD5m+XQtQ07lrPjuyk12NWVvmaeSyHf3UmgeTG258o3iwh3fAm58YjPAjKA0
	68czHDkqJwTXXEI4qyVCf6Ekykf6lfT8xSThM9W4TXQa0xX3fUTyQfrEBVVt7ersalKg4L
	+ADoa14+5B1pllpKguRi3TASYwFSzz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E53160160;
	Fri, 16 Jan 2026 10:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96405C116C6;
	Fri, 16 Jan 2026 10:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768561130;
	bh=dkGMnUjZbPERXe2UzCZdTDEfsSR+wJN4pvnWwDNOOY8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oc+g5iS08BauBBDTqNA6YL7U+mPwbB6i646TPD0vACL0CvFaPzyPiPQ2Yu44ReKMA
	 rla58KElVtFO61BpBrkBWDmU9wWjZFg+0Dn6weN9uCXC/Toz/c3fpq4KUqspweianL
	 aLY9iSKrhUpq1B0mOXbZQGu+qqyV8RmNedkRs1dBUfI83GDbX+y1iQNjaiJ6H5Iux7
	 Xkc3qxW7lQP73zsWFi+uEWKD4PzRRl65qabODcowiF9vgDX5PRRLuPRbJK7iDrt7PD
	 lQrncXDIHTeAZtD2SFgP0k/LpM4SR4I0v5xz41qBozNZ/suoopHJDKhNszzNkXX1rs
	 G/qMQSG2FFx8Q==
Message-ID: <70d46998-a6c6-4c18-b8d7-f813582d3143@kernel.org>
Date: Fri, 16 Jan 2026 11:58:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: akpm@linuxfoundation.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 mgorman@suse.de, linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
 <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
 <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
 <1ad31dbd-6743-473d-9f66-a603b91d1e54@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <1ad31dbd-6743-473d-9f66-a603b91d1e54@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: o5qsdj7gukp9ocn4jqh3uqem9d3zo4iq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8C194000C
X-HE-Tag: 1768561131-155907
X-HE-Meta: U2FsdGVkX18RZbBgUBKaZJIM9KcUdC8zCWTm0EsuzWMtEzlIiqZA+JpWrr99ewelLyumZWF4whaAvMDI6iM3trqe4I6BN67meQk1Ab1Ec/ps6/khEgx/I3K9lNMMUa7va7ZoL2B1EQEQwjyV0OoaAxpuFwx/NLZB5AM0Z1qJ/AjPKy/VzNYRpbTKD/gajTzYtZonrpGqswcc8wq47rXg19gmKmFuqhUZAcDFClqmfN9CuFpRIwwv5A7ZnWDc+9jpQrp0MpWwAjI6cfqbaQ0wuKoLvvlTC48rW8XnVpkMh7yyo4V3EZ1Ex7keISs8uvsacsSotSr1f4FpS8yuLq2Rl1gj7I7P1a9UcNR53uRf6Tty8ZoGYoWeHevFkjjl61W+VdUTJX7GCZiD9bu/jQwc12riYlnH0DSjB1voDNPVpWU5VGE404UeHdwjCGYrMA+BoplBiNG012duPzy5tJi2zWGd9o0ti+eUuQlBNcIRYpdsvGz++etSNPf6s9JNqaSvrlSqXLwe+1pdazjo0FztkcTef8TKlOTA1u9UBlizX5gQ5sgc0SlPOdoJgmnNSBOiHYmT+x/WM/bTyuLJ1Kg+nz298UAAVwLkZw0GiT9qfB00NYN1viveNM7lctUDJFZgSI/Lf6h2s4DrGhKdH07NnQ+9Fp4iAGwkrQuw9kzVdMF5s9nmJTyt10JmLG0mNT43VKOiJB8FZc4iia96gHMWjvf0clwiLQ2Eg7roP8aZqzl5amhkF4MrTR8kg0vpL9nxpGkkGYEc/drbwJUHGgRmQj67ATZzETGRgbAEwdadTs+kNNj1y9U5HEdgv/VSVB/tTnYFBL46qZ9XcFKHRWWf7Gt8YfkxXynKbrw5mNPZ1HEDJ7k/OjubnJ3LT0fkqjhgQXtFaT4b502qB1qA+kiQ/RIoDgLRFhlVeYoUUHDZZtuyrhFBd47F4gGY2hBW7oJzipzWa807soSYTEdOvm0
 4TLnDr7s
 FfoK3EEjJTCbhmcDOxT9vxtqsmSKOHWRFnIGrIXjnTtXCZOLYRfv0SfESM+qOMoBgyt0z7jLZpd+3U0GOMt/Pdjyn59AOP155N13Cj7IfFnrR4S4NHdQLMpkww8Ez2xbWloxAoV54mW2h+vAy4EfyvYDSuIqzzsZCUWe9zl10DrHdhCqM8TUx+ClGxmCLcjSwfzinfMLVkAb4EChSU766ZCiGsXV7SX/Tvo7ZiBsxyIcFxNCIHHPOCmenaC5pG4AyaPYkCKhpIynDxo3x/ivW9zFSuMxN8SlY69EunSt6j5qlXFNRjgIk0q1W62UjnX+QKsEAPM0V2z4S1wdOj1skM1NSdVi9WeiqUy1bmGaT2n75eowiOoL3Quua6STkeISoGI2Heh2Hia4tdxZIb3h5IFnon1KAWJ1DI0ZB0XQ3gY9UeZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 07:43, Jinjiang Tu wrote:
> 
> 在 2026/1/16 2:12, Andrew Morton 写道:
>> On Thu, 15 Jan 2026 18:10:51 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>>
>>> On 12/23/25 12:05, Jinjiang Tu wrote:
>>>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>>>> for MPOL_BIND memory policy.
>>>>
>>>> When the cpuset of tasks changes, the mempolicy of the task is rebound by
>>>> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
>>>> are both not set, the behaviour of rebinding should be same whenever
>>>> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
>>>> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
>>>> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
>>>> be set to cpuset_current_mems_allowed nodemask. However, in current
>>>> implementation, mpol_store_user_nodemask() wrongly returns true, causing
>>>> mempolicy->w.user_nodemask to be incorrectly set to the user-specified
>>>> nodemask. Later, when the cpuset of the application changes,
>>>> mpol_rebind_nodemask() ends up rebinding based on the user-specified
>>>> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>>>>
>>>> To fix this, only set mempolicy->w.user_nodemask to the user-specified
>>>> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
>>>>
>>> ...
>>>
>>> I glimpsed over it and I think this is the right fix, thanks!
>>>
>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Cool.  I decided this was "not for backporting", but the description of
>> the userspace-visible runtime effects isn't very clear.  Jinjiang, can
>> you please advise?
> 
> I agree don't backport this patch. Users can only see tasks binding to
> wrong NUMA after it's cpuset changes.
> 
> Assuming there are 4 NUMA. task is binding to NUMA1 and it is in root cpuset.
> Move the task to a cpuset whose cpuset.mems.effective is 0-1. The task should
> still be binded to NUMA1, but is binded to NUMA0 wrongly.

Do you think it's easy to write a reproducer to be run in a simple QEMU 
VM with 4 nodes?

-- 
Cheers

David

