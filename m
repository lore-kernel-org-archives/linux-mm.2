Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43A5C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DE96B0092; Wed,  2 Sep 2026 16:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6DB6B0095; Wed,  2 Sep 2026 16:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF7B6B0096; Wed,  2 Sep 2026 16:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 304D06B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:44:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1841A03AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:44:21 +0000 (UTC)
X-FDA: 85169999922.07.5B38823
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23BB7A0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:44:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cvI5z0qY;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788381860;
	b=vAIWwJCG5Yp5S+dXy6RJCSEXAjoJF+x+xY1EXMnhtJJFaPMB7dPIFs40wqILQEn8mo9qMd
	uzcBptMAuij0EdFrGAVDkokrwTfDLYEsBwqW0Vp1Gw5kZH2BkJ0jHwmFMoIKWl7DAIkVQa
	MX7QvkOVFGb8yirda/yjlx/Hw1TLjWM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cvI5z0qY;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788381860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSgNjnh8lLWVVyFB4dtxw8VS2iuPHbxG9BXo7PwVjDA=;
	b=X/mRctZV6w3+QaBLoZubU5IQPdP+k9zvvXmqcUk1f5MmeBr82ixtpM/pFbfuonZWedYsDJ
	5ErcjoO84NGKzfgG81H7YeCnfGQ5Cxy6zas3izEg5mD75ZSeo71XBAFpwGOWnXk0VGOXCD
	9q03t5aUqduwjhJtE8sUxqRPoQt6bHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36A74601EF;
	Wed,  2 Sep 2026 20:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EE21F000E9;
	Wed,  2 Sep 2026 20:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381858;
	bh=qSgNjnh8lLWVVyFB4dtxw8VS2iuPHbxG9BXo7PwVjDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cvI5z0qYp/y5i2UlogUYll7apXy3p57/EUpKyeTITSkQgBrLYX7c3WWxXE/Lnpy59
	 +v4U5EUm+IjdYvf64PC9UMTVhP7Eo+4901Q3h7qtFcfh0FkONuj1CId83cn8QFLmPz
	 eebBfhDqGJV+qCIplXL6PpB28HpCgBSFE5ikYP1c=
Date: Wed, 2 Sep 2026 13:44:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
 <david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
Message-Id: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23BB7A0004
X-Stat-Signature: 5kkth3pfjcz5wa6p5g1846ec1pimaahf
X-HE-Tag: 1788381859-116110
X-HE-Meta: U2FsdGVkX1+rQXyw62Md6w2+Uh/gglvGJxujmffYucbopzEJRULBGnmVH5PhEXpGyniBJWwg6U6zLdREZ430aa+P2c1yqS2eFTcSFlQD7X+ZLNx8MJEh83NRzSGVg835VeVV/SUsmbOczGhQ9L+OA2MibkeT0OKS+bM5PFZ31THd493I2q+0VuiyLhCqV//742rCPmHveYal/xWfxH4SYO0H7Z9bXWHznGlIArK6kpUQxYXQIEWASNOwurui3cCSVxGlRfPPr3UGqCvL1DZw06oFunXKGqRPQszqKi6qdOug7OxIpZIvBA6SCGB8hY/UvPV1/gfRVvutYLAuEBtooYD/k1oHyuvUer3D0pyrLWItRl349IuUXBQj63i7aXCKo0X1+IRPcuR7GoFiLj27IaIpwMRDk970pWBz7qdRxE9IMDiKQLZAWNQgAH+2yj3hcM2OFNon4/1IS+4noBgOMsar88/IrZKPsHtVqJ+Bh4aLKnS7mZwKi2kYmslVT70pgV+wHA1WtUbTRwWAJy1YJAUl9H62zEbWLlbgY2N0lr7bHoq/ZkV5b3WOAOSN12Yecs9G+jE3uibLrOoMAelNF+ePHAyDASy4u7E7uWlxy4CMAMBVnTma/r5s8SHhJdO75NShqrFGZ4Z/c2XL0V+X5b0UIAdSZ8Hh9UzeLO1b/+GJubcbM0EMg2S7LYd2ajEEkDZMP6niXyT0ogrWuSFG02Y1CUQQEgAKPCzx3/2D9LGFrHlFrO4j2+HZxBYksXroG7hf1VJ7KGCs4FkbnQO+ZilTtEl3h6/zDq+IjWrfo/pXFjLQ60wVcMnlWfwFsytGJULI+3Wx8s0CIkTZ7vEkf4JuTNqf8bA9H18PqB6GCJpqDZDiclLkeMLMIXtcodIGhmuEgb32/E7X+U37fmNjw0H3oyhbAXRVE8NxdXzCRejwGlV7yIFalwb+GAmXMLREf6ANoLVK59priRs7ZYF
 Wzlmpxcj
 Zb+XavoBYKVeDm5one9NVaTdSOk1nGSYnXQUrAH908iUtbxUU++yTSWM2A9gz8xjlO157A6MU9I3hZVp0dnL9jekNajFDE12rSvmXmWo8ABp2WCS6bSc2BuCJZIb9TZAqarh710tg9FdPSWhTu89j5edOFpeJUScbZu+ah2jSClamXYuDmF13NNu1ZegsX6outM2z0HQjmELUHVmQ7LwBi0HgH4xtJ0tjnrsaZQmgFazBwZS40OEPo5fqGtwNq0BFn1QsY4LJjDsVgsNq9TitlMCEq0hFskDm6sN0ReOa/dfSfa9IvdiGeHM+uqJcssYLRSSTPb/4520+00Fid2qnpE+SjYxhLm1/UQ+umNH8jB+PCG+jHuOsErV5ypPbMJ1zU089
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 21:16:49 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
> is kcompactd or kswapd. Converting these to use kthread_func() frees up
> two valuable flag bits for future use.

Well that was popular.

Sashiko might have found a problem in the existing XFS code:

	https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com



