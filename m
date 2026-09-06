Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 097A7C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 10:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A948E6B0088; Sun,  6 Sep 2026 06:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A459D6B008A; Sun,  6 Sep 2026 06:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936826B008C; Sun,  6 Sep 2026 06:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629B16B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 06:16:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C181980505
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:16:27 +0000 (UTC)
X-FDA: 85182932814.06.3237525
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1DAE40006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:16:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZDwHhkw;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788689785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ojcatem/E1McFU2tn3fpwcM30WG5bWRqceZT/nBgCPQ=;
	b=EezQDNmbJ4EZcwyEBch84EKVcoFlxvGJvyMm1ZAxI0gYjdE8DjpYBR2Plif/pu+7vsWZyw
	JLwVOHR/nZ5ND1LVrotD+SP4D8SW30BEjIOnDw0eFHHlLzd74h5WIS9bv/tzyhh7ZhODHz
	m8W+A87B+n9PX/GD8HwexLeiVj8XKFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788689786;
	b=RS0TA+MeP9pKFBswgwIOBzR78EHf0KC+M3wVsQtH6qrya+Ru06Ao2Jl1tlP9ere56BkusL
	shuEq7aPzf/1BAIfnHspTMRFR8zxIjqxKpNpRsB8m+hlhVaa/b8S+qMd6J03BkPSSfwxD5
	xLltlytBktvAaAsQ3TlRbds+KePsNmk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZDwHhkw;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-495590dde14so35185355e9.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 03:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788689784; x=1789294584; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ojcatem/E1McFU2tn3fpwcM30WG5bWRqceZT/nBgCPQ=;
        b=MZDwHhkwd9vYiHkxu2gHtmTvhYCutveMIVHSlRiYUnIK44dBEaaQEDT68AnsWvEkjr
         768bEwtxZx+98zCrX2Y9/v3dBlbCf38wTMovDE3YhnGzJU/I17eaINHpn4jxESC9TIkf
         0mHE6yF2hGrBLP/9/IC283uV4DeWJ3RWrQ8NJM0EtD5aK2AJECMZqZTd0RuNfanI0V6U
         z2WDcx9DE5gxITOBhmYujCeC28CH63JIe04+fbesHR5qBwkftOaJvyaQ+VArKPuK+Ce+
         mhSUECZJ4UVGG8I92R/qd/W0tISPxssVVtBAfUfEqOEd/i9E6VFqhE1nG6ULqBZDoaR0
         FEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788689784; x=1789294584;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ojcatem/E1McFU2tn3fpwcM30WG5bWRqceZT/nBgCPQ=;
        b=bzdrdpRw5md7Be/Roo4lqw6/9EVWJQmpTkjN2myckhccA153gSfoR1FNF5h5ctNjKH
         iciDqW2oJ/By6MZD9Cj/MohomqOQ0zsL2L+lBTPbIJslZLfmJwT05Uy4BhV0X/uKD9ym
         O565KNlv2E/A/i0BeMkbzheBH4lkLS4zQkLnD7A4Pxc9QWVR321WAIWdYHwzviGTPasP
         TkeLGXqZRRM0gERTFZT7+oXzU06gRIYtBSRf8zPbFsAkCv1EmFxsHpLraMf29g1adRqS
         s3CVtzslQa1z+lIlBJPTqH8uSozwQXmeEBDqlWC7nK0b1ORDMpz/yEbmnm/TMH3x/ct0
         xatg==
X-Forwarded-Encrypted: i=1; AKwUvBy40TRdihaD9J3jAE7VHxVdPzVzvUxU18xzS1oveyfefSK+8PPyHATdsPlpwbUGoj8FxC/2Ghwkew==@kvack.org
X-Gm-Message-State: AFuF++n/e/3U8CM5lEBmligJ0KaKXWsTwCI4MO2H0OwuK/96sHavLsJe
	osb+ZjVKbChEwF/23dmdUFzxV5dbo8NzEMWXoHUD6sRAw/so0pZDpUrH
X-Gm-Gg: AYBFou2iYwYimYgYe4IlCVJ+dkxuULVNAnCF7I+9uEzbI6cIeM4i2rWF1rJ29CSznu5
	w3u3IRRMj1yCjGPuytJhXIGptvhqJmsm8MOei8kl3G7V6nmXK08roNbVwqZ47FaiJVdRSeEah0C
	xMJk5rHmEMfkZsZ3ztAvZ91+AsNueoZtCylwpjpU3MvVyLW1LsFJ6fktxna1YkaArG2N1FKjtKT
	5fuBa8sMQyeOL2gYTH3cGgAhZMYXq2z7t1dDG30mPW3tudBWyRoq/6nlibmLbgy5e3ibJSwJ/sB
	NUV83R7nb3q7Od8fWuRDyWEWOgk0KY7iQVhQncXTh4LtvoyV/bZXfJvhwE72an3Xch8ecwNNNPo
	0EjhZSSnPrCScB3SyCPCnMJIqnHkyi8Xa2x4riOoMVZ+hG9y65PDrr7cUABRxDk4GozDbJajNbU
	m2HZUnWMz384V5ET7on/2xJ64EA2glmGxDCo97Fuxa7tjnUpt0l6YtqMne+0UrW+FOh8st/uvLI
	GHG25fJvYoAiK9otAGUgqYwbA==
