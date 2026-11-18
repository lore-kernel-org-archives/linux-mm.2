Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C974A606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deepfinresearch.com header.i=@deepfinresearch.com header.a=rsa-sha256 header.s=google header.b=AdgSCHkw
Received: by kanga.kvack.org (Postfix)
	id EB0586B05B4; Wed, 18 Nov 2026 08:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E885E6B05B5; Wed, 18 Nov 2026 08:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DCB6B05B6; Wed, 18 Nov 2026 08:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B22AB6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:55:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AD8E160778
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:55:36 +0000 (UTC)
X-FDA: 85448387472.21.61E5381
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4AD5C40008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:55:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=deepfinresearch.com header.s=google header.b=AdgSCHkw;
	dmarc=pass (policy=none) header.from=deepfinresearch.com;
	spf=pass (imf27.hostedemail.com: domain of cenk@deepfinresearch.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=cenk@deepfinresearch.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795010134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzZ8p4GcrJgIWf6F5LBlcZh4WchWnffp6/lWOYHVfoE=;
	b=YxAE52IZNbjFYQVmKdyfxagLxxtxbXA0w99QqC+yxUluJSxWsT8qDzbgi23BN831PjGTTy
	QwDcXWTnsrCi7QHFxUpxtVvvjFogkuRGUiybgV26J1NEO3n9mx5HlidfFrMWgaHrCkqgy4
	H798M6BqIFZj/Ig3I2vbRI1GEPnoLyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795010134;
	b=p2YR1IugLOCKsI0FtRm7mzdYj3f9QxBR3PxnPzE6NmUaP2QBKMHYxkSFTyyNsuTY8bqZhg
	KO0m8NYLGwCvEFgoye4D6sRw87vkQeayDDgFE9bWBB309jPc0xR8PLzSqQXvWU8oyluYEb
	2DxkFn0fFqvb+/6gv8ewAYQVGE72Lmk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=deepfinresearch.com header.s=google header.b=AdgSCHkw;
	dmarc=pass (policy=none) header.from=deepfinresearch.com;
	spf=pass (imf27.hostedemail.com: domain of cenk@deepfinresearch.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=cenk@deepfinresearch.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so7241225e9.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=deepfinresearch.com; s=google; t=1795010133; x=1795614933; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:subject
         :autocrypt:from:content-language:references:cc:to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fzZ8p4GcrJgIWf6F5LBlcZh4WchWnffp6/lWOYHVfoE=;
        b=AdgSCHkwJvUzrGpE6l3/5SA6Vk++0/lXmx6Dd4Ty4EFBMxm7MEP8otrA7n8ycbdmmv
         0p9B0Cha8YIdsQh4+eVq7G1KWCvBHiM331yW8urr4SlHI8XMkvHvGL/WIYaVsK0nKQw+
         J2Tv53I5+uva0xXjCdV2nSH4qmv8LikUc/mciGfJwfNq1ddaGC2oIU5UaJ6WOAPXw9y4
         9uWh68UGHfRh9KsA3wzHt6x17xHUuoWpz86HyxsFfT3+EDbiB948GX5HljPAm+EG21K0
         0T901vgl+N/ta3HUy1iP5fBVhTX3Y247yjHDonP2fNU4FKJuwtYGqy7hw9UHHj7F4DY5
         umQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795010133; x=1795614933;
        h=content-transfer-encoding:content-type:in-reply-to:subject
         :autocrypt:from:content-language:references:cc:to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fzZ8p4GcrJgIWf6F5LBlcZh4WchWnffp6/lWOYHVfoE=;
        b=KhAWtjZzJxURgEaqaIWos3YTEhHOu+PhzzbLTF4EZfJ07E4Kp0k3r1rGDNPXQw2v9q
         Xo8Zlzfh3+GrCR5QyPqamWTiwQ1UMTKDLiY4a1Fz6exzHz/CRpuTnA5xMxXhaM01slUp
         dhrqKQ12gF587HNLzKSmKAIykR20pFtS3dFKmwQ/hmbpCpGyBAwYxQD4ECHiL3pAR5ji
         dJ9Bf9/mSwOGzH2OVu6E+fusHa8KV6jf8KvmyPOPcF4ToWTTT+2LXacVO51ZcF0hVJly
         rbL8gSnyW0gav31K8o5n4VnyFGOyLLAzcy77rcwq/1X8g9C/eRKFCBYOQPlV+VgU1ji6
         cwng==
X-Gm-Message-State: APuU4Z//CjJk8mCIz/F2fgyVvPSIQQ0nJ/rdw04oZfpTe6MEzTDtqaVW
	+oYeXZenRoIVdI3zWXm4aJJrCDF2aO8s7sPjb7spFRJ2Aqj8yeW8ndtJsgKdAhiQjDQ=
X-Gm-Gg: AYBFou2Q6hXqes5DtCAVZDmwExc6dTJyVP0qZ+Wpg1iK5gWeQDni1etpVYhasH/tEHJ
	H5hGR2dpV6pVKD49FliSr1snkYuHkdHChY0HitgZpjC6ZZqTnObMCjCCix3dz2AWfeWa4WD6/lK
	jI2e1VBpAIgdJH4S3NYvISGVj4vsYfkdSCecMSbZSLuI5hErC62MN2RJhvUoChkLfcwbBafsEFu
	FF3wdP9UdDuNl8SIToVmQjyFK/nSCBhV5CIhaF6lm8G6OsaxfQfzc2eO5KEi3CmjOE9Fk00oyGa
	au/dmxjhGlBU1ezDmDWad3fvsMziNt+EnLs8pL7GDoJGe7kEmg8dbrfkp9qOarGNpFUtsHMWtUh
	ztWgPTJUF9peYLTa4U0tIUkzh+olTO9Dc281QFveCa8MX0ZdzS1htPpPeZn3OsmylT4FsJc+VeT
	ReFlNxj47qwA5sRghC/fXfxWjI6rs6I0HiA5EYtmu5WZZVr80EohO4JQbOVzm+pz44lcxDuL74t
	7ATVafnO2jtkXyK4Z2o7zgyIzPT9Cr5XzUiXqV52HfNgejGlQn3pV6Adg/8/k2DKzrLVg6O5Bul
	ve7AAlqjPqSFMV7e7OlSd3667BvLHJNevB3AHl3n4A2h7rv/3AIIJ4UqI7Wmsv/H1t5L1KC/G23
	RWIFl+5fksCWthAPk+mSPnmOiNj74H3EF
X-Received: by 2002:a05:600c:800f:b0:4bb:5bf3:8ee9 with SMTP id 5b1f17b1804b1-4bb7da4ec63mr52026205e9.31.1795010132684;
        Wed, 18 Nov 2026 05:55:32 -0800 (PST)
Received: from [172.16.14.5] ([67.207.71.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2c3c93sm99049865e9.13.2026.11.18.05.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 05:55:32 -0800 (PST)
Message-ID: <2c791bd1-7f9c-43e1-8a76-f3bbeefee897@deepfinresearch.com>
Date: Wed, 18 Nov 2026 13:55:29 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>
Autocrypt: addr=cenk@deepfinresearch.com; keydata=
 xjMEar0rFhYJKwYBBAHaRw8BAQdAHz6z6MLA+mS1Fuz7sv4rdnByHh/NoO3hkH4hixSiOw/N
 JkNlbmsgWWlsbWF6IDxjZW5rQGRlZXBmaW5yZXNlYXJjaC5jb20+wrUEExYKAF0WIQTrPCT0
 JMi19/R1ti4EM3Wz2u4IvwUCar0rFhsUgAAAAAAEAA5tYW51MiwyLjUrMS4xMiwwLDMCGwMF
 CQPCZwAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQBDN1s9ruCL8FNgEAi48UZATA
 4fLQCEod98yy5j3o8AJ1FqI2atRtFZRuxP8BALjrpBK/eH606w5s82THH9hCWXmu9vhlMmUQ
 NiVUjIYKzjgEar0rFhIKKwYBBAGXVQEFAQEHQNXlOF5B8tyFRxW+4M9Ws0CGNVN//I4GaOEu
 Vqvl09ATAwEIB8KUBBgWCgA8FiEE6zwk9CTItff0dbYuBDN1s9ruCL8FAmq9KxYbFIAAAAAA
 BAAObWFudTIsMi41KzEuMTIsMCwzAhsMAAoJEAQzdbPa7gi/XN0A/3HYaeGJBCsWXe7xkZZl
 wDADkFGIqk6oSu7rvvRh2QPUAP9aEEF089q6fPA+dQdnEr12WX0Wh9+CItd9Yiz2WjmsCw==
Subject: Re: [PATCH 1/4] mm: flush stale TLB entries before installing a
 CoW'ed folio
In-Reply-To: <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4AD5C40008
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5esbipbziqas7wj8bisxas7kbdtnpre9
X-Rspam-User: 
X-HE-Tag: 1795010134-516424
X-HE-Meta: U2FsdGVkX18MFmKRieOISmUuBWdC9uKAA2+e8Wm0sMhiIbHNQc4MVfvTTErbkE5Ba3KJ/CNsSoebKr50Rb98+zB+jbm0A1jg06WQ70tkUqNoPSbD6FbZJzHKcK4WSFc4iByy8Xd8Uqp/iOdVxspfSi1VKLBZtXiQKnGKbx7pGuBwz/8myQPFyMT0cvb1Noi8nkWb8H5VOXwfP+2BS+BbU6+lzGvGuxp3ohUt7p+eJRqOZkJ1JtN/n/EY187/k8AHKjTCD1nvFjkT4pvEOR72ULMyBcwHXu1CQ7bdJrDWspzhjaGaYf0Z5HKbDpMfPd8twtpCM07SLSKNRByHVARZv3S5444pvoG8ISisST1YW2CdsrV7kMkXTcFtxboB+nVKS8CY4/LqvBFx0VWR2e+yfm9O+IRexADp8D4y1uR9P0eTF4BDDlE24dWNslAFQhOzKkATkukIx4gts3oQ/CwfF/jrqp68W5an1G3rvKx3NlSijjW4fctZVghZELgc2OAPwD1Ask7TRchXd5BxP3H67ozIeUXroDZwikR1CLQLbokO6FmsUR+n+d6MMb9NXoCKQS4PfTgt71FN955hro9hcGQh3TLOUIgKZx511USyjpjpCwKfkhOgdAeusc9E7zs2G9ZuZ8of9O4zZEsoNY7iC3CM5vpoLohFHUhOYXNY4+X3Hrj54E4zSNqYlXmq5mIpHQ4hX61Hvo9RHi14vp4ezYNuNKJLwrVoromsgoGvClmGXmZNCVcbNujPp/0BWlm5rtLderGRFjLtYmTuHnNRSB6Ta4xfiGDRFZppluoijncR44qX4XN2MAF2eeBvW27L5hGYNlRkyK34U5Ke8Q3KqkilBllCM/cvf8XegTiSB1UmHfPr9aXAXJTS4VHX3rIbXPPbYbYZj3AfNcuzZo+V+QJsVtyPKeZgF/CATBC1b4KNIuRx8M/Z5vI602vZyd6jK+EZ7bh/inTUVUDfpDl
 CoWuIQsl
 3AwPRUiFB1X2pl9+aQM8na4rsg4EgfAOrOis7uZ6ktvz7gJQYQctjbhxqDaJGkLv5rSA0iIfc4uePWeMfyij+9J1rjI8Qidhi3ubkBrdM+/jCtvrBlCWkFOBH32q+zb+ZBajIU5kpiTdnkTkV2F2hBqA00C/rv70bhKKZUzqB8KU6nOfKtjP9zg/IBUGK+emHmPJ+Bgk5eIeUHBxpBawvSw/LwIFgXfQRzMEuTPY++FAd5rTYndNKR8C+ZqEkFyR9LWXTjFGC+8AtuUl12NmpP9yn5rRQo4YUCN5kJW0E1BxQxSJcIgrUdRdeb2nPbjswqIcB2lfM0dL6o9meQ48SJe277SlVs1DGEatJARioqrn7bktI6QKh9UK1v9XUw5FH9crfYiKLlABPyKcXhLme0zHC9CbYM6FeakUELCuv9bKxuxx4IM18MNg9b/y7Um02NKfVReObgsIP7UNLCGQFONJm2J1u1wQCPghy9e6RhGKRjD5JdotjIdazCwETm3iieqImlBJsTp8ls9+QL/R5JVfNjYx8dbrMtIePbTMGAffNpxzWq+zMPy+wjqtHeW9cTtV6DE4BwQWELur3nr+7MxdI1sryPx4dWQOYHMA5OhDZt51wh7z65zwLz7l30HzzUoevTKqp9ITLCBAGiXwhDC0P0IE+fn4iOMjm3fA+d2f7vH5gFLo/JEkhDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tested-by: Cenk Yılmaz <cenk@deepfinresearch.com>

