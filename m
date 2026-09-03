Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337B4C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6DF6B0088; Thu,  3 Sep 2026 04:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7966B00D2; Thu,  3 Sep 2026 04:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD5C6B00D3; Thu,  3 Sep 2026 04:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF3D46B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:24:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80A1A120474
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:24:14 +0000 (UTC)
X-FDA: 85171763628.21.762FD99
Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6280A0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:24:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wfVZLCR3;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788423852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xa/t3XNOlXe74ZMdB0kX8AqrXDDbQW6k323PomJFr1o=;
	b=wdwfx9CNMazxW9Bb0LZOnfkIP1JtJp/822I7lOhwtOb+YHhOcLnjLo8TyqzjUD8UhF+XNV
	iKvddBxa7aVGZIivYstodqElAIFqQbgFaZGddm+IRyVAJZlrnAESfA6otljOP+LiZgbQWB
	jylkV7Y4jJGaAtDQQqJ01KVrHSXqH1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788423852;
	b=LVanNpi+3e278xhOZQC01zQC4nKmUsL/v6hpe9+PnX0Q2o7o6pSAMaUhFaZs6EeYjtNqu2
	xvAi3S6T6mRniYirHmnN/krADaZCBKpKSQL0wFI6rDGVRF+7MoD8wEFYREcUYWTwarkU9G
	F4683xyySO9GHkcd3psQMLAa+Bipwa4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wfVZLCR3;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bz3SZL//Djx5lNW9Q5WO67qm9+hz2GY8LyxsWp6/XM0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788423849; v=1; x=1789028649;
 b=wfVZLCR3/QJY1z9mFnlgnq88hp9T7LvYFUSK2mWHk4R4tntmZWG4HZGH16gewlkiYIK+CpE2
 BfVEMQv9KuRbZOvkQ2Jt48M7E4mc6dC+5U1LUkRwXscSDSlgLCZnYpDMboXWd3hYw6wDUtpum9c
 zW4B5EXbJKB4yKepjUeDARHw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 94f1fcd18dd1bd3b;
	Thu, 03 Sep 2026 08:24:09 +0000
X-Mizu-Trace-ID: 94f1fcd18dd1bd3b
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 16:24:06 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] mm, swap: add xswap grow trigger on cluster
 allocation
Message-ID: <apkupjBofpvnxyOG@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-8-hebaoquan@kylinos.cn>
 <CAKEwX=P53GAmyPeBQ29XaHnGw5qpKkiKiBEwuhdRKdkMPT0GSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=P53GAmyPeBQ29XaHnGw5qpKkiKiBEwuhdRKdkMPT0GSg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6280A0007
X-Stat-Signature: fqrhtg3gyh497xiyzxwmms3fgggehhsj
X-HE-Tag: 1788423850-690526
X-HE-Meta: U2FsdGVkX18j9xtv3Ds5wO0Vz37gfsQz5VJTiLLqFLBOiURgakd+UG4Ps1R9QSL/kETh+61DDtfqqPZAaQIYHpt6olV1TWotfa7ZIeETH9uKFjaxok8+sMiDIuFTVoGunwWzUv3V3RnGwqsk0cndnFv1kuBU3usEMw+yt1NFtqO+tHb86cFwYY9SNUeI8c0ScBvAVMk73yKeKj9ufKJvdXSfpdLLB84DHdDuETrIcJptXaFScE3kf3/6Ei3o7KzsABSGH6EEekp60A0wwdoxsHXBSvpsveMnCP1VmNNqc+JWVVSd69+yNarDSXYd1DPLZ0KTM9lU3uFFgA1O38lBFEW4fkNc3ffjysU9b8Ywtg6MpDQ0qQLRPXrzHhwYg8iX07exzg5ltj30izQd9E7YobWnnvxfuWfQB/ZMnai3WHBhgNzaUf4UjmBeDv/RnNiXX3Vqlg2kYpOnYqc4fnq3R+ycyfpmw2LltogJNbW/CkAN3of+0DdeRbeZbiTHuXr1s0VWCJWN3qhRHBuO7dPOKISyHZ3J+1OakeDnn/iz6bpT4WFZxrC1BgdVEx1pKto8NF1wzkdw9fCN+DokPIucX3VlwotKsm782t4yER2PqSr+eXsAI9M+5eNU32zs7RRW92NDSYEiPOXiAPMN/06j0REAUwcJj/wNsl4qKeC5bmb8z9bgO3NH4Vk8AbCEUWWJJyAIFoZGP9xVPTLCZI8huEdvykKIyW/Z1qgcqSX/1juw0epDuZuhJpqGSXsX3q7TcTOR3OitCc9WI+Er0rGiRLwYb/gLXFyGob7rn90gA1V12EBwkezvC6g+dtigemJcZXUjL0gVOVRbsoC/ERRsaIHvjW6ALMbULLlXX4YNxPrm/4S8XLxSohU7wGsxx2TWR278PGjQ6DmDttdx5KEmuZ68r4qUcHzYSbi9+p/jnAjslChrClETQ1w0hWL6Fr+pCI9Mi+mvA9sTJdIwk5o
 8BOfarJp
 DT2gX+ZHpu1ZXIVFoRONhlGScf5gM2Ci+VzkYaeEf4yhBHstobpQ9VUqmdm4dxvj6syGbfnS9H/VuYyvLa5/2RYcmabeD/EmVyrkp+Au2LE/2f2MxGW+KfDsqlBbUcu2e61fhcIDzzNELVzjt6jlleq/4AYKve+Snp4Fz+RFsD3katsDleNsjvW0sPFV2I4u5u8SKXj6vCjGcToS/mcuh5gO4jKtHKehInPA4+cULZKbK12eD2YDfUT3glI7IvIu+KRyLAeYNo1/HoeBiY8LHsHeyKEwFp+Ly4TUDyo6u9vGtxrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 10:15am, Nhat Pham wrote:
> On Thu, Aug 27, 2026 at 5:45 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > When cluster_alloc_swap_entry() fails to find a free cluster and
> > the xswap device still has room to grow, expand the mapped range
> > by XSWAP_GROW_CLUSTERS clusters.
> >
> > Since xswap is always SWP_SOLIDSTATE, no locks need to be dropped
> > before calling xswap_map_clusters(), global_cluster_lock is never
> > held on this path.
> 
> What about local_lock()? I believe we're still holding
> percpu_swap_cluster's local lock as we invoke xswap_map_clusters()?
> Would this lead to issues :/

Good question. Kashiko also reported this , have fixed it by moving
swap_alloc_slow()() out of the lock scope as swap_alloc_slow() does not
touch the per-cpu swap cluster cache.


