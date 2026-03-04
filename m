Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A73EFCE4C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A328B6B0005; Wed,  4 Mar 2026 17:07:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFB56B0088; Wed,  4 Mar 2026 17:07:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB6C6B0089; Wed,  4 Mar 2026 17:07:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE696B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:07:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DDDC1406A7
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:07:01 +0000 (UTC)
X-FDA: 84509766642.21.71D648C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90C82C000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:06:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z+5mes6F;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772662019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFZcMxf240bThUw0U8FpeAM6uRw2SX21qR8oecXjMS4=;
	b=G4qI+4DrOWMZI0NbvSAqhoSQuS9+OsHz3RaxfDSBm0Jhp1XkhrByPsfq9hfJE+V6pLN0SK
	EZdQvwN0lHmYVZW2QxpSCi/hYs1o+CHJNxOo6yimcIQRe4bUsSrG+YYGz54/+adSBUFxRu
	8ZpWqJEf64d5cHi5U9af7pyMs8EgK7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z+5mes6F;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772662019; a=rsa-sha256;
	cv=none;
	b=Gv3W+VLme45CWeVCXSvr96Q6e6HYGgRTEOh2JAXipGzoxz0qdsTiUsL0bnWvIMIGzTg1Qj
	qGgo29uCtBL4ZmYmUpxnJk0/ji4idVSgvhFCuy8yYM2EaHcy2CVrwLAo7YAiqlgXE0YCEC
	BvOlFj64sizUkCpthyd7ttdIBuAayps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0D19600AE;
	Wed,  4 Mar 2026 22:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C7CC4CEF7;
	Wed,  4 Mar 2026 22:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772662018;
	bh=8Xl8IT7hq0toAnUmrvgPTcJcEweAl8oRj1L2Yr23ZGI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z+5mes6FwNQGeJ64sQB9kTOAb1+U3o9CXqvn1QVnqtL3RkKbqtyrvwrfVJsQCoym2
	 K9kpNjb1puSgMCJuWYIntDZ/rfgjjkKYkAr3WKadzl1LAj6Q1BSgZqyvQCYlJ6BGea
	 QPWtnY0yAdaDZNMpYxglGqQe28i4oQ0QlBn4C/pQ=
Date: Wed, 4 Mar 2026 14:06:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-Id: <20260304140656.10c524970519de373accca0b@linux-foundation.org>
In-Reply-To: <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
	<20260228072556.31793-1-qi.zheng@linux.dev>
	<CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
	<de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
	<46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
	<22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90C82C000B
X-Stat-Signature: mrmowk799xbodni9h988z1uo71jraype
X-Rspam-User: 
X-HE-Tag: 1772662019-951738
X-HE-Meta: U2FsdGVkX18XpOpWGFwP5brGC25bggYjxc3Qp0AyZFkyp3H7dLAU32Cp3+TWukPITeXvBQbHotWy9OnqMjdw94zzYlrqeptcwgO5NrXhsNe984Yxtpi9MQZ1DjhMPekWNrF/eU61sMBYNABhDWfhJmp2eujQ8WxsCYArP7E9cyYlq5K3xL7k9WhGCG7lzy5Xh7YyGy9BR8NvvB1lVvyVHyx4tGW9hRERabgOzF2dZIpWnpdwm94avloRaRH5X1gpNTGldiTWUPvV2BDiBGlNQjI0JlTRcPuehDGQvXkIglir71lGInII3m2TeTccqFA96g60Ee/O6mUS5m/qflNWgzDiGNHDfOAR7VnGTbO0oBNSWr+UCRK1SXml0zKztOjVES5yQYFaSA7wPruw17T1nqq1T+KdplmVaf4ewwWWITALNQsQY12t4hMgExrjgQPFdo9rGX7miitVzVAdpAnQI8lbRWnlzs13Iq5R/AlYb774HyNfrKYTeJC1fjlq9WuwHzZYCr0AO33TEIBZxfrHOQjOYsNx/EIFNTO+288igw6BkF8cBn0ASReRPHk+fJBVTt7SleGHmfb11tny4W9Vrz/4zgWH7Lw1yXlekEeYYf6MfWNc591zmo5mjcNxGVG7ghM3EtMtjbNvsXp5LrI7ACnyMvhibHh+X8M/bau9Ym/tAWH+oWt33p0dd/4hY5tNqsxwGeWfLUq3XYUJfn7cunfdPO6yJWnspppDICELhb4ussdbt5iWtMCy1yMIuC0+NS0zu0L9JyG5qjtRofpCWZ39fHIMQf23x/04yNxAa7tGMNgRHhDCgOc1I4FvWZE6YxaYxxg68emXM2CbT34urG99neRH6WiAW4JEX64rZxvX2y6hfroUai6PCrchIUNuqVcxnmGzLL6uWGjFd/yuxwUsmx3YCTLeER+Cmzt3GTP9JE72YRoD08DZtLGcnd8anZw4Bv1/P5i67IJcBlF
 CUY9MLiT
 +3TPIbnzf8Ebqm3iMm3knKMGv7XJzMolVyeHbQQ5IIRXZfO5xo4dKYa5N+B+H1goySnrVFBAywXXKRTgaWtfxVvVjEZeo5aO2ODMQMCjUz6YD/fW3yl3M1pRkjNp3sQKuOWlHjOZpjTNtgxzhdtxaWyiE2b2meX7NG1MF6UvokInobEttYq+4y4xppxPd9k00L9mWpGHeQUcpZGNe1ijLQYAt02uZnFOxRPUHb0efh+SMvTqXVH0Te2iEwCx8xyBuLRnYg9kk3Jd8PFWPxuG0gHgsOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 15:56:42 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6044,8 +6044,8 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, 
> const char *name, umode_t mode)
>    */
>   static void css_killed_work_fn(struct work_struct *work)
>   {
> -       struct cgroup_subsys_state *css =
> -               container_of(work, struct cgroup_subsys_state, 
> destroy_work);

Lots of wordwrapping in this patch.

