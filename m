Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194ECC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6846B008C; Thu, 27 Aug 2026 15:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256FA6B0095; Thu, 27 Aug 2026 15:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7776B0096; Thu, 27 Aug 2026 15:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D49086B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:06:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A4F81A0177
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:06:04 +0000 (UTC)
X-FDA: 85147979448.24.15C3473
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FEE8100007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:06:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvycqUr8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857562;
	b=URfxaPzI9rnfhfbeMp6Qjz2aT9P8QK8nq6DqJNjUmjYN2Yq9KAeqVGHN9wTi2sn4a5B5/h
	SORZ7/D1NKrl1A6v0ZVlQYgGt51rjO0jHwKJ1OmoE6sQavH02aOHt9NvDGtGmCq7VptfoB
	SP74c9DqJatDkJ6JnzCJlgdFTa622Dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvAjMUQfB68JhL8RVuJBxxq+2zV5hpIDxgxtvNxSWwY=;
	b=8R1CAmCorVCTnih4B9B+mhuCxMLLpuReqojc45I0tG5k6Pyxs06uaYnAmWjQkTBCjP+xM3
	z5n6L2UbZt3DJPOagrXY9rAT3Ktm69tkq0uqCC4uAKVsfmqJPxeiRk+PlpTfbw6d/I4maO
	pGGiHOroFRHU9uVCFOjMqzmtCk1zD8g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvycqUr8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D67AA600D9;
	Thu, 27 Aug 2026 19:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B7D1F000E9;
	Thu, 27 Aug 2026 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787857561;
	bh=qvAjMUQfB68JhL8RVuJBxxq+2zV5hpIDxgxtvNxSWwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dvycqUr8nLdxAJSsmYmBehOuav+6pGYrnTBb9M8bBqCwslkLJLCEoCtZvOtKbaHIR
	 ryAPQBlm7sHMrS7BJV1r443wYqfuBQhQlrxXWZxafTS2lLZ2vb0UrNjUA+jubDIjlZ
	 HcUATpM7k2WspidyNx4/YWoWqzRZ0dCBNFd2QkyTQdyFLhVc4dYzfqh24xGdbN0O2z
	 Q2empcC3PyH4s1m4N6AcGGrkOvt7V6okP4p56o07ybWLLbOOdOARJ32yxl5S9FeT+L
	 UkSwaYcNxTcjCbw52ruUFCgufiEaZJDGK/EdJISib7XijKTUPhYbiJFn7IPyHQm0GM
	 e38gChEbkc+Dg==
Message-ID: <dbc740e2-660a-44be-8f62-61838603d838@kernel.org>
Date: Thu, 27 Aug 2026 21:05:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
 <e156c931-69b4-48d6-84bf-c06df134c9da@kernel.org>
 <CAMgjq7BzAkuibv+SyZQ+WzzbEL29dV-vPYyX2p43L0JDn3=wNg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7BzAkuibv+SyZQ+WzzbEL29dV-vPYyX2p43L0JDn3=wNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FEE8100007
X-Stat-Signature: e7khfgh763b3dj6sgqja7tagjqfzhgm1
X-HE-Tag: 1787857562-354914
X-HE-Meta: U2FsdGVkX1+eslz0cLkR7bz5oUuI3mFgbpGA8hBeOLuAkT8eZFtQDfZ9GTZhlqaMOz1h2n+XboplsoM4POD28W0OORSabPaONydYGbAfPfWPOMViOjQEWhArgjOgQH88cWyT+30xldGbl2nosUciU+O/fQO/8G0V8aodi+oWHsg9qRG9/NvWajVV6BZNK1c3MYzN+UXNC1kjrAqxyHtNmpkKUzoMGunDxkLBHjyOQBht1kOvSXTIszYgCZq+R1mRDny92U/4t3rEo8138+7mIlW9FflagHnQ4dckHWcRbVJ1Ql1ixZV860j5cC3fQM2Xq4CSV+Tc8TrFDfmuBLqFbipW2Hdh9oix+aAxkRjABa4AqD/39hx+p3nvTFSdl1tFLOyfPTcNI8aP6hXuB9j0n9x7/2G4U5sKIU1HoXL1gjJf5mUaDjQAbA8ZTMsweaoYLsrRJtsITvkNXAj0iq/wchkWN1AORWIA/UgXgvdLDH6QPjCC5dyBYU5RIIx5dt9/LPWWNc22jND5mh9B4Uez0CO03vsHIrL1J4rOUGAqenDs0f7R/1JF2/ZZmp/PGirnWRRyToIUOE31dwEFWooMJeaiNkYfRjalgbeMY1SkTV7rdWw0+vY/hlQ4YEi22P97LSJdmY74KXjAKe0oleiVWZlXzXp3kljB6DSA7IIg8VycHJbwK0gINS4MhfxeGUeVucFaQgArP+Xi2SBeM5gGmaZKQl3G4nP+EfGlGr2lh3iG8h49gU4Lp/UnQIA4uUPYVlrfbgaf0QEpsiZ12XzTSr1RAGFBVfp1nbBr6lKRyvW7IPzAHuVjLV4JWa08ILM8MHQoG2Jx8vfP3m65Qg5RXjptT0GyORo5GpiC28Jjl0vLsCnm0utzO9ywx9JRMqTI2W0VMM1JLfzPhySRy7Pn9CYyg9KW2K3ykNo46zI7cnrXZOR2o/obe8xdrczilPUsgyCYcvBq8AlfPo0IcQP
 l41qNGu3
 drxymdNE6c8F1YBgHvnZ4p7a0cG4Rm7dOMs326BTRjWhhp1ns2sJ1zdWAFALGQCacA7lELzZ6igqcrmQdcmVTUMSQOUNku3g8PmJm2Plmde03pSMXFVzF2tYs/TtLTcGJ3C459PVGkTubPe4SASip7/B6foo8zs9mR12A6UkRFOxMyHL5i0/MRqYZQx73m+xygKVyo3DqG3Lkfc4L3kANmQQtjrSkz9uNeAq1HGLvnyffNeHCOW+NyqpD6XOokTlRCxM09g7HQDlq4VKMssX2I7f7hQdfQrXUAjXbwncgmI3mJ5uVBy+cPQFFAdoYvqpPYg6r81zaXRs1gb0tii7x5c+OJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>>> +      * place. Keep the head @folio frozen until the end: sub entries
>>> +      * in swap cache must be updated first, so a concurrent
>>> +      * swap_cache_get_folio() cannot return the head folio for a sub
>>> +      * entry (folio_try_get() will fail on the head @folio until unfreeze).
>>> +      */
>>> +     for (new_folio = folio_next(folio); new_folio != end_folio;
>>> +          new_folio = next) {
>>> +             next = folio_next(new_folio);
>>> +             zone_device_private_split_cb(folio, new_folio);
>>> +             folio_ref_unfreeze(new_folio,
>>> +                                folio_cache_ref_count(new_folio) + 1);
>>> +             if (do_lru)
>>> +                     lru_add_split_folio(folio, new_folio, lruvec, list);
>>> +             if (ci)
>>> +                     __swap_cache_replace_folio(ci, folio, new_folio);
>>> +     }
>>
>> This smells like duplicate code now. That should better be factored out?
>>
> 
> There were some discussion on this in previous series, I tried to
> implement a macro or helper, but it ended up being uglier. Right now
> the duplication is just about 3 lines of for loop due to the split,
> and the extra loop duplication existed before, so I think it's fine at
> this point, maybe a helper later if this grows.

Actually I wanted to drop this comment after digging into the code, but forgot.
So it's fine with me.

-- 
Cheers,

David

