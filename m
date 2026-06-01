Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C5FCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666596B025B; Mon,  1 Jun 2026 01:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6171D6B025D; Mon,  1 Jun 2026 01:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B456B025E; Mon,  1 Jun 2026 01:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3A96B025B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:29:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D841B1620D7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:29:47 +0000 (UTC)
X-FDA: 84830216814.04.2D5D4B6
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04C5540009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:29:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wqj7qqnD;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780291786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsKpIHqnf51QbeZWlXH2bfGBPrOfF8CYCvVjN2m0bnQ=;
	b=tQfcGzZO9VT1TscgduG/8BHjSxj9dPEX3Fpl64Qf9kKRPl7yjODgkkw5BRMbq9aUBt7lX4
	YUjhzTRJasgXqgdEACl8hnq4NlFm5HPAZuzOZ1bSKGpF7Y+A9BUe2l2ZQLm6FSwZSHUtsn
	ZDC/Rc4A592E8X8RTLQuqdrEFPUYc8M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wqj7qqnD;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780291786; a=rsa-sha256;
	cv=none;
	b=NXcAFjAaYH3hXPWWKXr6JbAW45IEFkOGZU9hHzsOAuEtfmli4bnVipzy8TkHfIsdIOY2nl
	99MtI84BRPX1Kuio2zxd0M0jSHy1QVGFiCXuR2kQS997gPpFN3uL2pmIkqpArfhMfbn2A5
	dMcwblFJmEiT2AFSR17EXDDTpO/piOk=
Date: Mon, 1 Jun 2026 13:29:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780291784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KsKpIHqnf51QbeZWlXH2bfGBPrOfF8CYCvVjN2m0bnQ=;
	b=wqj7qqnDdg0CTuiDo5Y081fpkL9o6vjT87F4EeAz3vGmlfY5/GU723zR8TPY7vVPusfuEK
	vqw1fOKPZF2j9bK6uYnZRGvJnY2o2ghie1qjXMiPqgGnBwcS6aDVRjF9iVYOXK9fBTe1q/
	hpQVBRx2h0AmysTgccf7mANwS1BTac4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH v5] mm/slub: use empty sheaf helpers for oversized sheaves
Message-ID: <ah0YNKL8bqo0Megn@fedora>
References: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: y4xuc6fx4dn49qakjhmbeghu7pbdiuf7
X-Rspamd-Queue-Id: 04C5540009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780291785-354034
X-HE-Meta: U2FsdGVkX1/WPNpO/5QjbKxkm/tdPMH5IhcDUIgcu/ILWR8/596TTza9ri2MU8zifHO5iYZzsKMZJE/vEUNSoXHB9s+Yj89wr73L0/95eMY5WjwSszDJ/kDUPhcQVj2tfdZs7fE7gUK30/J9X/Y0hQs8NkjYGerhcm/ESSU2j+R7fUxVIb7wKsTSLvo2/eBVmCRyTEKgidnqBDT5q5RhVSfBn72asPbK0B6gjf3YYbE3AIsOZg8dY0SNmezxzuyMtMdMVOj0vFlWV8EM4tRD3ra0Ms/cVAANd7KlE2AjlPqXfNTyKp6eguxCM7G/wEGQpqQ0g2SHUXmo9+XDS/5lr/ucD2yBGgUH3rO+94sTyR4tghsPiEx+9qn3wJ41BVZnuvXqveKDU6XMlW6Azc7Tn+XLMjkRh5FCm9SYOTwzB+thlxr4Aw0M6OprIF7pK4KuQ6/KjKnDb9cajuE8SAMNGNqeqMwEAE2PzTOJvvFB6wWLswXlKjZRjZdK19mxeYm5pT+LU3zCGm44U6YWZKmKskzGTJ/1IdhFzKMvVf7Qh1VSr71r8EhV9snFKZWbQB93F/jaK/6ITEPJz1IcLx8+8fo3gISZcvZ6Dm0dfQoQ4ndvZHV6Y2gZEdEA7GFIjx5nHcmqVe/SUu0mrWAxJL7AUu4Q9b0i2kJkXYEAdB7eLwVeHk+xEaurU+xc1I1EcguCiK/cpKdw/vfGvdrI1BCx5QBisPxLs9gfdwK8VKMCX/+O2C2tC7LBSGw2uq87+m0I/x5zKf2ib+XM/dKJVilrMc+FSv7C9WroBLlVW2Tvc+9YjDjJ9K9tFAF8CHwkMemUCd+vToJyjLAohe52LuxU9sMNiWnTin3mlavRWAT9GwElJMNRP/rPKH3LYomdvsRXzVxCniH8gfAl7YBd/i/FBDLB/i4xZospf9WYYaYa1esqVMwEtVFkd/USg+OcEVJ/MT3UW9LSksITqmPf6uT
 x8EdYM8a
 IyR9S5qu2UGHar5JDVZLpsMAbRGxDS58FXKrHVx+7TsYiHVgh21HckOr/QDhFDuxgZKP85WEcO5BkgA6wBjEitha15tb8sgsbuOP/VJX4/xkmjmGSdNmaexhd0ql54HuC/K+5UB9nXlKRtcqnmT6cYxyjq6IEKD5l5OPQ4Cs6ST2n3LPaS/j7eKl9gpd9MBtSvpwtij2uFb8LeG4evhOU/n9tSYMn+SLVrnCAkourin7H9JMF2M+K4teBJs2jlStJ0QZ1yGV8nGdB9Ms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 07:35:37PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Oversized prefilled sheaves are allocated separately because their
> capacity can be larger than the cache's regular sheaf capacity. After
> they are flushed, however, they are empty sheaves as well, and should be
> released through the same empty-sheaf helper.
> 
> Allocate oversized prefilled sheaves with __alloc_empty_sheaf() and free
> them with free_empty_sheaf() after a failed prefill or after they are
> returned and flushed. This keeps the oversized and pfmemalloc return paths
> consistent, including the SLAB_KMALLOC-specific __GFP_NO_OBJ_EXT and
> mark_obj_codetag_empty() handling.
> 
> Keep the caller-GFP filtering in alloc_empty_sheaf() instead of
> __alloc_empty_sheaf(). In particular, do not clear OBJCGS_CLEAR_MASK in
> the raw helper, so the oversized prefill path does not unexpectedly drop
> caller-provided flags such as __GFP_NOFAIL. The SLAB_KMALLOC-specific
> addition of __GFP_NO_OBJ_EXT remains in __alloc_empty_sheaf(), matching
> the free_empty_sheaf() assumption.
> 
> Since oversized sheaves are now allocated and freed through the empty
> sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
> sheaves. Update the stat comments accordingly.
> 
> Keep the capacity initialization in the oversized prefill path, since
> capacity is currently only used for prefilled sheaves
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

