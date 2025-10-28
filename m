Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E493CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89388801AD; Tue, 28 Oct 2025 14:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8445080199; Tue, 28 Oct 2025 14:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73386801AD; Tue, 28 Oct 2025 14:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D79280199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:31:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 119C788B57
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:31:59 +0000 (UTC)
X-FDA: 84048367158.24.693531B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 74EF52000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:31:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dSTQ7fLp;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761676317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7w5moGbJs32CZAVnRgFLSsnSp0tzhZTSlBCa2+otNc=;
	b=JFvFGXdtljaUE0IJakvEPvAvZl8AenJKCUzOgghRktWMfFdg6suH4m6vVd+b5cjavcUeKv
	cNASGQQsWve+zCVnPIdZM/I6OvzHZ+4t/l68aw8e7tY0LHYkUbT/mXjhvHMu4aatk4h+pE
	aC/S2T0ERFZesIRehAKVr9460d50guM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dSTQ7fLp;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761676317; a=rsa-sha256;
	cv=none;
	b=CwsOoQZ7RSU/yYL4pGwX6HkHM3da1yeiKt80EEDUDhHSLFe+JkcLT8zUsG8gsbgiHEZhbv
	LoVPCuPIkqpv//5a2rgKX/dvOGFm9AP3x4u/xaTGyhnJlWPlSUGMOW0QKcImDsuRa7bDuk
	DGGPMql83b4VbNFQVUyIcrt7+xctrZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7DC461176;
	Tue, 28 Oct 2025 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6875EC4CEE7;
	Tue, 28 Oct 2025 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761676316;
	bh=Jz+xbsYpIW+XRlp07m9hjFj4lzFgfq3vzbi6oujtiOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSTQ7fLpUEgaQWMm3JM9x2uJw2teY3OFi61nzuGcSC/ofmmQ4UUNKJFKwIzyzeJS0
	 o13aHsL5FHta5P7B7VftG1sj2/BhBPaKCqolUUi5NUXMEoT368Gb4Cq15IyN8NYome
	 1uIWQA5X0apRwJQPgUSoIl5K3q1GbuAGJHDPgcjwYSl+ct5Qb5SZcZC8tdhWbtgmoH
	 ydA1FRB5VQ/1yl0dauTiEMWJnNV0uKGzpxAopHKgnLPhlsxZj+Vqi2CMfarQCfe+LO
	 p/HfLi7jFpBX5eX3pIVLc90evL+Npo9KZQtz16HvE5k6LWE6GkZlGdZrAUQggXrhIn
	 WOQnwjho4g7oQ==
Date: Tue, 28 Oct 2025 08:31:55 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 15/23] mm: introduce bpf_task_is_oom_victim() kfunc
Message-ID: <aQEMG508sUQWDGrn@slm.duckdns.org>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-5-roman.gushchin@linux.dev>
 <aQD-RvxrX8_7QtxT@slm.duckdns.org>
 <877bwevqxz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bwevqxz.fsf@linux.dev>
