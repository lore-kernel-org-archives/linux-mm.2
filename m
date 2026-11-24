Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9700B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUGYs84X
Received: by kanga.kvack.org (Postfix)
	id 954746B0837; Tue, 24 Nov 2026 13:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B9F6B0839; Tue, 24 Nov 2026 13:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841116B083A; Tue, 24 Nov 2026 13:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62A1A6B0837
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:47:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9F55120C55
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:47:29 +0000 (UTC)
X-FDA: 85470895818.26.C13F5A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57B4A180002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:47:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUGYs84X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546048;
	b=ObMsKh1G8YdsjMtHvBCmcBn9aX79E9C8+hk0YFB74l4mLNPOX1PPkqMpSgO56H1TCLry5J
	a2ygx1Ei7VURGD/j7IGe4OXNAg0PwT0KzXKDMaxnQN2uF6D6Qwm8lK0Bjwxf+CRCBH+bTM
	ztI7Cld3WMA4NY6qU7rVUPhyAF9/hA4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2Hsh7q0vkgnrZd8VrB7TvHooxViXh8npaot090DDvQ=;
	b=PHC45FaOCCb5euCNb/8x+Vhr+2Be7+mb/j7itRf/c/n6XLUCWkEFetPtAQSh0x8ydF1lx4
	u+rWgedQPVngwV0CeK0U3DEDAqeEK+OB5Zprbof809U2rD/3hzewr1IlBo8UZ7watWmo1v
	GFc+KJYh1U6+peRxISutuZGTcU76zOk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUGYs84X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83B4B43B15;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2561D1F000C6;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795546047;
	bh=z2Hsh7q0vkgnrZd8VrB7TvHooxViXh8npaot090DDvQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SUGYs84X+rHx5Jhlz9tqODYGR3XBGKt5MJ8kY5HpsHzHjv+cAm2NKkVpcNcA1rdRp
	 vyRqt76aLpxH04KjUvcLxppU2kFsjMWsLKDOZaAaagXJRgBiqCiKU/gfk1sWYk/koz
	 axF9qE5lOPneSDvBXg/aX6IeFVHWI/ezOWUCD8BjIBft/9YScOEFnbyRgqfgB4ETp8
	 FhDjgcdZLmvRddCOdfP7xZzReN+Q7YuzhCOoulSO74vuuzt4Ixx318eWEsAhN8/rL1
	 wHVHWTiXddMGDC2kDJes3v6+MwX4pI73E3nMDt/yww+mNzmVVUEriFYZJHZ9Zqs3Hm
	 aSPO0B1SYYwvw==
Date: Tue, 24 Nov 2026 08:47:26 -1000
Message-ID: <837253372dc1b40de4e20924c1e4549d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, kolyshkin@gmail.com, chris@chrisdown.name, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 0/2] cgroup: list processes whose leader has exited where their threads are
In-Reply-To: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57B4A180002
X-Stat-Signature: 8zthyox6c4qdr8xh4qikr7firrwrq7d8
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795546048-317334
X-HE-Meta: U2FsdGVkX19SpRIHa7dROANeBLEyEHNHlsahnKzssqEDhRBnRJEMBI+fP/5GAlZ22gpp1B+iFNxtxwuMyMVYNa8IYKTc5HTVovnn/j5aLFci7uH83O125Fp4HhAOAWEKwpXFqd9eo6zKiGJSor2bvTpFyVHK5c7Q93FvdYOQUfMkgdKGTCDAscFUNQ9uH3uRkYLG93mRzoZ2/UGmlf/J7SS1XaX+GAcaqp6X/PcYuHoe38Q8hPupi8SURFZWHiOxC7QBYr2vXV7r0dZjsZm7Kkt+NUBtRIB67wujqiFOiMMFqWEiq5LYrl/cygxe4PdNq4dho8l1GWMgeZKKmtBjvniQ8wYM0QR8NIfJD7CNC1/XBp8umI3Y8WLfN7dUR2uy6nRlSk8gNYbYMKwMd2YYNUtT/vqxLGSq9ySG72m1XG5Da0UAiQqtjMOWbbbEWplH7svdhh/tf/jMOUYZ6Dk7sPzrxMzBHtblyBz4DUUuW42GqTa+lpgQQFog3okbBIkWUk5NEvp6lolxGxmupTZJD6KToCxqLoOzZ124xPFhm9AIM2enfPsttP7lu7N0S2wmcIocPclN5Xy2GDpj69QdmI52+Tdz0cNFgqPEIAzepqXGWHBSrSzbrGzNodlK1QLqNwwhTQxpz05gXrSBtzWHczYMffUXvT4mxUs9iGwTA4fK7QXq+Gln4T6+Xt7nOuxLhmGnQ6tHb/DR/DpJQtCXzPM8/RCL40QJt6yPZe4sYlIIdvMDh7GSc+YAgWC6dCpJ8gUYkJd8jc/DTEJPqYB7NWAnbnyCaLacWBQ679C8SUMITSLAEUWrgKDU9mEAFSUv5Yz/poivdX+JL2YzC7jhmnELHg+IrNU3UmgAkMK4kuWGm9F9vFgRRu0jeIe+hrWMbyMWPh3nkHml5l7nwfoRlg9U22xwKBaTZ67eiB0KKTJu2QpJ1BkEWZ2Y3dn+Wv0w9UtBO6dHt0/DM5n7LbV
 zprWhq11
 Qd4+W+8pGp6/uTleGzWRVXPh9lC/iLhXBKpa9ek2JEEVlazI66OPtQMw0UeBuoLjAbJSwz/xQh68bhk7n4t4MAJbl1gGDIQQoUoGzMnaByVSckMnX+OnjApmRz3QnIEuvId0jLg7YxNDq/GWvUGKFZzjmKDoBBEmyY5TIg1wWnOLHYJCUPJvE/x7vgyw/NCEvAy0dyI/J+KTNT6EaIigD9p8YnhTCwwL1uLKi0Zqj7jJTKMk9UK5EItcurg3nYG65DY8eI0Y+Tk6ukaVkAt7ImHv88pXnt859RrmBL+CDUdcKwKos4f3VM7qEHtsOBHMaF4G/677AQsUWTnMVljicVKTTGXJtI78NKib4uZI9Ggubkq9yqRCsSbom6TRwOUbbwlX+0bQemMykS/HL70okp4YrF2TvfSO9W3IdDwxcPuDswjQumyQmix/hHwPq1csgpaajRVbzOZIBVdr8CWiqfEAGONYHQmVj3I1iF8KOhuHRuL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Zhan.

On Tue, Nov 24, 2026 at 11:35:45AM +0800, Zhan Xusheng wrote:
> This implements Tejun's suggestion in [1].  Patch 1 makes PROCS walks
> visit an exited leader left behind by a cgroup.procs migration at the
> first live thread of its process.  Patch 2 makes the memcg OOM group
> lookup do the same.

The main problem I see is that it's difficult to keep the walks intact
this way. The thread that a leader is visited at is picked by testing
PF_EXITING, which isn't synchronized with css_set_lock, so, as the comment
in patch 1 notes, a walk can skip a process or visit it more than once. A
walk shouldn't miss processes.

It also looks fragile in general. AFAICS, only cgroup_migrate() sets
cg_leader_left, so when a cgroup.subtree_control write moves the threads
to a new css_set, a walk of that controller's css, e.g. the memcg OOM
scan, still misses the process. And as a walk can now return a leader
whose css_set isn't the process's, every user has to know to use
task_procs_css().

I'm trying out a different approach.

Thanks.

--
tejun

