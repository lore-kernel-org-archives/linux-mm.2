Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1D9CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3AE6B00E7; Wed, 20 Aug 2025 11:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A886B00E8; Wed, 20 Aug 2025 11:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068D96B00EA; Wed, 20 Aug 2025 11:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4E7D6B00E7
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:49:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 711B0C0537
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:49:00 +0000 (UTC)
X-FDA: 83797569240.22.9BD4ADF
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B2A180012
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:48:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gPgQdYL/";
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755704938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YapFlZLhDO6WeQ4sTaP804rPtqfECGySrXHAqDQV/uc=;
	b=8i88VB83SC4EoilRiW2NO1UY6FJdGccq7TBbZHUv3xLQuHLKSsI+fSz/BALZa8rS2kgCoE
	7rY/gTbeMQxL4W/DM07nU8FohH/WG2L7V2lvl9705x9xZ2mICpIM4Dcs0ec8JoDqINYtFN
	rIUp3EYiVrP+9O/cb30riTqr2Ds5xRE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gPgQdYL/";
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755704938; a=rsa-sha256;
	cv=none;
	b=WGHSVnkalbPLXckwAj/xo6KitZmcFEsdwxO6J8PINeWkHdIfhQXqXnmDgpCqKcMRmPeMbP
	yKPKKxMmz2hTW5GfLdOIgDgkCaodkBWlq6r0G2twepDqJrIMMR9VBHEQBEkdbZUQHiiRGx
	EPdul+h6rCBtdzFjFjKB/A2+oqTv1OY=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d605a70bdso50990607b3.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755704937; x=1756309737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YapFlZLhDO6WeQ4sTaP804rPtqfECGySrXHAqDQV/uc=;
        b=gPgQdYL/1gFcfodHG79XUa/zLGjqhNf0yBatNKdiun2Q0wCCBdtKLcJZFhMVYBgoqs
         f5qTvCW8WKXoShFU3ASyPQ9eYhOxBU1TcHlO5CJHMtiJ+EtjAThjXhvI0aRfmAq+QhYA
         d4qCi8v3Y1dP99m9jSNJWQFG5MCVhTEK9F35IQI/wakAQLJnsDqZj1s4Uz8OFtzqUgfK
         80fwuwRZxTAkGLt82ShqbEELUAGhaLXeBZGCTSqbvNYafqveZZDkWswAa11HwgBVj0vc
         FW2CtFg3LBvFSsudDstC3uA57d1mK98d1mdI65CVYe/UvV/gePELoPQX0bhpE1FnnZ/K
         mGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755704937; x=1756309737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YapFlZLhDO6WeQ4sTaP804rPtqfECGySrXHAqDQV/uc=;
        b=azS9jFsa7JHXR5fb/lytzFvYwSKP315d7jdW9WA5DA2jJf8vd4lCkUqR8clvvg7vC2
         fd57tSaxf4IQlFkwI7ZI3FE1z6MRwsnFj/MvPFcfX33RvfIVVGmjmVw3VBX2IinA39ns
         NTmldAqXglKqnffIGc0RjHX+8mk8IzzYgrKHxQLd7AWqFCQzYwSxDoTzZuTJ3iMNbi5A
         tFrPyA71mT9PivKIKyNWcyc8tHGnRZYOqF3hqKho+d9+5erg9PoHdddnISmuGr2h0TPK
         s0oqsQDSQSvPfP2h/yZs83Aua3S3OQv6eGhrU6rEXNIQVnnh7wD7odFVJiJ2FXxZmyGv
         pu5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8/1lqEoos4/AbbnOfq9wO7/UKuS3glG8WGcNTXfL/8zMCpDklUr59Tz1oz70lUbYYvo+zEe1i1w==@kvack.org
X-Gm-Message-State: AOJu0YzfQLRV8jHcBUFXozr+lOUhNNad4YYtAhh6YtX9JMD/m6zExZcf
	+gfvyr68qBWGGtGS9CQeaiWr3Eus6v1/q0qxF7ITqaVCS35UNmcX/cpN
X-Gm-Gg: ASbGnctprYgGbl/JF5DU/Z9ZglLS/MhzJhB8PpKqoTAeGnUjpdvdf/37tq3DgH4acQr
	Mm5ksO0Rl7rjsJr/lLCW9axwENNuXtMiKgCnSWD0tx1/zQqEoMIgFkKqS8eB7BDShea781gM7P/
	6zAigeePOUB0Wxoq/0CbBV5Wi7tcQce4eoT+KzeIWWouJNv3yn+uE9ABXMb/C50BBxUuxJEtrHE
	CJoI+cY9VnkvauxmwbTgJtp43XHOprPRN1a3KaS4znvoriPmrVG3WHxHYqFNXWXMsHrEvY0Z8KA
	82Qbei8AZ8IdtrModhCPK7ToNi3PyjYFmXYrEzUxzmCzb+zrbFXSkJqoQQPEOPRTWYwILtHJ9+S
	ioLs3wZyJ9cq4UPWe9YXfNg==
