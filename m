Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D501C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C009000BF; Wed, 13 Aug 2025 14:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6422900088; Wed, 13 Aug 2025 14:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1059000BF; Wed, 13 Aug 2025 14:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8D11900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:03:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66BC9160440
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:03:44 +0000 (UTC)
X-FDA: 83772507168.28.E9FFA9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 97F411A0016
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:03:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgZqVbaP;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755108222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHydpDYXf3xqaxuzsdcRUsqHAi9QaZltO6kLO6NK0ts=;
	b=mfadyKjsZJpyPAu9c7a3rBKJ7YzomSGpgZQS08kOTiL0k7H0YMh8XU2rA3fac7N54KEyVo
	itsSx+y7ytz/zFUtoOTerjRAOsZc+X6FWIHcFZaGkNFCYEAbHcFi5plK593HN2xyk7KtQd
	VxS8+aprUCmGSwftGjHMi3MV8F4lSDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgZqVbaP;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755108222; a=rsa-sha256;
	cv=none;
	b=7s/0z2pJtl/tUMr1NS2h3ZhpD/9WvHmzHROsCCiV3aeoGgzj+1ZxXchnC7qMO06XD22aZm
	rfTi2TyZGKdoMaREuP5xrWMTtoWvbooicPDhi2GQCpdyebTc3x7h+ytaBn0KQ57cWQBvGW
	bwnynWdStIW62LCjVy5nmkRkSuA4UAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CAE43784;
	Wed, 13 Aug 2025 18:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED5DC4CEEB;
	Wed, 13 Aug 2025 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755108221;
	bh=mxBe9IZW17EWG3soqFkqLWOPvQ9A5xBcmo8kGlCtxDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YgZqVbaPkJd4dniV6okJBx5xLrjRW6Nf9S1FYJbycm9dTQd1ycvHK6+kmO2rIKnIG
	 fL/p5pq3Aqc5QRf470boWhZV7uBym8vwGg4KotZ8tYK7BA56V3dwVxFU3sczONp9C7
	 jsP5GYyzrdiLfxfQeUQ9d7Svs68k26O0g8FdQowl8LaxiXSHhEfWnlI+D9dcFM2VLX
	 rdmTPJjyI+O30X9nNvHn/ysdaFa9eBaPwn94dLJNyBSiH0OOYv0Bd1l2NIJiwOZGob
	 NK8knKosCgCZcpHMwvHgVwqVqxAcOEEh2AXA2dIgSKnpBLGlL/4XfC+7/xWoV8as8e
	 zjgHNra0uuvMg==
Date: Wed, 13 Aug 2025 08:03:39 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <aJzTeyRTu_sfm-9R@slm.duckdns.org>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97F411A0016
X-Rspamd-Server: rspam06
X-Stat-Signature: ymp9g17hw5xbxrk9fbfyr9b1t8e6ofnf
X-HE-Tag: 1755108222-972827
X-HE-Meta: U2FsdGVkX1/u8VLKOcjBxxfsvI6q9SsMjpcZkCNptvWqIKA64m2x+tGISWSQ0KnC5J14LJpAQ4FVReta/FCW4h5MQaAh2MnWx1dA0f/O5DzqKA/BIwuMV7VZjen+lwLxVd0Pdcb9UG9MdFNz3mAsHp0bRZ6Ts30E4JgQEZ1DIUNkMpxO5e7hpZjmrWyXjFcXPlRCtvSHI59o/t1F8BxQlcOy5vyD58rzfjNtgY8RsMaEdXWtJorRdtQnyisNAUPF0RDnuj2iP/0SNuOI7FwEfMNmSmqHsmy03DwlPDykMjMMlG62ItnfJIqOX7evoMNkNFynzgHXYW1y3jaE/+tjCrh24vva4zQTHHnIvZaNPLatRmMBMa3TvCPR2n6cC5SoHZq0iossuFSYCPaJS2keQHsDmEx8XUTO5JYx5+NJIt3UMQTfOJyBjchD5BGEIys1EGrvl0fsvGgU1egHx0N1A+yZjxKKQuOXo7QunZaj67txhMwGTnp9TRf0yXJVHgDmPa+SuNW/nK2wXwrNSg3nTr3vXqJy7TSqXopCVC3ONSBcKylpNLjQaIGwa+KHFLFkdQZstYYVlyWc+8mkDUb0SoR1DZZHTXz7/QGjZfZhyl9BA2YJDXmcypSj/2dkHfXOPo7jcS1BQbjI+GPSjO19AKmAUzbIuZfgyhUGZDpu5qbSjU5wpsqtPnzbZyrAZFBr6z3LjbOfaL3imayvwcZo0jJ+RHiTluPAPe0sU6NtfGbL7uWzOO28NVm7ACmG6hZOOTu6y/Iq33prK32FU4UuYb8Vio14xzwWKz1CxVHi3uG5geE4+ptwU4OcMpOKHYHrVkJTZ10EDT6iETvhwOTzZaMuR7vpe1mhVHbLJtAbuAwqKYigR3aJz78mSYbWa5f4ym4taorMVVC8yKw8YvfNrpQ8qOEzFmWO/ErzScAMG0CtCbx54CLDRvWmu9PVsL4oKAX6Qubbj3yVHKLpunW
 FY05lmAI
 iZEWkML35gCw43MxZ7VffRKXh6YaiErk5rXE+SrtN+VbivNKi3nmH3OFjRDbBWeqAi6Q/p1SJtr1ckV9HUsOGTs/WG9AFrtt1DNVC3/cEKZ2VnZIhNr2gQBjDvPt1RDJB0GHupFoQBg+A0DihuQSQvyYtrOU4hZkfEj6jduDU+WzOmh61MidHQPOuogWPtiPQmjb2mezoacToF+H+7+ePtRWA+mQJHhmSo6J2E/EeVelfqr4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Aug 13, 2025 at 02:03:28PM +0200, Michal Koutný wrote:
...
> One more point to clarify -- should the value include throttling from
> ancestors or not. (I think both are fine but) this semantic should also
> be described in the docs. I.e. current proposal is
> 	value = sum_children + self
> and if you're see that C's value is 0, it doesn't mean its sockets
> weren't subject of throttling. It just means you need to check also
> values in C ancestors. Does that work?

I was more thinking that it would account for all throttled durations, but
it's true that we only count locally originating events for e.g.
memory.events::low or pids.events::max. Hmm... I'm unsure. So, for events, I
think local sources make sense as it's tracking what limits are triggering
where. However, I'm not sure that translates well to throttle duration which
is closer to pressure metrics than event counters. We don't distinguish the
sources of contention when presenting pressure metrics after all.

Thanks.

-- 
tejun