X-Received: by 2002:a05:600c:3b11:b0:49c:f7c4:dc54 with SMTP id 5b1f17b1804b1-49cf82512b9mr288796435e9.14.1788689784162;
        Sun, 06 Sep 2026 03:16:24 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03703f13sm57044775e9.0.2026.09.06.03.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 03:16:23 -0700 (PDT)
Date: Sun, 6 Sep 2026 11:16:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Chris Down <chris@chrisdown.name>, Tejun Heo
 <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, "open list:CONTROL GROUP -
 MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Ridong Chen
 <chenridong@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
Message-ID: <20260906111618.644362b3@pumpkin>
In-Reply-To: <f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
	<20260903031952.1120321-2-ridong.chen@linux.dev>
	<20260904093743.23cde26b@pumpkin>
	<f65d4985-5e21-4e29-b5f4-dcff0fa479ab@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4fz4iohz8siqfbyqg484i7dubr4di9gx
X-Rspamd-Queue-Id: F1DAE40006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788689785-91093
X-HE-Meta: U2FsdGVkX19A6YjmFbaObvMRhm6hUB3VIrv9dqg1KNWvDKq3v7HpHJDn8lKTRHaUt7rOqlMjGU+2/dsgNoa+Yv6OqmV0pe4rnqbYAJc+xtGisFw3OlTM1+yPvUqciclBPYHBoRt0oTWiAc1tiW/x7O0ZL9U3ajq9gFf0iPEZeMNfmTDAxaX5orjdxBahoKPLPxa0PnCd042/1EWHX7Wc4qbZz6lVVYmCtK/ZS2uKeut9RoOW4RsxoNZWS+aiW8TeMseZp25KDmnraRW1zJMRosCXiuOqomuphL81q6D37JXDwHzYCgpa8oPYai892M2rTqzcbOK6M3IEBTsfRdJ9xK8ZkD87JPNSw0H4nL+NRArxNFDtBj9H8nySEUahU/oNX1l66yGKtAzEd/Fv5DTJ0+0He1PZkBNUyb1z9m3zVK5/C/2I+exSvdVmvSA3fZwTYlbwky8AWdbSisgFWadHFOfIxfcejG6WG2V9qJBe9AIdIfpbpihXkOhwX9oFAPOVT/kQPhlYnuexeJU41ECccyAf87zkyq7qAtoorzLlaR9pHJcbKwceYnjHV8jXDmcBZAhxjmWYIjGXH63hc/Zwz/IOmLaDtyhG/gS/qHK8P38tGJCuuXNYuznZvgeqVMZQlHipp8+Oxrcq+EBsdjN7IBLz5kRwwpztBFs/947uDoV3/HjPJ6Sn9JWqt5H2cvFTxh7GBk/IoVuM9OlDWbVBzlpv/zPloM1HbaKDhhFlz1WZ/kfEIDHinqq0swiVTTYFnhuYW9JBNS65qrsRBHs5MPYgMDk5AHXAD8yl/sa27OAnxQdq1tZMbgHgAyyMOiGpEem2LTiSCjHTb697BkTM1EXs7SdktZt95sde44LgRTvkIt92eO/I7h7W+7Ai+8+aXBWfJJCNfS7fYqABR3+YPaf/cSqqX1BbArivoHe8LlggMvgfRMQMKXE4a7HrmUrNwU1ljYxUSvvIwmgdz1X
 erBEWkhi
 l3I+dh6RKBSsgE2XXcC4dgSMHKAEjBhDl0V21X1M0M2bwdafWMq+Ze/29SlsLd7+fy3L2YQtLgpyJk8HwLpHwKjGvM3ylEdyznAJ5GkSpMBEuX0nKTHS7ORHKBHEHPC9Lx8f7L6w6x8OPhOtDSGVFmEsQhAUGXLX8g59ym6qNdOxY74lBBKkpntgsd/+rM+1vbgb7TcAGbgDCmHSL/Dhrd7NtySiZbA1g9eCMZqtWkk0750pNY08VLcWXKiEkUyi0Bvh9V3QZ/OzLHq2jOp0u6NeUJGvOahuqv5VI8TDd5v+SNETs8p650V0ayQBstOEY2KZrEW8iGuQeoatYjFhl86jlL/8bRsxBX9pdh0DTeMrp1V0ENABadYC8A4t4INVsJn+oIj7iEPYsi/3AbnrtpfeqdKZNPjs7TlbW14k8cs8oAeFCtrGKKRJR451yxRQ3joOoeneCXBtfaWu49TG1Jozj6Zl8Vt1IRDWWiOt6fTthDuGN95j8qRLOtzxiqmZBHZFCujjSy9h+02bDhackfBCMVhKTyS2X/4rbykcDg0zuNFOlUmKCrybQrl2QWg8QnVqwM+wuPKY425ZrY3sOIxxdqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 6 Sep 2026 09:11:24 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> On 9/4/2026 4:37 PM, David Laight wrote:
