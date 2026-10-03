Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B047BCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC9B6B008A; Sat,  3 Oct 2026 10:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D3E6B008C; Sat,  3 Oct 2026 10:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982996B0092; Sat,  3 Oct 2026 10:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7757C6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D8B9409C1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:30:15 +0000 (UTC)
X-FDA: 85281549990.20.8E55409
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D7C24000E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:30:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5nou7g3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791037813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VOKNZsXt8POVkaKJcBsptOeZCCqTjnL2Hl8Rsw8LdQ=;
	b=7uagwzMSLBeLE+oQ/zV9DS2k4wge/RBJeIMIWVSiXtCKJ706kbWneu510qfSAOrp7eV+30
	mUJHc+xuFICdEJFvTJ0k9vz7IqS3Fx4+Dg0Rxe9nKrKo3HtwBb31NEPaWJUv8pVgr3+4MT
	/IGTJKUux1YON/pU6Z0/iKniHlPOU2k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5nou7g3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791037813;
	b=ywS3RryuN1AvcdSyC3Miqf9mv738kDdf9RHFVfJMR0wGhlhsSibUoQ3NK00xNzj4lK4BRN
	WECS7Grh/zmd4EKSFawbHjvnDqwjfj+XdeMnS9shx9hwi317QsucrkUMMS+B6jrgU5Xwsb
	gRIfsYcSW5yRewHO2GeyBxrflaG9uNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F31A60D82;
	Sat,  3 Oct 2026 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA99C1F0089D;
	Sat,  3 Oct 2026 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791037812;
	bh=0VOKNZsXt8POVkaKJcBsptOeZCCqTjnL2Hl8Rsw8LdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G5nou7g3BqkL8GO0V7LH3FWiz4Xoa6UoLxbdYyBRNRvGCkLhqMbp6+wA6pS2p/wVK
	 sidohVIkYNtujZDVfUM350+FJ1wgxX60ajONcjnohTOYKxjQMkWAyWELf0CnGvr02Q
	 gjohG0PwgaN8nLfzWqbu/L7Nia0F7RUnlNp248cYN3q92WlLgwaMyITpAQqEehfXjP
	 sea+oh86kMUv9RdeT7EsCS9ncjSttPEBd3y2ixsVo0icKtKNxWC3oeZh/c3Q5WQ0Sk
	 EhQsd9nLHWTRG2SBKA3cDpqFKNSGHPTNptvc7RmnmGg5bTdKrg/s5hmD3gnBUMZB7v
	 QtpTiEniK6sSg==
Date: Sat, 3 Oct 2026 10:30:10 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
	david@kernel.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev, stable@vger.kernel.org,
	4ncienth@gmail.com, alexander.motin@truenas.com,
	caleb.stjohn@truenas.com, ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asERcvLuNJatsBL7@laps>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
 <asDF77csaLDIuHTB@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asDF77csaLDIuHTB@gremlin>
