Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF2EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817DF6B0098; Thu,  9 Jul 2026 06:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED3B6B0099; Thu,  9 Jul 2026 06:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0026B009F; Thu,  9 Jul 2026 06:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 415C26B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:08:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC13C12045C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:08:20 +0000 (UTC)
X-FDA: 84968813160.14.28F0CBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EAB0140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:08:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+GYSTvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYouMMQpWMiml2AJuY6UOTgwCQtVn2gEVXaPeH/hu2g=;
	b=n/xdwFlV+6KcKIN+zPO+aKikQQCisIdHT2k4q4e7XCdA5SL6R1QXv6lh4RpRjNVr6aS+om
	rq0jZ5Cq19m/Lqbrcj2fQQiU+rdnTqO+hyrFvYdZhF5xDhCSH11zpPCrSdQ9A87XG6yCz0
	45nBhjBlqMMV/RidM3gK820Ttll4Dqc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+GYSTvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591699;
	b=jGq8Xkbr7FNuD9hLPKcxa/uJEqiFZwmdZNavAyQo/IM7k1gjvC1bgOZfhm2ZeRwXKafmbU
	b2vAV2qxzme2gK8FI593qYclS+j417IIz/cnbWHiR1l+AGfYno3DACz/zPM6eIzx2Flqbk
	wRyZPUVaaCrA3dPZTaBr5Ei1iVhjNeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13A8640E57;
	Thu,  9 Jul 2026 10:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9DF1F000E9;
	Thu,  9 Jul 2026 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591697;
	bh=SYouMMQpWMiml2AJuY6UOTgwCQtVn2gEVXaPeH/hu2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K+GYSTvF7N+skn4aOIfjLLuinA3pgecdrF05+utMxRx94f/7q2i8pUEYBv+ChEGFl
	 UTi3kDKesDpRwvDPVZ5X2Y+24KWOe5S4/NI+U2Xz7+s/WYr1UUmmj14Ajn4PyN7PWq
	 aoh6jfu05I5K0f7qQ8iA9nH3MovM3+8mzSR54X3pnwQe0UgwvplRM15w7Kw8OqzAus
	 p0kFy1mNdLYeMSFFVTqQSyyH+3iLBpReM68u3vSAb3Bs/cIqUb0Ov1w1KV9aeM3Kvl
	 l7whj5nWxjpu10JHNTW+60esKdwv0DbPKeTvXZCpWRqkBVMTJrn1o1Pa+RGWEo5N0+
	 KG2pLb2qpAEig==
Message-ID: <b1d85022-a43a-4354-8568-be5efc97d007@kernel.org>
Date: Thu, 9 Jul 2026 12:08:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Thierry Reding <thierry.reding@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Robin Murphy <robin.murphy@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
 linaro-mm-sig@lists.linaro.org, linux-trace-kernel@vger.kernel.org
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
 <e212caac-6c30-448a-9e10-32fff8b842f6@kernel.org>
 <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <83e5e74d-7106-4e14-9d10-56438372f6a3@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EAB0140009
