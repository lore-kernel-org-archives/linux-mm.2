Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C90CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 04:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2D86B0005; Wed, 10 Jun 2026 00:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453586B0088; Wed, 10 Jun 2026 00:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368F06B008A; Wed, 10 Jun 2026 00:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 275FE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:56:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1B2CA084A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:56:43 +0000 (UTC)
X-FDA: 84862792686.02.ABD07E3
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 69D034000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:56:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPuBiriP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781067402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LLL2tbdrNFlBdviOTZn0Zk3ROyJs5PUPFRhZVmiiFc=;
	b=7R+nDR9+Sjr3NTzgUKsTrItPDpb+8nqQOLN68B0w5UzNPZmfxn8d4O74iQ4TryyxE1RUTQ
	O5rBdHICUICzYXI4Wh1PvDcqRMb/xtE+8cDfObXX8hhzSDwA4E3kPKoas275QhQaNRYhzF
	f9IyJbLb3T/GmWNAO5LFUrGJXv/hD78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPuBiriP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781067402;
	b=6m2IhC/a9nfzGTm/iOisjQgSJHHhcmfaSZiEViMui3z8cIgmrSxWL3IiWh3VGBnHAVZ8eq
	hNWFj3vzVSETbGLM0+9yY5WebDxFRscPsonp8pF7u3PeH7zaYYroP2cd5GHLowWLjFTvqh
	8yaaxvN2smFU6YYziBXqkm+upXd4e/M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781067391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LLL2tbdrNFlBdviOTZn0Zk3ROyJs5PUPFRhZVmiiFc=;
	b=KPuBiriPYIZuU/h3FBAcrg3LDOjUF8aU1rZmdx4wVK+aflBg2CGKw9m7R1bMQ1FVEQkXRt
	Ic0ZjdMI9phOAGsUcb1YcW/p9qNnL/7uFt+ILEnBtoNRp9SINuHSrKB/m1sR4ZgqDuouP2
	KW72VcXPpVdRT5n0iQZcR6RA7o3P5DY=
From: Lance Yang <lance.yang@linux.dev>
To: kanchanapsridhar2026@gmail.com,
	yosry@kernel.org,
	nphamcs@gmail.com,
	coregee2000@gmail.com
Cc: syzkaller@googlegroups.com,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [Kernel Bug] INFO: task hung in zswap_decompress
Date: Wed, 10 Jun 2026 12:56:23 +0800
Message-Id: <20260610045623.10574-1-lance.yang@linux.dev>
In-Reply-To: <CACpmpodS2J_n+Q=RqgL4rfHN7zChrrefU3u2qXfYkcv4+YnCbw@mail.gmail.com>
References: <CACpmpodS2J_n+Q=RqgL4rfHN7zChrrefU3u2qXfYkcv4+YnCbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 69D034000F
X-Stat-Signature: s8dir6ntmadcyzja8p5wgw581xhe4xi8
X-Rspam-User: 
X-HE-Tag: 1781067400-886247
X-HE-Meta: U2FsdGVkX18XxOHn0x2j6ejjbBVDCnwNRdfCQvguPH6eZ79Ys1lPPD4o2pozjpCs3I2L3tB75MDwSbloWMWGZ2X7oVn4Aqv8NffiBkMCyAtp1/0GH117UhyCp3V+isTiTazvTdIWilwHM8QQErfqas+Y6RLnWKNiuHLHkRQrpf0ZwUs6teIzoOI70az1sSostQdB/d3izMI+zHMaMRCeL+2ko5PNbK/BLuPwUUH2BFRoXTLP9h2tY1+nYKGlG1zq/3WEuvBKQ5T5TqLJQvL4IKRGYHXEMi7aLOI8BDxHeHEd4ZWA/cHXHVQqq7TebVxjxYehX9L3BkYNTiRcR+gDrumcCl2pCE/4pZhL2mw7Iwt4xPna8PcjZPRy8dGkxWI0JPNA0sYOVcWeWwRN+LpMZpMNjFO8aPKeCa5aI1qfjdldzrRX74GpufIAkLW4zG7d+VVSQwM0Jw7ysEdFLHawRUR8V7NWib5LTJc0r4KoPar+IQngQ0m1+NZWdJTHPPUbznZOY8YlGGxKpmES8T7CorJV4wYDnSBw1iYKkwt4jON2RGd4U+e/paWSm2Lct10d8kwOTrOCDqK8cX5HMptMQmhMJD7FWKya8sNGh6My7WX8dO4ifqS68/uQUFAkdsihtKb2Zf3Tgqfzqm91ctKm+xYuW7EpZa07NgWyDVHX4t+c6zS8jBj1g1OEqnkbfuNKKtY/B1JnhB2PMFDLZT1hqFxPliIB9YtaCKZMmUysmu/IRibg4iqRaxBopP0LCurU98fuWI3o1jr/+K+9MBppGIFaVebMeUguQu9Ro8MDIW5ImDJ7FL5C0T2cY1VzlviEIPmhLO2ezCYUx1zqN7yDRSyx8o9RGuCr0R4LJc3f3ZWLgaS7KpkGBvfLK4YajDlojOgG9dEjdaLU44kupQUUkO/ipKnXz6vrbmgd9CWWcTSdr9TaNoLbDWrNjDnH7vT3wa5TPhRjRE4nBi3pP4B
 mN/Mrsx4
 6kwNVV8lVpIspNYGdJvz5AB72KzQP2gRZaJPdXAXfPNnJ0dyL/0SlV7jrlqHehsxJO5G9r3rzM298C4maAAm89+nHGIONGw1CMC274wERoFCKdx6aYUgo4QMSsdOSXmj6CA5nKQk06mh0Ymhb4Vz0uCClGZ7WNplgkbBPjYWP7gjW0nOQo/u5qecT2K/S1zr72oaqbOqkiUTPRpuHuDVWW4xvLUjJOAf08I2Kf5SKwLya8rRLrOnG64patzT8v/TxKOJL4O1vOAEllNBjB4NQYp+kmfSa2fP54jDjVQ9fGbxfSYdIF6pJBMedJ34E4Xq/xJZJ30g74LOZ2+7HZROMq01sNl8+o/e7IUZlp4Im7BBel2myIJS30pPZyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 09, 2026 at 08:36:29AM -1000, Kanchana P. Sridhar wrote:
>On Tue, Jun 9, 2026 at 10:50 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>
>> On Tue, Jun 9, 2026 at 8:40 AM Nhat Pham <nphamcs@gmail.com> wrote:
>> >
>> > On Tue, Jun 9, 2026 at 4:51 AM Longxing Li <coregee2000@gmail.com> wrote:
>> > >
>> > > Dear Linux kernel developers and maintainers,

Thanks for reporting this!

>> > >
>> > > We would like to report a new kernel bug found by our tool. INFO: task
>> > > hung in zswap_decompress. Details are as follows.
>> > >
>> > > Kernel commit: v7.0.6
>> > > Kernel config: see attachment
>> > > report: see attachment
>>
>> If I am reading the report correctly, it seems like we are doing
>> swapin from the page fault path, and waiting for the per-CPU mutex
>> that is held by kswapd. Since we can sleep waiting for decompression
>> while holding the mutex, it's possible that we have some kind of
>> priority inversion where kswap held the lock, went to sleep, and
>> didn't run again for a while. But that always been possible for a long
>> time AFAICT.

Cool!

Worth rerunning with CONFIG_DETECT_HUNG_TASK_BLOCKER=y, Should be on by
default with CONFIG_DETECT_HUNG_TASK=y, but I don't see it in the config.

With that enabled, the kernel should hopefully tell us which task likely
owns the mutex :) If kswapd is sitting on the per-CPU zswap mutex and not
getting scheduled back in, that should be pretty clear ;)

CONFIG_DETECT_HUNG_TASK=y
CONFIG_DETECT_HUNG_TASK_BLOCKER=y

# detect after 10s in D state instead of the default 120s
echo 10 > /proc/sys/kernel/hung_task_timeout_secs

# 0 means use hung_task_timeout_secs as the check interval
echo 0 > /proc/sys/kernel/hung_task_check_interval_secs

>>
>> Do you have any more details? Is this a new regression (observed when
>> upgrading to v7.0.6), or is it possible this was a pre-existing issue
>> and you just found it on this kernel?
>>
>> > >
>> > > We are currently analyzing the root cause and  working on a
>> > > reproducible PoC. We will provide further updates in this thread as
>> > > soon as we have more information.
>>
>> Yeah more details like a known-good kernel version, or even better a
>> reproducer, would certainly help a lot.
>>
>> > >
>> > > Best regards,
>> > > Longxing Li
>> > >
>> > > ==================================================================
>> > > https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?usp=drive_link
>> > >
>> > > https://drive.google.com/file/d/16xzUrwOvwE67cnMPH3AhhNRWq6hr26Qj/view?usp=drive_link
>> >
>> > + Kanchana, who last worked on this piece of code
>
>Thanks Nhat and Yosry. I agree with Yosry, having a known-good kernel
>version would be helpful.
>
>Also, it appears the kernel stack-trace is from before the merging of
>the per-CPU acomp_ctx simplifications wrt the mutex, and resources'
>lifetime being tied to that of the zswap pool.
>
>Looking forward to more details.

+1

Cheers, Lance

