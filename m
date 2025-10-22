Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5AE5CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B5D8E0006; Wed, 22 Oct 2025 15:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC168E0005; Wed, 22 Oct 2025 15:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB31B8E0006; Wed, 22 Oct 2025 15:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C48858E0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:12:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F99048649
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:12:42 +0000 (UTC)
X-FDA: 84026696964.15.AC066CB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CCBB40003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:12:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/rmej+e";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761160360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDiDIhAgxYtAgrSocK1j9aa060kOico56uNR3HEhB2c=;
	b=G5aVuYUmTts/somguDs9OQt5N2cf3XKBKJN99SWM/QW9ldAfiaQJwV4qnQ3vx8BBMEpDQg
	qkyB3iswox9+AGvomrvJdvvcK0x13LtLEEh+ZjaVd02JQL1P5NbRFMk33ukHgCmJX4zTMg
	mge5CBIkbuzHAb1MOnt6r93LyVLYt0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761160360; a=rsa-sha256;
	cv=none;
	b=SPN/lLiP0/xJBlGWI5DB8pZwMON0sujwR7APdxqsq/TT91LNKnzC4ycYRHgDAVLBrM3987
	DB4D+DnqKBCcH4IzIOA53pUGjNAQ0U9ybx/Ei77Suy9EnyUDNQ8jq1kSh08veZA4E6FRqD
	71mTd2cH570VR4ute2c7ft9pDLch4+s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/rmej+e";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761160359; x=1792696359;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l6xmB6cEZmbsRUmTIY9DFLEmMzBpKp+bIf5sHUIX+IQ=;
  b=M/rmej+ekNj3+7yiqA9/yYm3PiGCv8/xWGDlxFhjHlQP+2bQH2WND3Ra
   9DGglufdXc20fj3Ln9I0VIQtENOSmsZH6BLAgTDEICooEdyB5LhcBDl2e
   oWsPEgxNqNrh5DeQKdqxyWadDSW0WErW/GlZKMMt+UCVQPyDnEgP37tAx
   iEMv8ye9ca2KCqqNDpIOalLV7XlJA1B00y+ubjWVV4+AAwQB5lxyz8vaB
   dKhBfTuIRya5K9euyy3hCErgQO6iGH3yz4OeutW97cXSsZTTHMyI4kDpG
   eSOPZ2lIj/PRFeK7REtr7llNnIEH+/yHmmXrq/hVVpzmMN9N2rlcOWdtT
   Q==;
X-CSE-ConnectionGUID: 0dRS7xkmQ7+uXhUFUeYF9w==
X-CSE-MsgGUID: YrhqGcuRT4+bB31lJoFlIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63242888"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63242888"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 12:12:38 -0700
X-CSE-ConnectionGUID: ZRB78qpyRqm79B6FCilF/Q==
X-CSE-MsgGUID: QGZ6xIBWQ7Gh0OgeGMsXew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="188357832"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.226]) ([10.125.108.226])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 12:12:37 -0700
Message-ID: <fd0147dc-d785-4676-9c8d-824d2c709320@intel.com>
Date: Wed, 22 Oct 2025 12:12:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/8] mm: Introduce deferred freeing for kernel page
 tables
To: David Hildenbrand <david@redhat.com>, Lu Baolu
 <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-8-baolu.lu@linux.intel.com>
 <dabf557c-d83b-4edb-8cf3-1ab8581e5406@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <dabf557c-d83b-4edb-8cf3-1ab8581e5406@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CCBB40003
X-Rspamd-Server: rspam02
X-Stat-Signature: 53drqc1jeai6thhiuna8wc6jx8ctcggq
X-HE-Tag: 1761160359-52498
X-HE-Meta: U2FsdGVkX1/r7UpfUWhbmybE3+ivPlDYs3YtefxPxrbu9dcJ0lTtuc6IhLA/OMuFw5HHnU47JX0z7u61lIdEMNxVmzNfvyB+kkpgGp0B9vJgQqdLDMcW47H655mfg9iz1XLVjiyF0C2JLQGZtV+nYfTba4nQY0usWgNDzqXm2yAXFe5T3vkd8+YlUR25Jt/YagAkTwBWPleLsA9cD/vbT2qBhhRuK/Q5eLrqSJHgP8mOQ4sfKop7GTeZ96pFVWMWp0WRnFizl1Z+StNcdY2RCaDZHKQ0RayF2bidonYmR6l9alRBjofk7FRvhx13IatvHNJKwyFmqHCla/TjGh3Q0YiOcxsKtW+olOmjPd/va4I6bQh34M7y/+fuzepyUTT0Rbc4jSKoJho8MweyHSuJ+ZB3gyW+8YHpm8WJXCIVTDDeSXYFjctYBgWP/GYuDXcPra0tIS8TQ1F423XHmiQ1tFufi+EHtmyd6oaRRoPgrgc/oiBw2fa6FrpLDEDE40BfTFTpLyeSgDkUVQDX1lGixlkPsEt159w2xM/ewlqzeRKbgHpY3o+/i9lebg/dSPNjigk81avV+nHxsrE2PxypMqy1L1U1/TyX3+qKywHPIeC6XhbAixXdO54SVEVwNGeukLQ4mlT5q3eL3LwqxYnpyJ6pXkbDH4vcVUoVIrVdotYRt7+WwvW73ChpMEegWlLvAXRpL9TGrWDeCtJ8q26zDMuriatDAJuHGICKDwu7P7Q3yGbFnKvMbKG5XHGQaKe/3NeZW2XGiIonv6UHnGd3paSt9e9BEx61jkEybFtaPrQ0y2eDsORCDaknVqLOdnAQ55aXLh9g2VEWTIzZJr7wFZQDk8WtWBu563j+eLxUWgr2MO6hjOvvplCslJjpHgef6uCN0bGmEbSeK0aPMDjOzGjUPPuEtkakzHmE3ulM+2y2VxN9cXd2ttiZ22NE2GCdoiEw1+qoWvPGYin8H0s
 vksLZHKE
 NBhRyI6V8kJDcv+6GFcTp6WjaYTDblGu/03kvJF+4Bn49ARqIVi+lDD6e91wsa5lfJbmvcdrDpFHE0wa2FwqBOb3XA6xg9uqo7SvW4u5lE7Z565QY6fN8FI8YHpdifo9b6vaUad6y6lqcG1c7OUTcHmXejScYBFK67JZJM4TJHEp8LzqiUIYk6XPkJ6oiB9S9WdtwpR+wyQcVbRUA9sjEV+AAZ87c5nAnKkEJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/22/25 11:34, David Hildenbrand wrote:
...
> I was briefly wondering whether the pages can get stuck in there
> sufficiently long that we would want to wire up the shrinker to say
> "OOM, hold your horses, we can still free something here".
> 
> But I'd assume the workqueue will get scheduled in a reasonable
> timeframe either so this is not a concern?

First, I can't fathom there will ever be more than a couple of pages in
there.

If there's an OOM going on, there's probably no shortage of idle time
leading up to and during the OOM as threads plow into mutexes and wait
for I/O. That's when the work will get handled even more quickly than
normal.

I suspect it'll work itself out naturally. It wouldn't be hard to toss a
counter in there for the list length and dump it at OOM, or pr_info() if
it's got more than a few pages on it.

