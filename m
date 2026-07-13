Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77316C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527326B0005; Mon, 13 Jul 2026 04:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D86A6B0088; Mon, 13 Jul 2026 04:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6E16B008A; Mon, 13 Jul 2026 04:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 192416B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:07:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9ACA1A0A94
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:07:29 +0000 (UTC)
X-FDA: 84983023818.06.483AF7A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1276318000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:07:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=qsxJhDXK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1Ils9B7r;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783930048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q84cQF/9BVMsiNBoLtWw7XAwZ26UdZlfjYA2oOWNSc=;
	b=zvnwg8WYuhi9Nwi88X+l0R/M8WiEvcV1Lbt5Ln2DsTXTsU1xj5qQG2P2UUzjqsY94NXN1X
	uoBiIKE+S2DGDTWqNm0B7Pufh2FL724SKbXVo6VNaHKSvjTfHCI+hRxwKHK6iUS/jdY/JH
	G5ZMMVXuS4Rml+DWF1POrC2XL8gEJao=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=qsxJhDXK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1Ils9B7r;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783930048;
	b=4KTZOW+NEJE+9k7gak6M8kkgzmc7J8XEaxd+VWfXC8zI05nlqVTQ3PS9FycLyOeDN9Mq1g
	cecHxv23uouoM5CP8GjF/ML8KZnJaPSetoK7Z9dKItwRuhlKzTSGGAm66WRHCcBg/3KtpM
	DLfww41Wh/7QY4/2bYyW4G7ta/6sjic=
Date: Mon, 13 Jul 2026 10:07:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783930046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Q84cQF/9BVMsiNBoLtWw7XAwZ26UdZlfjYA2oOWNSc=;
	b=qsxJhDXKQ4hpymg/q+SxwgwbmubBtDpjqi0c2KuDavullwomp1Cy7Ytcpwn+N7UAvuZun8
	3VVx1YCRaBvQ4mSUfKB5jAzS7/E2hJhZGyOL7F6mBE2IeIyDGKELvfdbabJn49jqSEOBDR
	erZut1M4VC3zO2jeI9OsX9EurX2Ri51l5PtcepAqvUJG5IY6DvyvZ40lZBQAcuEHvmtzAq
	gyR44JwB2PWdX7bWdYD8KOTPplfZZpuRZXXGQlT4IP9gnuOk26RdhhqtjeYlu7ansQLY01
	senVn+OVhcfNe/lSupAp/rgE7UX937RSsa7nWQTn92v0Y312JDrVSaX5xJOOxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783930046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Q84cQF/9BVMsiNBoLtWw7XAwZ26UdZlfjYA2oOWNSc=;
	b=1Ils9B7rKdgiHAW0BuuWKJgHBjbLhi0i/wv+n2YJ575Xl79HCES+SvSQw82t3EI60Pn84l
	SbZHVtB0fgwG37Aw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Masahiro Yamada <masahiroy@kernel.org>, Coiby Xu <coxu@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4 0/4] Introduce Per-CPU Work helpers (was QPW)
Message-ID: <20260713080723.XOTiibfG@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260520130903.Ebsd4aUa@linutronix.de>
 <alP58SgTc2_8OFPc@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alP58SgTc2_8OFPc@WindFlash>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1276318000A
