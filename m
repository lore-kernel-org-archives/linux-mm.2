Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600F1606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EuMVabxB
Received: by kanga.kvack.org (Postfix)
	id 7BBE26B00EF; Tue, 10 Nov 2026 14:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D276B05B0; Tue, 10 Nov 2026 14:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C2C6B05B5; Tue, 10 Nov 2026 14:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAD86B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:17:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A728F1A0AB2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:17:12 +0000 (UTC)
X-FDA: 85420167504.06.9E9F587
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3A4E180007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:17:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuMVabxB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794338231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vt/CmKJodaWf9jKe7kops2ibECH9zAPqIYPvDLfmxOk=;
	b=AilXTm+cGfEgj+FGcwwtDNJAku7byyVChgDr9yNYkSWFseWUxEcTVrx2DRnxwF6qSeZoAJ
	nlyzlMv+dcvKLrCF0v/CQem/d1+Z6tFagqqMEWEUHpT+qRLm2yKZTubleSlvCXAnB0dcr7
	9DnZufnR7rRkAIMXJB0aIavQrZiG6ZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794338231;
	b=gbTduDGaZUm7L1RGA8Esl+GnoOwX0kL8lynsnGJUuV4FLkzZ0U1skqbisObAUI6ONIMoIc
	/TcLp9lTVbOabBvd81LRsX593obChxi3qjUU1YeTAPjfPaBOZjk0p5r6XNK/yKc60rX5EG
	a9zspVoQRKCVruxVJVGKUvcYSjEWmgM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuMVabxB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AD8F60F27;
	Tue, 10 Nov 2026 19:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E5C1F0089F;
	Tue, 10 Nov 2026 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338230;
	bh=vt/CmKJodaWf9jKe7kops2ibECH9zAPqIYPvDLfmxOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EuMVabxBkF2GedsYrWAZAlnWBD7IPltSSop/T469rSorg/PnTP8kTkbpjhyHBzGke
	 /TY9zDrpVeEyybGn9/FRaXg1A8qtDInL4vbvYFrNvZlMdSFIwC6iFCwU4mi982D+Ic
	 X4eTwS+FCadwSu3VdLWT26p5AOe/gwd2n3fmL/fR0aTyxw5MKWOj+6TMqcIOugSb5V
	 Ot+0IeNagMPTL3W9GmdSUPW59aReQR9Ji1sNsBXotbcNSt2PIxunxqv9o33pWnBPB7
	 ysyHPWWs+NbgjnAx8lSb9efeYMXVf+PKoa0vb2NzsNJw9tsiic/CbgBdFlAXRzkfFI
	 bzTK6l49nUS6A==
