Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0312C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CB98E0006; Tue, 22 Jul 2025 13:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6B58E0001; Tue, 22 Jul 2025 13:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC9B8E0006; Tue, 22 Jul 2025 13:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0F3B8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:50:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DBB31A04A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:50:27 +0000 (UTC)
X-FDA: 83692640094.29.C764BB5
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 479B8A0009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:50:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbKw8UtG;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753206626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BejSsJQ8x+zI2KklFDPj8jeqTPKOlVUKviuQVXmFaIA=;
	b=PK2XuimH6RcFEXrjl43ZuVo0iZ8ESnL1DIskWl2THZADUXLGx8HYCbipFD0WSjmNV9LgED
	YAwW2+9j4cUFizgmxfnpVphZurnLBTuOCCaE87UNMUoNiH5Kp/m8+54M6V1umyWCUhusE0
	mc/ulbWErL0JgQhBoJybWmzp8V+UupM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753206626; a=rsa-sha256;
	cv=none;
	b=x8IwhQmg0xFGEnXkczJG7DLNPswLamwmNg/aFkvbqofM12HFKDuznHpGqfmv/oUykDKUhg
	9PC1CfLrWkVUYsShhn4CvDkbegnIUo6ASXPKsCHmK/2jhVG6s8diCGClwwJwPIvIwWfzt9
	0c8a5fmL+/VmfQYn8NKCCk3P57eBLWc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbKw8UtG;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 22 Jul 2025 10:50:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753206621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BejSsJQ8x+zI2KklFDPj8jeqTPKOlVUKviuQVXmFaIA=;
	b=LbKw8UtGVkpfSVbu1HPJ2OV1yGOUz8uu6GThUzkY1s4fZuHyrzyqzDVejTk/L2eL8lLo9J
	Kw3UEo9hhRLyCb2kX/yf4T87yOJ1E6zwNzWlvb9VXJAooYPF4BAFgSzonbSHcauD3wpT1H
	KndbinfCJlxz3NNr9gStI+AERG+bddM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 479B8A0009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bfrdfh3jcy9ef8fjb1j781gopb6ofz67
X-HE-Tag: 1753206624-823060
X-HE-Meta: U2FsdGVkX1+3lg7Bn35hHGvns1MT8BV57VIfSIE8JhnLxvRHApx4PfURd0moaq7731YTTzbBmuRQ0SNoQBko0r9YVOLUwz0BUYZYPtmnZ74+Mq89nA9YRsOycj83cbb8d0+HNsL73dKknkf3SJnucgSJPw4mlVMDVU8DWnActJ5uYmtY87ICCbY9ub8Swv8qbuqol11AVdm4AQk+jBIrW7/CgvAZ0R4VPAlJE5kFt+GboZXrnh9sYLuvZNNl5RBly646MtUKSAGXM/FyM/czCcvHuM6MsF9RFlg1bqRVp9QB+/uCIwPbAevUvt0OhrmgzgZjwr3Qn6Tnheyww6X2YY22VEVd9k0/iX42LuJlaNB2H61hkUYFKlmdgu4f/jv7uvAUkcc/320Ut5HERpa0rM9zo6dPZDzw4F4D3bTWLMCHrP0TcxnxjAtaFn6UZaFgQEesm9/VFEj1bf3xTj+qLEGMDD/ZEXKM8gzZYeTSewnXX1JkQX+l7TljBhCInlnnMfaWlwfLQJFy3gRLwWm/dyAflOysqDlC/UV5wJ6uejnNQ305LToVS5IdS9ehoEG4f8a6Kg5WaADDIB0N+73/31Ct0HSftvrrB8HdXSbrBwxXAdcGXm/Dti+qzKdFGqNArVTPZYzNI3KBYm5Au9xkEMQFEcC6CGCdSPp7jmtymNeEC4q0AGQLX7e/4EjS56cUUGSQ99YMk27/FGDFnepv4IL7eqM3jFvviVFQQJa9bYz7xpAFDD1KG54SMWYrzeTc4LPLmzaeX/Xt8zVBYYYhW4w9h++h6Z19IYbNZkyiU0W9L0kjG43KbrCdC9LUCKlDw8oY/JqZrvdw4r2TZ12/g3jyJVfwJLvYAQwYu1voe5HpaVIM5vYzEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutný wrote:
> Hello Daniel.
> 
> On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
> >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > 
> > The output value is an integer matching the internal semantics of the
> > struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> > representing the end of the said socket memory pressure, and once the
> > clock is re-armed it is set to jiffies + HZ.
> 
> I don't find it ideal to expose this value in its raw form that is
> rather an implementation detail.
> 
> IIUC, the information is possibly valid only during one jiffy interval.
> How would be the userspace consuming this?
> 
> I'd consider exposing this as a cummulative counter in memory.stat for
> simplicity (or possibly cummulative time spent in the pressure
> condition).
> 
> Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
> thought it's kind of legacy.


Yes vmpressure is legacy and we should not expose raw underlying number
to the userspace. How about just 0 or 1 and use
mem_cgroup_under_socket_pressure() underlying? In future if we change
the underlying implementation, the output of this interface should be
consistent.

