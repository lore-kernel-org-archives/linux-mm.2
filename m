Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696A8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599D66B009E; Tue,  7 Jul 2026 06:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5711C6B00A1; Tue,  7 Jul 2026 06:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1D46B00A2; Tue,  7 Jul 2026 06:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27C706B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:08:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAE09A0324
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:08:45 +0000 (UTC)
X-FDA: 84961556610.02.23BF427
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id CD8B040007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:08:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJA3uk1u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUY55oS394CtAuTTigq+2eRfUqPG18NKirH243JNBP0=;
	b=BCGx4PUUJY86WO0V5FsySpqXgWCdSfV5dHSkLrVr3XeOiJJ5C39WWvq7AuFMHcB3b/CRez
	Gi4+fb2aMI0ldjISDPJSFh/DjrUtXp5p97cq/+7vdu88y2XVxPRbzGSRrCwUDM0fgf0EY+
	rEf0SYhNbbuSo8OW3v5qQmLKATqFMF0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJA3uk1u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418924;
	b=Y/SGw89dr8/w3ivWXQWk4ZEe4vtwDsKTkRWymDPaIqSha2wCWNKdT3nYQ4O5bQa3AoZhBd
	QnmnjDfbhobO+xpTiGO0ztSItMvE3HKS6U3YnvH4KxOsVhcpeI5zzTahlJEown/lkpqSTg
	vGPPZdfPX5+Wz046oQ0sQA3Hfxn/75U=
Message-ID: <5d423660-dae1-4ab9-a656-7e488cf98321@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783418919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUY55oS394CtAuTTigq+2eRfUqPG18NKirH243JNBP0=;
	b=lJA3uk1ukFUMfWyOdmT6NDSS6hxI2mmC8DrlSshGOnPVKLBhJRCY+4xQgy128Vr/Y2mtjI
	Vpg1W6uVYZQs9rrq2fdwT1N/rrhYR1MU1u3Q8iOWa3zaztOREs5vZdtIhOlgz8/+tYiIA+
	Y2npszhgSvrVEVA7tVaetbbllI63P2w=
Date: Tue, 7 Jul 2026 11:08:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
 <20260703173903.3789516-5-usama.arif@linux.dev> <akwfJekWILGd6cPS@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akwfJekWILGd6cPS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD8B040007
X-Stat-Signature: 6ghu17jif8fqjwm1q66do7sxud9hgxcd
X-HE-Tag: 1783418922-718348
X-HE-Meta: U2FsdGVkX19LY6zWDHPlB0xlRynKkdax+pM20QaAeVeil650SF/XEKVj28KpP0fQbY+VAgCCNFSMsMgpv4IZCV27fEs3E1dnJOMz7BtzJy+qgctL5HoqQd2k+TuE+gweyc6w+EpFl1IQm019xl5oSYGFUOgm+yfQC9azNsnLGLI/Mgq3n8uBm0srxzI1/VuJN6jhtT4MBsBRbtv8KiADjt+vWE/hcOTRAz0Nng+l+0VO1i9zVKVAYxoO5u9zfBg13b2/UejAVp2p7Z+QsEvS8VUlZ+aZt2piEJBVqM/6jXzmsLzVtFoFeR6vGFG0c3EohSsQzbWQ6cRJHQSm4SQj1Z8mYPTbfQf/+/iQqjJiehz+iVpIxdoTyYjKEueLQz+6K6CN3rFm+l7aKNMNsOr8lTgoH6/6MOIKLG8dyhZSXc27RH25TAHzdpx3R7GtHtF3k8tnPmHpINiKcgjFvqyz3dL029pEP7QpK4h9yrSvVbvTTUwEx8Na+27tGl3BMel8JmA+/ZuHZX7Xvc0b9rZwtMxkaAOCvTnsbxvAVnpbze1BZ9MxKXJDTS+vxiC4UO/mO1hOMzhy9/RmAggoIRwJT1ShWGE9fgSfsVfQjGzIJkSG1RwkUCaHSB40zmDyHp00UEwBlu15BtZ29DLijmo1KRMnYQUIoFhPSMEiYQ9vIk3Dz6eLLlnTHOYhpPhL+ZFc9qcWoxIav3ywxI2baFeKe3v8zxwjYNjD9iuvmHCRKsr5iYJoqjV/sjW12agqRyPn8z/5RB3IjNrGYXgtmY+9Cf33u2fTW5pZ+2o+FcHEhSSa9t/iWarrzTAsMwDQUcQ3RYri+lgKOcTORRp7hizvuyHW3IBo/LXE7aR9jHv5hyjJ51rVdjyAgKT/gIXskylOlCFAdrl0ybixx2+htuVOEU3LTLCEkEtnzOBGGuOHJ3W7/pjIEQ7+ZnkGFw+EPyqc/0EJXYZdkub+iGbW0Ep
 N6aHdsDP
 Zq2b2u6eH8jqaPOBLcaFLjd0VW8DSJS7kDw1IhpdsxWXtRz6cIdq7LQjEl3RDh/gimI8pmtzWFbRfvP11/3marN6kn56Pm27/HUCVDwWU17Zt7GA45xxXqcXZpM3igerVlx/nH8dbHMI5aFSImtTm9fNiwwQl6FlMYDiYDiPDbV5cMO4bB1hpp2Y4alnre3VJn7eO3U6HHg5OvNQB74VLioHTVh1OMRtZDGBMJUhTYzsQKvBNcuLa6uPJFqG0gkIAJlh/yju35zL2NupV7jQ7lxe+ng8yutotfQH8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/2026 22:36, Yosry Ahmed wrote:
