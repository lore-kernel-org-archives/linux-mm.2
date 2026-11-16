Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9E3606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nw7HaeLI
Received: by kanga.kvack.org (Postfix)
	id DFFEC6B05B2; Mon, 16 Nov 2026 07:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63706B05B3; Mon, 16 Nov 2026 07:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29EA6B05BE; Mon, 16 Nov 2026 07:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EBA56B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:10:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AC531A090F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:10:37 +0000 (UTC)
X-FDA: 85440865314.11.BBA0466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 83ED21C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:10:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nw7HaeLI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794831035;
	b=parRGHD217emf7BCuBUGNvSFyh3vA84Pi5ZSU8ZBMVF779cWmkjuS5rdqh0+NGsgMIZZ7i
	8MrJuwzjKrDIX2LOJgtlySbXH1eGdaZ+XtvxyMNdiw7sEPa2sxFHVY0HoCiQvcj/HcNG5l
	9MCg+Gva/8q4u8JfOb/9T7190Q503Zw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nw7HaeLI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794831035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFCJbWYEuE16JjQX+YZE9UilBooBU6BB31fpYrmMkl4=;
	b=Ww0/7UGRwquFfzQex33o0Imusu+KCrZ4TD5C2zR6qxqB5DQE7adLg40rvleGVeoaCEW6R5
	kVcYc9ngT6l/BrHfxuXExkIEwjUgNKd5Xu/c0/C7Pn4alI5fqDFiCIYSvZZlDWPz1tsJjD
	ocwUm2xtO56cRyLiV9U6FpxSUJ4fE2I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9A5D42B80;
	Mon, 16 Nov 2026 12:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0707D1F000C4;
	Mon, 16 Nov 2026 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794831034;
	bh=JFCJbWYEuE16JjQX+YZE9UilBooBU6BB31fpYrmMkl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nw7HaeLIXmoL2o0UYw7Gqb9iEchqovHvLZrEf4u/wnYUHbLlPq7vQIqAC9AysUEw3
	 hfmsNcRCpo8w/jMPJ5FKfkKIQliWmKNLYFTCjbTmz7GZ91YH1csZ6HvTJnFwHzJjXC
	 qYQYVjFwPkZjp8/VXmJmlHBD3LVgloy1g/YChXgZnnqgMiGSsNFu2Wu61UFNjgSox3
	 isNFI+dWPd5OWM0U3J6M1v3Q0fjm1rWXoBKP74z+r1P3asre5VMBIjUA374F9aappH
	 eXuzZK91mILJ/cY1DPkWfdv4CqB5h28a9IY64Kr9vozC8IZ/MhrRH3pFkPQvy3PQBw
	 A8QG3LXTTRpJg==
Message-ID: <8b89bd7d-8de3-408f-8f27-c0e4918e48f9@kernel.org>
Date: Mon, 16 Nov 2026 13:10:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhang Peng <bruzzhang@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 83ED21C0006
X-Stat-Signature: ginpfgt9ascm53wceozs3w9oqq4q4ger
X-Rspam-User: 
X-HE-Tag: 1794831035-242279
X-HE-Meta: U2FsdGVkX1+5u9HEq7uCbY7XmoXbPYOhM8oT9hvyQu7tX0/Q1rs0XnHLqTvQJt9CtjVI2+Cd4VfXVSByPSYWIDTggNgII+9sOMhrsFbOPqaWyZbdXlaUASjzs26VENj3IAVV0JacvDTYtflwX+Jkn7+kHoeS6RA6Con9pX83v1NMoNoNSiyrEJZHXft6Q3oLKWII1BGO4MZ0jUCphcSImdgSxhdr/qdCY0jLit4HHFN+ocLaaeRUS5aJPpVJGriIcAsDBYWrI22VnIwzmMZ2GQYa3uPWODGMzrHfuzuuXk4OpLhwNVY8OUb0hz0MAWgzyQrO2GfRQdNXbl10dkwBZA86wEgDfO9XcA/0+sw/KeBworiBgitOHQUlMsRV8XRpXeoC0DwCUN7Y11dFTfJEA35+bpyStcn3K8He8I94UjQMPGK/VrQaAXQTxv59+YucsZY0aBQbay3NX+Fdd3Zwn/j3mMwFDe+g3Q/qjNUjufBpkjB8jOXlMOmr+qHrohMWGKcxfKmKe5JtV5Bhmc0vPyfuXCSnW7ySePEeK/NXwVW/9ovx16ynZnCpzG7ZxTauh4dTg/mnd+oESsXumgdQaGDQajjlt47MTIx1VoX2GMKh2c8Ire3DCpAgaHVgIptDKMxynC/FsxVxScacPHm4vSYEJZ0ipBw7C8Zx4dkCcZSPnBCSqEcHqTRDF/Dp4uAmS1GBw+5PRdgPXU7I7ii58c7sdpuEpaip0DZER49JlYtEAAMsrjmF8j4WsQhxYCdomrDsBBWUFQaval/k2CCbS3NxZ85v1vFmrTy8RYr4SdQQvKQLkjE6zf4tKjlxvSkxah3m8RgvL5C44yuwPmZRoVyRpMCCYqMLLkIGuYwKt39l2x5PSo+Ra+FOMf6Vi3pdLFCpI0xGBFvvHJjTjoRWsqr7B7KdvmeEa1G18chl3/P2G3yice/Y7o/EfQR9NNnejwMsmlMgyRFv9XTO+oX
 oyS2wa51
 LACr25mGjnzbXP5UdUE/ZqCGziJTKcJRGDb41R8cDHghAbOseIz3fdF9iiOPdpm9qNXynmFxfrWWt0hFg6roULRS9eL66GQtmJXL6yYUKIqkT1Yvrop5yKM/US9Dm2QjUYwHg6ijTTghrve2mYcHutMmn+6pX8TPiYfMXYBtZS4lAF2qnZuQmOjg2tRDsBWFa1Khd/pwF7XSVDLjr78hUfoEG1Wbrf8WPZZegj3FOic9Cz0oG/6+pkjwmXdrnOIqJxY+x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 11:35, Zhang Peng wrote:
> This series introduces batch TLB flushing optimization for dirty folios
> during memory reclaim, aiming to reduce IPI overhead on multi-core systems.
> 
> Background
> ----------
> Reclaim calls try_to_unmap_flush_dirty() before writing out each dirty
> folio. When writable TLB entries are pending, this triggers a flush.
> On systems that use IPIs for TLB shootdowns, frequent flushes can add
> significant overhead.
> 

I will send out a series soon that fixes various issues with current delayed TLB
flushing.

It's all such a mess.

There will be one issue that is harder to resolve, which will interact with your
changes.

I think something along the lines of your approach might come in handy to
resolve it. I'll CC you once I send it out and we can discuss there.

-- 
Cheers,

David

