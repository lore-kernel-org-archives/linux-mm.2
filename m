Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5EBED7B91
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7100F6B0095; Tue, 14 Apr 2026 05:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0B36B0096; Tue, 14 Apr 2026 05:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFFA6B0098; Tue, 14 Apr 2026 05:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A65A6B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:09:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AA11C153F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:09:01 +0000 (UTC)
X-FDA: 84656586882.21.F700694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 347AE180004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:08:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K78y+bsE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K78y+bsE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776157739; a=rsa-sha256;
	cv=none;
	b=wcrZmTMpO73467Nl2tAS6xvfmh4Iv/a+jHcthFZBJYR5+4VjAKxbV+eKfJeMerSYcMpEFN
	oAinoyV7gFL9KUYD59bt9TcN1pPcGp9e8y46ydjTphZ5eg76ojs80yWGg4MTT0y/3K+w+p
	0NluD/V69TCW/rsaK4pymz2lZQ0IYJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776157739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAHazjcZIBA97/hmg/ReAJQv37SvpmKIiwFyyLCaCas=;
	b=L5I/diBpatWJVDvHpNu5pq+Tyev4gWD333YAV8nA+KjLJgDZBl2XfZ0PDMfDkefqG0/m1d
	KZemSYO26xqK8kes/wA+VRW8niHCNWHei/taKIB/69e3hYrGqMmbPpnrBiTieDfN8i1Da9
	ckHbY+G8ps3Bszc7JD1CaSZS6WosNK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2159D43D03;
	Tue, 14 Apr 2026 09:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97E1C19425;
	Tue, 14 Apr 2026 09:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776157738;
	bh=kFQsu16PS4TcR1wUOaHYbRYwmtPBOrXiE6IJuMeHqPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K78y+bsEejqPqLUZedA/9YcP4jF/0uyvmYFjVq87EPfcHxxPa1atjtxiLyyUux2ea
	 Wmpxu95tdngd/MLfrfG8dy/Qr20vi3jJrMzcrfFRv2j6EqenpNrinnz3moZdpjClOS
	 TflWRTTdiLCSGvil7vnqVL5urdYN3+tKP9sd8rjokYDhFHlrG+f+HFdZ8ElkfBv7FS
	 /CE+6CKf4+RfazDh9TUhfud3SRtDgLMOuSqing/yDmtElQqrYi4qoEcMgqisGqPz3M
	 7BdfZsvvy7/ovurn6/HfHu0zAttA4UpA2zNFm/5CcPENC0IedrJCnBd4iswl1RFU7n
	 G4kPyaYfjoVSQ==
Message-ID: <6a667757-9105-4a75-afed-bed4cfd751d9@kernel.org>
Date: Tue, 14 Apr 2026 11:08:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/9] mm: page_alloc: propagate PageReported flag
 across buddy splits
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <a74ad3652d9bd68c78fbb5360fa7adfd0606689f.1776033771.git.mst@redhat.com>
 <b330143f-f3aa-4f4c-8467-d91102094e8d@kernel.org>
 <20260413163104-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413163104-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 347AE180004
X-Stat-Signature: pqe5n5onbn5e3jfcheftz91yuxwka8sz
X-Rspam-User: 
X-HE-Tag: 1776157738-339968
X-HE-Meta: U2FsdGVkX19lXdw1nWfFecFmfCufvattFVpXNrr6O9Di1zBnQlHgmsHFoTBK8El677IR6co2YCMvoOCL1UvmL9CqEEQPsJYpIrkd8Q60J/cTU7sT6WrQy4iQCHTWJk6ENTTQGPX8HNiF/TbDgwZgtaZKIEgSXoT30bb/7vP2suzl8MBV+wb+0SX6ykT5Lci1kkLxDF7sKeudDWYk0sE/h87r6oW+0QCHHJtS59N2otFS/TdlDUB31xG7Oft0aAQw0pa5f22lm8Xpet5j/n8p4AQRYKLhSfSLMfj+iegABBrieLQE6I6XyIUeNtYoatvb/J8NVQkkPV3x5clMG2Bm1K2B+7rJyawI3vIb6oc9MuWyMYxq1p1v69BJtZmI8FrtuK3zHvXoRdsasFD9EJrL/g3M/zJAxNXogTMwHyQttyuFittl3AUc9AyABBDHKy+WhL8z7VO5twmUI1erCO1tn1qN451j12pv3tyB6XPg/5PjBHZzj/booaqarJEdylc2o9tZHjZdW78nQ45olvffd/O5hvewX3j2uVpu4GjuPH/3483Xz95ZRnEMLCELwLUF/+uMl/+xniGd1Duz6zG1VV4d2EGNeNVgY9vFZkGgQvl+HFnMD12OJqxN2Lrr3J6QuLE0gyLcBaYjVFtTLyNb3FS62rHvsh85IEND+45hDnPfq5TUMxNxaVZpzA2+OLK+lQI3uhl5HqZM4DBHloLDZPa4wRLkH+5giNbYrCpOnXYUjP0WCpBQb7XMvqj/ZZ0HXSCnCOE630eCSoLdR9Mxu4gFD5r24JGgkRTQNNWHf9awBo7sui00zhVy2o07vYZh16VhqPS2nzUt9Xx3pQwj4xp8BY7ebMDe071TclTlV50RBr9g3d97XhCKhaZIJXsWKrQNgpkfjGkevJJ5wdMScaA6MvBSjlnd2FYnVnE/VnmG/0jVZZiIj0/nD26zMONweKRb7FAVPAzDr1fqxp5
 z8YCCgjQ
 36z37kUnX0uKcpPr/FTJoItzFGGnx/QllXNwzyl1qvGMnCpB6AOI2BDKiY5cD8YCVmHWRFnWkU0KCi3a52yx1KZBnWkZv8LPq2uZ+pvW6dykUweB0GnqCisF46a7hTI3j1mjAvKidTPY6kDotZ9Vrntd8JiHiPAvM4F6zJoYGeJ3WNSaVNMgqLPKbEoSQI5Nchjp4xB1j3CBwddIH+eTGixvzla7Htwzme7EvOIbytIX2/lhzUWfy1rAVdKVATyqMVVqQ7/Gu8Qpw9o2ec6q7stx/QzMIpB115ZPPfM40nrLIx0Lmamg+5FApeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>
>> This raises a good question: how does buddy merging handle the reported
>> flag?
>>
>> -- 
>> Cheers,
>>
>> David
> 
> 
> IIUC it doesn't: reported pages are never merged, if a page is merged it has
> just entered buddy.

I guess it makes sense: if a page gets freed and we end up merging, the
freed page was not reported yet, so we have to report the whole block.

-- 
Cheers,

David

