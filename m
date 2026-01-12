Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D5ACF45A8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F43A6B0005; Mon, 12 Jan 2026 12:15:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E626B0088; Mon, 12 Jan 2026 12:15:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C906B0089; Mon, 12 Jan 2026 12:15:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E22776B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:15:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56C8C13BBD0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:15:57 +0000 (UTC)
X-FDA: 84323964354.08.131340A
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BB77100004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:15:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="stHkps/v";
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOW0Y2WwzMDSvX6e6gxQ8/DR62t44tPrvU+xaCSB0EY=;
	b=IzYjyANOl1Y7edZkXGlckP9upI2p87KMNYwRqYWqwt3JtAl+lszX2tzoqQgueDHg/CmaWI
	0cqx/a/en1muivn/x23KgBcRt85VKktxtpgixRmiXFh9PZS7UjyfdO/MZ/u/14msOwZg+K
	EwziwRpnrebbR5UQElP1WI9gRz+P1AY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="stHkps/v";
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238155; a=rsa-sha256;
	cv=none;
	b=Z+ZcoiPjVvgVyRjN4MbG29ZQCkKw2zhc0sDqPYFVFTmbkPOfc1gRrD2Givo7tMls76yE7F
	Mp1wfePBJZ+jZFQwyI1/1eOzMNIZeZOuodAMGelRb19PJLid1KGAIRjo5qbrp092ZqPC1E
	jqbTQ0w7or/F8gEJPKQ5T0dumSVtvH0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768238152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOW0Y2WwzMDSvX6e6gxQ8/DR62t44tPrvU+xaCSB0EY=;
	b=stHkps/vtcyG6bwWOUBgkwNhYjEhcBGwxkbKERZThkcxe+4bD7FI3ULaLSlI7vjxzdPSSi
	vYJA2OmB2MHtSwB39YOg5/B1ba/whGdM6Zoj9X09B1umme4/2htOtQch3w0BMCNUEFBdCc
	3pdFzXXV499KIBrCMkX5srkf1HeNf1o=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  "Paul E. McKenney" <paulmck@kernel.org>,
  Steven Rostedt <rostedt@goodmis.org>,  Masami Hiramatsu
 <mhiramat@kernel.org>,  Dennis Zhou <dennis@kernel.org>,  Tejun Heo
 <tj@kernel.org>,  Christoph Lameter <cl@linux.com>,  Martin Liu
 <liumartin@google.com>,  David Rientjes <rientjes@google.com>,
  christian.koenig@amd.com,  Shakeel Butt <shakeel.butt@linux.dev>,
  SeongJae Park <sj@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Sweet Tea Dorminy
 <sweettea-kernel@dorminy.me>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  "Liam R . Howlett"
 <liam.howlett@oracle.com>,  Mike Rapoport <rppt@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Christian Brauner <brauner@kernel.org>,  Wei Yang
 <richard.weiyang@gmail.com>,  David Hildenbrand <david@redhat.com>,
  Miaohe Lin <linmiaohe@huawei.com>,  Al Viro <viro@zeniv.linux.org.uk>,
  linux-mm@kvack.org,  linux-trace-kernel@vger.kernel.org,  Yu Zhao
 <yuzhao@google.com>,  Mateusz Guzik <mjguzik@gmail.com>,  Matthew Wilcox
 <willy@infradead.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large
 many-core systems
