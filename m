Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12280C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0120D6B0088; Fri, 11 Sep 2026 23:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F051F6B0095; Fri, 11 Sep 2026 23:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1AEE6B0096; Fri, 11 Sep 2026 23:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3D9D6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:11:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 063C2402D9
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:11:07 +0000 (UTC)
X-FDA: 85203633774.20.F864611
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA308140003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:11:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OTnYzwSA;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789182665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=44rZqpZhEH8P0al8mdGjQVEEhurovctXDBOm6bGHXVk=;
	b=c0fywCtFBt1BIFJVrmfZZYQtZ1WV7zHDNG9Obwupshp+jnoY17E0cbRxDmP0DlBqSbKKmp
	S3r63mkPmSs/ywZFsO3VSVofTd2I+wmv8TUQZ9qGzUdh4BkklJdt5w1Qpwqv9Yq2feDzuU
	5Nk/qSFJHy1GkCT1LCpbqj3DFzieG8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789182665;
	b=PQwXvw2hpiuqersH8RHBAEu2JTgNKR9iHdopDo+fH7xbYYuoDdoCkxmEwr0wWrZQnX6gw8
	hpB5FC0oDWTvBpge1nj+TM1HyCoETbaTjmDwqQlorWviQ+BEb7MxJLKFTtH7oRjPX1X+eh
	H+T0brUR365EhT37ICX3YOgn2W3OQYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OTnYzwSA;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:Message-ID:From:To:Subject; bh=44rZqpZhEH8P0al
	8mdGjQVEEhurovctXDBOm6bGHXVk=; b=OTnYzwSAp8Ms5R4UJF6tAsTZgkq9Y/+
	1jnV2brKcO3Vuz61Ug3y4AB3blt2mck/ctXTIz8dNToVlb48a6tcfHy/+xnbz95w
	Y3Iv0V2Jr9Osoy9aZ/mOrb8yfSutkDP7tAI6Yq4vZAeU6NQ26OaKX9hkS3YFpPH3
	P++7PrNeupmE=