X-Google-Smtp-Source: AGHT+IFnBectO9j5CKIBEIOyjSzsK1xF+OQVRcvut6PzymCeGy0chKH+uklouHbhduerRNsx19yK+g==
X-Received: by 2002:a05:690c:6e13:b0:71f:9a36:d33a with SMTP id 00721157ae682-71fb322d649mr33501547b3.44.1755704937493;
        Wed, 20 Aug 2025 08:48:57 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e068f64sm37561437b3.40.2025.08.20.08.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 08:48:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Wed, 20 Aug 2025 08:48:54 -0700
Message-ID: <20250820154855.2002698-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250819224111.e710eab683b7c7f941c7d1a7@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B2A180012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6j66xfox1ixip1p3yr3ecyu74xdypiyh
X-HE-Tag: 1755704938-802906
X-HE-Meta: U2FsdGVkX1/ukcrtR4Z+dK5XwkJRb9E/h5ShLRetHB/uzFYV/fqbqTQ9ZO4Xc+32HEQz7+RsY1VpE4ZB+xC17lAG+rLy2as7uDJgvPQHu/+aVkySm8wya+QbrT30qkN8PfHzZ3Vw/ooPJFWwkEW2gSyrNt/TrYV2uUWgxOJ8oxuJJK3qi3nFNjjtSccQTxiDiTnrS1mFpi/aIIgymu+p7RX6r6Kk3FsRdehenzU+uAChRvAd5KB+7JhrIerUEoznRReb07529mdYNqNbgJtU6xa/9bbAhUIdP/PIIuejS7B7Cw1EnFJ/hkDY483/maE5z68LaOaj6kKpEqStaKuFWO5oOpOw+d3cEycdWvclNnPSzCneMFYuqnxXByDZZw6nOC+C3enAZQYD0+EU2y/6wuc93Lbz7vmPOPnftasUqw4f7XB71N0hvt9BVrIYKjspxiqN3N4xnbdZHFmpImj9qUi6Ev0+qGhRrlNxX85gtu2DrYOclQMAkSJw5jWUbSC7H8RycfbehQSMSMJYVsHQcdGLmKjkBmN/WzUt4jlnHECMtUHMACXg/thQm7jqeDJYwhPPwl4VFg1IkqhDLvJJHOLqHSeN6lp436yGtZFMAn2FjY7CqFTwDfq87UrLrwSmUHJB8239chzMjUMZXcBl3BlUga5KBbYtOt/50PMc0UZkbcmjguliosSCDd85R9QcwavuUKv1oWMJKrCTLgkz7c9HBpUHIPNx2yY9PKG7W4JbGoqvOUxnb2TrdAFssfOqNkMQu7TrI2mzBqUUy9SGIpxbcBjODdVajSTtwAT4/xKuKJ2ld4MlMD4QJb1Dl8y+Co2ZrFhd5DaIcdva9fxRTJqOGgz/Qq1X8ljQLX2kBFv+DDHWYx24QuDFhnl5grZRqyGsmDb9s3SGDxni5GaAizzbz54bRZnpBD0DNVbmTVQrtJXXww9mjPAF3eAW0TN8XHhV9Uc6piSli7J9rrG
 axrsd6UW
 nV55V8LKX7q18rfzpPif5npikVj0QS/za6i3A/meyNKb9AlFThw2wkjHNCfqWgHgjHvhQDLEMCiOLMZ9Scx7gjQ5DS334DqKMco8YKzKdJWNaqml1nG8GG7wx913V8dSa3eA6HVZ5OW8BsdJh53EQF53hxbkR0uVqPalRK+6O814VlnljiwwXbz3Qky67RlP/hPj5pcD7wCa/UZn34d6rfDUf7nDCsRcfXtxSwEXzm6eiSaBpfyo4p/m4NnrnSitmi5baln3zLH1CHy4I1ENBYPOeisP8lUWKGcZ0WqME8TLBU3tLEnJTmxJQR/BDglrD7Nup3hKs4y/dxjFFtaaGr5PwG4WUIvIJGN6IM5kiOIvuBjC9Q58fDmNSVVuAoktuJXpYHtZaLJN5oDZ4hB0kDVfKwssBh2PcvCJo4veRoK3OLMcOzebTpJMcHHpTDZgS3mROtYGkwsRHVNRckJfuJlAoKh9lujfwP7onX0msQpejeo2vc+GmZLaQZEFygFErPtHNaJZD3u1E2s+qbk2H1EmML7r0miBoCUudkeiRpUYSbtVu4gMxgUHlV0toapU6aBvCzXCyYKAdpVZHn4F8evx9HpYlvUcFGr/QS977k13b3zYOtvbmmNDeKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 22:41:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

Hello Andrew, thank you again for your input : -)

> On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed.
> 
> It would be interesting to share some of those softlockup traces.

