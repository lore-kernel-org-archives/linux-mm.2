Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347C11091912
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A346B0535; Thu, 19 Mar 2026 15:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAD86B0538; Thu, 19 Mar 2026 15:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7177A6B0539; Thu, 19 Mar 2026 15:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBC36B0535
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:58:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21EBB1DE9C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:58:43 +0000 (UTC)
X-FDA: 84563875326.12.C589307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B61CA0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:58:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8IjRoXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773950321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCy63MzPd2QXVwLu/vS9dzmFm6wnKEiUJeFqp6vHyt4=;
	b=lkDGWzijdPYrCD9DbbePXdv+hfMQ+g/wpzTK27hkwY29oJ6L+bRAdJlRebTmfR5ns2qAAI
	iHCkYBHZT1r2nBVpqPGH9+dU5keINToHE9VFXAevNbO870iobgekv6gNiHkECgDErbBRW7
	dKaUpmQvlDhP06JMx0GgJmebtZKgAUY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8IjRoXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773950321; a=rsa-sha256;
	cv=none;
	b=43SKsFEfx4RSXjJ6QOyL2OGu4DcBUhF+OoOcGx+cY0lAmXjC7wf0n/SeR2sYOS5YbSO/9N
	Iid0Q7QqOzA2y1Ls4ul+0gZls2gW+50QvIwJCAJj0aImjo9W/GDvGGf8/mZ8xhKx0TOLg3
	1vtOT1NsNDGob28yInbu58fAuAW4OHc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CA7E41566;
	Thu, 19 Mar 2026 19:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00986C19424;
	Thu, 19 Mar 2026 19:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773950320;
	bh=T6BKD1tqEyuEpYK55Snf7V7YPTv2oSGQpGwo9UT6bpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m8IjRoXAb3Zn/Q67ROj1HfcvutqDAL5M5RN5U9jIQ+MDQtwlLUhEPBHAM0gg0+vj9
	 bRhMmk2R0w2Ss7XmKPV75OZiSRABwamNdgK+i03w9BnRUcRL3LCL1GmYUC8HUaPbBx
	 714XFx4wuYbiYxYvymJiZ/pvn7ebpp77eClZHB4OTicuQh5dnxYWf7MM3aw4ABy+8+
	 4jqy5YMbhMooeiEtIzOtsjS5NFA0qeEHUfuYJSBl2KV54Nqc64SzKPBwRx/PWyIYQr
	 0PgZMICX0rP0hpEsD3wqrCOGaxgXneNtmubvl0+jiBUZUGTnmhTPT7ULd+qB9BhQMw
	 UlXfQKFEJVS9w==
Message-ID: <6ff14b27-a494-4faa-94ed-ebbf63116125@kernel.org>
Date: Thu, 19 Mar 2026 20:58:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko
 <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
 <215517e5-a49b-4eb7-824c-8c42e4db046e@kernel.org>
 <CA+i-1C1g=3_nK=Xq+OV8KU06YDo18ZaDJqbkfp21Z8G_cnkQww@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CA+i-1C1g=3_nK=Xq+OV8KU06YDo18ZaDJqbkfp21Z8G_cnkQww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B61CA0013
