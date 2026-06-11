Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2C8CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B721C6B008C; Thu, 11 Jun 2026 05:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22A86B0092; Thu, 11 Jun 2026 05:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A118B6B0093; Thu, 11 Jun 2026 05:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C76F6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:24:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AED840590
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:24:03 +0000 (UTC)
X-FDA: 84867095166.22.76E7B3C
Received: from outbound.st.icloud.com (p-east2-cluster4-host3-snip4-7.eps.apple.com [57.103.78.138])
	by imf03.hostedemail.com (Postfix) with ESMTP id 686F520003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:24:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=BLK+9v4l;
	spf=pass (imf03.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.78.138 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781169841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yruy+uDSwynGDVg5p2NykKBJLXswuax2VIEq8rPzrwE=;
	b=CJG7DSMklb/ANDZ9B63I9ha9/TxkXh+kBtWXe//KdQpIQDm8MiWTE0U6yys2lgzPCMC3Dr
	d6rD0uwXaX3OKYFXiW1q6YTLb1TU+4r3uRx9dkh3Ncn6O6DlVzLd4Oib/DdBy25Q4YDmdB
	KHA17LfA+sdfdYOxfi0RtCmEIiLHtFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=BLK+9v4l;
	spf=pass (imf03.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.78.138 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781169841;
	b=m1plB+q8jkt7jd4kGEZLr2MRAGdzR643encJUTmcr1v3im4rXJuYimhto8KdbPW4J96olX
	YvAjlzCOcwvt8k9yqnzky/ndekw9zIVJ7L5r+M9THMQLs/bGvy3Kbc2h5eBAKkqG5E4vLz
	crx4VE2h03NerSTZV7stgPcjsSpG9v8=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-4 (Postfix) with ESMTPS id 73ED4180026B;
	Thu, 11 Jun 2026 09:23:56 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1LHVwEWRxBDUkdXwdLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWh0aG1k/UiEeLkADcDZeOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1781169840; x=1783761840; bh=Yruy+uDSwynGDVg5p2NykKBJLXswuax2VIEq8rPzrwE=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=BLK+9v4lXZLgJl0JsJ6MpHx39olx+zw4FQL/tmQNPy2jRLxxpQ4DuspOXV2kYzWM7Y494lfNEytXzx0fi0lZjtRArjT/8Ks1QlKUcb0Q7r8kxr3Eo4x1DQAaNfw7mAxBAXfOOEQjCby5KNKROFXhMtJDesvxMVFNiaJzTWxBuZM+07mCu8lMjF2Ngo1a0vRwuuOZCqVgsXnZbVVVKGMpWllBPfbi2BLsx5+QwOhZQICaDu6nWGJxx5Mus+1v9rQcqdvXOMQnRBm7bEm3Y6934kuzAu9IFOxbNp/LQGPihAvrXlq2hQeFIOC682wm9BefHKeKb3MyRzFCyYuWWLwiOg==
Received: from localhost (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-4 (Postfix) with ESMTPSA id 351E3180024A;
	Thu, 11 Jun 2026 09:23:55 +0000 (UTC)
Date: Thu, 11 Jun 2026 17:23:50 +0800
From: Luka Bai <lukafocus@icloud.com>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
	Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
Message-ID: <aip-pkOkY-CwhBFg@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
 <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
 <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
 <aiooiNyND2Q96b4j@LUKABAI-MC1>
 <bdce3c32-54de-4f07-9321-986f49e47767@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdce3c32-54de-4f07-9321-986f49e47767@kernel.org>
X-Proofpoint-GUID: vWiI5DfDlKo9d_pTiAL8bLxbN4XYVEVa
X-Authority-Info-Out: v=2.4 cv=ZKPaWH7b c=1 sm=1 tr=0 ts=6a2a7eaf
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=kZerjp_4y9AqR4350q8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA5MyBTYWx0ZWRfXz55/QVcYLGVo
 fjA+rDUkbTg/5s3fdTTH1xBnati0BBf1LZoUEsKBt14uXCMw/vrzGlxIByX69y/kGDVdoEZgPJT
 utU+tR0kWEZE4aA4l9ufhHpnO/tM+iRLcylnUlBI0Q2IBuvhWJeSMbe7izIRfOaZtXQ5bHyowUW
 rJiBq7POXSC0z8dutLIKQ/1wfyYABlBD4xqBSRSTbTC+Ktc17/B8uza24ZZaF7RaK16i2rzzdgE
 XuiD3OzV4+7oPuwzuJa5IaptGSvM2TGLwcsysIODMQ1VroSu4B1QIl2z1JRHN+YcMPo6/K3ce48
 IBNc7yUyXr4ZEYmxKHuOgR0Sbb7RKlZ9Zq5nxLztbd7z97wYhF1qf4DtoVWe2k=
X-Proofpoint-ORIG-GUID: vWiI5DfDlKo9d_pTiAL8bLxbN4XYVEVa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 686F520003
X-Stat-Signature: 33r6iqso4uktke7yui5uop784etxcjjh
X-Rspam-User: 
X-HE-Tag: 1781169841-247255
X-HE-Meta: U2FsdGVkX1/bGfVPiU5fBA94UZhMqev8FAYCveoxAiZaoC14HkSgR0AUN9KloKNt7EOfst/SdglQui7ewps5TU0JcI8jhDLaEOa3Bvhn0eqS0DjkrcwjB3ftR6WKfnB9JaEwheewMJf5m1z8IqMfcs0PsFosvk7Cmd5bpHIPPPye+hNBJoNVAtr/Pi+azTnawnLBAQVaBFv1iU91XrwW3su5cO8sjc1QkoDrqTwndPfJj3b30LDjREbb+CzeSoPZCK1GHDP9IenRvwQtnVDSnFWHNUIc07Rh7m1ZPDI5h0ubHNR64yvczy6ag+naqgFIMNJfuqF824JHfQQNjvPtVzrNLQVxPBvysf7l2RungvREQUGdLRIW9WbkQ93LX4pTUu+Wjk513cQBKMbv75Q+KoQho3Fplh7zvYGG1NRP9xYLbioOOLrTKJM6h4q6p1vFm71CaaXPaR4B92zvwzfv5S1JpUBlaO1N9y9NcGcn2KLQl1skon8cXw3m3h3ms47uUeX1yusZlmjPt9TP+NlchhlknUgl3aBXRWlTLuBCIWhxnTzC4WVpzWDLJ1zhIpi+/Tz+Gkho26XYPg/SWrelsLFdbu6Jv68nVO7X7hak8i1ULvJwI+MR3u7GTOs8N+ZKQXBPdeMk11dmW4xdMam7HR7Q5zO8cFP+Rjerl3Xi4e24F+g+li+3Z+L1/zOmz9Qd3tADokKlhGt0dlWUqz6BVldyoTKyEcDgpnuBBTXOhvvXEZ9zrp2c67uhutFWna15t19PAH9Un9UqeQpGByPZtk2lIeu3AlYlqEgolLeYjo6REDuzQtSI1nURs8ezlfRahP9uZYNJMgue2+1PPaQCvXBvtQtIT1auTyiswQHHcV0DUm+Dv+b2HA1vTafr5l9F6QRmIwFPdITHXwf3KAIQTgx8aQGWIbDkh5mrDJolaT15lvRsfsmnkuRXK49r/Fjbvb17CO7pH5kob7ojJ96
 KF/OhTcM
 O2K5TYp1HgNbD8tWa4i4vbopDj4aW8mQzhKEYGcYHcL/5asDYIHhHGUhKZrlWT5m52lChBGtmi7kBatu3undQUHvPXNO28nNK4fSVRsgf+Ya5T0fHKz4Jx2BfJi0euGSpvArIbLmetdpCzlcPUPS7kvmiLmvoxxhbsoy+C6UhUeEgAbtEZvIUebmlC0sYK1RQviQRXRHp5MWjx7dqmUq+BYdMG2X2WF5GwW8/hyxcFaYXKvlctM6XTKm+H0bCQZZOOcFSQoq7sb0Jjy834Pp0X+56OkGgbqLWh5SPC8eS3hE9BFFRFc4ezWyJdcLORsvjLPr/J8EFVCMX8DcYC1izTedsTT1FXfFdx5XYVvN8lrSFvglVSnLsW+Bt+H57W41mQs2U2sJQw9NEYqBVmsqfmjywQ8Xqa/Wl2l/FILvCLaZVYLJUnBHvQaexuIC5WlaP7vNPqay6q8W399/mYD9hearFBPX0ZvqemdKvlcxn9HTCEriSfTlyhEeo/zVZoeT6I3pOebAeKvAMpWWNv0qNHyfhJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Thu, Jun 11, 2026 at 01:35:46PM +0900，Harry Yoo 写道：

Hi Harry,

Thanks for the review.

> 
> 
> On 6/11/26 12:16 PM, Luka Bai wrote:
> > 在 Tue, Jun 09, 2026 at 12:26:18PM +0200，Vlastimil Babka (SUSE) 写道：
> >> On 5/31/26 06:23, Luka Bai wrote:
> >>> From: Luka Bai <lukabai@tencent.com>
> >>>
> >>> We added a kmem slab cached called collapse_hint_cache for
> >>> khugepaged collapse hint, to improve the performance in allocation
> >>> and freeing for the hint structs.
> >>>
> >>> Signed-off-by: Luka Bai <lukabai@tencent.com>
> >>
> >> Khugepaged isn't exactly a hotpath? Adding own cache comes with memory
> >> overhead, so this doesn't seem like a sufficient reason to do that.
> >>
> > Hi Vlastimil,
> > 
> > Thanks for the review :).
> > 
> > Yeah Khugepaged is not a hotpath. But in my implementation we will allocate
> > those khugepaged collapse hint structs in other paths like walk_mm() and
> > lru_gen_look_around(), which may be called more frequently under memory
> > pressure. I'm a little afraid that directly using kmalloc may compromise
> > the performance of reclaimation... What do you think? Thanks. :)
> 
> What makes you think using kmalloc compromises the performance under
> memory pressure?
> 

Sorry, I didn't do a comparison test for slab_cache against kmalloc to be honest so
this conclusion may be not very rigorous :). I just analyzed from the implementation.
Since khugepaged collapse hint is just a "best-effort" implementation so I don't want
it to influence other more important procedures and that's why I wanted to use the
fastest way for it.

1. Using individual slab_cache can help it use its own locks and slab caches from
what I see. So maybe we can improve performance by reducing the lock contention?
And I found that mm_slot used by khugepaged is also using its own slab_cache. My hint
struct should be allocated much more frequently than mm_slot during mglru scanning.
So that's why I said that "using kmalloc for khugepaged hint struct may compromise
the performance compared to using slab_cache", still, that's just a guess. :)

2. We can also save the fraction since kmalloc only has caches for sizes in a power
of 2 if I remember it correctly, while khugepaged collapse hint struct has a size of
48 bytes. So maybe using a individual slab cache could be helpful to the fraction.
Of course this reason is not as important as the first one.

I didn't realize using individual slab cache can have that much negative influence :)
Maybe I should actually do a comparison test for these two machanisms. Thanks.

> > Best regards,
> > Luka
> 
> -- 
> Cheers,
> Harry / Hyeonggon

Best regards,
Luka



