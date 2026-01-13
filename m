Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 549C5D2F33E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3F86B0005; Tue, 13 Jan 2026 11:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1C66B0089; Tue, 13 Jan 2026 11:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876696B008A; Tue, 13 Jan 2026 11:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 763716B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:25:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16DEEB696C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:25:05 +0000 (UTC)
X-FDA: 84327464970.19.1541B36
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4370040007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:25:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768321503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3foyz8+T3IMAT0fmzgiihixVjDib6Vrs6KRfgBOcqA=;
	b=yh5q4A1A3HtxLnuOsnVHo/6ZN9LGfMaiMhXqHhOOfCY7lMgB5R1qpmNkI8TOXP6WEZpi/g
	yzK2bx6RZ/UpvZg/1tX9LopgNGyRalRUb/WlU5QRGk2Mw3YzPoIzm3sjRfRrdv25EUjRuT
	ITqiZpxsiRb7mSgAtwW1+zpg8cB/p8E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768321503; a=rsa-sha256;
	cv=none;
	b=N6WKXO7SArq6/bsJGtp2c19wvrK8BBuVIQo7VdiQL6LWqfkykYisNoy58XXdTW2YRV/8l7
	wZgFtf2cc4LrhBU4PyaPNbDT/u7L8Kk8h2o8Vzk7IgckvEyExW7zIJKxK3ALncH6UeT5Zh
	vyaITCF2FLLHU4E0P6JQ+bg1yeo/514=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drF2L5f5TzJ468V;
	Wed, 14 Jan 2026 00:24:42 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A5C640569;
	Wed, 14 Jan 2026 00:24:56 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 16:24:53 +0000
Date: Tue, 13 Jan 2026 16:24:52 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: Yosry Ahmed <yosry.ahmed@linux.dev>, <linux-mm@kvack.org>,
	<cgroups@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <kernel-team@meta.com>,
	<longman@redhat.com>, <tj@kernel.org>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <corbet@lwn.net>, <gregkh@linuxfoundation.org>,
	<rafael@kernel.org>, <dakr@kernel.org>, <dave@stgolabs.net>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<ziy@nvidia.com>, <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <rppt@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <yury.norov@gmail.com>,
	<linux@rasmusvillemoes.dk>, <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<chrisl@kernel.org>, <kasong@tencent.com>, <shikemeng@huaweicloud.com>,
	<nphamcs@gmail.com>, <bhe@redhat.com>, <baohua@kernel.org>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, <cl@gentwo.org>,
	<harry.yoo@oracle.com>, <zhengqi.arch@bytedance.com>
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <20260113162452.00000da9@huawei.com>
In-Reply-To: <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
	<20260108203755.1163107-8-gourry@gourry.net>
	<i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
	<aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
	<4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
	<aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Stat-Signature: x5o77uorobdxjwjjg4gcotgua4iz6b5k
