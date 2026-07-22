Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C2FC4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26056B00A0; Tue, 21 Jul 2026 20:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD376B00AE; Tue, 21 Jul 2026 20:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECF16B00AF; Tue, 21 Jul 2026 20:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7731F6B00A0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:55:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CA4A4021F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:55:57 +0000 (UTC)
X-FDA: 85014595554.22.03BEEFF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id D60BC140005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:55:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FuAAY/yo";
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784681755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRZCQburw7HgkreYBNUaHDCQ/ve0PWnL6l7wpHhXWFE=;
	b=M8CTC5ePXdZRGlB9UDiGvek87Ow0z3aSKg815N1i4Yw0pxB2jz9kXAPvON9liOcppPJhrr
	xaZRoBKxRoqJCj484ZW1y6x4Wu402WXG/yWuRwfbKfIUSsCW3b/pig5dy5yxoPi3/G9tma
	FmB/61utxXI+jbkKRMsBB2GFXusOt14=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784681755;
	b=dKJuasheqEsveMRh3IeW8WD2/Lj0Xk7tvHwfPm2vHfTgsJ5CC7jJhWUqHpRoz5DqA45dWl
	+q/pFNLCC+h26MqjRbdqjXfGLjqzUD5Xb1eH/GhSN4HCNnphSoTHmgfF0rNvJUs8BvuK3b
	9IbcCKhFrLmaJhFXRf/t5/5/KDPOgn0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FuAAY/yo";
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1d596a2a-f930-449a-b8e8-4349d95578e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784681752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DRZCQburw7HgkreYBNUaHDCQ/ve0PWnL6l7wpHhXWFE=;
	b=FuAAY/yoInt8FpHJSquoeDZ9NamAcZJ9YBXv6ftCfMNzSK5KJCEE0BLqmx4Jy9HyzKoqDQ
	EzjpoKhahJcykPC1KM/nyCjngSwOjK3aTAqoivUbXjWPgHIRdY3S15bZ6eZ/wILM3dM3nt
	fPmFob1DXt3NO+fHZQNKe7ncV6sb9TU=
Date: Wed, 22 Jul 2026 08:55:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Omar Sandoval <osandov@osandov.com>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Stephen Brennan <stephen.s.brennan@oracle.com>, SeongJae Park <sj@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
 <1784596208654455.18988.seg@mailgw.kylinos.cn>
 <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
 <e72f54ee-2ab6-462c-a9b4-4e05c3e85266@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <e72f54ee-2ab6-462c-a9b4-4e05c3e85266@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D60BC140005
X-Stat-Signature: mgfp4yygyccqthznkmsaxj9dgizby6wc
X-Rspam-User: 
X-HE-Tag: 1784681754-479861
X-HE-Meta: U2FsdGVkX18b7K15Y9Yy7mciCTt6FoDtbHeNuhp2Uvm4MxBSUruTAzkqadz5PplaIcoGGbYjgLVFAPxry7vritIQPxIgTpFeq1ZyqmTTzQkTYkw1Wg9g5ReOdMZ1TpG8lMvnrN4I3PeL3ZdUQos1XDDXc1BgYZ/h9cBfNAAlM7KTds48uRa4K1guwY9ftmr7I/LEe0erigNCb3mBgmskYoEQMD3u11BxHqxUkeZ/AIexp/vvQ2eSUZqKJG4J/EfrIXJ0f1r90iZxAbZFx98bViEQw8CSNi8/Q+wLmoW7BjW8WFo7YfbaZUepzh1l6qOyjjQpPI3L/n+9r1woRLi8sSSfgDvmYN53Japoo3iMfYw2r7j6uepeBK8cl4HDHw1y5TiSsGaCUa+r4/ioTy0T33MKUBSASA+0ISpATDTmWiW5fXNDYDTFVZwpnjhmKDWqA0uh/xoHLT9Wov903mKz4eAwpWkFqYRse76anLpXBeyRtC5H0buvaZv0rwf4u1EylU9hhwEYIDqcQ7AyzzNFEMj/A28g7Z8v5mPnftx6G5rpdv4BA8RxRILM93KwNGDTroGv7lJ/YKS2P20BkyJaEYMNpEW4dp5t8Rm0nWOYSRVhjmaWk8/8G/P1kshR9GjpSda4dDxJWgDCQZl/xVAfTBzxMoj4Zq11m5MIRhlu3/12pjWVvbDQNC6a33S6zel/i1nBfiZOfdcqkYySNrpEBooIO9IcJcscTccEoqJWe4gc/uS+OE+BvBLzkd7ZQrs1jp31YdAsgF/eToGwxS623St+bCCoWA1xvkTob9ee1zO5hTW/l9LvVkM58XAyfhsiYQpRxgojib6hWs1rzwhZF36Y9TDe6k/4cEi91w1MTlLfxGoXscVy+FW4Zs5blVcKCsVmUV1P0P4VrjLHKtf4OLruHSU4z21NTYic3WPrmTKeTl/75o5xgjOoK5UtV/QsYGkag31sHhL6vhfHTsc
 0cupmryK
 h7EgEcHP8liPAgQeVWDizH5zQ9YRjNPbdOjEeZ1Nkaqgkq7ZKrIJxsAu6juMklPLYro/ubt4CUkXGdbWHEp1o8zFF7NuUkbjPIJsa9kfU0oBz8pRDK/qBC1csyXfLgfaqZKunAKCs4fyD8UX3EvwaSv4K8nabjpYrqJCSF73duKZTXRr0fTG/RHi2P6+XPqVCUjbPTZljSJ3uL6p6hl/aTHhrJwLELeD5r4Pg7kneFFF5lh1HNXcTNw9eMed32S1lYuk336SCx48YZlGuKlbKFRIzfEPHjlSqTw1n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/21 21:20, Vlastimil Babka (SUSE) 写道:
> On 7/21/26 04:00, Ye Liu wrote:
>>
>> 在 2026/7/21 03:58, Omar Sandoval 写道:
>>> On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
>>>> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
>>> FWIW, if these scripts were in the drgn repo with test cases, these
>>> breakages would be caught by our CI and someone (usually me) would fix
>>> them up promptly :)
>>
>> When I first used the drgn tool, I noticed that some scripts were directly      
>> merged into the kernel repository, so I merged show_page_info.py into the kernel
>> repository as well. Later, I found that merging into the drgn repository was    
>> also a good option, so I merged it into the drgn repository as well,            
>> and maintain it there. Therefore, I currently use show_page_info.py regularly   
>> and update it promptly if I find any issues.                                    
> 
> Seems we could remove the in-kernel version then? Besides better regression
> testing, I'd assume the scripts in drgn repository can also handle ranges of
> kernel versions and not the single one as of the given kernel commit (and
> often not really due to undiscovered breakages) which IMHO is much for
> useful for using these scripts and tools.
> 
There are many drgn-based tools in the kernel repository. Should they all be removed?   
Or should existing scripts be retained? Should new drgn scripts not be merged           
into the kernel repository in the future, but instead directly merged into the          
drgn repository? I think Omar Sandoval would be very willing to accept new drgn scripts.


-- 
Thanks,
Ye Liu


