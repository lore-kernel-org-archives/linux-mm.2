Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33683C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 04:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45106B0095; Sat, 22 Aug 2026 00:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5DB6B009B; Sat, 22 Aug 2026 00:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E52C6B009D; Sat, 22 Aug 2026 00:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0656B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:50:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D600D160306
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 04:50:55 +0000 (UTC)
X-FDA: 85127680470.17.05F101A
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3277C0004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 04:50:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JvEWI1pi;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787374254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FUvD8EAPmYxNy9sZTSE/DIJMEcpIQaJcCmSJdyyGyI=;
	b=yggYuLOfmf6kQhHO2ShtO06tSCX7QgjiAzwp9hJlfxFRw1pX3NxkvpRmzX+ve2ogsFgn2i
	cPpWyrIgpm+P4TiirYNP+joQh+/gZefX1/6GclbGjQe+S+sGT+GwpVbd1ohoNLbQ47ENsN
	7w0fHgPRgReCaYjOk1dUbjmg4oWbz6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JvEWI1pi;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787374254;
	b=COM1ZDGfuLIJFC1IDufM38Duc6Moo9fSdQ/P0rebgrJf1Yk0ypV9x8bTn2I4JluSYnmgVf
	v7opSKz1Rg/bysMV3IeG/iEpWiYpr1MJ+1ILjPPLkrj4+eVxBEwsnnRokRPBiBW4fdx8wD
	+ha0CJKOEEeSbgT2VyqbdbmPJa/pOgg=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8eeb4508f29so10897106d6.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787374253; x=1787979053; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/FUvD8EAPmYxNy9sZTSE/DIJMEcpIQaJcCmSJdyyGyI=;
        b=JvEWI1piZDC/VB6z+s7ob8rMakwFjNBVskkrkQPc2bTFwFcmjohdrnQIiKDdQtbVzB
         63EFZUoBWplQh22GlabjCEnqiXYbt7S9T73/6YkKkiDfgSGq85QpQ+stFUKnGeu3N3Nw
         mNq2DWfszyWjUXnbzjf/yzQ6HyFLbT/qi/YjyPRHcKCw3R2dWUoA2QRivxMlh7eB9alW
         9eeSq9gl7aWl4R5EWP4fLMl5YFNnZorR0BfDtELt6NVbQY1wPHiIpbbUIPB99PXC1nzn
         dOT0bvGCwcKXN5KOlIHaYuAb/M4A7Ve/5D1Ob3g7HCXeMJ5feBKxqzI4tu10GW2jkB4j
         8DAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787374253; x=1787979053;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/FUvD8EAPmYxNy9sZTSE/DIJMEcpIQaJcCmSJdyyGyI=;
        b=NFanEzr2tCQqNYPqsOexaTBeYh5BS6L8urQOzm7jYzxsaYRSQ2twdP4OnFk2fUEGg1
         o4G2ipNGpyJThxY7Dfn0CiWJYygx2QBkpFKolCrg6mpOIYatixME9KD3o5NpWywppFNS
         2b9b8zp8KR0qVFHJnnGOdTwOvZtWWJAjdrFxlsxQVq1aj7djeDG7eM8aLWFIbTD7Ckse
         54tVGAnkD3XTta+V/FGuLYk6IjfbpQI2r9qfw+ODNgcFd9ufwR/GaBXK4CT6oD+NbIT9
         Qy03LSLGb+2evOvXubJLttvyWn7JQ/hEt6z4v0YMb6z36OG57RgBO6VKxEqO/YnMWYSD
         vo5g==
X-Forwarded-Encrypted: i=1; AHgh+RorCP5iU8DA2RWSJ/TzvbEqrWsKdsYqB32QTqLsEs+UDPp3pQhZTpkFlVZ13zYk43OmtHlwwsNO5A==@kvack.org
X-Gm-Message-State: AFuF++mT2YB7dIOMS4rVXH+Ev7ght/pLuLLt3T+YEOxPOk+Os9+Rg2tW
	NYgoQssXojkvx3O57QfWtMgjud0UClbxND5J+5L1uYfQ6zenNKXKVKnr3w1GSnq7ML4=
X-Gm-Gg: AR+sD12+QrVgWHQyjXejJNKyYoDy0WCCs5iktyQ2yGMnjxNhvpjfEu7IK1FmyDOmG9I
	aAnekibb14MIflP2vCvWlivxwtZdNVj+Qd0ZZZHCAUlG48gTt9Jf9ZLwftYPCo6zlfMLwJ5OyBC
	fBDpPgGkBT0gmorOvIqwGE2aayTQNNObx1yjMKPBE9mh3+0PvOr9+Ao2iceNB6UhMQsLCE4NWy4
	0VU56JuoIECNrvD0vgknqjiszl9il93idsgfAYIK3AwFLkegqo/bzqPHUfjz3rox6E6LVkYTqLb
	WwzbaiSIIB2xkzkaVyrDWStLd1hOkPkknTZhVOlUtcAGuv3tm3omoMrpmDDCfju6go0OxjEnzkq
	I7yf7rlQ3qyi//WxrwmFjvpr434wrX4KACgFfQltls7gpVjiCPxRigVshM3tPvlghC1Knsuq0HR
	sLNSl0RTXqkW/837IyR5J7s8nKq0Lg5ws9W7cnKY4nb3/ePCUoq70EcF4QNUVzlxXnM5qNzsNwP
	REi71Bs9/YYklTg8SkIVLL/MKyNFUJYiMeHgWcGFvVcGM0KgR/U7CI=
