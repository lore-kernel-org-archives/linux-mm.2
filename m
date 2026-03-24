Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C810F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82326B0088; Mon, 23 Mar 2026 21:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33736B008C; Mon, 23 Mar 2026 21:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C492C6B0089; Mon, 23 Mar 2026 21:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFAC46B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:08:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61DB814100A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:08:45 +0000 (UTC)
X-FDA: 84579171810.20.9E45DB2
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94CFB140002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:08:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cfC4g1+Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774314523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL/H9vnrwh8k2n7/j6srSqA0EyN3fEIrRdwUnMet1/s=;
	b=HNEz+M2kEUQQuDZNB+bgrb3U8bmhOHZszf+veFOjPZVxnbEpMn3ZkixX49aDL7habrg32h
	2p/ldkF292XUjsGqtGivM7VP/zo4E6+X4jm2tOC7L++A+0pvgMKfuzyAYQ17LU1ihyE/Uj
	MOOlsm6nht4AC/x/26BKUm4r6MAD3Eg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774314523; a=rsa-sha256;
	cv=none;
	b=J/ye6/KrWznsG/GMqPLFimcEbA0EOQW7ajofRfLIWMD9y6JQLIFapb3BCeOU4GaZzls1Od
	1LFgsp3qma3iQhvNa0VbZRgthNZYfHGwcajPccgShxZKF2a1o3+b/UqCfP7BaTXlsXl13l
	no+6BjRqbh/bQvAgY5UtqK/pJExNm+A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cfC4g1+Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774314520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OL/H9vnrwh8k2n7/j6srSqA0EyN3fEIrRdwUnMet1/s=;
	b=cfC4g1+ZyWDKntwuCkIXgBjduic1ZDBTiNgA+JMPU9NQbDdq0HfcbRZbSHvcXQPpT2ZDci
	+aGx6+YOoHG3ln0WrBfPktiZ6aztXsAk1LIdJpT9J/EPuHaBGgU3dDunKnpl+9UPqFsB5S
	eQ8AEY5V8LHLzw7zkH4c3AUJ2odMins=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Nico Pache <npache@redhat.com>,  Ryan Roberts
 <ryan.roberts@arm.com>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Lance Yang <lance.yang@linux.dev>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
