Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAA2606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTTm8uV7
Received: by kanga.kvack.org (Postfix)
	id 6B2486B05B4; Sat, 21 Nov 2026 08:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689E66B05B5; Sat, 21 Nov 2026 08:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FD56B05B6; Sat, 21 Nov 2026 08:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32EDC6B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:01:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABD184045D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:01:49 +0000 (UTC)
X-FDA: 85459138338.01.BCAEA03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C08B82000D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:01:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTTm8uV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266107;
	b=W6hfA8Nu6DT/qDGyp4ogEVXXAONpbzruzUngC+EW297OQfJQJynxYuraBsJXmRR1KWqVIL
	L3o9ven1OHvvHmCK4kwk+Tkod6UkDj7HPrlhl27t4RN2A7cO1w7YKuJukjGbCPRGtdgPb/
	4is3aIk5aG9YS7hebq0HtqiqIiESaHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzaSLVmKPBX31jKxTVwHESe0dN4GEJWpEBij/w3vhM0=;
	b=Z48v814mthTzzR7z7dm1C+at9IFh+n3Pt6ymg7jThS7XA/pXOFs4XdKbEJPGlVnyqQGttG
	2pBaT/CJ2VezMBqhWwibjhgfzuAmX2E+9zPbwFfugOot0oio+VXRSHm3n2EFeyOTaTmeD6
	p7V8PdSu33glA2hVJysreSTpTToNJWY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTTm8uV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F0B44109;
	Sat, 21 Nov 2026 13:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD01F000C4;
	Sat, 21 Nov 2026 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266107;
	bh=FzaSLVmKPBX31jKxTVwHESe0dN4GEJWpEBij/w3vhM0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=JTTm8uV77whsPPyhAo95fT6LNhKi3Lml8Y8zUNkmQroCJKNkyQ7u1kuCP713GMosk
	 /6ubb7d6L3+8YkTDNpplB7bGleM/iXHAFFLxntgn9DzJEJxYAh05PhKuPc6LpfQ2YJ
	 yjghQGC1DcPCHOMsEQu2zAi94JheY6vGio8H1qdWgLPT6PhYkZ6nDc7kaBxBSaDE2E
	 iRFAJgmhSvVigPEwpP22TOBgD20XiSSWn0Rb7TRznTkbhT1p1bLmbYcch8lR5steua
	 nQ7dTUenG1j6WvAfM4UhtrklkjDOn5lbawivbi2QKOsfiY7c/5AJIxfnimFxh5JKFO
	 yuBoj6qUv9bYw==
Message-ID: <037fc749-cc74-48cd-ae64-6b01889fec77@kernel.org>
Date: Sat, 21 Nov 2026 14:01:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, Chris Mason <mason@kernel.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, qi.zheng@linux.dev, qinyuntan@linux.alibaba.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
 <179526598180.412063.14973682472309530978.b4-reply@b4>
 <960b4568-9d20-4eb0-b0e4-67e60f8274d4@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <960b4568-9d20-4eb0-b0e4-67e60f8274d4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C08B82000D
