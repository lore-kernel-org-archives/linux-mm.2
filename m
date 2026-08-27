Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C06C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06656B0088; Thu, 27 Aug 2026 03:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD2A6B008A; Thu, 27 Aug 2026 03:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2B06B0092; Thu, 27 Aug 2026 03:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60236B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:25:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B8D0140361
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:25:56 +0000 (UTC)
X-FDA: 85146215112.29.A4AEB4E
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3BA4FC0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:25:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YIORl3l8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787815554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqdYAE3DzNwx8Re7WzkaOLHuzM46BuJSDTWTl0D7N68=;
	b=KNpLNik8gTF86h0st1J0ZxuLgQd0ttGMOXM4At/liq2Y515lAPpCQ2+tJiydwJVt83B0iC
	hVLN1fQ5dEFFo0/doemNIQR45Km/4zl88l/HCXK8q9CnAgd576cjknF759lxD2oQVrq75j
	jkcJ2fYx9eCJXQuvB2bateZZ9FDaQVg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YIORl3l8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787815554;
	b=jn2ndWcxVebp65gCsuuzxez6zr90rMXvMTYW/Bk/lmtFxySiv7exrYfPEljS9zI/Or1g1z
	5Xk/EVyuHwJQZ0J1FO4CxxFisaaRJGhdtN1SR2RdSDIPefocb4RUIJHa0qJYs9hUHU+1mQ
	qDGI/Csy8zl95s2sy1NMQ9Fdi2A1l/0=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so3124074a12.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787815553; cv=none;
        d=google.com; s=arc-20260327;
        b=SvnwQtpOxlv+I9TBA4BEqbAP43vb0gYewigpxwkwyIDoEUgyqM/fxNdyXO8U+mYkg0
         o1MP6E/VzUPvtELxdoqcjLrpnrxf39hXMIMPCQKJhAE48r1UyF6nHnvHRM8ixs/TBJgM
         9Q/isTV6FVB4G0ph04OjEPnLL3pLc9iJeESe27gOmmwYp03sdtD7s18LA8Nn7wsTLp04
         t8miXCLefahjJzYN0FvICSqplkTptqWBNBqTdtjXH8nKrxSyOvc19a4jiYIcPPlv/o/q
         l0qlxWi06F4NRZ8NGapuWfvimBsdsxeLxsmIyX9gvHG53YNESnxF5ceWxVc8ygNXgGgF
         Fvaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nqdYAE3DzNwx8Re7WzkaOLHuzM46BuJSDTWTl0D7N68=;
        fh=uH/75jZtJOHdwRGo/iNw/gDa4JseRn8weqQoOR68YrQ=;
        b=S9u5TjkvZhIz1ONJB69Ip0rn03m5sE6DyPNYpx3ihkm6ttNq5rDGUqmqEyYlxm+PUc
         VG2X6k9lP8Co0EquSCJzKOF6Xw/IPi9U/JzopHop2aMD6HN1FntNblEkRtheus/PHaEX
         AAYUlFoV3wtyM9tblMR5uIrn23pfBM1dtfKDa9i29tkKkfqTmcBABqX60y8RnYJDwQXc
         zJGH0c6tC8KKhRuvReLfhRGBDXpoLQfdeqY7S/vwR21fLcwZyhWCwObIRsyJutN0C9Ot
         4V4QB+mBGdLZJMi7Sz3P2GqbFn+CFO9enKfVNB6lJNznJF8brIInGZne5uPfVnXo9x2G
         8bzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787815553; x=1788420353; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nqdYAE3DzNwx8Re7WzkaOLHuzM46BuJSDTWTl0D7N68=;
        b=YIORl3l8ALQ9/DBtOfPWpdVdztnFbPmkkPr7CMlm27VlT413/cGNrWHSIzKE8luptp
         ql5QG+qtY1DDmaukwN4BnLJuCwr6HTwTbGRi9Aqb4Yz6XIuzJlT61bd4vbGHdQyYKtjI
         yOqehSQvN1/L5WPqy9LfZ2hsCz5NEIFEdngJizd/F/5M+KeovbIAh6gDR9TnbO37XAwN
         WIA29XRMTlrrS+02IGGDL87vHxXk4WzSUJmPcrX3u9SNILQmHHdfC+dWV+XDZqN6vY0B
         x3KbbJVvbirXFUZyO1jkcHmx/cChuUNuFFoBlZANpOznMF6921qmBuAJCr/sYZIZOS1z
         PxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787815553; x=1788420353;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nqdYAE3DzNwx8Re7WzkaOLHuzM46BuJSDTWTl0D7N68=;
        b=l3do79gvvDXwZghZDc0JZKx8zbMonPmR6rhwadXbDdvb8dSMNMzyz0qNHfT81ewExy
         N8TDXahnTipPTbwayF+9yRcWUErjopQ7IuqjKhd9ZyC3m6flQpKapXM1Hf1iQZagkIxb
         RtOjCDzMuNzdgV5Hg0CTF+c3yhEfT6VHGCEXZJz6m1sEy4PnMBhOhBUHKFhkUoIcsDrs
         /FaRsYbXh46H+GOb9xrSf8vdOMhE7zsqT8L89CLikThyUriYOaVBBKb0PfUw15O85VU9
         i5dgf4v+vpHcPBwmK4/9TXseL7pI5bZmDpbN6UsJYCkf5AZ5mJr4LTRBogj3z7lH5kDV
         rpNw==
