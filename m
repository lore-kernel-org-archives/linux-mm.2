Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD8FE98FA6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 04:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A55C6B0005; Thu,  9 Apr 2026 00:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F356B0088; Thu,  9 Apr 2026 00:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6B86B008A; Thu,  9 Apr 2026 00:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68E626B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:07:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F20F1B78A4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:07:58 +0000 (UTC)
X-FDA: 84637684236.01.718528A
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 50D41160006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:07:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c644hdmN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775707676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=LAVFMhISX71mA6gdtT79bgsvTIDHJN01ntSn6nTznYc=;
	b=PyXBKy+Qp+cOSEe6TWX53HlV7bkoCLGSgdvlyouynKy0YqFNz6yTw6yUCv0YrC55j2unO9
	FOVaafHop7zmVuxMj3dtp9gG3CDA3XjV3j0RQszQASF9tFnnVoTocGQUYcvGcH1j1j2LcJ
	U8zQ+gdBHCBoCJnBxZCt0l/iSQOuUgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775707676; a=rsa-sha256;
	cv=none;
	b=x4qQU2qcCuAw9FrJ1kpL+QUEUXJsLavyTlKHx+qEbRo0pnaNcH6deiBm9fQ5m4wzk6itkV
	viS0Csn0oZ6Q2ZblCiceRAEwuj4ypldr6N6FYPfzluwahlHwTnj/2zRa+miTy1WVKJOQhj
	GrZXIVB2/TvubI6xbS/me5Sa8AYnJmg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c644hdmN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35c238f1063so387958a91.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 21:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775707675; x=1776312475; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LAVFMhISX71mA6gdtT79bgsvTIDHJN01ntSn6nTznYc=;
        b=c644hdmN7zMDkQbm4jbda+vhSJ67/bkaEG9fikCf1cZSC2WuQuXEHbZ7WLWa9NGhKz
         q8tyRsjno6P4C7o1hPAYBIvKF0eQx0exzCAMeqLvkvWXEtKSTIjNG/G8JX4ADmsGjAoG
         V+olvZ6HaA6itcGpZ1iICodgYvan0/KTTJfcNpKYW3rUevAM8yjA3RDTe++qqdpE923x
         LDk2SMNdSZm2E4olrtqgLPhuX0OW2Gsbvye9tvsQGdtxUuIt5bjeVjV/XjiXS3vcNiMn
         MbTAS0gaG2Hb7XdXcjQ85TrmTJjLItEqt1vB5NOX+661cvwH3okPLcZ96ELBpy03Pjmr
         ahoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775707675; x=1776312475;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAVFMhISX71mA6gdtT79bgsvTIDHJN01ntSn6nTznYc=;
        b=N4NMHeRQctyI46jNPkEl7fIc0r3S8V1co5RtguLapb94slxy3TzocWHmoTPvN442l2
         6rybk8IPgImHFm6DuD56yHTbszUJn4l+xWfJZI0RG5W03sQOlqKjvOlaJQfGAvqhjy5c
         Z3fSFwL3IZV+/R6H/YrCp2dQqNLPHRUJy3brX7WzmTmiv8OuI8wHRezb6VIQKpRHiNsU
         sp/o0DqgUrz6RM9R2b8gFa2I2dLsgqKJQ4UTG8jnCbAyGI71p2zqxvcomV5EJK2jzqxa
         QpNkFg2c4eV3aIvIGLxHYw7Yvz7tQrTqs8FAHnNKBKz3IuxJhLcG8c/iG4BPycwHt+RY
         /ueQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFAsqY0Wg0aHepdT1m8eOq583la51AJy1IBSaa5aKjdWg9Fb6UuhXT9IgN//bYDEKZjuIzgNs0CA==@kvack.org
