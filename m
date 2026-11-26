Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C3C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mC7UtwFI
Received: by kanga.kvack.org (Postfix)
	id 9E0276B05B6; Thu, 26 Nov 2026 14:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990DF6B05B7; Thu, 26 Nov 2026 14:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6E96B05B8; Thu, 26 Nov 2026 14:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 635576B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:14:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E497BC0552
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:14:53 +0000 (UTC)
X-FDA: 85478222466.10.7399F92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51D3A100006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:14:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mC7UtwFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795720492;
	b=IbOkFYrg/j6KJEUsbliUE3CMIeuQQzV2wrAhWgz1Vsshmz0y7SRP9KEY0jUUrJpeTLlKuA
	Cvq5pLaUNs17niI3v3Qf8CHFuncCYEQPlvqVWfr2sbRL9qBGtf3WwWBBe9O+g/r28ZC4jl
	O0XCsLc/WZxrEs/gFP3Pq/kLvnTaJZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795720492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuVLv2i2GOptfnACX7l3LiPUxZvYfKOmSODmwPhhkPw=;
	b=KN9wJmgd/83MQH0iPe36h1SVqu4oX2q6LjPypNWmvep8y5MSDBT1RRbaDb9U3iYEOmXwzb
	iazSUhCp1K2wt3LlC9Mpqg/7t2njNALuAxJDs1aE2/RbfaJqQYirnpF/cEZQCm2mID7gnO
	0/DIrWKo0SwcbTv8+PhxNiXkdawtVdo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mC7UtwFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B1C460D72;
	Thu, 26 Nov 2026 19:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B11D1F000C4;
	Thu, 26 Nov 2026 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795720491;
	bh=CuVLv2i2GOptfnACX7l3LiPUxZvYfKOmSODmwPhhkPw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mC7UtwFIZfgl362g4XVFFQa/G8viDzYK9zciLeNK4vN3HA19avPzi/zfmTg9BbGIU
	 dgelNbTa7s4yMuoGmp8foEhEPgNckZ0kOOxjjZzmt6CBra5rShY0LwesOtWrGrviCT
	 BXQwqJfB3mNv/WrPnyop1ygoMYYseBWl1YAbDtlasemS/PkApEcvJLQwZ6e3eGygqI
	 Z3OXnQlvYs/Yo8WSSjFWvSEvKBPp5MXU4m+OUQkmI7PKHw5pZhjyTruSefXYjiNpzB
	 VjRtOH2rC9Q8ru9ADi02DdfamuJWXQkm/qynGSBxdwbpRo+RVi6rEgIwh1Zb8voVhL
	 ocZCZs24Dg2eQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: sashiko-bot@kernel.org
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Pasha Tatashin"
 <pasha.tatashin@soleen.com>,  "Mike Rapoport" <rppt@kernel.org>,  "Andrew
 Morton" <akpm@linux-foundation.org>,  sashiko-reviews@lists.linux.dev,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v4] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <sashiko-outbox-234004@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 25 Nov 2026 18:40:57 +0000")
References: <20261124184042.1823277-1-pratyush@kernel.org>
	<sashiko-outbox-234004@kernel.org>
