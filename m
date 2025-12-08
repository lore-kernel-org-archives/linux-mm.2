Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C831BD3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381C96B0005; Mon,  8 Dec 2025 06:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3329F6B0007; Mon,  8 Dec 2025 06:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249716B0008; Mon,  8 Dec 2025 06:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14C406B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:24:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD25D13C033
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:24:54 +0000 (UTC)
X-FDA: 84196071708.21.60A8117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 06F791C001D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:24:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zk0C0EKY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765193093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZ0HaHSzQtxEzxOLopQcltU/hqK4swFGEhC8NvAPK+s=;
	b=GN1ohkeBOLgPq1hNTXahm3W2hjeIZBRoMncC/9o4udosgpBdaA3ftseoEoqE5iYABzcNFk
	rW2RKUqpdhl6bJ8vP6eCWZVlN4GL3xt1aDKZUMjD93aMm0yIJ13qieq5ApJW3Ma21InobW
	tYg7eFnB+hMbSgz5i65gIehNTk2ch1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765193093; a=rsa-sha256;
	cv=none;
	b=5+p6k6QBE/bfBDqhcrmjUiZl7UsjRfBzRcaTn/KaB+7LE9GYFJvya5OX6BfeC21tXAimv2
	SbrTZPAtxyT+D6E1Qdp1ToULo0dsDmHvhD+e7VVNMkLZ45Wvt519ubRyLH357Z1R+j0ZbI
	OtIqGq95n7RlNmK//SY7wmhCsDtzWpc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zk0C0EKY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE727437FB;
	Mon,  8 Dec 2025 11:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2753BC4CEF1;
	Mon,  8 Dec 2025 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765193091;
	bh=fC/24Oc3hf4PxmCbW821UhQo/NgsLPZaEn7uaZClSa8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zk0C0EKYfYOApC+Dr//4eGf69mnRDReQefVGpqs8iACGOs2ex0hcMYsQ0iIM+RQLo
	 087o3F+wVYAZkzbhlnTb3Rvs05O2Vn430vXpJjfLeyLwbpvD8n1wWXyuhJOr8OvK6R
	 2ARaOW6Qi4mCxXTciDGPgtg8n1AG0Moh3vqNEOJFOhTD+47L3oPH4ys1ahbLIXaWpg
	 m0+1j6QhN+uMiVL7hNGcGEfBYMBdeDIqZQiTjHSbey3C+dqrwl4d8Bv7y8QjB8Ta7W
	 jaHPPSh6B++lk1nDEsYPQgYDRio6E6MkZoaE+hXh1yyvLR4msAY+EmqkVS8ZKemsMO
	 k75/bKb2p3azQ==
Message-ID: <bc25b607-f99d-4878-abb7-cff5de13fc2c@kernel.org>
Date: Mon, 8 Dec 2025 12:24:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/workingset: fix crash from corrupted shadow entries in
 lru_gen
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+e008db2ac01e282550ee@syzkaller.appspot.com,
 Yu Zhao <yuzhao@google.com>
