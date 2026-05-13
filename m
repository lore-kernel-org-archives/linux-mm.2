Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55AA9CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 21:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717FD6B0005; Wed, 13 May 2026 17:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1E26B0088; Wed, 13 May 2026 17:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5427E6B008A; Wed, 13 May 2026 17:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3486B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:10:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E79D71C039B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:10:12 +0000 (UTC)
X-FDA: 84763639464.18.7FE2EA7
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBE16180004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:10:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=szBx6UVH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778706611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yw9HWAanvQGxxotRyCikt0YifQqq9eeU+f4Jwn4SlFY=;
	b=xMTdqgI7LrjXBfuY4Ht3ozmq14AXj6SX6aQ2cOMVopgaDKbKUJfQXVwGER3ZoKvY3d4osC
	jMri0qxfyq/k8v7RsL71Xms+cHbEf8p0S8NlJuNc4fP/CjkDgy5sao84j8qfVFH7UySn/p
	mmdxaQ7qo3t3+Z3nIU7lL7NAFdBaOdc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778706611; a=rsa-sha256;
	cv=pass;
	b=lEcwAAaAU4bH2Y4D5n+1e4u1/f9WCF1dqnUg76gGu1MWnUjoWxPYXZCnL96/cH12OMtYqO
	1Baq4b4+hP6SPSbNHTaoztHm/aJgs8no5X77n95PyP9xBSX0aEj806Ins2jZXgw90gy2SU
	mM5I403Ty2s9G68o0Mu4vYIJz/JBROU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=szBx6UVH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-44ce78ab5feso6158789f8f.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 14:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778706609; cv=none;
        d=google.com; s=arc-20240605;
        b=UO612du99GWveVqqKRK6vXVTpEEBDhJZwgoPP2Kpq+9oJB3HKQRwmEJ9baViPonrzF
         lius/zO32aSB+LK4cbbzZCla921+xD8FDGwpS9tLyRsBZy5xnE6lzhlg8RC00ZBTFIPa
         gxSVCDJpB4rpDuaq6985+hMss2cFnVRUqzhAVLgo6X5GG1bKFIfM1n5w6WXBCM6Y58t8
         XutYXdaw5h8iSZUn5HNimzd14G4yPbRCATnj7hybYtmlXQ9JM9i7HYqnGjO9yAHL/BPs
         crOltb0M4MHWlIK+vwpOEFQ0wXis1tlqcu9h2Q0krpfyh99wiQemngEhCYKR8+z/hAVU
         Do3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yw9HWAanvQGxxotRyCikt0YifQqq9eeU+f4Jwn4SlFY=;
        fh=Iuq01eXJdcYn60uZ5yXoaOJvpHOPUEg/4WGUnbZxi4U=;
        b=X2m/EadH8qyAvd9f+YMcERMMQCZvuw6rL/yP+gm6uVsQuSDN/Vf/Cd0ASkgKLErEeE
         pT+yPReADGVvePdJzCdI3Y/3BDumPzV3xOyleqHLPCzxSujyOePMy5YZJbrnFNFbpUuE
         KtdFyVYKbo7dhp4HMFIylDTtSDQ8P0R0mfk0of6GZiLwAmdQKz3yI99psiu38EZYcyqN
         V7o69UEgSrmSiuwbgZu3ZAWLldKa/uGacsmkZcijokjR/pKb35AE5mxlHETDAChlJ5eB
         jhweaIIv74OH0OEYsO8578kbrR5Lw8YeD+ZpjWyDFUfowxjYuS9SVfTuhbIW1ZGIzihY
         kmHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778706609; x=1779311409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yw9HWAanvQGxxotRyCikt0YifQqq9eeU+f4Jwn4SlFY=;
        b=szBx6UVHmjn1aGgm3vW/WRdfbKx0eMz9Xate5rogj2WH82aXH585ZCHafrxzrifKu9
         43+LhJOTETuhS9Xet7fOnvW5xVI3InmwMNdqObZa8CsyKPbGtQ/l30GMY3JlmFHEKTsm
         MEjdY1Z7l16zfQ6OECYdBkdnbnpWWAhAnO8Ml/QhLlL9HT6cTdgHTpDwWuUsXWhrbXcc
         DW44fdRkhXxEnkrjoa2ojVFBbvwocbjQffXkG4CZrMwMHOo0u0OO6Y6VtCuhYdUsWgbr
         y6JP39J86Qwlmuy1fjId8t3oeHQonrlvc1W4kconk94LY4SiT9s6S4ZHMwp5LdW5qziJ
         Tmfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778706609; x=1779311409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yw9HWAanvQGxxotRyCikt0YifQqq9eeU+f4Jwn4SlFY=;
        b=WZFcpu5un7MR6ru2H47mRvxHYgAHBcVK9LEsI8/lLrHAoLSvSmNME3uwLELs2vtosR
         ca9AxVFcApZvpvyAKSe3BW+fltN1K8or50RLB8ZFZ6D1Gag7WCm5RX6UngiwtnBeZs34
         LkdWvvP1vi85bSvlf3jc6n8Z72ebtCHXemfKr8cY/7v9EATpxeCwzPtoXZXAbS6zbN58
         TJDeYxqWj3LDPOw9k5b7fK44FdAEK/prSkJM4cX+ncqq0gu6wxzKz7blckMdSW1BlDf1
         PjIVRiIKsrY6BGsghCFh55UcRuSSMzX9zSuAKBol0GNV+he0XgU48aZN/lu4mvEHHoqN
         GFpw==