In-Reply-To: <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local> (Lorenzo
	Stoakes's message of "Mon, 23 Mar 2026 11:31:29 +0000")
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
	<20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
	<5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
Date: Mon, 23 Mar 2026 18:08:27 -0700
Message-ID: <87jyv2hw50.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 94CFB140002
X-Stat-Signature: 961sd4mb1o7ksi6jwp3dbfrhc7j8s9gz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774314523-418992
X-HE-Meta: U2FsdGVkX19iD5GsYu02tk/W8oSwhyxuaM8u4mL96eDXzWfYYZ7k1It1iRGX9tJ2y+lkRaQ6C/zJRD7LonRaBx4wghrFEVseG8XwXBSL4qQdGdK75m4+L/Xu7sC2SvduqGaq8/U2YfFu7FUpVZ7gktVV2Li8dxgND7MvXl/n5fLhK8TNiAEwCS43XEChvHdEA8vjcP+gTX5WrZD6cj9GDBsJQm5siD9zrh8uHmP+KTJdIcdvAQaSNQFfiOiNk0TbX96S0UcJtksMjnsiCXdrLfA3Jne7fE1byjWKqG1q+qh+0//L+M6cI9Z9g9W6yyvGewgHuddwnMTRus7DFns3qQTSiLwwu1869J/m7NXgl3qc+j2c9h1u9BNz5WZEKBlIuEDQub539+0VPdkW/Ztf8M2q7Amag3sJOksXjwGN0TMonvy5es+Lr1R8hBXPP+teyGotVtdepzQ7d/W6cAQBRgLSLu12UaGXMysHwQtSC7fXcQAsRoebbBFMgnlUy3b40l29FGHrgkKXDIx88H1RCbIn+zZ6MFlguKXpxyXraNYINV6thayXlDj1h2dLCMKz2LvTX2abN93J6/WY3JcvBtWGVr7C7uryy5BFBO2D44Q2qYqSV/D2xGE/rBYAR8shc/79ebxu1uV2hXllgrc56ZYrNo1KDejFN3UtVvEhUfipPJ2pmB3yPomEElrMhOikijqritHw9xH7ncqqiCtatGfq7ItDw2+ynfXMiRleh9941eWLjJm/jRaW7k65U0JMESLapN3tiNk5x3hDxgp0jlETAR789kHjBrOGtKFj6c29CL/VeqtF4satcgprcKkwHD7c/r+V9d+BhEzjSdoOVFlAiR4mTjjl7mNhpPgtlgGfSipUXRwvTs0zFCdWwAFQLVHZuTV9lp4JUvQTakJXW84sZa92U/KPWkLQ/7hfU/EVnnjJPwxDMdFtb37VVORlcgCN3k9s29StoQdXxbT
 iqzG+rGk
 /vOUV2gjZKe2YveSvAOp3TKcYo5jy5tUsLskka5nDXpM3MFJJdt2IwWsg489NgAfptZ01ttnSjBGWNcMnonegoAt6tPnWO3w50BKmEKuVUlFH68369NaNtH4/xro0APvXlKzsgX7PjKnM46xfuqHEJ7REuNhVd4Wg5FQul8/WokPdjsdY/vwPD4CV+igYxUjXrOOvC9PrpmP8LTgVeq2wuf4uuYE/VTuIhQJB5yV+FuMkRxNyIJmL+FbFbLxL4uln1WxChruDn4izbsn08r0uBx4FkxXtH5vRUfS6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:

> On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
>> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> > A lot of patchsets are "failed to apply".  What is Sashiko trying to
>> > apply MM patches to?  It would take some smarts to apply the v2
>> > patchset when v1 is presently in mm.git?
>>
>> ?
>>
>> The way things are going at present, I'm just not going to apply a
>
> 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
>
>> series which Sashiko "failed to apply".  And that's cool, I'll just
>> wait for a version which Sashiko was able to apply.  And then not
>> apply unless all Sashiko questions are resolved or convincingly refuted.
>
> Andrew, for crying out loud. Please don't do this.
>
> 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> apply to Sashiko, but do apply to the mm tree.

I'll look into that.

> I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> experimental website applying or not applying series into our work??
>
> And 'not apply unless all Sashiko questions are resolved or convincingly
> refuted.' is seriously concerning.
>
> The workload is already insane, now you're expecting us to answer every bit
> of nonsense Sashiko hallucinates or misunderstands also?
>
> I say that with no disrespect to Roman or his efforts, but as discussed at
> length, it is not ready for prime time yet.
>
> It's clear that Sashiko is not correctly handling applies, and produces a
> lot of noise. Predicating taking series on this is absurd.

Not trying to pretend that Sashiko is perfect in any way, I think a good
mental exercise is to put down our expectation how the "perfect" system
would work. The more I work on it, the more I realize it it's far from
binary correct/incorrect. In fact, the same applies to humans: I'm sure
everyone of us had once this feeling that someone is to picky and just
annoying us with finding small nits. At the same time some of these
people are extremely useful for the community to find and fix a lot of
issues. In the end, we do argue all the time about questions/issues
raised by human reviewers.

Like do we prefer a system, which finds more real bugs at the cost of being
more noisy or we prefer a system which misses more but if it points at
the bug, it's certainly real? I'm sure you tempted to prefer the latter,
but image a hypothetical system which finds _all_ bugs, but has some false
positive rate, e.g. 20%. I think it's pretty attractive.

Also lot of raised issues are real, but subjectively are not worth our
time. But this is extremely subjective! Depends on the personal level
of perfectionism, amount of time available, the state of code before,
further plans, etc etc. For example, syzkaller has usually o(100's) open
bugs, which are 100% real, but not always are high priority work.

I think that asking to address 100% issues raised by any LLM is not
reasonable (especially because it's output might be different each time
you runt it with the same input), but I also think it's reasonable to
address critical & high severity concerns. And I'm happy to tweak
Sashiko to be more conservative here, but I think it should be based on
some specific examples or data, not purely subjective.

tl;dr I increasingly realize the importance of the social context for
providing good reviews, and it can't be easily derived from the code.
What is acceptable in one subsystem is considered a bad practice in the
other. I guess the only way to get the system we all find acceptable
(and we still might not like it, who likes being pointed at their bugs?)
is collectively codify our expectations in prompts on per-subsystem basis.

Thanks!

