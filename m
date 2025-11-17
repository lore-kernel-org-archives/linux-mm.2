Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A096CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF1F8E0019; Mon, 17 Nov 2025 11:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FDF8E0002; Mon, 17 Nov 2025 11:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4675C8E0019; Mon, 17 Nov 2025 11:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31BC98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:47:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C012C1DFF93
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:47:21 +0000 (UTC)
X-FDA: 84120679482.03.65690B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 230DDC0016
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:47:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4mLEid5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763398040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llPiWJRYLpgiUrIU3JnNlxvsyPJoyl0JQWbI9WjRYTQ=;
	b=k6Li8oFz8Sga6C3bSfXbjZNyvZP+JeZDHixdVi8W8rpIoUv8EFLi5Ba4Nw9+BGTcn8zXTC
	/IG64tW9jVD6EF/iyhidItyuAD8/vpgQk/5J46LYJw6KaRMH+loGFiWwh9SquFs+ZDjPsD
	HL0biaS36iJ3Wr63xiesOD6nMuJDUFw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4mLEid5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763398040; a=rsa-sha256;
	cv=none;
	b=SoBH2SmzfYpgY1ZeB6bd6NrK8GSQ2Hv1QBBGj0uzwO9BEcMCaywrlffHovyTbbfmK48Zn/
	cCpNXUh5C49iMQ0YNh1cAMPrKD52fqc0XQxhhvJgFNo+rBXf4uj+lETxHHVTvzECJUeWMZ
	GT7KJs3aTzbmrgiLIBJ4Jde8ae9NlZI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74BA8601E9;
	Mon, 17 Nov 2025 16:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818FDC4AF0B;
	Mon, 17 Nov 2025 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763398039;
	bh=VDPU8WBpaSMdog+Adn5C5R/6IBPWeQhuaPBSI4eT7Ko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I4mLEid5UB2vfOwQXMYCyyiehnTm4dhzeg8ijCEtfD2upmwu1wXdOEhJ+MLKn5PyL
	 XWjEQLi4Gkzt61V91UBFEXN4IvveVwebdp3HmwNGmDyTT3QB4mXI5bbIo+K+MmoMNn
	 LgsO/tTrW0XgeARy9TG+bmFaCZbslP/UdD/1PnRitn2CLZfBffpDBprSsOJ/9yJEL0
	 5G7QezrhBDd/ytSQhI+YTKE0+c7cXgDd5CnuaNKFtHucUrNJE4J+3snXSh/O5y+7ju
	 5mJjRxcNDM8F9XTrK87uvomDx9F2hDcRKfm4olTCbOTtGNf6+tq4xFxicNH+bG1uM4
	 6zkTWIT+Y7vaQ==
Message-ID: <e470c73a-9867-4387-9a9a-a63cd3b2654f@kernel.org>
Date: Mon, 17 Nov 2025 17:47:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
To: Jesper Dangaard Brouer <hawk@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20251117052041.52143-1-byungchul@sk.com>
 <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 230DDC0016
