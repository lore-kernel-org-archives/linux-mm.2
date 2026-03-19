Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EA5107526F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F38C6B041E; Thu, 19 Mar 2026 03:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A50F6B0420; Thu, 19 Mar 2026 03:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED60F6B0421; Thu, 19 Mar 2026 03:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBF066B041E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:40:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9113C8B88E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:40:35 +0000 (UTC)
X-FDA: 84562015230.17.769D235
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B795D100005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:40:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBereu8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773906033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZvTKENtcCv2cSZKl3LDo5qu3izmZZmpsJiVt93OIbw=;
	b=BVN6sFyhNaFS999xncwR/vyUF9T3P60tOqU764gFRXAuf3zrvrwWNczHik6zv99zoYomSI
	zOB8+JbHOrz5h5dFaXl6Q/0c4PAMLbZSP/YsEiXFGJSrT+/EIv5/TK/gF59kKzLXpuxGbh
	pzlar4xFJi0YzmrAdz7KhObUdroKQ2E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBereu8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773906033; a=rsa-sha256;
	cv=none;
	b=MJvJbmqIjBHAUqLb/tnIhuYrC1YgyjniM3doAk0KVm90MmAhTrXh5piI8fETGlCYcBBvx0
	B3SwdTe5NtcieIhwW5HHEwa8Ni8RYfumxLMJryBCEY3K16uXn8RnWUbEayADvrbkJxM6rY
	RsQwzSI5dohgYp2UyVb/nJZ0LA42D0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C71D642AD0;
	Thu, 19 Mar 2026 07:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13048C19424;
	Thu, 19 Mar 2026 07:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773906032;
	bh=kgARICWk/x9CE46a29m+2Qcl6pq7KGjzLcdjK9IrfZ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DBereu8ZX4zRIwgOzq6jnFRd45UKcoO6INJUpK0rgEE4H6vgNpRG/4s1bXsz/TzEv
	 NhhbGA9liBmxUrMFHISG5m5cW7lJQfeI9iAdx5m/AWfsSfh2WZRkVplbIiRfCYTkdP
	 ierUOwCw4r5LSLU7duyhDpXvrNn0sjiVaZ411B6CTIrMb1VIDaPT+p/zPkr3yMcaCQ
	 9bwBZBYT1DPzjMc3fIWcEgg21Ch8SFZA/oqIciKj2BHlMgPTAyjxTkLcNovneEk1sQ
	 qU3HbmRBio+n/0+dj9KXiU1Fxg303ft+zsFMhMItV1OmA/jIVnW4hOm9v/eYUjF6JF
	 NZDcyJfEazVjA==
Message-ID: <d72d5ca3-4b92-470e-9f89-9f39a3975f1e@kernel.org>
Date: Thu, 19 Mar 2026 08:40:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K
 pages
