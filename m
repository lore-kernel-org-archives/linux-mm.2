Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7602E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302C66B009E; Mon,  9 Feb 2026 14:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD636B00BF; Mon,  9 Feb 2026 14:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B99C6B00C0; Mon,  9 Feb 2026 14:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBB56B009E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE1301B2B1F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:39:32 +0000 (UTC)
X-FDA: 84425932584.04.2352CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B36920007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:39:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQ4hvmkG;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770665971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sma3W2PDOxdA5dW42PS+s1pH9YZFI4C2mJBD0fjNSqU=;
	b=DBTy0x4kK8jJ6EGkp6dJUPdMrCDNlNDu+ELE/Aa/BgaMYlV9XL7G/k/wQyqGiycXZKKMRA
	Nexn/sDdr/XVmvEVEHhG4eJlxrIsKPbkHShk6FW3eUzZJd29BO3QlaRq8mtWE6jKj5yZ2O
	4GRP9YoR21BVYMNLKthOzO7mjekl7nM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQ4hvmkG;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770665971; a=rsa-sha256;
	cv=none;
	b=pdbHJLqD7a/0hwxMJzawIUUkp7fTy9nfsWTOfRg4my3DT9PiGtf23wNNo6Ly0aoG6P5nMk
	LHVo0f/UrzyYALQOOHCnrWI0qr0CjLreoDgX8HweXEIqhD01uirntG9xQb/+/hGDY2ti8Z
	5t43esdIIM+Me0YK8RRs+mtYhNAVYO4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F29860140;
	Mon,  9 Feb 2026 19:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCE3C19423;
	Mon,  9 Feb 2026 19:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770665970;
	bh=n4Kvj4wOUb0BbsPUCO8jW48A0gwM+U+LAE6RdQaRVfQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EQ4hvmkGWYxIwKiZ2OXd/Uxe1X+keZkxqhDigcX6xGCp+GOpciQ5vLiGCA4Jdw4SS
	 FAfr4xM2RgYh1WbX81nymMzJGjjtSKSG4pVC6UmOJmqi7s6wtIpcBqDrJvZYPbs8t9
	 ssCMNwpGXtLfAzA+vzLSd3fx2itWsfERSkJ42uHXM1CMUcqccmnWkfnuLAuov3NRML
	 0F0kpA8ZL0S6Nq28aeeLn2jqUzCcav/cxay8nDMN7bhzHLbxXxHr68YrzdxX8sKhfQ
	 3C1VQxugmdsOLV9wi4ubWP/IwPlGTCZw5FKr1JClym4lNwyx4hqYP89arMAXTUB/0N
	 GNnCEWeRgMing==
Message-ID: <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
Date: Mon, 9 Feb 2026 20:39:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
 <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B36920007
X-Stat-Signature: 7pd4dxwzmc18kqou5ffyuukcc43oze7p
X-Rspam-User: 
X-HE-Tag: 1770665970-902341
X-HE-Meta: U2FsdGVkX1+FJd7SW0U6xK4cYqq6HoTKO1S7k4xq1AcqW5NzW2BJIvn4/+goXhxbx7E/b7uhTMpWl4Jaq99S9EToNxx3LHdFajLeabvgoQt6mlaTqlp0rmACoZQTFthyaggYothI40GCYrH2GHBmJ5G+2JGJLHIMjuCLmBqYHK62EjQ33fkqNNpFNtmplCj5Uel9xoA457b9t+Ue1I9Nlbj2eW6JwOH9pREtpSbI0G+xS0A+Eee+YfUqqLdyni4EyPf/DvR4jWlUe9W8Ia1FzKzB4S9bV5E1APNEX2ptLSD3Q58PVzEXXBzVwU0AUwPLKC51gPTrkIF/9GYQelxUm/LO71pYWwhEOOd7uwQZdZ9eHyrfi18QbPftbgKmOAx40Jtfei5rl8G4gLOJ2CIsVKurymrNnfevyqx/mS9H3UTF92QFw+rT0ip/jODdmcScRmYJ7kDKxvXgPeFLWzPPQS8FzZo3Weu4kN1Tru8g3mt2H03aDzIyNJKFpoYRJA0z3PuKjIjnPENeDg6GheVjRUdjIcAVWfaI66fwg/jeiN24lGyb5WldG5+wM8vYTgmSSLXFp9RWARTlSuBmv/K2YlBG66cDo+lMQV/y8LjMEgFV3eKUkC8DdneCzfiWeMMEeU3bXkb63T4BBRZf92FwstStyoxa1qNWr9t1zj+HjVpfXHSIIpN6bTCuPqiIu8VRc1qWfMMt708DWuCPp+yODcI15bBWBJzioNb/zpvA7s7GaTRXTejFXzAR+cFzD9xvXzrNBhh6SNfxPzMvAfp7qVdOMF1dqXrPlBbvMggU3Sa3zaye35NUha0HRHi0+quLCkKQap8R+cJnrmtBbEWBr+YtUuXvOtLzO4W5wZgsjCHlhmykIGar4O8/sB7qwqrL3gwPzpx98693nXnPwzjc7nfFqBcS9pHSLRp8DUxZHTYzIOWUSm97nMsXDzCSJNUXOfbfpW5Rhb1R8kRt96G
 92z34D6q
 utXyjtOsJYGME67w6h9vNDWoA1L2mWNy9JqIzPMn4pLyDIPhIx7/seImxJ7WyK9j/OaDHiNo2vCUiJSKEW/0U5zBQNNcSpO+WvLddcCcce5iAPFS6OmsZNq0AzhOk3TnFrkdDWsoFWW6ODxdSG414mJAgzwSReFsIHqGndNVXlCYQy3jNPJ9EPMP/A+W4c8Ue5h20seHz+dtbaSWlMXICZFkiWsN9EQNwM8Wr4I6GaCI87YUvTXqRITtDS/0uh1B2RFYvIg2wsw/paYl4DvHu19c9QDxm7kbgs47kqWRoDAYhH9QvyoHbMhuXEMXholWiSqtGpF8X0XmOERdxmyyVUmgYefjZ8ovxEldz5Bj0cP+SMKnIfK5EvVUIWDwXwzYRgJi2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 18:44, Zi Yan wrote:
> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
> 
>> On 2/9/26 17:33, Zi Yan wrote:
>>>
>>>
>>> I agree. Silently fixing non zero ->private just moves the work/responsibility
>>> from users to core mm. They could do better. :)
>>>
>>> We can have a patch or multiple patches to fix users do not zero ->private
>>> when freeing a page and add the patch below.
>>
>> Do we know roughly which ones don't zero it out?
> 
> So far based on [1], I found:
> 
> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overlapping
> with private);
> 2. __free_slab() in mm/slub.c does not zero ->inuse, ->objects, ->frozen
> (overlapping with private).
> 
> Mikhail found ttm_pool_unmap_and_free() in drivers/gpu/drm/ttm/ttm_pool.c
> does not zero ->private, which stores page order.
>

Looks doable then :) Should we take v3 as a quick fix to backport then?

-- 
Cheers,

David