X-Forwarded-Encrypted: i=1; AFNElJ/vpUcy4FyHz3MJ8WNMtwNr3gNN2FXsMkC0tBEswnv342nmK8uE1jDuGXrUgzoDzKsxfp/i1b1UOQ==@kvack.org
X-Gm-Message-State: AOJu0YxFHGuSL8IveOzKisGNv8X7FNP/fW33J7Di3Xj2TdMXDmqiH4Vr
	zJvciDpSl2PNCfPm6HJbZPOdgyni98YGiu8mycfH4r+Rh0nSUYrTyKi71p2BGkIR1outQ3XHQvg
	VvD8C2V9zx9OiT/d9N3LfwLvHqtYvmg0=
X-Gm-Gg: Acq92OG1iLQU3ade2kMWAwVGsZWxkQcjIu/zCFUkfG4hmOE91YQO5Pr1jOs9s2JsKdC
	/Zl2zMR8DpxQKQcf6c2gk28zscvuzTZ32X1sytT4i+fikQpv4rhIOmAqfaWqsfnMvqMMGK2FALn
	PMYEtt3nVrF5u9AkJm8Hinw42hFvoa+H2pbxglZkmyhP4PvWLBi5bMFHUzxhJThETnmqeftVVQc
	i8fJu7PSTRnnLqoWNpFz/GR5fJCRpXGF2GExBzu3qo5oGrfEZKuHMJUyFB119djuuLYD9BouCg3
	cfAQZCCXASkIZVwhdPO7OTsm2NwQWJWHtgROEww=
X-Received: by 2002:a05:6000:471e:b0:45d:3cbf:bdda with SMTP id
 ffacd0b85a97d-45d3cbfbe3amr3759439f8f.20.1778706609173; Wed, 13 May 2026
 14:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com> <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com> <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
 <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
