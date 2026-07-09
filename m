Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B284C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BD86B0099; Thu,  9 Jul 2026 15:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523346B009D; Thu,  9 Jul 2026 15:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462536B009F; Thu,  9 Jul 2026 15:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215076B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:19:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BD1F8CDE9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:19:56 +0000 (UTC)
X-FDA: 84970203192.04.0734790
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1C90A4000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:19:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vklztZeQ;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783624795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywJuDuX3pJR00dpC/wU8zi9tZDyVl8qDRYGEK5siP2E=;
	b=SM8wuRMBukXWXIEbQZX6FEzYXKcD8T5OK3w037+Ll7yZc1nnVEIF7jwSj29XxsxCCecRwY
	Ru4N/ysebLO4g6u46ZIhRhhLWHLiiLaTWqQjP6JaCEbA3ttwazYN9/hJWj/NIZpLgzL4CQ
	8Tx5S84joc8I90JqXAx1a/8ZJZzf6B8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vklztZeQ;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783624795;
	b=F/kIfsM9rN6jLqTGMybqoIKYh7QkWuyiCSaBNYFvAfxfTtF6gTFAmIZ6nTFim2UGh3Ej52
	WdpRkuV2bjwaehA/V0IwvkthwkgkEUqfeMLqcGvlfPxlsKuBoRvLKANBzcqiwInUk8Kgmp
	C8XS47dmTrrgsOYbBHuch0fni6M8L1w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ywJuDuX3pJR00dpC/wU8zi9tZDyVl8qDRYGEK5siP2E=; b=vklztZeQzyUAabKNBVOE3K0ahb
	Ka1tU67W+PoS/sQxtr4NG4BQwiez3iuX5S2h36+DS+lX5zq2jLHmAVk6yKZ7hSqxZs0OLlg6xRg4j
	JafG3aADCjWO2kDujximy3Gcs051dMGvxswXCoD8wuGpcNKDkyfZ0uPdRJHw1ESJ6ol55rEb4e0je
	vbkVNOjnkOyjW9Z8LANE/jRcHyp2cbQMdYygffskKGtrI7tnNLqjDc5MEtkFGnQtpKl+GW/yqQHlF
	VUBDJnfND6Hcgj6XZrgT7g/DGF6nmmSgWKtZVv9r8rS7dYZvMcGcuIofpEac0HsIsIB5rs+Dw+Qzd
	e+7KN9Ug==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whuHn-00000005Rtz-0Jqc;
	Thu, 09 Jul 2026 19:19:51 +0000
