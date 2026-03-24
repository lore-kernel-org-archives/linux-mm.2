Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B417FF532EC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3ECC6B0005; Tue, 24 Mar 2026 04:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16476B0088; Tue, 24 Mar 2026 04:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53336B008A; Tue, 24 Mar 2026 04:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D75746B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:11:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89120CEC8F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:11:02 +0000 (UTC)
X-FDA: 84580235964.14.3E88C03
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id 572DE4000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:10:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jd6les8F;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovdqLfrLfNLqQkHe/B9nBLf4SoIZKFL5iWuK+Ra6vtg=;
	b=z+VH8AwuMoT6ThDUxcKRqeU+0S7bE1LldcFteGQD82cjEXhJoll4ePx0xi1DRd9XLYma6F
	b5qgxcBDjeFk9thmuZt738ZAJubPdGSK/tQi3cIo33Nw2VDCXC5foKINbpWogsBGMywwLc
	YpDOeY0MIkGbWoAnz7m0jf0RT1MMuKY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jd6les8F;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339860; a=rsa-sha256;
	cv=none;
	b=BpHBgNLmpZwQfi1b9YLYFyQUNmPw2MxlZ0Nl0MsfMrA80gSZW6cLdnSRFzIpOPHltJMkrn
	q3t6SQg+N+R0742wGi/705y8RJzywk003luI8W/o2Es9212/jbTjXbpxy273hPRLmOtbcP
	nw6GCxpSCLTZrTqQeNpDBrGu3b5tWo8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774339856; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ovdqLfrLfNLqQkHe/B9nBLf4SoIZKFL5iWuK+Ra6vtg=;
	b=Jd6les8FeSnW0aboMMI+OhbsSN+y0ILcyo3s3bux1L8yeoAMHfraxSlc9EY70EmD7Bn8rMIe10FMQvLbZDxI1LMBlMBjTpuLYX/8HO+yFTHh1ACipTwIIZM/i0nzHX4uxeOHIeAbBjRxUTHtB1Cfnb7Jym+AT38Cg2Nq6/kWxc0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0X.dvi7y_1774339843;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.dvi7y_1774339843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 16:10:53 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <lorenzo.stoakes@oracle.com>,  <Liam.Howlett@oracle.com>,
  <vbabka@kernel.org>,  <willy@infradead.org>,  <rppt@kernel.org>,
  <surenb@google.com>,  <mhocko@suse.com>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <dan.j.williams@intel.com>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
In-Reply-To: <20260309120725.308854-14-shivankg@amd.com> (Shivank Garg's
	message of "Mon, 9 Mar 2026 12:07:31 +0000")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-14-shivankg@amd.com>
Date: Tue, 24 Mar 2026 16:10:43 +0800
Message-ID: <874im51wcc.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 572DE4000C
X-Stat-Signature: adp3ktfz13xt93xx3f5rfryckg5b9rn5
X-Rspamd-Server: rspam06
X-HE-Tag: 1774339859-864872
X-HE-Meta: U2FsdGVkX1/7YGA9zmdlBDvLOKHBeh5DaSdB9zQ7s39QI2oGIDfIjrw6nlC+lL3UtbJKc6VnRvQu0rzgYI+yZ4Zr/rdQQcFg76Q18mthNREl1/wmXTFK3GwXVUlP0s/SLBYrwR1ZRpbxPUXrADfJgTdiCWraPkn3ERXjzZ+mTaokg2e9v2z3+8k1vLxpU2SAZTgmWfdmimAMZtvy1qve+siYdC5Bp/1jseS0B6yYD2IxGDqgRTLSxT5KM/TmbBtO+CmplxP1UCkJqK7c7A3xmYdLGpit1fpfhhpnbiaDpGPu8nXlLDNjr2+DvImNWQDRttkh4prvTtca8zUj4JEkstbB0rCyRJcQu7SKYzJU2ocint0mrEXiagsrD/Q4LNRoxkbCa4wyM2Bgfv605yBB48l1SGq1ep+toHq+QBoVrfK3LP+kS26lbk6ylj4bmhy/KRP4JfGVkK56ELkQl6jOOnDmKW/1tODr0kuAqjiHcys1aDypDzRyDZEwjDwjp0AgVE4kLz3CN2BJMlFW0ZNqL265lS/pGED/UWoXvsn4bH16QFjA9JBGawC0280l2oU1H9/AOPQSrmPRvR9+pKjgYB6GTbwKWVruXooskGzScA7+jGGYSZaZFZ3nahsL2m3XmZITpPO6b1Vd6YbtiMoVcU2M14fIbXXrA0n0fJvVfycDj9W/jmKpLoHlXj+GW0kAt8N35zRbHP+FUmKBS4pOGypQou0enrc/EstEMr3IpxpbMpsuMsTGnZSVzQPrn0gwLDufuUi4LziSj4OAi/wADwz/EGD2wBGpBb6YgezvSHsYvwD/Mzv+AJvvoTiOriUVevHq3oFpghSjTRANOboR652hZ8XsKJDBAHMrcgRUJOoyuTLDpuYWgDB1R0YAHhzfN54g4kbXFUYiLIEz7LKZKB5PfHYyNFsVVR5g2dxYXexyxC+UtSAXrbsQ/7+6pPIFZZg0RMWESdGRFcDsJZm
 H0OqJqGu
 LC5ibau7+4Q5Z059jtHp6MWGmm9rKQypvULxbQKxBffeOafo7wQx/jpYT5lNRIygCzS094dnB9AiczBKrUEqrE5fn5mzNnkF515mTUDI9XxWFbDEQgLUUYIB8Tq26JGvLHKGRSxRNrGqLWNgYlBJmfr2AmTJMuyaHRqPw9+PQ70+ZDNeM3rKzJvqg1cRFJNA3FvpapTwRd+25dfkc/US+rXH81jeU6aYeqZJoPgzBIly3sxHowv+VrtTD/T+sBRg3EJzSvqp7JANiHnSznA+9c+hm+O0FelkBA3BeR9mkenksItxmO1nz7lStv5BUYH/07cXSQmmlfJoh/anb8X/wSydN/LXnLaGgiWtlp8dHdvBdmcE4t9rLF1GvkTwU+1jRCLp7Bi8YdHUOVJpzTrFdDuPeUrrD7kGvKS3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Shivank,

Shivank Garg <shivankg@amd.com> writes:

> Simple DMAEngine based driver that uses memcpy channels to batch-copy
> folios during page migration. Primarily for testing the copy offload
> infrastructure.
>
> When DMA fails the callback returns an error and the migration path
> falls back to per-folio CPU copy.
>
> Sysfs interface under /sys/kernel/dcbm/:
>   offloading      - enable/disable DMA offload
>   nr_dma_chan     - max number of DMA channels to use
>   folios_migrated - folios copied via DMA
>   folios_failures - fallback count

How about placing the sysfs interface under /sys/module/dcbm/?  We will
have multiple migrator implementations in the future, so dcbm behaves
more like a driver, right?

---
Best Regards,
Huang, Ying

[snip]

