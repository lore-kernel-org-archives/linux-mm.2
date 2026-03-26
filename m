Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE9B10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299976B0005; Thu, 26 Mar 2026 18:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24ABE6B0089; Thu, 26 Mar 2026 18:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139C66B008A; Thu, 26 Mar 2026 18:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F02DE6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:19:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC6D5BDC1A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:19:56 +0000 (UTC)
X-FDA: 84589632792.08.5AEC796
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5BF50160003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:19:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A6/mP01n";
	spf=pass (imf08.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A6/mP01n";
	spf=pass (imf08.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563594; a=rsa-sha256;
	cv=none;
	b=Sy0t8ebSPjwPqzCe7zWF8q1iJRAkTZwEZQMok+UWWBnYOUFJHANI5qHype/Jn9eYRo6XPw
	n0dsIBuTwyNY0joECQO4jVpvVsrNzLnwk+2m+eOQtLCr5PTl3JJd6BunRlrcXiYHLJcgYB
	YC3MwVe1j50aEI0tUfSX6IkT0gk6KQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llBE4DQfBfBpoyAaaaj/5Fh8IshN8PkZbxEFPZE+kXo=;
	b=LWwbt9224upU0p0H1JEDgVP33oFuQcIRRh1O7zv5kfjrYoGnZ1UDgf8XYZTt7qfSLpNwWe
	LQGxGqXJ/sU1+/qQlKjVobEAu0O3WrN3g2uTowmieSrIFLArzV70Mpab5yS97Kc9YFmzHq
	eRo5OI8J3fYeotsGHc51XxN9F6GnnCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774563594; x=1806099594;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=8B/tXMYm8hAUhCMR+YxCgI3aaCb+Or0dadbsaOVLgmI=;
  b=A6/mP01nFpqiEMr3MrSjh01oiu/W/wIs6++8axb/ziwUxV9KxZ8iOsJ4
   xiXE68Vw/8ZEhzs4UDt9f5DCuqAH8TaqN2iNAk7ELYGlQfrDv9cihyYKN
   H6TflnscFQmhxaTwVFcnSULpdjLR6IfG/IMMl+NgwXxdYHNes3YYm6pu4
   xjfKHs4+wPNDC14zAUn+hgbEKA7qWBseMeV2pOXXvHD7pZu1jVYH4ry0n
   wqT/tX2jPr8bc+GeUTBe0yaktFvp8Qxr8QPrVf5Adtr8s6RJhm/VvQqto
   Np8mR+ZK0kdqBuQHUiV0qm/3yn1H/phjc7my/IqJSTQN9tDvKITWmCGV/
   A==;
X-CSE-ConnectionGUID: lZD7uQTuTROSK1MivlubXg==
X-CSE-MsgGUID: z26BLbl9TXuVydZxnO/Itw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75351484"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="75351484"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:19:52 -0700
X-CSE-ConnectionGUID: Ko7MAvEgSz2TmyhlSJ4h6A==
X-CSE-MsgGUID: SNSI9yd0Rd6Gw+Hl/lkW9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="263048103"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.122]) ([10.125.110.122])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:19:50 -0700
Message-ID: <9d672ece-e67c-47ff-9978-db405c939f67@intel.com>
Date: Thu, 26 Mar 2026 15:19:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
From: Dave Jiang <dave.jiang@intel.com>
To: Rakie Kim <rakie.kim@sk.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, kernel_team@skhynix.com, honggyu.kim@sk.com,
 yunjeong.mun@sk.com, Keith Busch <kbusch@kernel.org>
References: <20260326085501.343-1-rakie.kim@sk.com>
 <67c5b4a4-fdee-425c-8383-5c9c2f32227c@intel.com>
