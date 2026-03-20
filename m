Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556411093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991C16B0418; Thu, 19 Mar 2026 23:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942886B042D; Thu, 19 Mar 2026 23:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8589B6B042E; Thu, 19 Mar 2026 23:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7011D6B0418
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:27:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EC7013B96B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:27:37 +0000 (UTC)
X-FDA: 84565006554.09.E5D3D17
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BE75100007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:27:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SkMEDsmk;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773977255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Josyn2zVO9ro+7tAnU82a7XOF9i0y5Y582jYl2b2RDk=;
	b=GjhmKUjF2i/1VkspUnb9kpoY0rC0OaWpEtETf+QFLfKnOObUtslN+ai0RMkH4Q6Z+Ykpw4
	tEv9CuNwYIG2e/bH7JqAYTe1J122iUkb9G36Z6qZ2KLhGD+1U/i/F0gfthmJTYgRpN9qz6
	vpzCqe7l+8ksOqc3tTI00zAtHcbr+SI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SkMEDsmk;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773977255; a=rsa-sha256;
	cv=none;
	b=2FdaM3xl0pa+PxBVINXR2TvVhyp2H572Dz46eKIsv/DwJsIA7vaLGZTOEHnPKe61RBWtq3
	2qXEWHB+skxAr82lXO20PLzlnkmZQo2Nkn/YTX7pzuk4FWbzkIceiRMVDmmvPmxpBzs08r
	wUvRTqKF6AYqS5ITcrekzqvLzQxJRb4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773977250; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Josyn2zVO9ro+7tAnU82a7XOF9i0y5Y582jYl2b2RDk=;
	b=SkMEDsmkHvyzwQBXPOo9xIqLV10Ld68g9fpwqoIvujVREW4ksSVspmvNS56V7GXtRxRGE/UsPINEHqcSlJOAw9E/Yg0EghOTSx0CPM14KLhS+gKt28ZYthhtoJWyxC8nCdZsI/iayEtZWPUgpO4f9k0+CinM80fPfipDQFspGfI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.K7pvd_1773977248;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K7pvd_1773977248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:27:29 +0800
Message-ID: <655fbfa3-5358-4290-b12e-f20cad2c87b2@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:27:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] mm/huge_memory: add a common exit path to
 zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <f5d3d47da1bc1607fc01604c0e803c3248d8a1fb.1773924928.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f5d3d47da1bc1607fc01604c0e803c3248d8a1fb.1773924928.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4BE75100007
X-Stat-Signature: 8ie15x16banhnsarb5f5ppu7waefwmhz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773977253-18993
X-HE-Meta: U2FsdGVkX1/LAZbfrxqJSUToKX29EAIZ3giAiMYURxJ5ak+g8JLl292DcB5WOiNXdZSzF+drITbM96WEIwWXPpTMDagAmm/BaL1JqphTGUh6gUuWuw72+GQPJbn++ZHdg8+za9kAw5cn+BiJw11M1WGVm/jpqKL4CsB1G+rGQAk7tF7FLN7T+U8WAxFnZpoG1+4yvbS5xZMmphEqziG982cnYwZgx2BrCEyH82NCXRS2bIGbwN13sshOuF6hhD6i4k59VSPoC4dxpbqdzAcCk7zp3ZluesUZuTwnV0ne6+KjK1g7OhTMOLinsEtNodvceF7VCg0Rg9hJ1MPMfgwIhWw5LVuHC/2wh+8gyvmD8ZryiHAYOqc3ezjYPFowajArteYiJcjKSqHP6pS1AGFqsCVnf9eTfh53Tfo2/FQhlIjg+xM+WSbLczEGOneKwGGRVD/q9AFBbKawhjoLybF0s/Hjp6gaF7vY1SnQ/Sit0jkWoo1tBuODfYMoAa0FIO06/btynAKFdfaMNjbC74x53AotaO9ke/4rV//QvLTQd3tdkW2C8uniBfnAxW63ce4wfUInYg9fu7MAkinAnkldQL6tjr7cVqDYYni3weLweuPQ7DTW1H88QFtX0Q4p4z01GTMZZASbDEBu7BwU2brwyOrZoq5hn7k3S2p+XyP+haYvcXHkKhTYB8YOjdRGgCiZwgNmxWlkqSnx6eqDyerW0+C2iqDeGrvduhV/fywcuGE+ZYATUtZi9S4K0o9CU27a0ofMSLKTea0pdPuigFeORXu+O1NpQ5zTMhg/E3HdKbjO0gP3Omz9DMjtLv9nrIu/Zg3ozFiOJfP65d+0RuPCnMqNtsFKGwPd22fzDk6r0KvCFIv+wLPtXwlmgH5IPTohI1tK/NQLarVsFk+w/W/lx5PC7cwJJ6EZ0WuXd326i08Q+6Js5+JgI/kZ6brXv+bW7aQTE0Qesli73p/YDsp
 bnFNXH4H
 Oa/d1TveuX9ctaGnUOg6fw50isEA8g/rvGzEOBDsxAp/dl/LoAOKDpgmYka1RiApryeEbMgT3/KKGl+Bp1FsfBRbVnVbkKnKE3r8Wux5psxCuTq6h9qyt0KdfMGSUlkSh9ro+PF3n/jIQVyBlsTpD3SuN3duB15/R1z7Lyagw/Zjj58OHmy40umon7ly459kiM48YwF5R28kBBhwnqBvU5kh8ZaSEG4QWzu22nT8CD4m1Yb7kgLFZb0u+y7vQC1pTzYBenTEKsvE08QxWmMzYoHWeJ8I89oZNEicPvu4Y5crYIyAx8OkBUj/biXMPBIMFgPdjyT//Yfdtp+8bHoKacLFlF0fqwqPpyqQT82SNG+a3bIJwdvUxTtI17w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
> Other than when we acquire the PTL, we always need to unlock the PTL, and
> optionally need to flush on exit.
> 
> The code is currently very duplicated in this respect, so default
> flush_needed to false, set it true in the case in which it's required, then
> share the same logic for all exit paths.
> 
> This also makes flush_needed make more sense as a function-scope value (we
> don't need to flush for the PFN map/mixed map, zero huge, error cases for
> instance).
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

