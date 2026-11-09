Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1885B606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CdZ/Cvkr
Received: by kanga.kvack.org (Postfix)
	id 31B356B00EF; Mon,  9 Nov 2026 09:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2546B05B0; Mon,  9 Nov 2026 09:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BF66B05B3; Mon,  9 Nov 2026 09:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56CF6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:01:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7838FA8138
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:01:38 +0000 (UTC)
X-FDA: 85415743476.30.8B9E972
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A408FA001C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:01:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CdZ/Cvkr";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794232896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBa/P2Hn1G1AAcH5rTB5EEXlvsWzy0r8UioG7AFjED0=;
	b=18H0QfvPCwcI1logCpVtFxuUNvpDh1RPk84/WAohUXaMy5LAdP//+cH/Ez63qDTaKjL3vf
	Pe3GN2GDbCpgqIelXt3w7KMNHX7DqPHWZ4pdkptc6byhslXYXqGuXZH39N8tbDqBVdMw9A
	Xaogu8KYgWZAksGunUiEw0hXeAp084U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794232896;
	b=YKk46aNN3ujB+qVHZ64AwtkUNRPpKIDNSQXd4jOCWl71ThP2wMMBMoK/nqy4FM4HB4yctk
	Vk8on0CzFQm5hPKd9KPV+ldnbSe1IDuLfRcpIhOXzy/RW5NWJOwjxA7uMvYijc8KKRh8Uq
	1fJEw+ENUC3OXwvKbEM81Zo1QroLxdY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CdZ/Cvkr";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 235AC618B3;
	Mon,  9 Nov 2026 14:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D321F0089F;
	Mon,  9 Nov 2026 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232895;
	bh=WBa/P2Hn1G1AAcH5rTB5EEXlvsWzy0r8UioG7AFjED0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CdZ/Cvkra7opLZYJNiSlo0fgWJuimpbJ7qpbNjAgFiNc1j0OO21mxfq8JgwmVOsCt
	 k4bLCivYZrcFgv+truIgIUHM1bm8tR3zuqFt+DdYAWQTHqfyWtWhhltIOYiMy3TSaa
	 CtRCcsw17zG69xtwy2ebFSDYdymU4x2i/PerH6oWYlCQ19IGoTQH08Djzcf3Tn9JbF
	 s+2tM8HRMBkFLZOIdRSW2PNboOilsFVl8RGO2gcRH4m2RkLlS5eVR6npSG57D2fwN8
	 faXNQaGPBLIQI+CEmqB/mfYpbz1a+qXOpPXajDQ/CWn+z615J2XoE9Av2ilSzj8PYx
	 x+ebCZCSY2nNw==
Message-ID: <8ffe5804-a8a1-4486-b5eb-7ce5f451b77c@kernel.org>
Date: Mon, 9 Nov 2026 15:01:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au3CUJO9zBMHLx-B@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A408FA001C
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ngjf5rnzm5n7nxeuktg7b8o5kwdisxiw
X-Rspam-User: 
X-HE-Tag: 1794232896-695873
X-HE-Meta: U2FsdGVkX18jFdinVqeduDpZdzW/48idfHw7hOr8TpJ2E/v7kdX976UoNAX33G2qjTUv6cIuy3FfZrHBVcYGKAjGcPmibklLEMM9InjqaNeeamV5wzx5jZ7gy8bB1reSN42LM8JVCGTdd0gP0uPxl9pGR8HV5XyuDqxNuQUed6HINPvAbkzdadneUhZFuK+5569bf7W84867ILSneuKW2dZTlP5P/V+EG+AweLgd/HEna2+TbMDxttDbyyyDrcnKXwLeBTZ+R7iluu5lNP4uwIcsCURPs84/8Ws/erB09v/0qHR8F9m3lUYLcyA9RQxo7WKHALxArv/Qv6bkmEZSZbc98ux6tDIA42U2rgCFG5r5N3FyMXR815Li64/ogYKmeG2JjremJkzj4dkHKnb1FCYs4nVFWAAtQGcKuCXQIPhH4jPBxn7ZrM9HKb78W9i+jEN6bnkZVdDLmjdxQC2khBpirpJHqxJrPJSfRe4DxLcnSS52dTYfvy34NVK9PiaCfxeIEqdJuxLfi97AxnhxcAsGLz9RQzntP9gk2KEsgapyffQ1iG4P9SVLvoLl1SaHfhit2Jou6uq952+j4sc6KEcuPAOFFJ5ij9ziu+5cqy+0OTT/jf2/OSLKk5zHPXJF5XN14qWA04M5Z3QFlL47a4Lgt8635i6V7WeCoo/s82I2fcD7Dv1Tx9pZgpMK/BKvfOYHrhNtYvWQBinaosiSufBgxKceZHqTJxVxDXjac0uFkSFWa6bbOcIF1Abi3KyC7DyXr4STsJmL2P2uQlM1IZCU4CBUVs6GGC2RvrDZuZbmiM65tsADYdNuZSuPbf4VuyF+0qN3zbkhReeIgjBmCSeREwtdMHu80dwSPWFxN6MHlHo3myc2CtxC7pi0/yh/v8i7WmDREqOMIuo0jhBSH30vNfgMtE7jXmIbrE5GAhWXxyJQlFOedHFU0vCvAVUlGF0O1fl9p/PZEVptbLU
 5fohZfi0
 fsay9bmED5rthkLmgbgGIOFqgsg/aj/U0T4eotssNSNpQ7K/mInF7taHSFT6BsQK3Eaqe45LmVwHcVNEBTBpoF9NTj8gX8gyMXeRFwr03x4kQl4Zm49F0f1TPr+LjtRJGiQwth0k6X2i5Y7IxyGyJn2+ttMmNsn9bsS6k7A3ha2yTWp4Qb7tZPRqOVvV9A2Wf+ImXv8iAFwa8mACD75JkmSshyC8AClFdPJbDYh9g4IZ5cAGD6vMx7QYxObzC/kQO0Eeb6NXjig/DRKCEwSy2sWyG9oHj9RsXzk/N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 13:07, Lorenzo Stoakes (ARM) wrote:
> On reflection, I think this would be better implemented as something like:
> 
> static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> {
> 	unsigned int long lock_start = jiffies;
> 	...
>   	for_each_vma(vmi, vma) {
> 		...
>                 if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
>                         mmap_read_unlock(mm);
>                         cond_resched();
>                         mmap_read_lock(mm);
>                         lock_start = jiffies;
>                         vma_iter_set(&vmi, mm_slot->address);
>                         continue;
>                 }
> 	}
> }
> 
> Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
> on HZ), which is a long time in the kernel to hold a lock, AND the lock is
> contended, we drop/reacquire.

That approach indeed sounds better to me regarding lock contention.

-- 
Cheers,

David

