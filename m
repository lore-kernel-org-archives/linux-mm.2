Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 810B2CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E869A6B0095; Fri, 22 May 2026 06:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FDD6B0096; Fri, 22 May 2026 06:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74F36B0098; Fri, 22 May 2026 06:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA9046B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:43:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70B77120900
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:43:09 +0000 (UTC)
X-FDA: 84794718498.08.C7A36DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F05B14000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:43:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1qNWdO1;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446587; a=rsa-sha256;
	cv=none;
	b=PMYZKPrbw7lFkEbmLjXseGLj0T/stdAUC6UjfrPliyY/3b8xUgiwW5RtgZgE8vPaep20Wf
	xNBJtTOJyaMs1Jx0Es6YmVR/nEBahp+xGiDEcVvAm7l4VSQgTlQfPUvvyKVZolSEmMSeK+
	FalxWNmFT6OJvnySzXwc2ieS/jBx+Uc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1qNWdO1;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YTLOARiRwWk8QNejm59jNXoVMaiSI2DNwIVg4xY6GI=;
	b=nZwD5Uc+qp75iBfD9CEzbVvZ/AAuc/Es1rXu/dlcBQXD3zvIOjsww6AZdwUUW/LwFUjQgD
	+hP9lJF8Yclh3Mx7VIqXtkEn1y56Cc0rqQ3V9B5Xf4S1DgR887hjBhtK1KVO/gvwhO80up
	sE+55tAkCFez+mqPaLyyCtfvUUaD4ZM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CB9A26BC;
	Fri, 22 May 2026 03:43:01 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8013F3F85F;
	Fri, 22 May 2026 03:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779446586; bh=49ERVB42HbkzceUNDuiP0n4teSxNaWaUsT8J9PiFBJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1qNWdO1SmfjrQQ0lb2yVnJDiMBnyUxUuurt3x2TqS+jPAIpxjgjR37proU0VrQI7
	 yhEAc0n648oP4KiXgGRQ5RveySpxd1jY7QX7ErqNVvWx/sbVbTfrglaYEeGhN57oAi
	 fe20E8ILDxz3vz1Q63o39pebv6lu5c20hDthXK30=
From: Catalin Marinas <catalin.marinas@arm.com>
To: will@kernel.org,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	aneesh.kumar@kernel.org,
	peterz@infradead.org,
	Zeng Heng <zengheng@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Date: Fri, 22 May 2026 11:42:58 +0100
Message-ID: <177944657885.252010.9796978866224637120.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521073011.4121277-1-zengheng@huaweicloud.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F05B14000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 4m61gcocksxcnmc1tosipt9jzsbe1tp5
X-HE-Tag: 1779446587-407422
X-HE-Meta: U2FsdGVkX18A3Ie2x1g7TRbo53KcTZc0HyntqCKL9TuICsPzEQarzgJCRuGTTUXzAXAPLh7kUPvVpdBVzWnq61897fExpeuTXTloASLQ+27boKoNrq+chQweJgtQLvGmydYObjdDn3nLAE3TzdKKznKaQqk7oVVtJMeOUgNLxRHzK4vVMuagXDgF4MUAwXclRVXs7hoa0HraHTzDKJIrHGbyZAb0pVCJm3RiIwGn/1alYGxQLnfZt7wNC8tan9TBeCdch6rgV4hFREt1gp3I1YT6loEHHZFoaiSO4FK0gV3jnymIcGFlzYxXQHxqZuPi+mZytm0UHS5t0BxcIz/XW5GDsuYfqBfGoVMPgYqpPV75zTw9eGN2e+2GLJom3TmZiSoqom6F2D4A7cc/jeT6PYcqVl3m539B0HECoVr+2L/V2d9pq1IJJfkWWtvjN0l7U1S9zGEwqzCC3JwfZ0Dk5MkuQDztXEk9Nk6QQ27eaq4pqFXHi0GAsgzCKCWGHkoq4KeKIq1h1Ly0ThEsiio/wSoLOucM/5FZpWtXEVetLkbOeUFhr86utRt5x3da+UuENe5BiyVK5fqESiQZuWvsYUQPi73HnaW8AqyzFnF0/2kB1ZPsEy+miImBlsFbxIZzknjpi572CFqNgoz6ufaCx60SBIjLEqCkAUtZcaXDtjFLoplzch+0E3Cve8/3zSUOHw3hzvPBrit8EG+bGTyu0y88TOO9BHy0QAUuCO7jWJYaI93qucG9OGIaLhMcXSxde0E+hZW6RMzzxJHw3fpK7VU0XpXGr3pPukGO7IJj2b0wQw6fqBOsIWia5oxo1VGu84UtoV+QQCggadKGfQZgJarLK7YQ7SJvYq8d0ExVyAncBUOOwWJi7GUatypK2S4GSiPZEZUjMzu+rl5Sffr9Ltz9feZ3tmaRMBl4jjqEGN5nwBrcOA5+tz/TLZI7xnMSpX2tfF2lpxDy/s29DsT
 p1Y43s0q
 09UumcEpYjYP3Z9JDgK7uikHlhKf6sQkNFpLdD5lZGSMrJb2o3249pmAoWtSTbtidFarPbm0MQBsyq/BshfP3qGKX0LURpNN6yKeVExIsEnhyvuJ3Vd3Drb+c63HjUPz374a9BXcoNuUV+48S/pc8eScBKNALqd2F7iMQQx1ispDh+Ad7YZF96q3ilnwZuJcwCF3HjVK5gL1L/4jCpWkqatT31A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 15:30:11 +0800, Zeng Heng wrote:
> When huge_pmd_unshare() is called to unshare a PMD table, the
> tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> but the aarch64 tlb_flush() only checked tlb->freed_tables to
> determine whether to use TLBF_NONE (vae1is, invalidates walk
> cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> 
> This caused the stale PMD page table entry to remain in the walk cache
> after unshare, potentially leading to incorrect page table walks.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: tlb: Flush walk cache when unsharing PMD tables
      https://git.kernel.org/arm64/c/c2ff4764e03e

