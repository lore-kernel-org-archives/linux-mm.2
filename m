Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2266610BA445
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FAE6B0095; Fri, 27 Mar 2026 04:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638386B0099; Fri, 27 Mar 2026 04:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DF76B009B; Fri, 27 Mar 2026 04:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41CCA6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:37:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D91FEC564E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:37:38 +0000 (UTC)
X-FDA: 84591189396.02.8B0F345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2714A40003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:37:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=op4oNO9B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBTTNErES2h7ZZqatJkjCZFo6dc3d3qR5Xgs0ABbhes=;
	b=phTArkeQmm0iRwDzA4BcXM4fj9bKJCNZWqA1O3kDzqIJcS8GU567CrGNHyLanXEWF7hfoF
	lHRF6ccyjOypwniH6qUoJQASOF6nGF0c5uvEAwRPcR4Qc+A9Ze1K8JkvTgnXt8Y3dDfs2v
	L5VNArD4TSHqReVo7Mb/LXuPwQwsYxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600657; a=rsa-sha256;
	cv=none;
	b=fHzYOUuwC8cOqJ66qQ8cAVMtWYX4mKgihC9fC9kZ9O9529kriqst0NIY9/YsU2fH9oLJKD
	c6JP4Vat5qhLMBMXBMA6L6SdgXVwfuInEdFEcEurt2E6qoep/hDDjCJph2u2UH1aTq8L5I
	cCTPiBaQz/xxiz6QRGCIQsFYfjU/cIk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=op4oNO9B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68DDF61334;
	Fri, 27 Mar 2026 08:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD0FC19424;
	Fri, 27 Mar 2026 08:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774600656;
	bh=gNvS39gg49GkZoghluTdBWb/NlvTxoQRrrHU6/cFDj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=op4oNO9Bo3cTK/FRl/G2SS20U2utHZhcO5d6PR7ol9YAQLrx8XD6jZcomZnXpDZy2
	 QE+2zSF1xDyqclr3Pl8S8h+3xU+TKx3Viadwl9Jo+GdhLfr+JjzN9eTCKR2kJ4Qp40
	 DMRTv6y64LvssQqJTJgJ2z1YfZtKk3Q81nSIryiyaJfgJa2UFm/HgF1iabkN4//VKT
	 SqZnm7NZhpjVd6vsPul8Suo1BG/CjoS12C02L+NHEw+wIPRn70K3wHQ/dWkWUDhcND
	 /cYFPn5zlXE9plrziydZ+DgN/AjAU6g7WfFj4upX0QMp/kVq61AZvpQXYaMLdHMyat
	 oOc90sLWQKA2g==
Message-ID: <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
Date: Fri, 27 Mar 2026 09:37:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: Josh Law <objecting@objecting.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Josh Law <hlcj1234567@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2714A40003
X-Stat-Signature: q3rmawub7ejdmw8gfdigzk3bkf1dfd3h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774600656-663328
X-HE-Meta: U2FsdGVkX19Y+SgAfmWxtLaPKOXacs11M+YJAmhGUMiN1m7caPJ4You+lp9tZBIeDxUv9sXkTniUcOEC6Fcx+7Oq0aKnROHwIsiNH2WgmG/pEbzb4khgl6Uf5JknZtr3k2ZJ3xKOTrDZCWoteGDXKjvR/cQap7Ta1/AE1QuDoiQlQ5pQ1XZ9Hc6paWPEh2mNDZvC5J6TPU5et86vG5JX8n35HlIFxB1089d+OwxsqWjeden81PUe/QpXA3nAFLdVAESmlIMfw2W2ICOf5WnX7TUIz1gcFPID5G0R59O4oNwjdzQPOXzUBNvdd9ORUqOxoYLVGVGanAmXN5o3viw6QRwx0Mk2PVs8f8H4UfZvRM4zD5YC7R+ABXa4UTN0IJHK2e8dOX+fKDVRdcd/piniTvktMHoWAdqdB2hvLKYn9hPjckc735y40Y7PXjTfbZ7/r0lB/pFURlEZsA0K60NWjWsEXy4zUFLbBgnTUODGKGr4ZEUn/9pCRL9bTS+r1dAYa1I+tuVhWlwpL0tKM2t/JRoaq4MD/3PnF9Qy0HFprHRfpqBAHhCoyFmiyPBpSJlDvxxvjSXZ/7J6ShRuAfMTgnJq+mRNmjFaNDWTMwpN8fe2CODlOf07NRjz/EQb7irEIlj7JdlVW2hl4aXuSuU5BYglsVGvUvG9+9tevnx9jWAPLf0ogoANhvrAb2f9QH+q4kYGlqJHqU9OsHDGxRBauUtdY2k6yF94a64fbyaQxKHOe4IkUZg2AK4EEFMHyV+lrPue3bZUfP5Bl20C3o3jYhKxpvXY3qGytUNmjjeTsyBUcOv8AHmYpo0K1qsXZDTM+jVy5y0qrglVOSQm4UIHZPaueAr3AL9/SgTPAcO0+/o0gSe4iMBfRsC/9LZm5DNLJZrmLyjAeUL2bAQInKkI6Qp3sf6ITgplTVmt2NbyimKogpb6NWp4IYc1Xq7CS7+/KCX1gWbwQ+nqwZv3DpE
 RsNYfpwX
 PMKvr6BjRnwhCGcgP0XbtFQ/AnLSdJgWmAYooZYjzkFn09WI1H/S6GWg+cqNLZ0SqEtaTfoat+Nd/Es21OckTTd5zCbuCKJjO5yjAOKRVznv3IcC4cegcUuNpwoOFclCNhsFIVJsne+tqBPW1R3Ndhor88alA++r6weUfSPg71DsKWD1fp2QLPP9cRX3NNTJgbOr7yDkSxHxRx9/ujPjVbHFIG9LfqM0Jud+b2LpA+vj87SG5dWyi2BjCEXh6tK4NYETsLQjTCC2VFK18GcBcuyvDgwWPj/QVVK5zDlRWdmpiWncxlx5Zrn0E2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 17:39, Josh Law wrote:
