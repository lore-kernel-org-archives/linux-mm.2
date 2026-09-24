Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4FDC98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0BE6B0088; Thu, 24 Sep 2026 14:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8506B00A7; Thu, 24 Sep 2026 14:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCEC46B00A9; Thu, 24 Sep 2026 14:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4A126B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:51:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35E8CA6833
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:51:31 +0000 (UTC)
X-FDA: 85249549182.18.8B9ADF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 75C5740003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:51:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9TaPuWg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19lgN71Gpsx5vFX/9xhZyr5Tn9Zwnud+YgNQwdRHAz0=;
	b=KAlRCjZn9uvMW7ReYQsWImFAt3mrh6lIEXYCieo8IeOaqmqALgvNzN3CoYisnveXKeUrNG
	+Fb7WuhtfaDGWIzc9KVj7JmPK6mGrh3dHzIPOPXI3rhO20pqAYgfLovy2a8JCpitZBX+CQ
	hBj4NisiGmrdOaskSAvJ+1ocnLRxJSE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9TaPuWg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275889;
	b=Bphgk3+EU3b13JKHqecM48O1S9maoX1LHCc9SXNU60/bXcD9PmfbZaDssz2MG8VZ4e0uYc
	jwEcg9+Uko6XWUbzeMRjgoySHj24hsY5iYkzKJHxnW7BqFi0MdPyNeTjcdeLD23ElIj9nK
	SiAf7yv8XSpQIsPpKyS+iGbuqghKHa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE605600D4;
	Thu, 24 Sep 2026 18:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4B71F000FF;
	Thu, 24 Sep 2026 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275888;
	bh=19lgN71Gpsx5vFX/9xhZyr5Tn9Zwnud+YgNQwdRHAz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B9TaPuWgeX2V6EXNOynhKmYXxpgBuhF0GO9GvEleV73ppMJ+4jg0gfKTK508nINu0
	 y5E68P/eS0N1Nf2rY9y/C35ESNH3DuJHHqCrktyZKsEz142m40zL+RvZubdy2Bbj6N
	 B0gGhz7zq8YO1mV19YDxCBqcO/vi5mSTd8odzb0MeZcOcB11UVJJtzGXMG2x4uJaSx
	 J6Es0Ej/BiLSmH0sepF5PDeoQzTg3lpupc7vbO24JxIqjpYE92LknGL0hQWuXIc+2N
	 lQWjUiD9QO4+Z4unk5ZVWj6SNX/rkJMzJgTrpEerfy+R/pvx/8bE5MjCg6M/22H1aH
	 pbA958pAZJ98w==
Message-ID: <c01aa1e3-f2cd-4b28-8e6a-8e8a1c36c641@kernel.org>
Date: Thu, 24 Sep 2026 20:49:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
 <arP0-maAEi5yeNnl@kernel.org>
 <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
 <arVJm8CiLG6vpy9-@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arVJm8CiLG6vpy9-@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 75C5740003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: okhsyn9k9a6474wor5sjozuwoan9znb9
X-HE-Tag: 1790275889-187791
X-HE-Meta: U2FsdGVkX19NP8KZPS7Qp6JbKjnv2CcNOIWsa8AbkBVBmVZ23JN2EKqTLRHz3it0/nyJ3e+eUYfDInmB7hDK46AZyW3veuVK9jFiwGTClMxL1U2Ky9mIWPfjLxq7Jqm9LmX9gP/Nk9+bNwSoyC9nZF7/RwY4FGgi7pFKDiLaE0EwUmAqkLawyg0qYs4nT3HViCTJoyv9BJL7Lk5O8avXgi6mW7UdhnQlj4iqEoepcPinK1jf7YvPAeP1O6VL6E1s9zfPuEQ4jQ7NB84EtmPETGWJ/F9XDqriz5cO+BAIA6Lo6nuOZ0fUSb+CnQQSZJjFQqWC/AzvioD99YBt+FJHY3wvydi/XuKK6gzYCxBIJCoNY+kSoS0YvkJ16MwEu7kcBS6rQysOQk7g52o/T8yR2K0SmxBGGdeTvKdoud8WkZ60/B76Z1QXT1UG3MojUO+095/vo3ATr+iDFNFe7IwaqW/Y2LgpJQ6OOpc9u2taSSK8rABBfLKSlcB+OzStVqP8FrWIKxQh51cg9rQFXupk/aWvYd+9oOSEesm4vNJ0kZ+SslsuiqfH2V6mFo+nXLqK2V28UuxOzsndZv3jg0g1BRENTKQHG7Xy52SmX9wsMyStx1hlC1Wqsuzn0t4MTQbyeOM0StXuPIPbF6uEUUqN8MHGISazukZ33GnZ8OWOH2deq1nT/NQk3t5yJBFzDfUPYRDv+W0sQilIKTCKudwmBU9+4TWJiLr/HuZvbbNZksdkNR2Hl03KbdW7K+6adpOg2P6FLsCHURi7TMHBRsLM6fnAvwamfSyzLIQdpT+/ERtGLLeO5jVPDeLzoybC9037JFfJNS68x+5k2aIDqHhef3Nyp2WI0br1jeLMTc+6/WNrbyKbLUCdx1/Hnqd8vyse/nR/3Trvjlz8E906dpfAT/Fk36QptnbRXOWMrdL+mv6McDv49bBnkJadJ+Qb9FenUJcLvQVcm2D2FJMxEQT
 cnrwXmqN
 iLNg7QYEmVHtL56CEPXKiplLv18jLPgvVHD4+oNVET5NsoiBCjqYoiU8KK++cqJkQ7EOMGe14gyhizwPXdMMkXlhHlbFcshkrIx6kqHDME5Vn4x85z2yZY+w2MKIXpbx/a0mEpxVTE64htXo6k63/UOzLAd92HQtjYNwoQmgtYKMMdihdvv+XhYFRg7GLF8vzsxoq24uyO98fKeWSW0n7herSNlZpKDe9AVWnsnp2wBJm49UWvYEKUIbC4qozU0t623D2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 18:02, Mike Rapoport wrote:
> On Thu, Sep 24, 2026 at 10:19:33AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/23/26 17:49, Mike Rapoport wrote:
>>>
>>> Naming is hard :-D
>>>
>>> I feel that _copy_page() is to vague and adding hibernation there is to
>>> mouthful :(
>>
>> Yeah, I wouldn't mention hibernation.
>>
>>
>>
>>>
>>> And these could be used outside of safe_copy_page() someday.
>>>
>>> How about 
>>>
>>> kfence_set_page_present()
>>> kfence_set_page_default()
>>
>>
>> Maybe spell out "direct_map" ?
>>
>> kfence_set_direct_map_present()
>>
>> kfence_set_direct_map_default()
> 
> They are not necessarily in direct map :)
> loongarch does not have direct map, but still supports kfence

Ugh :D

But where are the pages mapped/unmapped then?

(I know, I should read your doc patch)

-- 
Cheers,

David

