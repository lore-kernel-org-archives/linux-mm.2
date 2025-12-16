Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96D2D609A2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAE06B0089; Tue, 16 Dec 2025 10:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AFB6B008A; Tue, 16 Dec 2025 10:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191AA6B008C; Tue, 16 Dec 2025 10:12:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5A86B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:12:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DFDAC05AC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:55 +0000 (UTC)
X-FDA: 84225676710.30.2EE1F14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33BF340017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WtoEDxoF;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0VPxdNyuLpxWokzSwS3f4tGWI152Lb8CgjDYmWiWDg=;
	b=a9LtYMTYcVggy3DIG+GVkloq8zmxDUrdes1omstpLXUMOdiKr2k4L8h/GchXSdkKfGeKzq
	hZltsUFfvtyRrw2dGRBYj3TUlW5Qq4Z8tcDMwKjQk8RBmGeUSm8m6IbpthSOU+uFiUrWs+
	w/SFmQIVxxtiU660Wj0tCqyyPv8qa2A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WtoEDxoF;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897973; a=rsa-sha256;
	cv=none;
	b=jBCbeLzrLQ/zw6LprqTwCRzf4lb1URg877XPJxhANvtz61NjH6xzmHg8Qq+4ZF3dvszJSp
	yXtC8CMC9Oj4pYDJpT9eMTATNc9hPkrFexG1+lzDqv/L4odAigIYPIuLEjaFAbMgOSEGvL
	Z3LtUQiPo3bmvmJskrtIl2JWPnH7z1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E347243859;
	Tue, 16 Dec 2025 15:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB20C4CEF1;
	Tue, 16 Dec 2025 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765897971;
	bh=s3mWl19IsBaYscnhUDI/X0Sg6nqiJrXm+KLBkFlAHc0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WtoEDxoFxKkX6YD2btUH4i1VWm6UhQJlEN4mW18ItLNDGupYZX389yjw2v5Emgi0c
	 fJBFQCUpLRXT1tdrt0HgN/fMMB98nltOA4QKQEo2QgZxINHj4cTzjYMWxP3W37cmqo
	 GTIBOMhxxbGO/8Mw7bV1lyqFGRHJl44htjCtNv/g=
Date: Tue, 16 Dec 2025 07:12:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page
 ranges
Message-Id: <20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
In-Reply-To: <874ipqexai.fsf@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
	<20251215204922.475324-8-ankur.a.arora@oracle.com>
	<20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
	<874ipqexai.fsf@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 33BF340017
