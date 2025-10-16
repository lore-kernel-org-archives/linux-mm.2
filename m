Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15864CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 23:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA2B8E000D; Thu, 16 Oct 2025 19:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A20E8E0006; Thu, 16 Oct 2025 19:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20D38E000D; Thu, 16 Oct 2025 19:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD0328E0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:01:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B8EE160419
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:01:13 +0000 (UTC)
X-FDA: 84005500026.29.A1A05B8
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 943B6100018
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:01:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F81fm32C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760655671; a=rsa-sha256;
	cv=none;
	b=kxvKFL01ZTz+ZrEJKyMuMwWlRu7i8MmbU8IZ9F0IvSC2yEz4maNDXpqsToTcYPaLIbrqFf
	tQ3lcVzozooPKctfnAajXAydkZcQjpTHwIWtsnXPBSvF9qc5e4YhZqAD3TrNPRcklF7oA0
	qXXGKBJxvJd0Y92YukgpAtb+cJi+as4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F81fm32C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760655671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lnf0SlVNBa1MHaoQqJyDwakLfgUyXqJdGj6LGOIvyI=;
	b=SrzDp35RO+pj+Ea7zJ2DlXlXbHLMgMuxM0bHVyu3CEDgAbBk8z7+nkBvcJTD91N3dKk2Va
	lAP4WdkJNkdGoow/Rrz49uSyZz42SKShUov0ecXh2NjOv2NRrCYI1PfGrINRZ206ULmPvC
	Zk2xyhSQ7fHVIMUkP5Uo/yo61BO/Tgw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760655667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6lnf0SlVNBa1MHaoQqJyDwakLfgUyXqJdGj6LGOIvyI=;
	b=F81fm32Cy9ymkg8hRJwfUSBZlIddtx0rrYIvKNcMyGg30wqq+TDhJUAppy/zpkfR7sFmUK
	BzJxiPuQqKecd1ogb3moIZcub+cle2Sxur8YuNi1pZq//SzlgI1qC6Sn5lbVo6FSMWjAnW
	y/NyoB4mkR2VXNeGoRNPM9pqofHXBpU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,  andrii@kernel.org,
  ast@kernel.org,  mkoutny@suse.com,  yosryahmed@google.com,
  hannes@cmpxchg.org,  tj@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,
  linux-mm@kvack.org,  bpf@vger.kernel.org,  kernel-team@meta.com,
  mhocko@kernel.org,  muchun.song@linux.dev
Subject: Re: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
In-Reply-To: <2fa573e6-bd9a-46b9-a2a6-bfb233d0389a@gmail.com> (JP Kobryn's
	message of "Thu, 16 Oct 2025 13:26:44 -0700")
References: <20251015190813.80163-1-inwardvessel@gmail.com>
	<uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
	<e102f50a-efa5-49b9-927a-506b7353bac0@gmail.com>
	<87wm4v7isj.fsf@linux.dev>
	<2fa573e6-bd9a-46b9-a2a6-bfb233d0389a@gmail.com>
