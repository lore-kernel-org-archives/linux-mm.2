Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA370D6406A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 01:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C1A6B0005; Tue, 16 Dec 2025 20:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29946B0089; Tue, 16 Dec 2025 20:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27EA6B008A; Tue, 16 Dec 2025 20:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC6D46B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:04:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E676C0863
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:04:25 +0000 (UTC)
X-FDA: 84227167290.09.F6C96B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C9A41C0012
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:04:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZCQGuh9c;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765933463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQ6hBC0AK+z4m22/qZO+22sBRLwZSiEGZMw6lh5U9Ec=;
	b=QptfmCw3w2H/UZI7LWhfHw7s64vNFvF/ml84emPoPAEwSWHLtcwfRuHCq0/clDyVBypyaj
	3o8tqjZK8y6ITrHnXONxQlACJoEgywa7dF2wb7KT74rmWLuWqOymDbGzUfTlboPhW6JERR
	sTIW38n2Qu0nnM5+gkYHb8WKrnX/+80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765933463; a=rsa-sha256;
	cv=none;
	b=kLVUdcG2W5Pu9KdWBLtlka5AnNEgdm7xIIDGa58RztQYakX45f6VNjTvQYHKAIREbyhz93
	fpGwiHEzBvz64UAavxIBmP68rBouLj2SK9y2kSoeCH3RdTRrf01azDq1rn7jNa5sfM9kdZ
	X23iobdXGVPKRBlCNmW/EsKCo7CTrXI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZCQGuh9c;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51DBA40E25;
	Wed, 17 Dec 2025 01:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CCEC4CEF1;
	Wed, 17 Dec 2025 01:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765933462;
	bh=mMXmHQ7csVVs/pqngM3zcYY3/VLMqlnXZgjxMihN4jQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZCQGuh9c7Xu3acTV1Pfs2wZHylukIvLXKSjT76xZ9+QzUh2RlFczM2CUz6XLfGLbv
	 w+vzf3XOvh/lBf49Q1KR8PTFSKl3GBK/9QxEVstLa/QOKgN79rdLWGkiiFyOmclXk2
	 uS4lUWzddnrBxgbGqrBOAbI4n0vzGccERLhiSMOIanX3UzefgYznnqkFP3mQ8c7pCj
	 J2KEqaO/4p+dywxTISgfR4R+SqDvbFS8BDEIX62XBXgKlJM3jT+WACBZoy43Hosuta
	 1X14Y3MRX13PuNALqJxuz7vFQ/Q97ITROy9HgHzx34qxYWbOu3nDa9AASdlPU4xCft
	 0GvqCJ6S4820g==