X-Stat-Signature: mxmmdrck83iyauz5e9mqgdqb5fnrr9w1
X-Rspam-User: 
X-HE-Tag: 1765897972-535677
X-HE-Meta: U2FsdGVkX1/MWkRrhzdddsJ6xF5HzljEzOoxTyVtm+CNiYVc7DxTIvE0vgBAUetnXiF0MKyZt0hkMLRZCbeN0+gFOKpF7yCUglDBgijWGJFCOn65q/5YDHq4uUs+6BqClE/xrlv/LXoKlX/fb7s4gn4Yc1UfhqLeHrdDBMmJVu4KDpdbY0uJ0WrcgQ86YmlAxr5Zs7sM1k3O0LZmyD9j1kcORbKuBaEgiJ/WqTp+NDmiyT43TxihgwjsEK4knSQutZBPgbU8PJLxUW/38z3+4Pn8VqetMrQ3b7EPbSgk1QXnk7vAtm0yzHOKp7CWL6joBxQJFZgXfk78/n9t+ujTG3Ph5met/45AttsOzewATiAOJgJqllOn08+uLLvQp9IE6S1OlafKX8R4+Nb4+bgPHjgpyEcZk9HjhyC2nAYGB7sCR9OvKWO2ExFkrikxxosBMi8S7asG01wNArtpJHaKFfFWOqvFMyTUl0459eiVyjtr4C8Z/uaqIsyD/G6n0x1EOi4DgWzMgVpu+sfHQJ6ooVHDMjiswxaSkRA3aPFISF27W6CosIOKeVMH9ZeG1Q/6zNZukEQ6fZjO0L2bS3+mlj1Dqe4J/D55Fn1LirR80WS5nZdJwUoj0gtqk3IzreZfe/tu2l028QtyGV5oUPyrbb2+NBUM/+38+kUz1xImYZ1h24WwoUV9z6GFbux4YaUlfJsdJj4WcHhU/0ddX4KXcnzMHB6lLMyyt+R9rfOVa5BfBG+o9bPac6vC+RrefWICoeFSVOnBCMLDPcAKND8AWIl40DhQj4sssVsPMM2yLWY/Sr+VtbXTstqpG0VYOTeewPflf2T712Q7k/j10mEh2v5mVDa4/9e1VvH5DVUY5xaXOPHsCMeC/1hqFvg5Otswgf6WhHuKNIOOaihIS3GNH17b1RnuuS9w/MUMpmvB25wk+J392tGvMAggDAfbrrBsZtmFQqCSgFbDdKV26uG
 c88U7rg/
 sgKqoGsfzZoRZwl68YMzDXhariAnfvXyS6GN7o1pzsu325c+UfPtgtlx84V6x/q7hDjd2ZSiviFnnwtC6fPuXud01GwEamtLSOKYhSK18ESnxR/wOVVz4bmzYh+HreKmHNJxEDbsQsyIY4/5R8Jn/znXQLwZhGYdGd30f8YZIlL/KUdPlTmx39JITuLjqhSdFoSFrJTsxOnUerKWJCOS2DyQT26yHWwHl/ODKamaToD4K5hn+QUIrGOjxjnTjullZYzLHVWPkdqsGig46I4WXJUdzWM9w157ucoGQBu2oDY1lW3XYR2E9+Fj46YHv+iMficA9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 22:49:25 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> >>  [#] Notice that we perform much better with preempt=full|lazy. As
> >>   mentioned above, preemptible models not needing explicit invocations
> >>   of cond_resched() allow clearing of the full extent (1GB) as a
> >>   single unit.
> >>   In comparison the maximum extent used for preempt=none|voluntary is
> >>   PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
> >>
> >>   The larger extent allows the processor to elide cacheline
> >>   allocation (on Milan the threshold is LLC-size=32MB.)
> >
> > It is this?
> 
> Yeah I think so. For size >= 32MB, the microcoder can really just elide
> cacheline allocation, and with the foreknowledge of the extent can perhaps
> optimize on cache coherence traffic (this last one is my speculation).
> 
> On cacheline allocation elision, compare the L1-dcache-load in the two versions
> below:
> 
> pg-sz=1GB:
>   -  9,250,034,512      cycles                           #    2.418 GHz                         ( +-  0.43% )  (46.16%)
>   -    544,878,976      instructions                     #    0.06  insn per cycle
>   -  2,331,332,516      L1-dcache-loads                  #  609.471 M/sec                       ( +-  0.03% )  (46.16%)
>   -  1,075,122,960      L1-dcache-load-misses            #   46.12% of all L1-dcache accesses   ( +-  0.01% )  (46.15%)
> 
>   +  3,688,681,006      cycles                           #    2.420 GHz                         ( +-  3.48% )  (46.01%)
>   +     10,979,121      instructions                     #    0.00  insn per cycle
>   +     31,829,258      L1-dcache-loads                  #   20.881 M/sec                       ( +-  4.92% )  (46.34%)
>   +     13,677,295      L1-dcache-load-misses            #   42.97% of all L1-dcache accesses   ( +-  6.15% )  (46.32%)
> 

That says L1 d-cache loads went from 600 million/sec down to 20
million/sec when using 32MB chunks?

Do you know what happens to preemption latency if you increase that
chunk size from 8MB to 32MB?  At 42GB/sec, 32MB will take less than a
millisecond, yes?  I'm not aware of us really having any latency
targets in these preemption modes, but 1 millisecond sounds pretty
good.



