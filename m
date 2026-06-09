Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E67CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E296B008A; Tue,  9 Jun 2026 05:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6606B008C; Tue,  9 Jun 2026 05:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C536B0092; Tue,  9 Jun 2026 05:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 815AA6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:22:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 412B21404AE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:22:24 +0000 (UTC)
X-FDA: 84859833408.30.36AD597
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79160A000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:22:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWQgzVI5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng9jHxhLKm+wupNc2lT6TIXiphnAOWpSgu5QGHBRdkw=;
	b=B2Lisbk5SLWL+1x7qObHlta8O6m3vvc60tbtfyjGiUoMa/eYeciZIqcGRcZMVkX2YrPh7P
	O+/d3yU/qqJYi/hsrLcM6V8f1uZo+ABqUthNaAPJ+f47G49XbbnaHrHQpJdRfeXg+aYYFH
	NIE/ggfwJEdFzIKY8zPplkN+64PMCCo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWQgzVI5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996942;
	b=YzLPJa4vilk1Clhrr2aCzImzsuVZCsIPDT0As2FLj/TRqOVgiZD2+/M/xgr65EF88vZuEV
	O9scZOhqA7ozv1DFAswAJzu8yFwsrsKLrn/uDNUufRJK1d5b+xpatlJ7zR/Unoc6SLh3CM
	IWGgN7uLdGJ619QOe7yxJlaeNuqNz0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B08E54004E;
	Tue,  9 Jun 2026 09:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02581F00893;
	Tue,  9 Jun 2026 09:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996941;
	bh=ng9jHxhLKm+wupNc2lT6TIXiphnAOWpSgu5QGHBRdkw=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=SWQgzVI52LaHkB7VoZBRP5Hep43cRjdcNaxoxP8s799rSQR10tuC9zEdbcd/OK0Zj
	 Qg3Zi8Q0kZHVXMrubP85luSqXwcss6sIuQfi5UcGSdqCRJnTLeYEaWLGQD1uL4No8P
	 4dVL7kNGywcze91d2iG8aL8qFav98WG2jmJjOxXXgT+nRAEvhnyZrU7AZCf0TJtAxk
	 W46BDDJ6FNLWOuVjkypQK1MjWqyS41ToH7O8dLG49OTre8ayvppG0u13AMTq/sH/3E
	 4y1SS98K7w1YJraYhy7Im77ox9c+GhETrnx7gdUt60C3ToM9xXEs7mziD4jdyMP0/O
	 rPTkApO9tZc1Q==
Message-ID: <c600d34b-8424-4ff9-adab-f6aa654d7ca9@kernel.org>
Date: Tue, 9 Jun 2026 11:22:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 7.2 candidate? was: Re: [PATCH 2/8] mm: merge writeout into
 pageout
To: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
 akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
 kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-mm@kvack.org, hannes@cmpxchg.org,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-3-hch@lst.de> <20260609084909.GA12512@lst.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609084909.GA12512@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79160A000D
X-Stat-Signature: zj34twqynnfs9sutzz7pfj913ayafb5n
X-Rspam-User: 
X-HE-Tag: 1780996942-320518
X-HE-Meta: U2FsdGVkX18mx59ZBkUUNhR92KGYbA7XnlpoCBFYeFhL9TVy827Skykh17bYXUfcHNYEaRC+GLOnQqVvbyMSDBEQAVhsCwpbEQPPRH2PCAhMkCNrvMysnsfrW1+Gy1iJDQS0jPf9YOjcV6jRcRfuO9XX1jQx+0bwcAM/5atoCrIycctGpe3PEDXbstLVGjF62GRXmPUeK/4GYrblvnxHUf6gjYPZJmvp8NHPWwC4YHIGHgfyUcbyn1hVe9RSiQyK4JwMih/M/psZvugRE1cBAtanDW0/sEiuvTkkBFRlCpwzFgOxd0AH4N4jAFq+JQet0jL1kgJaII0F8CGZhQMi8VSYafM1zGbmxDa/f7uZQOiRzxi4/eEKkUf9CIT2FxRc3suUVVBaSLb6HrfUz0Sgv5JalYFkXxSBhR3aagbVxqO2Pws+ubnr4IHI6ZMIgEj4V3xbtCJkaxAlnGI4GOJ0vH0p5OAT7Hw+Szg4HpVH2Ru8cTGHOYyK3WQvi6aRCuDbfdoW4OVpbDedeRNrfoJAxLMKNCQFecygiMoOQjv4bAnXuEGPbSNWAUb5I7QsBF0CSiIsvRIjxJmJSn7T/Kp7TKj5RvLkrTe5WfxuccNn8FYgxc6+hTuWMT2i8mPyNKLwm/APMLiVpvmVf9kYiOA/1L2vuDdS74RB6mhUgHBuq6JI8KxOZyfR1Yps2GSPEtuG7OlCK7wMoO8J9MuQgdt1v159VOY+4Lx4Ot15cVucJot6tHMWPEyCxEtp8BdyNM18cmUGcqZPU9xJkOZzAlHAPzRrgfCP7F09mOg4EivHMW/UWXnkXTlSARwOx/VNFbw5Bf6XhanG//JNWaOTJK1CcsZNhp0SECprjkJ7YF26/WAda591KgPK+eUnf8C7mN+s2x6Yu6O9IlcAXc+xQ0FLO4Y9ra3u4tXvKz0bbJSTv4Ej511LxuCSd/lCsJwawZIOKT0s7WJ3j6Qc5zto/ou
 /dW/EFCs
 9QxQTaICDZYf9qJxCQnGuqwTWDKQ34yl8qqpQixueafI8KznELUrt5hHK7v/Xw9QEM2Et/UwpiGpioFrX8+JjtF7vnXhagcdHHc/C/tkshSVQe5X68hlb7w2ksQafDwnaFsph+g3K5CGdsoRDu/zpMOaYcITNBT8I2fi++gNHHWRCqZ6lKaDuj1H6hHjh4miOSWCnKOcEuXrp4AGwRBKtjmtWKETITMCaQQYael11dS91q19IfBesWktmTYhZ+COLzgayBl/l/9I/Ht5XO++JL5H3Tg6k822Gk7eao0t+2PQYI6ycC8+TebQWBnbzyJ8vjF8NUsdgj+yerCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 10:49, Christoph Hellwig wrote:
> Can we maybe pick this up for 7.2?  It is a trivial cleanup that would
> be nice to get out of the way.
> 
> On Mon, Jun 01, 2026 at 01:34:28PM +0200, Christoph Hellwig wrote:
>> writeout is only called from pageout, and a straight flow at the end, so
>> merge the two functions.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  mm/vmscan.c | 63 ++++++++++++++++++++++++-----------------------------
>>  1 file changed, 29 insertions(+), 34 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index e8a90911bf88..d7303eea1265 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -612,45 +612,14 @@ typedef enum {
>>  	PAGE_CLEAN,
>>  } pageout_t;
>>  
>> -static pageout_t writeout(struct folio *folio, struct address_space *mapping,
>> -		struct swap_iocb **plug, struct list_head *folio_list)
>> -{
>> -	int res;
>> -
>> -	folio_set_reclaim(folio);
>> -
>> -	/*
>> -	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
>> -	 * or we failed to allocate contiguous swap entries, in which case
>> -	 * the split out folios get added back to folio_list.
>> -	 */
>> -	if (shmem_mapping(mapping))
>> -		res = shmem_writeout(folio, plug, folio_list);
>> -	else
>> -		res = swap_writeout(folio, plug);
>> -
>> -	if (res < 0)
>> -		handle_write_error(mapping, folio, res);
>> -	if (res == AOP_WRITEPAGE_ACTIVATE) {
>> -		folio_clear_reclaim(folio);
>> -		return PAGE_ACTIVATE;
>> -	}
>> -
>> -	/* synchronous write? */
>> -	if (!folio_test_writeback(folio))
>> -		folio_clear_reclaim(folio);
>> -
>> -	trace_mm_vmscan_write_folio(folio);
>> -	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
>> -	return PAGE_SUCCESS;
>> -}
>> -
>>  /*
>>   * pageout is called by shrink_folio_list() for each dirty folio.
>>   */
>>  static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>>  			 struct swap_iocb **plug, struct list_head *folio_list)
>>  {
>> +	int res;
>> +
>>  	/*
>>  	 * We no longer attempt to writeback filesystem folios here, other
>>  	 * than tmpfs/shmem.  That's taken care of in page-writeback.
>> @@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>>  		return PAGE_ACTIVATE;
>>  	if (!folio_clear_dirty_for_io(folio))
>>  		return PAGE_CLEAN;
>> -	return writeout(folio, mapping, plug, folio_list);
>> +
>> +	folio_set_reclaim(folio);
>> +
>> +	/*
>> +	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
>> +	 * or we failed to allocate contiguous swap entries, in which case
>> +	 * the split out folios get added back to folio_list.
>> +	 */
>> +	if (shmem_mapping(mapping))
>> +		res = shmem_writeout(folio, plug, folio_list);
>> +	else
>> +		res = swap_writeout(folio, plug);
>> +
>> +	if (res < 0)
>> +		handle_write_error(mapping, folio, res);
>> +	if (res == AOP_WRITEPAGE_ACTIVATE) {
>> +		folio_clear_reclaim(folio);
>> +		return PAGE_ACTIVATE;
>> +	}
>> +
>> +	/* synchronous write? */
>> +	if (!folio_test_writeback(folio))
>> +		folio_clear_reclaim(folio);
>> +
>> +	trace_mm_vmscan_write_folio(folio);
>> +	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
>> +	return PAGE_SUCCESS;
>>  }

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

It's rather trivial, so throwing it into mm-unstable for a bit to merge it in
the second MM PULL would make sense to me.

-- 
Cheers,

David

