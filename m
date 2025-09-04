Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61ECCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F978E000B; Thu,  4 Sep 2025 10:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F79C8E0001; Thu,  4 Sep 2025 10:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CA58E000B; Thu,  4 Sep 2025 10:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E825F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:32:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7429357B6A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:32:26 +0000 (UTC)
X-FDA: 83851808292.06.BF0FE3C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C3F94001D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:32:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLHA9PwT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756996344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDBdIXqGhXisdI9dGc4nJcjo34W6QqppuoGXLGaIWNs=;
	b=LtWD8GBAqVG3tTI4eWZ7Lmn5fBdgfWd5QJeAoW9qpkhpSlKuCbpmWg5g7a2F7hhVMA3FB3
	sGLNLEqwOqclzIWV0qMhVJ045dwuHA08x/uzdPssMl25xTUZX7C0LUp5Yb4AbB17art/8H
	FomqJrErYZ7s9fwlLOg5JVjXeeCOb2c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLHA9PwT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756996344; a=rsa-sha256;
	cv=none;
	b=uUtCEaGY12qy0uccZmaFgd3IAvoRQrvBpBUOSUBHGcF/UHyiuo823njnXIZTTVWGliXmc2
	1CwtJuu4J4DpDXQaIls18zgwJQ+Yznx06Hre4x3HvVIGYl1CMqUSw2UcWTLUu3WKnrZ0wz
	qGzS2X/5Us0DtvfnCUnPYgYWIkSzNMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756996342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HDBdIXqGhXisdI9dGc4nJcjo34W6QqppuoGXLGaIWNs=;
	b=xLHA9PwTaXoDBP744wDjpvRy1G72Zi59tr/7Y5cji3JaVm31+i7+3GsunlrLWew29Q06wB
	pqQesQNb4k0tq/5fkOp6hNSUTdaj4z1zkNydhaw46Myh/YE15jmwtN5elShJvFGRZSSzWZ
	pkh2e+M3ejdcOqenmCq4q5Z2ZDcIqEc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,  Martin KaFai Lau
 <martin.lau@linux.dev>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  linux-mm <linux-mm@kvack.org>,  bpf <bpf@vger.kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,
  Matt Bobrowski <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <aLk0FuezkcInlM_r@slm.duckdns.org> (Tejun Heo's message of "Wed,
	3 Sep 2025 20:39:18 -1000")
References: <20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev> <aLeLzWygjrTsgBo8@slm.duckdns.org>
	<87qzwnxgfr.fsf@linux.dev> <aLk0FuezkcInlM_r@slm.duckdns.org>
Date: Thu, 04 Sep 2025 07:32:14 -0700
Message-ID: <87h5xi1e6p.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C3F94001D
X-Stat-Signature: goo1sa5m7166rhtar3e85n3g31k66o1h
X-Rspam-User: 
X-HE-Tag: 1756996344-972723
X-HE-Meta: U2FsdGVkX1/bxr0TP5Cvgtj4NhYfYvwyxpWwMqt74Uz4SU7qGM+zzgE9LQkdQpdPpCK8ySLr2dmw2xyjXDp1RXN8xC6iomEvDPGw9P6pqlx0TWbdQ6Ykdg6k2wZZD/xvI4mmffJXgsIj7DcFE7t4gKw+zy80L8BHR7dTyBKTioWFF2LgpMyh2qfgZyi03k2QarV1eyOadPpksLXt5sxn/iTEIXfWflOjz6Ke36HUT90J5GWdHzaMPLsHadSJ5W6WTjpYTLI+Aiany/FAHLfetjCGd7jmfQUzMqSPU8WollSR9PYqoDiTwIRybzBxcMPxkA28H3tAk004uh2pm/GBPLwIh4NEZA4ZUQkoagWnfp6ghb2FxhvChJcNvlwkQV5ABQQ1ATKTm/4wcl4WJ/MWui08xwIlMjn6t/majl3rN8u1VHTaNnXZd0HenHnw6bDdtJmgClYCjobSiEHs3G3qa6bELqL4kZIITy/0cHI0rI1JhVBiUnS9Cpfkt59/v1xHorzNbxAJfPG3YNV7wcbNdQ6lNAMPXD5IQVW0czEqkxcwiNCb4NwxN8tNr57TkLKHBMSKgQ6hseCVXH16uYrOsKQVp6U+3Q88hKtPHRVBWBrhPRydg/3cfyc6H9feI/6EIfO/BHOV1ZhQJoNzBWSe+ssWm2QsdpCy2CIga54DQeLwn1GP0wnrjFCJv/5+BT+a6/wjQB7GO96At0ItVGzVBu1CnzkKd5v8MykwYDqhEKHhfVxWZxovPK6DVjDS7NVDdSFwWjfcWwNSp9OvSdWqPZ0o3FvRbxCBwAnYp+NtBJwBD+PrXw1O94vCpqoL7BGr8sZj1v0ErsF5/HLczbd8ggB9dHjKMFDxMT/5/lBipL72270thYiMCbpioxGlOMd3+45xnx81QXq06yFfc+eTrTUdHLzywkmbQOW0HTfjLQHjn9p1yb2sxf6JhPoN5CYq8xyVKyZ9mpmGs4H79+x
 B4v57sxG
 Mp7/YgQn4K722oBI0TFWXfJHgasIGl821IpaL/uBBOw3+JMb4rb06uUgKXhQBhyk2/8zOHiLqKybLCiNiiFTOkLqjSpagoZyQ1xwgeeM3y117B3io60dWPRxmHCRrVpUd2TCOfXizkls52uVw4cirXb4XjlCstTKbLltkTI1fCgwLYC9cjFKsgb19YggmU8ga/jmGgIA9g0Er2dtdr7tUOPaYHlDHc9k8PuAI9SvfcI5JuCxQQLdBTFcimRYzKtSLVaRH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Wed, Sep 03, 2025 at 04:30:16PM -0700, Roman Gushchin wrote:
> ...
>> > - I'm passing in cgroup_id as an optional field in struct_ops and then in
>> >   enable path, look up the matching cgroup, verify it can attach there and
>> >   insert and update data structures accordingly:
>> >
>> >   https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5280
>> 
>> Yeah, we discussed this option with Martin up in this thread. It doesn't
>> look as the best possible solution, but maybe the best we have at the moment.
>> 
>> Ideally, I want something like this:
>> 
>> void test_oom(void)
>> {
>> 	struct test_oom *skel;
>> 	int err, cgroup_fd;
>> 
>>         cgroup_fd = open(...);
>>         if (cgroup_fd < 0)
>> 		goto cleanup;
>> 
>> 	skel = test_oom__open_and_load();
>>         if (!skel)
>> 		goto cleanup;
>> 
>> 	err = test_oom__attach_cgroup(skel, cgroup_fd);
>> 	if (CHECK_FAIL(err))
>> 		goto cleanup;
>
> Yeah, that'd look better but are there practical differences? The only one I
> can think of is fs based permission check but that can be done separately
> too.

The practical difference is that a single struct ops can be attached
to multiple cgroups.

