Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F053C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06276B00CB; Wed, 21 Jan 2026 22:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E857F6B00CD; Wed, 21 Jan 2026 22:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5CF6B00CE; Wed, 21 Jan 2026 22:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C803E6B00CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:54:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EB3C91A72
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:54:42 +0000 (UTC)
X-FDA: 84358233204.21.242ED71
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id B25E2A0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:54:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iBiWSJOE;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769054080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ji0CigumA7jfO9ppIET7zL2OUFQ+Uh5oYQd0iOYkPNM=;
	b=nX9AC2huw9KXeKiSSR/cxogYHvwf070yaE51rZ/Wb2/KL4Or1rCkrQIQJHrgvfuBLJQGrv
	Wuujb1P2nUKbVwVWaaxJR7coce2rJh2EktLu1HM2iuWr4JtQbJqiNdA6wgpnCBq49C9Tno
	ZPUIAFBlWlk6F1JkhZzKKsEXnTE6hWg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iBiWSJOE;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769054080; a=rsa-sha256;
	cv=none;
	b=uGyjhoIhInOiaf26RgQsXRWsY8n7/4WYOd3cHiRhnlSEzmQ6TbeMkt983TTysfAz2u/tG7
	hAyBsogh0TzIt/ntT3N/WBqcuj6bD/EFDuTGfO6YCqYt9fKMmJr+HSa9xejZRnhWUp/RUq
	MVPA9IHayrOXLktc2kuT71vNrNybjc8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769054078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji0CigumA7jfO9ppIET7zL2OUFQ+Uh5oYQd0iOYkPNM=;
	b=iBiWSJOElCJig6scRE+IEEvD2/hQIcBtsIFSHTrOZNRNk+kV6fLeA+5Yeb1NFnIhlSYWXe
	GjXZarukkNQAbzlmh8Uv8K06w58xTKNK6qXzREHFLZx87oydMw4ecE6xrnnsVLIZ3Mpq/f
	XSEFgusUPBi8lX8f5m9RbDnqEalBCKg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] hugetlb: increase hugepage reservations when using
 node-specific "hugepages=" cmdline
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260122035002.79958-1-lizhe.67@bytedance.com>
Date: Thu, 22 Jan 2026 11:53:59 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <460D009E-AC58-4AF2-AF43-A1C38570CDFB@linux.dev>
References: <20260122035002.79958-1-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B25E2A0003
X-Stat-Signature: ue8e1tin75py65m5o1rmfssw866byqf8
X-Rspam-User: 
X-HE-Tag: 1769054080-894799
X-HE-Meta: U2FsdGVkX1+zmuBHSMfwTTIyPuvBSy2uajtbO7i6MT7n3/Le+p1dO8wRJB7kMsjISc6LoXnduiV2NvRW/VdC7XI60P94XF8yu3oSDjWSCgn6rEexAQTzWL/KD+ddau8M/5zKEblkwcyTFex/5L9SWU+ugHKZsmv8pPnSjLuwbGs0BxxbUhwu/AbhnHztOPxB8uILzYlbuOVgBJPuDgKvXMS7UO2rc69dnrYGYgJsbkbZHlJiaOFNyZIDHz3CX4SVX72SOJJPMhkfdzjyLn5kfc0idmOg0ESVj9z4bKVA36RdM/y4iM8QOXSsW2PWwTP15SLQi5q0Ko0Hiuf0lvhM80mSg6NtAOOBtv5HvBTc31Aw1nBnlYPnZ/EJUcDvm+qHXDEp5l2/AL4IYRDH55OFxHl+qU+F0EC92d20Em6xFy3srEmyal/K+vw7Z/8c2wTQJQDWmtJ+Lcgqsq1/aMg4gx2Mg1Iej6qehB4VoxfQHQtmpcCslVsZfyWuLLuKwXYnU/GojnahPE7qiT9sg3C4JEjqpM/iKMBoTN5gFVdab3HeQyoZSHNMW5Uaruu3G91wf158c/yIT6ShAIdxZy9UWERr3JS65r0O0j2QyWfPSs0TjbT/SH7kt0jiQgyw8fP3eDjmont7JeWZHUzvDXYdD6fYZ1TgIjgE6cIi8AnDHsTxq5V/yKfm+j+inAYH91gXsmARtYVwRq6D+R2LwTzN1yaDynwjyOmVcBKFejS+1RvOZ8OjAK0ipX+2BkBT0xUji+aPMJIxISa9YsogjuWRZ9IpEbQ8nsR7B42wVD5QPPEXm8oCxY6AzK+TvgiG2vccnnLJSdI8R5GExFo3EDe5M226zxoHGEMa5Cv+Z1R7YVRhCXSsJ8NbiKFchU42ENMi06jZqesFATD2bq1kKVoGeICYhePjEz2vI7pXcEdohXQpa7R9EjDORGHEc+0e9p+XJSEcmQNQCEqeHWqqm5u
 CFWbH/vD
 aGr0ZykQQTnlfbFog9KMzStj67MymdcYnlopBESaOBF9gggZ13kzKRhlSjz839+FDfBm7w4frz6JGcFyP8zzJeipUOAkLfdkC/sVY3wrDKrSg+ovNBRsatngBKzpafauDgPYg9XHcVEyEK31u/IeKc8Y74EwikcDoLr7ejLUN1uNMQaH8buZMO0Z7Ium2ImwmoKFwHxrlj7LrMlvwhaTLU3fttJyoaH+LD8hcGHpG3510Ur4ruvZFPLmZns39gkeyfCOV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 11:50, Li Zhe <lizhe.67@bytedance.com> wrote:
> 
> Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages
> via cmdline") raised the number of hugepages that can be reserved
> through the boot-time "hugepages=" parameter for the non-node-specific
> case, but left the node-specific form of the same parameter unchanged.
> 
> This patch extends the same optimization to node-specific reservations.
> When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
> satisfy the requested hugepages, the code first releases ordinary
> struct-page memory of hugepages obtained from the buddy allocator,
> allowing their struct-page memory to be reclaimed and reused for
> additional hugepage reservations on that node.
> 
> This is particularly beneficial for configurations that require
> identical, large per-node hugepage reservations. On a four-node, 384 GB
> x86 VM, the patch raises the attainable 2 MiB hugepage reservation from
> under 374 GB to more than 379 GB.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



