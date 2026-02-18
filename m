Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B113E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 21:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7AD6B0088; Wed, 18 Feb 2026 16:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B858F6B0089; Wed, 18 Feb 2026 16:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91826B008A; Wed, 18 Feb 2026 16:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 923996B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:26:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27536C17D9
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:26:00 +0000 (UTC)
X-FDA: 84458860080.05.185F473
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 12DCA8000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:25:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1x2hzsx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771449958; a=rsa-sha256;
	cv=none;
	b=tZ0RvSFFknW4vwL0E9FuzRChK6ZguiH0BgABaTZNyKc0FeL69ZxvpNFunF7P+QRz/6Z+ym
	mBpWDrKKApLhOdvkDOSCoNquXhj7bgbw1CwmDNWTTfSXitPb3GgxAc6SWW82cKI7JFP3B6
	tD/lNELjrg4okS9anarCPwvRDaG86vg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1x2hzsx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771449958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wo6vv3zwAb49jabaYEhJvfqzD+EG3AeCMF5nyF6m1Uo=;
	b=TGH+VYC+IyD7LVQogrg46kpHJG7OMEdXOD/WZJpLsRlKkvkEyX3wb9ItA9hLKjp+tb7kV+
	g8pGpngaUr55nAzpWNBlWiU5+nhqYCn5i9aPBDGqUpRkDrzxxwH/Bd1nVwHLp6YrYYrxI/
	ys/KuKHCg59eb/E9VdcM4XpzZejG1Ok=
Date: Wed, 18 Feb 2026 13:25:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771449955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wo6vv3zwAb49jabaYEhJvfqzD+EG3AeCMF5nyF6m1Uo=;
	b=n1x2hzsxevl2KlW0/u2V4Vyr/ZSO5Xh+P9TXfWKLEIalUF12vlcIdJ8A5qhfR4EXzkOPNc
	tA8qejHL3g3QvA2gIMr6KY/kDgpRKkTCAAG7m+6aiqlp3hyLgb8cRmYYEXY3+leRbLTv7i
	xA43Ain+4HSrKFlMxM5ocAXx9hoOfKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com, Muchun Song <muchun.song@linux.dev>, 
	Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Subject: Re: [next-20260216]NULL pointer dereference in drain_obj_stock()
 (RCU free path)
Message-ID: <aZYuJiEvMR9wC66k@linux.dev>
References: <ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com>
 <aZReMzl-S9KM_snh@nidhogg.toxiclabs.cc>
 <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yshn7ywm3oggcod78r6u6f5gtow6yn87
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12DCA8000D
X-HE-Tag: 1771449957-984085
X-HE-Meta: U2FsdGVkX1/KZekF42Da0KD/EsX3Np5Pg7y9OpsosjlTdL7c1bVEb9kePzvJi/t1uR3TvlUgu/O9sDwaAXHJsJJS0+ZAyhdidmhm8XuHtmQzYJQkiZfHgTZLCnVOz0FiXPWVDdGgB0TGZmTjfwBT74KAlCCYSxSKLXL7ikO69e7PLPYjHa+iGnn0rNGr/k3OK56Gc1sY4zGJtos/4nbTlL/L7WVd7I5u2GQDzN1TM50lgiuaISCDeaMwMQsZYLnql/gLMhztTlUpbZVOlBDzvQAIosW0jP17bjofqZqn8YbeeGLewYuOLDFA13Jp/q5yoytkjSW3ii0CHjjkeWi3U1gixvVKMqDxQ5tCCJc02YFRLJ8cjQEmXknf8P/nPSlCB7wiK/llj4zyI1BWa4Lp75yZ8a8B6g/MfI726FrkqriEihKcuTt+b/0LhOD55mwxZ5kgZPJIwKvXaN/MXiOhqr1/OQAD61hlLiMidSZfWAAmCr0bbgmdNjyN0W2bpHq5tfjvlM8QROJydJPFjWv09uyg9CztRu4In+q1ZPqx3ZC8dH6cueVPuhNkfVoV0KRXG3onn60dM3npLAqsUOpcr6clTI19y+6dpG+aRrctRcTQvJ2tM9JBf6oVUSztWTV4NdohNbaPD0vAHMRyt3tH+rvwCUaACEQuFJIktEPXbD+PjkOV4N8oPdPBx4AZOWBci2WgbQ95ZMRyiDQw0TZQ7td1kw0c2vQcjp4DnJaeJnTNcXZjXbsBVXFv4AqT2Y6C6Nt37BRkvhBc8vLvbESeuJxIqfZX8nYD0DxD4YZ48HvbR/bhkwfmK2moIMNKwZTSoqKOxzeKbUsdGfwuY0XpWO4bmK7aKgIDB6PSm7mxNvYMH5FzlPoelhde3dLdq8bz88GaHnXrGXu5bLiY9TszJ3VE9oKn1el4NTzPxrvZzoE1wkA8f22srEuyOCYbZOw9IPvUim65oYJ+Q4o5ro+
 KFgkWmC3
 QuSh0x4mpBBEi4Him7+qgzxXnmyfcqiq2xAhHWM5CGt8Ol3Pn4E0UzAkCXsxFRibYcRfqTYnCs0V3k/IklJ1mG0z4hVwA9TISanFHaIfajneZKWt4/qW1reoLL0FeAAzHwMJ1Q18YPhivimIxiVE5yrMp3yYWpXDgQdlZN+Mc2KYE2yBoi6W3TN4ZsVkyrV264HSaq28IHifYTUAlHHIiLQdKrId+fhSd51H5oXulQZTkKVNp/FfMoK9Hb2t64971r8CqefM82ocAgOSPyNBVzSNGHbmb0vhk6QC12iMQdJbzuM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 12:36:06PM +0100, Vlastimil Babka wrote:
> On 2/17/26 13:40, Carlos Maiolino wrote:
> > On Tue, Feb 17, 2026 at 04:59:12PM +0530, Venkat Rao Bagalkote wrote:
> >> Greetings!!!
> >> 
> >> I am observing below OOPs, while running xfstests generic/428 test case. But
> >> I am not able to reproduce this consistently.
> >> 
> >> 
> >> Platform: IBM Power11 (pSeries LPAR), Radix MMU, LE, 64K pages
> >> Kernel: 6.19.0-next-20260216
> >> Tests: generic/428
> >> 
> >> local.config >>>
> >> [xfs_4k]
> >> export RECREATE_TEST_DEV=true
> >> export TEST_DEV=/dev/loop0
> >> export TEST_DIR=/mnt/test
> >> export SCRATCH_DEV=/dev/loop1
> >> export SCRATCH_MNT=/mnt/scratch
> >> export MKFS_OPTIONS="-b size=4096"
> >> export FSTYP=xfs
> >> export MOUNT_OPTIONS=""-
> >> 
> >> 
> >> 
> >> Attached is .config file used.
> >> 
> >> 
> >> Traces:
> >> 
> > 
> > /me fixing trace's indentation
> 
> CCing memcg and slab folks.
> Would be nice to figure out where in drain_obj_stock things got wrong. Any
> change for e.g. ./scripts/faddr2line ?
> 
> I wonder if we have either some bogus objext pointer, or maybe the
> rcu_free_sheaf() context is new (or previously rare) for memcg and we have
> some locking issues being exposed in refill/drain.
> 

Yes output of ./scripts/faddr2line would be really helpful. I can't think of
anything that might go wrong in refill/drain.


