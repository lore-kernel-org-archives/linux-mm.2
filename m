Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EFBC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262C26B0088; Thu,  3 Sep 2026 16:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213D36B008A; Thu,  3 Sep 2026 16:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AA96B008C; Thu,  3 Sep 2026 16:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4C476B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:22:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 819A5805B4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:22:02 +0000 (UTC)
X-FDA: 85173572484.21.315ECB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB05040005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:22:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wCbSM/uE";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788466920;
	b=tGEummAIhSrKPhFPPmfiR8jI0eRt5y26Kr4ovcJe8CxsleRcV23GkCP9y9ZE1H34k16dPH
	OsIF3HRGAhxkcmM8+IQK/2ZzA6Vk0/0F4QqIiIcrTld09yNFzJAOYIDHMRyhxmn9+d5RqH
	t0nMT/XboPjIYvod26vItb0U8iqQwnA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788466920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yky/f0WiCrxErR0j6vYpCOZ1PkjzKLIdBoCOJhOCRD8=;
	b=mM4ViITcvAyIuQRxR1ZWPB2xtZU53QKaE0/BoJTMepp/pkoxwQvBLZXODR49GYqBwjNq6M
	3WKLXafNMFjn5FEu3GeeiWm90k7EBzFuq6r1bQjL19oRQtuDO+ctWc1Gbb7ZdLSHu/dNXf
	HP8c02FQ8sE5A1OkiWLL3Gyl2+cL6NM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wCbSM/uE";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED34B40F18;
	Thu,  3 Sep 2026 20:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF7E1F00A3D;
	Thu,  3 Sep 2026 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788466918;
	bh=yky/f0WiCrxErR0j6vYpCOZ1PkjzKLIdBoCOJhOCRD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wCbSM/uE1oD6985EqHCqBqSnG48CDKxjN7yXXCahMDkRVLlrzMMOFyfx68wlnDvq7
	 bW6uTyvqsmNt7n9oH1y90q/o2uADoC6HmWE/UkyV80dpYgv0eQ6QmQovitbA0xVHu3
	 Tleif4F4rJHF6eL7YS2htB0nylm0rIYx973Eh0/0=
Date: Thu, 3 Sep 2026 13:21:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu
 Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] mm/memfd: fix hugetlb reservation accounting in
 error paths
Message-Id: <20260903132158.a2d6f965477220838d884bae@linux-foundation.org>
In-Reply-To: <20260903030134.7407-1-hongfu.li@linux.dev>
References: <20260903030134.7407-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB05040005
X-Stat-Signature: ruzi5i9weknb4wwhja45wotnpww4i7g3
X-HE-Tag: 1788466920-306530
X-HE-Meta: U2FsdGVkX1/DrGg7IMpc8JNJzWoNBO9l3OgTC+L/WYYt6l4nEf8Ofqkd27LRTFln76fUI7wgSKLsxUFtAmXIoV8sO7yVEx+Jkh7pigl7JBK+GBLi6iu/WfLao4/1G2xU09YajOx/Glm1gGXntGKXA5GN2SnyUI/9/bvxkBpuji1negQmwBpSdFyB35NOG83Ek0LYiyfhjBJqAGhCYsZCuNhkX9++s685ERgqabq55pys8h2CNEGs4GagNMimg56rgAmuyyANv+Viu65CEYbZ53ql62vkbhUg3dcxuhFcJMPKJ56xt+LdO0AW5ujfGsWD+0leRxndksxfS5BZBb/DvYRwvoaHWJXdtAc+hapybIWMUuYJIjF6Lr32Rr8TUKRJeNsf9fF1nTZgvs+3OGLR8+dFgt/2DT3DOIorhEul4x3DbRglVvuOglXR+7oMgweDasvo4brREns36V++QR7k34FlLLuw3/UWPlZxFDFBgujk1WqzrWxgFrq9C0SHKUoSI3+iE77k8mXSPKhfrhU6G9lOpxOIr9WfNbnuLptny3KNkgkWKVgGFYls3fopcbU+TD6Ugms7WPDHf4wWxmw3pLCVr7+IUkbbZB9DdUgumZMopfraygUiyCDW/ytaubExTcWMBSsjhST0YxX7QMwONayZOdG6K1tt2DJ4ceHFP/q9Dirk4d5rGsEVVLzet/drQQGczju44Jf45kA6QEK3S3GKeJ8zg+kBz2BZhzmBtKO3P3zZ6hEl6TTDPrp/lsJMWogIsh+RXYKSbmCVaM0A+eW9LF3bOl7bHq9HHassxZw7gkg3q7y+7XpkQgcbztU3jfQs40mhufZNGa6A8UOmIyW2F13oLx1ipa8QTSZEEBvDF9Ik645W7r+2jBGNLA4AWS3DTH3JN5T+E25g0uaODbhXhXe5R0zlFfAnMhvmJLpzIc2afwBVre/os/uWKpvGyP0rJNOX3Z9LDWt8Is0
 6bNoBGD/
 DA0hcZYhV4j3YoeG5eVCoBbEpwDKkMqdp/6wIJaMY5oKY58Y1/PcDJerPPnxj9ozt+zvA547DJc/fCw4CYe+6dlWWPjc3pSXio0wDWBPQPj4kYrvh6I2j802rFdPu/pmEZPo+spI+MpJwyanGHaIIk6mFThlMVlJ7zazgok/oiTv20zhPTsvhX2lw6qvHXohQ/WDm5aOGHRN6Ue4lVF5egoqZKMZH6vdv/b8QKQSkyIcke50+pYtvo70DYcnj6up+jZu8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 11:01:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with
> -EEXIST, a concurrent fault has already instantiated the folio in the
> page cache, and the reservation now belongs to that folio. Calling
> hugetlb_unreserve_pages() in that case incorrectly removes the region
> backing the cached folio. A later truncate or inode eviction then passes
> a negative (chg - freed) into hugepage_subpool_put_pages(), corrupting
> subpool and resv_huge_pages accounting.

Ho hum.

I've asked so many times "what are the userspace-visible runtime
effects of this bug".  Nowadays I often just ask Gemini instead.  It
told me:


  Over time, these corrupted counters would leak huge page reservations. 
  Applications using hugetlb memfds would eventually find themselves
  unable to allocate huge pages, receiving unexpected ENOMEM errors even
  though system memory and pool capacities appeared free and healthy.

and

  The corrupted accounting caused hugepage_subpool_put_pages() to
  receive a negative value during a later file truncation or inode
  eviction.

  While this typically manifests as kernel logs (WARN traces or
  badness flags regarding subpool page counts), it could cause
  misbehaved resource tracking that impacts subsequent system
  operations, unmounts, or process teardowns interacting with that
  hugetlb file descriptor.

All of which sounds rather unpleasant, so I suggest a cc:stable here.


To help people understand why we propose a backport and to help others
understand the impact the fix will have upon their system, I'll paste
the above into the changelog.  Please send any necessary corrections.


Please also update your prompts (if using them) to ensure that the
changelogging includes this info in the future.


I'll queue it for testing and shall await maintainer review.

