Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E00CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A638E000B; Thu, 25 Sep 2025 13:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1C48E0001; Thu, 25 Sep 2025 13:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F278E000B; Thu, 25 Sep 2025 13:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5E218E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:23:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C38EB9573
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:23:16 +0000 (UTC)
X-FDA: 83928443592.03.E637D82
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2097A2001C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:23:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758820994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZaVI04tBI2okl4vEUcF/oxxN+zLScxOe7QzYcIDwi4=;
	b=zKa/CUV1dzVxncX4sYT8w47baFE1vjZtSth3SJg7zlZK/jHXnap6JkqLS/PAV2lVWlO2jC
	2mdFz6BDeY+PfIYP5BsDp7mW5VPuL74zrLsEpHWTNmJK88cgZAumK3B21k72YLUfKjpMy8
	2+I7gw7oHWe33Mj8TIoCHld1xAwUHJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758820994; a=rsa-sha256;
	cv=none;
	b=w9FdF+lIoO/DkFNhUjkWzGkHUfWxe99meqMxpgpDtdFRp2hnaBs+zmksSvIEk+dOkS89aF
	cLmFVEFRoiihcRSjnI6dnQL+LqklEN0zclWzy3DdfvS5fJrt8fXxbmxsXtHbfj9HYY7RN3
	TuFCS7BDTL0m6J1FbYOEFsihVd8fDhQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cXgVL4L9xz67j73;
	Fri, 26 Sep 2025 01:21:14 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 21E7F1402F0;
	Fri, 26 Sep 2025 01:23:11 +0800 (CST)
Received: from localhost (10.47.28.112) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Sep
 2025 18:23:09 +0100
Date: Thu, 25 Sep 2025 18:23:08 +0100
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
Message-ID: <20250925182308.00001be4@huawei.com>
In-Reply-To: <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
	<aMGbpDJhOx7wHqpo@casper.infradead.org>
	<aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
	<7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
	<CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
	<20250917174941.000061d3@huawei.com>
	<5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
	<20250925160058.00002645@huawei.com>
	<aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
	<20250925162426.00007474@huawei.com>
	<aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.28.112]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: ab9ikatwixdwp3nbt8uhxn9taqqrq9sf
X-Rspam-User: 
X-Rspamd-Queue-Id: 2097A2001C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758820993-830395
X-HE-Meta: U2FsdGVkX1/W2rRUFCDh925V6wJ+coxtzoMhs8WuUJ/7OHijPYN/xuwTbtLovlAMI0VS/+DJPDY4LGcQpPrh7x4ttdqdiUYVgeXVKLhGoxLZr9BjfygWevfqoUl3MIeB5sjcmHv8i5/9CFkSLNBNkcRr5x3SvE5BZkHk3/ATuebZHctkX7ugLd7plAemwwtbVpgldBAAq17QNRCFD0NRB8Wrc9d4YFyuagSN2hHsknt2/hdjrhqXe46fB5tPPHikjQ3PJpYTd3F1EVMY7tWzuuvUBJXKsihHLZ2xr9l9H+IBhNdF0gssFB72S6gOwJbPA47xwZb1zLLUTcdS6Kr8+3VEVwCl6Da63cGSUOChzRVd4GdjUBJ2OV38ti8mwg1ucl/HVZNBXyCc+Idwt+ZPs753I8WELskU43cTQyBZw6WcXS5ThBLke9kX9o4Yi16vRVP6iGNoJ3M7gMVzrd+2thGs7lzkIhIHNaAP4zvpfH5Jo8vdc90mQQu9Qfu3A22MMDJ/CjkXyt6zE2DM3APT3g3yK4bxkVzSmZ77s3fRoJxpRjGXv/X1tq4AiCTN5SKf2Xjl1w2kSayX+zhO94VCyDp7ZQUMsm9qAzdoi+i1EZqaug7J192WU0eLuUzmPwTdz48+X3LL+FdUm9prSgV4mpV7GfA4kkoylvBa4jJV6fDKUsXLWI0eRG9Elqj5eNcJD+hdREXwdBMKQYIl6b+5h9fIYnvXt+8siNhgE7B8vGfoWZFVpL0nLLHDhegq18N9fuCOvcPCtDP0C9Gww1AFoYRjkpp1OMaWxlzUwoUaqr41q+IL8qUPaQxYrxPll2B1pgenL1kyzuVBzHOusoxCqfF/TkPU+UB4cRyGoxbloj4Y6X50DiHneN21YGVQS2HVMX5pzaSdmF/h4hDRRcMv4crFxadtaTwGAtWz9bbEOW8M+mBEbFnWQZE2i7oES9OXQHRDTD96GUOdrxKVJtp
 0nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 12:06:28 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Thu, Sep 25, 2025 at 04:24:26PM +0100, Jonathan Cameron wrote:
> > The CoW thing only works because it's a permissions fault at point of
> > asking for permission to write (so way before it goes into the cache).
> > Then you can check margins to make sure you can still sink all outstanding
> > writes if they become uncompressible and only let the write through if safe
> > - if not promote some stuff before letting it proceed.
> > Or you just promote on write and rely on the demotion path performing those
> > careful checks later.
> >  
> 
> Agreed.  The question is now whether you can actually enforce page table
> bits not changing.  I think you'd need your own fault handling
> infrastructure / driver for these pages.
> 
> This does smell a lot like a kernel-internal dax allocation interface.
> There was a bunch of talk about virtualizing zswap backends, so that
> might be a nice place to look to insert this kind of hook.
> 
> Then the device driver (which it will definitely need) would have to
> field page faults accordingly.
> 
> It feels much more natural to put this as a zswap/zram backend.
> 
Agreed.  I currently see two paths that are generic (ish).

1. zswap route - faulting as you describe on writes.
2. Fail safe route - Map compressible memory it into a VM (or application)
   you don't mind killing if we loose that promotion race due to
   pathological application.  The attacker only disturbs memory allocated
   to that application / VM so the blast radius is contained.

Jonathan

> ~Gregory


