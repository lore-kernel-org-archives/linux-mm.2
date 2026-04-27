Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE509FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2DB6B0088; Mon, 27 Apr 2026 17:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99BA6B008A; Mon, 27 Apr 2026 17:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6C66B008C; Mon, 27 Apr 2026 17:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEF686B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:11:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 897A11202CE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:11:28 +0000 (UTC)
X-FDA: 84705581856.25.1D8CBA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0DCF10000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:11:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jopbo+g7;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOH66SUjraABYSv2luUK0UqdaDoekaBQxUT/8hXHBTw=;
	b=vtMa7z1nI7dQXCyRAXDsv+AX601tUqD+yo8tQsBr0ag3t52xzW2Z/oy/QDbQywsvOesCIJ
	HPVNHqBQ87ogmLvXYxCp/Kxj2rBjogmJthhpp/Eq4Dq34xXiEwTeVzYJJ0M39xmCG2XbGc
	7/Y9ZbdjLDVja+5zcXm1WjX5GpcvBk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324286; a=rsa-sha256;
	cv=none;
	b=FZU14Ij+uVkm6/XaDXHBK+QmHyOoa15rq1Zoc9s6sDhWJywgHB2mYfxwulb85JAH1Dng9L
	5Hm0SNn3ezwRbcojvi/tpCeWadnnFDGxDJIaVZrjhRVjIaylePsIhTeB3rbePdj413To0o
	WCcOu+a1YhO/k5BUOgaWCANcYjL4+C4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jopbo+g7;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D675419FC;
	Mon, 27 Apr 2026 21:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE7CC19425;
	Mon, 27 Apr 2026 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777324285;
	bh=VyG05trERLUUjBqaf1aHAz+Pp420OrM/UE10PBpRFNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jopbo+g77IaQmMmCio+rl3i9VUarbuNVBVxqG8AHrfG1fX+ebMSjZzMCe4tCMyStP
	 DAM6GNubpMvhq49iPRThsGxP+bigsXiB1pNDgN4tY5ByJoDGRu6aCnXAdmFAO3zPD1
	 XePpT2/wcyC1Uy082oCXug+ft5RiaywilfbLfLDk=
Date: Mon, 27 Apr 2026 14:11:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, vbabka@kernel.org, mhocko@suse.com,
 ying.huang@linux.alibaba.com, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 gourry@gourry.net, kasong@tencent.com, qi.zheng@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, surenb@google.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, apopple@nvidia.com, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v4] mm/mempolicy: track user-defined mempolicy
 allocations
Message-Id: <20260427141123.734c66450100c0f900e02947@linux-foundation.org>
In-Reply-To: <20260427151520.137341-1-jp.kobryn@linux.dev>
References: <20260427151520.137341-1-jp.kobryn@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0DCF10000B
X-Rspam-User: 
X-Stat-Signature: tbqo9sz8mmqkzjhi4jsmh79ttn36xxh5
X-HE-Tag: 1777324286-990912
X-HE-Meta: U2FsdGVkX1+5jLoamzMLPwkS6iM18R/WjrQFKpU9ptV8FQZG7E2JuxYCsBHR+wS3a4zQkVouJGLnJ+QtaqHfbM7oWzv/rPuedd8nViZR3JLRSQvqBmSzpNaOVEpg6ltb/fPuHUieMV9XDZl6hV6S9j+kM+LZCvK7UNMZW+atqWje1q01zLrC7QKybO4SOawYaYE8Mpx3EFSOj7gsRfsHJnGVHkMvuSnIIHr20CvYxi58KKMZMDODAfDfI8LrCi3eQaGj62iKbFy+25ecPV5EzqJXYSw2tUBwIvV7HOhCHZbc9Lo2GKHRqAehm0iDCN3bkejAJkmtXJuBxytwK2VTB1ChZWVMpaqO1s7vWaihy00LGPLbk7RbU86TUSw7f7XYqFBsmsiqfxmOYoC8gSQy2h2kObQCwh/evpJGzc+iDdds3RxGFjPe9f4Mt0pxVgaBSBZeVrSEwDvHygBv/iDNtwByEmHz8UHF8hyDtnbFxZAURL4h/SwonvYkmBLQmuCZuqflNhWA0kilj/Ot0bOv+fJ2WP74v2omSKkGZwCDzp9hWoLK7h1C5y855TBnNOJhzlpP8TqUZCIak6BoDNuwXUF+GxBIdFcIb1f3m+tbfkAzXbsdGa1vf5CH0U8yP//twwwH0Jli9qjWZdmPODBFLHUgOB+ExEjple/Uhwp6+i46zrXLQNIzbCyrh6kvdfKZlOdqJhit4gaQH0JFJOQJ7YeGkSeAG6h7K8rqQZ4kXZhuNSMVrYouooIqRHHkJp6Lm1U41lf5ccDLSgi7gmorDWa9awua6sCpMOCRJzwR3a8JAjdmdC9B/W5WqExhzqlTeStGP00AxtP9t/SJVjDMl16VPBC3V/9zeNy9ATZAVizMUGyejGMSd9ZsranI6GlDCpFHUfZ7iVhhGr/bddADoMOeayBOlWcyvKrHBGKSRbdMeUtJj4214k8KkpKF2tjGLcFsv2ZHKVMOtcrb8Su
 SMnK6nbi
 V95ggmrPAG7GzoqeqcrytUWzLh4Flqnzv5mkyiofeLmqQq/tJcDcnYM72g3EH5we/Z2TBMNB/Ug1sL+YuqTzbhYPN1j6o+ScYTO9Cy5gye4S88rnl5+v3b0jNDio+gN5ZA23yS6Md4N72LTDb9A598/jG+QvbyES7QHIRIcEjAKfkgMGjVcEhWatAm0EINVUVQF7gwo5Mt2vJsiHyzXa1DgFH/elPrjmxrD8roNS/xJGUY0Zl4+K0HT23XNGzqD6zx7TGe0n8Qj01SauxFqb8a/UoW/UVkd8vgl9e7bW11ZvZc5L9f9c32jGGst7QGGWbGfIMIgGCQCOj7Pf1lu5IcfJlTq+UbCF1GHfxzKw6WRfHNGDpVvYr2O8s6oKQsBnau0L/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 08:15:20 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which user-defined policies are driving allocations to it.
> 
> Add NUMA mempolicy allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.

AI review:
	https://sashiko.dev/#/patchset/20260427151520.137341-1-jp.kobryn@linux.dev