Unfortunately it has been a long time since these softlockups have been detected
on our fleet, so the records of them have disappeared : -(

What I do have is an example trace of a rcu stall warning:

[ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
[ 4512.604370] rcu: 	20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
[ 4512.626401] rcu: 	         hardirqs   softirqs   csw/system
[ 4512.638793] rcu: 	 number:        0        145            0
[ 4512.651177] rcu: 	cputime:       30      10410          174   ==> 10558(ms)
[ 4512.666657] rcu: 	(t=21077 jiffies g=783665 q=1242213 ncpus=316)

And here is the trace that accompanies it:

[ 4512.666815] RIP: 0010:free_unref_folios+0x47d/0xd80
[ 4512.666818] Code: 00 00 31 ff 40 80 ce 01 41 88 76 18 e9 a8 fe ff ff 40 84 ff 0f 84 d6 00 00 00 39 f0 0f 4c f0 4c 89 ff 4c 89 f2 e8 13 f2 fe ff <49> f7 87 88 05 00 00 04 00 00 00 0f 84 00 ff ff ff 49 8b 47 20 49
[ 4512.666820] RSP: 0018:ffffc900a62f3878 EFLAGS: 00000206
[ 4512.666822] RAX: 000000000005ae80 RBX: 000000000000087a RCX: 0000000000000001
[ 4512.666824] RDX: 000000000000007d RSI: 0000000000000282 RDI: ffff89404c8ba310
[ 4512.666825] RBP: 0000000000000001 R08: ffff89404c8b9d80 R09: 0000000000000001
[ 4512.666826] R10: 0000000000000010 R11: 00000000000130de R12: ffff89404c8b9d80
[ 4512.666827] R13: ffffea01cf3c0000 R14: ffff893d3ac5aec0 R15: ffff89404c8b9d80
[ 4512.666833]  ? free_unref_folios+0x47d/0xd80
[ 4512.666836]  free_pages_and_swap_cache+0xcd/0x1a0
[ 4512.666847]  tlb_finish_mmu+0x11c/0x350
[ 4512.666850]  vms_clear_ptes+0xf9/0x120
[ 4512.666855]  __mmap_region+0x29a/0xc00
[ 4512.666867]  do_mmap+0x34e/0x910
[ 4512.666873]  vm_mmap_pgoff+0xbb/0x200
[ 4512.666877]  ? hrtimer_interrupt+0x337/0x5c0
[ 4512.666879]  ? sched_clock+0x5/0x10
[ 4512.666882]  ? sched_clock_cpu+0xc/0x170
[ 4512.666885]  ? irqtime_account_irq+0x2b/0xa0
[ 4512.666888]  do_syscall_64+0x68/0x130
[ 4512.666892]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[ 4512.666896] RIP: 0033:0x7f1afe9257e2

> We have this CONFIG_PCP_BATCH_SCALE_MAX which appears to exist to
> address precisely this issue.  But only about half of the
> free_pcppages_bulk() callers actually honor it.

I see. I think this makes sense, and I also agree that there should probably be
some guardrails from the callers of this function, especially since free
pcppages bulk is unaware of how the pcp lock is acquired / freed.

Functions like drain_zone_pages, which explicitly enforce this by setting
"to_drain" to be min(pcp->batch, pcp->count) seem like a smart way to do this.

> So perhaps the fix is to fix the callers which forgot to implement this?
> 
> - decay_pcp_high() tried to implement CONFIG_PCP_BATCH_SCALE_MAX, but
>   that code hurts my brain.

To be honest, I don't fully understand decay_pcp_high() as well : -)
From what I can tell, it seems like CONFIG_PCP_BATCH_SCALE_MAX doesn't directly
pass in a value that limits how many pages are freed at once for the bulk
freer, but rather tunes the parameters pcp->high. (Except for drain_pages_zone,
which you have pointed out below).

> - drain_pages_zone() implements it but, regrettably, doesn't use it
>   to periodically release pcp->lock.  Room for improvement there.

From what I can see, it seems like drain_pages_zone() does release pcp->lock
every pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX (simplified pseudocode below)

do {
	spin_lock(&pcp->lock);
	to_drain = min(count, pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
	free_pcppages_bulk(zone, to_drain, ...);
	spin_unlock(&pcp->lock);
} while (count);

Although, the concern you raised earlier of whether another thread can
reasonably grab pcp->lock during the short check between the unlock and lock
is still valid here (which means the concern is also relieved if the machine is
x86, arm64, or any other arch that defaults spin locks to be queued).

With all of this said, I think adding the periodic unlocking / locking of the
zone lock within free_pcppages_bulk still makes sense; if the caller enforces
count to be <= pcp->batch, then the check is essentially a no-op; otherwise, we
create some locking safety, whihc would protect it in case there are any new
callers in the future, which forget to add the check as well.

Thank you for your thoughtful review, Andrew. I hope you have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

