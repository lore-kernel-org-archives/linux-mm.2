Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC0AC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B446B008C; Sat, 19 Sep 2026 13:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9E86B0092; Sat, 19 Sep 2026 13:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893AC6B0093; Sat, 19 Sep 2026 13:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58A436B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:00:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 815CCC02B1
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:00:29 +0000 (UTC)
X-FDA: 85231125378.13.D74B757
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C6C2180006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:00:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=TYW3oqJU;
	spf=pass (imf24.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.76 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789837227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4EVCCJGMVi/Jgl5olIITsEJ4O030sdS93t+4GDKvrY=;
	b=ngRjFSPA/UBt4/fxppS2MN5F2j9TRR5scXttyGcc18cPYf4JSGyzKar5rnzInUGEnfKEEL
	xwlzeKA6PFfBFUKCCJlbvKPnVdckxMT9D4HDSTHcJQmS2Nhlsk+/ACAQHUzLQ4bVn0MYgF
	bfvFibyb7S3TeI24a4X6VRjH3n5kq9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789837227;
	b=K6wq2Yc94HqWwMrJUPDeR0ME5zviA8/Ydlb9S9pJYV6XmCPohkDhTFlR08cyi+OMtL/ffk
	YJRaoRuFpugKTVcXgb6GV4JkeCyyPEBET27CYkXqCrt8vlLLThfIA6NO2VrwPsWqwPUcCw
	RkiHLvbPGNDbEgb4BAOukAnrC3hN02o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=TYW3oqJU;
	spf=pass (imf24.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.76 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9adea43b6so2246183a12.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789837226; x=1790442026; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R4EVCCJGMVi/Jgl5olIITsEJ4O030sdS93t+4GDKvrY=;
        b=TYW3oqJUAr9Dj4Qo8QCQewzHBMnoT1ICfBwASe8bjazTLBC/c1N6UAiGsiuxX9Wpv0
         6MNmV4SuUDJRwApgapPL0kSAIDyAfM9QMf7DAHz8/urGBbPCU4BEVjCp9ROdBZA2b9ww
         LJLV7Fzh3OY/EEvFSz0pGxL0jRfsPExI/uKKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789837226; x=1790442026;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=R4EVCCJGMVi/Jgl5olIITsEJ4O030sdS93t+4GDKvrY=;
        b=DaToi4pXIBBMo8a2nJEcVpmcmmYHEQl7hH79Eau/UDyp3Zq63kK6mNmZEcG4fcb6Vf
         KWrBrAwGsedxcXd+tTXiDvRUCRDksDL92xHcWd0wja9vhGsngdrO2CmqVsX00+1/OEwQ
         Ord6bOmqdXNZVKKdo9GKTZZI6CIaMnOscToMmi9rwRe+Nu7ZLMjzqDNGqiUc9/OaVCiu
         RWAY8OsvFcb6Q1EKohmz1AtRY/1zOW9qNazN3W3ZKh2yjyUOW6jIZ9+eS1WIIjYmbjkI
         2Y8EUjCguXFsGKmWddE7StonWvqv7a8lvf/sTZEMGipxus5S5JhFGqc+hWj8B3h6FjAu
         t8zQ==
X-Forwarded-Encrypted: i=1; AKwUvBwoIRZiUIDKyZSjx1AXQSjJiXmIq9OTHqt67JUx0fSDEvx9DTQdo2zftz2nmJV9sf1der68CJcdtw==@kvack.org
X-Gm-Message-State: AFuF++lywHiVIq755fMXfk3QT/fWRrl4m6BKk1437W+HeHQGRaBzbrPS
	SrN+RypHKJ9UfzKd5kKGo5gTx0WsLnqbZPrtT6JppSi5AI1/lOxs5/SASgcqh99QCAjGc5Dr7DX
	8l8PHKSw=
X-Gm-Gg: AYBFou2hpfgqUAY98lQsZI+QsMQP922itiMa0c8WnTgFYY99pOZMhdPxNWdUmTJdVer
	4fuDxVeWULmT/6kAvEJ2Nz7xHySNo57ukLDiLtazzOTAx/pgFOvstIHpVa3pYTzCM9q7x4z61OT
	fYBoSXFwfzjo8te3IKUzNfXJ1jZBe8rdVeVhHBvpYNZpxdlgW5eupEdU2aeuGX5TfqPeoxXnd5F
	q8acjnPKDN9yP4we8So2cgBVj121QLMrGoILPMzM9DDL7GpmdboF/68YlHhifw1fhN+WGw1XtzX
	4NCqgHqGf1HXdfyEc+4y/PxIwyCE6+WO+sHHwnH/FJkAPtV1jBIsIaXLoPQdu+2Q8xGEOCmUcRS
	/n5B5ygQ01cFCCTN/5NmQVI1Lh1ggSPEnAVmIORU4ZQgS0Eh5KLV84YmQ85OGMtvfE/B2HoBQ8e
	V6JIc3tLzM7QL476BGbfH1cJ4xQ6oYPo9p1QPDuqQVroSJt9qFkL6D5WOxXHgwrZCQN0GUUCUMJ
	qhx9tQkzQAgOkP7ZOXWVOVWzoNvfEblcWbw8kfFmil1IM1X2w==
X-Received: by 2002:a05:6402:4145:b0:6a9:9766:59ad with SMTP id 4fb4d7f45d1cf-6aa548d810emr4910658a12.43.1789837225747;
        Sat, 19 Sep 2026 10:00:25 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67dbaf0esm1546402a12.15.2026.09.19.10.00.24
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 10:00:25 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a58so255588466b.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:00:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwgk1qkU9mV080UBaxX5ZHhgs/MxdniY6Tm3zA4iqHJ0j6QQEkESYw0oK0WdVIlL0s/U+FAP+TyoQ==@kvack.org
X-Received: by 2002:a17:907:3f17:b0:c26:1649:47ab with SMTP id
 a640c23a62f3a-c2a15b4bca3mr522411266b.33.1789837224119; Sat, 19 Sep 2026
 10:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop>
 <20260919000056.3132131-1-paulmck@kernel.org> <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
 <6B1FC39D-6EB0-433A-8E49-E5EFC9379AD7@mainlining.org>
In-Reply-To: <6B1FC39D-6EB0-433A-8E49-E5EFC9379AD7@mainlining.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Sep 2026 10:00:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
X-Gm-Features: AcwNN1WCbh_CXATf-FMT8x_ZS8yd9pmRtrkzEOhM9i8GXxqTrntEHha57Im_sMA
Message-ID: <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
To: Bradley Morgan <brads@mainlining.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Boqun Feng <boqun@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, lkmm@lists.linux.dev, 
	Zqiang <qiang.zhang@linux.dev>, Wang Lian <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, 
	John Stultz <jstultz@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik <mjguzik@gmail.com>, 
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pbhu1zhsxpgagfaibr1yberuroqba6o4
X-Rspamd-Queue-Id: 4C6C2180006
X-HE-Tag: 1789837227-591555
X-HE-Meta: U2FsdGVkX18Gys4V/C6kEKhlnhDL/A68sD3J0xrpOAZhEAk2XRQi7Y01fzTBPvV7mPt0pnfZa2ZizOivd0LZwSRILVD8/YS3ZTDlFA1HqwaidAWVvUBu7Z/Q1E53qqM1eG9iFX2n9SdxIs7N9qAuYP6AuchuvLutft63n2HtsI1rzA59BN7dxQVWLNKOTtG31QLU6sBhy1LDJBw51l/cYvDi2Q3gSNCIxAjZQnxAQxfoxAHfzPO4udKoEJkT/YRhvAs2pAXVkbPAz4SGk/djRACJ20SHiciP8hRPRRSNV1E0e/y2k/QTacnBJkAFEVmswsQzjlROJzci/6ZBb5unPscCiA0X6q69l6QV3ohJ11UUOxQedKr0jCMMT72yWLQOrP5bVYjxpTgfA+ZiA8a1+EoVrf+Zx/4iIFmTCfr4UrgFhjr2w0thR7CWBHv6vDr1MMcH/6zXx3r3lDQ25BzktSiwIweOUXg+QfJn55P4T9v5ty8M2if2CLvFFO4uYcKnnsHQPLVAhte4HaEfBjkGgdD3T5e3X7PrB0JaSqDiv9I4IrQkUznZUdo+/Ex/NZv8y/LwIwD73UIIv1tQhxYtwJr45C8dxvtkzlzpLj2BtO5zd+4MWx5KYCicQizSXLxD8QQZzkfjNWINZHMGzidLkjHFhWsOTB7p8RbOV7AUaUCYf/TYtbyKHREdJizgyMd774/6HFsxuO/ylCCWwsNUr+6L5oLg36+lexym7I9SHAQ8r/d29/91gTjb+MhHfgiDl6x5QSta82xqJtints0n8GMXybhKyYqCyWijHcrnslahfmod1hDpkuA0jwaLyVNdmdWcQlS7609nDiIoyD+UnWgmWrwaWiiFfjaD11dEXNLZgbdb3XND7N9K/QEAosXKBHQ/nBrbJ3oib1He317dh/x7kk7QvU6Zu47FHuFKYiCR2KQsuwDvfD+zin4FwugFibJJV6BnFAM72MGdCKM
 au6Ttl3l
 L3I0LzWJMNWvIqtrD8TxV+ZIEBfgNTQQtZLMpeYcQ6l/uO5yID3apBs/wmoyeiaiW/rEbTL7e0IwUoCRUKR0dGusfCjHJ1h3TfMITPizD2cKH4cH4IQnhvpzBnvew+NvspeCRxmg5RIgX3cQQ56j3KY5KsNuPa/YoZat1g9On6M1/PDBgt00QKr/0vWSqbLcX4+6qZMyOINa4Fn+agYQqe4d23JqlS3b8ly8mHH64v0qlmNZhGGPMXx9DIVG8l1HsmdgYlI1VCTpn5mQaxW0UBa2fJngkQHHuNnU1u2YfKGOP4wDTWrgIfW+denCBfvd+4Zd6yGNyr93hUSsLyIrKAgjbwiVlQkrRkPCKP2T7VRElXRLdcD92tESmaFuRvWkUO1GH8c7TMsUlYt1FBx0PO+JCtbj0j7qfnDHtwUW0nx4imhdU1aJCfCVN3D39+eIThQGQjgiJE1qNOt48ZtZJbXACbdYrGbfHIAcrK77H20t2+FCexn9scJiiXYOxh+XIH6LZnLlzPDS+4bMcxag6f7LeYQxFKqE0B82rXgIleRlZpoweHy7vSke/6bHq0IVQsWdE0iKzA33vqvIM/VwSOZkYk7MCbS4CTAlM9gtSCgC3BPBm2hr58lLQ9siqCtkgTsBZq5wHA8uFAyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sept 2026 at 09:35, Bradley Morgan <brads@mainlining.org> wrote:
>
> I think hazard pointers are good, what test do YOU suggest we do here?

I want to see a single real-world example of "look, this speeds this
real load up by 10%, and the kernel code was actually cleaned up in
the process because hazard pointers are great".

Not a microbenchmark that tests just the hazard pointers themselves,
but a real kernel feature that has been converted to hazard pointers,
and in the process actually shows improvement.

The ONLY reason for hazard pointers to ever be merged is if they
actually buy us something real.

So I want to see that 'real" thing.

I want to see how easy/hard it is to actually convert a real current
user, and I want to see how it actually results in measurable
improvements in performance.

Something *core*. Something that everybody uses. Because I'm not in
the least interested in a new subtle feature that interacts with the
scheduler and is only used for some random driver or (to pick the only
example I have ever seen) AppArmor.

Now, obviously, the thing that would impress me is something like the
dcache. If *that* can be converted, and it shows real improvements on
some real benchmark, then I'm sold.

Now, I don't really expect that kind of major test-case, but I do
expect *something* meaningful. Not a driver. Not a test module. Real
code.

IOW: "Show me the money".

Because the kernel is *not* some kind of acadmic project. Never has been.

I simply don't want to merge something that is touted as an
alterantive to RCU - which we obviously depend on very very heavily -
without something *major* that actually uses it and shows the
real-world advantages.

The discussion about hazard pointers in the kernel has been around for
a few years by now. If there isn't some real core feature that was
converted to show that, then I think that's already a failure
indication.

I'm hoping that those patches and numbers already exist, and I just
haven't seen them.

                  Linus