X-Gm-Message-State: AOJu0Yz9evu84z6EgRHWxa3o6JRcWgRyw9w8QzaFI1TeHqr2JL94FA+8
	aBRn1WIdX3BgW4H9tBFqrwMItRs5TCCequcLJdN3kwsL9d6mX1K09iDN
X-Gm-Gg: AeBDieuVR1UtfLh9ExDkHzEDc86+07y65pt93aRrIK69jsKz8H1t40BVozLaxzGlHk7
	d/I/NpKVlcYcvfDm8VqWYzeOdZdKFYfQsu3lI2ywmu54GgaDn9K1VYXRmx3Vdw0/UscSJF8nW3P
	A/nyYOTvmFKg6HJU+Jh4p8OFFdSody3ArmEK2ShU4yRDdg0CGEMJ8hECfsnuDEL5/CBXzi7TEFU
	l9dgUrVnH5bhEwqYfqPdJIpUnHUVK+JnWBS20G7WkAMMA/Hj8GWwFaeCyQUKd5s6JpxkALOf3Tl
	Swcj+QXpvnATBQgApMOaAl5c7CdM1gRsiXbKFD8PyEV+P9Zlrn/B1UIbkHTRIHTPjDLVFgCjRK8
	wskdF0ZPy7gZV1D7U7DiDNVKE+y5+EqVEHtZ1agYJatcJ3iPW8CBUOHN7DMrWdx/6D3GzQmLicU
	FcEcrtBMVXwvoARMe90RKf4w==
X-Received: by 2002:a17:90b:4c90:b0:35b:e690:c5ad with SMTP id 98e67ed59e1d1-35e359a5e4cmr1974770a91.25.1775707675088;
        Wed, 08 Apr 2026 21:07:55 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e3517f2a0sm1658684a91.17.2026.04.08.21.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 21:07:54 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>, Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <huang.ying.caritas@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <877bqgvs4k.fsf@DESKTOP-5N7EMDA>
