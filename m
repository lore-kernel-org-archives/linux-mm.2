Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA12C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C7E6B009F; Tue, 22 Jul 2025 15:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64146B00A0; Tue, 22 Jul 2025 15:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1346B00A1; Tue, 22 Jul 2025 15:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBC26B009F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:05:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AAF3C04A6
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:05:52 +0000 (UTC)
X-FDA: 83692830144.01.6651D2A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 803E0180005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:05:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bsjxRM8W;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753211150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YR5doc3ubATFIwFqCTAQj7mEB5SIW2AFvm6iIjBaed8=;
	b=QEThaUmpcydLguOaT5C/aiX0fKpfRSs9oe0JBgxSdDU58HzraleI9EIb+XbU1ntI+iONZk
	SSIboNqi4MeJ5C83KmZh5fLfoFH8nKuWrt1KHvD1mKhKSmtSXTSsJBfaKIJOSWvlLY5m1Q
	CsM1O3GW4CYoGXys8ayuu0WZJNz6/wk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bsjxRM8W;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753211150; a=rsa-sha256;
	cv=none;
	b=aVZWYDpABYw5Mv9rBUgMZIxZ8GORS7tFbM5iaiBopACSOlPgqBVVFPaKVkt37hUdE1oKEL
	iDUP9009a2K1H6ftE18Vg4OEfrwlDSFYfdwVZrNqba7l8Rd48Pz5fx6BOgFOJVrw4BmKTG
	Q/30rTPpXVMiEfP7pFkSErJQ3wGKXTY=
Date: Tue, 22 Jul 2025 12:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753211148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YR5doc3ubATFIwFqCTAQj7mEB5SIW2AFvm6iIjBaed8=;
	b=bsjxRM8WfX6Y/hUmZzPYJH3CThZq9cHvRIsrKdAIOKH6kYfPmQQU3ccX6o8xRli3BDvuGX
	H1X1NqHpg0kyCmcreBFRHAoB2aeNqGSWfxXWU9nIMgHnMgWk6BPAacJJ2q3d35iSWiDNHp
	gY0xmbFWlTp6IyWIv9lYzxOQmqBIka0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: w6wfshk8jpbghbrshdw19tyfz8domsp3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 803E0180005
X-Rspam-User: 
X-HE-Tag: 1753211150-503562
X-HE-Meta: U2FsdGVkX19FW3krgZrcMOzVQp7IS2QPCKWMIXbMBbqG8e/sI466BBJ8UZN3CazFws1Xb4UU76MIUKGoUeawfrtw1NC9X88+oDY2Psabm5nnh6Q5vqYCA8opyW93+WY2VcjkXMRsKrmGUD6hRvVN6/+zaJMa0Shj2px1b8/o6b2w7Pj/A4E761ByxqijQMXTIqpgohX7ADod2HLrv2Dy9Nd9il4lGijKWrW+AwtYEj214VO6mVnDGQT1h5qvmbbHXBGhjekd5gpGjCWJePeRBeJscyXDCDUXspy3P4mwlmfW+Wf2jYUu0BCrc9Q6Ut3Lycert221xQwIKPvy3lHKxEkiQ2IuHUxx3AsNVfC1Q9O3BI00u8eoWIekrqXzAnTsIwOCVsmJSgJYFXFig16MVX6WtktW87EPOzNhVdJj6oOZXtw1L+FRJJjtcBukNIO3YjdtVXLQoOuNLTxCC72tSaaAa1nRU72TDwoZ9lFZeNEAdHFUua1jnymR4YtllRZZ1H3ehqQJ28qlzrIBQYKSXp8eZQi+jzTodHF0rk8yUCBY13r6GXv2UPhB1BWgUD/BVVoLIBpegzEHNl/X38F6YrprlrmgSR2IIWT0S8w6jDrD9N4zCyZ3Wbl3RYILlGjq0t0KRlpLNDzmXT86kKn0RMDMAzg3qkA+S26QTbbY/vSXcv3yT1UO4MpKL7fs0kOCjq4bvUNHHQJLuMM6FVmChR/iLh6ao3b8j2JNArg9KpQzKhbRKejl/4ZKfFMwZPr4HI+XAZUFd4lTOKMOZzGSburzdtxV3miTGLsu5L/NVJhMvJRWoHMf83CWuXhxf4fWV4sPODzcR1uPiXW3dPKCGlpr7/f/tjY4+eRG/ifEOrh3PaB0Vo47YUzZFHStDZLqj5yXiaUs0d2NRD5+lA10ANAb5KTNu58zNQKVYrPeGY1G8mbyuK1/Ze0Cj+jDRl/Qb5zcmnxRzu413H4boZA
 vDxI4YcS
 QiryHytTMQfxnNByieOiYUMw4tTcipevxQJzaXREWEJkSkyrz89Y3g+Fw+7JV3Jg5Xst309s8IY8z+m8QIt4qmo7cWEyGZ2XXrMnKZ/+sbwBKyQiBSTdVivNv2Fxf0SkqdwhTx9da6jvEXgzCrBq5PviqBY7VDn5O3ya4pB/wqB8HD9CyzTISQn+Ogb7HcitaRZLMzkG3szQIh1AvbZR1MbRwySch28NS16TwhHFvpocIeyaUK+UatROPOo4a6jYKBpz5QvQ4RjA81JRMTGlLIKgR6sE6tKg8ypuIO5Q+HHIhw8uVezFU4pSgz/O9Ey9d8aY2rYPuffa0gY9ktc9fXQ5PK+r9srT4T7gW/23KOn4fPoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:27:39AM -0700, Kuniyuki Iwashima wrote:
> On Tue, Jul 22, 2025 at 10:50 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutný wrote:
> > > Hello Daniel.
> > >
> > > On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
> > > >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > > >
> > > > The output value is an integer matching the internal semantics of the
> > > > struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> > > > representing the end of the said socket memory pressure, and once the
> > > > clock is re-armed it is set to jiffies + HZ.
> > >
> > > I don't find it ideal to expose this value in its raw form that is
> > > rather an implementation detail.
> > >
> > > IIUC, the information is possibly valid only during one jiffy interval.
> > > How would be the userspace consuming this?
> > >
> > > I'd consider exposing this as a cummulative counter in memory.stat for
> > > simplicity (or possibly cummulative time spent in the pressure
> > > condition).
> > >
> > > Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
> > > thought it's kind of legacy.
> >
> >
> > Yes vmpressure is legacy and we should not expose raw underlying number
> > to the userspace. How about just 0 or 1 and use
> > mem_cgroup_under_socket_pressure() underlying? In future if we change
> > the underlying implementation, the output of this interface should be
> > consistent.
> 
> But this is available only for 1 second, and it will not be useful
> except for live debugging ?

1 second is the current implementation and it can be more if the memcg
remains in memory pressure. Regarding usefullness I think the periodic
stat collectors (like cadvisor or Google's internal borglet+rumbo) would
be interested in scraping this interface. If this is still not useful,
what will be better? Some kind of trace which tracks the state of socket
pressure state of a memcg (i.e. going into and out of pressure)?

