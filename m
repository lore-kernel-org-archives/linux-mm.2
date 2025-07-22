Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E95C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 20:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C2F6B009E; Tue, 22 Jul 2025 16:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944246B009F; Tue, 22 Jul 2025 16:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8818C6B00A0; Tue, 22 Jul 2025 16:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 778196B009E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:11:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C5961A04B5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:11:26 +0000 (UTC)
X-FDA: 83692995372.17.436F36A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B29240010
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:11:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvnEYZCf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753215084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPFqfHTW5KnsxiLhz9edf6zd7pMuKzXqFyyNT5kggzo=;
	b=y2ay840jsicJktSAetKUvrOp+Ys55/pZoPzRlufZnTvKYCpvN3iljBPQQHSR8H92MaPRB3
	p2hN7pdCjVnTIRxDN1O8bG5BFfW74jDxqvDVQN5l3vWQTLXIhLkJ+Y+xEn6fAH36S5fjYt
	mSeB9a0aHAcwtc088duG/5DuOoTmc8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753215084; a=rsa-sha256;
	cv=none;
	b=IeqMRop6BRMXHlF5dfWnFssZs3sX8rgmSwuujsrRHF1dtvcZqozIgsQZatYD3G1W37sjcl
	ReNVry881yC9nAj/MnHmdqnBFN9LCnJ40rm3RqalmmVpvUHJPPgaq0brrx+HhmXHH9wMLN
	ZTGX8grLj1ZXfpxepyr3NP5OVfAzPpY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvnEYZCf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 22 Jul 2025 13:11:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753215082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPFqfHTW5KnsxiLhz9edf6zd7pMuKzXqFyyNT5kggzo=;
	b=pvnEYZCfK3MecfMLXiRT+/VBf/gnC1CrODQcJgLu+gew4ylNM+KkrPU8jIY4fvk1lzJAGb
	YmlDQBm42VvhBFv25vTXlGEGoO672LgRt4BYCZan0C7xoAqek55/rGXP6r28kd7dP7pmVg
	G7oAHarBwLNFnoV5Mj1liOV+B1zjRrE=
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
Message-ID: <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3B29240010
X-Stat-Signature: t6q1f9qgotf6at9jkaikduo9o335kzoc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753215083-626702
X-HE-Meta: U2FsdGVkX18E/TpbacSEtgGN/V3ce/Y9F5G4nSZR2Owh1DUfkaI+tlTcX0Dy/kjVE9DCyPii2Zvd93M9Q/wH0anhbJNFQMd3uWm8KVyMdZgvPxbgzskYd4Mk7lDEknoWsZL9fQU5QkoRiiwbQzeH5RjoUSZRajdxbzp6t7R3YQQuiP2ORBFMU6UvZUfCKSvnL75kNRrb6mfJxGzYS1Jtqn2TrLvF+J8VvznzahjuDo5FL86iUFaZsieKFWBE+OKhvOqjXBpCNo+5bxXV57Al1hgCwDk5qUmQVzudpomARujXsxArOxfuPaNgXrIhJxD0+5N8LPX6eyRSdZDNh9lLd1GiHuA19QgETPBhr7/mJY+f5xZkst4RtWq/+6HSH3FE4GGykCkxQN2f2WkVDBzZxHgSjo9XLVFCvEwO6ig0pN8oZuDRjMlM9faMg6dChqvOSyFIZK0V1jBUxrpONkSvp7caNs+J9UX48GCxDmvH0Hv2pwOP7FaUnLMCOj6ZqvIEcHdbStx6QxFbsGkvr/UQ4y871qkK3XGYhAJZRVjDiQ5uuRn83pucG9P/6AsyRXPO3CviD/LnCecAT9T8yGcVXXuzTX6clQe5Z7MS1ucHYyAjDp/t+6T09czXcUnMyB4HfujBMWuwwfAisM3PqWuoc4davxkoyXPffTPzXSI1M487BILd49CB+8QxBc2yooN5q6C+pqxFC7nC2wX9puEFL5UCsuoP0Zf0efFS8q8ulWv/ETIClz/hBf6JzNHdQZjoHz9IxumY+vi+1Hdk9YnG7V4h+xnF8nUA5T602x+5GEB/OWPab6eZpCWgC4nLmVJ1qqMHh2q5TsZhoz47jBR6GLqFU1iuJyJSDfwTsn3H6YXcp9Q2lkQk5FS/z5PdKJyg02SmKJdlkEIqujCXaaHTohPlYnmHkQKeRwHoxZgS85dA3h84TS1MOXQoepVswAcUQRDy0P3+YLXEe/fRjaH
 kmE8dcEu
 grNoVVNMLJ0J16XIDhMRwtOlAxL6GdY/3N5tmz3oItjO2hF2c/vXy+5seEKHHmk7HmTPCpGWoLn5Km3tUHjzSqIkfA5adQc7RyP8xwXLvZUAtSpeT8PGfccZupe1ib3PiCAUNbU0DFU1n23u4PWqRD21611KrQYel2kVzucBEqtwZw9WO6AF1UK/NLHV3fn0XWJPfJhkwqleNWnApmMqmNNmDfzoL8buFGrw2SuLXoqdBa696OHsziRXCoxUjeJRMD0iDOoKtQPghSvEPfNp0+Vpgty+913XIb3gUmssjsvC6bDh6r8Xte4WUWp88pKgIoMXLerbHhGYNBO9Wf/B+A4xZvsXXhxNqN6VxOz27wrLOSMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:58:17PM -0700, Kuniyuki Iwashima wrote:
> On Tue, Jul 22, 2025 at 12:05 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Jul 22, 2025 at 11:27:39AM -0700, Kuniyuki Iwashima wrote:
> > > On Tue, Jul 22, 2025 at 10:50 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutný wrote:
> > > > > Hello Daniel.
> > > > >
> > > > > On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
> > > > > >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > > > > >
> > > > > > The output value is an integer matching the internal semantics of the
> > > > > > struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> > > > > > representing the end of the said socket memory pressure, and once the
> > > > > > clock is re-armed it is set to jiffies + HZ.
> > > > >
> > > > > I don't find it ideal to expose this value in its raw form that is
> > > > > rather an implementation detail.
> > > > >
> > > > > IIUC, the information is possibly valid only during one jiffy interval.
> > > > > How would be the userspace consuming this?
> > > > >
> > > > > I'd consider exposing this as a cummulative counter in memory.stat for
> > > > > simplicity (or possibly cummulative time spent in the pressure
> > > > > condition).
> > > > >
> > > > > Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
> > > > > thought it's kind of legacy.
> > > >
> > > >
> > > > Yes vmpressure is legacy and we should not expose raw underlying number
> > > > to the userspace. How about just 0 or 1 and use
> > > > mem_cgroup_under_socket_pressure() underlying? In future if we change
> > > > the underlying implementation, the output of this interface should be
> > > > consistent.
> > >
> > > But this is available only for 1 second, and it will not be useful
> > > except for live debugging ?
> >
> > 1 second is the current implementation and it can be more if the memcg
> > remains in memory pressure. Regarding usefullness I think the periodic
> > stat collectors (like cadvisor or Google's internal borglet+rumbo) would
> > be interested in scraping this interface.
> 
> I think the cumulative counter suggested above is better at least.

It is tied to the underlying implementation. If we decide to use, for
example, PSI in future, what should this interface show?


