Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBFECCF9F5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 09:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470FA8E013A; Thu, 30 Oct 2025 05:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448778E0112; Thu, 30 Oct 2025 05:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386F98E013A; Thu, 30 Oct 2025 05:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22D978E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:23:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD3591A0ABC
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:23:09 +0000 (UTC)
X-FDA: 84054241698.13.146F428
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46D0A4000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:23:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761816188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrMY5h9NPyH7ETeTjqqeIgf3cTxNEkx0V/SvlBHJZIM=;
	b=nHVBauj5Xa64wMmwh9xbDfR8a26hktwH8dJ+dX3DfkCjm+8W3GJptifqwXRL+4M79czdWY
	w96h2qRHQYhzD6rXZGLWHBinmazKNOT9roC+gxLbvoHV4CQV1+GfpsU7MJgensi98wUAju
	BtqQgMjSuBcVhURvCoGFCF4uWx4/Hmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761816188; a=rsa-sha256;
	cv=none;
	b=7+vu5VZsj4sVuXz1vzUMy7hAmfFktAEzLkv4DgcSR87C2F5TVFLSF8EpwAGC3bsC/t9vaM
	HRFd8TYuA9V/isxVGf7Chq3IxYyUaHgHVkQo+qzQbO8gl5q/JuFKsooeTe4EKZin6umJIA
	r8ry1oZ7z6UvEz46xTxHfTsCrPpHZVI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cxzCF3ckdzYlcX2;
	Thu, 30 Oct 2025 17:22:01 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 17:23:02 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 17:23:02 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <tj@kernel.org>
CC: <akpm@linux-foundation.org>, <axboe@kernel.dk>, <cgroups@vger.kernel.org>,
	<christoph.boehmwalder@linbit.com>, <corbet@lwn.net>,
	<drbd-dev@lists.linbit.com>, <dsterba@suse.com>, <feng.han@honor.com>,
	<hannes@cmpxchg.org>, <jinji.z.zhong@gmail.com>, <lars.ellenberg@linbit.com>,
	<linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mhocko@kernel.org>, <minchan@kernel.org>, <mkoutny@suse.com>,
	<muchun.song@linux.dev>, <philipp.reisner@linbit.com>,
	<roman.gushchin@linux.dev>, <senozhatsky@chromium.org>,
	<shakeel.butt@linux.dev>, <terrelln@fb.com>, <zhongjinji@honor.com>
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Date: Thu, 30 Oct 2025 17:22:58 +0800
Message-ID: <20251030092258.2576-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aP-Ymcsoyls04jov@slm.duckdns.org>
References: <aP-Ymcsoyls04jov@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam01
X-Stat-Signature: yda77ttgu9bs15hin11bscxwipce1jzs
X-Rspam-User: 
X-Rspamd-Queue-Id: 46D0A4000F
X-HE-Tag: 1761816186-584332
X-HE-Meta: U2FsdGVkX18uxYcfxukI6I5CwFw7gZ7rlDgORl7NVoJ6Oz+muXGm7egMWKjst6z/auJl7NDH4G+DhEZ1tHL7CTgKjni7tb1aJPFsz0T0V9qivFGfLQxgjt0Udwm92+uYvGCrQO3OAoz2xnocQuP/3u4zkmpIHC1GpNLlPuWfVUcX8wHteCDq4uKavBNeJ5tKl+4vOBjqpeZ5q2H7WJorbZmHp7kwNAGvo1Fc0IUQSHE5FkFR1k/IOImePF5vgIDf7awGYx19hrOMw2GQq8UvxabpOhqWN23nd2qR1ZTpP4Hni9aS58dJ7kYcVpkgAPq5GAfXpEIGQl9banVXg/tIkG31yK7HqTRI6O1JcZ2SXfE7V3w4URFVKVnYRPwfLRjINcb0fP6/A4vKzTBQC3PXyxBSBmptGjDcmi5LDuaU3eD6Qq41cK234dqx3RP6xPz5ByrKapYHMzbjdSLFZuqO3a95BlVgv3RJv5Wbp5Udn26OW8dNeG46L/XdCH3b1RVw+QNSQx0mumyopyZraKKproRUbzkwn1cKZzR67UOI9+hAJOudzi9vzrXaUItXzbLwecxTvX0DZxW7BQWe5unYbz7/oQBoUtb//Q1/RYj4EsatP/2SuAH95t92iYHwE+Eu+JA4nl/G2/MGzU1caF+BaPStQZJgBoNaugnxPDaQaQqpoJiWkehzoY9VSR8IK6J1db3jhv2PS8b/t3kzGi987SpKg9/7h2lBwD6JVfVKjYBanZK8fERQ9gKheYT9hYa1pTvqC1KJ+u4DJ9N3gu8823Tjqqsr+LAawd1OtH1DNNvZh2qzcvwEg7Ug3i1kBQDB0ShVnvAdkj67+cNkegGBDTZ+dt64xktw6I7xxcka8WbfcHUewmlkZgVJIaluIFPg2U2dzrUKv/uOILRlLHd+lFCX3O8ZauZmqvZMo7lZAQXYs2TARBnKTIMW6Dryd2Dw5FvDCyUZ+2zV8xcqX/V
 22kvH0y2
 sr/Diea3hubx84/CZDRwRt5K4717lBpxABby7+nIf9sVD0+JgYCs47CZza0r5h3o+TGb1sfRz/YcITZAvK1muOaozl5hbb6Svq7XUtuR4VQB6V7Er9W7I7IZrazkWpDphxUsoKe21QWRG+MxbvfCxUebtKV7+8E1V/vYJFVo8HHe5r5DS2wvrklQ2Tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello,
> 
> On Sun, Oct 26, 2025 at 01:05:07AM +0000, jinji zhong wrote:
> > This patch introduces a per-cgroup compression priority mechanism,
> > where different compression priorities map to different algorithms.
> > This allows administrators to select appropriate compression
> > algorithms on a per-cgroup basis.
> 
> I don't think it makes sense to tie this to cgroups. Is there something
> preventing this from following the process hierarchy?
> Thanks.
Hello, Tejun,

There is also a layer of page tables between the process and the page,
so making it follow the process hierarchy would be complicated.
But you make a good point; it may indeed be unnecessary to introduce
a separate per-cgroup compression priority. As Nhat suggested,
we could try reusing the per-cgroup swap priority.

> -- 
> tejun

