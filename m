Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D0BCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 17:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE96A8E0003; Sat, 27 Sep 2025 13:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BCC8E0001; Sat, 27 Sep 2025 13:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A438E0003; Sat, 27 Sep 2025 13:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE6F8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:21:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 275EA140902
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 17:21:00 +0000 (UTC)
X-FDA: 83935695480.28.99C2F0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 985561C0008
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 17:20:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WNWK/UBb";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758993658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPFvFZpqjscR7nfqaX6NJJDHRV9COk9d8n8OMCkc0sk=;
	b=y7shHiaRl6qDRy2cKqF2VXU6p703h9n+crZZhvKKdCHph7n0o2bRKvu3IOVvz8OS/0d2li
	n1F5JyV/jIDJG0OH7cfPUoLp5Im4saqGOJHEW6AGlF3gg/grcGjvHsMexPNo91bbk0UXVA
	8MHTMgNq7DowBp1uhkqdPkbdHsLs3YY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WNWK/UBb";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758993658; a=rsa-sha256;
	cv=none;
	b=edWSjIf5mvAJjBo9sLvjnN0fbAA/GGyH752/C0la4rHmCEz0Oo73BagV9dDxa6QacyJtaN
	JIR4zlTDbT6bjEUaQEkD0L2R4ITD839BnIrsml4OpQEUOhvNPfQ8tXMAVDZGFeXfYp9PKt
	C4mitkyQz4b+ewrPUQGJFOxs7yevOnc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8BF0620A7;
	Sat, 27 Sep 2025 17:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D47C4CEE7;
	Sat, 27 Sep 2025 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758993657;
	bh=wS3DRm04+H3K/wyL5VDDsA9Fi2Z1LU9EV49a582r2IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNWK/UBbP6w9c8vIsjQlBmz8eWNW21TxeqJvX4kN5rrCtmMJaksWy3ght2ItZ8tEX
	 eLLrZrPQap4md+TiIU6cJ2iW76MlOzOVAXQ1iybr1DDvjYwmVyJlDNUifDNclmZdbQ
	 Zh96sIVhNCwh9W2wvZmvfnqmrFaTKI0fryK8ErnU2C/AvYQmdPhO1Ds2pnYFznb1g/
	 5OUHXz59ZS4kAKaosPqZpWWiJmaPqh0vs4ae9/xra34D0HyCVDiI/o6JxyieHgI11+
	 32XFj5LvPmcQRcc8GH4Ns+TE1COhMc6IOuiW7d5lmk2aVRLxQ/O1LzrRWdHRwFEvvv
	 KsxzyxZdqOuTw==
From: SeongJae Park <sj@kernel.org>
To: "jianyun.gao" <jianyungao89@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	damon@lists.linux.dev (open list:DATA ACCESS MONITOR),
	linux-kernel@vger.kernel.org (open list),
	kasan-dev@googlegroups.com (open list:KMSAN)
Subject: Re: [PATCH] mm: Fix some typos in mm module
Date: Sat, 27 Sep 2025 10:20:55 -0700
Message-Id: <20250927172055.54527-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250927080635.1502997-1-jianyungao89@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 985561C0008
X-Stat-Signature: amwrd1b7joxq4dhp7d7npnbxd3c7nkek
X-HE-Tag: 1758993658-808670
X-HE-Meta: U2FsdGVkX19W923tDp5LwH+0oeaZYKOJMlMs6nIsJoUxMUh5Ba2himq8UWr66Xkws5nnDZ9ggr14JDHZwVcM2tUvggllx5skq07SZA6Rqz9SQ6/XNNrKBbcSo77pBvPXcT0FTI0Tb798LaCNKZ/0I6hS5Xb6jYA0fP8PZmnjjiTd6PeMbqnB75ghxIitUZhCmQWmr6FjRIBUCohl0AGFrSn+HG1BRkcRHZQGZqERjf0Rm/ntgCGd/x2pli1zG2Nlqmn6u53HM3k1hza2mo+1FyA1PVB5oMLsWeM6EUu7rrPjSAD8VwluoN6leInxDoIp47IP2RuwJ6Le1MS10/893wuPL+2/tbQVNaxJRaXlKLZkySVM9WdiDxCl5eTPGCTaYqJw1+7ZIwpFrfOlEYWcFUB/8+zQY+XorHXyvK7dWiHUIlvlj6sYH0kmRQ6/C8cpDaE32sX9HPE8iLGmYWe1MjC8MnDawXqwSFTWagRUjJK1gY2UPWK4of/8pABttN4YOJg5u6txzBLNGzXoqJ1T4wJG8yi56LUvaEUki/Vf3/6Tazzf7y3q96nEVuxhgkZkgoPfEl3uhyKbl75ZLoewPEHn5YwhX3ldehqtPesIGkW/T26VtG+1bd5aC6CiQHNP7dOJnXj0oPbdSLrUp4bcR3HEgXMlf2Jf6u6Bz40DDvvK4/9rLLnLZojPFNbYv0loepAcjexNhe8MH6S0XdpTMYyEZQ+RO5VvbTAAiIvhuqQv/s4+wOj072Y4DtOXM0PUIJbfPJJDgjhGe7EvhtebKiQdj3ZkXEcLZUA4iB+kzspAtSLd3wZ5tNrugcvxmk7MGk3ViDR3ki9EivS/4jrvCkz7/4YqouJPANS+4TkuKehPpErx3Ll9RD6C7k3ZkJgR68FnQC2i5fWti4+2o95PHwXNTioYfMY3sdkyhWFFYlzgzbG/zUoTWPt2JrYWhhs+KhXzMDI/K3zszqnXhVS
 1jY/mj5V
 +GLj5oDuIm9PBHZAGoaVK9b9NgUGS4Ts0rnzOsBNx3scfkrC8QJ8SGk+JcDIYQrJp9wYWKc/uGkrtFpoKXG1hUo3gjdH4BkLUCXai0ZHgW3SOnG3MG++HkrQVBEXEjouEIgHwdTuv+6n9qBts0kUJK3bvq92Ubvy9YoA/MHBpuW9CTobpUruunR+LcRWuvMNyGpypyD3lRlcrAxBSHHh275+yf67VEAgjrNkhQc54iv+yoHzBUF0Vqx3LFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Sep 2025 16:06:34 +0800 "jianyun.gao" <jianyungao89@gmail.com> wrote:

> Below are some typos in the code comments:
> 
>   intevals ==> intervals
>   addesses ==> addresses
>   unavaliable ==> unavailable
>   facor ==> factor
>   droping ==> dropping
>   exlusive ==> exclusive
>   decription ==> description
>   confict ==> conflict
>   desriptions ==> descriptions
>   otherwize ==> otherwise
>   vlaue ==> value
>   cheching ==> checking
>   exisitng ==> existing
>   modifed ==> modified
> 
> Just fix it.

Thank you for fixing those!

> 
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