References: <20251208060046.2933866-1-kartikey406@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251208060046.2933866-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06F791C001D
X-Stat-Signature: zck7s4y669fawq6oip8x9p7ypp7gumw8
X-Rspam-User: 
X-HE-Tag: 1765193092-119428
X-HE-Meta: U2FsdGVkX19cuqQfhX0luxMPgr+Zw+VleNIoyYrYKGxPjPC9z+eDH/ufK7f4bTebjJoZ8KuY8SZj4mSKDZxwcql1uYoCbYDqe6ZFkmeZ1vXwHGvDGiKIRx05se+DnG1i9UgqO33fuCKSkwbBgRHd8BxuWnJC/vIcsZ99dtDzGdyaj/MBUl1z3rzaSPjtvciCCgqTmZXPUuh1dKVbDhBfLM/U2V+ogCn4WAMjqPoyl1LZb5KG/vDZTSHLx+O9YXJIDEeicZlUSS9xmpxn8qabK9SB+uBusBUKKy/j9xNBYTzqQlIloZupr0DuYQZwMccHrztg2mx2lPRjxNHQkMXQA0tHpdlifU3yb2gj6auLLcHKs+5n4HDKQl3RLgOjjv8YlJnrAhqUbXwZYaHaHtS1Swk43XlGdBKqP8iuD8LkZXXb5csnqedHaSLVjs4+4d3xSSFQK1zlldBDSiQ2uA/dOjSJ/oldGGULtFb7vYY1lLCT0VoC8E51LB24vhcRsMCZkTgm481U5T63qQa1N8iX+W/pYgBOcaXL0TYB3HEpvphtS4p3HtgD+vDtiVBW47mK0U//Yr2Ww6A+Wwp97NX69XX2NqkvPhGYMiVWI3SwhJFb/G2V1uoyUwg1wNdA5ltvlv44LyxZQHN+7Y0lAAN+95R2XD2ci8+ywdTZm1myJnZeHQ/R2XMQgCwdgktbvxviySOg4BRDaWQBHnXC29jVCUqNovGg7AdGKBPoiULKDeuJ/v5pw3HDPd3tCPif+QhRKy70/3oylPgyR0PQKlqCABD4nrOPMpqsNhQ0FfNRVl3AfMND0mzkUjIHsuLpVuIL14mpL5Us6UOoF2FczDsyavx9Xj4NwZszAKcC2ylQdUsDa73b7wBs8PdJiRlYVSbKKR65yRoUF5urP4uZc3jsb11mTdk6i3PI6j2s6BVs2SPEpSFxLH0rxKtNHTUM7lftMrVZannJvEoukeYEjlq
 4mSTqLw+
 5c6XqfFYn0L9GBXTUyAGBXsk28lhV9MQZ495SYp400Uhn+XtTz2+GTLM4P7/LBbKoKmmuCkRkm+iv3+3aQsJ5vvFQcfkhlQo2RGCMkUnwlmcDGpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000015, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 07:00, Deepanshu Kartikey wrote:
> Syzbot reported crashes in lru_gen_test_recent() and subsequent NULL
> pointer dereferences in the page cache code:
> 
>    Oops: general protection fault in lru_gen_test_recent+0xfc/0x370
>    KASAN: probably user-memory-access in range [0x0000000000004e00-0x0000000000004e07]
> 
> And later:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor instruction fetch in kernel mode
>    RIP: 0010:0x0
>    Call Trace:
>     filemap_read_folio+0xc8/0x2a0
> 
> Investigation revealed that unpack_shadow() can extract an invalid node ID
> from shadow entries, causing NODE_DATA(nid) to return NULL for pgdat. In
> the reported case, the shadow value was 0x0000000000000041, which is
> suspiciously small and indicates corruption.
> 
> When this NULL pgdat is passed to mem_cgroup_lruvec(), it leads to crashes
> when dereferencing memcg->nodeinfo. The corrupted state also propagates
> through the call chain causing subsequent crashes in page cache code.
> 
> The root cause of shadow entry corruption is unclear and may indicate a
> deeper issue in xarray management, page cache eviction/refault race
> conditions, or memory corruption. However, regardless of the source, the
> code should handle corrupted entries defensively.

We should identify+fix the root cause.

[...]
> -
> +	/*
> +	 * If pgdat is NULL, the shadow entry contains an invalid node ID.
> +	 * Set lruvec to NULL so caller can detect and skip processing.
> +	 */
> +	if (unlikely(!pgdat)) {
> +		*lruvec = NULL;
> +		return false;
> +	}

That's just hacking around the root cause, no? Because IIUC, that's not 
something we would ever expect to happen unless BUG.

Unless I am missing something this patch is trying to cure the symptoms, 
but not the root cause.

Now, if it would be valid (and we would not have a corruption), then 
handling it like you propose would be the right thing.

-- 
Cheers

David

