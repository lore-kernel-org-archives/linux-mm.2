Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC0FE668A2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE92E6B0088; Fri, 19 Dec 2025 18:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96C16B0089; Fri, 19 Dec 2025 18:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA26D6B008A; Fri, 19 Dec 2025 18:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAB7B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:51:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 419C6136FC1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:51:43 +0000 (UTC)
X-FDA: 84237870486.30.553BE9D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A5851A0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:51:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BuTPEfHz;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766188301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCrh45RVm6ird5mYb6C/XHEt4dgYPxVyQmx1eiSJEWM=;
	b=vFyX8MUXXOYfcIt+If4hgGh1JAd6/o16jGLE26uFL4TUINCTbmecAPmnDK2x56xsL7T5/b
	5OcI/k2/HBQ0/i5u+umA2EHZFAdRHAcm73jNu4KIBMGEDPw1W3WGX3Uu6wczyO2xvvIT3b
	dGpiX/OzmSDB4LWzcNG0OgNgl7A4a9Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BuTPEfHz;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766188301; a=rsa-sha256;
	cv=none;
	b=FWS3AJtVo7MSJImCyBlArjhJVbS59u5BO+g5nQEDoh2IVOQ1D9SVaZplJBFAhBLVeoIFG0
	lsZo55uLh6OUzZWbm3rgXJS1mFHTqgKa1m1FLszu+veinBUYCPY9TjLQIGs0EDfJVuCxyr
	abqEfUiPhuXL25eugPTbGacJcDZ5HBQ=
Date: Fri, 19 Dec 2025 15:51:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766188294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XCrh45RVm6ird5mYb6C/XHEt4dgYPxVyQmx1eiSJEWM=;
	b=BuTPEfHzEXHAWe9VeYOFKGU8Zgr8LTdKcvswRzA2SueIoGtOQP1J3qyYq3L6ogSrPNQ0+k
	GhZuAcZOGPPyIU2NBBQ8pWFdTltNL3DkMYj3liUbjN2NHdMdlzN7HK72O78zpyHPcfePUa
	YNX8bzInWtXOCw6PixjxVzaiZpeAWUQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
Message-ID: <4icfifjfr77f4yle5cn4buotiscvpwxccxerwuzuj227l5kqs2@bdkeysc6xigp>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 91btz8oarrn13xft67ey5uijh886fijd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A5851A0003
X-HE-Tag: 1766188301-270728
X-HE-Meta: U2FsdGVkX18/j7LONlRXy6vmbTkP1rrpVJ+5SCQIms8TyumlDYdshICjLoKZmVD7HV0ShvkpeOZV9ImGogM9wfEnrwZhgBh+1XyA8Zpq6tagJ+Uhr7MwWZIYkFqx30z8QaBg9TmpatKFd7fCezGUX7vSzS3HPdLSDkjtOGd30oNNKwCE16XzFBK7LxarLnk5mUcVD5x9HoswEMMEL3IPH3IN7En2BSthevEw5cNPfchc4aFe/ahIxlaoatXCVrd9xBnF9PnsVv+7D+eOP6yl3MLweEQLz4k1lcSwFMzxTlwry4fyhlv/SmLOcxitCpcoVV5kaYHxrTc5Rhag7pJ79KtYJQdpKKXlhLNVa4pyCXXTnE+iziCJidymLejWkgrbSoSFWOOX6PSvh1IdTIq4i3UFQ4B1sp/lbElmgk/fJeB/WQ0bAqXbuWNzn6X36At8mArAYnzm5oQM/Nirw7DwUsx10OZbMd0kL0G8tbLPI7bdtheo/P6QSoBAFS78Y9OTnEF2ipb7PDwQM1VnB/ufteqzqEpcFegXU5d1Q2AWZAruv45mVYTsd9/d105EZAuZ1U19Ndaa2H5qN3M2b/qaDMh3hZbaG2O+FqEk4kVbcmsN1VR3ZyPaFILcNUGIzvnif/1FMbP54S+NznCUKQBVgVm13pRL2le87cl7OChbxFaBfkOXYEXGEZJn7G8ZyahI3avGZXCRkmRpIyKRRkMPCpHO1Ob/uiHgM7YIz04ce/yUFoKB8mfuqoacoEoGq34OPQr+Wm0LskHaGX2fewVwY5FxDfz7ygpvTL08L+szB6Ld9xZzBVy7FoFoSh1qcfLv0uzAhEVzM91hXPTgHhHjnPscquw42rvL6PqPEQAPOFVeVw4Aqs//7KCnFBdBdwnVjuA2xvw/+HHjdtvEhkJOpa/3//4OgR5iEzfB1f3xPBgSJVP+YLzuJg6TRZ3iSIDiOJf8KeU0onSeu7VtBdW
 j1N1sZln
 q4avN3lnwy1izNrkmTlUsX3q4UNq0sGuje1EsS5OEpcPY/ixmIbuNoiD0RtphAHylw0fqzSCiswLEiUwqC526uBvOieGgF9RjnNKeBAOmkCMP6o50btOjp9O/mi59Z6SmDoMyejhEELLPExrSKU8Lnr8TbRXt+UPsxXNRzokP9dnGaAbBaDJmHw3IFSOesoqGcVBFMy2A9GstjUcH324s3xKWEX3IfsfRHm+OTQAJnOWEjgIzctBjlvNpzuMq2bYDaqWloZCmLTM35OKzUk6ov6nqezAKCLL5boqhS3+Ic8E8kpBqzqKgHxRJXL5rzemSg9yiB+aVS2FbBmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:37PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in folio_migrate_mapping().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

