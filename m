Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6278CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC228E011D; Tue, 14 Oct 2025 09:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C528E0112; Tue, 14 Oct 2025 09:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334AB8E011D; Tue, 14 Oct 2025 09:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3478E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:21:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7118140848
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:21:13 +0000 (UTC)
X-FDA: 83996780826.26.44D5AB6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1FE4210000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:21:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LuhlCmGO;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760448071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xeAu8B+/LX43o9qs62eAzypTsmhUMsAjzDseN7YVlw=;
	b=O2xxTyXVPdmsbDx/PPdlMjCzfEE7zhGWMpaIkG3t26eCSAMdf89S5v+FGiAW/sjUyiLEHA
	3XaDW4EEHSyPA1CuEgZ1HRlzoHTzon/gcszYoV6usfdnX6tzcQw8dokD+DtbPqOIX17N6q
	+D+SEQvVTuxStQKBRDFPlll9m4iNQX4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LuhlCmGO;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760448071; a=rsa-sha256;
	cv=none;
	b=BMWyMT4zlQ01lMrX7/45O1pX+kR1LqhUD5BpAoZ2u4VVk0xfYGCIu3PToylzmMv/D1Bqef
	aZkcN0Ic1M50G5w9Cyuk6cU/JmbfVhBp5bjRn85Iq+HlR90koAKtHBEBdBn7cKcp6srDe+
	ZRqIAGOGBtlfiii6cvZxIb46JAr76Ws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760448071; x=1791984071;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dwlM0r1x41mCovJ0Qg9vjNNsJ/ik6stihf/fX5U/0ug=;
  b=LuhlCmGOAXt91Y5AhHNzrrUG7b8P7lHwHTWiSn6THEInN8xXnWHoGTTJ
   hV7r/o9XZICOv6ZzzzkGakmYNVfYiw8cMCJBIdcLkEhfahrcLUSpJtCrw
   lhiA9pMUmE5yuq1yR58QD7tjVe5y5fsWQy60VGKLCZWVfNgF8MYXt7I7M
   mJZZrSvtm1xO+tcm+zy196COAkmyv6Q4YvQ5O3BOHZfKdIuHT1b5UAcEu
   z60NOuh3hFjs8QkBIVVMEGC4EaMV2rw6mMbAJpOZYL6Z+kXucU/fSHGvv
   Y/vWF1rKiovP5kL8TRArZVZ9W/8xREutpLQ8FBB6jsWp3g8SeRJl0Hd00
   A==;
X-CSE-ConnectionGUID: 1NikuEP/QY6IjMJ6yLZvxw==
X-CSE-MsgGUID: CWMVexRzS16ncpJKWuEFZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="65229220"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="65229220"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:21:10 -0700
X-CSE-ConnectionGUID: rSzo43+EStWT1L4l4EAH/w==
X-CSE-MsgGUID: f9t6ltQrTiCtilvRv734JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182343602"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.236.114]) ([10.124.236.114])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:21:03 -0700
Message-ID: <a1883b7d-b5f9-419b-ba51-735a977522d9@linux.intel.com>
Date: Tue, 14 Oct 2025 21:21:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, iommu@lists.linux.dev, security@kernel.org,
 x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/8] Fix stale IOTLB entries for kernel address space
To: Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <c04d4c9d-e868-4883-af92-26f142bc84be@intel.com>
 <d3cf3716-98ec-419b-90b7-b91b83599498@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <d3cf3716-98ec-419b-90b7-b91b83599498@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1FE4210000D
