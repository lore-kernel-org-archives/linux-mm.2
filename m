Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14138106FD68
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669D16B0005; Thu, 12 Mar 2026 22:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617A46B0088; Thu, 12 Mar 2026 22:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9456B0089; Thu, 12 Mar 2026 22:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8826B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:25:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A77DB160698
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:25:50 +0000 (UTC)
X-FDA: 84539449260.18.CBA6F41
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D3FD18000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:25:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="b7E/eUVf";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773368748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWwNJT14PCK1Z6vJwC1eY4CLOkFnzy21NPPOxNIkUno=;
	b=pqDRgveJCC/PcxfnmuwZTcieuSwk0sl03tgEKh87cB2sUoY+GHZTeTqVeOMgaAAHMtIhZz
	W1P1AhOxaPeZwl02CzdVCe9+4KgLJbXy1JXWKNsELvV31kD8GXN89f92KbpSpXMPsDzWla
	PfYJXf5zMwOLwGJm7h8rfEPwR+b+ZT4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="b7E/eUVf";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773368748; a=rsa-sha256;
	cv=none;
	b=zzjPe0HwBKc8qPhoknOPgRHqwdedG0fuMMoP0CNvMjWby7Ste0GFSHEr1as9VsDRLxy1t7
	boKDE07iwOU01UhKpx46J4Kkhm2/IaCTkmtPmfy5akQKcAlpl7oP+cjeYjOAb1HvPgx2n7
	3L6qXPBuiIrrpWkSojB5jTDBSCSQWa0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773368747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tWwNJT14PCK1Z6vJwC1eY4CLOkFnzy21NPPOxNIkUno=;
	b=b7E/eUVfpAzg3adITWNB9R8/wzFdIijH5W+hHC60Ds2l3HnKGTjiF8/o8xhLC7fpS8i9ti
	7lfjF7t/l4oRlQ9RqSxN+n4pVa3dGwgKzzf5mPpjx2PO/xsBXA4X5j66HwhvoxpCEgw9hw
	QkAKJ19dIIRg4JXjBIp6+xkQmYsRF98=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-lg-MkysrPSK6HjkozIXAtQ-1; Thu,
 12 Mar 2026 22:25:42 -0400
X-MC-Unique: lg-MkysrPSK6HjkozIXAtQ-1
X-Mimecast-MFC-AGG-ID: lg-MkysrPSK6HjkozIXAtQ_1773368740
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7D6118005B2;
	Fri, 13 Mar 2026 02:25:39 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.171])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BAB9180035F;
	Fri, 13 Mar 2026 02:25:27 +0000 (UTC)
Date: Fri, 13 Mar 2026 10:25:21 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <abN1kdjgA-B73Sz-@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <cb35f32d-ee65-4865-8664-1c9d7547bd5a@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cb35f32d-ee65-4865-8664-1c9d7547bd5a@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: MnO5_V3BuhSL6PffKmMOL9Ucn-QxF9R0WJhxoYinTpI_1773368740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D3FD18000E
X-Stat-Signature: a7zhsbjjgtach1omoesojfa9kz5e83bm
X-Rspam-User: 
X-HE-Tag: 1773368748-151732
X-HE-Meta: U2FsdGVkX1+RJvUoLYxV3SbQVjH+2E6YO/Wo+0fO2dJXYbZWYf02yYqLRI52hdaXQpzrcP0yv9VK7nNv2U6z6jhU1rqlVbmUY39qvx/iTVtHnu7t2KtTpvqdnTh7ua1dip3MuWxjE0LCay85BMPWYy5nrG43thG47Y7EWI+5gpKQ2rv/19vUmIb41TplZgE57U4PwSS759N8HctR8g5wYl0Rm0WPIzLA4/UaTqJ9lBhMKgvKFSvSSBqfKm/r8dM2a6pXn25+fTH9tQ9skg0ACZxm0vdwcLRNqoD/2pwln4I+a2pU66MorNV2HCA3xoFMzMVNYPPJyk2+Y9dQc8fBC9M7BwxRgAuhxZEe/FJyPBUh3Enhb7531VapdTMTKiqL4ZaH0QYyaTTxSoTimwqrXJR4wREnxvvaU5lPKFSLJUku+JaDpsKX0cNi4LMzBUZ/PQyNXUB+HFVlETeA1b3TxPkXMcFg/HtvTp4GgiqKmIiU1tgRXs5xvtdsTi4yfpCKWHpWxUa9k2A1oQRNwy/9c3dIBii7VW/Q0R7T2jnfuKhGLHSXxoTWiIw2BYAWdhaJot74IIeUhVsNeonSbe5y8+sudutgI5ygfQoytyQ/cN5+3W4rgcqfSKFftwrPyoelvNAsKKh9v12k1pwIPiZ/9veII+vpSCtHecLyZIwChTykcKmpHpmQDuEYWmJyj8Tuvp55WEhzCmccI8Vu75o341rZ/9FvddtPmeZgReZ01qVW+1p2vk6rHW00KzVRj4vn/wUK1FP1pvcP7dwcWQSYA9IfyE1ww/Ta5FNnsDbvyD0Sefj36oYGHEsYBHmwYkShJW5vIv6a2XfRE0MizGJ0CEYVOlLc18MJl91UvPbYVGxfmkG93DsRWYP0EFBuirOZZI7SFbQrCpk3cZAgDZ3l8LCYvu5AAmt4pqMZxF6/i/G26N+YV4Nr4zVAFxTwNeInw3XaibVqCad99XVm87S
 qmKnNOQM
 oraFD+sA+BrKJoKgVfv1oWZ0DAXopsfcDiCz+b6mGf1St1VkTlaLsCXJEsOynRDp8XVtk3xX6b75W2TuN6RVuMnaarTiPqLXdwnJOo+Jj4q8wjTzA7OLeZYBu/MMa56TLB+LcWVNTHo1o7haSUgf9Q6fUkNVlttzxJmE/ha3nT3VZHSeOqNvEocZOu63mzZv6USPE+/b/AYrs15Rf8/h92jokWZpbF+2RG1nzXW2ale/1xrqcYiZj6BMj97OwKo6PkR97I+HviQHjB0cTnLkthLx65ed5n2jdh3cAsaymT1WuZ7Lmw0hlIFTe7iXEuy9mAqrNNjAGddZt0v6br8vSRTubYlivKpQUBGg6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:44:46PM +0100, David Hildenbrand (Arm) wrote:
> 
> >  
> > +	if (!thp_is_enabled()) {
> > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > +	}
> > +
> 
> No need for the {}

Oops, my bad. I overlooked it when checking patch. Will fix in v2.

> 
> -- 
> Cheers,
> 
> David
> 


