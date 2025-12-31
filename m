Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B058EEB565
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 17:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43D26B0088; Wed, 31 Dec 2025 12:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1336B0089; Wed, 31 Dec 2025 12:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC91B6B008A; Wed, 31 Dec 2025 12:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB3376B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:02:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01A611A847A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:02:17 +0000 (UTC)
X-FDA: 84280384356.04.214ACAE
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2DD814000E
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:02:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oo8vQsKc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767200536; a=rsa-sha256;
	cv=none;
	b=xHzjtoj64F63fvpDC4XdpHcIfuego1a4MCCbNv7ZjKBOXpEhQ4vws+VKrb1F/7852zoIRz
	T1vExqhhK75J2wtsT5+45htvWqyb+OZpvfVyOv+/oY5DCDLlKImTzCTGZ+8UYe6P1mrK5G
	1DPFX/VsgA3CFjVzm/oCUdMtdi1VOfw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oo8vQsKc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767200536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6I0h3kezoKxK3IDpc47mY2gwi29RX44rQplizDpRGo=;
	b=S6lIgMtSN4wcdv0M/w2QeBRbtgY9icZ8UIMhHDGLukDms3QxBhrFxzlYEGRHMXQ9X/ny70
	7WU4og2W82M66QnbuCZAa/4R9VrQ1AeVV3zERuMCUm6p47cm3+XNSDUZWmcbDSz1rV1CaU
	1TecN+9L4O/8AnaeJCrh3Bpx7/25qko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767200533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e6I0h3kezoKxK3IDpc47mY2gwi29RX44rQplizDpRGo=;
	b=Oo8vQsKc6quUCd98ROWFbf+fWzFq8lj/cuYDwgh1BY3HtZGuM6BSf0E/nhEVf/mcBVfrCA
	M8FyzK0R16mXX2PIbI6IeZpJLOZDinkySZf26rVKzHwYIie4yq7qwMWtNVB/X7NnSfv4eU
	2RqCs5Fjk0SrJboZA6l8A8HgzfWAFkg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  JP Kobryn <inwardvessel@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Michal Hocko <mhocko@kernel.org>,  Johannes
 Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
