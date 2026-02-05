Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1168E83F1F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8036B0089; Thu,  5 Feb 2026 10:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B958B6B008A; Thu,  5 Feb 2026 10:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A777B6B0099; Thu,  5 Feb 2026 10:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91FFA6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:09:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67CA0B9A07
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:09:22 +0000 (UTC)
X-FDA: 84410736564.16.F7D5359
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0B1A80012
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:09:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nith4y4w;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770304160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jJfHFzXEaAp/egvpvt/MBkU81T+3rqXh7wMICB0ZeM=;
	b=WkA16TIlMPiSl2ucCjm/P0VXCCdLnIapigjT/TL63vUdy/YTlQQq6J9xUAHpPOQ29uDvNZ
	31yTRUPGwNTHecXfiG/71evha493y85ygRyzpHUlwyG/+Df6E6sGGIScxLwyvRjPdlo2zk
	B7EE0X9e2P0M9UkPcT+n0wmzDdIirbQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nith4y4w;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770304160; a=rsa-sha256;
	cv=none;
	b=eOrQGZOPTlTMUfmCoHUOcmKt6UVjRWZM+MMRElz6nlOJS2acMEhzQ7+oU7uh4GGmub+9iX
	rOoC1iWjmtOh6oklQ2Wf8JpmiizCLSTGOW5viynzoI4WTFWn5bQWH0brYO/KAwjV1I106K
	JN6lPQDDNmtSGeIj+VRXuXrXziH3064=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770304160; x=1801840160;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5jJfHFzXEaAp/egvpvt/MBkU81T+3rqXh7wMICB0ZeM=;
  b=Nith4y4wKW+WIMHnoMi1OQ/oLgP7dFbp1UIftH35znbk63Sy01lmwRxP
   UQVUtXBH2MmRXDgWbJ13r3kHb0etNpBLkLEWETeydQwW4lpY4u7zYIbur
   TS1whf1hLuibHIHcZWy2VUz5NFeiH1SoCUAeTcvBMEUr4FXJKDmRxVqgc
   tbTw6NH493kR5RF/mYzFIRNHqqtXzJUj8r4/CCF9VjTV7vKzkIOqzm40N
   GoPif9Shhm9VqoXfjT3UJgaSQMKrFUBHrpf/SZJnZSetZ4UYmm+AEmobs
   jLKxO1diiMeZHywUxgsOmE9ix5u0+9xBncmcnGrTyfd6cAnEmq7eMXFmd
   Q==;
X-CSE-ConnectionGUID: Zxx6mEefRRWLNrGnkCdJhw==
X-CSE-MsgGUID: fDaG54eITB2Eb170VmaypA==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="82874856"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="82874856"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:09:18 -0800
X-CSE-ConnectionGUID: MR7SxKoTQQOkJJrYuLxBvw==
X-CSE-MsgGUID: 2dRbd5IjRTC6xZWZm68x7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210470361"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:09:17 -0800
Message-ID: <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
Date: Thu, 5 Feb 2026 07:09:15 -0800
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7yikau48jbrzz9kfxw714mgbdkqkprmm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0B1A80012
X-HE-Tag: 1770304159-128470
X-HE-Meta: U2FsdGVkX18vF5W3WjY2mz66mw96pq9GAa4e0AKjo5u9fakqdvzap5oy8lEVjAKD8RJndUwsQkh6OU4P8bddPf+VVCAwQMk4umbBbgyx2GmaBleivHI1lrDEn7oCx1gssql2WQZYEMB4J7GrNV6trt7SPcggssLV+d/XCgwKXhU+upEf6Y1W7eq0fI+WAVE30ff8As2H/WvYVYkhP08GcnKR6Z/ifg4y8TvcSFbwodhZ6DdeLUKr+Dw1PeY30uFr1ds+W9QyVaqzmnIbaYlvE/F+fxK0kHFLajDM3p+wDfTupbCFnM3nsWr0S2LCv02zPBEBWWlwG8SP+Ry9tanH72jfL52lEoaiYAt3yb6uD4g9ZlbcAoWNQKooTURPAR8QPjfXfXuq7zGJmmcU3w2naC4cbab/nFWBkFDIkDzhZf+h2ngF9CIcV77Zvv+YMJUI5i833tc0xVQC/wIwsJCMBTcaELmex2A0r6B+FZs3hvun1CJjPP0m3/0LR12+S/fdKdbMAoNFRSEWmlw9+CUo+lQ0/ZycZg8eI/bKtWAhL2A6LdK5OtSERb1QUtzBsOdlyS3n4IHmgkhG4riXKXE8rGfoNzfqgw5/yvvf6DyGMaSAHZKk0h00UzJJJw7PCIIAr83jdwNNGylNpmxOeSkd9g/C1qt0v0425u7ABLY+BlPuJbTc8KZep5m5zKL+etwJ8JUUi9t3liyfRQx9G8R4m2LNMzaUVQhMX/n3iR2WoZJBbvNekxXZpRY4UnNyKzZIdLQUFHLGqqyXPJGS0D3lL8zw/hdAkRWw7LE4NDTM0WZy+VEmzbFqNfaWsi55RrE6H/oXQ/IAYYzje+0cXYwH0JKxjarh+mdcESKnXzM78+fADLEIguM9elqb4Lyo0PJd50flLdQyNBJiFechFSTy2mrdRhjh5r7n/NNCAQcNxY83Gl9orZEQ/zcpBiHREoYkUgLw96yyt9hTnwBkPR4
 cjDeK4HY
 xZo81fLyIl+0KHvYNJQ0iuGcYTyL82wL+knwWWBvlAMz6Yd6lYThceCKSZRSCWvkoYULcxP/ueCGIftOY4ZH1hNXgj16mq7eoqr6BhLzmC92chJ3NtplhrgDDHESByw5o6e+7vlxNi5rfHTSSAkD1zsQrt4rwZAjaQBzWnFOFSW/qZTt0cPuoAcGojgAFpttz7n7S3tRZxY8uaeo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 07:01, Lance Yang wrote:
> So for now, neither approach looks good: tracking on the read side adss
> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
> is too slow on large systems.

Which of the writers truly *need* synchronize_rcu()?

What are they doing with the memory that they can't move forward unless
it's quiescent *now*?



