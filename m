Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E604FCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 22:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9A06B0005; Sat, 17 Jan 2026 17:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91826B0089; Sat, 17 Jan 2026 17:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4556B008A; Sat, 17 Jan 2026 17:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 896C16B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:47:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA32DC1CD0
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 22:46:59 +0000 (UTC)
X-FDA: 84342942558.15.088662D
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2321040004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 22:46:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xm34E/Ut";
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768690018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NTwg/md3l+esgAA1bEBco3G/kPju1HLOPgY9+zbAnk=;
	b=Ajjd/b1XHPTQqOAYmIpXsCIjblKmxeSYJmFra43cb79D02zNnC391Hwv6DWw9o5/OW4fa6
	P407ZAfowXEIr1g7KnvwFL2J98RN58G8f9leoT+acRDcmLuhIp+yvTCRlIVNc7DyFOllOC
	OXCMO/2gZ3j1HzOzxU19Eryc59KkdQQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xm34E/Ut";
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768690018; a=rsa-sha256;
	cv=none;
	b=Ims2tDkspPQ/Jnn4tCzdYlQnNhH2nppVLkq0nBDcEZgJyIOS9IYaDdwoBh/TkuUncho4cO
	EL2Q44jLVW8Bj4SMdmwznDajOaB/Jgp75qpRVwvypCl2+1JGEoqPZF/yAtdrITfbZbczd8
	pseB4Zxhmxl3oNbmvmxKJjE7hnLI6AM=
Date: Sat, 17 Jan 2026 14:46:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768690015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4NTwg/md3l+esgAA1bEBco3G/kPju1HLOPgY9+zbAnk=;
	b=xm34E/UtjMbIIddWD2AEVoe3QA/QySUPbMJ0VPkn6fnVeNfe6r21wV/0Si3kqrQsef17R9
	UxVLTX9p6LpY3FEQ6nYwCrTV6lWIQP359Pt1k1/piXy0MACuBrbM7ifX8PAagZAcIigiOM
	EYJ2ikqZKcvTieFVp9WZUqKzPoEmnC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in
 mglru
Message-ID: <bqwvvjegxtcahjidweipozoyafsyvidxwshvczgw7farae56my@5amtcfrcakat>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <2a42effe148a31d308075f9fe72bd76d126b96b8.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a42effe148a31d308075f9fe72bd76d126b96b8.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: s7774gmab1bgj4zc9xap8fofkfx9fruq
X-Rspamd-Queue-Id: 2321040004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768690017-161668
X-HE-Meta: U2FsdGVkX1+YqDwRd7SlA9la4SzOqfqkVuSCq3v8JsydFNSYJ0metKLQ92c9THpEiQC2w/Qcz1rtvVhNP455dX+kUq0A+TsQtUgJGuAvDkTHeAhZCcI59geRNp5mKtCzrvls+wgvprngLSFij7ZGFepK/rocREJriIHsPDuumX6D8Xf3T6IG1GAVGc/DH2RbkrWle7Jy8PtHK2DZ5iQVJG6nhaeYicmIIvEfP0nmXTL36D/iBelmjpbc6zqN/awcQxmiLd10+LCeJWrk6vq+nwuL6bCFeSe21xZPhUPQRE3fKzRrnJw9hhISy/VJ2et+zTq2okf+auh60sV9bI/UeqIZgSAYgLs1A99JU7A3wPS6Ir+3/oQwogpceD/wYJZFmjguUHOp6e2fzkuf20jaRu85Kj5k8V9w1xpesNNJRvx4TjuKL105Yi95beUW5jM3uf7Nhqq7wTIjhZSFerGXEPVNkKDG6RvHoHchtgBBqvqkmsZYiBAJwWvES6Bv4S0XeK/646uwLEwbvM+QVknTSSuGh2mBrD7TIGr7+OScnN8YcF2BCq+4pmQLc5uzqGz1Z8Mw2jM1/jQ+V4jPslMoQQY4jgIBgcmoJh5E3HSa3KpRmfdreeeQWxLkDI66I7ZLkYrtSk9Rb/SNcKP7LhAWgoVISXCBfqYNIEP7kqYsg315mMvBZANugituy1LKglQrlz9K9RYkHihVIZ/LT7FYOVMD7F06C+g6wenn42lgOjwVgFF47d0ZxIxq1mjlRSw7DI8C3iwbaWHujn5mPGlfAE8hGW6fIXpQqXVU6ayB5xG9LRVpCxmqcehRGeNzzyLETaiTGtjmJPBrOngcCgUxdXLaaeD68uaJlmON/4W2++r1hyjgfySmq74gesQLZ/dFAmmyHnKBEFtYPyxMOMmyCBcXE0JtAYsj7nT0hYhgOmdWZZUFpJE64Bct30q+W/VkX7f+iLx5Ag50KNyPJ4v
 BA0QYXES
 qmOS4iUJtNg94Icvdzw+7iqVk9E1X7gl3w+blpaUeEg/ukQjlxGLyGs4HZdAryBookAy4x3u4CQAGYPN33nHxolpoNuL8jSoH4WSkee8IWqo7EpNJZSZPGZ5YVYxbLX6hB5sHwbe5tlSoRswN1RMNuW6Tkr2uRa3wzrlH90PwEi65fb/X/6xQjpBcfZ+7zo7Agro4zaWTwagbO4koqVDuY/svS6KFkxqwNZD9CF8GrBsyU2ix2N3jkES35RSrpmhTfZbkQuCOmMDV7h78BVpE6fvUjXzLqr/hMDDg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:41PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in mglru.
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

