Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE80C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE536B0099; Thu, 10 Sep 2026 07:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6986B009F; Thu, 10 Sep 2026 07:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABECA6B00A0; Thu, 10 Sep 2026 07:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 816E96B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:14:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20EB3402FB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:14:53 +0000 (UTC)
X-FDA: 85197595266.30.6DBACC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5A038100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:14:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ohxqqE/h";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTk08ghQEYuYo89c0VG6xsdyLB9DUgU/FUr7ab35PKM=;
	b=uSgdr/FIRJYGIsKJ2Fo9iaDvn5FHCJ3tQFoU87Io93u/1rsbylSJgn1Cb5BgkXlmegTslL
	EzyA5vwzGatpSPmTy2JX9TXsAFNd9svPGKElwxFOwXlRKkWl4txhZ6OAdIZudTI/KM5JFN
	kavkoRFjE6nWgXSSkQu5KHAFIJ5T6HE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ohxqqE/h";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038891;
	b=w6Nioo3x3mb1DaNDmvwEzmHrXY4X+Ao0QHd9BWK94He9eS5jYv3WFHQBf2d4LYfyDpAs/N
	fEtB/TpBzwkjL0Z5puZiqa1GbTZ3fSbLiVleZStv/BpQZI+l8VURxtDhv9kKT63GYkSY/9
	sl/hE/PPxAGK7kWZ49y3gW2aPgffokY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AFA642B82;
	Thu, 10 Sep 2026 11:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB881F000FF;
	Thu, 10 Sep 2026 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038890;
	bh=PTk08ghQEYuYo89c0VG6xsdyLB9DUgU/FUr7ab35PKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ohxqqE/h8/pErTUSk94yiONeiZNIo5OYZZfvgXM/isBkATQx22xTOFjqP5ws1BX0r
	 O/zuLixBlzlJMHNnTACJ5rau/3/pmfku0CYHOYwr341hc958uhJFPQJzmQGlvmcJVK
	 HYHi9WSHCL5dBDzixrjyPXW18twNc27UbTCDvuQbM6VLjdGGpOm2mwdddVhpj1/AQ9
	 N1vl4sxz7shcP8PQTxuztAszZk/x3NV1rLZ10aCpyGyNvgb3l1FJu2SqeliCsTtd7Y
	 h9tz8KscbXjxI0bjVYTG764s6Oj34cer8zl4Glja/WzCDcwN50uGP7cZ3bR0ttfFU6
	 JDNUXhSywWWOQ==
