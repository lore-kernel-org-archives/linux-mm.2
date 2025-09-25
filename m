Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A89DCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5743B8E000A; Thu, 25 Sep 2025 11:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524278E0003; Thu, 25 Sep 2025 11:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412C28E000A; Thu, 25 Sep 2025 11:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 327958E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:24:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCA1986CAC
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:24:38 +0000 (UTC)
X-FDA: 83928144636.17.22416E8
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E0144000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:24:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758813877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqkbb9J1eTg4e85EdHWQQmOla5K8ExohMtRGRdii/OE=;
	b=HrsbQ20fsUcEu3XXguYt6sdmgu2LhlfyNaZzt3yPDd5w0m1b0Pdr7TwNQq8rl/opbUpxdd
	MNHgu0jb5P9XGv+aoBsPIhzFjhouOTkuu85A57Lco402JSpCBAL7Ywckh8rbPBY6qRaczl
	Oat09BIv+VRRysp3ARjwL06woO9YiKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758813877; a=rsa-sha256;
	cv=none;
	b=CT+a0+jyRV1brwQ9nSPiSu8YELV61ASHM5BwMw81c8Um39QEucpCCy5/bZpJP6VLERrPRC
	wnpq+6Wl/+3HMKErKERK7N6i2nFwj2T5vKnF4xWA+guvHSEkwTiQ31bEnKWfZL8vuOfBxR
	qkWlFyZagbkU7nyVVV9JmPaqhqese9g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cXcnx1bPbz6L5pY;
	Thu, 25 Sep 2025 23:19:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D1D71400CB;
	Thu, 25 Sep 2025 23:24:31 +0800 (CST)
Received: from localhost (10.47.28.112) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Sep
 2025 16:24:29 +0100
Date: Thu, 25 Sep 2025 16:24:26 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Wei Xu
	<weixugc@google.com>, David Rientjes <rientjes@google.com>, Matthew Wilcox
	<willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<yiannis@zptcorp.com>, "Adam Manzanares" <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20250925162426.00007474@huawei.com>
In-Reply-To: <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
	<aMGbpDJhOx7wHqpo@casper.infradead.org>
	<aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
	<7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
	<CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
	<20250917174941.000061d3@huawei.com>
	<5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
	<20250925160058.00002645@huawei.com>
	<aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.28.112]
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E0144000A
X-Stat-Signature: efgq5fs6x8nycohkiinem5beh51bz8iq
X-Rspam-User: 
X-HE-Tag: 1758813876-712373
X-HE-Meta: U2FsdGVkX1+MzQa4pR7jqpsrwMuXF+952l5qNrTd52iutDTjPA2TCTvl9ZG7A00MRCfT9mWflH03ngENDvWiUuUGS//PS70wDBXA5jcasPHDgejPV5DJRebNEfmFpyKJOINTo7Eph653QEEmKMzBfDt4YgagbVKAuG1TPzHwjk944WFdiXfHBwAAfPsyyz3TtTRaxYR4C/9momj8v3m6uz7RahJHzONh0JsrtBAPZFuFec0hvlUJC9I2bmcVb0JWicsKSr80qZAFCQ8ODL0dLgQDzpB3X+ttHmyWtTMbGlOQlUwFe2wWn0sya7umUQT6vioumonu1RIsLND7mLEdjXIpvTuA+gUz2wH8M/fVGBUagnkHemfiPxZq7S5i/eQQsO1QyxQgEIEwLbbLrzmjAZ+AUu8KTzA79xD6tX328F6EBtNezCyZxPbb5srJvIkh39r06rxUutJptYuPO+Ovq2Uilh89uz+LY7GHdn6x9iYtj3IwcXIs5nzRjy0w06SeQ7QexBxYEDoVg8Z40KJkFaaHBMXFx9E65Vk8EHVP5S5SIowVhStV60EGfJl8kL5saPzyFm362xgv1tqMzAZmxPAd2N5u4OcIKWCtOolXGCkbnPP6j7BCosZgpCLQCkJSVzhdhb7ciZfPWKmmSNCfir3jLCQV40yqbSFCPVaE4/MLNxRLwa5MQH1nlAWO3JU7GF+BGkde0y4kwCuWSuTWYIw+O1N/QqXpK59GI0+GC4U+ZC26B1d+BEeu84MtwOa+lk+OGIfFbvzvzGCBUvVbjS4om22yAMOUHxOTB8lhWXm41cXNTJxa8KQ0cm3c98+XgHQ3KU7ZnccP0rADKI5MMwAT2dDRAylcfpDE9ASlTXlW47J6LxsTmA7v1qaRF8sPy+UDY96GlnG+1Ci72IFVLtwf8D858U1UqW1YY3cp1Pn6Lutn+6c4ILkus46sJb5qCeKTkrriX+WbCFkjaqX
 4mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 11:08:59 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Thu, Sep 25, 2025 at 04:00:58PM +0100, Jonathan Cameron wrote:
> > Now, if we can put this into a special pool where it is acceptable to drop the writes
> > and return poison (so the application crashes) then that may be fine.
> > 
> > Or block writes.   Running compressed memory as read only CoW is one way to
> > avoid this problem.
> >  
> 
> This is an interesting thought.  If you drop a write and return poison,
> can you instead handle the poison message as a fault and promote on
> fault?  Then you might just be able to turn this whole thing into a
> zswap backend that promotes on write.

Poison only comes on subsequent read so you don't see anything
at write (which are inherently asynchronous due to cache write back).
There are only few ways to do writes that are allowed to fail (the 64 byte
atomic deferrable write stuff) and I think on all architectures where
they can even be pointed at main memory, they only defer if on uncacheable
memory.

Seeing poison on subsequent read is far too late to promote the page,
you've lost the data.  The poison only works as ultimate safety gate. Also
once you've tripped it the device probably needs to drop all write
and return poison on all reads, not just the problem one (otherwise
things might fail much later).

The CoW thing only works because it's a permissions fault at point of
asking for permission to write (so way before it goes into the cache).
Then you can check margins to make sure you can still sink all outstanding
writes if they become uncompressible and only let the write through if safe
- if not promote some stuff before letting it proceed.
Or you just promote on write and rely on the demotion path performing those
careful checks later.

Jonathan


> 
> Then you don't particular care about stronger isolation controls
> (except maybe keeping kernel memory out of those regions).
> 
> ~Gregory


