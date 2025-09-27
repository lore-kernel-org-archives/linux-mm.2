Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861D5CAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F408E000D; Fri, 26 Sep 2025 20:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BFB8E0001; Fri, 26 Sep 2025 20:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D1C8E000D; Fri, 26 Sep 2025 20:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C10E88E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:46:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B09787BD9
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:46:34 +0000 (UTC)
X-FDA: 83933189508.23.AE023A9
Received: from smtp153-166.sina.com.cn (smtp153-166.sina.com.cn [61.135.153.166])
	by imf01.hostedemail.com (Postfix) with ESMTP id 40E7D4000D
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:46:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=MNzSQBYC;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758933992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cnyeesIhcUrYexD4eZfyUD5rAtsW99qBCL0U3oqSJo=;
	b=dpODliOVEgSRjOgDHWeDfLUMmqKM7pdgSn0WRuGqc08BFkU4Mxx9As90zs6Y46SityLQM+
	RLVHHkXowBwQaflLwiXgYrCAAmyTqaPJ9ewYjE7p+f9hCqRHI3bhF56COBkkleuQOKVU7U
	xyb9biQLplCMhkNQZyir2Q1OTLJ4YqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758933992; a=rsa-sha256;
	cv=none;
	b=WYLLds08v6Sgn2Umcq35xxG1ucqG564oU+p8LDlbfy/Ru4yH0UlT5umPiNmKCbulsYhF6W
	cAUsS/9RTuEkIGqHoKAk9/YKssm3I7HAWFwDE9h7QqgYX4nLh2ILoKL8e+qU6MeQiWTjup
	ryf5dhsgiGt/l3Ax+xU44MlXB+/QGRg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=MNzSQBYC;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1758933991;
	bh=9cnyeesIhcUrYexD4eZfyUD5rAtsW99qBCL0U3oqSJo=;
	h=From:Subject:Date:Message-ID;
	b=MNzSQBYCbSpoXmGWR+7+NuD6AW1g9hYkwyRuWR/Z1K0sprNibBf6HllQtmu6uCZnP
	 KL5CfyVMTJEmrGQWCPvXrciqjgXaWp01JnAty6EAN8DxiOKL94g3IG27Tkocm8nALq
	 Nsl+vkIv4oYCN68LRFfPQ8iIJv2rF2Ds4Vlxe3nc=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.33) with ESMTP
	id 68D733E100003FC0; Sat, 27 Sep 2025 08:46:26 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8362056685430