Date: Thu, 9 Jul 2026 20:19:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 00/10] Use generic_file_read_iter() in hugetlbfs
Message-ID: <ak_0Vg7_qyPquaOh@casper.infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C90A4000C
X-Stat-Signature: 4xbonoxhqkprmh7q4r3cqq3ykxte8zpy
X-HE-Tag: 1783624794-904158
X-HE-Meta: U2FsdGVkX185kDg3AM8JAyKtadkK9+eTxQHCH25BsT4GTKQn9IeezqwgWkJecO+xsGOLcvUot5tJX8a/rEExZ215bvGVoYio2RncxVdE+vgN4uHXcajBu3OcBnC4KYlL25h3wSFxUhEwHIU0HyL9eoxS8S0vTd2Cf2H1J7bxJefju3T7HKzc5Tz7Cw9kzeRkK+xZkwmnBvxWw2JL8fQQDk4tRWcTI8e2qOd1kGoykI1DjLKT4X0FfviSD1T2QxteXR18IexuX4LXcq1dO/JwgPzyLbZDNPpdn0UtjcDuoEb0DBBgiC/ED8R06pU20hTJ0ImHaKn9hlOQSoehoiTKsZpnRWJlI5vAJ/TCQYz+rT07GDlA7JkTlmMgEl0ezTJPhCkarKQG1IQlIWS0Lz+PwxfAIQLgIDIqBNna/HqMi8hb4WKVnArFiP0GQKpMP2LILS7BhAZzxGl7/vOU5oB+0ht3gy2Cd+qTp/FhOaMnWgZ6PPdhhT19iT0Gkowb6XFDC/II9AJ2/ODdYbHQ0TlQcXZk+DU3AejrfzXbqTt/cne+iF0s7zvX3LzZ2IZ3u/JAiYVHc8gGjGRhbTIChDFMVQWq4WLyLWOjARCfIwcMoXc/nAXEZgp8yjAnbeVgHLAj1RFeLbXSL57rp+vsQTd6gMmBxyuvOTNuISOY2FBoqN6yTIIq4ozQVfIUrqhpaFOgFg41DkT1mHDXBkuC5v+q/68qLJrDMgYFY2pEQ9EfYwqSHlREjjzF3Qm7NbN56Jnp7kUQoBlLyz0dUU969Nzj2Xo7nICDoFEIWAswvZwvxV2cvmsbcfu6Q1+5IdACVDP0ho3huMUHyufdDntxfzSjFOwhx5w+JUpoAh4tO9QaKj2rgvEB/V2NcHfTdRqEgR16y+rWsgw2xb8JwZfqD+Vx0iDVdu8t3XiCrYz5EfYerTUhtDZlncasVy+wjyRj2v9CCj5OdPLL7ezb2ocvYiJ
 cdk9Tf+F
 /LoiBFaGcGXILZX7xbAEQGMh6nZYYqKZiyBckTxps+5ySDX4L3MQ1pkT5ClIwgxWmxyQIz7Z7u0wNFvswv4rjJAPLpKA8DN/OeZuryVOw1OjGfZilPOAnls7JiM3i6vCkQfxMq4hBV4pngIV2n7uMxpretqp0TN3m7FWuM/yZw6cA+V9b4Hzd4aQ0ABOrGq8aEiBb6KWuEB5+l+IlpqGc1BrzKLNu+J0HJNz1QT/1dpneTuVEVHhBdfUCU2iEPwzq/lixP686Yn30Zeip8b9daKM2QO8loB9ZOg8xY8DsJ3Jquht4ANoFkKDWuhWYZ1iPfTBdrYGr0vhvOfZnq3LW3n+W+uB4ndlqoxtjq8CQQypxbdEzwoL97IG7AiQkZIdthg9ejpvULCaw+nfMKjxAFZodhEO/HEQRl0eAzFQstNcuQ47EYBf+0edTCrOlGjCsy/NJ/Gm1LWg5glzgW+akmDOiX4kD8MNP0E3Bk8Nz9Qu7SNsO2bbOT2g5HRwX+2DJL4GC4ryNEUNwpGU01jZHyUtfXmRHY9JGlAxuCkrHt1OJN760b18TTnFUbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 07:47:28PM +0100, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> 
> There's enough potentially controversial things in here that I think
> it's worth considering them by themselves.  First, handling hwpoison
> in filemap_read().  I want this for shmem as well as for hugetlbfs (a
> later patchset, maybe).  Second, handling misses in the pagecache as
> holes rather than opportunities to populate the pagecache.
> 
> v1 here: https://lore.kernel.org/linux-mm/20260707181713.208282-1-willy@infradead.org/
> Sashiko had a lot of valuable feedback on that, and that's all addressed
> here except for the things that I don't think are relevant.

Well, Sashiko pointed out a few different things this time.  Will noodle
on them and produce a v3:

https://sashiko.dev/#/patchset/20260709184740.1286561-1-willy%40infradead.org

The only one I think is invalid is:

: Does returning 0 here with an empty batch cause an infinite loop in
: filemap_splice_read()?

No, it doesn't, because we don't call splice_read for hugetlbfs.

The rest all seem like legitimate concerns.  If anyone spots anything
else, let me know.  And really what I want from humans is higher level
feedback like "This is the wrong way to handle hwpoison, it should be
done inside copy_page_to_iter()".

