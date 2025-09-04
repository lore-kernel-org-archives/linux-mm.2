Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8856DCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E348E000E; Thu,  4 Sep 2025 02:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBED38E0002; Thu,  4 Sep 2025 02:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86F28E000E; Thu,  4 Sep 2025 02:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B24478E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:39:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FE64160A23
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:39:22 +0000 (UTC)
X-FDA: 83850616164.16.2C1ACF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB9A21C0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:39:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQw6WNVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967960; a=rsa-sha256;
	cv=none;
	b=VNywqiDf3s8a+u/MBWg05y2N7he8CnGw51ZyZaPZHKRgXN0f/QgnnoGWf1/OHYfAVbf+bi
	EdymX0GqUu8inEf9bfGa1w18PXEMimtyyztbCOTG+b1TBg8PIBXheVzZzpsqVxzwVkXoCs
	kRZT/hXElVzt8uVnmAd1KGyJs5FnYe0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQw6WNVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VK74MCr9d9zG+LhvF2lYUOHF0woy5Q3zVfi2vnneeY=;
	b=wLXNHAdzuTmKwNeqGhsANPpuS3/izNiD4VRwUEnp2JhZ6SJY2u/xzLVuaIqTTs4k/Sqd/U
	KMezs1hU4jHr6qjRBtD5CCUj3lyO8DT5b8eFLzGv2g7YmZc8cwfHTb+BT4V32bTBxx/ZKp
	jTg8dNQGVrcRt0c0IVTCbs7CRaQ1Yuc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9CA86026B;
	Thu,  4 Sep 2025 06:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2CAC4CEF1;
	Thu,  4 Sep 2025 06:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756967959;
	bh=SVkNgU9FyklxN8vI/1LcwXJJASb8Zw5fwx+daQ223sw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQw6WNVHoW/KS1hUY15Q0PkslgZvP+TZ1M0hUw53UBYSSKbljQ1nnM/X5n93S/I3A
	 JvAJeGccjuWFWJQr+HI0/ttT5PXEv/1/S7MwOcIp1cgRts8JxIzc7+6q0y68E+vcdQ
	 IjcY6aP5szF66JjI2H3eSBkmcmzqBQMtHtsN14UFsZzEf3F+HhgwA7AtEBxp1e3Cws
	 7c3brDrPJVm2LubAkN2f/JJIGRYImAvfavKx0reOTXi5MQcgHge5XvaLKQvErg5+ta
	 MTTLlDMudFuMVZL8FuyIT24Gvg3/ysOSwrAHHM2x0aF/sDNfhmoJi+9R79XUVpo+Y5
	 LuvIG/EMIUghA==
Date: Wed, 3 Sep 2025 20:39:18 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
Message-ID: <aLk0FuezkcInlM_r@slm.duckdns.org>
References: <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev>
 <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev>
 <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev>
 <aLeLzWygjrTsgBo8@slm.duckdns.org>
 <87qzwnxgfr.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzwnxgfr.fsf@linux.dev>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AB9A21C0009
X-Stat-Signature: 8y54u8hkwm1t3qbjdqtn7hch56z7adp7
X-HE-Tag: 1756967960-996710
X-HE-Meta: U2FsdGVkX19okDa5PlBeIAqK/yE4XzVksvE0TiZ15eL1UT6+L0daWiNKI4cgCLfvyOTCR0WbsramsyytU+vWywv0dOAwo19a6+R3MZtmFOip6r9PKITqxuCb5IWg9eZ3NEabPUhUZ6Kmz+ByqPfPOEFQ/0Wg0vd7W9jDhZhDre4gkNH8RYkYN55wesXjw0pGyixIkKUJwl4Y6Zt5bYu+7cvndGYlow/CBODATztq845B3Ms5hINMu7vAXu8Yk6sHtXi8TZOBY90hAgC5jN9Ys18vrO428NtjmI31+fwyJqMhlJx0xLqmDaAniAZtecuNfQW5slbCwh5AW/MyMMyPAAaB4Rjlg1/fSCbtZsBfs+sY0hFY8NRy5CN7trNLS43cl7s0wUIE61szJPyPyyFrGthVSNSgl4VlNLkIYrFGgAB+ichIigfUoIyBggMtnm0Fc5yFGMYXGDbYbi46viSWiLpHKM2WqbEcrxbS6qRjHKipzh0wWIhtimNM9PGmRIwXCZEY1Mcr2jJEP+9lxbsxyMWrED/7ILkzEslqce8eutX/zIkjhcMbUhDlTeWua+mdHS/S8NHs/fHgGV9bDyPGR0FuA9+TwxVx97tZz5Jf7vyX4cDVgoCy1ZO4T4u0ljBZVytUGBAMgNs6AfxWx44nFpI8szwPZwGfTexbJwhZanSaJFPPVdxVl96meU+zFeo/z77wML9OTtFKff8f8tuT5Ozsvjjft9UX6kF6H1gKL0prENms5innZ6NpDJ97x/yMJ3NIUUpQX7vuIcKZM8pu3D7oMvBGeVfi9g0rgHAC1J3WnLF8xEx/pBkER2SJLYPj77Vvj+zmSPZRpEUM/SEGjTyznMGZtaBmx5gnnuAZXCXQTW4kh+0oFU734x/HY/LWgmOgfKZG12G/DivHpFTtvDuIMMUIRnrfjBauBtUPe24m3E7Xw6L0NpQmHUH6jueK7kjMSgCMBkv9Tonw8WF
 suysWNU1
 wiVTnCwhXCaSFWiYP4My9NCgnG9r+AFkZr3MF2FCDwGkoG+17i3aXRbtgprRzc2OrU5TK8cT+PrbCJlnisdJnmZGaDuIhBJOhbgOAS02jcfWONKkVSEtAeI9JqeqITs42hYtxnuCxirInGzBd/WxwTW3ci0yb5jf4x7AU9BRx+D11bII/C1HibCN9udZ0Hbj0azmyrU/RNfnXydXOkCPf1vD1d94mD0Fx9i3z8rKVMAm5x10kLlgpf23v1MclG5P4+QaT8J0AQRNNpqsYFnHgVTYkcNKZQ9heGhw5cKl4ZWtZ8pgpY5ZctuKQOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Sep 03, 2025 at 04:30:16PM -0700, Roman Gushchin wrote:
...
> > - I'm passing in cgroup_id as an optional field in struct_ops and then in
> >   enable path, look up the matching cgroup, verify it can attach there and
> >   insert and update data structures accordingly:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5280
> 
> Yeah, we discussed this option with Martin up in this thread. It doesn't
> look as the best possible solution, but maybe the best we have at the moment.
> 
> Ideally, I want something like this:
> 
> void test_oom(void)
> {
> 	struct test_oom *skel;
> 	int err, cgroup_fd;
> 
>         cgroup_fd = open(...);
>         if (cgroup_fd < 0)
> 		goto cleanup;
> 
> 	skel = test_oom__open_and_load();
>         if (!skel)
> 		goto cleanup;
> 
> 	err = test_oom__attach_cgroup(skel, cgroup_fd);
> 	if (CHECK_FAIL(err))
> 		goto cleanup;

Yeah, that'd look better but are there practical differences? The only one I
can think of is fs based permission check but that can be done separately
too.

Thanks.

-- 
tejun

