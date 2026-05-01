Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4175AFF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDA76B0088; Thu, 30 Apr 2026 20:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EB36B008A; Thu, 30 Apr 2026 20:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984696B008C; Thu, 30 Apr 2026 20:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 893406B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:57:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C01E51603CE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:57:37 +0000 (UTC)
X-FDA: 84717038154.24.C76E1BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 286FAC0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:57:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4gjkU8o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777597056; a=rsa-sha256;
	cv=none;
	b=vqThRIK8jFAJXjoUH2/FtJ5tYJT5riml+MNgK6m57b2XtOntsBhDQSJxNLHBEfHmd8kVi6
	xgZGbRs6gR2ENkNlvXrHxY+gaC1FFqMZ65WXfoF7bNRllEj2FOYkWYzp94jhx2SEf/3HXO
	NleB/3Q9kR5Iytobg75jJO3oZMbRuto=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4gjkU8o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777597056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8w7VAg5csyWpRDTQY9itJmt00aaoEhWbuqVoa8Vl2s=;
	b=o7ZRrTB4pOhfpzFb1w3Hu2areOoK3DabLCvx+fn5vZK95sCEZJcw2RdkOae0HCAqGM9jE/
	nVpfP1e2TbhyLv4v1rGx+OniRem0bESHfMHyQVLqGxbd3GvQz06xLX8IyodtOfpvn+fWfC
	HXCv8XWD7O3EX7D7yVYMy2RdBvR7fwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8174F60142;
	Fri,  1 May 2026 00:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDAEC2BCB3;
	Fri,  1 May 2026 00:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777597055;
	bh=1IYp1ZgJR/BbgkwxFxDNLAre0KLyvTjycCJgVR8+QvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4gjkU8oqLUPRx3qGLH8490ENePW9y9lwc3yOXNMHN8H/EgFcNsS6lprkjHWgI25t
	 Ni6TeSbD4U7paeoziYotvpo/8+Jhy6Jlv3xK5ign5rakizymNYvqqj9sEsH7FIOaTC
	 wCbqJpChFWpRQkkEja0p3kS1HcvwneAZk+rgny2N4KEeRVufiIN2urRteJ5VQqOISY
	 Y21k1pNuYwjZmpKROvuupMPSOO6IBWMLoicEnE1gh9cUer17jm6Cy28r5qSFnv0bVH
	 /PHmMwYtDe+1Hd7auk6z2WElzfYlExmypAidPIBL7GDgnyCCCFBCqpYM3WvXzC96sk
	 wJepV5iaSf6bA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/4] Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management documentation
Date: Thu, 30 Apr 2026 17:57:20 -0700
Message-ID: <20260501005721.79301-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430134139.2446417-5-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fakzq85ktycpgjn1cgk7f9p1wdwwb4ps
X-Rspam-User: 
X-Rspamd-Queue-Id: 286FAC0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777597055-942260
X-HE-Meta: U2FsdGVkX19zrQKbJYE0NSo/vzSCFgSE6MRpqlZJTGcmKfJzurhdnDfkxoRAtzbdLB6agsomJYNFqe//J1m9CkmLzXTWZboKOWxTH6JzG6rXh3S8XwNghxBKBXnikFs5wB2cVwbZTOtuc7oBPeUq5WD+GBccniWaC0a+KWXbMeJpJLq/z1SvAx7KobQ9bK6VJKzcqUW5vyDoecJ1/rBW1h1HB1WmBSKD2iGPX94ajuLumUWnQ5X+PTthxt6iRV19OTQnUNrPFk9Xq9uK+xJADtpXJJ/BuAQ+sRHKTYMQMJC8oqb7HQnrDxWMbyrKkpfBa7wF4eyplG7CCX+bUyS8canQmtcHBUZv6XSG8gOjZ2h3aeAY4te+Y2b5f+69GY3P3GnCNzZQtq+qNYio8E47otUATeLEEl9RKcQLIAIpZKr4sOmPVTHYh8aClEkdnr4ZC6ZWbvdwnZIscSWGivShHf49odH2xHpkNZ/ioRAG6pnsXfKHtvXGzWNmVLndEUee/nXzykCqztiMBHcnwdD51ceo32/EcddznJylah3czrKv9DBeF8bczXONg4gHO+nPYnikV7SwohlRbpApu+L1pvfI6Zin3L7eATVfTA0J+i+RrfJ1hWtvCdvacgvKT7N+IC+fCDO4UHTOrFVlwJxNOfbIgORjXFAkiLaVpLSR6uNCEPFlzC319eL5zMsF5YLv7cxYjsllKNUT+ElpeNVQqQYnbkpxco+ABvUArxoU3+x7tfjhgKGDjbS13MEcnopolgjjRQ3knnONQ9lS3fFgD4PJLYLUcDhGoRmS0zvz6CJ3/15WUs2fsIp3ujjjIhuln5rv/n3IKKrRuHodzviZkj5J9HJGywUkdgBEsv1Hu3Ef1daqgaGVIWnkMtOod8jb6ZTcKeFb68pnjsQ8PQBVLvfPNM3AkT4RgX/ZT4iYowx+23iIYsDxA57cI1f48ebIophS6DKqoAHNsxi/dbV
 t48lD6JG
 pKZkofKj4GYoaHJYX/iBeoCtHjs4T7d8qvJ5ITxvtI6ZnEf5YjH7Jt3PVf9QTXWpf9X/bgDJQf9fHndXDQtCO63qXE3PXbRl5YKFPVBmErrZWg6GrQxJR1iKQa6vMcm00BfOymzOwQdrGJM3HZoEwAVEqeWiiPSzpkzv9ffStI5YrrUqbG/+N/PHe+xZYP4pjzxEnCZ5WYX5ldKkD52a5eypyAxGDbN6pxrrhCc1BLfYfK6bfpLNo1De5KgY/Sm9H2Wi8V2xHXw3sKmboK9eo12JqX7uhQFj/z0+A3zvUFqlQPBbDehPPuNI/sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 13:41:39 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Add documentation for the DAMON-based Hugepage Management (DAMON_HUGEPAGE)
> feature, which automatically manages huge pages by identifying cold memory
> regions and collapsing them back to regular pages. The documentation covers
> the module's features, operation, and all available module parameters.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  .../admin-guide/mm/damon/hugepage.rst (new)   | 258 ++++++++++++++++++
>  Documentation/admin-guide/mm/damon/index.rst  |   1 +

I will review this after the discussion about whether it should be a sample
module or real world usage module is concluded, as this could be changed a lot
depending on the conclusion.


Thanks,
SJ

[...]

