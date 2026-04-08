Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B866E1073CAB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187A06B0089; Wed,  8 Apr 2026 09:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EF66B008A; Wed,  8 Apr 2026 09:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075856B008C; Wed,  8 Apr 2026 09:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB2566B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:16:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BF69551B9
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:16:39 +0000 (UTC)
X-FDA: 84635438118.16.033E33C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D33A180011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:16:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nlt082+b;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775654196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mn3qzYNhRg2iM1VfqVNGAcokt35ASZjZJxAjLKuRg54=;
	b=rnYGP0BJLTKBFOr8ijFJZnf7a+P4dhZIKdeL2kha519kstTv5I5fD/Tm9rxkQUcyVyH6XE
	k8ffXw/M+Rf8WNx6hFfnd1n2yYvPs0FECqqZhehZ6OXUrT/oQQMXIErFcvJtG4D6wQNmIf
	W/c+mdxWvhrtmsmU0r0EHXKnRrGlKDg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nlt082+b;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775654196; a=rsa-sha256;
	cv=none;
	b=G25fqC1jxQsIX30fa0UG0FX/wQLd3aLAgT77PAbzMS4SFKfM+KMDh5nXfooQsFoJkskI1b
	dzeunfPz7oRo5DnqwY/M4zWwcJZeBUeQ7Af4c7QGqcx34GZMNrSl+WOP0hOpEC3dWKwzsg
	teewu4wd4l36uGFNuX78OspdsuyoT24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5C4F60123;
	Wed,  8 Apr 2026 13:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E6C19421;
	Wed,  8 Apr 2026 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775654195;
	bh=Ac0zbnS5vZmA7kIf0+uT8N3G9Vj9PgQSB+IhboG+Jks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nlt082+b82AFZJw1fMQw569oIJihl238fyLWhEE4gw1rT+TiOEE8R7lCXtc0V7geu
	 aBPm2l5z62FhN0aXehWnfAJjWmJ+9LlswK4LbHzxHVaxwuhIOxyU1PR0fnUqhsDf0B
	 uxX/TEByTG1/YfiKA0hyFPTzH8KvGF6zrAisirTmEP6NM6k8FM30soOlWvU3syiBtq
	 zOp80gvxYIlyb2+N5VEuJb4gmmAbgGyVVz22ueUN0p4eyGYufJXemyC6EVMTJUih5W
	 n7ANjkY6TLzd+jkLbVRbZaHALZOBe4O72JLq3ahbzOqbX/NM69qCK0fEhX2doAyfzW
	 zOFkQmyqMCtrw==
Message-ID: <159316d9-e3a7-481c-a72d-fecf553d2ff3@kernel.org>
Date: Wed, 8 Apr 2026 15:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing (incl.
 using mmu_gather)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 Jane Chu <jane.chu@oracle.com>, Harry Yoo <harry.yoo@oracle.com>,
 Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
 Liu Shixin <liushixin2@huawei.com>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
 <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
 <2026031222-vacation-cramp-6fdb@gregkh>
 <c6b9712f-2f23-43e4-b270-dd3a7371e57d@kernel.org>
 <2026040846-curable-portfolio-0bba@gregkh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026040846-curable-portfolio-0bba@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D33A180011
