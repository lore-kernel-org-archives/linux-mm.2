Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91D9C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBECB6B00A7; Thu, 24 Sep 2026 14:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B966D6B00A9; Thu, 24 Sep 2026 14:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85516B00AA; Thu, 24 Sep 2026 14:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 880AE6B00A7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:52:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F65A1C2D68
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:52:01 +0000 (UTC)
X-FDA: 85249550442.20.04987BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5DEC7100003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:51:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWev+vg3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POlX+wONx1gCTE6Vq8TjSNhvRxCbSmUHbAHjJxxduJA=;
	b=gb4ZI2mEoD7c5hEGYdxtuO9DILVTbtGBAJEzd4UPm4omalelDlltCHib5mA6MgtBelv+ba
	XAokN9L9Bmtm+dX4oDPGhCTejKFqX77PnfbWXgjDthVA0zN2tpgGWhL680ID/SpNxFsMgx
	3pcoA9m7ex+SgRfPgI69xTWSzFEzrow=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWev+vg3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275919;
	b=UQtdkewyC8b8CrgxGWgJBISTOIbPZccFjJDCV+4q04eWkwFAtgXlTnYE55QcekYkgLIbHA
	IWrAIqQQ3ghGYfIJqBTUeXkmep1dRy2UuCZEkayTt0kj0vcut7DJ9WtLruUGJPwYFReg0d
	5XNzOoLjZy04jsfs/Dim/d8gAgyqnu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9E4343D84;
	Thu, 24 Sep 2026 18:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D9F1F000FF;
	Thu, 24 Sep 2026 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275917;
	bh=POlX+wONx1gCTE6Vq8TjSNhvRxCbSmUHbAHjJxxduJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gWev+vg3aOUbjtwtT3U2+C2VyN7eOtcfSBJs3s8YonBNI/+ZZ7xc1mf6k3ukzx0PH
	 Nb814Zy6qTVPFJpgHeTrhLWHbWJXlGYju1D2NrpmJPctR+FCbAJDal4gVTwnWwW2xI
	 /MFTvB3yrPrnMGBOFMN4O88mm0HjIb4cEaoDuj+UNT4EqcaMrg/MKzFJ8w/H78bLVm
	 fw9oOITb653B8XboMh1yPGGCS3ctD7pEsjXS9288YTGJolEMdjEWCUs65za7t3JhlA
	 tImKWiPpv8xP/PxYxxQlkz6Rpt893lRL4IjOhyugIHB+gp0xVjpO+tnRCf3dnynPqs
	 aEjtLEJvNH9Nw==
Message-ID: <16d3f4da-cc35-4d1a-99c2-270fad68728e@kernel.org>
Date: Thu, 24 Sep 2026 20:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: don't schedule deferred kernel page table freeing
 while booting
To: Dave Hansen <dave.hansen@intel.com>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>,
 x86@kernel.org, linux-mm@kvack.org, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
 <6a0c2fd9-b2e1-40d2-b7a1-ba93cb3c53a3@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6a0c2fd9-b2e1-40d2-b7a1-ba93cb3c53a3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DEC7100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: p5uu5qbwhr3ok1zhk7s5pi7etbip8r51
X-HE-Tag: 1790275919-236334
X-HE-Meta: U2FsdGVkX1+gZGtf9ovnS2NGwNz+u5E1iPKEtkePL7CCc4U74biBrSRjd2TWAgfdR40P1FHjWBmuOXdH++HSUByI07Djow1Hq/yfg7ZX/4UfYotgAXZ5IMIMCmTItx7CFKVKrhWeXBlieO9zxyAdqoP8cznPir+GbVTsMZWBIZ3GPNO3JxyZImNj+MKWoMZGgC+qN6qE9qW9N49GpCCaOR7tBJwCqaHgiHdtsa7U2+bGTifpIO1OWp0Gc6Uy2/NE7LiqrVRZrqtfDK53jHGrWVmU4yNtcOTrFy8Pq6PBpg9GXDBeLS+oWesBdIfCJzPzU6s1bxfAjqNhHUo5w8uMxchXTsTX0cA2Fb5ipk0n98lDC7iVzv3dL6tltp+ZCtTXPp3G/qhk8nelZ1NLCqqPhwbYYr3ixnCJM+dss68Wb0Wm6Np496nRdzntpwoA0MuP24v4s2Me6xH4lYsik78p5Did/Ssl+yUppqNB0wgCJVeLWV5//WVGYLW5e2ovY5h8J+3KcdAnLrk1KLvcCqZEhTsblpNO44ZSZnUS4Z5Wv1hrqPVUzGq1+z1ix1iVoSv8QNrMY8dkIIYCl6aPMghuZ3ENjQmanXqsH0f2ndxgCBIpnVsAV6SEk9C3LIU8P9S61ljkjZuCACI5hm++MOSLApzfBf9VKrMDTdJhI5CPyFUbGHXOaYPruCsxS/WWIjpg32bABYfWyvFOL2uFmbZFhTQ+pWd3IMdsVD4QMVSwvFyx2a4zaE1BTHa5lgaCWDd0fgEUWvNi+bDFT4HMYaVUWYQInZPb8xcIo2Ek3L/MOmv2ElUQX28qvm3o0CSqYtPECjaUZZB2ZeserlrT4sUNQDG8J25QX/ZTdHry9V514zGvKIst7jT9gkZWzlzVq69zI8Cwfve//ML4y1Bpr4YZv4PggQRoYN0pu64BWto4sSyRSwiqqZ/s1nnWcgZPONJ7e1Yget069En8nfI0Sa8
 eFRddcKz
 nXI5Ti/UVGT/iBI2W1Mdf3q954uiqZnPRR4+v4gOoAjlIpexnbyR4B7OYLc05IUUBkZP9w9XNkj5IuXQqU93l9xbFfWiP53s9Y0lJM1izdIE07jmDA1/sgYmK29zphqceUbMLQMNoDAyF4nNVON150OhkuhMYgoQJj3rNWLgzH3A1oDjC+m1eoWDoo52DdIVlzhen2OjLxqNTcVk/SorNoKhPVaRMHzco9e+v9omu17YNVYlaOLPAy5xhHaOteGG/az0klLoNP4/y3v0faGuQA+aFH91hdWNw5FUyugjkX9JB6ppDCD0PB1Yaw0bGFyZRYS2LiVyxwRQoqcNJAj3/FZtZMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 19:57, Dave Hansen wrote:
> On 9/24/26 02:23, Mikhail Gavrilov wrote:
>> Keep putting the table on the list, but don't schedule the work while
>> the system is still booting.  The next kernel page table freed after
>> boot schedules it, and the work then frees the early table too, after
>> the same IOMMU flush as any other.  If no kernel page table is freed
>> after boot, the ones freed during boot stay on the list.
> 
> There seems to be an awful lot of chit chat about how and when the
> boot-time tables might get freed. Like:
> 
>> So on this box the early tables wait until the first module is
>> loaded, and no separate drain is needed.
> Wouldn't a "separate drain" be all of 5 lines of code?
> 
> /* Take care of deferred freeing from boot: */
> static __init int free_boot_kernel_pgtables(void)
> {
> 	schedule_work(&kernel_pgtable_work.work);
> }
> late_initcall(free_boot_kernel_pgtables);
> 
> Then we don't have to reason about it at all.

Jup, that's what I hinted at in v1 and what Lorenzo replied to v2 as well.

(late_initcall vs. core_initcall)

-- 
Cheers,

David

