Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63B9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDEC3wKQ
Received: by kanga.kvack.org (Postfix)
	id E7AA56B05D4; Tue, 10 Nov 2026 12:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E039C6B05D5; Tue, 10 Nov 2026 12:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D166B05D6; Tue, 10 Nov 2026 12:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0BCD6B05D4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:38:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 221991A0A77
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:38:12 +0000 (UTC)
X-FDA: 85419918024.02.88D5654
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6733E4000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:38:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDEC3wKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/eB+/CH5yaEpI1uhM4dFjSsW0sUvRV8va2xHbNL6Kg=;
	b=fPL1Qk+3dlbRIULAe2K/Z9XRuyIj4i7FHJJakJ7NbHKq8D30p5d42GJvU1OA/tm1ovOQLU
	VjKoCK6HUD6SY9KuEI4Vm56rbrXvicYwotvrTBMGtVbVE2j5rvo+YAXfGVth+SX61husAy
	Chvn4f0VL+6NLMrdvJHk+I/5h7y4r+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794332290;
	b=LElnEPCAhtp4+GPjhFjk6R3OuJ36/kqT5pCTe1RMzBPPp3msXdYOG9Vr+NTzzf3RO2ooy6
	uwzyNyQ6V50O7/GlNDN6dOj8109L3X1MWei6++XojvfMGfS3HSYvSuGyzbHdUzuYpnGoM5
	UFutU8TTIwsB4K7PIOgm209vzBv0gdE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDEC3wKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9D44088B;
	Tue, 10 Nov 2026 17:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392F71F0089F;
	Tue, 10 Nov 2026 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794332289;
	bh=6/eB+/CH5yaEpI1uhM4dFjSsW0sUvRV8va2xHbNL6Kg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=WDEC3wKQyX0hwMUN7w0VPurSY8Nvo/ERaH/+f4RahK/VRm8DW4X2gwlvhh7KTVPcD
	 M1BCzIkLVMIL9ZJYaGK3hVB9BiyTYIK8mAg88QneuGhyvFPARVRjC6tIdUJJ8BPvBH
	 txO0v2O2BXqcz5yMfuH0485bf+bmK8ZDLA4Z+ynQioxlG/HCoIBIpUfLW1Nr9AKDC+
	 PzWNOAj5G3lN37XjPQeNeEtRlMi8Oc9OwVJT0CsDSxxdAIrbUy+//RaNdNL+a6YfzG
	 EEUQ1wiGUUPMeoXetkDh3OZ/8xOdTkUCqOpfLg9RMsOYCt2JFmSKHxZKJ8EOM6H9Sv
	 Q1oK4bFpBW/TQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <179381215936.28814.9050829645096838793.b4-review@b4> (Mike
	Rapoport's message of "Wed, 04 Nov 2026 19:09:19 +0200")
References: <20261103172251.2348370-1-pratyush@kernel.org>
	<179381215936.28814.9050829645096838793.b4-review@b4>
Date: Tue, 10 Nov 2026 18:38:06 +0100
Message-ID: <2vxzse18h9j5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9oy149oqaypt99uzet69wxiwpudrojuy
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6733E4000A
X-HE-Tag: 1794332290-826238
X-HE-Meta: U2FsdGVkX1+HcHrb9mH9/gLn6XRRJ/sdNkSizoCqpfHRi/NY4z0l3caP8rbz/bHVzrAW7mDJfWVvamFE+P+3k7tIVuskTlPxnTNpVv7V/ytOJwUJfs3TK22/+erbFaKH9rhBlI6AjZ140fnLC/DIUC8YshzGmmYCydhqeIFwOXQ7cmj3aBsYC+3xOTyL/X7ILPWXB4GctVsQp3iWj2msCWZKYAxmhzUD4tnXl0IM8jnZUFJITRpz9SyUn4JQpkS7D6HjMzThtwpUBPKe1cs27yjmSBAupyLI5zBWG15/3kx26H0p+KouuYC0juvhmjWYJPLp4TjwuZEOo2hPIL4jITGyrb4kJX+8CNiGxoU9gRYw7IlehgysRd/NjvZ14UCq0JuvGTSHt3a8rihQWWuRfKUinzx8Ru8PgEC6aEsfL5rpoFFcW/m6aGctV9EsPhkYy/kzNtLIM8T76P6zJeK98Ns6XLOw8SoIO9rUGW8fQt5dOIhOd9RzEfgUFMtXHm8kssuli15zKNGMlwari/QH8Uqq/q7XVgu59/C73o+m/1kDwlBJSEHCq923iOCTO7yPi7oXLk/xNWlqdV12nF9yGOxc9IBvYdhB/A941EvgYeT4SOW1y93nKVXcGG2f82WoTyP7X98I6UEi8f78GeoTMxjgmX9gU1UKeh7loPhGlBILTsfG1TSvqlSxx0YoKo8Mz7rPgd0s5HDtCBpqm9hR/bYgHVAwb32zmWi3W+jUuW5ug+THyWPu6pxRT8PhlBtIcvLZOApzn4WNo9vt3TBC1Obc4cK8Sv4jNxnMeP3EjQQ1SfQw8v5aLKtIkfOUMvurZB8DAToofZ//L+8M4dvuxNcQgKPbBQoYLyht540NYO4oDz8ehzQOeGj2VyDqrJLAPgjBIYxCwyBPkqZC/6/h9iscW54+lXEsiD12xsU4kVOQ35FfdDus/ZLh/RK1J0/s4O8GoF4b8VaX08WYzpI
 5GuHWZb3
 jfTikrpAUdQe8BrFcbnDtkff7o3TlEWb9nVtI8pXKlOCRzWUHCYhEdlZRIBHegGZkOXTdVT4HTkF5tDWsgfgEwXod6+wEulWGsQHnYbkAO3ijJzz30Nrxg9x6gK3+kfg1+5DUlB0I2m43w3wlYi9m7Qv0/p7du83W15AJEhaiIDZLNCrqOUDMygL9Ok5y9kDOqUBiR49SjDXsdmk05rQKSW/Dos0bDO8RVj5r8NaSy5sw2MyXN558imZbr4MyBujdnvBBU6RSxG0XQSGwXlYQh5G4OqvHb3hcV3kSqOFakA3r/vRAU8RX7bpZBE4YuZsnnN+9y+8MYp3EIB+odWYa3YeYnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, Mike Rapoport wrote:

>> memfd_luo takes a snapshot of the folios in the file's mapping. To make
>> sure the snapshot does not go out of sync, it pins the folios in the
>> file via memfd_pin_folios(). The pinning also migrates the folios out of
>> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
>> region.
>> 
>> memfd_pin_folios() does not lock the folios. So it can race with
>> shmem_writeout(). A folio returned by memfd_pin_folios() might already
>> be in swap cache. This happens to work but is fragile. memfd_luo looks
>> at folio flags and index on a folio that isn't in the memfd's page
>> cache.
>> 
>> In addition, memfd_pin_folios() needs the caller to allocate an array of
>> folios. memfd_luo does not really need that since it will vmalloc
>> folios_ser and store the information there anyway. The folios array is
>> unnecessary overhead.
>> 
>> Finally, memfd_pin_folios() fills in holes in the memfd. This makes
>> preserving sparse memfds very expensive in both compute and memory.
>> While this patch doesn't yet stop filling in the holes, it sets up the
>> infrastructure to make it simpler.
>> 
>> Fix all this by walking the page cache directly using shmem_get_folio()
>> with SGP_CACHE. This returns a locked folio with an elevated refcount.
>> memfd_luo holds that reference until the memfd is unpreserved. This
>> blocks compaction, migration, etc.
>> 
>> There is still a need to migrate folios out of MIGRATE_MOVABLE page
>> blocks. This is because those might be CMA or KHO scratch. memfd_luo
>> will hold a longterm reference to the folios so it will block migration
>> in that pageblock. Introduce memfd_luo_migrate_folio() to do this.
>> 
>> Also factor out folio unpreservation logic into memfd_luo_put_folios()
>> and use it from memfd_luo_unpreserve_folios() and from error paths in
>> memfd_luo_preserve_folios().
>> 
>> Since shmem_get_folio() always returns uptodate folios, drop the folio
>> zeroing logic.
>> 
>> This change also improves preservation performance, shown in the table
>> below.
>> 
>> |------------------+----------+------------+-------|
>> | memfd            | baseline | this patch | delta |
>> |------------------+----------+------------+-------|
>> | 4K pages, 32 GiB | 748 ms   | 600 ms     |  -20% |
>> | THP, 4 GiB       | 0.59 ms  | 0.59 ms    |    0% |
>> | THP, 16 GiB      | 2.99 ms  | 2.61 ms    |  -13% |
>> | THP, 32 GiB      | 4.83 ms  | 5.21 ms    |   +8% |
>> | sparse, 32 GiB   | 8695 ms  | 7269 ms    |  -16% |
>> |------------------+----------+------------+-------|
>> 
>> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> With a few nits below
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

>
>> +/*
>> + * Move a folio out of ZONE_MOVABLE or CMA, so it can be held until the next
>
> "held until next kernel" - here and below - I feel that something is off
> here, but can't pinpoint what exactly.

Hmm, perhaps this:

    Preservation holds a longterm reference on the folio. This would
    block migration in ZONE_MOVABLE or CMA. Move it out.

?

>
>> + * kernel. Called with a reference on the unlocked folio, which is always
>> + * dropped. The caller must look up the folio again afterwards.
>
> I'm having hard time parsing "called with a reference" sentence :)

What about this:

     Must be called with folio unlocked. Drops the reference to folio.
     The caller must look it up again.

?

>
>> +/*
>> + * Look up the folio at @index, allocating it if needed, and make sure it can be
>> + * held until the next kernel. Folios that are not longterm pinnable are migrated
>> + * out first, retrying a few times if someone else has them isolated.
>> + *
>> + * On success, returns 0 with *@foliop locked and holding a reference.
>> + */
>> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
>> +			       struct folio **foliop)
>> +{
>> +	int err, busy_retries = 0;
>> +	struct folio *folio;
>> +
>> +	for (;;) {
>
> Won't
> 	for (retry = 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {
>
> look better and the body simpler?

Right, good idea.

>
>> +		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
>> +		if (err)
>> +			return err;
>> +
>> +		if (likely(folio_is_longterm_pinnable(folio)))
>> +			break;
>> +
>> +		folio_unlock(folio);
>> +		err = memfd_luo_migrate_folio(folio);
>> +		/* Someone else might have it isolated, retry a bit. */
>> +		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
>> +			continue;
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	*foliop = folio;
>> +	return 0;
>> +}
>
> .

-- 
Regards,
Pratyush Yadav

