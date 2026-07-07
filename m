Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1686CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB15C6B00A7; Tue,  7 Jul 2026 11:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D883A6B00AA; Tue,  7 Jul 2026 11:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EA56B00AB; Tue,  7 Jul 2026 11:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 998C96B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:28:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CA0B1680EF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:28:35 +0000 (UTC)
X-FDA: 84962362590.04.EB70F01
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8FBD120007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:28:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=V2mp06PI;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf13.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uks/4C8ANKSue2FooHR2fOD1vcHZENkZsyUiD1kh9o=;
	b=wGotOYIvkTGfvW46jgs3urX93vr1kkHIfYBNiS+jL3j7cMT4CmrFDyQmwkzssSV9oOUJ0q
	dYibu0WKd/SBQhtpbjmFC33r5PvP+z5tG1ucp/gDMpsgPvqjQlN3NfP/Tgq3Q7nlqP2L96
	8MrW01VlJTIiyZrNtt26KWEFjZsM0ds=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=V2mp06PI;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf13.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438113;
	b=iDrMq/9HJRnjQJnlSbvhco6e3pno0X1nIwWEhkeVYLT93gdBM0Bhsfp2MzrY4+/YIzGD7F
	ECLBEAnUVRo/iXhP5M2Aos22xCAA4b3SU9S7fY7IFAmEeFIM43G9njRJOfRewKVrM68h87
	WdY2xKh0rVcnwr26jzY4i/RsjO/KMcI=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B621340E029F;
	Tue,  7 Jul 2026 15:28:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HjE96e7rH9tE; Tue,  7 Jul 2026 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783438098; bh=2uks/4C8ANKSue2FooHR2fOD1vcHZENkZsyUiD1kh9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2mp06PImRVVEzD7A2oD392jDBI60ysYtmCiHBipsESyUCuuKNKsOzLY8q6dygURt
	 BDxIHof2aiJBwgMUq+1jrM4V4/xc+WJIG6boP7uiYF/+xEbS4BGchztjBmklDjp8Yr
	 h0i/kIvOnVyfxzwk8BM1HJ/lwrssZeWW+ZrI8ePAjjMNbvJyJSpL6pabT1g3yV7dv8
	 6A9KEc5WMGxNN86YX2GzIW+1YFM6t77X4hJoIe0mmzyZoq/wZ0qkYjyXaKvPOWWSHj
	 mC37rUs303+qjcvBfnT4jqfPxu7HAfK7jsOwWb1ayxbQbG5PbZQDnVLW2Hpo5rH9LQ
	 tl5NtRuhJHIrqs4u2hNDu9fQBfvnPDA11HlmrEDG5W7l3q5XQvDe64eDEC68vTf3HY
	 y+EZkfADz8Pfud3ktcA22n4JCXA6kLDOmabI/R/VCyZUmAB6zTJ/KAil39IOOy1y9Z
	 6gjFUXKDjP5B3S+uQyjHgD1jyor//QGGtxp0uk3Qb3V2GlyuBGIdvM4hBiyDwSNv2J
	 7bBcr7NEBAkICrPMpROHVYB9uqhdj50MoJD2+oiGBzOo3Q50OHZ//QnYaBcSQer2E5
	 y7pFEEbV8RKlqznif1e+jIwR8fdiCp9gewyjqKKYUPsVphJ5Th0IgUUeWH4ukdUQ2u
	 Z1iR5mX3OYcjm545s/E02/Bw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8C9540E0140;
	Tue,  7 Jul 2026 15:27:16 +0000 (UTC)
