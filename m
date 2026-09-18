Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD3DC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 17:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823F76B008C; Fri, 18 Sep 2026 13:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAC46B0093; Fri, 18 Sep 2026 13:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7137F6B0095; Fri, 18 Sep 2026 13:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7806B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:53:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1022D160760
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:53:45 +0000 (UTC)
X-FDA: 85227630810.29.C2ECD7E
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4C0240004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:53:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0SXkDdH;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754023;
	b=qVEOGYGkifpeSdkZWfI+r+iRPJX1/hBkuD5XIcyXhLh4pjU09gJcEb2hJeVUraO/dprYSJ
	KukNllvLWBBfN86V+Pr5iOGY+kfWv3nRw892lzvwUHwxbtJK9SBBzhLjavasU/4yKDtxGr
	aXxR0kz53T/Q/OXIHJb8AOhz4GPIEJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0SXkDdH;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wbm5n+MTacR6JBK6JaH/GpM3Ddc87zjvfs5dxTHh40=;
	b=YVXsqOf+qefmXvMfoYiS55QdF8m75RV0uneJUF5kX/MAa3T6tgqwQVVLKFE6vkLkTe64ml
	LQc9oDe3k8IAfJfrxzRlTn+++CDyxt8/EMfkeKhNno0rTTwZvb8A47wOiM3bRjcafbrSjo
	X/gsbmSmECV5BUPBj5QsOlQfrBDDzVc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qef1qfESxx2iUjqupM6SsnRWUnav4c99ce74qBOBVbQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789754021; v=1; x=1790358821;
 b=F0SXkDdHJzR7M1rAPkRuYqPQWiYg23GAyrZPDhIs6K2ZEZC+PsmTC0JIUhyybYtAXO2UYNrM
 UV2bDvFpnIgJspy7hEMrqjcIXsjO8vP5erbnvRsQL8MN7K5cGaIl7VnJlIm1mjmwkEY9911vVZR
 erGmh8Hgg/g9vPqDna+bS8E4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4b40d4790eec116b;
	Fri, 18 Sep 2026 17:53:41 +0000
X-Mizu-Trace-ID: 4b40d4790eec116b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 10:53:39 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: Add memcg async reclaim
 test
Message-ID: <aq14epWc4EwAIEvs@linux.dev>
References: <cover.1789714023.git.zhuhui@kylinos.cn>
 <44f7fcfafd5f33072dd2b9abc31aa9bf5eacd9bb.1789714023.git.zhuhui@kylinos.cn>
 <DLIK17AFECZV.3U5UY0LYU5Y5O@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLIK17AFECZV.3U5UY0LYU5Y5O@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4C0240004
X-Rspam-User: 
X-Stat-Signature: xuwjaf9fh6cz5rdc4ws7uir7e48fic4g
X-HE-Tag: 1789754022-599523
X-HE-Meta: U2FsdGVkX1/8dTNC3lRPgiF+TtQrmQHM9HMAmfgmD0SG2i6oyajDN69c1l98gM8lzYhhh9sxxpUZOQYS8SNbABijbqvbdVxd+l4utEJAT97GFl8j2F6G6u3uHmue5kCbAD5xCvzOlk/NMMSXuXre3VmWoXzMyl8ZM3eKNjJk2s2CRVkUwCaKo1LHMJBwPf+dWTCX+Hw2XA3HLj2xFWU3COhswqioQ+u0hDxEqAr6JnwxpWTaJfcc0bLM5n4CuXVxJ0TaEZoJa4ZFXHeNhaJcrvSyKAu97xJve44mbjedWeBTV0WqPQdGtzIqRpNAKOtlAnMElnNWvtvbFzOXNvgFu91RZ3uUc5O5ewJivYKOCuc8Ei13MKioNv+litL0iAix8u0N60tAaHCsgj0Tyi+qNKLRAjvDNC/XcM8PuzbPhXv/w7n6LpWoEAT8asUCLZv9MO9YFRqYIzAWCYbp/AMK8qFf2NwF2WVIhJJGUl0hqYldVPG8uN52kdTEOSWx1YOS9hdwaW3EASDJiepyYNop5ouNbBt6VJ1pkHgMs+u0SR4T5CR9o6upw7l5QSTlGTMhMQAkPvCdXzVjXqz3lV9yCLE6wAq1aRofxE5GR3OnF5wq4oigc3OS9vRHeUa97Dt+DgaNjCzCqwUiLHopNLvRkI6lKkvUmstpSiqZgqrcj/ODRpJDIDw+mDfSof408sEY5/fBKsrbr5nUVSbQJM38kOi/PzonLWqaFuf7NTutk+h7ftb0al8PkaluHOw6M9pW2s6dEzaDyqngZDIuR4+31ogqvC3cM6oDWNAkTc1t9AbNQ9kYookR7FLLxEQcMPsByRWz1w2uSq0HzygHRlna6+bzAbK74INKOrqvgwsRHqQM3ZD9MutHw1Ga5Jl3xIabigbIms3LRkcM3btQf0jiwu6k81/xXCrSPO55Lrij3etBq3gjNddQZVrkVQfrTazV8VkCoSNWr12BD0A0uyo
 tUh973bW
 AxX9SUkuPbYI4XYG3LjJa3b4xZaEygwMqlLnjKFM4PfBKQGfc67Vki81ezC/zxJncXPaqx8NFaLgILL4qiHcZ79GkVIshJRHfEIaa9zpRyWUsneh85pG29A7Zn27Y53WqS07nlT4CncDFEqBvLuJgbM2TcyjOPP1VY7/hnNWeql4obZa1YKuWfg1NsrhxyHUKMFhi/6CPjs0U6SDKYcQKqo8/M3rUH+CUhGMaVFWVqgaSn1hFb4priKDME1DVHZiSKwnizNTettSNjG12rlYTp482X7X16agRGTtXKn2paTl+uGDYhj8z91/5Cur1yb5wBHGdCBAAHTdPCs8Hex5fOFAZytwJg+uXcIhG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:41:12PM +0000, Alexei Starovoitov wrote:
> On Fri, Sep 18, 2026 at 02:58 PM Hui Zhu <hui.zhu@linux.dev> wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > Exercise BPF-driven async proactive reclaim. A BPF program watches the
> > refault stats of a memory-pressured cgroup and, once they grow, reclaims
> > a second cgroup from a bpf_wq callback through bpf_proactive_reclaim().
> > Pass/fail rests on the reclaim counters. The workload timings are a
> > benchmark, not a criterion, so they are logged only under
> > TEST_MEMCG_ASYNC_RECLAIM_BENCH=1, which also runs a baseline without the
> > BPF program, recreating the cgroups in between so both runs start cold.
> 
> [...]
> 
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> >  tools/testing/selftests/bpf/config            |   1 +
> >  .../bpf/prog_tests/memcg_async_reclaim.c      | 890 ++++++++++++++++++
> >  .../selftests/bpf/progs/memcg_async_reclaim.c | 327 +++++++
> >  3 files changed, 1218 insertions(+)
> 
> 1200 lines of selftest for a 20 line kfunc ?
> Sorry that's an overkill.

Yeah I agree. Also I understand that BPF would prefer to have very fast and
minimal selftests and selftest for a memory reclaim kfunc would not be that.

We have memory.reclaim selftests in cgroup, maybe that would be a better home.
Basically whatever we do for memory.reclaim, do the same but using this kfunc.
If you don't mind, why not let's just take the patch 1 in bpf tree for now and
we will cover the selftest in next release but in cgroup selftests.

