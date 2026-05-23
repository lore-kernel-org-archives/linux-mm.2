Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE98CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 01:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D936B00A9; Fri, 22 May 2026 21:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065996B00AA; Fri, 22 May 2026 21:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD7D6B00AB; Fri, 22 May 2026 21:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD1F86B00A9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:43:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E6798E8B7
	for <linux-mm@kvack.org>; Sat, 23 May 2026 01:43:15 +0000 (UTC)
X-FDA: 84796986750.04.18C359B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F0D340003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 01:43:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3f0pC7s;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779500593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJZA49pdKvOvbXnn1X2VV5uzZwkIZlG3EH0IQFJCaVM=;
	b=JfA0UXD9y//DLyW4GEVFs951D29NSGUKHKBi43pg/fPWQn9tlq7M4Fmam49xnAzvgzjCpQ
	cEXOiDu0ob2LECygJdnV/ZDzJuTuNIpdif0KyBAOsXU8Gx4EBgZUQTPsPiK1PLxtREBhfw
	JPO05O1O/Cyl7aJH+41PCo0FYyFiSgI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3f0pC7s;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779500593; a=rsa-sha256;
	cv=none;
	b=SuQ8x1VAduP6A1maeH12iW/6PgU1RVsC0e4YR8cqxhc09rhd+qBNR9XfZLshL6MWB1x9XG
	sc1p6rC0fRcTX/zN6J89+uNkB/jK8J1mMBG+DmtA0MB3BF039jXX5Kuagart2rq5xbA4JC
	qxtwuwC440BWMpjNVO24Yj1+73Wh5sk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F02C860103;
	Sat, 23 May 2026 01:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573921F000E9;
	Sat, 23 May 2026 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779500592;
	bh=dJZA49pdKvOvbXnn1X2VV5uzZwkIZlG3EH0IQFJCaVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3f0pC7so9o1vgcYOyhGmA/6u81QRK7S+vNew4N4QMoaASu1hO7Yn3Ob2hiCFTvmG
	 lsXTo9mW5woS1TLfzx0U0GLB9P3Y7HzOBS7GDKZX5FAXEnNyAxPjxg08LcIzJdO6HH
	 Y21Yu4z3WcjL+4RXCTnqKPmOHkB+jDCVrt0M+UX+03jKTTd1CiuVN6VV8CosJypE56
	 kRrDGqWUg1KooDatbKEGs/0LGPGFP7BjWsXz1jUqxe9stJGaFMaTmvYzrK7z0ot8k5
	 8PPw/xt/K25q46mvyiMkVLQqezcYcsBX38u0pqMWKV6kJ41RjcOUgOhLzXgkdXd5cI
	 B+JjnfuGG2oDw==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Fri, 22 May 2026 18:43:01 -0700
