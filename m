Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D5DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00476B00AF; Wed,  1 Jul 2026 04:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8B16B00B0; Wed,  1 Jul 2026 04:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6E66B00B1; Wed,  1 Jul 2026 04:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A99F36B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:36:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31625C15E6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:36:43 +0000 (UTC)
X-FDA: 84939551886.29.80A5CB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C6F1A0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:36:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jzW/rrzw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895001;
	b=v/D2q8LSkfXlFrKlslel32zSmZdZk9U6ORmagV1vPld867KhHtx+iP240yY6kOfAm3Pssw
	cV5ZmQyhm+mYHqSyxnowIxkzVUsGhE7GIoa8ZNbA74o5VE0fEWN9SXZ9wxyuzoHhb3gsDr
	8kP9+hodnPhspa2gbPMt66u0tvR4guk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPEJAHy4hb00HRqDPAQWbFJl4HuP8MOTJH/+eoezJ7I=;
	b=g8FsCmcZaTSrd+QAAU94jqKALLbzxEI7McFY/QpWNZlXMHnVN4dPopyzb4Ap7b0eq1QoDa
	3O8Me8wiacW+Q9m7HmIkb+GaWrfRJM3tKvXd7LraCfREs9CCiC3d9vN0Yao1lzn/AiAquE
	N8bnSmDWvRXZ6KPG8dRT1/GBenM14+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jzW/rrzw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1A8C6001D;
	Wed,  1 Jul 2026 08:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371091F000E9;
	Wed,  1 Jul 2026 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782895000;
	bh=xPEJAHy4hb00HRqDPAQWbFJl4HuP8MOTJH/+eoezJ7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jzW/rrzwTr0czj4QnvDVZj4wh8o8DkAXTIMba4+v3umaXcz2XyBShEeJaunOpw7oJ
	 c62tiaBrta2dD+rFE1Mvn0I/QqPtJn6btwSICosFH2epy6HfAUHFIEoygUUEi5lV3a
	 48/5zbISrWpdxErC1ygFmRBoOzmbkNwEo/2si6aJLrHouWoG0Ay6dp0M+l4IKonbwK
	 Vly83+W/tyxp2abFNlcl2m9+TZKljikrsMtK3DpXQfbe0s52A/SXRBDT/EytnagoVN
	 0e9ewkvbyVLx3gJDBL/JaZhpzx8irrSv3t7msktUZXNAi5N03ReL0AoULRrW+PcywP
	 1ZLEdArRC3XUA==
Message-ID: <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
Date: Wed, 1 Jul 2026 10:36:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701043024-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C6F1A0005
X-Stat-Signature: awbubgctkb8a1dfu34sh4piqxpkpqm5x
X-HE-Tag: 1782895001-452024
X-HE-Meta: U2FsdGVkX18tM9aQsDmXoHCNf+R7rZBzB/R63+yvv/oxYfxgNreVfqjuINZwLY58rwhpeVzlF2Lpsjl9wi9lQ1oDgaQNkT3kph7558OnttoHUY9nH+Mm96WvRTys+jKSC7C8WA+G9h34qeNgMAql8eVtvSg36eWPtcWjDpVHQLMswaRSsn0ja8u+8yjIBQQz49yUcDVq61qbRm2/ryquFpngCILij+ZWiPB9/+A/7imoifyJbOjbvCcUJ+3Grh8kFrzeWUXIBLeBKSaVAe8bnR2k3KZWRMeHNWHlVgNztJ0nvtI73X//C7HAzP/6FsJ24unTdODVkhU7N0Cf0CzgQkwS1+YLyOGdmui1kuPB1dqrJjPwYXAuRYi66kEPAcFcBzBoiPAWe0p3U7xfQIDRffETj9sA4wjfi79eNPupauOIWxY3ebuQu1dlxcIXz4rqM8J/R/rrvbgPyP9/Imom5i3RkNY19VHev2EFkm4ElgQlwf/4qPKqPnJw4pKQ/8U9tAJHjjiJiHwD5m3KK8ssIHl/LJFnJddNXhPY/ik59OsN0uIBaT/Dkrn5XSHEkd/KoFdaNgqsy496p52Hp/t8lCCkSUxXwjFWo0ttT4DUsJWnaWnqjnQkxYhc0oXPoV6844FJKUks0wml/yHXwn8e0+8BRjDXUxIEQaJFN0WkAZHIxYXQgNy2hWT9fn6CibT9hnZF+ODefDuBKMmB+3H9nkktK9bVHzEWaPnz9Bx5mq62f7OaeIilJ4xlgUaWNY4UdRRPMazaAdX0c/ei+MkN3g/ZwWvn1pEkfOEXPWFx1PhzQ1mJ1stXF6KCogHdvJDzeHVjdXj5DxSvgc44BqWuLUxuPdBaRpxjGiHn1iHNkfRxNJxrOZuca2PqguouPse8X4UrDCkfzpMKw3/VpFLu2eieH8DGgZEgRqBMx5TBcneaXk3p5TMyqKT6mRTYRjbPkzhs+sABHgSS3jT7PYz
 gbn1fh7u
 l4lTlRAzRezac9LGxfVzXkRD0GVpd1V7B5dTXdMk1m4T5Ei0npVnD6A6cFmiKaKqre4PZlPOZwNoJl1yXNZ7dmVbPnRfIFXVB8JxXKSIW8nWBwmZS40Hn0W7Lj/K7KerNq+zHHgM/7xdYJiF7WurzIKYGINYSTr0bkZyfl966BGIwgOoqYWVR4jtbG8yN4hBZea+XYUOdU8aGJIqe5aXyBp6P8MTSx+mNWzbW6wqz1gDnLCddbPZjGt4JjKZIiXrptilVFAS57TiS0hes75MBAlS2riMf31gX6RLe5CsEkDmOwS1NHkZm0kNGuOkWHfVR9KMYqmSa9dyyE8lOLuz5+59/3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 10:33, Michael S. Tsirkin wrote:
> On Wed, Jul 01, 2026 at 10:26:26AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/1/26 10:18, Michael S. Tsirkin wrote:
>>>
>>> So on this idea. It might not matter. What I had in mind is:
>>> 1. run the current logic
>>> 2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
>>>    (or call_rcu_tasks_rude) maybe
>>> 3. in the callback, recheck and if poison cleared, go back to 1
>>> 4. otherwise everyone will see the bit set, remove from list we are done
>>>
>>> it seems to not regress anything, and for the rare race, we set
>>> the bit eventually.
>>>
>>
>> So test-and-set (and friends) would also have to check the data structure that
>> remembers bit to set/clear (and possibly update the data structure).
>>
>> That does seem doable. Do you have a prototype?
> 
> what do you think ;) post it?

As RFC please :) [and if it's AI generated, obviously properly reviewed and
reworked by you]
-- 
Cheers,

David

