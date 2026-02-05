Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6633DECD983
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9526C6B0089; Thu,  5 Feb 2026 10:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6256B008A; Thu,  5 Feb 2026 10:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA4C6B0092; Thu,  5 Feb 2026 10:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 681B86B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:41:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DA681A0514
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:41:23 +0000 (UTC)
X-FDA: 84410817246.19.A1A9DEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3EFEC1C0010
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:41:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lge0Cv4a;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770306081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzDiEIgZsxlHmTe9e9KPhynX8G0YBUS3E0Eqp4YmHs4=;
	b=xiujMImjn/jK5TajO/WAt2rKZ/Qirj81+opjwxy2ojeX43ljMIh96gtwdgXU3UTX02LVYZ
	q/gM4uqRGp6UCWQkM+ScJnUMjA1CneicO1GMblzzZrTXEf4RsoCbZxm9h0gqS3UGWUjeDP
	3j6lI9XXZvVGlGO7PYpoMpaVSGc45y0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lge0Cv4a;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770306081; a=rsa-sha256;
	cv=none;
	b=CL2Rf6gGknVDwmr7aK4b8582y3OEkVu9hQs8uWI6zMbX6xbuKpuwwjqBlCQhHbfdGDmxvx
	vA+TAUOpMewhHFkTYNxffo4EfCWJh1aJdvANIXMnOMC+0qnjVFgbfca3khA2M9zBob458V
	4V1qXNHQpR66flTe8m48mWlUuAso+OI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770306081; x=1801842081;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zNoAsT440FIb0g02Vad7ZEtDCAleg1YY9QN1EnWtRAM=;
  b=lge0Cv4ae4FupQgcrEWZvsgIdJC//bNVXfWvCbfqLoE32Pleeyq61tLm
   779oLXVKxCMPlydfLZy1vtB3dNJBSi47L141TBXJA7sMd0Q4hrYgibsLL
   pb5PcsjxOF3bQdrGh/AX7V16v708ih4qp4JBnKXHYFQVZQeZl+IC7pSmf
   y197TkWCot+BcDHjE98cvyaeERtJ+R4Owqku2+Od6ieowby0pvNa3SsrS
   65+9A0wSqx3vF03POoSjQCG8ljTIr/TT93IwliQwfKEQAAFcbK/C1eqwZ
   3ca7/E4HmSAFRZFijGFCDm+yqVmX28KUZG4gNGES0IkRmIDHbrgKF4CX0
   w==;
X-CSE-ConnectionGUID: Xq9BQqLaTcCBr5NjGXiyjg==
X-CSE-MsgGUID: MFJj3fxTS9uxwXprwVbLeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71680905"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="71680905"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:41:19 -0800
X-CSE-ConnectionGUID: tQuG9rUnQzqTON/tKRA1gw==
X-CSE-MsgGUID: 7XBnfXDlRPyS2QWppXwJLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210007394"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:41:17 -0800
Message-ID: <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
Date: Thu, 5 Feb 2026 07:41:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Lance Yang <lance.yang@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EFEC1C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: fg34xin43nn6fu7nauphfo1fcbgods16
X-HE-Tag: 1770306080-825219
X-HE-Meta: U2FsdGVkX1/ce8A2GvvhR1IQjtBK7lAM6cI5cJD4v8diHvgBe2Of8GDEvHGigeot1tMTNmUWoAXWVvPPxahKSKkAdjf8TtqpEaezvQak/qPEmFdujfrxdvQk782QUSLNl4pJ9dcS1ZyM+Vm7kGkhMjmnlQGmyeGVnxgCHzlUI53zLIABosKD/vbQGY7tlbkd4hYnG0B1fW4+h00jzQrIf1/NGPc8C8mnAcK5t7mX4gLZJxYdFWdHOolDQwJEl/fzF2YzRRoa9wUMuCoQKZZaeJuiVUI0lszPtxK+8+ToJAc9BHc+FTjKxrdHeMrYqZbv9HT5gAHvwGhOB/pK15jP7lUnQko2tBgj6+1OIMFaCFOWlTisrhp4WqEzU8P7bOFBFkdkiF1WAJkZFNfhWoSVLKvQHoFnIsbBpj20tPXISLP5rFch433u8jMCZ+HqR34/pBxtpjSSdglzKyHejql+VMQ0W/MQWTWmSC0QskhuiOmvECxPPZahFceqVrbNrDfBb0GoHDYdSzLOF4dN0wF/y36nA02Y9HuEQLe1pRPNJcIdZG9lyeP4Khnzbj2hR8sGnMPLMYmuetL94H9GYW2jUB0dtdesZVTp9Wk37CxZjNRebX+XXR5nizbz3ocZIYuELtpYSBwzZN+rUY8YL/LY+YndoD+43UYxry2K4+3Bg7FC0yL+RAEwoI7/1Fr89W0MlOKEsR+BKums2fRoKF6OB9Gz1eMs5+n2eDRDMueEwYYg5IMvtT+Guv8mrEO56GLOAcDr5QgzLg2uTjjaP34k0lrf3ky0asR2bzy35Opbs6CbFBeMLFQfXbMOAzOiiqCTjJ2/VlZLX5AUXLLPfzKMDJxCYqX9K1yYc7fShn89N7XLAJVPXE9+NNLCeSNtqnMWbajrPv5b3P9Q/kaaECANAQ4DXosCjXSqYw24mxwtpMIdzhwFUYjnkdgCY5ds1zP0ipnnvmzrwTuZ79mYYVf
 g6N8RQW5
 /9HnLSCwyfVxtwMaI09tcoKCSUMsECxeuXWb5oaFT793sNuYyzAala1owyXXgjwlFDS/e6lAAdFqrfHZO4sRMz5/mZKslaQlrpozrkmG7MMQ6bc7jPpdWyI/BMowll8BiDL0ilc++NgQla/d1TgKz8XZOzQQX9026lFj7gH0F7r741nRZ05COTpWhIzjd2DCqcYBN4LaAgi2JRgUUYnJ9aSZc/1jF/I5L6zDy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 07:31, Lance Yang wrote:
> On 2026/2/5 23:09, Dave Hansen wrote:
>> On 2/5/26 07:01, Lance Yang wrote:
>>> So for now, neither approach looks good: tracking on the read side adss
>>> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
>>> is too slow on large systems.
>>
>> Which of the writers truly *need* synchronize_rcu()?
>>
>> What are they doing with the memory that they can't move forward unless
>> it's quiescent *now*?
> 
> Without IPIs or synchronize_rcu(), IIUC, we have no way to know if there
> are ongoing concurrent lockless page-table walks — the walkers just disable
> IRQs and walk.

Yeah, but one aim of RCU is ensuring that readers see valid data but not
necessarily the most up to date data.

Are there cases where ongoing concurrent lockless page-table walks need
to see the writes and they can't tolerate seeing valid but slightly
stale data?

Don't forget that we also have pesky concurrent lockless page-table
walkers called CPUs. They're extra pesky in that they don't even stop
for IPIs. ;)

