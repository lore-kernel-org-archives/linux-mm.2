Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBE8C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F84D6B011A; Thu, 16 Jul 2026 12:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFD96B011B; Thu, 16 Jul 2026 12:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E44E6B011D; Thu, 16 Jul 2026 12:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5336B011A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:19:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0BA7120226
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:19:12 +0000 (UTC)
X-FDA: 84995149344.18.69FDED3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DA3F40007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:19:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ei9T1TfJ;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784218750;
	b=ok9MR0XhiGfLSfTBbnDVMZcRD7EXOFyUtrJFwL/xW8qiHCxgpNigMIWdkdS7XBtOySbeEw
	RATZvgtKzNmNVYssuAnPMApzQ3y5+0G3MLbJlyNS40uvo1+WZdwgTJqKTa2MaYm0I16Bdg
	nO/SwC8/GO18WT4FJEtVVyNXsv4/W6k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ei9T1TfJ;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784218750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0y63It3PC0dreerP+MNi520uJb/wPY1MYNcfVafzhmE=;
	b=YzdwdDAylZdPAkB/Vlj2O1YsNVCpPikmrPnZjqtytBQ1DuikyQazPmwirFoSBYL8aWPIQl
	/g9DTAMZ2/pHNjchnKclhQg9ZqU1D2psOQarXkT56iiXwvW4EXLYSIgiu1j/H94wFwICOh
	wb+bMUSGftlFaxmeuyNKnVbE48WYM9E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784218749; x=1815754749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0/Fk8bMYKR6nYRmd7MD5F/OXammJjg//Xp/IxAHeSOo=;
  b=Ei9T1TfJMlVvsuvqs0Myu45+rf+TzCpjqlnulBUaYAM75t1MKW+evRrW
   jqeBbZQGCJWcppr9HoG2bJq3yTh/nUi0szuD+0kRXaQJBTTARlcysZMKJ
   LLg/o2jqi1pKCSlbku8Cyco2Leeq05c422/+KfNPrrPqqqmM85kffVLiH
   USB98x5YGgbMfKK2oDdSMoSybf1C69w2k7iYZz7h35Rx0HS8itCLNUYaI
   yI6Yg2fYhlLQ3e5levLgzhaE7rUy90RM+GP2saiMzcfSM1iTdR/94Q4x0
   Y+C+tXAjDGEL9LtErBGofIL9K69lCIiHpSwaD6mlLK4jgdPKh+OyA99/k
   A==;
X-CSE-ConnectionGUID: xOoYcu9OTxSk0TZQzBDdXQ==
X-CSE-MsgGUID: UcHiRZD+SaKrfTiAM2o3Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84909962"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="84909962"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 09:19:08 -0700
X-CSE-ConnectionGUID: 5fnBUgAPR86qBDvxjDk2Mg==
X-CSE-MsgGUID: 9wqLZrHjRumIc80hv9sy5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="260354356"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.108.230]) ([10.125.108.230])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 09:19:08 -0700
Message-ID: <c0f585ce-bf1e-49c6-b04a-91c905716042@intel.com>
Date: Thu, 16 Jul 2026 09:19:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part
 2)
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DA3F40007
X-Stat-Signature: nbhk9yd8o1rdqsxeu7hpuckcneyckczt
X-HE-Tag: 1784218749-866112
X-HE-Meta: U2FsdGVkX18TQIAIHB5iWgzrWNzncrw+uc4sONgMgaP/RvqoI8GL9BFaJ4cu2Sch+aadAEkKa0QUQcOMSgbJNVafeWUkAs3c51emDKht2i7FAsLpmFlgm5udDnbexnro5EkzuSSUXIcZ8zENI7vK3Qw7k4GSxXC5A2MRqTzSm+jPPPk0+Bwn7jFHtJrgLSPFx7mzMOKhKg32rDciOUkmcikJ5JF+Zk6OM+Kclg9UEwpR/ot7QY/UUr+rfLHbr0UpI1o3ni2C0IAJnpMjMcYsnsPtjBdYh17lCTaWEPZrJktBALjyQDiwXj9IqQn3eeLDXnHWUYRujrf463wiBilwYLyrhIadw/G4loKIe3Lb2sBtUJ1vFpv8uBQ8280Wnl2Yfl47/GykwT93Xbqmoz6F5SYNPqV2+rl4B8WeWYLvVbGqzXgT3RT7Jb8az9f5wzkkJj307kekQCXP6/Rzr+RmgEmYKQUUByoZxj6Za030XfYxP3PWV+wRka2CImf7fsYF5+H1E0n0c0BRmPd10zqigShMgcWeKt7Afv7Co5k+jleIeOB007gO0ijKnazT47UkMcv5b1ehCvdwh1H2prhO22/nYwvTlKGNBaA3RrM+n1qhFoxg4aTNaO6KQwJDQLoqIm+C1qTny5agkA64e7TUWUCD1eaj3PX7PcAYMBRUeXOUE4Eyo8ayb+6z3+P04mtnY3JCdFB9W0iVrwv5TjosKhqEwOFjTeiC+pIJsoEVxVNQ9672VXRhlXf9awCWzczy5C2IFyF5dRa0CccHQw2rZeuo5u0SSQek45pMYru2lofR+CnE7wcbg7Th7KB/hZPNCcgvqW0YtbUtr3j8Y3VhphEKjvcHoFazrriGnRucl0S16zj2M6gAPtGnh+ANkLUhB3haPJULrwHvOYVdc7xQTHuBxzm5l9ICXIhoc0RoFNUAHcLWHwFtKK54vNxZdb1GMBjepZTqzKeszcmh4ch
 zX60syr9
 dwO1JTY9O+JJ/MlUatU4D8w8bcyOKvdYMCsHms/sge7mOxnRONHXCLH7BnCn9vQaZ/zwTwmEqc0hCVjX9VDSW1Ohb3jm11uu4ekPzTwp74/N9FQdupdkkL6dlN3rqDeoTXF/v/7+UuM4EjklIlMxCWuSS1PRjHZx57dRy8lqzJFeFhX3Wp0ZVqyUtKZWPnThLD7EXzwzy68cuF9LchFm3yu2ijxTH4/pWHVzwYbeWZ6D4LsIKjSjIxDnoPQOlTAqs57K8aqRTw5LfNIj3oIQUpab8yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 07:50, David Hildenbrand (Arm) wrote:
>  arch/x86/mm/init_64.c        | 134 ++++---------------------------------------

Uhhh. Wow. <blink><blink><blink>

This is a really big win. Thanks for doing this!

I assume the plan is to take this series through the mm route?

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>


