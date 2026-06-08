Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A54CD98C3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887AF6B0005; Mon,  8 Jun 2026 10:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8389A6B0088; Mon,  8 Jun 2026 10:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7277B6B008A; Mon,  8 Jun 2026 10:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 610BD6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:55:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E20EDC0447
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:55:33 +0000 (UTC)
X-FDA: 84857044146.04.0BC1CBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EDCAA0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:55:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icgU8R3K;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780930532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQxIp5STkM1u5oGeAH0FbCR0lUzYUCAoQQ1syLTLpJk=;
	b=75IwwRyg68xcSyHI0gqayCVUKn8mw8pBOu0/b6+meIiiYxo30c7wUEVY7u/OQPtIif5Y2M
	sd4XOMl9Hq+zQfT5VCCGFtbtfcjOaBwKmxXpxn6BUtyinOR9kog3unWZuHCGB4sJZt3qFC
	wM9HupmIDCNDNoG2O6AC6IEqQ2KI9GQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icgU8R3K;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780930532;
	b=6t4Vqs4TnbsViYDUBNn/7ItGe2hvALzrkOGQw3bzWYBGiJJwYMf1QqV/f5XdelxGEqFR87
	hpKB7vVlMnhTndVnwkpKTgD50h8YZPZp5kkDgSNnfyaZBy86VNb++l7jv/2EKCPSGYj2h+
	NXjTi3QUd14XTbnSbwG9lbYbgwIURbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4601843248;
	Mon,  8 Jun 2026 14:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69F61F00893;
	Mon,  8 Jun 2026 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780930531;
	bh=YQxIp5STkM1u5oGeAH0FbCR0lUzYUCAoQQ1syLTLpJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=icgU8R3KjAHS2Z85xEQssGeXxzqB7M1tP5okT93EKmWfmvoHP+pPDZ1TdEYs8pyM+
	 YRRSa9Eg5WdLSAt3pPT7Yw/WrPBUNNPaLO6ebFoTucxfiMfWXXZkmeNirbWtfmz5t5
	 SXSqeH5Wu8W43k20RsndYGqlWLYOihtQD33amC/AsnjjAhIK2NAIsinOBBaPPAW+G9
	 ciWPO2iQ9ono2WGQsp8G1pKK5hMSexYCTGBMjfHleqIw9ihf79FjKUDnN+Jnp2fQQb
	 C8WWfymG2sqez1r3phP3B8ISRfttTUKA35umD3tAaCUl1Dowd0Kkty+J4w1rdt0MFv
	 kAnKj2uCccdJw==
Message-ID: <68ac0163-865a-452e-b643-351e094cb2ba@kernel.org>
Date: Mon, 8 Jun 2026 16:55:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org> <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
 <aibSPsc33YQiYSMI@casper.infradead.org>
 <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
 <aibVTe5HTk-fF_kj@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aibVTe5HTk-fF_kj@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1EDCAA0006
X-Stat-Signature: yw4imfbstbmktdpcmcf8xnjhk5yym5tw
X-Rspam-User: 
X-HE-Tag: 1780930531-533846
X-HE-Meta: U2FsdGVkX1/2JIBXw8uGU9xjfhljlVBM9g1quAoVm3jNcsmdoZQwTggHc1iYmxyWa8jAyWuhTrqn1c/GMdvby7/B65j2kWy27J1rfre6ff5Oy16sFChq8gPSC014q00Z1mQUZK9qkfniCVbE0jk8ws8fqVwbpZEEfdPz7lbk7bUJu+PnAxAEugK7Y6t/HCoHhXozFjGyKGbCMIItRCiP70jO0xLBzAgJhCXCr96ur65eFsBSLcr3n+DMppajlFk8tvDhj5SEjPkKcWXuRumskEiEEKYytypKMEswXGOssapodJdOpKENZ7oTBitjeujHmvnfROExnsRLvCzoWACA+hZe5XvPVE9nuDIInnpaHn27K1+2W+ROzjqMdYhAkLV/2DBmoK6k4IhgEn+z1R4Mgi8U0bYmCrpE1yR/PB2MIfWluZHxWlTNOTMDmCKW4vpmZQ1rUUfLRZ8gXqxWioLKK+HTLYOFiuyx3+jury0glw2ZTaJAkxrVFsabwhsP0xDpfY5BqEFfICuWKwT1STmaFDtxRXG9mSM3sK1kf/XFNgXgOF2WIaewBeIuL2CBNFPqT9fjIaPgORvYF9Jbe2bHTtbnWTgBG78dL4lMCT7GHaRVrU6+T8XF/cb3lUURRBMjEZ3dbNXqKQnm+bGyftY0Ly8a8SDOe3bjgYaark6O+BaXZ2Iwgqz2QWiG7NiwXhOr4V3hY26oPubYtiYaeKMI+nUNl1WwcMDV244wbXeoLAgqBAmQoG04ZqCy6TtFebBwk5YkRee+gcclqM6o3S0HihVMUKRfKbUIN13oDex9F2/zcCD5M5wsJ7TX8hFrgw2+oLwYmIJCZQd32QMXzhrlFxJz7rLcWVxMF49ikRBF/3CDRXbM/8F8Xw67hV1qxyIHxBsVbQgYzKlMjf3x4LXudmNpty8wLB47jabqRDO8KZjkkM2RwcmnGOS5Fz79wTarb78hdQesQHykdApnIpW
 RVCP0U2Y
 U6f0SHiQmMxJG/skd37LoYIVja3LD+5NkyjbW0EIc3nyOMkqhlQZMqMTcPb5Kth1dq19VgG18B/or/d5YMOdfxHGfnTnbu8pCI+xmTdfDKXXeo1NfqhMc4upn1jmgVqrAEc4+9qhKCW+jY1ojQEP38WoTlI2mbixPHAPLHOsFlp3zEDOvVFHP0QEBy/RA/IJsDcDtbqabPn3L97tPSE87khbvrAwIpVtVy7anoF0frdGFlLVbszhh3DD+UOklkbKo39tWcxf1xyeTLTYHo2H4cLVftPoOSiaYe3kgmnlpIvT4oYdzjR523mJovM3atcbYSF532xV52VX+1x2erUt9mUR6uY2SkK0fqWjCdo8WkQY9ztKjxcA1K/M/EChJaguW3jBi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 16:44, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:37:03PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/8/26 16:31, Matthew Wilcox wrote:
>>>
>>> What I don't understand is how the kernel page allocator needs to know
>>> the user address in order to effectively zero it, but the hypervisor is
>>> able to zero the page without knowing the user address.  It feels like
>>> somebody has x86-centric thinking where cache colouring doesn't matter.
>>
>> (not commenting on the icache dache mess we have to drag along)
> 
> Well, that was kind of the point of this email ... I did ask the
> question you're answering in a different email so let me respond
> to that too.

Now I'm confused :)

> 
>> The thing is that with free-page-reporting the memory is already zeroed by the
>> hypervisor as part of discarding that memory previously (e.g., MADV_DONTNEED)
>> and allocating fresh pages on re-access.
>>
>> So it's not a question of "why is the hypervisor zeroing less efficiently", as
>> zeroing is just a side-product of reclaiming that memory in the first place.
> 
> We definitely have users who don't want the guest to trust the
> hypervisor.  So how do they disable this optimisation?

Right, I don't think we currently have a toggle to disable free page reporting.
So IIUC, this optimization would similarly automatically get enabled if the
hypervisor advertises it.

-- 
Cheers,

David

