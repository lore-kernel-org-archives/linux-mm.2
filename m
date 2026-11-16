Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FA6606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxFx48EV
Received: by kanga.kvack.org (Postfix)
	id DEAF76B05CE; Mon, 16 Nov 2026 06:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2336B05CF; Mon, 16 Nov 2026 06:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8646B05D7; Mon, 16 Nov 2026 06:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1996B05CE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:38:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 242B41A091B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:38:35 +0000 (UTC)
X-FDA: 85440784590.04.4BF1453
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51290C0010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:38:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxFx48EV;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794829113;
	b=K6j0h+c4Q0rEdAudG0ep2fzDB2biCcZxQwrg4qfGhDdbIIXxNndsXolPu4WMIour3Is78g
	Tlw8uWEsU2vOkbwAymKYkGb8Lyv3zSCVu0yC28OPmdsFRK9oBdEwFkqDkxMOdDxzCFyaxA
	aas7rw7RExYBZmbe0+KOGKG4YXlbVcs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxFx48EV;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794829113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/Iy4monEOhPPa4BHMH0yk9mcJQuZ2pyCYhq4+fXjbA=;
	b=UiY3FeG9m+4hk20dscjoYa2kYFT0ElslgP9jr1cZLMzttQAMy1GJ3UyX68EZ1ludOLmphG
	n2QoHIPohCd8rGVfJJ6U4i7m8abGL0QOw6CjOIe/INcBZ2/x/otbq6mynw53ppG7qAh85v
	rYpVTRnoegJtIe3g/wj2ALvFOBdflBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3860460546;
	Mon, 16 Nov 2026 11:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B5A1F000C5;
	Mon, 16 Nov 2026 11:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794829111;
	bh=c/Iy4monEOhPPa4BHMH0yk9mcJQuZ2pyCYhq4+fXjbA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HxFx48EVvyTnO4tgOweDAjo2/AaovXKiGE9s2z8T1PObcZ+f8JpJOdpYIV5FkcB1/
	 ZAhSd3arULFvkzLoKSG1ig+ztLEXyrG9Cw81cmlDEzYYFcKKFYYXOf9x+/QD4Q65wr
	 gibruL2Qc2qrOMDizz+iv3cyWZSxxSnNy5aWlpYyB8TX7Gq4tnxZ5vzXpKi+N67OEu
	 j+RoVsmT9Q2DQ8+39NQd+s/druE2ZSDw5Z4wd6dlOp6jLhZaHS2JZpHSopq0P5Ql/L
	 Eg0F4bVkfafp4dTJQAp0qIciNUTvwR6e3QLdrUCtkXMqh/CRD3U30LvQjEDN6EZvTB
	 2PH/EZKhTsY8A==
Message-ID: <18f06e66-5a6a-472d-b6a6-dc12ddadff3f@kernel.org>
Date: Mon, 16 Nov 2026 12:38:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: vmscan: tell direct reclaim the allocation is
 ALLOC_NOFRAGMENT
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-4-kas@kernel.org>
 <e16c46e8-d69d-450f-bf98-6f14755cdae5@kernel.org>
 <avrk2Vn3q8FUI1oZ@shutemov.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avrk2Vn3q8FUI1oZ@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t89yhwy886oqa5rkj7uhmwbces33xpbf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51290C0010
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794829113-70326
X-HE-Meta: U2FsdGVkX1+eB/Y/XJr51kAX1bGFTY2iI9JS4LjHbjnuH4dMu+mvRpOxxRdl+B6JOoagTs7kW+kiWXAaPxyH+NTr1VBQJZZClyuXxI2L1esE7+BZ86KjAJ5cxnddHKJbRqaRHuh2YKIOp0NNwU2gCqSgFXi3tnlUhiCA/onOYMqxsoQNdMNPnHVvbsIasBqUJDLleyqphwFHqre8RO2o5Xcd68rNpsiQsP7w2ucomfwekMusmacrwZT7Zhd0BM6IfWzEkOKiTbwACesbfI4bRnhndGkeg0JQ0SN2q39E5OrVNBBe95NyVp5v68A3hpvlr/noFEvec8kPT8gR2qBl6cctiPjBv6AEbrx2VfZ49z4bPBodVso7I91Sj52RaBD5rGryxG+7kt6GFVx//8r920WFxMNqa07hWHQilm9sMuunqh79DM3gob6NetQ5WuUDXdjgAovrUl+jr+ORr6sq6b0naz4jn1TrP8xdLL5KsRkczt4GIrc2KtNkWEQ0JbGPlboeEdLaOFA2bX+dYipdzFSwEojIo6fqNrpp2T83a/ft7jp6ppf/zqCJSU9UOgNmsd+hFDCJ2ilTCy/rLqD2hvV3BTVhTIDpEw6/1ujYiJAuwhfrnGpS8/ThER7ClwdIsPE/cCpQ01d4cp4NY187xCNinTldWZ3UjRSvalGsWY1uY3WMIwr0TTHhdKx7o7EAZ76vGdwG7B5DMRVgeDeUk1Ct36OgPpPsl7NsaeZYeKxPSynePyfs76O3Zw0RH0iTw/AxkJUT1X39lSCWzib20yO8w2IDDUYp1Bg4gCQSU1em9SntARwW2+2Yei2Y1qhtFHME1WpadFlztpF/eqbdRtxZo0rWg8APC89VW2QWrQ4tuIEUDKoPR3xNlXjdzSGRmK0Q3Ms9W6qeM8yw+mFJ9J4Z7Ns8oPbp6kaNFkR+ce3P9BUyeDpZLwOgLm6P96G03EK6CgcTwx5r+3mWEWo
 FzOIYIyK
 lrT4WFNi7ljcoobkXJitvTugRYpucR7PBJWoRcvwUinn/ufQRIHPZCOnw5hRhTJsQKkYpKk6XXbLtVLN5/Q/RznYe2p5qHkmhAleGVfzN4Q/sLPsXd7VUAUa0phwnPrxfbaxSxjAGkwTk8XKgkbxqq4JhVVOPK6PTYwoYdyb4y0xcWYNc5oNHkD4x8+Crs5AqQXya4BCA0cb6dtC7I7StIqXaSJSSmlvZIDo7YL6rIQFbglEfIa09+6w1YcnZmGGNYoz+fgKavPYJfEwQmmlV6SdUqGbRK6XoFn8JMEHxR86TMdGRsbJ5RrP5qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 12:18, Kiryl Shutsemau (Meta) wrote:
> On Fri, Nov 13, 2026 at 06:58:05PM +0100, Vlastimil Babka (SUSE) wrote:
>> I'd perhaps pass whole alloc_flags to try_to_free_pages(), but other than
>> that LGTM.
> 
> Passing alloc_flags down is easy. The question is what reclaim does with
> them.
> 
> I can keep using only ALLOC_NOFRAGMENT from them, as the nofragment bit
> in struct scan_control.
> 
> Do you want anything beyond this?

Dunno if anything else makes sense to use in that context. Maybe not now,
but in the future it might.



