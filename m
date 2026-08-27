Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625BBC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EB76B0088; Thu, 27 Aug 2026 05:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825FD6B0092; Thu, 27 Aug 2026 05:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C766B0099; Thu, 27 Aug 2026 05:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAE36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:20:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D457EA0175
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:20:43 +0000 (UTC)
X-FDA: 85146504366.18.DBE6B45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28A4940004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:20:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AewH8qVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQ5yrSer67OLzLd9lz4RUmRIM3BfwQlVemrGrqjo/J0=;
	b=hFuhexi8GqCb8ZBG7tTocFnmBemNTqVMgT+Ayc9ZCAbH9uWmL5VKGKMDefCkomZzar9wnj
	HBKsP/6Rv37I8kyxSoMcTyOf164WeVwMPQ7SLWTNHXnag5w1CZ8nnBol6PslmB08Hj35K/
	VcPACm+BlZv14GPNJa9f8gXNZDXXPZE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AewH8qVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822442;
	b=8oUfg3siSJ9hALoilRyvk3Q95+9tqwU0W/P73wMbHYU+3BkY+OIrRW6l6I70Fhg/QzLYpN
	ExQjdTpfT+QKGSvvysthuRM+GpzU1rs2NLqvYIZR/KUe9OGjpAxyrg1FNdJDMFD9wtVZQO
	c6jDzjjCrgyjD3QXULGeTbwKRklEGxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48A58600D3;
	Thu, 27 Aug 2026 09:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED11F000E9;
	Thu, 27 Aug 2026 09:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787822441;
	bh=MQ5yrSer67OLzLd9lz4RUmRIM3BfwQlVemrGrqjo/J0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AewH8qVoW428CLvXuvn03nnnNNP+TgdWg5uRUNFsxqCL+qVKeAjZDW+Tmxv3tAVdc
	 7UIVsQWQbyBgUKhK2nFQti2iPxw0BTpPo1vq8iLuV88Lgd4H/PB1EF6MYmiaihBni6
	 G5F6gOD/c/IuPNuv7PXCBiTHbx44v1IRNf32u/Vb0ErvNQVonwYUp8zYU+tDAzZUdx
	 wy/6HEE8/4+JjE3saEFPne1x2ZAx9PbQZVIk5BRuTTtwzFXfGeJJJXlXU5XunauPqm
	 Sxc89Jf7AuhJN9ZCDiVpmwkcHiZr7L6Sjj+HRwJWxkrQ4nRUqxV3uAdsRHdH+ppbBk
	 YaSl01yghZ8oQ==
Message-ID: <1dc8f7d5-c923-410a-a262-dc21c9e65420@kernel.org>
Date: Thu, 27 Aug 2026 11:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH alt 13/25] mm/fbatch: no lru_add_drain() to
 collect_longterm_unpinnable_folios()
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com>
 <333bb765-a36d-e07e-d3c4-5ea2f1cadfcb@google.com>
 <5d42fbfa-1cc3-4161-8ba0-7318267576a1@kernel.org>
 <e10bc806-f995-e48d-a24e-8872f0a71689@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e10bc806-f995-e48d-a24e-8872f0a71689@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28A4940004