In-Reply-To: <aVTTxjwgNgWMF-9Q@google.com> (Matt Bobrowski's message of "Wed,
	31 Dec 2025 07:41:58 +0000")
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
	<20251223044156.208250-4-roman.gushchin@linux.dev>
	<aVQ1zvBE9csQYffT@google.com> <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
	<aVTTxjwgNgWMF-9Q@google.com>
Date: Wed, 31 Dec 2025 09:02:03 -0800
Message-ID: <87qzsaoa9g.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2DD814000E
X-Stat-Signature: sm5536eud9qykpsqhkp7m1umpk6c5bhx
X-HE-Tag: 1767200535-621917
X-HE-Meta: U2FsdGVkX1/DWTWMkptzAJ0TAFBsDuuY0kU+vZnKuvvOdj1QPHw8fIn7ByWGB8DYUPxKYDT3l93ONH1TLy/nR8c7Wf8JV1KJnhb1cIve+q6DgYxadspr5X/Wz7ugBdAfIPPkVupsVQj+seotXOvn29kFy+Er2+xwZrBFpyWvmZZANRwXne/sk3D60Cb99Xj4hkz/AYIDXL8jrNvdK5nRMQK8sGj9TKT+9H3l1J+nK94e1UtmZricFWsgA5Pp6R2bfyzYguPbtHR+TCi62rknS5ZVBwvf+mn8g3RGNmgTbA7dCfsfkKcUt34b+FbteWjcJMruT8ll7OFoGXLsgoMpzu5e3ugexeIY6DzQkZ7xfQKCGsjCStjhMgg27slj3uR3kVySpKJgzHLYka7KwO+SgNz+8IteLPFP8U3yFug5mhHmu0bw5+WAufwS/mSWYNhgUNHk3OM32NvBge+scs+/iuJ49Aq6xgT5ct7Wzy2p2rf41CTacWxaLuhdne2Eh00sjOb+rI7DaR01sDygVyvnknTFT13npmrZtJqM6Hjp7bgCMeD+n1nEMh6lUJ+NZ2ktG6yOg0QlFQQBNzie4pMgmz7Ptug2X3YCv8OEajDoYp21o6OH2u8/Ex717uJzU2pgPPeQxbUhOXprwXvRL4EJiS8v1TWOWUHmxuUwiTWL6CTlQjfrA4twdvP1gJC6D+dFLj8W7gHqILKiqhi6bOux8NeBzbgfW0WXj12+Qfop04tjno7EniiNoK8y4IPd8b4woXNuCXMpaRl76aJauW4BSmKrAVbQi8SCjy1lkDMo6hduwrcylQ9mP+LncHYFMPlKPU0h6VeQjaci0XmjKV/WdUu5t3u8ufA8OTCjy3QbWgGL5kZgslM320s/AuAgod/4oonQpD4rRzbniGfY7ISASpP+rPISYxSMKLAuJuXLrJvWW7xrP8tK8ogfDYW8YppfL6QqVocVWq1/08oUzfm
 DMXEk+Dh
 E7W/SrHnsXLKmPhuFLYcEARQA3WgwWbHmoHGzISzYAxfMFNpHJ+kTKJ9+cm9LpE/g+0OFEJERbQf8VDl8UY+V0rkUNv9KL/dqOcaTKdbxSwRyX3mCyRHxE4bqGXzKFKEfDPQFGFkXCLyJFo1Y2zNCs4GtLBOWjbbR4kpoizF+uIb4hsvTfdE7PgDL4e6A06z0CIYHZd43ck9pqw08wCf0Dx7w/iDlFtEZ4SEIUS+DS7t3aL0MlkUAR9YpQwxaUnMgjcB1NLyR7ro3SkM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matt Bobrowski <mattbobrowski@google.com> writes:

> On Tue, Dec 30, 2025 at 09:00:28PM +0000, Roman Gushchin wrote:
>> Matt Bobrowski <mattbobrowski@google.com> writes:
>> 
>> > On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
>> >> Introduce a BPF kfunc to get a trusted pointer to the root memory
>> >> cgroup. It's very handy to traverse the full memcg tree, e.g.
>> >> for handling a system-wide OOM.
>> >> 
>> >> It's possible to obtain this pointer by traversing the memcg tree
>> >> up from any known memcg, but it's sub-optimal and makes BPF programs
>> >> more complex and less efficient.
>> >> 
>> >> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
>> >> however in reality it's not necessary to bump the corresponding
>> >> reference counter - root memory cgroup is immortal, reference counting
>> >> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
>> >> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
>> >> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
>> >> 
>> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> >> ---
>> >>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
>> >>  1 file changed, 20 insertions(+)
>> >> 
>> >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> >> index 82eb95de77b7..187919eb2fe2 100644
>> >> --- a/mm/bpf_memcontrol.c
>> >> +++ b/mm/bpf_memcontrol.c
>> >> @@ -10,6 +10,25 @@
>> >>  
>> >>  __bpf_kfunc_start_defs();
>> >>  
>> >> +/**
>> >> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
>> >> + *
>> >> + * The function has KF_ACQUIRE semantics, even though the root memory
>> >> + * cgroup is never destroyed after being created and doesn't require
>> >> + * reference counting. And it's perfectly safe to pass it to
>> >> + * bpf_put_mem_cgroup()
>> >> + *
>> >> + * Return: A pointer to the root memory cgroup.
>> >> + */
>> >> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>> >> +{
>> >> +	if (mem_cgroup_disabled())
>> >> +		return NULL;
>> >> +
>> >> +	/* css_get() is not needed */
>> >> +	return root_mem_cgroup;
>> >> +}
>> >> +
>> >>  /**
>> >>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>> >>   * @css: pointer to the css structure
>> >> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>> >>  __bpf_kfunc_end_defs();
>> >>  
>> >>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> >> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>> >
>> > I feel as though relying on KF_ACQUIRE semantics here is somewhat
>> > odd. Users of this BPF kfunc will now be forced to call
>> > bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it being
>> > completely unnecessary.
>> 
>> A agree that it's annoying, but I doubt this extra call makes any
>> difference in the real world.
>
> Sure, that certainly holds true.
>
>> Also, the corresponding kernel code designed to hide the special
>> handling of the root cgroup. css_get()/css_put() are simple no-ops for
>> the root cgroup, but are totally valid.
>
> Yes, I do see that.
>
>> So in most places the root cgroup is handled as any other, which
>> simplifies the code. I guess the same will be true for many bpf
>> programs.
>
> I see, however the same might not necessarily hold for all other
> global pointers which end up being handed out by a BPF kfunc (not
> necessarily bpf_get_root_mem_cgroup()). This is why I was wondering
> whether there's some sense to introducing another KF flag (or
> something similar) which allows returned values from BPF kfuncs to be
> implicitly treated as trusted.

Agree. It sounds like a good idea to me.