> On Fri, Jul 03, 2026 at 10:38:21AM -0700, Usama Arif wrote:
>> From: Alexandre Ghiti <alexghiti@fb.com>
>>
>> A large folio reaches zswap_load() only when the caller expects the
>> whole range to be on disk. Zswap still stores large folios as
>> independent order-0 entries, so reconstructing a large folio from
>> zswap entries would risk returning partially initialized data.
>>
>> Teach zswap_load() to scan the covered range. If no slot is in zswap,
>> return -ENOENT so swap_read_folio() reads the backing device. If any
>> slot is still in zswap, fail the large-folio read so the caller can
>> fall back to per-page swapin.
>>
>> Add zswap_range_has_entry() so PMD swap-entry consumers can make the
>> same range decision before attempting PMD-order swapin.
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I found this by accident, please CC me on zswap changes :)
> 

Sorry about this! I will CC you in all future revisions of this series.
>> ---
>>  include/linux/zswap.h |  7 +++++++
>>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++++----------
>>  2 files changed, 43 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e..de10aa528597 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>  void zswap_folio_swapin(struct folio *folio);
>>  bool zswap_is_enabled(void);
>>  bool zswap_never_enabled(void);
>> +bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr);
>>  #else
>>  
>>  struct zswap_lruvec_state {};
>> @@ -69,6 +70,12 @@ static inline bool zswap_never_enabled(void)
>>  	return true;
>>  }
>>  
>> +static inline bool zswap_range_has_entry(swp_entry_t entry,
>> +					 unsigned int nr)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif
>>  
>>  #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index b5a17ea20237..89dd88a5223f 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1559,6 +1559,27 @@ bool zswap_store(struct folio *folio)
>>  	return ret;
>>  }
>>  
>> +/**
>> + * zswap_range_has_entry() - is any slot in [entry, entry + nr) in zswap?
>> + * @entry: base swap entry of the range
>> + * @nr: number of contiguous slots to check
>> + */
> 
> Maybe zswap_is_present() as suggested here:
> https://lore.kernel.org/linux-mm/CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com/.
> 
> IIUC this interface can be used for the same purpose, we just need to
> pass nr=1.

Yes, this sounds better, will change in next revision.

> 
>> +bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr)
>> +{
>> +	pgoff_t offset = swp_offset(entry);
>> +	XA_STATE(xas, swap_zswap_tree(entry), offset);
>> +	bool found;
>> +
>> +	if (!nr || zswap_never_enabled())
>> +		return false;
>> +
>> +	rcu_read_lock();
>> +	found = !!xas_find(&xas, offset + nr - 1);
>> +	rcu_read_unlock();
> 
> Why not xa_find()? It seems to handle RCU locking as well as retrying.
> 

Ack, will change in next revision, Thanks!

>> +
>> +	return found;
>> +}
>> +
>>  /**
>>   * zswap_load() - load a folio from zswap
>>   * @folio: folio to load
>> @@ -1571,10 +1592,9 @@ bool zswap_store(struct folio *folio)
>>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>>   *  will SIGBUS).
>>   *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>> - *  do_swap_page() will SIGBUS).
>> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
>> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
>> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
>>   *
>>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>>   *  locked on return.
>> @@ -1593,13 +1613,19 @@ int zswap_load(struct folio *folio)
>>  		return -ENOENT;
>>  
>>  	/*
>> -	 * Large folios should not be swapped in while zswap is being used, as
>> -	 * they are not properly handled. Zswap does not properly load large
>> -	 * folios, and a large folio may only be partially in zswap.
>> +	 * A large folio reaches zswap_load() only when its whole range is
>> +	 * expected to be on disk: PMD swap-entry consumers split before
>> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
>> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
>> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
>> +	 * zswap, fail the read rather than return partially-initialized data.
>>  	 */
>> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
>> -		folio_unlock(folio);
>> -		return -EINVAL;
>> +	if (folio_test_large(folio)) {
>> +		if (zswap_range_has_entry(swp, folio_nr_pages(folio))) {
>> +			folio_unlock(folio);
>> +			return -EIO;
>> +		}
>> +		return -ENOENT;
>>  	}
>>  
>>  	entry = xa_load(tree, offset);
>> -- 
>> 2.53.0-Meta
>>
>>