X-Stat-Signature: zooyhh3shr8fnmajt8qbnwgpn178m3sc
X-Rspam-User: 
X-HE-Tag: 1783930047-829601
X-HE-Meta: U2FsdGVkX18V+oXovAYEdQUCNmiZezIKtGyXl7Le9LBuQfWUN/eMP2ms58cRH0dNwT4hMjRJzfwH2cy8HtRGbe2EB0N84AcmmciccaMhlRyZ00edAKKN3+EBjbKcCTz2/MAxYZ9GEpT+9dXVCr7EeZNMbzweWdVPYmSsvY0txDa9tU7U3D3Jo4UT2/dZHiJCzH/zlVUa9NpCzfDsM5nZADGERlaqWig49T2In4TXDNftLZzJhQ320HY5ZR7+6N6neW/8k4lBwqwRW4Q7ySsfwr9i+EIOabKXU0TU8FUJ6JjB57XTSd8bJf9vnv5HV8U4g4Z3d/Rzhrp+yqx3eIHb4jAlcUXRGIR/u9GPrNr8wuKw0+Pn3W4pl9tKuFCiwLYA/XL+so45LtqBn5CYZ1c+tpMuEUyOqWUq8eTacP3Ys/sfQtSNEJtntHSO58e0zkLXIvShOQnppJjgnEhG+vTlViOoysct+92jOO8L7vJSXe0N8t4MQX0q/+f/BR/UEbzJvk7g1C9aa8kPddCcV+zXaNe6nnxQWHUK3VmYeLNPVBT5Uwif98aMU8wYgVySoMyWAGDGWtgHL27LCZg8628Vw7A1SlKDSyhspUxeoBa0RU9GUnu9evekx0kGaYnCcV3x+rjCU/34PzlY19llTr6R6tUHCHgtf+WlyulgZioRIPN4CsycTOXnejieD6nI9/CFrYKXpHJw8dGKax9qh1IbghqDyOkZG6N+EI7ZE95Z18TpoKg6g7WvypHt/vGjtR8PQ68qC9h7QXwp7Ui1FTQoVuEAY4MARlBC/rLLTnmLB0fjTDJ9w1DDD7LsWqtFeCR+LYE6ofBivbBJEDex88DAvqPMUlEmh1c++NrAQH1Q4HJPn6kuGmZCPorA/QACTZYedWkBfVKn2oJPzMP0jpAkLCzU4x4d4q24+lmMNy1DWdKj3TO4foFWUvl4WUqMvf7Mt7iy4nuRy5NVna0cuXq
 d/Na3M0e
 gNxAZT0KfTv8DQk3liENmTy4Q8TKSvLVL/xs6rEokvI+V7PlOqppoi6gIHC23EVKat7fada/pzCiB24MmRLV6oQm26q76SHE6FhIqTa4jWuv3YhO2fRzFSEH5x1H3NkdNOEEGEhPm2g37VDS5NBfN7aBSZkWgYf43zbuzX40uP5QaUu6QFghVyiSmBk+0P7gqg97ucaUeFhY83tQgjOOg0jSNxpnkB/9Wq9HqTq8JUn4qQxPAvORTbRlyaRwDlbr3XXKvy30fjKUN27g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-12 17:32:49 [-0300], Leonardo Bras wrote:
> > > The idea:
> > > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> 
> Hi Sebastian, thank you for reviewing!
> (Sorry for the delay)
> 
> > It does not become a _spin_lock because it does not spin. It sleeps.
> 
> Right, it's a per-cpu mutex. 
> My point is that it's a full lock, and we could use it instead of doing the 
> whole scheduling thing, since we are already paying the 'atomic overhead' 
> to get the lock here.

The whole lock is a spinlock_t. There is also raw_spinlock_t and
bit_spin_lock(). All three are considered spinlocks.

> > > In this case, instead of scheduling work on a remote cpu, it should
> > > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > > work locally. That major cost, which is un/locking in every local function,
> > > already happens in PREEMPT_RT.
> > 
> > We did have this before but only in the RT tree. It was a bit messy from
> > the naming because it started with local_ but then it was a remote CPU.
> 
> Had the same naming issue here. This idea was initially a expansion to 
> local_lock() mechanism, about the same way you were planning in the past.
> 
> > The main issue was the different code path which led to a few deadlocks
> > back then.
> > By the time local_lock_t went upstream, the cross-CPU locking was
> > removed. As far as I remember, the cross-CPU user which did schedule
> > work on a remote CPU and annoyed NOHZ folks were replaced.
> 
> I understand this could be a big issue if used in a generic way.
> 
> What I am proposing here a mechanism that standardizes those 
> local_lock()+IPI strategies based on how they are done today, so we are 
> only explected to get 'remote-cpu' pwlocks in the 'IPI replacement' 
> operations.
> 
> The idea is pwlock_local* in every local function, and pwlock*(,cpu) in 
> operations that can be remote. 
> 
> Maybe being used in a more constrained way, it has less chance of being an 
> issue. Also, the whole idea is to improve CPU isolation numbers by 
> reducing IPIs, so maybe NOHZ people will be happier with that :)

I get that part. The local_lock_t part is cheap on !RT and becomes a
full lock on RT. While the lock details change the overall expectation
remain the same. With this change it is possible to acquire the lock
cross-CPU but this depends on the config/ setup. This might not be easy
in terms of testing and maintenance.
The more potential users you have, the better it might become in terms
of a selling argument. If you have just (say) two users it might be
simpler to address just those.

> Thanks again!
> Leo

Sebastian

