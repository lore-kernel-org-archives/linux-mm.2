Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B877C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 04:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA926B0088; Sat, 12 Sep 2026 00:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B7A6B008C; Sat, 12 Sep 2026 00:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C838C6B0092; Sat, 12 Sep 2026 00:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC796B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:25:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 900F512040F
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:07 +0000 (UTC)
X-FDA: 85203820254.26.58F4249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D550B180002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BwBMXooH;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789187106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WD2psr2yzjyCJK4w/2X5moNA7VDH939yz28Da2OB/Wg=;
	b=8L6GNYK3NkrJOgpX8zKhM4xyUbEo6+Nrzw/VTnLuB2aeRLlxXW0lUajOhAzjg2Y/9nemqa
	UrkMGJ1tGVmbk94n/yyVBY5fty/uoWlmnPIYtBHuOoVy3/j3OU41G+F2ZBicGGCAdkdFTB
	lzhtMYWAN05XDicjebh9iVlWNGE3654=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BwBMXooH;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789187106;
	b=naAp+/a3hbADw2EgcumlbzMy5Wos0a/1uH05hA9xExy/XQB6vdawnvjcSCOqZfBw1VceUH
	Y7FTMZO8mzH/Y9jqLWefS0TaA00diGOFCqoWXaBJEAaEDk9K2bfZ8WczVf/WP31g1CQLQ9
	kotowzf1KJ83T+b86jrcUN1tpwjisZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B54C760210;
	Sat, 12 Sep 2026 04:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86D01F000FF;
	Sat, 12 Sep 2026 04:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789187104;
	bh=WD2psr2yzjyCJK4w/2X5moNA7VDH939yz28Da2OB/Wg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BwBMXooHh/FNWX+eVvSFWRbzYe6GxMeInSjLfY6+Uh9LrW8QyR6o6r0+nH+La9maz
	 b4H+drJ6+Gacit9buekB7BqVmjK0WJWa7BwKTcv7DOFGdtVXy8KSOZdZNjfMHdgOMB
	 jgsKImFGNu+YneeknvNigWDwqdNFh/vSUHU/NFhc=
Date: Fri, 11 Sep 2026 21:25:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org,
 jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, peterx@redhat.com,
 jgg@ziepe.ca, sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: stop calling pmd_folio() on special PMDs
Message-Id: <20260911212503.bcf8461db17ebbf51233826a@linux-foundation.org>
In-Reply-To: <20260912034833.2952750-1-gourry@gourry.net>
References: <20260912034833.2952750-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D550B180002
X-Stat-Signature: tg5m1wocrcq6rhwu3bxx4y9uwyubjfih
X-Rspam-User: 
X-HE-Tag: 1789187105-145551
X-HE-Meta: U2FsdGVkX1/zUZavW/H1yvcHpOmtVKSU0Ynhl+KbermnTq0SddYVS+B0XrviYopXEN74n4kS0BZ/ZjZvvUNYpuGe7BoPBdt1AP94hes1eX42zcRgEDixg34K4eQpJuTTuNPl4OGxbNdHjH/lz9lylPz2pdzR4aUoNbbNYzGtht5xuNa5KZiQ5mJ70+XI7Ai9zl2L1IMOn51uci+9vURmE8/n+2thrxF2zBY4pJY6X5OU3iLLbrtJSPQ8P+9y4h67gGCMAR23myT/MVgDAZSPGliA/mh1RKIslSyoXS9aE24odL+OUlsGpmbXO6PftmSzuDPpcPE/CRCXmElwn38ceX5so9XOvyIa1Muz9MTaLCd90nQi3AH6Kacfy9Me0ZVdxqWNrZwhd+Ek3NGdWDVp//Q1AkALcbqPqcJ91N07k4KnSRCWV35l+F5N4WU0hbc+BlKUn1V5l9mI0iPg0ncdOW363AK8+I/57W9aSeaTq0Fm12fuPmGBEaf1kfHCaGpINsWGQVDKDl844zGbnly+evzhEfbI9O6CSRNxrqo9xi+PrPyRCLUHHkmoU4v7aD5f4pWPEov7LMZr5gMMC265Fd5Z85Y22oOWMHgx4Jei8FvTb6qPdoytAYKN9mAm/Sa7h1zRFqHuUmp/s+FSbUclre3CGgP8SyzKn2uTh0Eq9i1/CkUK/MsW+Tp0gGreCCO1E0Vfdt/cK31+eHjmrRZWoBnTeyHjItKhbx6r8dew9BdR4zXDpfnXcINPHFOq5G3EgXHhROw11UEP6TVGET0/cW+Dn9gmK7wvAlhxqVooXefv54m4/E2SibrBIRFS//sQP7gyyZ/nyTtYOCr8RE82YMbYfVS0btuYNNX6Le9QQ1Iq2RY9sL7VSTimMKZFZIAHCHZIV3JI/6IBHtaQNpvOVgLWtmrWv8br32HflHzMOcvbBOpFHuBbNfOvDkhJy0/h6CjMNdZ6ntBgi6gn1Rn
 a/bRgCj+
 brw4CmSLGn7bkM49+t3F8pKUyMyAEjvhVwohKiuJOOaGS3pextGfvVA68lE18Pe92TVOpRpZKvQkH4YqxII5p6zNYUR8Q1D3v8Gy6MX0AA4uwJ/i1hYgX3ptv0j/l7SR/OFupqoO6oS/yCP0TAQNrFgHt9Adu9RAQGF7rAiM2KZE8Xv0dIUK5n4X6yhAJXoB4vO2HldtVrtxjT1qLGOeEh4ywF/0OUJgW2flG2mhXMFq+Q1XbRIh++18gzj1FiIL1B/GetEfq2GyAhTZUWfNThYIdOgZBqyp2L52Et5ddjY5LZe+QsJFcodE/KJfHkFH68mxUymqIBX3zvcCKykSs+r50AJRUGUjE9MiQH4w2mzdPpFsbYbjGskVN5tUUw/tCJwlRpnrRyQ5lo7jN72cJZFRbEovN9/yn3toYK9JO5afrh5l0GTuau/6Zhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 23:48:31 -0400 Gregory Price <gourry@gourry.net> wrote:

> Reproducer
> ==========
> 
> No hardware needed.  An out of tree module stands in for the drivers above:
> three misc devices, each with a ->huge_fault calling vmf_insert_pfn_pmd(),
> plus VM_HUGEPAGE so the fault path takes the PMD branch.

I take it there's no known way of triggering this in current mainline?