X-Received: by 2002:a05:6214:3002:b0:8fe:40a0:7cbb with SMTP id 6a1803df08f44-90c8fa362afmr27850446d6.15.1787374253092;
        Fri, 21 Aug 2026 21:50:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c939314d2sm5396066d6.25.2026.08.21.21.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 21:50:52 -0700 (PDT)
Date: Sat, 22 Aug 2026 00:50:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Ridong Chen <ridong.chen@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aoknUpLTzBi65OKB@gourry-fedora-PF4VCD3F>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <aogQ6iDA7RkuTtDG@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aogQ6iDA7RkuTtDG@gremlin>
X-Stat-Signature: f95k4qqbz4d1yh9ywd4ufj8it856m984
X-Rspamd-Queue-Id: F3277C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787374253-53790
X-HE-Meta: U2FsdGVkX1+bZ0jB4vwfkDDRnC4BmBbjrJBNg6VEwao7BjQgECg4Qm8awDF0oUTM5KfXAfsnN2DM8NWmp1ldkJqMGHS/zRrZMW55Swm0VlvznWFgUVxHMv5sM3+D5s46SxrntpRxsCOoqO75M2PVld73dfbRrENZPU9UxrYeot9vhWNaHzL/HNCaVcHfjQ2xrWF6W2Jp0DEn/GIo959f2/6AvUdYuGlxvKQdEhVFkg7KLLfSEfKlivlboGrxBR5wmG0I5MliCT3kwsF3pIiiv7Q3j/szi1aSEg0ABT+P8HQDlVuNTdNrbqjpDr9Hq1f/VcDS6RazQpglSnsQrDdZ+ROoEXqEX7yQnL/k5lBk2UQS4LMtMxUG3JW0+oN468B+DryE4LdnaDFJwhN4T9+EG2uEztSnMvuyCgDgD8qZTugIAKgKabjYyEVeDXdxaa7FE2jI0dOLGkn39bZ4NHUm/uwnu+sC7tUZUIjpsgP3lFzSgAZo3/4zUyjTpTj0k0rm39G8GD0W121+72YIvJ+VbwOI3jJyxDJtTnG3ymBHd0WeLCQIkoGxXW/cExATFqrmvCe/q+ABASXZ89EBU51CllMwGY2p2Lqyo1fAAF4teaSmJZtfZI8LsJQftzQ6QsYqNWmRfTC0joXwFk2ADRA1n887RLUT1MZghTjY868++TfBkl8/MMnJ2Qn2Y7OZT72EIBpYxYGleYlL/vMNvUOLdJkgvVGlyHwLyVd9fhcggKyldPsCLnFsHcXmpuaDCKK1XnbYhdTqWp/mAkkmltTlwT7eshhTICcEvSL1tAuhs+tzJ3II0JpmY/EahJJ0uQifNDz300M26mrkis9DiSQtAIHYAAx877X4Vqs62L/L0xJNeX8+ecQpIANLtBJAlwm2yZTbacKlMc7PkjwSdW7NiquejZaeXfbtetnUtS1wIwjTC0qRC6Yf/swG1EGS7DxZbtcupmtF07juAJ9HnuY
 SwG0C+fu
 4yakIf5A45Vl6Yx0aA+b5aXOb2N197WYH60KQMaXbpzV9B2/mM2CvRwwHh96i9BQ3qqrjvNx6JQq3PKYEjzFtawSI9uMz964dxXOoB40QAvaP6gJ2nCUXYGQ/p2OJDL18r/pjGgGZTieserZk55kMfkIy84DCnIupdDDeFPIkV6X0lR1/Gy+9uHwqR61Wk6vgfydxV6mm9QyFcfm717/cexXCR5070p5Sx+XwGhifZUqiFvaideMYpFCbZS11+AZj7WRPd09h65xKnLu7fLtjEzE7TWpwjQmAl+Q7fCF/4pPdwz7g0P/ZhxgrC8I6JY23bhooiM3wrKfs81A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:58:52AM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc Roman for suggestion.
> 
> On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> > You are explaining what but missing the most important part _Why_ do we
> > need to have this addressed? Is this just addressing Sashiko review
> > refernced below? Is there any real usecase where the current behavior
> > matters?
> 
> This is exactly the issue with these 'unrelated to your patch but' suggestions
> from sashiko.
> 
> You end up in loops:
> 
>         AI generated patch --------------->  AI generated review
>                   ^                                  |
>                   |                                  |
>                   |                                  v
>                  AI generated 'unrelated to your patch but'
> 
> And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).
>

                We've been trying to reach you about
		your kernel's pre-existing conditions.

The reviewer piece aside - which I agree with (aggressively) - there's
actually some value on the first go-around of this cycle.  It has been
valuable to me in identifying bugs that are affecting my active
development areas - which is simultaneously frustrating and helpful.

Feels like ye olde map cycle problem - just break the chain at some
point and let it sit in a database and create a timeout on how often
sashiko can nag about a particular pre-existing bug.

If it keeps getting reported on - that means the area is under active
development and we should really address it.


Also - bugs is bugs.  Ignoring them is double plus bad.

~Gregory

