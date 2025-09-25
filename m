Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE98CCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FEF8E0003; Thu, 25 Sep 2025 12:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37AA8E0001; Thu, 25 Sep 2025 12:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CFA8E0003; Thu, 25 Sep 2025 12:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4C808E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:06:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78B5E119D7B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:06:34 +0000 (UTC)
X-FDA: 83928250308.26.F193BBA
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6AB1F1C0009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:06:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A7jwrnOt;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758816392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yb6vceRuaH7iX55SPXoLoljlTLWExr/Ac2Cewgac2Y=;
	b=0oZChaqToQvsbCP29M1f14mb7hIXTQ3EQ7frCEutqQqEr8NIyPbKSrcA8/qxvUGttETKKE
	KuwQAbFHuWpTfoMseyWRMxFE26PUO0vvc1yIRw8e0nscItqs2lie/6UYwOYKUcnoWGPlVz
	2gaW3vcIlhU64zSP8mtWTLi4pFhVUBg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A7jwrnOt;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758816392; a=rsa-sha256;
	cv=none;
	b=FL5zd6U5ozS39ugR7sdosLZ9/Zmf41nXHGtXehy2b4AYzPIP7VBCBcJNWCaZflIKrlaB/w
	rfmSf/jzssvQ8jK9mJPYYEOGA5LdS48JGrHQxiYd8OhnNWCM2DYWqOHxMa0kuknH79NvwM
	fbjITnna2JB9d6/m5urhYWFw2Rw2kV4=
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8936326129eso40919339f.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758816391; x=1759421191; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+yb6vceRuaH7iX55SPXoLoljlTLWExr/Ac2Cewgac2Y=;
        b=A7jwrnOtKfxYilDgPbjrvjo9vvVRCHtl3Sksa9EII22rxKyREuX3PdBBv86b7pc28v
         sk+dwrjnrWq/XIYYEJ9wEhutmCoHgIXvoAYQ4hVDK2N3DWt0ejdWx1X216IPEn6DYNcS
         Vij4H1XztI4eeEbKP7CxOUpX8hEf3OHW+FWG6AxdRhfbpBDhNv26aH4E9Qcae/LN1BvT
         DzzYcDmZxZy62jWlkROsMMS1HjgNXxjsqMax5gk+bxU4HxqjRa9o1klAAHVVCaL57Ojo
         2UBxqhiYyBcAjmdA7gYuZWDIvk0x+szLY9e05AOsqeZJbjMEi1PrTXbEm3VRQhxgg91X
         EGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758816391; x=1759421191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yb6vceRuaH7iX55SPXoLoljlTLWExr/Ac2Cewgac2Y=;
        b=pGOc6sUs5bqgNA2AWDdG08bl3zLkkxTxAR5unICeu/i8bvEZwvS4GinsfhiPwFlIA7
         fP6qFrX1SSVunbtugjDwc40StR/zuFUK7zK/Y6YQczsvhNTD3segvLXbI6gpS/riZzvn
         EOQW3nQW0EiWQLWHC/gv0iyEZ0aK7E8Nh5LApJOQtbdIh1wwoF0XHMRPqYqkcyAVyowS
         60XVk6NJvQiY2gDtIWZjSClvjZWnr7MpJPlOZq17VCclZ+ml50yOYLSwh0CO0gUBpPD7
         Yv7tHZQb0Vlwc/EmeWxHtJXzE/mTdHgmsZKTR9/kMrZT4QlQWJFsSW3xGIBpXQyPeEML
         1cgw==
X-Forwarded-Encrypted: i=1; AJvYcCWxPD65yINOFV+LWRUfj5XUOQNKM2AtCZFoWVXdJZJT31896GpcDOCbNg4q/FNQzWhGRK8efjTrZw==@kvack.org
X-Gm-Message-State: AOJu0YznLIHWD7QpqqeVHwUrjQmVz8ySFeeVY8hpuLQyF78Zqt1UIEkG
	y0fzNe1fh+MdxjARb+1RV7LGiMWxE5QRaT6wxTekJe+L1uEiqcjyzTla+aQbDxVn5xM=
X-Gm-Gg: ASbGncv/FbPaECwSiHzQCFO4kRGRFWsqs143Vk1lDadvBVVKpHM2G/ZROM+7ChE1eAt
	BYt8TXoGXELniIG4fhslAi111K3wC9m2EpCw3EkL62CwwE4p38FG8ztFjd/1WIHmFqviXqd9oh9
	18CX3PtNU0o4CUldkxGE0JE/sH/+ZkD77dhp2fc75i5cgszr9L3t4gBFBGXSeO3l12i9QCUpr6c
	PZLsA3A8vGA8DTfS/HpkEzTObkUdXOZxKXb/jCpvMOIxNhOR4ZPbZvKz4nGiF92uerecxYaZuc7
	LhdX1TBBZIZYILxvzNMeQBED/pHn/pzXX44PixJMO0E8JC/8OTo667y54yLiHkROBff8dws+D3q
	R0H+b5H6RzyhzpS10V43SVxam33Q5cCEJAAJTGimhQORvoQVRmGTpKpgmZ2Z86amFfwuJSyAq+H
	o=