To: Usama Arif <usama.arif@linux.dev>, ryan.roberts@arm.com, r@hev.cc
Cc: Andrew Morton <akpm@linux-foundation.org>, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, jack@suse.cz, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, willy@infradead.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260318105203.3288727-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260318105203.3288727-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B795D100005
X-Stat-Signature: mzk41giw7iqkzice5yhsapxb1cenorgq
X-Rspam-User: 
X-HE-Tag: 1773906033-384459
X-HE-Meta: U2FsdGVkX1+mTklx3mF0UVxmNH+tkXNyGeu4/xnyQpPzcvacjloMrglMAQEVsxaj/8zA3II4GAabGA8s9YhyNvKSZnhe3lE8+J9B/27COCdDIzgNgnOhXZFORfeWIT80SdL44cgqH3r1C5yv97nq6H86AZsycZHEX1Ewth2q1kcEZ2HeodKpDqQQKgQmHMBys0CYZ0CJ+fd7i/fU5Z+VQC6kOycWfw+U8zmfISp96eA4tCd5YPSLZAeZ1FOGUeKiGB7GakKtacNdcHPyglXbZMvvcoG1FJ/l7Ik9aStWfYITW9nU48osA6+/QTB1jCSZ7M2D4A9XeAzdPpdDxZqRf/2E2bywCAUZwGr09Wa+YrraSbfkjKO1LdNuSUVZe8L6pdMj+0TmqV6G9bt75poY5azPcgv1IcTXe3EpLAvp4ufjMqbYO2gx9KQEoGN+pmUoLqSOOt5liP/veJ3C3RVFliChY5y7phWPmhED9qQjk8fk3dbC8kZeQxkbgxb4PIaWGqzHo867FSHMawhVCuK01oKjiF6G/qmckZsxGO6KGrckKQZ/+Z2sUPGqZoDE+Q4XaBou05dLodTv0dJ6skQyTHpILURnRCzofvxrhtGreVkD8X0IhkqvwPWUucVj6FEadRM5l757cme59QaLqPmEednAmPNrdTji2SSoiVxIaPgqd6fdCdz9n55BVZIAHDx2Xo51hsZvtu5TXwDq1FGVZUmsT0E8vyz4jV/+tOLCXxyDWHkzYuCWDeD10CI1MwBDJRl0YxQhsYJ1tz/ze9q+0/iMoEf+dHROrGZkNFtHTsuTKAZ9xRREltq+7DsMTBRQBU0lqIiTEYHTwsn824LHHbkakd1QCz4Ch4Qhx90oGZee91NCs+ohUd60UCJ/j9vyY8+53AJFP4pJOwhTc0X6zrkJ/+Cj3G40lHe1mDElEW3vz2tKqwSdc8njuHA/285UunoKv17Cbh9Dfpqdrf7
 vjfNKLd1
 w/c8fB0k/SHbYmbQGVp0b0LrXUw3AlHOoyQvzza/bwPxDR3ov+RQEOIWt0xYCvuN63RwLfHDAoXZKL39MdYIb+E0k88pxRffBLk8h2mkS1RUwvBksmPVfjJ1+a1yfXELGniQmERG6Q64cpaRimbxBJjhUboKQqXGH8YWQI3X+/cVF1Mdn91Uw6G9uVhFQVa5VWbSGRMfhV/1K4ZRb3E1hWtljcC65RB9PrN/j0VARhjxOVrtVM2suzPDIxP8iNvhKWB9c6plF8OietJ5tVaZ0BC+2Rmk5OYPlOrjWedYaZfex+d24PvA5Km1jPWeBxM70jJe6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:52, Usama Arif wrote:
> On Fri, 13 Mar 2026 13:55:38 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> On Fri, 13 Mar 2026 16:33:42 +0000 Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>>>
>>> This was deliberate, although perhaps a bit conservative. I was concerned about
>>> the possibility of read amplification; pointlessly reading in a load of memory
>>> that never actually gets used. And that is independent of page size.
>>>
>>> 2M seems quite big as a default IMHO, I could imagine Android might complain
>>> about memory pressure in their 16K config, for example.
>>>
>>
>> The force_thp_readahead path in do_sync_mmap_readahead() reads at
>> HPAGE_PMD_ORDER (2M on x86) and even doubles it to 4M for
>> non VM_RAND_READ mappings (ra->size *= 2), with async readahead
>> enabled. exec_folio_order() is more conservative. a single 2M folio
>> with async_size=0, no speculative prefetch. So I think the memory
>> pressure would not be worse than what x86 has?
>>
>> For memory pressure on Android 16K: the readahead is clamped to VMA
>> boundaries, so a small shared library won't read 2M.
>> page_cache_ra_order() reduces folio order near EOF and on allocation
>> failure, so the 2M order is a preference, not a guarantee with the
>> current code?
>>
> 
> I am not a big fan of introducing Kconfig options, but would
> CONFIG_EXEC_FOLIO_ORDER with the default value being 64K be a better
> solution? Or maybe a default of 64K for 4K and 16K base page size,
> but 2M for 64K page size as 64K base page size is mostly for servers.
> 
> Using a default value of 64K would mean no change in behaviour.

I don't think such a tunable is the right approach. We should try to do
something smarter in the kernel.

We should have access to the mapping size and whether there is currently
real memory pressure. We might even know the estimated speed of the
device we're loading data from :)

-- 
Cheers,

David

