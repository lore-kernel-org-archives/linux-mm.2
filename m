Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F060BD778AC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C78D6B0532; Fri, 23 Jan 2026 13:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374916B0534; Fri, 23 Jan 2026 13:25:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB216B0535; Fri, 23 Jan 2026 13:25:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1967C6B0532
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:25:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA1EA1A04F4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:25:35 +0000 (UTC)
X-FDA: 84364056630.29.8A7304C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA6241C000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:25:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769192734; a=rsa-sha256;
	cv=none;
	b=7iCdRAmyXB8gyL3lKzPH4BgF7U3eUNrdklMRhqKlltZWSDLoD3DOHblJxtudc1w4DtMkzD
	TPTcbkXLjB1Z7Xzz6cjqvyk28PI7ZOYFhWMV//v7XeOko1memVtGnJkHjWsnuUkElpGAPi
	Wu/4k58CFk+sLvbHetvTziZwzku57hQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769192734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4fyaRR4voNxq8GIVydnj3W1+pjQzyvci15sg++4o3rU=;
	b=jS68xslaknxISswJo06nuA5MAlF6FDBZ7brab4/THwCEOzfECxPqulOEBdOVPSvmOVYjA/
	IoLYDgdSj3Rgt1leK81FU8qpbpdCl3k67QzRXTpCwcAm/T32c7+WglAYcXwAGpQ8Sci1sA
	A8CKnM/5dpNcxgSSTq59Bi4EeTQA5u4=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dyRDV5hM0zJ467F;
	Sat, 24 Jan 2026 02:24:58 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 85A9F40570;
	Sat, 24 Jan 2026 02:25:28 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 18:25:27 +0000
Date: Fri, 23 Jan 2026 18:25:26 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<kernel-team@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <eperezma@redhat.com>,
	<osalvador@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online
 type control
Message-ID: <20260123182526.00005ee8@huawei.com>
In-Reply-To: <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
	<20260114085201.3222597-4-gourry@gourry.net>
	<b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
	<aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
	<4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
	<aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA6241C000B
X-Stat-Signature: tjgxjxftyhc5chd6488kcartsfcht3zn
X-HE-Tag: 1769192732-98700
X-HE-Meta: U2FsdGVkX1/vx4kyOFpC4PmkbCDdK5/QXLu3wqX5snKr58pCjKcWCpAhAG9OYuIM/vftNHyx4BjXQ4rqkusuuqcTUxQ27vJ6izJabXQjiBPueWuwWFVk2EEtL0JTEyjUh3g3s3g6Ibgjm/Xb/l7neODLcsO5YAW0HQ6jeE/vgK7U+baKROgm8xlAaYauK6k6Lc1F8amqgzsEPh/8ZZtQyP2u8ZMQ8Thd0cfxiXDq0FqKw/qt1yWtOdLnmv6MdsLXpXZOi1e8v3JSNeJRrHTGtxi3Y3fQjR1qCCN6nUeQejqX5UtRVxo8xUDjirXimGAIaWwaaTA6OMvnPw1kKNuS0l4YwOp8niRhrDydVwako57frnt4QiNJ3pCXu9vv7qX+RSvBo/GrZuKU4s5oc0WRt8qObqgdiYobAMHsyIsDXsqK9fkI+fK6f7ELKd/k1abaHlyZLt4gvRhTYhzq7b8QUEMHiAvf54ALG+ZdODq7onskjkfeGlYNNt5Ss63O96Dke1MHX37ouoZVEtYUIUE9C0prz8gSrpAxb4KrtifNDMt7GVK8uVqcsenApTk8jADBiFIE0b00tNjDrcJTLg/S0tpOyZYsTnypxnuaDk0+YkrsGkjUbrgF/rKBVGCrGQOEfeXTJUV50na/4byHOL+JFGn5JD43ebxmbH/bUnsDNOaQ0vJGzQWLtGeYJzokWd3bsydpE1GBK44M4ApFSFTbz30Na33hfD3WKL2211CDa0beB1WomJqEwFaVrtKdScBW9hX/wAPutzsNp/1SmAne2maXfMVIIAul09bTaNZUIaG2UcJUoohdU86RqvdggmXlt9dsd29yAhWFj5NZAYIqhTEiLkNO6d4DUQMFaRlKAW+ELdOAyO96wyd3UjeytE+pcXT7o3zMoUKSGDrkc2dU22Zz6XZNkX66txS5WXxa8/pa3rMPFK6UHm3d09C9m3h4VIT7XXdcstWHvtGBODZ
 JZCo1eH1
 sHh6hu7f+IXJu/SQVFuiJaN/LeRrOGdr3IB3Q6dx8Y1Ufj7gBFZ+SeUzgwjad3xbp6+FE/wwAMfy6WLgDQgtm4dunQJHya6/eMnJVEE55eL8JtSvjRGhaq9Cx1AikVjOJECvJGXjWCmwelWgqWALIvXW84JS4znU0po1nfeDVYuD3yqnCKrRMKHNSgyg6AXAP29ef0n7tUA8RzFM+KSLKoYfS8M9sbZDiaq9xtRZOt4UMOLmhIRD0DV9iFgjs8359/+3nfaFkEG7gvtkLAKG7LcIRGD5uCZl+vDrr53r/Z4Z3ScDr0yG/rrJ8yDEE8GnWWrEBp9NdXg0CEwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 19:34:10 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> > 
> > Right, but I don't want any other OOT kernel module to be able to make use
> > of add_memory_driver_managed() to do arbitrary things, because we don't know
> > if it's really user space setting the policy for that memory then.
> >   
> 
> Ah, this was lost on me.
> 
> > So either restrict add_memory_driver_managed() to kmem+virtio_mem
> > completely, or add another variant that will be kmem-only (or however that
> > dax/cxl module is called).  
> 
> unclear to me how to restrict a function to specific drivers, but i can
> add add_and_online_memory_driver_managed() trivially so no big issue.

Is EXPORT_SYMBOL_GPL_FOR_MODULE() enough?

> 
> You'd be ok with with this?
> 
> add_and_online_memory_driver_managed(..., online_type) {
>    ... existing add_memory_driver_managed() code ...
> }
> 
> add_memory_driver_managed(...) {
>    add_and_online_memory_driver_managed(..., mhp_get_default_policy());
> }

> 
> ~Gregory
> 