> > On Thu,  3 Sep 2026 11:19:51 +0800
> > Ridong Chen <ridong.chen@linux.dev> wrote:
> >   
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> effective_protection() scales a parent's protection by a ratio of page
> >> counts, e.g. for recursive protection:
> >>
> >> 	(parent_effective - siblings_protected) * (usage - protected)
> >> 		/ (parent_usage - siblings_protected)
> >>
> >> The multiply is done at unsigned long width before dividing. On systems
> >> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
> >> protection value and silently breaking memory.min/low enforcement.
> >>
> >> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
> >> usage and parent_usage are not read atomically (a child is charged
> >> before its parent), usage - protected can briefly exceed the divisor,
> >> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
> >> the ratio stays <= 1.
> >>
> >> Reported by the sashiko review tool [1].
> >>
> >> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1
> >>
> >> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
> >> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> >> Cc: stable@vger.kernel.org
> >> Assisted-by: Claude:claude-opus-4-8
> >> Reviewed-by: Barry Song <baohua@kernel.org>
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> ---
> >>   mm/page_counter.c | 19 +++++++++++++------
> >>   1 file changed, 13 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/mm/page_counter.c b/mm/page_counter.c
> >> index 661e0f2a5127..e8bd512069c5 100644
> >> --- a/mm/page_counter.c
> >> +++ b/mm/page_counter.c
> >> @@ -8,6 +8,7 @@
> >>   #include <linux/page_counter.h>
> >>   #include <linux/atomic.h>
> >>   #include <linux/kernel.h>
> >> +#include <linux/math64.h>
> >>   #include <linux/string.h>
> >>   #include <linux/sched.h>
> >>   #include <linux/bug.h>
> >> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
> >>   	 * otherwise get a smaller chunk than what they claimed.
> >>   	 */
> >>   	if (siblings_protected > parent_effective)
> >> -		return protected * parent_effective / siblings_protected;
> >> +		return mul_u64_u64_div_u64(protected, parent_effective,
> >> +					   siblings_protected);  
> > 
> > On 32bit it is only necessary to use a 64bit intermediary.
> > mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
> > divide (and then maybe to a 64 by 32 one).
> > But there is a lot of extra code before that happens.
> >   
> 
> Hi David,
> 
> Thank you for your review.
> 
> Do you want me to split this for 32-bit, or is keeping the single
> mul_u64_u64_div_u64() call for readability fine with you?

Maybe I'll look at wrapping mul_u64_add_u64_div_u64() with something that
checks statically_true(((a) | (b) | (c) | (d)) < 1ull << 32).

Probably neater than the conditional here.

> 
> >>   
> >>   	/*
> >>   	 * Ok, utilized protection of all children is within what the
> >> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
> >>   	if (parent_effective > siblings_protected &&
> >>   	    parent_usage > siblings_protected &&
> >>   	    usage > protected) {
> >> -		unsigned long unclaimed;
> >> +		unsigned long unclaimed = parent_effective - siblings_protected;
> >> +		unsigned long unprotected = usage - protected;
> >> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
> >>   
> >> -		unclaimed = parent_effective - siblings_protected;
> >> -		unclaimed *= usage - protected;
> >> -		unclaimed /= parent_usage - siblings_protected;
> >> +		/*
> >> +		 * The usages aren't read atomically, so a child can transiently
> >> +		 * appear to use more than its parent, making the ratio exceed 1
> >> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
> >> +		 */
> >> +		unprotected = min(unprotected, parent_unprotected);
> >>   
> >> -		ep += unclaimed;
> >> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);  
> > 
> > If the ratio is forced to 1 there is no point doing the scaling.
> > So maybe:
> > 		if (likely(parent_unprotected > unprotected))
> > 			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
> > 							parent_unprotected);
> > 		ep += unclaimed;
> > OTOH if the min() generates a cmov rather than a conditional branch
> > then you don't get a statically mispredicted branch in the normal case
> > (which is very likely with the empty 'else' branch).
> >   
> 
> I'd rather keep it as-is and avoid the extra branch. Does that work for you?

I nearly came to that conclusion while writing the comment!
Actually the same might go for the other three tests - generating a 0 or 1
from a conditional move ought to be better than the possibly mispredicted
very unlikely branch.
(I am right in thinking that they should never fail?)

I also suspect the #UD is the least of the problems.
You don't want the scaling to produce a bigger number at all.

David

> 
> >   
> >>   	}
> >>   
> >>   	return ep;  
> >   
> 