Date: Tue, 7 Jul 2026 08:27:13 -0700
From: Borislav Petkov <bp@alien8.de>
To: tao <tao.wangtao@honor.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, willy@infradead.org,
	sj@kernel.org, kees@kernel.org, luizcap@redhat.com,
	zhangjiao2@cmss.chinamobile.com, kas@kernel.org, ljs@kernel.org,
	hpa@zytor.com, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca,
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	muchun.song@linux.dev, baoquan.he@linux.dev,
	nao.horiguchi@gmail.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	pfalcato@suse.de, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev,
	ryncsn@gmail.com, jparsana@google.com, dvander@google.com,
	zhangji1@honor.com, wangzicheng@honor.com
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Message-ID: <20260707152713.GAak0a0fUAZN_5jgeR@fat_crate.local>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FBD120007
X-Stat-Signature: 7sibtmc9mqkmng7qxqpxi9i8rrsx43yn
X-HE-Tag: 1783438112-119151
X-HE-Meta: U2FsdGVkX18mVh48AwjMjQGlXqElWpd7kVxcCVcvx60vGjGLzyUvNX1PwdtvTAoRM/HMvczaZMedvxeTAYx0LCJOwKUq20t5Ae+rU33zywbgQ2ReBFKMEKpldAdDiTUSiZmnj6Pd7SncInhUfwrd68E8dbkdAQDR+94i4nrlTdBdgUMUJX1RBVxnrUjSKW/aa39FxzIxSbNVx4NOghiB/m8WjbugklN2dKfZ4UjIZnoWPrMCvazB7IlYuIcPmX36b/yNe2XJgvmqDXUSGQnaiXn3Fnx65hq2+zuvzckgNygW5FNniG4Fu4deFr+0RY4pOcKVQDm18RCPitq0shPKoPC6Eu2EJW57PgBtBfzmKCxak/yS25m1AM4HlLjjILK9e6mpRGgYI76P1ptmF37laiWRs5F6PGRYfPuFwNNsciXPIQytEg1xDlm+BdsgxjiOPeAUAC83pSoa7Bf0mD6uUuXR9tAthtQ44bTcQbwKczgFrZFoeU8WAc+vAny+wqz86yhu58SuApyFu6gOFjeOOE4B1yw06u0R/3IKtHsRABoEyDHOLpcdxPf3a/B8gaVYY5KUwbXSH/uePWqX2vSbXU7whMtlWReKci9/x5UEg1zRVN97M4SJPbLu88gfq0qMs8AndlhhfIUNcSVwa3bPiR6Y88Up/st85ZiF/6chvkzhdcPWnHTZEa8DXRg5Nt9sClm7At4YRn+nUkdsoi6bE+gczV3rZWG9Y7MskC0KwAi7NLoULc/uE4EubPlRBjrHcBADI0SDTyhxDOkaEkDr2hgqJrA1FQLdViP7XMGyyF8soojck6OdihUHH0qVbQQz8sIt7NmKaM36s2+AMYjD7G7pajkDtBZ8MqPrb9BQlZNLmmc8YvkpQAxyCdHFVErapap3Dpw33M0dHYXGwa8M74MZSg21M+AF4wI4aH8tEjoyE0nm0gE1GHwvEHlEb0Dm/dUbJvilC5ZQQ/pqWT9
 NAI2mtEU
 0yRbW/1+E4OVhnUx90XbgoAmF93NMTt2LMMbiieEW61j7U/bhjhPk4tQ28tgiPbcTtUQmtXNVVuA1cPgbjeX27w88nsEU/ZqACxoU0X0VEzhBDnfbz3gjLsSFsX6OAOXrUOFlxdtXE6k/G6qjcl7qNS4wLxkMQfYHRqwO3JvxUNe+WZObH0hCxOXC5pz8+8ABGJw5DIHusbu4dILZ1e7Ozupu0GCYVNYocByLab7Sx5t4IOEX8JPFG/f8K/DRNbcpqcsWILsxzyPsVjzaAYtKo5R0SWJycepVhFeYBnIouJx5gCY/rRRDNIaNvTCJUWvnbCuZl9FoM2WvtNUpwnrdgBvGKeRLxfoCaKxOp7BVinQhITIciOyTt9McTw0Cg1nNBDQ2roYQJ9PRD/Tsk4rbawiH5Hi654VYYTJc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:32:55PM +0800, tao wrote:
>  include/linux/mm.h       |   2 +
>  include/linux/mm_types.h |   2 +
>  include/linux/rmap.h     |  56 ++++
>  include/linux/rwsem.h    |  10 +
>  mm/Kconfig               |  37 +++
>  mm/internal.h            | 205 ++++++++++++
>  mm/ksm.c                 |  19 +-
>  mm/memory-failure.c      |   8 +-
>  mm/mmap.c                |   7 +-
>  mm/rmap.c                | 686 +++++++++++++++++++++++++++++++++++++--
>  mm/vma.c                 |  76 ++++-
>  mm/vma_init.c            |   2 +

Why am I on To: on this diffstat?

Please learn how to use ./scripts/get_maintainer.pl and do not spam unrelated
people with mail.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