X-Forwarded-Encrypted: i=1; AHgh+RrYTMP6RHYxS0AL3B/AkbnR1sm7N8fKd5o6HToKRVHx15PiYQwPLFkp19++yD0oVN66E0Ywfy9aKw==@kvack.org
X-Gm-Message-State: AFuF++lYNLulAa2704FgICP1xsGS1t9WNFKvDhe54yDFdwaO4QfQBwHp
	lXipGyq16Q3LfDaJJdE9qkccN9vD2gORn+hD8pyIegCSy54EZfB2CVoicv36szt+TbuYkQ4a/Li
	xpISSGmeLdy0AI3890biokuKl1+s2njM=
X-Gm-Gg: AR+sD12tm3HTZ9Td97kmRS2gvW5EbPHP8qioifw6XdJ06tult8zFKxiCE0FMrN2lWBU
	8qGJGTu6KnauJGqW6FWpKnjnbe1ngfXnURUYoZmOkOevWnq5NJJlEpEILUv1mwTgY2aisapE4u3
	XGIzGu6hGcR38Yp017fi3HfRxfT9fzqYrLhgLgHssz3pu+9ye7froytOdihpyIeMVRvIslhlQ8g
	izzI5mCl+HVnPzhsHBEizxOXU6DuKGsHijXZ+oA92a5IrqvSqe7wfCqwyjOZDRINSxitOGeLtuh
	V1+ZTsI+LCDKLMVzlnGDa+fe+ab2Y/VicoubcxxhQ9WqCj+xwIJzcWjE2aTJBKlCjIzM8nYFq2w
	VG8VLmLU+fuI=
X-Received: by 2002:a05:6402:4508:b0:6a1:f895:1ba with SMTP id
 4fb4d7f45d1cf-6a5df66c303mr12950074a12.12.1787815552468; Thu, 27 Aug 2026
 00:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
 <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com> <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
 <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com> <70133332-966f-4bd2-99da-cfc5ad5fb6b6@linux.alibaba.com>
In-Reply-To: <70133332-966f-4bd2-99da-cfc5ad5fb6b6@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 15:25:15 +0800
X-Gm-Features: AcwNN1XzEIBdrYx_8QnqfHlcDN8ximssQJ-i7s0PfqTykhhYNXebXL6gRC8BgT4
Message-ID: <CAMgjq7DudvXYMLD_1hnbK3ivPY0j6jUiO9b0JWdRg24B8vA7VA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm <linux-mm@kvack.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Ridong Chen <chenridong@xiaomi.com>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Lian Wang <lianux.mm@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, lyugaofei@xiaomi.com, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Stevens <stevensd@chromium.org>, 
	wangzicheng <wangzicheng@honor.com>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r7m5qd1py1zyadc4hc3noz36rxmxrszf