X-Rspamd-Queue-Id: 74EF52000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bqemmoikxp6cjt7cd9rdzozs7dnioary
X-HE-Tag: 1761676317-691900
X-HE-Meta: U2FsdGVkX1/VUGBwZ9YDNady+PUcyGbQEKtKdJRHvtVQcNuqaRqnnzPs9UMNfbe0B4hYrwkJg73qHztK8u8HRGqei+0qrvvRa0xTQEJdorJwjga/evCHqnCif9Dls9gNWFkBT8/CC+rBvMvtDTNGOZhA4drQplhOhv9lhuz2BDJJSgLWzssV8i5BQmr2/8PyePZV9Dpi0qAkkcVVgDQMMEtksmjWmLzufc2PS4XFbz+/OJcxGjbJ79FZmFX5ClT0SimjFzhdgtK9qpMZS4LJtozyzvG8tt8yJxYCMmpuwy9wP5qgWc+jLj3JjaXxB3ijPG/21iV55+hzcguS3WkQXdh3lqll/eChXKen0ErL4TZG57Y2ZS2JJEMba7q28B10eqUgTu9Vu3yKVUxn+y4grj9Uns/oC0fOS+3kHTqPKtVCAY5iXuKKBLY69gAkFoig2WBALk0lBJ/JrwN3fLGaMGTzOIYMrQE7r3SU3OtmxQUpsNZg667DwmVMxTcN2t60kiT7LJoEBBYO33Y0b2cz3fqb+TRcvRoPEaG2hVFQ6iBQ19/wDB6Ou+UcfsyQbvt9Nz3Dpg4u6wkjWi36qE73VS4K3n+p2fYNhkepMbcoXijt6gQw4FZS+jXooT2gwGQIwThnQOus1J3APcwxm28uQhlKwZqPMPcA2n/33ckgSJKGyuFsMCNwe6EQI4CfoINHSN1pj8FWm2tMpZ2VvfF8y0pCvWQ+ytJ26ciFaCJdYMOV0VFFOjNlqGOpswUY3P/cslHaYAEbrjs1kbZVMk9mptsesGx6MTtyDjHZ6He51iGo50msA05m9Bu2pLk1Aem2sq3t8lQ/31VYFvD7j6+KmQERdBdMK7tnh/rMAHjmnwHBJbDjzUob34EQnpBackePN3RFN79APRBSvUbj5ZUclj3I+4BCJkNI+sRYArTddc+ikx5ekj3E+K9NqcIeoMJDsaC3dw9hC9pAK/UgRGJ
 1juFK4xb
 5IYSJlfYQcLianEt6PQePwxINnT0048PazHgqQ3ZUrqUHupV6gGgI58NbVNltvmyGkN32uAEiXcNu+OIWUuWoBwz9OOkZwyh2zs7sOGJ8XZMxu9zM3Se2LOkOpnm19WyjdzkjEzp8z5MlVwWWjZ9HHm/3TXFvoDVH0mo7aHesW1oW0KeL4JQQ/DyVz539Y8W9ZqgzUIaQuWA9SVuZGv02ucgftRK9j2GjhMZazP/NMcp9qHq2IOHqK+OtFBvs4b8LjV4KuUzC3ngKMhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Oct 28, 2025 at 11:09:28AM -0700, Roman Gushchin wrote:
> > In general, I'm not sure it's a good idea to add kfuncs for things which are
> > trivially accessible. Why can't things like this be provided as BPF
> > helpers?
> 
> I agree that this one might be too trivial, but I added it based on the
> request from Michal Hocko. But with other helpers (e.g. for accessing
> memcg stats) the idea is to provide a relatively stable interface for
> bpf programs, which is not dependent on the implementation details. This
> will simplify the maintenance of bpf programs across multiple kernel
> versions.

This is an abstract subject and thus a bit difficult to argue concretely.
I'll just share my take on it based on my experience w/ sched_ext.

The main problem with "I'll add enough interfaces to keep the BPF programs
stable" is that it's really difficult to foresee how BPF programs will
actually use them. You may have certain ideas on what information they would
consume and how but other people may have completely different ideas. After
all, that's why we want this to be BPF defined.

Projecting to the future, there's a pretty good chance that some programs
will be using mix of these hard coded interfaces and other generic BPF hooks
and mechanisms. At that point, when you want to add access to something new,
the decision becomes awakward. Adding a new hard coded interface doesn't
really enable anything that isn't possible otherwise while creating
compatibility problems for older kernels.

The other side of that coin is that BPF has a lot of mechanisms that support
backward and forward binary compatibility such as CO-RE relocations,
polymorhpic struct_ops and kfunc matching, type-aware symbol existence
testing and so on. It really is not that difficult to maintain a pretty
large sliding window of compatibility using these mechanisms and I believe
concerns over interface stability is overblown.

So, my take is that trying to bolster interface stability doesn't really
solve serious enough problems that justify the downsides of adding those
hard coded interface. There are just better and more flexible ways to deal
with them.

Thanks.

-- 
tejun