> 
> 
> On 26 March 2026 16:33:30 GMT, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>> On Thu, Mar 26, 2026 at 04:10:42PM +0000, Josh Law wrote:
>>>
>>> I will be absolutely transparent with all of you here, The commit descriptions
>>  (The long ones), Use AI, to be exact! Claude sonnet 4.6,
>>>
>>> Additionally, I will make a promise here,
>>> All of the bug fixes I made, all of my lib/ bug fixes, are made fully by me,
>>> (minus the commit description for some of them) And I can promise you that on
>>> the bible, If you have any questions about this, You can always ask me
>>>
>>> Forth thing: My patch volume
>>>
>>> To justify my patch volume, I am a "excited" Developer, I love the Linux
>>  kernel, and I have a passion for that, I am very very sorry I filled up your
>>  mailbox with my slop descriptions
>>
>> You're obviously lying, and you're not very good at it.
>>
>> To reiterate:
>>
>>  Assessment: ~95% probability all contributions are AI-generated. The
>>  evidence is overwhelming:
>>
>>  1. Volume is humanly implausible — ~30 emails/day, 5–10 new patch
>>     submissions per day across unrelated subsystems, from a contributor
>>     with zero prior history.
>>
>>  2. Breadth is the strongest signal — no human newcomer simultaneously
>>     finds subtle bugs in bootconfig, vsprintf, base64, bch, maple_tree,
>>     assoc_array, io_uring, AND writes a new DAMON NUMA tiering
>>     module. Each of these requires deep domain-specific knowledge. The
>>     pattern is consistent with an LLM being pointed at different source
>>     files to systematically find issues.
>>
>>  3. Bug-finding pattern — the patches cluster around unchecked return
>>     values, type mismatches, resource leaks, off-by-ones, signed/unsigned
>>     issues. This is exactly what an LLM produces when scanning code for
>>     potential problems.
>>
>>  4. Rapid revision cycling — bootconfig went from v1 to v8 in ~1 day. This
>>     matches AI regeneration, not human revision.
>>
>>  5. Feature additions from a newcomer — glob_match_nocase(),
>>     glob_validate(), debugfs BUG/WARN interface, and the DAMON NUMA
>>     tiering module are all non-trivial features. A first-time contributor
>>     proposing features (not just fixes) across this many subsystems
>>     simultaneously is essentially unheard of.
>>
>>  6. Zero ramp-up — the contribution stream started at full throughput with
>>     no learning curve visible.
>>
>> Please go away.
>>
>> and >/dev/null to any further correspondence from you, other than NAK's when
>> necessary.
> 
> 
> I am withdrawing all pending patches, I am not gonna even touch artificial intelligence again, and I am going to take a couple months break

Josh,

in general we try to be a welcoming upstream community. Finding people
that are willing to work on the low-level bits and stick around is rare.

At the same time, we need people that are willing to get familiar with
the code base and technology, so they can help out with review and
provide long-term value to the project. AI use is only partially useful
in that context. Certainly not for writing patches as a newbie. At best,
to double-check your understanding (e.g., AI review), help you learn
(e.g., explore the code base), or improve your writing if your English
is really, really bad.

I prefer someone trying to use their own words to compose a change log
and actually learn something on the way over some AI slop that reads
nicer any day. Often, when you write a changelog you actually realize
which corner cases you might be missing, that the design might be overly
complicated, that, maybe, the reasoning or motivation is bad etc. It
takes time but you actually learn something and are forced to think
(crazy, right?).

The same is particularly true when it comes to writing documentation, as
people raised earlier in other context.

Having that said, your actions made a lot of people's alarms go off and
there is pretty much 0 trust now. As Lorenzo says, even now we are not
really sure if you are saying the truth right now, which is a big problem.

If you are, in fact, a real person, and are passionate to work on the
kernel, it would be best if you would start things very slowly and don't
use any AI for crafting your patches (including patch descriptions).
Stick to one subsystem and ask people what good starting tasks/projects
could be.

Ideally, you'd find someone people trust around here, that can verify
your identity (i.e., have a video chat etc) and start mentoring you on
how to start working in the kernel community and gain trust.

Now, I am still not sure whether I am talking to a bot here (there are
too many things Lorenzo points out above that are very suspicious), but
I just wanted to say that there are ways to become a trusted
contributor, and that information might be useful for other people that
might be interested in working on the kernel.

It's certainly not by flooding the list with AI slop.

-- 
Cheers,

David

