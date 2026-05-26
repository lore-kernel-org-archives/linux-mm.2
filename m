Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F766CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1BC6B00B7; Tue, 26 May 2026 08:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472986B00B9; Tue, 26 May 2026 08:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3619E6B00BC; Tue, 26 May 2026 08:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21D516B00B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:25:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD26B161501
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:25:44 +0000 (UTC)
X-FDA: 84809492208.12.21C82BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 009D1A000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:25:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLHfrSFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9scc/QTQDTADk/8Ifzj+TCXHxk5Dm6o+leMu+796Cps=;
	b=jJMdKQCHserTi0i799gOjw3ukSWHGxnlVZSpRxbrMmP5ihdVcNTy9jNuXoMUCvHnjHvW0U
	y8EURcQRzkxJJCFqwaVdeUP1gIiWoBOXukSd7fcwslfrM+Xdg5YmQZxK7It/hPaBcT+sg7
	aLCIzCSvvU4ZX6GHTLigdk0nZ+PtYng=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLHfrSFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798343; a=rsa-sha256;
	cv=none;
	b=KrSdG4/NDrdFdBu7lhLT+Pi1siwCrS3d6avyfoh7FUAXdWLops11CMRJ3uJ4cAmdxUJtn+
	VxQBYMTROf9Pc/luTlh8FgdkY/d3DzIEre79/ktUWMwgHFjQ0UG2BCwUZuh/EROWyh5g+6
	nLQrQTJXrkr7ycLei1QCtd7xQHCecNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63D5060018;
	Tue, 26 May 2026 12:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A22F1F000E9;
	Tue, 26 May 2026 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779798342;
	bh=9scc/QTQDTADk/8Ifzj+TCXHxk5Dm6o+leMu+796Cps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PLHfrSFINh6urNgS6KFJYpZnn08HeBIYrA3ajZDVc8sl/ZXlll2F6O3tvrAxw6IgX
	 2yoY6ZUce2iB5UGEFjOZHuymHEmrFW6mxapG0LJPnk1kT1bWtz2Fq5eJxi3kH1CQsL
	 9evDLBseSNw0ckV1/GN4Zrh2grhf+dWhCELwoFcC8rDwakGBQSOHhsDw32Ep+z9v0G
	 SIHLkZVS7y3neCgkIdbLRv++9nSHc7+XtRQNEZPCORL92Qs+Te55Xw4KFeBv80+76y
	 du+ecA/1QV6pGaNYlKt1+bCDiispNjruOp0RWu+YeaZxjLD78rifG4QzjmCD968NHt
	 C1Vz3ygFRyJ1Q==
Message-ID: <58434ba7-78c8-44a5-8262-98fcaf131e6e@kernel.org>
Date: Tue, 26 May 2026 14:25:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before
 folio_put()
To: Lorenzo Stoakes <ljs@kernel.org>, Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260526101337.1984081-1-yintirui@huawei.com>
 <ahV8PuP2sg7fV_DR@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ahV8PuP2sg7fV_DR@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 19ijh91gikuw7rb9m8rp7cbrtuqnydmu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 009D1A000D
X-Rspam-User: 
X-HE-Tag: 1779798342-386804
X-HE-Meta: U2FsdGVkX18SviishBohq/BReczohcG8EQPIivTQexqY3oE0sebKVmxczvcp2tglHWuQzqDD8/f3Acw/BSAheqqWoSboS2uyD+APcxLCpA26Xf2XpkxFBzQyXuNN/LUNYD/Rl92q3G55gRP3HjUPrSs36z7RcaJc08m1jMoRgpkdEXz9g8/sdXNvw67qznnRFcUv2tsg+G8/+8lHJejBFs5MNfb5Mv54D4D3/ud7/JW0kBsWqs9SIli42UtBuiiUu3RKRh7vEXB6oPQI4XAUoR0zE4zGt3KyIopFPtSOeLWe8WT8e/T4D6J6r9+Y8YZoh6vrkkQpWd19aS9G1UidUROxZ7vP8tnzJ13e9md1AgHeLrg2TUAg7ieCDWQnT50ICLJ0Fs3Ami2uEmZN5Y2oyo7KSy1WdSdp4f3dEAc/yLLlAknkzVS770qEp5dmfqlSWtCp667KgqJ1E7I/yHkEDnloKov3ZWE3nabhFCqT5zOKWRP3AL2UbeXgWQR0zqzOrCmu8vJfLPtFQZiTN1SN33yhhZHpjHS0mSdB583uqU9AOkJlMWKaVX5hI9YTzvVuffDDKDHB9gnDslXxHRHMsOYLnZUGUsuaUf7CSIfH/kP5Rz+yqbGAa8IXKSQ8fSxmI25Jy9pBL9PsQlkG8xJgJEGbKJzNaLoazxGCnqNfxlXeLnM7+4CQBvKDvtVsISuSBGmY1zAveFD4yyBADKc9336IC8RfjVdJOBM47S/OylJNp54sa6/FKR/01W6RWNAeZFgSbgEtPiozW/Vd6C+MTUbwgLXSWyMz/e+w9JpcssPJfgyEDbMQIWwRfb0fQtXUhsjKPxLksqz7KqkGJHecKc4IfniFnihiMC/L8PqWoyaU1wStfL92Nu2hKOzXjyw8lyEtczGPRe6w+4gTV4lwdcGRTaEW689cQUniI9CCPjmgC3S7KEwRd7jcQEL3euXNygQRbzXtM5Xw2OMkDPd
 FQKdewRv
 FHEO5ayqq9BQi0mvxX+1fgwGPxCXGa7xyGvXVaTiXug2/28gJxUn3fwG/BFN5CGet6oa8D8usxCmatz8WhLuOTHifwyYxH5GarUJdFXBwenpxJzKqulZPG4Z7+/rxqnieSBaHG/7anrMsb2blh4rkLrw5dcc3fxsVxFW0JCkOZMoZmPH9Z11WrKYmwl3NF3UcH2gS17DJah0LX+39p/Zn1ZG+RAMeN35um256mNzQf+mYh4KR3JUKoCKi3WMabY50d+syBlsyHqvOdAMN3F9I2Eig8eQq+c9SAE5X9AHyKhvR/YgFJXfS1jdhr/jPGmRx8LtmtEb3KA5WpHdF0UNy2TE58Zt4rY15NfQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:05, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 06:13:37PM +0800, Yin Tirui wrote:
>> __split_huge_pmd_locked() updates the file/shmem RSS counter after
>> dropping the PMD mapping's folio reference. If folio_put() drops the
>> last reference, mm_counter_file() can later read freed folio state via
>> folio_test_swapbacked().
>>
>> Move the counter update before folio_put().
>>
>> Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
> 
> That's an old commit :) I mean I suspect we're probably not actually ever
> dropping the folio ref to 0 here since we never had a report since ~2018.
> 
> The page cache keeping a reference I guess?

I assume we could be racing with truncation.

Truncation would have to trigger unmap itself before we do the
folio_remove_rmap_pmd().

While the race could happen in theory I think, I do assume this would be rather
hard to trigger.

> 
> But doesn't mean we shouldn't fix this on principal/there being some way
> this could happen.
> 
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

