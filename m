Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC8DC54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 21:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE8F6B0088; Wed, 29 Jul 2026 17:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFF96B008A; Wed, 29 Jul 2026 17:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E0B6B008C; Wed, 29 Jul 2026 17:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A12C56B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:45:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 020E7A0802
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:45:32 +0000 (UTC)
X-FDA: 85043146146.01.EECFF4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 275744000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:45:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xq4WBuMY;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785361531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDAZ9vi2KsO6qrLBZTAFU1nlDgmqJpzCkJDjK+DL7n4=;
	b=rxsf87ooFqP8Q4/PVkOGXd/ap0LADgllWtiymVIo10Wmo55HNzC2AJfuL+nGdvfEplQgH8
	5a4i52I2JMHXYt1Ai9ZWss9Q9F5BFj2x/ETvPhLT0+EGwUJyxKnwE7e6PcFvblNV6mQSbt
	IZmV8w8VbFdI3SzLtqqEzoyCQctrqHM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785361531;
	b=ngUU0ywB0USGz/9T6v3grY6Sw7rke9eN7mCOgPPcABodR5dwIFHgboimcvSuZYhyuzsxWT
	qBL6LyPMZO5fj2pNp8yGPlZ53Srq+fBbn4TIIGQe/8F59NTSErTAmMZZXXJunWMbz4hjOi
	JhkwLKLDNlSqejB9ndSHlP3aIyqkt0o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xq4WBuMY;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E712A600AA;
	Wed, 29 Jul 2026 21:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733FC1F000E9;
	Wed, 29 Jul 2026 21:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785361529;
	bh=oDAZ9vi2KsO6qrLBZTAFU1nlDgmqJpzCkJDjK+DL7n4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xq4WBuMYGkMr4QPhjIapmQ2FXmFaBhxTq6Uvu/arWojlSM2Kge4kTP5v7lG1ncA/M
	 TNaJyESRoeFo+/uRbaFe2TBNtGfNVgiE/v24u3o7ycKwhIAGpFCkTFuRi2fjbGTGt1
	 orij7001+mUUXCUM8Pct4S37LBatIYD9rmNGnYoo=
Date: Wed, 29 Jul 2026 14:45:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Artem Lytkin <iprintercanon@gmail.com>, linux-mm@kvack.org,
 urezki@gmail.com, shivamkalra98@zohomail.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-Id: <20260729144529.e1f1e0c7525954d23ab6a051@linux-foundation.org>
In-Reply-To: <ampGVI1MLmnLksnN@casper.infradead.org>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
	<ampGVI1MLmnLksnN@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 275744000B
X-Stat-Signature: qcyxe347p6wqu4xrectuh7w1cfzezznk
X-Rspam-User: 
X-HE-Tag: 1785361530-964332
X-HE-Meta: U2FsdGVkX18forcuHIkn/lFGyN7vNhlZJCzdFssNLzHRpqxVJlm+gE4SpOLvv/qSdoYM6cOs+KLr3a8umwEhEnEu3Yqf5JkPVga/bmQcZbjTZMMADIZnHR7XZ+u4BKStJDZI11vTFQTSn+Za7h/W5dneGhxKzmnl19QoRSV0IQ3iHpFzP4jdaNAgAdgLuesN/DDD2rSh+KJprwMJvCZFNEy19hf6+Kv4EWaFEE+Wmqsi2EIbKhcmz0/pYzgucHOIeK6zy64W6DCEY3C1IqEuDa0nuzU3WmdwLF3p2ovxiHSbzoX3bnaessCGgTokhuvGvxZiDesPSdQE2Q7NwpnawiAgDSHFyaK+w2ih7qul1bSVKgiwqbHCNrbKit0zzSb7S6Z2YHSbXBK5g4Ge/kyZeLFvgdr/2sGRovHp047+GUozH1zWqGwDkEyKSe76U/VHEsjrPS6CXvWI/FxzLQ7v3w24eQUlltPsJVsJ1xw217NN2QRw7OYQD4Vq9VrDDUU3zKOytGFBgqCjhV8ldqYIobKHIG8qulLZG1uiPM0op2Dxo6wEdHpo0mw1O9zrltvmUPefjJ+1WrLTe9f9SUzys/5XYHqLRXsKXAwryS31dNvUQOhT2htAe6j4kh7x6pIv5XPY0pEkwEeP3apbwKh7afprEdkQarcLmud70vAut7t4/iNx7Wo8r1/TzaJLpgxSIQf1gWcur/gCGhg3I6JHdGHV6yzKXA19DTSBa71RPcyVqMaDflXLns5ALQ8gf/6q8Id0E9hbcpbKeuspZTWRjZ2M/AcuX/HJMyPq5cKPr0QH7gDsYFGsGHTLK/uNdZS9IL+GA1SO8uDJFYfAZNbAYPz9pY9K+qWIJpvNt3zeeZilJwLdz9kTrg6ujtLXuYgzX/Zdr+6wGkbyhLcWBeoNrkTErnary2GCaAGSiUycZbwOCocn7ZKuSPf69p2sMlA2LvuvDUV10NL3i1uEmH3
 xJANiLe2
 SElTaKR1MTXYF+sY6lmh91mTJSQ3ze3ji9kIuaJTqt4IFsxKcR6LsjUM1GTxH06tooNIRogGcmr8pvvV6kOXH8hueAkHXlru1mdzQtcjPcf82xMZcklQWcDf4Fx2HY5OSC4an60dahBS51bdL/V+eNM/P23N7ZHlu9I0QsL9A6UknNxVX1enYnbdznNdQ0IoC25jYbJQIFijgc6Q+66cBq2TbeDDfSqweKz8AUmb/5VWdenf0LwNpRe31aZ+l8Kv2oiE6T7ebPnOSBQWXybeuue5BrAGl2UIbDwbujOfq2fkSxO4RJ/lgZ6RmHo6Jh1DOruoiYNb+rdQA6cCRHhNHNaEbToJizB46HziriM4M56gbfTfrWr+M3SK57gs7Cvyred75
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 19:28:36 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Jul 29, 2026 at 08:57:08PM +0300, Artem Lytkin wrote:
> > A vmalloc area can hold more than 2^32 pages, but the page counts
> 
> I had a "wait, what, really?" moment.  And it can!  2^32 pages is 16TiB,
> and x86-64 says:
> 
>    ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
> 
> So we can have _one_ allocation that is more than 2^32 pages.  But I'm
> not sure where we'll get the memory to populate it from.
> https://blogs.oracle.com/cloud-infrastructure/announcing-oci-compute-e6-acceleron-instances
> says I can get 2.3TB of memory in a single machine, which is a factor of
> 8 away from where we'd need to be to actually hit this.
> 
> Intel are adveertising a max memory of 1.5TiB on the 6990E+ (128GiB *
> 12 channels).  So if you put 8 Xeons in a box and loaded it up, that
> could get you to 12TiB.
> 
> I'm not saying we shouldn't fix this, but it's all theoretical for now,
> right?

Artem said "That has produced the same truncation bug twice already,
once in vread_iter() and once in the vrealloc() grow-in-place check". 
This might imply that the issue has been hit in practice, unclear.

Anyway, it's a good change so let's do it.

Sashiko wasn't able to apply it, and the mechanical checking would be
useful here.  I was able to get it to apply, took a bit of work.

So Artem, can you please update the changelog to clarify the above,
redo against mm.git's mm-new branch (or linux-next) and send us a v2?