Received: from localhost (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAnIyKswqRq4ZmlRA--.7821S2;
	Sat, 12 Sep 2026 11:10:37 +0800 (CST)
Date: Sat, 12 Sep 2026 12:10:36 +0900
Message-ID: <aab6844e51f8600e1b152fc2ab13ac1e.sh_def@163.com>
From: Hui Su <sh_def@163.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: consolidate compound folio handling
In-Reply-To: <664b3576-05a9-4c49-99c6-ba0928b25300@kernel.org>
References: <20260911061348.2869524-1-sh_def@163.com>
	<664b3576-05a9-4c49-99c6-ba0928b25300@kernel.org>
X-CM-TRANSID:QCgvCgAnIyKswqRq4ZmlRA--.7821S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFW7uFy7Xry3ZrW3Zw4fZrb_yoW8GF1UpF
	WfK3y3trWDXrZ5ArnrZr48Xa4a9rWrua15G3Z5Jr1Ika15J34vkw43t3Wagr13Zrn7trWx
	Z348tw1UX3WUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UYD7-UUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwg2f-mqkwq2vNAAA3U
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA308140003
X-Stat-Signature: osf3zcx544uaaszz95uskd6w9e38c5mb
X-Rspam-User: 
X-HE-Tag: 1789182662-54085
X-HE-Meta: U2FsdGVkX18rx616DGSDfSE9UMz5esfUdaRBcX49EUuDfBdO2297xbTPcr7D27E6d36Gx8dUznZuUUAvRf9ffjuZWfWiA44A7SjcprzEh8Z1tFA0lAQPl4EaO5BRJW7oG2D1Nw1SZdoNDsik/msecqn/GZFuKwPCi+GFXCzQ6Si7IOJ6vNdJOOkSsOVIA0UzQL4+W8eWVBRf9kHdudLkZx0ek+nLE0Bj3lGpuJyM+wxu3JsgPLTeAOvrGvXWy1aBr8cM+7klhk0Coe1eix6WhwCHsf9XFeS+UpSXxLMs+obu3pDiDhJktxKeiLvoNEmJfjRxYJiuRLPnJsdAK5Ufth9dkSO+iFfyquDvO2EZrhWBH8mEwFKgaljeDP4HR10mRTpsa7lJLba9e3oAeElkrG7tC6kVJjoPOznS3UUbqIfUD74E4bDsYFa3Mk5S7fS8jRVqWadKvefFEOUYLSno9c7LrpcGdw0gxgBYqdvxBmzziIsTcDMQUHB4Wiydd+ntGJVJkyDHb3I5GtjVa5FqJG12ilFlf+mvZMKsyjCAIZNamFBXkpg5bHv5pxYRu3FidLUoWnt3SGeSU2wqiH60E/HtnUZQMze0a18qysh3CEWDk3zx+rUXltPYjqBkMQRz9Gkg3Z9sjlQ4nVz3RxWL2JAY374uNIdXUkHO4RBYhK/+jpKcMh5X9gygImHqjAfpVOv7ZYQpMjcCerSI7blWPRjKFWZMMsQ3NX8KhGt30nCAND7BzcgOIvGBffg26jD58so1QvrfgA8AipxHsyFBloUS/kSodxWo4zG+CMSfMwCpu/mvA8McYYiNQoylXEVEXaksKevlC1C0OGJapimmZexLY9MAleh3I4P74Cogkx7IMzWrNa0ohZmwuE2V1X7LBoPZHmIkeWMp2OyOuqqJ0dtXqMY3YVfrIjufALnnFblIwm9LFhsbzgOtABCaY+3kaIG5g/za6WoOX4TJeIt
 GxoPMd7Y
 9tQHgabPbuvfOmLDgxq2laL0Slq16++Vdeg13cqyldT7Hv4bCuGvPhgz/xPml/nPJ9p+UlDC3rD0ayi5qzaGt9IaElCF9S1wmuzJVDRZgAFm1PYmDyKhbQ7jbO3vOrgH1RRd4kBzpnVtIt4v0uMTY3xKH/swXNXwI2ubg7FC4BCCuggCKcaPjlcvaR/WkpEvolHFXXV/FONPsH7LAfEj4NE1NE64mZ8eTNkquojzbeL6XfX3qkcNySgCrcvU5asfIXj5MWRVC0SbqjwyGTTCJ/+hfbb0EnAhO1qGZvW7PYl6hLXGLB3HDmqSrcGvrHdP4+dTDeO8dU5Cfl3hxzjd8hChqJ0fVC8daSC/Rucbbz2QZYvsy0hvv02/b8Cr52YXq7IgXlFpEs2e6NuVk//D3pCTyqoTWfzzJqHu0cKDBPci4uWDwf1mQb/omheIohM/mjWQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> Two tab indent please.
>
> Just to be sure: there is no way we can currently validly trigger this, right?

Correct, as far as I can tell. I checked the current in-tree callers and do
not see a valid path that can trigger this condition.

The migrate_device_range() callers evict complete device-memory chunks,
and the migrate_device_pfns() caller expects large source folios to be
represented whole. In these cases, the supplied range or PFN array is
large enough to contain each encountered compound folio completely,
which is required because a compound folio cannot be partially migrated.

The condition is still reachable with invalid, truncated input. For
example, on a 4 KiB base-page system, passing only one entry for the head
of a 2 MiB device compound folio would leave one entry remaining while
folio_nr_pages() is 512. That would be caller misuse, and is the invariant
checked by the WARN_ON_ONCE().

I reran the original HMM migrate_anon_huge_zero reproducer on current
mainline. The private-device case passes, the coherent-device case is
skipped because DEVICE_COHERENT is unavailable in my test configuration,
and the test exits with status 0. I also instrumented the truncated
compound-folio condition; it was not hit, and no KASAN report was
observed.

I'll fix the helper parameter indentation and resend the patch.

Thanks,
Hui


