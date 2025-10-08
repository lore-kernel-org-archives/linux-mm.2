Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AFFCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 18:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921568E002D; Wed,  8 Oct 2025 14:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D22C8E0002; Wed,  8 Oct 2025 14:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816418E002D; Wed,  8 Oct 2025 14:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3AD8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:58:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D2F811ABA5
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:58:59 +0000 (UTC)
X-FDA: 83975859198.22.44BDBC0
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A7314000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:58:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bAWpZV9G;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759949937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn4CeiQ0r8D1fLDDSKVzE9nFg8D/XnQ/f/O/x7Mav0A=;
	b=tzyxwOvg7y5P0kn1nPNI115J5JY8mmp0ugEwMhb2AI1SCqLmrerNJfDW+YuZGg9RMVwA+d
	k1jVO6B+5kG626Aron0yGzFNNsVqCyCDbXUT3u0kXnLVTNVPf6aLQKerLqdTLkurbU6SfC
	hPMOcrZRrkMDdpOMVUAB9n0Su2O/W/U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bAWpZV9G;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759949937; a=rsa-sha256;
	cv=none;
	b=ZHGUtxS11hIKxMEsJlzxppx9jjmqVr9UB1t3WlGp7GVvjAYNBUY0ysfGBWodMxoA6xRT4C
	whpv5pwiwTssho879waVrnAZZsOTajWat4cTUIrfFie6KtFNbst4LHct2Lm/Cxk4kOWbcz
	7UzokJg8z6iqpn79e0IfdQeXcJgyBsA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759949934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vn4CeiQ0r8D1fLDDSKVzE9nFg8D/XnQ/f/O/x7Mav0A=;
	b=bAWpZV9GgcU6ICDKvxnFP/BX5aTzYHu83vlKFmn8sop/6mwxvNFV4Gbb57/60XhwrsHmN/
	nlXpscz7x1d1+uEhGdVcRQiOu698MexiqvJR21p2ou7uq7NLluZLTsb/GfbtevazchB6gS
	50+qEMBoZzXgBXA8fulFj+VYVWDOIHg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni
 <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,  Jonathan Corbet
 <corbet@lwn.net>,  Neal Cardwell <ncardwell@google.com>,  Kuniyuki
 Iwashima <kuniyu@google.com>,  David Ahern <dsahern@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Yosry Ahmed <yosry.ahmed@linux.dev>,
  linux-mm@kvack.org,  netdev@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  cgroups@vger.kernel.org,  Tejun Heo
 <tj@kernel.org>,  Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
  Matyas Hurtik
 <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
In-Reply-To: <20251007125056.115379-1-daniel.sedlak@cdn77.com> (Daniel
	Sedlak's message of "Tue, 7 Oct 2025 14:50:56 +0200")
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
Date: Wed, 08 Oct 2025 11:58:46 -0700
Message-ID: <87qzvdqkyh.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dwozcrarq66x3z8e1bc4ny4g3ozyp9qp
X-Rspamd-Queue-Id: 2A7314000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759949936-464990
X-HE-Meta: U2FsdGVkX18V5+UEythiB3Gx4P+Rjtui4UullBtdoxfJj3czSRDAbTb34TjHSENwavucNN/M8XhsmBUXPbkNEe3MEZNf6nRLKNLH3ye0bCNaZP09KjKQBp3dbrIaP4E+cWXl2Qx3+tbUL3s8gzZuQDzmpu2ZZVJSmTnHqPyJe2ktVsapfzDw9J3EtRiz+lJiJCehxrxQR8PsGgk6qOa6yNSWN1Wn+nyuCxq3pE41NO6Z5ucl77bQQzQ9rHIDCVcq6SzLlyJLldqYH4LGyzVJ0mz2LjZTlGKSiNxgp1FNsiJxUcqSynoq3/td3Q5OkjpjxHXRZ7e0XWJsJNK4hoJo2gcZ0BtexIL5U1mmwYpeyXRLp07LefJ8pwKGgL7rL7tVQpvD7u5wEMeuiMIBpybUDvMaI4FnfpXNESkv6+5P/IQvi3GoV28AvJC0b986nTmM4BVOjJnC/D1AsP0cWaPCoEkXpTmniuwBe8EyHjXKvaa5EseCRoJW6Z6KDHmiNCti9WqNMJKIxM9rvgNFhjp1Wl376TMdZjoHSdz63EM+0J4VT5kIHtYWBNtTWZ8YPVCCeNGSJiNhUa6BllNPTUBeS/avlLuyt5/r5PXz32k9LfuY7WpcAQHrPx631xY3mtOmGMT0293KBYr2WvOgFrbZAWg6UKmtTaIzZOGVGpNGTkJNTqQTKXDVaWdQ2ciSpi6yy76+Cl/A6FZv3rKCNajcD9s+JdfyQFpqKfyRLJ6eLckkSKZ8Wor1q2KFZjJUIoX/ccN3pZjmQcJDaqWCcUcRL97i2ppqE+hl3YfIIsch6pP9lP6KdEL8rC+edJKtxa6TOXDxopvqVNHsxhWsQo2nLk4OHbG1gzAmo93LigDBXN0jy3vy1hC8SAZGnI/h72LRCcoKYk9LiMLXi/5CPJ7nNNoxw8J7MnoGTtQB15JZRmMJIXfAWEjVullVT3C6x6sV9nH9CmDimjMDDEdtu4v
 FlbofibY
 RKQdsULJ6TW098ziUWVJ+N0nsrmuCF/Q+RLvBiwr4QI/V6ii6rVlQuKzFQCDkI+pfUBVQwebYHIymRQ+7mZdL/nTzCtj1y8fnJQXF7J2hlZmVvhNd+aU3KqCA7sGRywITIVAHRC956dDhFcJWjs6vHy7TyiErnaya5sfSGsPh5a1ExvsOMWPOyBLYRrlQxNVrtk0lg8f8iuC9zUrxOMV76wo1c8rDqAfMUYZ3rhyYgtcBmKjc49XLDvph076I+ZWiPeJKhJNTbI61XAxGxWBKwAft+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Sedlak <daniel.sedlak@cdn77.com> writes:

> This patch is a result of our long-standing debug sessions, where it all
> started as "networking is slow", and TCP network throughput suddenly
> dropped from tens of Gbps to few Mbps, and we could not see anything in
> the kernel log or netstat counters.
>
> Currently, we have two memory pressure counters for TCP sockets [1],
> which we manipulate only when the memory pressure is signalled through
> the proto struct [2]. However, the memory pressure can also be signaled
> through the cgroup memory subsystem, which we do not reflect in the
> netstat counters. In the end, when the cgroup memory subsystem signals
> that it is under pressure, we silently reduce the advertised TCP window
> with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
> throughput reduction.
>
> Keep in mind that when the cgroup memory subsystem signals the socket
> memory pressure for a given cgroup, it affects all sockets used in that
> cgroup, including children cgroups.
>
> This patch exposes a new file for each cgroup in sysfs which is a
> read-only single value file showing how many microseconds this cgroup
> contributed to throttling the throughput of network sockets. The file is
> accessible in the following path.
>
>   /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec

Hi Daniel!

How this value is going to be used? In other words, do you need an
exact number or something like memory.events::net_throttled would be
enough for your case?

Thanks!