X-Rspamd-Queue-Id: 4370040007
X-Rspamd-Server: rspam04
X-HE-Tag: 1768321502-349208
X-HE-Meta: U2FsdGVkX1+8MfCluZo9OjoSFX2d+LUXsZbCOknRlEn7FfCJFMMjPAaSG+aD79bSD4cm+X3CX1kkGn5WNOyq0PAMPYdaWSRgL4UoJ+uoAqTdgItwVllPLVlWqHXF2L0mwXdHJBx11YOszTnOKwHbs4NLHL4rEUZOAksjqMzdsOTnp8gs5k1CvCzfLgQ+cppHjxR8YwLkSM1mUk2eXl+4RdJVoNHvx539S9VXJmsxyL2oddSrg+OS4Nso2WlETj99VuIpM8O1/83cE81aGIytdoRHXWIWdLlsZW0pCTGCQ+Ctt8i37G7HCeqiNMsG7n/II3cyn06mmL1QjNGmVu6O8bQ2gRfgTeg7kYTYY+OTbf0dZSE0mi5LHzPrGr3XohJj9FPZUOctKxeo1wmpVhH1W6bwuXKKKCh7i2rGuojRZZ5Eexil3G9S05i46cQyvmOOy+GIj6eSU5HLfwbmcY/oNRaOUMqd00jGyoGry9AVs2nOFEtT0fsdwm42jVUBOFTPPYLmiF3wOrfhjYHhAKXfy3iyE/5ZSexyBFlrg5hEO8JgVVYqkLiB6brb0PBfrJd7tPEk/NM97Wbn1vCqqd7js30k2olRufztdKaSeHY7wB7CYGHPMpAqKJQ4N+11HbgNkaerGbUsKUh4UdQrYOdwtEToFX23YWfCPPahMhg9wlH0dINU/3iVW+zC8R18ahfZAe0aAtYgwb/E+9Q5o4s03bXu0Ubmr3cYMAQbT1333/rD93AlUnCa5CVlzcxfybsEbLKMLdJJz7zokhI5MMqUBwdESiqwHB48wiKcjmbTvNkk8w78L+i24HbHyskyf9dZOWl1hdCSWB+R7l1iE6At4FRdEyWXcFokWktdjOjiTYcvYlV/qe8UMmhWQU8YAfqR/n4cV0VbDS/nsbnb02mKX3to2RO8sggqagkVhxF/39LuSRR0eGYEvzOQYqjcatJdOYoSlJNWw42BLCfwagM
 rxFU7HOk
 1IwGSMm6EyJL8bRu+zrack7ODYMW1F0R1GoN3gtQPd8CzkQGzkN0S4hzf133BlAvKfsjWBRyCKskr3B7ddF0H1EWgPOAziytMkOVYUx1WjF/+EQU7mS2b0B5xsNpCEsVlKFjPS2eq0vHdxI+9k/snHH8IVBaAVb8eAL/8t17FzvLZDecUoT5p/BCPzYnoszQwfGMn4WLhBEXINizmsOuNuqzMkY5bQ33fQ6I3ltMkWnSw0lWwxbhpxZEmxDzLWQTm0tXf4PrOaUDUf1GFXAJds2d81y5VEs+dvMIQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


...

> > Are we checking if the device has enough memory for the worst case
> > scenario (i.e. PAGE_SIZE)?
> > 
> > Or are we checking if the device can compress this specific page and
> > checking if it can compress it and store it? This seems like it could be
> > racy and there might be some throwaway work.
> >   
> 
> We essentially need to capture the current compression ratio and
> real-usage to determine whether there's another page available.
> 
> It is definitely racey, and the best we can do is set reasonable
> real-memory-usage limits to prevent ever finding ourselves in that
> scenario.  That most likely means requiring the hardware send an
> interrupt when usage and/or ratio hit some threshhold and setting a
> "NO ALLOCATION ALLOWED" bit.

I believe we could do some dance to close the race.

What we need is some upper bounds on usage at any point in time,
if that estimate is too high stop allocating until we get a better bound.

Can do that by starting an allocation counter before reading capacity.
As long as it only counts allocations (and not frees) then it will
always be an upper bound. 

Any frees will be dealt with when we reread current allocation (having
started a new counter of allocations just before that). Once we have
that new upper bound, can ignore the previous one as being less accurate.

If we see the interrupt, all bets are off. That's a fatal error in capacity
tracking.

> 
> But in software we can also try to query/track this as well, but we may
> not be able to query the device at allocation time (or at least that
> would be horribly non-performant).
> 
> So yeah, it's racy.

 
> > > 
> > > Thank you again for taking a look, this has been enlightening.  Good
> > > takeaways for the rest of the N_PRIVATE design.  
> > 
> > Thanks for kicking off the discussion here, an interesting problem to
> > solve for sure :)
> >   
> 
> One of the more interesting ones i've had in a few years :]

Agreed. Compressed memory is fun ;)
> 
> Cheers,
> ~Gregory