X-Rspamd-Queue-Id: 3BA4FC0003
X-HE-Tag: 1787815554-336866
X-HE-Meta: U2FsdGVkX19lVHFQYm7ShRi/lssONKSN4aVbm35kGG5OlJdu1iLYkQ54tYzUxQ1sWJs6sWHiF4SOPSuUfFFSxNAgKjEyunsyBNyWExJtpIEIRq/hGZdgskjENtAKbGS5qX8OtTqoqEh+c44vpS4DE8V0BBdgkB25iEcMkltFuJAZM5iQPdbFgPAP6agXUUccySgXDX10p6FSf3w1Mi1bJ2MhWDYyd1LA9PMfw8IDUAK+kuPE+VMhVKyZZm/gPP1RyAUtYOczVuiuhtz5XTOkV1zuXIq7Axj9R5QTXcOlklISkCX4UobOj/7DHLgexIYHJDM5EnfJWB7lY8J643aBy2Hf69lybcGQHYBbSijuzs1k8iXae6E8Fr65pwaFoBdajeM5HKQ1anTNqHxaw3Yn9+sNQ5WFGYSTABwMN5wLz3lrGhLMRYNGlvFCY7s8qdyVRU2wpdxQye1Pvdcwnn7nQWI150FdIZza2T2xWcMIUpw0arw7b2XZC9j9+uuz/J4CSHueHLtG5F9wwLmMOj/u2gP5eH9OF7a7FfafkpvHXuahStKMQogfyiyhcYl8J/6aTDB5F2bmIAMufMiPvzojz4iz9qC6O6PCLkZSxESgsShxzwGyAPR+jNH6m1SGqMj+wzoZvJYPL4F1+bXCV7Q7rfpXpqc1WvohGU5WpvyhTc4G5iKOQKr6Ou0wZrIj1U6wUYq8lXpMeJ3AiFjHfdc4nmDFRuTHYX3ohbKuMid4v44T74zjEhjxah6uqn9tcySY8DJhpTKqQh1UliuY1Vrwaog75Kp2PFO1fNDP0k+bK9n9AddA0oQOjG4vw+kqoAUPDSZQ1XGN/z/c3JdAebhD1IbGzMRcaSrrVyCjR4vhyjecpDQwDqtR4gS87TPpxP46YLzl7x7eCg3DBm/daX+ylIoYBoFCIRuVMtIYRPmhDVhK2lMHVMUqbaTuM3uVFf95cNRonHUHLGgvPGfR7uc
 XMne1YAh
 w403Zr71MVQNy4/BNTMSHzDKCCH4y7seJqHzkVTpkwa/t+LGe7WwzQmBpaoEm39udGe6p5mDyzCMg7OQdHzgSaUS3t9JrKi9oEffTqym5cJMe/Bp85zDMBAJ/CmdGpy56N98IxK7uBHlYMG+diBVH/sAo4/RqPKGrjDqLCf8PQU88katzhtTrcty+nCuJQ4cF8GxF4jvui/g5ZnFc7ZNEc1OCIxL5aEfbKQa1UageO5TdOlqbuLYNvHBjTLRtDMcSftH8bCProrUJd1roDF/LrJ9dKsGpSERHhbPA5WGDBZvwxJoovMd0AEWEm9dp1HHFwObA/X3hLROHyd35GE/NNKKOjgOSZpehS6Wjj5m3JD4vc+K5OCgunGycGOQTlX18e50ntp/I98567Ryk6bAE774+foR0vxPoB8pykbdJYEuZRFAbZS5/gvezY19vocSMy1MKX4xlSOKCkIPtRoENk3HV6ccRj2c69EPU3TbTB7TdTu5XokVBF8UnE/eSRog3QeMD3W6zPH52d17TezcRBaigIF11mV5yRB9rEdt+FWRV2maOK83D5McXmP7Kg42WjWtb4Kfd57gYP91eWB+uiBuv6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 2:21=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> With the above changes, I can also reproduce the slight regression with
> NVMe swap (set swappiness =3D 100) mentioned by Kairui (but the zram case
> still looks good):
>
> Before:
> sys: 757
> refault_anon 5554715
> refault_file 3867998
>
> After:
> sys: 765
> refault_anon 5791349
> refault_file 3939552
>

...

>
> Thanks Kairui for your data and anylysis.
>
> I mostly agree. But on whether we should fallback more, I still prefer
> Barry's idea. The current patch might be a bit too aggressive, cause it
> only fallback to another type when the oldest generation is fully
> exhausted. I've always felt that falling back too easily doesn't really
> respect the PID's choice.
>
> Of course, there's also the concern you raised about the limitation in
> try_to_inc_min_seq() when updating the min_seq. I think we can address
> that together later, so that we respect the PID's choice (i.e., try the
> reclaimed type as much as possible) without ending up with a tailing
> draining generation that blocks aging. That may not be simple, though.

Actually in the long term I think we should get away from the PID
rather than respect it more for eviction choice :), and use a actual
calculation that respects swappiness and IO cost (we can still use
the data collected by it though).

There is another series form Barry (and the clean up here is extracted from=
 it):
https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/

To achieve reasonable swappiness following the PID and aging
protection idea, we will inevitably increase overhead, and PID is
really bad at protecting the cache anyway.

PID controllers generally correct long-term linear statistic well, but
they aren't well-suited to reacting to abrupt workload changes. While
MM workloads are full of such bursts and phase changes. What's worse
the design aggregates folios into tiers based on access, and the
limited high tier means folios staying in the same high tier can have
dramatically different access behaviors.

I think PID still makes sense as a long-term reference: it can correct
cross-generation behavior over time, but relying on it as the primary
mechanism for for single type eviction or protection is problematic.
In my view, this is also one of the major limitations that has made
MGLRU difficult to generalize across a wide range of workloads.

See: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@t=
encent.com/,
by softening PID protection (still used, just with a much lower
factor) and using FG protection, zipf and real workloads gets a much
higher hit rate (much higher than 10%, and dramatically better in many
cases, the basic 10% gain is end-to-end gain diluted by the overall
cost).

So in the long term I think: For promotion, we will use FG; for
eviction (the issue being patched here and in that Barry's other
patch), we will respect swappiness & IO cost based scan budget
calculation. Currently, the IO cost is just the refault count, which
seems fine, this is similar to classical LRU, but ignores scan cost
because MGLRU's scan is special, full of lazy-promoted folios that
already offset the scan budget well. PID can stay to catch long term
characteristics, at a weaker factor.

(BTW I know that PID have a way to be more adaptive to bursts;
however, that's really hard to tune for MM, and doesn't fix the long
time cold folio stay in same high tier issue).

Maybe I'll just post a series soon for the eviction part.

>
> Anyway, personally I'd prefer to keep the original code until more
> impact investigation is done.
>
> Just my 2 cents.

No problem, I'm OK with this change for now.