In-Reply-To: <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 May 2026 14:09:58 -0700
X-Gm-Features: AVHnY4IP8DEacwhsvW6UMiUvn20aGQIjyCPvbowN-gskCg9d2oQuJyw6uFZbOMY
Message-ID: <CAKEwX=M=6AQVYA7ROM0YOP7irpxbdMrEOAHKGKYo0Qgr+-uhSw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DBE16180004
X-Rspamd-Server: rspam04
X-Stat-Signature: nh1sz3z5x454hp9gfyrpshffzu863n8u
X-HE-Tag: 1778706610-856386
X-HE-Meta: U2FsdGVkX19UVQbvqHI+2PDL/Yrrwb0dRz2dRd18Dkw0ZrtkSFUywxJZGdKO8xa3rTdKhZ0+kY+CR2Ivc0c+YjttEgCz4h9bpJkodyxS+ZmqUjR8dzY2oTyIMk7OZk8UsujA+iTiCuQKJofBnEsHZbi6YfrWkL1afpXRsZjoJaenq1MVE6/isnz8fbkFAF89HepznHa9gfCVvXkfsdc1/IiQ9IDc7l4Cz1iW8pmvckSGzN88G6ocGnYz5dCNEY+F3G5ljfKs7BpppR7OhzwIb1dAQlpLDRSj/RA9HQ1Y1VNBZRjb4+i4Ep9iycttUqPtJ0QbJ637dQXFaMPCe7YcutEzGkg0TgHcSQSdisEdX15E95j4WCcxrrea7qzjvjKzghBxY2mdz6DfIV+MYuBG9Htw5rmQyeYAj8vj7NgCiDkHvImfyB4ZpJ3TQr5jwBqd+O6KOC2L6/NMvYUdP27SmVVK8a1//DSBij/iOjl3DU8aB4fNWnXjSPwi9hzsKQrKZ7Xst5Yd5VrtDx51LBGLCdLJr0X8YQL/Et77WQI8VL25qWnHjldbeUrAvDaKUNy7c+/z51VS6TUL/5cLf9D9PsCvhPgv6jC3eMIGTP4tOf2fZ6q7UesRHj8RPm54dEF39h5xlyTNsmjSaaJQNMiYDjCExgWgZNnqjpWzIMH6LdrKBZrGAeOquh7suRgNXAlslhbaG8b2G6kZOvSe5jUwcPKCVuGkQgUElttcptReSxBGXnw9J+QO2yKiPs1W3CwCbj3mNFcrDqWdeIKtsZJWJ0eufRwBVs2eHhsFn6eIep1Eowbqr4Bp5VFQGDLXb+FlrlQWeR5dH5JIiQGhHzbKLwqxuTmVGAWG4QqW1VZMCWBbtoDYhnJf1IMYsujkc6Wibbr7unh0zebTrojoYwy77O8glWDdVdc+MQoJ5C/vLRwmrAbr+nVaeCFVgqmyTqBSZ5wNUPJXlfW7Ducwp9D
 Xhrl253+
 1mGRJp2QfMKLEbH25Pt3p6fy8B51TITXDITcNQuQtjNyhqVZUpkm5WXW1ZGmxOwhRZdQEWkq4m++E7JzfRWH6iYHzr4p4VRTcx0A/XT14JBgi/qoOBINQtkKMUHhfr4grmuOMbG3w/OVY3HmrFPTI8xrJTzqBpL4K4UJUzQPvxYEE+Ol+4LWiU5ePSBRhEvOWaPXgbNLIamOAS3qRs7GozbaQKiuaOD+Gz/DWDMphkimaYQwbZ4XhYkcwpqbICXTdBIf2+NSaHNmwiwQ9JH+mtqbslD1inGg9SlYP96TA0ibJGPxqpvwIQjR0vjWMJhTdJ2kkpiEfeVc74RwGUybm+B442+Vy48geCwpsoL3bmDvT+eqtS+fuRXI1OBPZz8lrDQ63n4r5eMZYFefQx1hgdKAb8/8aoVbQeQrs1+uE39zMBe87PDOwE6WIj3lpVfnIg6klczEiYvbhtWJVc4T2Xjo7u9uTEumwJIvtR7JaOghu4c5gl07WL+rMWp67vK/m2nSOVHlJofzxSgTESTc5WEYA82BRVRO3HYk/oBGRKEbCnrau34K90T6wvUwxj/88Hu0uGa87yd6jk7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 1:04=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/5/12 23:47, Nhat Pham wrote:
