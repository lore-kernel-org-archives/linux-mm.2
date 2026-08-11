Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48F5C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C954A6B009B; Tue, 11 Aug 2026 14:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C460C6B009D; Tue, 11 Aug 2026 14:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34656B009F; Tue, 11 Aug 2026 14:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9832E6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:46:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D939A01E1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:46:26 +0000 (UTC)
X-FDA: 85089869172.09.D2330A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23050140008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:46:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZYy6pYr+;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786473984;
	b=OORl0w1Y6pgKSzo3KJmDoPmb8zGGh1zg478WupFB+KK6NY6J1FTPcRyW9+cJvLZGC7425u
	ZBMi/Or9AheVor3Ak+AlDNYeByGsrca0GTFNdytxRfm8BTw+ksdblGkvpDWdtuvQWYgMzD
	VwH1JZD2ddH4R8wShzP0XNqL8YJINY4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZYy6pYr+;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786473984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKPZZ3B0d2sbP/oMQ9LePwX+c7Vb+ZdjwJJLMFTv0Ew=;
	b=pCg3KPRlmhXAgoQnYCwkyW426zdiV5DYqc5bXlvWgaRqn2qgkqWPrN8+QbDrcb+bjIYfYT
	Gn4Hc2iap57mV3ZTtLQVdBM3vHAes0dixal4aviFfQbVG2t4Eoe3uB+tZXriZAN2fx//AU
	ki7ufB8qMeeIky4ki66mLcqcWZKmCRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33B3743AC7;
	Tue, 11 Aug 2026 18:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17231F000E9;
	Tue, 11 Aug 2026 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786473983;
	bh=iKPZZ3B0d2sbP/oMQ9LePwX+c7Vb+ZdjwJJLMFTv0Ew=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZYy6pYr+DxUoI7TbicnIiX4Sh8Mi+oV/yG/61UWORxewaWM0ldGrEpzRBd5WkSxyU
	 wVN3AK8mhvD5HDcSKXMWjziRdrd6JIJsBo+hdK5yX7L41o6BkKrx6scqPiJ5q6h0OV
	 dW+by6O1QQLJM5OChZoEVw9ODM4/8rhmukRYhJ10=
Date: Tue, 11 Aug 2026 11:46:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Jianyue Wu
 <wujianyue000@gmail.com>, her0gyugyu@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm, swap: keep hibernation swap slots out of the
 swap cache
Message-Id: <20260811114622.6a04927b0c7ca0c2d6b39cce@linux-foundation.org>
In-Reply-To: <20260811132209.2862708-1-youngjun.park@lge.com>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23050140008
X-Stat-Signature: 7eurij5xgdozxwnq5obot6y7cky8t6in
X-HE-Tag: 1786473983-89926
X-HE-Meta: U2FsdGVkX183GMr8HgwMD9cckSuiJKPhc3wpjp2z4iuJaLL+kW4aSNBW2J3ljACtcXirJpMVHY4kIPX6c59myeDGUTkFxxF7aZ9XpnXFRD8Bb95+6fIGigVX8C04dZEwi80ABOlqPtZk2SmqvWuQQrcSfg7XXEbvkLdBxiIbNfaBOGM7halACEGWZdVoh+zAFkJfs6XU9tsdNNAjlw9AA+0vmasmJbSEt1nJYSc7zkmaV1oypXWkB8Zvn25xTiwYGYksmHVHhpwebj5Vr1ufsghRCDpVV9ZH3so6fmrhQT0dLOwUCjMv1u4b1n2BBBdLKhZBIkKe/qQSL6BO9SnWHgCDAMGJor2vgfmCdF/9LaJGZdKOZhVnawQ/uSZ5H7SCPCnTLlcl+rv5CABYj01e1+UzJVF44SdmcvZY2Zcrb6CqA70FhKHvIEvm7Uvg3IuYJlStAr5okT6Z0tClskX+UKL669ezya9/t8hsVppKFUKCWODnN+hCG6eLzqkPPO6WXT5N8YgKjNl4cK0UkruEolFnz1w4vhPvCN7J9VEK638HFiN9YAfK6zcFMSjjq1QhKtDQsCHNNNzMlwCYPhyEXuIddTlj50q7xNKg8PZkR/kexDoOgmDWytraqPd9syE//vXrs66+VlL5vZ/YVIFFIlvke4SoBn1mGWvfwNG8yCHyH699/TYOZEy0iI318P3d1aYsJaamkoFAx2AZpInDXfsTs+ZQj99FjHGDrubfpJPOv7W4AL0gaF+pAoMijp2qTL6tJUx1nbPjOYwklq7t9FGyQy4HTdzJ82UFCznGivm8cj/8DlWzqkQRp4NbEAuilOxPg7Z90QM3529wOmJvL7f6e0SUDw6rpIQMuzqCAy8jpekaArYwL4JCLy7z8gFf8qDrVAOtEse5KEjMnEm+ztwk5AqyHfbM6T+te5Ykb+wHLgmoqBCGTOjTyZCjvGtqK0y51nPe5uGsCtCdrc6
 mANYNb9E
 YEcvrVkp8Bh7H1z9YJc8jZfTBxTxoERrLQamC7k8/B3UxU7EcGVW6kpn+FoulsdMP2cqhZqSOmbhxPmWuhPpy2Qn34pXQiJmKNq4FxeJsEXaPq4MhWvWQNv9a3+aatDvVhLKEFeeeXDI+npIpPIj/68CD/AKjw1eZ0i4sfpMRHKPiQ5VpfojDHat7VAgr5x1SuULglGAsyZEpF+vylbHnteB3Gf26ICo1YwA4Wzpa+34obVFwWnJgaFCCnCj7fxc4K2ENl3gHMsUnMWL89AI/7QpZ1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 22:22:05 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Cluster readahead walks a raw page_cluster sized window of offsets around
> the faulting entry.  A hibernation slot looks like an ordinary swapped out
> slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
> off the device into a folio and puts that folio in the swap table where the
> hibernation entry was.  This has been possible for a long time.  It only
> wasted a folio and a read.
> 
> That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
> track the swap count").  A slot with a folio in the swap cache should only
> be freed when the folio leaves the cache.  swap_put_entries_cluster() still
> does that, but the conversion left swap_free_hibernation_slot() freeing the
> slot either way.  Nothing points at the folio after that, and when reclaim
> drops it later, it writes to the table entry at the old offset, which
> someone else may own by then.
> 
> Patch 1 is the fix and the only patch for stable.  It puts the missing
> check back, so both free paths behave the same again.

Thanks.

When fixing things, please always take care to describe the
userspace-visible runtime effects of the bug, particularly when
proposing a -stable backport.

For [1/4] Gemini tells me "At a high level, this bug triggers silent
memory corruption, process crashes, or data instability across
completely unrelated userspace applications - typically occurring after a
system resumes from hibernation (suspend-to-disk)." Which is what I
figured too.

Do we have any reports of this?  Reported-by/Closes?

I'd like to grab [1/4] only, and defer the other three until 7.3-rc1. 
This might be mistaken, but from a quick read, it's not clear what
benefit those three patches offer our users.

And there's value in merging the backportable fix alone, to avoid the
risk that the other three patches accidentally fix misbehavior in
[1/4].

