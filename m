Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC58C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 02:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648CB6B0088; Thu, 24 Sep 2026 22:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9816B008A; Thu, 24 Sep 2026 22:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8716B008C; Thu, 24 Sep 2026 22:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6E26B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:12:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00FD8120501
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:12:35 +0000 (UTC)
X-FDA: 85250660712.07.BB40376
Received: from fennec.ash.relay.mailchannels.net (fennec.ash.relay.mailchannels.net [23.83.222.58])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C4E118000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:12:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=hAMu6hkf;
	dmarc=none;
	spf=softfail (imf06.hostedemail.com: 23.83.222.58 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790302353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djP5XwafCJ4cxBiTvz9MUWwQtYHkRPgJgZ89NauuvtU=;
	b=4ykSZkqvtVuctc56uUD3aKhisM0a51aNQ9bjdigQLe0qwZ+p/Bj8qQNndbtfZLmzm7AyBZ
	pvgm7bS/vwSnPK57oIwYBQWo/MbHCFMpZJV2wVeAu7RhYIOac/OMoeArrZ2OJRJ51M8Gy7
	4D1Y9dvfCQ69qT79DGaG7MGkuKgHm0E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=hAMu6hkf;
	dmarc=none;
	spf=softfail (imf06.hostedemail.com: 23.83.222.58 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790302353;
	b=UI9GsFA4GOAt0SOIBv1z86C0VTiduD3WoYndQaSYxPCNjv/Ku7n4kH1QzyD1WOJfY6opiz
	jO33il+jC1vU2XNxXbVxhY+HQdlySsibbO3tBft4CVwVZvUarRzOdM7kJso9VybKx5LbRv
	o05qDH5J5l6K1nwWapK81KWbuMDnwp4=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C72233E1FB5;
	Fri, 25 Sep 2026 02:12:31 +0000 (UTC)
Received: from pdx1-sub0-mail-a247.dreamhost.com (trex-green-6.trex.outbound.svc.cluster.local [100.100.66.64])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 1D8BD3E1F9D;
	Fri, 25 Sep 2026 02:12:31 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Battle-Callous: 7196804e2346228b_1790302351581_998903741
X-MC-Loop-Signature: 1790302351581:2710523619
X-MC-Ingress-Time: 1790302351581
Received: from pdx1-sub0-mail-a247.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.100.66.64 (trex/8.0.2);
	Fri, 25 Sep 2026 02:12:31 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a247.dreamhost.com (Postfix) with ESMTPSA id 4hrZ3K2pmmzyrG;
	Thu, 24 Sep 2026 19:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790302350;
	bh=djP5XwafCJ4cxBiTvz9MUWwQtYHkRPgJgZ89NauuvtU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=hAMu6hkfDkFG2sGtKgJUR6x7TvXaA3XybQus6zjPGz9VFNcIW7t8XUUdrqX1OKRYz
	 nM5UTYkQQuwfkaNcmQZFlUKnwOF/RxPFzFomIY84Nj5u4tp2nXBmx0nCfRcsby2Vrs
	 2ZxdDjuNozBGTMHqt231JsCFHmbhKF+xKZakbXQ7FG2W7scbEt2FpyOSsCofD8cjBI
	 fc8VKBC0/wbB2cOgwynv+w8c+yI639oEUYuairqMoyUEP0XDBdU/NCmaRawkq0KY/b
	 97IrhjjjR1Ag72f0WB+DTGbwbu1rtFFyQvS7ZOxYleaYobkYKAh0JyLKnpA/VYFhlP
	 uRXf4PhqTRtWA==
Date: Thu, 24 Sep 2026 19:12:26 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jic23@kernel.org,
	dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <20260925021226.52kpnmvfylw73dz4@offworld>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
User-Agent: NeoMutt/20220429
X-Rspam-User: 
X-Stat-Signature: 4n9nfc411mxczefzbr99znwwobgg3kip
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C4E118000C
X-HE-Tag: 1790302353-814309
X-HE-Meta: U2FsdGVkX19JyIMYoXbwT9s60p54BotMXUD3wBbGmAfrbTxI2RjJ4HI9RXE2OhAaBQSMlGwTVVIgKmi+bBibBiWPuam4K/hRT/QASS1nz5npUTn36/ZdB68rvJJfUJj5gX8LcgZj2VXnKyTnEDUKmSjs8/vt90vvtT6HB8Krb4wBW2MBLYQgrP6VJXCdEPTui8Jkj8TBkyOBNnQAvbr5MLfnO2Hn5VqikkTA+0KYcrFlTo00vRO9K1xANe9yWWBYmnVK5XedDtINfhwu60RsbXxo4DukvniZ99u2jX9HPqCLbCTTiRQGNEIac6GchlJn7O31o/7LZZpjOb7LRx63Kg5WIve0TOyf/uA1UGi4XNfKsfFGqYxlM+eiBV4FhW3yuNdNCj/C5CHatS6kxMcOZiDCCaBlzUXdNv6wwk/JmmkIIEpxxYOG61N6diMBWUH5/M9yPw06ygt3NEIxjOTa81NEEVuWOzfxvb7bF8c42QVgPLMJPQydLbdXLgB2LVRCeFO6Lguo+7hH5Lm8TGE3V0L6fNCfNnWP+z1808TSXRT1VNEdOzEQxvDCLR9xEAWE4SPLgqtAl+BN3bk2jnENbruxS6u8iNMfafcbeN9DGB2nr4EDktHIgS9+7xLUBedkZcdW1NOHKEbFNCQ5aRF7Hypr708PcwtFMaJIOWi22t5/7UMaz+Jtm3iDCR+DVEGRKtJtjgRR9n2XEfhHz/G6NDuR3Txl7GpMDEbKOT0UvGZSBnhJ5rCg6qGi7+jBMDpJlDcuCQSRX8iYWr0pALdZDRVq+l94XQ7qrTou/Gg4nigRZB5P9FrveAia6Fv/4RGLc2vG7PydHQQYEGWZ+C/HLZ2u7zsI7qQn5hEf4XOfRRDAx0qSVMALXRPtDQxuysBVd+iQDpDbKEdksdZaXG6o87n+zVp8l9dlK7G6yWR+YcZmwWDtEwsHfGVkKsjFD1Rw5a7YAm7UYB2eQ4byGtK
 eHCqNvXc
 sWzuOxk9vSwys9uTt0amn25oehhF5pKlWZnmQfhA18PvP01Yb9n51qYxM6R8oRPtvA8ITBlInzGwa+YIVTiUeqpLdLk9J7WdvgKY3vE8QPbg+RZfqNS7rsJ5VFRCTjoSxRatkjnW4Id97diq9k3SKsY8wE1PlM/zVheZB665fTWk2WMjEumc1FGKrNVy/0Q/i+sDNeHIfgh4LD+hINxdtgb2vwYFBsAO0a3QMrVo0HEQbg/r0hxBgoxH9ugAt+YkHxXOL6eiDZ0XTHWVMWqhIF1W/mYtyLsqzWzMs9L6nQqFhZi8JN6ujjJIQAJtJt528o+bfterPIKDvdFjiS1FLnUPRbCp+1DljNYQ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026, Bharata B Rao wrote:

>Performance summary
>===================
>All results are on 3-node tiered systems (DRAM top tier + CPU-less CXL
>lower tier). Speedups below are normalized to the base kernel with no
>tiering (NUMAB=0). Columns compare mainline hint-fault tiering
>(base NUMAB=2) against pghot in two modes: hint-fault driven (pghot-hf,
>NUMAB=2) and HW-hint driven via the AMD IBS memory profiler (pghot-hw,
>NUMAB=0, no NUMA scanning). Single run per config (abench is avg of 3).
>
>Benchmark      Metric (higher=better)   base-NUMAB2  pghot-hf  pghot-hw
>-------------------------------------------------------------------------
>NAS BT (MPI)   Mop/s total                  2.26x     2.26x     2.13x
>Graph500 BFS   harmonic-mean TEPS           2.64x     2.49x     2.68x
>llama.cpp      decode tok/s (tg128)         1.09x     1.41x     1.21x
>Redis+memtier  ops/sec                      1.05x     1.05x     1.00x
>Microbench     completion time (1/t)        2.41x     2.40x     2.35x
>-------------------------------------------------------------------------
>(baseline = base kernel, no tiering = 1.00x)
>
>Summary: pghot hint-faults reproduces mainline NUMAB=2 with no
>regression on every workload; pghot HW-hints/IBS matches it mostly.

The IBS doesn't seem to bring anything to the table, other than just
serve as an example - we've discussed this in the past this. And for
NUMAB2 I would expect this to be the very best case in that you are
not suffering from loosing the locality info.

This is a lot of added complexity and code just to break even. And
hardware sources should really outperform NUMAB2 for this to be
worthwhile, methinks.

I know Joshua mentioned some improved PSI by doing the promotion async;
which makes me wonder that perhaps just a simpler promoting kthread is
enough, so NUMAB2 just kicks the migration to it and not done in the
accessing tasks' context etc. And Gregory also recently improved this
path vs NUMAB1.

I mention this because I have integrated the chmu as a source of
hotness for pghot and this was tested on a real device vs NUMAB3.
This was based on Jonathan's rfc for the perf driver, only that I carve
out the first chmu instance for this, and leave the rest of them (if any
for perf).
For example, 'XSBench' improved by a factor of ~2.7x (I would like to
report a wider range of benchmarks at some point, but this is what I have
now). But a lot of this bypasses most of this framework and just piggy
backs on kmigrated moving memory. chmu does not do well with
pghot_record_access(), which is designed for sampling... so I just set
MIGRATE_READY right away. I also added a pghot call/api to make use of
the regions chmu deals with instead of per access/page. The cxl driver
just takes the dpa range given by the chmu hotlist, coalesces into adjacent
hpa ranges (just 1 for the case of no interleaving) and feeds that to the
pghot subsystem as a list of these contiguous physical chunks ranked/sorted
by access density (accesses per page per second, so a large lukewarm region
and a smaller hotter one can be differentiated and promote the latter
first).

So perhaps any mm interface for this stuff should just not be designed
around sampling, and instead proper hardware sources?
A lot of the complexity in pghot can be removed without this imo (per-pfn
metadata, accumulate+decay phase). Of course we still have the problem
to evaluate the cost of replacing a chunk from the top tier(s) with the
what the low tier is reporting has "hot". And this is particularly true
with chmu with limited full system memory visibility (as opposed to IBS,
for example). I don't really have a good answer for this, other than the
user could use proactive reclaim along with the per-device tunables
(ie unit sizes and thresholds for chmu) to configure things realistically
for their use cases - prob. easier said than done.

Anyway these are some thoughts prior to LPC.

Thanks,
Davidlohr