Message-ID: <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
Date: Thu, 10 Sep 2026 13:14:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKOVGECsCNtSMIV@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A038100006
X-Stat-Signature: wxi4w65mzqpzyjgaarim3rsqq6r7k9wn
X-Rspam-User: 
X-HE-Tag: 1789038891-896565
X-HE-Meta: U2FsdGVkX19Z7zt/rFeJ6B0Dzc/QKVS9Q0Ony1ACG2tVfQ3jHlY6JqPKIA8MpNOVQ/Sv4OqiV7Bk8dyB8YkdpVx+Gbe+XMURkQ++dSzPpxoArDOUCOrweZFBjgdD9WXrY/Ysw7jWXFK0qRaTaf/n70OdPrwO0sl1VA+uklF5IyY9Cs+wUOVL0i/vBEz5AOOaicwGWx1KzY07x/kLzOiEDNrHXNQwtQ6CEA4TftOUN8uvxZMhd/aNdLFWoYz2q3xcVgaMBTLKQfHfsD+0XOglQMrSdZ1jWLctuoOgCMp2DumE72Ngrb/BMiW55y9GteFodmlBuRnf/AYZB4zSvJApvGP9De/CI7kHv6fWvOerzX/YsbS0SVvlLgOyD9IY+UWAjjnIXhYHno+95nYWoSelW5lbhKuZf5/r01Z5RKtT+AU6Zjbk/MoYtAEPs4uQE4+Tatm89/notzlfQazukz+jWWcxTDvZ35H+sOij1dA0DT4N/Mu8owtK/gDSQEX2PXDRLILGAvH3VqlWBfmEIvT2+MA0fbAFYmTM7Gm6eZ3Wfo4uCNIZLN4r33YeiLHEfYPgDFjpIv6pwsB4ZzOa+C3ZimPZuIV/417tHlMn9jRP+rXHUQoEWC7lheJBsZBIJsBskDhf35ZiVEkB3V6sTlVJS45tSPdewXsdI+wedXVw+778XykFiuwaINXaWRQDEnr2U61gpCbyQ/BIl8+CfPli3Pcx1Uep/rQJS1Hf7VSuSUjmSTXwbKqc+5rBnJfRa/N16kbNmLijTSI4a9OkGU/jMGNC0azslFnMvG/YztfQt4oJsH7dpXcPeWG0Oer9XqRnwJ4ZoJSon12WmcJ16Qd5VSYv2RS022eRx+xGYg+cERcbBWT9I0b5O9XN72CLYIEAngOVk8WBIt0x/StemPf/OhFBL6pM8lmIfNZW7ljIDiSU7GabAIKvdK6br4Wpek4dqrbmTr9h+GRlsMu/kVd
 s/PfcK5L
 F2XrOuRdjWFpJupfIK1ijIvbFNVDEVa1sMCmsS6pAjFyXmy5t5BdRNjrRx5Y4jNjriEUCHivJvGCDh/imzDU75DoSkLIMXH44DYkSnnUXYD1T9Xs5RnK48LQxxVJNPYgvcluDA6h9N6cWsKQ4KU+QeUepnp08Ma/LzSZcHqaoguGBPIS7nCCVYw5jUOr17XmS1HjAAlftcPzGRiOYsMzCeJzxJlRUTBmgyVkE8ahcvoC7VGPhE2o2nNufHbjPl64Gm7RjcYGTOH8VDGatp/mU3sJ/5/MPrvFl5qmpH3LLiyi0QJsRY8/1zPdlrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 13:02, Yeoreum Yun wrote:
>>> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
>>> index 5f278913c4d7..b6fad38c8bee 100644
>>> --- a/tools/testing/selftests/mm/soft-dirty.c
>>> +++ b/tools/testing/selftests/mm/soft-dirty.c
>>> @@ -92,9 +92,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>>>  	if (!hpage_len)
>>>  		ksft_exit_fail_msg("Reading PMD pagesize failed");
>>>  
>>> -	map = memalign(hpage_len, hpage_len);
>>> +	map = alloc_isolated_mem(hpage_len, hpage_len);
>>>  	if (!map)
>>> -		ksft_exit_fail_msg("memalign failed\n");
>>> +		ksft_exit_fail_msg("alloc_isolated_mem failed\n");
>>>  
>>>  	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
>>>  	if (ret)
>>> @@ -130,7 +130,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>>>  		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
>>>  		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
>>>  	}
>>> -	free(map);
>>> +	free_isolated_mem(map, hpage_len);
>>>  }
>>
>> smaps is really only problematic with merged VMAs when relying on exact page
>> statistics. For other properties (vm flags, MMUPageSize) it's not a problem as
>> long as our smap search just finds the VMA that covers an address.
>>
>> Assuming we fixed check_huge_anon() to not use smaps, why is this change here
>> required?
> 
> Since there is no interface to get vm_flags not via /proc/self/smaps,
> It might be good to have it for preventing unwanted VMA merge.
> 
> And might be useful for future to prevent unwated VMA merge.

See my reply on why vm flags are generally not a problem. Just like other
properties that are not changed during VMA merging.

Let's not perform random code changes without a clear picture.

And just to emphasize again: VMA merging could already be a problem before
memalign() internal changes.

(also observe here how we do a MADV_HUGEPAGE, so this is all rather arbitrary,
which is not good)

-- 
Cheers,

David