Message-ID: <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
Date: Wed, 17 Dec 2025 02:04:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
To: Zi Yan <ziy@nvidia.com>, Bijan Tabatabai <bijan311@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shivankg@amd.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yf1ie7g5msccahxr646ijwcojm6ijhig
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C9A41C0012
X-Rspam-User: 
X-HE-Tag: 1765933463-368590
X-HE-Meta: U2FsdGVkX1919DiqwEQQN4OLvy9JvKIiR0vM7NxU4OgN5z5qH8GiQeLCBK6/JFbu11KzzCPGGFM4DU7PF2XIYlRt9TN/WXSyBOrayy5LUJI9Ds61fTrJMWBg5BpVCzMWmxZHB1T9r2UZIYuLFbqIUNYVkwCoU2kxaijHYNnC4VdKCzB5Njsx+09PgE3z7hLtvOtxOFHq7n5Zvhv+PMmQ5jcHulgFqW5tshPtwFsUJLGZoKlV5K/uU09Qk/Xt+tTNdFh1UjMqXxeHEdNML1NkuJYilie93lOhVW3xABf+Fwz6cmYJ482VVVOB0hLsK+ueanx9ezKYCikB0MDUuGpot4LCxcWDIPwBKSsGml/H8wyNqE3Uo8518J2Uy41RrjwfemGuaxWNid9CCy5X4N3JIAxtvuFhXIULFO0Z+nGcosNg8wnrrpUMVLCv0BaKkljUILK+5EEe+zXuErSk51lhvCWNxSGArqVvbIsHORuUwp0ESum6UjyigicbMQd8pDg5DT8PX8L4oKeXyvoCS/zGSehuqdE/N0MwxQwgiL4N3lKlwjK4cIVbKY1mvKYKQH50QeNtcmrKhi0v2OnYKLekYZsEe8JvKJMal9pAw3p0LgOughT0KN1uzqAgHhM6/gZcPiDYO2Sx4aEUJzm9r4cQJuS/ioL53cv16D4MMSZ/OCFdqeZa1mXGkdWqkuwatBoyMZOkU+TiHQJuuTBWFhwHsqgXCV5eUnwirnEcfjZho+kgoqpJu89pZwpkqJgJyj7nfIs9dCm5QM9agUdle7+ldWYZbLkJeYIfC5KyOmqLIYb/Erhz4wvS9/I1VlY7PM8oGBMP3EXS6SOGzhOMaDGI1XmJ0aZUUlpcWibxKJKf3wP+8s9AadTq5oosDlV0biPpDj35rO9a2q2IykXPO40H49mz0+uMEJytYnThs9FybUSLjvaq+1cSY48LJSM7IACZ54xgv4lRQ6t5rouM1UQ
 7UZuu2jm
 u4RBjgb7LE/F96BqZqK0FBmKw6K43fNNe14MOuQkCBfJ5s3uEzOuFYRLQYK5OStxzCpG8vbWauKaQBrC5jC8eV+UqBdZlXd0hK2QnI6859WWgsUKCmkY3Y0zN34XAnGk4r084c/6LxggMW1rZOh9JCoJD1ER2yGUi69EAzRWkQI6RoY3lJ6y9SSkjaATKfBYkclI679SHycLjZWK2x4D0ibquiACn8isp2G+NzETH0nxMNvdthr3/wIyTWWi68xPnnJELFzlaYhdbPdSeT2T3fbIVKP6ytHaiR58s18FfHRqpGLpJlaFAJANdaEg+YXGjApDj1eHChYEfSZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> I am not very familiar with the memory hot-(un)plug or swapping code, so
>>> I am not 100% certain if this patch actually solves the root of the
>>> problem. I believe the issue is from shmem folios, in which case I believe
>>> this patch is correct. However, I couldn't think of an easy way to confirm
>>> that the affected folios were from shmem. I guess it could be possible that
>>> the root cause could be from some bug where some anonymous pages do not
>>> return true to folio_test_anon(). I don't think that's the case, but
>>> figured the MM maintainers would have a better idea of what's going on.
> 
> I am not sure about if shmem in swapcache causes the issue, since
> the above setup does not involve shmem. +Baolin and Hugh for some insight.

We might just push out another unrelated shmem page to swap as we create 
memory pressure in the system I think.

> 
> But David also mentioned that in __read_swap_cache_async() there is a chance
> that anon folio in swapcache can have anon flag not set yet. +Chris and Kairui
> for more analysis.

Right, when we swapin an anon folio and did not map it into the page 
table yet. Likely we can trigger something similar when we proactively 
read a shmem page from swap into the swapcache.

So it's unclear "where" a swapcache page belongs to until we move it to 
its owner (anon / shmem), which is also why I cannot judge easily from

[   49.641309] migrating pfn b12f25 failed ret:7
[   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 
index:0x7f404d925 pfn:0xb12f25
[   49.641311] aops:swap_aops
[   49.641313] flags: 
0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
[   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 
0000000000000000
[   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 
0000000000000000
[   49.641315] page dumped because: migration failure

What exactly that was.

It was certainly an order-0 folio.

[...]

> 
> I agree with David. Acked-by: Zi Yan <ziy@nvidia.com>

Thanks for the fast review :)

-- 
Cheers

David