X-Rspam-User: 
X-Stat-Signature: s8x1myin4kfqkgdbeyzcbp6cnyfgz9hk
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D7C24000E
X-HE-Tag: 1791037813-849914
X-HE-Meta: U2FsdGVkX1+oDKNnMyQ0gZsQVNed6AUtAxLD1KVqoxEuO+bbiAsYwKi6e5ErM5maaHUT3BKYvnALWPUCfdrSkyb63ehm8EhqXyXDlQdFfQzROz6w6OoHSWSA8QvWYsg0gsRP2+hJm9k8xQBqX1bDAhQom7sobajamnr2yc5V09gBsCjGp9vXwamiHX8Lo15UcPL/SbDYwkeq+RkQMDIwWS8jrNfXu4i+JYR7JFepUUteLZvs1oXqhuqbKYT0b51rnFbrvxpGYpC+86Ri76BVxmdfqHSt3kmi2UQiSJVSDU7VQmOLXPpdV/IfINoNtRU2zfxOCHa5SnXT4zKp67a8a6qOucc9iRqzVZJ3HP+oM+8ptYM/6IjVdUZRtQuu3VFingqF4a02foajqM4GIobsow/4popOJpgp05vp5QDo6j7q8jlcOK0l19NJCZeLs/TEKUTe9bp1CXCxYJc+QKd48F6YhNiXZW35faZlOgVey38Jj0xUzRGf29Ins8/Zc7gYAtw5BhIXiMY/cRntf7PDPGaRDnIxHzUmXYUoBpuu8SLyuoHHeqiwqIoZ13zur+yYCIa/6AZWdc8OtwLHYb0Od3Yuby59de6JbM50R3FUPjOERafhtdN6ELVAl8VpuVY67fPE8vKbpp+3x+2MBIPWvDudOj0jgNE+O7yykxuVYt2N+Yr496X6T4hs70jmVRT43PyLLFOUf54aU2F1xpqdQ4Kw+jJCrAc9FGzC2GDusSo0ivoY2wnkKM2QNeLzsKZD6CWln6IiUY19FA91Fbam4MWbJ3sZ60AzpYYPaKUYy901dahUg3HSN44QAPo8c7EKEQ+C3jbrkD3ssrOH1jAg+oPwE4t04YKaNGLiUldjds7251N577taoIlGDE0pgi8i4h8NtMGqeZq0cP3msCCUzG0FwONoqOYPqDnHZQwHTkrUDdtUl/UAAYGttM+JR81x85FimqxcUYQoEBxoqIN
 0vrBL4Gq
 DCg4UyP5X0f2HrUvlAWfmDS7/6g1kg/mH14pic7nwipBJ2MekOBo1W3cXkiDHjAOVI2C+nr+tIHqKBU745VvgLLzbqSy5elZxp9sox53vEmbM9Y33xwU0NML2G46JN2KF+JXxl/QxKlfsBbpHP3ZX4Uxlld4O3ryqmZhKQwYfnnwL2EP0xtXFw1PN+cpNkYl1sHZMBih4jNJUmGL4pzXtNgShnjsEe6gC6tCjgj4kucJVFJqjGQMoEiQqn4guzHAsEs16kKBDb8k8/Yw+M2QStnv++KhCIF2IZKuyTZW0DCMDLhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 10:18:34AM +0100, Lorenzo Stoakes (ARM) wrote:
>On Fri, Oct 02, 2026 at 09:30:23PM -0400, Sasha Levin wrote:
>> > Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
>> > pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
>> > memfd_secret() page for the first time fails with SIGBUS while the
>> > same user is running perf record, and read() into such a page fails
>>
>> Thanks for the report. I've dropped 97d34aa65c29 from the 6.12 queue,
>> and also removed the copies that were staged for 6.6 and 6.1.
>>
>> 7.2.y and 6.18.y already shipped it, so those need an upstream fix,
>> which stable will pick up once it lands.
>
>Sasha,
>
>Could we perhaps take a breath and pause?

I pulled this out quickly because I didn't want this issue to go into the kernels that were released this morning.

In general, our policy around this type of reports is that if the issue is in a
released LTS kernel, we will wait for a fix upstream, and if the issue is still
in our queues, we will simply drop the patch from the queue.

>This patch fixes a really quite serious vulnerability that allows an
>unprivileged process to allocate arbitrary, unreclaimable (i.e. OOMK cannot
>save you) memory.
>
>Allow me to assess the validity of this report _before_ dropping things
>from queues perhaps? :)

No disagreement that this would have been better - in this case it was timing
as the releases were about to happen the following day, so the safest choice
was to drop it while we figure it out.

>It was sent late on Friday in a week that I was ill and it's Saturday
>pre-LPC, so that's hardly a timeframe that I could reasonably have replied.

Keep in mind that our release cycles are fairly short, so this shouldn't be too
big of a deal?

We will generally go for the safe option of dropping a commit that introduces a
regression as it's fairly easy to queue it back up very soon after a
diagnosis/fix shows up.

-- 
Thanks,
Sasha

