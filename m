Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7564DE94627
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD156B0098; Mon,  9 Feb 2026 20:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A916B0099; Mon,  9 Feb 2026 20:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866A46B009B; Mon,  9 Feb 2026 20:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72C486B0098
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:20:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F11985867B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:20:12 +0000 (UTC)
X-FDA: 84426791064.25.93308F8
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id 698B320010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:20:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Ase/T4mh";
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770686411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cN85VGoE32TAaBeuh7trX4TvvDZc5iL4HxTbBbIYYCc=;
	b=kEOtOoVt84z6vX8PhdM5/QucqBAyWe2otiEtWQM6rDyBAhNQubEqbN9cr9iv8YgFb/LdKf
	4J8rMb5fXo1ZglnU/oOxRuPnWH0duw8jJloK11cSrKROHjcDSoPUoKgrO6e+sS2L1J/ag3
	7KE/k1JRF7jJgfPZ2awx2vqXII0OpFg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Ase/T4mh";
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770686411; a=rsa-sha256;
	cv=none;
	b=WMiSBbiuRuXys4X5kNL8WumogSjlba0PXQa/swPHjssBKqhK32i8Qoc81rL3V7wQ1vS7Nv
	4Azmp6naUiXo81KaX/u4S86tyxRts4Y85QxxbyYnkmZhUIZdMu9GzptNJF64eEtZGBTiZr
	jrcv0cXB6xZQqJsyTjYuzc8HztkUAd4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770686405; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cN85VGoE32TAaBeuh7trX4TvvDZc5iL4HxTbBbIYYCc=;
	b=Ase/T4mhl3RrGkZ6tAe2ff08C4JAymQaeH/U/xvL0ghquwN1d8P2+lnmqR+Km58vPuK7j4F17WQm8tse8D1Y3RQYWER6qTnLyDct9IW9qbL0AW2e0JN3Gp9+wND5eEPM84srkSrAUWf9sI1GlB2X/pLfn1kZeOcFEAgTJuHB9d8=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyx9JBp_1770686404 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 09:20:05 +0800
Message-ID: <e69270cf-dac1-448c-ace8-3f789e5cdc6e@linux.alibaba.com>
Date: Tue, 10 Feb 2026 09:20:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
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
 <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
 <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 698B320010
X-Stat-Signature: eb6ot5j1j18zqth4hmitrwuo5n3refum
X-Rspam-User: 
X-HE-Tag: 1770686408-944425
X-HE-Meta: U2FsdGVkX19T5YW+UBnFSgg1UatCUeDAubVAwYe7XnHFEdBKYgA/Q6+0zNmuMZATNo3HdAmyyl4sba3tfsWbx6Bfkn01BPm/MdInOsH4Neys/3TssSnbx+8CeCh8LYJs/NLTkd7RdeY0hIy3nCELmo7IFKe97Nl/LnsxWMEMHtbOZ219IJHH/YCUVeSzc9TPpRj1uHgxh1nqNoOoSbsfDCsZGfL74hC8y0zoNIE2xD0vzgeoY7C2iUzcA7IeChS3bWsQ5Os+IZ68JD27VgUdQVlecRBUuMMw0Zh+8ogabZf6XrG/AZfajDM1rgXZCT4g+ixd0vlyylxwivHWT3ExlAnukex8vf4GMhhwHp/eHY5Ia8zf9vDQvXPCcfIs/k9jrLS0aaXJCqrTIPjPb4L5jR8PX2g8Aay3bTQRRUBYRw4Pp44dI3cp1VGOnT4sizrU9fBVcwn8sf+75FJ+vkbF/Y3inMFlHbQtGSz768+9eVJv3JghuPqgptdLOPhGwfhEcHQVd56AeWD72QKnHBen4RRKTXuYD0mn9SdVyhoTlW/pulrhoGUAsXYkDwglnMSt9CPpo9Im+kJfJ0P3mLZIXaZmAAySjw+l3L7P28qr7zDFPoNKnHr87VsdlsIuEdq5NxG/RyK0hlNh09BKdK8VbKrzjkKX0tI+hjS7Me6kuQFp/kJQqX4L1zU+JxtFTttu/YNisu0g5tJgPORglD3ZO7ayNXYO2bplGxwNWiEcXdEFgIYuHraGqsWBiD0rZeh0IgOiI59iQJRUbcFof8DzSkRO6Z90lTvq3TNn+q5L0AunK2FocsAnnBn7vb7NzKYcbqPtwdudlYhXUqeQDLxbtswloh3VN38B3/0Ptb1ch4aP+wyYWLZDVI7nzrQVKWVGthqX2umiBu/euNJq4TuxYH3TddEtGMHmekUjVOX3m4CSTX7U2BXD69px2lGMH03QGKU21qkhCko9qxjuZWI
 Zp6OQMVE
 bqvQL/6sTW1UsD2RKTplSebOp4Stydnl0zFA2QIaizCE/M20Z6xrNBPUc/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 3:42 AM, Zi Yan wrote:
> On 9 Feb 2026, at 14:39, David Hildenbrand (Arm) wrote:
> 
>> On 2/9/26 18:44, Zi Yan wrote:
>>> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
>>>
>>>> On 2/9/26 17:33, Zi Yan wrote:
>>>>>
>>>>>
>>>>> I agree. Silently fixing non zero ->private just moves the work/responsibility
>>>>> from users to core mm. They could do better. :)
>>>>>
>>>>> We can have a patch or multiple patches to fix users do not zero ->private
>>>>> when freeing a page and add the patch below.
>>>>
>>>> Do we know roughly which ones don't zero it out?
>>>
>>> So far based on [1], I found:
>>>
>>> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overlapping
>>> with private);

After Kairui’s series [1], the shmem part looks good to me. As we no 
longer skip the swapcache now, we shouldn’t clear the ->swap.val of a 
swapcache folio if failed to swap-in.

[1]https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/T/#mcba8a32e1021dc28ce1e824c9d042dca316a30d7

>>> 2. __free_slab() in mm/slub.c does not zero ->inuse, ->objects, ->frozen
>>> (overlapping with private).
>>>
>>> Mikhail found ttm_pool_unmap_and_free() in drivers/gpu/drm/ttm/ttm_pool.c
>>> does not zero ->private, which stores page order.