X-Stat-Signature: ymdwokczqmt49tbrmnenis3gntgxcccb
X-Rspam-User: 
X-HE-Tag: 1763398039-323810
X-HE-Meta: U2FsdGVkX19K7/WoEKTcMOLrCo8VTYXTYns7mU/XaF12qsm+j56lmnNZcmNC2ro6DJsoHv5fZwDDUju0OqMAub5WMPjccTDWb5WxFdFNDfr3sfFuqeHVVs2p+7kybEX0qBERtZGg/YGU7aits4ABZ3CErTtH6D2vv3wCsXFcAnqxIZH/TkLGjFeR9xBnGx6VWlIuukBZi6FHPAluhdBxhTxPqkpB1XfOykUAeWkwYXhjn0mn4JM56cXaUnwxUGD1WVwQYlIjDhQ3PjlPh3ahiAGi5THkN9nRZALpb1e3bjEleRTmqENldm3kTGuMQpbvmpHC317aRScBOD1PL42JeutAAHxbx2GmmGYd4XI/kvOHOxCU72UDO5qwQTyqBGanir3mx5IRIjIsEPn/OfRCrq+UKVrNziLTDRSP+hCgFXjBBweVMieD5k/+BogaWhUS/3V6KOEhI2zPuQL9sPG0dfhm08MxK1QawrVlnZ8mQxrTm5Er3lDklIUg3f6msydoVfNmxjmr8u43anH/3662ukDTdb4KDJLiVh0lYeiluIqsgZkkAhAaYxlt34V8B7urB7mMi5wGXC1W3UnL7TA5rgbCV/663/QL/KYimUCb+zoQ5I+DNd0dAHis2Ok5Sp6szKVaQyXy//noEpxFDqKOihTQB1nzAl8xZnxAxwjuFp59KMHsbSgdoB3HhjV3i8eCvr5VatVPemeHYanruaQkKAanUmbhx5nZlr7BibPktjuW65Y0MtsVrbS29dmeghlKWEvLNur3QmggNb1j40JJfParrb/hJCe8YD5WcGPgfJcP57VPKIlnMKoAkE0wzP1wOeaMCXcET4NtQ7/gJs44gtszl6MFQWnnRbsuHpZURoDLQJZQRqxWBVR4hj7jr5aWbmmNtQVYANOLXQg/z/Cp7ipa3gF8anzLw1WMTB4D409mLrOD+0wP0DvT3ZRhEaWle+179l4hJNrXtZxGgpe
 ccBUA4jS
 y52QEUY4Vfk+xgsxcIMJIsmHvlSPGSbept3/j9bAL8eWE1Ndm+sJMQ+pW3azY5mCKCwOXYrxr1HvsWDZW0ioX+TFtFzIwUizLFi7yJfrdNoQP5NbonFEKJFkhOcZdovBa+k/z7xuYbmAqilupg8gvvdVzhUxLps/2H3FfLrBiVJuez+IPLmby4Kb5FdaMgSPSLtlO7BPlTILsu/v6IN9OAZ4HbgCepwM6NfN2EU8kF4GZhRWQmHf06FDEMDZABBJtN1QbVICw4bWFdm4eZ/+qGHVdRMMiZ21vGpk30wPPu97jXwd3ZUDzH7bfjuKSnaA9MTeI6Nid6mciF6R2yjdsN3Ll4QOI4b1q1K/lMo2+Ot1ZtojLy6epV2/8jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 17:02, Jesper Dangaard Brouer wrote:
> 
> On 17/11/2025 06.20, Byungchul Park wrote:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 600d9e981c23..01dd14123065 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
>>    #ifdef CONFIG_MEMCG
>>    			page->memcg_data |
>>    #endif
>> -			page_pool_page_is_pp(page) |
>>    			(page->flags.f & check_flags)))
>>    		return false;
>>    
>> @@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>>    	if (unlikely(page->memcg_data))
>>    		bad_reason = "page still charged to cgroup";
>>    #endif
>> -	if (unlikely(page_pool_page_is_pp(page)))
>> -		bad_reason = "page_pool leak";
>>    	return bad_reason;
>>    }
> 
> This code have helped us catch leaks in the past.
> When this happens the result is that the page is marked as a bad page.
> 
>>    
>> @@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
>>    		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>    		folio->mapping = NULL;
>>    	}
>> -	if (unlikely(page_has_type(page)))
>> +	if (unlikely(page_has_type(page))) {
>> +		/* networking expects to clear its page type before releasing */
>> +		WARN_ON_ONCE(PageNetpp(page));
>>    		/* Reset the page_type (which overlays _mapcount) */
>>    		page->page_type = UINT_MAX;
>> +	}
>>    
>>    	if (is_check_pages_enabled()) {
>>    		if (free_page_is_bad(page))
> 
> What happens to the page? ... when it gets marked with:
>     page->page_type = UINT_MAX
> 
> Will it get freed and allowed to be used by others?
> - if so it can result in other hard-to-catch bugs

Yes, just like most other use-after-free from any other subsystem in the 
kernel :)

The expectation is that such BUGs are found early during testing 
(triggering a WARN) such that they can be fixed early.

But we could also report a bad page here and just stop (return false).

-- 
Cheers

David

