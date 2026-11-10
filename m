Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5FF606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhQiG7uu
Received: by kanga.kvack.org (Postfix)
	id 22A9B6B05C5; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DAC86B05C6; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9F06B05C7; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4216B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:45:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73A3780A56
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:45:40 +0000 (UTC)
X-FDA: 85420088040.07.180CAA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDA3840007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:45:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fhQiG7uu;
	spf=pass (imf01.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDn+kAHlJ1YKV/vSjJMTOq+sX3gPOQ26dm9cQX+T7Co=;
	b=VVHtaFoLrQemNvLdiX8fv9PktTnVblBfDa6W2sqQDSI8fAyESCafopNXNS9cecxfazGjLb
	alsRkCBgZ0WjSsgngEOeefJp+00Z5qecqO9nzu7YDgNNJTqdFUb9JCJgEqYAA+8tu2Q3Xm
	1oarWS7R+1FwOxTWfpJD0cFiHXj1DZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336338;
	b=PeI0/MEiMYsQcFyw93pSGBO82RDRmmhBTbw1GcU6pkhyEh087lNfL0/uhRwT2PKYPTA1L8
	qR8XSKRYvbBY5haBGT6Sm5N3F/eqXv6PRfQrgBIc0qhjvY5Oe8Y+sOVcVLuBF4OckMj6s0
	E7w4SE/Y6xnA3gFbpcThKUJ/bHY3EbQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fhQiG7uu;
	spf=pass (imf01.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2CA042B9B;
	Tue, 10 Nov 2026 18:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6381F008A2;
	Tue, 10 Nov 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336337;
	bh=jDn+kAHlJ1YKV/vSjJMTOq+sX3gPOQ26dm9cQX+T7Co=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fhQiG7uuYywqrnJ1To2XB3v7Jidj1RPi/wyyYjpeBPZsVAD2HJiQvdshP5yDQtNk+
	 4bTubfTT36iMuNB1Ux18/gUn2k3On06ctHzcZEuBQnMkgxqs+x4LUgW4of1uB7x2Ck
	 ec4z61FshOMCHLn6R8c1NPikkLK9oWiPbijkXnFJ1LB+MWK1wd1fcEFx6w5UwyMavF
	 CBauDfjcfYpa/CcWwAWFF6fB+st3chmIvfVWqHr1bB49moU8seP0H+MBmIR3+zaES+
	 05MS8ATN4ERryl56oZDf7o0kx+GHrN4E8Qln2FW0U3E1w9HdGDcgJ7Lp2BlODpAiVo
	 F5faYuv83ydDg==
Date: Tue, 10 Nov 2026 08:45:36 -1000
Message-ID: <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, ziy@nvidia.com, mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wsgwj6rddzxhg6f3b9jy7pz3irja8pq5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BDA3840007
X-Rspam-User: 
X-HE-Tag: 1794336338-172706
X-HE-Meta: U2FsdGVkX190prgRZNO6QK3xXitQYsY+ZYBPXM0DGuaywbDtiEQuagw2z3+aCvQepDGR52EyYQl7QmBQ0IhoCC4ObHR1hZ4N1Rq8/GrPMyhyNidvCgbb/h/MlwQzATmQ4gjm0mN8rKHYayvgLfewieokoz5Axj0CBJX4iq5TXLrOltAbzZDElFfZo8dC54m4tzCawrrNyT//FWC70/HDUHXqSSVhOLG0OUlEnx7HnMsT34WArf1NO4kBRJmWVRf/zhSuEmpDDP+97O1KebFNKcSKD7ebLrjy9Mil+/e0mKHk4GgccHIUQIr8XAUPAYXuyOTi3+LmlUA2ZFImDneDkLN0dOodE7+IjcrXTcnIdG62quj9aN8n2DJW8IiRN1CdpHYYle6QpRKsRIXS/OEf73ZWAnIS3yBpagZmhxXjU4u+5T/LRHWi6a7ZImjjIufZB3u932zCUb9ZDg0KvKR3tyl2XVRtsi3dcKz0C4zfKa+cVVkMjtCZXFbtPTXd3VZKDptAJKjOBslKA6fzvp6x6OfSFdd4qYTom2YwhMs84ZdfRMLf35bSTeZTrPF3aS2TZwHe8kjBLu3q+chy8yAFfMZJX4XYwEu7P6HudH1jUVAaLKN6h7t0YtPiTgz1ssuiivkPjKvhOzdL6AZy0hUls+Uks5+YmGdQ3RsT73r3tvjh3yfBtJ6tlBwFtYLczK8No0zAx0BZeyTw0tAh8nMS9nq0PkhJuBmTrehjb+aSPJNX4Vfj8bfI/PQAa6Ds7x6IwmZfP+42Ym4yqBZ7bNrMXNDvszBogeI5let5mLHr3oTRCp/566uexrNYOkWACDZnqsdPzfuB+pq759KOyw3YoOERtpKl8pop8Pn0mRM8RmlSeMJdRon0MlefXIqowuqJlnEgFcF1zK8WdKZykalctInpHgOStJaoXymuu3yQhll9e6OvhhtG3IOlc0/5r7AZMALeyhGBv4SJ7lBC5QW
 FedmWwqX
 EQCPqshpy1dXC9V3Tr+3dWk7tGei5Y/YJ7uEFiZ43zUHNtkvMg680oU8gWaGe/ZdnnRXHYImsGBAz1OtKUTWSlp7Zy3TOOaTwPgAUurXi7U1vfbhfHQi/eoImaFegymecZWBUKa6K2dG/Z7KPZds1vX6UdGKljchqTbX5gZjPeAMvbW0Z8r3jnSGnUFrHwUpEmeCJxOtNs31apdA0gtfdN7fhO9sgpORCsIrMj8lKP8TAw5KIFsplI2V8QqIjbicKb6G/72E1ZbvdWToiPvhR+0lsefHIhThSGhxtN2ARbMcMvp1ftu72Ed7ZlaIFusbjhgJebUPKSqdXmZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Yafang.

I'm not going to engage further in this series until the situation
changes.

LLMs have made it much cheaper to produce plausible-looking patchsets
for new features. That makes it easy to keep sending iterations of a
feature which touches code that the submitter doesn't really understand
or hasn't thought through in depth. The reviewer ends up doing much of
the developer's work while the submitter sits between the reviewer and
whatever the LLM produces. I think this series is an example of that.

Some examples from v4:

- A folio belongs to a memcg and that memcg decides the policies around
  it. That's how memcg works for every other memory policy, and tasks
  belong to a memcg too. The series still splits NUMA balancing into a
  task side and a folio side with different semantics. DISABLED applies
  to tasks but not to their memory, and the two sides combine the
  hierarchy differently.

  On v3, I asked why. v4 moves the storage into memcg and keeps the
  split, but doesn't give a high-level reason why NUMA balancing should
  work differently from how memcg handles every other memory policy.
  More generally, the major design decisions come without the reasoning
  behind them, and asking didn't produce it. Each iteration only barely
  updates what was pointed out in the previous one.

- numab_memcg_mode() walks up to the root memcg and recombines the
  requests on every call. The callers include every load-balancing
  candidate in can_migrate_task(), every task migration, every NUMA hint
  fault and every page migration including compaction. This happens
  whenever any cgroup has a mode set, although the result changes only
  when a mode is set or a memcg goes offline.

- numab_memcg_active() reads css->flags once and the comment says that
  this makes the three state bits describe the same moment. However,
  nothing synchronizes those flags with the mode. In the lookups, the
  check is redundant anyway because offlining a memcg or disabling its
  controller already clears the mode.

A developer could cost reviewers time before too, but each round took
the developer much more effort in comparison. That kept the effort
balanced between developer and reviewer in a sustainable way, and it
made sure that the developer learned and improved while working through
each iteration. LLMs broke that balance.

I don't know what the right solution is, but at this point shepherding
patchsets like this doesn't make sense for me.

Thanks.

--
tejun