In-Reply-To: <6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com> (Mathieu
	Desnoyers's message of "Sun, 11 Jan 2026 13:04:59 -0500")
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
	<20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
	<6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
Date: Mon, 12 Jan 2026 09:15:40 -0800
Message-ID: <871pjuu4zn.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hohr9rbyixzqh7b3nc5cthq3aemt6bib
X-Rspamd-Queue-Id: 1BB77100004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768238154-737556
X-HE-Meta: U2FsdGVkX1+aSfATP/kF95E5fVjFsdX6KIdNTMDhvMd+BRni5T/NgrAKfnybzSExltFyYQFUKbyZL1aPNSrpB/0D+8QkENZ+h02mJwAdmAIfy0utxqaGCT82WIofh4xkxT1MvFaPWE3DvQxKE3a9L/CwJ4qHofx2NxxQ41UpJ6V19+4G0b+lYwQS3RzN44B5SLZfH5P5xvfCMX22LG2pfdYCFdZvxMjNVZa2YgnVDJ8sb7Y06bngFau1zb1QBFxsimn6MPVarMXG2/p3m0mWhaV4GBpRnx1Kb+3c3Um7gzoA+eimg3YYJ1wuenAZukTPxQw1NFnZzXdu5WcXL3t1ODtkdcljiXJyE9D0xIYNkwHluI8Cx7eUfdOc4bEziBuWhkRnYcCfin3mmq5oEQTWBaK2QmkI+5H0qgbGkjgbaRK60Y1keZ1MGze9DF85Hh2zFYfcJY3iZ9BBBn7MScCYylp/vV03/8boUAzjw+SaifmQQqUf7jmnY0onCSVVuAoV+TkJCALFmrHSkm/jVlBkBD7RkvvcCA7WPlLoWfw5vZdzfwOQS+I+Y/ToMFsNsN6HQ0p3vL5Orqv9uGsok40v5gmE+lrdQfEusKNn7Ccj7a/WTjLV24efXo4LZWZGwpdzofFrOo+SaBql0kZDnle8pH0EmXJIZHIYPp9SKusLbBkVc4RImOC3h53GaYPOPyatUQeSljn/8crExZdwF0KaWfO6IjcEVIL5y2CkxkcpYBO8tyh4UNOV16e0vrkPr+bSs7xX9doCnbvu7ziPmngTmAVseYO4DyXO5MAHNPZ6dn9jOjfRHkj3ZKaIIY1lvKaKBRbqUI+K959pgPMaoB8wzui+QVBbTX8Jz2vxpRs1Sjzi92dSLDrDYZAOiujidHMBD4B8cIIyY19a+9mkojbWvUjvyQkJ5fSwSY0go5yi3oKlixb+8qbILecvDF5EturBJ3/D/j7WqMzlQqZR11d
 6xJ8Ql4B
 QbCZw1Q9dmW77W1cbxu2HUc/gpxCFUY8XD6z5XFE6smX8HpbaYrD2ZR5mVdAKdrBovTUuYh5e0TSbD66w28wJB67HxSZjkbNq/TLvwnCt3jMN5czFgmWpaOqsJQELfoB6MDqxfBZPMeCiXTr38I99ZpRj1zfjL+ar7JipRT6hgR585hegzpQepVd6AE4Am61ngs8CxkeDioLEOPXGL7sgvSpV3iU1K6Wk/M2rdhXCvZt2HjOT7tng24xaADloZAjOcs5AuqUpzkFSfuwsQ7uyjFPKlJ/NMSXUts+LOUuAngQUSgMD4b/iKsVIgijAFfHugboW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> On 2026-01-11 12:48, Andrew Morton wrote:
>> On Sun, 11 Jan 2026 10:02:46 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> 
>>> Notable changes for v12:
>>>
>>> - Reduce per-CPU counters memory allocation size to sizeof long
>>>    (fixing mixup with sizeof intermediate cache line aligned items).
>>> - Use "long" counters types rather than "int".
>>> - get_mm_counter_sum() returns a precise sum.
>>> - Introduce and use functions to calculate the min/max possible precise
>>>    sum values associated with an approximate sum.
>> May I ask, as an early adopter, what is your overall impression of
>> the Gemini reviewbot?
>
> The review comments were all spot-on. This is the level of review I
> would expect from a good reviewer who spends a significant amount of
> effort digging into the proposed change to make sure the type limits
> are OK for the intended purpose stated in the commit message and that
> the intent stated in comments match the code.
>
> As a patch author, I find this feedback really useful. Is there
> an easy way to get this feedback privately before sending out my
> patches ?

If you need to review a limited number of patches, the easiest way to
use gemini cli/claude code or similar tools with a consumer grade
subscription (most are $20/month these days).
I maintain a pre-configured environment for Gemini:
git@github.com:rgushchin/kengp.git , but it's not hard to hack something
similar for other tools.

Thanks!