Date: Thu, 09 Apr 2026 09:12:56 +0530
Message-ID: <se94lry7.ritesh.list@gmail.com>
References: <20260323094849.3903-1-donettom@linux.ibm.com> <87wlyqt52m.fsf@DESKTOP-5N7EMDA> <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com> <87o6k1ubg4.fsf@DESKTOP-5N7EMDA> <bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com> <877bqgvs4k.fsf@DESKTOP-5N7EMDA>
X-Rspamd-Queue-Id: 50D41160006
X-Stat-Signature: 7z4yoky341udbyuciygqtuyk3fb7yius
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775707676-1765
X-HE-Meta: U2FsdGVkX1+a14IiUIsu2hVBCTIZGilwpXkgPcRpK2JkBSbyyPnyvBHRW4+YyvhdmYDyQd4d4B1j+OdmiFpvVatBlALRvLC00RxW5hDH3hh9HVvunnAueWiO4QtG6VrfHik1hnbKrRHtLuTKfHGNrRM4MDK5SCRj4eekkywULgnTMgHBQ/i7v48upeWRvnECCZHKbwe6/qnopLUeqZPzM5dWjaxN/S86KxyJFhmUsrQUvtW3RaNnkpxLF/CPAE7Y7GfpkkTKyHJ8cS+oWeJFpKEuRgJdxVD+WXA4mw0OS9RzICWCYOkIHPK0+uUQm3Ebn7FEMgLyC8/ugKO1PbW6Gb0AywSH541XbHboZa1s8aFqOdo1HRT1XYiiyehAzwos3ehW+7fMD0SEyw/vfp7RIMSSgalU4nXqj4l4F6Jc6vfOWO/DOFBkibW5sE+qGLQvWnjtEpWoWabYx+2qpB4W9+ScwsTU8zamReUNJ36OXoeEWEPLqV/5Xr3fkb6Vhy4xrYwaFpdgKZ7Du75dvChMGfDMeNMTUc3AWHUeius7JFBVhRSPvsXVxxBUFLLy9z1bGd5JMVqbkarSYw84LnkJPA6+8vU9wlV2rXI8kkSSK4VDzzD9jwK+1p1WJFTvcGushPw5TBATuQL34NyRRyvMBTyFErQvpDHYWws7G6WXrtlhbToBF8I6alUhLvpWhqDUgqClvgNMc/YGUc1nVcK1ss06+1GPvTc5Lm9XN9ldErCMG23uyoXSxWDh/k7xW02VBVYz4U5hj2db+F8i1T7bal0tJxO451xPaPgWPcEwryrv7lvuwLTVhXev4Ryv21i8kDkfLcSqSy8NTUlwxeiP2mYNnzD46j2oh4k31ar6c7Pbxg9STEKjrvfZdATXpQJEeskXK8bVyjvwg3AQ7/ej+94xmdUITTB1ubov9/twyceFgqGGJCyG2SLvHowt89aV8/gprkv1X5azSHDV+FV
 THSO+U8b
 BIjEM4ww2OYnmE016ytJiAeTHC9I9gLWLGgzGQVQps/MUgyoud2LSQkyS6QVvpa0PoUL7cRot3QKqYQCXm1jihnerczfjE3V2D1WTFmLWeEQz1nXhmlsaYy8lfjPDX1hGvp/7oLOfqVR4uaU1c1w/P9Sizjs27gUSEE6B9KI75Ow0/hfzKP4Xlvh93Rbz+idV2FQOHfGZm0n1V2niJy8bPaSft8PpQarl7SHrE/UD/WjmaWHnlOucxW9Ce0lXolFtZSESk8FPng5PhfNOTOXUFqHtZcDecQtoepl6pmgAq3unc9rW+VaejDzpo4+p1Ka3AWjBuz+QJ33ETKuB7FVd3qaP8X36PKC9KWAAV1g8VD6e/F1MsTmh+w8fKp7cWzDeT7ifICgW7p2l769nm5CYxGIya2jc3Eb8dvLz20aisIX8LdRqtoxJ5bInv2ZZhH2QmiYnhphuA2UDkAi2nURX4R95q9WdUGL4yoj0HRhvSbaG9ILLgl14njveiVnUpZ2s4luGLtPr3U9rRolDjG4AVJabpgpz1h1llyEZpuDmDV5QJb1GsxSCa/3XRXN+xmBgIWZYgx1ZSSZ4eOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:

>>>>> Donet Tom <donettom@linux.ibm.com> writes:
>>
>>
>> Thanks for the clarification. I was running some experiments where I
>> only required migration, not promotion. However, I observed that
>> promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING
>> was disabled, which led me to believe it might be a bug, so I reported
>> it.
>>
>> As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and
>> NUMA_BALANCING_NORMAL results in both promotion and migration. Given
>> this, do you see any concerns with modifying the behavior of
>> NUMA_BALANCING_NORMAL?
>>
>> With this patch, we would have better control over enabling and
>> disabling promotion independently. I would appreciate your thoughts on
>> this.
>
> IIUC, we change the existing user visible behavior only with strong
> enough practical reason.

So what I understood from this discussion so far is, we don't have any
mechanism to do auto-numa base page migration between DRAM -to- DRAM w/o
triggering promotions too from a lower tiers to higher tiers.

... This to me sounds more like a broken interface.

> If so, making something conceptually better isn't enough for that.
>

I think Donet's approach was more towards fixing the problem, then
making it conceptually better. So, as of now most of us may not see this
as a problem, since not many systems have different memory tiers
attached. But with more widespread CXL adoption and more memory tiers in
the system, we might require more finer control over auto-numa based
page migration.


But hey, I just wanted to voice out my opinion here. If we think
changing user visible behavior is going to break existing applications
and we don't want that - then in that case the reasoning sounds ok to
me.


> ---
> Best Regards,
> Huang, Ying

Thanks for your feedback!

-ritesh

