Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A744606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AZpGlpev
Received: by kanga.kvack.org (Postfix)
	id D6C0F6B00EF; Wed, 18 Nov 2026 00:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CC06B05B0; Wed, 18 Nov 2026 00:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33D26B05B1; Wed, 18 Nov 2026 00:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0FF6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:38:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E892A82A6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:38:54 +0000 (UTC)
X-FDA: 85447135788.30.8B2A5BC
Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	by imf27.hostedemail.com (Postfix) with ESMTP id 329864000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:38:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZpGlpev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794980332;
	b=r5gDi0h0aQTaoD43BW4XZJQmeW5mEqi1zPdRB8nWaQFW81lfQE7H3pSzdrk5OXM0LSDO5v
	JzjBOSDGIlMuQfISRbJ/2Y6ns2eB8YW6aYZT4d7YiE0QijJEdSZ2lU2y56i64jDlIrm+TZ
	oP2uw+BUxoU/Fv+xPTPIysAnFNX2iHQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZpGlpev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794980332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPAqbowMtLzbIekB9EQTVpQCqoE4uZmeuAc0TOycEFk=;
	b=HCjwNRGoOKHwvyZK5rRIE9+Uo38HRQq4ZilZV/VhysF/t0dJ3QykuhenRDOOnjEckG8ruh
	S3B2qkdChtxGZkzD53ZgIv2HYSPYh15n+5nfY9P1nEjXHH56SIkSZVpQsH47otMKJ9Hkd+
	pSa+6o/JLRsRHOL3r7SY7FvoN0LNL9M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2FR8HM/p++ob46YeHJNL26wRuxeb82p19yKGmVM2grk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794980330; v=1; x=1795585130;
 b=AZpGlpevNzmKYFzyNrix7BV0m72pm7SAjYAoEEcUOGwPCwLzuNQLxjdPm5QF/VrNx1i+awcS
 8YDgkK/VPB4bRgMNfjE9HImHhyQizmcuTQQOJvlskVkVTdclFqYbF36Xs/00h/yQvwDObCPoOQm
 s7r2v/b/BameUUb3MzjmXQJU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 67d94c72d45337b4;
	Wed, 18 Nov 2026 05:38:50 +0000
X-Mizu-Trace-ID: 67d94c72d45337b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <6e73ae4b-5400-4f6d-bf5b-2892827ea144@linux.dev>
Date: Wed, 18 Nov 2026 13:38:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
To: Chris Down <chris@chrisdown.name>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>, Song Hu <husong@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
 <avzSkT9-jsCrMoeX@chrisdown.name>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <avzSkT9-jsCrMoeX@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a4r9qigidd9s5g99dr9ia85t4jsgscts
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 329864000A
X-HE-Tag: 1794980331-692050
X-HE-Meta: U2FsdGVkX1+weoNBEJTT9W5RITTWUHSlVklwCxnFGtNvJUSFcakRQABwtxMoSymtM4yZvRcwdivG6zdkIVPh6oWNSTvR2Omxyovj30NbZmnAUPAG9dhfxkrZ/Jr6JOoprJIHQj1ZLyT3ZGlCpgPtlgxDYdUgre2prIHwHnJNCQtBtUUJz4VQf4fUECPxmNIjSWAAf/WlOtTiK4NRfk09ubKLQ+w5A76Qk7AMQSXUxJO0hVApdtizWhcDoHvBUKERxL/1pvf2f1jKT2iuFjdRWfcqvh1KPbNa/zeTeNI8veppfyMUfpALlfQYGml4akefaRYP+kdrzqvtH5igOF446m9tSrVRBKGkcbhlPZcP+Coh1bRYR+dna4mfC/MmmRMuoEGtKzcdvGMFHWnwvld1m96vlMKJftfRXXzbvOoxSHZjfq4Xx+s+YMS6IqL0fIaeuxCUbztNw9ja/7b48P304Bfrmsv0lHBOp+Z4wCyL4yynAwYskX8i3hQlqbGHgjCkNCPxtk6e3wa803fR//ms44gaMHqIjpnMKmMx4W1Wrrr31DmaaoTHFRDaxpjyEu40QOWeCOsQbCvoscMCyOmGPjkZ4RbyTb0oK2OYE2XJsEGcxzMDYJP3RRBZ9CRgqEo88Wny666L7lJf30xJ3vpSUWn6LXxVpLgEopVELCTodNr19R0GZveIzMVDaj+qJfEG04fkhBFpfPCW+MhikGuw8LGjpai14e0zLxhVMatOJb/JR8CAI2m1XrcQ6z4gV3gSayi81FBivrPDUo7qu7ZiAqPU32fpgzaVdrUzj2/7Yz2T81JLptoLotCISblcQGvwWoVMn9xQb0X5I4httuf0rl90+D9NHegX3NIM2o8UUiGe4hlMP/vHWPV6NULYD+LQ/VXbJU7ilshPDCVRp4FWK7OU3KXGHb0G4MkIRgh+1DNa1UyppxXREpo4intfnFlFDAiihotzRnYaA/1k2a2
 IXM7fweT
 Pe2j6DxMcHxrh3nam9Im3zwTkef+11QK9GB8m0G9XeD3OifCOzgM70QM5o49dGz+0yIj6q5DMpy+auR4LPgCGCyecKrUS1tQHOcf2DFBNmx34xhGhFMSvWZn2b2gtljvdCL3d0fHc+wiP0QDJ104+T/Bbpmk6WsGw3VN04FBnNWmwAKfjLy54ayQOfyDurLytcVejNBRNLkH+P9K/fk2yIMqZ7fbObJ8zcSemDYpyYLBkicqD6Nh/NwJ7RxU9ITlcWQisUv3X8XUydiIAHKxGEaegMvDs+qPBEnRWObG84KAZtZ+mjcb1qtJLMJgOLElSq4a9l1FFIQfd0TnEmSyv4s0iudwybd9yIkpsJUWiqFj0yJqJ0xEl0Z5vcCk5AKaVbQXTJznpc3S7qDb5FTpli/v7lZUUP0C7G8Yj/9Y27VJIUK0na/6NNNAUgElhgA94Re0Wb+cvzya31zWX1yoMUnhPhbt61r4zk12ckSuJnzpaCh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/11/18 06:17, Chris Down:
> Hi Hui,
>
> Thanks for fixing these, I've verified that these fix the issues
> reported.
>
> That said, Zhang Jiao sent a fix for the same two problems a few weeks
> ago, and Johannes thought the overage cap there was a bit of a magic
> value, which we have plenty of in mm already, and I agree we shouldn't
> add more [1].
>
> Could you please coordinate so we don't have two patchsets doing the
> same thing?
>
> Chris
>
> [1] https://lore.kernel.org/all/auNrakxaET8qkuAn@cmpxchg.org/

Hi Chris, Joshua, Zhang Jiao,

Chris: thanks for the pointer, and apologies for the duplicate. I missed
Zhang Jiao's patch [1], and Song Hu's earlier report of the overflow, which
already proposed check_mul_overflow() [2]. I've added Zhang Jiao to the
thread so we can settle the coordination here rather than off-list.

You and Johannes are right about the cap. I've dropped
MEMCG_MAX_DELAY_OVERAGE and reworked 2/2 into the shape Johannes suggested,
with calculate_high_delay() and the caller's penalty_jiffies both in u64 so
the value is narrowed only after the caller's clamp. That also removes the
in-function min() from 1/2, which was undoing ff144e69f733 ("mm/memcg: move
penalty delay clamping out of calculate_high_delay()"). The series shrinks
from 19 insertions to 9.

Joshua: the Fixes tag is the right one, though I can see why the diff
suggested otherwise. The division comes from 0e4b01df8659; my patch only
touched that line to add the clamp. The bug is the reordering in
e26733e0d0ec, which replaced

     penalty_jiffies = ((u64)overage * overage * HZ)
         >> (MEMCG_DELAY_PRECISION_SHIFT + MEMCG_DELAY_SCALING_SHIFT);

with

     penalty_jiffies = max_overage * max_overage * HZ;
     penalty_jiffies >>= MEMCG_DELAY_PRECISION_SHIFT;
     penalty_jiffies >>= MEMCG_DELAY_SCALING_SHIFT;

Before that, the shift ran on the u64 temporary and the narrowing into
unsigned long happened afterwards. After it, the value is narrowed
first, so shifting it right by 34 always yields zero. The division plays
no part, and in v2 the diff no longer goes near it. Your other point is
settled by the same rework: with the clamp gone, the comment goes too.

How I'd like to proceed:

  - Zhang Jiao: would it be OK if I send the combined series? The overflow
    fix stays under your name and keeps your changelog, in the shape
    Johannes suggested, and I'd carry the 32-bit truncation alongside it in
    the same series. If you would rather send it yourself, or split it
    differently, say so and I'll follow.

  - Song Hu and I have been in touch off-list, and they are working in this
    area as well, so the patches under my name will carry them as
    Co-developed-by.

  - v2 will include what was missing before: a Fixes tag for each of the two
    regressions (e26733e0d0ec, v5.6, for the 32-bit truncation;
    0e4b01df8659, v5.4, for the overflow), Cc: stable, a changelog that says
    plainly that throttling was completely inert on 32-bit, and the wrap
    threshold corrected to about 130x at HZ=1000 -- the 4096x figure misses
    the HZ factor.

Two separate patches rather than one, because they are different
regressions with different lifetimes, which matters for the stable
backports.

One number that may be worth putting in the changelog: the smallest
exact-zero case is memory.high at one page with usage at 2049 pages, where
max_overage is exactly 2^31 and the product wraps to zero.

Thanks,
Hui

[1] 
https://lore.kernel.org/all/20261029073857.974-1-zhangjiao2@cmss.chinamobile.com/
[2] https://lore.kernel.org/all/20260818012115.65838-1-husong@kylinos.cn/


