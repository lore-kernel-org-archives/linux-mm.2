Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C85CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240248E008F; Wed, 15 Oct 2025 21:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2176C8E0008; Wed, 15 Oct 2025 21:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154008E008F; Wed, 15 Oct 2025 21:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 089758E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:11:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A779A1DB16B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:11:04 +0000 (UTC)
X-FDA: 84002198448.07.C7ACECE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id B67D740005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:11:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjNeyfN1;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760577063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eWglOj1q+AvMecMj1okWvapeunhbN56i+AV+BTzGlg=;
	b=fVZ+X4q+BBFHhCGVDgJQ7R7i1oMqF5UK4jIFxYoi0bnOt6ayl/aisK/7MRhXb2UCC3itX0
	4WKa3ITnzed26m8Tvtpe+6qTo1wxNw908m1Lc1VVjNvliHOmafW5YpDglv0iwLJKOAQf+n
	aO/5kRYu6Bq5HIWPI94YUHx2XdFT5GE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjNeyfN1;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760577063; a=rsa-sha256;
	cv=none;
	b=NrjKSaqEQB3pMtxyMWEFWyQPGxU4DkjjN/NLuDbTKvqzruGUyN4HnUnPzFtb4Z6wHg4KOu
	jnmspQX3aOgSAsQ4uEOulqE6ecDfrr94Y8j+OTvUJ+ZAAIshu3DmVHDBtxyEzMdq2P27cr
	QNJUZoq4rOo1vtPmyq7gpFmzIkwAonA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760577060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eWglOj1q+AvMecMj1okWvapeunhbN56i+AV+BTzGlg=;
	b=UjNeyfN1lT1QbHQB+SBjn0crZxw3AICe3s9vXl69EmVdsbWMGRugblFUU+RtOSrApnbuYn
	qsCHcCG9o2C7orU+K/C7S5ix0iMllM0rqLx3c0zQqw3cXquoFBBCtvZMdJqdhRfToEAkVd
	8vY7AV0p6MJ6tuTF+BMvv/UuTc+Bd7M=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,  andrii@kernel.org,
  ast@kernel.org,  mkoutny@suse.com,  yosryahmed@google.com,
  hannes@cmpxchg.org,  tj@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,
  linux-mm@kvack.org,  bpf@vger.kernel.org,  kernel-team@meta.com,
  mhocko@kernel.org,  muchun.song@linux.dev
Subject: Re: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
In-Reply-To: <e102f50a-efa5-49b9-927a-506b7353bac0@gmail.com> (JP Kobryn's
	message of "Wed, 15 Oct 2025 17:21:46 -0700")
References: <20251015190813.80163-1-inwardvessel@gmail.com>
	<uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
	<e102f50a-efa5-49b9-927a-506b7353bac0@gmail.com>
Date: Wed, 15 Oct 2025 18:10:52 -0700
Message-ID: <87wm4v7isj.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z756e4b9d9pe9aokxynw9zg3zxziois9
X-Rspamd-Queue-Id: B67D740005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760577062-722929
X-HE-Meta: U2FsdGVkX1/0+qpNIM1cmAjs9CYFA0NUrv1g/jkxr4TLbtkkYW21PnDY5W7I88+1NhywPZnvQCDoUGEURkKrjVQoME2FCX7CemnlJkOfAZsDME6RA3EvVSN/2We2IqpUj6NiTrXActXC/thKyHGtCqYctSxMQ/1tqADYIkQBzL6Z3xAx+wXKHYem3j2uvmJiE4Am0P0Edu/AHrP3QEwnRiuSBBE+qgGDECvz31sZegqfoxuxKpd06GykxZOMSPTy5C0KsiYr8A1UJmijdBu1CWgpRYXliSzSb8B9QqQ7n4p6Ugl7Uvp6pc0G5FhPs0C61FCSC+QKJYX3pbiTOZJG8qOSwPLGEtfwqmhLj24X3iUcMdFGdgq2Fv2BXHLCwOYwM3JDjJFS5hacVEyXHNw+PuRZcIb+CVnu1Hn3otTkIkTSDXU6kNCA8hAs2ekel02Rlf21TRa7NRWxKZtiC/7vhxOrAHrZohGkili7Nrx+XFVnKCINKZhV+tfwjDzJbZRGqg3MJD9THtc31GQimdHnyT0T3og6QBfpLgO4mwLm+exjkhsJnN0dxJ8ONlODCLODYh3z3C+/AX/xalwBWhSgOXW/skDEiy426vXoB/24rmvm6aH3f/i1/4FnEAyFszHsueBgD7xl3zNVoQOrbnY4cEHzqTtyMzCmISb3GnKNlNEUBw7zcBdodxSNLT5Tjus22FPsTZfsxESjdx/CbjE9qEf2CHZL6h9GmLjU/LlDS06hpr/Hv4WYR/Us3rsMtkNlYnbTSu0vGyFsuyPAr1lIaQf/UakIMhXMGy9U9mGzvPV75BxOU4J+IkEULEzlia2yeL3++T3NX9I/mT3HiFWQ6OJ9hs1n4nMX4+D8T4/b8MUXjqClrBW/lq5t4RPXcyUSy8SA05HgM6nC6462igDeBFMWyxBqGTvfIOusgFZQmqvqKxVHl5BtcifyDSN0TOWnqCnhk2CRnyIUff510KB
 pRG/MQoR
 /aHYMDJU0Dz/40rHo/jzopqgmmZtQw9/hOOIH4G5GPzlsMaF/sx09CKdLRYLRoLQTnK1BHsYKTSFu9NYdV3rZfJo2hMn6WizFK86qRp8MsikrAeMi+CRZGve4MPQh4FtfDadLf5o1hBuF1paG17bowIax27+JimW1RYXbTSWMb2S9EODncOHCybgduucFI1MWQ5Ub6J08tySKioRZvCz4rc43NZM91hIc1l45rFPdKzLa0cHt/RPZpjv2Kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

JP Kobryn <inwardvessel@gmail.com> writes:

> On 10/15/25 1:46 PM, Shakeel Butt wrote:
>> Cc memcg maintainers.
>> On Wed, Oct 15, 2025 at 12:08:11PM -0700, JP Kobryn wrote:
>>> When reading cgroup memory.stat files there is significant kernel overhead
>>> in the formatting and encoding of numeric data into a string buffer. Beyond
>>> that, the given user mode program must decode this data and possibly
>>> perform filtering to obtain the desired stats. This process can be
>>> expensive for programs that periodically sample this data over a large
>>> enough fleet.
>>>
>>> As an alternative to reading memory.stat, introduce new kfuncs that allow
>>> fetching specific memcg stats from within cgroup iterator based bpf
>>> programs. This approach allows for numeric values to be transferred
>>> directly from the kernel to user mode via the mapped memory of the bpf
>>> program's elf data section. Reading stats this way effectively eliminates
>>> the numeric conversion work needed to be performed in both kernel and user
>>> mode. It also eliminates the need for filtering in a user mode program.
>>> i.e. where reading memory.stat returns all stats, this new approach allows
>>> returning only select stats.

It seems like I've most of these functions implemented as part of
bpfoom: https://lkml.org/lkml/2025/8/18/1403

So I definitely find them useful. Would be nice to merge our efforts.

Thanks!