X-Stat-Signature: 9od1h49mkzf8b34t6aahzxcnbsxeehg3
X-Rspam-User: 
X-HE-Tag: 1760448070-547555
X-HE-Meta: U2FsdGVkX19os5WrDdq6UeacdwrIUSitpPubFCp94cwAWbQhqF+bFbiTN04pNMGNP5Fq5MQjkIzyei/QCf3Q5itduczQyaZy6m5P5uWN2JAKReCPzAQ1lcKX+QxSm4iOXcL4O4pfuAXj4lEXxOv0KgMyNkCqntsx93QEV36o1SgzmA3gu2jgovHm7XREknFGlYcJ5JZWpjMR1YMCAvjIxiNf2HN/zKaBKGziCis6C1YdyvkpXnznvlB9eD6fFq3Z2x9rfoUESuo37nbcqx340FWqGybhfUsnAQMj7Zc6PfHnFlG0ERdQzMlDlWOzvUrYCOiCEMXfCsTISYRd9Rjc1LqFDeCNHhpcYVJm28eG17g1lFyIw4dPE8vDhNV+iJLKAY0ekT0kKdglo6jwmJVwNZTFKDP1e7bj1BXcS2TGfkdQrxhoO2dJYeJsylfkMQ+iO73Rgm0zOuyEOBL4TEUv88oFU3wwKLSodBSwuT85K6xT2Ie+R2xSBiFDk0+UewLyuBeEig+oNA1VgC+psq5oD153kde+TXobdIObeF7ZeINrf+tjUezofVsIrc+qznlYzpiW3NPPqsOcIbk/hxy/jms1YkE2Oc7JGLwkQjSyaAaQtMfmo9WiMpilkGYxgqZDe9itmSMQXSrHGsg2CqzubCm9CEi2KWGOYuVrfHEoSlceD9y0WOhiX3713dTXoRnLeHK4rvkhdFJUgHDzwURpbV4CjMRMfDOC1S7ezmfTsQ0xeYvZlDCqxQlHS830ZJ355Pwmq339Y9axIg1FQI6XbzZUKdRtXXx41TBuDr2TdLwyCDnoHffXvr/SvQyG3NP+xXuJGNZO7WThkGCNQbqZmCvSEGrI3boXJhWOE2Nsn+fvEX/TUsKKxXWP4LFVB9A3+KzLSTdikzmfqLt4sO0VvSs2BotOuL3YRdL0E+Q9ENf6waOhXCVt1vjfPLtBJnXI7ma7HwQDqYDKo9zn5Xq
 y/xXiWve
 jHeFxPj0EutLOGg+IfbGo7YNhFD8jDlK8gHAic1ENsGxjNMGHbG2TpscgSkiWwQH6Nj3aHcvgY7I2SQAIGi2Auw66c4iunL1p3o1wrL6FY0JMd6URc0nKG25FfJhzq+CceYNcPGc0Hc+Rds6IPIsRj2rAgO8NhVK4IPY7O7kYe7koN4HkbFuCba9OYwP0YH+Y7GUnlGqzXiSDCTQcuiMYY5ZgTEKS0wELrbdzK+no7FEqZuCegpWMWcrJag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/2025 3:42 AM, Dave Hansen wrote:
> I wondered why no mm folks were commenting on this. linux-mm@ was cc'd,
> but the_people_ on cc seem to have been almost all IOMMU and x86 folks.
> so I added a few mm folks...
> 
> On 9/25/25 13:24, Dave Hansen wrote:
>> On 9/18/25 22:39, Lu Baolu wrote:
>>> This solution introduces a deferred freeing mechanism for kernel page
>>> table pages, which provides a safe window to notify the IOMMU to
>>> invalidate its caches before the page is reused.
>> I think all the activity has died down and I everyone seems happy enough
>> with how this looks. Right?
>>
>> So is this something we should prod Andrew to take through the mm tree,
>> or is it x86-specific enough it should go through tip?
> Hi Folks! We've got a bug fix here that has impact on x86, mm, and IOMMU
> code. I know I've talked with a few of you about this along the way, but
> it's really thin on mm reviews, probably because mm folks haven't been
> cc'd. Any eyeballs on it would be appreciated!
> 
> It seems like it should_probably_ go through the mm tree, although I'm
> happy to send it through tip if folks disagree.

Thank you all for the review comments. I have updated this series with a
new version and posted it here, with the mm folks cc'ed:

https://lore.kernel.org/linux-iommu/20251014130437.1090448-1-baolu.lu@linux.intel.com/

Thanks,
baolu

