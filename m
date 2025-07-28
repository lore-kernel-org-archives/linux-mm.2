Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA36C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1286B008C; Mon, 28 Jul 2025 12:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B614E6B0092; Mon, 28 Jul 2025 12:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77446B0093; Mon, 28 Jul 2025 12:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96BFA6B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:07:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39B41C0341
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:07:45 +0000 (UTC)
X-FDA: 83714154090.09.D228E66
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 51EB1A0012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:07:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=zD9pPGbe;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753718863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAw+2X708It0VR8pZYVOK00HQXozxtPn6s8nfVW4nlE=;
	b=nVJAKuW1kXKgjjRxlQ6wKdk98WKNUAoiG6b2uw5jbekka9ougYZTnZdEMJAsFnVuSQ0vKd
	eFz+1zbAjGJBEzFenHZEE2rkXyEiVUzcmqoChv/Lv18OXH4TNd1ivMCf2Yy7foCAqLkmtv
	4xi/ohGfkcw3WhkERlTlRh05nBeZKo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753718863; a=rsa-sha256;
	cv=none;
	b=FvL1eiXwbsLn/NjlZMTU4rBboQX95acW4teK6NgylzX1UVBhw05dXq9eo/sGw+foVUkBV8
	R9ymx1DXUmbi9zCS9nRFOWYxB9ocSJGw/BodyTK2dYAxo5BNorVUhR+o4jsI8wAQvAi9TY
	C5OYYByd3UXWzGf5fAoSiLcfd1wLlUY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=zD9pPGbe;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7073075c767so33458356d6.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1753718862; x=1754323662; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAw+2X708It0VR8pZYVOK00HQXozxtPn6s8nfVW4nlE=;
        b=zD9pPGbeeaROs4dSkYxJLCYJSfju4ReEAkgM5CEjkyLM4BhukVHJ14nlZol8rzQT4F
         LTSpj5XKLC5OmVYaxtLbUF6TwT6c682vJ6jk/iJaTVTrNGrRxN44V7LJyOyIwkC7PC6A
         A5YzI79NQ97pacsXJ6olgeDYYoUoC7KIk+uKPYYb0yi9fYJ7ZwYmfTpLVw7OiJinVpV8
         g0lg2gJ3o7sKNXW9XppdII1f76mCoa+CO8pJRdB+xj4E0bLJcmeVxr4TGdSay2F5ZExg
         KDRG+zkNgTNfxOmZTRQONlA2ZzZGbDhbFPwPacReJ3JAaGHY4WROPTVvevyuYHYKGr+v
         Xy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753718862; x=1754323662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAw+2X708It0VR8pZYVOK00HQXozxtPn6s8nfVW4nlE=;
        b=T5/1LZciHRo0xVwQr7BzHXjS05cwGi7KSj5b5IgFsGX6Bag/u7gWBqHI3V2i4Ox69M
         3DXdYLUAqHg8HMRiMiIcF8cR94YCsz9TN94KRab7ESqbL737cX8nUTsG/iGfoeCJvGWz
         dlkb0WwT8V9r7SsY+kod0jBeusU0JD1juUASQSQzAkXd5gljywi8ZdZpUCZLxkNM28nA
         VMApaF8UJs+kpy2Sq85svl8IslSg4p61o4o7gHdnP6os1Vzsf5kiWKmb8d/jzHm2fcZB
         XJYq6xGFKLcw2hnAKxSZOq1vbE+ce4K2Ij0lRZNe4jb0J6Tn7VMtUfZw7nBYQ2pWKnL2
         lKzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8AfFFmSVAn0HpxsB7c4cq+LtBYLFsczrg28JvgmuKdYiMjhtIWfGwoU15snZc1IpOZrDvBVNtJw==@kvack.org
X-Gm-Message-State: AOJu0YyWKwVbaP8xtlx4MD6yCFgCZqM5YArGPRdSjYc+RbkEMuHp+lkh
	fZC/dMlOCpZX2QfO6pxyTNB78qrUET8xV6bJnEtDS6EBRhV3geICZmg2VRAqso/B5MQ=
X-Gm-Gg: ASbGncs38iKtDJP4iINA24h76D0tu1tEqXyII6zNFHaSQqW3a3bd1cRzdPboP06wcD7
	ciY1n1leU2Y2q6BZrbN0Gs4HdVd2zD/BglTfNmTft+ts8JKMGZpul8vVFWhRl89TQQZOIQ+B7zA
	UKr4nPQlpRXhGD4ybRnmTALKy8gN1Ma9u7y9+w8603kWDl+0+5AK17C5ntFcO/KIJwATkChbfpl
	xVRAroZA2KbAapv6th0B2kiWVujydvn4APwMkOFLscTTCfnH3ReL7tLO4m4hAGvWcqb/eXCtMEs
	0IUsgVRONppp05DY3+FkuEfjJZMsoMb9YtoJu7yTqg5ghUo6OFxzdAm7WYoyaHiZw4gkF1dc8wd
	pL+oZ85GuJ+KEiRg63B/qWQ==