Date: Thu, 26 Nov 2026 19:14:47 +0000
Message-ID: <2vxzzeuvv1zs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 51D3A100006
X-Stat-Signature: uz5exygdoqzqms96wmfaope77kbybdtj
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795720492-714195
X-HE-Meta: U2FsdGVkX18PMQ903sCjvNfMiGXLPCnL8JwTDF1Zt/dMBu3fLDTKHKnINkzOwwrwCRHzp3I0DBrlXOATO1KvGHdPA5SV3W3P7BCYh5wlZgmWZF6BRD4EOtVSQZx2ZLMsnFxmnsyyGgbyFhgOeL5SN8Dis8YsupwZs+0C8YwC1GYEvICRero3fAfT6fFmIoXUjb8O4TzokjCWGpkr5eTs99wzu6W3gkcmQypFrLLYC0VI1JVcCqMGzdkYlStsv247U3Z2y/gBNLM4VEAqeEAcqJgJzjn/9bV2NgX1LzCkNXOVV2NqNLkGwzMDhLBsX5n7boFydMrd86x9UK3v5y26jG59vuU314SrkFZHqXuDfzfN8nk0IjMOZa/z9eUJzkmxpI6QpzAKPqXuO2JTFX+EbvXEX+TntveYK5NaF7OCW0BRuqNj9Vvz3lYXaLKpUDpkIVek8oCcq8YCyuggjt1s3KdTuIxDAXflnRTkKsmrGwRygVCc2oLWiXqVbSM3Z5+YcUgEn8i3Zraa+gU/qYHtJv5NmYqFCtFP+n/9mXPBeuxalxvPtcOhADw5fAMBoO4J12f12ClaRXUgx0xSPyuuMk1TZtGbOqMtDJisqhfZQj1G8p5Fu+QQiaIdzILVWiMDJdWnxQuWzu7pfB47ApyBZ6XO+s1FiDGmUObLPqssxda1+imTg0q6ueqMlcl3NSwiq+njE4y1vZsOlheQALN43TkdGdn8q/wYHrJAIkNHhfOqEtXDWojHG/PBBQAaPmjLkeSmFNiRiYOT7wc2vBEyMEDaqnznqfBqkwPlIW1UalAgmI1f7kcGXev/UiwFDGOc8On3Ula3RlMGyPZfP46YFuw6zkmPCZy71jyUlMNoA8pTJ6xBetDH+Z5CFPrvraSxuuU3pWaIV53FJEIr2OjNmCqvgAo0Atfd3rvaVw3BGjRmyU2DwU95OOZQCFt1G17+Vs5V4DSFna2cX7+RffG
 s1OaTDe6
 kOxTdrKViiSKFrldA3Yg8ch8QuKmOEMTuj8Dy4FNn2qdxPPH660rW1MGzXZzmh3mCvkAxeIzwxLiqNt8Ni+QE/ec9mDrLe9icfOiTTpLvx0QH2KNRDFrKMCJWuxUVFkZSsU3VSYYLNMyuYcWy+c2PBeB5yfz4djONexsTFlOO1k+7rGq8PzRMgaiDpFzw/72wUsqknYOZfkwILSB1y2/yF4SSSqgT/+vMhjtNrQTGhJ3/+rR+IWS/09qKYvkWner1VBliSe1wzidUSrZ0l6w3s/zQNT/yK37X/WpmjGaefF/l8qBH4XIG8hmbOE8X3K3r1taQtvAHca5117DVZ+vCpxn+BC+8xFod5pou0LfWSZa6nZ+TnNmeK5gTRTCGjm9eTnPiveSkN7Ntu7DBSjP1em/mfo0yG1+DYVGh2E0ETO6yijUyMs9U7ntlCADFF3kL1YN2scVEooJIOlDRDXQJYBZOy+0NPe3yZL7otWomk8w34FjBk9zeCqZ5PPPp2LOtrirO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/memfd_luo: unbatched migration and LRU drain in
>   memfd_luo_migrate_folio()
> --
>
> commit 36bee618bf022031606488c041334f6b85cc82a9
> Author: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> mm/memfd_luo: don't use memfd_pin_folios()
>
> This commit replaces memfd_pin_folios() with a direct page cache walk
> using shmem_get_folio() and migrates folios out of movable or CMA
> pageblocks individually via memfd_luo_migrate_folio().
>
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index 6b68220275ebe..38584ecfa70be 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -77,26 +77,168 @@
>
> [ ... ]
>
>> +static int memfd_luo_migrate_folio(struct folio *folio)
>> +{
>> +	struct migration_target_control mtc = {
>> +		.nid = NUMA_NO_NODE,
>> +		/* Not movable, so the target is neither in ZONE_MOVABLE nor CMA. */
>> +		.gfp_mask = GFP_USER | __GFP_NOWARN,
>> +		.reason = MR_LONGTERM_PIN,
>> +	};
>> +	LIST_HEAD(source);
>> +	bool isolated;
>> +
>> +	/* Flush per-CPU LRU batches holding the folio so isolation works. */
>> +	lru_cache_drain_for_folio(folio, 1, NULL);
>> +	isolated = isolate_folio_to_list(folio, &source);
>> +	/* Isolation holds its own reference. */
>> +	folio_put(folio);
>> +	if (!isolated)
>> +		return -EBUSY;
>> +
>> +	if (migrate_pages(&source, alloc_migration_target, NULL,
>> +			  (unsigned long)&mtc, MIGRATE_SYNC, MR_LONGTERM_PIN,
>> +			  NULL)) {
>> +		putback_movable_pages(&source);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>
> [Severity: Medium]
> Does migrating one folio at a time here regress preservation latency when
> folios in the memfd already reside in ZONE_MOVABLE or MIGRATE_CMA
> pageblocks?
>
> Previously, memfd_pin_folios() called check_and_migrate_movable_folios(),
> which shared a single enum lru_cache_drained state across the scan so
> lru_add_drain() and lru_add_drain_all() ran at most once, and passed all
> movable folios to a single migrate_pages() call so migrate_pages_batch()
> could batch TLB shootdowns across up to NR_MAX_BATCHED_MIGRATION (512)
> unmapped pages.
>
> Calling memfd_luo_migrate_folio() per folio passes NULL for the drained
> state to lru_cache_drain_for_folio(), which can trigger repeated local and
> all-CPU LRU cache drains, and invokes migrate_pages() on a single-folio
> list, forcing a cross-CPU TLB shootdown IPI for every mapped folio that
> needs migration.

I measured the performance before and after this patch with
movablecore=75%, and it found that with 4k pages, performance does
indeed drop, but the difference is quite small. Only 5-8% slower. THPs
stay about the same.

So I think the slowdown is small enough to not matter.

-- 
Regards,
Pratyush Yadav

