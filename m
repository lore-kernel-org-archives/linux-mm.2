Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECCD606B389
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XG5g/nm+
Received: by kanga.kvack.org (Postfix)
	id D6AC76B05C5; Thu, 12 Nov 2026 03:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C546B05C6; Thu, 12 Nov 2026 03:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31CA6B05C7; Thu, 12 Nov 2026 03:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2416B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:33:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BF83120523
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:33:10 +0000 (UTC)
X-FDA: 85425802140.01.BF05A78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F551C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:33:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XG5g/nm+";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472388;
	b=PNC67/5vbw1phmORlh53VDhPv4zloVe/TFMEB3dEjUwz2RZrgTHgEm3jifofpu1A3fRHZx
	9dQNyHKkoAr73ZDriiaBTDmjZKh/oxATZfyVVcnJD7Kpp5nnGG1VYPjGHY0MI4H/QZt331
	c+EKan4hvAHA+cYYGpgtNFUyR/HIc0s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XG5g/nm+";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHiIDa6cL/vpsXtyC/9ShVCBR8lPrdKhQ+5jGKW/U9k=;
	b=Fq1NtLcCHySd2FX0u6o7igCy65y2Z7Jmr0RR7MUIjvuSUnocxi3WOywdykdf/uHxrJpUSX
	4+wsNnYN2wEtPXWEViOoNwgNmDNQZkb4Ip0t5YcXPBVrl0RRwJ75pA74fi5qmZ3fBhx9Gy
	OWzp9oc+dnPym6AG0135ULGu6qOHcLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBE7D47901;
	Thu, 12 Nov 2026 08:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2451F00A05;
	Thu, 12 Nov 2026 08:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472386;
	bh=wHiIDa6cL/vpsXtyC/9ShVCBR8lPrdKhQ+5jGKW/U9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XG5g/nm+K513+nhn+5OndsG9mSGbSKzvtgyM6i/B1s7gs6BBtrMqbTQEB4nsUsb8Y
	 oQBiqPksMq2HIM1slpfSCtELJa+h1P9qduLsmng/X+fuofsa/4TxFbTx0cExrAvgN0
	 4TTPv5gaIf8qxki3ZocDSc0+llOvkYB7jVhO9XIdEtTU94MxWL1KPtuaXY4iuOgdz8
	 RKNT/l5phTCXxGIXrMq6E0/2HZxwWuVJkRbC4XUORQ7Tzce4iD8P5Nbm8wSMdxKQf7
	 f9Ov7BH49eJmcxU3WAtmhyUDUb/GRsfdxvJdFck11FIyh5fa3qVOAV3bQmQfuoeGC6
	 I2uEMwAG3Da3g==
Message-ID: <8fb62131-db10-491c-9839-a3835d7aaf32@kernel.org>
Date: Thu, 12 Nov 2026 09:33:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: drop the second folio batch from
 shmem_undo_range()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Qiliang Yuan <qiliang.yuan@linux.dev>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 Qiliang Yuan <odys.yuan@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 kernel test robot <lkp@intel.com>
References: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
 <787a1ba3-df93-45f9-abe1-3fcdefbe41cc@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <787a1ba3-df93-45f9-abe1-3fcdefbe41cc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cgh3k8mpegzk1q6dhqybztewuibmzya3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F551C0004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794472388-718594
