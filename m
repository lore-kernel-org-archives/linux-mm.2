Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C37B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHbVXo2O
Received: by kanga.kvack.org (Postfix)
	id 891296B05B1; Wed, 11 Nov 2026 05:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867F26B05B2; Wed, 11 Nov 2026 05:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E8C6B05B3; Wed, 11 Nov 2026 05:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9876B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:22:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BE45140255
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:22:56 +0000 (UTC)
X-FDA: 85422449952.09.3F998FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C8B4A140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:22:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHbVXo2O;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xL48yn2OGhXARt11XybDpQ6QVcFFK2xgF3IOcOSuGFY=;
	b=yCH6f5ERbiK1gb3/ShZ9XJxXpFSaVxCFAH/XGvE5JrGFRsVg++9fK8v/yzuoca8H9tGYAr
	gR4e/47ax096LzWCq1fr/CDVmRy3oa2A441SJ68shSkW1ZzP9mYhHmXYlryyVmC8Yv5qxB
	mid3dw5KHEYIL6PT6wRyE0QTbHcLVEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392575;
	b=3zm6kp3ulzwdyYiGZbaGU8/gOdFyMcwv/e10oRaMASewLr4X497lrVHY6r+cf6se/qXOYa
	PSFtmLfBvC4oI2q74W9wqy65yQtodnbEbn5CgQSJV2e5tlR6zAcFD2HKGltJ4uDEKHIfMS
	LZcppRROZmNrIl+U1lTifRI80xjJAns=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHbVXo2O;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB2F840172;
	Wed, 11 Nov 2026 10:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E951F00A06;
	Wed, 11 Nov 2026 10:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794392573;
	bh=xL48yn2OGhXARt11XybDpQ6QVcFFK2xgF3IOcOSuGFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OHbVXo2O2RfSkpn2doyIKxnrGsXhG3R45Ni9WY6n1ISklH80KnOANB/JVgcGGcR2B
	 ef0h3EYh5dBbieP6ZDz+MsV5X0bJuaLVyPk68QEuXOgW2raVUwD6PyAYzV+URQNCJF
	 NuRdGbp1PNqskDcCXSAMIa+e9d6ZgOb4sIOG5PLJoFhwpHH92xWxm5KGl6Uoz3Bkr6
	 T/9rlBYXGWh0vw/OSJwU2Uyrxo16KHBAlbMmbpi5NRKQMCAizVql64LLWve1ro0HYN
	 PViOLAzvpl4LR3td4qobd+/CC2y9xZqNT+/0uii0NQTRtunL0WecccnTC7TRMpfkoX
	 nhTFaYBuzNHSA==
Message-ID: <96ab7886-2f8d-4bad-9e22-67c4d1163768@kernel.org>
Date: Wed, 11 Nov 2026 11:22:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, vmscan: make kswapd unreserve highatomic
 pageblocks
Content-Language: en-US
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f@kernel.org>
 <057dc7a4-cdf6-48dd-b326-49c92a936b9b@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <057dc7a4-cdf6-48dd-b326-49c92a936b9b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wfye9gak93kbagqaqdb338qa6jexgojh
X-Rspamd-Queue-Id: C8B4A140005
X-Rspam-User: 
X-HE-Tag: 1794392574-297597
X-HE-Meta: U2FsdGVkX1/T50q24xtb0yGpqfALJ738cFoEGl3tn+efd08dBoAkXv8AHd0CAoPei8iH7u6QpOG03XK2DzcHsB7KhSjXt+xGVIO6T9stsrGiomkE4uoDholcp21XZ4wdAGqmQwuB6M74QZYwyNzu/bPwHk0eWClYAUsFSxnIWDMbsCybNJyT/8NX9Dn99nnsag6nLil0LqddYHEro8md/jb3C98NomlZY6jSvYmKvTytYKisU4YkQkmtXvezlOIPS/xC/JjotePVQ7Me6TKfh5Ll4pOb+/YjIhXuENEtWaV6EUr+DW2U1egcH1VpadySFFOMjGQjULRLndllFspdygq6YJ26ir7yU1DcY+XpPjWmmXYWGm8Ykp6/CU0GhFkJQdBpjHLTaAhccHsqiqzvrdGTHbc4CnJ7vUOMHfErlvhNgeLSpmwlq4Yt7UIXWsh+FkUbvIP3eIU86OO1m1OfGvsI6c1CljBmd5EGxBgpYgJhfy4EOvzy+Ovgt9AC7XtJshIatnSm9IM/MvrNF16jeWZbmbwzgJIP+XoPlM80kVzzWo3wnzNGlRIi+GW37chV8Imdhm30pytkOD6N/wSaMjVIz7KAD5h9tTstqNceq7xXY0N7xbMmovQI8g9JHqLYkM1CmMS1/CNarOF3GebxkEJaWQpXpigyhrTfigLlbEVAXkblQW7MzAReZ67FxmUKip8ni7+7Z6ujNLPIoWsoUhmtxQTFc2wg43oCzmRRg3FitXwyJQHyAqcXV+Xvsrf1c4iLI9IUSPXkN8JruC7861MwBsdLHWnCKasci8q+9fQfaUfuSyJ3vQMkYPkd0mIK5vz6jEDZW1uFL19CpLfvMu0HkOWBcouS6ZCmn+pxx3EQX9b4TFkBtqg1c4Vsg6nxkR7x35mjOz3fkN9aX6YWjxDMpHOVBpc9dcaNDIISQynWrCcHQeBmhmPxdPy3O21PT11T2iWG0oVZnqQGpz0
 w4m1Oimb
 QWAYI34jETTX0JRaIE3nemLxvVfiHH0WovYnfC+hn5ouzfu4bDdwFUr4KhhuEaTdrj8WpfZ6xJGv7SWceW9ul/kWApdCrdSbA9y9R5UTpvaxbsz5Vtk7h/aKfxlIhnE8/UOR+KdZI144BrG4ffXVQp84rNhL2Xt1VPpIBccs2lYplf811CUUvnJL8QZwTnBmURj5rMBQ8iPmDr6zdsgSULG20LBqFC6R/T/wndtXLkH6IST+AkYOuTidFvzgcV1Ani8aUdRO9tGpus87+fDeohaFWyl5CwOp4pAys3HCnbA183QK9wML8V8KdwDpAmwQlpyI7AvQQ6tCtdxDJZ2ha2T27/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 14:25, Jose A. Perez de Azpillaga wrote:
> On 11/9/26 11:20 AM, Vlastimil Babka (SUSE) wrote:
> [snip]
> 
>> Hook this highatomic unreserve to the moment we exit the loop in
>> balance_pgdat() due to exhausting reclaim priority, which means pgdat
>> was not balanced and the last kswapd_shrink_node() attempt returned
>> false or failed to reclaim anything. Even if that last attempt made the
>> pgdat balanced, kswapd was struggling enough, so unreserving is far from
>> premature. This should be a more conservative variant of when direct
>> reclaim failure triggers the unreserving. Pass force as true to make
>> sure repeated failures fully unreserve everything. Also make sure we
>> don't count kswapd failures until then. Don't restart immediately as
>> the kswapd() loop will call balance_pgdat() again if the unreserve does
>> not lead to a balanced pgdat.
>> 
> 
> the lowest priority gating looks good to me.
> 
> however, sashiko found some concerns [1].

Yeah I saw, and I wonder why there was no email this time.
The inability to unreserve when there's no free highatomic pages to grab
onto is concerning on its own. Should be a pfn scanner probably.

> [1]:
> https://sashiko.dev/#/patchset/20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f%40kernel.org
> 


