Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDC0C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626EA6B0088; Thu, 24 Sep 2026 13:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7D96B008A; Thu, 24 Sep 2026 13:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7156B0092; Thu, 24 Sep 2026 13:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB3F6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:21:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DC28C043F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:21:08 +0000 (UTC)
X-FDA: 85249321416.23.9796BF8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4B8F40006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:21:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jHwxq5j/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790270466;
	b=JPv9X1FRxZu3HbSVBAcbzn3uS+VAHajZRUOhF85wnEUZJ7tsM+DpE5RuxmtPQwLkN3Olua
	k87Wu6Gr+QybVdbEFNGFGUTICC7rZcuYeRqbHhQMQZ25PgnW5Cm44GLkLHgwHyhZvp8CQg
	vUFfsusj4+PqZvbUSd/l7Zt0pbyCIUc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jHwxq5j/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790270466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYEK7bqTK81B9cfb1lNVZACMRyatDb4IFpKYqtTn76M=;
	b=LglnnXdm9uoGJcue/vDI4SxMMv00Zt0fQw/G/f8Y4s9UXwqt+wrCx3s1mmaUhPusRg/4GN
	BGZX0iIAyClJXL+EoQkF1BmJ0nozbdAcd/5EX5A8SyQd7edveaK8LV0FKbA7G5wDrbkgdm
	J37B7jOr9GcpozuMynQFHSkuTQ6nc7E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790270466; x=1821806466;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zYEK7bqTK81B9cfb1lNVZACMRyatDb4IFpKYqtTn76M=;
  b=jHwxq5j/QAnTxmpcPWm0kOOTaMv0eahDMLoXJIbUbsHVsipVmHw/ATgX
   6AK9wlW4ttiosC4j9X96ogxI2GAMsGiR2tQzfjnWlrk1N5MzWzXpKyG34
   nT6vL5VKvx7QbEwcSUSVZTb32vbazj8qEHx3qvDpvTj16ahYAzep1h7nR
   2914gyjQXXqMAeP51NKQo5cago/jh7KADQOHjyUeXE36VVxZyPFx+vI1b
   O6pqVkQpA9ND+1Rtgi2b2NJnhG96I5Y/MaxMFVzLoGxzCzE6AiMYENs2R
   TDDRYmOpc0oNV8YZXKgGOvDflI2d5Zgg6sLjVTQxL4V1WnYxBMYpbZJ1m
   w==;
X-CSE-ConnectionGUID: P18ygnDuQi+QZjmeCEznrA==
X-CSE-MsgGUID: 3voKYcH5RYenLYX6kBFEVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="107437032"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="107437032"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:21:05 -0700
X-CSE-ConnectionGUID: vf3yPULhQ2GSNc4Lw1fP6Q==
X-CSE-MsgGUID: TESpmyX2RdaAm3wzd41vtA==
X-ExtLoop1: 1
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.110.171]) ([10.125.110.171])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:21:03 -0700
Message-ID: <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
Date: Thu, 24 Sep 2026 10:21:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
To: Pedro Falcato <pfalcato@suse.de>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
 linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
 <arVV9WLXQOwR8Hy8@pedro-suse.tail5790ac.ts.net>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <arVV9WLXQOwR8Hy8@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 98717a5prppafq6ftynt85cyya3owpts
X-Rspam-User: 
X-Rspamd-Queue-Id: D4B8F40006
X-HE-Tag: 1790270465-96080
X-HE-Meta: U2FsdGVkX1+5Ni4q21gN5NR5O3IDTYtNpbaWl65Ugx4twMvmlEShtnqqBFvDSpYz7ix8VLK5Js4Mgqf4SxWQO3KBkVqEuMAn/oYcoAUynBu1yCXXU82R5jpcJqNVENINUfQN7SClbO6K4DjzD7T9KTa3CIza8rhJpCElWSkTWLfgx72yY+6/2BMauzQf800RWSR7GiO4zsEgjp0WNDyLbWwMsgV5JuA9WqrQiSx7cruyggCTj1dAhyxX/olFryt/6dIFdOVTM/WX7dtrqeCbcxKcY8chZ4l4aR0iopKkzKCjm9zyVNWabFlSongaaWPQg7ZR0f39XMg5LFXliSLlbxw9aOiRtzIS7O5z/ku3tmEU/DUbrpT5LpY7tsXODM18I2cyR1vj9OPvjKH38eCqRDwMvpXQjJKd8PloOd9EhzOV8r5msz+RQ9StoursbN+oCwDV0VxjTjBbqnFRICSrP5ztieWvqpe1zvCi33tozjR7KfJnnPqwJ9eEgPaYW1dCiJDvVBF84TPYeHwfazX+LrwBZe02oVXf3btvf4iZx0tRXpbbKe8RHJJK4LDvJuHlzk+A6iEE9DumdGqsnU9X35PrlP+OJNjz/mNNl3p3GdZQ7HoYC9SbMjNsrEwV+d4l4EMxMs4eNCz/DU0EZdNFOKS2Us9h1umKsFWh5yWMRpmXGaz2P15FyFIkagrW9I8A1IcOBxulOpWbBAt/39EOizrLBPcmA/hbJz1eYo0mRWVRmM8fiEHWHogbNeszjttYCsqzAWoaveagGEuPTvf0Fd+ceUztLC13DCfBpRFS0pLEC3Ngrtj67SAO3Kl/b426MihxUPyi/DK19EGoLc7ClwodbbJs9etrr6skjA1bq97hnQ6PJQfx4tNlC9IPdYyiJd3ue1aBKOH8sitRrGsHjXyi5/tjXkz40hP1Dc5gwFCo5dY27wahr1lMgfnEcsoHG39xE3u5fSog441P17l
 9EszeLPX
 +OT6dgkrdMy3OGf/MIY2ykV+rh/Nqjg20R96HLrCTGb9MIyw9MbCba1vwYTIeZxt80VTfPN0VEbJK/AzxdANyJvF5Hzoic3qm/V0ArLSH4+RaLk9kyuzonz+S+sfWS4jH0od+qhQGNoPKOgEIKcM5b6c2/jZUYLnCxJb1+ltd6TFcbaX6ABH/1wFh8nsGAID8cbpUcu5XmluECswJ/zY3Ggrom79CbBYcIAQeenTPPyBuibuFJ3OJa8bJwTFolI5JtY7SWL7FUrQltwZVojy0YnJtYuTJD6U3tswmTZc32ziP3FBCqFJAd+pbEiXw/gYsA/QO+NCSCXoJLCecfe8aj9TJ8Xtp13U3kQrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK, I've got a version of Mikhail's fix with a changelog and comments
I've munged a bit:

> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=pmdfree

Does that look OK to everyone?

