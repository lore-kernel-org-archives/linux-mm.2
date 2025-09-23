Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3759ECAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 05:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710148E0008; Tue, 23 Sep 2025 01:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7638E0001; Tue, 23 Sep 2025 01:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624308E0008; Tue, 23 Sep 2025 01:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51B058E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:52:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA6CAB8939
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:52:36 +0000 (UTC)
X-FDA: 83919445512.13.22B067E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D169120004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:52:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hz53iHZo;
	spf=pass (imf29.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758606754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncEwKodHLofR/hxoHJLbWLArv2qzRlaaSrh4f7ChnNE=;
	b=q2tJPlO+6iCe4hVwg56Uk/oGLUlInZ8ry4KPJnymPVEkYwTXy8GSPqgxh3G2BOVG8HsyzJ
	aS96f4OyNU9z3nH0cnV2cHxEu+TizkznX02F1LgWYo5kBhQlv6e4W7pxuWKpKrLwDR4O7p
	hSOqkOU+W3CH/8/N5NtPzTMJmX0EQAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758606754; a=rsa-sha256;
	cv=none;
	b=gCjW0awTfYz6MaUToNSHe9SqkRTTcdZs02f4jChZSg/he0XLS9cbaF5DpRGjHStMdrL+EO
	8U0Ku+4P4PzVKVt9ssyHqex5MkKbRuAiNYcT4r6ZlV/uO6n+mE6fgOBo8/xjFoQe6YzVeE
	Tm83/XCleooiE7TwUE/q6TJJxVGHjcc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hz53iHZo;
	spf=pass (imf29.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758606755; x=1790142755;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yv4vxS5FfhjU/zpDBpO1D2UxDxUcGTXGSS0bA5T5eAs=;
  b=hz53iHZoY+Wxq1ZAD0L2k0UBcaEtBahJm1da7sPxR1RKYFNXylVoA2M0
   u6WdOWqT7p9nT9ravUIXSEcEZU9t1Tw/MYGYbnSZmPm4gpXd7ROX48CjS
   0Rgp9ZJAHZbsADgiz0I7x2lhNF0As4PVB+8NFRVeeus/o+1FyIP4XHi5D
   KsExSybskqL469/V9I4bD6Z9umsaiNE2vozif7YziXIfxGQN6YPD7V/ER
   CM3i1HeEkYLbvgct+c5VGpI7gcXhBPheBrm3Rodx9g1nsv21LZHs4VMQi
   U/Mld5w841ZBGLHOi7/eXjMery7wsRQNHN/3NzucV77pz7dS9s+6F3h2n
   A==;
X-CSE-ConnectionGUID: nUrP2XsdQtWRzq6MHIoyBA==
X-CSE-MsgGUID: Joj5hH1qSXOus9cjz2vGVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71985426"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="71985426"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 22:52:33 -0700
X-CSE-ConnectionGUID: ey1wUJiRRRmHLQLcgAPe8Q==
X-CSE-MsgGUID: borv5jnjTHC3J6hNV2upxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="180973917"
Received: from alc-skl-a23.sh.intel.com (HELO [10.239.53.6]) ([10.239.53.6])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 22:52:30 -0700
Message-ID: <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
Date: Tue, 23 Sep 2025 13:11:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>,
 Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Vinicius Gomes <vinicius.gomes@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Chen Yu <yu.c.chen@intel.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
 <20250922204921.898740570c9a595c75814753@linux-foundation.org>
Content-Language: en-US
From: Aubrey Li <aubrey.li@linux.intel.com>
In-Reply-To: <20250922204921.898740570c9a595c75814753@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: szti4t97jomoe5cw55mxxrcwqp6tjqd9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D169120004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758606754-188070
X-HE-Meta: U2FsdGVkX1/fLrooBRy701WDFDFHwfT6HcxtjUJz7Aw1VqVEgKNMDRwsdz59OX/RbMHGaQo7dc8Os+U/k/olwBPx/Qhv5/gYHTONRsvLxAkOCE/PwDhPCPHGnGhbdNgI6XEVVEoqtkEcMWTEA2CrO+FQm1X1UH+GZFcecLQvZ4dsBl40lGuycgvTdX0/bjvrpoux0rnZUn5cPuz/D+qZcsfcI9vlMZxT9YRzYCnb+ezza4Lm9TNjnihvkyETGNWlfbsBcMDOJNXQ3PvOvu9KvkBDCs5Xcx5wHwXGyFAssBbnMtQZLFZc+9QlP7TQMQ00GqVKTmOTYTzyPh1zOntRuhqpvEpG/PDBjkqPML2zivYcdKnZhhIX6vJuuxMiWqEIUxD01Ok6FMdddvT67enAZyZ3cSDUCHCbBBiLku5/YCcPSme15a+U0HPoP+ScYqybn9GTYyLBmClzOlAA53oTe/vKR6LlJnGCxcXXh1IgWoL/GEurvFxuQWJFKnnZrB0BDVPH8+00HYT+NQjv/7qaYXpriJvSnvVi8uNqFkW3oqGddt6VxJeEI2GeojIr25651kCS14HzkiGYNwP3C3lLGvP2uPJbqc/9D7G9irEkPXFKAIk+Itf/HMJ1I5JBwaByed5dfa6aTLW2CkjRNq+CX6z393g2pdDxhyE/3tokckBG7PsyQaHxBsgZKm4uNeeatqDutZX4pyBvtHKyg2IwOm882pMkM5qrDI2/6HLXYitDYmO2QDz20NszJblrYBRENtKlOxtoAPStBzgT7Zi8B5LoIJ9RysgkenjgN3U8FPDx6924OA6YaX1gneKYWh5XPlwoBYRDM/CFSu9u47bMCSoJplwAh/lNdtdY3DJszUVZq8cVebcNBKWnOeY0GMnDl0m38qPIzIpPfJ62qxIwR2ivvQ52f8oaqf+bgTcxTuVNmSioa9Y9PIN0ol21t5zm5+qw0+iHQ5bKna3DSvl
 urgcCh8y
 +97af0ygE6w/gwuXTZrZtCYBwzw+W8tg4M9HfMYzx6kXi/ktRFtF4H5gYJZWPAzqe1AyeTTTwqRrAyH8zDN6qN27jqyDDSmeM2TSr8rwpfI6w2+pmNztKUUr0+8LAOt46u7xNbcC3EkEFsvUoGFh4O8BLx/szFWPZdmuy+dcrgwMvAXCky914wTsE+b/no5XCr9oU0UXKvHSfmla+zaWUmX7T0qGSqhLxogp4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/25 11:49, Andrew Morton wrote:
> On Tue, 23 Sep 2025 11:59:46 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
> 
>> RocksDB sequential read benchmark under high concurrency shows severe
>> lock contention. Multiple threads may issue readahead on the same file
>> simultaneously, which leads to heavy contention on the xas spinlock in
>> filemap_add_folio(). Perf profiling indicates 30%~60% of CPU time spent
>> there.
>>
>> To mitigate this issue, a readahead request will be skipped if its
>> range is fully covered by an ongoing readahead. This avoids redundant
>> work and significantly reduces lock contention. In one-second sampling,
>> contention on xas spinlock dropped from 138,314 times to 2,144 times,
>> resulting in a large performance improvement in the benchmark.
>>
>> 				w/o patch       w/ patch
>> RocksDB-readseq (ops/sec)
>> (32-threads)			1.2M		2.4M
> 
> On which kernel version?  In recent times we've made a few readahead
> changes to address issues with high concurrency and a quick retest on
> mm.git's current mm-stable branch would be interesting please.
> 

I'm on v6.16.7. Thanks Andrew for the information, let me check with mm.git.

Thanks,
-Aubrey


