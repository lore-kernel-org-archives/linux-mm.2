Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34546CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783C76B00E2; Mon,  1 Jun 2026 11:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B866B012B; Mon,  1 Jun 2026 11:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6715F6B0140; Mon,  1 Jun 2026 11:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 566E26B00E2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:56:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F26DE1A06F3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:56:54 +0000 (UTC)
X-FDA: 84831797148.02.69E7160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37959A000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:56:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpgHRa1v;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1LOXYWGnyE1v0dMMQCjT19PvBVTyDuJ+KlM/Hm4iR8=;
	b=MpRDHc1VPZdpqeNDJzmxO30tP1LB42qW67xjLPRT9R/6xeRQhebv8y73R8SaAMzk+itA2u
	ywcWnkaFGZg3LOW+xzcJqbrNPpatjsczBbJjIDWL5e2cJViwDUFhxUEMUuQilUzl3CgQ3M
	5r9w5zTQWuhQQB3ZDm6RDQa2KVgMblA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329413;
	b=YklisTKoCphkOPW2nv+gFSnCXzHn9+ki6qBigSdQdkprx42vYbutmNOJu+/f/cX/ghd3CM
	sfrDNqPCuH+uEEv0FodLHs+NxkOy+n2mR2G95sO8x1sju7W4gLWguDKghde/iwA7T9f5lk
	MOCCy8icUUsynPnz/Hli9mz5YSEQjLc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpgHRa1v;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94CE1601E3;
	Mon,  1 Jun 2026 15:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3CD1F00893;
	Mon,  1 Jun 2026 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780329412;
	bh=h1LOXYWGnyE1v0dMMQCjT19PvBVTyDuJ+KlM/Hm4iR8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hpgHRa1vdTJkWwT53uYam3CM0oNfWlHdzxlGJiI4qYqBdKPPuOaRLEUfGZ57PnXHN
	 9PKoN2fb+ekqhbaI9oiQl4HBbih19TTPDbCNiq+UUJJM+/cwBLxK+/ByQoIQlO73xp
	 ChdLzkayLF8TbUB0iMcW6xEng1d3jue6RXYGrCbeSydcwgEK7jrXLR6Pultn49OQZT
	 Lhi3J2CDGTuNFJXWXaLE+Fm6M/gpiND627FOuZl8RRN+nxNaHR9ngQN+cB37oJWfmZ
	 tHm8r0ulMtgjCXMyFGrcNNcsFCAMC+VNIPP7VamB5Sien1dIiT8Rx9tFuUv7p5tx9O
	 3M59R/QJZtb+Q==
Message-ID: <d30e0d87-69f6-48d4-b3fd-6e6b87678f91@kernel.org>
Date: Mon, 1 Jun 2026 17:56:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>
References: <20260601083044.57132-1-ljs@kernel.org>
 <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37959A000D
