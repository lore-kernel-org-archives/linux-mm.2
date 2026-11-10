Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8AA606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jir9xEzU
Received: by kanga.kvack.org (Postfix)
	id EF8E16B05B7; Tue, 10 Nov 2026 09:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED02E6B05B9; Tue, 10 Nov 2026 09:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6076B05BA; Tue, 10 Nov 2026 09:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B50EC6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:14:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B69F31608A5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:14:03 +0000 (UTC)
X-FDA: 85419403566.18.0A317A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCB8F80008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:14:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jir9xEzU;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ivmt603po3d3E2NVVoR2W5ORstU9Dg9rTKeWn3hg5so=;
	b=i1H7tgDsSfzjL6xe/yYxMEuAq6QfqaGcdhP3BA5WiKgpqUBEGGcTSUIt1DINYAxxmnGcpR
	UHhBtSW+FPsS58VgrO/U6/H3HqblEvwrzmVqJaXi3JbriFJ90BSNe8w1W9d8wgh0ZvY2dE
	PMcGpElTWfHLwgI04q8pPtfOWC8pw3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320042;
	b=z0TqpLLHOvw1XYp6fXgIsTf3yzqHKNUJRJWu4VyTXXi1uVDXsP5t3s80gsersMEJfrxEV/
	vHXJuo7bVrgXqM0kYnKJeFMVVmWdJ7KTiqgcVYnA7xl7zODga2StNhfX6QdzpkchZG/YBE
	53FYvHJiFLfewTCT/tlLCcCe7GBS5HA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jir9xEzU;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C9D6399D;
	Tue, 10 Nov 2026 14:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABAB1F008A2;
	Tue, 10 Nov 2026 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320041;
	bh=Ivmt603po3d3E2NVVoR2W5ORstU9Dg9rTKeWn3hg5so=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jir9xEzUa4uLP6tZoo+roz29YPgHORGT7V/V/D0xiwZU22ph1bKqdE78bL0dNUGNn
	 lFjpngEiey7fMGra+q9S1NVnzbVDfEa7ZX6SIR4ff+lX3FoZSGG3Puhw/Xfa6DNGRQ
	 LotPXVBtzyYJp6lYcrWSWcqKarHVtWVzf0rqc9qS3upIUt3nohdWAqM4PwxQc1V6SM
	 +19rn4gp0RTNUmTnPFVJwmO3t84ctQpVwvZKxojsQG2ocpZume8rk9otqAe2Ew5pgr
	 ZWh+i2qSW2Us59HlS0PjLklxdNYwS2RSwuT7xFbetacDE/MWvsUkxPw6o3gdc9TcPd
	 fPf9OqmV1ukyg==
Message-ID: <0a850ec1-d45d-463e-829a-e782290ef864@kernel.org>
Date: Tue, 10 Nov 2026 15:13:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/compaction: stop repeating failed async
 compaction on every THP fault
Content-Language: en-US
To: Qiliang Yuan <qiliang.yuan@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
 <20261110135824.3264904-1-qiliang.yuan@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261110135824.3264904-1-qiliang.yuan@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCB8F80008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: yfn4prdpwzekwtwth9ismqfr91gqqkyj
X-Rspam-User: 
X-HE-Tag: 1794320041-964861
X-HE-Meta: U2FsdGVkX18BCve58SoyfFFrJaifgRvLD4gN8Xl3sWUMnSFcsi+V3XdLbUWvTNoHv3yKmXzFDV/4N+K6tH/15UywhR9IaJvz5g+oKhpwgfD4L6Ipo1zuTFevzTP8wCR1akKw4ZVk3GzpEe4l4f01r1uYhol8hoFnR0UO/BuR8gEVWh8TuwMNXH4EmSnG7ly9XL5kQEsUXCqrl4EY4fUKDntdrW3/HHRAumFhbykdo8WDl5EdTGqkqDSX64TArXrhE4sCsKYqi53H1tu8YL5Dke5MCG8KTl+YgFT2s7t6VsERN4vcKd9aED7u/Piti8pf+mfrzP23CK5PidrZ5cAyvJJTGzxInyAj/YO8nzc68Vmo7tFRQl///BhPprWLtBsK7JqNY2mXgsSogJHxvduixc6gOmRsfYjzGJOdHQRp+pe912lNkzrn1jlUcQ2cmID2LJS1Wf+vSHbNbM5gM3XZth4jJc+Z/5bcvmZ2Xjoa+WAAvfiV3tl0avTnmCB4Or5y6UnBYbkU7rXM/gkbWbmnd3edJ+Bp5Wsoy+hNXEC/q5L/bU95YKK8EHxmzeWN0uJ1R1ce/FTUXC2fL0ul6M4eI5aI1Zs4rRQZQGCSWglY1kFtx0BXHDTvsmMApI00TYjkTpLgD/bmjrNK1YCItp7oJ13RHH2i44X80DpA5jQzXDYh5oDBbOr83QgtTkT3m4qiMkiVsGFYG5l2ADwpd40pKXzqobs2WYiHwFSWVWiPZKsbP/EhU6H+E1co7jtQT15bD1QBdPRzOBhCTU9/JD4TX17zCTbZYypxLWS751UmiJ7bAkIChol+Sl9bfm4kidR3yAla1Qs/P/XggEsN0kLJYPvuprBx04RDeXaEAC7t7HVopEk4tyg/5yOyhSVVW72Jldpx/+N/11cJx/KbZa9h7sS6IdzteFIlgZc4OAcucy3xg4lpqbeAXTMFCiQw5bz1ZqGL8CkLSEBef+tUsRM
 Mv1WlqDP
 mpR8fNxaGfIpG+G2Ia+U2Rir0KYgo4JjrVAOuBEKog7RBYuorXRwVhrQdKgVMD6JQNnRRu1j6I5Tc0qpZcZTLHreyRDjhZmq3F3vwAIQpbJNpMnV/WrnIcYZN+XafX+syJOsZRkDWsXj/5SOhNM+mVRW/NwLqpaB20UaqnteV7Q6/R3fwi2QDeNJ35oj1FA8a2vFIa1MHODeLyqcwkwmfDOFDsjrWeky1LvgxTIE3s/8EtPBBgQp7elkTfv+2mCTOyf7RMERRqPKm286fb/4EfSX/1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 14:58, Qiliang Yuan wrote:
> Hi Vlastimil, Johannes,
> 
> Could you share your view on this series when you have time?

The series was nacked twice by senior maintainers. Due to dealing with
urgent issues [1] we might perhaps find time later to see if it reports a
real issue, and in that case fix it ourselves. We have currently no time to
help those who need AI assistance to contribute instead of having own knowledge.

[1]
https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

> One known issue in v2: the cc->mode != MIGRATE_ASYNC check added to
> 2/2 blocks clearing stale skip hints once sync compaction is fully
> deferred, so local THP may not recover after the pins are released.
> I'd drop it in v3, but won't send one before hearing from you.
> 
> Thanks,
> Qiliang


