Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F90CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E826B0027; Wed, 27 Aug 2025 22:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F67C6B0028; Wed, 27 Aug 2025 22:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BC96B0029; Wed, 27 Aug 2025 22:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFE06B0027
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:49:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2FC911965D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:49:37 +0000 (UTC)
X-FDA: 83824635594.27.B2A453C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4042F4000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:49:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AacTSgpz;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VziM3uC7KHxiZwEfI3ADjtsbz6ZHawjYyYSaKG08lVI=;
	b=OuiUgXVSvHsBfyeHaQy+UsKQMXlnIidBoz3wOOZ9433aaWN13a/gmOCuzQDUAhG9LC3mug
	nvjD09rKyB65hMn65FwiOKTbUTgQ03qLtAOT+6bgnIVukQs7TPakibZklCTRRkLKmnjlXR
	cs+YKcujITJmhx0jmVTWM+quLeW9fOM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AacTSgpz;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349376; a=rsa-sha256;
	cv=none;
	b=D0GCqhzCuWUqeUGXGaif8Gn+kV3iD70SFhyM9SwzI2aS3oz/0F12xgOW9Dv8q+Njwe5q3M
	HbENpu0T04vEMGwutavbh44io5Rd3e9gVkFvO9D5ACTa65/shC8fm3rKJOXnK+t4zQl95D
	a3GTDwewFeYt4nuJ7DDF7bI+J3/ShWQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F48443F61;
	Thu, 28 Aug 2025 02:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D77C4CEEB;
	Thu, 28 Aug 2025 02:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756349375;
	bh=MY12FLgHJvDO8ZWuSX9iiKYIYofyf+wiN9Q7AGKJHTs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AacTSgpzIB8RE6dH17Zp/HcjWv29c1bx6rPALNeUjF0fsPcoc8wCkBSjEn2pJz6Tt
	 CxbciPpAX5WkmVvXhjDXrMj1kDhLHlZlvrfrNlWBKp+NgXW5uEdfnW0/WRynJLwzXZ
	 JpgK0vmR6luiag+OecOwILbQyzDBQl7D9fkx7zPs=
Date: Wed, 27 Aug 2025 19:49:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert
 "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
Message-Id: <20250827194934.f30fe19856fc343005c9703f@linux-foundation.org>
In-Reply-To: <0138514f-c580-c066-c16d-2a0b207e0604@huawei.com>
References: <20250826030955.2898709-1-linmiaohe@huawei.com>
	<20250826203552.b4340b12b16a374396f49343@linux-foundation.org>
	<0138514f-c580-c066-c16d-2a0b207e0604@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jyqu9h6htmgmt8aqbmisgho4mey76wzr
X-Rspam-User: 
X-Rspamd-Queue-Id: 4042F4000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756349376-3018
X-HE-Meta: U2FsdGVkX1/es0Q/6AzgQGtPmEqfbmjx2oPDG0YVUvsJODlnsjnKOZDuO3kh7UCb/xejYilT6sZv+fwROV8uCjPx0fpT0NovmN4Wxt1xe47TogmitnHQDKryUUYKgOJNJWK544qayUQje457+h1Y/yklOJ3lwLbEdEKkql1FPQ5YbbHKtVGuIwQWgNPKL4dt/nLinS8QDL5/m/Qf2NkJTe+/e6svFlkQJkwiED0OOSUydbMUF+GT35BIx+6o8wskbuiIx9dEvqZWgPdIFAhIAaEmyCjIXU2Ea4MK1CSr+UeBvRNzEIUqkgN8aAxF2w+zZe6vnf8fjPRS0chiC7sVDkKb5fLeZAgexfN0PK3kqY9F/U9W0ihw1hBRuK+LpGUmH6NNRNoszh+9o/0m4BDjhRXFrydML1QupbuHFY0qr/DgmfGAvhxsjmj4eGNkACx+RBGPMIZaozMPIM7+BuU1kF7P14WIBtBdPq0qPLjxisv4MEXbRG+HDzKf+jeydKhDvVm1T+KJ1V4IAhsS/8YQ8U2VB9XMiD/+c1qleEiD7V7yLGA+l+db6Xjpa5b66NmvbuWbdpBUy/LtA7YGt6IMSJJyQjVlapxDge8W37nfTOOxBVk76/dtbOJGDK90AVXYK/vVjVmV5Ju1DtbCFro8PkwzTzlPAGCQwJsoSYJnl/F6C6nuqnbnQKZo4v1GBMNhbibeoyI/pyum/LAknELDGxKKbzZiMM8qu6Z7HzNOK5QyWbs+mkKml57eX+3cnXov1hQCO1mz+ziUk3edx3Azh1PUS+FdORYFGRu8VIOpkV8jJIIrzrAue5dALYf6V29r+IhTCnceZyxssSCJ3NCxjy2RoJPAy64rtyVm7Wf81hn+XzJ9oBuCv/u95teOCG8vzXDHmS/o7cdQCjsj17nJBDDexBTDWlcBwupze50n0NVxqI/fcUN7MyQ56ZMWDuGAdk7BWaXnNUhOks8dFU2
 jso5CSmI
 Hb116xXoC7OAZa9YXlKGtNHXmgwXDQeF4wW8p+hQA0vRKSiTfr7bhzEjmJIAcffVdrM/F7d7BVrFSwkKZLPZjQtrknEb5LEzScmZwSTCxtNEb0NRIOR7hfVkSbbf3T3GEnVB2ZOfw6Mi8LxFfHjv9W/LhPiYCdex5nXI7lddJKVm2RIxQayJBD9pr1xi4apS8EPcaPzqhvEU36YicuDqa0NNXdP8fVFUn8T60wuLRM3Nxi2mdhxp/KOvaP0cKRQS6QL+zFHmmUN0EygM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 10:31:51 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> On 2025/8/27 11:35, Andrew Morton wrote:
> > On Tue, 26 Aug 2025 11:09:55 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> > 
> >> Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
> >> added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
> >> or SYSCTL. So this dependency is wrong and should be removed.
> >>
> >> This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.
> > 
> > f8142cf94d47 said:
> > 
> >     If CONFIG_SYSFS and CONFIG_SYSCTL are both undefined, hugetlb
> >     doesn't work now as there's no way to set max huge pages.  Make
> >     sure at least one of the above configs is defined to make hugetlb
> >     works as expected.
> > 
> > So there is now a way to set max huge pages?  A reference tot he
> > commit which made f8142cf94d47 unneeded might be helpful?
> 
> The commit is just wrong. It overlooked the scenario of using hugetlb through boot parameters
> when it was submitted.
> 

OK.  Could we please have a description of the user-visible effect and
a decision on whether we should backport the fix?

