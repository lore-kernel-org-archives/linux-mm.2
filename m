Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCD2C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E146B00B4; Fri,  3 Jul 2026 08:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8786B00B5; Fri,  3 Jul 2026 08:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290E86B00B6; Fri,  3 Jul 2026 08:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF2656B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:14:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5914AC25E1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:14:44 +0000 (UTC)
X-FDA: 84947358888.24.87F5008
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC6D84000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:14:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6VbRKa+;
	spf=pass (imf01.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783080882;
	b=TOE7HcaBXizp6a+VY5FSe6tkWJV7pumJ1WXClhvbxKWuB68a72gStvcXVPLCaSCp3kOWj5
	YN+atCdbphitynhEv7pnnZm6BPqV+gMTTmeJQNkwhS14xHsLmtVQRapu8OLxImGOujg+Ci
	X2gjK1NyLqTYIa5GT7oUeEk50d/FBEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783080882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCSekJzceclmv2Xdvl4vn/0F9vF6oLcNXpc7pUyDj0k=;
	b=XZs2ln0uNb2j+o9wWOes3QKt7VNoHPxh2t7xJivtByDLLSfJjAxA7JGk1SikNAlMe+MkSM
	YGgyLk5QiQelsGODJlgyT5jxwnJLmTlEIDfWNcwJ2An0HGklNURjxwzgZWLfxs4VhwttZO
	kot4L95DBDQlX33XMH0J98VkBMftwWg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6VbRKa+;
	spf=pass (imf01.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFD26600E1;
	Fri,  3 Jul 2026 12:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D41F000E9;
	Fri,  3 Jul 2026 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783080881;
	bh=wCSekJzceclmv2Xdvl4vn/0F9vF6oLcNXpc7pUyDj0k=;
	h=Date:From:To:Subject:In-Reply-To:References:Cc;
	b=d6VbRKa+He2/cAFmwYnkVZjxIlsRAYd3koyUzl174SlRWigVinPrxLNyW1D1D0xO6
	 vkKKNIjrywD5F/UoMCDkjtUhMxTDLSU421VLUP3NnsA6Yq0l9c8CZZMUbV11zQMLVm
	 xMzeOzkKcw/86tXQdDzbYMe4rYh4Pzb86R5wZxWB+2w+rY6vfS4Tp4BiDgmMxVtryf
	 iBGvffCRTHwx+6nF4Codf8+X4UD6mDt+kizURmVt9H/JKijTnykALPxPBgCZUpmupk
	 VMwlDGrjS5G8BUxlsvjQZ0J03g4d96qrPiIHOY/A1nSnH6jTvs4ieLW2YML2tmOltj
	 ytQtBS/G8QFIA==
Message-ID: <e6cccc28049a6231d50842254447c909@kernel.org>
Date: Fri, 03 Jul 2026 12:14:39 +0000
From: "Maxime Ripard" <mripard@kernel.org>
To: "Thierry Reding" <thierry.reding@kernel.org>
Subject: Re: [PATCH v3 07/11] dma-buf: heaps: Add debugfs support
In-Reply-To: <20260701-tegra-vpr-v3-7-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-7-d80f7b871bb4@nvidia.com>
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Conor
 Dooley" <conor+dt@kernel.org>, "David Airlie" <airlied@gmail.com>, "David
 Hildenbrand" <david@kernel.org>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "John Stultz" <jstultz@google.com>, "Jonathan
 Hunter" <jonathanh@nvidia.com>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Luca
 Ceresoli" <luca.ceresoli@bootlin.com>, "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Maxime Ripard" <mripard@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Mikko
 Perttunen" <mperttunen@nvidia.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "Rob
 Herring" <robh@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Russell
 King" <linux@armlinux.org.uk>, "Simona Vetter" <simona@ffwll.ch>, "Sowjanya
 Komatineni" <skomatineni@nvidia.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, "Suren Baghdasaryan" <surenb@google.com>, "Sven
 Schnelle" <svens@linux.ibm.com>, "T.J. Mercier" <tjmercier@google.com>, "Thierry
 Reding" <thierry.reding@gmail.com>, "Thierry Reding" <treding@nvidia.com>, "Thomas
 Zimmermann" <tzimmermann@suse.de>, "Vasily Gorbik" <gor@linux.ibm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yury Norov" <yury.norov@gmail.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC6D84000B
X-Rspam-User: 
X-Stat-Signature: da9euoheoqiukbn7gwsdze3ybf34a4mt
X-HE-Tag: 1783080882-495693
X-HE-Meta: U2FsdGVkX19KL+9Xw45kp43uEZ9cK3F+efSXcA2OwO6ftmdmmdLeAEXiFHC68M74fj1RJHLfV6xt448xsmk75EJfABNeLpzHEm1UWqaVORpE6NgkSF0zGtmOozBYeNgwfzm9TyrnpAJ6tXqwj1ViwXtyQWhpZTLkEIhwRxkNeINsG5uWEzbpmNKhN7VGhiRdTueZ/+F38tThRGePHPdUKa9lvPBQbYD3bsI2w2M3Gk4MGhVi8b6ZarFxr+8iHwgsDsdJBctow31luVisHEzy2JMMLBnbAf8xxFWrjeu2m81IzujDPqBu5Cb95i42PoMi4LjJrS4xaDg7gQ7BbGXZzGMP+0h1UvkeWl4qWfuWIvjhwEq9ClnaK7rdds9rRDMG+EnfjouZi0RT/AAi9S4G9qMQwwtjTigDwpIDWPt+D51WoChf0ytCKHh99VihBC2FoYDTxjjNARyEqJh/QpBOBTdhSDy50cK96ohtYpYWaiDpyY6D7ya90kH48PRWW9Q8zREvGJIhUxTmT9OhKRF5h2Fog/X+juQCPxnypHn5PKK8HvPqE3jn9fdsE7zCSaTRbEO+D7VXAxZqz5hy3Nmhl9ryM0uYhOYwOUHRMEUKrR7IghDmWa/Ksx9Z9dUnwi9TCmxdydlpJVBUnELjkct0ZLyFgDcXfvBGaOf5aGh6mPIyZYIQwkNjGhSAet14xPTVU9h1fFmW2Zhtj5RBez00ANlAXJ0OkMkQuQJXkbSB7lCo/awTeSPrIVbei8NE57DrMAL6ZkeyeKclpX+Qx0LzLCloNddBUDBHhGQ6yfSGvOj+SMDbZTWZZXVH4hyFO234EtsnUvpbDv6v5v4aRsQsGrKplaDGprgOSN65I+RLxu0VpmPo4aBkL+NhjUXeJOHJZeVpTgIHnpoY3xBEZwTsa0vdN5OkIODGN5wlTM19kCoN2A6a53GNN5cm/q1YGxV7lA2cBCUlWHQPPUt6+kk
 qWEk7Yr7
 /SzfqVi4buF61AMmEVNehh++GP8qintIZ6yI7Bu1xHm1PV8aGmdFUWH24XEgQWcakz4O/Rj5VVUdLQQv6OdQQfgcgmUymee5u9B5x74mRhXEcpwDvPfTmjoNy7swb7t8N+rxCfPc+w0s1VqBX1Ass57aeqpejndNAIMz6vK55jLmfH0PkH7LX1X6O4pPLKsKb33jfdEy07S043Hpp8pHXRYe3KheRRwFHaAHXTHIydKVVxgmp1SWqQa22a/jLtgepBK1zsjPvwii5ZUPXdWpqEkocUeAeRd7g6vtCtDv8Iok0SHlub2t32m4/iv8VtIhF0lNU7+V44j5rF6L+6LPbq74/obIVUOmUtxTAjXjxiPmdkjqKW3TFPli5L4sokmFvwd+v8H6zX8rQwqo8cND5IufJfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Jul 2026 18:08:18 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add a callback to struct dma_heap_ops that heap providers can implement
> to show information about the state of the heap in debugfs. A top-level
> directory named "dma_heap" is created in debugfs and individual files
> 
> [ ... ]

Reviewed-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime

