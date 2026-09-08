Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A0BC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A86E6B008A; Tue,  8 Sep 2026 12:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A226B008C; Tue,  8 Sep 2026 12:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B316B0098; Tue,  8 Sep 2026 12:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C42A06B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:31:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58FF91606AF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:31:03 +0000 (UTC)
X-FDA: 85191134406.18.503A246
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68B1BC0013
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:31:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJhwsDAz;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788885061;
	b=4ZmfgK1rvtyVvrttG6kpqjZ1MPFT/L/OSsM0/FeBhpywJg/fcJXkhSU18z5XhHbj+ha1ku
	e5xXx/riUG1t1/hAFo8cJLOUz7dmXdeB2D65V2idXt2PdQ5GSZ7EoiRI5d39ofhK3kExx8
	+uaRggUHvHmsgbQKkYmBi2fShDTZHjc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJhwsDAz;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788885061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbREINwiHzdfOIDyvzXmpqXBcn2ufYLyhPRpYbuszSY=;
	b=ogBVFQL1O6Ouj+R6gTY926IvCMgvcHF+d1WPSeJUV4qDqR/V5h1KMPF4lJ8XMnUuiNeYdX
	SPKxylma9plV7N1D4tzxane0mDV0cQ/7UBrdJgDb5s1mMyQcF+bQVUCFizCNWO6oNHf5lC
	04+M4+TD4uFa0p8OkoStLq9BmeDfKtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9587E436F3;
	Tue,  8 Sep 2026 16:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687791F00A3A;
	Tue,  8 Sep 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788885060;
	bh=PbREINwiHzdfOIDyvzXmpqXBcn2ufYLyhPRpYbuszSY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JJhwsDAzdDYYBuw+OjApzid/DL+uKEvAJ2ThGvEQEp2/vT/ZgMLMANci4KhIZVs+q
	 KJIDDQQEyY89H+5OdaSGpu84eRh3LwQimAoVYTdEGIr2HH6/9L/SixMgZ/eRkkp52m
	 HbFatySDrHgffwcdSMmR1TKgUfv7D8u8QNU9vBBvQDD5ag/tdudXWiBGWJIgqhyP20
	 DUX/YejlKToKQSDWX24HIZrv5PvbQhTnV/ykAxojd5wB18HHVIGHuG5DUbmadoVHmP
	 tLQYD8brxV8cRvpS+E2sUT9aaSJuO4XG6dBrT5eWlTQggVrvOdfVg8KQSmvc6cdwZ6
	 xhu0OCpOAfQuQ==
Message-ID: <da0f5ac1-c9a6-40d4-b67d-3c35fab0f428@kernel.org>
Date: Tue, 8 Sep 2026 18:30:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/25] mm/fbatch: temporarily disable lazyfree and
 mlock+munlock batching
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <9593975e-8732-999a-73d1-37fd332eb840@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <9593975e-8732-999a-73d1-37fd332eb840@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68B1BC0013
X-Stat-Signature: q1ruzbmz3413uicfoc3t98m937bm45ax
X-HE-Tag: 1788885061-518679
X-HE-Meta: U2FsdGVkX1+Zzj0s+zHNznF2lxKeEAzVGMi39W7R094OMZMnhEXeW02smTUfp7+WET8tw7BMk6CiEL1CH6DkLsbQ1th5H2rwrOnPppTg1sTC+lmSBNp6q5AIvI7br0yxsErYuCmbFmgRIZbVUsMuyMxg0qHayLyKIseDZXc/oFNDT+nW8Y4AWRAGyn0ibnEufhXxmjUoKVFcZh/dbTdNIr2TKsqBEP+MGAJ5ISQyExqY6/tvVQFLMb8BVI4oMgKJ2Jo+HrJgF2tbxmqqY4JmKr0OBZwppQSQ7BQlPlu8KOFp+RZVaB+MNzWO8muOCEuuQLf/jBaAEAeXf8yMM4l3fPLELpSz/TtjgA8OPZRel7KnzrDXUe/+QwxMNTdCxFj9PxcyiB4jNQBKs9jEvl3Gazw5eBaZ1dyOk7ZkuauXJPUpZlICjOOou7vzf1xV9HqgPjMV4P8Bf4CDOIdgevAmogJDBrQS5Qx0SIZhdmvgqrGHTJEkXzKkeHaetrj7qwcqeFzHe1ybNFFeN9o/E1cMWQFJIS3qhKShASppcdxoG/nEUbkJgkP44Fz3Piqgh3f1/cnF0ZD6XRQiTtYxOsB8Q4unb0DD+MBgAu/vzBEainzlKnFlJutzUwQoJ2qhohXNdpoT1bchxfINW5TKFF3l6nxxEa2BbW+XA4iX2I/SF9pVXxCDa+vqmw2KawA35ZHnJVzY06B/uC9/ob9Cz8G0d14p3iNYNcNqlla9Dl3hZjxYYB6ApgMQoFK8W/B/FxI7ZsZ5wT43Dns8vTF7k9nTTYrAyzCxEFqKahmS5U4DeOSd4gSiTZ5ab5Z73q+DRct+PU2l9Atu58ArfS6BVr9xyLN7FFgunN5gNtRt+GqQseQhgrk+L0PNd9oIV8a+d72H5aJ0nRGxd4ojCRBWolITC+Vs04aUfDCh8oYCZ4IRlG2HlMBFxa2UCIdNUp9ITz6JlhQ0z1EfqeRQyKuj/2C
 fYQ63M6Q
 K29isXjtqsBAXcHbXTdNRi17fQPQdRiK9WqowWNH2sTYc+i9BvPJd72uScOuF6lhocwjt53W7gjw5uLPZzXozOCCC/CZJZDAgU2TMWkivDHVFNDhZRbJtEyHHhUj1I5sdEWJuNcY9aZuMB89qBB8haFpPA8yvR+FddE4dYfzKJNFWCgTizChbBa0iHw0qRqzpSfWuXefvhcFlbryhDOPKhHLHCOr9vWbQIREEYvrIEjGskHoi6nSJSSSNQP4HFzjAZxR54EW9HFXoLc9PDstf1NXUPL8xWQ6kcN6IbUWjFxPOUwJZrCWGiWDZlmgfJa8dvdWqmkwWKlu+LUX/GI7byGfwicmb4+aUlQd4dVRC9nfOuhTUWBzmVHh7NRrtTFngQF39
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 15:58, Hugh Dickins wrote:
> It will not matter if we occasionally get activation or deactivation
> wrong; but a mistaken lazyfree (MADV_FREE) would likely cause dataloss.
> So disable its batching while reworking the per-cpu fbatch handling,
> then re-enable it with more thought afterwards.
> 
> Similarly disable mlock+munlock batching temporarily: they will need
> some redesign before re-enabling. Just insert one disabling line for
> now, leaving the rest of the code as it was, for consideration later.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


