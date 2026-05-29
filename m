Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43CECD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC9C6B0005; Fri, 29 May 2026 02:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD346B0088; Fri, 29 May 2026 02:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F049E6B008A; Fri, 29 May 2026 02:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFF436B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:57:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74634163132
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:57:00 +0000 (UTC)
X-FDA: 84819550200.01.5D796ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C192A1C0006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:56:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3wokvyV;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780037818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYhbJ03zngjCzkJ2hPrDNjIkIlO3ghoI+gEguCBz3YM=;
	b=xIa6HvnhR0b9vh7Mjs8u42jVDjCh3DCqky5EwG1OAeBUNMpA8pS8+JVEGGZK9YglbVcYFd
	+Kesx02D7qzXOtX1EN3BAWY+TlEnkzNM30IZeAW2wh8zicpslMJhbTtYtCBk4ttLqHgzkd
	ff8v7VzPX4lufcrJPTFslli3FM96py0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3wokvyV;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780037818; a=rsa-sha256;
	cv=none;
	b=dkg5VOidgM3iPv/1TSq8VMex9QyHJjyS481SLtcW2tHN0vEThA5lT3SAxPmWRBkrGE1a4K
	KGv7eARpESwDy9KU9puLKbtOaN7ObhbrG1W3ZKdC3PG6ucK889SHH/VqhPsPwDLlFqR874
	kYgj3ppBZWSjXsgwKEYZoayZ1WRx0/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A506A4409D;
	Fri, 29 May 2026 06:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E761F00898;
	Fri, 29 May 2026 06:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780037817;
	bh=bYhbJ03zngjCzkJ2hPrDNjIkIlO3ghoI+gEguCBz3YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q3wokvyV5MKZlsvJg4UNtT918QlXzkB1U0kHy4MQZf3J8TNDLjCs6GWuK6gBtLL2S
	 XwxTTnb8J8zHH5LRtHazfGYB3Umrz1PHhEDR9QNPU0EOEIaA3XN4JVt7wCnygoA1zV
	 4q+FTfFAUbdKZZbslBEY/VDMaQPAemhXbHlqgR6SKTL5Rr5iKO6uEFjESpmfoIwVLb
	 AEq9ZYzwDZSXe5A0SDEA94a3R1N1gVz2W5Cz4tTFDGKSsdQLDLv+lIcvVy+XKCnFA7
	 OOK4ThbmBiMKIXV7eLFB/GpX8xtJZgGZD4WmS5hEg3F41Iq5zx4rb+uQBIuKEyOAQl
	 hXnsGCXkomZXA==
