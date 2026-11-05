Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4647A606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SI3iPrAe
Received: by kanga.kvack.org (Postfix)
	id 68B296B05BB; Thu,  5 Nov 2026 11:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662676B05BC; Thu,  5 Nov 2026 11:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578146B05BD; Thu,  5 Nov 2026 11:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33EAC6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:53:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C53C740BB4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:53:09 +0000 (UTC)
X-FDA: 85401660498.27.45664D5
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1F304A000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:53:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SI3iPrAe;
	spf=pass (imf15.hostedemail.com: domain of 3crTsagwKCOsPUeVfjVfRZNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--chriswiseman.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3crTsagwKCOsPUeVfjVfRZNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUR1yw/NzCt/ibiVDN/9/OoN1Hg4UhV1CJmzmryBLQU=;
	b=tvxx/LVEDNeRn7HJ6sd0FEMyg2CgiK9IDZDgQ/8zpTXRW8UQU3NrjisU9GhsCflr9ltcCb
	uCBwR5HYVxEH6CmgFsmKmFgrwB7LADK4JRSLs4l+qo0Pxzrbmcs0fYV2dhpOgIf/0GsQUf
	EhvurSYwh9CzCy5gf6rUUE5gOl/SbSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897588;
	b=VxVdEPiLaH91KfzZ83XLq3gma5YC9gW9l9NQALvsNYfgC3TOdVWPtsZNpjuZ1Dd1xEnAla
	Fg5OivSYneSwIgseN3o8421bBQW6TlKZC88G6bctwQAMAAsKD9h/mbrj0PRSak10pEj+Z1
	U0Gz/QSt1APWj1DYG9EaZlg7q7B9Rgw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SI3iPrAe;
	spf=pass (imf15.hostedemail.com: domain of 3crTsagwKCOsPUeVfjVfRZNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--chriswiseman.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3crTsagwKCOsPUeVfjVfRZNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36ecd5db581so240189eec.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793897587; x=1794502387; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WUR1yw/NzCt/ibiVDN/9/OoN1Hg4UhV1CJmzmryBLQU=;
        b=SI3iPrAeYOLgWWbK9sRXA82MddU+N8957ynad/AvIC6qf6Ae7fLoIpBI7KzPbBUUJP
         1T274KDVfqezlI3rRNr3FEMh2Dw2hYvF64PRBUyNIO0HqIuYo+8E4ygGpiUtArcbIT/g
         HniI5sN40oM71L8LdxPWjtPT27ZL9jg9SWi/DMOcQchg79BudEN5kYt+C1IlnU7T8sen
         L4VhO81ybAarLbJkjn/WHHkoeDh0vWCyVUSGioydQR25GUfbjlcTHw3wkFRYoRZBJYGB
         PVzmjpFXXn9E+OBnQT15jI5L/T1nyh7acLxmurrMTCvFqiX4mxbVE7KOEYzUyRoapOua
         CSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793897587; x=1794502387;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WUR1yw/NzCt/ibiVDN/9/OoN1Hg4UhV1CJmzmryBLQU=;
        b=xSvVXYfm2l98B3a9VZX5HCrrzN1iGTLmpYVlvLocSBLPYHNIqusgcad64iIiLs/5Eb
         T6DnkxmViXT1nnU0NXhUC0vgDF9iYVeB6zkCKHOFxPTXaH4/wrRwYqLifrGH2ITMtKon
         Fz6RvtCKhbZN6DE2ZpLY9Bqp8TxAIu9zmOu5nFNpdGLSoCSJGjT9BZBc+LQF6jWt71XB
         JlCkH5pT3+p28mCS1AcTIFfP++jKl3symhiH0krG7imm2CfBulezBOTX7o5SD4AX/3Gk
         ETb+l5IK+g2d0BQYk1auh/aMr8Dop/26THVz/+AvWY3zxNS2cs9Tlynrc86b6rA4Q3yF
         8KOA==
X-Forwarded-Encrypted: i=1; AKwUvByIuqpB+8xK81xHbt9ux6K9RXMSH+NQAk5Km1MSUAsmY0FcQ57+BKC6kwZXRHJrDALiUYQ3moQOZg==@kvack.org
X-Gm-Message-State: APuU4Z/8EQAHe4dvk4SHMyJd2afMmK8gcgRBtleSupHjjssMCMbH4f/7
	p4fDL9dD46rwfQKuDiLLvXBb56o+Rts/CWcMax4Kn53AY0FnbQ+4vkGn+atb3udK494nu0k9M0u
	e1XIm7xbD3QvhbHJ2/wLbEtKzn2gkiQ==
X-Received: from dyad26.prod.google.com ([2002:a05:693c:835a:b0:36a:de0:d28a])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:fd14:b0:36c:cd7a:dd8d with SMTP id 5a478bee46e88-36ccd7ae336mr7157275eec.20.1793897586257;
 Thu, 05 Nov 2026 08:53:06 -0800 (PST)
Date: Thu, 05 Nov 2026 16:53:05 +0000
In-Reply-To: <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com> <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
Message-ID: <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c4znu5ja7awqurdp895xdj9ktx9qi1g1
X-Rspamd-Queue-Id: 1F304A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793897587-79994
X-HE-Meta: U2FsdGVkX18F+RodVHdnSdiJ8KdAe/R6roCHMP7GTvQrS/9aaxHZSRVOB+4UJATZkMzWEAsCcyxNs/Ay9hzCPEzRveMrKPl3qDRzp+PDPFbUD50Y7muqMyd6ncwFWanxxHI9QL1chP4dEGvJFbUeZF/qAf2WAtQOu0Xn/cr1mMVeXh0bosSuNTKsOZVuNZ7OySMzeIAoElP9n2Gy46IRq7oFuyfMoveeezsWg441MZdjdiaznf3jIBdNHcX0tNHPMQ+gsbCyYe14P3Lx9tzZxaFf82YaFXqBigooWQqOR30Ff7V0r8XWIowMuwcId/TlSjlQT7fHG25473353DDcefa9xOZYmmY8nMMYrGKZKotksvgoAz6QfIy3igr/bgOmiHRp6wQp1zzjeMjFJ71FbkFjFMDEfXLLQNEWDWv0wxkQDWHsoJI9HZAP14VJRJXglbYETE72OXv1OI+xA4QObL3zL5pnjmY7877r/0BQSk7KelCeftC3kSXftHNTb0QyEMchbSTyMnThMvOJrrBj9kefBZCE9N58DKqrPYQ6cPOjoB5p/TEK4AEY9BytlEaMB/YQ+x+EcdFjtivOLYSLENIjFlSDAzfYct7THlmIKl7AQGFeBzfV5VKxrxht6NazhD+fKxn8Sijms2N5YCvDRaH2JjCJc4/I+kmwMQpQw+JXU2CiXcy7ZzrnpuANduY6SL1d+NKnf6FQ2x9cV5mUZL2lD63g56jLI/RSFeZlJ/rcRM6EFf7d+fsBXlmfkvR/DwtPDsEm3F6b6Ginp8jhtLbDO/fQgjKdi7zl5vPXpkBJyt9tFkCkK4iqHj5u6Z5si1lBpxtyuZozpaTcVm5FLT7EAbx5Y2Bls4ipwKQdR/gNdVWQPHkjws2NpQw+yioHXyZTAhxr4RWFdy/Rjq5A1jicfeuhbW4qj8yI2QnCD4sOHJYz5vtUreRF6D3xfw+/B/j6tS5pyrbHbcnCf0K
 Aq8/KXqG
 ga06J0DdzjsBiu2cq0U0EHZiNRRStHKQyFUzDn8q2VDW8hnFZJA+r28fT6Eo2jLJfWxXF2cRtyNPtE1IAjIUVQD25J+xghnF2aypr8FE+yOzr88YRusy/P+A1s/posrJz4we6vBq+4zgRWI32k5WQtHaYNfvTjfZW3ixQocPD3pD6Z77t+oozjwrpf6oH1oLqlWlO2sZCmfZ+GVmoaXggisOYzyDnnJHddZwC8AVvRTgaXASBAk70zdgJRqjHwDFPunInIBqSlc5D3Ha8C0rntCLQ8c2jQE6Q+b9oKGo7M77eJpR3ndlkvyMXgGJMUG8BVw/xDy87VkWKUYkncaxjxhz2R7Kv3kVU/8nA+a3TcFWbE9sAYl5CE+xhLmokpB6ANLs0WlbDsVU6B3kxAt0fVEWt3ZUmkO2iGkWgiYuE1TlJzejHXsXJWzwbSsgozWklAmg9M/Na71wP7kW2LTosKvSEqz49WKVP8ZjeXu7HLLJsLpr9sNro6kGJYjAkeTQVS89+tAGpTIJJB3wdxCbCQi1TxDIWVaP5kMBWmUOkyWpgPWVscdOxER2FAvSdrsUYRQq+JfQqSeyB/9zXJTKrlomWXSp+e0oMC/VKPjVrhHXWF/lM7+XLfjmGGoz/fex/B22hNfO+u7wiLl5O6nREzqIKl92NB1qq5y/lKWZgASacdH8GIfoYar2t6vSHZYu528fUy57XSzrqVypgxbSROTQEEJ++q8miiUlzsbsJAZVmhiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 7:40 AM Yosry Ahmed <yosry@kernel.org> wrote:
>
> Never mind the compaction argument, this is just to move zsmalloc
> pages around, it doesn't help with internal fragmentation. -ENOCOFFEE.
>
> I still think we should check if the zsmalloc shrinker actually helps
> zswap or not tho!

I ran a quick test with zswap turned on to check.

Yosry is right - as long as new pages are swapping out, zswap naturally
refills the freed slots on its own.  Both runs ended up at the exact
same 95 MB pool size, and turning the zsmalloc shrinker off cut page
fault latency by 26% because reclaim isn't fighting itself for the same
locks.

The only time the shrinker actually saved memory in zswap (~20.8 MB) was
when I blocked new swap-outs completely after punching holes, since
zswap doesn't have a manual sysfs compact knob like zram.

ARM64 QEMU (Linux 7.3.0+, 4 vCPUs, zswap lz4):
                             Shrinker ON    Shrinker OFF
Active swap-out pool size:      95.9 MB         95.1 MB
Active swap-out p50 fault:     3,262 us        2,414 us  (-26%)
Idle pool (swap-out blocked):   44.2 MB         65.1 MB  (+20.8 MB)

Maybe we go with Nhat's idea (CONFIG_ZSMALLOC_SHRINKER defaulting to
ZSWAP_DEFAULT_ON) for now, and if zswap adds a proactive compact knob
later we can just kill the shrinker?

