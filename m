Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B79CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CBB6B00A2; Wed, 20 May 2026 10:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F41C6B00A4; Wed, 20 May 2026 10:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A1B6B00A5; Wed, 20 May 2026 10:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E686B00A2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:47:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0C358CF3B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:47:40 +0000 (UTC)
X-FDA: 84788077080.19.87E5F58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1331818000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:47:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeB8Rmgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2RCHoSb5AXLNUZZbMLGGEDeZ4b7SlXf1yZ924yOPQ8=;
	b=ORtG4Fk0xYiRACgfOPt0XUAMDnWfcYtP9AH/p/0EmKNBvyf9EnRPGnEft7VzT42rAP9aBc
	Krg2ZRHrWKSEOM2DlRHN6ktFh/7GDaaajMIx3VwaMMJZquEat9703gYnuz4gq5MDohII1u
	gMNfABD/gsruxNK3HW98HVJriAlHwSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288459; a=rsa-sha256;
	cv=none;
	b=NNjcND4s4FIo2T/3Of+0o6YmVZM2xR9OQeBeJ3sSTEOc4l0LsRsnjFCvuOjusxHjim/sBy
	8O7ZKRrfcXy8Wt5KUuLgoX4zYw7vKeSbDNbH2PFqlcWCAX7vEgMazMZlt447iOwjv8Pfxe
	fSzBrov+uY0y7axteU1A9B9shBXvBe0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeB8Rmgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D59643684;
	Wed, 20 May 2026 14:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FD31F000E9;
	Wed, 20 May 2026 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288457;
	bh=O2RCHoSb5AXLNUZZbMLGGEDeZ4b7SlXf1yZ924yOPQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MeB8RmgdeqXx0OiIdtL4BpvMTEFwxD54ehryvlqrGt8hWL+w8Vnguq355GGGVq126
	 lIBvOpdEC7DMJpEFFVUBZnqx5wU7g1T85j86mA+YweTWs5JmA0mDcQ2Krb4kInQDna
	 tI/OEb8eLhV6oVFlAg3fd8VsKpoCJ8uFldfzekI583E72sGfnKKA6FYn8S6BOopX8t
	 2vkBwrJSeBsd0F9+TcT7sUpC+ItW2+Am0bhewJtsRV+lQNKaxNoVMIQqwCmRf3A2oP
	 sZ+o3mi9KnTWeDYCCOODsIhCmPXD1f+IQ9FHrhwaGO54w1XdoP0F+tqpkA0ljKoMtu
	 T6dwMMki7gRPA==
Date: Wed, 20 May 2026 16:47:35 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Leonardo Bras <leobras.c@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush
 work
Message-ID: <ag3Jh-8iUdgKvw5y@localhost.localdomain>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-2-leobras.c@gmail.com>
 <20260520134832.WS7TrMnu@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520134832.WS7TrMnu@linutronix.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1331818000F
X-Rspamd-Server: rspam04
X-Stat-Signature: cfp8jas3i6i5k57dqeke7wwrikb1jws1
X-HE-Tag: 1779288458-727442
X-HE-Meta: U2FsdGVkX18vn7fVxt40HiVDYf4gcT1Zi9BQYxGfUgIYuyQyxu0v1Cz9f3xzZmJFVty54FReHE+2Cbay74pjcZx9EyRWqVpNPaRus0yrw8tAxkFqMJsNvLUtWXY/DMlRQW+OGVjD8kOtssFxC3oYzPI1/1cuYHp3RVs6u6dGqM1l9198JFR1mv0okpGdlTZju40ZMLhQffWCF0SadeKwuKrNqEVRbMChhh6rWbDUv0CXu0BTkVWkoqPXtN7OD7D2a7kft2cx+11eX4dFTSO4SrK/xCW5UYCAb3u4u/HuHotJv4ajmQ3QHiaFILlwxMjCDJiVc0yWOTiLadke1jzpv6hG4u42fLjIuOZo405exBhkOiizmTfaasZLQPDisIyKHVTGWQYatkrc75nTZF6dYpk3RdvAkxZafyOOchBNk3rrijMPlLwvqNSqIG+jTt5pE4RQB+AxVx8sbwFgSFjf1nChByrYKO6xvjW9lmhAHwk46zfnG7f3UhdkcJ2KbJqBtIH/W0fZyFL6GUuW4IZPy6KcYN67kZA5kX/hrp/+XDnxuzjWdlqj90i9vhjxBWQgAjHwo4pXV+kYJxO8WTlM+5w8WI94C0Kd2ncw4bp/SDHpDEKqgWvbiJlsHCJHNu5/PQqOIaC5fdC7j1Gpb4GSRyZ61lfW8whj+BD45a2BC63OjjpOKjMCCxbzYm/yB5IoDvVmqgR4gDenvSyD158GzDRrCZ7ol65NRJBOPtip8oIAyB0rVQm3WnN9EXCq8XvaldlPnIIID5CXpaCYEJ0PKDWlKjXcKW1z/wblYOGtOs8kDAblodU74CC3vYgmH6lN+H5ou8TY9oGsyjLmjWjLxTWf/Ngcd6vRZ8w3qNWVT+Ctz4hVJGxMOmLPMW/BvWCtaGNEEQ6rQMPdNKvFtDpYCiC4mXVwyjE5rxv7HJipRFvHVv4IYispH9ef3WKbRoGfELkMyS40Fp2laFEDUh8
 deJM+XXi
 bA2F5LwGsBbBXhdN8OrtsU+/yEusoX7EmsOoJpvhWMC6FWNtyEWc3GQHFaQfbSkUxRpCD4FW9W4lJ9VmPo7urw3TbQFW9lb0aveCYTP8IXAYJAHnTHobGg34yRcaqU1HdOEinbvXtmKvr8P1IO3WzbpVJM/KM6Bm0gBKmdYtjqaryxRqmE2W88NrWrFIO7sg6n3Gj+vPj59mSN8aWEFeEHMhutJVkj7jkijUGpD6BYZAMAEauTe8JOKTtizLaDp4DLqaKNxib2+T2zXYZQxm7XaSRvwqb04yn/BVq5JCHT8EybSLpuJmp55vawEHdN+XBq1EEJSJ0W0hp+EXRhbSyALDpfHFS4gJ1VkUy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, May 20, 2026 at 03:48:32PM +0200, Sebastian Andrzej Siewior a écrit :
> How likely is it, that you you had users before late_initcall()? Also
> can it happen that one of them uses one function to lock and the other
> unlock in this brief window? There is no check if this was used before
> static_branch usage.

Or let alone initialization on the wrong member of the union.

-- 
Frederic Weisbecker
SUSE Labs