X-Google-Smtp-Source: AGHT+IHezaCibeMYUx2n4QIwepKBTAEGeWF/wdbRATNTTWqYlSWG7aBiY/OaNiXbiz5X0eqEvxW6Wg==
X-Received: by 2002:a05:6602:14c2:b0:887:5cc8:fc1 with SMTP id ca18e2360f4ac-90168766a6bmr566009339f.13.1758816391165;
        Thu, 25 Sep 2025 09:06:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (50-32-2-77.vng01.dlls.pa.frontiernet.net. [50.32.2.77])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-903dbb2b459sm88516339f.0.2025.09.25.09.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:06:30 -0700 (PDT)
Date: Thu, 25 Sep 2025 12:06:28 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925162426.00007474@huawei.com>
X-Stat-Signature: pkujdmysafd8h448dy6cermszh6uqpso
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AB1F1C0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758816392-381438
X-HE-Meta: U2FsdGVkX1/N5Ny+vT1ttgHjARuaxZjsnLhQwnjZeU5mek8ha8Oi1qWYMVTvYWbi7wCtOzafaaz+wccVVZx7IOcaz1Klwnu70c+3WsIBw4+w1Phj21ETve1wemsboxzobKMAT4PVL67a3kCVQzV3Y2f+Y0ZdHYe6ihUczJIR5W7NaUl+iZcGyhKL21ZTzvMnyBYUo/RKuzrW72+HgAkTN+yU3Lr/24dO5qrAKY1mN2HsxfEevAPrwHwhHuonrEyJFN3C37R/gGLdtqzUIeVNFj90zqfXJpRr86H4L0W4jY20P0H0LtUtAq35rd2+hDldJzbBwc+CoMRb+qMlxt6RGfa89T8G1d679F+cLQ6PJb/gkuUdugoUoqvUz4YzNbvWVRFUsYGCgaFcp310ovB9RvMEGBwixvCSlkaTTiqUb2Fd0iBVhF+Re6+ZyDkV2163EhM4r0iozN1Ji6fE+MuK+bdYwMgyUoGIHop7VoLG3HPGmEvipA3Xg+/MBozvAePCLYQqBUV5QIXXGSp8ZaRVHh7f37X5Pb+cETDakV3bCbZcJ+1BlRei969dPxriAI2myC0GVto6q46kONmuSW7EEEdPrH8AjOZNRqG+8Mcv6PhugDvRUEWj/94pakscTL3ShpLlsxe9k95PrqfS+VlVWclSrHB8S3SlvyIYFyOxGcJGbgVgaJHVU1+vF8TwBLCaxzV+L9Re4Q0/s6FmYsthYv7REGkxJ4o3+ro6HnPu8L3FIfH+9ysmxZnHVd+XuL/yubBY3OkWM/uYBgjMcWPrLxWjvJSrxDIMpwBABVz4DuiNLBD92JpFsIy4cifjHIVRF398ICojWOm2n04R5eBx83b1USYnYu82PUTGC5QxpjavHqX/GjU/Vco2pj0ENwbKytullSZFJiitHbKl8lU8he1DMtFkBNyYxPUyFSVYlL8jsFO6hEiBC6Ab5j/sA8pToH3IbV48GD3+FjVfS3r
 l6LUQfh7
 kVqSy/iEStd71g3lcbKZ96jHfD1xENy0KlyqV7h0wRafx7O9ObbuiQ+/LWsTx1K2RtVTu6Z78UqpMNCtGnY3/A6piTKHHEO9zUN+NnfMqeAIgxk6K5+edSmzyw9iyOLCAdqQKKybDW3Eq1gp7JmxM3XRn9pvlbvoaRGn6NLbwEm6tNkOxzdaaV8+wDqIWKsJsOc7fKsC/37RDQkptFW95ntXBV1TaHCqGRs3yzzw8MhKDFJNkeh5qGb1HB82C/ZUKbDyzdHRsSnvvwxAHaSfRknL7JjebX6qN0ZeEplkM7HKyXAds+mUX1fmRbou+mFL5XpCOAzrH7peZz4+NSJJjBXW9+3BtPv+s+o/4+CNGPBRlcEtt3Kw3U2KzusRtHJFGUqTqEcEsOxVBRp7NcTeTkuGsiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 04:24:26PM +0100, Jonathan Cameron wrote:
> The CoW thing only works because it's a permissions fault at point of
> asking for permission to write (so way before it goes into the cache).
> Then you can check margins to make sure you can still sink all outstanding
> writes if they become uncompressible and only let the write through if safe
> - if not promote some stuff before letting it proceed.
> Or you just promote on write and rely on the demotion path performing those
> careful checks later.
>

Agreed.  The question is now whether you can actually enforce page table
bits not changing.  I think you'd need your own fault handling
infrastructure / driver for these pages.

This does smell a lot like a kernel-internal dax allocation interface.
There was a bunch of talk about virtualizing zswap backends, so that
might be a nice place to look to insert this kind of hook.

Then the device driver (which it will definitely need) would have to
field page faults accordingly.

It feels much more natural to put this as a zswap/zram backend.

~Gregory

