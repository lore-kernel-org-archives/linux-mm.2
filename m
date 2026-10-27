Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFBA606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hc95gwYr
Received: by kanga.kvack.org (Postfix)
	id 9DEA26B06A5; Tue, 27 Oct 2026 06:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6A86B06A7; Tue, 27 Oct 2026 06:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2916B06A8; Tue, 27 Oct 2026 06:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668146B06A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:55:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E74501209FD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:55:36 +0000 (UTC)
X-FDA: 85368100272.20.562F697
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1918CC000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:55:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hc95gwYr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793098535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKbxYvklE+RtW/4px6T7qZCglKItX3GKgrMwqEp3qDw=;
	b=ueEo+6NX514uHISGUBqcoTU2Y53gt5gTYAIuCuuZCDu2g5VX/gwAplMIQGkVwronrFCNya
	7wN7AaSpE7e1eTkQXw/rKnlrpvWGE1dhn2bRhwhfskSpnvfMye0sNQPxz5XhSstFvOCDMy
	ew96QZ+uXdkDw789/oRIV9kDf4sNKRg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hc95gwYr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793098535;
	b=p5zkY/UICMBzRSZ/6LSkvKjnNiI0fJ4ro/8yxKrRIVdeN83ugcQcrUbsWYamRTNl75JcGG
	/2EPvKbpcAEP/Arx52fYQaOG95/w8qqWeKX1aud5nex+HiJKAer5Jw6WWSYvePhk0jP36K
	oZY724zrRPLcSXPb5teUz1BiqMob3rE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D800615A1;
	Tue, 27 Oct 2026 03:55:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E00023F59E;
	Tue, 27 Oct 2026 03:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793098533; bh=2KWWEm3YGgOg7VXROLDs0BaAsOc3yp6g0LrHlJpAeJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hc95gwYr4hlRyW/o5zs0jyhfOGs74Do+ch0sJPW5V5HxppF6ribgfdRKL5l+Ph1qM
	 divMRR/TWoxxKhidxaYV5/bLcdzmWWzi7zrZ3SsmUbA2ws9BGJeDnbCnPVa+mkE9Qm
	 v0KvihGVOgmtbN05Kl4GX9PpZb6J8aJNpWqTJH9I=
Date: Tue, 27 Oct 2026 10:55:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	andreyknvl@gmail.com, vincenzo.frascino@arm.com,
	odys.yuan@gmail.com, sashiko-bot@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: untag addresses when querying page nodes
Message-ID: <auCDIcgPP2tKq32y@arm.com>
References: <20261026195330.46757-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026195330.46757-1-dennylin0707@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1918CC000B
X-Stat-Signature: h465f1mnnxohdfo48if19kx44fkayswb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793098534-808208
X-HE-Meta: U2FsdGVkX193s2fILfwJtEVmG+DZIm1dvIX3HggAVxI4toyO+gbiXuHkaxdMxMl3dheESHe2B06UdmGHN4gB5qIJKDkwDwy7feIPJ0NXgDTW31SYkd45QK6Sa9kXmpDEZNolXqgaey9rIivxHIezsUdrMo0HxYH+BrIFf4rgGt1UOPASb+9qj6zv0H2HZf2UlwckYBTbDCY8e2//g9umKg+amu9FtwkvH8T+sKB2yHJ6wCxuLGrkz7U8ioJoo4/RuLGMAPM4cXSzrndrDP+XW0HL/nhdyld9mW5OdMqaNox39melAlNNnq/LJSNbA6u8zZYTqTMdd173oIHL0rJPFVEY5lf5VjOpo14VI5uSPwZJa3HHBoH1d/ujI2IQcLAykbboYadSg3XvMnndf763L7mRtJ+vaRXSHnJEinTeW0uEJoCSMBMy3Udcn8/ZBEN7IwTko2+SPIqtZJVWKajZepjwx5qdsGyU9qGPUmdg6Aa0C6GR8+jNf0PgFMIcM/VW2S1il32nWTy9NMqeFEKvHC5VlBbslrIavDYGlWFs/2wi8l6u9I7byH7naWKwhJOgilGrEZq2JH7o6Zkiv+E4USYlVZnFvKJ/L9KQrRifDKs80DARWlvfTBQgfsLicMa7J7dSrJUMGpSgVjo7dIntdJTNyEYbR6gE6lRDqtfFGcEtPO0Sv6e3bqA6noGJE7s8fRZ4WfPqDID5rffXPnr7kFWbLdPbgdKYiOo5gWW0XS5yiyyQLy2Kk45bKlMaBHAW85yI0Sw4LES7vNCjn6U7HL1t5ii9+3GCoDckshVQpviV3z21p9TnQfrO3urHE2EfFSlq3S9HiFYS7pB2UDbx8gvyU2tB0AA+rRF20Swka5QiDQfCDeY7OSMgl9YxJ48rHg9/XtCPv22sUa8Tzqpf2cxHUuzzm4q4jp9sbgszjjTtkLpE7NNcJEE2f7kQRqcrYPUdSpYWHghesEum7jU
 JepUnjV0
 pBw9caQmuSZ+c0V3IbqBG/vwavJoIr/gipmB/0h3jNFQ9G0smt28JQ9j536E759kefgcXpFB7+wmDfCmcxmmMm4zAIsSjxyLPgiEOYV5MUY4rvQObCf93sekQBpgzz5Pmo8s3uxUNADSswQvlLQKF2AQfdByOrf6A7D6HwgV8qhZkJ1F11zgWNaSI0ZSLdDYocvJraP4XHj1lTr8X6oFaPeOl9vLqt4vbud0JzB3KejjClKfVUxdvvQZd/z9Iew2u0XP5hs+e1CbjRuNlAGgkagfojXT28X9PAb2h+7xTDHrRQHxd6gCgMW1zxGyu9EsweDTUWUYegW3B3NRDWmfFNIZacV5PsCvQu7+xyNQ4AZiKks5Z3YRlbOmYy3fdna9RNErCdFENv7qPlGAiNm8sTd7WV7ddSRKvpHandssNG/kk33DdLid98Cp+BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 07:53:29PM +0000, Hungyu Lin wrote:
> When move_pages() is used with nodes == NULL, do_pages_stat_array()
> passes each page address directly to vma_lookup(). A valid tagged address
> therefore fails the VMA lookup and gets -EFAULT in its status entry,
> instead of the node reported for the corresponding untagged address.
> 
> The tagged address ABI permits these pointers, and the migration path
> already removes their tags. Apply the target mm's untagging rules to
> the query path as well, while holding its mmap read lock.
> 
> Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