X-SMAIL-UIID: 6AE58A0D45A640499DF9C2884A90FC74-20250927-084626-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Sat, 27 Sep 2025 08:46:15 +0800
Message-ID: <20250927004617.7667-1-hdanton@sina.com>
In-Reply-To: <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40E7D4000D
X-Stat-Signature: z95j33ydggmtzun9zux4uuj8amrdy41s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758933990-120030
X-HE-Meta: U2FsdGVkX18wzhUS0uUojIqAwwXvlfAYZzsjUdLmrCb2yk+Vg4Snc7KV9AI5WIFNAVLl8bFqLdBc1qdA2LmP5rZc+GtOjllP8ljUmxTH01fTgFi2SVzwE6SdiUHSUChafRpQXYyfvkaePiJiUONyLiM77SaPfkU9g60BcwYtogWD35oQEJtjNkg4f7TcKM5VtoTeq2IxP1gQkC0dmpNbP9wgOt3mtx5B89v1XuQBPeXl6HMwt6e2uus87zJlWx5+3E78NW+qryWWi58O7sZ9r7ylaYyDkMhczoqFE7LpGC7dDMPuBSZ+7i5Uh1P8BHnWG2HRBNkzUjdMEwN0qb+A1nA06GOdkfcx6cmS+G3NGuGQDSRpTZohVqF11Ep8SyJraBrsMIg0WyaBoOQ8uhz5ICh7DKduBQp8JWUxUC3KPtjsE1j9mV3pIf3RKGu+rzttEsS9w6cjW7N3FDX/V6TVKx92PAP9uVbtPHw27wUjZOsM7cdNMTByjhcK8woSuiWLuon5u/uWnZcI1Tpaw+OU4Pwrw21xI1v32Ma1YeubEC+c9QFuKsTB5QpHOavY3Whkt0t85DY0fjdZ1GFRfdcMpwJwZSQRZzTEO4q61mO/Nfk2e+E1Md53kZ7xy2OsYxAS8n0/Ss/nLEx5tXUwUcBeRVauo6pnMkl9T+4UA8j2vg4V2FjFkNYyfdViQ318CIYAWtfJd/SoaRqHcm9sNYNZoa6xGaTJ/c5NuA612BN6EZlgXhFId4VCVXriEFg3weOOcPeM1gG1e0k4ZRnfrX4/CtvtzGTBOCowp+JqKd+U5PDIMuaqAlD/OsPLJyEsAX99AQu5tGEO4t2PO3elfK220AmRizMni+7rJx5iOZEsxRoF9FW0wzy3qjW8x+ht0ghssC7/X6hT60El5yM45Yc8YcMJuk/MKijJH/sMsNEHX5IoUdAhEh8vNf+XB/VAVVIF9WugWLsa9AmHNWnqDzi
 zmbKwzMY
 XnEhgg2xEWCVrNVaQMjmA+UzZRkPSiTpZswALvwv0ttxYIY6d9XBGc3jV/qTjoy1JXZOd1VQIDutM4OrHVGncd9Tn7Xr5YP1aUbZyAqFALTyilrtsl1umslRmrn0wwrnxDYdTMlZZQfSOGDQ2feDMO9oujiMuMHkkNgDQf4BHHSnRhjdqzrJ3jdszQYRb5+3wbnmjEPH/PlazviuRFDB6qXafLQ2Y4KNZtbk6rf027W3HLsKS17d3rCPRGTrawnLo1sxi5qMOGegjKidItJ/WG5QCiE8oQrDSBYiFXtqrqLeULSvZImOzM6/b0eQLpRd2mtwDMY5NxKJ8SP6stwdfPs7qUX5cmjDLK8hlVDYAKEDgSyvxxIbqnSDcKKNF6W6jX4DDnUOZv/OJR8gbrNmRBu2KDrU6aan/2veZ8jU4M/KNhLkwquB9ybUr5AIfGesU86ZcVD/dH9hLEF6oQjLLhwIdOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 13:44:06 -0700 Joshua Hahn wrote:
> drain_pages_zone completely drains a zone of its pcp free pages by
> repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> In this loop, it already performs batched calls to ensure that
> free_pcppages_bulk isn't called to free too many pages at once, and
> relinquishes & reacquires the lock between each call to prevent
> lock starvation from other processes.
> 
> However, the current batching does not prevent lock starvation. The
> current implementation creates batches of
> pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
> Meta workloads to be up to 64 << 5 == 2048 pages.
> 
> While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
> indeed can be adjusted by the system admin to be any number from
> 0 to 6, it's default value of 5 is still too high to be reasonable for
> any system.
> 
> Instead, let's create batches of pcp->batch pages, which gives a more
> reasonable 64 pages per call to free_pcppages_bulk. This gives other
> processes a chance to grab the lock and prevents starvation. Each

Feel free to make it clear, which lock is contended, pcp->lock or
zone->lock, or both, to help understand the starvation.

If the zone lock is hot, why did numa node fail to mitigate the contension,
given workloads tested with high sustained memory pressure on large machines
in the Meta fleet (1Tb memory, 316 CPUs)?

Can the contension be observed with tight memory pressure but not highly tight? 
If not, it is due to misconfigure in the user space, no?

> individual call to drain_pages_zone may take longer, but we avoid the
> worst case scenario of completely starving out other system-critical
> threads from acquiring the pcp lock while 2048 pages are freed
> one-by-one.