Message-ID: <20260523014303.86907-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ddc3eb87-e34f-400f-a1d1-b807b340ff33@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F0D340003
X-Rspam-User: 
X-Stat-Signature: nuqk9ccda6zwimr1jtdhtoyj5qwatjo9
X-HE-Tag: 1779500593-416971
X-HE-Meta: U2FsdGVkX18Fj6zdz69TNZB+QQPx8ZT6LXKDvAnOlj6WOCin+m2xQcqiDjb/c6bC5GkZRK/IykEmtK1tnksjc2soKy8zqd1NiK90Q0EyKJy3TJqamWqCxISDKXNNUGrCqhoItzfrfLPF2JKtJ9gBm0LC5yPCdu2KnxFJJUrB3LkvtF+8CC18kSrXGnC4C6AUpHU1wMop/W/wyW/IEVVvcubK5YQ7/wMiNZFck0e3XVzoI8LVAB8LPXDVtIZ9XI5N1n1peLWvfVm6nkuzdobaQnQQ8i48yXg7OCzGJX0j6i8TRNr8ewJDnZG4+wD5gh98QdGp7RmcS3Lc7vRLpafVXCpaWntIznPdzA/6MRoeOlLu2q+gbUeiY4DHUToPc38UoIY73HgCyb5PdhEt1Fp7NwTGcy5wFvbj+fT8zgYdFqpxPZm+q2Zlu4Gn8X4tTF87/8UyQY+unx9G0LHJiemAEn0+BxuylV8pcwbzdS3wALDQQTWN9Gycuhg0HSwm5vxRjAnP3F3lvhQmTEnDFLUBbn+Gh+Tu7R8tqVNWhEb9Zf0TYNnmM0MEYdK1oh9w1SQeqnDMnoob759HwKXandkVKWTCd46sU7PPGig0eB/9fik2uhucKViku9sKISKeGkOuJ6REHXy5gGalgiqnpzOGJ1+hg5r+ZZZ9xSIn4eikKsmbVnt+In14eE4tzLUPUJ9lQ4rusCt6akPR7UXpB1s+2LsnhcN/N25604e3gbWNIA/ppNj0b3aiisLbvcm0z4pEntQOR+lml7RUCGIehz1OhasLmIDjPUxomHi5ppyJ/DgahX/dztxOmZmSbslZ8VRAhPdKIJzxAq1ZdFnEURIPrP3YWcOoW9vB/n9SCnqCoSbReWkA994wIZ3iljhRhg+CT6qMNaQ/+vPf3B+67gVTYFA+eI8NY8Ucp0WL2dHrd7Qmk0WOE2YyivaDc+uHId95X7x84/vq3UuxzJERJ15
 MsihWM47
 KkQqfU+VTCuvFP/qyUMd8rub/AsRlT4TC3yhQWV3yhvISN4KGM8xEODiO04P7H0/9M3hgeN7mvj1F/hTbnAc/hKvXMJJ8CbwQfxpGXJU25FV8EQyLGkFJZqhtlMmUz26v/RN6QVRXiE+hCOoT8pZkW1rfgMprc/iE9X8+CQIXiTtC66/zy0iGvu5Eq18n/2W8c3CmxD2gueU9hnqjHJXiMjdufF7yjTo8/1CybJugiC3t3O6YfgdXwbAIFWlbovJ9LapyXwn9WRjlmov2Ho1RmK6w2tT2IMPz6W8DZgGytZudOCTIU+btjRH54mCBDwVeQnCTG5pXNxH46zwa+3hv5Un4oTF6QcUcKElCQ8fJ3g8cbpZLgH+coE6+Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 23:11:47 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Hi, SJ
> 
> On 5/22/26 10:42 AM, SeongJae Park wrote:
> > On Thu, 21 May 2026 23:07:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> Hi SJ,
> >>
> >> Thanks for taking a look.  Quick replies inline.
> >>
> >>
> >> On 5/21/26 10:30 PM, SeongJae Park wrote:
> >>> Hello Jiayuan,
> >>>
> >>> On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
[...]
> >> counter was just for convenience -- easier to cat a sysfs file than to wire
> >>
> >> up tracing.  Even the tracepoint covers it, It's cost to much for
> >> Grafana to just get
> >>
> >> a metrics by tracepoint.

Out of the scope of this patch series, but I'm interested in how you connect
DAMON outputs to Grafana.  I believe that could be useful for many people who
willing to get some fleet wide access pattern.  Maybe worthy to present to
wider audiences, like System monitoring microconf [1] at LPC?

> > Makes sense.  And I think this deserves to be upstreamed.  Some minor
> > modifications might be needed to your current implementation, though.  Please
> > feel free to send a patch to start the discussion, if you want.
> 
> 
> On the sysfs counter -- agreed, same data as the tracepoint. I'll
> look into a suitable location.

Maybe /sys/.../schemes/<S>/tried_regions/nr_regions ?

[...]
> >> Yes, age == 0 means the region's access count drifted past the merge
> >> threshold in
> >> the last aggregation -- the strongest signal it just changed internally.
> >> Regions with age > 0 are stable; splitting them tends to oscillate (the next
> >> merge cycle pulls the halves back together and we waste the budget).
> > Thank you for confirming this.  Yes, that sounds good approach to me.  But
> > because this is a core behavior, I'd like to be careful more than usual.  I
> > will spend more time at thinking if I'm missing something, and if this is the
> > best approach.  If you have measurements that I asked above and can share, that
> > will also be helpful.
> 
> 
> We considered selecting regions randomly past max/2 (which is what our
> downstream tree does).

Interesting.  Actually I was thinking something like this as a suggestion.

And I understand that you had to develop and carry your downstream patches
because DAMON was not supporting your use case.  I know carrying downstream
patches is painful.  Sorry for the inconvenience and thank you for making this
voice.  I'm here for users, and I will be happy to help you removing the
downstream change.

