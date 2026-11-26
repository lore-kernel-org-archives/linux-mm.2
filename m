Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDDD606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZfva1MT
Received: by kanga.kvack.org (Postfix)
	id 8914B6B05B6; Thu, 26 Nov 2026 04:46:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842576B05B7; Thu, 26 Nov 2026 04:46:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731086B05B8; Thu, 26 Nov 2026 04:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47E446B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:46:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93F7212038C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:46:28 +0000 (UTC)
X-FDA: 85476790056.27.2119963
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC05340009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:46:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZfva1MT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686387;
	b=j7wULdvd+SZ12MjrPGerhPy9IcpaOhBqO7A0+6zKB9+/X6cChrVfaeveri/0KGSScziBEk
	zmX+otoGAvxX7cIfylTKkwwhf0uyZNgUtXyYC/j9QLh+bb7/tMRDcdVD8tlXEpRtHdIVYt
	oZ5b07EVAcJ8jtM/ikBQC4W8LQCvuSc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iOFGCN2xqfzOpq48k6oJBM/eJYJ7XXUTZKnlzXr0YI=;
	b=UZc7sDwBjxhvC1VdxQfMdDHrZmDjZ4+WOxySPcPiqb6ODfLffIJi9Y9QTmJ1rpdpkh40JB
	qE47Nkd60K0TAHHHjYqBYFyhsXZNY0BuStzzZRNvU6q2+la6FfqHoHA6lsW5TCf8Af8v7b
	Cv2mZmWnE4oIU5i9X/Ba6l9Pe5EkUFI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZfva1MT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E604C61F63;
	Thu, 26 Nov 2026 09:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC611F000C0;
	Thu, 26 Nov 2026 09:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795686385;
	bh=9iOFGCN2xqfzOpq48k6oJBM/eJYJ7XXUTZKnlzXr0YI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mZfva1MT0HkGb3bUMZyMaDNx/SSgWJQGvrvB90fiSg6ExD/e2IHNmVp+joGudbs5W
	 4lz+Rj/ZjHsHZWaTBZhUc5nn/To/U+7YNC39ZKO0VkFwg8rkg0PyP4qzNXDBw18DI+
	 t85wpBfIP8OI1JfRs61ONjbZ3ukTEPlcluAkSSvvGfX2YeX0u2Vv6ffqd1A+4LyMLG
	 sGAZ7zYVMaN8Pj0jSkIqhENzHt+nHs89uMB47MU68dhFW6qDH8Qe33Rx5RdY/jg3b7
	 Oz4ISLSPN6u/5TFq/dKt7gT4bmSBoG7cIACIvpVtXEpw3jjB7Ytbq/WeADTVk62Uwh
	 ct8LdZwseltsA==
Message-ID: <aecebb39-47c9-4b0f-a076-ac0ddc7724d9@kernel.org>
Date: Thu, 26 Nov 2026 10:46:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
To: Peter Zijlstra <peterz@infradead.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Harry Yoo <harry@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 daniel@iogearbox.net, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
 Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation>
 <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
 <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com>
 <20261126094403.GA49833@noisy.programming.kicks-ass.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261126094403.GA49833@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: noqq6oxmeyzrjzkxxr55n7ntj7qcxhjy