X-HE-Meta: U2FsdGVkX1/Kfg64SYAvYVy4iDNVQ8UGucr5qjffO0C/lZLzdQeFFgrVbOVoFOqvM7pQq2a2sP0gk3IfEtCes24gvHtI91dZOrVYM3NH/bX0F1QXL80CWQLTLGk2vg/W03d3Mvpl4808YosHqralEk+86dD6FyGyBe9HR9Yde5yiRcms8zF6xwhP3ZVZbupnxyP51ARVD+2+evTv0zaCc4SQrOQUW2PIQGlOrb9CNeh/xb1hmw/6ssDaRI8S48u+3757CEmzsQNVlCJAVFMQ5rQtnOBn3mIiovVP/jx1XGXQjIUicbrlhRFdeoClrBqYCdyihgKlnp6sFqKVa/aY/mwSiKpg2pSu61qSronMj4MYcacWv/LL6pubuBqjTagufr2vhrJZurfGv7TT9QMvTomf77y2/36NFAPuXcGSV+yt8AIm316Ienw6sabYepOB6ZSs+h5z2xmJYrPVQNj6/h01Nup5YlZCaOEo90osa0tvmya1e8por73jFm2DfZdChjbqLjsM7i4YrqjKamv8o3QDNaLCfRat1EO5yal3lptKEZmE7K/YAJ3eewRmdijvz/eychdinceZZtgj/uJqROSF0pZ/+qrGlbaKQLmPpbgwcvGaGxgPSzHAcoaub3xIdo4KHTaV50SU8k8wPTh2WFJ9qOQrFEbm1vPifN3Y5h/VJI7B+FLPUoHRzG1PQ+Z5xHCdUcOUTVc9CCjCdAFvahPT7SU+mJLM5y72WMNW6gKWVRyPi0GQYzUizUb7lLv3xXlP9x/eb0ho/+6+cUvVEsNSN5mdVUy4y6J04Z8nkpLn7fnWIVWAXfdfICktoqydy7C9zKIhe26pTqZY15OZKAppHJhdx4qudj3x7W+V86oIKw1lIS6GaWMsfxFjNwOKHdnO9vFwRhafjO098Xc9F4wwjJdC6MuW+IgSyE8JpOZqKmDfYM5hCsS0Ivd9dAU4tEJQsyeKzK6rBouptqt
 vSZsTtMw
 vwYT7b7eVwoP44zlHoelQR0N8tqPp1tUaNR9s1EnbKiYwPZfkHvYvu+mp/UiJFnJLyEV0XEKXtP2EcZmh3+wN1eyupi5Tcclly7f25jmQKWl0aFNKrxaMMdkxoCS3YsKOHIhqOPK5RuyHh6+JJc1o16a+RPotFMuylM1V2QdUC038b8XKS9r5PSHyN2VZK1iFxGfwUOyNsqSxoWseWsBavtszesM09GkErr6gMoYIt7a84lL3toEZEJklJBrTVZ2iCXLEc+NJPtBEIJ4F4ngrC77g/9JoaBs1/lo070Adzqt6teh/jnEQRQxXdiqeLXAjQqelxbGN+Qwn0lOyuBfxWtlMcEAkVTB5jjQ38oBa14jt69qVshV2m9rFjeuCBKoyM1AKtA2agnyBMK04iHwEnaWwhqkngYKdxA6KJQ+/FJ2v95XfB2chZIlMHB13J5ANv45gyqQ2rN0Zx0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 09:05, Baolin Wang wrote:
> 
> 
> On 11/12/26 11:39 AM, Qiliang Yuan wrote:
>> shmem_undo_range() keeps a folio_batch and an array of FOLIO_BATCH_SIZE
>> indices on its stack. Removing truncated folios from the page cache in
>> batches added a second folio_batch to collect the folios to delete.
>>
>> That grows the stack frame by about 200 bytes, past the 1024 byte limit
>> of mips eyeq6_defconfig built with clang.
>>
>> Pass fbatch itself to delete_from_page_cache_batch() once the swap
>> entries are gone, as truncate_inode_pages_range() does. Undoing a failed
>> fallocate() only removes the folios that are not uptodate, so remove
>> those one at a time with truncate_inode_folio() as before.
>>
>> Stack frame of shmem_undo_range() built with clang 18:
>>
>>    config                before (bytes)  after (bytes)  change
>>    mips eyeq6_defconfig             928            720    -22%
>>    x86_64                           920            712    -23%
>>
>> Fixes: b97fbd541ecba ("mm/shmem: remove truncated folios from the page cache
>> in batches")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202611112032.TMyPU6Rm-
>> lkp@intel.com/
>> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
>> ---
>> David, this applies on top of b97fbd541ecba in shmem-7.5.misc; please
>> fold it in if you prefer.
>> ---
> 
> I think you should send out a complete v2, and David could queue your new version.

Yes please. I'll drop the old patch from core.git. Should be gone later today.

-- 
Cheers,

David

