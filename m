Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E883C1099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430C66B011C; Fri, 20 Mar 2026 15:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E16F6B011D; Fri, 20 Mar 2026 15:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D01E6B011F; Fri, 20 Mar 2026 15:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A60F6B011C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:00:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5672813A451
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:00:05 +0000 (UTC)
X-FDA: 84567356370.03.8FA3009
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7952B4000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:00:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6noSgyn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmen2rnquLyQqt0IxEKyPJBr6tVm4YkLEBFvGl63Rv8=;
	b=bn4gstjMB8lnwNtQ4eNYof4HfGO+FFGh84CmvB9Id/MJzlDe+sCj8YU/pUIyKTEDloNKYp
	p8Ran5ZMmRh7mIpaHARbPp5qW796GCtF2Ts1rxVatesireRqbrvbFPPMgydnD9AXy3tukt
	Pp3UkV0BOJRP6KX2Jchr01Sk3R8fyXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6noSgyn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033203; a=rsa-sha256;
	cv=none;
	b=6b18b6TXYNI7J/4IVK1/sEEovrYBapG1ieZBxYxloY2f5Y1iD32IQDmhCsWSFha9rvyqYS
	El7klMyS6NYAnUig8HzEDjdYph7ZsnvoZdNWmsfkBi3lR/ArwG101qd3N3iWA2Le9YV8cJ
	Q2DW7rkEqFFPlyGDdPWpcS+ahSXd6wQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84EBD43A0B;
	Fri, 20 Mar 2026 19:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D6AC4CEF7;
	Fri, 20 Mar 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033202;
	bh=uxjjHqGB/9RLq0brKZBrx/Blf7F9pfvaOhGzXURab98=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U6noSgyn1uU9HRmh9SUcesG5bhk78ZZSeQvCUVI02fk4o690H+jjA/Q+JF14S57mT
	 eMHvSkw9XBDJjJMY75DbYhtsSLbi805ESbFsOM6JqELUgTPeIpHwh9Sp50jxy5qhWf
	 A73jw6R86xbOD+kK540CETYywtFK1IvGyPQ8GvilUXiST4X6qkw3icdX+dpDfo9YLS
	 8B10/trsgncfLoUk057WHIu80s52aN7NTdpFsV3dBd0eORO7FPrS0Q9i59j+Ivas7S
	 /SntZLsH12cODAEAZxu1QkmAZ17E48g7HDthJcSLs7bIQHg1mFIqjeF11PsXwgF3b2
	 rprsq8hy1SC1Q==
Message-ID: <7fba6344-710c-426c-a7eb-8e71fdc5cd51@kernel.org>
Date: Fri, 20 Mar 2026 19:59:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/14] mm: prepare to move subsection_map_init() to
 mm/sparse-vmemmap.c
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-11-david@kernel.org>
 <cb710be1-5fec-409a-a017-c794ecad0382@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cb710be1-5fec-409a-a017-c794ecad0382@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7952B4000D
X-Stat-Signature: zrtwy6mawsipu55wnqdusy9kpi9ewhux
X-Rspam-User: 
X-HE-Tag: 1774033203-554312
X-HE-Meta: U2FsdGVkX1/QRNMqwmtBAeDrcYCaY7oAyZwyK5Dmtaphtfeox7YUY5qkDjQj8+uwFUI4U6M+B44tKy4Yl0uT+EgmKH235flXKxO4ictiILvo0E4WOs/blLRZI+vDWu7sH4cw52ArmZDuxw5V1PtbofI8NuotG4CW/TipPKmN/4ri0/7qciUjCldrWRptVbRXDSH5xLKcX/PdQgeExfMMz0lExctl5mxuu+BzzLQOdpVvRN6Eg6jJOWk1R0LVKEogsszJKpHU0D9dtqAdUq/ziHz1105KfpntGjvKMTq5w4ixhxo/m474p/xB+Sat/0Kepfnjb1NPrzTXQTXDWO7AmHAm53eRlHG3MMukshwCWZHo+QMVLqBiCKbPuZE/Ee5rXWcUGWIllKi8xbJhWQ2YQHu0RO2LFQKvIkiGBZd8VOV+7yERonQNLCw8ouQNZkmiBSlJDMeNZ7yt09rIeA6qKLx2J/qJxVGfixSj0x/Bb6U1MI2ePuzYy1C19JllRJvpFsHaTq6bD07zSRSYRGquCGBHUNuwFa0DmxTkIWxAoxHIbEizzQaPZZ8jrB7/K/PMjxH9PvwBChlhyiwJEetgxSVoBTJ4vkCi+9MbWrX3Mnm5wXGPPPl60zxvsJwAD3TwVTMUJKWkuZifGg0HU406oY3cUVWybS2kkh/lmvWppAdtuaMx0zt9AcEklwzCaTx1T9k2dRfhRLDfuiA9mdvygthE6gOK7ZE/kKsOiPROpxFhKf+VR1tqb6xUfie4QOpQ5ABKkqP8CEwyPE/hlm/TBTBBLQVg0oqZFOnscPnU3Q4om8faKL9NVDxQ4VSBeuPPdJeqXebDCgWF00KnqGd+scXLzbCTZnw1BtkhWsuz+HPZNt6MGty/DAt2eTxENN7g1mH8mgSG3l4rWmX1h5fwvh7yUURoP2MgHBCt8tsxi4ZOnexqmcy/ZprcbhKLeZD1YKbzxIuScXDzjDGDwLE
 fOY6+byX
 ZD7XMmIMRIoq5BgRHzIe39xZyLD9dlTlQO/7WMBLayNFhZyhg0GFH3QF/6DLS4n2Xw6yymTsMx6zN29wr2+oUa7PZVeeJ+RHi6toja0JenmqMwe9JQ+kmxgDQWB55W7ICz+hxSOst048TlWmQ2D5CpA/M41I4HHtNQRBNhx3ob27Iw+OjyKcH+FxcKKmel1Pq0Y2P7oHSuHJU4bvOh7d6hI3oIK2AGXb8ZnrpdKv2UJhjHorGBzUTcbT0E6M8y7JhYGTBmOE1CEqyTByAqyH1C0dAPcrWtjCdhU72Ns23zev8GQtcxVn8KcP1AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 20:51, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 17, 2026 at 05:56:48PM +0100, David Hildenbrand (Arm) wrote:
>> We want to move subsection_map_init() to mm/sparse-vmemmap.c.
>>
>> To prepare for getting rid of subsection_map_init() in mm/sparse.c
>> completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.
>>
>> While at it, move the declaration to internal.h and rename it to
>> "sparse_init_subsection_map()".
> 
> Why not init_sparse_subsection_map()??
> Or sparse_init_map_subsection()????
> Or <all other permutations>
> 
> Joking that's fine ;)

To match sparse_init() of course :)

-- 
Cheers,

David