> > On Tue, May 12, 2026 at 2:32=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.co=
m> wrote:
> >>
> >>
> >>
> >> On 2026/5/12 03:57, Yosry Ahmed wrote:
> >>> On Mon, May 11, 2026 at 12:49=E2=80=AFPM Nhat Pham <nphamcs@gmail.com=
> wrote:
> >>>>
> >>>> On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail=
.com> wrote:
> >>>>>
> >>>>> From: Hao Jia <jiahao1@lixiang.com>
> >>>>>
> >>>>> Zswap currently writes back pages to backing swap devices reactivel=
y,
> >>>>> triggered either by memory pressure via the shrinker or by the pool
> >>>>> reaching its size limit. This reactive approach offers no precise
> >>>>> control over when writeback happens, which can disturb latency-sens=
itive
> >>>>> workloads, and it cannot direct writeback at a specific memory cgro=
up.
> >>>>> However, there are scenarios where users might want to proactively
> >>>>> write back cold pages from zswap to the backing swap device, for
> >>>>> example, to free up memory for other applications or to prepare for
> >>>>> upcoming memory-intensive workloads.
> >>>>>
> >>>>> Therefore, implement a proactive writeback mechanism for zswap by
> >>>>> adding a new cgroup interface file memory.zswap.proactive_writeback
> >>>>> within the memory controller.
> >>>>
> >>
> >> Thanks Nhat, Yosry =E2=80=94 let me address both comments together.
> >>
> >>>>
> >>>> We already have memory.reclaim, no? Would that not work to create
> >>>> headroom generally for your use case? Is there a reason why we are
> >>>> treating zswap memory as special here?
> >>>
> >>
> >> Apologies for the lack of detailed explanation in the patch descriptio=
n,
> >> which led to the confusion.
> >>
> >> While we are already utilizing memory.reclaim, it does not fully addre=
ss
> >> our requirements.
> >>
> >> Our deployment runs a userspace proactive reclaimer that drives
> >> memory.reclaim based on the system's runtime state (memory/CPU/IO
> >> pressure, refault rate, ...) and workload-specific
> >> policy. That first stage compresses cold anon pages into zswap. Entrie=
s
> >> that then remain in zswap past a policy-defined age threshold are
> >> considered "twice cold", and the reclaimer wants
> >> to write them back to the backing swap device at a moment of its own
> >> choosing, to further reclaim the DRAM still held by the compressed dat=
a.
> >>
> >> This is the "second-level offloading" pattern described in Meta's TMO
> >> paper [1]. zswap proactive writeback is what this series introduces to
> >> address that second-level offloading stage.
> >>
> >> [1] https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf
> >
> > Yeah that's what we've been trying to work on as well :) We are
> > working on a couple of improvements to the mechanism side of this path
> > (cc Alex) - hopefully it will help your use case too!
> >
> > Anyway, back to my original inquiry: I understand your use case. It's
> > pretty similar to our goal. What I'm not getting is why is
> > memory.reclaim (which you already use) not sufficient for zswap ->
> > disk swap offloading too?
> >
> > Zswap objects are organized into LRU and exposed to the shrinker
> > interface. Echo-ing to memory.reclaim should also offload some zswap
> > entries, correct? Are there still cold zswap entries that escape this,
> > somehow?
> >
>
> Yes, the memory.reclaim path does drive some zswap writeback, but
> it is not enough for our case.
>
> 1. For a memcg that has reached steady state (a common case being
> when memory.current is below the policy target), the userspace
> reclaimer may not invoke memory.reclaim on it for a long time,
> and so no second-level offloading happens through
> memory.reclaim. In this state we want
> memory.zswap.proactive_writeback to write back entries that
> have sat in zswap past an age threshold, to further reclaim
> the DRAM still held by the compressed data.
>
> 2. Even when memory.reclaim is running, the fraction of zswap
> residency that ends up reaching the backing swap device is
> still very small for many of our workloads, and the userspace
> reclaimer has no way to participate in or control the
> granularity of zswap writeback. So in our deployment we prefer
> to leave the zswap shrinker disabled, decouple LRU -> zswap
> from zswap -> swap, and use a dedicated proactive-writeback
> interface that lifts the writeback policy into userspace where
> it can evolve independently of the kernel.

I see. It's interesting - we've been dealing with the opposite
problems (reclaiming too much from zswap) that it's refreshing to see
the other end of the spectrum :) We should invest more into this to
see why we are not reclaiming enough, but I see the value of adding a
knob to hit zswap exclusively.

Regarding age-based reclaim, I agree with Yosry here. Let us try to
land an interface to do targeted reclaim on compressed memory first. I
do see the value of age information: with it, you can track zswap
entries ages and the distribution of refault ages, and only reclaim
the tail. However, I wonder if you can just build a system that adapt
the reclaim request size based on PSI, refault rate etc. similar to
how you're adjusting memory.reclaim on uncompressed memories with a
senpai-like system. Something along the line of - if we are swapping
in too much from disk (or if IO pressure is high), back off, and if
not, stealing a bit more from zswap pool (perhaps with a bigger step
size), etc. Is there a reason why zswap cannot adopt a similar
strategy?