Date: Fri, 29 May 2026 07:56:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangzicheng <wangzicheng@honor.com>
Cc: Barry Song <baohua@kernel.org>, wangtao <tao.wangtao@honor.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahk2JJkUdpHQIqFa@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <3f7112ea7bc0409885f0fb0b4d09561e@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f7112ea7bc0409885f0fb0b4d09561e@honor.com>
X-Stat-Signature: 6hmrmbr88ecpr8t5xyrandy87cxo9xcg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C192A1C0006
X-HE-Tag: 1780037818-855063
X-HE-Meta: U2FsdGVkX1+5EHG7Uwrhp9hyyOlOqmRrK2zEYIBvuIJHld8VxM16oc+YUpmMsI0oLD7dE9IgM5FVBNdQacEDac79Ik2FXR7hb6O/bAYOmzqsL0hadxdrOjxVEKDIYKJiD8VnnbTD1iXHOP0cAO2zkq7hv65g+WCoA94oWH4SeuYFJseLbhgbK7SygzqAGmHBBPAarAcPZtJ0OF5+Jl43qVffgfEQFv0jGYKfvuh8HTamuquAHK0AbYh9/3T4Yz0t6sre7ESIBbEJEnLMiNd9AYSfalCx/aqn2p6OE26BzNNLD9NdYHJ4IhZjEYRMQxl5vNBdKlwt4m9lnVttTaPZWNWxKeorBFS30ZSBPnaHg8VNfgxOhSzDYqJV1dLf6v3i/IMZxIS7PSmc0cfG1MJ4eyGZtokVN/tmn3BZHVbk7Rj/mvWVFBjtmAD4MoQkzlZ/ZfytdBkQPzAzDWPgW4rf/7fkd4LQXXyy3tuzBX/RvdoIjEw6rpi8YSDMG8GMOqVh6MxExypJgEp+IGMHO6DD19mlLU3vnQEqHIxNZcL3Rcmi2MPoqxvPLLR3KIB07IHGaWu67eG6DWw5GC35NdFvldkGWAQAfVfCfk2PEcvnIEXmeB0vd7+NMevFUAuSXNWteYjW0k17i385q6rpnbw3o8qGhKMo4TmHe3t73lNh7ExQAsQ2FRyKh+spIVxs0rLiop3zpwjqm2eTU7j9ZVU89zhRfn+gi30SxK1DD3CBlK98f0EXyQ7gjqzd4UKCDh9quYHqsRM66a7v/8WktObL9MEsguo+BQje94Vg7XhqDZ4wkbQ95HrxdkSh9g93dwoFNUq8NFgJn1WXZO/nD3gHFG8AH8mwrcQuvYK2VjdY/+XI/O3Gz1lklR8QpRIKnCMsUAo8e76yxP8daT2Wldl7sED705Ko3yHmGiHGmi8WsriOi5icc0U8orR9Xv31KWueG3gwT4rtZ6/vsLotR80
 LfsXzvTx
 CsVFnJ3/PX5dSSGMcmSdG2DtluzPWr+coT+qQDZ+APzu41BJ+qOP3xaj6BJko+cJx4wClqZn5MfVG9Wiycr+egMc90maxgPxR3zaQs7IAYiqF3nwcIhKnNFpyjZQTl1EF8HeaGnSG0uF8krvPbOgEmpPNYG0i9KZofwE9pfopqv4Doc/TdshCsYG81Zj5Q3aQYF7OTvuHpzWXQ1JA++gBw+QYA28rNj903GfNY79fEL5Vrd9Aal2rGHp5CkEV+phU0IOShAj2FkpTsRQyfNcwQGPM6nnVTEYiwvYbY7QaQhDEtRFsfjA+CmWRIxHfpGYZDQ3HXfSeAkgl3FCn+kCKfmW5n4CwqHKYC47gPaCGO9t1qprbMFmYN2ToRV/3GKDWLKZhUfgUwTkmtIY1csy3NcfoU0eH666Y1XPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 02:20:38AM +0000, wangzicheng wrote:
> Hi Barry,
>
> Thank you for your guidance, it is very much appreciated.
>
> I work with Tao at Honor. The motivation behind this work is genuine and practical.
> The memory cost has increased significantly, and we have spent real effort investigating
> and prototyping solutions to reduce it.

Thanks, appreciate the input from your side Zicheng.

The series is unmergeable as-is, regardless of provenance.

What's unfortunate is that early discussion could have saved effort (and/or
tokens :). This is often the case with firms that develop something in-house in
isolation then present it to the community suddenly.

And as I said to Barry (+ Tao previously), the circumstances surrounding
this series are additionally very suspicious, and while we are fine with
LLM assistance where the authors fully understand it, it feels that this is
not the case here.

>
> We're happy to join "constructive" discussions and learn from the community.

So with the negativity above said, I'd really like us to move to a more
positive and constructive situation :)

One thing that is clear is that - we all want the same thing.

Reduced memory usage, reduced lock contention in the anon rmap.

So one thing that could be very useful is for you guys to help assist me
with testing of my anon rmap approach as it develops, and also provide
input, critique, and review.

I'd also love to be made aware of any testing you guys have done or input
on that, also any workloads where you have observed particularly
problematic memory usage or lock contention.

Please note that my work is currently under heavy development so the
proof-of-concept code provided is incomplete and not yet functional (it's
just there to give a sense of the shape).

I will likely provide a pre-RFC series to interested parties prior to
sending an RFC on-list.

I'd be more than happy to include you guys in that.

And as I said previously, I'm more than happy to engage in discussion
on-list or privately regarding this work :)

>
> Thanks,
> Zicheng

Cheers, Lorenzo

