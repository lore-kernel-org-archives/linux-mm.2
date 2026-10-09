Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39177CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050DB6B0099; Fri,  9 Oct 2026 16:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002176B009B; Fri,  9 Oct 2026 16:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C276B009D; Fri,  9 Oct 2026 16:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFF716B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:48:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FD7F40166
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:48:10 +0000 (UTC)
X-FDA: 85304275140.16.68DA981
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id 295BB2000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:48:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vs8ylNiF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791578888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx2WnKvEdS11l9IWSE6fv38e21+5iBA2wfNbqaEuCjE=;
	b=sELQyFy2me+lHZ/NY+2aWu71e8XOZLaBOP+9Qg8k4buOtam00JLJpMqarzF4IgbJTtTBTl
	6K1FrE0bxvbmmAeKaR2PW8kmSr3yBWiJXSQFBwZxNLrmegkpo8B1y9EfZKD6A1zbEtmJot
	bfWnfKRPzByOyxkkgiJUGkwh3QpyDmU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vs8ylNiF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791578888;
	b=BReSLiEJ1PY/aoYtI9HETBxmON7TINrII5NKNzM8HO4JVbsiQwcT7K6xIv0FvR37BrT1Qj
	Y6sKPbRJzKsa/JVP4fuRr+Dosil9/45YvmoGnc3iFTtDMkKpVLPLHAuZqFULxAN2Rzuki4
	QRH4D12GdJr70i2oXs5YbFc8JXYkF0w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791578887; x=1823114887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yx2WnKvEdS11l9IWSE6fv38e21+5iBA2wfNbqaEuCjE=;
  b=Vs8ylNiFdXjmbPJ7Ii+oPfbi7Jo7TefvBmPHTzFZH5v48IWwnkrrC++A
   s0QKkX+WN3vy6l4KzAIMgvsRLZ7xS8S5SmqLXyg5Oz2HzA0wUjkFfz5Wz
   xcy2A3RyIAYWxLJFUY/REQe2zPjdqajTHwFWwO6mj2AD0a7GTuf6pjqhF
   zCkR2nlSWUxNPoVNXGllcp2nY3akXHFsp8mMXfBpCsTSFLfgAZkrUsXIh
   +O/MtCv3QaV88u4WDlcuZ1iHxkPQn6BW9DuqU/SsxiP1yyyKy24WjbEle
   aP9saHNNKWOUULTvCDA7C/MaVEsqKNX/bULs/yuG8Jbmg8kS+q7fu7QY+
   g==;
X-CSE-ConnectionGUID: COqtl2a8SOS1hf6DNIUyjg==
X-CSE-MsgGUID: rV3WdBjeT1SrIeZNsklpFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="277917"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="277917"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:48:05 -0700
X-CSE-ConnectionGUID: 2m33Y0liQmGGAODzyZB35A==
X-CSE-MsgGUID: qiLxGGcPSTazmWfte8OiKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="722194"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.84]) ([10.125.109.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:48:05 -0700
Message-ID: <b62aa96d-6c83-476c-bc28-7c2057702063@intel.com>
Date: Fri, 9 Oct 2026 13:48:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: Fix page-table teardown during memory hot-remove
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, david@kernel.org,
 osalvador@suse.de, dave.hansen@linux.intel.com, luto@kernel.org,
 peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261008073021.2512665-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n6rcnain8ns4w6zeyst4kyrwce6ysrj4
X-Rspam-User: 
X-Rspamd-Queue-Id: 295BB2000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791578886-710540
X-HE-Meta: U2FsdGVkX1/AoNVxh1lM/zaD9KdJhVED0JC8J/zWAZMSbWhVDI7xQQRIDFx8S8jFdXFCnSE34pD+qJcCks7g4uFhnrmxzo7t1q1aJfMicuSgP9wu+/EvvlB3OWTmweC3pet1CzvdLAe8V18CJNIzGQXBdYw5RGE1kVbdklpns51r3bnmbUzX5qR1Zl+nWzfoftIyfr36IO5sgjXeRUkzP3XLexud/iEhaf6KtovQyNbtu44WPl7if6HBcDOMv59qWUmfXl2H6IPO09LrGvusn5sOqBL1R1iOpZAwbQrzO9tyHNJRVKF+oUSeTA5loF0XrfAlVCnKloVAe9EMy4VkguBjM4b/WocyNr/J+GNv22x3k/l1+VzNZXI6SSa72dq1ah/vQD7tWXHVclIHOJETYj6FolsWLtmyG7gX0Yy1TQfePXkoyNAjtHMe8fCVLKIyJ6QwXkcW1yYkHiyEdHvgDEjGE5dhgT2be6B9ZtR57nnjKW54TT0StHLg9vhmBeGm3Ize4cNeK6ChcJYDTTF2c6YkYVNpFAv/sjJTMT1slHKzmLwUj+S7prhUIUmh+9xefpPVEQSozohnE9iM8Bry3a0dbtKFL3fMsi0HgQvR7pQRIT6MMAiJhKKFdw55ALU97t3nsBKSHeM8wxZdsIFxv0oA40TzzGIMF5rl8x+RaDy+OwwarFQedKXsPDyw6MFZP8VzeVXQfEEJeU40VuuF+7CB3a7FLyoN0YAIQqoxAvBcxXvVNUQ+u5pGZuxI9NZrpezWqcwNJ2ZpjNwbbLb90c8ORk33ZP6Z6w3IVgaxJFgR2lgHW/EQpGg9+keb7o7J6Syppx11e7RlOqREwMEg56Tu1ECZblnJUuVymLzSkri8B0aweGz/mIN9E7IITb0JeS6HznPFUKYPK6V7HsJ9TtGqRU3nskxkOtFZvGaGmnjYwSOGUcfHibW0VQdnUhS16/XpSfadr16zHVRaNya
 fE/4tWNL
 3voZhCFnRNy9EbFK24hMS1LjcgANqGjuGjPDicq1iaTmvZNSMbzelp8qFp9RLPjVdGi0kNkWiaqPTyF4b0mpgNG7ESxzL+ZB0ZQUkiLxnsvimZt5zBI8RzfAYAZuCrzg6mwF2jxBPUPkh9XmJExCBjGva5KXPuRO2xEwvnTytn29ObjHhvugYhNO/RzlsdbpjCPmWECVQBO8bvbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 00:30, Muchun Song wrote:
> This series is limited to bug fixes for the existing teardown paths.

Why is this a series? Why not send the architectures independently? Is
there some dependency where they all need to be applied at once? What do
you want done with this series? Are you expecting it to be merged via
the mm path or the individual arch maintainers?