Date: Thu, 16 Oct 2025 16:00:58 -0700
Message-ID: <87frbimoyd.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ju98coyda9qshqig7fg4j7u8wqhnd9tz
X-Rspamd-Queue-Id: 943B6100018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760655669-230552
X-HE-Meta: U2FsdGVkX18/fpmNAjJX4EYNKmpdvBRzc7vdtOtbNH4S5zP5N5HIaWh/kH/XuADc+le8ebEgEAHujejDTxCoTdLi2nu7SwAaUN/SZQxwltw6eYiTrjMgVaxOeOdeNDr6sJ+kyNpJTwEI5MGnhP8jPlNtr8TIo9h2/JiL82mJLPgtIlEMgf9F6QXUrD5paQBeD1rzbwUaMUuRyNM+sCPuDSzkX5G4+AT9m1IJSUCVo7p4ZPjg49jj8UIiEKvWRD5zvdille4ncAkK8Mb9OKylF/gkfHyfvAgdo9Z4R/R24l7AKNQrl1AQJLHus4mNID71i8YHcjRZcUNrqaPtbsDdmxUTD7EBIOIa1kKcgw63KGHZp5VsiusduQMLEi75viWnzEs73eJh3pbdiohEZMm6oJWRlKhXWQ/mugtCQDBitLIwt4vFg4HkipmrWtvrQG4Ov2aYBSJvBVh1XhrLsNDqFgyNjvbm7pSsyE30HkWGsiJ9SZL9v90O/oBn06jmBsITB8J/lt3tTiakpMpcBD2S4qn7RUVcnFkQp85NF+/KLEUCH6fMj+NQ79ezz9lbTBRUWMF5hdBy2clbZnjzqmMYymZOOxr/eMry+gHEBTi0Q2gwoWMnXftVDSzxEdTCKHy8F1B9yAYF0ZBI4Dl/zI6ot7O5dMh4WjvwpeJwmPPmPpRjpgH+x215f+jmU9/+0G0Z0t7SlVwXKSbyvQKRF6LgXrF6x3ndar7RYMv4D7Hi38ksBu1ZHgDLVNKbKbaddoI9AD7/q2oK8S9xCO7hvxNmc4dDGshxo8VOBhifisiqYbM1piMzO6UI7V6aD9lucb2/0pfpsV5YDKIYZmiKlogIvjIkfyAP2lBpAWIYrnbZMWYCBnSPNO5KlKN6BT1sfoctVSB4D+qYPin2i2iWe7W42qelY0rctLPAmImifpf8EnSBXNrcDfmanlQ6ju3LMrSKtpW60DNhaAwqJ7rHbVr
 cMaRPayB
 51FIWbtY2loNAFqDCg5GqhUG/47NFIL+1HPUSh1D9jGBIRX67qRz8CdTJOUnBh/rKBwSQApi/VTZW5BHEkmUvT3kg4rGBSA2jzPj4A1gIOd2JQeRBgl/Ue5sWGd2JEXTtRyjVoFq3LUjBBUiwPIG/bvS8YitGpMmdR65LUVbJNQ9AWVc8E3m6/+79BRCQYX+C/fy+l4EQMwst0ApkIoYI+ntU2v1N+ElSgTEL38va47AAYbpEP2cr4iwe3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

JP Kobryn <inwardvessel@gmail.com> writes:

> On 10/15/25 6:10 PM, Roman Gushchin wrote:
>> JP Kobryn <inwardvessel@gmail.com> writes:
>> 
>>> On 10/15/25 1:46 PM, Shakeel Butt wrote:
>>>> Cc memcg maintainers.
>>>> On Wed, Oct 15, 2025 at 12:08:11PM -0700, JP Kobryn wrote:
>>>>> When reading cgroup memory.stat files there is significant kernel overhead
>>>>> in the formatting and encoding of numeric data into a string buffer. Beyond
>>>>> that, the given user mode program must decode this data and possibly
>>>>> perform filtering to obtain the desired stats. This process can be
>>>>> expensive for programs that periodically sample this data over a large
>>>>> enough fleet.
>>>>>
>>>>> As an alternative to reading memory.stat, introduce new kfuncs that allow
>>>>> fetching specific memcg stats from within cgroup iterator based bpf
>>>>> programs. This approach allows for numeric values to be transferred
>>>>> directly from the kernel to user mode via the mapped memory of the bpf
>>>>> program's elf data section. Reading stats this way effectively eliminates
>>>>> the numeric conversion work needed to be performed in both kernel and user
>>>>> mode. It also eliminates the need for filtering in a user mode program.
>>>>> i.e. where reading memory.stat returns all stats, this new approach allows
>>>>> returning only select stats.
>> It seems like I've most of these functions implemented as part of
>> bpfoom: https://lkml.org/lkml/2025/8/18/1403
>> So I definitely find them useful. Would be nice to merge our
>> efforts.
>
> Sounds great. I see in your series that you allow the kfuncs to accept
> integers as item numbers. Would my approach of using typed enums work
> for you? I wanted to take advantage of libbpf core so that the bpf
> program could gracefully handle cases where a given enumerator is not
> present in a given kernel version. I made use of this in the
> selftests.

Good point, I'm going to change it in the next version, which I'm about
to send out: tomorrow or early next week.

> I'm planning on sending out a v3 so let me know if you would like to see
> any alterations that would align with bpfoom.

I kinda prefer my version regarding taking a memcg argument instead of cgroup
and also regarding naming. I also think it's safer to expose the
rate-limited version of stats flushing function. But I do lack the
node-level statistics (which I don't need)

If it's ok with you, maybe you can rebase your patches on top of my v2
and I can include your patches in the series?

Thanks!

