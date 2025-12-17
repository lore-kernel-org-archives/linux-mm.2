Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD2ED65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524476B0005; Wed, 17 Dec 2025 17:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EED56B0089; Wed, 17 Dec 2025 17:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B6A6B008A; Wed, 17 Dec 2025 17:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3193A6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:34:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC1A51A0A89
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:34:52 +0000 (UTC)
X-FDA: 84230419224.22.0CC2F5D
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 023E2C0011
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:34:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qO2ZDsIX;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010891; a=rsa-sha256;
	cv=none;
	b=Wwh1fPUIzBK9GXP/bO9r3zTvtEx67VJfH2jttw9XDUf6yril1q2U7EHKe8eoy9JurWXeYe
	3GN3btYDTaQ4aVXZyLwNjKB1ijVcEtm4s7xNQmj2S3BbmnHBPo7WWpx/CFPZMhainm/3QN
	SZZBNXZLjHYN7jcSvGXBd6LAaE1eKqw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qO2ZDsIX;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvYaWzPPdrJtfkJUMIbw9W2hBZKRUblNNmvifflj8gA=;
	b=uCTLP86vHAIUKqRsZs0102F3vT6J/Rewn5IzJN4sEsTxhknOY2gBXle3BhitS1e2x/zkx+
	nwhNQMqlK0oNWfi5FfnW5zAoFtYNhytCHLCWEwm5sXNkTVVWabWBuXdwVQH72He7QACYz4
	67rDDsB+IuYe+rZpVUTRYrWZYqIPXPA=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8ba4197fbd4so2644285a.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010890; x=1766615690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvYaWzPPdrJtfkJUMIbw9W2hBZKRUblNNmvifflj8gA=;
        b=qO2ZDsIXr2YTIli5nlApFGD3eiGXQhIWJOQieCjRXdGoRkKLF6FTh1waLkZs+xcGdQ
         9+zMon2KT7WB1HFqDJwI5kFRZ56jFMCRPZ8ig2/olJmgT9YU91g0pCctp9tWLgAv9eMk
         Mlfzg8s0lcz5dNt81g8lO01MnbQaVJukE/13FW2ffeeNN44zsQ4a9gAtH1cgo2ZZCQxI
         GmOKDsT6H0GtYSFG5F2iDkr+kKJbeEuN4Qdvdmt+2jqzCQfQzzVJmazxzLBlLMCTbBsg
         GfD8Eb3AgOca5+/TEqPzajkrSRzPsCsoSkfx6yMnAq6lif77NHe07x84VCuxOquq7/uG
         kSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010890; x=1766615690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvYaWzPPdrJtfkJUMIbw9W2hBZKRUblNNmvifflj8gA=;
        b=DKkqSaEojrg+YUM7C91mbtrhudSalFsKHaEPIJ7xhDB1q+bKB9FNJqP0grgUDsvPNV
         /eaJmo4efN6i5pBiMjSDDHZYLU+ZMNkS1zOJEhFLENaZlOt7I0bo3avSmT2RAyodvdBj
         3+N+VL5Ep6fq9kBGhok7g6WT4rukUM23niin8qpTH2GUKeuFgY7a+Nup7oGU9mjYM1fn
         oKCZY562U/rGCpL9QwecGX6iHCaNphMQUsVWrbNhD1zvIC85PUPVid+WUM5nWgDQcAuD
         JnBj3+1hCCZsaRbLdk5oer4Mt91/mbSUpy6gCDWw9xr1x3Egf93arpqzM98nbhJ1EUFm
         cWLw==
X-Forwarded-Encrypted: i=1; AJvYcCXNG0IfFk2xJiBzIIzFafR0Jf4Dpxz7zno/kixvDnC6VnJa4S9Jd/2LC2HQIN3Gd0Qya2/lMXabVw==@kvack.org
X-Gm-Message-State: AOJu0YyfSiDElzydGxg2tVfSkLt3XoXdH8jKP7+Axy6S9t1oaoX3pyVj
	ynzf7IH9YJ3S24ViNo5VFPhrGORfuWPks2LbukvMTY5I2pW/pbKgAMqnBtcf6l0lgJU=
X-Gm-Gg: AY/fxX4n4+8MSl69CF+aan/3Dte4mE6QAcspmpnTwRHhQXPD31D26VDJJAu/p56a3DS
	tS6Tvrx4hvKg0gRzpRHyOE415v2/wEsPJLxJAqj9V5kJxNValWRAye0MG3osvOKb6LRQ2qhFmO/
	Gbx+3pHCb7qImX3ZECgSfZZc5oMXGZ/CT4WzkfpCcfqauMxPpCV4onAUigTRZnGmrHbMXQrA1Rr
	+7Icd9ayPkhf5wz7WMFg94wj3W7DO+C0PxHy9R2aB/ABYnfHH3RqZl2GS9RX391B6Cc/a8W0poF
	nrGYilkfkErR1cLtiPgNOxSwkLcDWdE1rLplN3OBCWHi1aM8CK0LNo/JuqPxzT2Zkv/8kvE2Xtl
	nH++hIvwZ71Qijw2WeoYhdjDBaoMgCSr35dZjpiV8DMqfhKQ0bpmu4RFJpo4C9Va++uDTxkjZeL
	KQlc09Ov9URg==
