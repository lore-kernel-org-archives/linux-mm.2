Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1A0606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A64igOFw
Received: by kanga.kvack.org (Postfix)
	id D887E6B05B0; Sat,  7 Nov 2026 14:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D397F6B05B1; Sat,  7 Nov 2026 14:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B5C6B05B2; Sat,  7 Nov 2026 14:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1B36B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:07:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26A281603F6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:07:07 +0000 (UTC)
X-FDA: 85409255694.13.23D8F8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C78780006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:07:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A64igOFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794078425;
	b=wN+LhX+HoNj6LVX5lUC0/viD3wNNM8Ldx5sVrIjkBBCM9jreKf+nQ7/J8mSELY2sAKYIcG
	1RHcL6jG19UhzyZycxjw8fBwP/ufqlr5/WIB9vfPjl3wBiBAQBV8mILYr9EZ105YsCtFvS
	HiDEUEPYNrdcgVeTvE8f8p5xp2pk+JU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794078425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsOyfRfBmQLZMCYUcyY/AIK19SXpwuq2A2xY3kassHk=;
	b=LyDlxXDezukFFYQeDNGG71JFIS28owKNarlESYhyBRlqupZcyoMYm8B2C191yaN6q1lt90
	MjzC7FHp1vCblK8Kj4v3p36gA9XZuFweSshlELlvVDq1aiYnI/BgkFANo9fU6PerZFQpoH
	1zkoxImuBTSfT04BfubBNx/oY14ca1w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A64igOFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA8F60F2C;
	Sat,  7 Nov 2026 19:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1951F1F008A5;
	Sat,  7 Nov 2026 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794078424;
	bh=NsOyfRfBmQLZMCYUcyY/AIK19SXpwuq2A2xY3kassHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A64igOFwwlaHwrsyjLb2iScVGu6goG4rZSi2BRJvofB7goIXME3AxDejLUxdzVtPJ
	 G9xmD2LDUWBgaPmOupudbhKYypx8YdjHMXRfaAQ+KGUc35wkYLTszvxE3IxprqOYeq
	 DOrCwd1i6kQyHFwLNmOLS1TrnANHs18dIMmMkVsRNWdcJQ692bBHj5nJGirbP/xQnf
	 BH5clHynS3NLAiDOdEgQsHA3MVjlsJI2zgI7x6SgDz3FqIZ4h9utDRA0TvWTBqId7K
	 AidknTkNeA9Vi04tY4gj19LeCb2uiBaU1umnfFWPYzPyQItyEx+E16xy8amemcbh5a
	 jsVHBDg977fqA==
Message-ID: <a712518e-e094-474a-b7c3-bb9723917960@kernel.org>
Date: Sat, 7 Nov 2026 20:06:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 xu.xin@linux.dev, chengming.zhou@linux.dev, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 kees@kernel.org, ziy@nvidia.com, gourry@gourry.net,
 anthony.yznaga@oracle.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106013906.2229780-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6C78780006
X-Rspamd-Server: rspam12
X-Stat-Signature: 54aixzjrxkfifft1y1k57pedepgusp6z
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794078425-252842
X-HE-Meta: U2FsdGVkX1/YnGeFATO70vsZkFgLi38c/fZngC/OSVTCupMLC4NqEQsbbe55UyN8XeZfufsx6UaNec0cRtWW/yRdYM40Bf+N4YaMGU6N6aonHPhuGXjfM/1vlbQTbnbKlCf15GuW91NewC2lxKkczFEpkiW2aY64AogWSJfzdCudHPBfx+r9Nkyo/z4FQQtubY+qgGtjarWKv4ij4IYfaIUzsLC6qsTmVab4Pf1Ps2P3d5VcMxgR4nPMsVY3WJR/EFv63WvCxRlkbVy7GxUrKhC+oA7mIIsouy3GuYNMEu69W+XYMrOoFQfeUSTPm15S9Dkm6/ZPMtdFC+L6ev+MPrAamDRYVq6LqR/NiMBDxrm0cqDrl+rEFxZbpcETDfEnZZceZE6DJNc9FQOlZ/AcxsqhRx5eau2Q3qZkMNHVjznuTH88LsNiDYIRoXl0WiC44XgG/X448OyDBBEXfLkQw3/iISmFg6fWGN3yVK4F/xGaTtWRhmf5ZOzGbh0RVGnFOaK2MjoqSHlr91ypdRVURZEYS3L5zi5HRD2JqVbqPN6pF0rDLlnbpT9eIaNx+GOtwhly5YciQMi6l1D1KCtGkjKwIGEROX0geCF/qmywBiz/v50Ps+IBy8+zcD6OfJMo586oxdMB3k3NC9mirPEbwGq+thIc3ns4BdaL+pPqDugOcYiuHoswzuGSUDZxA4uzrDQyPho0qh5xFY/mUbuQm/9Eskdvl/oCylm3RJTOcedOzG7ljUrIuHpyl6OoF06NKiq2RGbz6n+oCPf8d/ZhLL/fFoVKmZsskfMB6s1YbufXJAeEWgeBRcdLe4xM2IQqTDU139zg+90dc446Or+/Zg0q72sI+ms1XjBsK+rrHq1GbGVCPRHbr5AXKhWwZDsc+6y0bd/5VN3ik1KuuWg4l/3d8N35taVZCE9czBoIx8YFFKFEnbuzHLCcH3a4ehguGd/s9H38var9Iv9ONYy
 EhppfbH7
 Mh4IAL7sjuAQZfqWwCJQEUZ/HmExqpTIXcDMeLwlnuLokrSDohEy/KvCcyhI3jperpynIp3/BXm/6F/B1nVWbCaorAq6S3uX31Mtc+YHRedNyEiEJpBGx/yVrN2uWw3eT894vqFIwvfvVY6PkffKaMZZwFlWR8zT4/Arhaz0SQlIQYwXPI/tul2ksnxoN2TUZOX1cuQ2tg9o/e6mCe2dx52xWCm+9svMu9zEeAzLBHL7u2Nzccf7tmG+L+ei8yg5bB7tAGMmCWMnoBAwjP7j9QQQsylZNwOcbIiMrktlmLPfN8YnihTc7RSz762dpbBPRwFtIToe0oXIZNgoYo+F068PX/d21lxR2141pZEjvKEdwPcYZYNuyKRqrSbmKPC6xMlJQXnr+USFvM/XNF06GGNeL0us8OugDH20ZuKS7L88fTeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 02:39, Jinjiang Tu wrote:
> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
> again when the mm is ksmd's current scan cursor, leading to deadlock.
> 
> The early registration is no longer needed after commit 590c03ca6a3f
> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
> calls __ksm_enter() when the first mergeable VMA is created. Remove
> ksm_execve() and its stubs.

I assume you mean the

} else if (mm_slot) {
	mmap_write_lock(mm);
	mmap_write_unlock(mm);
}

Can that actually trigger?

IOW, can we have an slot, and the slot can already have a mm_slot->rmap_list?

-- 
Cheers,

David