X-Stat-Signature: xoaknjptr6ufujkj7d9qqxqeg1rjwwef
X-Rspam-User: 
X-HE-Tag: 1773950321-507824
X-HE-Meta: U2FsdGVkX1+GIVzvsZZi/WweLYEWABonosZhdlT3K24EPO+EtoGQPeJrRCrdWFE0hoZDFEfkbsIpDa62qzN2D2uOdjAQB8/Fy+K44QhMMe0wPrY/Dms8S1oqXJt2eq2sr5isR9nIVvseUiPr0rFCmYb8T4LVS2K5KDnfCL2hl0l6uEihSTPMeV7QXwebnMSd89nSa//rA+fxceCk7ySz0hM/5PnMgJJlfZ0/RHrDXYBalGxoNvggMvzzfzP5xG4sQeNhDrnzaR1UQzTYlgDdpn+s4GCMBupty9UjtOvog8cHTM6EDClHXkF5Z+37j5YIg5HxfQL1HaOa+ANVK5RyI190607yK1mtnEZ2ak3BZ3w+Sixr3jhOUiCKcn0AJE3A11bT0ZPgvFgGkesue3BHvkA/0Lqk47lmTJnWw8vf2k1rdEWQMz5L5J8ER3vArc/eRd+JYyFp5YqmPdDWVZH4Eyv5T/lmk8FeNr7Si8N4DzUD02dAC2O9+0rmZFPpM52i5dk5UHK1aaHn6p+Op8y9tNLURiylNRmFFh0CxW8ACxJZDISUtjYrro9AzY7jmwr6+AzgLmmC26nFL7uU+dw3p44SbcvmhpiLqz63nf6K+pbhDfdUQ1uva8Iff66aYX32mAyX9V9WFRLJ7+m4jFfUer4UrQFkDuVNJyxF+s5TodW3nrci4WmYmRlXlUvUk0z6XoK7d3WFaUVr9lPPF62Cq2f6/ke1njT0SzxwNDLZ5VktmKi6DIuGQqwhjsWU0+4VkgVe/zp9Yy6NpHLKf3tshwXL9obH0j+HQ6o/6p8bZikLzKwgIEokQj2TK1kLpfrZlq9wnjriOXd4DgEMngdHC6POlR/yQg3adA4IEVGL0EiZAVAXJ+fuvLVgfWFZhja9pZxYS15iCNMlyClKzcIY2G89h/Z0XfwghxI3Kvf81pZNKoqJ5gpvCjfQuXnoqBQE7kwXdZFqhRxu50zqf2J
 0Yqmxs2c
 1nCQxrx5WlvJj+oPZidKOvg14MJowRTF/uxaZipNARIgtn0RZFhDafJZbhNhFWbPlOW/0BYBJom2u6CJsLmhkz0bahbtMOVv4l8GoOWMTDahcYh/Z3jWWHihXTfZHiFK5H5itnOoqgPYjdoRgkQiAYE8b89hDcELRfqPgtxk6oKsXfA9JmHFXkJIJL3ZCbdJ83sSo5OOPmwLPBPUDoTEBYXtRkwXEPQNsUOMivatYSv+/xOryEatIhYI7XGMFG6hGNZb/IgrHWhnhCXuqZmnKeP2xp3BW3bxXyvy0OHGFZyaxeKifBjUmiyO0+nhRcdY7wU1ITOPvT86vBAhGL7FODZnNnn7rUmh9cgwcPSUVo3XO569/dY0siNCfMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 18:38, Brendan Jackman wrote:
> On Thu, 19 Mar 2026 at 18:03, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>>
>> On 3/19/26 17:03, Brendan Jackman wrote:
>> > As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
>> > probably not needed for 32-bit. This offers a way out of the GFP flag
>> > scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
>> > machines, while leaving it 32-bit on 32-bit machines.
>>
>> Thanks for tackling this! But now I'm wondering, if we decide to change it,
>> would it be worth trying to add some type safety too? To help with cases
>> like the recent kmalloc_objs() footgun discussed in this comment thread
>> https://lwn.net/Articles/1063356/
> 
> Do you mean something similar to pgprot_t?

Yeah, at least I don't know a better way.

> I did that in [0] but I'm rather sheepish about it, I only went for it

Right.

> because I think it's especially needed for the specific "type" due to
> the migration path creating a high type-unsafety risk. And that was
> totally local to a few files in mm/.
> 
> Are there common issues with gfp_t in particular besides the
> kmalloc_objs() thing? If so then maybe it could make sense. It's not a
> problem I've ever run into myself though.

I think it's a hazard in any case where there are multiple arguments to a
function where one is gfp flags and other some integer, and somebody gets
the order wrong.

But I just verified that at least in the kmalloc_objs() mistake, sparse will
flag it, thanks to the __bitwise annotation. Would be better if compiler
did, but it makes the case for changing gfp_t smaller if it was too
disruptive (it likely would be).

> [0] https://lore.kernel.org/all/20260225-page_alloc-unmapped-v1-8-e8808a03cd66@google.com/