X-Stat-Signature: bywi43xxmypabuswi9z7waqbqseafr8c
X-HE-Tag: 1795266107-345509
X-HE-Meta: U2FsdGVkX1/kPQqJx2f9L+4mu5gKWuXFwf7dhEukv8zDn3xlOJZRUVJIHsTskBnq+pPdyrMAsmPlSQlGjZ2uSkPbeyigCmGWZQVWITmUAo7A3kb4vLURKeeriFojJjDHjJJKCiwfO/H2b4T8xwj2G5et8WyXt8iysm6ugPdVS6JTTdnhNK6mo4KhvRsIOQCCThCpdr0h2K5CTDKdFKSiYRw6Q+r0V7UmNJJhjznglSiaxC2CyDnXADKP9hcTEPYp6svFCglzs9SFBPWpz1EP/oCFaFhkAukPPGdyHPgl7y+AtfhQLyXv8xPcPLBagV3kusP01M4tcoAmI+MGKP1SKgbnCVbJNwj8wk7ehauPyx/gRTZsDjqvckjVjKoGtBqgXUbY3Oo0oPwsaP4h/r8GFEod96vQmjmUaqPD4p93OGgDvS18lCi5QZbWaAkftc9dYnZzsBSS3mjlulLuwiIFAJP1X18QJAdkT3dmNqXNJElxWs9SFVIQot6OzEXtpsaAcQKR8hTtN8fkQFQzVAO9v23QvrWbavTyl6+UvmLxFClam84cVsid9rqHf2B4YHDsf6BYJ+lT76h3qjrmITdqUTxyzK8mmvdP0kK53bQ/LLXuNC4ZNfJElJ66NOtCiwpRheKLxEgMiJkHaq5gRUcCPeacRm7tYMud6NVsnn8ys3UbeD3nN/EdpKb8XQA0jER6NIFukSGoz7929LgoAdEjsUlH/JWKoj56m8Xu0xA9GjcptGlmRExMfSq893/EOemjHHrMI+s+dG/TWnRcpfHIiqm2ZFXhRnPkHs7Pj3hzMl9NYjxVGlamToWfNoT2UGMg2UkVtmBrtUTPMG8eKj0jrGRn1xYmUNyNW5QlifBZf9klV20FUF77ernRx/Jbq5DX6KP7yLwrvm5odVTw2g0zzJnLpWZdPiLUPuAHD3KCGjCHwUwdiTkp1Q4Pz3/VvaSNi/nc9yBrZ0478cg2/33
 YBcwev6R
 wipBAiIpdsvoeMNkVgRrd/6U9xOhitR28NcOq2/w6VyC+U5WJyCpbxEzqAq9elFDy8sfdfXoXCIb3qMZyq4Clhgqxpxd65irHpF4hJQeLl4ChqxkeDTD2b0z3/f/AcX6dmEO73QClwg5ioKywreB+KsgjBqo2x1UC167haH/ylAavavr8Qzl/DYg9IfnFmJVV1+2D2fiuX6MRkLdRJnMaDdNZlQZ93X1VyhdpeAtbKPNEQJmmoFsx6CRJyH9/KeFLS6DFJm0qhjjlKhSdAI1/2pG0eyILYj1cjBpXJhnx8ULD8zi4gKo5DPa9uqGDkQ3nMDDbiq6+QrhkvxU2874IqAtv8seCmNISfq3AMNw9jWBmZjF573RofsmoK+mK6hRoFUsh+lD949ejpCu7bhqlqpWEo+/VIjlzi04M/46bM64mt3n8Co+X4K9K4NL0wr7GNdbZQKBcAFgFkCyiD1SSUqRSJpqJQAZDEZv243CfCVIJllQY0Tyn9fBjWLx8DiISkG8T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 14:00, David Hildenbrand (Arm) wrote:
> On 11/21/26 13:59, Gregory Price (Meta) wrote:
>> On 2026-11-20 14:50 -0500, Chris Mason wrote:
>>> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
>>> if it races with the migration of the folio at the end of a file.
>>>
>>> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
>>> But it is NULL until the folio is charged, and a migration target can be
>>> in the page cache before charging.
>>>
>>> shmem_unused_huge_shrink() looks the folio up without the folio lock,
>>> so we can race with migration:
>>>
>>>     __migrate_folio()               shmem_unused_huge_shrink()
>>>     =================               ==========================
>>>     __folio_migrate_mapping()
>>>       xas_store(newfolio)
>>>                                     filemap_get_entry()
>>>                                       returns newfolio
>>>                                     folio_trylock() fails
>>>                                     shmem_unused_huge_requeue()
>>>                                       folio_memcg_list_lru_alloc()
>>>                                         folio_memcg() is NULL
>>>                                         memcg->kmemcg_id
>>>     folio_migrate_flags()
>>>       mem_cgroup_migrate()
>>>         commit_charge(newfolio)
>>>
>>> Fix it by keeping the original objcg around while the inode is isolated.
>>>
>>> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
>>> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
>>> Signed-off-by: Chris Mason <mason@kernel.org>
>>
>> Reproduced and validated the fix. Changes look ok.
> 
> Thanks, I'll throw this into for-next-fixes right away and cc stable.

scrap the latter ... just a hotfix.

-- 
Cheers,

David

