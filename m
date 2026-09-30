Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657D4CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 23:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3886B0088; Wed, 30 Sep 2026 19:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94D16B008A; Wed, 30 Sep 2026 19:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85816B008C; Wed, 30 Sep 2026 19:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A83586B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:35:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D2761A026C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:35:37 +0000 (UTC)
X-FDA: 85272037914.19.83EA5E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B2B48000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:35:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BK5TJkB5;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790811335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=9wZLP+oTbknfbp3RkP0l6m3e4bL5ylavJVKS1T8of90=;
	b=1JI0Rk32WfndCWetgMVK2H29vA6K3Ya9wBRXKDsMwJJb1aP+tLpsUK4BK/ddMHRagkLSII
	wJ4ulTXG91S5hHeSTNCfXBIiOSdiBAEuPqnwk5F3vgUlyCdYTf4pE3ZljNqlkxLJy/Dym9
	dHxkcXNkHr5teqWapXHiU68YXLoYexE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BK5TJkB5;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790811335;
	b=Q8IOzpYs7vKfz7ChkOPOk5wvuzYMco33vQzQ+kxu1UslN5DbJvU8yMDMEV4twx2ISuI6dU
	o+qQZy/FxCqvSiAsrHn4V0qG2ExI+Ao7hqV4raBtXcLT7uVxNe60JRxr8EuLt62qpYRqre
	8kQTudsXVFxkOXaBuoxpzxJcevnyeZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 752DE43EFE;
	Wed, 30 Sep 2026 23:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEC01F000FF;
	Wed, 30 Sep 2026 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790811334;
	bh=9wZLP+oTbknfbp3RkP0l6m3e4bL5ylavJVKS1T8of90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BK5TJkB5IGftgeaJG2HDjs70RD5rQUlw/q8Zy3kOYU7qzv2veRbSVTI40FpoNTzwh
	 dPjjOpLvz1br9YDpP8ERDUHMbsRdHkkb817QzqOnIYUb0JThqETFLTlRiLliZjQeCc
	 JGS99kjehaBbgpznAfRDksfYKJqK99oipg4DMesZmkBoZiv35Nrm2bnnea1HjpDW9T
	 oUZgcv2IqGpYWW54uJZvq/6i6bvVqVbDiqs+dIszJpjGAeATbqknggpIeu+2BNi/g2
	 Qy1AKBdzJVu+nSqbDz8ijZ2Sq2NaDb/CaSLe1GpucNf3ZylyWxKhzQbx8ldUwrzQEo
	 0KuKBok25v6RQ==
Date: Wed, 30 Sep 2026 13:35:33 -1000
Message-ID: <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <arw4rjVkm2ob9ioL@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
	<bda525506b3fb3e61da28a112f28abba@kernel.org>
	<arw4rjVkm2ob9ioL@linux.dev>
X-Stat-Signature: c4oys7ruuc7nbopjuqcujfddxi5utofk
X-Rspamd-Queue-Id: 9B2B48000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790811335-226883
X-HE-Meta: U2FsdGVkX1/WBJHvU7z6Q4Qq31Gz6FJCfzMP2Kqvm7Q+EgzNx3vCGwyGQN/rSp9qA9/OHopqTXSqqshFa30Mth/ByuzvfBAXuCIrS/YdE+hlYGd/FpFBl3F0pW7d4UtHyNVzb+5MlsqGWClttMMScVgF6phZ2ANZNVWGy4WsCwOzSzn2wnSfBKRVy+gmaWpd8ikT0+B6J5LhE66Q8KkZzHhFvOi6+bhLg3oZO6WWQn/grRX3INc/CwPirxyipYxVWKwvQzvGLsaxiV/+FBvSjxzlspasDQy3LO9Weag8eTkBkEQne2nd3nt0rCT9X0K8tr3SlyeumBqI+/M6/PKzrjsPI/lHG3yqzaGDZPJltRPlua+f1QvsVvUzJaMkWU/49BdSZ8tzBXe1jKJaA9wiO3SdZo/Ol6z9IxepMmxMDUiyaM5rX3JZZ2LXf3CDexZG3amQRSFODCTOXTRQ46GJe1Sm71aQ74yZPXxuRYUF68G9zrX4uKIp+Y2SL4HDTTdroug2lL83NwMhTldKdUtqADKDTqpGdgc2dlihv4gG1AXjxKbStec8fgQYFNyfwIK57v+kC2/5GhoKLbcGQ/Nbpx6wc4cm1RZCnuYt24Gu44rvHdECeiDnMSdHOlmJnSN3iH2ROX5SVq+VpB97zgFhWBej/gyFsK9zIF8uDhnrnyJMGr1A7ydJEMYN3TZY2Q1CHbv3ww5FLQSHyjZ5+lAg/d7p84U7biRPJ5XylPRPrczmHY7Q4inPh1eIZCtEu7YacuwrQOBNhGv3qqD9X+xnBlXYg88GhrM78rIQRU2p6kT6oScpAxqBhx9aRJk9MKRT1bIUuSl+c+X2Cv2JkGYhyPdUlK0TwJd9GXPYiwu2Rf9itc49bHNJJ1Rn66B/rGwtxvGUlgjptA5xCc6Z/wbd079H1Cc3Tvf6Z3DB5UsO26Vmm6coFnjcceyBiwk3V0JH1k8NADTOUO8H4Zku9pj
 ZZ319s1z
 cLfJLvYY/TA4kigq8fV4+wH2Bgp/vfP2YHDpLsWmIRGlF2FDnRWilMFGeasJy1+1nEYkRIsxJ7IdPLv2Evg9AvnV1z32spFnRNtN3W3eGZ+VVZsXL5QZguxUQg/Wfs/rYZuzeTcGmuMkTcjj1JJBVV3Iy5KyhpqByjySBOdO4mmLQYN10UcjqCzLF+neB6tmDQQzBYyVOdWNa1sWoWaEOTZCWhXsjIdiuczyZMw/iXJnc/ppcGOhk0Ij5QGjY8JqymwPQr++zkmwF1CqxLYJzil0lF6A2wNCLTPACOJo01PgLAldIcOuY8GrUUnc8GOWm2f38zXfLBI8WD6IBLP9huMSCkoJ8qTUj2pxs0JZx+5VCgNvdDJ/PgBALxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Wed, Sep 30, 2026 at 06:28:21AM -0700, Shakeel Butt wrote:
> I am fine with changing the default behavior. Actually, I have been
> contemplating whether I should propose a revert of commit c9afe31ec443e
> ("memcg: synchronously enforce memory.high for large overcharges") because
> it has introduced more problems than it has solved, but that is a separate
> topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
> arbitrarily, so replacing it with something big might be acceptable. I want
> to keep that decision separate.

Which kernel paths allocate enough for this to matter? Can you give specific
examples where the in-kernel synchronous enforcement helps?

> Returning to the actual proposal, my plan was to start small with a narrow,
> specific use case. However, my long-term plan is to provide a mechanism to
> change the default behavior for custom use cases. For example, for
> memory.high, I will provide a way for users to specify what behavior they
> want, i.e., whether or not they want more synchronous throttling.

This doesn't seem like a policy problem. It feels like a problem that should
be and can reasonably be solved for everybody, so I'm not sure whether BPF is
the right call for this specific purpose.

Thanks.

--
tejun