Content-Language: en-US
In-Reply-To: <67c5b4a4-fdee-425c-8383-5c9c2f32227c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BF50160003
X-Stat-Signature: c78re8gbsxjuqw9y3ixpg5bdg1oe6nm4
X-Rspam-User: 
X-HE-Tag: 1774563593-137741
X-HE-Meta: U2FsdGVkX19vimWQYuz/CtZoSn3IaTvBPSmrH2KQn2bn/Yv/jsIZk+ZeAsjyrr23euTj8FGk3A4lQBiLehbjdN7mJtxCa1X/fHWyQ4h3NRGpxfuNH/ZgEZDielBE7esCOzjEuPP/i/Fb3X3HEvJyWM9p8e0Q8xc81S3RXt5E6c7U5lRMRcjvmAT0782R6B6R218+e6MapxikVihYIvD6UEN0xqi8GIh9Xa55HjA3AOkMhnj+PEKXgIsSFO2SToxxwljI7f5qxYXNsHlK675/NYTIKpmRmV8PJ8sNZoILx5t32jxV1mzaIbdSwyro19eowkQgbjQOINSs3koQ4xAp2rnPptBlj/kZc+3UAWF8gFvMhuG76YbZnkboMc2hxqp/cyWIXr9Yj5fgi1nVAsZuJkVL8siLZjt5MRgOE3IxtX50b/laPx32o7PseTK8JcQAU6+woYEunkMmKDBFUdBfd02XBJEXvvUqCLd56j7Cev1KC4HhPQNJ7h1HYgHL26EHURUJfHVwr+Gb8pJwfNy9IuLynMyGbun9h21ozsULgxC/4Lz3xUpDP7hWTjRT4y/QXjvcZgTqNVgTkQ/5E4m/VMdomkzChZqpCnidQ47mUG0cM9B+jIdJPxKpF8Wotrt6KmkqbknxruzhcDCjD5ftrlAYR+JbxXO9dUcu3kHSYgiDDO16YkdXjHYsSEr3vBI1qWMEQCS8lnUV89PlVTLJselPB0zDuN/lAOO+MSZWwRojF1GOzv4Cbhy5dvLzEJPa1qwFq15a6JQNi09dYe9oupLl7xt7fEkjMU3jlOgqYSHGx6ed3kerDHfpPyS6sFAXXvO+lqUADQlO4eZy3shbNX/TcBfp9F862P3S54MNWaRrcU/onAe4JAPRHfQlPuHVGFNEjS8vMX2e5j51wou5+onwbUgedwLGxJEw7Vr8dtcq1F2mcKy0j74rnyWzspx1ln6suDUhWOdVZ3x+SMI
 WvGRfb6p
 Nk3mXdY1iIIvqZkV31B79kttlUrE3iv4gfCzb11DC4c/LNLrJK/p5gdHWfeieexy3Ob4LdlbssAJpDYgIjVpMKrXSRLx0HyGe7UGRX8ttRxrH680UvsvO0MuKuI4Eopr47AVRP7etynjpISQv2cmo7Tw7sj4T0QB5lYyscCLZ5SwaDKkMTUm+RxJi/HbMIj/dCwbY2Phyt2kE2sZlY38a5FOU6A1/xEi+7qcePjf23fB1dhcyi9jhgyJvSGREgvp4sLKYEsP5hnnCR+yaXjikOE8ZsOE9O/NLPNEdkrCJIA/XKjTUNtWNIKF/uvCcEO4ac5UsiREaxGFr0gfrm3oRa5paC9Lk8JAieYU5/wlGZgKt+l0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 2:41 PM, Dave Jiang wrote:
> 
> 
> On 3/26/26 1:54 AM, Rakie Kim wrote:
>> On Wed, 25 Mar 2026 12:33:50 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
>>> On Tue, 24 Mar 2026 14:35:45 +0900
>>> Rakie Kim <rakie.kim@sk.com> wrote:
>>>
>>>> On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> 
> <--snip-->
> 
>  
>> Hello Jonathan,
>>
>> Thank you for the deep insight into the HMAT parser code. As you
>> mentioned, considering the current state where node 1 is still
>> registered as the initiator in sysfs despite the flag being 0, it
>> seems highly likely that the kernel parser logic is not handling
>> this specific situation gracefully.
>>
>>>
>>>> Because both HMAT and sysfs are exposing abnormal values, it was
>>>> impossible for me to determine the true socket connections for CXL
>>>> using this data.
>>>>
>>>>>>
>>>>>> Even though the distance map shows node2 is physically closer to
>>>>>> Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
>>>>>> routing path strictly through Socket 1. Because the HMAT alone made it
>>>>>> difficult to determine the exact physical socket connections on these
>>>>>> systems, I ended up using the current CXL driver-based approach.  
>>>>>
>>>>> Are the HMAT latencies and bandwidths all there?  Or are some missing
>>>>> and you have to use SLIT (which generally is garbage for historical
>>>>> reasons of tuning SLIT to particular OS behaviour).
>>>>>   
>>>>
>>>> The HMAT latencies and bandwidths are present, but the values seem
>>>> broken. Here is the latency table:
>>>>
>>>> Init->Target | node0 | node1 | node2 | node3
>>>> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
>>>> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
>>>
>>> Yeah. That would do it...  Looks like that final value is garbage.
> 
> Hi Rakie,
> So I talked to the Intel BIOS folks and apparently for devices that are not hot-plugged (with memory ranges provided in SRAT), those HMAT values are the value for end to end and not just CPU to Gen Port. That's why they look so much bigger. So there are couple things we'll have to consider:
> 1. Make sure that Intel, AMD, and ARM HMATs are all created the same way and this is the agreed on way to do this. Hopefully someone from AMD and ARM vendors can comment. We all should get on the same page for the CXL kernel code to work properly.
> 
> 2. Add code in the CXL driver to detect whether the range is in SRAT and then skip the end to end perf calculation if that is the case. 

After further talking to Jonathan, I don't think at least this part is an issue. The devices that are attached at boot do not have Generic Ports in the SRAT.

> 
> DJ
> 
> 
> <--snip-->
> 
> 


