Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F5AC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31226B0098; Tue, 15 Sep 2026 02:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E29E6B0099; Tue, 15 Sep 2026 02:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D04D6B009B; Tue, 15 Sep 2026 02:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67A8F6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:14:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA2CDC0348
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:14:23 +0000 (UTC)
X-FDA: 85214982006.30.3AEDC69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14731A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:14:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cwwjt4nJ;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xezU87Zq2Y1vT/o2bvpMtCWCufr1oupAxWYAhAbPVE=;
	b=KF/ufVjQUeQMywMkjrsNej3o3iv5EPNuf2g0xEtTliTv6fpngaFPIR0Hvrc8Yea6HV09M3
	HdHhgWEcji9qpbtLUOACHlQKQq1ZAgNeRrcy7hLiGUq11KSC+4y9noVQXN4/wJQFzu0B3B
	nYaZBdfrNTk4cZMwQ1DhBqzFMdlUj50=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cwwjt4nJ;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452862;
	b=yKzQzEf1hmEPYIjkKquFFZ6vIQXyZVHQQEO+AG6QbFhOYR+gGHBXC03q4xofY0YpXMLcIp
	96CepXOkSIiMR0ByZZiqi5+McmVElGDMY2Mik1seQr+hul3jvpA36Hrft9UyH8JHqeIjYC
	hkJsxbqOgCJ/ibw6YUPpzw/cSIfb1R0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A6A8600D1;
	Tue, 15 Sep 2026 06:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3910C1F000FF;
	Tue, 15 Sep 2026 06:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789452861;
	bh=/xezU87Zq2Y1vT/o2bvpMtCWCufr1oupAxWYAhAbPVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Cwwjt4nJYsaMpOAFBS96BKI8N+2+sK8qyZMEoJg8kDgjYtNT2BKKpZlwOV4sgpN7S
	 855KBpJ5y+VTkRCRPDpDh2agL14R3mMuAGVEDtM5DfVAxwgvZ+edoZhOW3rum1Pzlo
	 n7aEuG9bgOKttiqPyGo3uJh5NElBpjAtfEeOQXnI=
Date: Mon, 14 Sep 2026 23:14:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Matthew Wilcox <willy@infradead.org>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will
 Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, Neeraj
 Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, Uladzislau
 Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, Onur
 =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, Kees Cook <kees@kernel.org>,
 Joel Granados <joel.granados@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
 <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Mike
 Rapoport <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Eugenio =?ISO-8859-1?Q?P=E9rez?=
 <eperezma@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Bill
 Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 virtualization@lists.linux.dev, linux-rt-devel@lists.linux.dev,
 llvm@lists.linux.dev, Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 00/17] Treewide: enforce static storage for object
 initializers
Message-Id: <20260914231418.b15ec01f7225cf460f6e515a@linux-foundation.org>
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14731A0007
X-Stat-Signature: 5tsjn7s3b18s67cyhf1ptzo1rex6w91f
X-Rspam-User: 
X-HE-Tag: 1789452861-212697
X-HE-Meta: U2FsdGVkX1+Jdopg9UHrPZUhl8lWVi1zgYdxS5LjpVICNhkXf5WhuBqR/OKOIArV5o+Gg6dmLfBdkd122tJxp5a40x2rvNNNVuVYwjHA8aUoLvClHMEe0fveC9hB6BlAh+QCmQkeMWYZvS3F+Gp150EzhSHjkjmpJMm5E2uQHDnjXojIP9ruj2NtdJ8+Qsdj4baPF5ITj4rmm7XR+O9HW1GTb1DSFAr8mMXOA0GbXFDGybgj4LrXYgM4cEzIKBcdfWDlL6c8TwBAlHKuQeesW8/NkfeLiNk3aQAnlVI0LkhL0yBifZYkbli+1uX2Yx7xcQFDf/gTFNzFgB1KOPsWEXEEpl/l0h0hkLjFNo9WBT+WsXPh+yQ5Z4kMS7GHRweRdamP/TKmqxYCgkeFcu2hUfYRM8u7PtCaqlzcP3Z89kCDuwb6alOwQ4X4/kJOE6jKCR7nCcxAdLmzQNkOd6rmweQynTqDtcK9gRpzjkgoihaKO8RsQJrNokYYz5L2yAMFE7dsZ2rMPkXjGtNAccA2Hw6Y5jipeC1XIBSVeXLhQ9DDLf68JeTvzxq/imQmoHsDWmPkHtX219qIa3CaaJyxCamtF3GYJKa54CHeJqCZyr6Noc5QCRXhAyWlA85+PDNreBzW2OB0FJ78PFqFx7ingNBHm/Ou76+mciaVr8eNvJqQi9KCfb3jxxYqTWpWyHwAdE3m38otGXxGk4oAY6QYaZvlT8CqkHkmAGsMoUMCIKA1O/2X+UNSisSfHnG8Ri3kA8OVUiY6M2wBHPhl6BV9aYKL9xqrwxsyUTa46rzwF3NNP2Jt18SPfJ0nDOw8Lm6SUaGlLjv5rHxd44pdswx6deaLgwN8sbApUPTMpzthLpvYlbSZ9iacgJUaOZO2jfMZgb4WVfVWis6ZbcUZDlCSQxAnLU1gUp3xBh9xomanmj9HH2w/dJHWpSOM1pUcWn1nyvaoKpLwI7XgUFjxWlS
 2iEoqT76
 hRGtV6JKXQFnGzw/ar4x1ITDD3Zx1cM4ctM6PzMJpvGu+9P+0lNbPISEjdun30PVLwLTOQXgH5Cr6vpQGafhSvFUc7BQQnX6FoNIi6JMDJ3aTWhEjrMRN67FD0cxf8NYEFdpflyP9RR0eALA8xKOgecE3pkfirkiJxlLkrqV6WlJNY6eeSLyi1BeRYPTvpBiTbRvdzMNUoWZyFxagyVl1EQIUNr6MmeZPw05wlR74Di0Pqdcv4Xabi8nf78+Kcl9U5HRYpBPKmd7iHlum8oYlcTWwKgJLoh+MA9CoRuIbLoYhsxfnvLqEOnczMZuhWLf/PjyMQo2y2zdTq5X921QdXPRK3EiHKwr62VzmOVIconqPu8glj/pD79+kq2+AS4AWMcaF8zZil7ymo6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 23:03:18 -0400 Yury Norov <ynorov@nvidia.com> wrote:

> Declaration macros that statically initialize embedded locks require static
> storage when lockdep is enabled. Automatic objects must use runtime
> initialization so lockdep receives a persistent class key.
> 
> For automatic local objects, lockdep cannot use the lock address as a persistent
> class key and reports "INFO: trying to register non-static key" before disabling
> itself.

So why haven't we been buried in reports about this warning coming out?

