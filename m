Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEE8D66BA6
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BA36B0005; Wed, 17 Dec 2025 16:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F986B0089; Wed, 17 Dec 2025 16:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0D06B008A; Wed, 17 Dec 2025 16:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDF356B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:13:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D8928BAEB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:13:49 +0000 (UTC)
X-FDA: 84230214978.18.25D356A
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A55E18000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:13:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rI8mUMMU;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766006027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtGb0r/P6zEZ8trF9hUpub5gtg16/YJkxY5mix/dDUM=;
	b=a3LmAqQd5ebipyY0ftjYd0ACZf3hP/PlhoPiGkBWS8yqySKbqHjBzLbnh9dWSJjVLxyMG3
	v8ABDy2RkDg+z9C5a0bC03TR6S2Ofmu1NQ1RoqslL6u+FmfoofuQwETD6BM63HWzcYUkUX
	jIz/uuaSXNLIOCnc1X7KUfNboMlz3K0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rI8mUMMU;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766006027; a=rsa-sha256;
	cv=none;
	b=g7eigSBnOrbbHplvxY/bFmm/yToKTJu3F4QO6QoqERWRQ1pzhrhlk6pM6s+n7/2MvZVbL1
	PB+/PvLVEu4hYbgY+ase8HKsl6kB5dFmT2drNhqsG3Cp01AmcHgvyWs7RSgfJ+hoRL8drR
	yAJSdkfyb4YQ+Ar9M3j0nkaod0OnF7M=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b2d32b9777so913997185a.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766006026; x=1766610826; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RtGb0r/P6zEZ8trF9hUpub5gtg16/YJkxY5mix/dDUM=;
        b=rI8mUMMUbfD2qogD5Xp2PlX2889GAlqXQotvtsMynmnG4ar/MfYPFcUuE5XKtdBtCp
         L5mf3b07ijJ3KSSfF99Yvjj8EDE1m5oby6+mXkEA6Yrwyvdzvj2pDo4j4QMV1YmNSW7y
         A4s/n9FA2e2RcOvo76j0D0/FWTWj8g807EFMZoi5Xu6Epkt1fg1vAI+PPCmsEsq5lr8E
         gJsjcdTgVUTVAKz0FaH0lSpJvJ5S2HJ+xrsZpUjZzeyPPYNp41J+WUBwDtABGn4rrnzC
         GM3NItxObuCC5Uu7Jkd/iB3Xf2U0EqwEcXsxeyLgjUNNtxbCyVBpCRxHtkm4kv9bmYFJ
         4xMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006026; x=1766610826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RtGb0r/P6zEZ8trF9hUpub5gtg16/YJkxY5mix/dDUM=;
        b=Qkt5W2sGVqBfyEjL5rN8ei5nPbrpzeA/dOBQU6JGxdMpzhtp0yX2yv5pmn9gTIxYzR
         5a0++bmHuN/54IU52H4nGNZlyNuuNivEDQi4+LKI8GxDGhtMmgWZ4P9pzjNJuzG8itEJ
         RGE0sAyI/5P5cG0Zk7MueOk62epy46mUbmovCwX7b3SSb1bFpb34qZVcjoAuJbBthilK
         CLM26nMFxRKkWepUbvttqdZ7jEbKe0wsNZnekDgSMkmvmZV3d7oF8emNNJHXpF5A1KAt
         DRArsaEQAyGZSq9pF4uRFCCmv0io9JmjqxI+phlt69z9N+b38OAzsIonevWBhk8Av/6i
         2JZA==
X-Forwarded-Encrypted: i=1; AJvYcCVfUndOZhpCRoLQ15OT/Mq4mQAINj3kTyNuHXHIKnO9Mb+8ms8Mk9Ax9O+W/K3+JlAG/d9l68YtPQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6cQoiG1eJibdaJnBh2daUPPsrGMA+F/bamXxZOEC5FA47lBSW
	8lW9HAeOUTlhq4IIzjo0f4AzFKHZukwVAyvQAVf6DgOFf+K1b1Jdd5iy/20vJ5FJOqs=
X-Gm-Gg: AY/fxX5mfvzvjjyeqKVSw8Z5Sy/mPSfCm1Ao0cDYz6oJiozLC+UBiYi0GbWNkxM9tEU
	k14BntR7OONsP8uC4+H6FDFquktDP1UP9b2dglezSPlwgC5OzzWQy/bL71BPlpyERzqO4NP1GS0
	0cU8XnuyA1G42/1WgeGXG+b2kSkU3DQjSbq/guW55rDPGQng2VB8Wy3Jk/2Ln984WQ4ykP35J1w
	sdqWqMQGqiHngRH9xX423YNk3FfBIJRcOzONELHrF+kha5EI/AobFbqzyzqHqGNX/kGmlsERYKz
	zssLI2/mwuUAIrvgZJpt8qkRFjumXvGjCoL4tCDpXN9O0FRXUaPbaPBEnc8BZiwQuWpyw4eFLe5
	G3NXoi3XLuvSJCUYoBQGsmd9Jwcb+itXzkZQ3PKbH8WUN785BVDCYhQgeG2/73d2rHBzaE7l2R0
	ks4ZEwRjZw3g==
