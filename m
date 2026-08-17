Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8107DC5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C076B0413; Mon, 17 Aug 2026 03:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C4A6B092D; Mon, 17 Aug 2026 03:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB1D6B092E; Mon, 17 Aug 2026 03:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 341DD6B0413
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:39:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B38A3406FB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:39:53 +0000 (UTC)
X-FDA: 85109962266.04.C169B18
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92CF520005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:39:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMEliuDM;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786952391;
	b=CK6h0C97CE6ghOz4oZI6eH8ZH02I+tk5oyvt9oyzoVKNRN0a+OmI5YdFlF5lCXHKbEDgU2
	oQcbnwVfdX80kxJgdyqOkVBrGniDylOhhBPNcuY6pMhHYcTG/FjrizB2FUnkmAaqqqp347
	8zml2fTGQnLJeZMK2mwa3dKN1K9CVgY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMEliuDM;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUjVmPPcB1At7LZdvc64CAhIXtRxmY6K8F5ovKJHQDw=;
	b=PEMTwYXbl08C/dU3mViNr7vLYxzRVfv1p3JEEekHGa7cA819yB54sBFtSr50afw22AY/CX
	CHOXo2Rwx9E8BAaVpkkSO47P/rLJbADMLe4/ErKIQ5D3g5tUlk/OV+wsf5me2ZOwKHEQGu
	W+ZAQyQ8ZTouNzFvwggqLkS6B49LUa4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T7n46oyF9uMYAvescm6EbD1SiXnZCBlOdjs6H1Md6CA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786952390; v=1; x=1787557190;
 b=rMEliuDMGDk66yf0sh99HTgxUbHfh1wm8rxF+U7WX4hGNyX4LFynEc4u+skXy1TtrrnPSMDx
 ZeniCzuazGQPFTUcANjvv/Mfztnb3rEgEd4X+I7gC5UqUcjUUPrsq/l40tMunbFRhvxCaUzMooR
 WHvGRkS5ySo8tZJHedCN1GLc=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.244.244.3] (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 43d45dcbdeaa6b07;
	Mon, 17 Aug 2026 07:39:50 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <9255fa58-1fda-48d5-9353-f234fb35b78c@linux.dev>
Date: Mon, 17 Aug 2026 15:39:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix incorrect vm_flags usage when checking
 allowable orders
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ziy@nvidia.com, liam@infradead.org, hughd@google.com, david@kernel.org,
 akpm@linux-foundation.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 92CF520005
X-Rspam-User: 
X-Stat-Signature: enkimr6xk4shtkztwsqrddbqwa877ign
X-Rspamd-Server: rspam06
X-HE-Tag: 1786952391-499852
X-HE-Meta: U2FsdGVkX1/kAOS9bA06mLDqsGAfvaYf2urQf4QfheSln4VVWAJuSTrP2hiZSdYC5QP165yTX+t3ngajSMD/psQmWgLsac21xYu8akRRokv4h6CyNSbc69XAwo57P9GcSZrGo51ETCfpG13QMZra7eCFxC4+E0+3+K4G0itSSjQCxy6xHxMRWiHmv6sc3h2gxEb56DCbhFBJGGVjANBNXXPJBA9p+Bzm1M1/w6mUHNNB7p6PVAtUtGGgndugsZQspFNIDG/283pvaQmfPa4FZPyzwqI+y2Nt1OJ855MdHxblkIklA7AZ7BJuxF1bR6gSNNoAOXixb9wB3XicRYW0qEdxwTVeWTaSceEEqRXDSfZo7l2V+C2La8L/k/D+qCBKdOg1p7WEZyGq8FZ8l2f8e4vAZ4NE4wI+ZL4oT/f+kdQlc70OW14cJOJIpuYzK+L7qktomdDBgyO9g0H/xFuDyCzPzU1Yp7xxaOsIyS+iyuzLrJe+6tT38QKZy7vd8BJvz+zoAnO0N+YqBvnckP6ZKVLGhfGXYi4+vFu3np7KG353q+aqVANuM/+0WVFw78IPDvO4aYA5B0Wqx+kBdgS8gzGZxSihefhbcH9xeCZSbMitpLKbdDEY+Kl+Eqm+Fdt0jUWbvQacjgdnHOsMGnBbrGr+jSDA1y1ROQkc3knl5Jx8nWBeQmxhrKa8GFqOv2nUZS5ejdjbDsqDUuO1ltGTTc/7ndz3mQWb3QabRxybSE/s69SMio7wwtEf1Ag5Qs+s7qI5z8Ksm0lquMwO/z8WBYlV+H8I/RgKcfCOFjfu3MwAkwfvM9EJzHX2xuOqDwcZerw2DfpJjnGuMLCb74krLwSqktRbTBVzBOdqi7Q2fUfLwcX5LRa6irVC/COnwCeWBsBCkyP11vkaQ5OByzczEX9tDr9wHR9/OZa+thiNhJImtQJSCUo1yvB0J/+QPeVFvpHZt0EK40C46C44QGQ
 xD1h9ku1
 b2OuLAMO3r66bu5DkK3BkMSZKtLt7rU+ze7CiplwP7P6yt2cbzg3ghmMx5V/w64enNLhsBVnTiK2LEveWgyDilyMYYoZ1S9VMAAjB6+gmgMCX9X3ZnHODORKCuHMYFwpR5SrgrdbkdCTrjXynNSGWipXTPWEOUWvT1pBrE6asmNs+ZtR2lTh82rdPVc5ScsFkY5muDtHxNzGsovfQ8FQu0Od+/bdY2Th7AkzFbJpcwe1UIhSUg6onrH1MSjhg289/yQkP/jJUT03GKmUO2jDBytvVLW79Qo94M0HfqhElpn1CW95DZbgKxc4a3PQib3Qpk0bLfr2d+lBVnV50lxpi/Ywus4zRsFN18Wlulh4qM4xnkO5d4vJnFRMG3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/17 15:16, Baolin Wang wrote:
> Lance reported that when MADV_HUGEPAGE is set on a tmpfs file mounted with
> huge=advise option, khugepaged fails the allowable order check and does not
> scan the tmpfs file for collapse.
> 
> After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
> vma->vm_flags directly.  However, when MADV_HUGEPAGE is handled,
> khugepaged_enter_vma() is called before the VMA's vm_flags have been updated,
> so the check uses stale flags and incorrectly rejects the VMA for collapse.
> As a result, khugepaged does not collapse the tmpfs file into PMD order in time.
> 
> Fix this by passing vm_flags as a parameter to shmem_allowable_huge_orders()
> instead of reading it from the vm_area_struct.
> 
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