X-Stat-Signature: 9e47xnhq61atc31nge5ht6x1bn9mhyz6
X-Rspamd-Server: rspam06
X-HE-Tag: 1775654196-690699
X-HE-Meta: U2FsdGVkX1/mdRh6+mtbWtOFEM/gFoPvFl8IRuG3c7e9ktvBlyLr6aJxxJiLfCj6Eoc/Bs1CIhqKFdq2vFr8ZMXRKp8bvIpqHJE8S3xRzd2Zw6N+Jkxt3DEhKGqfyyuRpTylNxwaC1MTakHzJOcfNgSnVVzYmo9G6saBGIC0Ra+Cl+zxWuJ6EP8rqcHgAtA2gP0wixEtsxiGb3guVWES5XwkMpCWNBMJYiErWOL7M1u3yvADkCrXNE0aj1IIlxzT6VNIgPL62+/tESgMT2eJrYGAaC6DbuIDXfx4eRyrInkKdA6mvQGwpMmcpH4AS1Mo4KOaVzftpS7z8UsVeHwrsLfj7JGQKsHzKXeUUZVWHylhAslGUvcZUVNahhzeiapo0CRBpvF/RWyaEwC2qRbxWKGV5GCZw7Ur5ipCGesi8T3Pw89Co4ASvq7aWzDvNaYGCng0JFBhmySMVLFqnsuycJ8vjwceqRYDJx5Kf8g5nFf3aHoqPToD9ADdyQ9esmwZf4iV1iNGcrdpLID7p5YA6ZrgK3fYavp0ZI0m2ir0T5tie9f3D7tiwS4oYl22LZTtIrnez+jsxqdXi9KC9zJYRqpbxsUT0fno+IQetKlQ6WaQhuV+mWKSStuyQWCK1/03wqxej1FPOyexv3rVQCCW32VVMzg1xQa1q0wpfhhxGrclTd2A4blamMoYbQWrBdRKY9pimJVeZpZeG9fHBMia1kpBBtQKUn6CL+Zl1Tf1kV8sXtbaJH6cMJdj7r5jEB8L+X2fX9ayZXG+2HLKfwd3kcSFuI8Q9M+hTPnxAY9nYg2Lk+L92CQ5DrBuuS1KChJgdOSE/N6S/mWxqhnZqPVZKH0/ytKUYe4YsGtrsHLCDZuk/StMvmHU9CWZZDieEXk5ad68f4j/lbhIijE7OhbSLQrHQbBQTCdFN3vswseTlB1BiGuonchPTunl9YWykpWaibxegbrlTAdA+/PgeEj
 lgvpmQUu
 XSWD66DmTeaHIIF/qsgUPivGjONe6Lm8eCOvvDF4l0VrFoss95c2kV42dRiHDWh2gpkcj4HNVNuziyqiW7zfq7BrTfN1GawLGtbQPwvUeyDjURhkFr7/NgFBzN9ebWLWNrNtWGgG4RUUJyFljHHqvooipTbMu6y4jlQ6pbd/TaAsLEaqIxJNyVaWuw6tcGYiBFVlQxh5DbcwqBSZnuAyag89pDMLtv/wJSxh/tgegAj3I5LgLPmdE+or4y0njTF70z0mez1Y4+wiMrCpyQUZVJQQtH1ocxaz+cw3ux86aqkT0eaWsl4hLqZNrX22vp9OtjPjyrbctyjgpDVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 14:52, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2026 at 10:00:44AM +0200, David Hildenbrand (Arm) wrote:
>> On 3/12/26 18:47, Greg Kroah-Hartman wrote:
>>>
>>> I see 70+ pending 5.15 patches that people have backported that need to
>>> be queued up as well as the pending upstream patches.  During the -rc1
>>> cycle the stable trees get flooded, so the older kernels take a while to
>>> get released as they are on the bottom of our priority list.
>>>
>>> We'll get to them "soon", they aren't lost.
>>
>> I assume that is still the case, another 3 weeks later? :)
> 
> These are all queued up now, right?  It's a matter of actually doing a
> 5.15.y release, which seems to be on the every-month-or-so cycle as
> devices relying on this old kernel sure are not used to updating very
> often, right?

Ah, I was looking at

	git log stable/linux-5.15.y --author "David Hildenbrand"

And didn't spot the patches.

In my inbox I indeed see from 03/21 and 03/23

	Patch "mm/hugetlb: fix excessive IPI broadcasts when unsharing 
        PMD tables using mmu_gather" has been added to the 6.1-stable 
        tree

and

	Patch "mm/hugetlb: fix excessive IPI broadcasts when unsharing 
        PMD tables using mmu_gather" has been added to the 5.15-stable 
        tree

So that should indeed be on its way.

The 5.10 backport might still be missing:

	https://lore.kernel.org/r/20260218130552.55727-1-david@kernel.org 

At least I didn't find a related mail in my inbox.

Thanks Greg!

-- 
Cheers,

David

