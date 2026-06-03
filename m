Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 230C4CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F4D6B009B; Wed,  3 Jun 2026 04:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C436B009D; Wed,  3 Jun 2026 04:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CE16B009E; Wed,  3 Jun 2026 04:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 658BF6B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:05:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 322B71C125F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:26 +0000 (UTC)
X-FDA: 84837866652.20.90ED531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 727F840003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fmi/kQoc";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dQKg3fvoQXUdTatlK6PcboFOhBDiwUnlDV/Gb+Sv7w=;
	b=XMwlZKEYyAD7y8nVyTxspwKwpFqQIcpS45eVhwGMXC/rm4FYr6q4LV2KKsiNPgbC0zbkrm
	0UnmjEJwPHTJOqqlvFZlE7CdKTmi8mSHn9ta8KHCUswx9g6ZbN6EgM+dHwU7tZeelOqynn
	trHJmrOHZlFwsJJEtDb0ZzQK98S/XKc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fmi/kQoc";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473924;
	b=jFoPiff3pnNvR5v55ORHeqCiX/pXTezohceojjARJkbUFhvglirn7zgcS1ArAjMM0LEzRg
	mpthq52XyrK/yOdFdif4lBlrS7YMm8aT4uSDCM1bpjIo6omPVDd5vkc3kjJ2YSsOjiqpe8
	lIM3bybrQap4MXxkUJhF0LIdskTpD9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D575460222;
	Wed,  3 Jun 2026 08:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281721F00893;
	Wed,  3 Jun 2026 08:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780473923;
	bh=0dQKg3fvoQXUdTatlK6PcboFOhBDiwUnlDV/Gb+Sv7w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fmi/kQocICzf2H+zcJHdlBHGwo0Qp9QRK3CjEUT2veesOjS3zCAuHCn+NmJjmPt98
	 nrsO6B0z1IC672L4/t4Y1ey2578h8UEmrDA8joZieEPy7fS1UbhSDqu8FlN+akaPrF
	 VuQ2Z+PwbFeKKC3UMyalzcXtdRk973pNHZWd8UwSIEGGBND/r6oU4514YT5e0poV37
	 XdOn8AG5KBM3xUX/CS+NuDl7Emmia3jLYZYd+Kwr14ZFaWnmp+PLUqIBnD8k9ZLzEn
	 5kSOn3RSVLUcrRg1h7Q7Yf6hkTi2cMBrG3M73fFzhHxOhGC6UhoIIXhM14OdBlibqS
	 hLe3VM63EsOyA==
Message-ID: <46bb9d9e-03f0-4e26-9ac9-1cdc5ba9bf4d@kernel.org>
Date: Wed, 3 Jun 2026 10:05:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-12-npache@redhat.com>
 <20260531071845.10875-1-lance.yang@linux.dev>
 <CAA1CXcA+oZmp=cxiC2_EBDxqGX94gAd335d9eFPNv=j_0=og7Q@mail.gmail.com>
 <185f5699-3797-4300-8c54-bb99fc2a45e0@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <185f5699-3797-4300-8c54-bb99fc2a45e0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 727F840003