X-Google-Smtp-Source: AGHT+IGZsFVv6Cr36BxWCjVhDYrl4CGTwr9tOLKn/N9bxObB1v/vFjg3HVjrFrIuNreEatCVr4E83Q==
X-Received: by 2002:a05:620a:319f:b0:8b2:f145:7f28 with SMTP id af79cd13be357-8bb39dc4d2dmr2734359385a.33.1766010890047;
        Wed, 17 Dec 2025 14:34:50 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb5f2974sm39870385a.19.2025.12.17.14.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:34:49 -0800 (PST)
Date: Wed, 17 Dec 2025 17:34:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 21/28] mm: swap: prevent lruvec release in
 lru_gen_clear_refs()
Message-ID: <aUMwCOj5aDo5Jmxh@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <42682f81686e31019504a6e025fa08d2c9dea718.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42682f81686e31019504a6e025fa08d2c9dea718.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 023E2C0011
X-Stat-Signature: niyu5moijqrbrtrb84t77wcjqxpbqz74
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766010890-759867
X-HE-Meta: U2FsdGVkX18H/II4tIUL3xTx2PrXWGd4d8Iu9NUSdQlj5hnm8qVkuwiaqPxEd6txGhKRePr5TIfOwBb94LRKuj0gWW5WqkyiLQA7vvf0AgMumi4UrMNbNlLFMn2H40bS/G6L/rlr4bUle5l1VocUviaPLn47rclltiSukOiC0gg/SPYgLSQVulktO35wnqYjDv55l7HuIGpPAxSDc4/+K2AmYpOkNYJN1czrspsQ9tMZy/zN/WmlO9UJ2z9NXiVghe3+DuBRspTCfxShLfuhp0dqXGk3kh8MFo0S1hByZwEUFJRrWOAIWSFsgCaX65+UFUNKKAYfPU+SA5Z8g4vywtUjC/utOjmGyQkJeGsEk+YjB64S69e1GQaF4i2mlbbG45HVB9umXVq+wScVjEEJO7ZDW3yEVt35RYAMN31uKh40T6ZHsiSQQsLstKgADszRsbQA1xkh/7aXAvTqqlPrPZNEiCf9rfid6nNGK18PBw+3pISq+k+Hix+I197rAXWv9CaXyOxxoqP3coCTdU2JikYrSdoYBsrpt7VfjRfAW9b/k2gtYUJLJLN5Ffdu0FfUZUz4j/wThs8wMkWzMaAw/qwgi4bT6c0A1BO2oxMaiK7VmhbAI/LMnmGjQ9e+pdMdHWieH4PDjsNBDU3DP+HrgfWIpF81Oad4PwyIeiVpPeeBfRmbL01n3QpV7GsuLkCNV4qm5l44DAMAzrT16WTFkixHebEVAww+BTcPlr6AJzSGTV5MtxiuuZwDJ3FO1/m/b8gozRsUn6IyWWZ+8ERvE9MiR8HhWDDc5SUvgO6oLWSxKAqZ9wXmg+zxwVweNqry1ldjUsZQPNap8veNhGo7HSREa2oS+BVfdeqaGNz78iwL5txnboU7unNmt15t4Xv5jv3ofTLGk3fci73vmlnflIQJdXT8L3Boo72am2E92HgztQpyaqvsJAGtIIv9S0nTNZvt/2xSQIR12XX0elh
 SrK5zDKY
 YadqVi/cHH7sWDezaTUbMgNNkWmoVlp8YDVdFqWfdfYfOoDLwZ/CtBCDni2gqv3nTfo0clXnH4t7xHuKf1mAAlwUNPql/2mfRajYXUL7/n1YQ/MOPBrhZTtBmmShufdrGbdRaGoWJgHXlrXIvD4vbSne6iWJhkAkXD/VqpoDysFEdOCQNvQQ3Nx2q0kDgNW1CDp/Cg4WGO02yC+gftAji9kC6B2PiS35TjVILJDQz8uJvFzv4UjEHEmyyzWQVHp6683HyWsEa7iJa1UdW7rxGOD6vY7EkEohuHjlwni5QplIVORx65hgtKpR4nR2EV0cAcmYf9gcgX52NC/kqesLa6I/p597vKfLQk9j4HqYeAoBkTzwkLr9rP2gLzckScyZYEIbmDckZWStJuiMEBGahVCbq9J+psjioMYnIod9xo8A1L61nQeNuxFkEgRzIptkidl6tuYpslAGaxjKNfY75fQQJp4kViUPtMlexPXk0/JBvFk/oYU6nnuB7iy/zrEKRcTtCUU2ksryzqASTPWlZstyUvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:45PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in lru_gen_clear_refs().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