Message-ID: <4bfaa882-a1ac-48a3-aa41-cb282fbf162c@kernel.org>
Date: Tue, 10 Nov 2026 20:16:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Ye Liu <ye.liu@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
 <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
 <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
 <1B3B1BC7-7623-4070-ABD7-13A5EE559297@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1B3B1BC7-7623-4070-ABD7-13A5EE559297@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: xq8ijdfz7pkmtktu5je98qd8njqj69yh
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3A4E180007
X-Rspam-User: 
X-HE-Tag: 1794338230-494571
X-HE-Meta: U2FsdGVkX1/cUlbqf++IedqczAABqtwgHXgbY3FSIrEx61of48y2pZLE9GkAPqZUHy5lKyrZKnFuY5Mq6ckdnT0xAWMPI1u4OFHsGsEsT2a8jFsGvigLVNqJTJPqYFEK8/p5811PHj8jVr0g+Gnszr5OVJJT0upJgQ7hmxVtGrh71YUSLbPVbiHmBq77s3oRQ/gcMOAOcGDSGoM641rUhhLZeaGK1jBjalsiI6uf1gEHrjsCiTI0KwwSfaWbN7NiPAP2PJJZ0UvK2meZdr/UGX7LxKs2kSa0HUgFikwf+eaN67/JFYSUYrdAxuv4WukQxfWlNAFVM8jzs7Mx5uwkB4OgHeWqMi0yyt9/GK+boHJzmxDN6r0IwmnzFHAQtQ+c5Qgrt5Xz1i7sVlAxxECh0yUdjHC5YMlJYmQ6Bopn3kxGMh6QyKU3+ofenEB8XjY4f2yLAinmI3+KLWnrglxHiUQc2vO8fMP5x+DWdeVz0/acleA+pBjdF303/mJtEnd6qUC32cunCIDRzR7FhWkDPvwgcUJUj/iEFTYtUTWEMjbEcvEMR18omGbzOvGNgUOGa+MvrpI8QEvzQ/bN3K6kpE8B2GURw7B8sC0V4rXcvrrL87S7Xchej3KN23snSDY2xtTr4oQDpNIPfUpakzSKhsw9c+b0ID7XS+oBFJUBRDtyAbJt+uFVzXL5Pbmy6blE0tDKL+CxLqH4zkeXOqq6MR7Ocqk65q+6rhD6qVM28aYmnusztgmcRQmcrcQBSnIDlkNEgpmS74AbCgz2WdGm0ndrntODD7g9R/4HtxEi43LBfUmlIdcrfqVNTr0IuiMVugPkmalFuO2trFOX0/yXlfsTKPTb3p5BTvpIGZPm7bkoaSsoGtjff1tM6u4/FS0T8PwGsp0EKjpokIjV+q0CBol6iJE2YeNNoXT0fLp8Bq0o8kT5c/dRtaTJYb81gTjIhxtxiNy7uoW0KOIpo6L
 TOQVPGn8
 K6ozhWAH+LaL5u7e8G7WjMKwOwVISe6MAHB0me1387O0OYU+7Fb5dOgZs5cxqPHblTYltyD8PEYxX85MJLnoqlk7VNtWySp6OXn1tBef1/unSm399Kp1XY9L4UmJjVaOsIpDHWOzD2mMzC3jf5pLdL1rlI0ezP+x4OdWvbuNToxnd6e6rBoLuW6WdXK/RHRlCgKgU0UI/P/M63QZZkBzs2KpCpjUZ63h11KeQpRLpoSLFluiNpIU8Gt+G/D/guwDuEfvlyh8YgzIeWX446Lx4oW+cnxgmJ2HLrleqDs7s3long9L69pLgI3/JbIR8Lx8mrgEazabFDw/mAMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 18:03, Zi Yan wrote:
> On 10 Nov 2026, at 6:31, David Hildenbrand (Arm) wrote:
> 
>> On 11/9/26 22:05, Zi Yan wrote:
>>>
>>>
>>> This is V3 of the patch. Instead of using prep_compound_page_atomic(),
>>> PG_head is written before clear_compound_page(), after which new_head
>>> is visible to the reference-less writers.
>>
>> I'm confused, how is it then valid to have PG_waiters set concurrently while we
>> read new_folio->flags.f? Because that's what your comment states.
>>
>>>
>>>
>>> IMHO, memory_failure()’s reference-less access violates the frozen
>>> page contract and should be fixed.
>>
>> Exactly.
>>
>>> But I do not think it needs to go
>>> along with this patch. We discussed HWPoison flag race with
>>> Michael S. Tsirkin and Miaohe before [1]:
>>>
>>> 1. Miaohe proposed to reset HWPoison in memory_failure() as a best effort,
>>> 2. mst used RCU for all non-atomic flag accesses,
>>> 3. you also proposed to move HWPoison out of ->flags.
>>>
>>> So memory_failure() needs a separate and proper fix series after
>>> we decide the right solution.
>>>
>>
>> Vlasta raised the idea to set hwpoison only after we actually managed to
>> isolate/grab the page. Which might be the proper fix.
> 
> I was bouncing the same idea with LLM yesterday, but it does not solve
> all cases:
> 
> 1. normal page: taking a ref just prevents it from going to be a free page,
>    but atomically set PG_hwpoison can still be lost when another one uses
>    a plain write, __folio_set/clear_*().
> 2. free page: isolating works if the free page on its free list, but it
>    could be on pcplist and we then need to drain all pcplists. That could
>    hurt performance.

We can make memory failure slow.

> 3. we cannot take a ref on slab page and other frozen pages, then we will
>    need a case by case handling for them.

Yes, we need some way to isolate them, or to sync with them.

> 
> Anyway, this probably belongs a separate discussion on hwpoison.
Yes, memory-failure is the last of our priority right now when it comes to
fixing things.

-- 
Cheers,

David

