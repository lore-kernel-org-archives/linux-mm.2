Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BA1109C034
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28A66B0092; Wed, 25 Mar 2026 12:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED93E6B0093; Wed, 25 Mar 2026 12:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16F06B0095; Wed, 25 Mar 2026 12:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1BAE6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:05:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 853D9E0DB4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:05:08 +0000 (UTC)
X-FDA: 84585059496.24.C3ACB53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95878120019
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:05:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VwHysNZh;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774454706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W75sJhJZlORlWSS4im7+t3Q+YNTEhQ6HqcXj8hxbsms=;
	b=qqzrzQW/S74+QBcgZmfS3mqFik73yJfFuLVla5qo6XMxBZFzxbLV/F/ku5r+3SiWaGvWgA
	AXXOVEIfuJVOaIpSQAjFGuy87f7z1jYZQvoF6qP6SFbzbDUKhr2CkOsmnNIofFVTxLgvly
	93VIsjcLfzAY5iqEDyDErXb5ph/K6OI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VwHysNZh;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774454706; a=rsa-sha256;
	cv=none;
	b=5CZtQDIFBU+TNMbIPy8yXQ04VBc3Ngj/64KFTwvq9fD5Ls/fC0Cd6vKKWzl/kRaf5XuuRX
	k0EUZjUcYoAieNzEn5X5rMtBdDxaRJ8nVI+ReJ/Xc67S3ys2leB6o+pQpoYe2w9ENKUIyd
	Zwv6f2FPowWJ+8VyhHvBV5Epzb+V6oQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64EF64401C;
	Wed, 25 Mar 2026 16:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896EEC2BCB0;
	Wed, 25 Mar 2026 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774454705;
	bh=xKyHHnfE0tC2xIkdwZIbRnzLQ1O2tfuWrdj8iWb9SOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VwHysNZhgi4E6w6jEX7YF05sr1annXgdYSmz9kXWfHqL6HeTMDki+JsI/P7mweVcs
	 ragu+sWHVwyMqTTWm6cDSA0+yPF1AYbbxfM2oLWJX3YhuUxYFITtKfX0OM1xZxrZq3
	 glh1gvES5VvQVbbXOuOPVkKbKne887yBhlI2BUnk=
Date: Wed, 25 Mar 2026 09:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 2/5] mm: introduce is_pmd_order helper
Message-Id: <20260325090503.50739871bd95a3e700e45a39@linux-foundation.org>
In-Reply-To: <74104214-5759-451d-9279-37498918ec3e@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325114022.444081-3-npache@redhat.com>
	<eed250c8-7a31-4ace-b5e2-9f2898599ec8@lucifer.local>
	<20260325074516.46bfcf772d5eb4482d7df36d@linux-foundation.org>
	<74104214-5759-451d-9279-37498918ec3e@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95878120019
X-Stat-Signature: 8f1qgpnm4zwe4hj9yuuzz6uc5rpi157h
X-Rspam-User: 
X-HE-Tag: 1774454706-302994
X-HE-Meta: U2FsdGVkX1978nWohY9R2/QvtfIBa7nThxKTzGA29Gr67QStG0RpugeGtT9P3UhvIuPu7oMYb2INlDddtUJNyMWhyzlw8tmY6OxxAPc75ckCEnrvt/8kd/KobMjTicshSLIBbdbz4MIygHoDQZlFQfrry0kjg61/Pz9cx6t4YCTWQJ71kxvSUP5IzvLr1k4GD3enRwTEAk95/mbMCi0hRfEC4x/aFdg7meNIiifBnRpmZsfjHR3Te9rXml5CJU+QVdKhfx78ct5pOVlS5ZWpH1YHfnLQoZbkZQURWuzfNRB7V3nb//rWRufTQGXa9Vc+WXeK7QcE/6ljfQBP31YsQbFVGam9gb9BKU5n8Xy+eAmmZeGAHXgSZ/bu0qTFN4QfES/CnoeyDzBX7skVrm1cZ1/u4YKA5UZDO/5Ie2QFbOj26GtOuD0745GL4JnfHo5apVpUAB8MNPpxGCbKP6epiUzirTYVs0GGItOG5BNa6nlMLqL8Mchp0Wkb8oRN/kRGfLbGWgH3JJ8Rf72ZUmflkfltODgpvrz8v37s5Mw6Mo6Siu+uvkuYoIZA/I3KP9QAyLmDEteqAP0f3/nuUPB8rRN7Wp5Ik/AdoYm4iehNZyKSfBR/Hwxhbw3I6GZvM0zImv6YiUOm/2MY43EroSRcQ5YGuAOTx0+vCDp9yog/HOHOGtmcn3Gp+ax1RL+1j4DUCzKHySJOrCErnF7m0CZqxFauswyUT1VP9TZYblm/6qY9yDKa3WCKKdmVKTmCiJixSd2LWhEPoY3BUXwf1GBdb9FHrEprJ/bMdntIf4hWYpLm3vFNCFr+qRACASeyZQ/V3QDjgA6kXirtShssgfo5K8jnUtDTJYTNK2ayw6hnp9k/CzBvTXkqR557Cwlp23g/4DNN9YNPwCEBpyGtrhPgoZ5YEbSDmh06YABF26/G6fLGNCSGKXaMMuqCGGISqJElE8MEIjdinQLMyha/q9A
 5Sn6DIVn
 sn338s81+5Oh/2ZWDrbZT5ChY/+21R/k00qalnkUPswLYXTIT9n6Y1HxgLF4CzfmOIU4loDqlJDOv+rwp8RqBY9rNveNY6QAhv7e0p3rCBLXdD27Z28S2TaLD+DX7/WxGH1/tHeevQOYkUJktkSwNP9DZ29Sk4K6/oKVMicq189xHonyGw1N/gAggisIA7IO08ZqfyBrejuo4UlKFuYW2Mp96glIs6oLKDMOGltWAWxlqYdKT9vZvczDRXagFZI8AxBGJ0arzpA3+3s93l6gOSnP85DJ180TNvv2jWk0CSDOXWpldjVFlrJEvW+TqydfSvPAe699OEylSOh5f5cHsgf/2CM73aX1YApOgoGANoQNKqEEX92StXD+sCZVwNbV1ThcJluO6a8zP6RUrm0S9DCBxwgCnWCb7sNmeSBiPmlBh/fcDgFFeQD6X6ckHYLk8J+bXDCQIhoLxBxzZp9dgXmw2f1gLzL077pLZOvr8ctJGKAsSkSztdw9XbGHCZSijnFAtaijsu7aPyaO6S24qElF4hOCHGsivSKEy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 14:49:30 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 07:45:16AM -0700, Andrew Morton wrote:
> > On Wed, 25 Mar 2026 12:11:43 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> > > On Wed, Mar 25, 2026 at 05:40:19AM -0600, Nico Pache wrote:
> > > > In order to add mTHP support to khugepaged, we will often be checking if a
> > > > given order is (or is not) a PMD order. Some places in the kernel already
> > > > use this check, so lets create a simple helper function to keep the code
> > > > clean and readable.
> > > >
> > > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > > > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >
> > > Nit, but could we please update both to:
> > >
> > > Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > hp2:/usr/src/25> grep lorenzo.stoakes@oracle.com patches/*.patch|wc -l
> > 105
> >
> > Please lmk if you'd prefer that I go through these and update the email
> > address.
> 
> That'd be useful thanks.
> 
> It's not a huge big deal, but trying to gently nudge the transition forwards a
> bit...

Done.