> Random selection converges to higher
> nr_regions faster.  We picked age == 0 for upstream because:
> 
> - It's DAMON's own signal that the region's nr_accesses just
>    crossed the merge threshold -- i.e. the access pattern is
>    currently unstable.  Splitting an unstable region is more likely
>    to reveal new internal structure than splitting a stable region
> 
> - It's selective by design, so it leans conservative on a core
>    code path.  In our tests it still reaches the effective
>    refinement we need (e.g. 160-180 at max_nr_regions = 200), just
>    more gradually than random selection would.
> 
> We thought a selective, signal-based filte.

I understand that you concern about the increased number of regions, which
would make the overhead greater?  I think the concern and your filtering
approach make sense.  But the age threshold value feels like a heuristic that
may not be good for someone.  I also think age != 0 might not always be a good
signal for distinguising the regions.  I feel temptation to keep using the
power of the chaos (randomness) in the regions adjustment.

So I was thinking below as a suggestion.

The basic idea is, choosing the number of regions to split based on the
remaining budget (max_nr_regions - nr_regions).  I'd prefer making this simple
and lightweight.  So suggesting something like below.

void kdamond_split_regions()
{
	static unsigned char rndseed;

	budget = max_nr_regions - current_nr_regions()
	if (budget > max_nr_regions / 2)
		split_step = 1
	elif (budget > max_nr_regions / 3)
		split_step = 2
	...

	idx = rndseed++ % split_step;
	for (; idx < current_nr_regions(), idx += split_step)
		split_region(nth_region(idx));
}

I think this might be similar to your downstream change, but what do you think,
Jiayuan?

I'm also bit concerned about the fact that it would increase the number of
regions.  However, DAMON never promised the usual number of regions will be
around max_nr_regions / 2.  More technically speaking, the current behavior is
that once the number of regions exceeds max_nr_regions / 2, it only slowly
decrease.  Anyway, it is not a documented behavior.

Yes, maybe some users rely on the current behavior and changing that could make
them sad.  But I haven't heard any voice from such users.  Meanwhile Jiayuan
and their friends are apparently being suffered by the behavior and making this
voice.

And we repeatedly told DAMON does its random evolution based on "selfish
voices" from users.  So I think we should move based on the Jiayuan's "selfish
voice" here.  If it really makes someone sad and if they make thier different
"selfish voice", that's when we can discuss on different direction.  The
someone could simply reduce max_nr_regions, or work together to make another
knob for making the new behavior opt-in or opt-out, depending on their loudness
of the voice.  If you rely on the current behavior, this is the best time to
make your voice.

I hope this doesn't make people get us wrong.  We care quiet users.
Nonetheless in this case, the behavior is somewhat not documented.

[...]
> Our downstream paddr has per-cgroup tweaks,

Interesting!  Please consider sharing that on some conferences and/or
upstreaming that for the community and yourself!  No push, though.

> so I don't think those
> numbers would be that meaningful for upstream review.  Here's a clean
> upstream-paddr reproducer instead.
[...]
> After running for an hour:
> 1.Without this series: nr_regions stays at ~100 (max/2), doesn't recover
> 2.With this series:    nr_regions stays at 160-180

Data from the real workload would be really interesting.  But this artificial
test results also helpful.  Thank you for conducting the test and sharing
these.

> 
> In real production this is actually pretty common.  Workloads keep
> changing state and creating new access patterns, so nr_regions
> naturally tends to live above max/2 most of the time -- which is
> exactly where the corner case kicks in.  On our production box with
> max_nr_regions = 20000, nr_regions sits at 11k-13k for long stretches
> without ever clearing.

Thanks for sharing these, I believe you.

> 
> ﻿Without this series the effective ceiling is just max/2.  Set max=200,
> you cap at ~100.  Set max=400, you cap at ~200.
> 
> 
> The 1-hour reproducer above is admittedly a bit of a toy -- I set
> max=200 to force the corner case without having to scale up the
> workload -- but it shows the same pattern: once nr_regions crosses
> max/2 it just stays there.
> 
> 
> The offline-pod example I mentioned earlier is just one workload that
> hits this.  The mechanism isn't specific to that workload: any new
> access pattern that shows up inside an existing region after
> nr_regions crosses max/2 will stay invisible until something else
> lowers nr_regions, which may never happen.

Yes, makes sense.

[1] https://lpc.events/event/20/contributions/2327/


Thanks,
SJ

[...]