X-Stat-Signature: akhjg1raezg6kxbd5ofnijixcxjq8dns
X-HE-Tag: 1783591698-312428
X-HE-Meta: U2FsdGVkX18xE5uC067Zmc3lQV6UzdyWocoOUa8mxl1QlrpIlaKQ/IWLk0ZM5gFzLWBxtLYOAMFtEFOmc2ws8g9lLru2qFNLCkxcB35LfxGVNtOhXMdqKDkIxmNd11VTKBuLgUgT1sXmfQZc5nZ9xZvTp1JVneK+hjReoQfrXd15+zNIwxHLfVkCmxiG92rVE62ms8dyLyFvTN5GkFQJjcFN9IK1xucRAkPJR4eXQDEh+o+3xb+8gRODWDEiI5sboiY3F7zmV6NySK0UZOhKB3EOKHHFIYa/pcDhCIbL1QiIvm+jH5Dpab7gIks64Y0ad601lkwDF19jdT0osLp3SWW/BmZpdgaNVkDRFZJ8XHDg5PwJDZN1aMVxP3Wy1p7RH5L9Y33GSQUKbRXnMl3lAucii43VoqvVwpa6PHALQDlIqvQmGlXt6CEtNB6YQ6/zfSRW3YyU8bbHQCXXJnUqi2n38kB+5Q61DtCvo16hb+DjZ+DddbD9SYtsx6k3qnI6vq+LAMeLnP0QurJExHlNMxVYhRSWOpsf1p0oiKKKCyjdMR54f446/KuWzxBoD1fy/CPsm3amBPSSGFw/2ifajSSkpq0BAW55OhEvBj2P9LMsyjz11DjBSp/PeAnYlk2GRSRRT4UpauHCU0oop4GSQ0ulMdFrRyaaicMG4y1Hwxqt7gVYHoRkW5Mg6N7++LVx98W/Xoh8/O5J30ai6BfqejgDc27z+dUt7DOWbrWh9OfUFl42ua0hlIADL9WQmCBSbMkfZXjEbhVZ7j442uYfymEwXekjPjgMR6335vmot3tGIXJOi2kp44DuuxsH0bFfdHRaqMgowsbmx6NEQ6uK58eSzAH0uShLlXFBr54ocve3r4PuFnCeqNL8Al70l6ASY4sOO7OOsgLiQEpARtNwGoXV7Od6IkninvkyT6id9sNYLiAWdQvgSkJR6qaDqZIlOXJL9KNsCtaFYy/Fhip
 cOAfsf+a
 CDMj6VUzTdiEgfKTbHch5dN8PCD+LAk/jVX3sw8+RWx4NC+IFro5B15qTLMZerc9E5fgnPJoJtNa48d82fPCTDaAWDai5cFB29eunkbOsYO+G5maOpBAf9ZQ2UtRlqkA0I5lb+v4/MjLMGY+UvrfRNjwZsGL5L5v4UTt9TdiG0MegHYwAsyyVSECit6GyI+qhZenRN2np11AOWlC8+eqvJQSwL+Blz+G/qKzgjz68c63qoMrtnwkLL4W7mVakUwJylbsTjnHSVs13c88F+HTPbQ/M7eJdjGNWZKD9HBlLkDO8Xq1QkqOhi6um16jO+3N0KAJGmM7/h9um2sWC144uvWftj517r2OECtFrYKfG6l58aWAUk2mIV1BCDTNw4BBzYp2khtlowheh5tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 07:56, Marek Szyprowski wrote:
> On 08.07.2026 10:35, David Hildenbrand (Arm) wrote:
>> On 7/7/26 12:02, Marek Szyprowski wrote:
>>>
>>> Well, the technical reason for not creating cma regions dynamically at
>>> runtime is that on some architectures (like 32bit ARM) the early fixup
>>> for the region is needed to make it functional for DMA.
>> Can you point me at the code that does that? Thanks!
> Check dma_contiguous_early_fixup() and dma_contiguous_remap() in 
> arch/arm/mm/dma-mapping.c. Those functions ensures that the CPU mappings for
> the CMA reserved region in linear map are remapped with 4k pages instead
> of the 1M sections, so later, it will be possible to alter the mappings and
> change them to coherent when needed (altering 1M sections is not possible,
> because each process has it's own level-1 array even for the kernel linear
> mapping).
> 

Thanks!

> 
> 
> However, in the use case in this patchset the reserved region is only shared
> with buddy allocator by using the CMA infrastructure, not registered to the
> regular DMA-mapping API, so it would work fine. 

Yes, exactly.

> I'm not convinced that this
> is the right API to use for this though.

If it's supposed to be special DMA memory, then indeed, it would be bypassing
the DMA layer.

-- 
Cheers,

David