X-Stat-Signature: bwu5p9hy9fczrkpkd6jjycw9rq1wwrgs
X-Rspam-User: 
X-HE-Tag: 1780473924-555398
X-HE-Meta: U2FsdGVkX1/B9yg4gnqQ1P6Xr7xGCmehf4ZM7IsB7AlGY7H9V3LQM6MFNK/zaQZLYx0XHYoG2p7HO3Eww5m6A/QqIwux+FIeYQ9a4z4AMPHIguUpTjLmLUOL61SccZBaG4069/0efse6Kf0DyBl7PiyF9Itom4I5Nxd2AVmTPgvN0RelvMc53kceEK5YQpnDsqGuf4uTU8Zv+PwEKNivQJu8NzxZmhQr0T30HPcUtfUDEP9aM5Qyg0neu3o9wBU983d7arkTq3ScV+F4p3Cv/jm6KiVTx6ZViUBk0iIr5EFJKLY18Fes/6aSh9L7aF4cHXsrq5/ASrFn2x+5SWv+uEFlApfWO+3MscVP3As5ZP/jMlFlwGtTXE1ovwpXGP7UaX8yu3KU/uUQIGvE0phDxJzEZrWAkcKnZK4qLRCSAqhyABtOOYJHjrOulmkCiOpK9G2Y7VveVwv/4wZx/X3EcMI1ixVapEnSn0mmIj4lP+D5iL3hAqZL1UeClqBiF/mnPxJFLFQ+lOzgrt8iq9yoneHXj+Mxr6Dvm1YNWByu+FDGrT+q4POBP+G2QvIYh26bYtdhcT8i/4wYTZwxgZy+xq7fSWh/J9WjnZWECvCpLW7RUir4kadZe4HFYCwKBihr1e/rWlG2VPHuCn6Xk1YgZ/cx/NTY8nFBqd9B3ZFsoieA573bsmNiLCmPQuAICLlbarOvz/zQM7o88uW+Mvq/49isBLcUWFow/wOejgRQ+COLHV6yEDsESHW0o+rc3dVMPrIib4L6WxOPuugIsTCk2XZj3yNLaYs87UTx/q4CP5Y7sLdc9mbC7BHdAiBSVXio4fWVcqoGxkpQd9GIQG/2adOLDJXdwGoZ0tNVaZnQ1UzefVi1cAUl1OapiFObMfrX5s+24x4sgNHNg8lGIRhsXBWTyLXdE1gq9Szt6oOaYAft2BgBCzf0GWdcmOA9jRpcRjk3sVp6n0Tvd6JiPff
 F/QvyLpk
 OoOqhBPmId4OhLocfHmf/8r/92FZalIQD2UhxjYI9iVWVTsym98lc/SwHecC6HV82XgbXXb+4HUEhbk5dLNVQVhE7PcPW9QQSfQ2j2lJY3IhK+m7ATWoeO+5AFrnn0CNwxTmzzjTAAW0XC8oz3QEHggMehyZdsX8VCXcV4C9LGLmn/FRI9TdIpFvOJnJ042+UZRtosOrdIVsbzABcQxi0CXYCbdS3QSofqKeoUt9ozVRKgfvaIny4wLYVD9hiNsJ6Vy1Bg0YqLQxF1Y4mvU9GIZGNNlRUu+BgxXyxw8sFFuzyMTlzZTAp9wZTk7TvnYKofrgMYZcrSyjlcLyDep01MUyFHpigQodqiKnB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 17:44, Lance Yang wrote:
> 
> 
> On 2026/6/2 18:58, Nico Pache wrote:
>> On Sun, May 31, 2026 at 1:19 AM Lance Yang <lance.yang@linux.dev> wrote:
>>>
>>>
>>> [...]
>>>
>>> Hmm ... don't we lose the allocation-failure result here?
>>>
>>> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
>>> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
>>> in khugepaged_do_scan().
>>>
>>> Now if allocation fails and nr_collapsed stays 0, we just return
>>> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?
>>
>> Ok I did the error propagation! I think I handled both of these cases
>> you brought up pretty easily.
> 
> Thanks.
> 
>> However I don't know what to do in the following case: We successfully
>> collapsed some portion of the PMD, but during that process, we also
>> hit an allocation failure. Is it best to back off entirely? or can we
>> treat some forward progress as a sign we can continue trying collapses
>> without sleeping.
>>
>> Basically, do we prioritize SCAN_ALLOC_HUGE_PAGE_FAIL or the
>> successful collapses as the returned value?
> 
> Thinking out loud, forward progress should win here, the allocation
> failure only matter if we made no progress at all?

Agreed, in the first approach, forward progress makes sense.

-- 
Cheers,

David

