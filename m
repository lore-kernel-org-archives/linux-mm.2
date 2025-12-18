Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415ECD68BDD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C27A6B0088; Thu, 18 Dec 2025 02:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870686B0089; Thu, 18 Dec 2025 02:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752526B008A; Thu, 18 Dec 2025 02:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 662066B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:09:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FAB76085D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:09:24 +0000 (UTC)
X-FDA: 84231715848.25.E304D8D
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D19A16000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:09:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wo9TLXqB;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766041762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUoGWDo/ueOcvU1k8f5hEcEJi1kwbtQAhA8TscsLJ8c=;
	b=oYScDaan3OWri467dsG0l+PwFZdeaCQ4xqVC/siRUC2MjoX1FHC1zqb2bqlV4+DN/Mm4GO
	68bU3cwmx2EJUlvKMSVISnGcIjuJ486J/ZXA7eXEodP2LHcVL2bYufcY/Oga8CTYYeTxog
	yZbAOPyKZY2CRYiPJNPFUDO1564nXis=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wo9TLXqB;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766041762; a=rsa-sha256;
	cv=none;
	b=CLP9lcOaW7v8QRoGInxGBLkjytdoxFrmzO5OY7uIqO0tILvDZYvzeFnzuS4ZZ6S8abCVXx
	evT1QjyKMkizmCcHv+26HNHsh3LHhQqvc1V/WKY4Q9i+AgCAmbErw8sO+5YUhEmcISbEcT
	/9cCPVKtL7kJ4ggku6NnOPxWn7RYbKY=
Message-ID: <8aee44f5-11ec-410a-9b45-5cb224e9e23a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766041759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BUoGWDo/ueOcvU1k8f5hEcEJi1kwbtQAhA8TscsLJ8c=;
	b=wo9TLXqBZg4c+msgguYsic0XAZGdytn6yFZ3/W45uO5LfEOX9QMvyNr5REVy1yBgtjP/GH
	KNsaOWX0RZJDlSuKh7JM+rbcn9obJMFT8Byxvn/J43GwgGJDRn1eZ2CI7aI+UG1NgTiIpW
	LiEqHefQt8UMdpFjTS+Z4nlZuU6nv6c=
Date: Thu, 18 Dec 2025 15:09:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 20/28] mm: zswap: prevent lruvec release in
 zswap_folio_swapin()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
 <aUMvp5WzDp6dZCVr@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUMvp5WzDp6dZCVr@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D19A16000D
X-Stat-Signature: ujpqu8jwrykkixfrtymjhsk8pf1ztxdj
X-HE-Tag: 1766041761-309656
X-HE-Meta: U2FsdGVkX186qGZGBjZyTt3uj5gW1yV3dZoqjmxUp4liOIb5p9PUE42HXiCmsAwdJk8S6tufNqwz4LunfwoWQe+M5b9cjAbpyqgnsDoOqQ+COU9DY8IL2B1JKyI3qPqsQfoiYF5+Pde/lMMP06gGH8TFp3ieZQmqgoSZFhpaNcsVyCKYngD4p5aoZE7IACoN0/Xyk35xV7PdP1kLfMPgXYUhNIHW3+dxq9sb6PQnqYvoYoT7AnZ1AF+ib9iTM0vgpUMaMxnX8RFy5/ip/aEL2LdT66dS/tWM0R6geU3W5HxYBXp+Y1iLHV7K52Lfs1Y1uffQAPM+lGR1VrZT6/7Y1+nyY8jwDit7Gsd306UMNF/ME18BXX/hYuXV5oZMNNG5/liNu83NoTLRYDVIWmVJLTw2j46yGvG/IwY4Y6eCFGRCNCr6VoNP2zErkGbQkYToaUC1+r2175c+IG1myIKxCnNv+BrEEsCznHPseHL/FNXwo7P/fjz6F8YmXC2/TVehXusX6UuAWYutt74fVuff8K7GJQnZVnZGfYKsgEvSH6HKSsQRQS9dGgE/MY1uIQ8xk+BkFrwGL36MIWpdxqoyFwJBiKQVMmrsTz9YPAGhdk0Ame7/5z1H0dF+0O1OUobWNSY6qEd5aD/1gKpU0UnrqXFIzSYDcTSNWCy8Uh6T9a8IcuFgJ1+xW+YvrOZrdHEo4MwdMRFpqtU6XLWjTDkiXv1GdU+sd2N3vp9f/jln58Ea3VKvCuxpPqIsCuxfQAUrsiMKQ0cVdXqLji54Jhu6U3Dg/tDp5EDAxdnzdpkqjWyJ/5a0mLxE0xlxI0N+FsAYlWZIxs/+9rwUS00r2G/UvsGff5YSk45y/SAg5EEw4D6ih51yJGc77C9dUrLk6E7XriKNTIC62DkCks6hs0h/ebgn02mTQyetIGgg2R+DW/ko0/DUskF9hfRB37XaWyXXtjlMqszSanWKaBOL97T
 yndUYaeg
 2U5dV1Wop8tdbRp+lA2g7RgAbeTz42sbuDP/+Tn7FNc4RU/vz6FnGbJMq2dkhragJNmJ39QIyezy66kxDFAY+sUDjY6+SKgJ2mB6VcgjZAwKMKnCBBvi66PKnnkM1FXOf46eH6D4EYr0Hm4LjSMz+IKgd+1tOQDI8c5NPKEGFTFeWAHBb26NTheZzYT7fhruNcbmBXuwONyDFBlIdYQ8JD4RMWqmUQo+GHwKvyHITHVlThPuxo6HbdFFISQ2ZttqL+ZjrQUSAAcSbT/LnmydqczZzvq37ZvURPxniytvG4XctjHX3Y3/mgt24RkgEGXITIqjDQ04GOWV2pgRdWBhQGHx8IjEOy801Qie/odLwqr2PU5KJbNnCxtk7ue0bYTNPlHSQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 6:33 AM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:44PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. So an lruvec returned by folio_lruvec() could be
>> released without the rcu read lock or a reference to its memory
>> cgroup.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the lruvec in zswap_folio_swapin().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Nhat Pham <nphamcs@gmail.com>
>> Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!

> 
> Btw, it would make the series shorter if you combined the changes to
> workingset.c, zswap.c etc. It should still be easy to review as long
> as you just stick to making folio_memcg(), folio_lruvec() calls safe.

I prefer to separate them. For example, as you pointed out, in some
places, it would be more appropriate to switch to use
get_mem_cgroup_from_folio() to handle it. Separating them also makes
subsequent updates and iterations easier.