X-Google-Smtp-Source: AGHT+IET4L1o4h7gpr31cJq/0Bv9h1gq6eO5+hWYnncruBpcH76SMVyfZw1AptOE09FasXWhGUSOKg==
X-Received: by 2002:a05:620a:4116:b0:8b2:e402:20b4 with SMTP id af79cd13be357-8bb398d914bmr2946405485a.10.1766006026195;
        Wed, 17 Dec 2025 13:13:46 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb6e987asm28540285a.22.2025.12.17.13.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 13:13:45 -0800 (PST)
Date: Wed, 17 Dec 2025 16:13:44 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
Message-ID: <aUMdCIr9-rLrQi0X@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: f84ufjy1pfo3nzus31xu1uxq6jnoho3h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A55E18000B
X-HE-Tag: 1766006027-673374
X-HE-Meta: U2FsdGVkX19cUF3wJoJ3oTIUaGE50skfZnJRUEv7m5fNZOcpNM4HYKpUTLH7Raox+ApFRB7XJyr2KcH+upWDTh5md/HLSdqsI4smu4DaecQeqjk6/GSOFlqBRKmSvrhDjq3hV4m2fT8iWI/34IDlbPa2gFIm4apkRE95VtUlxFT62vz3KlcPvKyVT3uj2IplXGfxy/JVKSrfSIsbO4Om4ACCrVkwXfYmlc4B88wyh5nix9HClm8fXmUl9rDze5WvrbfdRZizOGa6uPQF9cv3Zou9yWroKRqDjLlg5zTdObqaRJe0N5fOFWanRR+JRnRbMG2DOsaCYw4bCeoE6xNYCMm/zhbKs+uJp4VrZOlWM7BXOF2mYFSG14HFQ2and0SbOG+ff0ASbA78TJgXdiQBhYuugyIfdkW4IaNra5Zyhx/eeSQOEF8yyXksj3f981JlcDVy+1L7ulg7n8o2x3mAPE7yHLwVmalRO4JiC41hrEX6BxCyORUkHV0bMbXKGmFuwBZwtG0qvYMbnTGPYkESJ8ML4dPbcwzxZqc3BLkeRWULxbK5QXSSih5TNMG5DVQ+ceF1jlA6RKr5PUlrHnktGZfipoyEDJOdF3TJe/O5W7kXoAiDy9f7doOOQdFFUu3/PY8dgRaCZQ+/FhxIwDEWbj8pY6COk5LNam6waWgEAPDb9WgcHVK1pBTEh4W5XocebePrEUGgJ2zpFL5pmKjVdrZil72vRumG9X88tiz+kgY63adiUYD7kXw+Q+OiPzUPElELQoGtrOSZ5k/0GLGjwlPBKQ1QJ8i2IoOrpHNiEGZAcQcCPY7d6Ob8gTKj+mBrh+mqtS5FxYaelNVbl9n42ipaxKsJmizek1WoWJTMa0LHYqAEdGDWIx1bJy4O0h2ABIxZiwXdcRg+6O08PgevVRdbTwUJtvMIGFjOpIHEnHaoTPKUMgjSF1g7BzAax2B5QD5BSTA/mp5lnO7HVRX
 Cf41qHX5
 EUPdqI5n7ko1M7UdR7pfEWSq7Dzn8P6cBm4lOCq74asjriuROv7DStXSFeFOYb4z/ToOgCSyTlwBZaEHgvnAEikQjRs0z9ucS4I/UxQIA5C1h8XOe7YXmnxWGKHSq4YSoW8dVpH5AvRfgDX0cEnhwwkgNKSM8mZsCzZCtUKfweO7L+xFKRBBW4UMY3VFOceOKbdXhkWfP3HTeJD1aUNgLGFgpWe9rZDS7YKZE2itoEakfsTtg99oycZxCqV8UuVSD2HqZet60cwIP9ce3y+dgmIRj/AMogxp4R8UTKwcMcXlKLZ038La7xZ960oUzmYvJHZ50c7JYSf0D/cULaJe9evp9hW43hLx01rOV7UnPVxF5RaRvtv1ySPn2V2JmqIV69gPeSGTjOUzWmfvUiqNe8jeybzcbA9M5jR5QqOHV1T3IdtTXTuHoIp6x8khS/JS4CftnE3XCguJP8zuZuzW5TZulxGffdMG1ZvQLCU8KzAiF3dKdeUsksZ50PdZLehX1RvhBM/wGMHx7rrIOIniauuEWumwgtgnHbmNCpPdkY+NVI2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:28PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> After refactoring the move_folios_to_lru(), its caller no longer needs to
> hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
> and __mod_node_page_state().
> 
> On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
> avoid using local_irq_disable() and reduce the critical section of
> disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
> count_vm_events() and mod_node_page_state().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

