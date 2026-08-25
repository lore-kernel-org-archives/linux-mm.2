Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A918C61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9866C6B008C; Tue, 25 Aug 2026 08:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937F26B00A0; Tue, 25 Aug 2026 08:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875576B00AB; Tue, 25 Aug 2026 08:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68C196B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:39:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0695F1C18C2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:39:26 +0000 (UTC)
X-FDA: 85139747532.22.42DD9A6
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04A9618000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:39:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bu+zn39Z;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jBoCvOZgu3TJX11/FJiGM1chFiNkdMB0eUrxy7gcA0=;
	b=t/j9F05UKb6I7aC/EWCNC8pf0R8Gkg5joabh0wkW4V3BZKVjd0Z5Q08+cEF2y3eEv4I2MW
	O+6IgEZCqhnfCxrtJO1Hg449hVdfKJr1OfqdDa9p79jTSRizE4JJF8175NZpHNFw1SYlIe
	9hOWbAJUVKq7iFoKTo1P64dhCkr+WOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661564;
	b=7sQe8mIUIdLC/zk7Wyubrtn4v54AopBOCY/UMCn/tpQf10QkQr6E/JtrQqDglWGBhHyUd2
	aEEAez501Q5O32TmzcCaiSkLltejTzLD1pOOeOyv94RiUPQzI4+cfgCydCLsjpVU+pSASd
	ylcvEZP+ri6ub4ScMzbRS6tRBvt/I/U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bu+zn39Z;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Pzwlf//Bvy46LelD2lYa9+LILpMnz7M9KVbRyTt1z78=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787661562; v=1; x=1788266362;
 b=bu+zn39ZAmUhPMP6eQi4M856XzugIccqrAw1XhWUv1Ex+I7DIaQW4JgQm86+SwB/WwVZ3wrz
 jWMIt81tTErULxqy1vGgVJi8WxZSdgPl/36h5mTn+QXC76zisRtNRPyQ0xt5g5XcjQ32trZcluF
 Xe3384+5ftrB4yyN241LnVRo=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id a43f18b9a5ea956e;
	Tue, 25 Aug 2026 12:39:12 +0000
X-Mizu-Trace-ID: a43f18b9a5ea956e
X-Migadu-Flow: FLOW_OUT
Message-ID: <59e0f96f-6405-4e7c-9561-456f18a658b8@linux.dev>
Date: Tue, 25 Aug 2026 20:38:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-9-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-9-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: iqmqch6qyz6g7kqggipcibhds9emsb8z
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04A9618000E
X-HE-Tag: 1787661563-911251
X-HE-Meta: U2FsdGVkX19u007O43f44q6sIsDWrIocl6y/CB+NJL8i3fg3qnZgBzYH7ngTAoDLB/Zl2yL2kyLYEPGAbOh2nYoMg8a5PaFKWOCy10lqWW222yNlQbaEtM5btC0mvU/L0CZqLnohP+fwWdXee6hfd0c5r9tXC6VHo1KvDSfOSEtj3ag0Tn80yY5hH/tyXChWcTTlcYwFAVq3TD6Xr7uluEZo0vGymFtyIEZe0sWzFS5eVfx5EQLjHDwYNaV+V17FAAIiuiYL4q2Ev5Tuj2s2+xIIf4YPNDc2oU5hFEDF+fsMxbyv1HGUVo2RQu4i2pn7kCDuVRE6aM9hpBZqwJlyxuyKqSyCzmCzjW4jaMb7/mM2QKxIXgf7AAS9SW6JaDAvZeN5PD0a1FV2/ScqrI655g0cyli+nS0XXPfQO6P4rlbcx8oBMm3bARU8DoUi2KuVG+bYgv6Oc0Va7IguHTdRMA55yVSmpLy/AI513NjoKKgO1YcM5Q1xkxKC+dz4JX2ZCedESU3LEjCpk0rJKoKj3QP19hFWjG36EGiCkmRAgzvCLamKuJNY2Q88itMu7Bn1/tz3LriwRvKl9z50kPhcJrh/yVcQXsM3W4QDi/sJcs6nyaraBWCFoLJdYnDs0patkoyVQPATwkE/K94QKy4dUO5dUOcMGSCrqbalZ0x2qyozpxOctOvv762ROd+p9MAE61u2yL259Bh1OjOjPZu4NZh3ukaAbK8ibNUYojrVgD6Rml2l48uG/fTarIZhY+KnSwPJASQj6qX3SxJVmPv3tnjJ4x0EcVOq+CGgqpeuuF9GBhsgKXgtzE6Mb0LRe2+23k6d3cGfX18T7QyGtAFpkFxnuFoTYSZU2C0mXMLCXgxHHFS69ZuUCIInMCZvTWQUKNPA0PS7wd44tR4DaWG1ysmFi4+RApgBGTYxXvY3X5i3j5qgFp9ZY1DneeldYWIDNo5cyCzyYWCP5Ni5NIJ
 mYfQaS0N
 JHnUolqzO5Sl/3ppLvg+1PznVud3LLYTRWL38IwRLJuGPSpxDLNF/WdqC4J8qMRTsueMb43j1nmIDJu5Rck2Ec27SHUKDXGfW2gd81pDvDgHlWnNcT536bWdNPoDXEdIqToyA5mI1zStS2LUCggUhW7o0prqqG4TCtHt22BzC88pjBnsnRQdYCnKdSFEhsW/PqcGrZw7Gc+OZ610s56EepoqYtWAxhJyF+wecZJ3aPOPUt4vIrAPxNZW2J2e/Nx9l8K5Jg8PYE5yM3E0Yp/2zTqfzE9r+VUJDse+ZAkvPFPloL7hn0PzZRKNC9fGGn5O0KIH60+r1gwZdYxtY61Jq+2guQFwnb8KMrApZlknWysVQ+XCHlonyWaAOhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
> 
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of relying
> on HugeTLB-specific handling.
> 
> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
> based on section metadata, and prepares for sharing the same mechanism
> across different users of vmemmap optimization, including HugeTLB and
> DAX.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