X-Google-Smtp-Source: AGHT+IEaDZooEETiaWkCw4px/kQlCCmeui047F+bWZwnIBB50xOtbajOnYToq+ch+2hvV2HYIRrO0A==
X-Received: by 2002:a05:6214:76d:b0:700:fe38:6bd8 with SMTP id 6a1803df08f44-70720534e2fmr187905276d6.19.1753718861920;
        Mon, 28 Jul 2025 09:07:41 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-70729a9657csm33250636d6.31.2025.07.28.09.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:07:41 -0700 (PDT)
Date: Mon, 28 Jul 2025 12:07:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <20250728160737.GE54289@cmpxchg.org>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721203624.3807041-14-kuniyu@google.com>
X-Rspamd-Queue-Id: 51EB1A0012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: yydpxxr138ntq9ap5mpsqx54sdqdno85
X-HE-Tag: 1753718863-774602
X-HE-Meta: U2FsdGVkX1/1tv627XGtmvElJExt7LJWRit4PkSnGwidcHeIaqkE+v5wpmG2ryOfNcW18nTDeYQtNtsAqRYadqvZJI5xmS9KcyoxxgE4PT5PV4Txq3GEq47n30XpojvKJvTiZuEW5lVgu3cjUJjIOer6W+gJ1oHDjQ6aZOWguej7OAASpcdf2vTIQqDuyaXEpnG0dq66Sl4LZOP+sOEaOR6GLgo7XDd1ysvb0slfXoyT03nxRIrEb0fmm9D3MZrvLXB9m0kLS6MWRfWBLlp2TIgGjOH8l99S/MCAUWwolBEWrR0QGIre2EbtY3vXKcXsAN49WI0KPrridvWjlSJDQrxTrctiR9CPXjiI97ulHpIj80Ert7X7Fc1+jBE+sYv8Cd5H1utG9HTR2P5rQjWHfifxCZL1zIERVBYLkX2mXvfo/y2YS0ywvA7PwolN6JzGB+Wurier/C/dI/fw6ppsR2qdFBSHi/B4fCnXxk7uf5iCymvxTB/BGLVqOo8H9/loKNEdj24FRHitc2sDc8oBYzh46tADZgxHGYO5tB/0dHwRjjyHdupFm/m8o4xiQ3+YGD8L89b33AOhBlse6eqekuaVtaOGP6fszSQuWl2Jy7fL6XcLAXfalyERj3R1UWgYPjjDbTyW3+012V7iv2DN5OyurA72MufV4jgMibjOuf26fouAR4XoYkigkgUDJy0ehrRPyckCIytZvwNnHCJazraGhhtuAElEV7+T4lW3Yar++oX7wsBQdTFihGRXwhhz3Sj2i+r+U9cqfW+iuX0ZdBjGjA7TwXmLtoyTyv//Q33rtsnb+ZLc0dhhz5BOSdDQMO9PIcSgJMhaSrLC2U5Ig5Ff9gQDyzlOnumdvnHnHCjp7qYnF1/8rCAWvAng6pmMH1e4YZBkFFPNQIzgGMMKmakha5iyoh0UTpz9sdaU1P5XRuXONgpO4a645IMKJZOjP5LaBsSf1NSi8A0V1r/
 RgH6cgl5
 Xy/n9TX/FIdiw7QaIXT7TggFcZTAgey8wqxBQHzCEzGr6++nyxJQG2CQaff3mheohhvpD/GAMASb2d99blw4sSouRpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> buffers and charge memory to per-protocol global counters pointed to by
> sk->sk_proto->memory_allocated.
> 
> When running under a non-root cgroup, this memory is also charged to the
> memcg as sock in memory.stat.
> 
> Even when memory usage is controlled by memcg, sockets using such protocols
> are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> 
> This makes it difficult to accurately estimate and configure appropriate
> global limits, especially in multi-tenant environments.
> 
> If all workloads were guaranteed to be controlled under memcg, the issue
> could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> 
> In reality, this assumption does not always hold, and a single workload
> that opts out of memcg can consume memory up to the global limit,
> becoming a noisy neighbour.

Yes, an uncontrolled cgroup can consume all of a shared resource and
thereby become a noisy neighbor. Why is network memory special?

I assume you have some other mechanisms for curbing things like
filesystem caches, anon memory, swap etc. of such otherwise
uncontrolled groups, and this just happens to be your missing piece.

But at this point, you're operating so far out of the cgroup resource
management model that I don't think it can be reasonably supported.

I hate to say this, but can't you carry this out of tree until the
transition is complete?

I just don't think it makes any sense to have this as a permanent
fixture in a general-purpose container management interface.

