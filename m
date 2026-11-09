Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162E3606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3H8wQYE
Received: by kanga.kvack.org (Postfix)
	id D34C06B05B0; Mon,  9 Nov 2026 09:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12256B05B1; Mon,  9 Nov 2026 09:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22696B05B5; Mon,  9 Nov 2026 09:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90EAB6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:27:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16E1416067F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:27:24 +0000 (UTC)
X-FDA: 85415808408.04.A1A48A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C071180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:27:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3H8wQYE;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794234442;
	b=liSN3iwk4q0fzWjYPEFgWsyZKV00b/L/u+wRCeTIDAuG7p52TvCo3+/hbG4xc+f0WX5QsE
	o+iIO33jigmpKmnrbxDt8E4RWYUOPk6lTK5ANOPiC1Y5IvePZvlcVFzCa7VpZkiPIYyHct
	qiTyYFeWGICTZ6GceRJoQYyzSOqw6J4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3H8wQYE;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794234442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQBR/dBCMcYTXkdOeOOog1rJR98U8AmPJCb23jPzIvA=;
	b=ZN564M4p5J34grcZRieVG21VSnxkuTc1q41Qhs5NdhUsSqSc+an8uNVAOZSduBNRFVp4md
	GVuMMk9xut2Hxfb4aXRo1ayfpk1qq5cZwhtxEDx4B/4sObtbeJoFtgPyWEHJRJ1Ts06jNv
	RxSfE1+SjogZeHUjenz70FRWUxkuz+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 804D340E56;
	Mon,  9 Nov 2026 14:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83B31F0089F;
	Mon,  9 Nov 2026 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234441;
	bh=DQBR/dBCMcYTXkdOeOOog1rJR98U8AmPJCb23jPzIvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C3H8wQYEaereW5Y+ykz1l50Et0cRmZvNz5OyubO8k6Mzm3JRcJ8ZwAzbIpn1O0VnW
	 WoQZamewYE3OxZzQIlKv3AdsQpU4iqUvDUDOUFFBxGhaas9ujo4Rviw5CnK1wasFNZ
	 BUbvNzWWpx8nshdFgRq/q4q6yeNnrkSKKxHXxuWA1lNtb1Qdi219igtdjcLi+Ld4bM
	 PZPeinVRzFXxJ1Ls9Oa8cCwUWPLcmMFskJLS5DmV9kGsMA4Qcpf6ev0HbUWLZBFjBw
	 eLU5zsQLYsYo7mXGzMGvrSGOBEjSMBn1GmAXyNmOInW70mml0WujDbfWK6rByi2MN5
	 ZGKuwK5yM2DAw==
Message-ID: <07b298ca-d258-4cda-b5ae-0231ec39e033@kernel.org>
Date: Mon, 9 Nov 2026 15:27:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: don't allocate a page table under RCU in
 do_set_pmd()
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261106155604.3999641-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106155604.3999641-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C071180004
X-Stat-Signature: n8yd5nbhcmzz9kda7pfg8zzxegaasjqc
X-Rspam-User: 
X-HE-Tag: 1794234442-356272
X-HE-Meta: U2FsdGVkX192RLOF3o28nOhEU3qIPs7eqa0tZoO8Vz/Tsl7d01qHJYFPCX4CE8RaiCnilS2aOjzAuzWvCY0evTxQ5xKczCBxXVJV46eLdfzXVmCZ08eU2aSxqX841MwaiQUEkScfLnQgaZhZIKZ9qcCd8l3CxddTNAouZX9hfoVrAF60Qk+4Yy4DN81TZ/YIEe5plbsmtHfDF3KATfA8Tj5mwJS4tp4aOvqKWb9BMY1ZKJy2eML/MgoBFHoEc3Lkb4UDuMKf3ZApT9MPovoFbtEq+PnFunROToTXveAVosvMo1fF5PKPqQIbw1ppsnZ9JXq6KVegFo0b7HtsL7eMKb/2uOxJlAwzDrUWFxB9ZRj6ub0hOkj3rvkwFFZpQhNAhfTmapPxHDYK/OHN0iJPrCNtqzSq0lHq+RjzS7rPsv48ZFK1nxc5M8iqHUM0qkyUEsge6pg6kkHucjNqjlIDgGphxp1QFJ7DAotcczqdcWpLJgq58DYUUFcvDhh6UgPnpeyZQA2/HGzv3e2S3gq4JM67/mfcId008z4JGL6/G0VBr4Y/9kQj9XjqTpPmFeOjeAuToOmAop4CbDhUw+R1oseL+e22PtFFKQqpzu2lZ3yoWXRmPIbgr7gvDLJzrsAaUSFtdUNXkyENArhwEiD7GRhCwnOpbvbSdCnh1k/ac/YGTR/6PwQZMxAc99jTzfzPIuXOvK0jI5wrpDBxsm/g3JnJUTJdj6n/gMs5dB/7ZxggMkLTYeJZeNsC4sa3eqhBUVMAsR5inmFfo6CYfkuupsxqOxfFi5NEHbo0OZd/qnFEv9D6kbQdNU/c64ZtI5UaTQBLnN9FlK7k51vFmps2yPiW3l8YoBbQuORjBMMCik3qmd5LJPZuho6+AsbT2urreJS8v85T26romA1ohwhvYzgUp1QAj6obGRsYKhQa5QXxN0t1gt0CtFN/KGZyYnVMHBXI0900pN84Aazn43A
 CdYyg8+z
 WP77nst9v/tNx8wskWJ87dNYuXuowKDUqRh0vaWTDnWtW+aM2HcFb6mp9qZ5nc3u/TA0XygBAmr8KzXpHGFIRcRezhCcWH0hO4mdZBeO8oTleSEHRRdIwrLClWUlklK3r4HF5RXjGLAOr57N750IqU2VAjE2No7ypXSF1nkD1/24eYB9B8Y7r9bZZEt/spM/YwX4ri5bj9MhCKd5+io94AueVVfwiXwV/TULKrTxX0v/RqepdG04Jdb/g+olaRCB9Z3aRCm7P7SzeSTiOkMB3IebYotaZm3i5YzyvCMTc+HsrRJeXbk7PAR/pUUeLqiu2D2crwIY8ZCq5qsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 16:56, Usama Arif wrote:
> On Fri, 06 Nov 2026 13:36:13 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> do_fault_around() skips PTE table preallocation when the PMD already points
>> to a PTE table. A concurrent collapse can then retract that table and
>> clear the PMD before filemap_map_pages() locks the new PMD-sized folio.
>>
>> filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
>> preallocated table. On PowerPC hash MMU, do_set_pmd() then tries
>> allocating a PTE table to deposit. But filemap_map_pmd() calls
>> do_set_pmd() under RCU, so allocating from that context is not good.
>>
>> This race became possible when retract_page_tables() stopped taking the
>> mmap and VMA locks. Previously, those locks excluded retraction while
>> the fault was in progress.
>>
>> Add a may_alloc argument to do_set_pmd() and pass false from
>> filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of
>> trying to allocate.
>>
>> This issue should be fairly hard to hit in practice.
>>
> 
> Yes, I imagine it was very difficult to reproduce, doing a sleeping
> pte_alloc_one() inside filemap_map_pmd()'s RCU read-side section
> when a concurrent retract_page_tables() empties the PMD. Only
> possible on PowerPC.

Yes. Did I express how much I hate us having to support this ppc handling?

I'll buy you a double digit number of beers if you manage to rip that out ;)

-- 
Cheers,

David

