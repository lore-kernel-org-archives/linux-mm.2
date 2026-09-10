Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CCE7C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 05:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC166B008A; Thu, 10 Sep 2026 01:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D8F6B008C; Thu, 10 Sep 2026 01:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7506B0092; Thu, 10 Sep 2026 01:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAD586B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:59:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F600A044F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:59:09 +0000 (UTC)
X-FDA: 85196799618.28.1DD5550
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D8F8160006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:59:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r+b243BF;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789019947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+W848YAGgId+r0hutVeqFh0OVKi+g9bP4xQ6R+kF14=;
	b=OLKHPxgG/8oRqL1JRIhrJWFRMaHiwi9AD6r6AsM58/cedMATebOJHm9UfukkUO8h2pgWrt
	2xFNRVgp+ZvsAApvbbJlqVygwqZjde+eFwmWFy8WktZjeQp2mJ9bFfcnDRU0f/XuCkMwyZ
	7HsdTh7RYf2/dO9QDAUdej8v2jdG/zo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789019947;
	b=7/A8lg3ksYbnMEh93W1nVzQJHyEmYPOYNwpZo9FgdT/Fl4WHrK/2s8od4P8j4G3PPm75lY
	EtKvf0X/Fc4kZ56SXGC7vFASbXVRx7lhgNQ1BE5PEhFAMoeyryZt5hYu2F8YX8IUkAr78s
	ONpfi9Rap4XHYSZukS36CdnH/05Iu+4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r+b243BF;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2CED43C1D;
	Thu, 10 Sep 2026 05:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7891F000FF;
	Thu, 10 Sep 2026 05:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789019945;
	bh=6+W848YAGgId+r0hutVeqFh0OVKi+g9bP4xQ6R+kF14=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=r+b243BFAi1hYjM3C5FSUaRF87pjCI3Jp7Gy16gGEtlDLB+qr6pI76jTdWFOtd9nV
	 zkzmtHr+WvIyIfodL4jckPUVjGIkNxEyFRj+Smk+lt5tFZjU5I+Dq4DFaIhIbXOau+
	 yDBPitQAj0zIg9oKLCDEAfYVZtHGv0mwIfk8RdxY=
Date: Wed, 9 Sep 2026 22:59:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bingfangguo@tencent.com
Cc: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo
 <bfguo@icloud.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v5] mm/memcg: clear folio memcg after changing per memcg
 stats
Message-Id: <20260909225904.6d60c722ba21f26e18c98767@linux-foundation.org>
In-Reply-To: <20260910-memcg-swapcache-stats-fix-v5-1-033f510ba748@tencent.com>
References: <20260910-memcg-swapcache-stats-fix-v5-1-033f510ba748@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D8F8160006
X-Stat-Signature: 6u6cptm6xc5b5kuwezks4q1muoxe99z4
X-Rspam-User: 
X-HE-Tag: 1789019947-179573
X-HE-Meta: U2FsdGVkX1+CVYKg55lviP5c+qdbBxpzOmqHmUpMgop1VerKiY5/E3zCHLtA4cxGJGDjS+Iwsu//E9jQVJfC7kvuxU4Ew7tWc8IipONdO/X4Lkf8TuckEdm23OVir/CGr+N4I/pToJEB6w1D+TuRuV5icuOCWIn/+QaTkgh4gt3m+LHOXH4nsFrAzOw5OqRoQ2ph3CaU/LKUmJg7khCV3znYm+EYYPZK3ZBPNqlTQ68yel8sJEGlkgf71tzsv1agJhHAOo0fHQW+44jz/0W4KFuG+7w83G4XvnjDiuxFAnd9Tpi/AOJc2QpFHfLGcuLX5c+iZGuAAmcOThJpq1aBEBfS7JuYoHVXaWJpeGQEkmuyRdE/1sj8SVZynHugWytbkwKGdfcvMVMLj5pQRBzJ4vLj5ZJN3m9tm01/DYp5Rz+5SAO8XHmE5aYvo5bsU09pw0jDtLmcoG1wUDK+swMCGZKxrV47EKAyxW2PJCPdDMtNU4pM+td120/HQ+znDye6FAxZ71V64DMMy0SLuHZ2W6wwdL+rya62MHgHEx4qt6v9ZrtnoeI8WMbf9nzm5CQpYSZL+I2yy1HXcfKWU+EDBICY5L2h05/tkKexiaK7ImV3lF0KyDxJzVtVJmNKvkG3o05a+RxZSepJ441F8JKTitEpJ2ZDxNMYFWFDFJbtGUrqpXTOryeSwCu16WyrWSGYozWcvrfoqZkhdsQNBk9xJ7iX3YP+ar361LbMkQ47fUpVs62AtnpLvXhKoP3sFb4q5ebRTpTpWsgy8SIHkr3AHVPJHmvPazAhv3muf/rWWe8Tswo5u0Nl7iZZEujPJj86sxcP/keI3qOEBr4x35JihkdRr0XsraER4lNX1FcOokoOCZ/OvQzxM9i+i02vD7pClipR+NNAj8BBHrd63ygLcJFklrGsK27FIKrJejMO8CtNJsEQcNJKE+xBTr9IMEVeVZRWX5GojHHx90wvECn
 PPBl4mCU
 knVCsjMbuZf7qrBHJka2v5zm3dX2nltudRNOqutroF+jrFEBV5rbziuSzVLWeD2YoDpeEB7HLX0aPvjRUb+7cwilTbqW77JUKEpAGtMqp4BgJvtx5sj/jG221KMN7Iy0YMJuPKdzJqScgQUW/2B0rI8TKel2J6rw3iCJBFtDXcZIBV8sUCPb13ymOcPS75TcqcUz6xDj7lNhFglEQVyOJSoEfhRLXGhZIaA/RxnqRXOl4DUjlnHe3uSoxMvhdbwwetljJhtIK2OCE8cIy9B2uezpioGJl1xIOC6jC//TnulmoUYw3pxFCXGGsKnsyXIS4IYhPAUC0LCLXZBjbz2DKhk9aiPn7havNQgxD+DvabjWOYNNET2w8sioJi7f5ZvCbCIGu8O+XH9CLjvOWKeo0c3LbUA3TV07m/9lh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 11:46:58 +0800 Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org> wrote:

> I notice extremely high swapcached count in the per memcg level
> memory.stat when running tests with cgroupv1 setup by swapping pages in
> and out.  It seems that the counter never gets decreased so the value is
> rather useless and confusing to users reading it. So I think fixing it
> so that the value can reflect the actual swapcache usage correctly could
> be helpful.
> 
> __memcg1_swapout() transfers the memsw charge of a folio to its swap
> entry and clears folio->memcg_data as part of that.  In the vmscan
> swapout path it runs before __swap_cache_del_folio(), which then
> decrements the swapcache stats through lruvec_stat_mod_folio().  Since
> folio->memcg_data has already been cleared, folio_memcg() returns NULL
> and the NR_SWAPCACHE decrement only updates the node-level counter
> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
> 
> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
> __swap_cache_do_del_folio() removes the folio from the swap cache.  This
> keeps the stats attributed to the folio's memcg while still recording
> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
> the plain swap_cache_del_folio() path is left unchanged.

Thanks.

> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")

January this year.

How does this affect users?  Should we backport the fix into earlier
kernels?  If so, why?