X-Stat-Signature: ge41eyafsz7maksj9i3jhs9tjmrb8boy
X-Rspam-User: 
X-HE-Tag: 1787822442-440985
X-HE-Meta: U2FsdGVkX195sCZf/3OjiojInAV6PgGJI9xgAMdsiwwTrrPB1cSvDfFR4M3APm6h0Yy53ETDWIm/6rBckAzR5F8+0V621HM2zyBgfrQsFLm/gBdpfpY2uVgB9p2ksvljZEok/PQmuIpwBIpbjcvt/xgssCqyhpTu/Kr8zyQOoUN6n8kUt1j84G0Y/lTAdvYEDFOyAL9ReO0KaYULIV/vikdQ3xviJHxgGXXDuwXvNFCqqtO45gOkgx6OvD3CGrd5RyVqpwLEwNwR9z/T9pl5uL/hIMaec7vGv5RWkdDrMqe5f6ITbi7tNMD3Wrn7TPcFOQTl1ff/Qo58qSB7jzdXwrfqCcmqRyDyesBaSP6m7gwPFbe69i9bzVIcFO9WG+8U9JdrXU/ck4tfbMJHNDAjOJHi3HmPYvh53XEw3T8mceTeqUMTg+d/isSXQP28wkRewTHNMEIEt2wcNy0WXzG3Cxb70M2s4Uymtw3UPBOsEHvaJxEc/Iw/dCyxzWUAQeVNYVLTLuiW6sGYlBZ8eTYX5AV3rREuN9WqGqtCc5L0ZKvYjy2qc0FHf3tG3RGYwxsSz3EFOhXBCopiy+HUdhmZ7K4Ep0nKmFbb68VpeRjxNmG8ahuQfN79ghbjJwEb+km2MLKXqUMnA/GgYIou/mm5/xE+mD9VR0xgrK7WPHVm5PeN/0tyqZCZl0FzGlHDHAbdzY9nU6m9qpr12aYeS+c/P9UuGbzoI//hhjLZ/oqnaTBVqv+HilYRb0lEoDSIWsbi83zUAytHHqBW4VQp/Xr4JiyfgqVqngSRE0up+jXt5WVNQiK8Hex5qJGY5Ae5w/beDIu2QeV0vUF6yTp/qgXxuDeueyfvy4pHLeSfEA9MMwvFnRzr5vQtXPe010PEAHjNGb5pyKFHzC29uUErEoLSFvRKfbfeIN6G8wAAY8qmjQxWnsQTrlOn31fS2wpVscXZye96xs5uWR0uf5tatpN
 Xe4pscCC
 3xtdGCFtbH1Eda/ZVHW2jA5ZUM3u00ibzWcIhTJwDUkoi4YDH1EjZaJGgSlrz2NPzTZT4rytbtJZGR2TsuL9AS/nyPOUSEgTFrAXB5TZBYdqo9R+akxpCY/IL+eL9Qh4uKnFdICkwnxSz8crBAGWaqCmL9TGNC8917mTVimf/64XJYU2c6yYvzj4unAeYodc/lS6dd21pcDbxK1qoZ/gj9GTdKW4UnPhSexcOlL44PXAnfaKyPsUuv5xrOSBvL+llQ7KsDVL243pnB7tClg0X8Mr2Z4z7L9eoMWMdwz43+gqZ0USbe13sDrTX45p+fpzldq6TNmTPP22WUVaRcA3YmzjRSVcRrk9mVfQSs4j2ylj++XuS6sZ5igNpEDIsn31CekJ6wqyDcAfHmAdbFRtYLfjpbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 11:16, Hugh Dickins wrote:
> On Mon, 24 Aug 2026, David Hildenbrand (Arm) wrote:
>> On 8/24/26 16:55, Hugh Dickins wrote:
>>> collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
>>> lru_add_drain_all(), now that the per-cpu fbatch references are gone.
>>> So remove the recently added lru_cache_drain_for_folio().
>>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> ---
>>> Alternate version for use once David Hildenbrand's two commits
>>> here have been pulled from mm.git into linux.git for 7.3-rc1.
>>
>> For 7.4 we expect another user of the helper in KVM guest_memfd code (the
>> primary reason why we introduce the helper), so depending on when this series is
>> ready it will just remove that user as well, or we'll need some coordination
>> between trees.
> 
> Yes, I could supply an alternate alternate version, providing an empty
> stub for lru_cache_drain_for_folio(), so Ackerley's and my series can
> proceed (or not) independently. Later. But at present your patch or
> patches seem to be in both mm.git and Ackerley's series (17/46),
> but not yet in Linus's tree.

They are in mm-stable, so they should go upstream this week. Anyhow, that's all
stuff that's easily resolved later.

-- 
Cheers,

David

