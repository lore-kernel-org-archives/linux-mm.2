Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E6ACEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E128E000A; Mon, 17 Nov 2025 11:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E7C8E0002; Mon, 17 Nov 2025 11:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8447A8E000A; Mon, 17 Nov 2025 11:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7136D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:53:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 267CDB7273
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:53:52 +0000 (UTC)
X-FDA: 84120695904.26.346361C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5B1944000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:53:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=auYCSxxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763398430; a=rsa-sha256;
	cv=none;
	b=aMtZ2wuUWxzdFPyfetlFlDi1GxG01wrZAIiix/Fb41G+aNK0fOmKkFh8clfOaZ5aaZpILV
	Bk/n+0cgnmoiBZHEbIcdTZJPZ/P6Bia8VGMO8AntxMH2jIuAtLWMpO488gpyRiH4aueT3u
	J3Qh63CM5xFXYl1SiPM0CikJ01jg0hw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=auYCSxxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763398430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjBcC8MJ5ncNRd+FxyETkJed/HhN2WH8VIoZ1KVckmI=;
	b=q0CG6S5VsSBMzuvlZeiLDBWsABfesFU4O2wsEXztKngPoPrj4zyIfFhlx9q/j26AE005Dn
	37BvxCfSK1C9L7zCRKdM14v6QFYSFEQ1ejWtXG6mZNuaNTJkcrx6eshVw5IE36o4Uh455x
	wuMgSHbUCqmLGOEp/41I4iVAuqXy+Ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 504284062C;
	Mon, 17 Nov 2025 16:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD96C4CEF1;
	Mon, 17 Nov 2025 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763398429;
	bh=xcaskcSeK6dNzaCv0moe8ATxJ9XohqfqvmJEObNmum4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=auYCSxxEolEdVdPP5hVqXRlt7AuV/UT6WrPa29QCtPBvB6LhWtxK/veNm59+tg6iq
	 rWqGh7NFp27ucHsHpE+PxOZC6j5PxVDjo5pOnD0QHkrYbGowV5ij7ERUBYhkkveU8s
	 Qzg6TBFQc+DUeNZ14jTGRDww4CnIYZTFis12VZGpJEwzucgudCK3WO/qGAhAPMC7y/
	 uuneSx1mR/5L0/EYwLyIp6CPdn57YNuXiEoHNjZnllcUZGQFacQDKvwPIybR0ThFFp
	 q5NSzE8k0Nzvt6Mn+oVgHtGvj1wYQsVXpn4r7yvTJbgDFs0FNmoLC3DfEgh3t0L6cE
	 NX3xoTtWTQtMg==
Message-ID: <83e88171-54cb-4112-a344-f6a7d7f13784@kernel.org>
Date: Mon, 17 Nov 2025 17:53:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] enable PT_RECLAIM on all 64-bit architectures
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B1944000A
X-Stat-Signature: 15cihy1w6yqi87kodsij6ntsujowr3sg
X-Rspam-User: 
X-HE-Tag: 1763398430-612236
X-HE-Meta: U2FsdGVkX19JF005p3oYUPFCKg2mljfx5hnd5Ly5nk7BTD2HAYT4d7i8D5BOmDtRcsR6jH5juWb/dxE6q15hsr6m018eWTFD6SFqRevxGEMxZdLxD4C9mZOIMu0CXcIxXoQhpyzkdxdbqV8+VNGLnk5M7lgZPCnZxFbmwPdtEWta5zigu6HMN3UkEAHFWso1LBK/yqnCzWyYK5N46+jdhsCjnkYxkIXrdD5tF9/aZC+vPDAt7wA/uTuwTKKNUjjnAIbKJuSFqjv8s3fy3/rTvXmXeQST5XRjfmdL9Sp83C5CXPiCV3ywYl38MV3XTOQFYmQi0U5AWpU6Ou8dX4SPavN1qnDLB+Qhzv7jpSmraK49F+gWjSbe00VO33D9QEA3kZiVg2m07N1bf+0+/ScPhmOEwgjHWL9+XXa1DhWa/KyNjYk9VJI9t9kp8diPtLsAWvh4UNCiuph5o/t5Mayx4tDAdX6WBOdLE29mdumCHQzW57G4/85r3wr4smB9hsWGDbBiAGyx7IvQndmMg96dfG4XoRk8EDvh7X0lE15uwQL1r5O/dOe82gn6FX9EZBB0O/y0tg6huLkqWHD0gDTYPt4ylTD1LBnDpQR8xskzPn0+3/EmAAQ0lR90fKZJ1+RB8nozqMwvTMc3fnF5d6YgB6rIel8V2KQlFxkUYgevusAcySWGQF6FkF/fYKNej9bptDJdh1dWB4GKoR6ZdWaqqqwxY5e7Y/S4Pw7G+z2GhkQJRnJld3DPVmnioASPIkKdeHAT1zZIhAncPgeOiRBckin7INFWOFd1s3DSBZNnU4Mx+4Ci3e5cj/XvDb6BinUKW1guFoUjRnp5ySiVvQFq+/WLBNNAiMLuCg5dDuoZpXHKJKCWLhLl/mFVwCgp6FLtsB6i4vhhyE2iFhmdjYKpKZWzipbvFqxq4cQ5PdOsKOOCDRt2b9IeVlN5piaeKahqKEPmu+o6GVAlK98GZUF
 zyvRS9YK
 koU+RLIbjtV+nBTQJGrXaDHOK5eDGEZO0KDv4Y2DwLu/ZIyrV7DSyM8JMXpdAJEJAhtEx+9NZX6SVr8Hfp6+kNZ0iyBMZyDIIrdBrbKwDdSVVnajFp8J/hWt7HrO4OViiThrUbJ8R68JOLGjNeg4x07qyqawltHtJUIBhV5vxaYdUmql9ichxmyGqI4DuknROovf5NfSn1Nj+WJ/ayUkjmg+zeGvKLM52BVe7GIoyp8jMHYwWVbfIDQ4kdbtTwI+3Jxo4KJNRYWpbCPUqNSIAHVzyWFsHfwgvwlNlPj9KiWVVt42AfYfKStataaPOfgrzw59xqeIYDzDnfxr5RHpVtfMv3o9gOPsF+A1V90Tz2RtTp0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 12:11, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 
> This series aims to enable PT_RECLAIM on all 64-bit architectures.
> 
> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of empty PTE
> page table pages (such as 100GB+). To resolve this problem, we need to enable
> PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.
> 

Makes sense!

> Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all 64-bit
> architectures, and finally makes PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE
> && 64BIT. This way, PT_RECLAIM can be enabled by default on all 64-bit
> architectures.

Could we then even go ahead and stop making PT_RECLAIM user-selectable?

-- 
Cheers

David

