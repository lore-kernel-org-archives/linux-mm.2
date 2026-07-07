Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B294CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0313A6B00A6; Tue,  7 Jul 2026 10:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008D36B00AA; Tue,  7 Jul 2026 10:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D2F6B00AC; Tue,  7 Jul 2026 10:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C061B6B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:15:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D2D114043C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:15:38 +0000 (UTC)
X-FDA: 84962178756.29.094AE02
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 34198180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:15:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LyOTCEzl;
	spf=pass (imf06.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeuSWdWWyPuBQRFBqkPwTo2uvNDLPsXRSKKIgSH5biw=;
	b=v6pvPLuT4zXLNsg6oObUBNL353Blg9rOgxONeHv47zmJQzwE75733uLPfPKnncNGKf2Vf/
	IAbuJlX4vcPbP91cj2GJmDTOy5YO56Pt6RHeM6dirNYD2iTOnS+nogVePAvAgo9DWpCchp
	vSn9bOkeIdkf0KD6irDG5ozycIvrZBQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LyOTCEzl;
	spf=pass (imf06.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433736;
	b=6qtRP9aUwlZFpaFPytA2N4X7lyx1wf0o+8oyEvx9NQfFX8Vh8vYflb+hYSy7Avs1178kG8
	Nht/VYRtWZXL3zuSx09Hwb1/rQWdTqTV2Ss3sxhvZH+glLnLvewdRw3cq3mYHSOl79aI5u
	aYJjQIRUBGmjEz+MKGgSTWOIRkI7p1o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E00901756;
	Tue,  7 Jul 2026 07:15:30 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BEF93F7B4;
	Tue,  7 Jul 2026 07:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783433735; bh=IinY0qicpix8YaJZbueQ0ZMS6TH6C9aVow2ztmvUxgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LyOTCEzl2lnONxDyc5YgaBVzkQQTQt8ZMCnf0rfSax4/Wh4a3/jy5UcOfHKZmIpCd
	 0JK0/K1vtUPTZHNaeJXMR1zwsZF41NYv8fSGFE5DnXecvjNTDzStlfxEvHuMh4fFmB
	 7HXVfvV6cUYysmr155+Ry6uasnPzrKLfjL2xY65Y=
Message-ID: <f6e8b4d4-8b50-4cc7-b264-ae39929c619a@arm.com>
Date: Tue, 7 Jul 2026 15:15:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
To: Mike Rapoport <rppt@kernel.org>
Cc: Will Deacon <will@kernel.org>, Thierry Reding
 <thierry.reding@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Sowjanya Komatineni <skomatineni@nvidia.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
 Chun Ng <chunn@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck> <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome> <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome> <akzikTrmhMsvkNVY@willie-the-truck>
 <b0a1bdd7-46ab-4025-8775-c9273892444e@arm.com> <ak0A6eLp0Pw8iKK0@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <ak0A6eLp0Pw8iKK0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34198180003
X-Stat-Signature: 6qhdzakdfhed5x43j3jp74rsnxqrdmka
X-HE-Tag: 1783433736-232797
X-HE-Meta: U2FsdGVkX1+yATldpi/m8hN0C7hIpgokXj+rDxGRni8+9ZWv7ptNOgW5sctp/OBYAJZ01qbJ19BjysT+W7ueswUNW4udRJkL60zI/nx19LmKUbJYjJ6g6P/biLn05wdROefNNbtNmdBNcjj7LLhqmKhMOVnKUigVgzdHP9ZAH8ATuAb2iTw8eyrmOJiH1KVcBRTdelivGbWjKyKfm27PbcCzJqf7AOJC1S+ti5wVeM5wxxEHwWBv1S8ivtxTOUtsAEcR+xjZycjLkLM5zU/cVcYTBt747zWwxeWZ0t3fqMfpFVSMt4I8oPPJFto4wmEHLKyQT9EsqeMRJoTDRcvVlXt7e5sQlUXZJjrfiLc0wGOYDcdlGIcMItjjzelM4Rw2e0TuArySR2TLYnNEQMeXhqsGUvPB8Tv5EFQN5pbw+yCcy9x59rVmGPLMuyH1IBQ6StOMgN6c+X+KNdUXg8nL62IMLzIpmUs63YnZQ79pu0356YvFqb9fHB62VTLA3PgPQ49+c8KqGloUFl+F0Pzu+D4JynZAD7ZUCACKOHFlER0MSMRWPcYRFRSavuQuzBtNoBpzZMaIbcdyxYcb9tF+7F5WxAIkDBF4rCWbZu65nmk1/0bLuvGi8244QU6IvqkpXmBZTFKWIH+dpYZNgnhafHyOKh03qmp5hd5wPJYE/B4u8f/2gok4ZQQ0iBx235Ff+SzVVNi2TKUEZAfO7sKGAeuw31rZZK7hiPg/3tr6ugNcyf428jYX/51WX8ZtFdo60GQxHZlyEyX+fYBKZjAcRQVMa9h7Sje+g7xj3gKPxDKdD+PCqaA+y3UL6NDP20wILN6DkxrFYdtbrf2EL4DQUORlWlsJ97pZn7WwzExaW5bmr26MkOJd1IwMQc6PR577IuwM8Cz2vgp37xI5umPfV5McqlH2zaR5pdUAFhn8CzGpTT5qKR6mFrQacPzO6AFqklJd0D6+39t3bH3NUqp
 JWtrZee7
 lCRPx6OTLc2qx1fr2WGZfw//wPQtXmTeJwq/CeI5svmYPRh/4AdJrRd1k6q4W3u2h9EkklNkozfRHYBxhrXGARZszhF+FxoC3Qf5JDTRUhuFJermjBZa7F3rdzVH9du30P6/+TEzEbziBA084rajARtpV7KJYyV34xl81LQ44DNNAbrgo0A5DiNhsJvCqwTi6MphMFl60Svs9+Ax9m6PTK3i9sKpkTemdNAK5/S8yN1zzttB4sTpU5f/TMgxzvwxG61I2uOeD34DDooV5SwyhU1lNcak48lyAMVeoqtsuFNAeuq3Di7HSRLobGgOsp9H3Z9JUqdYCkP5Tuu3OHso6wPwgk3n9sgxVttEvdXXYj7bDOq/MsR7BBexSH1h6W3Oa+mIrs/PNCCsdSco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/07/2026 2:36 pm, Mike Rapoport wrote:
> On Tue, Jul 07, 2026 at 02:17:29PM +0100, Robin Murphy wrote:
>>
>> Given the precedent of memblock_mark_nomap(), as long as the reusable
>> reserved-memory regions also get split into distinct memblocks, then it
>> seems like in principle we ought to be able to give them a new
>> MEMBLOCK_PTEMAP (or whatever) flag which could then be picked up in
>> map_mem() without needing to override force_pte_mapping() globally?
> 
> Please don't. _nomap() caused enough pain.

Indeed I was there for pretty much the whole pfn_valid() saga :)

Bad example maybe - in this case the only actual similarity to nomap 
would be the fact that it would also be set by the of_reserved_mem code 
based on what it finds in DT; in all other aspects it should be 
functionally closer to something like MEMBLOCK_RSRV_NOINIT, i.e. just 
carrying information through the mm init phase, then ceasing to matter 
at all once the linear mapping is done.

Cheers,
Robin.

