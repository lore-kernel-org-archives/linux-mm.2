Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313E0FD375F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9472A6B0096; Wed, 25 Feb 2026 08:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1606B009B; Wed, 25 Feb 2026 08:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806F46B0096; Wed, 25 Feb 2026 08:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 684D06B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:57:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 161F116037B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:57:27 +0000 (UTC)
X-FDA: 84483131334.08.BCA951A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6573E120008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:57:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I92pcnP/";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772027845; a=rsa-sha256;
	cv=none;
	b=LIJvHnghviscEqYFIRLH8ydpw3gXtLI2/CmBYexti/EQgE+7nDdbgKc8KLczc+/ptjJ1uP
	uaae9Zo0bY4giUPjFBSUHxlp4h0JV0qVSYhbwvDUHFjZmy8kZ+ucUs98Tg5plwSMsoT49a
	psgpOH9lBEru4oD9272Mu75sY9eC110=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I92pcnP/";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772027845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euXigfeu1Ls+Mvlqr/jfLJrufgIc8aH5ZNnJ/mmFges=;
	b=wztBfjTTCUbV8LHJvnmnzzv1yJ8cd/TTEenjWymYMyVywnHzGSaS32ebEyRiJsYp2XUifN
	vYgP5e0VUZ8Kaj0+LWS4DERyi5rp3ysmB7cNSNzg3tH2iroZvP9SRNQZVLAwcrSbWFrTZx
	8LiqC9Ihv2VZvk8O96CV6KJkdsqbcAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CAFE16012B;
	Wed, 25 Feb 2026 13:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD8CC116D0;
	Wed, 25 Feb 2026 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027844;
	bh=OUurYv35bNhXesuuVWjFpAi6I65QdGPN0j4kp3KPEIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I92pcnP/2w/38kBmgcDkuu+UDMvqA+rUZOm3NlbmqSs/M2THpW0kgPllrMeteQshm
	 vOfYwOs6vei328598cOpaenhGoAYoIXD8nqV3ivJKUH8XAGotGZwQ7E8Z0JAMtXwgK
	 D4xDk1e+5hc9dMVj+LDpW/dmGs9gFZYy5974BopbOmYeeSGU2+JN7Sw45oAvy3uVKa
	 JPaQR+IhNJIM34CCmd1FDef2ElMhcfCqoXmwPSLgxT2yWhQK9+phbCg0ro0Wucn9HE
	 pBg9j6ZoA5ndt9PZGt40XNny4FR0erxKyQ9Zb5gdcR8sE2EAbZB5tjLfsw+1I1avWS
	 sXSvM8ohkeL9A==
Message-ID: <258cad5e-9ad2-4dfa-a090-c65bbe3fc7ff@kernel.org>
Date: Wed, 25 Feb 2026 14:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: rmap: add a ZONE_DEVICE folio warning in
 folio_referenced()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
 <b3c1c739c233ccb32945ccaffdaf25fd3f96dd59.camel@surriel.com>
 <ec92b9a6-d6a6-4b14-9724-b1722d35b69d@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ec92b9a6-d6a6-4b14-9724-b1722d35b69d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6573E120008
X-Stat-Signature: d9rykud83umhfucdrt1gdnonhi5b9ddx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772027845-358035
X-HE-Meta: U2FsdGVkX18bcA4DVcwZSC+fqAoBLvqASH0+rv54Sb8mprRzqOOrnSjw0JjQbB+9lUR3iKP/IOsNa2Sg2WmBLbsrnxvHeHCUeFw/K6GurAq23HLh6rH/sJlX5Oiqhhnhrtd2oLi9d0jzPeKPpMk+/phoz6omAEn9gmT8BRxBYU+rfpDWGY+8EvEqx/wm2lUqM0u9j0QmocUBH2hJltR4uz+BwMuWJY7O6PjFMhT4KjKtTJvOBj0ibT+CyB0L/1p2CvHYiv2ji5a3QSxAgp63kCx48uOqGVesyYnqihrApx06LkAYWJusrgRIV8f8IflfUAGUZV9Pf/9ervEARZDltMQ25bqAmfnJMYx9wg5GixOC1lI6RskYTyryppcorm7Z/4s3iboBgeG3uXR9joSv2clVQOILer8h1cAlsmJrFccDX8Gzx/UsbWzPYf7xbk73nNEe9qUDYoImg3iM1a6kQTpr6bH1uOPbN+Xwv4OAZTSlRTlDI6Mnzf2tK9aCR+x5aQ6pA0tHoaw4LzzMjYqBZI+YRk+lhln+3VO4oVgsBW+B20LbM6mCgUzJHImygKaOsHXmmD9tR30Ahu8ZiOfKebIjc78H3NZQHSsovR35Q6nfCyNB+secxcr1S9JPMu1nyy1Wy2ucQCKEwdLEHhm+hKaS4Xn75wYXQwUr+Xb6iElB0mpt1ktE4aiJofhF4wqBJPw7YUzLzKWDgvo2clTAJTGikf5Us822XlOEiW9mWlO9n12HmWeHxXydI+SJ+GR4gJASZflH5VxdexfgqIRwoon6JcvFx9G+qsX46dWBMgeR6SCN3dfwmczLpUCcllIFdDnB2m0/ElOHXv0PmNiudHhy40aoJ9NFrQUI8n7TIU3AIWxa7rYQ3h2d6zJV3V3/czw7ySkM7fIIWh3YCTTUhHNCmNUUV0TxxC7WBoHNfxbhnpuN9MHfLOhqBs69QxS1A3pcljMX5WRXxZHcLhb
 /jGTiap7
 cP+y9Ci2lSMGdeOUnqglnc/Yo6o1bSFpQE7ESSxqSA4is+v2nj5C7mHEbWPZJ1c8Sg7gx5EChDtt5YBBRBHi4ISPi3eNQXYMikg8KwQZ9/nv4k67q0cCEqU4/J7I+aTdq+sGZ0OMGh5C7gIgTXLlHE8QeE5qLTvu3nQZ6Wj8CzmTTaa6b5CTEUOK4dSN4QERvEnhfRGwz5YOoAYTkDkNdxsOMyhxoeqwDsb42Fjr6AZSRidWxXjV8vgE7T9eKLzJjuDr6hG4/k7+W2alZHM11QWeLtiU/ouaIS4OIuf9NvptCcduJwQjXVnNjoceQ1332Hm2EC1gbl7/0Dw8xEk7xYxp6ZVFIXRP0kfi5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:49, Baolin Wang wrote:
> 
> 
> On 2/24/26 10:38 AM, Rik van Riel wrote:
>> On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index bff8f222004e..be785dfc9336 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int
>>> is_locked,
>>>           .invalid_vma = invalid_folio_referenced_vma,
>>>       };
>>>   +    VM_WARN_ON_FOLIO(folio_is_zone_device(folio), folio);
>>>       *vm_flags = 0;
>>>       if (!pra.mapcount)
>>>           return 0;
>>
>> Should be a VM_WARN_ON_ONCE_FOLIO so we do not cause
>> a softlockup if we try to print information about a
>> million ZONE_DEVICE pages?
> 
> Yes, sounds reasonable. Will do in next version. Thanks for reviewing.

Feel free to add my

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

to that.

-- 
Cheers,

David

