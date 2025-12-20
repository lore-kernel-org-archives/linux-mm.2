Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BCCE668AC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C6B6B0088; Fri, 19 Dec 2025 20:25:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619836B0089; Fri, 19 Dec 2025 20:25:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5259D6B008A; Fri, 19 Dec 2025 20:25:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4369F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:25:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEAE858D07
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:25:10 +0000 (UTC)
X-FDA: 84238105980.05.108AF56
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1A36A8000D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:25:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fp2Uk85P;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766193909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4rj5Kk8zj7DgKXiaSbgv2uhdn7Z5onK0VOn5gyo83I=;
	b=LTvIP5fIs/F2k+ZUUL9tVP9sQax4qBQ4o17M5Won5X8u6pzY1yDSxE+A789AENWGRLV3ZW
	7NAeI1us22A/P6Nya2GX7eONeJtGB/vCfFcHWDKFj5O2xZzZ0RhuCOgnwTUY/clhwAisIq
	X7hEzA7aU1tFRDcGKcteoZndSDM1GGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766193909; a=rsa-sha256;
	cv=none;
	b=R04uGb3eZuD4HgzCi2kvJk0d3Ge/MhnwZ8Nl7SzHBVc0SHiWncULRRvDbaFaS0zYm8XRhr
	nr0aPmxNgII5svlAZT0TbT1ajnI3I0O4dbVWW7yjvYiMRNEbAQr2yy8dJV+5BeatgaXbhQ
	BTP/uDMlshFYUmiH90UcYBhFjGvimFw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fp2Uk85P;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Dec 2025 17:24:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766193907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4rj5Kk8zj7DgKXiaSbgv2uhdn7Z5onK0VOn5gyo83I=;
	b=Fp2Uk85PyuP1BaWh9pYFtMj1d0JEhBx6b+4qF4ME84XdryKQheKuRa9snVdzLtKDHV+uBM
	v5V+UQyjdh+0pXLQaEhVnWghDeoSpB1Om3sh1esBOK/e3fJxJ9GnP+A7pvZihUJMv0t4Q8
	svJFYNSf63jKiHrl4iGcaDaTsAsbMtg=
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
Subject: Re: [PATCH v2 21/28] mm: swap: prevent lruvec release in
 lru_gen_clear_refs()
Message-ID: <6as6jdgqy4vrq2skolwnqzef2n7xljpw7yul6vm6g3k5pbzd2k@vluyqctcvxj5>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <42682f81686e31019504a6e025fa08d2c9dea718.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42682f81686e31019504a6e025fa08d2c9dea718.1765956026.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: eqkquxtrotb55y7jz74u1krkwwugqxx7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A36A8000D
X-Rspam-User: 
X-HE-Tag: 1766193908-669764
X-HE-Meta: U2FsdGVkX1/icuOrK4tGUn3FjH+pX4cdj++piWJAM4t49pI466LEexIR1/EuCpubEdo6dzMaLYsJz7/mJrWMvVE+wDjPFwSzVquYvxZbuZ98ntIiXMMrAC1tKt8CO1yHNCuhhfZjuty9OTpqfcVYGIBO8D0S6Gdvz9CbRZpA1lRNeSBkCIh++ODox/cydFhXrV3aVHNpF2B9TViJOIgoGnU+Kr2JeKOwaaMAbfLU8/Lmz+3rf4+D2vZ/oEPI31sDc5djV+hX8MZWhE9k7EYDsyR5xF+BDWCdbd2HSV9JM/td6RjOmYMpK2zVfAcb/zEdE2ERRM9Zt77P6XRDEEP0fhqxudEmAD9CwNjIIUueUtlBiJsI3+CyXUmTd0t2NIxc4OrP7E9L8Rpw8RBbuq9IqKLRo25ZWvYk1vv72RO5Sy4gOA3ndRR71N47zReRCBcyezeouuOmBIjtR2fQh+kvcnikvQt2KbTDE4241EyXzBwyQzCQLptaU4K1v+eEsXnX5TzWum15SdgijWzsVCKCy961FbHz1alEQGcs8jrPZG+H5yuANazgP3ce0xykO0xS+kycENuEZjKZk+s9+W5/t0uhfOWrUHByE3IFXvytW5tSYJW1+tlPdLEMCf9Mq4VjzGKw36ZOg0FmPKkXX9F+I0qPx8IZljkW4pyHFxYOtk7nL+wnm8dsR0G8GB4UjBgn80pyPKGYjd664mGAdMu1DgKvFL5zGld6nkDflESB20h6IE1+R1vs6L9iGTr7pVCKa2qdYJac+eFDGSmexqQOF/k5ES28sZglNYqLxI86eYCAOj7H+LwinYcVYrA3RZmqmt18UTCnZIFy662EiI8UcHGOYONTWQUCRNxWiFoUTzkBAOyyNZDGGoGayk/NIh6ow9izeWe2LEo146RAeo6D7+WI8D2nnIbNmGlboA0HFocpLsGn6rJ52utA2rRt3LLETYArlvWDFXReDCEZLZA
 0NKdKvig
 xNhsetvEB4ptjhnrIyOildJM3M9GPbYoC8iZKdjvBONhEDtuWz9G0MGmGoHF2IUjduqeRWxHnRYt6YAxKYG0VNiiJvfo8He/hzWn8Xepxc+RhiQywpEWVVsLnCBHhYUpGGKxxtP7K+OoTAAfHpk3et2WKyx/mQ85Ze3CtEjoj7xz5HR/2oiAr37WoR5eiYaw+7jm/C9nPPfmPIydJBUzLmcjqnby7f1NAKZ8z1cDyJSBGTNbY6reRLf+SOqlrjSt1u8VXbK3aXpil9f3KxfktYcSKjxa9RajGRYnTLMY2KR0RBas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:45PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in lru_gen_clear_refs().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