X-Stat-Signature: pc1tsjy115xpcz59gao14qhmp9qjtr76
X-HE-Tag: 1780329413-220235
X-HE-Meta: U2FsdGVkX1+pBz8bSuehCa5g3iEghM8iP/FiDeRmhg73NECQLz4dh8qgdTrE3yyCpQMQkM8Fc1YG9xHJeVef3Ak13aZ4XhZsGnpZdSq2jp7zT0dCXLXITzBAwLfVMtVujIrawatM9GCmbmTvBd6TurVELJMiDEwhZ+40jh6jLwzjZq5XmsCy3r4+JbvkQrAgJs+YkNsVeNJl6wWrtvo2EiOQwQ24srtYzemZqSr8hsdy+fqBEb9/St3189lvE9Nf4Vekv6NA73veAww/VoWtyABFSF72bbhBkJnCOWlaxC5+XT159NCHOntwuzSapuXfEneZWCT22xEvYYmsVayIAgyDXrHN5l7OhMc5zGICOKx4gp0ZieBzAG/2HaNakwwrIV2mt0ybjWmkbpjHb5H42iasAd6Hs/73WZTUmEkS8gxxx+KTQ8c3vCJul8VuYztVqJBCGq+hPqXktFHmInNjFa0wk1I5R02hX6ffGYHOD+Fb1wuGC6RBaRTS2TvQLIbxjd60nA6jYBSqLBSszX25nnR+BcIPsYi1+YlERRvw2wZC8AD1qJHN2FFQcsFrCdvqAtbAY4rt2hTBwWjDNMCmMyZ1Hn5KPvvdHq7gdWH1Lx1BxHcFELnRf894Fxa6DGbBqo1SBpR0dXnJQX/YPW0PRS1AVhzq5q90piRUBDSCyEMTAaFQUhG4n031bFXX+YpbcGBmKKIstqs3QvdWefd8dS7e3SzAwG8edqAc3kUVeoP+/zqZpyzs2M1hLPh5i9tXEA9pUvduo2pT5TMmTqlyT08EQG+V9zh2p6U+syYbUAhlJALzfgdT/sPrI8HIN4OBvNSIlwmGitHQhnRy3aWIr2vFSQ2yXTWbZoZl2Y4uZV78VNCfHMQL2mFHWVRRBghP2WYo90iH8Yi5LOByztzyB0qqCvKwScdg/SyXyKsIkvYr///y078P10lV5psjzRyQxF2K4fcuyBV6H+NZW/6
 QPM33881
 CP5plUMLpXe6ANOBBCFLq7re6Nv2K/0FmymxaGq3Tf+Q9g65E/ZbDSwibJBHG/1x3tKjMuo3I6PWVjq7xyucea7J7oO6wFexCJXS20C0QApb4qRKvvij0XPczH7S36vzDnp+CDIrfyK/cuIr7JueNcijdFBrhGTPwXkCj9q8RpQ7AmIkvE3i8NFb02SHrMTLHLAOObnQnfetck22Z/SGa/VPHn/TXgXGThmbWbx0GlN1Gf+1n7xDMkdKUXz48t0cfidA/oKlNXSskbBJ7Szq9HrzptrIux4+RisiAm0oYbUYyYMrcsL+eCiL9A8xUtWCRIDOG2FN8ivQvKiNBlEjRS6AYnaedc9fGysWdtFadb/faIINsCbxQkaoEVS7J6qZflPl/LBFraQG4lSjlmjrjHkS1qZotBAuuNiv8OISkp1MZ242jZ6HjT4KRlAI8TTzGFZ0bxvB/z1O4Y/2I0KwWT4n+FXTE+iEL28GN4jd5JvHXinE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 17:50, Dev Jain wrote:
> 
> 
> On 01/06/26 2:00 pm, Lorenzo Stoakes wrote:
>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>> device-private entries") updated set_pmd_migration_entry() to use
>> pmdp_huge_get_and_clear() in the softleaf case, but made no further
>> adjustments to the function itself.
>>
>> Therefore this function continues to incorrectly use pmd_write(),
>> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
>> migration entry should be marked writable, softdirty or uffd-wp
>> respectively.
>>
>> Whilst all are incorrect, the most problematic of these is pmd_write(), as
>> this can lead to corrupted rmap state.
>>
>> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
>> pmd_write() on a softleaf will return the softdirty state encoded in the
>> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
>>
>> This was observed when running the hmm.hmm_device_private.anon_write_child
>> selftest:
>>
>> 1. The test faults in a range then migrates it such that a device-private
>>    THP range is established.
>>
>> 2. The parent then migrates it to a device-private writable PMD entry whose
>>    folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>>    (accidentally correct write state).
>>
>> 3. The parent forks and the PMD entries are set to device-private read only
>>    entries, entire_mapcount=2, softdirty still set.
>>
>> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>>    install non-writable migration entries - but replacing parent and child
>>    PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>>    bit.
>>
>> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>>    both parent and child, which are therefore AnonExclusive.
>>
>> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>>    entire_mapcount=2 and we end up with an AnonExclusive folio with
>>    entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
>>
>> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
>> 				 folio_entire_mapcount(folio) > 1 &&
>> 				 PageAnonExclusive(cur_page), folio)
>>
>> This patch fixes the issue by correctly referencing the softleaf entry
>> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
>>
>> It also only updates A/D flags if the entry is present as these are
>> otherwise not meaningful for a softleaf entry.
>>
>> This patch also flips the if (!present) { ... } else { ... } logic in
>> set_pmd_migration_entry() so it is easier to understand, and adds some
>> comments to make things clearer.
>>
>> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
>> device private THP test infrastructure") which first exposes this bug as it
>> was the commit that permitted test_hmm to generate the test.
>>
>> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>> device-private entries") is the commit that actually enabled this
>> behaviour.
>>
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>> ---
> 
> Sashiko continues to find existing problems :) What do you think:
> 
> https://sashiko.dev/#/patchset/20260601083044.57132-1-ljs%40kernel.org

IIRC, Wei is already working on fixing what it reports here regarding
try_to_migrate_one(). So it's old news.

https://lore.kernel.org/r/20260508013728.21285-1-richard.weiyang@gmail.com

-- 
Cheers,

David