X-Rspamd-Queue-Id: DC05340009
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795686386-974479
X-HE-Meta: U2FsdGVkX1/9pR9mhtv8xgTDxi45I2j2yxYTsn+079Fm8ETqF5fSnyxT9iFK9Vwn9X+HuPwPE3hwevps1O4wlPU2jove8HeoChLWkp3Angcrz2vmPLZent8UKQg2y3CmdcYN9jxIAZMcjfqEFZdyO4NomXKsc+BqaY2AmmXJYohBuQVi/kjkLAfP986OTyizynn4KWP+tHF0OdqXCES9iZvYfk3UPErs5lDNLbIevvHuZQCzFplONQQCwJcmBRgySYdRGdkZrSWB3TY2rsQcjKbD6cmSrDtNjelUv6x1EHBOOzX7AS0P/2SsD2SF+qwigksrumfW5u2ACV+PvEAy42B0z12Ci6F9NR0CHzy77HTFi8Hlrca8boYtdAILNHWmBhZ/VImb+HWjXFNrYndbZgLuQoIiE0JwMYm1UJDC0rceRl1nZq1aI+97t9N6/r0f50nX3V2PPf2p8om1qN7n3j4kFcgJmka9VvUMNOy8NxICsWM4s7hRCcPobSE4YzPsvRkxCNS5xjVnMgHUPuEbXuUB+rC+e9U6hhDOt6SaHYDjDut8NXr5yo/OKQe6Gl363GeJnpLIiAD/9vtyirakcT97lltB13EFQe+4gQqN1Ux0NBIT3qSEjQOGR/0b40bc3DlE71/XnZ4kkcCBuUf2QKzc5VP7CoAcq/ucRLWWQfkFLQMZ97OLfwHSlH9uKdOWz5FtSQw36ui+UXLRY//U3vPqz29kAJm/YaGKSTyNZn32mdKpSQz6IlOpmOIGgY3ewmWHsmQ3CD1SXj8C8y2jHHdejpb7KACK8mhPQXILbVeIwkhhcia6vXe3Kaul3uM+O3eSaCm5+S2p2k1a8WNk+knF59R6jg2TBrNn0SYRWPs73jshBkgif0UWN0IXdjjGHtvaOlW9C2aVs262S/am+eXb3Xnn7a3fBxwS65Ck35N9IWp9jNwIVsWWi5dvymloLRJxsNPv4tECrPaLA69
 0msEd+KN
 F3kxiWy3J4vMpuSWDYZk8HtklyeAgUCi+EDL1X8uCyDJK2fZCF7xsbaGxFCQLTUirF/bMrQQCMR6JTUlKPonTGuQrv8S+sRspncFH+eIWN7gdxdC5Dk12x2UOCgAhQywGv4EgUNQPRdD2sFejjVvSjtyNKDal23gfPQE2Hpb0DUKO36ReeVYHwsYEPvrBAN0sS2wC21u/fVZFc5Mavb95a12M5xLRsxtakAddqaxuvU8lGboGZ4WdTivzb3XDM51hkyg1aunYDtAs3i1G0ZqDu3H2qwI13F1xCJIWim6v3GF6n6m1BTUubEBabts5Cwrdme43LFHPYoh23U8TmXhfObwpzO7YvhtPLJezyc3vnMz0iy/gy31DxkBgfdexuDoz2tXKJreFQk+m6buTKJlv3HgOFIGcJ7WC1vpelEvoKJXY1N2WAeGH/aLWWGYkAquFD05QuRJfh3tP5TY8heAmk5iB7Bp1lvkQh9XfZKywn3GKm/9nVZ+p8tLUR+iHKPcvTb8Sfx5s32IS0d+n/YIIEG3JX4vl4KDLB/VwU4Z9Omto4CbaHJQ6+HC+KbGmLxHgptXjHKWFGX0qxdyqqaxoQcIoSTy839HkOsSAQo3g13de0eVjv/h8NyfAyiXqrNvs4lnlxi1CtVua2ZxQa2EHdYTd9/KQyK+L453I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 10:44, Peter Zijlstra wrote:
> On Thu, Nov 26, 2026 at 01:04:27AM +0000, Alexei Starovoitov wrote:
>> On Wed, Nov 25, 2026 at 06:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>> This is absolute atrocious shite. You cannot attempt a spin_trylock from
>>> NMI context. That thing might be a mutex.
>>
>> cannot spin_trylock from NMI _on PREEMPT_RT_ ... correct.
>> And the patch guard against that.
>>
>> On RT the nolock path doesn't reach zone->lock in NMI or hardirq:
>>
>>   __alloc_frozen_pages_noprof()     alloc_flags has ALLOC_NOLOCK
>>     alloc_nolock_allowed()
>>       can_spin_trylock()
>>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>>                 return false;
>>
>> fwiw kmalloc_nolock() has the same check.
>>
>>> This should not work; if it does, that is an accident we need to fix.
>>
>> It's not an accident.
>> In NMI only !RT SMP kernels reach the trylock.
> 
> Allowing this on !RT makes people think this is 'OK' and then the RT
> people get to fix endless crap again :-(
> 
> Locking constructs should behave identical across the configurations to
> avoid divergence and create problems.
> 
> You're actively creating something that doesn't and cannot work on RT.
> That is not cool.

This is all just way too complicated and shaky, sorry to say it.

-- 
Cheers,

David

